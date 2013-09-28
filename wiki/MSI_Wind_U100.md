MSI Wind U100
=============

This article pertains to the MSI Wind U100 netbook/sub-notebook.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
|     -   1.1 lspci                                                        |
|                                                                          |
| -   2 Installing                                                         |
| -   3 CPU                                                                |
|     -   3.1 cpufreq                                                      |
|     -   3.2 overclock                                                    |
|                                                                          |
| -   4 Multimedia                                                         |
|     -   4.1 Audio                                                        |
|     -   4.2 Video                                                        |
|     -   4.3 Webcam                                                       |
|                                                                          |
| -   5 Networking                                                         |
|     -   5.1 Wireless                                                     |
|         -   5.1.1 Realtek                                                |
|         -   5.1.2 Ralink                                                 |
|         -   5.1.3 Atheros                                                |
|                                                                          |
|     -   5.2 BlueTooth                                                    |
|     -   5.3 Touchpad                                                     |
|         -   5.3.1 Sentelic                                               |
|         -   5.3.2 Synaptics                                              |
|                                                                          |
|     -   5.4 LAN                                                          |
|                                                                          |
| -   6 Memory stick reader                                                |
| -   7 Power management                                                   |
| -   8 Resources                                                          |
+--------------------------------------------------------------------------+

Hardware
--------

-   CPU: Intel Atom N270 1.6Ghz
-   RAM: 1024 Mb, DDR2 667Mhz (optional)
-   HDD: WD 80Gb SATA (optional)
-   VGA: Intel 945 GMA, 64 MB DDR
-   LCD: 1024x600, 10.2" widescreen
-   WLAN: Realtek RTL8187SE , 802.11 a/b/g
-   LAN: Realtek RTL8101/02
-   CAM: 1.3 Mpix
-   BAT: LI-ON 3 cell 2200 mAh, 2 hours (optional)
-   Bluetooth, card reader, 3x USB 2.0
-   Touchpad: Synaptics or Sentelic

> lspci

     00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03) 
     00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03)
     00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
     00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
     00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
     00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
     00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
     00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
     00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
     00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
     00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
     00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
     00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
     00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02)
     01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
     02:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8187SE Wireless LAN Controller (rev 22)

Some have other wireless cards:

     02:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)

Installing
----------

There are several possible ways to install Arch onto a MSI Wind U100.
The most usual methods are booting from a USB stick/memory card, or from
an external CD/DVD drive. Refer to the Beginners' Guide CD installer
part for instructions on obtaining an ISO image and burning to a CD, or
consult the USB stick section for indications on writing the image to a
USB device.

Regardless of choice, finish by hooking up the external device (CD drive
or USB stick) to the notebook. Hold the F11 key while booting in order
to get to the boot device menu, then proceed by selecting the
appropriate device and install as normal.

CPU
---

> cpufreq

you should use acpi-cpufreq driver which will allow you to slow down
your CPU to 800MHz (p4-clockmod driver will work too, but it's not
intended to be used with governors like ondemand, it should be used just
for manual underclocking usig hotkeys or ACPI events like
AC-disconnection because it's too slow to react fast enough to be
suitable for use with automatic scaling based on CPU usage and therefore
kernel will refuse to use such governors. however you can underclock cpu
down to 200MHz using this driver). Probably you will also want to use
cpufreq-ondemand governor.

> overclock

It is possible to overclock the MSI Wind using an upgraded BIOS. The
overclock (turbo mode) can be activated with Fn+F10, however, this
overclock is not reported in /proc/cpuinfo or by cpufreq-info.

Multimedia
----------

> Audio

Audio is supported through ALSA with virtually no configuration.
Following the ALSA article should cover all that is needed.

> Video

The on-board graphics uses the Intel driver. To install with pacman:

    # pacman -S xf86-video-intel

Aside from that, there are no out-of-the-ordinary configuration steps.
Consult Xorg and Intel for more information.

> Webcam

First, do not forget to activate the webcam with the hotkey Fn+F6. If
it's still not working, then try loading the module. The webcam should
be supported through the uvcvideo module by default, if not:

    # modprobe uvcvideo

To load the webcam driver automatically, adding uvcvideo to the MODULES
array in /etc/rc.conf may be needed:

    MODULES=(uvcvideo)

The webcam uses a resolution of 640x480. As a warning, recording video
with higher resolutions may result in a lower framerate.

Networking
----------

> Wireless

Determine which card the particular u100 version has by running lspci.
These are the possibilities:

-   Realtek 8187se B/G
-   Ralink RT2860 B/G/N
-   Atheros AR928X B/G/N

The lspci output should mention the company name.

Realtek

Since kernel 2.6.29 there's a working driver included in the staging
line. The module is rtl8187se and should get loaded without
intervention. This network adapter is known to be buggy, so it's
unlikely that this driver will show significant progress over its
current state. Using ndiswrapper in place of the in-kernel module is
recommended because of this situation.

Ralink

The RT2860 now works out of the box with rt2x00pci drivers.

Atheros

AR5001 (rev 02) works out of the box with ath5k or mad wifi drivers.

> BlueTooth

Some versions of MSI Wind do have internal USB bluetooth module. It
should be autodetected (using modules btusb, bluetooth and rfkill).
However there is bug (probably in kernel) that prevent's people from
toggling bluetooth using fn+f11 if it wasn't active during boot.
(toggling wifi using fn+f11 remains working) If you happen to reboot
your linux with BT deactivated, you will probably need to use windows or
some distribution without this bug (BackTrack 4 was reported to work) to
activate it again. There is hope this will be fixed in future. (please
let us know if you will find any solution for this issue)

> Touchpad

Sentelic

The Sentelic Finger Sensing Pad driver (version 1.0.0) is included in
kernel 2.26.32 and above, however, it may be difficult to get the
configuration utility (fspc) to work correctly. It is possible to
configure the pad manually by adding the following lines to your
/etc/rc.local

    # Disable tap-to-click:
    echo -n c>>/sys/devices/platform/i8042/serio1/flags

    # Disable vertical tap scrolling:
    echo -e \0>>/sys/devices/platform/i8042/serio1/vscroll

    # Disable horizontal tap scrolling:
    echo -e \0>>/sys/devices/platform/i8042/serio1/hscroll

Synaptics

Some models of the U100 have a Synaptics touchpad installed. The
Synaptics driver can be installed as described here. Vertical and
horizontal edge scrolling work, and can be enabled in the synaptics
.conf file:

    /etc/X11/xorg.conf.d/10-synaptics.conf

     Section "InputClass"
           Identifier "touchpad"
           Driver "synaptics"
           MatchIsTouchpad "on"
                  Option "TapButton1" "1"
                  Option "TapButton2" "2"
                  Option "TapButton3" "3"
                  Option "VertEdgeScroll" "on"
                  Option "HorizEdgeScroll" "on"
                  ...
     EndSection

> LAN

The Ethernet adapter functions thanks to the r8169 module present in
kernels 2.26.31 and newer.

Memory stick reader
-------------------

The multi-card reader appears to work automatically.

Power management
----------------

pm-utils usually works without issues. However, some users have reported
that it may require adding the resume hook and removing the autodetect
hook before working correctly.

Resources
---------

-   MSI Wind U120 - Arch Linux wiki on the MSI Wind U120
-   MSI Notebook Official Website - BIOS upgrades can be found here
-   InsanelyWind - Community website dedicated to MSI Wind netbooks,
    includes forums and a wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=MSI_Wind_U100&oldid=206295"

Category:

-   MSI
