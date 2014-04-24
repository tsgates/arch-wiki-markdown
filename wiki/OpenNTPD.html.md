OpenNTPD
========

OpenNTPD (part of the OpenBSD project) is a daemon that can be used to
synchronize the system clock to internet time servers using the Network
Time Protocol, and can also act as a time server itself if needed.

Warning:OpenNTPD is not currently maintained for Linux (see this
thread): users interested in its functions should better use NTPd.

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: rc.d references, 
                           bad style/format.        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Installation
    -   1.1 Enable OpenNTPD through systemd
-   2 Making openntpd dependent upon network access
    -   2.1 Using netcfg
    -   2.2 Using NetworkManager dispatcher
    -   2.3 Using wicd
    -   2.4 Using dhclient hooks
    -   2.5 Using dhcpcd hooks
-   3 Troubleshooting
    -   3.1 Error adjusting time
    -   3.2 Increasing time shift
    -   3.3 Initialization Failure
-   4 See also
-   5 External links

Installation
------------

openntpd can be installed from community:

    # pacman -S openntpd

The default configuration is actually usable if all you want is to sync
the time of the local computer. For more detailed settings, the
/etc/ntpd.conf file must be edited:

To sync to a particular server, uncomment and edit the "server"
directive. You can find the server's URL in your area at
www.pool.ntp.org/zone/@.

    server ntp.example.org

The "servers" directive works the same as the "server" directive,
however, if the DNS name resolves to multiple IP address, ALL of them
will be synced to. The default, "pool.ntp.org" is working and should be
acceptable in most cases.

    pool.ntp.org

Any number of "server" or "servers" directives may be used.

If you want the computer you run OpenNTPD on to also be a time server,
simply uncomment and edit the "listen" directive.

For example:

    listen on *

will listen on all interfaces, and

    listen on 127.0.0.1

will only listen on the loopback interface.

Your time server will only begin to serve time after it has synchronized
itself to a high resolution. This may take hours, or days, depending on
the accuracy of your system.

> Enable OpenNTPD through systemd

If you are using systemd init, you must enable the service related to
OpenNTPD as follows:

    # systemctl enable openntpd

Then reboot.

Alternatively start manually without autostart on boot:

    # systemctl start openntpd

Making openntpd dependent upon network access
---------------------------------------------

If you have intermittent network access (you roam around on a laptop,
you use dial-up, etc), it does not make sense to have openntpd running
as a system daemon on start up. Here are a few ways you can control
openntpd based on the presence of a network connection. These
instructions should also work for ntpd found further below.

> Using netcfg

If you are using netcfg, you can also start/stop openntpd as a
POST_UP/PRE_DOWN command in your network profile:

    POST_UP="/etc/rc.d/openntpd start || true"
    PRE_DOWN="/etc/rc.d/openntpd stop || true"

Of course, you will have to specify this manually for each network
profile.

> Using NetworkManager dispatcher

OpenNTPD can be brought up/down along with a network connection through
the use of NetworkManager's dispatcher scripts. You can install the
needed script from [community]:

    # pacman -S networkmanager-dispatcher-openntpd

> Using wicd

These instructions require wicd 1.7.0 or later, which is available in
the standard Arch repository. You will also need write access to
/etc/wicd/scripts.

Note:Remember to make these two scripts executable using chmod

Make one shell script inside
/etc/wicd/scripts/postconnect/openntpd-start.sh with the following:

    #!/bin/sh
    /etc/rc.d/openntpd start

Similarly, make another shell script inside
/etc/wicd/scripts/predisconnect/openntpd-stop.sh with the following:

    #!/bin/sh
    /etc/rc.d/openntpd stop

> Using dhclient hooks

Another possibility is to use dhclient hooks to start and stop openntpd.
When dhclient detects a change in state it will run the following
scripts:

-   /etc/dhclient-enter-hooks
-   /etc/dhclient-exit-hooks

The following example uses /etc/dhclient-exit-hooks to start and stop
openntpd depending on dhcp status:

    [ "$interface" != "eth0" ] && exit 0

    if $if_up; then
        pgrep ntpd &> /dev/null || /etc/rc.d/openntpd start
    elif $if_down; then
        pgrep ntpd &> /dev/null && /etc/rc.d/openntpd stop
    fi

See dhclient-script(8)

> Using dhcpcd hooks

/usr/lib/dhcpcd/dhcpcd-hooks/*

See dhcpcd-run-hooks(8)

Troubleshooting
---------------

> Error adjusting time

If you find your time set incorrectly and in log you see:

    openntpd adjtime failed: Invalid argument

Try:

    ntpd -s -d

This is also how you would manually sync your system.

> Increasing time shift

Starting openntpd in the background could lead to synchronization errors
between the actual time and the time stored on your computer. If you
recognize an increasing time difference between your desktop clock and
the actual time, try to start the openntpd daemon normal and not in the
background.

> Initialization Failure

Openntpd may fail to initialize properly if it is started before the
network is fully configured. In some cases you may want to remove
openntpd from the DAEMONS array in /etc/rc.conf and add the following
line to /etc/rc.local:

    (sleep 300 && /etc/rc.d/openntpd start) &

Note:This method is an alternative to the four methods listed above. The
other three methods are preferred and work better. Use this as a last
resort.

This will wait 5 minutes before starting openntpd, which should give the
system sufficient time to set up the network properly. If your network
settings change often, you may also consider restarting the daemon
regularly with cron.

See also
--------

-   Network Time Protocol daemon

External links
--------------

-   http://www.openntpd.org

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenNTPD&oldid=302141"

Category:

-   Networking

-   This page was last modified on 26 February 2014, at 01:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
