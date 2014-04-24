HCL/Laptops/Asus
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

ASUS x401u

2014.01.05

Radeon HD 7340 - install xf86-video-ati

did not work out of the box, never configured correctly, using pulse,
everything works

not tested

Wi-Fi out of the box

none to support

all power options work just fine

webcam works

overall performance is satisfactory

ASUS x401a & x401a1

2013.05.01

Integrated Intel HD Graphics - install xf86-video-intel and
libva-intel-driver, enable SNA

hda-intel works, headphone jack, mic works

Realtek, out of the box

Wi-Fi out of the box

not tested

all power options work just fine, only brightness control needs module
asus-nb-wmi to be loaded and acpi_backlight=intel acpi_osi= GRUB options
as of kernel 3.9.4

webcam works

overall performance is satisfactory

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

only tried with open source NV drivers (got 1280x800 pixels default
without xorg edit), 3D proprietary will probably work

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

ath9k

Untested

Hibernate untested, suspend works but with problems due to USB3
controller

Web cam works, touchpad works, media buttons work

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

Web cam works, touchpad works, card reader untested

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

Q400A

Works out of box using i915

hda-intel, mic works

AR8151v2 works out of box

Works out of box

Works out of the box

Suspend works, Hibernate untested

Backlit keys work on GNOME 3, screen backlight works with keys in
gnome-3.10, touchpad works, webcam works, card reader works, HDMI output
untested

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

A55VJ

2013.05.01

Contains NVIDIA Optimus, both work (NVIDIA only via Bumblebee)

hda-intel

r8169 module works

iwlwifi

Works with bluez

suspend works out of box with systemd/logind.conf

Web cam works, touchpad works, card reader works

Highly compatible with Arch Linux. Add i8042.nomux=1 to kernel line to
prevent jittery touchpad.

S300CA

2013.08.01

Intel HD Graphics 4000, works out of the box with xf86-video-intel

hda-intel

Atheros AR8161, works out of the box

Atheros AR9485, works out of the box with ath9k

not tested

works, slightly higher power usage as Windows 8, for backlight add
acpi_osi=Linux acpi_backlight=vendor to bootloader kernel line

Web cam, touchpad, touchscreen all work, USB 3.0 and car reader not
tested yet

Highly compatible with Arch Linux.

X502CA

2013.07.01

Integrated Intel HD Graphics works

hda-intel works

Qualcomm Atheros AR816x/AR817x, did not work during installation, after
that works, but check model specific wiki

Ralink RT3290 performs very poorly with standard kernel driver. Check
model specific wiki

not tested

suspend works, see model specific wiki for display brightness control

not tested

not a very good choice for Linux due to Wi-Fi problems

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Laptops/Asus&oldid=292927"

Category:

-   Hardware Compatibility List

-   This page was last modified on 14 January 2014, at 23:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
