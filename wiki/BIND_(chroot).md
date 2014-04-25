BIND (chroot)
=============

  

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Arch no longer   
                           supports Initscripts.    
                           This article needs to be 
                           updated to work with     
                           systemd. (Discuss)       
  ------------------------ ------------------------ ------------------------

It's not a good idea to run BIND as root, so this document will briefly
explain how to setup a basic DNS server using BIND 9.8.0 in a jailed
environment (chroot). This document assumes that you already know how to
configure and use BIND (the Berkeley Internet Name Domain).

Contents
--------

-   1 Installation
-   2 Init script
-   3 Configuration
-   4 Setup BIND
-   5 Running At Startup

Installation
------------

See BIND#Install BIND for instructions on installing BIND.

Init script
-----------

The bind package already comes with an init script, but it does not run
BIND in a jailed environment; however, the following script does.

Create the following file:

    /etc/rc.d/named-chroot

     #!/bin/bash
     
     NAMED_ARGS=
     [ -f /etc/conf.d/named ] && . /etc/conf.d/named
     
     . /etc/rc.conf
     . /etc/rc.d/functions
     
     PID=`pidof -o %PPID /usr/sbin/named`
     case "$1" in
      start)
        stat_busy "Starting BIND (chroot)"
     
        # create chroot directories
        mkdir -p ${CHROOT}/{dev,etc} ${CHROOT}/var/named/slave ${CHROOT}/var/{run,log} ${CHROOT}/usr/lib/engines
     
        # copy necessary files
        cp /etc/named.conf ${CHROOT}/etc/
        cp /etc/localtime ${CHROOT}/etc/
        cp -a /var/named/* ${CHROOT}/var/named/
        cp /usr/lib/engines/libgost.so ${CHROOT}/usr/lib/engines/
     
        # create block devices
        mknod ${CHROOT}/dev/null c 1 3
        mknod ${CHROOT}/dev/random c 1 8
     
        # set permissions
        chown root:named ${CHROOT}
        chmod 750 ${CHROOT}
        chown -R named:named ${CHROOT}/var/named/slave
        chown named:named ${CHROOT}/var/{run,log}
        chmod 666 ${CHROOT}/dev/{null,random}
     
        [ -z "$PID" ] && /usr/sbin/named ${NAMED_ARGS} -t ${CHROOT}
        if [ $? -gt 0 ]; then
          stat_fail
        else
          add_daemon named-chroot
          stat_done
        fi
        ;;
      stop)
        stat_busy "Stopping BIND (chroot)"
        [ ! -z "$PID" ]  && kill $PID &> /dev/null
        if [ $? -gt 0 ]; then
          stat_fail
        else
          rm_daemon named-chroot
          rm -rf ${CHROOT}
          stat_done
        fi
        ;;
      restart)
        $0 stop
        sleep 1
        $0 start
        ;;
      reload)
        stat_busy "Reloading BIND"
        [ ! -z "$PID" ] && rndc reload &>/dev/null || kill -HUP $PID &>/dev/null
        if [ $? -gt 0 ]; then
          stat_fail
        else
          stat_done
        fi
        ;;
      *)
        echo "usage: $0 {start|stop|reload|restart}"
     esac
     exit 0

Do not forget to make this script executable.

    # chmod a+x /etc/rc.d/named-chroot

Configuration
-------------

You will now need to add a new configuration variable to
/etc/conf.d/named. So open it up in a text editor and add the following:

    CHROOT="/srv/named"

If you are using a clean install of bind your /etc/conf.d/named file
should look like this:

    #
    # Parameters to be passed to BIND
    #
    NAMED_ARGS="-u named"
    CHROOT="/srv/named"

Setup BIND
----------

At this point you can configure BIND the way you are used to because all
the necessary files will be copied to the jail accordingly.

-   One thing to note is, for security reasons, the /var/named directory
    in the chroot is read only and the /var/named/slave subdirectory is
    writable. So in reality, slave zone files are saved in
    /srv/named/var/named/slave so your slave zone's configuration should
    reflect this otherwise zone transfers will fail.

Running At Startup
------------------

In order to run the chrooted version of BIND on start-up, edit the
DAEMONS array of /etc/rc.conf and add name-chroot to it. Make sure it
starts immediately after network

Here is an example:

    DAEMONS=(rsyslogd crond iptables network named-chroot)

Retrieved from
"https://wiki.archlinux.org/index.php?title=BIND_(chroot)&oldid=267999"

Category:

-   Domain Name System

-   This page was last modified on 25 July 2013, at 23:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
