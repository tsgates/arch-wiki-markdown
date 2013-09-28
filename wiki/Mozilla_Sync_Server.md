Mozilla Sync Server
===================

This page is about special operations required in order to install
Mozilla Sync Server.

Newer versions of Mozilla Firefox feature bookmarks, passwords, settings
and browsing history synchronization between all your computers and
devices. Mozilla Foundation provides a public Sync server, but you can
host your own one if you want.

This article describes how to install it manually. Note that there is
also an AUR package for it: mozilla-firefox-sync-server-hg

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prerequisites                                                      |
|     -   1.1 Dependencies                                                 |
|     -   1.2 Accessibility                                                |
|     -   1.3 Administration Rights                                        |
|                                                                          |
| -   2 Installation                                                       |
|     -   2.1 Python preparation                                           |
|     -   2.2 Setup                                                        |
|     -   2.3 Python initial state restoration                             |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 Server-side configuration files                              |
|     -   3.2 Unprivileged User                                            |
|     -   3.3 Automatic Startup of the Server                              |
|     -   3.4 Client-side configuration                                    |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Prerequisites
-------------

> Dependencies

Before proceeding, you need to install python2, python2-virtualenv,
sqlite, mercurial and make, all available in the official repositories.

> Accessibility

If you intend to use your server with itinerant clients, you should
install it on an Internet reachable computer.

> Administration Rights

All installation instructions are commands relying on the superuser
privileges, so open a terminal and type:

    $ su -
    Password: 
    # 

Installation
------------

Mozilla Sync Server depends on Python 2 during installation. Arch Linux
provides Python 3 as default Python version so there are special tweaks
needed before running Mozilla Sync Server setup. Setup process creates
an isolated Python environment in which all necessary dependencies are
downloaded and installed. Afterwards, running the server only relies on
the isolated Python environment, independently of the system-wide
Python.

> Python preparation

Mozilla Sync Server setup needs Python 2.6 or newer. In default
configuration, /usr/bin/python is a symbolic link to /usr/bin/python3
whereas Python 2 is /usr/bin/python2.

Before running setup, we must check the link and change it if necessary:

    # cd /usr/bin
    # ls -l python

        lrwxrwxrwx 1 root root 7  5 sept. 07:04 python -> python3

    # ls -l virtualenv

        ls: cannot access virtualenv: No such file or directory

    # ln -sf python2 python
    # ln -sf virtualenv2 virtualenv

> Setup

Installation instructions:

    # mkdir -p /opt/weave
    # cd /opt/weave
    # hg clone https://hg.mozilla.org/services/server-full

          ... source repository cloning messages ...

    # cd server-full
    # make build

          ... many build messages, including harmless warnings ...

          ... end of the successful build messages:

    Building the app 
      Checking the environ   [ok]
      Updating the repo   [ok]
      Building Services dependencies 
        Getting server-core     [ok]
        Getting server-reg     [ok]
        Getting server-storage     [ok]  [ok]
      Building External dependencies   [ok]
      Now building the app itself   [ok]
    [done]

Check the end of the build messages, they should state "[done]".
Otherwise, look at the first error messages, they give you hints on the
problem and how to solve it.

> Python initial state restoration

Once the build is finished, restore the links in /usr/bin to their
original state.

    # cd /usr/bin
    # ln -sf python3 python
    # rm -f virtualenv

Configuration
-------------

> Server-side configuration files

Configuration files are used to define where databases and logs will be
created. We will place databases in /opt/weave/data and log files in
/var/log/weave, so we must create the directories.

    # mkdir /opt/weave/data /var/log/weave

At least two configuration files must be changed in
/opt/weave/server-full in order to reflect these choices:
development.ini and etc/sync.conf.

In development.ini, locate the line:

    args = ('/tmp/sync-error.log',)

and change it to:

    args = ('/var/log/weave/sync-error.log',)

In etc/sync.conf, locate the line:

    sqluri = sqlite:////tmp/test.db

and change it to:

    sqluri = sqlite:////opt/weave/data/sync.db

This statement appears twice in the file, both should be modified.

Bump the disk quota from 5 to 25 MB:

    quota_size = 25600

The fallback node URL must reflect the server's hostname (here
server-name.domain-name). Change:

    fallback_node = http://localhost:5000/

to:

    fallback_node = http://server-name.domain-name:5000/

> Unprivileged User

It is a good practice to run daemons as an unprivileged user. Create the
group weave and the user sync for that purpose:

     # groupadd weave
     # useradd -d /opt/weave -g weave -r -s /bin/bash sync

This new user must have read and write access on every file in
/opt/weave and /var/log/weave

    # chown -R sync:weave /opt/weave/*
    # chown -R sync:weave /var/log/weave

> Automatic Startup of the Server

In order to make the Sync Server start automatically at boot-time,
create a startup script:

    /etc/rc.d/mozillaweave

    #!/bin/bash

    RUNDIR=/var/run/weave
    DAEMON=/opt/weave/bin/python
    PIDFILE=/var/run/weave.pid
    MESSAGELOG=/var/log/weave/sync-messages.log

    . /etc/rc.conf
    . /etc/rc.d/functions

    PID=`pidof -x -o %PPID paster`
    case "$1" in
      start)
        stat_busy "Starting Mozilla Sync Server"
        [ -d $RUNDIR ] || mkdir $RUNDIR
        [ -z "$PID" ] && su sync -c "cd /opt/weave/server-full && bin/paster serve development.ini &>$MESSAGELOG &"
        if [ $? -gt 0 ]; then
          stat_fail
        else
          PID=`pidof -x -o %PPID paster`
          echo $PID >$PIDFILE
          add_daemon weave
          stat_done
        fi
        ;;
      stop)
        stat_busy "Stopping Mozilla Sync Server"
        [ ! -z "$PID" ]  && kill $PID &>/dev/null
        if [ $? -gt 0 ]; then
          stat_fail
        else
          rm_daemon weave
          stat_done
        fi
        ;;
      restart)
        $0 stop
        $0 start
        ;;
      *)
        echo "usage: $0 {start|stop|restart}"  
    esac
    exit 0

The script must have execution rights:

    # chmod 755 /etc/rc.d/mozillaweave

Start the Sync Server at boot by including mozillaweave in the Daemon
list. It depends on the network so it should be placed accordingly.

For systemd:

    /etc/systemd/system/mozillaweave.service

    [Unit]
    Description=Mozilla Weave
    After=network.target

    [Service]
    Type=simple
    User=sync
    WorkingDirectory=/opt/weave/server-full
    ExecStart=/opt/weave/server-full/bin/python2 /opt/weave/server-full/bin/paster serve /opt/weave/server-full/development.ini
    StandardOutput=/var/log/weave/sync-messages.log

    [Install]
    WantedBy=multi-user.target
    Alias=mozillaweave.service

Test start the server using:

    # systemctl start mozillaweave
    # systemctl status mozillaweave

Set the Sync Server to start at boot with:

    # systemctl enable mozillaweave

> Client-side configuration

Use the Sync Configuration Wizard in Firefox' Settings to create a new
account on the server. Don't forget to choose "Custom server..." in the
list, and input the server address: http://server-name.domain-name:5000/

The "Advanced Settings" button allows fine tuning of the synchronized
elements list, and the definition of the client hostname.

See also
--------

-   Mozilla Sync Server Howto
-   Great tutorial, by Eric Hameleers
-   Owncloud has mozilla sync server application

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mozilla_Sync_Server&oldid=252282"

Category:

-   Web Server
