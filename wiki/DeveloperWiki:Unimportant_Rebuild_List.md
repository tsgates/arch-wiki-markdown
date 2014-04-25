DeveloperWiki:Unimportant Rebuild List
======================================

  

Contents
--------

-   1 Packages that can be converted to arch=any
-   2 Packages with uncompressed man pages
-   3 Packages with leading /'s for paths in their .install files
-   4 Packages greater than two years old
-   5 Done!

Packages that can be converted to arch=any
------------------------------------------

List thanks to Gerardo
(http://archlinux.djgera.com.ar/misc/any-20091019.txt). Care needs to be
taken as some packages in the original list contained references to the
arch in their scripts (e.g. pacman-mirrorlist, abs)

    [extra] (12 pkgs, about 250M per arch)
    boo                            1776.00    K
    gecko-sharp-2.0                180.00     K
    gettext-mono                   40.00      K
    maxima                         88800.00   K
    mono-basic                     2520.00    K
    mono-tools                     3488.00    K
    mono-zeroconf                  300.00     K
    smplayer-themes                5228.00    K
    taglib-sharp                   464.00     K
    usermin                        25752.00   K
    webmin                         73344.00   K
    xsp                            1812.00    K

    (can not convert as from split packages - repo management scripts limitation)

    [core]
    kernel26-docs
    udev-compat

    [extra]
    foomatic-db                    48224.00   K
    foomatic-db-nonfree            8917.00    K
    gconfmm-docs                   960.00     K
    glibmm-docs                    15396.00   K
    gtkmm-docs                     50104.00   K
    kdeartwork-aurorae             132.00     K
    kdeartwork-colorschemes        56.00      K
    kdeartwork-desktopthemes       1656.00    K
    kdeartwork-emoticons           688.00     K
    kdeartwork-iconthemes          26364.00   K
    kdeartwork-sounds              1504.00    K
    kdeartwork-wallpapers          78676.00   K
    kdeartwork-weatherwallpapers   7728.00    K
    kdesdk-kdepalettes             28.00      K
    kdesdk-kprofilemethod          16.00      K
    koffice-karbon-doc             40.00      K
    koffice-kchart-doc             416.00     K
    koffice-kexi-doc               256.00     K
    koffice-kpresenter-doc         1456.00    K
    koffice-kspread-doc            676.00     K
    koffice-pics                   788.00     K
    koffice-servicetypes           40.00      K
    koffice-templates              64.00      K
    koffice-thesaurus-doc          44.00      K
    libsigc++-docs                 10836.00   K
    libxml++-docs                  1960.00    K
    pangomm-docs                   3340.00    K
    ruby-docs                      281180.00  K
    xorg-server-common             188.00     K
    xorg-server-devel              1520.00    K

Packages with uncompressed man pages
------------------------------------

See https://www.archlinux.org/devel/reports/uncompressed-man/

Packages with leading /'s for paths in their .install files
-----------------------------------------------------------

TODO: generate list...

Packages greater than two years old
-----------------------------------

See https://www.archlinux.org/devel/reports/old/

Done!
-----

For reference, the following lists have been completed:

-   Packages without the arch in their file name
-   Packages containing a .FILELIST file
-   Packages depending on gcc
-   Packages with files in /usr/man
-   Packages with uncompressed info pages
-   Packages in [core] needing more deps to run their install files
-   Packages removed from base group
-   Packages with old install file syntax

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Unimportant_Rebuild_List&oldid=217397"

Category:

-   Package development

-   This page was last modified on 10 August 2012, at 12:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
