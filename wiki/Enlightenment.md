Enlightenment
=============

> Summary

The Enlightenment project provides useful libraries, a graphical
environment and other applications as well as development tools for
creating such applications. This article covers its installation,
configuration, and troubleshooting.

> Overview

The Xorg project provides an open source implementation of the X Window
System – the foundation for a graphical user interface. Desktop
environments such as Enlightenment, GNOME, KDE, LXDE, and Xfce provide a
complete graphical environment. Various window managers offer
alternative and novel environments, and may be used standalone to
conserve system resources. Display managers provide a graphical login
prompt.

From the Enlightenment wiki:

The Enlightenment desktop shell provides an efficient yet breathtaking
window manager based on the Enlightenment Foundation Libraries along
with other essential desktop components like a file manager, desktop
icons and widgets. It boasts an unprecedented level of theme-ability
while still being capable of performing on older hardware or embedded
devices.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Enlightenment Desktop Shell (formerly E17)                         |
|     -   1.1 Installing                                                   |
|         -   1.1.1 From the extra repository                              |
|         -   1.1.2 From the AUR                                           |
|                                                                          |
|     -   1.2 Starting                                                     |
|         -   1.2.1 startx                                                 |
|         -   1.2.2 Entrance                                               |
|         -   1.2.3 Other                                                  |
|                                                                          |
|     -   1.3 Configuring the Network                                      |
|         -   1.3.1 ConnMan                                                |
|         -   1.3.2 NetworkManager                                         |
|                                                                          |
|     -   1.4 Installing Themes                                            |
|     -   1.5 Modules and Gadgets                                          |
|     -   1.6 "Extra" modules                                              |
|         -   1.6.1 Places                                                 |
|         -   1.6.2 Scale Windows                                          |
|         -   1.6.3 Engage                                                 |
|                                                                          |
|     -   1.7 Gnome Keyring integration                                    |
|     -   1.8 Troubleshooting                                              |
|         -   1.8.1 Compositing                                            |
|         -   1.8.2 Screen unlocking does not work                         |
|         -   1.8.3 Unreadable fonts                                       |
|         -   1.8.4 Failure in mounting internal partitions                |
|                                                                          |
| -   2 Enlightenment DR16                                                 |
|     -   2.1 To install E16                                               |
|     -   2.2 Basic Configuration                                          |
|         -   2.2.1 Background images                                      |
|         -   2.2.2 Start/Restart/Stop Scripts                             |
|         -   2.2.3 Compositor                                             |
|                                                                          |
| -   3 External Links                                                     |
+--------------------------------------------------------------------------+

Enlightenment Desktop Shell (formerly E17)
------------------------------------------

This is comprised of both the Enlightenment window manager and
Enlightenment Foundation Libraries (EFL), which provide additional
desktop environment features such as a toolkit, object canvas, and
abstracted objects. It has been under development since 2005, but in
February 2011 the core EFLs saw their first stable 1.0 release.
Enlightenment the window manager was released as version 0.17.0 on
December 21st 2012, along with the 1.7.4 release of the EFL libraries.
Many people currently use Enlightenment as a day-to-day desktop
environment without problems.

Warning:This page refers to both stable and development packages. Any
PKGBUILD which ends with -svn or -git will use unstable development
code. Use them at your own risk. Since the release of the EFL libraries
and Enlightenment itself, it's no longer necessary and even discouraged
to build the core programs from SVN or Git. "Unless you're developing E
or willing to live bleeding edge, stay away from trunk."(source)
Unfortunately, many of the additional software packages have not been
released and building from SVN or Git is the only way to use them.

> Installing

From the extra repository

To install Enlightenment, install the enlightenment17 package.

You might also want to install additional Fonts. You need at least 1
True Type Font.

If you need/want an Enlightenment package which is not (yet) available
in [extra], see if it is available in the AUR.

From the AUR

Development PKGBUILDs which download and install the very latest
development code are available in the AUR as enlightenment17-git and
it's dependencies.

> Starting

startx

If you use startx or a simple Display Manager like XDM or SLiM, add or
uncomment the following command in xinitrc:

    ~/.xinitrc

    exec enlightenment_start

Entrance

Enlightenment has a new display manager called Entrance, and is
available in the AUR under the entrance-git package. Entrance is quite
sophisticated and its configuration is controlled by /etc/entrance.conf.
To use Entrance :

    # systemctl enable entrance

Other

More advanced display managers like GDM and KDM will automatically
detect Enlightenment thanks to the
/usr/share/xsessions/enlightenment.desktop file provided by the
enlightenment17 package.

> Configuring the Network

ConnMan

Enlightenment's preferred network manager is ConnMan. It is available
from the [community] repository as the connman package. For extended
configuration, you may also install EConnman (available in AUR as
econnman or econnman-git) and it's associated dependencies.

Finally, configure systemd to start the ConnMan daemon at startup:

    systemctl enable connman

ConnMan loads very quickly and appears to handle DHCP quite nicely. If
you have installed Wpa_supplicant, ConnMan latches onto that shows all
available wireless connections.

NetworkManager

You can also use networkmanager to manage your network connections.

    pacman -S networkmanager

Follow the instructions on NetworkManager to do the configuration. You
may also need network-manager-applet to help with your settings.

    pacman -S network-manager-applet

You may want to add it to the start up programs so every time your E17
starts it appears on systray.

    Settings -> Settings Panel -> Apps -> Startup Applications -> System -> Network

> Installing Themes

More themes to customize the look of Enlightenment are available from:

-   exchange.enlightenment.org, for which you can use the e17-themes AUR
    package
-   e17-stuff.org
-   relighted.c0n.de for the default theme in 200 different colors
-   svn trunk (svn checkout the theme you like, run 'make' and you end
    up with a .edj theme file)

You can install the themes (coming in .edj format) using the theme
configuration dialog or by moving them to ~/.e/e/themes.

Note:During 2010 there was a change in how themes work, so older themes
will not work unless they were updated. There used to be an edje_convert
tool to do this, but that has been dropped long ago (see:
trac.enlightenment.org)

> Modules and Gadgets

Module
    Name used in enlightenment to refer to the "backing" code for a
    gadget.
Gadget
    Front-end or user interface that should help the end users of
    Enlightenment do something.

Many Modules provide Gadgets that can be added to your desktop or on a
shelf. Some Modules (such as CPUFreq) only provide a single Gadget while
others (such as Composite) provide additional features without any
gadgets. Note that certain gadgets such as Systray can only be added to
a shelf while others such as Moon can only be loaded on the desktop.

> "Extra" modules

Warning:These are 3rd party modules and not officially supported by the
Enlightenment developers. They are also pulled directly from SVN, so
they are development code that may or may not work at any time. Use at
your own risk.

These modules are available from the AUR, either as part of
e-modules-extra-svn or as individual packages.

Places

From the current source code README for Places: This module manage the
volumes device attached to the system.

In other words, Places is a gadget that will help you browse files on
various devices you might plug into your computer, like phones, cameras,
or other various storage devices you might plug into the usb port.

Available from e17-places-svn

Note:This module is no longer required for auto-mounting external
devices in e17

Scale Windows

The Scale Windows module, which requires compositing to be enabled, adds
several features. The scale windows effect shrinks all open windows and
brings them all into view. This is known in Mac OS X as "Exposé". The
scale pager effect zooms out and shows all desktops as a wall, like the
compiz expo plugin. Both can be added to the desktop as a gadget or
bound to a key binding, mouse binding or screen edge binding.

Some people like to change the standard window selection key binding
ALT + Tab to use Scale Windows to select windows. To change this
setting, you navigate to
Menu > Settings > Settings Panel > Input > Keys. From here, you can set
any key binding you would like.

To replace the window selection key binding functionality with Scale
Windows, scroll through the left panel until you find the "ALT" section
and then find and select ALT + Tab. Then, scroll through the right panel
looking for the "Scale Windows" section and choose either Select Next or
Select Next (All) depending on whether you would like to see windows
from only the current desktop or from all desktops and click "Apply" to
save the binding.

Available from comp-scale for the Enlightenment release, comp-scale-svn
for the Enlightenment development version.

Engage

Engage is CairoDock/GLX-Dock style docking bar for both application
launchers and open applications. It requires compositing to be enabled
and has full controls for transparency, size, zoom levels, and more.

Available from engage-svn

> Gnome Keyring integration

It is possible to use gnome-keyring in Enlightenment. However at the
time of writing you need a small hack to make it work in full. First you
must tell Enlightenment to autostart gnome-kering. For that you should
go to Settings Panel > Apps > Startup Applications and activate
"Certificate and Key Storage", "GPG Password Agent", "SSH Key Agent" and
"Secret Storage Service". After this you should edit your ~/.profile and
add the following:

    if [ -n "$GNOME_KEYRING_PID" ]; then
        eval $(gnome-keyring-daemon --start)
        export SSH_AUTH_SOCK
        export GNOME_KEYRING_CONTROL
        export GPG_AGENT_INFO
    fi

This should export the variables you need for your key management at
your next login.

> Troubleshooting

If you find some unexpected behavior, there are a few things you can do:

1.  try to see if the same behavior exists with the default theme
2.  disable any 3rd party modules you may have installed
3.  backup ~/.e and remove it (e.g. mv ~/.e ~/.e.back)

If you are sure you found a bug please report it directly upstream.
http://trac.enlightenment.org/e/report

Compositing

When the configuration is messed up and the settings windows can no
longer be approached, configuration for the comp module can be reset by
the hardcoded keybinding Ctrl + Alt + Shift + Home.

Screen unlocking does not work

If screenlock does not accept your password add the following to
/etc/pam.d/enlightenment:

    auth required pam_unix_auth.so

Unreadable fonts

If fonts are too small and your screen is unreadable, be sure the right
font packages are installed:

    pacman -S ttf-dejavu ttf-bitstream-vera

Failure in mounting internal partitions

Check if user is in storage group:

    # groups <user>

If user is not in storage group:

    # groupadd storage 
    # gpasswd -a <user> storage

Then create this file as root:

    # nano /etc/polkit-1/localauthority/50-local.d/10-storage-group-mount-override.pkla

And write into the file:

    [storage group mount override]
    Identity=unix-group:storage
    Action=org.freedesktop.udisks2.filesystem-mount-system
    ResultAny=yes
    ResultInactive=yes
    ResultActive=yes

For more information, see: http://bbs.archbang.org/viewtopic.php?id=2720

Enlightenment DR16
------------------

Enlightenment, Development Release 16 was first released in 2000, and
went 1.0 in 2009. Originally, the DR16 stood for the 0.16 version of the
Enlightenment project. As simply "Enlightenment" now in the /extra Arch
repositories, it is still under development today, regularly updated by
its maintainer Kim 'kwo' Woelders. With compositing, shadows and
transparencies, E DR16 kept all of the speed that presided over it's
foundation by original author Carsten "Rasterman" Haitzler but with up
to date refinement.

> To install E16

Simply run

    # pacman -S enlightenment

E can be quite different from the other WM's out there, read
/usr/share/doc/e16/e16.html after installation to learn more The man
page is at 'man e16' , not 'man enlightenment', and only gives startup
options.

> Basic Configuration

Most everything in E DR16 resides in ~/.e16 and is text-based, editable
at will. That includes the Menus too.

Shortcut keys can be either modified by hand, or with the e16keyedit
software provided as source on the sourceforge page of the e16 project,
or from the AUR.

Background images

You have to copy the desired wallpapers into ~/.e16/backgrounds/

MMB or RMB anywhere on the desktop will give access to the settings,
select /Desktop/Backgrounds/

Any new image copied in the ~/.e16/backgrounds/ foldere will get the
list of available backgrounds auto-updated. Select desired wallpaper
from drop-down menu. Inside the appropriate tabs in the global e16
settings, you can adjust things like tiling of the background image,
filling screen and such.

Start/Restart/Stop Scripts

Create an Init,a Start and a Stop folder in your ~/.e16 folder: any .sh
script found there will either be executed at Startup (from Init
folder), at each Restart (from Start folder), or at Shutdown (from Stop
folder); provided you allowed it trough the MMB / settings / session /
<enable scripts> button and made them executable with chmod +x
yourscript.sh. Typical examples involves starting the blueman or your
favourite network manager applet.

Compositor

Shadows, Transparent effects et all can be found in MMB or RMB
/Settings, under Composite .

External Links
--------------

-   Enlightenment Homepage
-   Enlightenment Exchange
-   EFL User Guide
-   Bodhi Guide to Enlightenment
-   E17-Stuff
-   DR16 download resource
-   E-Users mail list
-   E-Devs mail list
-   irc://irc.freenode.net#e

Retrieved from
"https://wiki.archlinux.org/index.php?title=Enlightenment&oldid=254514"

Category:

-   Desktop environments
