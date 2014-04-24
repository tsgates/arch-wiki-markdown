systemd/User
============

Related articles

-   systemd
-   Automatic login to virtual console
-   Start X at Login

systemd offers users the ability to run an instance of systemd to manage
their session and services. This allows users to start, stop, enable,
and disable units found within certain directories when systemd is run
by the user. This is convenient for daemons and other services that are
commonly run as a user other than root or a special user, such as mpd.

Contents
--------

-   1 Setup since systemd 206
    -   1.1 D-Bus
    -   1.2 Automatic login into Xorg without display manager
    -   1.3 Automatic start-up of systemd user instances
-   2 Setup
    -   2.1 Using /usr/lib/systemd/systemd --user To Manage Your Session
    -   2.2 Auto-login
    -   2.3 Other use cases
        -   2.3.1 Persistent terminal multiplexer
            -   2.3.1.1 Starting X
-   3 User Services
    -   3.1 Installed by packages
    -   3.2 Example
    -   3.3 Example with variables
    -   3.4 Note about X applications
-   4 See also

Setup since systemd 206
-----------------------

Note:User sessions are in development, have some missing features and
are not yet supported upstream. See [1] and [2] for some details on the
current state of affairs.

Since version 206, the mechanism for systemd user instances has changed.
Now the pam_systemd.so module launches a user instance by default on the
first login of an user, by starting user@.service. In its current state
there are some differences with respect to previous systemd versions,
that one must be aware of:

-   The systemd --user instance runs outside of any user session. This
    is ok for running, say mpd, but may be annoying if one tries to
    start a window manager from the systemd user instance. Then polkit
    will prevent from mounting usb's, rebooting, etc. as an unprivileged
    user, because the window manager is running outside of the active
    session.
-   The units in the user instance do not inherit any environment, so it
    must be set manually.
-   user-session@.service from user-session-units is obsolete now.

Steps to use user instance units:

1. Make sure the systemd user instance starts properly. You can check if
it is there with

    systemctl --user status

Since systemd 206 there should be a systemd user instance running by
default, which is started in the pam_systemd.so pam module for the first
login of a user.

Note:/etc/pam.d/system-login must start pam_systemd.so: it should
contain -session   optional   pam_systemd.so; check if a .pacnew file
exists.

2. Add the environment variables you need in a config file for
user@.service. For example:

    /etc/systemd/system/user@.service.d/environment.conf

    [Service]
    Environment=DISPLAY=:0
    Environment=DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%I/bus

Note:Since systemd 209 we need to set DBUS_SESSION_BUS_ADDRESS manually.
On systemd 208 this variable was set by user@.service, but not anymore
since 209. The reason seems to be that once the transition to kdbus is
done, this variable will be set by pam_systemd.so.

3. Put your user units in ~/.config/systemd/user. When the user instance
starts, it launches the default target at
~/.config/systemd/user/default.target. After that, you can manage your
user units with systemctl --user.

> D-Bus

To use dbus in user units, create the following files:

    /etc/systemd/user/dbus.socket

    [Unit]
    Description=D-Bus Message Bus Socket
    Before=sockets.target

    [Socket]
    ListenStream=/run/user/%U/bus

    [Install]
    WantedBy=default.target

    /etc/systemd/user/dbus.service

    [Unit]
    Description=D-Bus Message Bus
    Requires=dbus.socket

    [Service]
    ExecStart=/usr/bin/dbus-daemon --session --address=systemd: --nofork --nopidfile --systemd-activation
    ExecReload=/usr/bin/dbus-send --print-reply --session --type=method_call --dest=org.freedesktop.DBus / org.freedesktop.DBus.ReloadConfig

Note:Since systemd 209 systemd-run seems to use a hardcoded bus socket,
ignoring DBUS_SESSION_BUS_ADDRESS. Using the path /run/user/%U/bus for
the user dbus socket solves the issue. This is the path kdbus will be
using.

Activate the socket by running

    # systemctl --global enable dbus.socket

> Automatic login into Xorg without display manager

You need to have #D-Bus correctly set up and xlogin-git installed.

Set up your xinitrc from the skeleton, so that it will source the files
in /etc/X11/xinit/xinitrc.d/. Running your ~/.xinitrc should not return,
so either have wait as the last command, or add exec to the last command
that will be called and which should not return (your window manager,
for instance).

The session will use its own dbus daemon, but various systemd utilities
need the dbus.service instance. Possible solution to this is to create
aliases for such commands:

    ~/.bashrc

    for sd_cmd in systemctl systemd-analyze systemd-run; do
        alias $sd_cmd='DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/dbus/user_bus_socket" '$sd_cmd
    done

Finally, enable (as root) the xlogin service for automatic login at
boot:

    # systemctl enable xlogin@username

The user session lives entirely inside a systemd scope and everything in
the user session should work just fine.

> Automatic start-up of systemd user instances

The systemd user instance is by default run after the first login of a
user, but sometimes it may be useful to start it right after boot.
Lingering is used to spawn the systemd user instance at boot and keep it
running after logouts.

Warning:systemd services are not sessions, they run outside of logind.
Do not use lingering to enable automatic login as it will break the
session.

Use the following command to enable lingering for specific user:

    # loginctl enable-linger username

Setup
-----

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: After systemd    
                           206, systemd --user      
                           mechanism has changed.   
                           (See [[3]], [[4]],       
                           [[5]]) (Discuss)         
  ------------------------ ------------------------ ------------------------

> Using /usr/lib/systemd/systemd --user To Manage Your Session

Systemd has many amazing features, one of which is the ability to track
programs using cgroups (by running systemctl status). While awesome for
a pid 1 process to do, it is also extremely useful for users, and having
it set up and initialize user programs, all the while tracking what is
in each cgroup is even more amazing.

All of your systemd user units will go to $HOME/.config/systemd/user.
These units take precedence over units in other systemd unit
directories.

There are two packages you need to get this working, both currently
available from the AUR: systemd-xorg-launch-helper-git and optionally,
systemd-user-session-units-git if you want to have autologin working.

Next is setting up your targets. You should set up two, one for window
manager and another as a default target. The window manager target
should be populated like so:

    $HOME/.config/systemd/user/wm.target

    [Unit]
    Description=Window manager target
    Wants=xorg.target
    Wants=mystuff.target
    Requires=dbus.socket
    AllowIsolate=true

    [Install]
    Alias=default.target

This will be the target for your graphical interface.

Put together a second target called mystuff.target. All services but
your window manager should contain a WantedBy line, under [Install],
pointing at this unit.

    $HOME/.config/systemd/user/mystuff.target

    [Unit]
    Description=Xinitrc Stuff
    Wants=wm.target

    [Install]
    Alias=default.target

Create a symbolic link from this unit to default.target. When you start
/usr/lib/systemd/systemd --user, it will start this target.

Next you need to begin writing services. First you should throw together
a service for your window manager:

    $HOME/.config/systemd/user/YOUR_WM.service

    [Unit]
    Description=your window manager service
    Before=mystuff.target
    After=xorg.target
    Requires=xorg.target

    [Service]
    #Environment=PATH=uncomment:to:override:your:PATH
    ExecStart=/full/path/to/wm/executable
    Restart=always
    RestartSec=10
     
    [Install]
    WantedBy=wm.target

Note:The [Install] section includes a 'WantedBy' part. When using
systemctl --user enable it will link this as
$HOME/.config/systemd/user/wm.target.wants/YOUR_WM.service, allowing it
to be started at login. Is recommended enabling this service, not
linking it manually.

You can fill your user unit directory with a plethora of services,
including ones for mpd, gpg-agent, offlineimap, parcellite, pulse, tmux,
urxvtd, xbindkeys and xmodmap to name a few.

To exit your session, use systemctl --user exit.

> Auto-login

If you want to have systemd automatically log you in on boot, then you
can use the unit in user-session-units to do so. Enabling a screen
locker for will stop someone from booting your computer into a nice,
logged in session. Add this line to /etc/pam.d/login and
/etc/pam.d/system-auth:

    session    required    pam_systemd.so

Because user-session@.service starts on tty1, you will need to add
Conflicts=getty@tty1.service to the service file, if it doesn't exist
already. Alternately, you can have it run on tty7 instead by modifying
TTYPath accordingly as well as the ExecStart line in xorg.service
(cp /usr/lib/systemd/user/xorg.service /etc/systemd/user/ and make the
modifications there).

Once this is done, systemctl --user enable YOUR_WM.service

Note:One must be careful with tty's to keep the systemd session active.
Systemd sets a session as inactive when the active tty is different from
the one that the login took place. This means that the X server must be
run in the same tty as the login in user-session@.service. If the tty in
TTYPath does not match the one xorg is launched in, the systemd session
will be inactive from the point of view of your X applications, and you
will not be able to mount USB drives, for instance.

One of the most important things you can add to the service files you
will be writing is the use of Before= and After= in the [Unit] section.
These two parts will determine the order things are started. Say you
have a graphical application you want to start on boot, you would put
After=xorg.target into your unit. Say you start ncmpcpp, which requires
mpd to start, you can put After=mpd.service into your ncmpcpp unit. You
will eventually figure out exactly how this needs to go either from
experience or from reading the systemd manual pages. Starting with
systemd.unit(5) is a good idea.

> Other use cases

Persistent terminal multiplexer

You may wish your user session to default to running a terminal
multiplexer, such as GNU Screen or Tmux, in the background rather than
logging you into a window manager session. Separating login from X login
is most likely only useful for those who boot to a TTY instead of to a
display manager (in which case you can simply bundle everything you
start in with myStuff.target).

To create this type of user session, procede as above, but instead of
creating wm.target, create multiplexer.target:

    [Unit]
    Description=Terminal multiplexer
    Documentation=info:screen man:screen(1) man:tmux(1)
    After=cruft.target
    Wants=cruft.target

    [Install]
    Alias=default.target

cruft.target, like mystuff.target above, should start anything you think
should run before tmux or screen starts (or which you want started at
boot regardless of timing), such as a GnuPG daemon session.

You then need to create a service for your multiplexer session. Here is
a sample service, using tmux as an example and sourcing a gpg-agent
session which wrote its information to /tmp/gpg-agent-info. This sample
session, when you start X, will also be able to run X programs, since
DISPLAY is set.

    [Unit]
    Description=tmux: A terminal multiplixer Documentation=man:tmux(1)
    After=gpg-agent.service
    Wants=gpg-agent.service

    [Service]
    Type=forking
    ExecStart=/usr/bin/tmux start
    ExecStop=/usr/bin/tmux kill-server
    Environment=DISPLAY=:0
    EnvironmentFile=/tmp/gpg-agent-info

    [Install]
    WantedBy=multiplexer.target

Once this is done, systemctl --user enable tmux.service,
multiplexer.target and any services you created to be run by
cruft.target and you should be set to go! Activated
user-session@.service as described above, but be sure to remove the
Conflicts=getty@tty1.service from user-session@.service, since your user
session will not be taking over a TTY. Congratulations! You have a
running terminal multiplexer and some other useful programs ready to
start at boot!

Starting X

You have probably noticed that, since the terminal multiplexer is now
default.target, X will not start automatically at boot. To start X,
proceed as above, but do not activate or manually link to default.target
wm.target. Instead, assuming you are booting to a terminal, we will
simply be using a hack-ish workaround and masking /usr/bin/startx with a
shell alias:

    alias startx='systemctl --user start wm.target'

User Services
-------------

Users may now interact with units located in the following directories
just as they would with system services (ordered by ascending
precedence):

-   /usr/lib/systemd/user/
-   /etc/systemd/user/
-   ~/.config/systemd/user/

To control the systemd instance, the user must use the command
systemctl --user.

> Installed by packages

A unit installed by a package that is meant to be run by a systemd user
instance should install the unit to /usr/lib/systemd/user/. The system
adminstration can then modify the unit by copying it to
/etc/systemd/user/. A user can then modify the unit by copying it to
~/.config/systemd/user/.

> Example

The following is an example of a user version of the mpd service.

    mpd.service

    [Unit]
    Description=Music Player Daemon

    [Service]
    ExecStart=/usr/bin/mpd --no-daemon

    [Install]
    WantedBy=default.target

> Example with variables

The following is an example of a user version of sickbeard.service,
which takes into account variable home directories where SickBeard can
find certain files:

    sickbeard.service

    [Unit]
    Description=SickBeard Daemon

    [Service]
    ExecStart=/usr/bin/env python2 /opt/sickbeard/SickBeard.py --config %h/.sickbeard/config.ini --datadir %h/.sickbeard

    [Install]
    WantedBy=default.target

As detailed in man systemd.unit, the %h variable is replaced by the home
directory of the user running the service. There are other variables
that can be taken into account in the systemd manpages.

> Note about X applications

Most X apps need a DISPLAY variable to run (so it's likely the first
reason why your service files aren't starting), so you have to make sure
to include it:

    $HOME/.config/systemd/user/parcellite.service

    [Unit]
    Description=Parcellite clipboard manager

    [Service]
    ExecStart=/usr/bin/parcellite
    Environment=DISPLAY=:0 # <= !

    [Install]
    WantedBy=mystuff.target

A simpler way, if using user-session-units, is to define it in
user-session@yourloginname.service so it's inherited. Add
Environment=DISPLAY=:0 to the [Service] section. Another helpful
environment variable to set here is SHELL.

A cleaner way though, is to not hard code the DISPLAY environment
variable (specially if you run more than on display):

    $HOME/.config/systemd/user/x-app-template@.service

    [Unit]
    Description=Your amazing and original description

    [Service]
    ExecStart=/full/path/to/the/app
    Environment=DISPLAY=%i # <= !

    [Install]
    WantedBy=mystuff.target

Then you can run it with:

    systemctl --user {start|enable} x-app@your-desired-display.service # <= :0 in most cases

Some X apps may not start up because the display socket is not available
yet. This can be fixed by adding something like

    $HOME/.config/systemd/user/x-app-template@.service

    [Unit]
    After=xorg.target
    Requires=xorg.target

    ...

to your units (the xorg.target is part of xorg-launch-helper).

See also
--------

-   KaiSforza's bitbucket wiki
-   Zoqaeski's units on Github
-   Collection of useful systemd user units
-   More systemd user units
-   Forum thread about changes in systemd 206 user instances

Retrieved from
"https://wiki.archlinux.org/index.php?title=Systemd/User&oldid=303185"

Categories:

-   Daemons and system services
-   Boot process

-   This page was last modified on 4 March 2014, at 22:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
