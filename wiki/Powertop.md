Powertop
========

Related articles

-   Power saving
-   Laptop Mode Tools

PowerTOP is a tool provided by Intel to enable various powersaving modes
in userspace, kernel and hardware. It is possible to monitor processes
and show which of them are utilizing the CPU and wake it from its
Idle-States.

Contents
--------

-   1 Installation
-   2 Tips and tricks
-   3 Troubleshooting
    -   3.1 Error: Cannot load from file
    -   3.2 Calibration to prevent inaccurate measurement
-   4 See also

Installation
------------

Install package powertop, available in official repositories.

Powertop was updated to 2.0 which comes with more features (Article from
the H Open). For more information, see the Release Announcement.

Tips and tricks
---------------

PowerTOP suggests a few methods to reduce the power consumption further.
However, in the console, PowerTOP does not display the parameters. To
find out which ones are suggested, proceed as follows:

-   If you have changed parameters (e.g. in PowerTOP), reboot so that
    the system has default state of the parameters.
-   Use PowerTOP to produce a report on parameters:
    # powertop --html=powerreport.html
-   The last tab of the report now shows the actual parameters suggested
    by the tool to apply to save power.
-   Powertop 2.5 includes an --auto-tune feature which sets all tunable
    options to their GOOD setting. This can be combined with systemd to
    have the tunables set on boot.

    /etc/systemd/system/powertop.service

    [Unit]
    Description=Powertop tunings
    [Service]
    Type=oneshot
    RemainAfterExit=no
    ExecStart=/usr/bin/powertop --auto-tune
    #"powertop --auto-tune" still needs a terminal for some reason.
    #Possibly a bug?
    Environment="TERM=xterm"

    [Install]
    WantedBy=multi-user.target

You can apply these settings at boot by using module parameters, udev
rules and sysctl. For details, see the power saving page.

Troubleshooting
---------------

> Error: Cannot load from file

If you get an error like the following when starting powertop, you are
likely to have powertop not allowed collecting enough measurement data
yet. All you need to do is to keep powertop running for a certain time
whilst being on battery.

    Loaded 39 prior measurements
    Cannot load from file /var/cache/powertop/saved_parameters.powertop
    Cannot load from file /var/cache/powertop/saved_parameters.powertop

> Calibration to prevent inaccurate measurement

If you experience inaccurate measurement, then it is likely that you
need to calibrate powertop first. This can be done by running powertop
with the --calibrate parameter.

    # powertop --calibrate

See also
--------

-   Official site
-   Wikipedia article

Retrieved from
"https://wiki.archlinux.org/index.php?title=Powertop&oldid=301787"

Category:

-   Power management

-   This page was last modified on 24 February 2014, at 15:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
