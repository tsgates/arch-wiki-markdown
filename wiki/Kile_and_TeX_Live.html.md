Kile and TeX Live
=================

This article summarizes how to install the Kile LaTeX editor with
TeXLive instead of TeTeX (which is no longer maintained). For additional
information about how to install TeXLive on Arch Linux, visit the
TeXLive article.

Contents
--------

-   1 Step 1: Install TeXLive
-   2 Step 2: Install Okular
-   3 Step 3: Install Kile
-   4 Troubleshooting
    -   4.1 pdfTeX warnings

Step 1: Install TeXLive
-----------------------

The best way to start is installing the texlive-most package.

    # pacman -S texlive-most

Make sure you have enabled the community archives (in /etc/pacman.conf).
If you encounter errors during the installation complaining that
commands could not be found, try running:

    $ export PATH=$PATH:/opt/texlive/bin

before installing.

Step 2: Install Okular
----------------------

Simply type:

    # pacman -S kdegraphics-okular 

Note that okular can read .pdf as well as .dvi so there should not be
the need for any other tools.

Step 3: Install Kile
--------------------

Finally you have to install Kile.

    # pacman -S kile

Start Kile from your menu and check whether all dependencies are solved
using "Settings > Systemcheck". Kile will ask you for the Acrobat Reader
(the pacman package is called acroread), but that is optional.

Note that if you installed Kile before installing the required packages
(like kdvi), you can still install them and have a fully working Kile
install.

Enjoy Kile and TeXLive.

Troubleshooting
---------------

> pdfTeX warnings

If you get warnings such as:

    pdfTeX warning: pdflatex [...] fontmap entry for [...] already exists, duplicates ignored

try to remove the map files pcr8y.map, phv8y.map, ptm8y.map from the
updmap.cfg and finally run updmap.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Kile_and_TeX_Live&oldid=226689"

Category:

-   TeX

-   This page was last modified on 3 October 2012, at 13:25.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
