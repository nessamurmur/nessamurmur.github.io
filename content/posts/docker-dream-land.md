+++
draft = false
date = "2015-12-17T18:17:43-07:00"
title = "Docker Dream Land"
description = "This blog post describes an idealized version of what a dream development environment that uses Docker looks like based on my own experience."
tags = ["docker"]
categories = ["devops"]
+++

This blog post describes an idealized version of what a dream development environment that uses Docker looks like based on my own experience.

## What it looks like for a dev joining an existing project
Below describes what working on a Dockerized project looks like to a dev starting with that project for the first time.

Ideally, a README for a particular project will, at the bare minimum, have a similar layout:

1. Prerequisites: Links to how to set up Docker… anything else the project requires a dev to do first (hopefully nothing)

1. Getting Started / Installation: How to spin up the service, other high level information knowing within the first hour of working on a thing.

1. Running Tests

1. Other common tasks and how to accomplish them

_Aside_ Contribution Guidelines are tangentially, but equally important in a README.

## Prerequisites
Installing the whole Docker toolchain (specifically, Docker Engine, Docker Machine, and Docker Compose are required for local development).

Ideally, one document describes getting started and all repo READMEs point to that document. Very ideally, that document would be Docker’s own docs.

## Getting started
1. Clone the repo:
```
git clone [my-cool-git-repo]
```

2. Copy example configs to get up-to-date config stuff.

3. Run `docker-compose up` This will build a new Docker image from `./Dockerfile` to run this repo, and pulls down all services this project relies on from a private Docker registry and runs them.

## Running tests
Run `docker-compose run [container-name] [my-cool-test-running-command]`

## Other tasks
Anything else you need to do (asset compilation, database migrations, etc, etc) just involves running `docker-compose run [container-name] [command]`.

These should be [well documented](https://www.writethedocs.org/guide/writing/beginners-guide-to-docs/).

## What it requires from the repo maintainers
### Good documentation
A README should include:

1. What the project is and why it exists

1. Information about any prerequisites to get the project running

1. Installation instructions

1. A “Getting Started” section detailing high-level information about the service you would want someone to know if they just walked in the door of Emma knowing nothing else.

1. Information about how to run tests

1. Information about other tasks / scripts that someone might want to do / run.

1. _Contribution guidelines_

1. How to submit an issue

1. Details about the build / deployment pipeline

1. Links to further resources about the project (i.e. link to a wiki, links to docs for software the project relies on, hints on where in the code to look first when reading the code for the first or second time, issue tracker, etc.)

Ideally, your README will also include a table of contents somewhere near the top. There are good tools for automating the table of contents like [doctoc](https://github.com/thlorenz/doctoc).

If any of these sections make your README unwieldy it’s recommended you move that section into its own document, either in a `docs` directory in your project or on a wiki and link to it in the README. Wherever your document lives _make sure_ it’s somewhere where contributors can easily collaborate. This is why in version control or a wiki is a really good choice.

### A thorough understanding of Docker
If you’ve _never_ used docker, [start here](https://www.docker.com/get-started/).

If you’ve used docker level up on best practices with Docker’s own documentation on [best practices for writing Dockerfiles](https://www.docker.com/blog/intro-guide-to-dockerfile-best-practices/).

Make sure you understand how to [effectively use](https://docs.docker.com/compose/) `docker-compose`.

### Service discovery implementation
Consul seems to be the de facto choice. Fantastic documentation on what this looks like for local environments can be found...

### A Dockerfile in the root of your project
Again, refer to [Docker’s best practice](https://www.docker.com/blog/intro-guide-to-dockerfile-best-practices/). Also, note that there should be steps to register the service with consul to enable service discovery.

## A docker-compose.yml in the root of your project
(You’ll use it alot).

## Good documentation
This is here twice on purpose. It’s really important.

_Level up your documentation game reading some of these articles:_

[Beginner’s Guide to Docs](https://speakerdeck.com/ericholscher/writing-docs-a-beginners-guide-to-writing-documentation)

[10 Things You Can Do To Create Better Documentation](https://www.techrepublic.com/article/10-things-you-can-do-to-create-better-documentation/)

_Read some beautiful docs to get inspired:_

[List of Beautiful Docs](https://github.com/matheusfelipeog/beautiful-docs)

Read some good books!

[Strunk & White’s Elements of Style](https://www.thriftbooks.com/w/the-elements-of-style-by-eb-white-william-strunk-jr/249214/#edition=2351806&idiq=142044)

[On Writing Well](https://www.thriftbooks.com/w/on-writing-well-the-classic-guide-to-writing-nonfiction_william-knowlton-zinsser/246124/#edition=2339386&idiq=2024383)

[The Insider’s Guide to Technical Writing](https://www.thriftbooks.com/w/the-insiders-guide-to-technical-writing_krista-van-laan/9477934/#edition=8842861&idiq=35389127)

### Docker Registry
If you’re working at a company with closed-source / proprietary software you’re going to have an additional challenge of where to host Docker images.

There are basically two options:

Pay Docker to do it. This is basically equivalent paying for private git repos on Github. They also have an option where they’ll host a private registry for you.

Host your own registry.
