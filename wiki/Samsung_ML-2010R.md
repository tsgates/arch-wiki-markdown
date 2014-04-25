Samsung ML-2010R
================

Samsung ML-2010R

I guess this work for all other ML-2010 printers too.

Installation

1.  Get .ppd file from:
    http://www.openprinting.org/printer/Samsung/Samsung-ML-2010. (take
    gdi ppd. Search for "directly download PPD" at the bottom.)
2.  pacman -S cups foomatic-filters ghostscript
3.  Configure Cups and direct your browser to http://localhost:631
    (Administration) -> (Printers/Add Printer) As driver, chose the
    downloaded ppd file from openprinting.org and do not forget to set
    default page size to A4.

That's all.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samsung_ML-2010R&oldid=196843"

Category:

-   Printers

-   This page was last modified on 23 April 2012, at 13:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
