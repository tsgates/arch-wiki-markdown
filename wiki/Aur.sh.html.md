Aur.sh
======

aur.sh is a sub-ten-line bash script for installing and building
packages from the AUR. It consists of four lines of multi-argument
handling and five lines of package installation. It was created with the
intention of bootstrapping AUR helpers, although it's possible to use it
as a bare-bones AUR helper itself.

The entire script
-----------------

       #!/bin/sh
       d=${BUILDDIR:-$PWD}
       for p in ${@##-*}
       do
       cd $d
       curl https://aur.archlinux.org/packages/${p:0:2}/$p/$p.tar.gz |tar xz
       cd $p
       makepkg ${@##[^\-]*}
       done

Installation and Usage
----------------------

aur.sh has no dependencies and no installation beyond what's already
required by pacman. It can be saved and set executable, it can be copied
into a profile function, or it can even be directed straight into bash
from curl (due to some clever user agent detection at http://aur.sh/):

       bash <(curl aur.sh) -si packer

Philosophy
----------

aur.sh's niche in a nutshell:

-   be flexible, but not robust - aur.sh is enough to do anything you
    will need to do to one-shot install your first AUR package. It does
    not keep track of anything, localize message strings, or indeed
    include an interface of any kind.
-   be as setup-independent as possible - smaller character counts means
    easier transportation. At 159 bytes, aur.sh is short enough to be
    transmitted in an SMS message (in a worst-case scenario).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Aur.sh&oldid=254620"

Categories:

-   Package management
-   Arch User Repository

-   This page was last modified on 20 April 2013, at 03:08.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
