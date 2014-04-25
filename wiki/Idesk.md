Idesk
=====

Idesk is a simple program for putting icons on your X desktop. It can
also manage your wallpaper with a built in changer similar to that found
in Windows 7.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Background options
    -   2.2 Icons
    -   2.3 Idesktool
-   3 Issues

Installation
------------

Install idesk from the official repositories, then set up in your home
directory:

    $ mkdir ~/.idesktop
    $ cp /usr/share/idesk/dot.ideskrc ~/.ideskrc

optional:

    $ cp /usr/share/idesk/default.lnk ~/.idesktop/

(the default icon just runs Xdialog to display a little message but can
be used as a template)

Configuration
-------------

The idesk package doesn't come with a man page, but it does come with a
readme file: /usr/share/idesk/README. There's also documentation on
SourceForge.net, even though most of the options are self-explanatory.

> Background options

If you're using another program for setting wallpaper (such as feh) the
defaults will work fine (you may want to set Background.File and
Background.Source to "/" to silence the error messages).

Background.Source seems to take predence over Background.File; however,
it is ignored if Background.Delay is set to 0.

Supported wallpaper formats include JPEG, PNG, GIF, and XPM.

> Icons

Idesk looks in ~/.idesktop for files which names end with .lnk for
icons. Each file should define one icon (if you attempt to define a
second icon it will be silently ignored). Aside from ending with .lnk,
the files' names are not important.

Example for Chromium:

    chromium.lnk

    table Icon
      Caption: Chromium
      ToolTip.Caption: Google's OSS Web Browser
      Icon: /usr/share/icons/hicolor/32x32/apps/chromium.png
      Width: 32
      Height: 32
      X: 977
      Y: 369
      Command[0]: chromium
    end

Width and Height should match the actual dimensions of the icon. X and Y
will be modified by idesk to reflect the icon's actual position.

> Tip:

-   Most system icons can be found in the following locations:
    /usr/share/icons/hicolor and /usr/share/icons/gnome.
-   If you are wondering which size to use for your icons, 48x48 is a
    decent standard size for desktop icons.

> Idesktool

The idesk-extras package in the AUR provides a graphical configuration
tool for Idesk. It can be started by running the idesktool command.

Issues
------

I've noticed that icons seem to show the contents of semi-transparent
urxvt windows that are on other desktops... I'm not sure it this's the
fault of idesk, urxvt, OpenBox, or xcompmgr. It's not that irritating,
so I do not plan to look into it, but it is odd... --Solarshado 01:09, 3
November 2010 (EDT)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Idesk&oldid=306155"

Category:

-   X Server

-   This page was last modified on 20 March 2014, at 19:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
