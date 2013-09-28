pyLoad
======

pyLoad is a fast, lightweight and full featured download manager for
many One-Click-Hoster, container formats like DLC, video sites or just
plain http/ftp links (supported hosts). It aims for low hardware
requirements and platform independence to be runnable on all kind of
systems (desktop pc, netbook, NAS, router). Despite its strict
restriction it is packed full of features just like webinterface,
captcha recognition, unrar and much more.

pyLoad is divided into core and clients, to make it easily remote
accessible. Currently there are (screenshots):

-   a webinterface;
-   a command line interface;
-   a GUI written in Qt;
-   and an Android client.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Headless Servers                                             |
|     -   1.2 Requirements                                                 |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Optional                                                     |
|     -   2.2 Scripts                                                      |
|                                                                          |
| -   3 Running                                                            |
|     -   3.1 Essential                                                    |
|     -   3.2 Interfacing with pyLoadCore                                  |
|                                                                          |
| -   4 Daemon                                                             |
|     -   4.1 Initscript                                                   |
|     -   4.2 systemd                                                      |
|                                                                          |
| -   5 Alternatives                                                       |
+--------------------------------------------------------------------------+

Installation
------------

Install the pyload package from the AUR.

> Headless Servers

On headless servers, you will want to use giflib-nox11 instead of
giflib, before you install pyload. Otherwise this package will pull X11
dependencies.

> Requirements

Required dependencies are handled by the AUR package's PKGBUILD.
Nevertheless, some optional dependencies aren't:

-   Ability to establish a secure connection to core or webinterface.

    # pacman -S openssl python2-pyopenssl

-   For ClickNLoad and at least ZippyShare (maybe other hosters too)
    support:

    # pacman -S js

Configuration
-------------

Run Setup Assistant:

    # pyLoadCore -s

The Setup Assistant gives you a jump start, by providing a basic but
working setup. Being a basic setup, there are more options and you
should at least look at them, since some sections are untouched by the
Assistant, like the permissions section.

Tip:Most (if not all) of the options can be changed with pyLoadGui or
with the the Web Interface.

> Optional

However, if you prefer to edit the pyload.conf yourself and you went
with the default conf directory, you can change the settings by editing
{{ic|~/.pyload/pyload.conf}. Use your favorite editor to edit, ie:

    # nano ~/.pyload/pyload.conf

You can get aquainted with most of the configuration options in this
page. Do note that it is outdated, in a sense, since the
/opt/pyload/module/config/ files it refers to do not match what's still
on that page.

While also editable with the web interface, you can also change the
plugins configuration by editing ~/.pyload/plugins.conf. Use your
favorite editor to edit, ie:

    # nano ~/.pyload/plugins.conf

Extraction passwords are store in ~/.pyload/unrar_passwords.txt. To add
passwords either edit the file or:

    # echo '<password>' >> ~/.pyload/unrar_passwords.txt

You can get aquainted with most of the configuration options in this
page. Do note that it is outdated, in a sense, since the
/opt/pyload/module/config/ files it refers to do not match what's still
on that page.

> Scripts

For more info on this,

    cat /opt/pyload/scripts/Readme.txt

and visit pyload.org forums.

If you are interested in running userscripts, before running, you need
to either

    # chmod 777 /opt/pyload/scripts/

or

    # chown <user you defined in pyload.conf / permissions settings> /opt/pyload/scripts/

in order for pyLoadCore to create the necessary folders.

Running
-------

> Essential

    # pyLoadCore 

Tip:You may want to add pyLoadCore --daemon to your rc.local

> Interfacing with pyLoadCore

    # pyLoadCli

    # pyLoadGui

Or, as stated above, with the web interface. If the default settings are
true, then:

    http://localhost:8000

Daemon
------

> Initscript

To start pyload as a daemon we have to create it first:

    su
    touch /etc/rc.d/pyload
    chmod +x /etc/rc.d/pyload

Now edit the content with:

    nano /etc/rc.d/pyload

Tip: Don't forget to change USER and PIDFILE and/or uncommenting lines
after # after pyload update restart itself if required.

    #!/bin/bash

    . /etc/rc.conf
    . /etc/rc.d/functions

    USER=YOUR_USER
    PIDFILE=/PATH/TO/.pyload/pyload.pid

    case "$1" in
      start)
        stat_busy "Starting pyload"
        su $USER -c '/usr/bin/pyLoadCore --daemon' &> /dev/null
        # after pyload update restart itself
        # sleep 30                                                                    # waiting time for pyload updates
        # su $USER -c "kill -15 $(cat $PIDFILE) && rm -f $PIDFILE" &> /dev/null       # kill pyload
        # su $USER -c '/usr/bin/pyLoadCore --daemon' &> /dev/null                     # restart pyload
        if [ $? -gt 0 ]; then
          stat_fail
        else
          add_daemon pyLoadCored
          stat_done
        fi
        ;;
      stop)
        stat_busy "Stopping pyload"
        # killall -w -s 2 /usr/bin/pyLoadCore &> /dev/null
        su $USER -c "kill -15 $(cat $PIDFILE) && rm -f $PIDFILE" &> /dev/null
        if [ $? -gt 0 ]; then
          stat_fail
        else
          rm_daemon pyLoadCored
          stat_done
        fi
        ;;
      restart)
        $0 stop
        sleep 3
        $0 start
        ;;
      *)
        echo "usage: $0 {start|stop|restart}"
    esac
    exit 0

Finally start pyload with:

    rc.d start pyload

To start pyload automatically add it to the daemon array in
/etc/rc.conf.

> systemd

/etc/systemd/system/pyload.service

Tip: Don't forget to change $USER

    [Unit]
    Description=Downloadtool for One-Click-Hoster written in python.
    After=network.target

    [Service]
    Type=forking
    PIDFile=/home/$USER/.pyload/pyload.pid
    ExecStart=/usr/bin/pyLoadCore --daemon
    KillSignal=SIGQUIT
    User=$USER

    [Install]
    WantedBy=multi-user.target

To start pyload run:

    # systemctl start pyload

To have it started automatically on boot:

    # systemctl enable pyload

Alternatives
------------

JDownloader available in AUR.

Tucan Manager available in community.

plowshare available in AUR (CLI).

uGet available in AUR (GTK).

TuxLoad available in AUR (CLI).

Retrieved from
"https://wiki.archlinux.org/index.php?title=PyLoad&oldid=234745"

Category:

-   Internet Applications
