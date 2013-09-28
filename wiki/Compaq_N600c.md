Compaq N600c
============

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 System Specifications                                              |
| -   2 What works and does not work                                       |
| -   3 Video Driver                                                       |
| -   4 Mouse                                                              |
| -   5 Sound                                                              |
| -   6 Modem                                                              |
| -   7 Ethernet                                                           |
| -   8 Special keys                                                       |
| -   9 SSE2                                                               |
+--------------------------------------------------------------------------+

> System Specifications

-   Pentium III M processor (Code name Coppermine)
-   CPU clock speed 866MHz or 1.066GHz (depending on model)
-   Maximum SDRAM 1024MBytes
-   ATI Mobility Radeon, 4x AGP
-   14.1 inch display 1048x768
-   Built in 10/100 BaseT Ethernet port
-   Built in V.90 modem
-   2 x PCMCIA card slots
-   1 x multiport bay for CDROM / DVD drive or other types of
    perhiperals
-   2 x external USB ports
-   1 x VGA interface
-   1 x RS232 serial port
-   1 x PS2 mouse interface
-   1 x Docking port for interfacing to compaq docking station,

Output of lspci

    00:00.0 Host bridge: Intel Corporation 82830M/MG/MP Host Bridge (rev 02)
    00:01.0 PCI bridge: Intel Corporation 82830M/MP AGP Bridge (rev 02)
    00:1d.0 USB controller: Intel Corporation 82801CA/CAM USB Controller #1 (rev 01)
    00:1d.1 USB controller: Intel Corporation 82801CA/CAM USB Controller #2 (rev 01)
    00:1d.2 USB controller: Intel Corporation 82801CA/CAM USB Controller #3 (rev 01)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 41)
    00:1f.0 ISA bridge: Intel Corporation 82801CAM ISA Bridge (LPC) (rev 01)
    00:1f.1 IDE interface: Intel Corporation 82801CAM IDE U100 Controller (rev 01)
    01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI RV100 LY [Mobility Radeon 7000]
    02:03.0 CardBus bridge: Texas Instruments PCI1420 PC card Cardbus Controller
    02:03.1 CardBus bridge: Texas Instruments PCI1420 PC card Cardbus Controller
    02:04.0 Communication controller: LSI Corporation LT WinModem (rev 02)
    02:08.0 Ethernet controller: Intel Corporation 82801CAM (ICH3) PRO/100 VM (KM) Ethernet Controller (rev 41)
    02:09.0 Multimedia audio controller: ESS Technology ES1988 Allegro-1 (rev 12)

> What works and does not work

Everything appears to work from a standard installation of Arch linux.

> Video Driver

At boot the radeon driver is loaded and the kernel supports KMS; so the
console is set at 1024 x 768.

> Mouse

Built in touch pad uses the "synaptics" mouse driver.

> Sound

Kernel driver used is snd_maestro3.

There appears to be an initialisation issue that means sometimes no
sound comes out of the speakers after boot. I've found that using
alsamixer to raise and then lower the volume by a small amount fixes the
problem.

> Modem

Untested

> Ethernet

Kernel driver used is e100.

ethtool suggests that the Ethernet hardware supports Wake on LAN, but I
have not tested this.

> Special keys

    - XF86WWW
    - XF86Mail
    - XF86Search
    - XF86Home

> SSE2

The pentium III does not support the SSE2 instruction set, which means
that its not possible to run the lastest flash plugin from Adobe, or the
linux build of Spotify. In both cases, there is an exception due to
illegal instruction execution (SSE2 instruction). As yet cant see a way
round this (other that building a new laptop).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Compaq_N600c&oldid=227892"

Category:

-   HP
