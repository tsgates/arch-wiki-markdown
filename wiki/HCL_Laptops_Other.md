HCL/Laptops/Other
=================

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

Clevo M350

Noodle

Yes

AC'97 with ALSA

Yes

n/a

n/a

Suspend-to-RAM yes, Suspend-to-disk no

Yes, with slmodem

IEEE-1394 not tested

Front Panel keys doesn't work

Clevo W150HRM

2011.08.19

Intel 950GMA and Nvidia Optimus (Bumblebee works)

Intel HDA (OK)

Yes

Yes

Not tested

-

-

-

-

Clevo W110ER (April 2013)

2013.04.01

Intel HD Graphics 4000 (i915) and Nvidia GeForce GT 650M with Optimus
(nvidia).

HDMI out works.

Bumblebee (3.1-6) works with primus.

bbswitch (bbswitch-dkms-git from AUR, mid-April 2013) is unable to power
down the GT 650M to D3cold, but ACPI does that on its own.

ALSA (snd_hda_intel) and PulseAudio

Integrated microphone works.

HDMI audio out works.

Analog headphone out works if the "Independent HP" switch in alsamixer
is set to Off.

External microphone jack not tested.

Realtek 8168 (r8169), works.

Intel Centrino Advanced-N 6235 (iwlwifi), unreliable on 802.11n. A
workaround is to disable 802.11n with module parameter "11n_disable=1".

Intel Centrino Advanced-N 6235, works after an initial "sudo hciconfig
hci0 up" which persists after reboot.

Suspend (disk and ram) sporadically fails on kernel 3.8.7-1 with dmesg
showing "Freezing of tasks failed after 20.01 seconds (0 tasks refusing
to freeze, wq_busy=1)".

On linux 3.8.7-1-ck with bfq scheduler standby works reliably.

n/a

Webcam works (uvcvideo).

All Fn-keys work.

Screen brightness control works.

Touchpad works with multitouch support.

Card reader Realtek 5289 works (rtsx_pci).

USB3.0 not tested.

A highly Linux-friendly machine. Tested only in BIOS mode, not in UEFI.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Laptops/Other&oldid=254610"

Category:

-   Hardware Compatibility List
