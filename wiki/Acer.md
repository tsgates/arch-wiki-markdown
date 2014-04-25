HCL/Laptops/Acer
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

TravelMate 2413NLC

Gimmick 0.7.2

Intel GMA 915 driver: i810

Intel 82801FB with internal microphone

OK

--

--

Suspend to RAM: Yes  
Disk: Yes  
Battery: Yes  
CPU frequency scaling: Yes

untested

Hot keys: untested

Aspire 5100-3825

0.8 (Voodoo)

ATI Radeon Xpress 1100

Intel

Realtek

Atheros

n/a

untested

Hot keys: untested

Aspire 1501LMi

0.9 (Don't Panic)

ATI Radeon 9600: HW acceleration only with proprietary driver

VIA: OK

Broadcom: OK

untested

none

Suspend to RAM: ??  
Disk: Yes  
Battery: Yes  
CPU frequency scaling: Yes

untested

Hot keys: untested

Travelmate 6292

Core Dump,  
Overlord

Intel x3100: HW acceleration with Intel's open-source driver, ~1100 FPS
in the glxgears

Intel HDA: OK (model=acer)

Broadcom BCM5787M: OK

Intel iwl4965: OK

Broadcom: OK

Suspend to RAM: ??  
Disk: Ok  
Battery: Yes  
CPU frequency scaling: Yes

untested

Hot keys: untested  
FireWire (Texas Instruments) TSB43AB23: OK(?)

FireWire detects well but I haven't tested it yet

Aspire 5024

0.7.2

ATI Radeon X700  
Runs Compiz on both fglrx (catalyst) >= 8.02 and radeon driver

AC97: OK

Realtek: OK

Broadcom 4318  
Needs acer_apci + firmware or ndiswrapper driver

N/A

Battery: Yes  
Suspend: Video and Wi-Fi problems  
CPU frequency scaling: powernow-k8 driver

untested

KeyTouch works for hot keys  
Volume control, etc.

Aspire 7720

2009.02

Intel i965

ALC268: working OK

Broadcom BCM5787M (tg3): OK

Intel 3945: Needs microcode

Detected, works

Battery: Yes  
Suspend: Seems to work ok  
Hibernation: still flaky (often hangs in the middle of restoring)

With linuxant drivers, might work

Web cam driver: uvcvideo; card reader: only SD cards seem to work;
special keys (Acer Arcade, direct access to browser/mail) seem to not
work; volume knob at the side is seen as a multimedia key.

FireWire seems to be recognized, untested. For 64-bit, update BIOS to
fix ACPI and wireless problems.

Aspire 7730

2009.08 i686 & x86_64

Intel Mobile 4 Series  
i810  
Autoconfiguration works. Compiz OK, with indirect rendering.

ALC888  
Playback & internal microphone: OK; microphone input socket: not
tested  
options snd-hda-intel model=laptop added to /etc/modprobe.d/sound.conf
to get headphone output working

OK

OK, with iwlagn

None

Suspend to RAM: OK  
Suspend to disk crashes on i686, OK on x86_64  
CPU frequency scaling: OK  
(using cpufreq)

Untested

Hot keys: OK  
Web cam: OK  
HDMI: untested  
Card reader: untested

Problem booting install CD  
Solved with ln -sf /dev/sr0 /dev/archiso at ramfs

TravelMate 8371G (TM8371G-944G32n)

2010.05 x86_64

Intel GM45, works with i915. Radeon HD 4330 listed but cannot switch to
it.

OK

OK, works with r8169

OK, works with iwlagn

OK, works with btusb

s2ram works (see remarks), s2disk works, CPU scaling works, no fan
control

No modem

Web cam works with uvcvideo.  
Card reader works.  
Fingerprint reader does not seem to have a driver!

Suspend to RAM only works with the i8042.reset=1 kernel parameter.
Otherwise, it fails to wake up, and ends up rebooting itself
uncleanly!  
Generally, this Acer seems to work quite well with Arch Linux :-)

Aspire 4935

2009.08 x86_64

Nvidia GeForce 9300M GS

OK, Intel HDA

OK

OK

Untested

Suspend to RAM: OK  
Suspend to disk: OK  
Frequency scaling: OK  
(using cpufreq)

Untested

Hot keys: OK  
Audio touch panel NOT working   
Web cam: OK  
HDMI: OK

By "audio touch panel" I mean the illuminated plastic hot key touch
panel on the right-hand side of the keyboard.

AspireOne D255e

Archboot 2010.12-1

Intel GMA 3150

OK

OK, Atheros 8132 worked only with latest Archboot not official images

OK, Broadcom worked only with latest Archboot not official images

Untested

Untested

Untested

Hot keys: OK  
Synaptic Touchpad: OK

Aspire 2920Z

2009.2

Intel Mobile GM965/GL960 Integrated Graphics Controller

OK, Intel 82801H

OK, Broadcom NetLink BCM5787M Gigabit Ethernet PCI Express

OK, Broadcom BCM4311 802.11b/g WLAN

n/a

Suspend to RAM: OK.  
Suspend to disk: OK.  
CPU frequency scaling: untested

Untested

Hot keys: web, mail, and wireless work. Blue e on the left: not
working  
Synaptic touchpad: OK  

Not everything worked fine on fresh installation. Requires some work.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Laptops/Acer&oldid=289405"

Category:

-   Hardware Compatibility List

-   This page was last modified on 19 December 2013, at 05:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
