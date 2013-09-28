aMule
=====

aMule is an eMule-like client for the eD2k and Kademlia networks,
supporting multiple platforms.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 amuled                                                       |
|         -   2.1.1 Create configuration files                             |
|         -   2.1.2 Edit configuration files                               |
|         -   2.1.3 Execute in background                                  |
|         -   2.1.4 Create daemon                                          |
|                                                                          |
|     -   2.2 amuleweb                                                     |
|         -   2.2.1 Create configuration files                             |
|         -   2.2.2 Create daemon                                          |
|                                                                          |
| -   3 Usage                                                              |
+--------------------------------------------------------------------------+

Installation
------------

aMule can be installed with package amule, available in the official
repositories.

amuled is a full featured aMule daemon, running without any user
interface (GUI). It is controlled by remote access through aMuleGUI
(GTK), aMuleWeb, or aMuleCmd.

Configuration
-------------

> amuled

Create configuration files

First we need to create a user for executing amule daemon:

    # useradd -m -d /srv/amule -s /bin/bash amule

Then we start a shell for the new user amule and run amuled once to
create the configuration files:

    # su amule
    $ amuled --ec-config

Now amuled will ask you for a temporary password, enter something (amule
for example, this does not matter), and use Ctrl-C to terminate amuled.

Edit configuration files

Now we need to configure amuled properly. First, we need to set up a
password for the external connection of amuled.

    $ echo -n <your password here> | md5sum | cut -d ' ' -f 1

The output of the above command is the encrypted password. Now you edit
the config file by adding following lines under section
[ExternalConnect]:

    /srv/amule/.aMule/amule.conf

    AcceptExternalConnections=1
    ECPassword=<encrypted password>

Execute in background

    # amuled -f

Create daemon

Note:It is probably better to include these configuration files by
default with amule package, like it is done with transmission.

To make amuled run on system start, we need to create the daemon
/etc/rc.d/amuled:

    # touch /etc/rc.d/amuled

Then copy the following to the file:

    #!/bin/bash
    DAEMON=amuled
    USER=amule

    . /etc/rc.conf
    . /etc/rc.d/functions

    case "$1" in
     start)
       stat_busy "Starting $DAEMON"
       su "$USER" -l -s /bin/sh -c "$(printf "%q -f>/dev/null" "/usr/bin/amuled" )"
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
       killall --quiet --ignore-case "/usr/bin/amuled"
       if [ $? = 0 ]; then
         rm_daemon $DAEMON
         stat_done
       else
         stat_fail
         exit 1
       fi
       ;;
     restart|force-reload)
       $0 stop
       sleep 4 #1 is not enough
       $0 start
       ;;
     *)
       printf "Usage: %q {start|stop|restart|force-reload}\n" "$0" >&2
       exit 1
       ;;
    esac

    exit 0

Make it executable:

    # chmod 755 /etc/rc.d/amuled

Add it to your /etc/rc.conf, so it will be autostarted.

    DAEMONS=( ... network amuled ... )

> amuleweb

Note:amuleweb provides much less features than amulegui (and displays
much less info on downloads), and it has to ask for password quite often
(unless your browser could save it). It is therefore advisable to use
amulegui instead (which starts up very fast as well), and if you decide
to do so, you could skip this step.

Create configuration files

Start amuleweb too using the user you just created to create the
configuration file:

    $ amuleweb --write-config --password=<password here> --admin-pass=<web password here>

Note that here, the <password here> is the unencrypted password you used
to configure amuled. <web password here> is the unencrypted for the log
in on the web interface. This command will write configuration file as
such.

Create daemon

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: does the package 
                           still lack daemon?       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Create the daemon /etc/rc.d/amuleweb:

    # touch /etc/rc.d/amuleweb

Copy the following to the file.

    #!/bin/bash
    DAEMON=amuleweb
    USER=amule

    . /etc/rc.conf
    . /etc/rc.d/functions

    case "$1" in
     start)
       stat_busy "Starting $DAEMON"
       su "$USER" -l -s /bin/sh -c "$(printf "%q --quiet &" "/usr/bin/amuleweb" )"
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
       killall --quiet --ignore-case "/usr/bin/amuleweb"
       if [ $? = 0 ]; then
         rm_daemon $DAEMON
         stat_done
       else
         stat_fail
         exit 1
       fi
       ;;
     restart|force-reload)
       $0 stop
       sleep 1
       $0 start
       ;;
     *)
       printf "Usage: %q {start|stop|restart|force-reload}\n" "$0" >&2
       exit 1
       ;;
    esac

    exit 0

Make it executable:

    # chmod 755 /etc/rc.d/amuleweb

Also add it to your /etc/rc.conf, so it will be autostarted.

    DAEMONS=( ... network amuled amuleweb ... )

Note:Whichever way you are starting amuleweb, make sure this is done
after amuled is up and running, or amuleweb could crash. If this
happened, you can't use `rc.d stop` since process is no longer present,
so instead just use `rc.d start` again.

Note:Do not forget to set amule's shell to /bin/false as we do not want
to give it shell access to the machine. Edit /etc/passwd and replace
/bin/bash by /bin/false for user amule:

    amule:x:1001:1001::/srv/amule:/bin/false

Usage
-----

You can start the daemons with:

    # rc.d start amuled
    # rc.d start amuleweb

Now you can run `amulegui`, use `amulecmd` or connect to amuleweb at
http://127.0.0.1:4711 (or with external address of your host).

Tip:If the default URL for nodes.dat for Kad network does not work, you
can get URL from there: http://nodes-dat.com

For further info on using the program, continue to Getting_Started at
aMule wiki.

Retrieved from
"https://wiki.archlinux.org/index.php?title=AMule&oldid=250182"

Category:

-   Internet Applications
