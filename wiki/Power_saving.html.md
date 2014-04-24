Power saving
============

Related articles

-   Power management
-   CPU Frequency Scaling
-   Hybrid graphics
-   Kernel modules
-   sysctl
-   udev

This article covers the configuration needed to turn on power saving
features. Almost all of the features listed here are worth using whether
or not the computer is on AC or battery power. Most have negligible
performance impact and are just not enabled by default because of
commonly broken hardware/drivers. Reducing power usage means reducing
heat, which can even lead to higher performance on a modern Intel or AMD
CPU, thanks to dynamic overclocking.

Contents
--------

-   1 Configuration
    -   1.1 Audio
    -   1.2 Active state power management
    -   1.3 Backlight
    -   1.4 Bluetooth
    -   1.5 Web-Camera
    -   1.6 Kernel parameters
        -   1.6.1 Disabling NMI watchdog
        -   1.6.2 Writeback Time
        -   1.6.3 Laptop Mode
    -   1.7 Network interfaces
    -   1.8 PCI Runtime Power Management
    -   1.9 SATA Active Link Power Management
    -   1.10 USB Autosuspend
    -   1.11 Device Power Management
    -   1.12 Mount options
    -   1.13 CD/DVD spin down
-   2 Tools and scripts
    -   2.1 Packages
    -   2.2 Using a script and an udev rule
    -   2.3 Print power settings
-   3 See also

Configuration
-------------

If you would like to create your own scripts and power saving settings
such as by udev rules you can take the following settings as a
reference.

Note:Most rules described below are also managed by tools like TLP and
it is unwise to use multigoverning.

> Audio

By default, audio power saving is turned off by most drivers. It can be
enabled by setting the power_save parameter; a time (in seconds) to go
into idle mode. To idle the audio card after one second, create

    /etc/modprobe.d/audio_powersave.conf

    options snd_hda_intel power_save=1

for Intel, or use

    options snd_ac97_codec power_save=1

for ac97.

Note:Toggling the audio card's power state can cause a popping sound or
noticeable latency on some broken hardware.

> Active state power management

To verify that ASPM is enabled:

    $ cat /sys/module/pcie_aspm/parameters/policy

    [default] performance powersave

Either [default] or [powersave] means you do not need to force it on.
Otherwise, it's either unsupported or broken on your hardware, or has to
be forced on with pcie_aspm=force on the kernel line.

> Warning:

-   Forcing on ASPM can cause a freeze/panic, so make sure you have a
    way to undo the option if it doesn't work.
-   On systems that don't support it forcing on ASPM can even increase
    power consumption.

> Backlight

When system starts, screen backlight is set to maximum by default. This
can be fixed by specifying backlight level in the following udev rule:

    /etc/udev/rules.d/backlight.rules

    ## SET BACKLIGHT
    SUBSYSTEM=="backlight", ACTION=="add", KERNEL=="acpi_video0", ATTR{brightness}="1"

See Backlight for more information.

> Bluetooth

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: The device       
                           should likely be         
                           disabled with hciconfig  
                           first. (Discuss)         
  ------------------------ ------------------------ ------------------------

Blacklist the hci_usb module if the driver is loaded automatically.

Alternatively, blacklist the btusb and bluetooth modules.

Another variant is to rfkill it:

    # rfkill block bluetooth

Or with udev rule:

    /etc/udev/rules.d/bt.rules

    ## DISABLE BLUETOOTH
    SUBSYSTEM=="rfkill", ATTR{type}=="bluetooth", ATTR{state}="0"

> Web-Camera

If you won't use integrated web camera then blacklist the uvcvideo
module.

> Kernel parameters

This section uses configs in /etc/sysctl.d/, which is "a drop-in
directory for kernel sysctl parameters." See The New Configuration Files
and more specifically systemd's sysctl.d man page for more information.

Disabling NMI watchdog

The NMI watchdog is a debugging feature to catch hardware hangs and
cause a kernel panic. On some systems it can generate a lot of
interrupts, causing a noticeable increase in power usage.

    /etc/sysctl.d/disable_watchdog.conf

    kernel.nmi_watchdog = 0

or add nmi_watchdog=0 to the kernel line to disable it completely from
early boot.

Writeback Time

Increasing the VM dirty writeback time can help to aggregate I/O
together - reducing disk writes, and decreasing power usage:

    /etc/sysctl.d/dirty.conf

    vm.dirty_writeback_centisecs = 1500

To do the same for journal commits with ext4 and some other filesystems,
use commit=15 as a parameter in fstab or with the rootflags kernel
parameter.

Laptop Mode

See the kernel documentation on the laptop mode 'knob.' "A sensible
value for the knob is 5 seconds."

    /etc/sysctl.d/laptop.conf

    vm.laptop_mode = 5

> Network interfaces

Wake-on-LAN can be a useful feature, but if you're not making use of it
then it's simply draining extra power waiting for a magic packet while
in suspend. Disabling for all Ethernet interfaces:

    /etc/udev/rules.d/70-disable_wol.rules

    ACTION=="add", SUBSYSTEM=="net", KERNEL=="eth*", RUN+="/usr/bin/ethtool -s %k wol d"

To enable powersaving on all wireless interfaces:

    /etc/udev/rules.d/70-wifi-powersave.rules

    ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan*", RUN+="/usr/bin/iw dev %k set power_save on"

In these examples, %k is a specifier for the kernel name of the matched
device. For example, if it finds that the rule is applicable to wlan0,
the %k specifier will be replaced with wlan0. To apply the rules to only
a particular interface, just replace the pattern eth* and specifier %k
with the desired interface name. For more information, see Writing udev
rules.

In this case, the name of the configuration file is important. Due to
the introduction of persistent device names via 80-net-name-slot.rules
in systemd v197, it is important that the network powersave rules are
named lexicographically before 80-net-name-slot.rules, so that they are
applied before the devices are named e.g. enp2s0.

> PCI Runtime Power Management

    /etc/udev/rules.d/pci_pm.rules

    ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"

> SATA Active Link Power Management

Note:This adds latency when accessing a drive that has been idle, so
it's one of the few settings that may be worth toggling based on whether
you're on AC power.

    /etc/udev/rules.d/hd_power_save.rules

    ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="min_power"

Warning:SATA Active Link Power Management can lead to data loss on some
devices (e.g. Lenovo T440s is known to suffer this problem)

> USB Autosuspend

To enable USB autosuspend after 2 seconds of inactivity:

    /etc/udev/rules.d/usb_power_save.rules

    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend", ATTR{power/autosuspend}="2"

Other option is to use modprobe:

    /etc/modprobe.d/modprobe.conf

    options usbcore autosuspend=2

> Device Power Management

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Should be done   
                           with a udev rule.        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

    # echo auto | tee /sys/bus/i2c/devices/*/power/control > /dev/null
    # echo auto | tee /sys/bus/spi/devices/*/power/control > /dev/null

> Mount options

You might want to use the noatime option, see Fstab#atime options for
more information.

> CD/DVD spin down

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: something        
                           similar without using    
                           udisks? (Discuss)        
  ------------------------ ------------------------ ------------------------

To allow the CD/DVD rom to spin down after a while using udisks:

    # udisks --inhibit-polling /dev/sr0

Tools and scripts
-----------------

> Packages

There are many scripts and tools which make use of the various settings
described in the previous sections. These are notably:

-   Powertop is a handy utility from Intel that displays which
    hardware/processes are using the most power on your system, and
    provides instructions on how to stop or remove power-wasting
    services. It's report functionality can also be used to identify the
    relevant parameters for the system.
-   TLP
-   Powerdown
-   powerconf
-   ftw-git
-   Laptop Mode Tools
-   pm-utils

If you do not want to take care of the settings by yourself it is
recommended to use these tools. But be aware of running only one of
these tools to avoid possible conflicts as they all work more or less
similar.

Tip:Have a look at the power management category to get an overview on
what power management options exists in Archlinux.

> Using a script and an udev rule

Since systemd users can suspend and hibernate through systemctl suspend
or systemctl hibernate and handle acpi events with
/etc/systemd/logind.conf, it might be interesting to remove pm-utils and
acpid. There's just one thing systemd can't do (as of systemd-204):
power management depending on whether the system is running on AC or
battery. To fill this gap, you can create a single udev rule that runs a
script when the AC adapter is plugged and unplugged:

    /etc/udev/rules.d/powersave

    SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="/path/to/your/script true"
    SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="/path/to/your/script false"

Note:You can use the same script that pm-powersave uses. You just have
to make it executable and place it somewhere else (for example
/usr/local/bin/).

Examples of powersave scripts can be found here: powerdown, powerconf,
powersave.

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
    esac
    exit 0

Don't forget to make it executable!

Note:Be aware that AC0 may be different for your laptop, change it if
that is the case.

Now you don't need pm-utils anymore. Depending on your configuration, it
may be a dependency of some other package. If you wish to remove it
anyway, run pacman -Rdd pm-utils.

> Print power settings

This script prints power settings and a variety of other properties for
USB and PCI devices. Note that root permissions are needed to see all
settings.

    #!/bin/bash

    for i in $(find /sys/devices -name "bMaxPower")
    do
    	busdir=${i%/*}
    	busnum=$(<$busdir/busnum)
    	devnum=$(<$busdir/devnum)
    	title=$(lsusb -s $busnum:$devnum)

    	printf "\n\n+++ %s\n  -%s\n" "$title" "$busdir"

    	for ff in $(find $busdir/power -type f ! -empty 2>/dev/null)
    	do
    		v=$(cat $ff 2>/dev/null|tr -d "\n")
    		[[ ${#v} -gt 0 ]] && echo -e " ${ff##*/}=$v";
    		v=;
    	done | sort -g;
    done;

    printf "\n\n\n+++ %s\n" "Kernel Modules"
    for mod in $(lspci -k | sed -n '/in use:/s,^.*: ,,p' | sort -u)
    do
    	echo "+ $mod";
    	systool -v -m $mod 2> /dev/null | sed -n "/Parameters:/,/^$/p";
    done

See also
--------

Note:Please check the dates of the linked pages as they can become
deprecated.

-   http://forum.manjaro.org/index.php?topic=1166.0
-   Ubuntu Wiki's Power Saving Tweaks

Retrieved from
"https://wiki.archlinux.org/index.php?title=Power_saving&oldid=305548"

Category:

-   Power management

-   This page was last modified on 19 March 2014, at 01:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
