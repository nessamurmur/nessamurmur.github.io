+++
draft = false
date = "2025-08-28T17:21:47-07:00"
title = "How to Learn a Programming Language in 7 Days"
description = "Learn from a polyglot of 15 years how to pick up new languages quickly"
slug = ""
authors = []
tags = ["languages"]
categories = ["code"]
externalLink = ""
series = []
+++

I'm re-learning a language I haven't written in 13 years. And I'm a polyglot who's lost track of how many languages I've written in and has written near a dozen in production. Early in my career I read a book called [7 Languages in 7 Weeks](https://pragprog.com/titles/btlang/seven-languages-in-seven-weeks/). Later, I read [7 More Languages in 7 Weeks](https://pragprog.com/titles/7lang/seven-more-languages-in-seven-weeks/), [7 Databases in 7 Weeks](https://pragprog.com/titles/pwrdata/seven-databases-in-seven-weeks-second-edition/), and [7 Concurrency Models in 7 Weeks](https://pragprog.com/titles/pb7con/seven-concurrency-models-in-seven-weeks/). I will probably always be thankful I read those books at the beginning of my career because as someone who already had to teach myself a lot of skills, it taught me to articulate my framework for learning skills _and_ to optimize it. Now I'm sharing that with you.

Why would you want to build this skill? Well it's not really about learning _fast_. It's about learning comprehensively. It's about being able to visit other languages and take away big learnings for your work. It's about creative inspiration. It definitely _does_ come in handy when you want to start a new job where you'll be writing a language you haven't written before or haven't written in a while. But my favorite use of this skill, is to be able to take experiences from many, many places and create something unique.

So here it goes:

# Day One: Learn the Language Features
On day one, you are not trying to learn syntax, idioms, community preferences, or tools. You're just trying to get a sense of the philosophy and mindset of the language by learning the major features it supports and ideally why the author chose those features.

Here's some questions to answer on day one:
1. Is this language compiled or interpreted?
2. Is this language part of a family of languages like ML languages or Lisp languages?
3. Does this language share a VM or other core with other languages (think Java & Clojure, Erlang and Elixir).
4. How does this language treat mutable and immutable state? Which does it default to and when?
5. How does this language handle abstracting things into re-usable chunks (variables, functions, methods)
6. What are the central philosophy's named for this language ("Everything is a object", "actors sending messages", "it's all lambda calculus")
7. How does memory management work? (you do it yourself, garbage collection, ownership, etc)
8. How does concurrency work?
9. What do people say it's good at?
10. What do people say it's bad at?

The main idea here is to walk away with a vague sense of why someone wanted this language to exist, what problem they want it to solve, and what core ideas are in it. You don't need to know more you're just trying to get a sense of it's "personality". You might also start thinking about what the website looks like and what information they prioritize upfront. Is the website gorgeous and are the examples silly? Maybe this language community enjoys what they're doing and has a lot of people in it with design skills. Is it mainly text on a white background? Does that mean it's mainly used in academic settings? Is there a lot of documentation up front or is it buried or incomplete?

# Day 2: Getting a feel for how it writes
No where in here am I going to direct you to try to figure out syntax only. If you've written  more than one or two languages, you will most likely figure out syntax along the way trying to learn the features and trying to learn the idioms of the community.

For day two, write something small you can write an MVP for in a short amount of time that solves a real world problem. I'm thinking HTML parser, markdown parser, JSON serializer, web server, csv parser... Something that has real world requirements but something that can probably be written with the language and maybe the standard library of the language. Try to avoid libraries beyond the standard library today and focus on learning what the language itself has to offer.

Things to try:
1. Write tests with whatever testing tools are available in the language or standard library. This can teach you about how much the language author prioritized testing, what kind of testing, and what it's like to validate your code works. It'll also start teaching you the features of the language more concretely.
2. Experiment with leaning into big language features. If your language says it's good for concurrency, try to use it's concurrency model for part of your problem. If it's VM is built for self-healing an resilience (looking at you Erlang) see if you can try running something that's hard to knock down. This will get your toes wet with the big ideas of the language.

I find writing something real world that doesn't need whole frameworks to hold it up can take you further than a fizzbuzz style exercise, without having to learn _everything_ going on in the language community at one time.

As you go, you might start getting hints of what's idiomatic from documentation or code examples online.

# Day 3: Try to learn the idioms
Here's where you start branching out. Keep working on your exercise but maybe pull in one or two libraries that seem popular. To figure out what's popular research what books are popular, see what people are blogging about, look at stats on Github, hell ask an LLM these days. Look at the patterns in the library you picked. Compare to a library you didn't pick. Start looking for community resources like IRC servers, Slacks, popular blogs, meetups.

Can you get a sense of how homogenous the idioms in this community are? Is it like Ruby where there's a relative amount of agreement and large opinionated frameworks defining the direction? Or is it like Javascript or Python where everyone writes it completely differently? If it seems very heterogenous, how are people who are solving the problems you want to solve using it? Are the trending in the same direction? Who diverts from the norm and why?

Also see if you can start getting a sense of why people prefer these idioms? Does it have to do with the core philosophies of the language? Is it for "readability"? Is it to avoid confusing errors? All of the above?

Going about discovering idioms this way should also start to give you a small idea of what parts of the community might be like.

# Day 4: Build something on a framework or foundational library.
Look for something to build you can probably build in a few hours but that takes a framework or a group of libraries to build easily. Some ideas are a microblogging framework, a todo list, a CMS, a photo album organizer, a command line tool... just something you can build a small MVP of and exercise:
1. Popular testing libraries
2. A framework for your problem (web framework, desktop application framework, interactive command line tool, whatever)

Along the way, read guides for the framework, look at tutorials, see how people are talking about it online. Keep starting to get a feel for the community before you dive in later. Focus on trying to complete your solution.

What did using this framework teach you about the community of this language? What did it teach you about the language features or philosophy? What was easy? What was difficult? What did you not have to think about you normally do? What opportunities do you have to lean into the features of the language more?

# Day 5: Dive into the community
Hopefully, over the last couple days you've gotten a feel for where to look! But if not, look at Github at popular libraries. Read the issues and the open and closed PRs. Who's name comes up a lot? What are they talking about? How are they talking? Who are they helping? How knows what's going on and who's new here? Figure out popular blogs, podcasts, look for conference talks, google what books sell well or are highly regarded. Who are the big authors? What do they value in the language and in life? Who makes up the community? Where are they? How do they treat each other? How do they think about other languages? What's the current discourse? What don't people agree about and what do they think is answered and doesn't need to be thought about?

I have found this step to be one of the most informational steps of all of the steps. After getting basics out of the way, understanding the people involved, the problems they're solving, and how they behave is one of the quickest ways I know to get a solid idea of how to find your way around when you don't know something about how to work in this language and this community.

# Day 6: Write more
You have so many options, decide for yourself what still feels confusing and unfamiliar and what might help you figure it out. You can go back to your previous exercises, try taking on an issue in an open source library, start a new exercise, start reading a book or working through blog posts. The main idea is to start your deeper learning you're going to have to continue throughout your time with this language.

# Day 7: Reflect and Rest
Take a break from trying to learn new things! That was a lot in six days. Write down key takeaways somewhere you can refer to later. Create bookmarks, reminders, and whatever else you need to point yourself to other corners of the community or the language you want to explore later. Don't spend more than an hour. Than go take a break. Sit in a hammock and enjoy being you. Touch grass. Give your brain and body and break from screens and let the information process in the background of your mind.
