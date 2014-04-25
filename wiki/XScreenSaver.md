XScreenSaver
============

XScreenSaver is a screen saver and locker for the X Window System.

Contents
--------

-   1 Installing XScreenSaver
-   2 Configuring XScreenSaver
    -   2.1 DPMS settings
    -   2.2 Xresources
-   3 Starting XScreenSaver
    -   3.1 Single-User Systems
    -   3.2 Multi-User Systems
-   4 Lock Screen
    -   4.1 Automatically lock when suspending/sleeping/hibernating
-   5 Disabling XScreenSaver for Media Applications
    -   5.1 MPlayer
    -   5.2 XBMC
    -   5.3 Adobe Flash/MPlayer/VLC
-   6 Using XScreenSaver as animated wallpaper
    -   6.1 XScreenSaver as wallpaper under xcompmgr
-   7 Theming
-   8 User switching from the lock screen
    -   8.1 LXDM
    -   8.2 Lightdm
    -   8.3 KDM
    -   8.4 SLIM
-   9 Debugging
-   10 See Also

Installing XScreenSaver
-----------------------

Install the xscreensaver package found in the official repositories.

For an Arch Linux branded experience, the AUR hosts
xscreensaver-arch-logo.

Configuring XScreenSaver
------------------------

Global options are defined in /usr/share/X11/app-defaults/XScreenSaver.
Under a standard setup, there is likely no need to edit this file.
Instead most options are configured on a user-by-user basis simply by
running xscreensaver-demo

    $ xscreensaver-demo

xscreensaver-demo writes the chosen configuration in ~/.xscreensaver,
discarding any manual modification to the file.

Fortunately, since at least XScreenSaver 5.22, there is another way to
edit XScreenSaver's user configuration, using ~/.Xresources; see here
for some examples.

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

> Xresources

Control many settings by using ~/.Xresources. Defaults are located in
/usr/share/X11/app-defaults/XScreenSaver.

Below are all the valid Xresources for version 5.22.

    from: driver/XScreenSaver.ad

    xscreensaver.mode: random
    xscreensaver.timeout: 0:10:00
    xscreensaver.cycle: 0:10:00
    xscreensaver.lockTimeout: 0:00:00
    xscreensaver.passwdTimeout: 0:00:30
    xscreensaver.dpmsEnabled: False
    xscreensaver.dpmsQuickoffEnabled: False
    xscreensaver.dpmsStandby: 2:00:00
    xscreensaver.dpmsSuspend: 2:00:00
    xscreensaver.dpmsOff: 4:00:00
    xscreensaver.grabDesktopImages: True
    xscreensaver.grabVideoFrames: False
    xscreensaver.chooseRandomImages: True

    ! This can be a local directory name, or the URL of an RSS or Atom feed.
    xscreensaver.imageDirectory: /usr/share/wallpapers/
    xscreensaver.nice: 10
    xscreensaver.memoryLimit: 0
    xscreensaver.lock: False
    xscreensaver.verbose: False
    xscreensaver.timestamp: True
    xscreensaver.fade: True
    xscreensaver.unfade: False
    xscreensaver.fadeSeconds: 0:00:03
    xscreensaver.fadeTicks: 20
    xscreensaver.splash: True
    xscreensaver.splashDuration: 0:00:05
    xscreensaver.visualID: default
    xscreensaver.captureStderr: True
    xscreensaver.ignoreUninstalledPrograms: False

    xscreensaver.textMode: file
    xscreensaver.textLiteral: XScreenSaver
    xscreensaver.textFile:
    xscreensaver.textProgram: fortune
    xscreensaver.textURL: http://en.wikipedia.org/w/index.php?title=Special:NewPages&feed=rss

    xscreensaver.overlayTextForeground: #FFFF00
    xscreensaver.overlayTextBackground: #000000
    xscreensaver.overlayStderr: True
    xscreensaver.font: *-medium-r-*-140-*-m-*

    ! The default is to use these extensions if available (as noted.)
    xscreensaver.sgiSaverExtension: True
    xscreensaver.xidleExtension: True
    xscreensaver.procInterrupts: True

    ! Turning this on makes pointerHysteresis not work.
    xscreensaver.xinputExtensionDev: False

    ! Set this to True if you are experiencing longstanding XFree86 bug #421
    ! (xscreensaver not covering the whole screen)
    xscreensaver.GetViewPortIsFullOfLies: False

    ! This is what the "Demo" button on the splash screen runs (/bin/sh syntax.)
    xscreensaver.demoCommand: xscreensaver-demo

    ! This is what the "Prefs" button on the splash screen runs (/bin/sh syntax.)
    xscreensaver.prefsCommand: xscreensaver-demo -prefs

    ! This is the URL loaded by the "Help" button on the splash screen,
    ! and by the "Documentation" menu item in xscreensaver-demo.
    xscreensaver.helpURL: http://www.jwz.org/xscreensaver/man.html

    ! loadURL       -- how the "Help" buttons load the helpURL (/bin/sh syntax.)
    xscreensaver.loadURL: firefox '%s' || mozilla '%s' || netscape '%s'

    ! manualCommand -- how the "Documentation" buttons display man pages.
    xscreensaver.manualCommand: xterm -sb -fg black -bg gray75 -T '%s manual' -e /bin/sh -c 'man "%s" ; read foo'

    ! The format used for printing the date and time in the password dialog box
    ! To show the time only:  %I:%M %p
    ! For 24 hour time: %H:%M
    xscreensaver.dateFormat: %d-%b-%y (%a); %I:%M %p

    ! This command is executed by the "New Login" button on the lock dialog.
    ! (That button does not appear on the dialog if this program does not exist.)
    ! For Gnome: probably "gdmflexiserver -ls".  KDE, probably "kdmctl reserve".
    ! Or maybe yet another wheel-reinvention, "lxdm -c USER_SWITCH".
    xscreensaver.newLoginCommand: kdmctl reserve
    xscreensaver.installColormap: True
    xscreensaver.pointerPollTime: 0:00:05
    xscreensaver.pointerHysteresis: 10
    xscreensaver.initialDelay: 0:00:00
    xscreensaver.windowCreationTimeout: 0:00:30
    xscreensaver.bourneShell: /bin/sh

    ! Resources for the password and splash-screen dialog boxes of
    ! the "xscreensaver" daemon.
    xscreensaver.Dialog.headingFont: *-helvetica-bold-r-*-*-*-180-*-*-*-iso8859-1
    xscreensaver.Dialog.bodyFont: *-helvetica-bold-r-*-*-*-140-*-*-*-iso8859-1
    xscreensaver.Dialog.labelFont: *-helvetica-bold-r-*-*-*-140-*-*-*-iso8859-1
    xscreensaver.Dialog.unameFont: *-helvetica-bold-r-*-*-*-120-*-*-*-iso8859-1
    xscreensaver.Dialog.buttonFont: *-helvetica-bold-r-*-*-*-140-*-*-*-iso8859-1
    xscreensaver.Dialog.dateFont: *-helvetica-medium-r-*-*-*-80-*-*-*-iso8859-1

    ! Helvetica asterisks look terrible.
    xscreensaver.passwd.passwdFont: *-courier-medium-r-*-*-*-140-*-*-*-iso8859-1


    xscreensaver.Dialog.foreground: #000000
    xscreensaver.Dialog.background: #E6E6E6
    xscreensaver.Dialog.Button.foreground: #000000
    xscreensaver.Dialog.Button.background: #F5F5F5

    !*Dialog.Button.pointBackground: #EAEAEA
    !*Dialog.Button.clickBackground: #C3C3C3
    xscreensaver.Dialog.text.foreground: #000000
    xscreensaver.Dialog.text.background: #FFFFFF
    xscreensaver.passwd.thermometer.foreground: #4464AC
    xscreensaver.passwd.thermometer.background: #FFFFFF
    xscreensaver.Dialog.topShadowColor: #FFFFFF
    xscreensaver.Dialog.bottomShadowColor: #CECECE
    xscreensaver.Dialog.logo.width: 210
    xscreensaver.Dialog.logo.height: 210
    xscreensaver.Dialog.internalBorderWidth: 24
    xscreensaver.Dialog.borderWidth: 1
    xscreensaver.Dialog.shadowThickness: 2

    xscreensaver.passwd.heading.label: XScreenSaver %s
    xscreensaver.passwd.body.label: This screen is locked.
    xscreensaver.passwd.unlock.label: OK
    xscreensaver.passwd.login.label: New Login
    xscreensaver.passwd.user.label: Username:
    xscreensaver.passwd.thermometer.width: 8
    xscreensaver.passwd.asterisks: True
    xscreensaver.passwd.uname: True

    xscreensaver.splash.heading.label: XScreenSaver %s
    xscreensaver.splash.body.label: Copyright © 1991-2013 by
    xscreensaver.splash.body2.label: Jamie Zawinski <jwz@jwz.org>
    xscreensaver.splash.demo.label: Settings
    xscreensaver.splash.help.label: Help

Starting XScreenSaver
---------------------

> Single-User Systems

Simply installing the xscreensaver package is not enough to have it run
automatically. The xscreensaver program has to be started, which is
commonly done by the desktop environment via a line in ~/.xinitrc as
follows:

    /usr/bin/xscreensaver -no-splash &

or

    ( ( sleep 10 && /usr/bin/xscreensaver -no-splash -display :0.0 ) & )

The ampersand & argument makes the xscreensaver program run in the
background and is required.

XScreenSaver is automatically started by Xfce in /etc/xdg/xfce4/xinitrc,
to ensure it gets executed use startxfce4 and not xfce4-session.

    exec startxfce4

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

Note:The command given is for GDM; if using a different login manager,
replace it with the preferred login manager's command.

Lock Screen
-----------

To immediately trigger xscreensaver, if it is running, and lock the
screen, execute the following command:

    $ xscreensaver-command --lock

> Automatically lock when suspending/sleeping/hibernating

The best option is to install xss-lock from AUR, and run this command
from the X session autostart script:

    xss-lock -- xscreensaver-command -lock &

Another option is to install xuserrun-git from AUR, and create the
following file:

    /etc/systemd/system/xscreensaver.service

    [Unit]
    Description=Lock X session using xscreensaver
    Before=sleep.target

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/xuserrun /usr/bin/xscreensaver-command -lock

    [Install]
    WantedBy=sleep.target

and enable it with systemctl enable xscreensaver.

You may want to set XScreenSaver's fade out time to 0.

Other service configuration without xuserrun and for one user from this
thread, replace the previous [Service] section by this one :

    /etc/systemd/system/xscreensaver.service

    [Service]
    User=yourusername
    Type=oneshot
    Environment=DISPLAY=:0
    ExecStart=/usr/bin/xscreensaver-command -lock

Disabling XScreenSaver for Media Applications
---------------------------------------------

> MPlayer

Add the following to ~/.mplayer/config

    heartbeat-cmd="xscreensaver-command -deactivate >&- 2>&- &"

> XBMC

There is no native support within XBMC to disable XScreenSaver (although
XBMC does come with its own screensaver). The AUR contains a tiny app
called xbmc-prevent-xscreensaver does just this.

> Adobe Flash/MPlayer/VLC

There is no native way to disable XScreenSaver for flash, but there is
script named lightsOn that works great and has support for Firefox's
Flash plugin, Chromium's Flash plugin, MPlayer, and VLC.

Another approach would be to disable DPMS completely.

Using XScreenSaver as animated wallpaper
----------------------------------------

One can run xscreensaver in the background, just like a wallpaper.
First, kill any process that is controlling the background (the root
window). Locate the desired XScreenSaver executable (they are usually on
/usr/lib/xscreensaver/) and run it with the -root flag, like this

    $ /usr/lib/xscreensaver/glslideshow -root &

> XScreenSaver as wallpaper under xcompmgr

xcompmgr may cause problems. One recommended solution is to use xwinwrap
to run it in order to use it as wallpaper. Find it as
shantz-xwinwrap-bzr in the AUR.

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

Note:Modifications manually made to ~/.xscreensaver are discarded by
xscreensaver-demo, therefore instead use ~/.Xresources. For example, for
LXDM, add in ~/.Xresources:

    xscreensaver.newLoginCommand: lxdm -c USER_SWITCH

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

Debugging
---------

You can configure xscreensaver to write to a log file by creating the
logfile # touch /var/log/xscreensaver.log and then specifying its X
resource logFile.

    ~/.Xresources

    xscreensaver.logFile:/var/log/xscreensaver.log

To log verbose debugging information to the logFile as well start
xscreensaver with the -verbose command line option, or add this to
~/.Xresources

    ~/.Xresources

    xscreensaver.logFile:/var/log/xscreensaver.log
    xscreensaver.verbose:true

See Also
--------

-   PanicLock -- Lock the screen and close any selected programs in
    background.
-   Homepage for XScreenSaver
-   Display Power Management Signaling
-   xinitrc

Retrieved from
"https://wiki.archlinux.org/index.php?title=XScreenSaver&oldid=301755"

Category:

-   X Server

-   This page was last modified on 24 February 2014, at 15:18.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
