JHBuild
=======

JHBuild is a tool that allows you to automatically download and compile
"modules" (i.e. source code packages). It can pull modules from a
variety of sources (CVS, Subversion, Git, Bazaar, tarballs...) and
handle dependencies. You can also choose which specific modules you want
to build, instead of building the whole project.

JHBuild was originally written for building GNOME, but has since been
extended to be usable with other projects.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Usage
    -   3.1 Installing prerequisites
    -   3.2 Building
-   4 Troubleshooting
    -   4.1 Python issues
        -   4.1.1 Building from scratch without JHBuild, or in a JHBuild
            shell
    -   4.2 pkg-config issues
    -   4.3 itstool does not build
    -   4.4 totem does not build
    -   4.5 evolution does not build
    -   4.6 gnome-devel-docs does not build
    -   4.7 devhelp does not build
    -   4.8 libosinfo does not build
    -   4.9 ibus-pinyin does not build
    -   4.10 Other broken modules
-   5 Packages needed to build specific modules
-   6 See also

Installation
------------

Install one JHBuild variant from the AUR:

-   jhbuild - Stable version.
-   jhbuild-git - Development version.

Configuration
-------------

The configuration file for JHBuild is ~/.config/jhbuildrc. It uses
Python syntax to set configuration variables. Here is the sample file
provided for building GNOME:

    # -*- mode: python -*-
    # -*- coding: utf-8 -*-

    # edit this file to match your settings and copy it to ~/.config/jhbuildrc

    # if you have a GNOME git account, uncomment this line
    # repos['git.gnome.org'] = 'ssh://user@git.gnome.org/git/'

    # what module set should be used. The default can be found in
    # jhbuild/defaults.jhbuildrc, but can be any file in the modulesets directory
    # or a URL of a module set file on a web server.
    # moduleset = 'gnome-apps-3.12'
    #
    # A list of the modules to build. Defaults to the GNOME core and tested apps.
    # modules = [ 'meta-gnome-core', 'meta-gnome-apps-tested' ]

    # Or to build the old GNOME 2.32:
    # moduleset = 'gnome2/gnome-2.32'
    # modules = ['meta-gnome-desktop']

    # what directory should the source be checked out to?
    checkoutroot = os.path.expanduser('~/checkout/gnome')

    # the prefix to configure/install modules to (must have write access)
    prefix = '/opt/gnome'

    # custom CFLAGS / environment pieces for the build
    # os.environ['CFLAGS'] = '-Wall -g -O0'

    # extra arguments to pass to all autogen.sh scripts
    # to speed up builds of GNOME, try '--disable-static --disable-gtk-doc'
    #autogenargs=''

    # On multiprocessor systems setting makeargs to '-j2' may improve compilation
    # time. Be aware that not all modules compile correctly with '-j2'.
    # Set makeargs to 'V=1' for verbose build output.
    #makeargs = '-j2'

You should edit at least modules to the desired modules to be built. A
reference for most configuration variables is available at GNOME JHBuild
Manual.

Usage
-----

> Installing prerequisites

JHBuild can check if the required tools are installed by running
sanitycheck:

    $ jhbuild sanitycheck

If any errors are shown, missing packages may be installed from
repositories or running the bootstrap command, which tries to download,
build and install the build prerequisites:

    $ jhbuild bootstrap

> Building

To build all the modules selected in the configuration file, just run
the build command:

    $ jhbuild build

JHBuild will download, configure, compile and install each of the
modules.

If an error occurs at any stage, JHBuild will present a menu asking what
to do. The choices include dropping to a shell to fix the error,
rerunning the build from various stages, giving up on the module, or
ignore the error and continue. Often, dropping to a shell and checking
makefiles and configuration files can be helpful. If you face a build
error, for example, you can try to manually make and check errors on the
shell.

Giving up on a module will cause any modules depending on it to fail.

To build as many packages as possible, skipping broken packages, run:

    $ yes 3 | jhbuild --try-checkout build

Troubleshooting
---------------

Note:If you encounter an issue that isn't documented below, please
report it in a comment on the jhbuild package.

> Python issues

Building from scratch without JHBuild, or in a JHBuild shell

If you are building from scratch on your own, it may be necessary to run
autogen.sh with the following:

    $ PYTHON=/usr/bin/python2 ./autogen.sh

And set the PYTHON environment variable in ~/.config/jhbuildrc

    os.environ['PYTHON'] = '/usr/bin/python2'

  

Note:JHBuild uses it's own python lib directory in
/opt/gnome/lib/python2.7, ff you are having problems with python imports
check to see that the .py files are there.

> pkg-config issues

If you have a malformatted .pc file on your PKG_CONFIG_PATH, JHBuild
won't be able to detect all the (valid) .pc files you have installed and
will complain that the .pc files are missing. Look at the output of
jhbuild sysdeps—there should be a message about the problematic .pc
files.

> itstool does not build

Chose [4] Start shell and run:

    $ sed -ir 's/| python /| python2 /' configure

Then, exit the shell and choose [1] Rerun phase configure. See this
merge request for more details.

> totem does not build

Choose [4] Start shell and run:

    $ curl https://git.gnome.org/browse/totem/patch/?id=198d7f251e7816f837378fb2081829188847b916 | git apply

Then, exit the shell and choose [1] Rerun phase build.

> evolution does not build

Choose [4] Start shell and run:

    $ curl https://bug707112.bugzilla-attachments.gnome.org/attachment.cgi?id=253584 | git apply

Then, exit the shell and choose [1] Rerun phase build. See this bug for
further details.

> gnome-devel-docs does not build

Choose [4] Start shell and run:

    $ git revert --no-edit 9ba0d959

Then, exit the shell and choose [1] Rerun phase build. See this bug for
further details.

> devhelp does not build

Choose [4] Start shell and run:

    $ curl https://bug707490.bugzilla-attachments.gnome.org/attachment.cgi?id=254113 | git apply

Then, exit the shell and choose [1] Rerun phase build. See this bug for
further details.

> libosinfo does not build

Choose [4] Start shell and run:

    $ curl https://fedorahosted.org/libosinfo/raw-attachment/ticket/9/0001-Don-t-use-AM_GNU_GETTEXT.patch | git apply

Then, exit the shell and choose [1] Rerun phase build. See this bug for
further details.

> ibus-pinyin does not build

Choose [4] Start shell and run:

    $ curl https://github.com/ibus/ibus-pinyin/commit/3d0680c2b9533d0abff30258d0e772b8aa97af1c.patch | git apply

Then, exit the shell and choose [8] Go to phase "clean". See this bug
for further details.

> Other broken modules

The following modules don't build, and there are no known/immediate
fixes (feel free to jump in and investigate; I've only made cursory
attempts to fix these issues):

-   aisleriot—bug report (probably easy to fix if you poke around)
-   gegl
-   gnome-boxes—bug report (a fix is provided there)
-   gnome-photos
-   gtksourceviewmm
-   meta-gnome-apps-tested
-   nemiver
-   orca
-   rygel
-   valadoc

This list includes modules transitively depending on broken modules
(i.e. some of the modules might be fine; I didn't check).

Packages needed to build specific modules
-----------------------------------------

-   gitg requires gtkspell3
-   gtk-vnc requires perl-text-csv
-   totem-pl-parser requires libgcrypt15
-   xf86-video-intel requires xorg-server-devel
-   xwayland requires xtrans, xcmiscproto, and bigreqsproto
-   zeitgeist requires python2-rdflib

See also
--------

GNOME JHBuild Manual

Retrieved from
"https://wiki.archlinux.org/index.php?title=JHBuild&oldid=305194"

Category:

-   Development

-   This page was last modified on 16 March 2014, at 19:16.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
