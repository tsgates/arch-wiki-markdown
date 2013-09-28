Acer Aspire TimelineX 4820TG
============================

Acer Aspire TimelineX 4820TG is a 14-inch laptop that packs in an Intel
Core i5-430M processor and dedicated ATI Radeon HD 5650 graphics, making
it a powerful 14-inch laptop. ArchLinux works mostly works out of box,
but there are few tweaks required to make the hardware fully compatible
with ArchLinux.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 PowerSmart / Battery Optimization                                  |
|     -   2.1 Switchable Graphics                                          |
|     -   2.2 Enable CPU Frequency Scaling                                 |
|     -   2.3 Power Usage                                                  |
|     -   2.4 Sensors                                                      |
|                                                                          |
| -   3 Synaptics Touchpad                                                 |
+--------------------------------------------------------------------------+

Hardware
--------

    [root@arp arp]# lspci

    00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 12)
    00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16 Root Port (rev ff)
    00:02.0 VGA compatible controller: Intel Corporation Core Processor Integrated Graphics Controller (rev 12)
    00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series Chipset HECI Controller (rev 06)
    00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 05)
    00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 05)
    00:1c.5 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 6 (rev 05)
    00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5)
    00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 05)
    00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 4 port SATA AHCI Controller (rev 05)
    00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 05)
    00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem (rev 05)
    01:00.0 VGA compatible controller: ATI Technologies Inc Redwood [Radeon HD 5600 Series] (rev ff)
    01:00.1 Audio device: ATI Technologies Inc Redwood HDMI Audio [Radeon HD 5600 Series] (rev ff)
    02:00.0 Ethernet controller: Atheros Communications AR8151 v1.0 Gigabit Ethernet (rev c0)
    03:00.0 Network controller: Broadcom Corporation BCM43225 802.11b/g/n (rev 01)
    7f:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers (rev 02)
    7f:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 02)
    7f:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
    7f:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 02)
    7f:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
    7f:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)

Make sure that you have BIOS_Acer_1.25_A_A.zip installed.

PowerSmart / Battery Optimization
---------------------------------

> Switchable Graphics

This laptop contains inbuilt Intel HD & Radeon 5650 graphics adapters.
The Intel HD graphics adapter is optimized for low power consumption
which Radeon 5650 consumes high power.

To use Linux kernel's "Laptop Hybrid Graphics - GPU switching support"
add following to /etc/fstab

    none            /sys/kernel/debug debugfs defaults 0 0

This will enable /sys/kernel/debug/vgaswitcheroo/switch

    [root@arp arp]# cat /sys/kernel/debug/vgaswitcheroo/switch
    0:IGD:+:Pwr:0000:00:02.0
    1:DIS: :Pwr:0000:01:00.0

IDN - denotes integrated Intel graphics. DIS - denotes discrete Radeon
graphics.

To switch-off Radeon, do following -

    [root@arp arp]# echo "DIGD" > /sys/kernel/debug/vgaswitcheroo/switch
    [root@arp arp]# echo "OFF"  > /sys/kernel/debug/vgaswitcheroo/switch

    [root@arp arp]# cat /sys/kernel/debug/vgaswitcheroo/switch
    0:IGD:+:Pwr:0000:00:02.0
    1:DIS: :Off:0000:01:00.0

To switch-on both graphics chips, do following -

    [root@arp arp]# echo "DIGD" > /sys/kernel/debug/vgaswitcheroo/switch
    [root@arp arp]# echo "DDIS" > /sys/kernel/debug/vgaswitcheroo/switch

Init script for switching off the Radeon card -

Note:There is now a vgaswitcheroo systemd service which should be used
instead

    [root@arp arp]# cat /etc/rc.d/radeon_off 

    #!/bin/bash

    . /etc/rc.conf
    . /etc/rc.d/functions

    case "$1" in

       start)
       echo "DIGD" > /sys/kernel/debug/vgaswitcheroo/switch
       echo "OFF"  > /sys/kernel/debug/vgaswitcheroo/switch
       ;;

       stop)
       echo "DIGD" > /sys/kernel/debug/vgaswitcheroo/switch
       echo "DDIS" > /sys/kernel/debug/vgaswitcheroo/switch
       ;;

       restart)
         stat_busy "Restarting radeon_off ..."
         $0 stop
         $0 start
         stat_done
       ;;

       *)
         echo "usage: $0 {start|stop|restart}"
    esac

    [root@arp arp]# chmod +x /etc/rc.d/radeon_off 

Switch the Radeon off while booting. Add following at the end of the
file : /etc/rc.sysinit

    #Switch-off discrete graphics
    /etc/rc.d/radeon_off restart

    /bin/dmesg >| /var/log/dmesg.log

> Enable CPU Frequency Scaling

Enabled by default, see CPU Frequency Scaling for details.

> Power Usage

The power rating before tweak -

    Power usage (ACPI estimate): 24.1W (2.8 hours)

The power rating after "switching off the radeon graphics" and "enabling
laptop-mode tools".

    Power usage (ACPI estimate): 11.1W (6.5 hours)

> Sensors

    [arp@arpc ~]$ sudo modprobe coretemp
    [arp@arpc ~]$ sensors
    acpitz-virtual-0
    Adapter: Virtual device
    temp1:        +53.0°C  (crit = +105.0°C)

    radeon-pci-0100
    Adapter: PCI adapter
    temp1:       +2147355.6°C  

    coretemp-isa-0000
    Adapter: ISA adapter
    Core 0:       +49.0°C  (high = +95.0°C, crit = +105.0°C)

    coretemp-isa-0002
    Adapter: ISA adapter
    Core 2:       +53.0°C  (high = +95.0°C, crit = +105.0°C)

Synaptics Touchpad
------------------

The Synaptics driver is available from xf86-input-synaptics package
[extra] repository

     # pacman -S xf86-input-synaptics

The default configuration is available at
/etc/X11/xorg.conf.d/10-synaptics.conf

    Section "InputClass"
            Identifier "touchpad catchall"
            Driver "synaptics"
            MatchIsTouchpad "on"
            MatchDevicePath "/dev/input/event*"
            Option "TapButton1" "1"
            Option "TapButton2" "2"
            Option "TapButton3" "3"
            Option "SHMConfig"  "true"
            Option "VertEdgeScroll" "on"
            Option "VertTwoFingerScroll" "on"
            Option "HorizEdgeScroll" "on"
            Option "HorizTwoFingerScroll" "on"
            Option "CircularScrolling" "on"
            Option "CircScrollTrigger" "2"
            Option "EmulateTwoFingerMinZ" "0"
    EndSection

For more information check Touchpad_Synaptics

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_TimelineX_4820TG&oldid=246396"

Category:

-   Acer
