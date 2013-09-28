Display Manager
===============

Summary

A display manager presents the user with a login screen which prompts
for a user name and password. A session starts when the user
successfully enters a valid combination of user name and password. This
article covers installation, configuration, and troubleshooting of
common display managers.

Overview

The Xorg project provides an open source implementation of the X Window
System – the foundation for a graphical user interface. Desktop
environments such as Enlightenment, GNOME, KDE, LXDE, and Xfce provide a
complete graphical environment. Various window managers offer
alternative and novel environments, and may be used standalone to
conserve system resources. Display managers provide a graphical login
prompt.

Related

Start X at Login

A display manager, or login manager, is a graphical interface screen
that is displayed at the end of the boot process in place of the default
shell. There are various types of display managers, just as there are
various types of window and desktop managers. There is usually a certain
amount of customization and themeability available with these managers.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 List of display managers                                           |
|     -   1.1 Console                                                      |
|     -   1.2 Graphical                                                    |
|                                                                          |
| -   2 Loading the display manager                                        |
+--------------------------------------------------------------------------+

List of display managers
------------------------

Tip:If you use a desktop environment, you may consider using the display
manager that corresponds to it.

Tip:The following display managers provide an automatic list of
installed Window Managers (reading /usr/share/xsessions entries): GDM,
KDM, LXDM, LightDM

> Console

-   CDM (Console Display Manager) — ultra-minimalistic, yet
    full-featured login manager written in bash

https://github.com/ghost1227/cdm || cdm-git

> Graphical

-   SLiM (Simple Login Manager) — lightweight and elegant graphical
    login solution

http://slim.berlios.de/ || slim

-   Qingy — ultralight and very configurable graphical login independent
    on X Windows (uses DirectFB)

http://qingy.sourceforge.net/ || qingy

-   XDM — X Display Manager with support for XDMCP, host chooser.

http://www.x.org/archive/X11R7.5/doc/man/man1/xdm.1.html || xorg-xdm

-   GDM — GNOME Display Manager

http://projects.gnome.org/gdm/ || gdm

-   KDM — KDE Display Manager

http://www.kde.org/ || kdebase-workspace

-   LXDM — LXDE Display Manager. Can be used independent of the LXDE
    desktop environment.

http://sourceforge.net/projects/lxdm/ || lxdm

-   wdm — WINGs Display Manager

http://voins.program.ru/wdm/ || wdm

-   LightDM — Ubuntu replacement for GDM using WebKit

http://www.freedesktop.org/wiki/Software/LightDM || lightdm, lightdm-bzr

-   SDDM — QML-based display manager

https://github.com/sddm/sddm || sddm-git, sddm-qt5-git

Loading the display manager
---------------------------

Many display managers come packaged with a systemd service file.

Simply run the following command in accordance with the display manager
you choose:

-   GDM:

    # systemctl enable gdm.service

-   KDM:

    # systemctl enable kdm.service

-   SLiM

    # systemctl enable slim.service

-   LXDM:

    # systemctl enable lxdm.service

-   LightDM:

    # systemctl enable lightdm.service

-   SDDM:

    # systemctl enable sddm.service

The next time you reboot, the display manager should run. The display
manager will load automatically after start-up and will respawn in the
event of a crash.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Display_Manager&oldid=251260"

Category:

-   Display managers
