Lenovo Thinkpad w520
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

-   1 Note
-   2 GPT / MBR Partition Table
-   3 Wifi issues
-   4 Nvidia Optimus issues
-   5 Sound
-   6 Other

Note
----

I am also maintaining this content at GitHub and it may be more up to
date.

GPT / MBR Partition Table
-------------------------

I was unable to get the most recent version of the BIOS to boot from a
GPT partition table. Everything worked fine once I tried an MBR ("msdos"
in gparted) partition table.

Wifi issues
-----------

-   Update wireless drivers:
    -   TODO
-   Random Disconnection
    -   check "dmesg | grep wlan0" will probably be complaining about
        "wlan0: deauthenticating from MAC by local choice (reason=3)"
    -   Arch wiki hints at solution: Wicd#Random_disconnecting
    -   My Solution:
        -   Disable power management of pci-express in BIOS
-   Wicd cannot obtain IP address
    -   Wicd#Failed_to_get_IP_address
    -   Use dhclient instead of dhcpcd:
        -   pacman -S dhclient
        -   Set wicd to use dhclient:
        -   in wicd-curse press 'P', select external sources, and then
            select dhclient

Nvidia Optimus issues
---------------------

-   TODO
-   see:
    -   Phoronix
    -   Nvidia Forums

Sound
-----

-   Worked out of the box, but was choppy. This helped:
    -   PulseAudio#Choppy_sound

Other
-----

-   Boot up issue with UDEV timeout
    -   cat /var/log/boot | grep -i pci reveals udevd[169]: seq 1352
        '/devices/pci0000:00/0000:00:1c.1/0000:03:00.0' killed
        -   Found similar issue here Arch Bugs Report
-   Disable annoying system beep
    -   Insert "blacklist pcspkr" into
        /etc/modprobe.d/pcspkr_blacklist.conf
    -   Reboot or rmmod pcspkr

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_Thinkpad_w520&oldid=298615"

Category:

-   Lenovo

-   This page was last modified on 18 February 2014, at 01:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
