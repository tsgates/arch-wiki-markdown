Console TDM
===========

> Summary

Describes installing, configuring and using Console TDM, a tiny
extension for Xorg-xinit.

Related articles

Display Manager

Console TDM is an extension for xorg-xinit written in pure bash. It is
inspired by CDM, which aimed to be a replacement of display managers
such as GDM.

Installation
------------

Install the console-tdm package which is available in AUR.

Now ensure no other display managers get started by disabling their
systemd services with systemctl disable.

For example, if you were using the Gnome Display Manager, you would stop
it from starting at boot by running

    # systemctl disable gdm.service

or

    # systemctl disable graphical.target
    # systemctl enable multi-user.target

After installing Console TDM, you should modify your ~/.bash_profile,
and add a line

    source /usr/bin/tdm

and edit your ~/.xinitrc, replace your exec lines with

    exec tdm --xstart

Configuration
-------------

You should copy the links to your WM/DE starter to ~/.tdm/sessions, and
links to non-X programs to ~/.tdm/extra. For convenience, you can just
run tdmctl init.

The use of the program tdmctl is much like systemctl, and it's a
powerful tool to configure Console TDM.

You can customize Console TDM by editing ~/.tdm/tdminit.

More resources
--------------

-   CDM - Archwiki page of CDM
-   Google Code page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Console_TDM&oldid=253728"

Category:

-   Display managers
