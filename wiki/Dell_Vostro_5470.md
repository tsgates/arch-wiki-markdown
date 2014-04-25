Dell Vostro 5470
================

Dell Vostro 5470

This page deals with setting up Arch Linux on the Dell Vostro 5470
laptop.

I installed arch using Antergos.

Contents
--------

-   1 CPU
-   2 Touchscreen
-   3 GPU
    -   3.1 Bumblebee and NVIDIA proprietary driver
-   4 Networking
    -   4.1 Ethernet
    -   4.2 Wireless

CPU
---

This laptop has several CPU configurations and that will depend on the
purchase. The one we are documenting has a Core i7-4500U CPU.

    # uname -p

  
 This CPU is capable of frequency scaling.

Touchscreen
-----------

Worked out of the box.

GPU
---

Card: NVIDIA Corporation GK208M [GeForce GT 740M]

> Bumblebee and NVIDIA proprietary driver

Install intel video driver

Install Bumblebee

Add yourself to bumblebee group

    # systemctl enable bumblebeed

Install NVIDIA proprietary driver

bbswitch

primus

Networking
----------

> Ethernet

Install r8168 kernel module.

Then blacklist the r8169:

    # echo 'blacklist r8169' > /etc/modprobe.d/blacklist.conf

Restart or remove unload r8169:

    # sudo modprobe -r r8169

> Wireless

Worked out of the box

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Vostro_5470&oldid=306127"

Category:

-   Dell

-   This page was last modified on 20 March 2014, at 17:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
