FreeNX
======

NX is an exciting new technology for remote display. It providesnear
local speedapplication responsiveness over high latency, low bandwidth
links. The core libraries for NX are provided by NoMachine under the
GPL. FreeNX is a GPL implementation of the NX Server and NX Client
Components.

— FreeNX - the free NX

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Setup                                                              |
|     -   2.1 Server                                                       |
|         -   2.1.1 Keys                                                   |
|         -   2.1.2 Starting the server                                    |
|                                                                          |
|     -   2.2 Client                                                       |
|         -   2.2.1 Arch Linux                                             |
|         -   2.2.2 Windows                                                |
|         -   2.2.3 Configuration                                          |
|                                                                          |
| -   3 Running                                                            |
|     -   3.1 Keyboard shortcuts                                           |
|     -   3.2 Leaving fullscreen                                           |
|     -   3.3 Tips on resume                                               |
|     -   3.4 Fix DPI settings                                             |
|                                                                          |
| -   4 FreeNX to existing display                                         |
| -   5 Setting up non-KDE or Gnome desktop managers                       |
|     -   5.1 Alternative fix                                              |
|                                                                          |
| -   6 Problems                                                           |
|     -   6.1 Debug problems                                               |
|     -   6.2 Authentication OK, but connection fails                      |
|     -   6.3 Key changes                                                  |
|     -   6.4 Xorg 7                                                       |
|     -   6.5 Wrong password / No connection possible / Key-based          |
|         authentication                                                   |
|     -   6.6 NX Crashes on session startup                                |
|         -   6.6.1 Missing Fonts                                          |
|         -   6.6.2 Awesome WM                                             |
|                                                                          |
|     -   6.7 NX logo then blank screen                                    |
|     -   6.8 GDM/XDM Session Menu Error with non-KDE or Gnome Desktop     |
|         Managers (more common with non-Arch Linux users)                 |
|     -   6.9 Cannot connect because command sessreg not found             |
|     -   6.10 Broken resume with Cairo 1.12.x                             |
|     -   6.11 eclipse crashes when editing a file                         |
+--------------------------------------------------------------------------+

Installation
------------

package is split up into 2 parts:

-   freenx (the server)
-   nxclient (the client)

If you plan using freenx to connect to a headless PC, keep in mind that
you'll also need an X server configured, so you should install any
relevant xorg package.

Setup
-----

> Server

The free server is the 'freenx' package.

Get the server from pacman:

    pacman -S freenx

The sshd daemon must be installed and running for it to function
properly.

    # systemctl enable sshd

For freenx to authentication to work, sshd has to be setup properly.
Verify the following entries in /etc/ssh/sshd_config:

    RSAAuthentication yes
    AllowUsers someuser nx

The main configuration file is located at:

    /etc/nxserver/node.conf

If you are running your SSH daemon on a port other than the default port
22, you'll need to uncomment and update:

    SSHD_PORT=22

Note:As of OpenSSL 1.0.0, it is necessary to set proper md5sum command
in /etc/nxserver/node.conf:

    COMMAND_MD5SUM="md5sum"

If you use KDE or Gnome desktop environments you do not need to edit
this file, as the defaults with the modified MD5SUM command should work
in this case. If you use another window manager such as Fluxbox/Openbox
or Xfce, you may need to edit this file slightly (see below).

After installing the freenx package, run /usr/bin/nxsetup --help for an
overview of the install and uninstall procedures.

Note:You should also install "xdialog" on the server or you will not see
the "suspend/terminate" dialog when you try to close the window or hit
"ctrl-alt-T":

    pacman -S xdialog

Note:Although mostly assumed that you will have it already, "xterm" is
also necessary for some things:

    pacman -S xterm

Keys

Keys are used to authenticate the clients with the server. By default a
new set of random keys are generated during the install, one for the
server and one for the clients. You will need to copy this client key to
each of your clients that want to connect (Windows and linux).

The client key can be found here:

    /var/lib/nxserver/home/nx/.ssh/client.id_dsa.key

Alternatively you can use the default key that is provided by NoMachine
with all clients. In this case you do not need to copy a custom
generated key to each client. To get the server to accept the default
client keys run:

    /usr/bin/nxsetup --install --setup-nomachine-key

Recreation of random keys:

    /usr/bin/nxsetup --install

Transferring nx keys to another freenx server:

-   /var/lib/nxserver/home/nx/.ssh/ contains the key files

     -rw------- 1 nx root  697  9. Okt 12:55 authorized_keys
     -rw------- 1 nx root  668  9. Okt 11:48 client.id_dsa.key
     -rw------- 1 nx root  609  9. Okt 12:55 server.id_dsa.pub.key

-   Save those files.
-   Add those files to your new server, they need the same permissions,
    names, group and directory!

     # cp authorized_keys client.id_dsa.key server.id_dsa.pub.key /var/lib/nxserver/home/nx/.ssh/
     # chmod 600 /var/lib/nxserver/home/nx/.ssh/*
     # chown nx /var/lib/nxserver/home/nx/.ssh/*
     # chgrp root /var/lib/nxserver/home/nx/.ssh/*

-   Recreate known_hosts file:

     # echo -n 127.0.0.1 > /var/lib/nxserver/home/nx/.ssh/known_hosts
     # cat /etc/ssh/ssh_host_rsa_key.pub >> /var/lib/nxserver/home/nx/.ssh/known_hosts
     # chmod 633 /var/lib/nxserver/home/nx/.ssh/known_hosts
     # chown nx /var/lib/nxserver/home/nx/.ssh/known_hosts
     # chgrp root /var/lib/nxserver/home/nx/.ssh/known_hosts

Starting the server

Once installed the server is effectively running and ready to go, you do
not have to do anything manually. The only thing that must be running in
order to connect is the sshd daemon. This is because the nxserver is
actually started by logging into sshd as the special user 'nx'. This
user has been set up to use the nxserver as its shell, much like a
normal user has bash as the default shell.

You can specify the local addresses sshd should listen for by editing
/etc/ssh/sshd_config and adding them in the following format:

    ListenAddress host|IPv4_addr|IPv6_addr

The original ListenAddress in sshd_config is 0.0.0.0. This listens to
all addresses, however adding any address will take precedent to this
and and accept connections from the new address only.

Restart the sshd daemon to put any changes to its configuration into
effect:

    # systemctl restart sshd

In actual fact, if you check the process list (ps aux) you may not see
the nxserver running even though it is. This is because the nxserver is
actually started by logging into sshd as the special user 'nx'. This
user has been set up to use the nxserver as its shell, much like a
normal user has bash as the default shell.

> Client

Arch Linux

Get one or both of these clients from pacman:

    pacman -S opennx nxclient

Windows

Get the client from nomachine's homepage: http://www.nomachine.com

Tip: Nomachine tends to remove old clients from their homepage, If your
setup works with a client save it at a safe place ;)

Configuration

As mentioned above, the client must contain the correct key to connect
to the server. If you are using the custom keys generated during
install, you need to copy the client key to the following locations:

-   Windows: <yourinstalldironwindows>/share/keys/client.id_dsa.key
-   Arch Linux: /usr/lib/nx/share/keys/client.id_dsa.key

After moving the keys you may have use the nxclient GUI to import the
new keys. From the configuration dialog press the 'Key...' button and
import the new client key.

Running
-------

After installing nxclient on Arch Linux, executables are available in
/usr/lib/nx/bin/ symlinked to /usr/bin/. At the first run of
/usr/bin/nxclient, the user will be led through a wizard.

> Keyboard shortcuts

    CTR+ALT+F          Toggles full-screen mode. 
    CTRL+ALT+T         Shows the terminate, suspend dialog.
    CTRL+ALT+M         Maximizes of minimizes the window 
    CTRL+ALT+Mouse     Drags the viewport, so you can view different portions 
                       of the desktop. 
    CTRL+ALT+Arrows 
    or                 Moves the viewport by an incremental amount of pixels. 
    CTRL+ALT+Keypad 
    CTRL+ALT+S         It will activate "screen-scraping" mode, so all the GetImage
                       originated by the clients will be forwarded to the real
                       display. This should make happy those who love taking
                       screenshots ;-). By pressing the sequence again, nxagent
                       will revert to the usual "fast" mode.
    CTRL+ALT+E         lazy image encoding
    CTRL+ALT+Shift+ESC Emergency-exit and kill-window

> Leaving fullscreen

There is a magic-pixel in the top right corner of nearly every
nx-application in fullscreenmode. Left-click the pixel and
application-window gets iconified.

> Tips on resume

-   Resume is a bit experimental, crashes might appear after session has
    resumed. You have to find out which apps like resuming and which do
    not ;) .
-   Resuming between Linux and Windows sessions does not work. UPDATE:
    It appears that version 3.2.0-14 is able to resume Windows-suspended
    sessions.
-   If resume fails let it time out and do not use the cancel button,
    else sessions will stay open and consume RAM on server. To kill such
    sessions use the Session Admin program to kill them.

> Fix DPI settings

If you like to have the same font-sizes/dpi sizes on all your client
session, set the X resource "Xft.dpi". For example putting the following
line into a user's "~/.Xresources" makes her/his "desktop" a 100dpi.
Xft.dpi: 100

FreeNX to existing display
--------------------------

Usually, when connecting to a NX server, a new X session is created.
Sometimes it might be useful, to connect to an existing X session, e.g.
the root session. This is not possible with NX in default setup, but can
be reached, using tightvnc and x11vnc. Do the following steps on the NX
server system.

    # pacman -S tightvnc x11vnc

x11vnc will serve the X session, we have to create a file
$HOME/.x11vncrc to give x11vnc some options, e.g.:

    display :0
    shared
    forever
    localhost
    rfbauth /home/USER/.x11vnc/passwd

Create the VNC password file:

    $ mkdir $HOME/.x11vnc
    $ x11vnc -storepasswd PASSWORD $HOME/.x11vnc/passwd
    $ chmod 600 $HOME/.x11vnc/passwd

Create a shell script, which starts the x11vnc service, if not running
and starts the vncviewer provided by the package tightvnc.

Note:The variable $VNC_PORT in the following script defines the X
display, which is configured as display :0 under $HOME/.x11vncrc, 5900
is the root session, if you want to use display :1 use the port 5901 and
so on

    #!/bin/sh
    VNC_VIEWER=vncviewer
    VNC_SERVER=x11vnc
    VNC_RESOLUTION=1024x786
    VNC_PASSWD=/home/USER/.x11vnc/passwd
    VNC_PORT=5900

    if [ -z "$(pgrep ${VNC_SERVER})" ]; then
    	echo $VNC_SERVER not running, starting...
    	exec $VNC_SERVER &
    	sleep 5
    fi

    exec $VNC_VIEWER -geometry $VNC_RESOLUTION -passwd $VNC_PASSWD localhost::$VNC_PORT

Save this script with a texteditor of your choice, e.g. under
$HOME/shell/nxvnc.sh. Make it executable and create a symbolic link,
e.g:

    $ chmod +x $HOME/shell/nxvnc.sh
    # ln -s /home/USER/shell/nxvnc.sh /usr/local/bin/nxvnc

At this point, you might want to test the current configuration:
$ /usr/local/bin/nxvnc

If the x11vnc service and a vncviewer session is started, you
configuration works well. You are now able to connect to the current X
session using your NX client with following options:

    Login, Password, Host, Port: your default entries
    Desktop: Unix -> Custom
     - Settings:
       - Run the following command: /usr/local/bin/nxvnc
       - New virtual desktop
    Display:
      - Fullscreen or Custom with you preferred resolution

You are able to connect to your current X session via NX client now.

— FreeNX to existing display (opensuse.org)

Setting up non-KDE or Gnome desktop managers
--------------------------------------------

Before following anything in this part, make sure the server working
setup and accepting connections. This section only deals with problems
once NXClient has logged on.

It is quite simple (once the server is setup) to connect to Gnome and
KDE sessions, however connecting to other window managers (fluxbox,
xfce, whatever) is slightly different.

Choosing "custom" and using a command like startx of startfluxbox will
either result in a blank screen after the !M logo or the Client to
present an error complaining about lack of a X server. A way around this
is open a session with the command "startx", and the another with the
command to start your window-manager-of-choice.

If you do not want to do this, you can start X by installing a login
manager like SLIM or XDM. I would recomend using SLiM because of it's
small size.

(Authors note: This is how I got fluxbox, xfce and others to work on my
arch installation- however, I have now removed slim from inittab and set
the run level back to 3, and yet I can still login perfectly with
NXClient. Possibly try this if you get your system working this way, if
like me you have a low memory machine.)

-   -   The above information may not be true anymore. Once connection
        and authentication were valid (and xterm was installed on mine),
        startfluxbox was added to the custom command line, new window
        was selected, and it started right up. **

Alternative fix

A simple fix without resorting to the above seems to involve a simple
edit to the config file. This should work for fluxbox/openbox/xfce or
any other window manager that uses the .xinitrc startup file in a call
to startx.

Simply edit the config file (as root):

    /etc/nxserver/node.conf

and change

    #USER_X_STARTUP_SCRIPT=.Xclients

to

    USER_X_STARTUP_SCRIPT=.xinitrc

Remember to remove the # symbol from the start of the line.

Then in the client under configuration settings, choose Custom as the
desktop, and click on settings:

-   In the first group select -
    Run the default X client Script on server
-   In the second group select - New virtual desktop

Problems
--------

> Debug problems

Edit the nxserver config file:

     vi /etc/nxserver/node.conf

Change:

     #SESSION_LOG_CLEAN=1

to

     SESSION_LOG_CLEAN=0

Then you can look/debug the log files in:

     $HOME/.nx/T-C-<hostname>-<display>-<session-id>

For succesfull connections and:

     $HOME/.nx/F-C-<hostname>-<display>-<session-id>

For failed ones.

> Authentication OK, but connection fails

If you are trying to startkde

     vi /etc/nxserver/node.conf

And search for:

     COMMAND_START_KDE=startkde

Replace for:

     COMMAND_START_KDE=/usr/bin/startkde

> Key changes

Change the key in GUI setup to new generated key.

> Xorg 7

Be aware that you have to remove the /usr/X11R6 directory, else strange
things can happen.

> Wrong password / No connection possible / Key-based authentication

-   If you have changed your ssh daemon to run on an alternate port, be
    sure to modify SSHD_PORT within /etc/nxserver/node.conf.

-   If you get always wrong password or no connection after
    authentication was done and you are sure that you typed it correct,
    check that your server can connect to itself using localhost by ssh.

-   If you messed up your key files, create new ones or fix the old
    ones, it's probably caused by a wrong known_hosts file.

-   If you get wrong password or login, put
    ENABLE_PASSDB_AUTHENTICATION="1" in /etc/nxserver/node.conf and add
    a user by

    # /usr/bin/nxserver --adduser [username]
    # /usr/bin/nxserver --passwd [username]

-   The above commands are also necessary if you have disabled password
    authentication in ssh and instead are using key-based
    authentication.

> NX Crashes on session startup

If your NX Client shows the NX logo then disappears with a Connection
Problem dialog afterwards.

Missing Fonts

Then it could be due to missing fonts. Mostly applies if you have
installed Arch Linux base and then installed freenx after without the
whole X11 set.

Solution until FreeNX Dependencies is fixed is to install
xorg-fonts-misc on your NX Server (pacman -S xorg-fonts-misc) and your
NX should work.

Note: This does not apply to freenx 0.6.1-3 and above, fix has been
incorporated in it and following versions.

Awesome WM

Using the window manager Awesome does not work with FreeNX. The bug
report can be found at FS#844 - Awesome does not work with FreeNX.
Troubleshoot with another desktop environment/window manager.

> NX logo then blank screen

If you see the NX logo (!M) then a blank screen.

This problem can be solved by running a login manager- The problem is
that X11 is not started, and it appears that "startx" or similar do not
work from the freenx client. Follow these instructions to setup a login
manager and load it at startup: Display Manager

Blind: If this does not resolve your issues, be aware that freenx and
bash_completion do not play well together. I only got things to work
after removing bash_completion from the .bashrc.

> GDM/XDM Session Menu Error with non-KDE or Gnome Desktop Managers (more common with non-Arch Linux users)

Problem: A session menu comes up talking about
"chooseSessionListWidget." A window manager never loads.

Fix :

Double check to see if ~/.xinitrc is executable.

     ls -la ~/ | grep .xinitrc

If the file is not executable, simply

     chmod +x ~/.xinitrc

Keep in mind this command should be executed along with pertinent
instructions on this page about "Setting up non-KDE or Gnome desktop
managers"

> Cannot connect because command sessreg not found

If you get the following error while connecting

     /usr/bin/nxserver: line 941: sessreg: command not found
     NX> 280 Exiting on signal: 15

then you have to install the package xorg-server-utils.

> Broken resume with Cairo 1.12.x

Latest cairo updates broke the render extension. After resuming a
session all characters from before suspending won't get rendered. To fix
this add this single line to /etc/nxserver/node.conf

     AGENT_EXTRA_OPTIONS_X="-norender"

> eclipse crashes when editing a file

     The program 'Eclipse' received an X Window System error.
     This probably reflects a bug in the program.
     The error was 'BadValue (integer parameter out of range for operation)'.
     (Details: serial 8414 error_code 2 request_code 149 minor_code 26)

Start eclipse using (see
https://bugs.eclipse.org/bugs/show_bug.cgi?id=386955):

     eclipse -vmargs -Dorg.eclipse.swt.internal.gtk.cairoGraphics=false

Retrieved from
"https://wiki.archlinux.org/index.php?title=FreeNX&oldid=236469"

Categories:

-   Networking
-   Secure Shell
-   X Server
