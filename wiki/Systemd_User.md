systemd/User
============

> Summary

Covers how to set up systemd user sessions.

> Related

systemd

systemd offers users the ability to run an instance of systemd to manage
their session and services. This allows users to start, stop, enable,
and disable units found within certain directories when systemd is run
by the user. This is convenient for daemons and other services that are
commonly run as a user other than root or a special user, such as mpd.

Note:systemd --user sessions are not compatible with -ck patchset

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Setup                                                              |
|     -   1.1 startx                                                       |
|     -   1.2 Display Managers                                             |
|         -   1.2.1 GNOME 3 (using GDM)                                    |
|                                                                          |
|     -   1.3 Using systemd --user To Manage Your Session                  |
|     -   1.4 Auto-login                                                   |
|     -   1.5 Other use cases                                              |
|         -   1.5.1 Persistent terminal multiplexer                        |
|             -   1.5.1.1 Starting X                                       |
|                                                                          |
| -   2 User Services                                                      |
|     -   2.1 Installed by packages                                        |
|     -   2.2 Example                                                      |
|     -   2.3 Example with variables                                       |
|     -   2.4 Note about X applications                                    |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Setup
-----

> startx

Note:This step is unnecessary if you plan to use autologin.

Users should first set up systemd-logind to manage their session. If
systemd is running as the system init daemon, then this is already
happening.

Next, the user must launch systemd by putting the following in their
~/.xinitrc.

    systemd --user

If the user is not launching the window manager through systemd --user,
then

    systemd --user &

should be used and launched like anything else in ~/.xinitrc, before
execing the window manager.

After starting X, the user can check whether their session is now being
managed by systemd-logind with the following command:

    $ loginctl --no-pager show-session $XDG_SESSION_ID | grep Active

If this command prints Active=yes, then the user is now using
systemd-logind to manage their session. The user should remove any
instances of ck-launch-session or dbus-launch from their ~/.xinitrc, as
those commands are unneeded.

> Display Managers

All of the major display managers are now using systemd-logind by
default, so the loginctl command from the previous section should work
as stated. A user simply has to add systemd --user as a program to be
started by their desktop environment.

GNOME 3 (using GDM)

For users who wish to have GDM/GNOME 3 auto-start their systemd --user
session upon login, they just need to add a special log in session for
this:

    /usr/share/xsessions/gnome-systemd.desktop

    [Desktop Entry]
    Type=Application
    Name=systemd
    Comment=Runs 'systemd' as a user instance.
    Exec=/usr/lib/systemd/systemd --user

Make sure to choose the systemd session option at the GDM login screen.

Note:This has only been tested with a pure GDM and GNOME 3 setup. For
other set ups, YYMV. This method does not need the systemd user-session
scripts installed.

> Using systemd --user To Manage Your Session

Systemd has many amazing features, one of which is the ability to track
programs using cgroups (by running systemctl status). While awesome for
a pid 1 process to do, it is also extremely useful for users, and having
it set up and initialize user programs, all the while tracking what is
in each cgroup is even more amazing.

All of your systemd user units will go to $HOME/.config/systemd/user.
These units take precedence over units in other systemd unit
directories.

There are two packages you need to get this working, both currently
available from the AUR: xorg-launch-helper and optionally,
user-session-units if you want to have autologin working.

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

Link this unit to default.target. When you start systemd --user, it will
start this target.

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
$HOME/.config/systemd/user/wm.target.wants/i3.service, allowing it to be
started at login. Is recommended enabling this service, not linking it
manually.

You can fill your user unit directory with a plethora of services,
including ones for mpd, gpg-agent, offlineimap, parcellite, pulse, tmux,
urxvtd, xbindkeys and xmodmap to name a few.

> Auto-login

If you want to have systemd automatically log you in on boot, then you
can use the unit in user-session-units to do so. Enabling a screen
locker for will stop someone from booting your computer into a nice,
logged in session.

If you installed user-session-units as listed above, then you must copy
/usr/lib/systemd/system/user-session@.service to
/etc/systemd/system/user-session@yourloginname.service) and edit these
lines:

    Environment=XDG_RUNTIME_DIR=/run/user/%I
    Environment=DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%I/dbus/user_bus_socket

to this:

    Environment=XDG_RUNTIME_DIR=/run/user/%U
    Environment=DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%U/dbus/user_bus_socket

Note:Notice the subtle change where %I is replaced by %U

As well as an install section:

    [Install]
    WantedBy=graphical.target

or if you have no login manager:

    [Install]
    WantedBy=getty.target

Add this line to /etc/pam.d/login and /etc/pam.d/system-auth:

    session    required    pam_systemd.so

Because user-session@.service starts on tty1, you will need to add
Conflicts=getty@tty1.service to the service file, if it doesn't exist
already. Alternately, you can have it run on tty7 instead by modifying
TTYPath accordingly as well as the ExecStart line in xorg.service
(cp /usr/lib/systemd/user/xorg.service /etc/systemd/user/ and make the
modifications there).

Once this is done, systemctl --user enable YOUR_WM.service

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

See also
--------

-   gtmanfred's guide - the original guide[dead link 2013-04-12]
-   KaiSforza's bitbucket wiki
-   Collection of useful systemd user units
-   More systemd user units

Retrieved from
"https://wiki.archlinux.org/index.php?title=Systemd/User&oldid=255254"

Categories:

-   Daemons and system services
-   Boot process
