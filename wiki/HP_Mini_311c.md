HP Mini 311c
============

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Before installation
-   2 Installation
-   3 FIRST BOOT
-   4 Another device

Before installation

Before installation of archlinux you need to activate Wake On Lan on
your BIOS , if you not make it, your ethernet controller not work on
Linux if your ethernet cable is not connected on Windows

Installation

Installation on this computer is very similar to a standard archlinux
installation, but you need to blacklist the b43 module, if you not make
it, udev crash at reboot in your new OS, edit the /etc/rc.conf file with

      …
      MOD BLACKLIST=(b43)
      …

FIRST BOOT

Now you boot on your new archlinux, install wireless by AUR with Yaourt
or another method

      yaourt –S broadcom-wl

(WARNING : This module is not a free module but propietary) After
installation edit your rc.conf, remove blacklisted module and add at
MODULES line :

      MODULES=(lib80211 wl !b43 !ssb)

And restart If problem : If after restart your wirless don’t work,
verify if wireless is activate (the orange led need to be blue)

Another device

Sound work out of box but i recommand install and use of PulseAudio ION
is supported by nvidia drivers For get hardward acceleration working
with mplayer, you need to get ffmpeg-vdpau and mplayer-svn from AUR

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Mini_311c&oldid=196627"

Category:

-   HP

-   This page was last modified on 23 April 2012, at 12:56.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
