Dell Inspiron 1420
==================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The Inspiron 1420 runs both 32 and 64-bit versions of Arch beautifully.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware Specifications                                            |
|     -   1.1 lspci Output                                                 |
|     -   1.2 lsusb Output                                                 |
|     -   1.3 lshw Output                                                  |
|                                                                          |
| -   2 Kernel                                                             |
| -   3 Networking                                                         |
|     -   3.1 Wired                                                        |
|     -   3.2 Wireless                                                     |
|         -   3.2.1 Broadcom Corporation BCM4315 802.11 Wireless           |
|             Controller                                                   |
|         -   3.2.2 Broadcom Corporation BCM4328 802.11 Wireless           |
|             Controller                                                   |
|         -   3.2.3 Intel Corporation PRO/Wireless 3945ABG Network         |
|             Connection                                                   |
|                                                                          |
|     -   3.3 Modem                                                        |
|                                                                          |
| -   4 Xorg                                                               |
| -   5 Webcam                                                             |
+--------------------------------------------------------------------------+

Hardware Specifications
-----------------------

-   Model: Dell Inspiron 1420
-   Processor:
    -   Intel(R) Core(TM)2 Duo T5850 (2 x 2.16GHz, 667Mhz FSB, 2MB L2
        Shared Cache, 32-bit/64-bit) or
    -   Intel(R) Core(TM)2 Duo T7100 (2 x 1.8GHz, 800Mhz FSB, 2MB L2
        Shared Cache, 32-bit/64-bit) or
    -   Intel(R) Core(TM)2 Duo T5450 (2 x 1.6GHz, 667Mhz FSB, 2MB L2
        Shared Cache, 32-bit/64-bit) or

-   Memory: 3GB 667MHz DDR2 or
-   Memory: 2GB 667MHz DDR2
-   Video Card:
    -   128MB nVidia GeForce 8400M GS or
    -   Intel Corporation Mobile X3100 Integrated Graphics Controller

-   Hard Drive: Hitachi HTS72201 SATA 160GB/120GB 5400 or 7200 RPM
-   Optical Drive: TSSTcorp DVD+-RW TS-L632H
-   Display: Anti-glare 14.1" WXGA (1280x800) or Glossy High Resolution
    (1440x900)
-   Network Adapter: Broadcom Corporation NetLink BCM5906M Fast Ethernet
    PCI Express
-   Wireless Adapter:
    -   Broadcom Corporation BCM4315 802.11 Wireless Controller or
    -   Intel Corporation PRO/Wireless 3945ABG Network Connection

-   Sound: Intel Corporation 82801H (ICH8 Family) HD Audio Controller
-   Cardbus: Ricoh Co Ltd RL5c476 II
-   USB1: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller
-   USB2: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller
-   Firewire: Ricoh Co Ltd R5C832 IEEE 1394 Controller
-   SD Host Controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host
    Adapter
-   Integrated Webcam: OmniVision Technologies, Inc. 2 Megapixel Webcam

> lspci Output

    00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
    00:01.0 PCI bridge: Intel Corporation Mobile PM965/GM965/GL960 PCI Express Root Port (rev 0c)
    00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Contoller #4 (rev 02)
    00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 02)
    00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 02)
    00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02)
    00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 02)
    00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 4 (rev 02)
    00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 02)
    00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f2)
    00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 02)
    00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 02)
    00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 02)
    00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
    01:00.0 VGA compatible controller: nVidia Corporation GeForce 8400M GS (rev a1)
    03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 05)
    03:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
    03:01.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 12)
    03:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 12)
    03:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev ff)
    09:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5906M Fast Ethernet PCI Express (rev 02)
    0c:00.0 Network controller: Broadcom Corporation BCM4310 USB Controller (rev 01)

> lsusb Output

    Bus 004 Device 003: ID 05a9:2640 OmniVision Technologies, Inc. 
    Bus 004 Device 001: ID 1d6b:0002  
    Bus 007 Device 001: ID 1d6b:0001  
    Bus 002 Device 001: ID 1d6b:0002  
    Bus 006 Device 001: ID 1d6b:0001  
    Bus 005 Device 001: ID 1d6b:0001  
    Bus 003 Device 001: ID 1d6b:0001  
    Bus 001 Device 001: ID 1d6b:0001  

> lshw Output

    lshw output can be found here.
    00:00.0 Class 0600: Intel Corporation|Mobile Memory Controller Hub (unknown)
    00:01.0 Class 0604: Intel Corporation|Mobile PCI Express Root Port (unknown)
    00:1a.0 Class 0c03: Intel Corporation|USB UHCI Controller #4 (unknown)
    00:1a.1 Class 0c03: Intel Corporation|USB UHCI Controller #5 (unknown)
    00:1a.7 Class 0c03: Intel Corporation|USB2 EHCI Controller #2 (unknown)
    00:1b.0 Class 0403: Intel Corp.|ICH8 HD Audio DID (snd-hda-intel)
    00:1c.0 Class 0604: Intel Corporation|PCI Express Port 1 (unknown)
    00:1c.1 Class 0604: Intel Corporation|PCI Express Port 2 (unknown)
    00:1c.3 Class 0604: Intel Corporation|PCI Express Port 4 (unknown)
    00:1c.5 Class 0604: Intel Corporation|PCI Express Port 6 (unknown)
    00:1d.0 Class 0c03: Intel Corporation|USB UHCI Controller #1 (unknown)
    00:1d.1 Class 0c03: Intel Corporation|USB UHCI Controller #2 (unknown)
    00:1d.2 Class 0c03: Intel Corporation|USB UHCI Controller #3 (unknown)
    00:1d.7 Class 0c03: Intel Corporation|USB2 EHCI Controller #1 (unknown)
    00:1e.0 Class 0604: Intel Corp.|82801 Hub Interface to PCI Bridge (hw_random)
    00:1f.0 Class 0601: Intel Corporation|Mobile LPC Interface Controller (unknown)
    00:1f.1 Class 0101: Intel Corporation|Mobile IDE Controller (piix)
    00:1f.2 Class 0106: Intel Corporation|Mobile SATA Controller cc=AHCI (ahci)
    00:1f.3 Class 0c05: Intel Corporation|SMBus Controller (i2c-i801)
    01:00.0 Class 0300: Intel Corporation|SMBus Controller (vesa)
    03:01.0 Class 0c00: Intel Corporation|SMBus Controller (unknown)
    03:01.1 Class 0805: Ricoh Co Ltd.|SD Card reader (unknown)
    03:01.2 Class 0880: Ricoh Co Ltd.|R5C592 Memory Stick Bus Host Adapter (unknown)
    03:01.3 Class 0880: Ricoh Co Ltd.|xD-Picture Card Controller (unknown)
    09:00.0 Class 0200: Ricoh Co Ltd.|xD-Picture Card Controller (unknown)
    0c:00.0 Class 0280: Intel Corporation|PRO/Wireless 3945ABG (ipw3945)

All works flawlessly

Kernel
------

The stock Arch kernel works just fine.  
  
 A working custom kernel configuration with tuxonice patches applied can
be found here.

Networking
----------

> Wired

Works out of the box. The BCM5906M uses the tg3 (Tigon 3) kernel module
which was loaded automatically for me. If it doesn't, try loading it
manually with:

    modprobe tg3

> Wireless

Wireless Setup contains good general information about setting up
wireless in Arch.

Broadcom Corporation BCM4315 802.11 Wireless Controller

The Broadcom BCM4312 page has a nice guide on setting up this
controller.

Broadcom Corporation BCM4328 802.11 Wireless Controller

As of 08/06/09, the only linux driver that works with this chip is the
broadcom-wl package which can be found in the AUR.

Intel Corporation PRO/Wireless 3945ABG Network Connection

Included in linux and linux-firmware

> Modem

I have not tried the modem to see if it works. I know that the 1420N
(Pre-loaded with Ubuntu) has drivers for it but I do not know if the
code for that is open or not. More to follow.

Xorg
----

After this run nvidia-xconfig and you're done. Go play Chrono Trigger on
zsnes or go see the Nvidia drivers page on the Archwiki for more cool
options.

Don't forget the synaptics driver, or you won't be able to use the cool
mousepad scroll.

     # pacman -S xf86-input-synaptics

If you have the Nvidia 8400GS graphics card, I recommend the
nvidia-173xx driver unless you like your laptop to sound like a jet.

     # pacman -S nvidia-173xx

Webcam
------

Install uvc from the community repo, and add your user to the video
group

      pacman -S linux-uvc-svn

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Inspiron_1420&oldid=196557"

Category:

-   Dell
