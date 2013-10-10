MATE
====

> Summary

What is MATE and how to get it.

Required software

MATE

> Related

GNOME

The MATE Desktop Environment is a fork of GNOME 2 that aims to provide
an attractive and intuitive desktop to Linux users using traditional
layouts and methods. For more information, see this forum thread.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Obtaining                                                          |
| -   2 Installation                                                       |
| -   3 Starting                                                           |
|     -   3.1 Manually                                                     |
|     -   3.2 Automatically at boot time                                   |
|         -   3.2.1 GDM (Old)                                              |
|         -   3.2.2 LightDM, GDM & LXDM                                    |
|         -   3.2.3 MATE Display Manager                                   |
|         -   3.2.4 KDM                                                    |
|         -   3.2.5 SLIM                                                   |
|                                                                          |
| -   4 Applications                                                       |
| -   5 Known issues                                                       |
|     -   5.1 Qt Applications are not styled                               |
|     -   5.2 Evolution Email Not Working                                  |
|     -   5.3 GTK3 Applications Not Properly Styled                        |
|                                                                          |
| -   6 Troubleshooting                                                    |
|     -   6.1 User Switch                                                  |
|         -   6.1.1 LightDM                                                |
|         -   6.1.2 GDM                                                    |
|                                                                          |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Obtaining
---------

MATE is currently developed on GitHub. Stable packages with
release-based version numbering are hosted on
http://repo.mate-desktop.org/archlinux/.

Installation
------------

To install the stable version of MATE via pacman add the following lines
to your /etc/pacman.conf:

    [mate]
    SigLevel = Optional TrustAll
    Server = http://repo.mate-desktop.org/archlinux/$arch

Run

    # pacman -Syy

and then

    # pacman -S mate

It might also be of interest to people to install certain packages from
the mate-extras group (most being counterparts to packages in the
gnome-extra group):

    # pacman -S mate-extras

Starting
--------

> Manually

In order to start MATE manually, you must add

    exec mate-session

to your ~/.xinitrc file and then run

    $ startx

Note:See xinitrc for details, such as preserving the logind (and/or
consolekit) session.

> Automatically at boot time

See Display Manager and Start X at Boot for details.

GDM (Old)

If you are using gdm-old from the AUR, simply select the MATE session
from the Sessions list. For your first time launching MATE, make sure to
click "Just this session" when prompted.

LightDM, GDM & LXDM

Just select MATE from the Sessions list. Works well.

MATE Display Manager

The MATE Display Manager (MDM) is the MATE desktop's counterpart to the
GNOME Display Manager (GDM). Its package 'mate-display-manager' has been
found in the mate-extra group or in the AUR package
mate-display-manager. It has worked relatively the same as GDM does/did;
unfortunately, the subproject is currently in flux, and MDM is not
currently (as of 2012/07/01) available.

KDM

In order to be able to launch MATE from KDM, the KDE Display Manager,
you have to edit the KDM configuration. As root, edit the
/usr/share/config/kdm/kdmrc configuration file. Find the SessionsDir
parameter and add /usr/share/xsessions to the list. It should then look
like this:

    SessionsDirs=/usr/share/config/kdm/sessions,/usr/share/apps/kdm/sessions,/usr/share/xsessions

Restart KDM and select the "MATE session" from the list.

SLIM

Just fоllow the SLIM tutorial to know how to install and how to copy and
use the .xinitrc file. And just add this line to the .xinitrc file :

    exec mate-session

Applications
------------

It is important to note that many GNOME core applications are rebranded
for MATE, as per the licensing terms. Here is a simple Rosetta Stone of
GNOME -> MATE applications.

-   Nautilus is renamed Caja
-   Metacity is renamed Marco
-   Gconf is renamed Mate-conf
-   Gedit is renamed Pluma
-   Eye of GNOME is renamed Eye of MATE
-   Evince is renamed Atril
-   File Roller is renamed Engrampa
-   GNOME Terminal is renamed MATE Terminal

Other applications and core components prefixed with GNOME (such as
GNOME Panel, GNOME Menus etc) have simply had the prefix renamed "MATE"
and become MATE Panel and MATE Menus.

Not all of the GNOME extra applications (built for GTK2) have been
forked yet. The following extra applications are available in MATE:

-   Totem (mate-video-player)
-   GNOME Panel applets (mate-applets)

If you are using NetworkManager to connect to the internet, you can
install network-manager-applet-gtk2 from the AUR for a GTK2 nm-applet.
You will need to modify the PKGBUILD to depend on mate-bluetooth rather
than gnome-bluetooth to prevent a recursive dependency on gnome-desktop.

Known issues
------------

> Qt Applications are not styled

You may find that Qt4 applications are not inheriting the GTK2 theme
like they should. This can be fixed easily by running qtconfig and
setting GTK+ as GUI style under System ⇒ Preferences ⇒ QT4 Settings.

> Evolution Email Not Working

Please see Evolution#Using_Evolution_Outside_Of_Gnome.

> GTK3 Applications Not Properly Styled

If you notice that applications such as Rhythmbox do not have styling
applied to them, try Clearlooks Phenix theme.

Troubleshooting
---------------

> User Switch

If you are not using MDM (Mate Display Manager) user switch is disabled,
to enable create the symbolic links.

LightDM

    # ln -s /usr/lib/lightdm/lightdm/gdmflexiserver /usr/bin/mdmflexiserver

GDM

    # ln -s /usr/bin/gdmflexiserver /usr/bin/mdmflexiserver

  

See also
--------

MATE official homepage

Arch Linux Forums

-   The MATE Desktop Environment - A general discussion about MATE
-   MATE desktop screenshots

Retrieved from
"https://wiki.archlinux.org/index.php?title=MATE&oldid=254877"

Category:

-   Desktop environments
