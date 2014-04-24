Starcraft
=========

This page is about the 1998 Starcraft, if you are looking for Starcraft
2, go here.

Installation
------------

Simple steps to install and run StarCraft on Linux:

1.  Install and configure Wine
2.  Run winecfg
3.  On the drives tab, click Autodetect
4.  Click "Show Advanced"
5.  Select the drive letter representing your optical drive
6.  Change type to CD-ROM
7.  On the Audio tab, I had to click OSS Driver (instead of Alsa) and
    check "Driver Emulation"

Install StarCraft:

1.  mount starcraft disc ($ mount /media/dvd)
2.  cd /media/dvd
3.  wine install.exe (install as you normally would)

At this point the game should run fine. My StarCraft disc installs an
older version which only supports IPX networking. I downloaded the
latest patch from blizzard and ran it using Wine. It patched StarCraft
to allow TCP networking, which worked flawlessly.

See Also
--------

-   WineHQ's AppDB entry for StarCraft

Retrieved from
"https://wiki.archlinux.org/index.php?title=Starcraft&oldid=198141"

Categories:

-   Gaming
-   Wine

-   This page was last modified on 23 April 2012, at 17:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
