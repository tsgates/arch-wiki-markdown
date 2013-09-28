HCL/Laptops/HP
==============

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

Model Version
=============

  
  
  
  
  
  
  
  
  

Model Version:

Arch Linux   
Install CD Version:  

Hardware Support:

Remark:

Video:

Sound:

Ethernet:

Wireless:

Bluetooth:

Power  
Management:  

Modem:

Other:

HP Compaq Mini 730

2009.02

Intel GMA 950  
driver: intel

Intel HDA   
driver: snd_hda_intel

Broadcom  
driver: tg3

Broadcom 4312  
driver: wl

Yes

Suspend to  
RAM: Yes  
Disk: Yes  
Battery: Yes  
Dimming of display: Yes  
Frequency scaling of CPU: Yes

  

  

HP Compaq 6715S

2010.05

ATI Radeon X1250  
driver: catalyst

AD1981   
driver: snd_hda_intel

Broadcom  
driver: tg3

Broadcom 4312  
driver: ndiswrapper   
 (Problematic with 64-bit arch)

Yes

Suspend to  
RAM: Yes  
Disk: Yes  
Battery: Yes  
Dimming of display: Yes  
Frequency scaling of CPU: Yes

not tested

Hotkeys: Yes   
 Lightscribe: untested   

HP Compaq 6720S

2009.2

Intel X3100  
driver: xf86-video-intel

Intel HDA  
driver: snd_hda_intel

Intel 10/100  
driver: e1000e

Intel 3945  
driver: iwl3945   
 Broadcom 4312  
driver: wl AUR

Yes, bluez-utils

ACPI: Yes  
Suspend to  
RAM: Yes  
Disk: Yes  
Battery: Yes  
Dimming of display: Yes  
Frequency scaling of CPU: Yes, cpudyn

not tested

Hotkeys: Configurable  
 Lightscribe: Yes AUR   

Pavilion DV2172EA

Duke 2007.05

Nvidia Go7200  
driver nvidia

Intel 82801G  
with internal microphones  
driver snd_hda_intel

Yes  
driver e100

Intel 3945  
driver ipw3945

Yes

Suspend to  
RAM: Yes  
Disk: Yes  
Battery: Yes  
Dimming of display: Yes  
Frequency scaling of CPU: Yes

Yes

Hotkeys: Yes  
Remote: Yes  
Webcam: Yes  
(uvcvideo)  
IRDA: Yes  
Lightscribe: untested

Pavilion DM1-1150SL

2009.02

Intel X4500MHD  
driver   
xf86-video-intel  

Intel 82801G  
with internal microphones  
driver snd_hda_intel

Yes(RTL8101E)  
driver r8169

Atheros AR9285  
driver ath9k

Yes

Suspend to  
RAM: Yes  
Disk: Yes  
Battery: Yes  
Dimming of display: Yes  
Frequency scaling of CPU: n/a

Yes

Hotkeys: Yes  
Webcam: Yes  
(uvcvideo)  

HP Pavilion dv5055ea

2009.06

ATI Radeon XPRESS 200M

ATI IXP SB400 AC'97 Audio Controller (rev 02)

Realtek RTL-8139/8139C/8139C+ (rev 10)

Broadcom Corporation BCM4318 [AirForce One 54g] 802.11g Wireless LAN
Controller (rev 02)

N/A

Suspend to RAM: not tested  
Suspend to Disk: not tested  
Battery: Yes  
Dimming of display: Yes  
Frequency scaling of CPU: Odd on battery, Yes on AC

not tested

Hotkeys: Yes for Sound and WLAN. and no for DVD and Multimedia button

HP Pavilion dv6605ed

2007.08-2

Intel X3100 (xf86-video-intel)

Intel 82801H (snd-hda-intel)

RTL8101e (r8139)

Broadcom BCM94311MCG  
b43: No (may need different firmware)  
ndiswrapper: Yes

N/A

ACPI: Yes  
Suspend to RAM: Yes  
Suspend to Disk: No  
Battery: Yes  
Display dimming: Yes  
CPU frequency scaling: Yes (p4-clockmod)

not tested

Hotkeys: Yes (HP keymap)  
Remote: Yes, except for DVD, Quickplay and Windows MCE buttons  
Lightscribe: not tested

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

Hotkeys: Yes  
Lightscribe: not tested

HP Pavilion TX1220US(GA647UA)

Overlord

nVidia Gefore Go 6150 (works with nvidia)

nVidia Corporation MCP51 High Definition Audio (works with
snd-hda-intel)

nVidia Corporation MCP51 Ethernet Controller (works with forcedeth)

Broadcom 4321 card (works with ndiswrapper and Broadcom released linux
drivers: pkg)

not tested

not tested

not tested

Touch Screen (appears to work, have not calibrated)  
Remote (not working)  
Hotkeys (not tested)  
 Lightscribe (not tested)

People with this same laptop have gotten the hotkeys and touch screen to
work on other distros. I'm sure you can figure it out with some work :-)

HP 8510W

2008

NVIDIA FX570M (nvidia driver

Intel soundcard (snd-hda-intel)

Ethernet Port (e1000)

Intel Wireless (iwl4965)

ACPI: Yes  
Suspend to RAM: Yes  
 Suspend to Disk: Yes   
Battery: Yes  
Display Dimming: Yes (using nvclock)  
 CPU frequency scaling:Yes (acpi-cpufreq)

not tested

Hotkey: Yes   
 DVD/CD: Yes  
 SD-Slot: Yes  
Touchkeys: Yes  
 Firewire: Untested  

HP tx2z

2009.08

Radeon HD 3200  
driver: radeon

Intel HDA  
driver: snd-hda-intel

RTL8111/8168B  
driver: r8169

Broadcom 4322  
driver: wl AUR

not tested

not tested

not tested

hotkeys: yes  
lightscribe: not tested  
webcam: yes  
touchscreen: works  
stylus: still working on  
Media reader: works

some known successes with touchscreen and stylus in ubuntu

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
--  
--  
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
Works well with open source radeon driver

Intel HDA  
driver: snd-hda-intel

unknown

Broadcom Wireless  
works OOTB

not tested

ACPI: Yes  
Suspend to RAM: No  
Suspend to Disk: Yes, with TuxOnIce  
Battery: Yes  
Remote: Some buttons do not work  
Display Dimming: Yes  
 CPU Freq Scaling: Yes, with K8 Driver

not tested

hotkeys: yes  
Lightscribe: not tested  
Webcam: yes  

To prevent output to both headphones and speakers simultaneously, add
options snd-hda-intel model=hp-dv5 to /etc/modprobe.d/modprobe.conf

HP 625

2010.05

Radeon HD 4200 series   
driver: radeon   
driver: catalyst

ATI Technologies Inc RS880 Audio Device   
driver: snd-hda-intel

RTL8101E/8102E   
driver: r8169

Broadcom BCM4313   
driver: brcmsmac

not tested

ACPI: Yes  
Suspend to RAM: Yes  
Suspend to Disk: Yes   
Battery: Yes   
Display Dimming: Yes  
 CPU Freq Scaling: Yes

not tested

Hotkeys: yes   
Lightscribe: untested   
Webcam: yes   
Cardreader: yes

brcmsmac >= kernel 2.6.37

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Laptops/HP&oldid=196345"

Category:

-   Hardware Compatibility List
