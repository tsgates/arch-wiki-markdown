HP Pavilion DV7-4263cl
======================

Arch Linux is currently running successfully on this laptop. This page
is a major work in progress

Contents
--------

-   1 Modules
-   2 Hardware info
    -   2.1 lspci
    -   2.2 video
    -   2.3 wireless
    -   2.4 sound
    -   2.5 clickpad

> Modules

-   Ethernet: r8169
-   Wireless: ath9k
-   Audio:
-   Video: ati or fglrx

> Hardware info

lspci

    00:00.0 Host bridge: Advanced Micro Devices [AMD] RS880 Host Bridge
    00:01.0 PCI bridge: Advanced Micro Devices [AMD] RS780/RS880 PCI to PCI bridge (int gfx)
    00:02.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (ext gfx port 0)
    00:05.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 1)
    00:06.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 2)
    00:11.0 SATA controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
    00:12.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
    00:12.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
    00:13.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
    00:13.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
    00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 42)
    00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA) (rev 40)
    00:14.3 ISA bridge: ATI Technologies Inc SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
    00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (rev 40)
    00:14.5 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
    00:16.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
    00:16.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
    00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration
    00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Address Map
    00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller
    00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control
    00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Link Control
    01:05.0 VGA compatible controller: ATI Technologies Inc M880G [Mobility Radeon HD 4200]
    02:00.0 VGA compatible controller: ATI Technologies Inc Robson CE [AMD Radeon HD 6300 Series] (rev ff)
    02:00.1 Audio device: ATI Technologies Inc Manhattan HDMI Audio [Mobility Radeon HD 5000 Series] (rev ff)
    03:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
    04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)

video

Open source ATI drivers (xf86-video-ati)

-   the PC seems to run much hotter with these drivers
-   these work fine and provide hardware acceleration for Gnome 3 but
    not enough for OpenGL games like Minecraft
-   suspend and hibernate do not work with these drivers installed

Closed source ATI drivers (catalyst in AUR)

-   the OpenGL performance is much improved of the OSS drivers however
    there are problems with Gnome 3. This is an upstream problem and not
    specific to Arch.

The closed source drivers average about 158F while idle and the open
source average about 134F.

Need to confirm HDMI and VGA output works.

wireless

The Atheros card is this laptop has open source drivers so nothing
special is needed.

sound

The basic sound works out of the box but the subwoofer does not. To
enabled the subwoofer add the following to /etc/modprobe.d/alsa.conf
(create it if it's not there) and reboot.

    options snd-hda-intel model=hp-dv7-4000

Note: When I rebooted the first time my Mute key didn't work until I
manually unmuted through alsamixer. After that it worked fine.

clickpad

The touchpad is known as a clickpad. Usage of clickpads are
significantly different from touchpads. Here's what I've found so far:

-   right click - two finger tap
-   click and drag - hold Alt key and triple-tap
-   scroll - two finger drag
-   double tap in upper left corner to disable - doesn't work

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_DV7-4263cl&oldid=196644"

Category:

-   HP

-   This page was last modified on 23 April 2012, at 12:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
