PS3 Mediaserver
===============

Server implemented in java. Has very good default transcoding profiles
for several clients, but lacks good information for headless servers.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Run as a daemon
    -   3.1 SysVinit
    -   3.2 systemd
-   4 Indexing

Installation
------------

Install pms from AUR.

Configuration
-------------

The default install location is /opt/pms and the config file is at
/opt/pms/PMS.conf, there are comments describing what each option is
for.

If running headless on a server

    Operating Mode

    minimized = true

If you don't want your entire filesystem to be shown

    Media Locations

    folders = /directory.you.want.shared/,/another.directory

If you run into issues with the wrong audio track playing (example:
English desired)

    Audio language priority

    mencoder_audiolangs = eng,und

Example of english subtitles desired, no subtitles by default on English
programs

    Subtitle language priority

    mencoder_sublangs = loc,eng,und

A list with all options can be found here.

Run as a daemon
---------------

> SysVinit

Use the following modified daemon script (originally from pms-svn).

    /etc/rc.d/pms

    #!/bin/bash

    . /etc/rc.conf
    . /etc/rc.d/functions
    . /etc/conf.d/pms

    PID=`cat /var/run/pms.pid 2> /dev/null`
    [ -z "$PID" ] && PID=`ps -Ao pid,command | grep java | grep pms.jar | awk '{print $1}'`

    case "$1" in
    	start)
    		stat_busy "Starting PS3 Media Server"
    		if [ -z "$PID" ]; then
    			if [ -n "$PMS_USER" ]; then
    				su -s '/bin/sh' $PMS_USER -c "/usr/bin/ps3mediaserver &>> /var/log/pms.log" &
    			else
    				/usr/bin/ps3mediaserver &>> /var/log/pms.log &
    			fi
    			PID=$!
    			if [ $? -gt 0 ]; then
    				stat_fail
    			else
    				echo $PID > /var/run/pms.pid
    				add_daemon pms
    				stat_done
    			fi
    		fi
    		;;
    	stop)
    		stat_busy "Stopping PS3 Media Server"
    		[ ! -z "$PID" ]  && kill $PID &> /dev/null
    		while ps -p $PID &> /dev/null; do sleep 1; done
    		if [ $? -gt 0 ]; then
    			stat_fail
    		else
    			rm /var/run/pms.pid 2> /dev/null
    			rm_daemon pms
    			stat_done
    		fi
    		;;
    	restart)
    		$0 stop
    		sleep 1
    		$0 start
    		;;
    	*)
    		echo "usage: $0 {start|stop|restart}"
    		;;
    esac
    exit 0

    # /etc/rc.d/pms start

-   (optionally) watch the output with 'tail -f /var/log/pms.log' or
    'tail -f /opt/pms/debug.log' for any problems.

> systemd

The package ships a systemd unit file by default now (since 1.71.0-2).
After installation just run:

    # systemctl daemon-reload
    # systemctl start pms@<username> # to start once
    # systemctl enable pms@<username> # automatically start at boot
    # journalctl -u pms@<username> # to debug the logfiles

Indexing
--------

This should be done automgically upon starting the service, but if it
doesn't, this is how to do it manually:

-   Browse the logs to see at what ip-address and port pms has started
    the built-in webservice
-   Use your web browser to go to:
    http://<ip-address-of-your-server>:5001/console/home and click on
    'index files and folders'
-   After the indexing has ended, you are done.

Retrieved from
"https://wiki.archlinux.org/index.php?title=PS3_Mediaserver&oldid=285922"

Category:

-   Web Server

-   This page was last modified on 2 December 2013, at 20:08.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
