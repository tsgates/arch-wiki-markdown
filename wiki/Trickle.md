Trickle
=======

trickle is a portable lightweight userspace bandwidth shaper, that
either runs in collaborative mode (together with trickled) or in stand
alone mode.

It works by preloading its own socket library wrappers, that limit
traffic by delaying data.

Also trickle runs entirely in userspace.[1]

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
|     -   2.1 Modifying other systemd services                             |
|                                                                          |
| -   3 Daemon configuration                                               |
|     -   3.1 Systemd integration                                          |
+--------------------------------------------------------------------------+

Installation
------------

Warning:Programs that generate heavy traffic, but get controlled via a
web interfaces (with very light traffic), will also have the web
interface traffic shaped. This means that they will barely be
accessible!

Warning:Trickle can only limit traffic of programs that do not fork, so
shaping a FTP server's traffic won't really work that way!

Install trickle from Official Repositories.

Usage
-----

If you are running the daemon (see below), just start any program with
"trickle" in front of it:

    trickle pacman -Syu

Otherwise also specify upload and download limit as well as other
configuration options (see trickle(1) for more information):

    trickle -d200 -u50 pacman -Syu

> Modifying other systemd services

Copy the desired .service file from /usr/lib/systemd/system/ to
/etc/systemd/system and add

    /usr/bin/trickle

in front of the ExecStart= value, eg:

    ExecStart=/usr/bin/yourdaemon

changes to

    ExecStart=/usr/bin/trickle /usr/bin/yourdaemon

In case you would like to use the standalone mode, also add the config
options like described in the Usage section above.

  
 Run this command after changing .service files:

    systemctl --system daemon-reload

And now restart your daemon, it should have shaped bandwith now.

Daemon configuration
--------------------

If you want to have application specific settings with trickled, create
the optional /etc/trickled.conf file as described in the
trickled.conf(5) man page. For example:

    [ssh]
    Priority = 1
    Time-Smoothing = 0.1
    Length-Smoothing = 2
    [ftp]
    Priority = 8
    Time-Smoothing = 5
    Length-Smoothing = 20

> Systemd integration

Create the following two files and customize them to your needs.

    /etc/systemd/system/trickled.service

    [Unit]
    Description=trickle bandwith shaper

    [Service]
    EnvironmentFile=/etc/conf.d/trickled_systemd
    ExecStart=/usr/bin/trickled -u${TRICKLE_UP} -d${TRICKLE_DOWN} -w${TRICKLE_WSIZE} -t${TRICKLE_STIME} -l${TRICKLE_SLENGTH} -f
    Type=simple
    User=nobody
    Group=nobody

    [Install]
    WantedBy=network.target

    /etc/conf.d/trickled_systemd

    # Upload bandwidth limit in KBit/s
    TRICKLE_UP=

    # Download bandwidth limit in KBit/s
    TRICKLE_DOWN=

    # Set peak detection window size to size KB. This determines
    # how aggressive trickled is at eliminating bandwidth consump-
    # tion peaks.  Lower values will be more aggressive, but may
    # also result in over shaping.
    TRICKLE_WSIZE=512

    # Set smoothing time to seconds s.  The smoothing time deter-
    # mines with what intervals trickled will try to let the ap-
    # plication transcieve data.  Smaller values will result in a
    # more continuous (smooth) session, while larger values may
    # produce bursts in the sending and receiving data.  Smaller
    # values (0.1 - 1 s) are ideal for interactive applications
    # while slightly larger values (1 - 10 s) are better for ap-
    # plications that need bulk transfer.  This parameter is cus-
    # tomizable on a per-application basis via trickled.conf(5).
    TRICKLE_STIME=5

    # Set smoothing length to length KB.  The smoothing length is
    # a fallback of the smoothing time.  If trickled cannot meet
    # the requested smoothing time, it will instead fall back on
    # sending length KB of data.  The default value is 10 KB.
    TRICKLE_SLENGTH=10

Retrieved from
"https://wiki.archlinux.org/index.php?title=Trickle&oldid=233490"

Category:

-   Internet Applications
