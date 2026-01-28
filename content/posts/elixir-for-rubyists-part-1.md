+++
title = "Elixir for Rubyists Part 1"
date = "2013-09-27 01:27:00"
images = []
tags = ["elixir","functional programming"]
categories = ["code"]
draft = false
+++

Elixir is my new favorite language. This will be part one of a yet to be determined number of post on Elixir. Elixir's syntax will be VERY familiar to Rubyist. So I'm just going to jump into a lot of code try to show you how it works.

## Elixir is FUNctional

Elixir is a functional language that runs on the Erlang VM, but looks a lot like Ruby.

```elixir
2 + 2
# => 4

IO.puts "Hello!"
# => Hello!
#    :ok

String.downcase("I DON'T YELL")
# => "i don't yell"

defmodule Numbers do
  def add_to(num) do
    if is_number(num) do
      num + 2
    else
      raise(ArgumenError, message: "Argument must be a number")
    end
  end
end

Numbers.add_to(4)
# => 6
Numbers.add_to("Nessa")
# => ** (ArgumenError) Argument must be a number
```

Elixir makes use of pattern matching to do comparisons and assign values to variables.

```elixir
a = 2
# => 2

2 = a
# => 2

{ success, string } = { :ok, "Hey Joe, whatcha know?" }
# => {:ok, "Hey Joe, whatcha know?"}
success
# => :ok
string
# => "Hey Joe, whatcha know?"

```

Elixir is _functional_ so variables are immutable. That said, unlike Erlang variables are not limited to single assignment. If you want to pattern match against the actual _value_ of a variable you need to use a carot. If you leave off the carot you can re-assign a variable.

```elixir
a = 2
# => 2
^a = 3
# => ** (MatchError) no match of right hand side value: 3
#    :erl_eval.expr/3
a = 3
# => 3
```

Like any functional language, Elixir treats functions as first class citizens. You can pass functions around inside variables for lazy evaluation. Notice the string interpolation in the following example. More Ruby familiarity.

```elixir
greeter = fn (name) -> IO.puts "Hello #{name}" end
# => #Function<6.80484245 in :erl_eval.expr/5>
greeter.("Nessa")
# => Hello Nessa
#    :ok
```
You can write functions that return functions.

```elixir
defmodule FunctionExamples do
  def build_greeter(kind) do
    case kind do
      :hello -> fn (name) -> "Hey there, #{name}!" end
      :goodbye -> fn (name) -> "See ya, #{name}!" end
      _ -> fn (name) -> "I don't even know what to say to you, #{name}." end
    end
  end
end

say_hello = FunctionExamples.build_greeter(:hello)
# => #Function<0.63189797 in FunctionExamples.build_greeter/1>
say_hello.("Nessa")
# => Hey there, Nessa!
#    :ok

wat = FunctionExamples.build_greeter(:something_else)
# => #Function<2.63189797 in FunctionExamples.build_greeter/1>
wat.("Nessa")
# => "I don't even know what to say to you, Nessa."
#    :ok
```

Also like other functional languages, rather than relying on loops Elixir makes heavy use of recursion. That said, the Enum modules provides you with some function that will be familiar for Rubyists, like each.

```elixir

Enum.each(["Jane", "Jill", "Jose"], fn (name) -> IO.puts(name) end)
# => Jane
# => Jill
# => Jose
# => :ok

defmodule RecursionExamples do
  def recurse([]) do
    :ok
  end
  def recurse([head|tail]) do
    IO.puts head
    recurse(tail)
  end
end

RecursionExamples.recurse(["Jane", "Jill", "Jose"])
# => Jane
# => Jill
# => Jose
# => :ok

```

That's the end of part one. Stay tuned for part two.
