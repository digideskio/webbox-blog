# webBox Blog Source

Based on [Jekyll](http://jekyllrb.com) and [Hyde](http://hyde.poole.com)

## Install

```bash
bundle install
rake # or jekyll serve
```

Write post:

```bash
rake post['Hello World']
```

### Tasks

```bash
rake post["Title"]
    rake draft["Title"]
    rake publish
rake page["Title"]
    rake page["Title","Path/to/folder"]
rake build
rake watch
    rake watch[number]
    rake watch["drafts"]
rake preview
rake deploy["Commit message"]
rake transfer
```

`rake post["Title"]` creates a new post in the `_posts` directory by reading the default template file, adding the title you've specified and generating a filename by using the current date and the title.

`rake draft["Title"]` creates a new post in the `_drafts` directory by reading the default template file, adding the title you've specified and generating a filename.

`rake publish` moves a post from the `_drafts` directory to the `_posts` directory and appends the current date to it. It'll list all drafts and then you'll get to choose which draft to move by providing a number.

`rake page["Title","path/to/folder"]` creates a new page. If the file path is not specified the page will get placed in the site's source directory.

`rake build` just generates the site.

`rake watch` generates the site and watches it for changes. If you want to generate it with a post limit, use `rake watch[1]` or whatever number of posts you want to see. If you want to generate your site with your drafts, use `rake watch["drafts"]`.

`rake preview` launches your default browser and then builds, serves and watches the site.

`rake deploy["Commit message"]` adds, commits and pushes your site to the site's remote git repository with the commit message you've specified. It also uses the `rake build` task to generate the site before it goes through the whole git process.

`rake transfer` uses either `robocopy` or `rsync` to transfer your site to a remote host/server or a local git repository. It also uses the `rake build` task to generate the site before it goes through the whole transfering process.


## License

Hyde's license is MIT.

