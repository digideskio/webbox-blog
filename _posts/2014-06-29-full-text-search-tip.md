---
title: Full Text Search Tip!
layout: post
published: true
abstract: |
  It was a kind of enlightenment for me! I’d like to share this great tip!
writer:
  name: Uğur Özyılmazel
  url: http://twitter.com/vigobronx
---
Couple of days ago, I was watching [CodeSchool][1]’s **CodeTv**. If you are 
a regular subscriber of CodeSchool, you have a chance to subscribe CodeTv via
iTunes.

There are always great topics, videos, information available on CodeTv. Since
last couple months, they have started a new series called "**Soup to Bits**".
If you ever complete the challenges, this would be great for you to verify
your knowledge.

I was watching **Rails for Zombies 2** episode. It’s **2 hours and 15 minutes** 
long. From scratch, [Carlos Souza][2] and [Greg Pollack][3] were building a
[Rails][4] application. That was all ok, normal stuff were going on.

In the example, there was a database table called `Books`. Fields like;
`title`, `description` and `author`. All text / String fields.

All we need is to make search query on `title`, `description` and `author`.

A classic and most common approach is use `SELECT LIKE` statement and iterate
over those three fields. Right ? Whatever you use? A classic `WHERE` situation.

```sql
:
:
WHERE
    books.title LIKE '%KEYWORD%' or
    books.description LIKE '%KEYWORD%' or
    books.author LIKE '%KEYWORD%'
:
:
``` 

Well, here is what [Carlos][2] did; He added another field to table called
`keywords` and made the model’s save method to grab + join those three
fields in to a single big String and putted as `keywords` field’s value.

Long story short, on every **Create** or **Update** operation; get all the
fields you want to search in it, change it to lower case and concat all and
place as `keywords` value.

## Rails way
```ruby
:
scope :search, ->(keyword){ where('keywords LIKE ?', "%#{keyword.downcase}%") if keyword.present? }
:
before_save :set_keywords # method to call before every save operation
:
protected
  def set_keywords
    self.keywords = [title, author, description].map(&:downcase).join(" ")
  end
```

Doesn’t matter which framework of platform, simple idea. Before you call save,
collect the fields you’d like to search, make them all lowercase, and
concat that with a single-space char!.

Now you can make **a single query** for searching instead of longer 
queries for looking up **three different fields** 8)

![CodeTV - Soup to Bits: Rails for Zombies 2]({{ site.baseurl }}assets/post_images/full-text-search-tip.png)





[1]: http://codeschool.com "CodeSchool"
[2]: https://twitter.com/caike
[3]: https://twitter.com/greggpollack
[4]: rubyonrails.org