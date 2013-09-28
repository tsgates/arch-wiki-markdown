ASUS K52J
=========

The parameters depend on the submodel...

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Model K52JT-SX011V:                                                |
|     -   1.1 Hardware                                                     |
|     -   1.2 Graphics                                                     |
|         -   1.2.1 Setting resolution                                     |
|         -   1.2.2 Setting monster resolution                             |
|         -   1.2.3 HDMI tvout                                             |
|         -   1.2.4 Setting Brightness                                     |
|         -   1.2.5 Hibernate and Suspend                                  |
|         -   1.2.6 HDMI port                                              |
|                                                                          |
|     -   1.3 Touchpad                                                     |
|     -   1.4 DVD                                                          |
|     -   1.5 Sound                                                        |
|     -   1.6 Webcam                                                       |
|     -   1.7 Networking                                                   |
|         -   1.7.1 LAN                                                    |
|         -   1.7.2 sd-cardreader                                          |
|         -   1.7.3 WLAN                                                   |
|         -   1.7.4 bluetooth                                              |
|                                                                          |
|     -   1.8 Untested                                                     |
|     -   1.9 lspci                                                        |
+--------------------------------------------------------------------------+

Model K52JT-SX011V:
===================

Hardware
--------

-   Processor: Intel Core i7 740QM 1.73 GHz (Turbo up to 2.93GHz)
-   Display: - 15.6" (HD, Glare Type) / ATI HD6370 1G GDDR3 VRAM
-   HDD:
-   Card Reader: SD-card, Memory Stick, MultiMediaCard
-   DVD:
-   Webcam:
-   WLAN: - Gbe - WLAN 802.11bgn
-   LAN:
-   Bluetooth

  

Graphics
--------

Works fine with

    # pacman -S xf86-video-ati

but works even better with xf86-video-ati-git from the AUR.

> Setting resolution

     xrandr --output LVDS --auto

> Setting monster resolution

    yaourt hwd

    sudo hwd -x

Now some template xorg.conf lives in /etc/X11

In the new xorg.conf Add/replace under Section "Screen"

  

    Section "Screen"
           Identifier "Screen0"
           Device     "Card0"
           Monitor    "Monitor0"
           DefaultColorDepth 16
           SubSection "Display"
                      ViewPort 0 0
                      Virtual 3056 1824
                      #Depth     16
           EndSubSection
    EndSection

And in the name of the holly hand granade: remember to that the x and y
in Virtual 3056 1824, should be a multiple of 8 or 16(old cards maybe
32) and maybe set the driver to Driver "radeon" in the Section "Device"
restart xorg hack:

    setxkbmap -option terminate:ctrl_alt_bksp

then ctrl-alt-backspace

> HDMI tvout

I've made two scripts! Turn on:

    xrandr --output HDMI-0 --mode 1280x720 --left-of LVDS;xset -dpms;xset s off

Turn off

    xrandr --output HDMI-0 --off

> Setting Brightness

Strangely enough the keyboard buttons works out of the box

FN+F5

and

FN+F6

> Hibernate and Suspend

The USB unbind hook is no longer necessary as of Linux 3.5.

> HDMI port

Works fine! See Enable_1366x768_resolution article.

Touchpad
--------

Works fine with no configuration required.

but works even better (3-finger) with

    # pacman -S xf86-input-synaptics

DVD
---

Works fine with no configuration required.

Sound
-----

Works.

Webcam
------

Works fine, a little strange but ok. Cheese works fine out of the box.

Google talk video chat:

    uncomment multilib in your pacman.conf 
    sudo pacman -S multilib/lib32-v4l-utils
    LD_PRELOAD=/usr/lib32/libv4l/v4l1compat.so firefox

Networking
----------

> LAN

Works fine with no configuration required.

> sd-cardreader

Works fine with no configuration required.

> WLAN

Works fine with no configuration required.

> bluetooth

Works fine with no configuration required.

Untested
--------

-   VGA port

lspci
-----

    00:00.0 Host bridge: Intel Corporation Core Processor DMI (rev 11)
    00:03.0 PCI bridge: Intel Corporation Core Processor PCI Express Root Port 1 (rev 11)
    00:08.0 System peripheral: Intel Corporation Core Processor System Management Registers (rev 11)
    00:08.1 System peripheral: Intel Corporation Core Processor Semaphore and Scratchpad Registers (rev 11)
    00:08.2 System peripheral: Intel Corporation Core Processor System Control and Status Registers (rev 11)
    00:08.3 System peripheral: Intel Corporation Core Processor Miscellaneous Registers (rev 11)
    00:10.0 System peripheral: Intel Corporation Core Processor QPI Link (rev 11)
    00:10.1 System peripheral: Intel Corporation Core Processor QPI Routing and Protocol Registers (rev 11)
    00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series Chipset HECI Controller (rev 06)
    00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06)
    00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 06)
    00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 06)
    00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 (rev 06)
    00:1c.2 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 3 (rev 06)
    00:1c.5 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 6 (rev 06)
    00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a6)
    00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 06)
    00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 4 port SATA AHCI Controller (rev 06)
    00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 06)
    01:00.0 VGA compatible controller: ATI Technologies Inc Robson CE [AMD Radeon HD 6300 Series]
    01:00.1 Audio device: ATI Technologies Inc Manhattan HDMI Audio [Mobility Radeon HD 5000 Series]
    03:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
    05:00.0 System peripheral: JMicron Technology Corp. SD/MMC Host Controller (rev 80)
    05:00.2 SD Host controller: JMicron Technology Corp. Standard SD Host Controller (rev 80)
    05:00.3 System peripheral: JMicron Technology Corp. MS Host Controller (rev 80)
    05:00.4 System peripheral: JMicron Technology Corp. xD Host Controller (rev 80)
    05:00.5 Ethernet controller: JMicron Technology Corp. JMC250 PCI Express Gigabit Ethernet Controller (rev 03)
    ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-Core Registers (rev 04)
    ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 04)
    ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 04)
    ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 04)
    ff:03.0 Host bridge: Intel Corporation Core Processor Integrated Memory Controller (rev 04)
    ff:03.1 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Target Address Decoder (rev 04)
    ff:03.4 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Test Registers (rev 04)
    ff:04.0 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Control Registers (rev 04)
    ff:04.1 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Address Registers (rev 04)
    ff:04.2 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Rank Registers (rev 04)
    ff:04.3 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Thermal Control Registers (reva 04)
    ff:05.0 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Control Registers (rev 04)
    ff:05.1 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Address Registers (rev 04)
    ff:05.2 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Rank Registers (rev 04)
    ff:05.3 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Thermal Control Registers (rev 04)

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_K52J&oldid=233234"

Category:

-   ASUS
