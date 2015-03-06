---
title: Ruby argument references
layout: post
published: true
abstract: |
  While I was reading the [Programming Ruby](https://pragprog.com/book/ruby4/programming-ruby-1-9-2-0) book the other day, I
  noticed something I missed before!
writer:
  name: Uğur Özyılmazel
  url: http://twitter.com/vigobronx
---
Yet another cool feature of Ruby! I’ve never seen such a thing in other languages
such as Php, Python or JavaScript. Let’s take a look at it:

```ruby
def user_ratio(age, val=age*2)
  "Your age: #{age} and val: #{val}"
end

user_ratio(42) # => "Your age: 42 and val: 84"
```

This small method requires two arguments. First argument is `age` and it’s
default value is not defined. Next argument is `val` and it’s default
value is a **reference to the first argument** and making a multiplication
with number 2 if the second argument is not provided.

If we use the second argument:

```ruby
user_ratio(42, 10) # => "Your age: 42 and val: 10"
```

method works as expected. Don’t you think It’s cool?