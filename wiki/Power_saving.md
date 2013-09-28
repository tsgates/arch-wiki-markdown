Power saving
============

This article covers the configuration needed to turn on power saving
features. Almost all of the features listed here are worth using whether
or not the computer is on AC or battery power. Most have negligible
performance impact and are just not enabled by default because of
commonly broken hardware/drivers. Reducing power usage means reducing
heat, which can even lead to higher performance on a modern Intel or AMD
CPU, thanks to dynamic overclocking.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Ready to run scripts                                               |
| -   2 Custom settings                                                    |
|     -   2.1 Audio                                                        |
|     -   2.2 Active State Power Management                                |
|     -   2.3 Backlight                                                    |
|     -   2.4 Bluetooth                                                    |
|     -   2.5 Web-Camera                                                   |
|     -   2.6 Disabling NMI watchdog                                       |
|     -   2.7 Disabling Wake-on-LAN                                        |
|     -   2.8 PCI Runtime Power Management                                 |
|     -   2.9 Wireless power saving                                        |
|     -   2.10 Writeback Time                                              |
|     -   2.11 Laptop Mode                                                 |
|     -   2.12 SATA Active Link Powermanagement                            |
|     -   2.13 USB Autosuspend                                             |
|     -   2.14 Device Power Management                                     |
|     -   2.15 View Power Setings                                          |
|     -   2.16 See also                                                    |
+--------------------------------------------------------------------------+

Ready to run scripts
--------------------

There are already a couple of scripts and tools which make use of the
various settings described in the next section. These are notably:

-   TLP
-   Powerdown
-   powerconf
-   Laptop Mode Tools
-   pm-utils

If you do not want to take care of the settings by yourself it is
recommended to use these tools. But be aware of running only one of
these tools to avoid possible conflicts as they all work more or less
similar.

Custom settings
===============

If you would like to create your own scripts and power saving settings
such as by udev rules you can take the following settings as a
reference.

Audio
-----

By default, audio power saving is turned off by most drivers. It can be
enabled by setting the power_save parameter to a time (in seconds) to go
in idle.

Note:Toggling the audio card's power state can cause a popping sound or
noticeable latency on some broken hardware.

Intel

    /etc/modprobe.d/audio_power_save.conf

    options snd_hda_intel power_save=1

ac97

    /etc/modprobe.d/audio_power_save.conf

    options snd_ac97_codec power_save=1

Active State Power Management
-----------------------------

To verify that ASPM is enabled:

    $ cat /sys/module/pcie_aspm/parameters/policy

    [default] performance powersave

Either [default] or [powersave] means you do not need to force it on.

Otherwise, it's either unsupported/broken on your hardware, or has to be
forced on with pcie_aspm=force on the kernel line.

Warning:Forcing on ASPM can cause a freeze/panic, so make sure you have
a way to undo the option if it doesn't work.

Warning:On systems that don't support it forcing on ASPM can even
increase power consumption.

Backlight
---------

When system starts, screen backlight is set to maximum by default. This
can be fixed by specifying backlight level in the following udev rule:

    /etc/udev/rules.d/backlight.rules

    ## SET BACKLIGHT
    SUBSYSTEM=="backlight", ACTION=="add", KERNEL=="acpi_video0", ATTR{brightness}="1"

Bluetooth
---------

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

Web-Camera
----------

If you won't use integrated web camera then blacklist the uvcvideo
module.

Disabling NMI watchdog
----------------------

The NMI watchdog is a debugging feature to catch hardware hangs and
cause a kernel panic. On some systems it can generate a lot of
interrupts, causing a noticeable increase in power usage.

    /etc/sysctl.d/disable_watchdog.conf

    kernel.nmi_watchdog = 0

or add nmi_watchdog=0 as a kernel parameter to disable it completely
from early boot.

Disabling Wake-on-LAN
---------------------

Wake-on-LAN can be a useful feature, but if you're not making use of it
then it's simply draining extra power waiting for a magic packet while
in suspend.

Disabling for all Ethernet interfaces:

    /etc/udev/rules.d/disable_wol.rules

    ACTION=="add", SUBSYSTEM=="net", KERNEL=="eth*" RUN+="/usr/sbin/ethtool -s %k wol d"

You can use multiple names in the matches; for example,
KERNEL=="lan0|eth*"

Note:This should be combined with static naming of devices, the eth*
names are not static.

PCI Runtime Power Management
----------------------------

    /etc/udev/rules.d/pci_pm.rules

    ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"

Wireless power saving
---------------------

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: This method does 
                           not seem to work at the  
                           moment. (Discuss)        
  ------------------------ ------------------------ ------------------------

Enabling for a specific interface:

Note:This should be combined with static naming of devices, the eth*
names are not static.

    /etc/udev/rules.d/wlan0_power_save.rules

    ACTION=="add", SUBSYSTEM=="net", KERNEL=="wifi0" RUN+="/usr/sbin/iw dev wifi0 set power_save on"

Enabling for all interfaces:

    /etc/udev/rules.d/wifi_power_save.rules

    ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan*" RUN+="/usr/sbin/iw dev %k set power_save on"

Writeback Time
--------------

Increasing the VM dirty writeback time can help to aggregate I/O
together - reducing disk writes, and decreasing power usage:

    /etc/sysctl.d/dirty_writeback.conf

    vm.dirty_writeback_centisecs = 1500

To do the same for journal commits with ext4 and some other filesystems,
use commit=15 as a parameter in fstab or with the rootflags kernel
parameter.

Laptop Mode
-----------

    /etc/sysctl.d/laptop_mode.conf

    vm.laptop_mode = 5

SATA Active Link Powermanagement
--------------------------------

Note:This adds latency when accessing a drive that has been idle, so
it's one of the few settings that may be worth toggling based on whether
you're on AC power.

    /etc/udev/rules.d/hd_power_save.rules

    SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="min_power"

USB Autosuspend
---------------

To enable USB autosuspend after 2 seconds of inactivity:

    /etc/udev/rules.d/usb_power_save.rules

    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control" ATTR{power/control}="auto"
    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend" ATTR{power/autosuspend}="2"

Device Power Management
-----------------------

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Should be done   
                           with a udev rule.        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

    echo auto | tee /sys/bus/i2c/devices/*/power/control > /dev/null
    echo auto | tee /sys/bus/spi/devices/*/power/control > /dev/null

View Power Setings
------------------

This function shows various power settings. Note you either must be root
or you must have sudo.

    function aa_power_settings ()
    { 
      sudo bash -c '
        for i in `find /sys/devices -name "bMaxPower"`;
        do
            for ii in `find $i -type f`;
            do
                bd=`dirname $ii`;
                busnum=`cat $bd/busnum`;
                devnum=`cat $bd/devnum`;
                title=`lsusb -s $busnum:$devnum`;
                echo -e "\n\n+++ $title\n  -$bd\n  -$ii";
                for ff in `find $bd/power -type f ! -empty 2>/dev/null`;
                do
                    v=`cat $ff 2>/dev/null|tr -d "\n"`;
                    [[ ${#v} -gt 0 ]] && echo -e " `basename $ff`=$v";
                    v=;
                done | sort -g;
            done;
        done;
        echo -e "\n\n\n+++ Kernel Modules\n";
        for m in `command lspci -k|sed -n "/in use:/s,^.*: ,,p"|sort -u`;
        do
            echo "+ $m";
            systool -v -m $m 2> /dev/null | sed -n "/Parameters:/,/^$/p";
        done
      ';
    }

See also
--------

-   CPU Frequency Scaling

Retrieved from
"https://wiki.archlinux.org/index.php?title=Power_saving&oldid=253937"

Category:

-   Power management
