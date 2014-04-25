Guitar Pro
==========

Guitar Pro is great to transcribe and compose for stringed instruments,
organized in terms of tablature notation correctness and ease of use.
One use of using Guitar Pro is to create backing tracks and export them
to MIDI, then use those as a backing tracks to practice with on an
instrument.

This article covers how to start using the outdated Guitar Pro 5.2 with
Linux. Native binaries do not exist for Guitar Pro 5, opposed to the
case of Guitar Pro 6, so this requires Wine running the windows version
and Timidity as a MIDI backend.

Tip:If you want to use Guitar Pro 6, as it runs natively in Linux, you
can use the guitar-pro package from the AUR instead. Guitar Pro 6 can
also use timidity instead of RSE, so this guide maybe still be useful to
Guitar Pro 6 users as well.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Troubleshooting
    -   3.1 MIDI doesn't play
    -   3.2 Missing note heads and other symbols
-   4 See also

Installation
------------

As a prerequisite, you need Wine and Timidity installed. Consult
respective wikis on how to install them.

The directory ~/wine is suggested for Wine installations. After
downloading Guitar Pro installer (either demo versions or full
versions), cd to the download folder and run these commands:

    $ WINEPREFIX="$HOME/wine/guitar_pro_5"
    $ mkdir $WINEPREFIX
    $ wine GP5FULL.exe

What happens is a similar to standard Windows install procedure that
leaves you with $WINEPREFIX dirctory occupied with installed Guitar Pro
ready to be configured/used.

Configuration
-------------

Configuration of Timidity is covered in it's wiki. Once it's running,
run Guitar Pro. You can use a little convenience script to launch Guitar
Pro from command line/prompt box if you do not want to use Timidity as a
daemon:

    ~/bin/GP5.EXE

    #!/bin/bash
    # script GP5.EXE
    # author: dante4d <dante4d@gmail.com>

    timidity -iA &
    PID=$!
    sleep 1
    WINEPREFIX="$HOME/wine/guitar_pro_5" wine "C:\\Program Files\\Guitar Pro 5\\GP5.EXE"
    sleep 1
    kill $PID

First, you need to setup Guitar Pro to use right MIDI output device. In
menu, go to Options->Audio Settings (MIDI/RSE)... . On top of the
dialog, select Timidity as an output device for port 1 as it should
suffice.

You may also want to turn off the splash screen and the intro jingle
under menu Options->Preferences (F12).

Troubleshooting
---------------

> MIDI doesn't play

Check Timidity settings in /etc/timidity++/timidity.cfg. You may have
this issue if you forget to include soundpatches there :).

> Missing note heads and other symbols

Sometimes you will see just whitespaces instead of note heads and some
other symbols. One of the solutions is to link font files from Guitar
Pro directory in Wine folders to /usr/shared/fonts/TTF or ~/.fonts. For
more info, check Guitar Pro 5.x at WineHQ or use Google.

See also
--------

-   Guitar Pro Home - http://www.guitar-pro.com/
-   Guitar Pro 5.x at WineHQ -
    http://appdb.winehq.org/objectManager.php?sClass=version&iId=3782

Retrieved from
"https://wiki.archlinux.org/index.php?title=Guitar_Pro&oldid=206508"

Categories:

-   Audio/Video
-   Wine

-   This page was last modified on 13 June 2012, at 13:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
