Autostarting
============

This article links to various methods to launch scripts or applications
automatically when some particular event is taking place, like system
startup or shutdown, shell login or logout and so on.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Daemons                                                            |
|     -   1.1 Systemd                                                      |
|     -   1.2 Runit                                                        |
|                                                                          |
| -   2 Shells                                                             |
|     -   2.1 /etc/profile                                                 |
|     -   2.2 See also                                                     |
|                                                                          |
| -   3 Graphical                                                          |
|     -   3.1 X session startup                                            |
|     -   3.2 X Desktop Group                                              |
|     -   3.3 GNOME, KDE, Xfce                                             |
|         -   3.3.1 KDE (Legacy)                                           |
|                                                                          |
|     -   3.4 LXDE                                                         |
|     -   3.5 Fluxbox                                                      |
|     -   3.6 Openbox                                                      |
+--------------------------------------------------------------------------+

Daemons
-------

You can easily start your scripts or applications as daemons, see
Daemon.

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

Shells
------

To autostart programs in console you can use shell startup
files/directories. Read the documentation for your shell, or its
ArchWiki article, e.g. Bash or Zsh.

> /etc/profile

/etc/profile is sourced by all Bourne-compatible shells upon login: it
sets up an environment upon login and application-specific
(/etc/profile.d/*.sh) settings.

Each time /etc/profile is executed, it sources the following scripts if
they exist:

-   /etc/profile.d/*.sh
-   /etc/bash.bashrc (if shell is bash)
-   /etc/bash_completion

> See also

-   INVOCATION section of man bash
-   STARTUP/SHUTDOWN FILES section of man zsh
-   Wikipedia:Unix_shell#Configuration files for shells

Graphical
---------

You can autostart programs automatically when you login into your Window
Manager or Desktop Environment.

> X session startup

See xinitrc and xprofile.

> X Desktop Group

$XDG_CONFIG_DIRS/autostart/: In this folder are .desktop files. These
files determine which programs are loaded for which desktop environment.
For an explanation of the desktop file standard refer to Desktop Entry
Specification.

> GNOME, KDE, Xfce

GNOME, KDE and Xfce all have a dedicated GUI for autostart settings, see
the respective articles.

You can also directly put .desktop files in ~/.config/autostart/

KDE (Legacy)

KDE also has a specific folder: ~/.kde/Autostart or ~/.kde4/Autostart

> LXDE

See LXDE#Autostart_Programs.

> Fluxbox

See Fluxbox#Autostarting Applications.

> Openbox

See Openbox#Startup programs.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Autostarting&oldid=253790"

Category:

-   Boot process
