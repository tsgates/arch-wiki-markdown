X2Go
====

With X2Go you can access your desktop using another computer -- that
means both LAN and internet connections. The transmission is done using
the ssh protocol, so it is encrypted. By using the free nx libraries
from NoMachine, a very acceptable performance in both speed and
responsiveness is achieved. Even an ISDN connection runs smoothly.

This makes it possible to connect your laptop to any computer with the
environment, applications, and performance of the remote desktop. It is
also possible to have a bunch of computers connected to a single server
(terminal-server, thin-client).

Clients are available for Linux (Qt4), Windows, and Mac. The latter two
can be downloaded directly as binary from the X2Go homepage.

Contents
--------

-   1 X2Go and Arch Linux
-   2 Installation and configuration
    -   2.1 Configuring the Server
        -   2.1.1 Install the x2goserver package:
        -   2.1.2 Install the ssh-daemon:
        -   2.1.3 Load the fuse module:
        -   2.1.4 Initialize the SQL database (and start the SQL
            server):
        -   2.1.5 Check SSH daemon configuration to allow non-English
            session:
-   3 Configuration of the Client
-   4 Various
-   5 Future
-   6 Troubleshooting
-   7 Links

X2Go and Arch Linux
-------------------

Arch Linux X2Go packages are available in the official repositories.
Currently the x2goserver and x2goclient are available. The LDAP based
usermanagement suite is not yet finished, nor are tools that make X2Go
more convenient for use in schools and thin client environments.

Installation and configuration
------------------------------

> Configuring the Server

Install the x2goserver package:

Install x2goserver from the official repositories.

Install the ssh-daemon:

    # pacman -S openssh
    # systemctl start sshd.service

To have sshd started at boot time:

    # systemctl enable sshd.service

Load the fuse module:

This makes it possible for the server to access files on the client
computer.

    # modprobe fuse

To have this module loaded at boot time, you also have to put it into
/etc/modules-load.d, e.g.

    /etc/modules-load.d/fuse.conf

    fuse

Initialize the SQL database (and start the SQL server):

You can choose to use either Postgres or SQLite database, the latter
does not need a running server.

Initialize SQLite db:

    x2godbadmin --createdb

Start the x2goserver:

    # systemctl start x2goserver.service

If you want to have the X2Go server started at boot time:

    # systemctl enable x2goserver.service

Check SSH daemon configuration to allow non-English session:

If you are using other than POSIX (C) locale, you may want to add the
following line to /etc/ssh/sshd_config:

    # Allow client to pass locale environment variables
    AcceptEnv LANG LC_*

Then restart the daemon (as root):

    # systemctl restart sshd.service

Configuration of the Client
---------------------------

Install the client:

x2goclient is available in the official repositories. It is a Qt GUI
app, although you can also check-out the command line options by running

    x2goclient --help

Double check ssh

Convince yourself that you can open a ssh-session from the client to the
server (host).

    ssh YourUsername_onServer@yourhost_or_ip

Within the local network this should not be a problem. The way you
connect from beyond your network, lets say the internet, to your
computer at home is a question of how your network is build up. This
would go beyond the scope of this article. Therefore here only a few
items:

-   A port has to be opened at the router resp. gateway which forwards
    requests to your server, and there especially to the sshd-port
    (which normally is 22). To prevent a big part of the portscan
    attacks it is probably better to have 222 as publicly reachable
    port.
-   To prevent you from having the need to keep your public IP address
    in mind (especially if this changes dynamically) it is advisable to
    use a dynamic DNS-Service (DynDNS, DynIP). Many routers are
    preconfigured to be reachable under a name rather than an IP
    address.

Enough preliminaries! Now to the x2goclient. Run it:  

    x2goclient

This opens the client application. You can now create several sessions,
which then appear on the right side and can be selected by a mouse
click. Each entry consists of your username on the server, hostname and
IP and the port for ssh-connection. Furthermore you can define several
speed profiles (coming from modem up to LAN) and the desktop environment
you want to start remotely.

Common mistakes:  
 Do not simply choose the defaults of KDE or Gnome, since the
executables startkde or startgnome are usually not in the PATH when
logging in using ssh. Use full paths to startkde or startgnome. You can
also start openbox or another window manager.

You should be asked for your password for your user at the server now
and after login you will see the X2Go logo for a short time, and --
voila -- the desktop.

Exchange data between client and server(desktop)  
 On the x2goclient (e.g. laptop) local directories could be shared. The
server will use fuse and sshfs to access this directory and mount it to
a subdirectory media of your home directory on the server. This enables
you to have access to laptop data on your server or to exchange files.
It is also possible to mount these shares automatically at each session
start.

To leave a session temporarily  
 Another special feature of X2Go is the possibility of suspending a
session. This means you can leave a session on one client and reopen it
even from another client at the same point. This can be used to to start
a session in the LAN and to reopen it later on a laptop. The session
data are stored and administered in a postgres database on the server in
the meanwhile. The state of the sessions is protocolled by a process
named x2gocleansessions.

Various
-------

Workaround for failing compositing window manager for remote session

This is useful for situations, when the computer running x2gserver is
used also for local sessions with e.g. compiz as the window manager. For
remote connections with x2goclient, compiz fails to load and metacity
should be used instead. The following is for GNOME, but could be
modified for other desktop environments. (Getting compiz ready is not
part of this how-to.)

Create /usr/local/share/applications/gnome-wm-test.desktop:

    [Desktop Entry]
    Type=Application
    Encoding=UTF-8
    Name=gnome-wm-test
    Exec=/usr/local/bin/gnome-wm-test.sh
    NoDisplay=true

Create script /usr/local/bin/gnome-wm-test.sh:

    #!/bin/sh
    # Script for choosing compiz when possible, otherwise metacity
    # Proper way to use this script is to set the key to mk-gnome-wm
    # /desktop/gnome/session/required_components/windowmanager
    xdpyinfo 2> /dev/null | grep -q "^ *Composite$" 2> /dev/null
    IS_X_COMPOSITED=$?
    if [ $IS_X_COMPOSITED -eq 0 ] ; then
        gtk-window-decorator &
        WM="compiz ccp --indirect-rendering --sm-client-id $DESKTOP_AUTOSTART_ID"
    else
        WM="metacity --sm-client-id=$DESKTOP_AUTOSTART_ID"
    fi
    exec bash -c "$WM"

Modify the following gconf key to start the session with gnome-wm-test
window manager:

    $ gconftool-2 --type string --set /desktop/gnome/session/required_components/windowmanager "gnome-wm-test"

Future
------

At the moment the package consists mainly of the x2goserver and the
x2goclient. It is planned to add in near future:

-   LDAP-Integration. This allow the administration of users, sessions
    and logins using LDAP. This is an interesting feature for schools or
    companies. For this purpose there are control programs which
    integrate themselves into the KDE Control Center.
-   The option to use x2goclient as a login screen for thin clients.
-   The possibility to use local devices (CD, floppy, USB-stick)
    remotely and transparently.

Questions and problems? You could contact me also directly. GerBra

(Many thanks to Stefan Husmann for translation from archlinux.de wiki)

Troubleshooting
---------------

-   If you get the following authentication error.

    Authentification Failed:
    The host key for this server was not found but an othertype of key exists.
    An Attacker might change the default server key to confuse  
    your client into thinking the key does not exist

Then delete the servers entry from your ~/.ssh/known_hosts file and then
retry to authenticate.

Links
-----

Screenshot KDE-Session

Screenshot configuration dialog

Project page

Retrieved from
"https://wiki.archlinux.org/index.php?title=X2Go&oldid=303122"

Category:

-   Remote Desktop

-   This page was last modified on 4 March 2014, at 04:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
