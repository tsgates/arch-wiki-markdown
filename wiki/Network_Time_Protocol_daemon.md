Network Time Protocol daemon
============================

This article describes how to set up and run NTPd (Network Time Protocol
daemon), the most common method to synchronize the software clock of a
GNU/Linux system with internet time servers using the Network Time
Protocol; if set up correctly, NTPd can make your computer act as a time
server itself.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Configuring connection to NTP servers                        |
|     -   2.2 Configuring your own NTP server                              |
|     -   2.3 Other resources about NTP configuration                      |
|                                                                          |
| -   3 Using without daemon                                               |
|     -   3.1 Synchronize once per boot                                    |
|                                                                          |
| -   4 Running as a daemon                                                |
|     -   4.1 Check whether the daemon is synchronizing correctly          |
|     -   4.2 NetworkManager                                               |
|     -   4.3 Running in a chroot                                          |
|                                                                          |
| -   5 Alternatives                                                       |
| -   6 See also                                                           |
| -   7 External links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

Install ntp, available in the Official Repositories.

Configuration
-------------

Tip:The ntp package is installed with a default /etc/ntp.conf that
should make NTPd work without requiring custom configuration.

> Configuring connection to NTP servers

The first thing you define in your /etc/ntp.conf is the servers your
machine will synchronize to.

NTP servers are classified in a hierarchical system with many levels
called strata: the devices which are considered independent time sources
are classified as stratum 0 sources; the servers directly connected to
stratum 0 devices are classified as stratum 1 sources; servers connected
to stratum 1 sources are then classified as stratum 2 sources and so on.

It has to be understood that a server's stratum cannot be taken as an
indication of its accuracy or reliability. Typically, stratum 2 servers
are used for general synchronization purposes: if you do not already
know the servers you are going to connect to, you should use the
pool.ntp.org servers (alternate link) and choose the server pool that is
closest to your location.

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
command) so that it will never be used unless internet access is lost:

    server 127.127.1.0
    fudge  127.127.1.0 stratum 10

Next, define the rules that will allow clients to connect to your
service (localhost is considered a client too) using the restrict
command; you should already have a line like this in your file:

    restrict default nomodify nopeer noquery

This restricts everyone from modifying anything and prevents everyone
from querying the status of your time server: nomodify prevents
reconfiguring your ntpd (with ntpq or ntpdc), and noquery prevents
dumping status data from your ntpd (also with ntpq or ntpdc).

You can also add other options:

    restrict default kod nomodify notrap nopeer noquery

Note:This still allows other people to query your time server. You need
to add noserve to stop serving time. It will also block time
synchronization since it blocks all packets except ntpq and ntpdc
queries.

Full docs for the "restrict" option are in man ntp_acc. See
https://support.ntp.org/bin/view/Support/AccessRestrictions for detailed
instructions.

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

A very basic configuration file will look like this (all comments have
been stripped out for clarity):

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

> Other resources about NTP configuration

In conclusion, never forget man pages: man ntp.conf is likely to answer
any doubts you could still have (see also the related man pages:
man {ntpd|ntp_auth|ntp_mon|ntp_acc|ntp_clock|ntp_misc}).

Using without daemon
--------------------

To synchronize your system clock just once, without starting the NTP
daemon, run:

    # ntpd -qg

Note:This has the same effect as the now deprecated ntpdate.

The -g option allows shifting the clock further than the panic threshold
(15 min by default) without a warning. Note that such offset is abnormal
and might indicate either wrong timezone setting, clock chip failure, or
simply a very long period of neglect. If in these cases you would rather
not set the clock and print an error to syslog, remove -g.

After updating the system clock, store the time to the hardware clock so
that it is preserved when rebooting:

    # hwclock -w

> Synchronize once per boot

Warning:Using this method is discouraged on servers and in general on
machines that need to run continuously for more than 2 or 3 days, as the
system clock will be updated only once at boot time.

Write a oneshot systemd unit:

    /etc/systemd/system/ntp-once.service

    [Unit]
    Description=Network Time Service (once)
    After=network.target nss-lookup.target 

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/ntpd -g -u ntp:ntp ; /sbin/hwclock -w

    [Install]
    WantedBy=multi-user.target

and enable it:

    # systemctl enable ntp-once

Note that a systemd unit of the type oneshot executes once only. Hence
the ntpd -q option should not be used in this case.

Running as a daemon
-------------------

To start ntpd:

    # systemctl start ntpd

To enable ntpd at startup:

    # systemctl enable ntpd

Or alternatively with the command:

    # timedatectl set-ntp 1

> Check whether the daemon is synchronizing correctly

Before you can use the ntpq command you'll need to use pacman and
install the libedit package. Then use ntpq to see the list of configured
peers:

    $ ntpq -np

The delay, offset and jitter columns should be non-zero. The servers
ntpd is synchronizing with are prefixed by an asterisk. It can take
several minutes before ntpd selects a server to synchronize with; try
checking after 17 minutes (1024 seconds).

> NetworkManager

Note:ntpd should still be running when the network is down if the
hwclock daemon is disabled, so you should not use this.

ntpd can be brought up/down along with a network connection through the
use of NetworkManager's dispatcher scripts. You will need to install
networkmanager-dispatcher-ntpd from the official repositories.

> Running in a chroot

Note:ntpd should be run as non-root before attempting to jail it in a
chroot (default in the vanilla Arch Linux package), since chroots are
relatively useless at securing processes running as root.

Edit /etc/conf.d/ntpd.conf and change

    NTPD_ARGS="-g -u ntp:ntp"

to

    NTPD_ARGS="-g -i /var/lib/ntp -u ntp:ntp"

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

Finally, restart the daemon again:

    # systemctl restart ntpd

It is relatively difficult to be sure that your driftfile configuration
is actually working without waiting a while, as ntpd does not read or
write it very often. If you get it wrong, it will log an error; if you
get it right, it will update the timestamp. If you do not see any errors
about it after a full day of running, and the timestamp is updated, you
should be confident of success.

Alternatives
------------

An alternative to NTPd is Chrony, a dial-up friendly and specifically
designed for systems that are not online all the time.

See also
--------

-   Time (for more information on computer timekeeping)

External links
--------------

-   http://www.ntp.org/
-   http://support.ntp.org/
-   http://www.pool.ntp.org/
-   http://www.eecis.udel.edu/~mills/ntp/html/index.html
-   http://www.akadia.com/services/ntp_synchronize.html

Retrieved from
"https://wiki.archlinux.org/index.php?title=Network_Time_Protocol_daemon&oldid=252740"

Category:

-   Networking
