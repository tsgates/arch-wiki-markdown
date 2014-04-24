ASUS Zenbook UX51Vz
===================

This page contains instructions, tips, pointers, and links for
installing and configuring Arch Linux on the ASUS Zenbook UX51Vz
ultrabook.

See the page for its 13" variant ASUS Zenbook Prime UX31A that has
mostly orthogonal information to those here (may be only partially
applicable to UX51Vz)

Contents
--------

-   1 Installation
    -   1.1 Boot from USB medium
-   2 Function keys
-   3 Solid State Drive
-   4 Touchpad
-   5 Powersave management
-   6 Hardware and Modules
    -   6.1 PCI
-   7 Additional resources

Installation
------------

The UX51Vz comes in a variety of configurations, most of those sold in
western Europe come with two SSDs (2x128GB or 2x256GB) in an Intel Rapid
Storage (aka Intel Matrix) RAID 0 configuration. To install Arch Linux
on the UX51Vz, you can follow the official Installation guide. Since the
UX51Vz uses UEFI and GPT, make sure to also read the UEFI, GPT and
UEFI_Bootloaders pages. It is recommended to use rEFInd as a bootloader
and mount the EFI partition on /boot. To prepare a UEFI USB device, read
UEFI#Create_UEFI_bootable_USB_from_ISO. The only way to preserve the
pre-installed Windows instance is to install Arch with RAID without
breaking up the RAID 0 array. See RAID with the only difference that you
should not create arrays, only assemble.

Note:As of BIOS version 207 on UX51VZH there is no option to reconfigure
the Intel RST setup through BIOS. Once you break your array, you cannot
set it up again. For Linux-only users, mdadm software raid should be a
better option.

To report the RAID information from the Option ROM (for instance
"Intel(R) Matrix Storage Manager"):

    mdadm --detail-platform

To get general details:

    mdadm -D /dev/md127

To examine information (including members):

    mdadm -E /dev/md127

This is the important part that uses imsm (Intel Matrix) metadata! To
assemble the RAID array inside the container, and/or to start it (the -e
option declares the style of RAID metadata (superblock) to be used):

    mdadm -I -e imsm /dev/md127

To check the current state:

    cat /proc/mdstat

To add it to the configuration file (to be activated automagically at
boot):

    mdadm --examine --scan >> /etc/mdadm.conf

Then proceed with partitioning and file systems creation as usual.

> Boot from USB medium

Press Escape to get into the boot menu. If the USB bootable device is
not listed, enter the configuration menu and directly press F10 to save.
Press Escape again on reboot: This time the USB bootable device should
appear in the menu.

Select 'Boot Arch Linux (x86_64)" and press Enter. The installation
system will be booted and you will end up with a terminal.

Function keys
-------------

The function keys are largely the same as described in ASUS Zenbook
Prime UX31A. This goes for both screen backlight (which actually works
out of the box on KDE as of June 2013) and keyboard backlight.

Solid State Drive
-----------------

Check Solid_State_Drives

Touchpad
--------

See ASUS Zenbook Prime UX31A, the touchpad is the same.

Powersave management
--------------------

For automatic powersaving when on battery configure Laptop_Mode_Tools.
For manual power saving see Power saving. Also check out Powertop.

The UX51Vz can run a little hot, this is especially true for the HiDPI
variant (aka UX51VZH) because the discrete GPU is always on. Be sure to
check out Linux Thermal Daemon (available as thermald in the AUR), which
proactively controls thermal using P-states, T-states, and the Intel
power clamp driver. It can do wonders for temperature management while
avoiding to spin up the fans.

Hardware and Modules
--------------------

PCI

This is output of lspci -nnn -k on the UX51Vz-DB114H. Note that unlike
most other UX51Vz models, this one has no integrated Intel graphics
(plain Nvidia, not Optimus) and a retina 2880x1620 display.

    00:00.0 Host bridge [0600]: Intel Corporation 3rd Gen Core processor DRAM Controller [8086:0154] (rev 09)
           Subsystem: ASUSTeK Computer Inc. Device [1043:15a7]
    00:01.0 PCI bridge [0604]: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor PCI Express Root Port [8086:0151] (rev 09)
           Kernel driver in use: pcieport
           Kernel modules: shpchp
    00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04)
           Subsystem: ASUSTeK Computer Inc. Device [1043:15a7]
           Kernel driver in use: xhci_hcd
           Kernel modules: xhci_hcd
    00:16.0 Communication controller [0780]: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 [8086:1e3a] (rev 04)
           Subsystem: ASUSTeK Computer Inc. Device [1043:15a7]
           Kernel driver in use: mei
           Kernel modules: mei
    00:1a.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 [8086:1e2d] (rev 04)
           Subsystem: ASUSTeK Computer Inc. Device [1043:15a7]
           Kernel driver in use: ehci-pci
           Kernel modules: ehci_pci
    00:1b.0 Audio device [0403]: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller [8086:1e20] (rev 04)
           Subsystem: ASUSTeK Computer Inc. Device [1043:15a7]
           Kernel driver in use: snd_hda_intel
           Kernel modules: snd_hda_intel
    00:1c.0 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 [8086:1e10] (rev c4)
           Kernel driver in use: pcieport
           Kernel modules: shpchp
    00:1c.1 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 [8086:1e12] (rev c4)
           Kernel driver in use: pcieport
           Kernel modules: shpchp
    00:1c.3 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 4 [8086:1e16] (rev c4)
           Kernel driver in use: pcieport
           Kernel modules: shpchp
    00:1d.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04)
           Subsystem: ASUSTeK Computer Inc. Device [1043:15a7]
           Kernel driver in use: ehci-pci
           Kernel modules: ehci_pci
    00:1f.0 ISA bridge [0601]: Intel Corporation HM77 Express Chipset LPC Controller [8086:1e57] (rev 04)
           Subsystem: ASUSTeK Computer Inc. Device [1043:15a7]
           Kernel driver in use: lpc_ich
           Kernel modules: lpc_ich
    00:1f.2 RAID bus controller [0104]: Intel Corporation 82801 Mobile SATA Controller [RAID mode] [8086:282a] (rev 04)
           Subsystem: ASUSTeK Computer Inc. Device [1043:15a7]
           Kernel driver in use: ahci
           Kernel modules: ahci 
    00:1f.3 SMBus [0c05]: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller [8086:1e22] (rev 04)
           Subsystem: ASUSTeK Computer Inc. Device [1043:15a7]
           Kernel modules: i2c_i801
    01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GK107M [GeForce GT 650M] [10de:0fd1] (rev a1)
           Subsystem: ASUSTeK Computer Inc. GeForce GT 650M [1043:2141]
           Kernel driver in use: nvidia
           Kernel modules: nouveau, nvidia
    01:00.1 Audio device [0403]: NVIDIA Corporation GK107 HDMI Audio Controller [10de:0e1b] (rev a1)
           Subsystem: NVIDIA Corporation GK107 HDMI Audio Controller [10de:0e1b]
           Kernel driver in use: snd_hda_intel
           Kernel modules: snd_hda_intel
    03:00.0 Network controller [0280]: Intel Corporation Centrino Advanced-N 6235 [8086:088e] (rev 24)
           Subsystem: Intel Corporation Centrino Advanced-N 6235 AGN [8086:4060]
           Kernel driver in use: iwlwifi
           Kernel modules: iwlwifi
    04:00.0 Ethernet controller [0200]: Qualcomm Atheros AR8151 v2.0 Gigabit Ethernet [1969:1083] (rev c0)
           Subsystem: ASUSTeK Computer Inc. Device [1043:15a7]
           Kernel driver in use: atl1c
           Kernel modules: atl1c

Additional resources
--------------------

-   https://help.ubuntu.com/community/AsusZenbookPrime
-   http://ubuntuforums.org/showthread.php?t=2005999
-   Wikipedia:Zenbook#UX32.2C_UX42_and_UX52
-   http://bertrandbenoit.blogspot.it/2011/07/manage-intel-raid-under-gnulinux-using.html

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Zenbook_UX51Vz&oldid=298259"

Category:

-   ASUS

-   This page was last modified on 16 February 2014, at 07:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
