Lenovo ThinkPad X220
====================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Setup
    -   1.1 Graphics
    -   1.2 Booting
-   2 Issues
    -   2.1 Heat
    -   2.2 Reboot loop after resume from suspend!
    -   2.3 Microphone
-   3 See also

Setup
-----

> Graphics

The graphic card is supported by the xf86-video-intel driver package
from the extra repository. The Xorg server makes use of this
automatically. There's no need for a Xorg configuration file.

    pacman -S xf86-video-intel

> Booting

The X220 cannot boot from a GPT disk with legacy BIOS, so either use an
MBR disk or setup UEFI.

  

Issues
------

> Heat

Warning:This is quite old and shouldn't be applied on up-to-date systems
without actual problems. In case of doubt better take a look at
Intel#Module-based_Powersaving_Options

According to a forum post you should set some power saving options in
/etc/modprobe.d/modprobe.conf or add them to your kernel line in your
menu.lst. We use rc6=7 for deepest sleep mode.

    options i915 modeset=1
    options i915 i915_enable_rc6=7
    options i915 i915_enable_fbc=1 
    options i915 lvds_downclock=1

As well you could suffer of Kernel Power Regressions.

> Reboot loop after resume from suspend!

This can be caused by the EFI storage getting too full. Run the
following commands as root to free up some space.

     # First clear the pstore
     mkdir -p /dev/pstore
     mount -t pstore pstore /dev/pstore
     ls /dev/pstore # <- Nothing important should be here, but check first anyway
     rm /dev/pstore/*

     # Next some EFI variables. These are used/created by pstore, but I've had them even though 
     #I deleted the pstore data using the above commands. YMMV.
     rm /sys/firmware/efi/efivars/dump-type0-*

This information was taken from the Lenovo forums

> Microphone

The x220 internal microphone has been the source of many complaints
across platforms. Specifically, it can generate a lot of static or
hissing on top of any recorded audio. The workaround is to mute the
right mic input channel (in audio control programs that allow
independent channel setting) or to drag the balance slider in a GUI for
the internal mic level fully to the left.

Note also that the audio jack is a combination headset/mic jack and will
work with modern smartphone headsets with inline microphones, as an
alternative.

See also
--------

-   Arch user blogs about the X220
    -   Thinkpad X220 model 4287CTO using a msata SSD for 64 bit
        Archlinux
    -   X220 i5
-   Thinkwiki X220 reference
-   "Arch By Hand" UEFI GPT SSD LUKS Install Script, built on an x220
    tablet with an SSD.
-   Power saving options for the X220 - Notebook Review Forum

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_X220&oldid=302688"

Category:

-   Lenovo

-   This page was last modified on 1 March 2014, at 07:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
