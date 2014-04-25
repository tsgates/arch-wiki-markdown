HCL/Laptops/Sony
================

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

Vaio VGN-S5M

Any

3D with nvidia driver

Intel audio with ALSA

Yes

Yes, ipw2200bg

--

Suspend-to-RAM with suspend2

Untested

Memory stick reader does not work

Everything else (Fn Keys, DVD-RW drive, FireWire...) works without a
hitch

Vaio VGN-C2Z

Any

3D with nvidia driver

Intel audio with ALSA

Yes

Yes, ipw3945

Modules look fine but due to lack of a Bluetooth client not tested

Suspend-to-RAM with vanilla kernel & linux-ck

Untested

Memory stick reader not tested

Everything else (Fn Keys, DVDRW drive, Firewire...) works without a
hitch

Vaio VGN-FS742/W  
VGN-FS630/W

Kernel 2.6.23.12-3

i810

Intel audio with ALSA

e100

ipw2200

No

acpi_cpufreq, sonyacpi

Untested

Memory stick might work

Fn keys with FSFN

Vaio VGN-NR320FH

2008-06

Intel GMA965/X3100 (xf86-video-intel driver)

Intel audio with ALSA

Do not know, but works out-of-the-box

Atheros AR5006EG/AR242x (madwifi 0.9.4.3844-2)

No

acpi_cpufreq, sony-laptop

Untested

Memory stick might work

Fn keys with sony-laptop and sonypid. Using vga option in kernel line in
GRUB might give problems with resolution. Pretty cool laptop, everything
works out-of-the-box except Fn keys for which I needed to do some
research.

Vaio VGN-N130G

2010 (right now with kernel 2.6.34)

xf86-video-intel driver

Intel audio with ALSA

Do not know, but works out-of-the-box

ipw3945

No

Untested

Untested

Memory stick might work

The only problem I have had is with the Wi-Fi randomly cutting out
(netcfg -r to reconnect). I think this is a problem with MY laptop,
rather than this model in general.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Laptops/Sony&oldid=289408"

Category:

-   Hardware Compatibility List

-   This page was last modified on 19 December 2013, at 06:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
