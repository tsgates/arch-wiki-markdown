Sony Vaio VGN-SZ38GP
====================

This wiki entry describes the installation of ArchLinux on a Sony Vaio
VGN-SZ38GP laptop. I a still configuring some stuff to make every thing
works as I would, but I decide to share what I have done so far. Do not
hesitate to had your own trick to improve the Archlinux experience on
that device.

Contents
--------

-   1 System Specs
-   2 lspci Output
-   3 Archlinux Installation
-   4 Switch Mode
-   5 Screen Brightness
-   6 Wifi
-   7 Fan Speed
-   8 Power Saving
-   9 Webcam
-   10 Fingerprint Reader

System Specs
------------

-   Platform

Intel® Centrino® Duo Mobile Technology Intel® Core™2 Duo Processor T7200
(2 GHz) *1*2 Intel® PRO/Wireless 3945ABG Network Connection

-   Chipset Intel® 945GM Express Chipset
-   Processor System Bus 667MHz
-   Memory Bus 533MHz
-   Cache Memory L1 Cache: 64KB L2 Cache: 4MB (on CPU)
-   Main Memory

1 GB DDR2 SDRAM*3 (upgradeable up to 2 GB) (partially shared with video
memory)*4 2 SO-DIMM slots (The pre-installed memory module uses one)

-   Hard Disk 120 GB (HDD Recovery Storage:7GB*5, C:50GB, D:Remain)
    Serial ATA, 5400 rpm
-   Optical Drive DVD±RW/+R DL/RAM Drive*6

Maximum reading speed: DVD-ROM: 8x,DVD+R, DVD-R, DVD+RW, DVD-RW, DVD+R
DL, DVD-R DL: 4x,DVD-RAM: 2x,CD-RW: 12x,CD-R, CD-ROM: 24x Maximum
writing speed: DVD+R, DVD-R: 4x,DVD+RW, DVD+R DL: 2.4x,DVD-RW,DVD-RAM:
2x,CD-R: 24x,CD-RW: 10x

-   Graphics Accelerator NVIDIA® GeForce® Go 7400 with NVIDIA®
    TurboCache™*4
-   Video Memory 128MB*4
-   Display 13.3" Wide (WXGA: 1280 x 800) TFT colour display (Clear
    Bright LCD: White LED, Wide View)
-   Interfaces USB 2.0 x 2*7 ・i.LINK (IEEE 1394) S400 (4pin) ・Network
    (RJ-45) connector (100BASE-TX/10BASE-T) ・Headphone jack (stereo
    mini) ・Microphone jack (stereo mini) ・Monitor connector (Analogue
    RGB, mini D-sub 15pin) ・Modular (RJ-11) connector ・Docking Station
    connector ・Memory Stick Duo Slot*8 (MagicGate compatible, Memory
    Stick PRO Duo compatible, High-speed data transfer compatible)
-   Multi Media Card Reader compatible with: Memory Stick*10
    (Standard/Duo Size, MagicGate, Memory Stick PRO), SD Memory Card*11,
    xD-Picture Card
-   Wireless LAN Integrated Wireless Intel® PRO/Wireless 3945ABG LAN
    IEEE 802.11a/802.11b/802.11g*12

Data rate: maximum 11Mbps (802.11b)/54 Mbps (802.11a/g) *13 ・Frequency:
5 GHz (802.11a), 2.4 GHz (802.11b/g)

-   Security Chip TCG Ver1.2 compliant Trusted Platform Module (TPM)
-   Fingerprint Sensor Built-in Fingerprint Sensor
-   Bluetooth® Bluetooth® standard version 2.0+EDR*13 ・Output: maximum
    +6dBm ・Frequency: 2.4 GHz
-   Modem V.92 and V.90 Compliant
-   PC Card Slot ExpressCard™/34 x 1, Type I/II x 1
-   Camera 310,000 pixels effective Image Device: 1/8", VGA CMOS

Lens: 2 elements in 2 groups, F4(Fixed) Focus distance: f=1.74 mm
Built-in monaural microphone aside

-   Audio DSD compatible high quality sound chip:“Sound Reality”(Intel®
    High Definition Audio compatible)・3D audio (Direct Sound 3D
    support)・Built-in stereo speakers
-   Keyboard/Input Device ca 19mm Key pitch / 3mm Key stroke ・86
    Keys・Intelligent Alps Touchpad
-   Battery VGP-BPS2C*14 Lithium-ion battery: up to 6.5 hours of use (at
    STAMINA MODE) *15
-   Dimensions (W x H x D) 315 × 21.8 - 32.6 × 234.3 mm
-   Weight 1.69 kg (including the supplied battery)

lspci Output
------------

-   Stamina Mode

    00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
    00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev 03)
    00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
    00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
    00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)
    00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
    00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
    00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
    00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
    00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02)
    00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02)
    00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
    06:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
    07:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8036 PCI-E Fast Ethernet Controller (rev 15)
    09:04.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
    09:04.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant IEEE 1394 Host Controller
    09:04.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD)

-   Speed Mode

    00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
    01:00.0 VGA compatible controller: nVidia Corporation GeForce? Go 7400 (rev a1)
    00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
    00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
    00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)
    00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
    00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
    00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
    00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
    00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02)
    00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02)
    00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
    06:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
    07:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8036 PCI-E Fast Ethernet Controller (rev 15)
    09:04.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
    09:04.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant IEEE 1394 Host Controller
    09:04.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD)

Archlinux Installation
----------------------

Basically you just need to follow the Beginners' guide, I recommend to
do the installation under the stamina mode (with intel graphic card less
trouble) and then I will explain how to configure the speed mode.

Switch Mode
-----------

-   When you finished your installation, download the latest nvidia
    driver
-   Backup the files : libGL.so.1.2 and libglx.so that you can find
    respectively under the folder /usr/lib/ and
    /usr/lib/xorg/modules/extensions/
-   You need to copy them in a different location because when you will
    install the nvidia driver it will automatically remove them.
-   Backup your xorg.conf file that you can find under /etc/X11/

I choose to put the lib file under the folder /opt/gpu/intel/lib and the
xorg.conf as /etc/X11/xorg.intel

-   Reboot the computer in Speed Mode.

If you are running X you need to kill it. First go to a command prompt
using Ctrl+Alt+F1-6 and after you have login run the command: killall X.
You also need to kill kdm (killall kdm) or other login manager that you
may have since it will make X respawn. Then you have to change the
runlevel by using the command: init 3.

-   Run the script provided by nvidia to install the driver, it will
    automatically generate a new xorg.conf file with the correct setting
    for you graphic card.
-   Backup the files libGL.so.<Nvidia Version> and libglx.so.<Nvidia
    Version> that you can respectively find in /usr/lib and
    /usr/lib/xorg/modules/extensions
-   Backup xorg.conf file generated by the nvidia driver

I choose to put the lib file under the folder /opt/gpu/nv/lib and the
xorg.conf as /etc/X11/xorg.nv

-   Now use the following script :

    #!/bin/bash
    VIDEO=`lspci | grep -c nVidia`
    NVIDIA_VERSION="256.35"
    if [ "$VIDEO" = 1 ]; then
    cp -f /etc/X11/xorg.conf.nv /etc/X11/xorg.conf
    ln -sf /opt/gpu/nv/libGL.so.$NVIDIA_VERSION /usr/lib/libGL.so.1
    ln -sf /opt/gpu/nv/libglx.so.$NVIDIA_VERSION /usr/lib/xorg/modules/extensions/libglx.so
    echo "Speed Mode"
    else
    cp -f /etc/X11/xorg.conf.intel /etc/X11/xorg.conf
    ln -sf /opt/gpu/intel/libGL.so.1.2 /usr/lib/libGL.so.1
    ln -sf /opt/gpu/intel/libglx.xorg /usr/lib/xorg/modules/extensions/libglx.so
    echo "Stamina Mode"
    fi

-   Make you script executable using the following command : chmod +x
    <your_script_name>
-   Add your script path to the /etc/rc.local file.

Screen Brightness
-----------------

For each graphic card there is a specific program that handle it, for
the Intel card it is xbacklight and for Nvidia card it is smartdimmer.
xbacklight is installed by default with the Intel driver so you have
nothing to do, but for Nvidia you will have to install smartdimmer that
you can find in AUR. Know we will have to configure acpi to configure
the fn keys.

-   Go to /etc/acpi/events and create two files sonybright-down
    sonybright-up.
-   in the first one add the following line :

    # /etc/acpi/events/sony-brightness-down
    event=sony/hotkey SPIC 00000001 00000010
    action=/etc/acpi/actions/sonybright.sh down

-   in the second one add the following line :

    # /etc/acpi/events/sony-brightness-up
    event=sony/hotkey SPIC 00000001 00000011
    action=/etc/acpi/actions/sonybright.sh up

-   Now you will have to create two script file for handling the
    brightness for each graphic card.
-   Create a file named intelbright.sh and put the following line
    inside :

    #!/bin/bash
    if [ "x$1" = "xdown" ]; then
    xbacklight -dec 10;
    elif [ "x$1" = "xup" ]; then
    xbacklight -inc 20;
    fi

If the previous script does not work, you can use the alternative one
below :

    #!/bin/bash
    val=$(cat /sys/class/backlight/sony/actual_brightness)
    if [ "x$1" = "xdown" ]; then
    ((val--));
    elif [ "x$1" = "xup" ]; then
    ((val++));
    fi
    echo $val > /sys/class/backlight/sony/brightness

-   Create a file named nvlbright.sh and put the following line inside :

    #!/bin/bash
    if [ "x$1" = "xdown" ]; then
    smartdimmer -d;
    elif [ "x$1" = "xup" ]; then
    smartdimmer -i;
    fi

-   You can now add the following line to the script that we used to
    switch graphic card :

    #!/bin/bash
    VIDEO=`lspci | grep -c nVidia`
    NVIDIA_VERSION="256.35"
    if [ "$VIDEO" = 1 ]; then
    cp -f /etc/X11/xorg.conf.nv /etc/X11/xorg.conf
    cp -f /opt/gpu/bright/nvbright.sh /etc/acpi/actions/sonybright.sh
    ln -sf /opt/gpu/nv/libGL.so.$NVIDIA_VERSION /usr/lib/libGL.so.1
    ln -sf /opt/gpu/nv/libglx.so.$NVIDIA_VERSION /usr/lib/xorg/modules/extensions/libglx.so
    echo "Speed Mode"
    else
    cp -f /etc/X11/xorg.conf.intel /etc/X11/xorg.conf
    cp -f /opt/gpu/bright/intelbright.sh /etc/acpi/actions/sonybright.sh
    ln -sf /opt/gpu/intel/libGL.so.1.2 /usr/lib/libGL.so.1
    ln -sf /opt/gpu/intel/libglx.xorg /usr/lib/xorg/modules/extensions/libglx.so
    echo "Stamina Mode"
    fi

Wifi
----

If you have your wireless switch that is not automatically activating
your wireless if you do not turn it on before turn on your computer. You
can fix the problem by adding the following line to
/etc/modprobe.d/modprobe.conf

    options sony-laptop mask=0xffffdfff

Fan Speed
---------

You can control the fan speed by using the vaiofand daemon that you can
find on this address : http://vaio-utils.org/fan/ There is also a
PKGBUILD available in AUR.

Power Saving
------------

You can automatically turn of some device like the bluetooth, the
firewire port, the cd/dvd drive or the audio card by using the vaiopower
daemon that you can find on this address : http://vaio-utils.org/power/
There is also a PKGBUILD available in AUR.

Webcam
------

I have a patch version of the driver that is working for the model : Bus
001 Device 005: ID 05ca:1830 Ricoh Co., Ltd Visual Communication Camera
VGP-VCC2 [R5U870] I will soon try to make a PKGBUILD in aur.

Fingerprint Reader
------------------

to be continued

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sony_Vaio_VGN-SZ38GP&oldid=298064"

Category:

-   Sony

-   This page was last modified on 16 February 2014, at 07:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
