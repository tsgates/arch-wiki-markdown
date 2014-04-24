Autostarting
============

This article links to various methods to launch scripts or applications
automatically when some particular event is taking place, like system
startup or shutdown, shell login or logout and so on.

Contents
--------

-   1 Daemons
    -   1.1 Systemd
    -   1.2 Runit
-   2 Cron
-   3 Shells
    -   3.1 /etc/profile
-   4 Graphical
    -   4.1 X session startup
    -   4.2 Desktop Application Autostart
    -   4.3 GNOME, KDE, Xfce
    -   4.4 LXDE
    -   4.5 Fluxbox
    -   4.6 Openbox

Daemons
-------

You can start your scripts or applications as daemons, see Daemon.

> Systemd

systemd is the default init framework, replacing initscripts. The
services which are started by systemd can be found in the subfolders of
/etc/systemd/system/. Services can be enabled using the systemctl
command. For more information about systemd and how to write autostart
scripts for it, see at systemd.

> Runit

runit is a mature init system which offers process supervision, parallel
startup, per-user service trees, granular cgroup manipulation, flexible
dependency system, and boot times that don't incur the penalty of dbus.
The root-level services are symlinks in /service with the actual service
directories in /etc/sv. See the Runit page for more information.

Cron
----

Cron can be used to autostart non-GUI system setup tasks.

Shells
------

To autostart programs in console or upon login, you can use shell
startup files/directories. Read the documentation for your shell, or its
ArchWiki article, e.g. Bash#Configuration file sourcing order at startup
or Zsh#Autostarting applications.

See also Wikipedia:Unix shell#Configuration files for shells.

> /etc/profile

/etc/profile is sourced by all Bourne-compatible shells upon login: it
sets up an environment upon login and application-specific settings by
sourcing any readable /etc/profile.d/*.sh scripts.

Graphical
---------

You can autostart programs automatically when you login into your Window
manager or Desktop environment.

> X session startup

See xinitrc and xprofile.

> Desktop Application Autostart

The following folders contain *.desktop files, which are executed every
time an X session starts, determining which programs are loaded for
which desktop environment:

-   $XDG_CONFIG_DIRS/autostart/ (/etc/xdg/autostart/ by default)
-   /usr/share/gnome/autostart/ (GNOME only)
-   $XDG_CONFIG_HOME/autostart/ (~/.config/autostart/ by default)

Users can override system-wide *.desktop files by copying them into the
user-specific ~/.config/autostart/ folder.

For an explanation of the desktop file standard refer to Desktop Entry
Specification. For a more specific description of directories used,
Desktop Application Autostart Specification.

Note that this method is supported only by XDG-compliant desktop
environments. Tools like dapper, dex-git, or fbautostart can be used to
offer XDG autostart in unsupported desktop environments as long as some
other autostart mechanism exists.

> GNOME, KDE, Xfce

GNOME, KDE and Xfce all have a dedicated GUI for autostart settings, see
the respective articles.

> LXDE

See LXDE#Autostart programs.

> Fluxbox

See Fluxbox#Autostart programs.

> Openbox

See Openbox#Startup programs.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Autostarting&oldid=305997"

Category:

-   Boot process

-   This page was last modified on 20 March 2014, at 17:34.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
