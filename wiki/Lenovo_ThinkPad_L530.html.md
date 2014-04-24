Lenovo ThinkPad L530
====================

  Summary help replacing me
  ---------------------------------------------------------------------------------
  This article covers the Arch Linux support for the Lenovo ThinkPad L530 laptop.

Contents
--------

-   1 Hardware
    -   1.1 lspci
    -   1.2 lsusb
-   2 Configuration
    -   2.1 Clickpad
    -   2.2 Video
    -   2.3 Ethernet
    -   2.4 Wireless
        -   2.4.1 Driver
    -   2.5 Bluetooth
    -   2.6 Sound
    -   2.7 Webcam
    -   2.8 Fingerprint Reader
    -   2.9 Card Reader
    -   2.10 Trackpoint
    -   2.11 Special key
-   3 Troubleshooting
    -   3.1 Trackpoint
-   4 Link

Hardware
--------

Using kernel 3.8.5

  Device               Works
  -------------------- ------------
  Video                Yes
  Ethernet             Yes
  Wireless             Yes
  Bluetooth            Yes
  Audio                Yes
  Camera               Yes
  Card Reader          Yes
  Fingerprint Reader   Not Tested
  Touchpad             Yes
  Trackpoint           No

> lspci

    00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor Graphics Controller (rev 09)
    00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04)
    00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
    00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
    00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
    00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4)
    00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 (rev c4)
    00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 (rev c4)
    00:1c.3 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 4 (rev c4)
    00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
    00:1f.0 ISA bridge: Intel Corporation HM76 Express Chipset LPC Controller (rev 04)
    00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
    00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
    01:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5229 PCI Express Card Reader (rev 01)
    06:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 [Taylor Peak] (rev 34)
    0c:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168 PCI Express Gigabit Ethernet controller (rev 07)

> lsusb

    Bus 003 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 004 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
    Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 003 Device 003: ID 0a5c:21e6 Broadcom Corp. BCM20702 Bluetooth 4.0 [ThinkPad]
    Bus 003 Device 004: ID 04f2:b2eb Chicony Electronics Co., Ltd 

Configuration
-------------

> Clickpad

The clickpad works with the xf86-input-synaptics driver from extra

> Video

In order to use the builtin intel graphics adapter you will have to
install the corresponding drivers:

    # pacman -S xf86-video-intel

> Ethernet

Works out of the box.

> Wireless

Works out of the box.

Driver

rtl8192ce driver LSPCI : Network controller: Realtek Semiconductor Co.,
Ltd. RTL8188CE 802.11b/g/n WiFi Adapter (rev 01)

> Bluetooth

Install : bluez and blueman

> Sound

Works out of the box.

> Webcam

Works out of the box.

> Fingerprint Reader

Try : fingerprint-gui

> Card Reader

Works out of the box. Tips : Card appears in : /dev/mmc*

> Trackpoint

See #Troubleshooting

> Special key

All special keys works except the microphone mute key : see
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/751471).

Troubleshooting
---------------

> Trackpoint

There are some issues regarding the trackpoint on the ThinkPad L530 and
L430 series. See https://bugzilla.kernel.org/show_bug.cgi?id=33292

Warning:This is just a quick and dirty workaround. The following
solution will remove the two-finger-scroll functionality of the touchpad

Load the kernelmodule psmouse with the options proto=bare:

    # echo "options psmouse proto=bare" | sudo tee /etc/modprobe.d/trackpoint-elantech.conf 

To activate the scroll function, create the file
/usr/share/X11/xorg.conf.d/11-trackpoint-elantech.conf:

    Section "InputClass"
        Identifier      "Elantech Trackpoint"
        MatchProduct    "PS/2 Generic Mouse"
        MatchDevicePath "/dev/input/event*"
        Option          "EmulateWheel" "true"
        Option          "EmulateWheelButton" "2"
        Option          "EmulateWheelTimeout" "200" 
        Option          "YAxisMapping" "4 5" # vertikales Scrollen
        Option          "XAxisMapping" "6 7" # horizontales Scrollen
    EndSection

Reload the kernelmodule, the trackpoint should now be usable:

    # sudo modprobe -rv psmouse && sudo modprobe -v psmouse 

Note:For more information see:
http://wiki.ubuntuusers.de/Trackpoint#Trackpoint-wird-nicht-erkannt-nur-ThinkPad-L430-530
(German)

Link
----

Experiences with thinkpad l530 on arch linux

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_L530&oldid=304794"

Category:

-   Lenovo

-   This page was last modified on 16 March 2014, at 07:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
