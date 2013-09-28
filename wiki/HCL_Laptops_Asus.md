HCL/Laptops/Asus
================

  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Hardware Compatibility List - Laptops main page   
   Acer - Apple - Asus - Compaq - Dell - Digital - ECS - Siemens-Fujitsu - Gateway - Hitachi - Higrade - HP - IBM/Lenovo - Medion - Micron - Mitac - Mitsubishi - NEC - Panasonic - Samsung - Sony - Toshiba - Zenith - Other
  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Hardware Compatibility List (HCL)
  Full Systems
  Laptops - Desktops - Servers - Virtual Machines
  Components
  Video Cards - Sound Cards - Wired Net Adapters - Modems - Wireless Adapters - Monitors - Bluetooth Adapters - Printers - Scanners - TV Cards - Digital Cameras - Web Cameras - UPS - Floppy Drives - CD and DVD Writer/Readers - SCSI Adapters - Gadgets - SATA IDE Cards - Keyboards - Main Boards - RAID Controllers
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Model Support
=============

Model Version:

Install CD Version:  

Hardware Support:

Remarks:

Video:

Sound:

Ethernet:

Wireless:

Bluetooth:

Power  
Management:  

Other:

W7S-B1B

Don't Panic

3D with NVIDIA drivers

hda-intel

r8169 module, out of the box

Intel 4965 works with iwlwifi

works out of the box

suspend works with pm-utils; hibernation is extremely unstable

webcam works with uvc drivers, but it is mounted upside down

ACPI works with acpi4asus and acpid

N80VN-X5

2009.02RC2

3D with NVIDIA drivers

hda-intel plus adding
options snd-hda-intel enable=1 model=g50v position_fix=0 to
/etc/modprobe.d/modprobe.conf

Out of box with r8169 module

out of box with ath9k

out of box

suspend and hibernate both work with pm-utils

webcam and card reader both work out of the box

ACPI works fine with the asus_laptop module

F8SN

2009.08

only tried with open source NV drivers[got 1280x800 pixels default
without xorg edit], 3D proprietary will probably work

hda-intel

Ethernet works out of the box

Intel 4965 works with iwlwifi

untested-but is recognized by kernel

untested-battery status can be detected and customization options exist

Syntek Sonic web cam and Ricoh Card reader work out of the box (might
need to allow user mount privileges just as you would for other ext.
drives)

Highly compatible with Arch Linux

L3000D

Most recent as of 2010-02-13

Works out of box

Works out of box

Works out of box

Not contains

Not contains

Works perfectly

Untested

N53JN

Most recent as of 2010-11-03

Contains NVIDIA Optimus, so only Intel graphic card works. Waiting for
NVIDIA to support Optimus on Linux

Works, needs some editing of modprobe files

Works out of box

ath9k needs madwifi

Untested

Hibernate untested, suspend works but with problems due to USB3
controller

Web cam works, touchpad works, media buttons work, card reader isn't
recognized by the kernel

N53SV

Most recent as of 2011-06-26

Contains NVIDIA Optimus, so only Intel graphic card works.

hda-intel

r8169 module, works out of box

ath9k needs madwifi

Untested

Untested

Web cam works, touchpad works, card reader works

A8Le

Most recent as of 2011-07-31

Works out of box

Works out of box (with ALSA, 'Speaker' channel should be un-muted)

Out of box with r8169 module

Untested

Untested

Untested

Touchpad works

1005HA

2011.08.19

Works out of box using i915

hda-intel

Works out of box

ath9k

Untested

Untested

UL30A

2011.08.19

Works out of box

hda-intel

Works out of box

Untested

Untested

Untested

Web cam works, touchpad works, cardreader untested

acpi_backlight=vendor in bootloader

G73SW

2011.08.19

nvidia

hda-intel

Works out of box

Works out of box

None

Untested

Backlit keys worked when I installed GNOME

Power settings need work...

Q500A

Works out of box using i915

hda-intel, mic works

AR8151v2 works out of box

Works out of box

Works out of the box

Suspend works, Hibernate untested

Backlit keys work, touchpad works, webcam works, cardreader works, HDMI
output untested

Backlight is black after wake from sleep. xorg-xbacklight does not work,
installed asus-screen-brightness from AUR

K55VM

2013.04.01

Contains NVIDIA Optimus, both works. Intel and Nvidia(proprietary
drivers)

hda-intel

r8168 module, works

ath9k Works out of box

Untested

suspend and hibernate both work with gnome power manager and
laptop-mode-tools

Web cam works, touchpad works, card reader works, sound card works

Highly compatible with Arch Linux. Technology optimus works with
Bumblebee

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Laptops/Asus&oldid=254723"

Category:

-   Hardware Compatibility List
