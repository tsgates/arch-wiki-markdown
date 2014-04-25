HP Pavilion dv2-1030us
======================

With a bit of work, nearly all features can be made to work correctly.
HDMI out, and the webcam have not been tested yet, so their setup and
operation is not covered in this article.

Contents
--------

-   1 Hardware Details
    -   1.1 Output from 'lspci -k'
    -   1.2 Output from 'lsusb'
-   2 Setup
    -   2.1 Grub and Framebuffer Modes
    -   2.2 Audio
    -   2.3 Wireless
    -   2.4 Graphics

Hardware Details
----------------

> Output from 'lspci -k'

    00:00.0 Host bridge: ATI Technologies Inc RS690 Host Bridge
    	Subsystem: Hewlett-Packard Company Device 3055
    	Kernel modules: ati-agp
    00:02.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Graphics Port 0)
    	Kernel driver in use: pcieport-driver
    	Kernel modules: shpchp
    00:06.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Port 2)
    	Kernel driver in use: pcieport-driver
    	Kernel modules: shpchp
    00:07.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Port 3)
    	Kernel driver in use: pcieport-driver
    	Kernel modules: shpchp
    00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
    	Subsystem: Hewlett-Packard Company Device 3055
    	Kernel driver in use: ahci
    	Kernel modules: ahci
    00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0)
    	Subsystem: Hewlett-Packard Company Device 3055
    	Kernel driver in use: ohci_hcd
    	Kernel modules: ohci-hcd
    00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1)
    	Subsystem: Hewlett-Packard Company Device 3055
    	Kernel driver in use: ohci_hcd
    	Kernel modules: ohci-hcd
    00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2)
    	Subsystem: Hewlett-Packard Company Device 3055
    	Kernel driver in use: ohci_hcd
    	Kernel modules: ohci-hcd
    00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3)
    	Subsystem: Hewlett-Packard Company Device 3055
    	Kernel driver in use: ohci_hcd
    	Kernel modules: ohci-hcd
    00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4)
    	Subsystem: Hewlett-Packard Company Device 3055
    	Kernel driver in use: ohci_hcd
    	Kernel modules: ohci-hcd
    00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
    	Subsystem: Hewlett-Packard Company Device 3055
    	Kernel driver in use: ehci_hcd
    	Kernel modules: ehci-hcd
    00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 14)
    	Subsystem: Hewlett-Packard Company Device 3055
    	Kernel driver in use: piix4_smbus
    	Kernel modules: i2c-piix4
    00:14.1 IDE interface: ATI Technologies Inc SB600 IDE
    	Subsystem: Hewlett-Packard Company Device 3055
    	Kernel driver in use: pata_atiixp
    	Kernel modules: pata_atiixp, atiixp
    00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
    	Subsystem: Hewlett-Packard Company Device 3055
    	Kernel driver in use: HDA Intel
    	Kernel modules: snd-hda-intel
    00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
    	Subsystem: Hewlett-Packard Company Device 3055
    00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
    00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
    00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
    00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
    00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
    	Kernel driver in use: k8temp
    	Kernel modules: k8temp
    01:00.0 VGA compatible controller: ATI Technologies Inc Mobility Radeon HD 3400 Series
    	Subsystem: Hewlett-Packard Company Device 3055
    	Kernel driver in use: fglrx_pci
    	Kernel modules: fglrx
    01:00.1 Audio device: ATI Technologies Inc RV620 Audio device [Radeon HD 34xx Series]
    	Subsystem: ATI Technologies Inc RV620 Audio device [Radeon HD 34xx Series]
    	Kernel driver in use: HDA Intel
    	Kernel modules: snd-hda-intel
    02:00.0 Network controller: Broadcom Corporation BCM4322 802.11a/b/g/n Wireless LAN Controller (rev 01)
    	Subsystem: Hewlett-Packard Company Device 1509
    	Kernel driver in use: wl
    	Kernel modules: wl
    08:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
    	Subsystem: Hewlett-Packard Company Device 3055
    	Kernel driver in use: r8169
    	Kernel modules: r8169

> Output from 'lsusb'

    Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 001 Device 004: ID 0bda:0158 Realtek Semiconductor Corp. Mass Stroage Device
    Bus 001 Device 003: ID 0c45:62c0 Microdia Sonix USB 2.0 Camera
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Setup
-----

> Grub and Framebuffer Modes

Not all framebuffer modes are curretly supported by this hardware. For
example the argument vga=773 that I would normally add to the kernel
line of the grub menu.lst, gives strange and terrible results. Also, the
32bit 1024x768 mode does not work at all. I would suggest that you use
vga=791 (64K colors @ 1024x768) for the framebuffer mode if you decide
to use one.

> Audio

Initially I was having some serious problems getting this working. After
you get ALSA installed, it will likely detect several different sound
cards. Use

    cat /proc/asound/cards 

to get a printout of what cards are available. You then need to use the
following command to modify the sound levels on the appropriate card
from the list

    alsamixer -c# 

but replace the pound sign with the number corresponding to the
appropriate card (HDA ATI SB). Be sure to unmute both the headphone and
speaker channel. Also, do not forget to add alsa to the daemons section
of the rc.conf. The integrated speakers sound very good and are actually
quite loud, enjoy.

> Wireless

The wireless card in this computer is a BCM4322. You can follow the
instructions here, to set up wireless networking. Also like the page
says, the wireless interface will be named 'eth0', so dont be surpised.

-   Update (08.23.09) -- Ever since updating to kernel26 2.6.30.5-1 my
    wireless card stopped working. After cross referencing some driver
    and module settings with my backup ubuntu install, I determined that
    arch was now auto loading the 'b43' and 'ssb' module and using them
    instead of the 'wl' driver. To make your wireless card work again,
    you will need to blacklist the 'b43' and 'ssb' modules in your
    rc.conf like so.

    MODULES=(powernow-k8 ... !ssb !b43 lib80211_crypt_tkip wl)

After changing this, just restart your system and wireless should be
working again.

> Graphics

Instead of radeonhd drivers you can use the proprietary catalyst drivers
for better performance. The catalyst drivers are available in the AUR
and setup is exactly as described on the ATI page. Installing an AUR
Helper is recommended if you intend to maintain such a system. It will
make the process of building packages from the AUR much easier.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_dv2-1030us&oldid=196634"

Category:

-   HP

-   This page was last modified on 23 April 2012, at 12:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
