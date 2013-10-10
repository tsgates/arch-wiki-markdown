Jekyll
======

> Summary

Jekyll is a simple static site generator written in Ruby and developed
by GitHub co-founder Tom Preston-Werner. This page provides a verbose
tutorial to install and configure Jekyll for both inexperienced and
advanced users.

Required software

RedCloth

Liquid

Classifier

Maruku

Pygments

Directory Watcher

Jekyll is "a simple, blog aware, static site generator. It takes a
template directory (representing the raw form of a website), runs it
through Textile or Markdown and Liquid converters, and spits out a
complete, static website suitable for serving with Apache or your
favorite web server. This is also the engine behind GitHub Pages, which
you can use to host your project’s page or blog right here from GitHub."
[1]

Werner announced the release of Jekyll on his website on November 17,
2008.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 RubyGems (Recommended)                                       |
|     -   1.2 Arch User Repository (Alternate)                             |
|                                                                          |
| -   2 Select a Markup Language                                           |
|     -   2.1 Textile                                                      |
|     -   2.2 Markdown                                                     |
|                                                                          |
| -   3 Configuration                                                      |
| -   4 Usage                                                              |
|     -   4.1 Create Index Layout                                          |
|     -   4.2 Create General Website Layout                                |
|     -   4.3 Create Post Layout                                           |
|     -   4.4 Creating a Post                                              |
|                                                                          |
| -   5 Test                                                               |
| -   6 See also                                                           |
| -   7 References                                                         |
| -   8 Examples                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Jekyll can be installed in Arch Linux with the RubyGems package manager
or using the applicable packages in the Arch User Repository. Both
methods require the Ruby package in [extra] to be installed.

> RubyGems (Recommended)

Note:RubyGems 1.8 and above are displaying numerous uncritical warnings.

The best way to install Jekyll is with RubyGems, a package manager for
the Ruby programming language. RubyGems is installed alongside the Ruby
package, which is located in the extra repository.

    # pacman -S ruby ruby-docs

Jekyll can then be installed for all users on the machine using the gem
command as root. Alternative installation methods are available on the
Ruby page.

Before installing Jekyll make sure to update RubyGems.

    # gem update --system

Then install Jekyll using the gem command.

    # gem install jekyll

> Arch User Repository (Alternate)

Alternately, ruby-jekyll can be installed from the Arch User Repository.

Select a Markup Language
------------------------

There are numerous different markup languages that are used to define
text-to-HTML conversion tools. Jekyll has two defaults; Textile and
Markdown. Implementations of both are required as dependencies of
Jekyll.

> Textile

Textile is a markup language used by Jekyll.

Note:RedCloth, a module for using the Textile markup language in Ruby,
fails to install with gcc 4.6.0 (see: RedCloth Ticket 215 and 219). It
is recommended that you install the current stable version 4.2.2 by
gem install RedCloth --version 4.2.2.

> Markdown

Markdown is a markup language and text-to-HTML conversion tool developed
in Perl by John Gruber. A Perl and a Python implementation of Markdown
can be found in [community], while numerous other implementations are
available in the AUR. The default implementation of Markdown in Jekyll
is Maruku.

Additionally, it has been implemented in C as Discount by David Parsons
and a Ruby extension was written by Ryan Tomayko as RDiscount. You can
install RDiscount with Rubygems as root or through the AUR.

    # gem install rdiscount -s http://gemcutter.org

Then add the following line to your _config.yml.

    markdown: rdiscount

If you are unfamiliar with Markdown, Gruber's website presents an
excellent introduction. Additionally, you can try out Markdown using
Gruber's online conversion tool.

Configuration
-------------

A default Jekyll directory tree looks like the following, where "."
denotes the root directory of your Jeykll generated website.

    .
    |-- _config.yml
    |-- _layouts
    |   |-- default.html
    |   `-- post.html
    |-- _posts
    |   |-- 2010-02-13-early-userspace-in-arch-linux.textile
    |   `-- 2011-05-29-arch-linux-usb-install-and-rescue-media.textile
    |-- _site
    `-- index.html

A default file structure is available from Daniel McGraw's Jekyll-Base
page on GitHub.

Note:McGraw has also setup a more extensive default file structure on
GitHub.

The _config.yml file stores configuration data. It includes numerous
configuration settings, which may also be called as flags. Full
explanation and a default configuration can be found on GitHub.

Once you have configured your _config.yml to your liking you need to
create the files that will be processed by Jekyll to generate the
website.

Usage
-----

Next you need to create templates that Jekyll can process. These
templates make use of the Liquid templating system to input data. For a
full explanation check GitHub.

Additionally, each file besides /_layouts/layout.html requires a YAML
Front Matter heading.

> Create Index Layout

This is a basic template for your index.html, which is used to render
your website's index page.

    ---
    layout: layout
    title: Jekyll Base
    ---

    <div class="content">
      <div class="related">
        <ul>
          {% for post in site.posts %}
          <li>
    	<span>{{ post.date | date: "%B %e, %Y" }}</span> <a href="{{ post.url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
        </ul>
      </div>
    </div>

> Create General Website Layout

This is a basic template for your website's general layout. It will be
referenced in the YAML Front Matter blocks of each file (see: Creating a
Post).

    _layouts/layout.html

    <!DOCTYPE HTML>

    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="author" content="Your Name" />
        <title>{{ page.title }}</title>
      </head>
      <body>
        <header>
          <h1><a href="/">Jekyll Base</a></h1>
        </header>
        <section>
          {{ content }}
        </section>
      </body>
    </html>

> Create Post Layout

This is a basic template for each of your posts. Again, this will be
referenced in the YAML Front Matter blocks of each file (see: Creating a
Post).

    _layouts/post.html

    ---
    layout: layout
    title: sample title
    ---

    <div class="content">
      <div id="post">
        <h1>{{ post.title }}</h1>
        {{ content }}
      </div>
    </div>

> Creating a Post

The content of each blog post will be contained within a file inside of
the _posts directorys. To use the default naming convention each file
should be saved with the year, month, date, post title and end with the
*.md or *.textile depending on the markup language used (e.g.
2010-02-13-early-userspace-in-arch-linux.textile). The date defined in
the filename will be used as the published date in the post.
Additionally, the filename will be used to generate the permalink (i.e.
/categories/year/month/day/title.html). To use an alternate permalink
style or create your own review the explanation on GitHub.

Test
----

To generate a static HTML website based on your Textile or Markdown
documents run jekyll. To simultaneously test the generated HTML website
run Jekyll with the --server flag.

    $ jekyll --server

It is recommended to define server options in your _config.yml. The
default will start a server on port 4000, which can be accessed in your
web browser at localhost:4000.

See also
--------

-   YAML
-   Textile

References
----------

-   Installation Tutorial by Daniel McGraw
-   Configuration Tutorial by Daniel McGraw
-   Jekyll vs. Hyde by Philip Mateescu

Examples
--------

Websites created with Jekyll can be found on GitHub.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Jekyll&oldid=239083"

Category:

-   Web Server
