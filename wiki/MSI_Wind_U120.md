MSI Wind U120
=============

This article pertains to installing Arch Linux on the MSI Wind U120
netbook. It does not cover the entire installation process, but rather
any quirks that are above and beyond what you might encounter during a
routine Arch installation.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware Specifications                                            |
|     -   1.1 Base Components                                              |
|     -   1.2 Additional Options                                           |
|     -   1.3 lspci output                                                 |
|                                                                          |
| -   2 Installation                                                       |
|     -   2.1 Dual Boot Windows/Linux                                      |
|     -   2.2 Kernel Modules (Drivers)                                     |
|     -   2.3 AHCI SATA Mode                                               |
|                                                                          |
| -   3 Advanced Configuration                                             |
|     -   3.1 Touchpad                                                     |
|     -   3.2 Hotkeys                                                      |
|     -   3.3 Webcam Usage                                                 |
|     -   3.4 Hard Drive Clicking/Ticking                                  |
|                                                                          |
| -   4 Tips & Tricks                                                      |
|     -   4.1 More on Hotkeys                                              |
|                                                                          |
| -   5 More Resources                                                     |
+--------------------------------------------------------------------------+

Hardware Specifications
-----------------------

The MSI Wind U120 is known to ship with a few different
configurations...

> Base Components

-   1.6GHz Intel Atom N270 "Diamondville" Processor
-   1GB DDR2 RAM @ 533MHz
-   Intel i945GSE northbridge chipset (graphics and memory management)
-   Intel 82801GHM (ICH7M) southbridge chipset (audio and other
    peripherals)
-   160GB SATA HDD 5400RPM (WDC WD1600BEVTY-22ZCT0)
-   Realtek RTL8101E Ethernet adaptor
-   Realtek RTL8187SE Wireless (b/g modes)
-   BisonCam NB Pro 1.3 megapixel webcam

> Additional Options

-   3G network capabilities
-   Bluetooth adaptor

> lspci output

Hardware components as reported by lspci:

    00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03)
    00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03)
    00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
    00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
    00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
    00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
    00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
    00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA AHCI Controller (rev 02)
    01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
    02:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8187SE Wireless LAN Controller (rev 22)

Installation
------------

Consult the standard documentation (official and unofficial) on Arch
Linux installation for general installation steps. What follows are
items of particular interest to U120 owners.

> Dual Boot Windows/Linux

The U120 ships with three partitions (sizes are approximate):

-   4GB hidden partition containing system recovery information
-   35GB Windows XP Home system partition
-   90GB empty partition for general storage

If you wish to retain Windows XP, choose the manual partition method
during the Arch installation and change only the third partition (sda3).
You can also use a partition management program to resize the Windows XP
partition before installing Arch Linux. This author used a GParted Live
CD to reduce the XP partition to 25GB prior to installing Arch.

> Kernel Modules (Drivers)

For the most part the hardware should Just Work™. Hardware-specific
modules include:

    i915            intel graphics
    r8169           realtek ethernet
    rtl8187se       realtek wifi 
    snd_hda_intel   intel audio
    uvcvideo        bisoncam nb pro webcam

-   i915 - you will, of course, need to install the xf86-video-intel
    package and configure Xorg for a proper desktop.
-   uvcvideo - you may need to add this module to the MODULES array in
    /etc/rc.conf for automatic loading.

> AHCI SATA Mode

The U120 supports the AHCI SATA specification, however this feature is
disabled in the BIOS by default. To enable AHCI during setup:

-   Add "ahci" to the MODULES array in /etc/mkinitcpio.conf
-   Once Arch installation is complete, reboot and enter the BIOS
-   Change AHCI Mode to "Enabled"

Note: To enable AHCI after installation:

-   Add "ahci" to the MODULES array in /etc/mkinitcpio.conf
-   Run the following as root:

    # mkinitcpio -p linux

-   Reboot and enter the BIOS
-   Change AHCI Mode to "Enabled"

Check dmesg output for confirmation. You should see something like this:

    ahci 0000:00:1f.2: version 3.0
    ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
    ahci 0000:00:1f.2: irq 26 for MSI/MSI-X
    ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x5 impl SATA mode
    ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
    ahci 0000:00:1f.2: setting latency timer to 64
    scsi0 : ahci
    scsi1 : ahci
    scsi2 : ahci
    scsi3 : ahci

Advanced Configuration
----------------------

> Touchpad

For touchpad functionality, install the Synaptics touchpad drivers as
per the Beginners Guide and Touchpad Synaptics articles.

> Hotkeys

Most hotkeys are properly detected by the kernel out-of-the-box and XF86
aliases (XF86AudioMute, etc.) are automatically assigned to most hotkeys
as well . The following hotkeys do not produce keycodes, however they do
function as intended:

-   Fn+F6 (webcam)
-   Fn+F10 (eco mode)

For more information on the U120 hotkeys, refer to the Tips & Tricks:
More on Hotkeys section below.

> Webcam Usage

To load the webcam driver automatically you may need to add uvcvideo to
the MODULES array in /etc/rc.conf.

Install the cheese application:

    # pacman -S cheese

To view input from the webcam, you can use MPlayer:

    $ mplayer -tv driver=v4l2:width=640:height=480:device=/dev/video0:fps=15 tv://

Note: You may need to enable the webcam (Fn+F6) before the above
applications will work.

> Hard Drive Clicking/Ticking

SATA power management settings are aggressively conservative by default.
This can produce a clicking or ticking sound every few seconds as the
hard drive head attempts to 'park' itself. Not only is this annoying, it
can shorten the life of your hard drive. To avoid this:

Install the hdparm utility.

Add the following to /etc/rc.local:

    # lowest SATA power management setting, highest I/O performance
    hdparm -B 254 /dev/sda

- or -

    # disable SATA power management entirely
    hdparm -B 255 /dev/sda

Confirm the current power management setting at any time by running:

    # hdparm -B /dev/sda

Tips & Tricks
-------------

> More on Hotkeys

To make life easier for others, what follows is a list of hotkey
definitions for use by xbindkeys:

Fn+F2 (screen)

       m:0x10 + c:214
       Mod2 + XF86Display

Fn+F3 (touchpad) <-- This hotkey will toggle the touchpad regardless of
its binding under Linux

       m:0x10 + c:249
       Mod2 + NoSymbol

Fn+F7 (vol dn)

       m:0x10 + c:174
       Mod2 + XF86AudioLowerVolume

Fn+F8 (vol up)

       m:0x10 + c:176
       Mod2 + XF86AudioRaiseVolume

Fn+F9 (vol mute)

       m:0x10 + c:160
       Mod2 + XF86AudioMute

Fn+F11 (wifi) <-- This hotkey will toggle the wifi antenna regardless of
its binding under Linux

       m:0x10 + c:243
       Mod2 + NoSymbol

Fn+F12 (suspend)

       m:0x10 + c:223
       Mod2 + XF86Standby

Power Button

       m:0x10 + c:222
       Mod2 + XF86PowerOff

More Resources
--------------

-   MSI Wind U100 - Arch Linux wiki on the MSI Wind U100
-   MSI Notebook Official Website
-   MSIWind.net - Community website dedicated to MSI Wind netbooks,
    includes forums and a wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=MSI_Wind_U120&oldid=225342"

Category:

-   MSI
