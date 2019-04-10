## MsgTrail

**MsgTrail is a blog publication tool.**

It is used to manage and publish [this blog](https://www.msgtrail.com/).

### Features

- Content sources:
  - Local Markdown files
  - GitHub [Gists](https://gist.github.com/)
  - Tweets including support for [tweetstorm](https://en.wiktionary.org/wiki/tweetstorm) stitching
- User interface: command line
- End result: self-contained HTML
- Hosting: no (bring your own)
- Search: no (rudimentary support for Google's `site:` feature)
- Archive page: yes
- Feed: yes (Atom)

### Simplicity

MsgTrail enables you to write, proofread, and publish your blog entirely from the command line.

Here is how creating and publishing a new blog article works:

1. Save your Markdown article to a directory called `articles`.
2. Add a reference to the article to `blog.json`.
3. Invoke `msgtrail {path-to-your-blog-directory}` from the command line.
4. Upload/sync the output of the `msgtrail` command to e.g. AWS S3 or your static hosting provider of choice.

Instead of using a Markdown article you can also add a reference to a GitHub Gist to `blog.json` or a reference to one or more tweets.

The output of the `msgtrail` command is based on a set of simple HTML templates which use Ruby's `ERB` templating system.

The standard theme contains a blog index page, archive, and Atom feed.

### Ingredients

You need three ingredients to publish a blog:

1. You must install the `msgtrail` command line tool.
2. You need a local copy of the blog theme.
3. You need a place to host the output (static HTML files).

This README covers only steps 1 and 2.

### Installing MsgTrail

Invoke `gem install msgtrail` to install the MsgTrail Ruby gem. You need at least Ruby v2.x.

Type `msgtrail` without arguments to display its version and usage hint:

```
>msgtrail
exe/msgtrail version 0.2.0
Usage: exe/msgtrail {theme-directory-name}
```

### Downloading theme

After installing the gem it is time to download and check out the theme.

Unlike many other blog engines the configuration of the MsgTrail theme is dead simple.

The theme directory structure consists of the following files and directories:

- The `articles` directory contains your blog article in Markdown format.
- The `blog` directory contains the output of the `msgtrail` command. This directory is empty when you download the theme zipfile. You'll use the `msgtrail` command to generate output for this directory.
- The `theme` directory contains the actual HTML templates and layouts for your blog.
- `blog.json` contains a reference to each blog article.
- `config.json` contains blog settings.
- `site.json` describes the various pages in your blog such as "index", "archive", et cetera.

### blog.json

The default theme contains an example blog with three articles:

```
[
  {
    "title": "First post",
    "date": "2019-01-02",
    "time": "23:55",
    "file": "articles/hello-blog.md"
  },
  {
    "title": "Markdown example",
    "date": "2019-04-07",
    "time": "21:34",
    "gist_id": "fd8d3b448ea4c2edec93c34baca44ad4"
  },
  {
    "title": "Writing a programmer-oriented blog engine",
    "date": "2019-04-06",
    "time": "13:16",
    "tweet_ids": [
      1114623023397646337
    ],
    "archived": true
  }
]
```

You can add a fourth article by adding the following lines to the top of `blog.json`:

```
{
  "title": "This is my latest post",
  "date": "2019-03-28",
  "time": "22:04",
  "file": "articles/this-is-my-latest-post.md"
}
```

Alternative you can replace the `file` directive for a reference to a gist:

```
"gist_id": "fd8d3b448ea4c2edec93c34baca44ad4"
```

Or you can use one or more references to tweet IDs:

```
"tweet_ids": [
  1114623023397646337
]
```

### config.json

The `msgtrail` command reads its configuration settings from `config.json`:

```
{
  "domain_matter": {
    "site_url": "https://www.msgtrail.com/",
    "feed_url": "https://www.msgtrail.com/feed/index.xml",
    "permalink_url": "https://www.msgtrail.com/articles/%s",
    "search_url": "https://www.google.com?q=site%3Awww.msgtrail.com%20%7Bsearch%20phrase%7D",
    "about_url": "https://www.bitgain.com/"
  },
  "file_matter": {
    "blog_manifest_file": "blog.json",
    "site_manifest_file": "site.json",
    "article_directory": "articles",
    "blog_directory": "blog",
    "theme_directory": "theme"
  },
  "head_matter": {
    "blog_title": "MsgTrail",
    "blog_sub_title": "A blog by Erik van Eykelen",
    "language": "en-us"
  },
  "time_matter": {
    "utc_offset": "+02:00"
  }
}
```

All configuration settings are available through a global variable called `cfg` in the ERB templates. For instance the `site_url` setting can be accessed using `<%= cfg.domain_matter.site_url %>`.

### site.json

The `msgtrail` command uses `site.json` to generate HTML files by combining layouts, templates, Markdown articles, gists, and tweets and writing the result to an output directory.

As you can see from `site.json` it is easy to map input (layout/template) to output (HTML):

```
[
  {
    "layout": "layout.html.erb",
    "template": "index.html.erb",
    "output_file": "index.html",
    "iterator_subject": false
  },
  {
    "layout": "layout.html.erb",
    "template": "archive.html.erb",
    "output_path": "archive",
    "output_file": "index.html",
    "iterator_subject": false
  },
  {
    "layout": "layout.html.erb",
    "template": "article.html.erb",
    "output_path": "articles/%s",
    "output_file": "index.html",
    "iterator_subject": true
  },
  {
    "layout": "layout.xml.erb",
    "template": "feed.xml.erb",
    "output_path": "feed",
    "output_file": "index.xml",
    "iterator_subject": false
  }
]
```

### Theme

MsgTrail ships with a basic theme. Feel free to adapt it to your own needs.

The theme consists of just 7 ERB files:

- `_article.html.erb`
- `archive.html.erb`
- `article.html.erb`
- `feed.xml.erb`
- `index.html.erb`
- `layout.html.erb`
- `layout.xml.erb`

Noteworthy:

`_article.html.erb` is a "partial" (aka "include") which is called by `article.html.erb` and `index.html.erb` in order to DRY-up the code.

The `_` underscore in front of the file name is a nod to Rails' partial naming convention.

Inside `article.html.erb` and `index.html.erb` you'll see that it is easy to embed a partial:

`<%= render_partial('article', { article: article }) %>`

The `article` variable gets passed to the article partial and made available through a global `variables` hash. Inside `_article.html.erb` you'll see for instance:

`<%= variables[:article][:date] %>`

This line fetches the `:date` value from the `:article` hash. You may add additional variables to the `{ article: article }` hash e.g. `{ article: article, foo: 'bar' }`.

The fact that the word `article` is used three times in `render_partial('article', { article: article })` is not a requirement. The following is also correct: `render_partial('alpha', { bravo: charlie })`, provided you rename the partial to `alpha` and rename the variables accordingly.

The two layout files (`layout.html.erb` and `layout.xml.erb`) each contain `<%= yield %>`. The `yield` method is used by MsgTrail to "wrap" the contents of the layout file "around" e.g. `index.html.erb` or one of the other templates.

Unlike with Ruby on Rails the `.html.erb` and `.xml.erb` file extensions used by the layouts and templates have no special meaning for MsgTrail. Instead, the file extensions in the final publication are defined by `site.json`.

As mentioned before, you'll also come across a variable called `cfg`. See above for an explanation.

### Step-by-step instructions

- Install the MsgTrail gem (see above).
- [Download](https://github.com/evaneykelen/msgtrail/blob/master/sample-blog.zip) the sample-blog archive.
- Unzip the archive to a directory called `sample-blog`.
- Enter `msgtrail sample-blog/`. The output will be something like:

```
Deleted '/Users/.../sample-blog/blog'
Created '/Users/.../sample-blog/blog'
Created '/Users/.../sample-blog/blog/index.html'
Created '/Users/.../sample-blog/blog/archive/index.html'
Created '/Users/.../sample-blog/blog/articles/20190102-2355-first-post/index.html'
Created '/Users/.../sample-blog/blog/articles/20190407-2134-markdown-example/index.html'
Created '/Users/.../sample-blog/blog/articles/20190406-1316-writing-a-programmer-oriented-blog-engine/index.html'
Created '/Users/.../sample-blog/blog/feed/index.xml'
```

-  If you open the `blog/index.html` file in your web browser you should see the blog home page.

### Feedback, comments, bugs, or praise?

- Create a GitHub issue if you run into issues or bugs.
- Ping me on Twitter: [@hackteck](https://twitter.com/hackteck/)
