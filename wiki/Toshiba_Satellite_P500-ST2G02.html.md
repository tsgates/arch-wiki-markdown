Toshiba Satellite P500-ST2G02
=============================

This is a tutorial on how to install and configure Arch Linux on a
Toshiba Satellite P500 Laptop.

Contents
--------

-   1 Hardware
-   2 Removing Windows
-   3 Arch Installation
-   4 Install the Realtek wireless card driver
-   5 Install NVIDIA driver
-   6 Install the Synaptic driver
-   7 ACPI
-   8 Laptop Mode Tools
-   9 Multimedia Buttons
-   10 External Microphone

Hardware
--------

Custom configuration, purchased on 11/29/2010 from Toshiba Direct:

-   Intel® Core™ i5-460M processor
-   Genuine Windows 7 Home Premium (64-bit)
-   4GB DDR3 1066MHz memory
-   500GB HDD (7200rpm)
-   1GB GDDR3 NVIDIA® GeForce® GT 330M
-   18.4" screen

lspci reports this:

    # lspci
    00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 02)
    00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16 Root Port (rev 02)
    00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series Chipset HECI Controller (rev 06)
    00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 05)
    00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 05)
    00:1c.3 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 4 (rev 05)
    00:1c.4 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 5 (rev 05)
    00:1c.5 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 6 (rev 05)
    00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5)
    00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 05)
    00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 4 port SATA AHCI Controller (rev 05)
    00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 05)
    00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem (rev 05)
    01:00.0 VGA compatible controller: nVidia Corporation Device 0a29 (rev a2)
    01:00.1 Audio device: nVidia Corporation High Definition Audio Controller (rev a1)
    07:00.0 FireWire (IEEE 1394): O2 Micro, Inc. Device 10f7 (rev 01)
    07:00.1 SD Host controller: O2 Micro, Inc. Device 8120 (rev 01)
    07:00.2 Mass storage controller: O2 Micro, Inc. Device 8130 (rev 01)
    0a:00.0 Network controller: Realtek Semiconductor Co., Ltd. Device 8172 (rev 10)
    0b:00.0 Ethernet controller: Atheros Communications Atheros AR8132 / L1c Gigabit Ethernet Adapter (rev c0)
    ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers (rev 05)
    ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 05)
    ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 05)
    ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 05)
    ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 05)
    ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 05)

Removing Windows
----------------

I was thinking of keeping Windows in its own partition, but I had
trouble with repartitioning the hard disk. Since I don't really use
Windows, I ended up deleting all Windows and Toshiba Restore partitions.
For some reason cfdisk (my tool of choice) didn't work here, so I had to
use fdisk to do that.

Arch Installation
-----------------

Both Arch 32 and Arch 64 install flawlessly on the laptop. For
compatibility reasons, I decided to go with Arch 32, given that I had to
later recompile the kernel with PAE option turned on, in order to access
4GB of RAM.

Install the Realtek wireless card driver
----------------------------------------

The wireless card does not work out of the box, so I had to install the
8192cu driver from AUR. Note that my card model is 8172, but it does
seem to work fine with the 8192cu driver.

Install NVIDIA driver
---------------------

    # pacman -S nvidia

This also adds the proper xorg configuration. X starts and works fine
right out of the box. It works in 1680x945 right away - no issues here.

Install the Synaptic driver
---------------------------

The mouse pad works, but it has issues. You need to install Synaptic:

    # pacman -S xf86-input-synaptic

ACPI
----

You have to tweak acpi a little, otherwise the laptop will randomly
freeze. First add the following modules to your rc.conf: ac, battery,
button, fan, thermal. Second edit /etc/acpi/handler.sh and under battery
create another case for BAT1) which is the same as BAT0).

Here is an example of my /etc/acpi/handler.sh:

    #!/bin/sh
    # Default acpi script that takes an entry for all actions

    # NOTE: This is a 2.6-centric script.  If you use 2.4.x, you'll have to
    #       modify it to not use /sys

    minspeed=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq`
    maxspeed=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq`
    setspeed="/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed"

    set $*

    case "$1" in
        button/power)
            #echo "PowerButton pressed!">/dev/tty5
            case "$2" in
                PWRF)   logger "PowerButton pressed: $2" ;;
                *)      logger "ACPI action undefined: $2" ;;
            esac
            ;;
        button/sleep)
            case "$2" in
                SLPB)   echo -n mem >/sys/power/state ;;
                *)      logger "ACPI action undefined: $2" ;;
            esac
            ;;
        ac_adapter)
            case "$2" in
                AC)
                    case "$4" in
                        00000000)
                            echo -n $minspeed >$setspeed
                            #/etc/laptop-mode/laptop-mode start
                        ;;
                        00000001)
                            echo -n $maxspeed >$setspeed
                            #/etc/laptop-mode/laptop-mode stop
                        ;;
                    esac
                    ;;
                *)  logger "ACPI action undefined: $2" ;;
            esac
            ;;
        battery)
            case "$2" in
                BAT0)
                    case "$4" in
                        00000000)   #echo "offline" >/dev/tty5
                        ;;
                        00000001)   #echo "online"  >/dev/tty5
                        ;;
                    esac
                    ;;
                BAT1)
                    case "$4" in
                        00000000)   #echo "offline" >/dev/tty5
                        ;;
                        00000001)   #echo "online"  >/dev/tty5
                        ;;
                    esac
                    ;;
                CPU0)	
                    ;;
                *)  logger "ACPI action undefined: $2" ;;
            esac
            ;;
        button/lid)
            #echo "LID switched!">/dev/tty5
            ;;
        *)
            logger "ACPI group/action undefined: $1 / $2"
            ;;
    esac

You may also want to add pm-suspend under button/lid) to make your
laptop suspend when closed. I particularly do not ever close my laptop,
because I use it as a desktop computer.

Laptop Mode Tools
-----------------

I installed laptop-mode-tools, but it didn't seem to improve anything so
I disabled it. The battery life of this laptop is less than an hour and
there is not much you can do. I use the laptop as a replacement for a
desktop computer, so it's always plugged in.

Multimedia Buttons
------------------

The volume buttons work out of the box. I am, however, slightly annoyed
with them, because they are a little too close to the keyboard and can
be accidentally pressed when typing. They can be disabled from the Gnome
menu System -> Preferences -> Keyboard Shortcuts

External Microphone
-------------------

The external microphone works well with OSS, but in order to work with
ALSA, you have to add this line to /etc/modprobe.d/alsa-base.conf

    options snd-hda-intel model=dell-vostro

Retrieved from
"https://wiki.archlinux.org/index.php?title=Toshiba_Satellite_P500-ST2G02&oldid=306002"

Category:

-   Toshiba

-   This page was last modified on 20 March 2014, at 17:34.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
