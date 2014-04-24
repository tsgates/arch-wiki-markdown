HCL/Laptops/Panasonic
=====================

  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Hardware Compatibility List (HCL)
  Full Systems
  Laptops - Desktops
  Components
  Video Cards - Sound Cards - Wired Net Adapters - Modems - Wireless Adapters - Printers - Scanners - TV Cards - Digital Cameras - CD and DVD Writer/Readers - Keyboards - Main Boards
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  ----------------------------------------------------------------------------------------------------------------------------------
  Hardware Compatibility List - Laptops main page
  Acer - Apple - Asus - Compaq - Dell - Siemens-Fujitsu - Gateway - HP - IBM/Lenovo - Panasonic - Samsung - Sony - Toshiba - Other
  ----------------------------------------------------------------------------------------------------------------------------------

Model List
----------

Model Version

Arch Linux   
Install CD Version  

Hardware Support

Remark

Video

Sound

Ethernet

Wireless

Bluetooth

Power Management

Modem

Other

CF-Y2 Toughbook (CF-Y2EWAZZBM)

2008.06

Intel 855GM (rev 02) - works perfectly at 1400x1050 with
xf86-video-intel package and 'intel' xorg driver

Intel ICH4 AC'97 (rev 03) - works perfectly with default ALSA

Realtek RTL-8139 (rev 10) - works perfectly with default Linux 2.6
kernel

Intel 2915ABG (rev 05) - works perfectly with default Linux wireless
drivers

NA

Suspend to  
RAM: Yes, via /sys/power/state

* * * * *

Suspend to Disk: Yes, tuxonice

* * * * *

Battery: Yes

* * * * *

Dimming of display: Yes (with pcc module)

* * * * *

Frequency scaling of CPU: Yes

Not recognized by Linux

CardBus slot: not tried

* * * * *

SD card slot: not tried

Use "vbetool post" after resume from Suspend to RAM to fix dark screen
problem.

CF-27 Toughbook (CF-27EB6GCAM)

2010.05

Neomagic NM2200 [MagicGraph 256AV] (Rev 20) - max resolution of 800x600
with xf86-video-neomagic package and 'neomagic' xorg driver

Yamaha YMF-744B [DS-1S] (Rev 03) - works with default ALSA. Bootup
messages say BUSY and then FAIL when loading modules. However, sound
files play just fine using aplay.

None provided. Cardbus used...  
Dynex DX-E201, Realtek RTL-8139 (8139too).

None provided. Cardbuses used...  
AirLink 101 AWLC5025 MIMO XR - worked with rt2x00 drivers (rt61pci)

* * * * *

Belkin Wireless G+ F5D7011 v2000 - works with b43 driver and
b43-fwcutter install method.

NA

Not tested

Present but disabled in BIOS

TouchPad seen as standard PS/2 mouse, not Synaptics apparently.

* * * * *

BIOS says touchscreen is enabled but unsure of what drivers would work.

* * * * *

OSD and some Fn buttons work - brightness, volume control, battery
check.

Pentium II, 300MHz, 320MB RAM, 30GB drive, DVD-ROM, USB 1.0 (untested)

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Laptops/Panasonic&oldid=289355"

Category:

-   Hardware Compatibility List

-   This page was last modified on 19 December 2013, at 03:08.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
