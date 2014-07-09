---
title: Introduction to Macros with Sweet.js
layout: post
published: true
abstract: |
  Use Sweet.js and It’s macros to create modular JavaScript code.
writer:
  name: Fatih Kadir Akın
  url: http://twitter.com/fkadev

---

As far as you know, we mostly use same code over and over again on JavaScript.
Sometimes this makes huge time-loss and creates code confusion.

```javascript
for (var i = 0; i < 10; i++) {
    console.log(i);
}
```

There are some **things** in this code that we repeat unintentionally and
surprise! there is a way to simplify this:

```javascript
from 0 to 10 as i {
    console.log(i);
}
```

This is a bit more **declarative** and readable/editable code. Let’s create
more smaller version:

```javascript
to 10 as i {
    console.log(i);
}
```

Thanks to [Mozilla][0], they built a sweet JavaScript library called [Sweet.js][1].

We can edit our Sweet.js macro via using [macro editor][2].

Let’s write down the macro we've been considering above but first, we need to
examine the macro structure.

```javascript
macro <NAME> {
    rule { <CODE> } => { <OUTPUT> }
}
```

We need to place a `$` sign in-front of the macro variable. We can call our
macro:

    <NAME> <CODE>

Here is an example macro:

```javascript
macro variableDemo {
    rule { $x } => { var $x; }
}
```

and usage:

```javascript
variableDemo x = 10
```

this will produce:

```javascript
var variableDemo = 10;
```

## Design of Macro

Let’s try to design a macro with `for`

```javascript
to 10 as index {
    console.log(index);
}
```

call it:

```javascript
to $value as $index $code
```

In this point, `$value` is `10`, `$index` is `index` and `$code` is
 `{ console.log(index); }`. Let’s write down our macro:

```javascript
macro to {
    rule { $value as $index $code } => {
        ...
    }
}
```

`...` used as a **placeholder** and holds the code below;

```javascript
macro to {
    rule { $value as $index $code } => {
        for (var $index = 0; $index < $value; $index++) $code
    }
}
```

Well, we have a macro to use :)

```javascript
to 30 as i {
    console.log(i);
}
```

out puts:

```javascript
for (var i = 0; i < 30; i++) {
    console.log(i);
}
```

Let’s extend this macra a little bir and add another design to it.

Right now, let’s set the **initial value**;
    
```javascript
to 30 start from 10 as i {
    console.log(i);
}
```

this means, loop will start from `10`.

```javascript
macro to {
    rule { $value as $index $code } => {
        for (var $index = 0; $index < $value; $index++) $code
    }

    rule { $value start from $from as $index $code } => {
        for (var $index = $from; $index < $value; $index++) $code
    }
}
```

Now, `to` will respond to two different designs in two different ways.

```javascript
to 30 start from 10 as i {
    console.log(i);
}
```

will produce;

```javascript
for (var i = 10; i < 30; i++) {
    console.log(i);
}
```


## Using / Merging Macros

One of the best parts of Sweet.js that **a macro can use/call other macro**.

Lets extend an example above;

`to 30 start from 10 as i` we need to polish this a bit:

```javascript
from 10 to 30 as index
```

more readable. This means we need to create a `from` macro!

```javascript
macro from {
    rule { $from to $value as $index $code } => {}
}
```

Let’s plug `to` macro to our `from` macro.

```javascript
macro from {
    rule { $from to $value as $index $code } => {
        to $value start from $from as $index $code
    }
}
```

`from` macro will also call `to` :)

Let’s try the code below:

```javascript
macro from {
    rule {
        $start to $to as $index $block
    } => {
        to $to start from $start as $index $block
    }
}


macro to {
    rule {
        $to start from $from as $index $block
    } => {
        for (var $index = $from; $index < $to; $index++) $block
    }
    rule {
        $to as $index $block
    } => {
        for (var $index = 0; $index < $to; $index++) $block
    }
}


to 30 as i {
    console.log(i);
}

from 10 to 30 as index {
    console.log(index);
}

to 10 start from 2 as i {
    console.log(i);
}
```

Now, we have created a macro which provides a custom loop mechanism.

[Sweet.js][1] is highly details macro library. That would be really helpful
if you check and read it. If you want to know more about **repetition,
patterns, hygiene** or `infix` please take a look at 
[http://sweetjs.org/doc/main/sweet.html][3]

If I can find more time, I'm planning to write more about this topic in the
future!



[0]: www.mozilla.org
[1]: http://sweetjs.org
[2]: http://sweetjs.org/browser/editor.html
[3]: http://sweetjs.org/doc/main/sweet.html
