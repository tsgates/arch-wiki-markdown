Libetc
======

This is for those who are tired of having a messy $HOME folder cluttered
with loads of dotfiles/dotfolders.

libetc is a LD_PRELOAD-able shared library that intercepts file
operations: if a program tries to open a dotfile in
HOME, it is redirected to XDG_CONFIG_HOME, as defined by freedesktop.

When an application tries to acces $HOME/.foobar, the call is redirected
to XDG_CONFIG_HOME/foobar

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Exceptions
-   4 Homepage

Installation
------------

libetc is available in the AUR, so use your favorite method to install
it.

Configuration
-------------

I use bash, but this should work for other shells too.

Open ~/.bashrc and add :

    export XDG_CONFIG_HOME=/anywhere/you/want 
    export LD_PRELOAD=libetc.so.0
    export LIBETC_BLACKLIST=/bin/cp:/bin/ln:/bin/ls:/bin/mv:/bin/rm:/usr/bin/find

XDG_CONFIG_HOME defaults to ~/.config if unset. Applications in
LIBETC_BLACKLIST will access dotfiles the regular way.

At that point, you might want to have every dotfile/dotfolder that was
previously in your HOME in XDG_CONFIG_HOME and strip out the dot in
their name. If you don't, new files will be created in $XDG_CONFIG_HOME
and/or "File not found" errors will appear. Read "Exceptions" below.

Then source your .bashrc :

    source ~/.bashrc

Exceptions
----------

Those files need to be in your
HOME, but you can link them into XDG_CONFIG_HOME if you need to.

-   .bashrc
-   .bash_history
-   .bash_profile

(feel free to add more if you find some)

Homepage
--------

Be sure to read the README there : http://ordiluc.net/fs/libetc

Retrieved from
"https://wiki.archlinux.org/index.php?title=Libetc&oldid=290164"

Category:

-   Dotfiles

-   This page was last modified on 23 December 2013, at 17:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
