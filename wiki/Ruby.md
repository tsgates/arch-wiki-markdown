Ruby
====

Ruby is a dynamic, interpreted, open source programming language with a
focus on simplicity and productivity.

Contents
--------

-   1 Installing Ruby
    -   1.1 Ruby 2.1
    -   1.2 Ruby 2.0
    -   1.3 Ruby 1.9
    -   1.4 Multiple versions
    -   1.5 Documentation
-   2 RubyGems
    -   2.1 Setup
    -   2.2 Usage
    -   2.3 Installing gems per-user or system-wide
    -   2.4 Bundler
    -   2.5 Managing RubyGems using pacman
-   3 See also

Installing Ruby
---------------

The version of Ruby you need to install depends on your requirements. If
you are supporting a legacy application, install Ruby 2.0 or 1.9 as
necessary. If you are starting a new project, Ruby 2.1 is recommended.
Below is a summary of the available versions and how to get them.

> Ruby 2.1

To install Ruby 2.1, install ruby. Ruby 2.1 includes RubyGems.

> Ruby 2.0

To install Ruby 2.0, install ruby2.0 from the AUR. Ruby 2.0 includes
RubyGems.

> Ruby 1.9

To install Ruby 1.9, install ruby1.9 from the AUR. Ruby 1.9 includes
RubyGems.

> Multiple versions

If you want to run multiple versions on the same system (e.g. 2.0.0-p0
and 1.9.3-p392), the easiest way is to use RVM, chruby or rbenv.

> Documentation

To make documentation available through the included ri command-line
tool, install ruby-docs. You can then query the docs with: ri Array,
ri Array.pop etc. (much like man-pages)

RubyGems
--------

RubyGems is a package manager for Ruby modules (called gems), somewhat
comparable to what pacman is to Arch Linux. It is included in the ruby
package.

> Setup

Before you use RubyGems, you need to add
`ruby -rubygems -e "puts Gem.user_dir"`/bin to your $PATH. You can do
this by adding the following line to ~/.bashrc:

    PATH="`ruby -e 'puts Gem.user_dir'`/bin:$PATH"

> Usage

To see what gems are installed:

    $ gem list

To get information about a gem:

    $ gem spec gem_name

By default, gem list and gem spec use the --local option, which forces
gem to search only the local system. This can be overridden with the
--remote flag. Thus, to search for the mysql gem:

    $ gem list --remote mysql

To install a gem:

    $ gem install mysql

The process can be sped up somewhat if you do not need local
documentation:

    $ gem install mysql --no-document

Note:This can be made the default option by configuring the following
~/.gemrc file:

    ~/.gemrc

    gem: --no-document

To update all installed gems:

    $ gem update

> Installing gems per-user or system-wide

By default in Arch Linux, when running gem, gems are installed per-user
(into ~/.gem/ruby/), instead of system-wide (into /usr/lib/ruby/gems/).
This is considered the best way to manage gems on Arch, because
otherwise they might interfere with gems installed by Pacman.

Gems can be installed system wide by running the gem command as root,
appended with the --no-user-install flag. This flag can be set as
default by replacing --user-install by --no-user-install in /etc/gemrc
(system-wide) or ~/.gemrc (per-user, overrides system-wide).

Bundler solves these problems to some extent by packaging gems into your
application. See the section below on using bundler.

> Bundler

Bundler allows you to specify which gems your application depends upon,
and optionally which version those gems should be. Once this
specification is in place, Bundler installs all required gems (including
the full gem dependency tree) and logs the results for later inspection.
By default, Bundler installs gems into a shared location, but they can
also be installed directly into your application. When your application
is run, Bundler provides the correct version of each gem, even if
multiple versions of each gem have been installed. This requires a
little bit of work: applications should be called with bundle exec, and
two lines of boilerplate code must be placed in your application's main
executable.

To install Bundler:

    $ gem install bundler

By default, Bundler installs gems system-wide, which is contrary to the
behaviour of gem itself on Arch. To correct this, add the following to
your ~/.bashrc:

    export GEM_HOME=$(ruby -e 'puts Gem.user_dir')

To start a new bundle:

    $ bundle init

Then edit Gemfile in the current directory (created by bundle init) and
list your required gems:

    Gemfile

    gem "rails", "3.2.9"
    gem "mysql"

Run the following to install gems into GEM_HOME:

    $ bundle install

Alternatively, run the following to install gems to .bundle in the
working directory:

    $ bundle install --path .bundle

Don't forget to edit your main executable:

    #!/usr/bin/env ruby

    # "This will automatically discover your Gemfile, and make all of the gems in
    # your Gemfile available to Ruby." http://gembundler.com/v1.3/rationale.html
    require 'rubygems'
    require 'bundler/setup'

    ...

Finally, run your program:

    bundle exec main_executable_name.rb

> Managing RubyGems using pacman

Instead of managing gems with gem, you can use pacman, or some AUR
helper. Ruby packages follow the naming convention ruby-[gemname]. This
option provides the following advantages:

-   Gems are updated along with the rest of your system. As a result,
    you never need to run gem update: # pacman -Syu suffices.
-   Installed gems are available system-wide, instead of being available
    only to the user who installed them.

If a gem is not available in the repositories, you can use gem2arch or
pacgem to automatically create a package, which can then be installed by
pacman.

See also
--------

-   Ruby on Rails
-   Ruby - http://ruby-lang.org/
-   Rubyforge - http://rubyforge.org
-   Bundler - http://github.com/carlhuda/bundler

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ruby&oldid=305852"

Category:

-   Programming language

-   This page was last modified on 20 March 2014, at 13:07.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
