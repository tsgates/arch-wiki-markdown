Hddtemp
=======

hddtemp is a small utility (daemonizable) that gives you the temperature
of your hard drive by reading S.M.A.R.T. information (for drives that
support this feature).

Contents
--------

-   1 Installation
-   2 Usage
-   3 Daemon
    -   3.1 Usage
-   4 Monitors
-   5 See also

Installation
------------

Sync and install with pacman:

    # pacman -S hddtemp

Usage
-----

Hddtemp can be invoked with the drive as the argument:

    # hddtemp /dev/sd[x]

Where x is the drive.

Daemon
------

Running the daemon gives you the possibility to access the temperature
via an TCP/IP request, so you could use this in order to check the
temperature from outside, or within some scripts.

Once hddtemp has been installed, standard systemctl procedures work to
start the daemon:

    # systemctl start hddtemp

To start it on boot, enable it:

    # systemctl enable hddtemp

Note:Arguments to hddtemp are directly given in
/usr/lib/systemd/system/hddtemp.service. This is especially important if
you have multiple disks, because in the default configuration only
/dev/sda is monitored. Change the ExecStart overriding the
hddtemp.service file:

-   Create the directory on /etc/systemd/system:

    # mkdir /etc/systemd/system/hddtemp.service.d

-   Create a customexec.conf file inside adding the drives you want to
    monitor, e.g.:

    /etc/systemd/system/hddtemp.service.d/customexec.conf

    [Service]
    ExecStart=
    ExecStart=/usr/bin/hddtemp -dF /dev/sda /dev/sdb /dev/sdc

-   Reload systemd's unit files:

    # systemctl --system daemon-reload

-   Restart hddtemp service:

    # systemctl restart hddtemp

> Usage

Another way to get the temperature is by connecting to the daemon which
is listening on port 7634.

    $ telnet localhost 7634

Or with netcat:

    $ nc localhost 7634

Refer to the manpage for information like supported drives, logging,
etc.

    $ man hddtemp

Monitors
--------

Hddtemp can be easily integrated with system monitors like Conky, the
sensors-applet for GNOME Panel or the xfce4-sensors-plugin for Xfce
Panel.

See also
--------

lm sensors

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hddtemp&oldid=301992"

Category:

-   Status monitoring and notification

-   This page was last modified on 25 February 2014, at 08:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
