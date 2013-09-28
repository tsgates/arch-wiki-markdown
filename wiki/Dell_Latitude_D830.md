Dell Latitude D830
==================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 hwd's 输出                                                         |
| -   2 lspci                                                              |
| -   3 Components 详情                                                    |
|     -   3.1 Processor 处理器                                             |
|     -   3.2 Video 显卡                                                   |
|     -   3.3 Harddisk 硬盘                                                |
|     -   3.4 Screen 显示器                                                |
|     -   3.5 CD/DVD                                                       |
|     -   3.6 网络                                                         |
|     -   3.7 声卡                                                         |
+--------------------------------------------------------------------------+

hwd's 输出
----------

There a few variations on hardware available in the D830.

-   Graphics card:
    -   Intel Graphics Media Accelerator X3100: It offers basic 3D
        acceleration. There is an opensource drivers integrated into
        Xorg: xf86-video-intel.
    -   NVIDIA Quadro NVS 135M: This is a dedicated graphic card and
        offers advanced 3D acceleration. There is a proprietary driver
        available: nvidia-drivers.

-   WLAN card:
    -   Dell Wireless 1390 802.11g: This card is supported by the kernel
        driver b43.
    -   Dell Wireless 1490 802.11a/g: This card is supported by the
        kernel driver b43.
    -   Dell Wireless 1505 Draft 802.11n: There is basic support by
        ndiswrapper.
    -   Intel 3945 802.11a/g: This card is supported by the kernel
        driver iwl3945.
    -   Intel 4965 802.11a/g/n: This card is supported by the kernel
        driver iwl4965.

    $ sudo hwd -s
    HARDWARE DETECT ver 5.3.4 (simple mode)
     Kernel     : 2.6.26-ARCH
     CPU & Cache: Processor 0: Intel(R) Core(TM)2 Duo CPU     T9300  @ 2.50GHz 2000MHz, 6144 KB Cache
     Processor 1: Intel(R) Core(TM)2 Duo CPU     T9300  @ 2.50GHz 2000MHz, 6144 KB Cache
     Sound(a)   : 82801H ICH8 Family HD Audio Controller module: snd-hda-intel 
     Video      : Quadro NVS 140M server: Xorg (vesa)  
     Driver     : xf86-video-vesa   module: - 
     Monitor    : Generic Monitor  H: 28.0-96.0kHz V: 50.0-75.0Hz
     Mouse      : PS/2 Mouse xtype: PS2 device: /dev/psaux
     HDD        : 82801HBM/HEM ICH8M/ICH8ME SATA IDE Controller module: ata_piix 
     USB        : 82801H ICH8 Family USB2 EHCI Controller #1 module: ehci_hcd 
     USB2       : 82801H ICH8 Family USB2 EHCI Controller #2 module: ehci_hcd 
     USB Reader : O2 Micro, Inc. OZ776 CCID Smartcard
     Ethernet   : NetXtreme BCM5755M Gigabit Ethernet PCI Express module: tg3 
     Network    : PRO/Wireless 3945ABG Network Connection module: iwl3945 
     Bluetooth  : Dell Computer Corp. Wireless 360 Bluetooth
     Firewire   : Firewire IEEE 1394  module: ohci1394 
     PCMCIA slot: Cardbus bridge module: yenta_cardbus

lspci
-----

    00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
    00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
    00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
    00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Contoller #4 (rev 02)
    00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 02)
    00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 02)
    00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02)
    00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 02)
    00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 4 (rev 02)
    00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 02)
    00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f2)
    00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 02)
    00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 02)
    00:1f.2 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA IDE Controller (rev 02)
    00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
    03:01.0 CardBus bridge: O2 Micro, Inc. Cardbus bridge (rev 21)
    03:01.4 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02)
    09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5755M Gigabit Ethernet PCI Express (rev 02)
    0c:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)

Components 详情
---------------

> Processor 处理器

Intel Core 2 Duo T7300 "Merom" @ 2.0 GHz (4 MB L2, 800 MHz FSB)

> Video 显卡

Intel GM965 X3100

> Harddisk 硬盘

120 GB @ 7200 RPM

> Screen 显示器

1920x1200 WUXGA

> CD/DVD

DVD +/-RW

> 网络

> 声卡

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Latitude_D830&oldid=249604"

Category:

-   Dell
