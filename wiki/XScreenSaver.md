XScreenSaver
============

XScreenSaver is a screen saver and locker for the X Window System.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing XScreenSaver                                            |
| -   2 Configuring XScreenSaver                                           |
|     -   2.1 DPMS settings                                                |
|                                                                          |
| -   3 Starting XScreenSaver                                              |
|     -   3.1 Single-User Systems                                          |
|     -   3.2 Multi-User Systems                                           |
|                                                                          |
| -   4 Lock Screen                                                        |
|     -   4.1 Automatically lock when suspending/sleeping/hibernating      |
|                                                                          |
| -   5 Disabling XScreenSaver for Media Applications                      |
|     -   5.1 MPlayer                                                      |
|     -   5.2 XBMC                                                         |
|     -   5.3 Adobe Flash/MPlayer/VLC                                      |
|                                                                          |
| -   6 Using XScreenSaver as animated wallpaper                           |
|     -   6.1 XScreenSaver as wallpaper under xcompmgr                     |
|                                                                          |
| -   7 Theming                                                            |
| -   8 User switching from the lock screen                                |
|     -   8.1 LXDM                                                         |
|     -   8.2 Lightdm                                                      |
|     -   8.3 KDM                                                          |
|     -   8.4 SLIM                                                         |
|                                                                          |
| -   9 See Also                                                           |
+--------------------------------------------------------------------------+

Installing XScreenSaver
-----------------------

Install the xscreensaver package found in the official repositories.

Alternatively, there is a patched version with the Arch Linux logo in
the AUR named xscreensaver-arch-logo. Running this package instead of
the one available in the official repositories is advantageous for
several reasons:

1.  Since makepkg is compiling it from source code, the resulting
    package will contain processor-specific optimizations unique to your
    specific system -- assuming you set up your /etc/makepkg.conf with
    the appropriate CFLAGS and CXXFLAGS.
2.  This package is Arch-branded (screensavers, lock screen, etc.)
3.  If running GNOME, this package will provide an icon to enter the
    XScreenSaver preferences under System>Preferences>Screensaver
    whereas the package in the official repositories does not.

Configuring XScreenSaver
------------------------

Global options are defined in /usr/share/X11/app-defaults/XScreenSaver.
Under a standard setup, there is likely no need to edit this file.
Instead most options are configured on a user-by-user basis simply by
running xscreensaver-demo

    $ xscreensaver-demo

> DPMS settings

XScreenSaver manages display energy saving (DPMS) independently of X
itself and overrides it. To configure the timings for standby, display
poweroff and such, use xscreensaver-demo or edit the configuration file
manually, e.g. ~/.xscreensaver,

    timeout:	1:00:00
    cycle:		0:05:00
    lock:		False
    lockTimeout:	0:00:00
    passwdTimeout:	0:00:30
    fade:		True
    unfade:		False
    fadeSeconds:	0:00:03
    fadeTicks:	20
    dpmsEnabled:	True
    dpmsStandby:	2:00:00
    dpmsSuspend:	2:00:00
    dpmsOff:	4:00:00

Starting XScreenSaver
---------------------

> Single-User Systems

Simply installing the xscreensaver package is not enough to have it run
automatically. The xscreensaver program has to be started, which is
commonly done by the desktop environment via a line in ~/.xinitrc as
follows:

    /usr/bin/xscreensaver -no-splash &

The ampersand & argument makes the xscreensaver program run in the
background and is required.

Note:XScreenSaver is automatically started by Xfce in
/etc/xdg/xfce4/xinitrc, to ensure it gets executed use startxfce4 and
not xfce4-session.

    exec startxfce4 --with-ck-launch

> Multi-User Systems

If operating with multiple users with a display manager (e.g. SLiM, GDM,
KDM) it is best to start XScreenSaver via the desktop manager's native
screensaver interface. This allows full management of user switching.
For example, if using GNOME, install gnome-screensaver and xscreensaver
but only have gnome-screensaver active. This allows for all the
screensavers to be selected, and keep the ability for user switching in
the event that one user has the screen locked, and another user wants to
"switch users" to he/she can access to the box.

Note:Some XScreenSaver native functionality will be lost such as the
ability to capture a screen, use photos in a pre-defined path, and/or
display custom texts when running the DM's native screensaver with a
subset of XScreenSaver's offerings (for example, Flipscreen3D,
photopile, etc.)

Another option to retain multi-user support, without having to install a
second screensaver, is to modify either ~/.xscreensaver for per-user
settings, or /usr/share/X11/app-defaults/XScreenSaver for global
settings, and add the following line.

    newLoginCommand: /usr/bin/gdmflexiserver

Note:The command given is for GDM; if you are using a different login
manager, you will need to replace it with your preferred login manager's
command.

Lock Screen
-----------

You may immediately trigger xscreensaver, if it is running, and lock the
screen with the following command:

    $ xscreensaver-command --lock

> Automatically lock when suspending/sleeping/hibernating

Install xuserrun-git from AUR, and create the following file:

    /etc/systemd/system/xscreensaver.service

    [Unit]
    Description=Lock X session using xscreensaver
    Before=sleep.target

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/xuserrun /usr/bin/xscreensaver-command -lock

    [Install]
    WantedBy=sleep.target

and enable it with

    # systemctl enable xscreensaver

You may want to set XScreenSaver's fade out time to 0.

Disabling XScreenSaver for Media Applications
---------------------------------------------

> MPlayer

Add the following to ~/.mplayer/config

    heartbeat-cmd="xscreensaver-command -deactivate >&- 2>&- &"

> XBMC

There is no native support within XBMC to disable XScreenSaver (although
XBMC does come with its own screensaver). The AUR contains a tiny app
called xbmc_prevent_xscreensaver does just this.

> Adobe Flash/MPlayer/VLC

There is no native way to disable XScreenSaver for flash, but there is
script named lightsOn that works great and has support for Firefox's
Flash plugin, Chromium's Flash plugin, MPlayer, and VLC.

Using XScreenSaver as animated wallpaper
----------------------------------------

You can run xscreensaver in the background, just like a wallpaper.
First, kill any process that is controlling the background (the root
window). Locate the desired XScreenSaver executable (they are usually on
/usr/lib/xscreensaver/) and run it with the -root flag, like this

    $ /usr/lib/xscreensaver/glslideshow -root &

> XScreenSaver as wallpaper under xcompmgr

xcompmgr may cause problems, so you need to use xwinwrap to run it in
order to use it as wallpaper. You can find it as shantz-xwinwrap-bzr in
the AUR.

Run it with the following command:

    $ xwinwrap -b -fs -sp -fs -nf -ov  -- /usr/lib/xscreensaver/glslideshow -root -window-id WID &

Theming
-------

XScreenSaver's unlock screen can be themed with X resources (see:
XScreenSaver resources).

User switching from the lock screen
-----------------------------------

By default, xscreensaver's "New Login" button in the lock screen will
call /usr/bin/gdmflexiserver to allow for user switching. This is fine
if using gdm or kdm. Other display managers such as lightdm and lxdm
support this functionality as well.

> LXDM

Simply paste the following into ~/.xscreensaver to use LXDM's switching
mode:

    newLoginCommand: lxdm -c USER_SWITCH

> Lightdm

Simply paste the following into ~/.xscreensaver to use lightdm's
switching mode:

    newLoginCommand: dm-tool switch-to-greeter

> KDM

Simply paste the following into ~/.xscreensaver /
/usr/share/X11/app-defaults/XScreenSaver to use kdm's switching mode:

    newLoginCommand: kdmctl reserve

> SLIM

?

See Also
--------

PanicLock -- Lock your screen and close any selected programs in
background.

Retrieved from
"https://wiki.archlinux.org/index.php?title=XScreenSaver&oldid=256055"

Category:

-   X Server
