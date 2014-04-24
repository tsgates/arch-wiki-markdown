Laptop
======

This page should contain links to pages needed for configuring a laptop
for the best experience. Setting up a laptop is in many ways the same as
setting up a desktop. However, there are a few key differences. Arch
Linux provides all the tools and programs necessary to take complete
control of your laptop. These programs and utilities are highlighted
below, with appropriate tips tutorials.

Contents
--------

-   1 Power management
    -   1.1 Battery state
        -   1.1.1 ACPI
        -   1.1.2 Udev events
            -   1.1.2.1 Testing events
    -   1.2 Suspend and Hibernate
        -   1.2.1 Hard drive spin down problem
-   2 Hardware support
    -   2.1 Screen brightness
    -   2.2 Touchpad
    -   2.3 Fingerprint Reader
    -   2.4 Webcam
    -   2.5 Hard disk shock protection
    -   2.6 Hybrid graphics
-   3 Network time syncing
-   4 See also

Power management
----------------

Note:You should read the main articles Power management and Power
saving. Additional laptop-specific features are described below.

Power management is very important for anyone who wishes to make good
use of their battery capacity. The following tools and programs help to
increase battery life and keep your laptop cool and quiet.

> Battery state

Reading battery state can be done in multiple ways. Classical method is
some daemon periodically polling battery level using ACPI interface. On
some systems, battery sends events to udev whenever it (dis)charges by
1%, this event can be connected to some action using udev rule.

ACPI

Battery state can be read using ACPI utilities from the terminal. ACPI
command line utilities are provided via the acpi package. See ACPI
modules for more information.

-   batti is a simple battery monitor for the system tray. Uses UPower
    (or DeviceKit.Power if the former is missing) for its power
    information.
-   batterymon-clone is a simple battery monitor that sits in the system
    tray, similar to batti.

Udev events

If your battery sends events to udev whenever it (dis)charges by 1%, you
can use this udev rule to automatically suspend the system when battery
level is critical, and thus prevent all unsaved work from being lost.

    /etc/udev/rules.d/99-lowbat.rules

    # Suspend the system when battery level drops to 2%
    SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="2", RUN+="/usr/bin/systemctl suspend"

Likewise, the rule can be customized to perform other action on
different status.

Testing events

One way to test udev rules is to have them create a file when they are
run. For example:

    /etc/udev/rules.d/98-discharging.rules

    SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", RUN+="/usr/bin/touch /home/example/discharging"

This creates a file at /home/example/discharging when the laptop charger
is unplugged. You can test whether the rule worked by unplugging your
laptop and looking for this file. For more advanced udev rule testing,
see Udev#Testing rules before loading.

> Suspend and Hibernate

Manually suspending the operating system, either to memory (standby) or
to disk (hibernate) sometimes provides the most efficient way to
optimize battery life, depending on the usage pattern of the laptop.

See the main article Suspend and Hibernate.

Hard drive spin down problem

Documented here

To prevent your laptop hard drive from spinning down too often:

    /etc/udev/rules.d/75-hdparm.rules

    ACTION=="add", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", RUN+="/usr/bin/hdparm -B 254 /dev/$kernel"

See hdparm(8) for documentation of hdparm parameters.

Hardware support
----------------

> Screen brightness

See Backlight.

> Touchpad

To get your touchpad working properly, see the Touchpad Synaptics page.
Note that your laptop may have an ALPS touchpad (such as the DELL
Inspiron 6000), and not a Synaptics touchpad. In either case, see the
link above.

> Fingerprint Reader

See fprint and ThinkFinger (for ThinkPads).

> Webcam

See Webcam Setup.

> Hard disk shock protection

There are several laptops from different vendors featuring shock
protection capabilities. As manufacturers have refused to support open
source development of the required software components so far, Linux
support for shock protection varies considerably between different
hardware implementations.

Currently, two projects, named HDAPS and hpfall (available in the AUR),
support this kind of protection. HDAPS is for IBM/Lenovo Thinkpads and
hpfall for HP/Compaq laptops.

> Hybrid graphics

The laptop manufacturers developed new technologies involving two
graphic cards in an single computer, enabling both high performance and
power saving usages. These laptops usually using Intel for display, so
Intel Graphics driver is needed first, then you can choose methods to
utilize second graphic card.

Network time syncing
--------------------

For a laptop, it may be a good idea to use Chrony as an alternative to
NTPd or OpenNTPD to sync your clock over the network. Chrony is designed
to work well even on systems with no permanent network connection (such
as laptops), and is capable of much faster time synchronisation than
standard ntp. Chrony has several advantages when used in systems running
on virtual machines, such as a larger range for frequency correction to
help correct quickly drifting clocks, and better response to rapid
changes in the clock frequency. It also has a smaller memory footprint
and no unnecessary process wakeups, improving power efficiency.

See also
--------

General

-   CPU Frequency Scaling is a technology used primarily by notebooks
    which enables the OS to scale the CPU frequency up or down,
    depending on the current system load and/or power scheme.
-   Display Power Management Signaling describes how to automatically
    turn off the laptop screen after a specified interval of inactivity
    (not just blanked with a screensaver but completely shut off).
-   Wireless network configuration provides information about setting up
    wireless connection.
-   Extra Keyboard Keys describes configuration of Media keys.
-   acpid which is a flexible and extensible daemon for delivering ACPI
    events.

Pages specific to certain laptop types

-   See Category:Laptops and its subcategories for pages dedicated to
    specific models/vendors.
-   Lapsus is a set of programs providing easy access to many features
    of various laptops. It currently supports most features provided by
    asus-laptop kernel module from ACPI4Asus project, such as additional
    LEDs, hotkeys, backlight control etc. It also has support for some
    IBM laptops features provided by IBM ThinkPad ACPI Extras Driver and
    NVRAM device.
-   Battery tweaks for ThinkPads can be found in TLP and the tp_smapi
    article.
-   acerhdf is a kernel module for controlling fan speed on Acer Aspire
    One and some Packard Bell Notebooks.

External resources

-   http://www.linux-on-laptops.com/
-   http://www.linlap.com/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Laptop&oldid=304337"

Category:

-   Laptops

-   This page was last modified on 13 March 2014, at 18:50.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
