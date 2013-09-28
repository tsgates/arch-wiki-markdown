Latitude E5520
==============

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware Details                                                   |
| -   2 UEFI                                                               |
| -   3 Graphics                                                           |
| -   4 Input / Output Devices                                             |
| -   5 SD Card Reader                                                     |
+--------------------------------------------------------------------------+

Hardware Details
----------------

    00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
    00:16.0 Communication controller: Intel Corporation 6 Series Chipset Family MEI Controller #1 (rev 04)
    00:1a.0 USB Controller: Intel Corporation 6 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
    00:1b.0 Audio device: Intel Corporation 6 Series Chipset Family High Definition Audio Controller (rev 04)
    00:1c.0 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 1 (rev b4)
    00:1c.1 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 2 (rev b4)
    00:1c.2 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 3 (rev b4)
    00:1c.5 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 6 (rev b4)
    00:1c.6 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 7 (rev b4)
    00:1d.0 USB Controller: Intel Corporation 6 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
    00:1f.0 ISA bridge: Intel Corporation HM65 Express Chipset Family LPC Controller (rev 04)
    00:1f.2 SATA controller: Intel Corporation 6 Series Chipset Family 6 port SATA AHCI Controller (rev 04)
    00:1f.3 SMBus: Intel Corporation 6 Series Chipset Family SMBus Controller (rev 04)
    02:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 (rev 34)
    09:00.0 FireWire (IEEE 1394): O2 Micro, Inc. Device 13f7 (rev 05)
    09:00.1 SD Host controller: O2 Micro, Inc. Device 8321 (rev 05)
    09:00.2 Mass storage controller: O2 Micro, Inc. Device 8331 (rev 05)
    0a:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5761 Gigabit Ethernet PCIe (rev 10)

    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 001 Device 003: ID 1bcf:280b Sunplus Innovation Technology Inc. 
    Bus 002 Device 003: ID 413c:8187 Dell Computer Corp. DW375 Bluetooth Module
    Bus 002 Device 009: ID 413c:3012 Dell Computer Corp. Optical Wheel Mouse

    coretemp-isa-0000
    Adapter: ISA adapter
    Physical id 0:  +57.0°C  (high = +86.0°C, crit = +100.0°C)
    Core 0:         +50.0°C  (high = +86.0°C, crit = +100.0°C)
    Core 1:         +50.0°C  (high = +86.0°C, crit = +100.0°C)

    acpitz-virtual-0
    Adapter: Virtual device
    temp1:        +25.0°C  (crit = +107.0°C)

UEFI
----

This laptop is UEFI-capable. The following articles were found to be
helpful in setting up this laptop to boot in UEFI mode:

-   UEFI
-   GPT
-   GRUB2

Earlier kernels (before 3.0) were unable to boot in UEFI mode on this
laptop unless "noefi" was passed on the kernel line. Later kernel
versions should boot correctly.

Graphics
--------

The integrated HD3000 GPU was found to work and perform well, although
graphical corruption was experienced in certain configurations of KDE
(before 4.7) and Xorg (before 1.11). This was found to be largely caused
by DRI configuration related to S3TC, and was significantly improved by
creating a ~/.drirc file with the following contents:

    <driconf>
        <device screen="0" driver="i965">
            <application name="Default">
                <option name="force_s3tc_enable" value="true" />
            </application>
        </device>
    </driconf>

This configuration file may be created using the graphical utility
driconf, available in the [community] repository. At least one game
(Braid) will not start without this modification at the time of writing.

Input / Output Devices
----------------------

This is the output from xinput list:

    ⎡ Virtual core pointer                          id=2    [master pointer  (3)]
    ⎜   ↳ Virtual core XTEST pointer                id=4    [slave  pointer  (2)]
    ⎜   ↳ DualPoint Stick                           id=13   [slave  pointer  (2)]
    ⎜   ↳ AlpsPS/2 ALPS DualPoint TouchPad          id=14   [slave  pointer  (2)]
    ⎣ Virtual core keyboard                         id=3    [master keyboard (2)]
        ↳ Virtual core XTEST keyboard               id=5    [slave  keyboard (3)]
        ↳ Power Button                              id=6    [slave  keyboard (3)]
        ↳ Video Bus                                 id=7    [slave  keyboard (3)]
        ↳ Power Button                              id=8    [slave  keyboard (3)]
        ↳ Sleep Button                              id=9    [slave  keyboard (3)]
        ↳ Laptop_Integrated_Webcam_FHD              id=10   [slave  keyboard (3)]
        ↳ AT Translated Set 2 keyboard              id=12   [slave  keyboard (3)]
        ↳ Dell WMI hotkeys                          id=15   [slave  keyboard (3)]

-   The keyboard (including number pad), power button, audio hotkeys,
    webcam, audio, and microphone were found to work flawlessly without
    any intervention.

-   The "Track Stick" performs as expected. The touchpad supports
    synaptic extensions, but not multitouch.

SD Card Reader
--------------

As of Kernel 3.0, the SD Card Reader does not react when a card is
inserted. This can be rectified by removing the Firewire driver from the
kernel:

    sudo modprobe -r firewire_ohci

To make the change permanent, remember to blacklist the firewire_ohci
module (see Blacklisting).

Even with this fix, some corruption has occurred on certain SD cards
when using the drive, along with seemingly related kernel panics. It
would appear than driver support is lacking for this device.

This may be related to the following kernel warning, which appears at
boot time:

    sdhci-pci 0000:09:00.1: Invalid iomem size. You may experience problems.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Latitude_E5520&oldid=237949"

Category:

-   Dell
