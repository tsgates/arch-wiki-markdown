Activating Numlock on Bootup
============================

Contents
--------

-   1 Console
    -   1.1 Using a separate service
    -   1.2 Extending getty@.service
    -   1.3 Bash alternative
-   2 X.org
    -   2.1 startx
    -   2.2 KDM
    -   2.3 KDE4 Users
        -   2.3.1 Alternate Method
        -   2.3.2 Alternate Method 2
    -   2.4 GDM
    -   2.5 GNOME
    -   2.6 SLiM
    -   2.7 OpenBox

Console
-------

> Using a separate service

Install the package systemd-numlockontty from the AUR.

Now you should enable the numLockOnTty daemon. Read Daemons for more
details.

> Extending getty@.service

This is simpler than using a separate service (especially since
systemd-198) and does not hardcode the number of VTs in a script. Create
a directory for drop-in configuration files:

    # mkdir /etc/systemd/system/getty@.service.d

Now add the following file in this directory.

    activate-numlock.conf

    [Service]
    ExecStartPost=/bin/sh -c 'setleds +num < /dev/%I'

> Bash alternative

Add setleds -D +num to ~/.bash_profile. Note that, unlike the other
methods, this will not take effect until after you log in.

X.org
-----

Various methods are available.

> startx

Install the numlockx package and add it to the ~/.xinitrc file before
exec:

    #!/bin/sh
    #
    # ~/.xinitrc
    #
    # Executed by startx (run your window manager from here)
    #

    numlockx &

    exec window_manager

> KDM

If you use KDM as a login manager, add:

    numlockx on

to the /usr/share/config/kdm/Xsetup, or the
/opt/kde/share/config/kdm/Xsetup for KDM3.

Note that this file will be overwritten on update without creating a
.pacnew file. To prevent this, add the following line to
/etc/pacman.conf file (omit the leading slash in the path):

    NoUpgrade = usr/share/config/kdm/Xsetup

> KDE4 Users

Go to System Settings, under the Hardware/Input Devices/Keyboard item
you will find an option to select the behavior of NumLock.

Alternate Method

Alternatively, add the script the ~/.kde4/Autostart/numlockx.sh
containing:

    #!/bin/sh
    numlockx on

And make it executable:

    $ chmod +x ~/.kde4/Autostart/numlockx.sh

Alternate Method 2

This method enables num lock in KDM login screen (e.g. numeric password)

1) Disable "Themed Greeter" in System Settings -> Login Screen

2) in file /usr/share/config/kdm/kdmrc find section

     [X-*-Greeter]

Right after that line, add this:

     NumLock=On

> GDM

First make sure that you have numlockx (from extra) installed then add
the following code to /etc/gdm/Init/Default:

    if [ -x /usr/bin/numlockx ]; then
          /usr/bin/numlockx on
    fi

> GNOME

When not using the GDM login manager, numlockx can be added to GNOME's
start-up applications.

Install numlockx from the official repositories. Then, add a start-up
command to launch numlockx.

    $ gnome-session-properties

The above command opens the Startup Applications Preferences applet.
Click Add and enter the following:

  ---------- ----------------------
  Name:      Numlockx
  Command:   /usr/bin/numlockx on
  Comment:   Turns on numlock.
  ---------- ----------------------

Note:This is not a system-wide change, repeat these steps for each user
wishing to activate NumLock after logging in.

> SLiM

In the file /etc/slim.conf find the line and uncomment it (remove the
#):

    #numlock             on

> OpenBox

In the file ~/.config/openbox/autostart add the line:

    numlockx &

And then save the file.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Activating_Numlock_on_Bootup&oldid=305919"

Categories:

-   Boot process
-   Keyboards

-   This page was last modified on 20 March 2014, at 17:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
