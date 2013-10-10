Laptop
======

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Setting Up For Laptops                                             |
| -   2 Power Management                                                   |
|     -   2.1 Battery State                                                |
|         -   2.1.1 Udev events                                            |
|         -   2.1.2 Low charge action                                      |
|         -   2.1.3 Utilities                                              |
|                                                                          |
|     -   2.2 Suspend and Hibernate                                        |
|     -   2.3 Power saving                                                 |
|         -   2.3.1 Automatic tweaks for battery life                      |
|         -   2.3.2 PCI-e ASPM                                             |
|         -   2.3.3 Granola                                                |
|         -   2.3.4 Wireless                                               |
|         -   2.3.5 Disk-related tweaks                                    |
|         -   2.3.6 More tweaks                                            |
|         -   2.3.7 Hard drive spin down problem                           |
|                                                                          |
|     -   2.4 Using a script and an udev rule                              |
|                                                                          |
| -   3 Screen brightness                                                  |
| -   4 Touchpad                                                           |
| -   5 Hard disk shock protection                                         |
| -   6 Network Time Syncing                                               |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Setting Up For Laptops
----------------------

This page should contain links to pages needed for configuring a laptop
for the best experience. Setting up a laptop is in many ways the same as
setting up a desktop. However, there are a few key differences. When
setting up a laptop with Arch Linux, the following points should be
taken into consideration:

-   #Power Management Power Management for laptops refers to optimizing
    the system to last as long as possible on a single battery charge.
    This can be accomplished by a variety of tweaks.
    -   #Suspend and Hibernate : the operating system can be manually
        suspended either to memory or to disk, allowing for an (almost)
        complete shutdown of other hardware.
    -   Hard drive spindown : the system can be configured to
        automatically turn off the hard disk after a specified interval
        of inactivity.
    -   Screen shut off : the laptop screen can be configured to
        automatically turn off after a specified interval of inactivity
        (not just blanked with a screensaver but completely shut off).
    -   CPU frequency scaling : the processor(s) can be configured to
        automatically step down to a lower frequency at lower loads.

-   #Screen brightness. How do I manage screen brightness?
-   Network and wireless setup is described in Wireless Setup.
-   Media buttons can be configured as described in Extra Keyboard Keys.
-   #Touchpad sensitivity, acceleration, button function and scroll
    borders can be configured for some (Synaptics or Alps) touchpads.
-   #Hard disk shock protection

All of these points are important to take into consideration when
getting a laptop set up the way you like. Fortunately, Arch Linux
provides all the tools and programs necessary to take complete control
of your laptop. These programs and utilities are highlighted below, with
appropriate tips tutorials.

Power Management
----------------

Power management is very important for anyone who wishes to make good
use of their battery capacity. The following tools and programs help to
increase battery life and keep your laptop cool and quiet.

> Battery State

Udev events

Upon change battery sends events which can be handled by udev. Example
of how it could be used is presented below.

Low charge action

By default, the system won't do anything if your laptop's battery is
going to discharge. In order not to lose all unsaved work this example
udev rule could be used (if your battery sends uevent when it
charges/discharges by 1%):

    /etc/udev/rules.d/lowbat.rules

    ## SLEEP IF BATTERY IS LOW
    SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="2", RUN+="/usr/bin/systemctl suspend"

Likewise, the rule can be customized to perform other action on
different status.

Utilities

Battery state can be read using ACPI utilities from the terminal. ACPI
command line utilities are provided via the acpi package. A simple
battery monitor that sits in the system tray is batterymon-clone which
can be found in the AUR.

Tip:More information can be found in the ACPI modules article.

-   batti is a simple battery monitor for the system tray, similar to
    batterymon-clone. Unlike the latter batti uses UPower, and if that
    is missing DeviceKit.Power, for it's power information.

> Suspend and Hibernate

Manually suspending the operating system, either to memory (standby) or
to disk (hibernate) sometimes provides the most efficient way to
optimize battery life, depending on the usage pattern of the laptop.
While there is relatively straightforward support in the linux kernel to
support these operations, typically some adjustments have to be made
before initiating these operations (typically due to problematic
drivers, modules or hardware). The following tools provide wrappers
around the kernel interfaces to suspend/resume :

-   Acpid
-   Pm-utils
-   Uswsusp

which are described in more detail in Suspend.

> Power saving

See the main article, power saving.

Automatic tweaks for battery life

As opposed to manually initiated actions like suspend/hibernate, a
number of tweaks can be made to prolong the battery life of the laptop
under low/idle usage.

-   CPU Frequency Scaling is a technology used primarily by notebooks
    which enables the OS to scale the CPU frequency up or down,
    depending on the current system load and/or power scheme.
-   Laptop Mode Tools provides a comprehensive suite of tools to tweak a
    large number of power saving settings through well documented
    configuration files.
-   Powertop is a handy utility from Intel that displays which
    hardware/processes are using the most power on your system, and
    provides instructions on how to stop or remove power-wasting
    services. Works great for mobile Intel CPUs; provides the current
    CPU state and suggestions for power saving. Also works on AMD
    systems, but does not provide as much information about the CPU
    state.
-   TLP is a power management tool that provides all the latest tweaks
    to save battery power without the need for elaborated configuration
    (nonetheless it is highly configurable).

The following options are specific to certain laptop types:

-   Lapsus is a set of programs providing easy access to many features
    of various laptops. It currently supports most features provided by
    asus-laptop kernel module from ACPI4Asus project, such as additional
    LEDs, hotkeys, backlight control etc. It also has support for some
    IBM laptops features provided by IBM ThinkPad ACPI Extras Driver and
    NVRAM device.
-   Battery tweaks for ThinkPads can be found in TLP and the tp_smapi
    article.

PCI-e ASPM

On some laptops, powertop suggests enabling the CONFIG_PCIEASPM kernel
option. It can be found under "Bus options (PCI etc.)"->"PCI Express
ASPM support". This option is marked as experimental in the current
kernel (2.6.35) and allows the PCI-e links to enter a power saving
state.

According to [1], this option might degrade performance a bit, but on an
Acer 3820TG laptop, it can reduce power consumption by about one third
or even more.

More experience with this setting would be appreciated, so please share
them here!

It seems like the option is going to be enabled by default in kernel
2.6.36; if so, the information here will be obsolete soon. However, if
your system should be able to make use of this power management feature
but you are receiving messages like like the following (check
/var/log/everything.log*):

    disabling ASPM on pre-1.1 PCI-e device.  You can enable it with 'pcie_aspm=force'

then add pcie_aspm=force to your kernel command line.

Granola

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Arch Linux has   
                           moved to systemd, so     
                           rc.conf is no longer     
                           used. (Discuss)          
  ------------------------ ------------------------ ------------------------

Granola is a daemon that monitors the cpu usage and uses the
cpufreq-userspace module to lessen power usage without any noticeable
difference in performance. To use it, first install from the AUR:[2],
the default settings will work for most setups. You will need to load
the cpufreq_userspace module, as well as the cpufreq scaling governor
for your CPU at startup. Edit /etc/rc.conf: For most generic cpus:

     MODULES=( ... cpufreq_userspace acpi-cpufreq ... )

For Intel Atom or Pentium 4 cpus:

     MODULES=( ... cpufreq_userspace p4_clockmod ... )

Then add Granola to the DAEMONS array:

     DAEMONS=( ... granola ... )

and reboot.

To test if it worked, run:

     cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
     #OR
     cpufreq-info #if you have cpufreq-utils installed

and check that the cpu frequency is below maximum.

Wireless

When working on your notebook/laptop without wireless access, here is a
little script for your system startup that turns off your WLAN-Hardware
to keep it from wasting power searching for an Access Point:

Note: Edit if wlan0 is not your WLAN-device

    #!/bin/bash
     
     essid="`iwconfig wlan0 | grep ESSID | awk {'print $4'}`"
     	if [ "$essid" == "ESSID:off/any" ] ; then
     		sudo iwconfig wlan0 txpower off
     	fi

Start the script according to your DE/WM options by
sleep xx && /path/to/script depending on how long it usually takes to
connect to your Access Point, 60 seconds are a good default value. It
checks if you're connected, turning off the device if not.
# iwconfig wlan0 txpower on brings it back up, as well as a reboot.

Tip:It may also be prudent to prevent your wireless interface from
starting at boot if it is not used often (e.g. netcfg-menu as needed).

Disk-related tweaks

Disable file access time: every time you access (read) a file the
filesystem writes an access time to the file metadata. You can disable
this on individual files by using the chattr command, or you can enable
it on an entire disk by setting the noatime option in your fstab, as
follows:

    /dev/sda1          /          ext3          defaults,noatime          1  2

Source

> Note:

-   Disabling atime causes troubles with mutt and other applications
    that make use of file timestamps. Consider compromising between
    performance and compatibility by using mount option relatime
    instead, or look into mutt work-around for noatime.
-   relatime is used by default as of kernel 2.6.30, so unless you're
    using an older kernel, there should be no need to edit fstab.

To allow the CD/DVD rom to spin down after a while using udisks:

    # udisks --inhibit-polling /dev/sr0

More tweaks

These are some generic suggestions that will work with most laptops.

Add the following to /etc/modprobe.d/modprobe.conf:

    options usbcore autosuspend=1

Add the following to /etc/sysctl.conf

    vm.dirty_writeback_centisecs=1500
    vm.laptop_mode=5

Note:laptop-mode-tools automatically rewrites these values based on the
values LM_BATT_MAX_LOST_WORK_SECONDS, LM_AC_MAX_LOST_WORK_SECONDS (both
multiplied by 100) resp. LM_SECONDS_BEFORE_SYNC, which are set in
/etc/laptop-mode/laptop-mode.conf. However, that only happens if the
three "Enable laptop mode" variables in the same file are set
accordingly — left to 0, it resets the values to kernel defaults (500 /
0) for the corresponding scenario regardless of /etc/sysctl.conf.

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: This belongs in  
                           a udev rule, not         
                           rc.local. (Discuss)      
  ------------------------ ------------------------ ------------------------

Add the following to /etc/rc.local (and make sure it gets executed at
boot time)

    /usr/sbin/iwpriv your_wireless_interface set_power 5

Source: here

Hard drive spin down problem

Documented here

To prevent your laptop hard drive from spinning down too often (result
of too aggressive APM defaults) do the following:

Add the following to /etc/rc.local

    hdparm -B 254 /dev/sdX where X is your hard drive device

If you are using Systemd:

Add the following to /etc/udev/rules.d/75-hdparm.rules

    ACTION=="add", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", RUN+="/sbin/hdparm -B 254 /dev/$kernel"

You can also set it to 255 to completely disable spinning down. You may
wish to set a lower value if you move your laptop around as lower values
park the heads more often and reduce the chance of damage to your hard
disk while it is being moved. If you do not move your laptop at all when
you are using it, then 255 or 254 is probably best. If you do, then you
might want to try a lower value. A value like 128 might be a good
middle-ground.

Add the following to /etc/pm/sleep.d/50-hdparm_pm

    #!/bin/sh
     
    if [ -n "$1" ] && ([ "$1" = "resume" ] || [ "$1" = "thaw" ]); then
    	hdparm -B 254 /dev/your-hard-drive > /dev/null
    fi

and run chmod +x /etc/pm/sleep.d/50-hdparm_pm to make sure it resets
after suspend. Again, you can change the value 254 as you see fit.

Now the APM level should be set for your hard drive.

For some laptops, the option -S to hdparm can also be relevant (sets the
spindown time for the drive). Note that all these options can also be
configured using the laptop-mode tools. This will allow you to set a
high value when on AC and a lower value when you are running on battery
power.

> Using a script and an udev rule

Since systemd users can suspend and hibernate through systemctl suspend
or systemctl hibernate and handle acpi events with
/etc/systemd/logind.conf, it might be interesting to remove pm-utils and
acpid. Now, there's just one thing systemd can't do (at this time of
writing): powermanagement, depending on whether the system is running on
AC or battery. To fill this gap, one can create a single udev rule that
launches a script when the laptop is unplugged and plugged:

    /etc/udev/rules.d/powersave

    SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="/path/to/your/script true"
    SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="/path/to/your/script false"

Note:One can use the same script that pm-powersave uses. You just have
to make it executable and place it somewhere else (for example,
/usr/bin).

Examples of powersave scripts can be found here: [3] (or in aur:
powerdown), here: [4] and there: [5].

The above udev rule should work as expected, but if your power settings
aren't updated after a suspend or hibernate cycle, you should add a
script in /usr/lib/systemd/system-sleep/ with the following contents:

    /usr/lib/systemd/system-sleep/00powersave

    #!/bin/sh

    case $1 in
        pre) /path/to/your/script false ;;
        post)       
    	if cat /sys/class/power_supply/AC0/online | grep 0 > /dev/null 2>&1
    	then
        		/path/to/your/script true	
    	else
        		/path/to/your/script false
    	fi
        ;;
    esac'
    exit 0

Don't forget to make it executable!

Note:Be aware that AC0 may be different for your laptop, change it if
that is the case.

Now you don't need pm-utils anymore. Depending on your configuration, it
may be a dependency of some other package. If you wish to remove it
anyway, run pacman -Rdd pm-utils.

Screen brightness
-----------------

See Backlight.

Touchpad
--------

To get your touchpad working properly, see the Touchpad Synaptics page.
Note that your laptop may have an ALPS touchpad (such as the DELL
Inspiron 6000), and not a Synaptics touchpad. In either case, see the
link above.

Hard disk shock protection
--------------------------

There are several laptops from different vendors featuring shock
protection capabilities. As manufacturers have refused to support open
source development of the required software components so far, Linux
support for shock protection varies considerably between different
hardware implementations.

Currently, two projects, named HDAPS and hpfall, support this kind of
protection. HDAPS is for IBM/Lenovo Thinkpads and hpfall for HP/Compaq
laptops

Just Check Hard Disk Active Protection System. hpfall can be installed
from the AUR.

Network Time Syncing
--------------------

For a laptop, it may be a good idea to use Chrony as an alternative to
NTPd to sync your clock over the network. Chrony is designed to work
well even on systems with no permanent network connection (such as
laptops), and is capable of much faster time synchronisation than
standard ntp. Chrony has several advantages when used in systems running
on virtual machines, such as a larger range for frequency correction to
help correct quickly drifting clocks, and better response to rapid
changes in the clock frequency. It also has a smaller memory footprint
and no unnecessary process wakeups, improving power efficiency.

See also
--------

-   http://www.linux-on-laptops.com/
-   http://www.linlap.com/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Laptop&oldid=255068"

Category:

-   Laptops
