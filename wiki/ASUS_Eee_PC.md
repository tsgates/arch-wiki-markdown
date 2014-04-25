ASUS Eee PC
===========

This should be the page to gather all information on installing and
running arch on the Asus Eee. Why? Because the 'old' page is a bit
confusing/outdated, wrongly named (makes finding it in a search hard)
and the title limits it to just the install precedure.

The 'old' page should be cleaned up and merged into this page, and any
future information should also go on this page. If no one that actualy
owns an Eee want to do it, then I (Mr.Elendig) can do it, but it will
take some time.

Until this page actualy get some contents, go to Installing Arch Linux
on the Asus EEE PC.

Contents
--------

-   1 Eee 700 Series and 900
    -   1.1 Installation
    -   1.2 If you do want an optimized Pentium-M kernel
    -   1.3 Xorg
    -   1.4 Sound
-   2 Eee 900A
-   3 Eee 901, 904, and 1000(H)
    -   3.1 Setting up the Network
        -   3.1.1 atl1e
        -   3.1.2 eeert2860
    -   3.2 Eee 901 20G lsmod and lspci
-   4 Eee 904HA
-   5 Eee T91MT
-   6 Eee T101MT
-   7 Eee 1000HA
-   8 Eee 1000HE
-   9 Eee 1001P
-   10 Eee 1001PX
-   11 Eee 1005HA
-   12 Eee 1005P(E)
-   13 Eee 1015B
    -   13.1 Audio
    -   13.2 Powersaving
-   14 Eee 1015 BX
-   15 Eee 1015 PE/PEM
    -   15.1 Hardware
    -   15.2 Installation
        -   15.2.1 ACPI
        -   15.2.2 Modules
-   16 Eee 1015 PX
-   17 Eee 1015 PN
-   18 Eee 1025C
-   19 Eee 1201T
-   20 Eee 1201NL
-   21 Eee 1215n
-   22 Eee 1215P
-   23 Eee 1215B
    -   23.1 Installation
    -   23.2 Audio
    -   23.3 Video
    -   23.4 Power Management

Eee 700 Series and 900
======================

This should be filled with the majority of the content from Installing
Arch Linux on the Asus EEE PC.

> Installation

Installation can be achieved from an external cdrom drive, or from a usb
stick configured as described in Install from USB stick

The wireless module (ath5k) is now part of the stock kernel. The stock
kernel performs very well on the eeepc. You do not need to install any
extra packages from AUR for wireless or install any special kernel.

During installation make sure you add the following packages in addition
to the base packages for wireless to work.

    wireless_tools
    netcfg

Thats all you now need for a working eee.

> If you do want an optimized Pentium-M kernel

toofishes created a repository for the Eee. You can find some basic
packages like a Pentium-M optimized kernel. Add

    [eee]
    Server = http://code.toofishes.net/packages/eee

to your /etc/pacman.conf to use the repository.

Simply use pacman to install the package you need. Install the packages
with this command:

    # pacman -S kernel-eee

Then, add the following to /boot/grub/menu.lst; note that no initrd is
needed:

    # (2) Arch Linux
    title  Arch Linux EEE kernel
    root   (hd0,0)
    kernel /boot/vmlinuzeee root=/dev/sda1 ro

Restart and select Arch Linux EEE kernel from the grub boot menu.

> Xorg

Xorg works without an xorg.conf on the eeepc fine with the new
hotplugging system. See Xorg.

> Sound

If sound does not work in a new installation add the following line to
/etc/modprobe.d/modprobe.conf

    options snd-hda-intel model=3stack-dig

Eee 900A
========

The 900A is a 900 with a Intel Atom CPU and new hardware (the most is
like in 901), you can get help in Asus Eee PC 900A.

Eee 901, 904, and 1000(H)
=========================

The 901, 904, and 1000(H) all seem to share much-of, if not all the same
hardware. The steps for setting up Arch Linux are as follows. NB. There
is a separate wiki page as well dedicated to the 901.

Setting up the Network
----------------------

Two PKGBUILD files are available in the AUR to help you get your network
interfaces up and running. The first is delcake's "atl1e" drivers for
your wired ethernet, and the second is jbooth's "eeert2860" drivers for
wireless.

> atl1e

delcake's PKGBUILD is located here in the AUR. Note that in order to
build this package, you will need to get the unrar and unzip packages
from the mirror of you choice, as well as the LinuxDrivers.zip source
code linked on the AUR page unless you did your wireless drivers first.

1.  Transfer the PKGBUILD to your Eee PC. Get the source files too if
    you do not have internet yet.
2.  Install the unrar and unzip packages if you do not already have
    them.
3.  Issue a 'makepkg' command at the location of the PKGBUILD.

If all goes well, a .pkg.tar.gz file that starts with the name atl1e
will have been created in the same folder.

As root, run 'pacman -U <package name>.pkg.tar.gz' to install your newly
created module. In order to detect it, run both 'depmod -a' and
'modprobe atl1e' as root in that order.

At this point, you should be able to issue an ip a command and see your
brand new eth0 device staring back at you. Don't forget to add atl1e to
your modules list in /etc/rc.conf to automatically load your ethernet
module during boot.

-   WARNING: You will need to recompile this module any time you do a
    kernel upgrade, so hang on to that PKGBUILD and zip file.

> eeert2860

jbooth's PKGBUILD is located here in the AUR. Note that in order to
build this package, you will need to get the wireless_tools package from
the mirror of your choice, as well as Ralink's drivers listed under the
sources section unless you did your wired drivers first.

1.  Transfer the PKGBUILD to your Eee PC. Get the source files too if
    you do not have internet yet.
2.  Install the wireless_tools package if you do not already have it.
3.  Issue a 'makepkg' command at the location of the PKGBUILD.

Hopefully, the makepkg command went through without a hitch, and a
.pkg.tar.gz file will have been created in the same folder.

As root, run 'pacman -U <package name>.pkg.tar.gz' to install your newly
created module. In order to detect it, run both 'depmod -a' and
'modprobe rt2860sta' as root in that order.

Now you should see your ra0 wireless device in the output of ip a. As
root, run ip link set dev ra0 up to bring up the interface for
configuration.

-   Still no ra0 device? Make sure that the WLAN device is enabled in
    your BIOS.

-   WARNING: You will need to recompile this module any time you do a
    kernel upgrade, so hang on to the PKGBUILD and .tar.bz2 file.

Eee 901 20G lsmod and lspci
---------------------------

Note :This section was moved from the 70x/900 page.

The following are from a stock ASUS EeePC 901 20G Linux version:

lsmod:

    Module                  Size  Used by
    acpi_cpufreq            5004  0 
    freq_table              1988  1 acpi_cpufreq
    usb_storage            22980  0 
    libusual                6352  1 usb_storage
    pciehp                 31172  0 
    pci_hotplug             9672  1 pciehp
    ehci_hcd               25420  0 
    uhci_hcd               18636  0 
    usbhid                 13444  0 
    usbcore                91992  6 usb_storage,libusual,ehci_hcd,uhci_hcd,usbhid
    snd_pcm_oss            33568  0 
    snd_mixer_oss          13056  1 snd_pcm_oss
    rt2860sta             468248  1 
    atl1e                  26388  0 
    fuse                   34516  0 
    asus_acpi               6560  0 
    button                  5648  0 
    processor              19820  1 acpi_cpufreq
    battery                 7940  0 
    ac                      3524  0 
    autofs4                15876  0 
    sr_mod                 13284  0 
    cdrom                  30624  1 sr_mod
    snd_hda_intel         284112  0 
    snd_pcm                50696  2 snd_pcm_oss,snd_hda_intel
    snd_timer              15556  1 snd_pcm
    snd_page_alloc          6728  2 snd_hda_intel,snd_pcm
    snd_hwdep               6084  1 snd_hda_intel
    snd                    34852  6 snd_pcm_oss,snd_mixer_oss,snd_hda_intel,snd_pcm,snd_timer,snd_hwdep
    soundcore               3744  1 snd
    genrtc                  6028  0

lspci:

    00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03)
    00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03)
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
    00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02)
    00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
    01:00.0 Network controller: RaLink RT2790 Wireless 802.11n PCIe
    03:00.0 Ethernet controller: Atheros Corp. L1e Gigabit Ethernet Adapter (rev b0)

Eee 904HA
=========

Asus Eee PC 904HA

Eee T91MT
=========

Asus Eee PC T91MT

Eee T101MT
==========

Asus Eee PC T101MT

Eee 1000HA
==========

Asus Eee PC 1000HA

Eee 1000HE
==========

Asus Eee PC 1000HE

Eee 1001P
=========

Asus Eee PC 1001p

Eee 1001PX
==========

Asus Eee PC 1001px

Eee 1005HA
==========

Asus Eee PC 1005HA

Eee 1005P(E)
============

Asus Eee PC 1005P

Eee 1015B
=========

Things that "just work":

-   Wlan (ath9k is part of the kernel; some use brcmsmac)
-   Ethernet
-   Graphics (with kms and dri2, using the xf86-video-ati driver)
-   Webcam (using v4l)
-   Suspend-to-RAM (after installing acpid)
-   Cardreader (but keucr is in staging, thus taints the kernel.
    PyroPeter experienced crashes while he inserted or removed sd cards)
-   Bluetooth (after installing bluez)
-   CPU Frequency Scaling (Use acpi_cpufreq since linux 3.7)
-   TouchPad (support multi-touch after installing xf86-input-synaptics)
-   Video Acceleration (Using ATI/AMD's propretary driver(catalyst))

/etc/modprobe.d/eeepc1015b.conf:

    # supposed to help against following msg in dmesg:
    # SP5100 TCO timer: mmio address 0xbafe00 already in use
    blacklist sp5100_tco

    # if you don't need the sd-card reader you may want to blacklist
    # keucr. it is in staging, thus taints the kernel
    blacklist keucr

    # if you find "ACPI: resource piix4_smbus [io 0x0b00-0x0b07]
    # conflicts with ACPI region SMRG [io 0xb00-0xb0f]" 
    # in /var/log/messages.log ,try to uncomment the following line
    #blacklist i2c_piix4

lspci:

    00:00.0 Host bridge: Advanced Micro Devices [AMD] Family 14h Processor Root Complex
    00:01.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Device 9805
    00:01.1 Audio device: Advanced Micro Devices [AMD] nee ATI Wrestler HDMI Audio [Radeon HD 6250/6310]
    00:04.0 PCI bridge: Advanced Micro Devices [AMD] Family 14h Processor Root Port
    00:05.0 PCI bridge: Advanced Micro Devices [AMD] Family 14h Processor Root Port
    00:11.0 SATA controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
    00:12.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
    00:12.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
    00:13.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
    00:13.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
    00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus Controller (rev 42)
    00:14.2 Audio device: Advanced Micro Devices [AMD] nee ATI SBx00 Azalia (Intel HDA) (rev 40)
    00:14.3 ISA bridge: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
    00:14.4 PCI bridge: Advanced Micro Devices [AMD] nee ATI SBx00 PCI to PCI Bridge (rev 40)
    00:15.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0)
    00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 0 (rev 43)
    00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 1
    00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 2
    00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 3
    00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 4
    00:18.5 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 6
    00:18.6 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 5
    00:18.7 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 7
    01:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
    02:00.0 Ethernet controller: Atheros Communications Inc. AR8152 v2.0 Fast Ethernet (rev c1)

On models with ASMedia USB 3.0 chip, replace last 2 line with:

    01:00.0 Network controller: Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller (rev 01)
    02:00.0 Ethernet controller: Atheros Communications Inc. AR8152 v2.0 Fast Ethernet (rev c1)
    03:00.0 USB controller: ASMedia Technology Inc. Device 1040

lsusb:

    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 002 Device 002: ID 13d3:5702 IMC Networks UVC VGA Webcam

Audio
-----

After running alsaconf the graphics card was the default audio output,
so I had to create /etc/asound.conf with the following contents:

    defaults.ctl.card 1
    defaults.pcm.card 1
    defaults.timer.card 1

Volume function key for alsa:

    /etc/acpi/handler.sh

    ......
            open)
                #echo "LID opend!">/dev/tty5
                ;;
        esac
        ;;
    ## volume control key ##
    button/mute)
      case "$2" in
        MUTE) amixer set Master toggle ;;
      esac
      ;;
    button/volumedown)
      case "$2" in
        VOLDN) amixer set Master 2%- ;;
      esac
      ;;
    button/volumeup)
      case "$2" in
        VOLUP) amixer set Master 2%+ ;;
      esac
      ;;
    ## volume control key end ##
    *)
      logger "ACPI group/action underfined: $1 /$2"
      ;;
    esac

Powersaving
-----------

When system is idle, ATI/AMD's propretary driver(catalyst) saves 2.5W
than xf86-video-ati.

Eee 1015 BX
===========

Most seems to work 'out-of-the-box':

-   Wlan
-   Ethernet
-   Graphics (using the xf86-video-ati driver)
-   Webcam
-   Suspend-to-RAM (with acpi & acpid)
-   Cardreader
-   CPU Frequency Scaling (add 'eeepc-wmi ac battery button fan video'
    to MODULES array in '/etc/rc.conf')
-   TouchPad (using the xf86-input-synaptics driver)

  
 My blacklist:

    # /etc/modprobe.d/blacklist.conf
    blacklist sp5100_tco

For sound at DE add this file to your HOME-directory:

    #
    # ~/.asoundrc
    #

    defaults.ctl.card 1
    defaults.pcm.card 1
    defaults.timer.card 1

For volume-control-buttons I use shortcuts with:

    amixer -q -c 1 set Master 5+
    amixer -q -c 1 set Master 5-
    amixer -q -c 1 set Master toggle

  

Eee 1015 PE/PEM
===============

Hardware
--------

The Eee 1015 series laptops come with a 1024x600 LED display and a Dual
Core Intel Atom processor (N550). They also have a Broadcom wireless
card and an Atheros Ethernet port.

Here is the output of lspci:

    00:00.0 Host bridge: Intel Corporation N10 Family DMI Bridge (rev 02)
    00:02.0 VGA compatible controller: Intel Corporation N10 Family Integrated Graphics Controller (rev 02)
    00:02.1 Display controller: Intel Corporation N10 Family Integrated Graphics Controller (rev 02)
    00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 1 (rev 02)
    00:1c.1 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 2 (rev 02)
    00:1c.3 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 4 (rev 02)
    00:1d.0 USB controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #1 (rev 02)
    00:1d.1 USB controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 (rev 02)
    00:1d.2 USB controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 (rev 02)
    00:1d.3 USB controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 (rev 02)
    00:1d.7 USB controller: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
    00:1f.0 ISA bridge: Intel Corporation NM10 Family LPC Controller (rev 02)
    00:1f.2 SATA controller: Intel Corporation N10/ICH7 Family SATA Controller [AHCI mode] (rev 02)
    01:00.0 Ethernet controller: Atheros Communications Inc. AR8132 Fast Ethernet (rev c0)
    02:00.0 Network controller: Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller (rev 01)

Note:The wireless card uses the brcmsmac driver. Since linux 3.3.1 the
brcmsmac driver depends on the bcma module and blacklisting is no longer
required. See Broadcom wireless

Here is the output of lscpu:

    Architecture:          x86_64
    CPU op-mode(s):        32-bit, 64-bit
    Byte Order:            Little Endian
    CPU(s):                4
    On-line CPU(s) list:   0-3
    Thread(s) per core:    2
    Core(s) per socket:    2
    Socket(s):             1
    NUMA node(s):          1
    Vendor ID:             GenuineIntel
    CPU family:            6
    Model:                 28
    Stepping:              10
    CPU MHz:               1499.813
    BogoMIPS:              3000.61
    L1d cache:             24K
    L1i cache:             32K
    L2 cache:              512K
    NUMA node0 CPU(s):     0-3

Installation
------------

To install Arch on the Asus Eee 1015 series you need to use an external
cd-rom drive or USB Installation Media.

The partition created by Asus on my 1015 PEM is as follows:

    Number Start    End    Size   Type      File System   Flags
    1      1049kb   107Gb  107Gb  primary   NTFS           
    2      107Gb    123Gb  16.1Gb primary   fat32         hidden
    3      123Gb    250Gb  127Gb  primary   NTFS          
    4      250Gb    250Gb  21.2Gb primary   

Results may vary. The first partition was the Windows 7 installation.
The second is the recovery partition with splashtop. Removing this
second partition will cause the fast-start Linux to stop working. The
third is Windows D:\ drive and the last one is the boot partition for
Windows 7.

Due to the limitations of having 4 partitions per drive I installed arch
on the first 107Gb partition and created a swap file instead of a
partition as per Swap.

> ACPI

ACPI works fine following the acpid guide. The following is for older
versions of the kernel.

To enable acpi you need to edit menu.lst and add acpi_osi=Linux to the
kernel line like so:

     kernel /boot/vmlinuz-linux root=/dev/sda1 ro acpi_osi=Linux

This enabled you to trigger devices in /sys/devices/platform/eeepc/.

Note:As far as I can tell, this is no longer required. If you do add it,
the module eeepc-wmi will fail to load - kernel 2.6.39.2-1

> Modules

In order to get CPU frequency scaling as well as the proper
special-purpose Eee PC module loaded, you can use the following MODULES
statement in /etc/rc.conf:

     MODULES=( acpi-cpufreq cpufreq_ondemand eeepc-wmi )

If you get double keypresses for with your function keys (like the mute
key, etc.), add the following into /etc/modprobe.d/blacklist.conf
(Create this file if it isn't present)

    blacklist eeepc-laptop

Note:As long as you do not add acpi_osi-Linux to menu.lst, the eeepc
modules load automagically and are not required in MODULES

Note:As of kernel 3.3.7-1, no extra modules are required in order for
full usage of Arch Linux on this laptop.

Eee 1015 PX
===========

Asus_Eee_PC_1015PX

Eee 1015 PN
===========

Asus_EEE_PC_1015pn

Eee 1025C
=========

Asus_EEE_PC_1025c

Eee 1201T
=========

Asus Eee PC 1201T

Eee 1201NL
==========

Asus Eee PC 1201NL

Eee 1215n
=========

Asus EEE PC 1215n

Eee 1215P
=========

Asus EEE PC 1215p

Eee 1215B
=========

Things that work out of the box: Wifi, Ethernet, Video (max resolution
available with basic Xorg and xfce packages installed), Touchpad,
Keyboard (Fn keys not working).

Things that need work: Audio, Fn keys, Power management.

Installation
------------

Arch setup encountered no problems, GRUB installed successfully with no
damages to Windows (need to uncomment the windows lines in in
/boot/grub/menu.lst) and Express Gate.

Audio
-----

With the xfce4 desktop environment audio doesn't work by default (didn't
test with other de). To fix this, add the following lines in your
~/.asoundrc:

    defaults.pcm.card 1
    defaults.ctl.card 1

(Credit to Touko Korpela from the Debian mailing list)

Video
-----

Youtube videos with the default ati driver work flawlessly with a
resolution of 720p, while with 1080p playback isn't smooth anymore.
Didn't test with the catalyst drivers, maybe a better playback could be
achieved.

Power Management
----------------

ACPI executes correctly and returns remaining battery life. Cpufreq
doesn't seem to work, hence making it impossible for Jupiter ([1]) to
manage the Super Hybrid Engine. However, from the Jupiter tray icon,
screen orientation, resolution and touchpad can be toggled and modified.

By suggestion from the Debian mailing list, I tried loading
"powernow-k8" with modprobe to get cpufreq working. This is apparently a
bug in the driver detection mechanism of cpufreq, and should be reported
upstream, I guess. After loading that module, cpufreq-info seems to
work. Have not tried getting Jupiter to manage SHE yet after that.

Suspend and hibernate work OK, with one tiny bug: I can't seem to get
the SD-card reader working after resuming from hibernate. After a
reboot, it works fine.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC&oldid=278712"

Category:

-   ASUS

-   This page was last modified on 15 October 2013, at 13:56.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
