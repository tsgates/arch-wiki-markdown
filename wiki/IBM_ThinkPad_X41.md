IBM ThinkPad X41
================

The X41 and X41t (tablet) are both SATA-based machines that include a
SATA-PATA bridge allowing the use of PATA HDDs, see external links for
modifications to use SATA HDDs and SSDs. The laptops utilise a Pentium M
processor (either 1.5GHz or 1.6GHz), the Linux-ck packages contain
optimised packages for this architecture.

This article contains some useful tweaks to make the most of your
machine, the tweaks are mainly powersaving biased. With vanilla Arch,
around 3 hours battery life was achieved, following powersaving tweaks a
bit over than 5 hours was achieved, this was performed with screen
brightness at the second highest value.

Contents
--------

-   1 Installation
-   2 Useful packages
    -   2.1 System Packages
    -   2.2 Applications
-   3 General Tweaks
    -   3.1 Scrolling with trackpoint
-   4 Powersaving tweaks
    -   4.1 laptop-mode (kernel)
    -   4.2 SATA-ALPM (pm-utils)
    -   4.3 Powersaving on PCI devices
    -   4.4 i915 RC6 powersaving
    -   4.5 Disable NMI watchdog
    -   4.6 PHC
-   5 Tablet support
    -   5.1 Getting display keys to work
-   6 External links

Installation
------------

Grab the .iso file from the download page, write this to a memory stick

     sudo dd if=archlinux-201x.xx.xx-dual.iso of=/dev/sdX bs=4M

Restart the computer and boot into it like any other Arch installation.

Useful packages
---------------

Some useful packages for your IBM/Lenovo ThinkPad X41:

> System Packages

-   acpi - provides /proc/acpi, interesting things like lid state,
    temperatures, volume, brightness etc.
-   xf86-input-wacom - Driver supporting Wacom tablet screen.
-   xf86-video-intel - Xorg driver for the Intel 915GM graphics chip.
-   tp_smapi - Adds support for SMAPI functions (battery discharge
    control, battery information, hdaps acceloremeter support). If
    you're using Linux-ck try tp_smapi-dkms (AUR).
-   thinkfinger - Driver for fingerprint reader.

The IBM X41 comes with a ipw2915 wireless Centrino (A, B and G) or
ipw2200 wireless Centrino (B and G) module, the ipw2200 module provides
support for these two devices. netctl has been tested and works
flawlessly with the ipw2915.

> Applications

-   powertop - Measure power usage.
-   cellwriter - (X41t) on-screen tablet keyboard.

Note:Thinkfan seems to fail due to thinkpad_acpi not having a
fan_control function

-   thinkfan - Control the utilisation of the fan.
-   gpm - Linux console mouse server.

General Tweaks
--------------

> Scrolling with trackpoint

The following file can be added for trackpoint scrolling support in X.

    /etc/X11/xorg.conf.d/10-trackpoint.conf


    Section "InputClass"
            Identifier      "Trackpoint Wheel Emulation"
            MatchProduct    "TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device"
            MatchDevicePath "/dev/input/event*"
            Option          "EmulateWheel"          "true"
            Option          "EmulateWheelButton"    "2"
            Option          "Emulate3Buttons"       "false"
            Option          "XAxisMapping"          "6 7"
            Option          "YAxisMapping"          "4 5"
    EndSection

Taken from Xorg#Example: Wheel emulation (for a Trackpoint)

Powersaving tweaks
------------------

Initially without any powersaving tweaks, the X41 uses quite a lot of
power (this can be monitored using powertop, it also provides
suggestions for reducing power consumption). Here are some modifications
that I found considerable improved the battery life of the X41t.

> laptop-mode (kernel)

Laptop mode is included in the kernel, it buffers disk activities to
reduce utilisation of your HDD therefore saving a considerable amount of
power. The effect with SSDs is less pronounced, but still saves some
power.

    echo "vm.laptop_mode=5" | sudo tee /etc/sysctl.d/laptop_mode.conf

> SATA-ALPM (pm-utils)

ALPM - Aggressive Link Power Management allows the SATA host bus adapter
to enter a low power state when inactive therefore reducing power
consumption.

    echo "SATA_ALPM_ENABLE=true" | sudo tee /etc/pm/config.d/sata_alpm
    sudo chmod +x /etc/pm/config.d/sata_alpm

> Powersaving on PCI devices

Powersaving isn't automatically enabled on devices as sometimes it
causes issues, this can save about 2W.

    /etc/udev/rules.d/pci_powersaving.rules

    ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"

> i915 RC6 powersaving

See Intel_Graphics#Module-based_Powersaving_Options.

> Disable NMI watchdog

The NMI watchdog is a debugging feature of the linux kernel that is
enabled by default. It is useless for normal operation and significantly
increases the number of CPU wakeups/second.

    echo "kernel.nmi_watchdog=0" | sudo tee /etc/sysctl.d/nmi_watchdog.conf

> PHC

PHC - Processor Hardware Control. intel-phc supports the Mobile Centrino
line of processors and hence the X41, this program allows you to
undervolt your CPU. Undervolting reduces the voltage(V) the processor
runs at, because P=IV this will reduce your power consumption, this has
no effect on performance, any excess voltage will be dissipated as heat,
your laptop will run cooler and the fan will activate less frequently.

    $ yaourt -S phc-intel
    $ phc-intel setup # To install drivers
    $ yaourt -S linux-phc-optimize
    $ sudo linux-phc-optimize # Repeat this each time the laptop crashes until you've got a full set of parameters, this is 9 times

Once you have established stable VIDs, adding them to system startup can
be accomplished modifying the phc-intel configuration file. If it
doesn't exist, create it

    /etc/phc-intel.conf

     VIDS="17 15 13 11 9 7 5 4 4"  

You can check that this is enabled on your next reboot by
sudo phc-intel status

Tablet support
--------------

The X41t utilises a Wacom digitiser for input,
pacman -S xf86-input-wacom provides support for it. Once installed the
driver should be activated following the next reboot.

> Getting display keys to work

If the display keys (Rotate, Escape, Enter, Prev, Next,...) on your X41
tablet aren't working, add atkbd.softraw=0 as a kernel parameter in your
boot loader configuration. Once they're producing scancodes, you can map
them to keycodes.

External links
==============

-   This report has been listed in the Linux Laptop and Notebook
    Installation Survey: IBM.
-   SATA support modification
-   ThinkWiki X41 page
-   T43p Cooling - applicable to X41t, I've added ~1mm thick copper
    sheet to both the CPU and northbridge heatsinks with no ill effects.

Retrieved from
"https://wiki.archlinux.org/index.php?title=IBM_ThinkPad_X41&oldid=293347"

Category:

-   IBM

-   This page was last modified on 17 January 2014, at 14:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
