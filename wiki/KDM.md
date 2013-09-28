KDM
===

Summary

Provides an overview of the default display manager for the KDE.

Related

Display Manager

KDE

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installation                                                       |
| -   3 Configuration                                                      |
|     -   3.1 Themes                                                       |
|     -   3.2 Themes creation                                              |
|         -   3.2.1 ServerArgsLocal                                        |
|         -   3.2.2 Allow Root login                                       |
|         -   3.2.3 SessionsDirs                                           |
|         -   3.2.4 Session                                                |
|         -   3.2.5 Restart X server menu option                           |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 Keyboard maps                                                |
|     -   4.2 Slow KDM Start                                               |
+--------------------------------------------------------------------------+

Introduction
------------

KDM (KDE Display Manager) is the login manager of KDE. It supports
themes, auto-logging, session type choice, and numerous other features.

Installation
------------

Install the kdebase-workspace package:

    # pacman -S kdebase-workspace

Configuration
-------------

An example configuration for KDM can be found at
/usr/share/config/kdm/kdmrc. See
/usr/share/doc/HTML/en/kdm/kdmrc-ref.docbook for all options.

You can visit System Settings > Login Screen and make your changes.
Whenever you press "Apply", a KDE Polkit authorization window appears
which will ask you to give your root password in order to finish the
changes.

If you seem not to be able to edit KDM's settings when launching System
Settings as user, you can use kdesu:

    $ kdesu kcmshell4 kdm

In the pop-up kdesu window, enter your root password and wait for System
Settings to be launched. Then go to Login Screen.

Note: Since you have launched it as root, be careful when changing your
settings. All settings configuration in root-launched System Settings
are saved under /root/.kde4 and not under ~/.kde4 (your home location).

> Themes

Archlinux KDM themes can be installed with:

    # pacman -S archlinux-themes-kdm

Many other KDM 4 themes are available at
http://kde-look.org/index.php?xcontentmode=41. Choose between the
installed themes in System Settings (run as root) as described above.

> Themes creation

Themes files are in /usr/share/apps/kdm/themes.

The theme format is the same one as GDM, a documentation can be found
here: Detailed Description of Theme XML format.

ServerArgsLocal

To force the number of dots per inch of the X server, add a -dpi option
to ServerArgsLocal. A commonly used value is 96 dpi.

    /usr/share/config/kdm/kdmrc

    [...]
    ServerArgsLocal=-dpi 96 -nolisten tcp
    [...]

Allow Root login

To allow root login in KDM do:

    # sed -ie 's/AllowRootLogin=false/AllowRootLogin=true/' /usr/share/config/kdm/kdmrc

SessionsDirs

This variable stores a list of directories containing session type
definitions in .desktop format, ordered by falling priority. In Arch
Linux some window managers install such files in /usr/share/xsessions.
Add that to the list in order to be able to select them in KDM:

    /usr/share/config/kdm/kdmrc

    [...]
    SessionsDirs=/usr/share/config/kdm/sessions,/usr/share/apps/kdm/sessions,/usr/share/xsessions
    [...]

Session

The Session variable is the name of a program which is run as the user
who logs in. It is supposed to interpret the session argument (see
SessionsDirs) and start the session as desired for that argument. One
may wish to customize this for window manager sessions, for example to
set a wallpaper and start a screensaver. To do this in a way which will
survive pacman updates (which clobber Xsession) do as follows:

    # cp /usr/share/config/kdm/Xsession /usr/share/config/kdm/Xsession.custom

In kdmrc set:

    /usr/share/config/kdm/kdmrc

    [...]
    Session=/usr/share/config/kdm/Xsession.custom
    [...]

And then edit Xsession.custom as desired.

Restart X server menu option

To allow users to restart the X server from KDM, edit this option in
kdmrc:

    /usr/share/config/kdm/kdmrc

    [X-:*-Greeter]
    [...]
    # Show the "Restart X Server"/"Close Connection" action in the greeter.
    # Default is true
    AllowClose=true
    [...]

This feature will be available in the menu drop-down options. The option
also includes a hotkey of Alt+E.

Troubleshooting
---------------

> Keyboard maps

KDM keyboard keymap can be set through the configuration system (login
screen section).

> Slow KDM Start

If KDM is taking a long time to display the login screen (e.g. 15-30
seconds) you may try rebuilding the X font caches:

    # fc-cache -fv

Retrieved from
"https://wiki.archlinux.org/index.php?title=KDM&oldid=251612"

Category:

-   Desktop environments
