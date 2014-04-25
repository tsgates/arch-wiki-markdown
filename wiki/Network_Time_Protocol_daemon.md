Network Time Protocol daemon
============================

Network Time Protocol is the most common method to synchronize the
software clock of a GNU/Linux system with internet time servers. It is
designed to mitigate the effects of variable network latency and can
usually maintain time to within tens of milliseconds over the public
Internet. The accuracy on local area networks is even better, up to one
millisecond.

The NTP Project provides a reference implementation of the protocol
called simply NTP. An alternative to NTP is Chrony, a dial-up friendly
and specifically designed for systems that are not online all the time,
and OpenNTPD, part of the OpenBSD project and currently not maintained
for Linux.

This article further describes how to set up and run the NTP daemon,
both as a client and as a server.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Configuring connection to NTP servers
    -   2.2 Configuring your own NTP server
    -   2.3 Running in a chroot
-   3 Usage
    -   3.1 As a daemon
        -   3.1.1 Check that the daemon is working correctly
    -   3.2 Without daemon
-   4 Autostarting
    -   4.1 systemd services
        -   4.1.1 Start the daemon at boot
        -   4.1.2 Synchronize once per boot
    -   4.2 At network connection
        -   4.2.1 Netctl
        -   4.2.2 NetworkManager
        -   4.2.3 Wicd
-   5 See also

Installation
------------

Install ntp, available in the official repositories.

Configuration
-------------

The main daemon is ntpd, which is configured in /etc/ntp.conf.

The ntp package provides a default configuration file that should make
ntpd work out of the box in client mode, without requiring custom
configuration. If you want to use the defaults for a start, you can skip
to #Usage.

The following describes main configuration items to customize. Also
refer to the manual pages: man ntp.conf and the related
man {ntpd|ntp_auth|ntp_mon|ntp_acc|ntp_clock|ntp_misc}.

> Configuring connection to NTP servers

If you want to configure /etc/ntp.conf manually, first thing you define
is the servers your machine will synchronize to.

NTP servers are classified in a hierarchical system with many levels
called strata: the devices which are considered independent time sources
are classified as stratum 0 sources; the servers directly connected to
stratum 0 devices are classified as stratum 1 sources; servers connected
to stratum 1 sources are then classified as stratum 2 sources and so on.

It has to be understood that a server's stratum cannot be taken as an
indication of its accuracy or reliability. Typically, stratum 2 servers
are used for general synchronization purposes: if you do not already
know the servers you are going to connect to, you should use the
pool.ntp.org servers (alternative link) and choose the server pool that
is closest to your location.

The following lines are just an example:

    /etc/ntp.conf

    server 0.pool.ntp.org iburst
    server 1.pool.ntp.org iburst
    server 2.pool.ntp.org iburst
    server 3.pool.ntp.org iburst

The iburst option is recommended, and sends a burst of packets only if
it cannot obtain a connection with the first attempt. The burst option
always does this, even on the first attempt, and should never be used
without explicit permission and may result in blacklisting.

> Configuring your own NTP server

If setting up an NTP server, you need to add local clock as a server, so
that, in case it loses internet access, it will continue serving time to
the network; add local clock as a stratum 10 server (using the fudge
command) (you can set up to stratum 15) so that it will never be used
unless internet access is lost:

    server 127.127.1.0
    fudge  127.127.1.0 stratum 10

Next, define the rules that will allow clients to connect to your
service (localhost is considered a client too) using the restrict
command; you should already have a line like this in your file:

    restrict default nomodify nopeer noquery

This restricts everyone from modifying anything and prevents everyone
from querying the status of your time server: nomodify prevents
reconfiguring ntpd (with ntpq or ntpdc), and noquery prevents dumping
status data from ntpd (also with ntpq or ntpdc).

You can also add other options:

    restrict default kod nomodify notrap nopeer noquery

Note:This still allows other people to query your time server. You need
to add noserve to stop serving time. It will also block time
synchronization since it blocks all packets except ntpq and ntpdc
queries.

If you want to change any of these, see the full docs for the "restrict"
option in man ntp_acc, the detailed ntp instructions and #As a daemon.

Following this line, you need to tell ntpd what to allow through into
your server; the following line is enough if you are not configuring an
NTP server:

    restrict 127.0.0.1

If you want to force DNS resolution to the IPv6 namespace, write -6
before the IP address or host name (-4 forces IPv4 instead), for
example:

    restrict -6 default kod nomodify notrap nopeer noquery
    restrict -6 ::1    # ::1 is the IPv6 equivalent for 127.0.0.1

Lastly, specify the drift file (which keeps track of your clock's time
deviation) and optionally the log file location:

    driftfile /var/lib/ntp/ntp.drift
    logfile /var/log/ntp.log

A very basic configuration file will look like this:

    /etc/ntp.conf

    server 0.pool.ntp.org iburst
    server 1.pool.ntp.org iburst
    server 2.pool.ntp.org iburst
    server 3.pool.ntp.org iburst

    restrict default kod nomodify notrap nopeer noquery
    restrict -6 default kod nomodify notrap nopeer noquery

    restrict 127.0.0.1
    restrict -6 ::1  

    driftfile /var/lib/ntp/ntp.drift
    logfile /var/log/ntp.log

Note:Defining the log file is not mandatory, but it is always a good
idea to have feedback for ntpd operations.

> Running in a chroot

Note:ntpd should be started as non-root (default in the Arch Linux
package) before attempting to jail it in a chroot, since chroots are
relatively useless at securing processes running as root.

Create a new directory /etc/systemd/system/ntpd.service.d/ if it doesn't
exist and a file named customexec.conf inside with the following
content:

    [Service]
    ExecStart=
    ExecStart=/usr/bin/ntpd -g -i /var/lib/ntp -u ntp:ntp -p /run/ntpd.pid

Then, edit /etc/ntp.conf to change the driftfile path such that it is
relative to the chroot directory, rather than to the real system root.
Change:

    driftfile       /var/lib/ntp/ntp.drift

to

    driftfile       /ntp.drift

Create a suitable chroot environment so that getaddrinfo() will work by
creating pertinent directories and files (as root):

    # mkdir /var/lib/ntp/etc /var/lib/ntp/lib /var/lib/ntp/proc
    # touch /var/lib/ntp/etc/resolv.conf /var/lib/ntp/etc/services

and by bind-mounting the aformentioned files:

    /etc/fstab

    ...
    #ntpd chroot mounts
    /etc/resolv.conf  /var/lib/ntp/etc/resolv.conf none bind 0 0
    /etc/services	  /var/lib/ntp/etc/services none bind 0 0
    /lib		  /var/lib/ntp/lib none bind 0 0
    /proc		  /var/lib/ntp/proc none bind 0 0

    # mount -a

Finally, restart ntpd daemon again. Once it restarted you can verify
that the daemon process is chrooted by checking where /proc/{PID}/root
symlinks to:

    # ps -C ntpd | awk '{print $1}' | sed 1d | while read -r PID; do ls -l /proc/$PID/root; done

should now link to /var/lib/ntp instead of /.

It is relatively difficult to be sure that your driftfile configuration
is actually working without waiting a while, as ntpd does not read or
write it very often. If you get it wrong, it will log an error; if you
get it right, it will update the timestamp. If you do not see any errors
about it after a full day of running, and the timestamp is updated, you
should be confident of success.

Usage
-----

This section will deal with the usage of ntpd and the other commands
provided by the ntp package.

> As a daemon

Warning:As of February 2014, ntpd, when used as a daemon, is vulnerable
to DDoS attacks in some configurations. Arch's default configuration for
ntpd is not vulnerable to CVE-2013-5211 because noquery disables
responses for the monlist command. If a user removes noquery from their
configuration, and does not add disable monlist, then that user is
vulnerable. See the arch-dev mailing list post and the aforementioned
CVE report for more information.

The basic command to start the NTP daemon is:

    # ntpd

However, it will run as root in the background. Hence, it should always
be started specifying the user option:

    # ntpd -u ntp:ntp 

See also #systemd services.

Check that the daemon is working correctly

Use ntpq to see the list of configured peers:

    $ ntpq -p

The delay, offset and jitter columns should be non-zero. The servers
ntpd is synchronizing with are prefixed by an asterisk. It can take
several minutes before ntpd selects a server to synchronize with; try
checking after 17 minutes (1024 seconds).

> Without daemon

System time can be synchronized without using the daemon as well.
However, this would not be suitable for machines that run without
rebooting for more than a few days. To synchronize the system clock just
once without starting ntpd in the background, run:

    # ntpd -q

Using the -q flag causes the ntpd daemon to set the time once and quit,
i.e. not fork to the background. If the operation is unsuccessful, your
system clock will not be synchronized.

Note:This has the same effect as the now deprecated ntpdate.

The system time also will not be synchronized if the ntp-server's time
differs from the system clock by more than a given threshold (so-called
panic-gate), in order to protect running system processes. However, the
option -g can be used to disable the threshold and allow it to be
exceeded, e.g. when the time is set for the first time or if the
hardware clock is faulty.

Autostarting
------------

> systemd services

ntpd can be autostarted by systemd at boot.

Start the daemon at boot

The ntp package provides ntpd.service for systemd. Enable it with
systemctl to start the daemon at boot.

Alternatively use the command:

    # timedatectl set-ntp 1

Synchronize once per boot

Warning:Using this method is discouraged on servers, and in general on
machines that run without rebooting for more than a few days.

Write a oneshot systemd unit:

    /etc/systemd/system/ntp-once.service

    [Unit]
    Description=Network Time Service (once)
    After=network.target nss-lookup.target 

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/ntpd -g -u ntp:ntp ; /usr/bin/hwclock -w

    [Install]
    WantedBy=multi-user.target

and enable it.

Note:A systemd unit of the type oneshot executes once only. Hence the
ntpd -q option should not be used in this case.

> At network connection

ntpd can also be started by your network manager, so that the daemon
only runs when the computer is online.

Netctl

Append the following lines to your netctl profile:

    ExecUpPost='/usr/bin/ntpd || true'
    ExecDownPre='killall ntpd || true'

Note:You are advised to customize the options for the ntpd command as
explained in #Usage.

NetworkManager

The ntpd daemon can be brought up/down along with a network connection
through the use of NetworkManager's dispatcher scripts. The
networkmanager-dispatcher-ntpd from the official repositories installs
one, pre-configured to start and stop the ntpd service with a
connection.

Wicd

For Wicd, create a start script in the postconnect directory and a stop
script in the predisconnect directory. Remember to make them executable:

    /etc/wicd/scripts/postconnect/ntpd

    #!/bin/bash

    /usr/bin/ntpd &
    -or-
    systemctl start ntpd &

    /etc/wicd/scripts/predisconnect/ntpd

    #!/bin/bash

    killall ntpd &
    -or-
    systemctl stop ntpd &

Note:You are advised to customize the options for the ntpd command as
explained in #Usage.

See also Wicd#Scripts.

See also
--------

-   Time (for more information on computer timekeeping)
-   http://www.ntp.org/
-   https://support.ntp.org/
-   http://www.pool.ntp.org/
-   https://www.eecis.udel.edu/~mills/ntp/html/index.html
-   http://www.akadia.com/services/ntp_synchronize.html

Retrieved from
"https://wiki.archlinux.org/index.php?title=Network_Time_Protocol_daemon&oldid=305416"

Category:

-   Networking

-   This page was last modified on 18 March 2014, at 09:12.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
