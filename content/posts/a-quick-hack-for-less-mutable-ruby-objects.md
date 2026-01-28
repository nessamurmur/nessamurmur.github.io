+++
title = "A Quick Hack for Slightly Less Mutable Ruby Objects"
date = "2015-02-26T23:04:46Z"
draft = false
+++

This won't give you all the benefits of language level support for immutable objects and doesn't *really* prevent you from mutating state... It just kind of a fun hack to work with objects like you would values in immutable languages. There's way better options ([Hamster](https://github.com/hamstergem/hamster), [Adamantium](https://github.com/dkubb/adamantium)) if you're looking for something a little more substantial.

```ruby
class Person
  attr_reader :name, :age, :favorite_color

  def initialize(attrs)
    @name           = attrs[:name]
    @age            = attrs[:age]
    @favorite_color = attrs[:favorite_color]
  end

  def self.alter(person, attrs)
    new(person.send(:attributes).merge(attrs))
  end

  def alter(attrs)
    self.class.alter(self, attrs)
  end

  private
  def attributes
    instance_variables.each_with_object(Hash.new) { |ivar, h|
      h[key_from(ivar)] = instance_variable_get(ivar)
    }
  end

  def key_from(ivar)
    String(ivar).gsub('@', '').to_sym
  end
end
```

Usage:

```ruby
nate = Person.new(name: "Nessa", age: 25, favorite_color: "green")

# when Nessa's age changes
older_nate = nate.alter(age: 26)
```
