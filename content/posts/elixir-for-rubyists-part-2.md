+++
title = "Elixir for Rubyists Part 2"
date = "2013-10-10 00:55:00"
images = []
tags = ["elixir","functional programming"]
categories = ["code"]
draft = false
+++

An attempt to answer some questions from [part 1](https://blog.nessajane.tech/posts/elixir-for-rubyists-part-1/).

## Immutable??
Elixir variable are immutable. They are _not_ single assignment. "But Nessa!", you may protest, "If you can re-assign variables... isn't that mutation." No!

## Elixir Variables Ensure Referential Transparency
Referential transparency is just an academic way of saying "when I do things to transform a value I can always go back to that value and expect it to be the same." In simpler terms, Jessica Kerr ([@jessitron](https://twitter.com/jessitron)) likes to call this "data in, data out". In plain code:

```elixir
name = "Nessa"
# => "Nessa"
String.upcase(name)
# => "NESSA"
name
# => "Nessa"
```
String.upcase is referentially transparent. It returns a new transformed value, but it does _not_ mutate that value in place. Contrast that with Ruby's String#upcase!

```ruby
name = "Nessa"
# => "Nessa"
name.upcase!
# => "NESSA"
name
# => "NESSA"
```

String#upcase! is _not_ referentially transparent. Not only does it return the new transformed value but it also changes the _state_ of the variable name.

## Why Does Referential Transparency Matter?
In short, referentially transparent code is easy to test, easy to read and understand, and easy to make threadsafe. In Ruby, if you had:

```ruby
greeting = "Hello"
do_something_to_string(greeting)
print(greeting)
```

We would _expect_ greeting to be "Hello" when you print it but do_something_to_string could just as easily have changed the value of greeting. Not to mention if greeting is being passed around an application and all kinds of do_somethings are being called on it. By the time you get to print greeting it could just as easily say "Game over!"

In longer terms check out:

* [Jessica Kerr's Functional Principles](http://confreaks.com/videos/2382-rmw2013-functional-principles-for-oo-development)
* [Ruby Rogues Podcast: Functional and OO Programming](http://rubyrogues.com/115-rr-functional-and-object-oriented-programming-with-jessica-kerr/)
* Please let me know if you have other recommendations and I'll add them!

## A Caveat...
You _can_ re-assign the variable name to a _new_ value based on it's current value. It's important to note here that = is _not_ an assignment operator. It is a match operator. When we use it with a variable will can either try to match the value of a variable or we can allow that variable to be (re)bound to a value.

```elixir
1 = 2 # the value 1 does not match the value 2
# => ** (MatchError) no match of right hand side value: 3
#    :erl_eval.expr/3

:a = 2 # the value :a, an atom (kind of like a symbol in Ruby), does not match the value 2
# => ** (MatchError) no match of right hand side value: 3
#    :erl_eval.expr/3

num = 2 # num is a variable. We can bind two to it to make them match!
# => 2

^num = 3 # the value of num (2) does not match the value 3
# => ** (MatchError) no match of right hand side value: 3
#    :erl_eval.expr/3

num = 3 # we are now not matching the value, num can be rebound to 3
# => 3
```
The way I understand it, this is included in Elixir as a convenience and is particularly useful in writing macros. Most functional purists will hate this. If you hate this, please see [this thread](https://groups.google.com/forum/#!searchin/elixir-lang-core/single$20assignment/elixir-lang-core/FrK7MQGuqWc/2aimbHDAAHMJ) on re-binding variables in Elixir and look at Joe Armstrong's comment.

Again, this is not changing the state of an object. There are no objects in Elixir. num is just a container for data and you can re-bind it to new data. When you re-bind it the old data will be promptly chucked by the runtime leaving your memory free to store new data.

## Just Try and Break it!
You are still going to have a hard time writing a function that breaks referential transparency. If you re-bind a variable inside a function you are only binding that variable within the scope of the function:

```elixir
defmodule Assignment do
  def change_me(string) do
    string = 2
  end
end

# when you compile this module you will get warnings that variable string is unused!

greeting = "Hi"
# => "Hi"
Assignment.change_me(greeting)
# => 2
greeting
# => "Hi"

```

## That's All Folks
That's it for part 2. Stay tuned for part 3. (EDIT: there was never a part 3)
