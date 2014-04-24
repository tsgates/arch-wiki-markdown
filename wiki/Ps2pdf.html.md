ps2pdf
======

Contents
--------

-   1 Installation
-   2 How do I create a PDF from PS the easy way?
-   3 ps2pdf
    -   3.1 Explanation
    -   3.2 Misconceptions

Installation
------------

Ps2pdf is provided by ghostscript which is available in the official
repositories.

How do I create a PDF from PS the easy way?
-------------------------------------------

This page should help people who are asking themselves (maybe for the
second, third or n-th time) this question and maybe found the answer
once but never have written this somewhere or remembered correctly.

ps2pdf
------

One command does it all:

    ps2pdf -sPAPERSIZE=a4 -dOptimize=true -dEmbedAllFonts=true YourPSFile.ps

> Explanation

-   ps2pdf is the wrapper to ghostscript (ps2pdf is owned by ghostscript
    package)
-   with -sPAPERSIZE=something you define the paper size. Wondering
    about valid PAPERSIZE values? See here
-   -dOptimize=true let's the created PDF be optimised for loading
-   -dEmbedAllFonts=true makes the fonts look always nice

> Misconceptions

-   you cannot choose the paper orientation in ps2pdf. If your input PS
    file is healthy, it already contains the orientation information. If
    you are trying to use an Encapsulated PS file, you will have
    problems, if it does not fit in the -sPAPERSIZE you specified,
    because EPS files usually do not contain paper orientation
    informaiton. a workaround is creating a new paper in ghostscript
    settings (call it e.g. "slide") and use it as -sPAPERSIZE=slide

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ps2pdf&oldid=305709"

Category:

-   Office

-   This page was last modified on 20 March 2014, at 01:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
