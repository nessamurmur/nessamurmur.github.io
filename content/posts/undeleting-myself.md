+++
draft = false
date = "2025-08-23T17:20:42-07:00"
title = "Undeleting Myself: Embracing Cringe and the Joy of Code"
description = "Once upon a time, I was told 'if you need this to be fun, this probably isn't the job for you'..."
tags = ["neurodivergence","learning","growth","leadership"]
categories = ["leadership"]
+++

Once upon a time, I was told on the internet "if you need this to be fun, this probably isn't the job for you". This was a comment on a blog post; a blog post that had hit the top of Hackernews at the beginning of my second year of being a software engineer. I was trans (and didn't know it yet), I was Autistic and ADHD (and didn't know it). I had freshly quit college for my career in software. I was starry-eyed and idealistic. I felt like I could light the world on fire.

When it happened, I laughed! It seemed ridicuous someone even had the engergy to find the blog post and comment when they felt that bad about their day to day. These days, I outright feel sorry for the guy who left that comment wherever he is. I hope he's doing better and doesn't need to pick on kids on the internet to feel okay about his choices.

Time went on. I realized I was trans. It was like going through puberty again. I felt _super_ cringey for all my opinions, thoughts, and words pre-2016. I deleted basically every blog post I had written up to that point and only kept technical tutorials.

Nearly 10 years have passed since then. I grew up more. I felt solid in who I was. And now, I still feel like my words were cringey but I also feel like they're the words of a 22 year old... of course they're cringe.

So, in an effort to continue embracing the joy of who I am and pick back up where the starry eyed version of me who thought she could change the world left off... here's the _entire_ blog post that made grown men angry.

# The Importance of Whimsy in Learning to Program
The beginning of this is a little bleak. I had a pretty dull, if typical, experience trying to learn to program at first. There is point to this post though. If you get turned off by the first few paragraphs skip down a little because it is much more positive.

## YAWN
I had a lot of false starts as a programmer. My first little taste was when I was ten or eleven and my dad tried to teach me some Visual Basic. His enthusism for programming was infectuos and I decided I wanted to write code... It was the nineties and I tried finding programming resources but everything just seemed really off putting at the time and I quit for a couple years.

I tried several times over the years on my own and I'd make a lot of progress and write a simple calculator or some silly interactive terminal program and I'd just lose interest. I was probably just looking in the wrong places but eveer resource I tried to use was so dull. I thought it was me for a long time. I was a musician and was always into art and creative things and thought programming must just be for math nerds.

Then in college I though I should give it another try. I was majoring in Recording Industry and thought it would be a good backup plan (I was 18... I didn't nkow what I was doing.) That's when I found out it wasn't me. That's when I knew there's something fundamentally wrong with how programming typically gets taught.

My first college programming course was in C++. It was taught totally passionless by a professor who couldn't really speak fluent English. We worked in Ubuntu. Fortunately I had been playing with Ubuntu for a little while any way but most kids were totally lost and very little instruction was giving on working with a Unix machine. We were given a cheat sheet of basic commands and edited code in Gedit. We moved very, very slowly. We didn't get to loops until at least a month or two in. The code exercises we had to work through were abstract and didn't seem to have a purpose. I can't perfectly reproduce one but it would be something like this:

```
// Write a loop that print out numbers that are multiples of three

#include <iostream>
using namespace std;

int main()
{
  int i;
  i = 1;

  while (i < 100) {
    if (i % 3 == 0)
      cout << i;
    i += 1;
  }
  return 0;
}
```

When we did "fun" exercises they consisted of moving an ascii robot left right and up on the screen. I was bored out of my mind. With less than a month left in the class one day I just got sick to my stomach, left, and dropped the class. I decided again programming wasn't for me.

So I went through a period as a lost 20 year old musician realizing I didn't want a career in music and not having any idea what I wanted to do. Fortunately doing recording all the time I had been spending a lot of time configuring and troubleshooting computer issues. Over the years I had kept playing with different flavors of Linux and somehow started reading Admin magazine and decided I wanted to be a Sys Admin.

I went back to the computer classes. This time in the Information Systems program. When I took my first programming class there it was in VB. This professor canceled 2/5ths of our classes. Litterally, two out of five classes were canceled. He hadn't actually worked in the industry since the 70s and told us the most recent version of Apple's OS was Solaris... :( He was VERY click and code generator dependent and taught the class to be. He once took off points on an assignment because I didn't change the background color of all the UI elements of an application... My application did more than requested with things we hadn't gone over yet and I purposely didn't change colors because I wanted it to look like a native Windows app and I was punished for thinking through having a professional looking app. One application didn't even have readable text and they were given an A because they changed the colors.

## The Fun Begins
Meanwhile, at home I was working through tutorials in Admin magazine and writing bash scripts. I knew there was a better way than what I was going through at school but didn't know how to find people who were part of the better way.

Jump forward a few years to my first IT job. I had been there for six months and was transitioning into a more Supervisor-y role for the support team. We wrote a lot of scripts to bandage up broken processes and monitor services that weren't very dependable. Somehow I ended up writing a little Ruby and it changed my life.

I think I always found programming to be a little fun or I would have put myself through going back and forth all my life. But it wasn't until I was writing Ruby that I found learning to program to be fun. What's funny is it really doesn't take much effort to be more enjoyable than the C++ examples from earlier. My first Ruby program was something like this:

```
print "What's your first name?"
first_name = gets.chomp

print "What's your last name?"
last_name = gets.chomp

puts "Your name is #{first_name} #{last_name}"
```

As simple as the example is and as little as it does it was much more enjoyable. I had written examples like this in C++, VB, C#, and Javascript but just getting to write gets.chomp and puts over cout << and cint >> made all the difference. Ruby examples kept me engaged just long enough that I could find [_why's poignant guide to Ruby](https://poignant.guide/).

This is the book that hooked me in. I was sold. I was a Rubyist. I immediately started thinking about code 24/7. I blew past all the material we should have covered in my college courses and started learning things that didn't even teach us* in college like unit testing and thinking about good Object Oriented design. I moved past needing something to engage me and just needed more input.

So now I'm at the point in my life where I can look at some archaic looking C and get excited and want to dig in. I get excited by books like Seven Languages in Seven Weeks excite me and spend my spare time writing Erlang because ideas of lightweight processes and hot code swapping excite me and while things like Celluloid are great for writing concurrent Ruby, it's hard to beat Erlang's actors. Ruby may not be the fastest language around, but the community around it seems to have more fun playing with code and naming things than any other programming community (at a distance at least).

## I Should Get to the Point Already
So I guess what I'm saying is if gets.chomp can keep me engaged enough to switch career paths and become a 24/7 programmer who dreams in code just think what naming an XML parser "Nikogiri" instead of "XML Parser" could do? Writing code is interesting in and of itself. Being able to write code is like being able to do magic. There's no reason for us to continue on pretending like we aren't creative. We solve difficult problems in code everyday. We could write our code in a way that communicates "Hey, we're having fun. We're playing. Stay with us and can play, too." Just think about it next time you start naming a class CSVReader.

## Footnote
*Granted... I did end up leaving school before most of the upper division classes. They may very well have tought object oriented design later on but based on my experience my guess is it was pretty convoluted.
