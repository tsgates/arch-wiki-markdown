Laptop Mode Tools
=================

Summary

Overview of the Laptop Mode Tools power management suite for notebooks.

Related

acpid

cpufrequtils

pm-utils

Laptop

Powertop

Resources

Laptop Mode Tools

Mailing List Archives

Less Watts - Official Site

Laptop Mode Tools is a laptop power saving package for Linux systems. It
is the primary way to enable the Laptop Mode feature of the Linux
kernel, which lets your hard drive spin down. In addition, it allows you
to tweak a number of other power-related settings using a simple
configuration file.

Combined with acpid, CPU frequency scaling, and pm-utils, LMT provides
most users with a complete notebook power management suite.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Hard disks                                                   |
|     -   2.2 CPU frequency                                                |
|     -   2.3 Device and bus                                               |
|         -   2.3.1 Intel SATA                                             |
|         -   2.3.2 USB autosuspend                                        |
|                                                                          |
|     -   2.4 Display and graphics                                         |
|         -   2.4.1 LCD brightness                                         |
|             -   2.4.1.1 ThinkPad T40/T42                                 |
|             -   2.4.1.2 ThinkPad T60                                     |
|                                                                          |
|         -   2.4.2 Terminal blanking                                      |
|                                                                          |
|     -   2.5 Networking                                                   |
|         -   2.5.1 Ethernet                                               |
|         -   2.5.2 Wireless LAN                                           |
|                                                                          |
|     -   2.6 Audio                                                        |
|         -   2.6.1 AC97                                                   |
|         -   2.6.2 Intel HDA                                              |
|                                                                          |
| -   3 Tips and tricks                                                    |
|     -   3.1 Aliases                                                      |
|     -   3.2 lm-profiler                                                  |
|     -   3.3 Disabling                                                    |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 Laptop-mode-tools is not picking up events                   |
|     -   4.2 Laptop-mode-tools does not disable on AC                     |
+--------------------------------------------------------------------------+

Installation
------------

laptop-mode-tools can be installed from the official repositories.

Configuration
-------------

Enable the laptop-mode service:

    # systemctl enable laptop-mode.service

Configuration is handled through:

-   /etc/laptop-mode/laptop-mode.conf - primary configuration file
-   /etc/laptop-mode/conf.d/* - dozens of feature-specific "modules".

Each module can be explicitly enabled/disabled by changing the CONTROL_*
value in the individual settings file found in conf.d/*.

If ENABLE_AUTO_MODULES is set in /etc/laptop-mode/laptop-mode.conf, LMT
will automatically enable any modules where CONTROL_* is set to auto.

If you want to check which modules are enabled, disabled or auto, run:

    $ grep -r '^\(CONTROL\|ENABLE\)_' /etc/laptop-mode/conf.d

Note:auto-hibernate.conf and battery-level-polling.conf are an exception
and use an ENABLE_* variable instead of CONTROL_*.

> Hard disks

For this you need to have hdparm and/or sdparm installed. See Hdparm.

Spinning down the hard drive through hdparm -S values saves power and
makes everything a lot more quiet. By using the readahead function you
can allow the drives to spin down more often even though you are using
the computer. LMT can also establish hdparm -B values. The maximum hard
drive power saving is 1 and the minimum is 254. Set this value to 254
when on AC and 1 when on battery. If you find that normal activity hangs
often while waiting for the disk to spin up, it might be a good idea to
set it to a higher value (eg. 128) which will make it spin down less
often. hdparm -S and hdparm -B values are configured in
/etc/laptop-mode/laptop-mode.conf.

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Please can       
                           someone add info on how  
                           to treat SSD disks with  
                           laptommode-tools? As, to 
                           my knowledge, readahead  
                           is useless for them      
                           (zero read time, just    
                           does wear out), and spin 
                           down most likely as      
                           well. (Discuss)          
  ------------------------ ------------------------ ------------------------

With the CONTROL_MOUNT_OPTIONS variable (default on), laptop-mode-tools
automatically remounts your partitions, appending 'commit=600,noatime'
in the mount options. This keeps the journaling program jbd2 from
accessing your disc every few seconds, instead the disc journal gets
updated every 10 minutes (BEWARE: with this setting you could lose up to
10 minutes of work). Also be sure not to use the atime mount option, use
noatime or relatime instead.

Note:CONTROL_MOUNT_OPTIONS should not be turned on with nilfs2
partitions (see this thread on the forum
https://bbs.archlinux.org/viewtopic.php?id=134656)

> CPU frequency

For this you need to have a CPU frequency driver installed. See CPU
Frequency Scaling.

    # cpufreq.conf
    # ThinkPad T40/T42/T60 Example
    #
    CONTROL_CPU_FREQUENCY=1
    BATT_CPU_MAXFREQ=fastest
    BATT_CPU_MINFREQ=slowest
    BATT_CPU_GOVERNOR=ondemand
    BATT_CPU_IGNORE_NICE_LOAD=1
    LM_AC_CPU_MAXFREQ=fastest
    LM_AC_CPU_MINFREQ=slowest
    LM_AC_CPU_GOVERNOR=ondemand
    LM_AC_CPU_IGNORE_NICE_LOAD=1
    NOLM_AC_CPU_MAXFREQ=fastest
    NOLM_AC_CPU_MINFREQ=slowest
    NOLM_AC_CPU_GOVERNOR=ondemand
    NOLM_AC_CPU_IGNORE_NICE_LOAD=0
    CONTROL_CPU_THROTTLING=0

> Device and bus

Intel SATA

-   Enable the Intel SATA AHCI controller Aggressive Link Power
    Management feature to set the disk link into a very low power mode
    in the absence of disk IO.

    # intel-sata-powermgmt.conf
    # ThinkPad T40/T42/T60 Example
    #
    DEBUG=0
    CONTROL_INTEL_SATA_POWER=1
    BATT_ACTIVATE_SATA_POWER=1
    LM_AC_ACTIVATE_SATA_POWER=1
    NOLM_AC_ACTIVATE_SATA_POWER=0

Note:Review the well-documented
/etc/laptop-mode/conf.d/intel-sata-powermgmt.conf file for additional
configuration details.

USB autosuspend

    # usb-autosuspend.conf
    # ThinkPad T40/T42/T60 Example
    #
    DEBUG=0
    CONTROL_USB_AUTOSUSPEND=1
    BATT_SUSPEND_USB=1
    LM_AC_SUSPEND_USB=1
    NOLM_AC_SUSPEND_USB=0
    AUTOSUSPEND_TIMEOUT=2

Note:Review the well-documented
/etc/laptop-mode/conf.d/usb-autosuspend.conf file for additional
configuration details. If you have an USB tool you always use (like an
USB mouse), blacklisting them would stop them from suspending.

> Display and graphics

LCD brightness

-   Available brightness values for certain laptops can be obtained by
    running following command:

    $ cat /proc/acpi/video/VID/LCD/brightness

ThinkPad T40/T42

For ThinkPad T40/T42 notebooks, minimum and maximum brightness values
can be obtained by running:

    $ cat /sys/class/backlight/acpi_video0/brightness
    $ cat /sys/class/backlight/acpi_video0/max_brightness

    # lcd-brightness.conf
    # ThinkPad T40/T42 Example
    #
    DEBUG=0
    CONTROL_BRIGHTNESS=1
    BATT_BRIGHTNESS_COMMAND="echo 0"
    LM_AC_BRIGHTNESS_COMMAND="echo 7"
    NOLM_AC_BRIGHTNESS_COMMAND="echo 7"
    BRIGHTNESS_OUTPUT="/sys/class/backlight/thinkpad_screen/brightness"

ThinkPad T60

-   For ThinkPad T60 notebooks, minimum and maximum brightness values
    can be obtained by running:

    $ cat /sys/class/backlight/thinkpad_screen/max_brightness
    $ cat /sys/class/backlight/thinkpad_screen/brightness

    # lcd-brightness.conf
    # ThinkPad T60 Example
    #
    DEBUG=0
    CONTROL_BRIGHTNESS=1
    BATT_BRIGHTNESS_COMMAND="echo 0"
    LM_AC_BRIGHTNESS_COMMAND="echo 7"
    NOLM_AC_BRIGHTNESS_COMMAND="echo 7"
    BRIGHTNESS_OUTPUT="/sys/class/backlight/acpi_video0/brightness"

Note:Review the well-documented
/etc/laptop-mode/conf.d/lcd-brightness.conf file for additional
configuration details.

Terminal blanking

    # terminal-blanking.conf
    # ThinkPad T40/T42/T60 Example
    #
    DEBUG=0
    CONTROL_TERMINAL=1
    TERMINALS="/dev/tty1"
    BATT_TERMINAL_BLANK_MINUTES=1
    BATT_TERMINAL_POWERDOWN_MINUTES=2
    LM_AC_TERMINAL_BLANK_MINUTES=10
    LM_AC_TERMINAL_POWERDOWN_MINUTES=10
    NOLM_AC_TERMINAL_BLANK_MINUTES=10
    NOLM_AC_TERMINAL_POWERDOWN_MINUTES=10

Note:Review the well-documented
/etc/laptop-mode/conf.d/terminal-blanking.conf file for additional
configuration details.

> Networking

Ethernet

    # ethernet.conf
    # ThinkPad T40/T42/T60 Example
    #
    DEBUG=0
    CONTROL_ETHERNET=1
    LM_AC_THROTTLE_ETHERNET=0
    NOLM_AC_THROTTLE_ETHERNET=0
    DISABLE_WAKEUP_ON_LAN=1
    DISABLE_ETHERNET_ON_BATTERY=1
    ETHERNET_DEVICES="eth0"

Wireless LAN

Wireless interface power management settings are hardware-dependent, and
thus a bit trickier to configure. Depending on the wireless chipset, the
settings are managed in one of the following three files:

1.  /etc/laptop-mode/conf.d/wireless-power.conf for a generic method of
    saving power (using "iwconfig wlan0 power on/off"). This applies to
    most chipsets (that is, anything but Intel chipsets listed below).
2.  /etc/laptop-mode/conf.d/wireless-ipw-power.conf for Intel chipsets
    driven by the old ipw driver. This apply to IPW3945, IPW2200 and
    IPW2100. It currently (as of LMT 1.55-1) uses iwpriv for IPW3945,
    and a combination of iwconfig and iwpriv settings for IPW2100 and
    IPW220. See /usr/share/laptop-mode-tools/modules/wireless-ipw-power
    for details. (note that the ipw3945 is not used anymore, see below)
3.  /etc/laptop-mode/conf.d/wireless-iwl-power.conf for Intel chipsets
    driven by modules iwl4965, iwl3945 and iwlagn (this latter supports
    chipsets 4965, 5100, 5300, 5350, 5150, 1000, and 6000)

Note that activating the three of them should not be much of a problem,
since LMT detects the module used by the interface and acts accordingly.

The supported modules for each configuration file, indicated above, are
taken directly from LMT. However, this seems to be a bit out-of-date,
since the current 2.6.34 kernel does not provide the ipw3945 and iwl4965
modules anymore (3945 chipset uses iwl3945 instead, and 4965 uses the
generic module iwlagn). This is only brought here for information, as
this does not (or should not) affect the way LMT works.

There is a known issue with some chipsets running with the iwlagn module
(namely, the 5300 chipset, and maybe others). On those chipsets, the
following settings of /etc/laptop-mode/conf.d/wireless-iwl-power.conf:

    IWL_AC_POWER
    IWL_BATT_POWER

are ignored, because the /sys/class/net/wlan*/device/power_level file
does not exist. Instead, the standard method (with "iwconfig wlan0 power
on/off") is automatically used.

> Audio

AC97

    # ac97-powersave.conf
    # ThinkPad T40/T42/T60 Example
    #
    DEBUG=0
    CONTROL_AC97_POWER=1

Intel HDA

    # intel-hda-powersave.conf
    # ThinkPad T40/T42/T60 Example
    #
    DEBUG=0
    CONTROL_INTEL_HDA_POWER=1
    BATT_INTEL_HDA_POWERSAVE=1
    LM_AC_INTEL_HDA_POWERSAVE=1
    NOLM_AC_INTEL_HDA_POWERSAVE=0
    INTEL_HDA_DEVICE_TIMEOUT=10
    INTEL_HDA_DEVICE_CONTROLLER=0

Tips and tricks
---------------

> Aliases

> lm-profiler

> Disabling

Troubleshooting
---------------

> Laptop-mode-tools is not picking up events

You need to install and enable acpid. Enable the acpid systemd service
with:

    # systemctl enable acpid.service

If that does not help, go through the laptop-mode configuration files
and make sure that the service you want to enable is set to 1. Many
services (including cpufreq control) are by default set to "auto", which
may not enable them.

I have experienced issues with bluetooth not working if i boot up with
battery, and i fixed it with disabling runtime-pm.

> Laptop-mode-tools does not disable on AC

It is possible if you have both laptop-mode-tools and pm-utils
installed, they can conflict with each other, causing laptop-mode-tools
to not properly set its state.

This can be fixed by disabling scripts with duplicate functionality in
pm-utils. The main cause of this particular issue is the laptop-mode
script located in /usr/lib/pm-utils/power.d. You can stop any unwanted
hooks from running by creating a dummy file in /etc/pm/power.d with the
same name as the corresponding /usr/lib/pm-utils/power.d hook. For
example if you want to disable the laptop-mode hook:

    # touch /etc/pm/power.d/laptop-mode

Note:Do not set the executable bit on that dummy-hook.

Its recommended to disable any hook that has equivalent functionality in
LMT.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Laptop_Mode_Tools&oldid=255777"

Categories:

-   Laptops
-   Power management
