DeveloperWiki:Systemd
=====================

This page is for planning.

Contents
--------

-   1 TODO list
-   2 Packaging notes
    -   2.1 Units
        -   2.1.1 Example of a simple conversion
    -   2.2 tmpfiles.d
    -   2.3 modules-load.d
    -   2.4 ntp-units.d
    -   2.5 sysctl.d

TODO list
---------

-   Update our servers
-   Finish 'Missing systemd units': https://www.archlinux.org/todo/161/
    and https://www.archlinux.org/todo/178/
-   Update arch-install-scripts and installation medias
-   Update devtools
    -   On brynhild, devtools are broken at the moment, due to systemd
        188's shared mounts
        -   To fix this, mkarchroot would need to unshare mounts, then
            (in the new namespace) make all mounts slaves
        -   systemd 189 may make nspawn suitable for use in mkarchroot

-   Reorganize systemd and sysvinit packages:
    -   Merge systemd back to a single package (aside from sysvcompat)
    -   Remove sysvinit and initscripts from 'base', add systemd (and
        sysvcompat?)
    -   Only sysvcompat and sysvinit should conflict, allowing
        initscripts and sysvcompat to be installed at the same time
        (this is done, but the conflict still exists in the package)
        -   Merge locale.sh from initscripts/sysvcompat to systemd? Look
            for an alternative solution to setting locale at login?
        -   Split off some of the tools from sysvinit (pidof, last, ...)
            into sysvinit-tools, which initscripts should depend on
        -   sysvcompat should then provide sysvinit, to resolve the
            dependency issue

-   Make sure timedated's managing of NTP works
    -   Add files to ntpd, chrony, openntpd for
        /usr/lib/systemd/ntp-units.d

Packaging notes
---------------

> Units

-   Use the upstream unit files whenever they exist
-   Try not to do anything Arch-specific. This will maximize chances of
    not having to change behavior in the future once the unit files are
    provided by upstream. In particular avoid EnvironmentFile=,
    especially if it points to the Arch-specific /etc/conf.d
-   Always separate initialization behavior from the actual daemon
    behavior. If necessary, use a separate unit for the initialization,
    blocked on a ConditionFoo from systemd.unit(5). An example of this
    is sshd.service and sshdgenkeys.service.

Not using an EnvironmentFile= is OK if:

-   Either the daemon has its own configuration file where the same
    settings can be specified
-   The default service file "just works" in the most common case. Users
    who want to change the behavior should then override the default
    service file. If it is not possible to provide a sane default
    service file, it should be discussed on a case-by-case basis

A few comments about service files, assuming current behavior should be
roughly preserved, and fancy behavior avoided:

-   If your service requires the network to be configured before it
    starts, use After=network.target. Do not use Wants=network.target or
    Requires=network.target
-   Use Type=forking, unless you know it's not necessary
    -   Many daemons use the exit of the first process to signal that
        they are ready, so to minimize problems, it is safest to use
        this mode
    -   To make sure that systemd is able to figure out which process is
        the main process, tell the daemon to write a pidfile and point
        systemd to it using PIDFile=
    -   If the daemon in question is dbus-activated, socket-activated,
        or specifically supports Type=notify, that's a different matter,
        but currently only the case for a minority of daemons
-   Arch's rc scripts do not support dependencies, but with systemd they
    should be added add where necessary
    -   The most typical case is that A requires the service B to be
        running before A is started. In that case add Requires=B and
        After=B to A.
    -   If the dependency is optional then add Wants=B and After=B
        instead
    -   Dependencies are typically placed on services and not on targets

If you want to get fancy, you should know what you are doing.

Example of a simple conversion

+--------------------------------------+--------------------------------------+
|     rc script                        |     systemd service file             |
|                                      |                                      |
|     #!/bin/bash                      |     [Unit]                           |
|                                      |     Description=NIS/YP (Network Info |
|     . /etc/rc.conf                   | rmation Service) Server              |
|     . /etc/rc.d/functions            |     Requires=rpcbind.service         |
|                                      |     After=network.target rpcbind.ser |
|     case "$1" in                     | vice                                 |
|       start)                         |                                      |
|         stat_busy "Starting NIS Serv |     [Service]                        |
| er"                                  |     Type=forking                     |
|         /usr/sbin/ypserv             |     PIDFile=/run/ypserv.pid          |
|         if [ $? -gt 0 ]; then        |     ExecStart=/usr/sbin/ypserv       |
|           stat_fail                  |                                      |
|         else                         |     [Install]                        |
|           add_daemon ypserv          |     WantedBy=multi-user.target       |
|           stat_done                  |                                      |
|         fi                           |                                      |
|         ;;                           |                                      |
|       stop)                          |                                      |
|         stat_busy "Stopping NIS Serv |                                      |
| er"                                  |                                      |
|         killall -q /usr/sbin/ypserv  |                                      |
|         if [ $? -gt 0 ]; then        |                                      |
|           stat_fail                  |                                      |
|         else                         |                                      |
|           rm_daemon ypserv           |                                      |
|           stat_done                  |                                      |
|         fi                           |                                      |
|         ;;                           |                                      |
|       restart)                       |                                      |
|         $0 stop                      |                                      |
|         sleep 1                      |                                      |
|         $0 start                     |                                      |
|         ;;                           |                                      |
|       *)                             |                                      |
|         echo "usage: $0 {start       |                                      |
+--------------------------------------+--------------------------------------+

Note:Keep in mind that values to keys such as ExecStart and ExecStop are
not run within a shell, but only passed to execv

> tmpfiles.d

-   Instead of creating necessary runtime directories and files when a
    service is started (as some rc scripts do), ship a tmpfiles.d(5)
    config file in /usr/lib/tmpfiles.d.
-   Add a line systemd-tmpfiles --create foo.conf to post_install (and
    post_upgrade if needed) to ensure the necessary runtime files are
    created on install, not just on the next boot

Tip:This feature can be used for a whole lot of other things, e.g. for
writing to arbitrary files, even in /sys

> modules-load.d

-   Instead of loading necessary modules when a service is started (as
    some rc scripts do), ship a modules-load.d(5) config file in
    /usr/lib/modules-load.d.
-   Add modprobe lines to post_install (and post_upgrade if needed) to
    ensure the necessary modules are loaded on install, not just on the
    next boot

> ntp-units.d

-   For NTP daemons, systemd-timedated requires an additional file in
    /usr/lib/systemd/ntp-units.d. It should be named after the package
    it belongs to (with a .list suffix), and contain the name of the
    service which starts the NTP daemon itself.

> sysctl.d

-   IMO(dreisner): This should generally be avoided, as tying low level
    kernel behavior to a package might be considered evil.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Systemd&oldid=236097"

Category:

-   DeveloperWiki

-   This page was last modified on 20 November 2012, at 13:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
