X11vnc
======

> Summary

x11vnc allows one to view remotely and interact with real X displays
(i.e. a display corresponding to a physical monitor, keyboard, and
mouse) with any VNC viewer. In this way it plays the role for Unix/X11
that WinVNC plays for Windows.

Related Articles

Vncserver - Remote display server that allows users to run parallel
sessions while NOT controlling the root display.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Setting up x11vnc                                                  |
|     -   1.1 Installation                                                 |
|     -   1.2 Starting                                                     |
|         -   1.2.1 Setting X authority                                    |
|             -   1.2.1.1 Start X                                          |
|             -   1.2.1.2 GDM                                              |
|             -   1.2.1.3 SLIM                                             |
|             -   1.2.1.4 LXDM                                             |
|                                                                          |
|         -   1.2.2 Setting a password                                     |
|         -   1.2.3 Running constantly                                     |
|                                                                          |
|     -   1.3 Accessing                                                    |
|                                                                          |
| -   2 SSH Tunnel                                                         |
| -   3 Troubleshooting                                                    |
+--------------------------------------------------------------------------+

Setting up x11vnc
-----------------

> Installation

x11vnc is available in the official repositories.

> Starting

First, start X either by startx or through a manager such as GDM or
SLiM. Then, open a terminal and type

    $ x11vnc -display :0

Another option is to place the x11vnc line in a script which is called
at login.

    #!/bin/bash
    /usr/bin/x11vnc -nap -wait 50 -noxdamage -passwd PASSWORD -display :0 -forever -o /var/log/x11vnc.log -bg

Note:The password "PASSWORD" above is not secured; anyone who can run ps
on the machine will see it. Also note that /var/log/x11vnc.log needs to
be created manually and its ownership needs to match that of the user
who will run it.

Setting X authority

You may set an X authority file for the VNC server. This is accomplished
by using the -auth argument followed by the appropriate file, which will
depend on how your X server was started. Generally, assigning an X
authority file requires running x11vnc as root.

Start X

    $ x11vnc -display :0 -auth ~/.Xauthority

If that fails, you may have to run (as root)

    $ x11vnc -display :0 -auth /home/USER/.Xauthority

Where USER is the username of the user who is running the X server.

GDM

    # x11vnc -display :0 -auth /var/lib/gdm/:0.Xauth

OR see Troubleshooting section below

SLIM

    # x11vnc -display :0 -auth /var/run/slim.auth

Warning:This will set up VNC with NO PASSWORD. This means that ANYBODY
who has access to the network the computer is on CAN SEE YOUR XSERVER.
It is a fairly simple matter to tunnel your VNC connection through SSH
to avoid this. Or, simply set a password, as described below.

Note:The password will only encrypt the login process itself. The
transmission is still unencrypted[1].

LXDM

    # x11vnc -display :0 -auth /var/run/lxdm/lxdm-\:0.auth

Setting a password

    $ mkdir ~/.x11vnc
    $ x11vnc -storepasswd password ~/.x11vnc/passwd

To connect using the stored password use the -rfbauth argument and point
to the passwd file you created, like so:

    $ x11vnc -display :0 -rfbauth ~/.x11vnc/passwd 

Your viewer should prompt for a password when connecting.

Running constantly

By default, x11vnc will accept the first VNC session and shutdown when
the session disconnects. In order to avoid that, start x11vnc with the
-many or -forever argument, like this:

    $ x11vnc -many -display :0

or

    $ x11vnc -forever -display :0

> Accessing

Get a VNC client on another computer, and type in the IP address of the
computer running x11vnc. Hit connect, and you should be set.

If you are attempting to access a VNC server / computer (running x11vnc)
from outside of its network then you will need to ensure that it has
port 5900 forwarded.

SSH Tunnel
----------

You need to have SSH installed and configured.

Use the -localhost flag to x11vnc to have it bind to the local
interface. Once that is done, you can use SSH to tunnel the port, and
then connect to VNC through SSH. (I have not tried this) (confirmed
working for me, thanks --bloodniece)

Simple example (from
http://www.karlrunge.com/x11vnc/index.html#tunnelling ):

    $ ssh -t -L 5900:localhost:5900 remote_host 'sudo x11vnc -display :0 -auth /home/USER/.Xauthority'

where USER is the username of the user who is running the X server.

(you will likely have to provide passwords/passphrases to login from
your current location into your remote_host Unix account; we assume you
have a login account on remote_host and it is running the SSH server)

And then in another terminal window on your current machine run the
command:

    $ vncviewer -encodings "copyrect tight zrle hextile" localhost:0

Troubleshooting
---------------

1. You can check your ip address and make sure port 5900 is forwarded by
visiting this website.

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

2. Tested only on GNOME + GDM

If you cannot start the tunnel, and get error like XOpenDisplay(":0")
failed, Check if you have a ~/.Xauthority directory. If that does not
exist, You can create one easily (Actually a symlink to actual one) by
running command given below as normal user NOT ROOT OR USING Sudo as
below:

    $ ln -sv `dirname $(xauth info | awk '/Authority file/{print $3}')` /home/`whoami`/.Xauthority

then try above tunneling example and it should work fine. Further if you
want this to be automatically done each time Xorg is restarted, create
the Xprofile file & make is executable as below

    $ ln -sf `dirname $(xauth info | awk '/Authority file/{print $3}')` /home/[ENTER_USERNAME_HERE]/.Xauthority

3.GNOME 3 and x11vnc

If you are using GNOME 3 and x11vnc and you get the following errors

    *** XOpenDisplay failed (:0) 

    *** x11vnc was unable to open the X DISPLAY: ":0", it cannot continue.

Try running x11vnc like

    $ x11vnc -noxdamage -many -display :0 -auth /var/run/gdm/`sudo ls /var/run/gdm | grep \`whoami\``/database -forever -bg

Please update if this works / not works for any other display manager or
desktop environment.

4. Screensaver problem

If screensaver starts every 1-2 second, start x11vnc with -nodpms key.

Retrieved from
"https://wiki.archlinux.org/index.php?title=X11vnc&oldid=246383"

Categories:

-   Security
-   Virtual Network Computing
