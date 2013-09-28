HP Compaq nc6220
================

My plan when I finish is to have my laptop (HP Compaq nc6220) dual
booted with Windows XP Pro (work image). I repartitioned my hard drive
with Gparted Live CD. It only took a minute or so. I will be doing the
install with the arch 0.8 beta2 base cd. There is an installation guide
(0.7.2) that may help.I will do my best to give as much detail as
possible.

NOTE: Per HP's website, this laptop is Novell Linux Desktop 9 certified.
So getting Linux on this laptop should not be too hard.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 System Specifications                                              |
| -   2 What works/What does not                                           |
| -   3 Xorg                                                               |
|     -   3.1 Video Driver                                                 |
|         -   3.1.1 Mouse                                                  |
|         -   3.1.2 Compiz Fusion                                          |
|                                                                          |
| -   4 Audio                                                              |
| -   5 Network                                                            |
|     -   5.1 Wired                                                        |
|     -   5.2 Wireless                                                     |
|         -   5.2.1 Troubles with wireless                                 |
|                                                                          |
|     -   5.3 Modem                                                        |
|                                                                          |
| -   6 Card Readers                                                       |
|     -   6.1 PCMCIA                                                       |
|     -   6.2 Compact Flash                                                |
|     -   6.3 Secure Digital                                               |
|                                                                          |
| -   7 External Links                                                     |
+--------------------------------------------------------------------------+

> System Specifications

HP Compaq nc6220 - Intel Centrino

-   Intel Pentium M processor 750 (1.86-GHz, 533-MHz FSB, 2-MB L2 cache)
-   Mobile Intel 915GM Express Chipset
-   512-MB 533-MHz DDR2 SDRAM
-   60-GB 5400 rpm IDE ATA Harddrive
-   14.1-inch color TFT SXGA+ (1400 x 1050 resolution and 16 M colors)
-   Intel Graphics Media Accelerator 900 with up to 128 MB of shared
    system memory
-   ADI AC '97 CODEC
-   9.5-mm DVD/CD-RW Combo (Matshita UJDA775 IDE ATA 8x DVD/24x CDRW)
-   56K Fax/Modem
-   NetXtreme Gigabit PCI Express Ethernet Controller (10/100/1000 NIC)
-   Intel PRO/Wireless 2200BG 802.11b/g WLAN
-   One Type I/II PC Card Slot??
-   One Integrated Smart Card Reader??
-   One Integrated Secure Digital Slot??
-   Dual pointing devices (both Pointstick and Touchpad)
-   6-cell high capacity Lithium-Ion (52Wh)
-   External 65W adapter

  
 Output of lshwd

    00:00.0 Host bridge: Intel Corp.|Mobile Memory Controller Hub (intel-agp)
    00:02.0 VGA compatible controller: Intel Corp.|Mobile 915GM/GMS/910GML Express Graphics Controller (i810)
    00:02.1 Display controller: Intel Corp.|Mobile Graphics Controller (vesa)
    00:1c.0 PCI bridge: Intel Corp.|I/O Controller Hub PCI Express Port 0 (unknown)
    00:1c.1 PCI bridge: Intel Corp.|I/O Controller Hub PCI Express Port 1 (unknown)
    00:1d.0 USB Controller: Intel Corp.|I/O Controller Hub USB (unknown)
    00:1d.1 USB Controller: Intel Corp.|I/O Controller Hub USB (unknown)
    00:1d.2 USB Controller: Intel Corp.|I/O Controller Hub USB (unknown)
    00:1d.7 USB Controller: Intel Corp.|I/O Controller Hub USB2 (unknown)
    00:1e.0 PCI bridge: Intel Corp.|82801 Hub Interface to PCI Bridge (hw_random)
    00:1e.2 Multimedia audio controller: Intel Corp.|82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Audio Controller (snd-intel8x0)
    00:1e.3 Modem: Intel Corp.|I/OController Hub Modem (Hsf:www.linmodems.org)
    00:1f.0 ISA bridge: Intel Corp.|I/O Controller Hub LPC (i810-tco)
    00:1f.1 IDE interface: Intel Corp.|I/O Controller Hub PATA (piix)
    02:04.0 Network controller: Intel Corp.|Intel(R) PRO/Wireless 2200BG (ipw2200)
    02:06.0 CardBus bridge: Texas Instruments|Texas Instruments PCIxx21/x515 Cardbus Controller (yenta_socket)
    02:06.3 Mass storage controller: Texas Instruments|Texas Instruments PCIxx21 Integrated FlashMedia Controller (unknown)
    02:06.4 : Texas Instruments|Texas Instruments PCI6411, PCI6421, PCI6611, PCI6621, PCI7411, PCI7421, PCI7611, PCI7621 Secure Digital (SD) C (unknown)
    02:06.5 : Texas Instruments|Texas Instruments PCI6411, PCI6421, PCI6611, PCI6621, PCI7411, PCI7421, PCI7611, PCI7621 Smart Card Controller (unknown)
    10:00.0 Ethernet controller: Broadcom Corp.|NetXtreme BCM5751M Gigabit Ethernet PCI Express (tg3)
    004:001 USB Hub: Virtual|Hub (unknown)
    003:001 USB Hub: Virtual|Hub (unknown)
    002:001 USB Hub: Virtual|Hub (unknown)
    001:001 USB Hub: Virtual|Hub (unknown)

  

> What works/What does not

Pretty much everything works on this laptop except the SD-card reader. I
am still working on it. The screen needs a little tweaking to get the
full resolution and works great. Also I have not tried the modem (no
POTS line) or tried to suspend the laptop yet.

Xorg
----

> Video Driver

The NC6220 has an onboard Intel 9xx series VGA, supported by the
xf86-video-intel driver.

Mouse

There is a synaptic touchpad on this laptop. If you follow this howto,
you should have no problems getting this to work. It works great for me.
Note: Make sure you update the modules in /etc/rc.conf.

Compiz Fusion

This laptop supports Compiz Fusion. So I followed the wiki, and it
worked great.

Audio
-----

See ALSA.

Network
-------

> Wired

The wired connection worked out of the box. The NetworkManager, that we
will setup in the next section, will manage this as well as the
wireless.

> Wireless

To enable the blue wireless LED, add the following to
/etc/modprobe.d/modprobe.conf:

    options ipw2200 led=1

Troubles with wireless

The default BIOS settings maximize power savings by only allowing either
power to be given to the wireless card or the Ethernet card. Either
disable the "LAN/WLAN Switching" in the BIOS, eject the "tg3" module
when you want to use the wireless card, or unplug the Ethernet cable.

> Modem

Have not tried.

Card Readers
------------

> PCMCIA

As far as I have understood from other reports, the PCMCIA card works as
expected. I do not have one at this time, so I cannot confirm it.

> Compact Flash

The same goes for the Compact Flash. It is supposed to work as it uses
the same interfaces as the PCMCIA does, but I cannot confirm anything
since I do not have a CF-card.

> Secure Digital

The SD-card reader on the other hand is a pain! It uses proprietary
drivers from ricoh under Windows and there are no drivers under Linux. I
would really want this working but I think the only chance would be to
reverse engineer the reader and I guess not enough coders have this
device. Subsequently, there are no drivers now and there will not be in
the foreseeable future...

External Links
==============

-   This report is listed at the TuxMobil: Linux Laptop and Notebook
    Installation Guides Survey: Fujitsu-Siemens - FSC.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Compaq_nc6220&oldid=249599"

Category:

-   HP
