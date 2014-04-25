Razor-qt
========

Razor-qt is an advanced, easy-to-use, and fast toolbox-like desktop
environment, which is, like KDE, based on Qt technologies. It has been
tailored for users who value simplicity, speed, an intuitive interface
and high customizability, therefore it features only few basic
components, while most applications, like a File-Manager, have to be
added by the user. Due to this, Razor-QT runs fine on weak machines,
too.

Contents
--------

-   1 Merge with LXDE-Qt
-   2 Installation
-   3 Window Manager
    -   3.1 Compiz
-   4 Suggested Applications
-   5 Troubleshooting

Merge with LXDE-Qt
------------------

Razor-qt and LXDE share the same philosophy. Both strive for small
footprint, limited dependencies and modularity. So they decided the best
course of action for both projects is to focus on a single desktop
environment, instead of two. The plan is to cherry-pick the best parts
of Razor and LXDE and include or port those to LXDE-Qt (Lxqt). Other
components will be ported straight from GTK code or rewritten from
scratch.

As for Razor-qt, 0.6.0 will be the final package for those who are happy
with the desktop as it is. After the release, there are no further plans
to maintain the Razor-qt tree on its own. All developer will all be
working on the LXDE-Qt repositories.

Installation
------------

There are packages razor-qt and razor-qt-git in the AUR that allows you
to install it. On a fresh ArchLinux, you'd probably want to add a
Login-Manager, too, for example SLiM.

When starting Razor-QT by .xinitrc (including use of SLiM as login
manager), the appropriate command is

    exec razor-session

You may want to copy the default configuration file to your home folder
for additional customization.

    mkdir -p ~/.config/razor
    cp /etc/xdg/razor/session.conf ~/.config/razor

Window Manager
--------------

Razor-QT has no Window Managers of its own, but it will run with most
Window Managers. Openbox is "the Official WM of razor-qt" but you can
choose your own either through Razor's Session Management tool, or by
editing ~/.config/razor/session.conf.

More information about razor-qt and Window Manager integration can be
found on the Razor-qt wiki.

> Compiz

In order to use Compiz as Razor's Window Manager, you have to edit your
session.conf like this:

    [General]
    windowmanager=compiz ccp

Methods like fusion-icon, adding compiz to the .xinitrc or
compiz --replace ccp & will usually result in crashing X.

Suggested Applications
----------------------

A fresh Razor-QT won't provide much of the tools you need, as it leaves
to the user, what to add. A collection on useful apps (which use QT) are
found on the projects homepage at 3rd Party applications.

Troubleshooting
---------------

When Razor's applications don't stick with your QT-theme (especially
when using KDE's system settings to set your theme), then as of KDE
4.6.1 you'll probably need to tell Qt how to find KDE's styles (Oxygen,
QtCurve etc.)

You just need to set the environment variable QT_PLUGIN_PATH. E.g. put

    export QT_PLUGIN_PATH=$HOME/.kde4/lib/kde4/plugins/:/usr/lib/kde4/plugins/

into your /etc/profile (or ~/.profile if you do not have root access).
qtconfig should then be able to find your kde styles and everything
should look nice again!

Alternatively, you can symlink the Qt styles directory to the KDE styles
one:

    # ln -s /usr/lib/kde4/plugins/styles/ /usr/lib/qt/plugins/styles

Retrieved from
"https://wiki.archlinux.org/index.php?title=Razor-qt&oldid=306025"

Category:

-   Desktop environments

-   This page was last modified on 20 March 2014, at 17:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
