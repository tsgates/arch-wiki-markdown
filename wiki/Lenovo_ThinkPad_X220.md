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

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Setup                                                              |
|     -   1.1 Graphics                                                     |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Heat issues                                                  |
|     -   2.2 My laptop gets stuck in a reboot loop if I resume from       |
|         suspend! Help!                                                   |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Setup
-----

> Graphics

The graphic card is supported by the xf86-video-intel driver package
from the extra repository. The Xorg server makes use of this
automatically. There's no need for a Xorg configuration file.

    pacman -S xf86-video-intel

Configuration
-------------

> Heat issues

According to a forum post you should set some power saving options in
/etc/modprobe.d/modprobe.conf or add them to your kernel line in your
menu.lst. We use rc6=7 for deepest sleep mode.

    options i915 modeset=1
    options i915 i915_enable_rc6=7
    options i915 i915_enable_fbc=1 
    options i915 lvds_downclock=1

As well you could suffer of Kernel Power Regressions.

> My laptop gets stuck in a reboot loop if I resume from suspend! Help!

This can be caused by the EFI storage getting too full. Run the
following commands as root to free up some space -

     # First clear the pstore
     mkdir -p /dev/pstore
     mount -t pstore pstore /dev/pstore
     ls /dev/pstore # <- Nothing important should be here, but check first anyway
     rm /dev/pstore/*

     # Next some EFI variables. These are used/created by pstore, but I've had them even though 
     #I deleted the pstore data using the above commands. YMMV.
     rm /sys/firmware/efi/efivars/dump-type0-*

This information was taken from the Lenovo forums

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
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_X220&oldid=255328"

Category:

-   Lenovo
