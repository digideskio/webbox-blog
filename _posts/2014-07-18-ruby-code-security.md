---
title: Ruby code security
layout: post
published: true
abstract: |
  You can secure the Ruby code with `$SAFE` variable!
writer:
  name: Uğur Özyılmazel
  url: http://twitter.com/vigobronx
---
I started writing a [Ruby 101][1] book in Turkish. This will be a kind of
pocket guide, covering most of the basic stuff especially for me :) It’s like a notebook to assist you in your
daily Ruby usage.

While I was writing about `global_variables`, (*That was a quite refreshing
memory for me*) I remembered a lovely global variable which is called
`$SAFE`

## What is `$SAFE`

Well, as far as you can understand, this is a flag that Ruby will
evaluate the upcoming code against the required security level.

Normal, all the Ruby code / scripts work at **level 0**. This means, by default:

`$SAFE = 0`

What happens if you set the value to 1 ? Right now, you have something called
`tainted` data. I remember the song called **Tainted Love** by [Soft Cell][2]
8) If you are old enough to remember them!

After security level set, Ruby keeps track of changed or tainted data on lot
of things. Such as `Array`, `String`, `Hash` etc...

When the security level is set to 1;

* `RUBYLIB` and `RUBYOPT` env-variables are not processed and current
directory is not added to path.
* Command line options such as `-e, -i, -I, -r, -s, -S, -x` are not allowed.
* System commands or `exec` can won't work from a **tainted string**
* Can not processes from `$PATH`
* `chroot` for directory won’t work (_if the dirname is tainted string_)
* Not possible to `glob` or `eval` tainted strings.
* `require` won’t work if a filename is tainted string.

## What is Tainted String ?

User inputs are **tainted** by default.

```ruby
input = gets      # get input from user
input.tainted?    # true
```

can we fix this? YES!

```ruby
input = gets      # get input from user
input.tainted?    # true
input.untaint     # make it pure again :)
input.tainted?    # false
```

`untaint` works because we did not set the **security level**. Let’s try
 **level 3**. Save this file as `test_tainted.rb` and execute via;
`ruby test_tainted.rb`

```ruby
#!/usr/bin/env ruby
$SAFE = 3
puts "Enter a text"
input = gets
puts "Tainted Love? #{input.tainted?}"

input.untaint
puts "Is untain worked? Still tainted? #{input.tainted?}"
```

Booom!

    tainted.rb:8:in `untaint': Insecure operation `untaint' at level 3 (SecurityError)

## Let’s modify a String object

For me the most beautiful part of Ruby is that you can manipulate anything even the Standard Libraries. For example you
can add a custom method to `String`.

```ruby
puts "hello"  # a standard string

class String
 def my_method
   "Hello! This is my custom method"
 end
end

puts "hello".my_method

$SAFE = 4      # lets lock this thing!
class String
 def my_mehdod
   "I modified my custom method 8)"
 end
end

puts "hello".my_method
``` 

output is:

    hello
    Hello! This is my custom method
    
    ArgumentError: $SAFE=4 is obsolete

Thats because you can not modify `String` on **level 4**.

## Internal and External Data

If you set a value to a custom variable, this is an **internal data**.

```ruby
s = "Hello"
puts s.tainted?      # false

puts s =~ /(\w)/
puts $1              # H
puts $1.tainted?     # false
```

Nothing is **tainted** because they are all **internal**. Let’s look at these
variables;

```ruby
puts ENV["HOME"].tainted?            # true
puts ENV["RBENV_VERSION"].tainted?   # true
puts ENV["SHELL"].tainted?           # true
```

They are all **external** and **tainted** :) You can not use **dangerous methods**
on tainted data! If you try to code above on **level 3**;

```ruby
$SAFE = 3
puts ENV["HOME"].tainted?
puts ENV["RBENV_VERSION"].tainted?
puts ENV["SHELL"].tainted?
```

You’ll get:

    SecurityError: Insecure operation - []

When google it about `$SAFE`, I found that:

> We use $SAFE = 4 to create a sandbox for the
execution of semi-trusted scripts, conforming
to our application's plug-in API.
"Semi-trusted" meaning of third-party origin,
but not intentionally malicious.

[source][3]

If you like to dig deep, please check [this website][4] for more information.
If you set it to level 3, **All objects are created tainted** and you **can’t
untaint** any of them!

## Trust and Untrust

There is a slightly diffence between `trust` and `taint`. **Taint** is related
to data, **Trust** is related to an access to a data. It’s like `taint` checks
if the data is ok? `trust` checks if the data is accessible.

[Matz][5] mentioned this on a Ruby forum:

> Tainting is a mark for data from outside world.  Data from outside
cannot be trusted.  Untrusting is a mark for data from untrusted code
(that run under $SAFE level 4).

One more important thing. You can’t set/change `$SAFE` if you set it earlier.
I mean, if you set `$SAFE` level to **3**  you can’t modify it later like to **2** or lesser.
. You can increment the `$SAFE` value but **can’t decrement**!

```ruby
$SAFE = 3
puts "Hello world"

$SAFE = 2
puts "Hello world"
```

    SecurityError: tried to downgrade safe level from 3 to 2

But this works:

```ruby
$SAFE = 1
puts "Hello world"

$SAFE = 2
puts "Hello world"
```

This is a really interesting topic. Sad that it is not possible to find more detailed
information about it. I tried to cover as much as I can. Feel free to add
comments, resources, links to this post!


[1]: https://www.gitbook.io/book/vigo/ruby-101/
[2]: http://www.youtube.com/watch?v=ZeJkbqjQvnk
[3]: https://www.ruby-forum.com/topic/1887006#1004452
[4]: http://phrogz.net/programmingruby/taint.html
[5]: https://github.com/matz
