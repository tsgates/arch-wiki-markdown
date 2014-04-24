Initscripts/Writing rc.d scripts
================================

Related articles

-   Arch Boot Process
-   Daemon
-   rc.conf

Warning:Arch only supports systemd. Arch's old initscripts package is
obsolete and is no longer supported. All Arch users need to move to
systemd.

Initscripts uses rc.d scripts to used to control the starting, stopping
and restarting of daemons.

Guideline
---------

-   Source /etc/rc.conf, /etc/rc.d/functions, and optionally
    /etc/conf.d/DAEMON_NAME.
-   Arguments and other daemon options should be placed in
    /etc/conf.d/DAEMON_NAME. This is done to separate configuration from
    logic and to keep a consistent style among daemon scripts.
-   Use functions in /etc/rc.d/functions instead of duplicating their
    functionality.
-   Include at least start, stop and restart as arguments to the script.

Available functions
-------------------

-   There are some functions provided by /etc/rc.d/functions:
    -   stat_busy "message": set status busy for printed message (e.g.
        Starting daemon [BUSY])
    -   stat_done: set status done (e.g. Starting daemon [DONE])
    -   stat_fail: set status failed (e.g. Starting daemon [FAILED])
    -   get_pid program: get PID of the program
    -   ck_pidfile PID-file program: check whether PID-file is still
        valid for the program (e.g. ck_pidfile /var/run/daemon.pid
        daemon || rm -f /var/run/daemon.pid)
    -   [add|rm]_daemon program: add/remove program to running daemons
        (stored in /run/daemons/)

Full list of functions is much longer and most possibilities (like way
to control whether or not non-root users can launch daemon) are still
undocumented and can be learned only from /etc/rc.d/functions source.
See also man rc.d.

Example
-------

The following is an example for crond. Look in /etc/rc.d for greater
variety.

The configuration file:

    /etc/conf.d/crond

    ARGS="-S -l info"

The actual script:

    /etc/rc.d/crond

    #!/bin/bash

    . /etc/rc.conf
    . /etc/rc.d/functions

    DAEMON=crond
    ARGS=

    [ -r /etc/conf.d/$DAEMON ] && . /etc/conf.d/$DAEMON

    PID=$(get_pid $DAEMON)

    case "$1" in
     start)
       stat_busy "Starting $DAEMON"
       [ -z "$PID" ] && $DAEMON $ARGS &>/dev/null
       if [ $? = 0 ]; then
         add_daemon $DAEMON
         stat_done
       else
         stat_fail
         exit 1
       fi
       ;;
     stop)
       stat_busy "Stopping $DAEMON"
       [ -n "$PID" ] && kill $PID &>/dev/null
       if [ $? = 0 ]; then
         rm_daemon $DAEMON
         stat_done
       else
         stat_fail
         exit 1
       fi
       ;;
     restart)
       $0 stop
       sleep 1
       $0 start
       ;;
     *)
       echo "usage: $0 {start|stop|restart}"  
    esac

Retrieved from
"https://wiki.archlinux.org/index.php?title=Initscripts/Writing_rc.d_scripts&oldid=300462"

Categories:

-   Boot process
-   Package development

-   This page was last modified on 23 February 2014, at 15:16.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
