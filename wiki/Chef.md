Chef
====

Contents
--------

-   1 Installation
    -   1.1 Omnibus Chef
        -   1.1.1 By Package
        -   1.1.2 From Source
        -   1.1.3 Uninstallation
    -   1.2 RubyGem
    -   1.3 Package

Installation
------------

> Omnibus Chef

By Package

Install the omnibus-chef package from AUR. If not using an AUR helper,
first install the needed dependency, ruby-bundler.

This package builds and installs an omnibus Makeself installer for Chef.
If you choose not to run the installer upon installation of the package,
you can run it any time:

    # /usr/local/bin/chef-installer

From Source

     $ git clone https://github.com/opscode/omnibus-chef.git
     $ cd omnibus-chef

Wipe out any previous installations and the omnibus cache:

    # rm -Rf /opt/chef/* /var/cache/omnibus/*

Set up the directories and change the ownership to yourself so building
as root is not required:

    # mkdir -p /opt/chef /var/cache/omnibus
    # chown -R "$USER:users" /opt/chef
    # chown -R "$USER:users" /var/cache/omnibus

You can set CHEF_GIT_REV to the desired chef version to install. Run the
following to build:

    $ bundle update omnibus-software
    $ bundle exec omnibus clean chef
    $ CHEF_GIT_REV=11.8.2 bundle exec omnibus build project chef

After you may like to change ownerhsip back of the system locations
used:

    # chown -R root:root /opt/chef
    # chown -R root:root /var/cache/omnibus

A Makeself portable installer will be created, e.g.
chef-11.8.2_0.arch.3.12.6-1-ARCH.sh. Run this executable to install
chef.

Uninstallation

Remove all installation files manually:

    # rm -Rf /opt/chef

You can also ensure the omnibus cache is removed:

    # rm -Rf /var/cache/omnibus

> RubyGem

This is one of easiest ways to install Chef, however if you already have
gem versions of the dependencies installed you could run into conflicts.

Ensure you first install the ruby package from the official
repositories. This also provides RubyGems.

Next, install the Chef RubyGem:

     # gem install chef

> Package

A number of RubyGem dependencies of Chef are older than the latest
versions available.

First, build and install the known old versions from the dependency
tree:

-   ruby-mime-types[1] (1.25)
-   ruby-net-ssh-multi[2] (1.1)
-   puma[3] (1.6.0)

Also for their dependencies:

-   ruby-moneta[4] (0.6.0) needed by chef-zero
-   ruby-systemu[5] (2.5.2) needed by ohai

Add each of the packages to IgnorePkg in /etc/pacman.conf, e.g.:

     IgnorePkg    = ruby-mime-types net-ssh-multi puma ruby-moneta ruby-systemu

Lastly, install the chef package from AUR.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Chef&oldid=293667"

Category:

-   Web Server

-   This page was last modified on 20 January 2014, at 06:33.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
