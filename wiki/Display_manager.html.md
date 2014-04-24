Display manager
===============

Related articles

-   Desktop environment
-   Window manager
-   Start X at Login

A display manager, or login manager, is typically a graphical user
interface that is displayed at the end of the boot process in place of
the default shell. There are various implementations of display
managers, just as there are various types of window managers and desktop
environments. There is usually a certain amount of customization and
themeability available with each one.

Contents
--------

-   1 List of display managers
    -   1.1 Console
    -   1.2 Graphical
-   2 Loading the display manager
    -   2.1 Using systemd-logind
-   3 Tips and tricks
    -   3.1 Session list
    -   3.2 Autostarting
-   4 Known issues
    -   4.1 Incompatibility with systemd

List of display managers
------------------------

> Console

-   CDM — Ultra-minimalistic, yet full-featured login manager written in
    Bash.

https://github.com/ghost1227/cdm || cdm-git

-   Console TDM — Extension for xinit written in pure Bash.

http://code.google.com/p/t-display-manager/ || console-tdm

> Graphical

-   Entrance — An EFL based display manager, highly experimental.

http://enlightenment.org/ || entrance-git

-   GDM — GNOME display manager.

http://projects.gnome.org/gdm/ || gdm

-   KDM — KDE display manager.

http://www.kde.org/ || kdebase-workspace

-   LightDM — Cross-desktop display manager, can use various front-ends
    written in any toolkit.

http://www.freedesktop.org/wiki/Software/LightDM || lightdm

-   LXDM — LXDE display manager. Can be used independent of the LXDE
    desktop environment.

http://sourceforge.net/projects/lxdm/ || lxdm

-   MDM — MDM display manager, used in Linux Mint, a fork of GDM 2.

https://github.com/linuxmint/mdm || mdm-display-manager

-   Qingy — Ultralight and very configurable graphical login independent
    on X Windows (uses DirectFB).

http://qingy.sourceforge.net/ || qingy

-   SDDM — QML-based display manager.

https://github.com/sddm/sddm || sddm, sddm-qt5

-   SLiM — Lightweight and elegant graphical login solution.

http://slim.berlios.de/ || slim

-   XDM — X display manager with support for XDMCP, host chooser.

http://www.x.org/archive/X11R7.5/doc/man/man1/xdm.1.html || xorg-xdm

Loading the display manager
---------------------------

To enable graphical login, run your preferred display manager daemon
(e.g. KDM).

    # systemctl enable kdm

This should work out of the box. If not, you might have a default.target
set manually or from an older install:

    $ ls -l /etc/systemd/system/default.target

    [...] /etc/systemd/system/default.target -> /usr/lib/systemd/system/graphical.target

Simply delete the symlink and systemd will use its stock default.target
(i.e. graphical.target).

    # rm /etc/systemd/system/default.target

After enabling KDM a symlink display-manager.service should be set in
/etc/systemd/system/

    $ ls -l /etc/systemd/system/display-manager.service

    [...] /etc/systemd/system/display-manager.service -> /usr/lib/systemd/system/kdm.service

> Using systemd-logind

In order to check the status of your user session, you can use loginctl.
All polkit actions like suspending the system or mounting external
drives will work out of the box.

    $ loginctl show-session $XDG_SESSION_ID

Tips and tricks
---------------

> Session list

Many display managers read available sessions from /usr/share/xsessions/
directory. It contains standard desktop entry files for each DM/WM.

To add/remove entries to your display manager's session list;
create/remove the .desktop files in /usr/share/xsessions/ as desired. A
typical .desktop file will look something like:

    [Desktop Entry]
    Encoding=UTF-8
    Name=Openbox
    Comment=Log in using the Openbox window manager (without a session manager)
    Exec=/usr/bin/openbox-session
    TryExec=/usr/bin/openbox-session
    Icon=openbox.png
    Type=XSession

> Autostarting

Most of display managers sources /etc/xprofile, ~/.xprofile and
/etc/X11/xinit/xinitrc.d/. For more details, see xprofile.

Known issues
------------

> Incompatibility with systemd

Affected DMs: Entrance, MDM, SDDM, SLiM

Some display managers are not fully compatible with systemd, because
they reuse the PAM session process. It causes various problems on second
login, e.g.:

-   NetworkManager applet does not work,
-   PulseAudio volume cannot be adjusted,
-   login failed into GNOME with another user.

See the following bugtracker reports for more details:

-   MDM: [1]
-   SDDM: [2] (fixed in git master)
-   SLiM: [3] [4]

Retrieved from
"https://wiki.archlinux.org/index.php?title=Display_manager&oldid=302336"

Category:

-   Display managers

-   This page was last modified on 27 February 2014, at 15:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
