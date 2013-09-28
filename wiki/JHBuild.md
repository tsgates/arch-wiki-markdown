JHBuild
=======

JHBuild is a tool that allows you to automatically download and compile
"modules" (i.e. source code packages). It can pull modules from a
variety of sources (CVS, Subversion, Git, Bazaar, tarballs...) and
handle dependencies. You can also choose which specific modules you want
to build, instead of building the whole project.

JHBuild was originally written for building GNOME, but has since been
extended to be usable with other projects.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Usage                                                              |
|     -   3.1 Installing Prerequisites                                     |
|     -   3.2 Building                                                     |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 Python issues                                                |
|     -   4.2 pkg-config issues                                            |
|                                                                          |
| -   5 External links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

JHBuild is available in the Arch User Repository. Install either jhbuild
or jhbuild-git, the development version.

Configuration
-------------

The configuration file for JHBuild is ~/.jhbuildrc. It uses Python
syntax to set configuration variables. Here is the sample file provided
for building GNOME:

    # -*- mode: python -*-
    # -*- coding: utf-8 -*-

    # edit this file to match your settings and copy it to ~/.jhbuildrc

    # if you have a GNOME git account, uncomment this line
    # repos['git.gnome.org'] = 'ssh://user@git.gnome.org/git/'

    # what module set should be used.  The default can be found in
    # jhbuild/defaults.jhbuildrc, but can be any file in the modulesets directory
    # or a URL of a module set file on a web server.
    # moduleset = 'gnome-apps-3.2'
    #
    # A list of the modules to build.  Defaults to the GNOME core and tested apps.
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
    #autogenargs=

    # On multiprocessor systems setting makeargs to '-j2' may improve compilation
    # time. Be aware that not all modules compile correctly with '-j2'.
    # Set makeargs to 'V=1' for verbose build output.
    #makeargs = '-j2'

You should edit at least modules to the desired modules to be built. A
reference for most configuration variables is available at GNOME JHBuild
Manual.

Usage
-----

> Installing Prerequisites

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

Troubleshooting
---------------

> Python issues

Note:Users of the jhbuild package should not encounter Python-related
issues; if you do, please add a comment describing your issue to the
jhbuild page.

Projects which use Python 2 may encounter errors when building, because
they refer to paths like /usr/bin/python, which points to Python 3 on
Arch. Building GNOME with a default configuration may cause this error.

To fix this issue, you can point the correct Python 2 path to JHBuild by
appending the following to ~/.jhbuildrc:

    autogenargs='PYTHON=/usr/bin/python2'

Packages will then be configured to use Python 2 instead of Python 3.

If you are building from scratch on your own, it may be necessary to run
autogen.sh with the following:

    PYTHON=/usr/bin/python2 ./autogen.sh

The shebang line in ~/.local/bin/jhbuild may need to update to:

    #!/usr/bin/python2

You may need to switch the symlink "/usr/bin/python" to point to
python2.7 to get "jhbuild build" to run correctly. The folks in
#gnome-shell on irc.gnome.org will help in any way they can.

> pkg-config issues

If you have a malformatted .pc file on your PKG_CONFIG_PATH, JHBuild
won't be able to detect all the (valid) .pc files you have installed and
will complain that the .pc files are missing. Look at the output of
jhbuild sysdeps—there should be a message about the problematic .pc
files.

External links
--------------

GNOME JHBuild Manual

Retrieved from
"https://wiki.archlinux.org/index.php?title=JHBuild&oldid=250600"

Category:

-   Development
