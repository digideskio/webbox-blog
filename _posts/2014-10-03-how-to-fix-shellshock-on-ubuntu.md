---
title: How to fix Shellshock on Ubuntu
layout: post
published: true
abstract: |
  How to fix Shellshock aka Bash Vulnerability on Ubuntu!
writer:
  name: Uğur Özyılmazel
  url: http://twitter.com/vigobronx
---
Every single day, we are facing some kind of back-door or vulnerability on
servers, apps, systems, os'es etc.

Few days ago, internet world shaked via [Shellshock][1] on [Unix Bash Shell][2].
It’s funny that, Unix is the most trusted operating system, also Bash was a
rock solid shell :) Yes, It was ...

If you have ***nix** kind of operating system, you can test your Bash if it is
safe or not:

```bash
env x='() { :;}; echo vulnerable' bash -c "echo this is a test"
```

If you see **vulnerable** text, this means that you need to upgrade your Bash!
If not, you’re good to go :)

We use [Ubuntu][3] OS on our production servers. That’s why I’ll talk about
how to fix it :)

Login your system and check the code name of your OS. One of our server is
running on **Ubuntu 13.04 (GNU/Linux 3.8.0-35-generic x86_64)**

```bash
lsb_release -a
```

You’ll see something like this:

    No LSB modules are available.
    Distributor ID: Ubuntu
    Description:    Ubuntu 13.04
    Release:        13.04
    Codename:       raring

Our codename is `raring`. Now, do ;

    sudo sed -i 's/raring/trusty/g' /etc/apt/sources.list

If yours codename is different, change `raring` to yours please. After that
you need to `sudo aptitude update` to update your sources for package
installation. Then;

    sudo apt-get install --only-upgrade bash

When It’s done, re-test your system via;

```bash
env x='() { :;}; echo vulnerable' bash -c "echo this is a test"
```

If you only see `this is a test` It means you've patched your Bash correctly!
There are few sites that checks online but you need to do this by your hands
for your own good :)

Let’s see what will happen in the future :)


[1]: http://en.wikipedia.org/wiki/Shellshock_(software_bug)
[2]: http://www.gnu.org/software/bash/
[3]: http://www.ubuntu.com/