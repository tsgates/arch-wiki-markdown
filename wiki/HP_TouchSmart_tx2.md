HP TouchSmart tx2
=================

This is a work in progress to get archlinux to work on the HP tx2z
multitouch tablet pc.

Installed using archlinux-2009.08 x86_64. Few other tips can be seen on
Arch's wiki page for Tablet PC

Contents
--------

-   1 Hardware
    -   1.1 hwd output
    -   1.2 lsusb
    -   1.3 lspci
    -   1.4 hwdetect
-   2 Configuration details
    -   2.1 Display
    -   2.2 Xorg.conf
    -   2.3 Bluetooth
    -   2.4 Network
    -   2.5 Audio
    -   2.6 VGA
    -   2.7 SmartCard Reader
    -   2.8 Webcam
    -   2.9 Modem
    -   2.10 Input
        -   2.10.1 Keyboard
        -   2.10.2 Touchpad
        -   2.10.3 Stylus
        -   2.10.4 Remote
        -   2.10.5 Fingerprint Scanner
-   3 External Links

Hardware
========

hwd output
----------

    $ sudo hwd -s
    HARDWARE DETECT ver 5.5.2 (simple mode)
     Kernel     : 2.6.32-ARCH
     CPU & Cache: Processor 0: AMD Turion(tm) X2 Ultra Dual-Core Mobile ZM-86 1200MHz, 1024 KB Cache Processor 1: AMD Turion(tm) X2 Ultra Dual-Core Mobile ZM-86 1200MHz, 1024 KB Cache
     Sound(a)   : SBx00 Azalia Intel HDA module: snd-hda-intel 
     Video      : RS780M/RS780MN [Radeon HD 3200 Graphics] server: Xorg (vesa)  
     Driver     : xf86-video-vesa   module: - 
     Monitor    : Generic Monitor  H: 28.0-96.0kHz V: 50.0-75.0Hz
     Mouse      : Touch Pad xtype: IMPS2 device: /dev/input/mice
     HDD        : SB700/SB800 IDE Controller module: pata_atiixp 
     USB        : SB700/SB800 USB OHCI2 Controller module: ohci_hcd 
     Ethernet   : RTL8111/8168B PCI Express Gigabit Ethernet controller module: r8169 
     Network    : BCM4322 802.11a/b/g/n Wireless LAN Controller module: b43-pci-bridge 
     Menu       : Main menu: hwd
     All        : Detect all hardwares: hwd -e
     X sample   : Generate X sample: hwd -x 

lsusb
-----

    Bus 007 Device 002: ID 1b96:0001 N-Trig Duosense Transparent Electromagnetic Digitizer
    Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 001 Device 002: ID 0bda:0158 Realtek Semiconductor Corp. Mass Storage Device
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 005 Device 002: ID 046d:c049 Logitech, Inc. G5 Laser Mouse  <- may differ if you do not have same mouse
    Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 002 Device 002: ID 04f2:b132 Chicony Electronics Co., Ltd 
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

lspci
-----

    00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
    00:01.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (int gfx)
    00:04.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 0)
    00:05.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 1)
    00:06.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 2)
    00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode]
    00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
    00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
    00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
    00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
    00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
    00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
    00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
    00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
    00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
    00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
    00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
    00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller
    00:18.0 Host bridge: Advanced Micro Devices [AMD] Mobile K10 [Turion X2, Athlon X2, Sempron] HyperTransport Configuration (rev 40)
    00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 11h [Turion X2, Athlon X2, Sempron] Address Map
    00:18.2 Host bridge: Advanced Micro Devices [AMD] Mobile K10 [Turion X2, Athlon X2, Sempron] DRAM Controller
    00:18.3 Host bridge: Advanced Micro Devices [AMD] Mobile K10 [Turion X2, Athlon X2, Sempron] Miscellaneous Control
    00:18.4 Host bridge: Advanced Micro Devices [AMD] Mobile K10 [Turion X2, Athlon X2, Sempron] Link Control
    01:05.0 VGA compatible controller: ATI Technologies Inc RS780M/RS780MN [Radeon HD 3200 Graphics]
    08:00.0 Network controller: Broadcom Corporation BCM4322 802.11a/b/g/n Wireless LAN Controller (rev 01)
    09:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)

hwdetect
--------

    $ hwdetect --show-modules
    ACPI   : ac battery button processor thermal video 
    PATA   : pata_atiixp 
    SCSI   : scsi_mod sd_mod sr_mod st 
    SATA   : ahci 
    USB    : usb-storage usbcore ehci-hcd ohci-hcd 
    NET    : mii r8169 
    INPUT  : evdev joydev psmouse serio_raw hid usbhid 
    PCMCIA : pcmcia_core pcmcia 
    SOUND  : pcspkr snd-mixer-oss snd-pcm-oss snd-hwdep snd snd-page-alloc snd-pcm snd-timer snd-hda-codec snd-hda-intel soundcore 
    VIDEO  : uvcvideo v4l1-compat v4l2-compat-ioctl32 videodev output 
    OTHER  : cdrom amd64_edac_mod edac_core edac_mce_amd i2c-piix4 i2c-core mmc_core pci_hotplug shpchp wmi rtc-cmos rtc-core rtc-lib ssb

Configuration details
=====================

> Display

currently the touch screen works with the drivers from the
xf86-input-synaptics package from the repos. To set up amazing
multitouch functionality, see Touchpad Synaptics.

    $ xrandr
    Screen 0: minimum 320 x 200, current 1280 x 800, maximum 1280 x 1280
    VGA-0 disconnected (normal left inverted right x axis y axis)
    LVDS connected 1280x800+0+0 (normal left inverted right x axis y axis) 261mm x 163mm
      1280x800       60.2*+
      1280x720       59.9  
      1152x768       59.8  
      1024x768       59.9  
      800x600        59.9  
      640x480        59.4

> Xorg.conf

edited from http://ubuntuforums.org/showthread.php?t=1038898

driver installed: xf86-video-ati. See ATI

    Section "ServerLayout"
        Identifier      "Default Layout"
        Screen "Default Screen"
        InputDevice    "Trackpad"
        InputDevice    "stylus"
    # I've commented out the eraser because it either doesn't exist or doesn't work
    #    InputDevice    "eraser"  # "SendCoreEvents"
        InputDevice    "touch"
    EndSection                                 

    Section "Monitor"
        Identifier	"Configured Monitor"
    EndSection

    Section "Screen"
        Identifier	"Default Screen"
        Monitor		"Configured Monitor"
        Device		"Configured Video Device"
        DefaultDepth	24
    EndSection

    Section "Module"
        Load	"glx"
        Load	"dri"
        Load	"drm"
    EndSection

    Section "Device"
        Identifier	"Configured Video Device"
    #    Driver		"fglrx"
        Driver		"radeon"
        Option	   	"DPI" "96 x 96"
    EndSection

    Section "InputDevice"
        Identifier  "Trackpad"
        Driver      "synaptics"
        Option	"Device" "/dev/input/by-path/platform-i8042-serio-1-event-mouse"
        Option      "TapButton1" "1"
    EndSection

    Section "InputDevice"
        Driver "wacom"
        Option "Mode" "Absolute"
        Identifier "touch"
        Option "Touch" "on"
        Option "Type" "touch"
        Option "ForceDevice" "ISDV4"
        Option "Device" "/dev/input/by-path/pci-0000:00:14.5-usb-0:2:1.0-event-mouse"
    #   Option "USB" "on"
        Option "TopX" "0"
        Option "TopY" "0"
        Option "BottomX" "9600"
        Option "BottomY" "7200"
        Option "DebugLevel" "8"
        Option "Button1" "1"
        Option "Button10" "1"
    EndSection

    Section "InputDevice"
        Driver "wacom"
        Identifier "stylus"
        Option "Mode" "Absolute"
        Option "Type" "stylus"
        Option "ForceDevice" "ISDV4"
        Option "Device" "/dev/input/by-path/pci-0000:00:14.5-usb-0:2:1.0-event-mouse"
        Option "TPCButton" "on"
        Option "USB" "on"
        Option "Button2" "3"
        Option "Button3" "core key alt F2"
    EndSection

    Section "InputDevice"
        Driver "wacom"
        Identifier "eraser"
        Option "Mode" "Absolute"
        Option "Type" "eraser"
        Option "ForceDevice" "ISDV4"
        Option "Device" "/dev/input/by-path/pci-0000:00:14.5-usb-0:2:1.0-event-mouse"
        Option "TPCButton" "on"
        Option "USB" "on"
        Option "Button1" "2"
    EndSection

> Bluetooth

not tested

> Network

Ethernet : RTL8111/8168B PCI Express Gigabit Ethernet controller

module: r8169 in kernel

Wifi : Broadcom Corporation BCM4322 802.11a/b/g/n

Followed setup on Broadcom BCM4312

module(s): !b43 !ssb !lib80211 lib80211_crypt_tkip wl

the module must be reinstalled after each kernel update in order for
wifi to work.

> Audio

works. see ALSA

> VGA

Follow instructions in the ATI wiki page.

> SmartCard Reader

works out of the box. just having minor privledge issues atm

> Webcam

works. followed setup as in Webcam tested using:

    $ mplayer tv:// -vf screenshot

> Modem

Not tested yet. Chances are you probably won't need this. Add some info
if you find out how to set this up!

> Input

Keyboard

almost all Fn keys work out of the box.

-   rotate screen button and configuration button are not recognized by
    xev
-   Fn + F[1-4] are bound as:

    $ xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'
    146 Help         <- Fn+F1
    33 p             <- Fn+F2*
    37 Control_L     <- Fn+F2* (Fn+F2 performs both functions simultaneously)
    180 XF86HomePage <- Fn+F3
    33 p             <- Fn+F4

Touchpad

-   mouse input = works
-   scrollup/down = works
-   tap to click = works
-   mouse buttons = work

Stylus

-   mouse input = need to modify xorg to work
-   button (right click) = need to modify xorg to work
-   tap to click = need to modify xorg to work
-   nema.arpit getting Ntrig to work in arch

Remote

-   Works by default: Super (Windows Button), Squiggly (turns screen
    brightness down), Arrow keys (behave like the ones on the keyboard),
    volume controls.
-   Doesn't work by default: Power, DVD, Play, Stop, Forward, Backward,
    previous, next, up, info, ok?
-   Update coming soon. ;) Trusktr 03:07, 2 May 2011 (EDT)

Fingerprint Scanner

-   Info Needed.

External Links
==============

-   Gentoo forums - HP tx2z touchsmart
-   HOWTO setting up Ubuntu 8.10 intrepid on the HP tx2z tablet PC
-   HOW TO: Set up the HP TX2z and Dell XT & XT2 (N-trig digitizer) in
    Ubuntu

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_TouchSmart_tx2&oldid=196654"

Category:

-   HP

-   This page was last modified on 23 April 2012, at 13:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
