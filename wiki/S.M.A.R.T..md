S.M.A.R.T.
==========

S.M.A.R.T. (Self-Monitoring, Analysis, and Reporting Technology) is a
supplementary component build into many modern storage devices through
which devices monitor, store, and analyze the health of their operation.
Statistics are collected (temperature, number of reallocated sectors,
seek errors...) which software can use to measure the health of a
device, predict possible device failure, and provide notifications on
unsafe values.

Contents
--------

-   1 Smartmontools
    -   1.1 Detect if device has SMART support
    -   1.2 Test the device health
        -   1.2.1 Results
    -   1.3 Monitor devices
        -   1.3.1 Define the devices to monitor
        -   1.3.2 Email potential problems
        -   1.3.3 Power management
        -   1.3.4 Schedule self-tests
        -   1.3.5 Alert on temperature changes
        -   1.3.6 Complete smartd.conf example
        -   1.3.7 Start/reload the smartd service and check status
    -   1.4 GUI Applications
-   2 Resources

Smartmontools
-------------

The smartmontools package contains two utility programs (smartctl and
smartd) to analyze and monitor storage devices. Install smartmontools
from the official repositories.

> Detect if device has SMART support

To check if the device has SMART capability (it may be necessary to add
-d ata to specify it is an ATA derived device):

    # smartctl -i /dev/<device>

(where <device> is sda, hda,...). This will give general information
about the device, the last two lines will show if it is supported:

    SMART support is: Available - device has SMART capability.
    SMART support is: Enabled

If SMART is not enabled, it can be enabled by doing:

    # smartctl -s on /dev/<device>

> Test the device health

Three type of health tests that can be performed on the device (all are
safe to user data):

1.  Short (runs tests that have a high probability of detecting device
    problems)
2.  Extended (or Long; a short check with complete disk surface
    examination)
3.  Conveyance (identifies if damage incurred during transportation of
    the device)

To view the device's available tests and the time it will take to
perform each test do:

    # smartctl -c /dev/<device>

To run the tests do:

    # smartctl -t short /dev/<device>
    # smartctl -t long /dev/<device>
    # smartctl -t conveyance /dev/<device>

Note:Some disks (e.g. SSDs) may not support all types of test. You can
see what your device supports with smartctl --capabilities /dev/<device>

Results

To view the test's overall health status (compiled from all tests):

    # smartctl -H /dev/<device>

To view the test's result errors:

    # smartctl -l selftest /dev/<device>

To view the test's detailed results:

    # smartctl -a /dev/<device>

If no errors are reported the device is likely healthy. If there are a
few errors this may or may not indicate a problem and should be
investigated further. When a device starts to fail it is recommended to
backup the data and replace it.

> Monitor devices

Devices can be monitored in the background with use of the smartmontools
daemon that will check devices periodically and optionally email any
potential problems. To have devices monitored on boot, enable smartd
service:

     systemctl enable smartd.service

The smart daemon can be edited for more exact configuration in
/etc/smartd.conf.

Tip:/etc/smartd.conf is configured with somewhat esoteric command-line
style options. See the comments and examples in the file, and refer to
the manpage for a full explanation. What follows are some examples of
the monitoring options.

Define the devices to monitor

To monitor all attributes of all disks specify:

     DEVICESCAN

Alternatively, enable monitoring of all attributes on individual disks:

    #DEVICESCAN
    /dev/<first_device> -a
    /dev/<second_device> -a

Tip:If you want to specify different monitoring options for different
disks, you'll need to define them separately rather than use DEVICESCAN.

Email potential problems

To have an email sent when a failure or new error occurs, use the -m
option:

    DEVICESCAN -m address@domain.com

To be able to send the email externally (i.e. not to the root mail
account) a MTA (Mail Transport Agent) or a MUA (Mail User Agent) will
need to be installed and configured. Common MTAs are MSMTP and SSMTP.
Common MTUs are sendmail and Postfix. It's enough to simply configure
S-nail if you don't want anything else.

Once the mail agent is setup the -M test option can be used to test if
an email will be sent (restart the daemon immediately to discover):

    DEVICESCAN -m address@domain.com -M test

Power management

If you use a computer under control of power management, you should
instruct smartd how to handle disks in low power mode. Usually, in
response to SMART commands issued by smartd, the disk platters are spun
up. So if this option is not used, then a disk which is in a low-power
mode may be spun up and put into a higher-power mode when it is
periodically polled by smartd.

    DEVICESCAN -n standby,15,q

More info on smartmontools wiki.

Schedule self-tests

smartd can tell disks to perform self-tests on a schedule. The following
/etc/smartd.conf configuration will start a short self-test every day
between 2-3am, and an extended self test weekly on Saturdays between
3-4am:

     DEVICESCAN -s (S/../.././02|L/../../6/03)

Alert on temperature changes

smartd can track disk temperatures and alert if they rise too quickly or
hit a high limit. The following will log changes of 4 degrees or more,
log when temp reaches 35 degrees, and log/email a warning when temp
reaches 40:

     DEVICESCAN -W 4,35,40

Tip:You can determine the current disk temperature with the command
smartctl -A /dev/<device> | grep Temperature_Celsius

Tip:If you have some disks that run a lot hotter/cooler than others,
remove DEVICESCAN and define a separate configuration for each device
with appropriate temperature settings.

Complete smartd.conf example

Putting together all of the above gives the following example
configuration:

-   DEVICESCAN (smartd scans for disks and monitors all it finds)
-   -a (monitor all attributes)
-   -o on (enable automatic online data collection)
-   -S on (enable automatic attribute autosave)
-   -n standby,q (don't check if disk is in standby, and supress log
    message to that effect so as not to cause a write to disk)
-   -s ... (schedule short and long self-tests)
-   -W ... (monitor temperature)
-   -m ... (mail alerts)

     DEVICESCAN -a -o on -S on -n standby,q -s (S/../.././02|L/../../6/03) -W 4,35,40 -m <username or email>

Start/reload the smartd service and check status

     # systemctl start smartd

or

     # systemctl reload smartd

Check status:

     # systemctl status smartd

Full smartd log:

     # journalctl -u smartd

> GUI Applications

-   Gsmartcontrol — A GNOME frontend for the smartctl hard disk drive
    health inspection tool

http://gsmartcontrol.berlios.de/home/index.php/en/Home || gsmartcontrol

Resources
---------

-   Smartmontools Homepage
-   Smartmontools on Ubuntu Wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=S.M.A.R.T.&oldid=305727"

Category:

-   Storage

-   This page was last modified on 20 March 2014, at 01:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
