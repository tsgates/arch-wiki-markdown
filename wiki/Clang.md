Clang
=====

Clang is a C/C++/Objective C compiler based on LLVM. It is distributed
under the BSD Licence.

Contents
--------

-   1 Installation
-   2 Build packages with Clang
-   3 Using the Static Analyzer
-   4 References

Installation
------------

Install clang from the Official repositories.

Build packages with Clang
-------------------------

Add export CC=clang and (for C++) export CXX=clang++ to your
/etc/makepkg.conf.

Using the Static Analyzer
-------------------------

First install the clang-analyzer package. To analyze a project, simply
place the word scan-build in front of your build command. For example:

    $ scan-build make

It is also possible to analyze specific files:

    $ scan-build gcc -c t1.c t2.c

References
----------

-   scan-build: running the analyzer from the command line

Retrieved from
"https://wiki.archlinux.org/index.php?title=Clang&oldid=302820"

Category:

-   Package development

-   This page was last modified on 2 March 2014, at 03:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
