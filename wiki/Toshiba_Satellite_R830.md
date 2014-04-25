Toshiba Satellite R830
======================

Wi-Fi & Ethernet
----------------

Atheros Communications Inc. AR9285 Wireless Network Adapter
(PCI-Express) (rev 01) and Intel Corporation 82579V Gigabit Ethernet
with kernel 3.8 work out of the box.

Brightness
----------

xbacklight from xorg-xbacklight works fine.

Suspend and resume
------------------

Brightness control works until sleep but after resume it does not.

Adding acpi_osi=Linux acpi_backlight=vendor to kernel-line (see Kernel
Parameters) helped me.

There is another solution here:
https://bbs.archlinux.org/viewtopic.php?id=132044

Retrieved from
"https://wiki.archlinux.org/index.php?title=Toshiba_Satellite_R830&oldid=256814"

Category:

-   Toshiba

-   This page was last modified on 12 May 2013, at 10:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
