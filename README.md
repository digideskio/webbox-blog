# webBox Blog Source

Based on [Jekyll](http://jekyllrb.com) and [Hyde](http://hyde.getpoole.com)

## Install

```bash
bundle install # or
bundle install --path vendor/bundle
rake # or jekyll serve
```

Write post:

```bash
rake post['Hello World']
```

It will create new post on `_posts` directory.

```bash
rake post["Hello World", "June 29 2014"]
```

Will create new post and will set the date too!


### Tasks

You can always check the tasks via `rake -T`

```bash
rake post["Title"]
rake post["Title", "Date"]

rake draft["Title"]
rake draft["Title", "Date"]

rake build

rake watch
rake watch[number]
rake watch["drafts"]

rake deploy
```

## License

Hyde's license is MIT.

