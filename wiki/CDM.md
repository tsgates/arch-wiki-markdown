CDM
===

Summary

Describes installing, configuring and using CDM, minimalistic
replacement for login-managers.

Related articles

Display Manager

CDM is a minimalistic, yet full-featured replacement for login-managers
like slim, kdm, gdm and qingy that provides a fast, dialog-based login
system without the overhead of the X Window System or the instability of
qingy. Written in pure bash, CDM has almost no dependencies, yet
supports multiple users/sessions and can start virtually any DE/WM.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Menu items                                                   |
|     -   2.2 Theming                                                      |
|     -   2.3 Starting X                                                   |
|                                                                          |
| -   3 Custom commands for power operations                               |
|     -   3.1 ConsoleKit method                                            |
|     -   3.2 systemd method                                               |
|                                                                          |
| -   4 More resources                                                     |
+--------------------------------------------------------------------------+

Installation
------------

Install the cdm-git package which is available in the AUR.

Now ensure no other other display managers get started by disabling
their systemd services with systemctl disable.

For example, if you were using the Gnome Display Manager, you would stop
it from starting at boot by running

    # systemctl disable gdm.service

There is no need to enable a systemd service for CDM. Rather, a script
called zzz-cdm.sh will be placed into /etc/profile.d. This script (along
with the rest of the scripts in /etc/profile.d) is run when you login to
a login shell. However, in order to prevent a sceanario where a broken
configuration prevents a user from accessing both their desktop and a
virtual terminal, the script checks to see which virtual terminal it is
being run on, and will by default only run on tty1.

Since the script is placed in the global /etc/profile.d directory, CDM
will be run for all users who login on tty1. If you would rather it only
run for you, take away executable permissions from
/etc/profile.d/zzz-cdm.sh and copy the contents of that file into your
~/.bash_profile for bash, or ~/.zprofile for zsh.

Configuration
-------------

You can configure CDM by editing /etc/cdmrc. It is fully documented and
should be relatively easy to figure out. You can also have user specific
config files by copying /etc/cdmrc to $HOME/.cdmrc.

> Menu items

Menu items are configured using three arrays: binlist, namelist and
flaglist. Order of items in these arrays is important, items with the
same index describe the same menu item. binlist contains commands which
are executed, namelist contains names which are shown in the menu and
flaglist contains type of the programs specified in binlist, either 'X'
for X sessions or 'C' for console programs. Basically X sessions are
started using startx (the item in binlist is argument of startx command)
and console programs are started using exec.

There is a sample configuration:

    binlist=(
      "~/.xsession"                                   # Launch your X session,
      "/bin/bash --login"                           # or just execute your shell,
      "/usr/bin/fbterm"                             # or start a frame buffer console,
      "/usr/bin/cdm ~/.submenu.cdmrc"  # or go to a submenu :)
    )
    namelist=("X session" Console FBTerm "Sub menu")
    flaglist=(X C C C)

> Theming

Themes are located in /usr/share/cdm/themes, all you have to do is pass
full path of the theme file to dialogrc variable in /etc/cdmrc, for
example

    dialogrc=/usr/share/cdm/themes/cdm

The theme syntax is fairly self explanatory, the best way to start a new
theme would be to duplicate and edit an existing theme.

> Starting X

You can affect the process of starting X server in several ways - use of
ConsoleKit is optional, you can specify on which tty the X server will
be started (specify either number or 'keep' if you want to run X server
on current tty), and finally you can specify custom X server arguments.

Custom commands for power operations
------------------------------------

If you want to add entries for power operations, like shutdown, reboot
etc., you can include them in binlist array.

> ConsoleKit method

If you use ConsoleKit for session authentication, see
ConsoleKit#Use_dbus_for_power_operations.

> systemd method

If you use systemd, see Systemd#Power_Management.

More resources
--------------

-   The Console Display Manager - Archlinux Forums thread about CDM
-   Aur package:cdm-git
-   GitHub page

Retrieved from
"https://wiki.archlinux.org/index.php?title=CDM&oldid=252811"

Category:

-   Display managers
