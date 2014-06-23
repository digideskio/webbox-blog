Sometimes you want to show a prototype **Web Application** that is working on your
computer to other people. The problem is that **Deployment** is **not** always 
that easy.

You ask people to check your app on your local development environment. It’s 
time consuming and maybe sometimes kinda embarassing.

Enter Ngrok. A tool that allows you to share your localhost to anyone on the 
internet.

**Ngrok** is a tiny tool which was written in Go programming language. This means
it can be executable in any platfrom ( Linux, Mac OS X, Windows ) without any
dependency.

To use **Ngrok** you can [download][1] the zip file or if you are using Mac you can
install via Brew.

```bash
brew install ngrok
```

After installing Ngrok you can share your localhost to anyone.

E.g you have a Rails or Node.js working on `localhost:3000`. All you have to do is

```bash
ngrok 3000
```

If it succeeds you’ll see something like below.

![Ngrok](/assets/post_images/ngrok.png)

Voila your app is on the internet and anyone can access it by using the HTTP 
and HTTPS links that **Ngrok** generates :)

[1]: http://ngrok.com/download
