Dell XPS 15
===========

This page is a work in progress! More info coming soon.

  

Device

Status

Network

Works

Wireless

Works

Sound

Works

Bluetooth

Works

Touchpad

Works

Graphics

Modify

USB 3.0

Works

Webcam

Works

System info

Not tested

Power management

Buggy

WiDi

Not working

Touchpad gestures

Not working

-   Works - Works out-of-the-box
-   Modify - Works with modifications
-   Not tested
-   Not working

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 System Settings                                                    |
| -   2 System Setup                                                       |
|     -   2.1 Power Management                                             |
|     -   2.2 Graphics                                                     |
|         -   2.2.1 Intel only                                             |
|             -   2.2.1.1 acpi_call usage                                  |
|                                                                          |
|         -   2.2.2 Nvidia                                                 |
|                                                                          |
|     -   2.3 Screen                                                       |
|     -   2.4 External Display                                             |
|     -   2.5 Wlan                                                         |
|         -   2.5.1 Note                                                   |
|                                                                          |
|     -   2.6 Bluetooth                                                    |
|     -   2.7 Power management                                             |
|     -   2.8 Special Touch Keys                                           |
|         -   2.8.1 Alternative method                                     |
|                                                                          |
|     -   2.9 Hidden Keyboard Keys                                         |
|     -   2.10 Notes                                                       |
+--------------------------------------------------------------------------+

System Settings
===============

Hardware settings om January 2011 model

    00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 18)
    00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16 Root Port (rev 18)
    00:02.0 VGA compatible controller: Intel Corporation Core Processor Integrated Graphics Controller (rev 18)
    00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series Chipset HECI Controller (rev 06)
    00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06)
    00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 06)
    00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 06)
    00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 (rev 06)
    00:1c.3 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 4 (rev 06)
    00:1c.4 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 5 (rev 06)
    00:1c.5 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 6 (rev 06)
    00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a6)
    00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 06)
    00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI Controller (rev 06)
    00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 06)
    00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem (rev 06)
    02:00.0 VGA compatible controller: nVidia Corporation Device 0df1 (rev a1)
    02:00.1 Audio device: nVidia Corporation GF108 High Definition Audio Controller (rev a1)
    04:00.0 Network controller: Intel Corporation Centrino Wireless-N 1000
    05:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 03)
    09:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
    ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers (rev 05)
    ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 05)
    ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 05)
    ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 05)
    ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 05)
    ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 05)

For Sandy Bridge model (L502X)

    00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
    00:01.0 PCI bridge: Intel Corporation 2nd Generation Core Processor Family PCI Express Root Port (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
    00:16.0 Communication controller: Intel Corporation 6 Series Chipset Family MEI Controller #1 (rev 04)
    00:1a.0 USB Controller: Intel Corporation 6 Series Chipset Family USB Enhanced Host Controller #2 (rev 05)
    00:1b.0 Audio device: Intel Corporation 6 Series Chipset Family High Definition Audio Controller (rev 05)
    00:1c.0 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 1 (rev b5)
    00:1c.1 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 2 (rev b5)
    00:1c.3 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 4 (rev b5)
    00:1c.4 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 5 (rev b5)
    00:1c.5 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 6 (rev b5)
    00:1d.0 USB Controller: Intel Corporation 6 Series Chipset Family USB Enhanced Host Controller #1 (rev 05)
    00:1f.0 ISA bridge: Intel Corporation HM67 Express Chipset Family LPC Controller (rev 05)
    00:1f.2 SATA controller: Intel Corporation 6 Series Chipset Family 6 port SATA AHCI Controller (rev 05)
    00:1f.3 SMBus: Intel Corporation 6 Series Chipset Family SMBus Controller (rev 05)
    01:00.0 VGA compatible controller: nVidia Corporation Device 0df4 (rev a1)
    03:00.0 Network controller: Intel Corporation Centrino Wireless-N 1030 (rev 34)
    04:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04)
    06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)

For 2012 Model (L521X)

    00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller (rev 09)
    00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor PCI Express Root Port (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor Graphics Controller (rev 09)
    00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04)
    00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
    00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
    00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
    00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4)
    00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 (rev c4)
    00:1c.3 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 4 (rev c4)
    00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
    00:1f.0 ISA bridge: Intel Corporation HM77 Express Chipset LPC Controller (rev 04)
    00:1f.2 RAID bus controller: Intel Corporation 82801 Mobile SATA Controller [RAID mode] (rev 04)
    00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
    01:00.0 VGA compatible controller: NVIDIA Corporation GK107 [GeForce GT 640M] (rev ff)
    07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168 PCI Express Gigabit Ethernet controller (rev 07)
    08:00.0 Network controller: Atheros Communications Inc. AR9462 Wireless Network Adapter (rev 01)
    09:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5209 PCI Express Card Reader (rev 01)
    09:00.1 SD Host controller: Realtek Semiconductor Co., Ltd. RTS5209 PCI Express Card Reader (rev 01)

System Setup
============

Power Management
----------------

For the Sandy Bridge model (L502X): Suspend works; hibernation doesn't
(it gets hung on a flashing cursor in text mode and doesn't even switch
video modes).

Graphics
--------

By default, both Intel and NVidia cards are active. You will consume a
lot of power.

As Optimus isn't supported yet, you will need to choose either Intel or
Nvidia.

In Intel only mode, you will reduce your battery usage by disabling the
Nvidia card.

You can also try Bumblebee for emulating Optimus functionality.

> Intel only

Install the i915 driver xf86-video-intel

To make sure nvidia module won't load into your system :

-   Remove nouveau and/or nvidia drivers
-   Use acpi_call (compile acpi_call or use the AUR package ) to disable
    the nvidia card

  

acpi_call usage

    modprobe acpi_call
    test_off.sh

If you have a positive value then do :

    echo '\_SB.<YOUR>.<POSITIVE>.<VALUE>._OFF' > /proc/acpi/call

Else your can test the other script m11xr2.sh (it worked for me) :

    /usr/share/acpi_call/m11xr2.sh off

You can use this command before and after to see how the battery
consumption change (you need to disconnect sector first) :

    grep rate /proc/acpi/battery/BAT1/state

To make this permanent, just add your working command in /etc/rc.local

Example :

    modprobe acpi_call
    /usr/share/acpi_call/m11xr2.sh off

> Nvidia

Not tested yet.

I assume you need to :

-   Remove all previous Intel driver
-   Install Nvidia driver :
    -   nvidia and nvidia-utils for the proprietary driver
    -   OR nouveau for the open source driver

(In Sandy Bridge models at least) The Optimus setup consists of the
integrated Intel chip connected to the laptop screen and the Nvidia card
runs through this. As such, the Nvidia chip cannot be used without the
intel chip (some other laptops have the option in BIOS to turn intel off
and use just nvidia, but not this laptop). The only way to use the
Nvidia is Bumblebee (or its fork, Ironhide). See Hybrid graphics#Nvidia
Optimus

Screen
------

External Display
----------------

For Sandy Bridge models (L502x), there is ongoing work in the bumblebee
project to enable HDMI output; however, as of 18 November 2011, this is
not working. In these models, the HDMI port is connected to the Nvidia
card (DGP), while the DisplayPort is connected to the Intel IGP. It is
reported that as of now, one can use an external monitor connected to
the DisplayPort.

Wlan
----

Some users will need to install the rfkill package in order to switch on
the wireless adapter with the fn+F2 key. Remember that wireless_tools
will be needed for using a network manager such as networkmanager, see
Wireless Setup for more information.

> Note

It seems that rfkill used in conjunction with networkmanager will cause
a normal shutdown to result in reboot when Wlan is powered off. To avoid
this DO NOT install both together.

Bluetooth
---------

Some users may need to run

    hciconfig hci0 reset

to get blueman working

Power management
----------------

Special Touch Keys
------------------

The special touch keys are strangely mapped by default. One changes
brightness, one does next track. They seem to be linked to the same key
sequences as the Fn+F# keys that do the same job. To fix this, make this
new file:

    /opt/dell_touchkeys_keymap

    0x90 previoussong # Previous song
    0xA2 playpause # Play/Pause
    0x99 nextsong # Next song
    0xDB computer # First touch key, Dell apparently uses a key sequence here where 0xDB is a modifer, 0x2D stands for the touch key and 0x19 for the monitor toggle
    0x85 prog1 # Second touch key
    0x84 media # Third touch key

and add this to /etc/rc.local:

    /etc/rc.local

    …
    # Fix touch keys
    /usr/lib/udev/keymap input/event0 /opt/dell_touchkeys_keymap

Source

> Alternative method

For L502x model the above method can be improved:

1.  No need to remap Play/Pause, Previous song, Next song keys as they
    are mapped correctly by default.
2.  For the first (leftmost) touch key: it's wired in a weird way on the
    hardware level. It seems to be wired to both Super_L and x. Your
    best bet would be to remap this using your DE or something like
    xbindkeys. You may want to double-check with xev or xbindkeys -mk to
    see exactly what keys it is producing.

Thus the keymap file should be (I prefer standard location):

    /usr/lib/udev/keymaps/dell-xps-l502x

    0x85 prog1 # Second touch key
    0x84 media # Third touch key

and add this to /etc/rc.local:

    /etc/rc.local

    …
    # Fix touch keys
    /usr/lib/udev/keymap input/event0 /usr/lib/udev/keymaps/dell-xps-l502x

OR make a udev rule (the former remaps keys on boot, this lets udev take
care of the remapping):

    /etc/udev/rules.d/99-local.rules

    …
    # Keymap Dell Touch keys
    SUBSYSTEM=="input", KERNEL=="event0", RUN+="keymap $name dell-xps-l502x"

Hidden Keyboard Keys
--------------------

For L502X model: there are additional Fn+<Key> (sequences) that are not
marked at all on the keyboard but underlying hardware generates them
anyway. Here they are (if you find more add them to the table below):

  Fn+<Key>     Resulting key (sequence)
  ------------ --------------------------
  Fn+Esc       Sleep
  Fn+Super_L   Super_R
  Fn+Ins       Pause/Break
  Fn+Del       Ctrl + Pause/Break
  Fn+PrntScr   Alt + PrtSc/SysRq

  :  Hidden Fn Keys

Notes
-----

-   Remember to turn on WIFI and Bluetooth by pressing the F2-button.
-   Touchpad can handle multitouch. Read Synaptics to get that working.
-   Card reader is finnicky. Try booting with a card inserted or
    inserting a card after it is booted and running
    sudo echo 1 > /sys/bus/pci/rescan. Otherwise, card reader will not
    be detected. It seems that a certain kernel update results in the
    workaround not working as well. More info needed.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_XPS_15&oldid=254678"

Category:

-   Dell
