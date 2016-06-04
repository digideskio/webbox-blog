---
title: Rack Protection tips
layout: post
published: true
abstract: |
  Most of the Ruby based web applications are using [Rack][1]. Rack is a Ruby
  webserver interface. Rack comes with many goodies. We’ll take a look at it’s
  extention feature: **Protection**
  [1]: http://rack.github.io/
  
writer:
  name: Uğur Özyılmazel
  url: http://twitter.com/vigobronx
---
I was playing with [sinatra-activerecord][1] gem for [Sinatra][2] the other day.
Building a basic **CRUD** application for test purposes. Sinatra comes with
[rack-protection][3] gem.

While I was doing some form post operations, I recognized that, if I post
something like:

```html
<script>alert('foo')</script>
```

in the form input, the code I wrote worked and executed :) I was very surprised
since I thought that **rack-protection** is taking care of **escaping** inputs!

I figured it out that, I need to make some changes in my `config.ru` file.

```ruby
require "sinatra/base"
require "rack/protection"

require File.expand_path '../application.rb', __FILE__

use Rack::Protection::EscapedParams # This makes the magic
run MyApplication
```

This worked like a charm. I started to dig what other protection features do I
have?

### Cross Site Request Forgery

* Rack::Protection::AuthenticityToken
* Rack::Protection::FormToken
* Rack::Protection::JsonCsrf
* Rack::Protection::RemoteReferrer
* Rack::Protection::RemoteToken
* Rack::Protection::HttpOrigin

### Cross Site Scripting

* Rack::Protection::EscapedParams
* Rack::Protection::XSSHeader

### Clickjacking

* Rack::Protection::FrameOptions

### Directory Traversal

* Rack::Protection::PathTraversal

### Session Hijacking

* Rack::Protection::SessionHijacking

### IP Spoofing

* Rack::Protection::IPSpoofing

I did many web application with [Django][4] last few years. Django was built-in
coming with **CRSF** protection on web forms. I'd like to add **CRSF**
protection to my sample Sinatra application with Rack’s feature!

First, I added few lines to my `config.ru` file again;

```ruby
require "sinatra/base"
require "rack/protection"

require File.expand_path '../application.rb', __FILE__

use Rack::Session::Cookie, :secret => "!x#foo"  # This must be set!
use Rack::Protection::FormToken                 # CRSF enabler
use Rack::Protection::EscapedParams
run MyApplication
```

Then, I need to inject **crsf token** in to my html form! Just added this
hidden input field:

```html
<input type="hidden" name="authenticity_token" value="<%= session[:csrf] %>">
```

That was it! If you `curl` and check the **http-headers**, you’ll see:

    HTTP/1.1 200 OK
    Content-Type: text/html;charset=utf-8
    Content-Length: 2574
    X-XSS-Protection: 1; mode=block
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    Set-Cookie: rack.session=BAh7B0kiD3Nlc3Npb25faWQGOgZFVEkiRTZmMTA5MTZkNzk3M2I1YmY3NWEy%0AZGIwYmM0MmQyNTA0YTQ0YmRjNDNhNWU3YjNjNTNlY2Q3NTIyNzgyMTI5OTMG%0AOwBGSSIJY3NyZgY7AEZJIiVjODQ5NTVhOTQ1Y2YzNjg1OTIzMTgyZmVkYWZm%0AYzQ4YgY7AEY%3D%0A--c4ffd2647d6bfdf7fa6b7dfb28357eb0936f7e55; path=/; HttpOnly
    Connection: keep-alive
    Server: thin 1.6.2 codename Doc Brown

There were only two form elements in my html-form and fields were `post[title]`
and `post[description]`. I tested via;

    curl -d "post[title]=foo&post[description]=moo" http://127.0.0.1:9393/post/edit/18/

and it returned : **Forbidden**

**Rack** and it’s middlewares are super awesome! You can check our sample
application here on [GitHub][5].

As [Avdi Grimm][6] said: **Happy Hacking**

[1]: https://github.com/janko-m/sinatra-activerecord
[2]: http://sinatrarb.com
[3]: https://github.com/rkh/rack-protection
[4]: https://www.djangoproject.com/
[5]: https://github.com/webBoxio/sinatra-activerecord-example
[6]: https://twitter.com/avdi