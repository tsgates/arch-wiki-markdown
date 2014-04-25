Xdmcp
=====

This page intends to allow remote sessions using "X Display Manager
Control Protocol" (XDMCP). See the GDM documention for more information
on the parameters:
http://library.gnome.org/admin/gdm/3.6/configuration.html.en#xdmcpsection.

Contents
--------

-   1 Setup Graphical Logins
    -   1.1 XDM
    -   1.2 GDM
    -   1.3 KDM
    -   1.4 LightDM
    -   1.5 SLiM
-   2 Accessing X from a remote Machine on your LAN
-   3 Thin client setup
    -   3.1 Example GUI-based Clients
-   4 Troubleshooting
    -   4.1 XDMCP fatal error: Manager unwilling Host unwilling
    -   4.2 Session declined: Maximum Number of Sessions Reached
    -   4.3 If you still cannot log in remotely
    -   4.4 Login screen and GNOME is somehow flickering

Setup Graphical Logins
----------------------

> XDM

Modify /etc/X11/xdm/xdm-config and comment out:

    DisplayManager.requestPort:    0

So it will be:

    !DisplayManager.requestPort:    0

Then modify /etc/X11/xdm/Xaccess to allow any host to get a login
window. Look for a line that looks like this:

    *             #any host can get a login window

and remove the hash '#' sign at the beginning of the line.

In case you have multiple network interfaces also add a line like this:

    LISTEN 192.168.0.10

Where 192.168.0.10 should be you server IP address.

Then reboot or restart your X server and xdm daemon.

> GDM

Modify /etc/gdm/custom.conf to include:

    [xdmcp]
    Enable=true
    Port=177

Then restart the Gnome Display Manager:

    systemctl restart gdm

Or if using the inittab method, login as root on another tty and

    telinit 3
    telinit 5 && exit 

> KDM

Support for this feature seems to be very buggy. Lightdm is probably an
easier choice.

Edit kdmrc ( /opt/kde/share/config/kdm/kdmrc [KDE 3x] or
/usr/share/config/kdm/kdmrc (KDE 4x] ) and at the end there should be
something like this:

    [Xdmcp]
    Enable=true

Then you need to restart your X server so the change you just made takes
effect:

    systemctl restart kdm

> LightDM

Modify /etc/lightdm/lightdm.conf to include:

    [XDMCPServer]
    enabled=true
    port=177

Then restart the LightDM:

    systemctl restart lightdm

> SLiM

SLiM doesn't support Xdmcp.

Accessing X from a remote Machine on your LAN
---------------------------------------------

You can access your login manager on the network computer 192.168.0.10
via the following command. TCP and UDP streams are opened. So it is not
possible to access the login manager via an SSH connection.

    Xnest -query 192.168.0.10 -geometry 1280x1024 :1

Or, with Xephyr, if you experience refreshing problems with Xnest:

    Xephyr -query 192.168.0.10 -screen 1280x1024 -br -reset -terminate :1

Or, if you are on runlevel 3

    X -query your_server_ip

Xserver should recognize your monitor and set appropriate resolution.

  

Note:You can enable XDMCP Direct/Query and Broadcast connections from
remote hosts without XDM starting a local X server.

After allowing XDMCP access as described above, edit
/etc/X11/xdm/Xservers and comment out:

    #:0 local /usr/bin/X :0

Then launch XDM as root, e.g.
xdm -config /etc/X11/xdm/archlinux/xdm-config

Thin client setup
-----------------

First of all one should setup dhcp and tftp server. Dnsmasq has both of
them. For network boot image check thinstation project. If your network
card does not support PXE, you can try Etherboot

> Example GUI-based Clients

-   community/remmina
-   Xming for Windows

Troubleshooting
---------------

> XDMCP fatal error: Manager unwilling Host unwilling

This is usually caused by an entry missing from the
/etc/kde3/kdm/Xaccess file. This file controls which machines can
connect to the server via KDM. The trick is to add a line that starts
with an asterisk '*'. Look for a line that looks like:

    # *                                     #any host can get a login window

and remove the hash '#' sign at the beginning of the line. Then, you
need to restart KDM.

    /etc/rc.d/kdm restart

> Session declined: Maximum Number of Sessions Reached

Edit /etc/gdm/custom.conf and add/increase the maximum sessions.

    [xdmcp]
    Enable=true
    MaxSessions=2

> If you still cannot log in remotely

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Arch Linux has   
                           moved to systemd and has 
                           no initscripts anymore.  
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

...and you see only a black screen, try removing the -nodaemon option in
/etc/inittab to have only

    x:5:respawn:/usr/sbin/gdm

> Login screen and GNOME is somehow flickering

If the login screen is created again and again and unresponsive, you are
trying to access GNOME Shell on the remote machine. This is apparently
caused by network speed, e.g. by accessing via wireless connections. The
workaround is to disable/deinstall GNOME Shell.

     pacman -R gnome-shell

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xdmcp&oldid=271557"

Category:

-   X Server

-   This page was last modified on 18 August 2013, at 07:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
