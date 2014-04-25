HCL/Laptops/Dell
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

e1405

Any

3D with xf86-video-intel 2.0, native resolution with xorg-server 1.3
(1440x900)

Intel HD Audio with ALSA

Yes

Yes, ipw3945

Yes

Suspend-to-RAM is shaky; hibernate is flawless

Untested

SD card reader works out-of-the-box

Everything else works without a hitch

E6420

2011.08.19

Intel HD3000 xf86-video-intel

Intel HD Audio with ALSA

Yes, e1000e

Yes, bcma-pci-bridge

Untested

Suspend-to-RAM good, hibernate not working

No modem

SD card reader works out-of-the-box, smart card reader works with ccid,
opensc, pcsc-tools. Touchpad (alps a10) pointer aspens by default,
install psmouse-elantech from the AUR to fix it (psmouse-alps does not
work anymore)

Ethernet was not working in fresh installation, had to clone
repositories to HDD and update

d420

Duke

xf86-video-intel, native resolution with xorg-server 1.2 (1280x800)

Intel HD Audio with ALSA

Yes (with tg3)

Yes (with ipw3945)

N/A

Untested

Have not tested SD card reader

External D-Bay DVD/CD-RW works, docking station mostly works (can
un-dock, but locks up on re-docking)

d620

Duke

3D with NVIDIA, native resolution with xorg-server 1.2 (1440x900)  
 3D with Intel 945GM, native resolution 1440x900

Intel HD Audio with ALSA

Yes

Yes, bcm4311 PCI-E with bcm43xx. Yes for some models with iwl3945.

N/A

Suspend-to-RAM perfect, hibernate works fine.

Untested

not tested smart card reader

Everything else works without a hitch

d820

Duke

3D with NVIDIA drivers

Intel HD Audio with ALSA

Yes

Yes, IPW3945

Yes

Suspending with KDE works

Untested

Everything works, even fingerprint reader with bioapi and pam_bioapi

Everything else works without a hitch

Inspiron 1420

2012.09

3D with xf86-video-nouveau

Intel HD Audio with ALSA

Yes

Yes, broadcom-wl needed from the AUR

Untested

Untested

Untested

Untested

Everything that I have tested works great without any problems

Inspiron 1501

Duke

3D with proprietary ATI fglrx

Intel HD audio with ALSA

Yes

Yes, BCM4311 PCI-E with bcm43xx

N/A

Untested

Untested

Smart card reader works out-of-the-box

Everything else works without a hitch

XPS M1210

Duke

3D with NVIDIA open source drivers

SigmaTel audio with ALSA

b44 module, out-of-the-box

IPW 3945, command-line wireless_tools

Untested

Untested

Untested

rico card reader worked out-of-the-box, hot keys using keytouch, web cam
works but is unstable. In MPlayer, use driver=v4l2:device=/dev/video0

Everything else works without a hitch

XPS L322

2013_03

Intel HD 4000, with xf86-video-intel

Intel HD Audio with ALSA

No Ethernet port

Yes

Untested

Yes

No modem

No SD card slot

ALPS Touchpad recognized only as PS/2 mouse, two-finger scroll, finger
tap-to-click, etc... does not work. Some new mouse drivers suggest a fix
but have not worked.

Inspiron 1520

Core Dump

3D with NVIDIA

SigmaTel audio with ALSA

b44 module, out of the box

b43, need firmware

Yes

Both hibernate and suspend-to-RAM and works with pm-utils

Untested

Hot keys work out-of-the-box

Everything else works without a hitch

Inspiron 1525

Arch Linux 2008.06 - "Overlord" FTP Install

3D with xf86-video-intel 2.4.3, native resolution with xorg-server 1.5.3
(1280x800)

Intel HD Audio (SigmaTel STAC9228 codec) with ALSA

Marvell Yukon Gb Ethernet: Yes (sky2 module)

PRO/Wireless 3945ABG with iwlwifi-3945-ucode 15.28.2.8

Untested (does not have)

Untested

Untested

SD card reader works out-of-the-box

Fn+Up/Down (LCD brightness control) works independently of the OS.
Everything else work out-of-the-box.

Inspiron 1525

Core Dump (2008.03 ISO)

3D with xf86-video-intel 2.2, native resolution with xorg-server 1.4
(1280x800)

Intel HD Audio (SigmaTel STAC9228 codec) with ALSA

Marvell Yukon Gb Ethernet: Yes (sky2 module)

Broadcom BCM4310: Yes, ndiswrapper (AUR broadcom-wl works, but must
blacklist ssb module)

Untested (does not have)

Untested

Untested

SD card reader (Ricoh) works out-of-the-box

Fn+Up/Down (LCD brightness control) works independently of the OS; media
keys configured with KeyTouch. DVD-RW drive and everything else work
out-of-the-box.

Inspiron 1564

Core Dump

3D with either Catalyst or xf86-video-ati; both work flawlessly.

Intel HD Audio with ALSA

Realtek RTL8101E Ethernet Controller

Intel WiFi Link 5100 with iwlagn driver

Untested

Both suspend and hibernate work flawlessly with pm-utils

Untested

Realtek card reader works out-of-the-box. LCD brightness works
out-of-the-box; volume keys need configuring through key bindings.

Overall, this laptop is Linux friendly.

Inspiron 1764

2011.08.19

3D with xf86-video-intel

Works well with ALSA

Realtek RTL8101E 10/100 Ethernet Controller

Broadcom BCM43224 802.11a/b/g/n works well with brcmsmac

Untested

Untested

Does not have a modem

SD card reader and LCD brightness Fn keys work out-of-the-box

Fan control/monitoring is completely broken with i8kutils

Inspiron 1300

Don't Panic (Core Dump version)

3D with xf86-video-intel

Intel

b44 module works out-of-the-box

BCM4318-based card, works with ndiswrapper

N/A

Untested

Untested

--

Everything works out-of-the-box except wireless and sometimes screen
resolution

Dell XPS M1330

Don't Panic (2007.08-2)

For dedicated graphics (NVIDIA 8400m) works with NVIDIA package

Works with Intel HD Audio and ALSA, but need to configure microphone

Yes

Works with iwl4965

Can set Bluetooth but have not tested with any devices

Suspend works fine with pm-utils (acpi_cpufreq problem: see forums)

Untested

2.0 MP web cam works with uvcvideo, media keys work with keytouch or
esekeyd, IR remote works, SD card works

Everything basically worked out-of-the-box except the microphone

Dell Latitude D830

Don't Panic (2007.08-2)

NVIDIA Quadro NVS 140M with proprietary NVIDIA drivers

ALSA with the snd_hda_intel module

Yes, with tg3 module

Yes, with iwl3965 module

Yes

Yes, with pm-utils

Untested

Dell Studio XPS M1640

(2009.08)

ATI HD4670 Mobile works with xf86-video-ati (see the forums for 3D
support); Catalyst drivers untested

Works with Intel HD Audio and ALSA.

Yes

Works with iwlagn

Bluetooth works

Works but when using xf86-video-ati, there is video corruption upon boot

N/A

Web cam works, media keys work with the dell_laptop kernel module, IR
works, card reader works

Everything basically worked out-of-the-box

Studio 1749

2013.01.04

Radeon HD 5650M, xf86-video-ati is almost flawless (just slower 3D),
catalyst is faster but has various issues.

HDA Intel MID, works with ALSA after adding
options snd-hda-intel index=0 model=dell-m6-dmic to
/etc/modprobe.d/alsa-base.conf. HDMI audio has some issues.

Yes

BCM43224, brcmsmac and broadcom-wl both work

N/A

Suspend works; hibernate untested.

N/A

SD card reader works, media keys work, web cam, and microphone both
work.

Flawless except for poor 3D performance and battery life.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Laptops/Dell&oldid=297814"

Category:

-   Hardware Compatibility List

-   This page was last modified on 15 February 2014, at 15:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
