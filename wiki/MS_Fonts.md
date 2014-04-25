MS Fonts
========

Related articles

-   Fonts
-   Font Configuration
-   Java Runtime Environment Fonts

Installing TrueType Microsoft fonts and emulating Windows' font
rendering.

Contents
--------

-   1 Installation
    -   1.1 Using fonts from a Windows partition
    -   1.2 Current packages
    -   1.3 Legacy packages
-   2 Fontconfig rules useful for MS Fonts
-   3 Sharp fonts resembling Windows XP
-   4 Smooth fonts resembling Windows 7

Installation
------------

> Using fonts from a Windows partition

Let's say you have a Windows partition mounted as /windows. You can use
its fonts by linking to them like so:

    # ln -s /windows/Windows/Fonts /usr/share/fonts/WindowsFonts

Then regenerate the fontconfig cache:

    # fc-cache

> Current packages

Note:These packages do require access to a Windows 7/8 and/or a Office
2007 setup or installation media, consult corresponding PKGBUILD for
details.

Available in the AUR:

-   ttf-win7-fonts — Windows 7 fonts
-   ttf-office-2007-fonts — Microsoft Office 2007 fonts
-   ttf-ms-win8 — Windows 8.1 fonts

> Legacy packages

Note:The fonts provided by these packages are out-of-date and are
missing modern hinting instructions and the full character sets. It is
recommended to use the above packages.

ttf-ms-fonts is available in the AUR.

According to original Microsoft's End User License Agreement, there are
some legal limitations when using the fonts.

The package includes:

-   Andalé Mono
-   Arial
-   Arial Black
-   Comic Sans
-   Courier New
-   Georgia
-   Impact
-   Lucida Sans
-   Lucida Console
-   Microsoft Sans Serif
-   Symbol
-   Times New Roman
-   Trebuchet
-   Verdana
-   Webdings
-   Wingdings

You can also obtain ttf-tahoma or ttf-microsoft-tahoma from the AUR,
which as you might expect contains Tahoma.

ttf-vista-fonts is also available in the AUR and includes:

-   Calibri
-   Cambria
-   Candara
-   Consolas
-   Constantia
-   Corbel

Fontconfig rules useful for MS Fonts
------------------------------------

Often websites specify the fonts using generic names (helvetica,
courier, times or times new roman) a rule in fontconfig replaces this
fonts with (ugly) free fonts:

    /etc/fonts/conf.d/30-metric-aliases.conf

to make full use of the MS fonts it is necessary to create a rule
mapping those generic names to MS specific fonts contained in the
various packages above:

    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
           <alias binding="same">
             <family>Helvetica</family>
             <accept>
             <family>Arial</family>
             </accept>
           </alias>
           <alias binding="same">
             <family>Times</family>
             <accept>
             <family>Times New Roman</family>
             </accept>
           </alias>
           <alias binding="same">
             <family>Courier</family>
             <accept>
             <family>Courier New</family>
             </accept>
           </alias>
    </fontconfig>

  
 It is also useful to associate serif,sans-serif,monospace fonts in your
favourite browser to MS fonts.

Sharp fonts resembling Windows XP
---------------------------------

A complete guide on how to make the MS Fonts look as in Windows XP is
found at http://www.sharpfonts.co.cc/ (site down, try sharpfonts in the
AUR). In short, install the fonts as described above and use the
author's modified XML files.

Smooth fonts resembling Windows 7
---------------------------------

Use Infinality's patched freetype2 package, and use the Windows 7
profile in the provided local.conf.

Retrieved from
"https://wiki.archlinux.org/index.php?title=MS_Fonts&oldid=290062"

Categories:

-   Fonts
-   Graphics and desktop publishing

-   This page was last modified on 23 December 2013, at 08:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
