+++
title = "5 Lessons Learned Writing a Clojure Web App"
date = "2014-08-03 14:33:39"
images = []
tags = ["clojure","lisp","web development","luminous"]
categories = ["code"]
draft = false
+++

## So I've been learning Clojure...

I've been fiddling with Clojure for a few months on and off... But mostly I find myself just solving code kata and writing tiny scripts.

I'm also terrible at budgeting. I like using Mint for big picture stuff and looking at my bank account through my bank's web application for a more accurate picture... but really want I want is a a simple ledger and nothing more but I hate carrying around a checkbook.

![](/content/images/2014/Aug/budget.jpg)

I want so little out of this app I could have easily built, tested, and deployed such an app in Rails in under an hour but I decided to try writing it in Clojure to get my feet a little wetter with [something simple](https://github.com/nessamurmur/budget). It was so much fun I'm going to keep working on it and already have some features in mind.

### 1. Definitely use [Leiningen](leiningen.org)

This one is _probably_ pretty obvious if you've had even light exposure to the Clojure ecosystem... and it's actually not something I learned in this particular project. But I still felt it was worth mentioning in a beginner friendly list.

Leiningen is Clojure's build tools and can be used for everything. Whether you want to start a new project from a template, run your tests, or package your app for production Leiningen is the way to go. The repl defaults for Leiningen are also much better than Clojure's defaults.

Leiningen also happens to be the easiest way by far to install Clojure.

### 2. Use [Luminus](http://www.luminusweb.net/)

One thing the Clojure community seems to value the most is simplicity. If you haven't seen Rich Hickey's [Simple Made Easy](https://www.youtube.com/watch?v=rI8tNMsozo0) talk I highly recommend it. Absolutely essential material.

As a result Clojure developers typically make use of lots of modular libraries that fit well together rather than your typical big MVC framework. You won't find your Rails clone here. At the core of any Clojure web application you're likely to find [Ring](https://github.com/ring-clojure/ring) and [Compojure](https://github.com/weavejester/compojure). It seems that many Clojure developers start there and build up with only the things they need.

I can already see the advantage of starting from a bare compojure template... But if you're just starting out writing web applications in Clojure and you're coming from a more bloated and opinionated framework like Rails then it's nice to have things like logging, session management, and templating ready to go for you.

To start a new Luminus project run `lein new luminus my-app`. The [docs for Luminus](http://www.luminusweb.net/docs) are fantastic! I highly recommend starting there. If you're interested in an even deeper dive the maintainer also wrote [Web Development with Clojure](http://pragprog.com/book/dswdcloj/web-development-with-clojure).

### 3. Make use of templating. Seriously.

If you run `lein new compjure-app my-app` by default the template uses [Hiccup](http://www.luminusweb.net/). Hiccup is actually a pretty cool way to render HTML... but the moment you start doing something even a tiny bit "fancy" (like adding classes to HTML elements...) it can get hard to read real quick.

At a minimum, if you use Hiccup I recommend moving your view code out to their own namespaces and out of your routes (many tutorials shove your view code into routes).

[Selmer](https://github.com/yogthos/Selmer) is a great choice and if you use Luminus it's the default.

### 4. Deployment!?!?

If you don't have much experience deploying Java applications you might have a little trouble here. My recommendation is if you're just throwing up a toy application consider [deploying to Heroku](https://devcenter.heroku.com/articles/getting-started-with-clojure) for a simple deploy.

Otherwise, I highly recommend [Immutant](http://immutant.org/). There's a bit more of a learning curve, but I actually found it much simpler overall than deploying to Tomcat or using Jetty.

### 5. I have to keep writing Clojure

Because I'm loving it.
