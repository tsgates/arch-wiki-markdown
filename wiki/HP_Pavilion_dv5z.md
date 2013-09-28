HP Pavilion dv5z
================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware Specifications                                            |
|     -   1.1 Output of "dmidecode"                                        |
|     -   1.2 Output of "lspci -k"                                         |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 AMD Turion X2 Ultra Processor                                |
|     -   2.2 Radeon HD3450 (radeonhd)                                     |
|     -   2.3 Radeon HD3450 (fglrx)                                        |
|     -   2.4 Intel HD Audio                                               |
|     -   2.5 Realtek LAN                                                  |
|     -   2.6 Atheros 802.11n Wireless                                     |
|     -   2.7 Broadcom Bluetooth                                           |
|     -   2.8 Webcam                                                       |
|     -   2.9 Fingerprint Reader                                           |
|     -   2.10 Card Reader                                                 |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 Framebuffer                                                  |
|     -   3.2 ALSA                                                         |
+--------------------------------------------------------------------------+

Hardware Specifications
=======================

-   AMD Turion(TM) X2 Ultra Dual-Core Mobile Processor ZM-80 (2.1 GHz)
-   15.4" diagonal WSXGA+ High-Definition HP BrightView Widescreen
    Display (1680 x 1050)
-   3GB DDR2 System Memory
-   256MB ATI Radeon(TM) HD 3450 Graphics
-   250GB 5400RPM SATA Hard Drive with HP ProtectSmart Hard Drive
    Protection
-   Atheros 802.11a/b/g/n WLAN with Bluetooth
-   SuperMulti 8X DVD+/-R/RW with Double Layer Support
-   Webcam Only (no Fingerprint Reader)
-   JMicron SD,MS/Pro,MMC,XD Card Reader

Output of "dmidecode"
---------------------

    BIOS Information
            Vendor: Hewlett-Packard
            Version: F.11
            Release Date: 08/06/2008

    System Information
            Manufacturer: Hewlett-Packard
            Product Name: HP Pavilion dv5 Notebook PC
            Version: Rev 1

  

Output of "lspci -k"
--------------------

    00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
            Subsystem: Hewlett-Packard Company Device 3600
    00:02.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (ext gfx port 0)
            Kernel driver in use: pcieport-driver
            Kernel modules: shpchp
    00:04.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 0)
            Kernel driver in use: pcieport-driver
            Kernel modules: shpchp
    00:05.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 1)
            Kernel driver in use: pcieport-driver
            Kernel modules: shpchp
    00:06.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 2)
            Kernel driver in use: pcieport-driver
            Kernel modules: shpchp
    00:0a.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 5)
            Kernel driver in use: pcieport-driver
            Kernel modules: shpchp
    00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode]
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel driver in use: ahci
            Kernel modules: ahci
    00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel driver in use: ohci_hcd
            Kernel modules: ohci-hcd
    00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel driver in use: ohci_hcd
            Kernel modules: ohci-hcd
    00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel driver in use: ehci_hcd
            Kernel modules: ehci-hcd
    00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel driver in use: ohci_hcd
            Kernel modules: ohci-hcd
    00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel driver in use: ohci_hcd
            Kernel modules: ohci-hcd
    00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel driver in use: ehci_hcd
            Kernel modules: ehci-hcd
    00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel driver in use: piix4_smbus
            Kernel modules: i2c-piix4
    00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel driver in use: pata_atiixp
            Kernel modules: atiixp, ide-pci-generic, pata_acpi, ata_generic, pata_atiixp
    00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel driver in use: HDA Intel
            Kernel modules: snd-hda-intel
    00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
            Subsystem: Hewlett-Packard Company Device 3600
    00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
    00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 11h HyperTransport Configuration (rev 40)
    00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 11h Address Map
    00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 11h DRAM Controller
    00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 11h Miscellaneous Control
    00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 11h Link Control
    01:00.0 VGA compatible controller: ATI Technologies Inc Mobility Radeon HD 3400 Series
            Subsystem: Hewlett-Packard Company Device 3600
    01:00.1 Audio device: ATI Technologies Inc RV620 Audio device [Radeon HD 34xx Series]
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel driver in use: HDA Intel
            Kernel modules: snd-hda-intel
    08:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
            Subsystem: Hewlett-Packard Company Device 1381
            Kernel driver in use: ath9k
            Kernel modules: ath9k
    09:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel driver in use: r8169
            Kernel modules: r8169
    0a:00.0 FireWire (IEEE 1394): JMicron Technologies, Inc. IEEE 1394 Host Controller
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel driver in use: ohci1394
            Kernel modules: ohci1394
    0a:00.1 System peripheral: JMicron Technologies, Inc. SD/MMC Host Controller
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel driver in use: sdhci-pci
            Kernel modules: sdhci-pci
    0a:00.2 SD Host controller: JMicron Technologies, Inc. Standard SD Host Controller
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel modules: sdhci-pci
    0a:00.3 System peripheral: JMicron Technologies, Inc. MS Host Controller
            Subsystem: Hewlett-Packard Company Device 3600
            Kernel driver in use: jmb38x_ms
            Kernel modules: jmb38x_ms
    0a:00.4 System peripheral: JMicron Technologies, Inc. xD Host Controller
            Subsystem: Hewlett-Packard Company Device 3600

  

Configuration
=============

AMD Turion X2 Ultra Processor
-----------------------------

See CPU Frequency Scaling.

Radeon HD3450 (radeonhd)
------------------------

I have not noticed any issues using the "xf86-video-radeonhd" driver. I
have not tried the HDMI out with Arch, but under Ubuntu it would only
work with the proprietary ATI driver.

Radeon HD3450 (fglrx)
---------------------

I have not tested the fglrx driver under Arch. If you have experience
with this driver, please feel free to update this section with your
config.

Intel HD Audio
--------------

ALSA sound was discovered through hwdetect during the install. All
necessary modules were loaded by the installer.

Realtek LAN
-----------

The wired connection worked after loading the "r8169" module.

Atheros 802.11n Wireless
------------------------

Wireless works after loading the "ath9k" module.

Broadcom Bluetooth
------------------

Webcam
------

Fingerprint Reader
------------------

My model did not come with a fingerprint reader. If you have experience
with this device, please feel free to update this section with your
config.

Card Reader
-----------

Troubleshooting
===============

Framebuffer
-----------

None of the values given in the default "/boot/grub/menu.lst" for higher
resolution framebuffers worked with the dv5z. In order to find the
available modes I had to download hwinfo from AUR.

    Mode 0x323: 1024x768 (+4096), 24 bits
    Mode 0x324: 1280x1024 (+5120), 24 bits
    Mode 0x346: 1400x1050 (+5632), 24 bits
    Mode 0x356: 1152x864 (+4608), 24 bits
    Mode 0x366: 1280x960 (+5120), 24 bits

ALSA
----

The Arch install process found and added my sound modules automatically
via hwdetect. Despite this, I could not get any sound to play. Many
people across multiple distributions seem to think this is an error with
the 2.6.28 kernel, so this may be obsolete with future releases. Should
you come across this issue, add the following line into
"/etc/modprobe.d/modprobe.conf"

    options snd-hda-intel model=hp-m4 enable_msi=1

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_dv5z&oldid=196638"

Category:

-   HP
