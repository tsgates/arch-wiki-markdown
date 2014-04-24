HCL/TV Cards
============

  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Hardware Compatibility List (HCL)
  Full Systems
  Laptops - Desktops
  Components
  Video Cards - Sound Cards - Wired Net Adapters - Modems - Wireless Adapters - Printers - Scanners - TV Cards - Digital Cameras - CD and DVD Writer/Readers - Keyboards - Main Boards
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Kworld
------

Kworld PlusTV Analog PCI PVR 7131SE
-----------------------------------

This card is reported by lspci as:

    01:0a.0 Multimedia controller: Philips Semiconductors SAA7134/SAA7135HL Video Broadcast Decoder (rev 01)

The following line must be present in /etc/modprobe.d/modprobe.conf:

    options saa7134 card=59 tuner=56

See specifications.

Kworld PCI Analog TV Card Lite PVR-TV 7134SE
--------------------------------------------

This card is reported by lspci as:

    xx:xx.x Multimedia controller: Philips Semiconductors SAA7134/SAA7135HL Video Broadcast Decoder (rev 01)

The following must be present in /etc/modprobe.d/modprobe.conf (or the
file you like), I think you have to restart for the changes to take
effect (couldn't reload the module manually):

    options saa7134 card=63 tuner=43 

More info at
http://linuxtv.org/wiki/index.php/Kworld_PCI_Analog_TV_Card_Lite

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/TV_Cards&oldid=279826"

Category:

-   Hardware Compatibility List

-   This page was last modified on 26 October 2013, at 04:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
