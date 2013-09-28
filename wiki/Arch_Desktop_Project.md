Arch Desktop Project
====================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 What is it?                                                        |
| -   2 What can you do?                                                   |
| -   3 List of applications                                               |
|     -   3.1 Missing file                                                 |
|     -   3.2 Broken                                                       |
|     -   3.3 Fixed                                                        |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

What is it?
-----------

The Desktop Project aims to fill the hole left by many applications
developers: the .desktop files. These files are the ones that allow you,
in a FreeDesktop-compliant WM/DE, to see the installed applications in
the system menu, along with their icon, allowing you to access them in
an easy way. Unfortunately, many applications do not include a .desktop
file, so you have to write one yourself or launch them from a command
line.

What can you do?
----------------

Just add the graphical applications you use that are not listed in your
system menu to the list below. I (bardo) will write/modify the necessary
files and notify the corresponding maintainers so they can be added to
the packages. Of course any help/comment/critic is really appreciated :)

List of applications
--------------------

> Missing file

-   apricots
-   bittornado (missing for btdownloadgui.py, btcompletedirgui.py,
    btmaketorrentgui.py)
-   carworld
-   chromium
-   dosbox (.desktop and icon files available from dosbox-cvs)
-   drscheme (fix proposed in BR#7571)
-   empathy
-   eric
-   flashplayer-standalone
-   flobopuyo
-   gkrellm
-   gmencoder (see FS#6568)
-   gnuplot
-   gtick (see FS#9675)
-   hedgewars
-   imgseek
-   k9copy
-   kobodeluxe
-   lbreakout2
-   lincity
-   lyx (note, can get icons from wiki.lyx.org - LyX Icons)
-   nedit (see FS#9677)
-   openmovieeditor
-   pdfedit
-   picard
-   pinball
-   puzzles
-   pysolfc
-   ripperx
-   scummvm
-   speedcrunch (see FS#5526)
-   stellarium (see FS#5639 and the project's bug report; the 0.9.0 is
    in [testing], but still no file, maintainer notified)
-   winetools
-   wireshark (see FS#7437)
-   xmahjongg
-   xpenguins
-   xsane
-   xscorch
-   zsnes

> Broken

-   denemo
-   ettercap (missing icon)
-   evince (present, but doesn't show up in XFCE menu)
-   galculator (uncommon icon???; I suggeset
    /usr/share/pixmaps/galculator/galculator_48x48.png or
    .../galculator.svg icon)
-   gqview (doesn't validate)
-   mtpaint (lacks icon; I suggest applications-graphics or
    gnome-graphics icon)
-   nmapfe (lacks proper icon)
-   opera 9.50-0.13 (lacks icon; from arch x86_64 testing repo; I found
    actual icon graphic doesn't exist) (icon is now included)
-   qsopcast (missing icon)
-   xvkbd (missing icon)

> Fixed

-   acidrip (included in the package)
-   atanks (included in the package)
-   gtkpod (included upstream)
-   neverball (included in the package)
-   osmo (included upstream)
-   smc (included in the package)
-   xmoto (included in the package)

See also
--------

-   DeveloperWiki:Removal_of_desktop_files

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_Desktop_Project&oldid=254945"

Category:

-   Arch development
