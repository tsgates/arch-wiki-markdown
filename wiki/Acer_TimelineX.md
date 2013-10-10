Acer TimelineX
==============

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Hardware is a 4820TG/5820TG, but should be similar for all these
laptops.

  --------------- ------------------- ------------------
  Device          Status              Modules
  Intel           Working             xf86-video-intel
  Ati             Partially Working   xf86-video-ati
  Ati             Working             fglrx
  Bluetooth       Working             bluetooth
  Ethernet        Working             atl1c (2.6.36)
  Wireless        Working             ath9k / wl
  Wireless        Working             bcm4357 / wl
  Audio           Working             snd_hda_intel
  Camera          Working             uvcvideo
  Card Reader     Working             
  Function Keys   Working             
  --------------- ------------------- ------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Xorg                                                               |
|     -   2.1 Open source drivers                                          |
|     -   2.2 Closed Catalyst drivers                                      |
|     -   2.3 Switchable Graphics                                          |
|     -   2.4 Touchpad                                                     |
|     -   2.5 Keyboard                                                     |
|                                                                          |
| -   3 ACPI                                                               |
|     -   3.1 Laptop Mode Tools                                            |
|                                                                          |
| -   4 Hardware                                                           |
|     -   4.1 Bluetooth                                                    |
|     -   4.2 Wi-Fi                                                        |
|         -   4.2.1 TimelineX 5820                                         |
|         -   4.2.2 TimelineX 4820TG                                       |
|         -   4.2.3 TimelineX 3820TG                                       |
|                                                                          |
|     -   4.3 Camera                                                       |
|     -   4.4 Card Reader                                                  |
|     -   4.5 Display brightness control                                   |
|                                                                          |
| -   5 Info                                                               |
|     -   5.1 lspci                                                        |
|     -   5.2 lspci - TimelineX 4820TG (with Broadcom 4357 wifi)           |
|     -   5.3 lspci - TimelineX 3820TG-5464G50iks                          |
|                                                                          |
| -   6 Issues                                                             |
| -   7 Links                                                              |
+--------------------------------------------------------------------------+

Installation
------------

There is a quirk if you want to install Arch Linux. You need to connect
via wireless, as Ethernet hardware is supported only by Linux kernel
2.6.34 and higher. Follow the Beginners' Guide for the rest.

Xorg
----

> Open source drivers

You need ati and i915 xorg drivers:

    pacman -S xf86-video-ati xf86-video-intel

While installing Arch Linux, you should disable the radeon kernel
module, otherwise you may encounter kernel crash during booting. See
Kernel_modules#Blacklisting for instructions.

If you need to use radeon and HDMI, you can manually enable it by
executing

    modprobe radeon

TimelineX 4820TG is having switchable graphics. To disable switchable
graphics, add following to /etc/modprobe.d/radeon.conf

    options radeon modeset=0

For more information, check Intel and ATI.

> Closed Catalyst drivers

Catalyst (also known as fglrx) is a closed source graphics driver
provided by ATI. It does not support certain features that the open
source drivers do, but it has fully working, fast 3D acceleration. This
is working at least with Acer Aspire TimelineX 3820TG that has ATI
Mobility Radeon HD 5650.

Since Catalyst cannot handle switchable graphics cards, you have to
disable the Intel card from the BIOS. At least with BIOS v.1.19 you can
do that by changing VGA mode to "Discrete".

If you use the stock kernel you can install Catalyst with the AUR
packages catalyst-utils and catalyst. If you have a 64-bit system and
you want to use 3D acceleration also in 32-bit games, you should also
install lib32-catalyst-utils.

See the AMD Catalyst wiki page for third-party repository and
configuration after install.

> Switchable Graphics

Switching video cards works with the open source graphics driver.

You must have debugfs mounted for the switch access:

    # mount -t debugfs debugfs /sys/kernel/debug

or add following to /etc/fstab:

    debugfs /sys/kernel/debug debugfs 0 0

Make sure that your radeon driver is loaded:

    modprobe radeon

Then you can use the following commands:

    #Check current status:
    cat /sys/kernel/debug/vgaswitcheroo/switch

    #Enable ATI
    echo DDIS > /sys/kernel/debug/vgaswitcheroo/switch

    #Enable Intel
    echo DIGD > /sys/kernel/debug/vgaswitcheroo/switch

    #Power off unused card
    echo OFF > /sys/kernel/debug/vgaswitcheroo/switch

    #Power on unused card
    echo ON > /sys/kernel/debug/vgaswitcheroo/switch

You may also use acpi_call module to switch graphics. There is a package
in the AUR named acpi_call-git.

By doing the following, my TimelineX 4820TG laptop's battery life got
improved significantly (now it gives 5+ hours on average .. with
laptop-mode customization and radeon switchoff) -

    #mount -t debugfs none /sys/kernel/debug
    #modprobe radeon
    #echo ON > /sys/kernel/debug/vgaswitcheroo/switch
    #echo OFF > /sys/kernel/debug/vgaswitcheroo/switch
    #cat /sys/kernel/debug/vgaswitcheroo/switch
    0:+:Pwr:0000:00:02.0
    1: :Off:0000:01:00.0

> Touchpad

Touchpad is a synaptics so you need its driver:

    pacman -S xf86-input-synaptics

Then add to /etc/X11/xorg.conf.d/ a new file (name it 20-synaptics.conf)

    Section "InputClass"
     Identifier "touchpad"
     Driver "synaptics"
     MatchIsTouchpad "on"
     Option "SHMConfig" "on"
     Option "TapButton1" "1"
     Option "TapButton2" "2"
     Option "TapButton3" "3"
     Option "VertEdgeScroll" "on"
     Option "VertTwoFingerScroll" "on"
     Option "HorizEdgeScroll" "on"
     Option "HorizTwoFingerScroll" "on"
     Option "CircularScrolling" "on"
     Option "CircScrollTrigger" "2"
     Option "EmulateTwoFingerMinZ" "0"
    EndSection

For more info, check Touchpad_Synaptics.

> Keyboard

Add a new file in /etc/X11/xorg.conf.d/ (name it 20-keymap.conf)

    Section "InputClass"
            Identifier "Acer Keyboard"
            MatchIsKeyboard "on"
            MatchDevicePath "/dev/input/event*"
            Option                 "XkbLayout" "it"
            Option                 "XkbModel" "acer_laptop"
            Driver "evdev"
    EndSection

Replace it with your keymap.

ACPI
----

ACPI works with BIOS v1.18 and higher.

BIOS v1.19 for 4820tg

BIOS v1.19 for 3820tg

If you do not have Windows installed, you can flash with a FreeDOS thumb
drive.

> Laptop Mode Tools

Install laptop-mode-tools

    pacman -S laptop-mode-tools

You need to enable these modules in /etc/laptop-mode/conf.d/

auto-hibernate.conf Hibernate when battery level becomes critical

cpufreq.conf Adjust CPU speed

dpms-standby.conf Turn off screen when not needed

ethernet.conf Turn off ethernet when on battery

intel-hda-powersave.conf Turn on powersaving for audio chip

intel-sata-powermgmt.conf Powersave for hard disk

lcd-brightness.conf Change brightness when on battery

The file is called /proc/acpi/video/GFX0/DD02/brightness and acceptable
values are 10..100 with a step of 10

sched-mc-power-savings.conf Additional CPU powersave features

sched-smt-power-savings.conf Additional CPU powersave features

usb-autosuspend.conf Suspend unused USB devices

video-out.conf Disable video out on battery

wireless-power.conf Powersaving for atheros chip

Hardware
--------

> Bluetooth

Works out of the box. On some machines, Bluetooth cannot turn on because
of Fn+F3 switching only WLAN. Fixed DSDT table seems to solve the
problem.

On the 3820TG, Bluetooth might not work even if Fn+F3 is used to turn it
on. (Symptoms include "usb disconnect" messages in dmesg, and the
adapter not showing up in hcitool dev.) In this case, copying
/lib/firmware/ath3k-2.fw to /lib/firmware/ath3k-1.fw helps, see this
mailing list thread. If it does not work for you, please change this
note!

> Wi-Fi

Works out of the box and supports injection and AP mode.

TimelineX 5820

Wi-Fi driver needs to be installed. Open source brcm80211 driver causes
kernel panics; the proprietary broadcom-wl driver works fine.

TimelineX 4820TG

Wi-Fi driver does not work by default. You need to install broadcom-wl
and b43-firmware.

Once you are done with driver and firmware installation, you need to add
the following in the MODULES array in /etc/rc.conf and reboot:

    MODULES=([...] lib80211 wl !b43 !ssb)

Once rebooted, you can confirm the working of the driver by following
commands

    # ip link
    # ip link set eth1 up
    # iwconfig eth1
    # iwlist eth1 scan

For more information, check Broadcom_wireless.

Sometimes, the network (LAN/WLAN) interface names get swapped with every
boot. To make the network interface name(s) stay constant, add the
following to /etc/udev/rules.d/10-network.rules and bind the MAC address
of each of your network interfaces to a certain interface name:

    SUBSYSTEM=="net", ATTR{address}=="aa:bb:cc:dd:ee:ff", NAME="eth0"
    SUBSYSTEM=="net", ATTR{address}=="ff:ee:dd:cc:bb:aa", NAME="wlan0"

> Where:

-   "eth0" is the name of LAN interface.
-   "wlan0" is the name of WLAN interface.
-   MAC address of each interface should be specified in lower-case. See
    the udev page for more information.

TimelineX 3820TG

Works out of the box, lspci lists the chip as

    05:00.0 Network controller: Atheros Communications Inc. AR9287 Wireless Network Adapter (rev 01)

> Camera

Works out of the box.

> Card Reader

Works out of the box, tested with a SD card.

> Display brightness control

Sometimes brightness control for integrated card does not work (at least
with the 2.6.36.2-1 kernel). You may add acpi_osi=Linux to the kernel
line in the GRUB config to fix this.

Info
----

> lspci

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
    01:00.0 VGA compatible controller: ATI Technologies Inc Device 68e0 (rev ff)
    01:00.1 Audio device: ATI Technologies Inc Device aa68 (rev ff)
    02:00.0 Ethernet controller: Atheros Communications AR8151 v1.0 Gigabit Ethernet (rev c0)
    03:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
    7f:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers (rev 02)
    7f:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 02)
    7f:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
    7f:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 02)
    7f:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
    7f:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)

> lspci - TimelineX 4820TG (with Broadcom 4357 wifi)

    00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 12)
    00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16 Root Port (rev 12)
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
    01:00.0 VGA compatible controller: ATI Technologies Inc Redwood [Radeon HD 5600 Series]
    01:00.1 Audio device: ATI Technologies Inc Redwood HDMI Audio [Radeon HD 5600 Series]
    02:00.0 Ethernet controller: Atheros Communications AR8151 v1.0 Gigabit Ethernet (rev c0)
    03:00.0 Network controller: Broadcom Corporation Device 4357 (rev 01)
    7f:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers (rev 02)
    7f:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 02)
    7f:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
    7f:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 02)
    7f:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
    7f:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)

> lspci - TimelineX 3820TG-5464G50iks

    00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 18)
    00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16 Root Port (rev 18)
    00:02.0 VGA compatible controller: Intel Corporation Core Processor Integrated Graphics Controller (rev 18)
    00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series Chipset HECI Controller (rev 06)
    00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 05)
    00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 05)
    00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 (rev 05)
    00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5)
    00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 05)
    00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 4 port SATA AHCI Controller (rev 05)
    00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 05)
    00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem (rev 05)
    02:00.0 VGA compatible controller: ATI Technologies Inc Redwood [Radeon HD 5600 Series] (rev ff)
    02:00.1 Audio device: ATI Technologies Inc Redwood HDMI Audio [Radeon HD 5600 Series] (rev ff)
    03:00.0 Ethernet controller: Atheros Communications AR8151 v1.0 Gigabit Ethernet (rev c0)
    05:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
    ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers (rev 05)
    ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 05)
    ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 05)
    ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 05)
    ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 05)
    ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 05)

Issues
------

ATI chip has no 3D acceleration.

Ethernet chip driver is buggy in the 2.6.35 kernel.

Links
-----

1.  Ubuntu-it thread
2.  Usind acpi_call module to switch on/off

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_TimelineX&oldid=254489"

Category:

-   Acer
