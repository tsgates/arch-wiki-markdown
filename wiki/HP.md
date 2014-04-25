HCL/Laptops/HP
==============

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

HP EliteBook 2570p

2011.12

Intel HD 4000 driver: i915

Intel HDA driver: snd_hda_intel

Intel 82579LM driver: e1000e

Intel 6250 driver: iwlwifi

Yes

Suspend to RAM: Yes  
Disk: Yes  
Battery: Yes  
Dimming of display: Yes  
Frequency scaling of CPU: Yes

not tested

smart card reader

has xHCI IRQ issues

HP Compaq Mini 730

2009.02

Intel GMA 950 driver: intel

Intel HDA driver: snd_hda_intel

Broadcom driver: tg3

Broadcom 4312 driver: wl

Yes

Suspend to RAM: Yes  
Disk: Yes  
Battery: Yes  
Dimming of display: Yes  
Frequency scaling of CPU: Yes

--

--

--

HP Compaq 6715S

2010.05

ATI Radeon X1250 driver: catalyst

AD1981 driver: snd_hda_intel

Broadcom driver: tg3

Broadcom 4312 driver: ndiswrapper   
 (Problematic with 64-bit CPU)

Yes

Suspend to RAM: Yes  
Disk: Yes  
Battery: Yes  
Dimming of display: Yes  
Frequency scaling of CPU: Yes

not tested

Hot keys: Yes   
 LightScribe: untested

--

HP Compaq 6720S

2009.2

Intel X3100 driver: xf86-video-intel

Intel HDA driver: snd_hda_intel

Intel 10/100 driver: e1000e

Intel 3945 driver: iwl3945   
 Broadcom 4312 driver: wl broadcom-wl

Yes, bluez-utils

ACPI: Yes  
Suspend to RAM: Yes  
Disk: Yes  
Battery: Yes  
Dimming of display: Yes  
Frequency scaling of CPU: Yes, cpudyn

not tested

Hot keys: Configurable  
 LightScribe: Yes lightscribe

--

Pavilion DV2172EA

Duke 2007.05

Nvidia Go7200 driver nvidia

Intel 82801G with internal microphones driver: snd_hda_intel

Yes  
driver: e100

Intel 3945 driver: ipw3945

Yes

Suspend to RAM: Yes  
Disk: Yes  
Battery: Yes  
Dimming of display: Yes  
Frequency scaling of CPU: Yes

Yes

Hot keys: Yes  
Remote: Yes  
Webcam: Yes (uvcvideo)  
IRDA: Yes  
LightScribe: untested

--

Pavilion DM1-1150SL

2009.02

Intel X4500MHD driver: xf86-video-intel

Intel 82801G with internal microphones driver: snd_hda_intel

Yes (RTL8101E) driver: r8169

Atheros AR9285 driver: ath9k

Yes

Suspend to RAM: Yes  
Disk: Yes  
Battery: Yes  
Dimming of display: Yes  
Frequency scaling of CPU: N/A

Yes

Hot keys: Yes  
Webcam: Yes (uvcvideo)

--

HP Pavilion dv5055ea

2009.06

ATI Radeon XPRESS 200M

ATI IXP SB400 AC'97 Audio Controller (rev 02)

Realtek RTL-8139/8139C/8139C+ (rev 10)

Broadcom BCM4318 (AirForce One 54g) 802.11g Wireless LAN Controller (rev
02)

N/A

Suspend to RAM: not tested  
Suspend to Disk: not tested  
Battery: Yes  
Dimming of display: Yes  
Frequency scaling of CPU: Odd on battery, Yes on A/C

not tested

Hot keys: Yes, for sound and WLAN. No, for DVD and Multimedia button

--

HP Pavilion dv6605ed

2007.08-2

Intel X3100 (xf86-video-intel)

Intel 82801H (snd-hda-intel)

RTL8101e (r8139)

Broadcom BCM94311MCG driver b43: No (may need different firmware)  
ndiswrapper: Yes

N/A

ACPI: Yes  
Suspend to RAM: Yes  
Suspend to Disk: No  
Battery: Yes  
Display dimming: Yes  
CPU frequency scaling: Yes (p4-clockmod)

not tested

Hot keys: Yes (HP keymap)  
Remote: Yes, except for DVD, Quickplay, and Windows MCE buttons  
LightScribe: not tested

--

HP Pavilion dv9530em

2009.06

nVidia GeForce 8400M GS

Realtek ALC268

RTL8168b/8111b

Intel 3945 (iwl3945)

yes

Suspend to RAM: Yes  
Suspend to Disk: Yes  
Battery: Yes  
Dimming of display: Yes  
Frequency scaling of CPU: Yes

not tested

Hot keys: Yes  
LightScribe: not tested

--

HP Pavilion TX1220US (GA647UA)

Overlord

nVidia GeForce Go 6150 (works with nvidia)

nVidia MCP51 HD Audio (works with snd-hda-intel)

nVidia MCP51 Ethernet Controller (works with forcedeth)

Broadcom 4321 card (works with ndiswrapper and Broadcom-released Linux
driver: broadcom-wl)

not tested

not tested

not tested

Touch screen: (appears to work; have not calibrated)  
Remote: not working  
Hot keys: not tested  
LightScribe: not tested

People with this same laptop have gotten the hot keys and touch screen
to work on other distributions.

HP 8510W

2008

NVIDIA FX570M (nvidia driver)

Intel sound card: snd-hda-intel)

e1000

Intel wireless: iwl4965

--

ACPI: Yes  
Suspend to RAM: Yes  
 Suspend to Disk: Yes   
Battery: Yes  
Display dimming: Yes (using nvclock)  
 CPU frequency scaling: Yes (acpi-cpufreq)

not tested

Hot keys: Yes   
 DVD/CD: Yes  
 SD slot: Yes  
Touchkeys: Yes  
 FireWire: untested

--

HP tx2z

2009.08

Radeon HD 3200 driver: radeon

Intel HDA driver: snd-hda-intel

RTL8111/8168B driver: r8169

Broadcom 4322 driver: broadcom-wl

not tested

not tested

not tested

Hot keys: yes  
LightScribe: not tested  
webcam: yes  
touchscreen: works  
stylus: still working on  
Media reader: works

some known successes with touchscreen and stylus in Ubuntu

HP Pavilion DV3-2155MX

2010.05

--

--

--

--

--

--

--

--

--

HP Pavilion dv6-2115sa

2010.05

Radeon HD 4200 series  
Works well with open-source Radeon driver

Intel HDA driver: snd-hda-intel

unknown

Broadcom wireless works out-of-the-box

not tested

ACPI: Yes  
Suspend to RAM: No  
Suspend to Disk: Yes, with TuxOnIce  
Battery: Yes  
Remote: Some buttons do not work  
Display dimming: Yes  
 CPU frequency scaling: Yes, with K8 Driver

not tested

Hot keys: yes  
LightScribe: not tested  
Webcam: yes

To prevent output to both headphones and speakers simultaneously, add
options snd-hda-intel model=hp-dv5 to /etc/modprobe.d/modprobe.conf

HP 625

2010.05

Radeon HD 4200 series drivers: radeon or catalyst

ATI RS880 Audio Device driver: snd-hda-intel

RTL8101E/8102E driver: r8169

Broadcom BCM4313 driver: brcmsmac (in kernel)

not tested

ACPI: Yes  
Suspend to RAM: Yes  
Suspend to Disk: Yes  
Battery: Yes  
Display dimming: Yes  
CPU frequency scaling: Yes

not tested

Hot keys: yes   
LightScribe: untested   
Webcam: yes   
Card reader: yes

--

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Laptops/HP&oldid=289406"

Category:

-   Hardware Compatibility List

-   This page was last modified on 19 December 2013, at 05:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
