IceWM
=====

According to Wikipedia:

IceWM is a window manager for the X Window System graphical
infrastructure, written by Marko Maček. It was coded from scratch in C++
and is released under the terms of the GNU Lesser General Public
License. It is relatively lightweight in terms of memory and CPU usage,
and comes with themes that allow it to imitate the UI of Windows 95,
OS/2, Motif, and other graphical user interfaces". Configurability and
presence of simple session management places IceWM between simplest DEs
and feature-rich WMs.

Contents
--------

-   1 Installation
-   2 Running as stand-alone WM
-   3 IceWM as a WM for desktop environments
-   4 Configuration
    -   4.1 Menu
    -   4.2 Themes
-   5 File managers
-   6 Troubleshooting
    -   6.1 No start menu icon (Intel graphics)
    -   6.2 Unable to logout when PCManFM is managing the desktop
    -   6.3 No shutdown or reboot options in logout menu (logout command
        has been defined)
    -   6.4 No shutdown or reboot options in logout menu (logout command
        has not been defined)
-   7 See also

Installation
------------

IceWM can be installed from official repositories with package icewm.

Alternatively, the latest version from the testing branch
(icewm-testing) and CVS version (icewm-cvs) are available from the AUR.
These versions add new features and bugfixes (due to slow development
they are often equal with othe official repositories icewm).

Running as stand-alone WM
-------------------------

To run IceWM as a stand-alone window manager, append the following to
~/.xinitrc:

    exec icewm

icewm-session will run icewm, icewmbg and icewmtray, so appending the
following to {{ic|~/.xinitrc} implements basic session management:

    exec icewm-session

See xinitrc for details, such as preserving the logind session.

IceWM as a WM for desktop environments
--------------------------------------

Actions required to use IceWM with DE are basically same as ones for
Openbox (and probably any other WM).

Configuration
-------------

Although IceWM configuration is originally text-based, there are
GUI-based tools available, notably icewm-utils in [community]. However
these tools are relatively old and most users prefer to simply edit the
text configuration files. Configuration changes from defaults can be
made either system wide (in /etc/icewm/) or on a user-specific basis (in
~/.icewm/).

To change your icewm configuration from the default, simply copy the
default configuration files from /usr/share/icewm/ to ~/.icewm/, for
example:

Note:Do this as a regular user, not as root.

    $ mkdir ~/.icewm/
    $ cp -R /usr/share/icewm/* ~/.icewm/

-   preferences is the core configuration file for IceWM.
-   menu controls the contents of the IceWM application menu.
-   keys allows the user to customize keyboard shortcuts
-   toolbar row of launcher icons on the taskbar
-   winoptions behavior of individual applications
-   theme theme path/name
-   startup script or command (must be executable) executed on startup
-   shutdown the same for shutdown

> Note:

-   Startup commands that install system tray applets must be preceded
    by sleep 1 &&, otherwise IceWM will create an ugly black window that
    will prevent it from quitting; in that case, use xkill on the task
    bar.
-   You will have to create the startup script yourself as it is not
    included in the package. Don't forget to make it executable.

> Menu

-   menumaker from the official repositories is a Python script that
    automatically populates your applications menu based on what is
    installed in your system. Although this may result in a menu filled
    with many unwanted applcations, it may still be preferable to
    manually editing the menu configuration file. When running
    MenuMaker, use the -f flag to overwrite an existing menu file:

    # mmaker -f icewm

-   Another tool written in perl is the archlinux-xdg-menu:

    # xdg_menu --format icewm --fullmenu --root-menu /etc/xdg/menus/arch-applications.menu > ~/.icewm/menu

> Themes

Some themes are included by default, much larger selection is available
in the icewm-themes package in the repository, but even the best of them
have a spartan, 'old Windows' feel. Much better examples (like [1], [2]
or [3]) can be found at box-look.org.

File managers
-------------

It should be noted that IceWM is a window manager only and therefore
does not include a file manager. PCManFM and Rox Filer enable desktop
icons, but Idesk can also be used to achieve this functionality.

Note:For a greater listing of file managers, examine the File managers
category listing.

Troubleshooting
---------------

> No start menu icon (Intel graphics)

If you have Intel Graphics you may find that the start menu in your
taskbar has no icon. This is due to a recent change in the
xf86-video-intel driver which means that the newer, but more unstable,
SNA acceleration backend is used by default instead of the older stable
UXA acceleration backend. Instructions for changing the acceleration
backend can be found here.

> Unable to logout when PCManFM is managing the desktop

If you use PCManFM to manage the desktop you may find that the IceWM
logout button no longer works. The workaround is to define a logout
command. To do this, open ~/.icewm/preferences, uncomment the following
line: # LogoutCommand="" and enter a command which can be used to
logout. For example: LogoutCommand="pkill -u username" where username is
your username.

> No shutdown or reboot options in logout menu (logout command has been defined)

Shutdown and reboot commands will be ignored if a logout command has
been defined. If you want shutdown and reboot options in the logout menu
then you must not define a logout command.

> No shutdown or reboot options in logout menu (logout command has not been defined)

If you have defined shutdown and reboot commands (such as systemctl
poweroff and systemctl reboot) and you have not defined a logout command
but you still find that there are no shutdown or reboot options in the
logout menu then it is likely that you are using IceWM 1.3.8. An
upstream bug, introduced into IceWM 1.3.8, renders many menu dialogs
inert. See here and here The only known workaround is to downgrade to
IceWM 1.3.7. You can find the IceWM 1.3.7 package in the Arch Rollback
Machine.

See also
--------

-   Xinitrc
-   Official IceWM website
-   IceWM - Gentoo Linux Wiki
-   IceWM - The Cool Window Manager - Detailed introduction on OSNews
-   IceWM - A desktop for Windows emigrants - Overview and tutorial from
    polishlinux.org

Retrieved from
"https://wiki.archlinux.org/index.php?title=IceWM&oldid=302743"

Category:

-   Stacking WMs

-   This page was last modified on 1 March 2014, at 14:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
