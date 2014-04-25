ASUS A55VJ
==========

Contents
--------

-   1 Model A55VJ-SXH161 (also K55VJ):
    -   1.1 Hardware
    -   1.2 lspci
    -   1.3 Installing
    -   1.4 Graphics
    -   1.5 Touchpad
    -   1.6 Sound
    -   1.7 Power management
    -   1.8 Backlight
    -   1.9 Cardreader

Model A55VJ-SXH161 (also K55VJ):
--------------------------------

> Hardware

-   Processor: Intel Core i7-3630QM
-   Display: 15.4" 1366x768
-   Graphics: Intel with NVIDIA GeForce GT 635M
-   WLAN: Intel Wireless-N 2230 802.11b/g/n
-   LAN: Realtek RTL8111/8168 Gigabit Ethernet controller

> lspci

    00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller (rev 09)
    00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor PCI Express Root Port (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor Graphics Controller (rev 09)
    00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04)
    00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
    00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
    00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
    00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4)
    00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 (rev c4)
    00:1c.3 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 4 (rev c4)
    00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
    00:1f.0 ISA bridge: Intel Corporation HM76 Express Chipset LPC Controller (rev 04)
    00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
    00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
    01:00.0 VGA compatible controller: NVIDIA Corporation GF108M [GeForce GT 635M] (rev ff)
    03:00.0 Network controller: Intel Corporation Centrino Wireless-N 2230 (rev c4)
    04:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. Device 5289 (rev 01)
    04:00.2 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168 PCI Express Gigabit Ethernet controller (rev 0a)

> Installing

Disable fast boot and CSM in BIOS to be able to boot from external
media.

Partition the harddrive in windows, no boot partition needed as
/dev/sda1 is reserved for EFI.

You can also partition the drive while installing using parted or
gptfdisk (not included with 2013.05.01 installer).

Install grub-efi-x86_64 to /dev/sda1 (/boot) and install system as
usually.

Setup bios to boot from disk1/part1 with \grub\core.efi (or grub.efi or
whatever the naming currently is, ignore the "fsx:" the builtin help is
giving you).

If you want to boot windows normally, do not format or remove files from
/dev/sda1 or the option from BIOS.

> Graphics

Works with xf86-video-intel. NVIDIA GT635M works with Bumblebee

xorg.conf:

    Section "ServerLayout"
        Identifier     "Layout0"
        Screen      0  "Screen0" 0 0
        InputDevice    "Keyboard0" "CoreKeyboard"
        InputDevice    "touchpad" "CorePointer"
    EndSection

    Section "Files"
        FontPath        "/usr/share/fonts/misc/"
        FontPath        "/usr/share/fonts/TTF/"
        FontPath        "/usr/share/fonts/Type1/"
        FontPath        "/usr/share/fonts/cyrillic/"
        FontPath        "/usr/share/fonts/75dpi/"
        FontPath        "/usr/share/fonts/100dpi/"
        FontPath        "/usr/share/fonts/local/"
    EndSection

    Section "InputDevice"
            Identifier "touchpad"
            Driver "synaptics"
            Option "TapButton1" "1"
            Option "TapButton2" "2"
            Option "TapButton3" "3"
            Option "HorizTwoFingerScroll" "1"
            Option "AreaBottomEdge" "82%"
            Option "SoftButtonAreas" "50% 0 82% 0 0 0 0 0"
    EndSection

    Section "InputClass"
            Identifier "touchpad ignore duplicates"
            MatchIsTouchpad "on"
            MatchOS "Linux"
            MatchDevicePath "/dev/input/mouse*"
            Option "Ignore" "on"
    EndSection

    Section "InputDevice"
        Identifier     "Keyboard0"
        Driver         "kbd"
        Option         "AutoRepeat" "500 30"
        Option         "XkbRules" "xorg"
        Option         "XkbModel" "asus_laptop"
        Option         "XkbLayout" "fi"
        Option         "XkbVariant" "nodeadkeys"
    EndSection

    Section "Monitor"
        Identifier     "Monitor0"
        Option         "DPMS"
        Option         "Enable" "true"
    EndSection

    Section "Device"
        Identifier     "nvgpu0"
        Driver         "nvidia"
        BusID          "PCI:01:00:00"
        VendorName     "NVIDIA Corporation"
    EndSection

    Section "Device"
        Driver         "intel"
        Option         "XvMC" "true"
        Option         "UseEvents" "true"
        Option         "AccelMethod" "UXA"
        BusID          "PCI:0:2:0"
    EndSection

    Section "Screen"
        Identifier     "Screen0"
        Device         "intelgpu0"
        Monitor        "Monitor0"
        DefaultDepth    24
        SubSection     "Display"
            Depth       24
        EndSubSection
    EndSection

> Touchpad

Works fine, use xf86-input-synaptics for better control. Add
i8042.nomux=1 to kernel line, seems to help with jittery touchpad.

> Sound

Works out of box with no modifications.

> Power management

CPU throttling works out of box. Use /etc/systemd/logind.conf to change
behaviour of keys.

> Backlight

Works fine with backlight-control, use xbindkeys. FN+keys only seem to
work for audio levels with Xorg.

> Cardreader

Works with dkms-rts_bpp from aur, remember to blacklist existing mmc
modules.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_A55VJ&oldid=306091"

Category:

-   ASUS

-   This page was last modified on 20 March 2014, at 17:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
