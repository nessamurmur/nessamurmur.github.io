+++
title = "Parens Are Your Friends"
date = "2014-09-15 20:27:33"
images = []
tags = ["clojure","lisp","functional programming"]
categories = []
draft = false
+++


### The Middle Finger

I was recently at a Hackathon standing in a group of people introducing ourselves. At one point someone I hadn't met before ask me how I knew someone else in our group. I said "Oh we know each other from [NashFP](http://nashfp.org/)". "What's NashFP", he asked. "Nashville Functional Programming group". He asked us what functional programming was and after a few attempts at describing functional programming he finally asked us "What's a functional programming language I might recognize?" We listed a few and then one of us said "Lisp". At that moment he interjected "Oh Lisp! I know enough about Lisp to give it the middle finger!" Soon after he exited the conversation.

![XKCD: Lisp](http://imgs.xkcd.com/comics/lisp.jpg)

The encounter encouraged me to write a blog post to explain a couple of things that tripped me up at first. To do this I'm going to be using Clojure for examples, mostly because it's a modern Lisp and it seems to be [growing in popularity](https://www.google.com/trends/explore#q=clojure)... That and I just love Clojure.

### How Do I Even Lisp?

The first time you see a snippet of Lisp it can be pretty confusing. You're probably used to being able to type `2 + 2` and get `4`. If you're use to that than Lisp will look pretty confusing at first. The Lisp equivelent of `2 + 2` is `(+ 2 2)`. In fact, you can even add more than two numbers `(+ 2 2 2 2 2)` will return `10`.

#### Wat!?

This may seem arbitrarily strange but there's actually a very good reason for this. Lisp used to be a shortname for LISt Processing. Lisps process lists. Lisp organizes code using _prefix notation_. In a Lisp the first element in a list is called the _operator_ and the preceding elements are called the _operands_. When you type a bare value like `4` into a Lisp repl it will return the value. When you type a list into a Lisp REPL it's expecting the first element to be a function that can be applied to the rest of the elements in the list. The semicolons in the example are just comments. The exception refers to a Java class because we're working with Clojure.

```lisp
(/ (+ 2 2) 2)
;2

(def x 10)
;#'user/x

x
;10

(x)
;ClassCastException java.lang.Long cannot be cast to clojure.lang.IFn  user/eval660 (NO_SOURCE_FILE:1)a

(reduce + (map inc '(0 1 2)))
;6
```


If you just want Lisp to interpret a list and return the list you can _quote_ the list with a single tick:

```lisp
'(1 2 3)
;(1 2 3)

'(x)
;(x)

'(+ 2 2)
;(+ 2 2)
```

Notice that you can even quote a list with an operator at the beginning and that operator will not be applied to the operands in the list. We'll get back to this in a bit.

#### Ugh. Parens.

At first when you're getting used to a Lisp the parens can be really off-putting. One thing that will help in any Lisp is knowning that Lisp doesn't care much about whitespace. You can arrange your parens into something more readable.

```lisp
(/
  (+ 2 2)
  (- 4 2))
; 2

(defn add-one [num]
  (+ 1 num))
;#'user/add-one

(reduce +
  (map add-one '(0 1 2)))
;6
```

### Ok.. But What's the Point?

**Simplicity**. Lisp-y simplicity is embodied primarily in something called _homoiconicity_. Homoiconicity is just a big word for saying `code == data`. In other words, rather than having a complex syntax Lisps "syntax" is just a big data structure, close to the datastructure in memory at runtime. Those of us who like Lisp like to say Lisp has _no_ syntax... It's not exactly true and Clojure in particular has some nice syntactic sugar for readablility and convenience.

Beyond just the simplicity of the syntax, homiconicity also gives Lisp **flexibility**. Since the syntax is very nearly the data structure evaluated at runtime metaprograming in Lisp is trivial. It's easy to extend the language, write a nice DSL, and generally do more with less code. How flexible you ask? Well to give you an idea, the original Lisp defined by John McCarthy in [Recursive Functions of Symbolic Expressions and Their Computation by Machine, Part I](http://www.cse.sc.edu/~mgv/csce531sp13/Mccarthy-Lisp60.pdf) consisted of only seven functions and two special forms that was completely turing complete through function composition.

### I'm intrigued... Where can I learn more?

#### Clojure Specific

* [Clojure for the Brave and the Bold](http://www.braveclojure.com/) A free book for beginners
* [The Joy of Clojure](http://joyofclojure.com/) For a deeper, more intense dive into Clojure

#### Common Lisp

* [Land of Lisp](http://landoflisp.com/) A fun romp through Common Lisp through writing games

#### Scheme

* [The Little Schemer](http://www.amazon.com/The-Little-Schemer-4th-Edition/dp/0262560992) Still haven't gotten to this one myself but I always hear great praise for it
* [Structure and Interpretation of Computer Programs](https://mitpress.mit.edu/sicp/) A absolute must read for anyone in computer science regardless of what you like to write

#### For Nashvillians

There's a Lisp hack night in Nashville called [Nashville Lisp Sync](http://www.meetup.com/Nashville-Lisp-Sync/). Feel free to come out and join us!
