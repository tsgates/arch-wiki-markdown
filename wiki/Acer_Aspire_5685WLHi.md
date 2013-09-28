Acer Aspire 5685WLHi
====================

This page provides most of the relevant information on installing Arch
Linux with the KDE Desktop on the Acer Aspire 5685WLHi.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
|     -   1.1 Standard Hardware                                            |
|     -   1.2 Hardware Status                                              |
|                                                                          |
| -   2 System Files and Command Outputs                                   |
|     -   2.1 System Files                                                 |
|         -   2.1.1 xorg.conf                                              |
|                                                                          |
|     -   2.2 Command Outputs                                              |
|         -   2.2.1 lsusb                                                  |
|         -   2.2.2 lspci                                                  |
|                                                                          |
| -   3 Troubleshooting                                                    |
| -   4 Tips & Tricks                                                      |
| -   5 More Resources                                                     |
|     -   5.1 Interwiki Links                                              |
|     -   5.2 External Links                                               |
+--------------------------------------------------------------------------+

Hardware
--------

> Standard Hardware

+--------------------------------------+--------------------------------------+
| Hardware                             | Description                          |
+======================================+======================================+
| Processor                            | Intel® Core™ 2 Duo T7200 2.0MHz      |
+--------------------------------------+--------------------------------------+
| System Memory                        | 2GB DDR2 667 MHz                     |
+--------------------------------------+--------------------------------------+
| Graphic Card                         | Nvidia GeForce Go 7600               |
+--------------------------------------+--------------------------------------+
| Display                              | 15.4” WXGA CrystalBrite widescreen   |
|                                      | TFT LCD display 1280 x 800@ 16.7     |
|                                      | million colours                      |
+--------------------------------------+--------------------------------------+
| Sound Card                           | Intel High Definition Audio          |
|                                      | Controller                           |
+--------------------------------------+--------------------------------------+
| CD/DVD                               | Specs comming                        |
+--------------------------------------+--------------------------------------+
| Lan                                  | Broadcom Corporation NetLink BCM5789 |
|                                      | Gigabit Ethernet                     |
+--------------------------------------+--------------------------------------+
| WLan                                 | Intel Corporation PRO/Wireless       |
|                                      | 3945ABG                              |
+--------------------------------------+--------------------------------------+
| Webcam                               | Acer OrbiCam integrated 1.3          |
|                                      | megapixlar                           |
+--------------------------------------+--------------------------------------+
| Touchpad                             | Synaptics PS/2 Port Touchpad         |
+--------------------------------------+--------------------------------------+
| I/O Interface                        | -   1 x ExpressCard/34 Slot          |
|                                      | -   1 x PC Card Slot                 |
|                                      | -   1 x 5-in-one card reader: SD™    |
|                                      |     Card, MultiMediaCard, Memory     |
|                                      |     Stick®, Memory Stick PRO™ or     |
|                                      |     xD-Picture Card™                 |
|                                      | -   4 x USB 2.0 Ports                |
|                                      | -   1 x DVI-D Port                   |
|                                      | -   1 x IEEE 1394 Port               |
|                                      | -   1 x Fast Infrared (FIR) Port     |
|                                      | -   1 x External Display (VGA) Port  |
|                                      | -   1 x AV-in Port                   |
|                                      | -   1 x S-video/TV-out (NTSC/PAL)    |
|                                      |     Port                             |
|                                      | -   1 x S-video-in (NTSC/PAL) Port   |
|                                      | -   1 x Headphones/Speaker/Line-out  |
|                                      |     Port with S/PDIF Support         |
|                                      | -   1 x Microphone-in Jack           |
|                                      | -   1 x Ethernet (RJ-45) Port        |
|                                      | -   1 x Modem (RJ-11) Port           |
|                                      | -   1 x Keyboard 89 keys Dvorak      |
+--------------------------------------+--------------------------------------+
| IP Phone                             | Acer Bluetooth VOIP Phone            |
+--------------------------------------+--------------------------------------+
| Remote Control                       | Acer Arcade Remote Control           |
+--------------------------------------+--------------------------------------+
| Printer                              | HP Color LaserJet 2700               |
+--------------------------------------+--------------------------------------+
| External Mouse                       | Logitech TrackMan Wheel              |
+--------------------------------------+--------------------------------------+

> Hardware Status

  Status       Hardware                                                                  Links/Notes                                                    Status by:
  ------------ ------------------------------------------------------------------------- -------------------------------------------------------------- ------------
  Works        Processor                                                                 No Problems Known                                              Menel
  Works        System Memory                                                             No Problems Known                                              Menel
  Works        Nvidia GeForce Go 7600                                                    NVIDIA                                                         Menel
  Works        Display                                                                   No Problems Known                                              Menel
  Works        Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller   ALSA                                                           Menel
  Not Tested   CD/DVD                                                                                                                                   Menel
  Works        Broadcom Corporation NetLink BCM5789 Gigabit Ethernet                                                                                    Menel
  Works        Intel Corporation PRO/Wireless 3945ABG                                    Wireless                                                       Menel
  Not Tested   Acer OrbiCam integrated 1.3 megapixlar                                                                                                   Menel
  Works        Synaptics Touchpad                                                        Synaptics                                                      Menel
  Works        Media Keys                                                                                                                               Menel
  Not Tested   ExpressCard/34 Slot                                                                                                                      Menel
  Not Tested   PC Card Slot                                                                                                                             Menel
  Not Tested   5-in-one card reader                                                                                                                     Menel
  Works        USB 2.0 Ports                                                             No Problems Known                                              Menel
  Not Tested   DVI-D Port                                                                                                                               Menel
  Not Tested   IEEE 1394 Port                                                                                                                           Menel
  Not Tested   Fast Infrared (FIR) Port                                                                                                                 Menel
  Not Tested   External Display (VGA) Port                                                                                                              Menel
  Not Tested   AV-in Port                                                                                                                               Menel
  Not Tested   S-video/TV-out (NTSC/PAL) Port                                                                                                           Menel
  Not Tested   S-video-in (NTSC/PAL) Port                                                                                                               Menel
  Not Tested   Headphones/Speaker/Line-out Port with S/PDIF Support                                                                                     Menel
  Not Tested   Microphone-in Jack                                                                                                                       Menel
  Works        Ethernet (RJ-45) Port                                                     No Problems Known                                              Menel
  Not Tested   Modem (RJ-11) Port                                                                                                                       Menel
  Works        Keyboard 89 keys Dvorak                                                   Dvorak                                                         Menel
  Not Tested   Acer Bluetooth VOIP Phone                                                                                                                Menel
  Testing      Acer Arcade Remote Control                                                Works as an extension of the keyboard, almost all keys work.   Menel
  Works        HP Color LaserJet 2700                                                    CUPS                                                           Menel
  Works        Logitech TrackMan Wheel                                                   No Problems Known                                              Menel

System Files and Command Outputs
--------------------------------

> System Files

xorg.conf

    /etc/X11/xorg.conf

    Section "Device"
        Identifier     "GraphicCard"
        Driver         "nvidia"
        VendorName     "NVIDIA Corporation"
        BusID          "PCI:1:0:0"
        Option         "NoLogo" "True"
    EndSection

Thats it!!!

> Command Outputs

lsusb

    $ lsusb

    Bus 001 Device 002: ID 03f0:3717 Hewlett-Packard EWS UPD
    Bus 001 Device 003: ID 046d:0896 Logitech, Inc. OrbiCam
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 005 Device 002: ID 046d:c404 Logitech, Inc. TrackMan Wheel
    Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 004 Device 002: ID 0a5c:2101 Broadcom Corp. A-Link BlueUsbA2 Bluetooth
    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

lspci

    $ lspci

    00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)                                         
    00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express PCI Express Root Port (rev 03)                                          
    00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)                                                          
    00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)                                                                          
    00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)                                                                          
    00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)                                                                          
    00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
    00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
    00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
    00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
    00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02)
    00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
    01:00.0 VGA compatible controller: nVidia Corporation G73 [GeForce Go 7600] (rev a1)
    04:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5789 Gigabit Ethernet PCI Express (rev 21)
    05:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
    06:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306 Fire II IEEE 1394 OHCI Link Layer Controller (rev c0)
    06:02.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
    06:04.0 CardBus bridge: ENE Technology Inc CB-712/4 Cardbus Controller (rev 10)
    06:04.1 FLASH memory: ENE Technology Inc ENE PCI Memory Stick Card Reader Controller (rev 01)
    06:04.2 SD Host controller: ENE Technology Inc ENE PCI Secure Digital Card Reader Controller (rev 01)
    06:04.3 FLASH memory: ENE Technology Inc FLASH memory: ENE Technology Inc: (rev 01)
    06:04.4 FLASH memory: ENE Technology Inc SD/MMC Card Reader Controller (rev 01)

Troubleshooting
---------------

Tips & Tricks
-------------

More Resources
--------------

> Interwiki Links

Acer Wikipedia article

> External Links

Acer Home Page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_5685WLHi&oldid=196469"

Category:

-   Acer
