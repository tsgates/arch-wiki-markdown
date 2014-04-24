Ccache
======

There's a wonderful tool for gcc called ccache. You can read about it at
their home page.

If you're always compiling the same programs over and over again — such
as trying out several kernel patches, or testing your own development —
then ccache is perfect. While it may take a few seconds longer to
compile a program the first time with ccache, subsequent compiles will
be much, much faster.

Contents
--------

-   1 Installation
    -   1.1 Enable ccache for makepkg
    -   1.2 Enable for command line
    -   1.3 Enable with colorgcc
-   2 Misc
    -   2.1 Change the cache directory
    -   2.2 CLI
-   3 See also

Installation
------------

Install ccache, available from the official repositories

> Enable ccache for makepkg

To enable ccache when using makepkg edit /etc/makepkg.conf. In BUILDENV
remove exclamation mark before ccache and it will enabled. For example:

     BUILDENV=(fakeroot !distcc color ccache !xdelta)

Note:If you are compiling for KDE example you have to disable export CPP
and export CXX — it prevents from some errors.

> Enable for command line

If you're compiling your code from the command line, and not building
packages, then you'll still want to use ccache to help speed things up.

For that, you need to change your $PATH to include ccache's binaries
before the path to your compiler.

    export PATH="/usr/lib/ccache/bin/:$PATH"

You may want to add this line to your ~/.bashrc file for regular usage.

> Enable with colorgcc

Since colorgcc is also a compiler wrapper, some care needs to be taken
to ensure each wrapper is called in the correct sequence.

    export PATH="/usr/lib/colorgcc/bin/:$PATH"    # As per usual colorgcc installation, leave unchanged (don't add ccache)
    export CCACHE_PATH="/usr/bin"                 # Tell ccache to only use compilers here

Then colorgcc needs to be told to call ccache instead of the real
compiler. Edit /etc/colorgcc/colorgccrc and change the /usr/bin paths to
/usr/lib/ccache/bin for all the compilers in /usr/lib/ccache/bin:

    /etc/colorgcc/colorgccrc

    g++: /usr/lib/ccache/bin/g++
    gcc: /usr/lib/ccache/bin/gcc
    c++: /usr/lib/ccache/bin/g++
    cc: /usr/lib/ccache/bin/gcc
    g77:/usr/bin/g77
    f77:/usr/bin/g77
    gcj:/usr/bin/gcj

Misc
----

> Change the cache directory

You may want to move the cache directory to a faster location than the
default "~/.ccache" directory, like an SSD or a ramdisk.

To do change the cache location:

    export CCACHE_DIR=/ramdisk/ccache             # Tell ccache to use this path to store its cache

> CLI

You can use the command line utility ccache to...

Show statistics summary:

    $ ccache -s

Clear the cache completely:

    $ ccache -C

See also
--------

-   ccache homepage
-   ccache manual

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ccache&oldid=280805"

Category:

-   Package development

-   This page was last modified on 1 November 2013, at 13:16.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
