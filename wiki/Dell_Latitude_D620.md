Dell Latitude D620
==================

Contents
--------

-   1 Hardware
-   2 Installation
-   3 Wireless Networking
    -   3.1 Intel 3945 ABG PCI Express
    -   3.2 Broadcom PCI Express
        -   3.2.1 ndiswrapper
-   4 Recommendations
    -   4.1 PC Speaker
    -   4.2 Synaptics Touchpad
    -   4.3 Volume, Mute and Super Keys
        -   4.3.1 In Openbox
        -   4.3.2 In Xmonad

Hardware
--------

(Possibly) an early 2007 model D620:

    HARDWARE DETECT ver 4.8.2 (simple mode)
     Kernel     : 2.6.19-ARCH
     CPU & Cache:
      Processor 0 is Genuine Intel(R) CPU T2600  @ 2.16GHz 2161MHz, 2048 KB Cache
      Processor 1 is Genuine Intel(R) CPU T2600  @ 2.16GHz 2161MHz, 2048 KB Cache
     Soundcard  : No sound card
     Video      : nVidia Corp.|Quadro NVS 110M / GeForce Go 7300 server: Xorg (vesa)  
     Driver     : xf86-video-vesa 
     Monitor    : Generic Monitor  H: 28.0-96.0kHz V: 50.0-75.0Hz
     Mouse      : Generic PS/2 Wheel Mouse xtype: PS2 device: /dev/psaux
     Drive(scsi): SCSI device sda: 234441648 512-byte hdwr sectors (120034 MB)
      SCSI device sda: 234441648 512-byte hdwr sectors (120034 MB)
     USB        : Intel Corp.|I/O Controller Hub UHCI USB #1 module: unknown
     Ethernet   : Broadcom Corp.|NetXtreme BCM5752 Gigabit Ethernet PCI Express module: tg3 device:   eth0
      eth1 
     Network    : Broadcom Corp.|NetXtreme BCM5752 Gigabit Ethernet PCI Express module: unknown 
     PCMCIA slot: O2Micro Inc.|OZ6912 CardBus Controller module: yenta_socket

A late-2007 model D620 hardware, output from lspci:

     00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
     00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev 03)
     00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
     00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
     00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 01)
     00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 01)
     00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 01)
     00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 01)
     00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 01)
     00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 01)
     00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 01)
     00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01)
     00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1)
     00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 01)
     00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 01)
     00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
     03:01.0 CardBus bridge: O2 Micro, Inc. OZ601/6912/711E0 CardBus/SmartCardBus Controller (rev 40)
     09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5752 Gigabit Ethernet PCI Express (rev 02)
     0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)

Installation
------------

The latest version of the Arch Linux installer detects all the hardware
fine on the late-2007 D620 (with the exception of a problem involving
the wireless network card, see below).

Wireless Networking
-------------------

> Intel 3945 ABG PCI Express

If your D620 comes with an Intel 3945 ABG card, you should install the
iwlwifi-3945-ucode, either during installation or afterwards, then

     modprobe iwl3945

And you should be ready to go.

In some cases (at least with the 2008.06 installer) you may have the
ipw3945 and iwl3945 modules in your MODULES=() section of rc.conf after
installation. You should remove or ! out the ipw3945 module, as the
wireless card will not function correctly or at all with both modules
loaded.

The iwl3945 driver can also be enabled during a kernel recompilation. It
can be found in the menuconfig under Device Drivers -> Network device
support -> Wireless Lan -> Intel PRO/Wireless 3945AGB/BG Network
connection. Enabling LED features should fix the LED feature if it was
previously not functioning. It is generally recommended to modularize
features but selecting the driver as "*" for built in support works fine
too.

> Broadcom PCI Express

There are two solutions how to make the Dell Wireless MiniCard (Broadcom
chip) work: the b43 drivers and the ndiswrapper drivers.

It is highly recommended to use the b43 drivers as some people
experienced problems when connecting to WPA2-encrypted networks with the
ndiswrapper drivers.

In order to install the b43 drivers, follow the main article: B43.

ndiswrapper

Install the latest ndiswrapper with pacman.

Go to the DELL support website and download the official Windows drivers
for the "Dell Wireless MiniCard". Make sure that you download the right
driver for your card. There are 3 different versions for the 13,xx, 14xx
and the 15xx MiniCards.

    cd /path_to_driver
    sudo ndiswrapper -i bcmwl5.inf 
    sudo ndiswrapper -l
    sudo depmod -a
    sudo modprobe ndiswrapper
    dmesg
    sudo ndiswrapper -m

Add ndiswrapper to your MODULES in /etc/rc.conf.

For more information, check B43:ndiswrapper

Recommendations
---------------

> PC Speaker

The D620 has an awfully loud PC speaker. To disable it, ensure the
module pcspkr is not loaded during bootup:

    /etc/modprobe.d/nobeep.conf

    #Do not load the 'pcspkr' module on boot.

    blacklist pcspkr

You should follow instructions for installing cpufrequtils and pm-utils.
There have been no problems with suspending and hibernating this laptop
- just ensure you have enough swap.

> Synaptics Touchpad

The synaptics touchpad should be working out of the box.

> Volume, Mute and Super Keys

In Openbox

If you install Openbox3 you may find that your volume and mute keys
(next to the power button) and your super (Windows key) are not bound.
You may wish to configure these in a different manner(e.g. Keytouch) but
if you simply want to get these to work in Openbox then create
~/.Xmodmap with the following contents:

    add mod4=Super_L
    keycode 115=Super_L
    keycode 160=XF86AudioMute 
    keycode 176=XF86AudioRaiseVolume
    keycode 174=XF86AudioLowerVolume

Note:These keycodes have only been tested on a late-2007 model D620 and
may differ on other models.

The first line binds Super_L to Mod4 (where Openbox expects your super
key) The second binds your Windows key to Super_L. If your super key is
already working as expected you should skip the first two lines. The
rest binds the audio keys. To set these you need to use xmodmap:

    $ xmodmap .Xmodmap

If you want to set them everytime you start Openbox add this command to
your ~/.config/openbox/autostart. You can now use keybindings in
~/.config/openbox/rc.xml that use the W (stands for super) key (e.g. W-d
for ToggleShowDesktop). You need to bind the XF86 Audio keys by adding
the following keybindings to rc.xml:

     <keybind key="XF86AudioLowerVolume">
       <action name="Execute">
         <execute>amixer set Master 5- unmute</execute>
           </action>
     </keybind>

     <keybind key="XF86AudioRaiseVolume">
        <action name="Execute">openbox --version
           <execute>amixer set Master 5+ unmute</execute>
        </action>
     </keybind>

     <keybind key="XF86AudioMute">
       <action name="Execute">
          <execute>amixer set Master toggle</execute>
        </action>
     </keybind>

These shortcuts invoke amixer to control your audio output.

Note: These changes have only been tested using Openbox 3.4.7.2.

In Xmonad

To bind the the volume keys and powerbuttons directly use the following
bindings in your xmonad.hs:

     , ((0, 0x1008ff13 ), spawn "amixer set Master 1+ unmute")
     , ((0, 0x1008ff11 ), spawn "amixer set Master 1- unmute")
     , ((0, 0x1008ff12 ), spawn "amixer set Master toggle")
     , ((0, 0x1008ff2a ), spawn "sudo halt")

Note:These keycodes have only been tested on a late-2007 model D620 and
may differ on other models.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Latitude_D620&oldid=243042"

Category:

-   Dell

-   This page was last modified on 5 January 2013, at 14:56.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
