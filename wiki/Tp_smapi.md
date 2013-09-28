Tp smapi
========

tp_smapi is a set of kernel modules that retrieves information from and
conveys commands to the hardware of ThinkPad laptops. This information
is presented through the /sys/devices/platform/smapi filesystem. Much
like the /proc filesystem, you can read and write information to these
files to get information about and send commands to the hardware.
tp_smapi is highly recommended if you're using a ThinkPad laptop.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Supported Laptops                                                  |
| -   2 Installation                                                       |
| -   3 Features                                                           |
|     -   3.1 Control Battery Charging                                     |
|         -   3.1.1 General Way                                            |
|         -   3.1.2 Check whether settings were accepted                   |
|                                                                          |
|     -   3.2 Protect the Hard Disk from Drops                             |
|                                                                          |
| -   4 Workaround for Partially Supported Laptops                         |
|     -   4.1 1st Option                                                   |
|     -   4.2 2nd Option                                                   |
|                                                                          |
| -   5 See Also                                                           |
+--------------------------------------------------------------------------+

Supported Laptops
-----------------

First check whether your laptop is supported. Thinkwiki has a
comprehensive list of all supported Thinkpads. In case your TP does not
support stop_threshold but only start_threshold please go here
Tp_smapi#Workaround for Partially Supported Laptops for a decent
workaround.

If you are installing on a recent Thinkpad that has an Ivy Bridge
processor (X230, T430, T530, etc.), tp_smapi will not work. Use
tpacpi-bat.

Installation
------------

Install the tp_smapi package that recently moved to the community
repository.

It's providing you 3 new Kernel modules.

Kernel Module

Name

Description

tp_smapi

ThinkPad SMAPI Support

hdaps

IBM Hard Drive Active Protection System (HDAPS) driver

thinkpad_ec

ThinkPad embedded controller hardware access (tp_smapi and hdaps both
depend on it)

After a reboot tp_smapi and it's dependencys will get autoloaded and the
sysfs-interface under /sys/devices/platform/smapi should be fully
functional.

Features
--------

Here are a couple of useful things you can do using tp_smapi. Please
feel free to add your own.

> Control Battery Charging

It's bad for most laptop batteries to hold a full charge for long
periods of time. You should try to keep your battery in the 40-80%
charged range, unless you need the battery life for extended periods of
time.

General Way

tp_smapi lets you control the start and stop charging threshold to do
just that. Run these commands to set these to good values:

    echo 40 > /sys/devices/platform/smapi/BAT0/start_charge_thresh
    echo 80 > /sys/devices/platform/smapi/BAT0/stop_charge_thresh

This will cause the battery to begin charging when it falls below 40%
charge and stop charging once it exceeds 80% charge. This will extend
the lifetime of your battery.

Note that when you remove and re-insert the battery, these thresholds
may be reset to their default values. To work around this, create a
script to set these values, and make this script run both at startup and
when a battery is inserted. More specific instructions follow.

Create a script /usr/sbin/set_battery_thresholds:

    #!/bin/sh
    # set the battery charging thresholds to extend battery lifespan
    echo ${2:-40} > /sys/devices/platform/smapi/BAT${1:-0}/start_charge_thresh
    echo ${3:-80} > /sys/devices/platform/smapi/BAT${1:-0}/stop_charge_thresh

With this script to set a battery threshold is very simple, just type
(if set_bat_thresh is the name of the script):

    set_battery_thresholds 0 96 100

Or run it with no arguments to default to BAT0, and thresholds of 40%
and 80%.

NB: if you let the battery discharge below 40%, you will get problems,
since it is not charged anymore. A solution consists in setting only the
parameter stop_charge_thresh and control manually the lower battery
value.

Set it runnable:

    [root ~]# chmod 744 /usr/sbin/set_battery_thresholds

Let systemd execute the script at startup (Using rc.local from
initscripts is deprecated). Thus, create
/etc/systemd/system/tp_smapi_set_battery_thresholds.service:

    [Unit]
    Description=Set Battery Charge Thresholds by tp_smapi

    [Service]
    Type=oneshot
    ExecStart=/usr/sbin/set_battery_thresholds
    RemainAfterExit=yes

    [Install]
    WantedBy=multi-user.target

Enable it in systemd:

    [root ~]# systemctl enable tp_smapi_set_battery_thresholds.service

You can also make it run when a battery is inserted. This requires that
acpid is installed and running. Edit /etc/acpi/handler.sh:

    #... other ACPI stuff
    battery)
      case "$2" in
        BAT0)
          case "$4" in
            00000000)
            ;;
            00000001)
            /usr/sbin/set_battery_thresholds
            ;;
    #... more ACPI stuff

Check whether settings were accepted

To check whether your settings were accepted check the output of the
following:

    cat /sys/devices/platform/smapi/BAT0/start_charge_thresh
    cat /sys/devices/platform/smapi/BAT0/stop_charge_thresh

> Protect the Hard Disk from Drops

tp_smapi includes a driver to read the accelerometer in your laptop to
detect drops and other events that could cause damage to your hard
drive. See the HDAPS page for more information on this useful feature.

Workaround for Partially Supported Laptops
------------------------------------------

For partially supported laptops you can still gain control over your
battery. First check what is actually supported:

    cat /sys/devices/platform/smapi/BAT0/start_charge_thresh
    cat /sys/devices/platform/smapi/BAT0/stop_charge_thresh

If start-charge_thresh is supported but not stop_charge_thresh but you
still want to have your computer stop charging your battery you have two
options.

Note : none of the two options works on T42p.

> 1st Option

-   create the script /usr/sbin/set_battery_thresholds as above
-   copy the original /etc/acpi/handler.sh to /etc/acpi/handler.sh.start
-   edit /etc/acpi/handler.sh as above and copy it to
    /etc/acpi/handler.sh.stop

Now copy the following script, make it executable, adjust the values to
your liking and run it every couple of minutes as a root cron.

    #!/bin/bash

    CURRENTCHARGE=$(acpitool -b | cut -d, -f2 | cut -d. -f1 | cut -b2-)

    if [ $CURRENTCHARGE -gt 80 ]; then
        cp /etc/acpi/handler.sh.stop /etc/acpi/handler.sh
        echo 99 > /sys/devices/platform/smapi/BAT0/start_charge_thresh
        exit 0
    fi
    if [ $CURRENTCHARGE -lt 60 ]; then
        cp /etc/acpi/handler.sh.start /etc/acpi/handler.sh    
        echo 99 > /sys/devices/platform/smapi/BAT0/start_charge_thresh
        echo 0 > /sys/devices/platform/smapi/BAT0/start_charge_thresh
        exit 0 
    fi

    exit 0

> 2nd Option

To control the battery charging thresholds, install the Perl script
tpacpi-bat from the AUR.

Insert the acpi_call kernel module by running

    modprobe acpi_call

or by adding it to the MODULES array in /etc/rc.config.

Manually set the thresholds by calling

    perl /usr/lib/perl5/vendor_perl/tpacpi-bat -v startChargeThreshold 0 40
    perl /usr/lib/perl5/vendor_perl/tpacpi-bat -v stopChargeThreshold 0 80

The example values 40 and 80 given here are in percent of the full
battery capacity. Adjust them to your own needs. You may also want to
add these lines to /etc/rc.local to set the at startup. While these
values should be permanent, they will be reset any time the battery is
removed.

See Also
--------

tp_smapi on ThinkWiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tp_smapi&oldid=250895"

Categories:

-   Laptops
-   Kernel
