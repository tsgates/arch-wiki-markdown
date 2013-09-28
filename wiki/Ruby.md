Ruby
====

Ruby is a dynamic, interpreted, open source programming language with a
focus on simplicity and productivity.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing Ruby                                                    |
|     -   1.1 Ruby 2.0                                                     |
|     -   1.2 Ruby 1.9                                                     |
|     -   1.3 Ruby 1.8                                                     |
|     -   1.4 Multiple Versions                                            |
|                                                                          |
| -   2 RubyGems                                                           |
|     -   2.1 Usage                                                        |
|     -   2.2 Running as normal user                                       |
|     -   2.3 Running as root                                              |
|     -   2.4 Bundler                                                      |
|     -   2.5 Managing RubyGems using pacman                               |
|                                                                          |
| -   3 See also                                                           |
| -   4 References                                                         |
+--------------------------------------------------------------------------+

Installing Ruby
---------------

The version of Ruby you need to install depends on your requirements. If
you are supporting a legacy application, install Ruby 1.9 or 1.8 as
necessary. If you are starting a new project, Ruby 2.0 is recommended.
Below is a summary of the available versions and how to get them.

> Ruby 2.0

To install Ruby 2.0.0, install ruby. Ruby 2.0 includes #RubyGems.

> Ruby 1.9

To install Ruby 1.9.3, install ruby1.9. Ruby 1.9 includes RubyGems.

Pros:

-   Vastly improved performance over 1.8
-   New features for concurrency such as fibers.
-   Various other language improvements, such as an improved CSV parser.

Cons:

-   Not compatible with many older gems (and Ruby On Rails versions
    prior to 2.3)
-   Changes in the language might cause older Ruby code not to run, or
    exhibit unexpected bugs.

Note:Visit http://isitruby19.com/ to determine if the gems/modules you
require are compatible with Ruby 1.9.

> Ruby 1.8

To install Ruby 1.8.7, install ruby1.8 or ruby-1.8.7-svn from the AUR.
Ruby 1.8 does not include RubyGems. Instead, it is available through the
rubygems1.8 package.

> Multiple Versions

If you want to run multiple versions on the same system (e.g. 2.0.0-p0
and 1.9.3-p392), the easiest way is to use RVM or rbenv.

RubyGems
--------

gem is a package manager for Ruby modules (called Gems), somewhat
comparable to what pacman is to Arch Linux. The gem command will be
installed if you followed the installation instructions above.

> Usage

To see what gems are installed:

    $ gem list

To get information about a gem:

    $ gem spec <gem_name>

By default, gem list and gem spec use the --local option, which forces
gem to search only the local system. This can be overridden with the
--remote flag. Thus, to search for the mysql gem:

    $ gem list --remote mysql

To install a gem:

    $ gem install mysql

The process can be sped up somewhat if you do not need local
documentation:

    $ gem install mysql --no-rdoc --no-ri

To update all installed gems:

    $ gem update

> Running as normal user

When running gem as a normal user, gems are installed into ~/.gem
instead of system-wide. This is considered the best way to manage gems
on Arch. Unfortunately, not all gems are happy with being installed in
this way, and might insist on being installed by root, especially if
they have native extensions (compiled C code). This per-user behavior is
enabled via /etc/gemrc and can be overridden by a ~/.gemrc file.

To use gems which install binaries, you need to add
~/.gem/ruby/2.0.0/bin to your $PATH.

> Running as root

When running as root, the gems will be installed into /root/.gems and
will not be installed to /usr/lib/ruby/gems/.

Note:See bug #33327 for more information.

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

    export GEM_HOME=~/.gem/ruby/2.0.0

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

    bundle exec <main_executable_name.rb>

> Managing RubyGems using pacman

Instead of managing gems with gem, you can use pacman, or some AUR
helper. Ruby packages follow the naming convention ruby-[gemname]. This
option provides the following advantages:

-   Gems are updated along with the rest of your system. As a result,
    you never need to run gem update: pacman -Syu suffices.
-   Installed gems are available system-wide, instead of being available
    only to the user who installed them.

If a gem is not available in the repositories, you can use pacgem to
automatically create a package, which can then be installed by pacman.

See also
--------

-   Ruby On Rails

References
----------

-   Ruby - http://ruby-lang.org/
-   Rubyforge - http://rubyforge.org
-   Bundler - http://github.com/carlhuda/bundler

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ruby&oldid=255941"

Category:

-   Programming language
