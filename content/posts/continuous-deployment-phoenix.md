+++
title = "Continuous Deployment of a Phoenix App with Travis and Heroku"
date = "2015-05-02 18:29:13"
images = []
tags = ["elixir","phoenix","ci","travis"]
categories = ["devops"]
draft = false
+++

I have a hard time working on any project without a nice deployment pipeline... For a Hackathon this weekend I've been building a tiny JSON API with the Phoenix framework. I had a bit of a hard time figuring out how to set up a good deployment pipeline so I took some really sloppy notes and decided to share them.

Hope it helps!


## Travis

Fortunately Travis has Elixir support! There's actually very little you need to do to set it up. The default script get and compile your dependencies and runs `mix test`. Here's an example `.travis.yml`:

```yml
language: elixir
otp_release:
  - 17.4
```

If you're using Ecto you'll want to enable the Postgresql addon and add a `before_script` task to run your Ecto migrations.

```yml
language: elixir
otp_release:
  - 17.4
addons:
  postgresql: '9.3'
before_script:
  - mix do ecto.create, ecto.migrate
```

Take note, by default the username for Travis' postgres DB is `postgres` and the password is empty. If you use something different for your test environment you might want to create an travis specific environment and set your `MIX_ENV=travis`. I actually took a weird route and have a file that I copy as a `before_script` task to `config/test.exs`.

```yml
language: elixir
otp_release:
  - 17.4
addons:
  postgresql: '9.3'
before_script:
  - cp config/travis.exs config/test.exs
  - mix do ecto.create, ecto.migrate
```

## Heroku

Deploying to Heroku is *pretty* straight forward but there are a couple gotchas...

Travis has support for deploying to Heroku built in. All you need to do is tell Travis you want to deploy to Heroku, use Travis and Heroku's CLIs to encrypt your API key for Travis, and tell Heroku to use the 3rd part Elixir buildpack. (If you don't already have the CLIs you can get [Heroku's here](https://toolbelt.heroku.com/) and [Travis' here](http://blog.travis-ci.com/2013-01-14-new-client/)).

```yml
language: elixir
otp_release:
  - 17.4
addons:
  postgresql: '9.3'
deploy:
  provider: heroku
  app: location-game # you can get this by creating an app in Heroku
  buildpack: https://github.com/HashNuke/heroku-buildpack-elixir.git
```

To encrypt your Heroku API key run

```
travis encrypt $(heroku auth:token) --add deploy.api_key
```

This will edit your `.travis.yml` for you to include

```yml
  api_key:
    secure: SrlGZ90AVszYkjlHRGrAOHT6McycgATX5ilbMdXmnNmyWq3ZqX6msX/QVB/T8dQL+sqpxv5cAB5OtxAH1noeA1FVdmRnbA+QGYQ3c59896bN3Zcb9iOWq5PRYVX5GSXj4GoqWU19U4SEjNtEpo1wReaWIvZb64ZHpApVsM1y8vA=
```
That will get your app deployed to Heroku... but it still won't be running properly. Here's the last three steps to get it running well.

#### Run Phoenix Server

Heroku uses `Procfile` to determine what task to run. Add a `Procfile` to your project that includes this content:

```
web: yes | mix compile.protocols && elixir -pa _build/prod/consolidated -S mix phoenix.server
```

Now when you have a passing Travis build your app will start up properly. But you still don't have your database up and your assets won't be served.

#### Run ecto migrations

If you don't know how to set up Heroku Postgres [see here](https://www.heroku.com/postgres).

Once you have Heroku Postgres setup you need a way to configure your production environment. The buildpack provides an environment variable with a complete URL for connecting to your database. You can load this environment variable in your prod config. My `config/prod.exs` looks like this:

```elixir
use Mix.Config


config :the_game, TheGame.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "example.com"],
  cache_static_manifest: "priv/static/manifest.json"

 System.get_env("SOME_APP_SSL_CERT_PATH")]

config :logger, level: :info

config :the_game, TheGame.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL")
```

I can then you can set each environment variable with the Heroku CLI using `heroku config:set MY_ENV_VARIABLE=my_value`.

If you push to your git remote at this point you app will be deployed and connect to the database but we *still* need to run migrations. If you need to manually run ecto migrations you can run `heroku run mix ecto.migrate`. Ideally though, it'd be nice to run these on every deploy just in case. I just added that command as an `after_deploy` task.

```yml
after_deploy:
  - heroku run "mix ecto.migrate" -a my-app
```

That's it for the database. Now to get assets working.

#### Assets

Assets are compiled using a Javascript build tool called Brunch. Brunch can be installed via npm. Fortunately Travis containers come with npm pre-installed.

Assets get compiled to `priv/static` and, as of Phoenix 0.12.0, for deployment your assets can be compressed (yay!) by running `mix phoenix.digest`.

So, in Travis as `before_script` tasks I

1. install brunch
2. run `npm install` to get dependencies
3. build assets
4. compress them with `phoenix.digest`
5. git commit so we can push the compiled assets to Heroku

This is roughly what my final `.travis.yml` looks like.

```yml
language: elixir
otp_release:
  - 17.4
addons:
  postgresql: '9.3'
before_script:
  - cp config/travis.exs config/test.exs
  - npm install -g brunch
  - npm install
  - brunch build --production
  - mix phoenix.digest
  - git config --global user.email "youremail@yourdomain.com"
  - git config --global user.name "Your Name"
  - git add priv && git commit -m "Heroku assets"
  - MIX_ENV=test mix do deps.get, deps.compile, ecto.create, ecto.migrate
deploy:
  provider: heroku
  app: location-game
  buildpack: https://github.com/HashNuke/heroku-buildpack-elixir.git
  strategy: git-ssh
  api_key:
    secure: SrlGZ90AasASDIJLSSDGcycgATX5ilbMdXmnNmyWq3ZqX6msX/QVB/T8dQL+sqpxv5cAB5OtxAH1noGWEeAFASC1FVdmRnbA+QGYQ3c59896bN3Zcb9iOWq5PRYVX5GSXj4GoqWU19U4SEjNtEpo1wReaWIvZb64ZHpApVsM18vA=
after_deploy:
  - heroku run "mix ecto.migrate" -a location-game
```
