Toshiba Satellite A200
======================

This document covers installation and basic configuration Arch Linux on
Toshiba Satellite A200-1GH. In general it should also apply to rest of
A200 series.

Feel free to contact me if any problems or suggestions (m4jkel at
gmail.com) (English or Polish).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Specification                                                      |
| -   2 Installation                                                       |
| -   3 Graphics                                                           |
|     -   3.1 AIGLX and BERYL                                              |
|     -   3.2 Second screen                                                |
|                                                                          |
| -   4 Sound                                                              |
| -   5 Networking                                                         |
|     -   5.1 Ethernet                                                     |
|     -   5.2 Modem                                                        |
|     -   5.3 Wireless                                                     |
|     -   5.4 Bluetooth                                                    |
|         -   5.4.1 Kernels older than 2.6.33                              |
|         -   5.4.2 2.6.33 kernels and above                               |
|         -   5.4.3 Testing                                                |
|                                                                          |
| -   6 ACPI                                                               |
|     -   6.1 Special buttons                                              |
|     -   6.2 CPU frequency scaling                                        |
|     -   6.3 Suspend2                                                     |
|                                                                          |
| -   7 Camera                                                             |
| -   8 Optical drive                                                      |
| -   9 Multimedia card reader                                             |
| -   10 Touchpad                                                          |
| -   11 Express Card                                                      |
| -   12 Firewire                                                          |
+--------------------------------------------------------------------------+

Specification
-------------

lspci:

    00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
    00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express PCI Express Root Port (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
    00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
    00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
    00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
    00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
    00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
    00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02)
    00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
    01:00.0 VGA compatible controller: nVidia Corporation G72M [Quadro NVS 110M/GeForce Go 7300] (rev a1)
    04:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)
    05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E PCI Express Fast Ethernet controller (rev 01)
    06:04.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
    06:04.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant IEEE 1394 Host Controller
    06:04.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD)
    06:04.3 Generic system peripheral [0805]: Texas Instruments PCIxx12 SDA Standard Compliant SD Host Controller

Installation
------------

This notebook comes with Windows Vista installed. In the beginning there
are 3 partitions on the hard disc, which may produce some problems to
reorganize. GParted and cfdisk refused even to start because of errors
in partition structure. I recommend to rerun Toshiba recovery utillity
from DVD and choose to create only one small partition for Windows. Then
you'll get much of free space to use for Linux or other NTFS partitions.

Installation itself is easy, just follow official Arch guide.

Graphics
--------

GPU is GeForce Go 7300, so install nvidia package. Then run xorg-conf to
create your own xorg.conf file. I do not know what are the correct
monitor settings but those work for me:

    HorizSync 31.5-64.3
    VertRefresh 50-70

NOTE: Set correct resolution which is 1280x800. Using 1280x1024 makes
desktop and fonts look awful.

> AIGLX and BERYL

Setting up AIGLX and Beryl is easy with this GPU, just install needed
packages and add following lines to your xorg.conf. You can find
additional information here https://wiki.archlinux.org/index.php/Beryl.

    Section "Module"
     Load        "glx"
    EndSection

    Section "Device"
     Driver      "nvidia"

     Option      "AddARGBGLXVisuals" "true"
     Option      "UseEvents"         "false"
     Option      "RenderAccel"       "true"
    EndSection

    Section "Extensions"
     Option      "Composite"         "enable"
    EndSection

> Second screen

Laptop has D-SUB port, so you can connect second monitor. Use Fn+F5
buttons to change beetwen screen modes. The easiest way to configure
double screen view in X is using NVIDIA X Server Settings and clicking X
Server Display Configuration.

Sound
-----

Run alsaconf. If you want MIDI support take a look at
https://wiki.archlinux.org/index.php/Timidity

Networking
----------

> Ethernet

Works with no effort.

> Modem

That's the only thing I didn't managed to run. I tried to connect to
/dev/ttySX using minicom, but got no response. It seems to be winmodem.

> Wireless

Laptop comes with Intel 4965 AGN, but it's very easy to install. Grab
iwlwifi and iwlwifi-4965-ucode from extra repository. It works like a
charm with wpa_supplicant and wext driver.

There is official support in Kismet for this chipset.

> Bluetooth

Since the kernel 2.6.33 came out, there are two possible ways to enable
bluetooth in the laptop.

Kernels older than 2.6.33

If the version of the kernel is older than 2.6.33, the solution is to
use the omnibook module from AUR (called omnibook-svn). After the
installation, load the module with the parameter ectype=12.

    # modprobe omnibook ectype=12

2.6.33 kernels and above

If the version of the kernel is 2.6.33 or above, the configuration of
the bluetooth device is even simpler. It is enough to load the module
called toshiba_bluetooth.

    # modprobe toshiba_bluetooth

It should be available out of the box in the ARCH generic kernel. If a
custom kernel is being built, the following option should be marked to
compile as a module:

    CONFIG_TOSHIBA_BT_RFKILL=m

Testing

After loading any of the above modules, dmesg should show some
information about the new device. A good step is to check whether the
bluetooth adapter is visible to the system. To do it, type in the
following command:

    # lsusb

The possible output will include the bluetooth device among the other
USB peripherals. It is also advisable to check whether the device is
functional. To do it, type:

    # hcitool dev

The bluetooth adapter should be shown (usually named as hci0). If so,
congratulations, it works properly.

ACPI
----

First of all start /etc/rc.d/acpid and add it to DAEMONS in rc.conf.

> Special buttons

Some special buttons work out-of-box, some not. Here is the list:

    Button                    Comment
    Power                     Recognized by ACPI, add event to /etc/acpi/events, see below
    Web                       Works (xbindkeys)
    Music (?)                 Doesn't work
    Play                      Works (xbindkeys)
    Stop                      Works (xbindkeys)
    Rev                       Works (xbindkeys)
    Ffd                       Works (xbindkeys)

    Fn+Esc (Mute)             Works (xbindkeys)
    Lock                      Works (xbindkeys)
    Magnify                   Doesn't work
    Suspend to RAM            Doesn't work
    Suspend to disc           Doesn't work
    VGA switch                Works out-of-box
    Brightness                Works, module "video"
    WIFI                      Doesn't work (there is a switch, so what for?)
    Touchpad on/off           Doesn't work
    Num Lock/Scroll Lock      Work

    Volume knob               Works (xbindkeys)

This makes power button operational. Create /etc/acpi/events/power and
add as following:

    event=button[ /]power.*[02468ace]$
    action=/opt/kde/bin/dcop --all-users --all-sessions ksmserver ksmserver logout 0 2 0

This action is useful if you use KDE. You can change it to
action=poweroff.

> CPU frequency scaling

Cpu scalling works great, choose from many different utilities to handle
it (I use cpudyn).

> Suspend2

Suspend2 works fine both to RAM and to disc. I still test this feature,
so this paragraph may change. Kernel patching is required. You can
obtain dedicated suspend2 kernel, but there are no iwliwifi package for
this kernel. I built my own kernel with suspend2 patch using ABS.

Configuration is covered in
https://wiki.archlinux.org/index.php/Suspend2. You may come across
problems trying to hibernate desktop with Beryl. If so, try to uncheck
Sync with VBlack in Beryl settings (General Options).

To make laptop hibernating to RAM after closing the screen add those
lines to /etc/acpi/events/lid:

    event=button[ /]lid.*
    action=/usr/sbin/hibernate -F /etc/hibernate/ram.conf

Camera
------

In versions 2.6.26.2+ of the kernel there's builtin support for the
webcam so no need install extra drivers.

Unexpectedly it works.

-   get linux-unv-svn from AUR and build it using ABS
-   do depmod -ae.
-   download luvcview and compile it. There is such PKGBUILD in AUR but
    it produced an error during compilation. I'll check it later.
-   to see yourself in the camera run luvcview -f yuv -w

Optical drive
-------------

CD/DVD reading works fine. I watch DVD films with mplayer. Burning with
no problems using k3b.

Multimedia card reader
----------------------

Card reader is 5-in-1 Texas Instrument device. There is kernel driver
(tifm), but now there are only MMC/SD card supported. It should change
in the future.

Touchpad
--------

Touchpad works right after installation, but if you want some additional
features like scrolling, use synaptics driver.
https://wiki.archlinux.org/index.php/Touchpad_Synaptics

Express Card
------------

Works.

There are no many Express Card devices on the market now. I tested out
Merlin XU870, which is wireless 3G, HSDPA, GPRS modem. In fact it
appears as an USB device. AFAIR Express Card devices should use either
PCI Express or USB bus, so there will be no problems with Express Card
slot itself under Linux.

Firewire
--------

Unknown

Retrieved from
"https://wiki.archlinux.org/index.php?title=Toshiba_Satellite_A200&oldid=238821"

Category:

-   Toshiba
