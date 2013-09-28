Hddtemp
=======

hddtemp is a small utility (daemonizable) that gives you the temperature
of your hard drive by reading S.M.A.R.T. information (for drives that
support this feature).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
| -   3 Daemon                                                             |
|     -   3.1 Setup with systemd                                           |
|     -   3.2 Setup with legacy initscripts                                |
|     -   3.3 Usage                                                        |
|                                                                          |
| -   4 Monitors                                                           |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

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

> Setup with systemd

Once hddtemp has been installed, standard systemctl procedures work to
start the daemon:

    # systemctl start hddtemp

To start it on boot, enable it:

    #systemctl enable hddtemp

> Setup with legacy initscripts

Start the daemon:

    # rc.d start hddtemp

Add the daemon to the DAEMONS array in /etc/rc.conf to facilitate
auto-start on boot:

    # DAEMONS=(... hddtemp ...)

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
"https://wiki.archlinux.org/index.php?title=Hddtemp&oldid=243233"

Category:

-   Status monitoring and notification
