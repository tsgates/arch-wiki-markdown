Pacman GUI Frontends
====================

This is a list of frontends for the pacman CLI tool. The list includes
full featured GUI frontends, informational tools, and a variety of
system tray notifiers. The list also includes categories for GTK2 based
and Qt based software.

Warning:None of these tools are officially supported by Arch
Linux/Pacman developers.

Contents
--------

-   1 Pacman frontends
    -   1.1 X11
    -   1.2 GNOME/GTK+
    -   1.3 KDE/Qt
    -   1.4 Ncurses
-   2 Pacman/AUR package browser
-   3 System tray notifiers
-   4 Inactive software packages

Pacman frontends
----------------

> X11

-   PacmanXG4 — GUI front-end for pacman. Depends neither GTK+ nor Qt,
    just X11. This graphical tool allows to do the following:

-   Install/remove/upgrade packages
-   Search packages/filter packages
-   Retrieve package info include screenshots
-   Downgrade packages (need downgrade utility from AUR)
-   Refresh package database, synchronize mirrors.
-   Update system in one click
-   Find out which package a specific file belongs to (include file with
    pkgfile utility)
-   Package Cache management
-   yaourt support

Screenshots
http://almin-soft.ru/index.php?programmy/pacmanxg/pacmanxg-screenshots  

Direct link to binary:
http://almin-soft.ru/data/files/pacmanxg/download.php?get=pacmanXG4.tar.bz2

Web page:
http://almin-soft.ru/index.php?programmy/pacmanxg/tags/pacmanxg (ru,
present "Google site translate" ability) || AUR : pacmanxg4-bin

-   PacmanExpress — GUI front-end for pacman. Depends neither GTK+ nor
    Qt, just X11. This graphical tool is a lightweight version of
    PacmanXG

-   Interface "all in one box"
-   No query. Install/remove packages takes place immediately.
-   Ability to run multiple operations/remove packages (be careful!)
-   yaourt support

Direct link to binary:
http://almin-soft.ru/data/files/pacmanxg/download.php?get=pacmanexpress.tar.bz2

Web page:
http://almin-soft.ru/index.php?programmy/pacmanexpress/tags/pacmanexpress
(ru, present "Google site translate" ability) || AUR : pacmanexpress

-   tkPacman — GUI front-end for pacman. Depends on Tcl/Tk and X11 but
    neither on GTK+, nor on QT. It only interacts with the package
    database via the CLI of 'pacman'. So, installing and removing
    packages with tkPacman or with pacman leads to exactly the same
    result.

-   Browse packages available in repositories;
-   Browse installed packages;
-   Many ways for filtering packages (word, group, repo, upgrades,
    orphans, explicit, foreign, fileowner);
-   Display detailed information of packages;
-   Display list of files belonging to installed packages;
-   Refresh package database;
-   Full system upgrade;
-   Install a package from a local file;
-   View pacman.log file.

Web page:http://sourceforge.net/projects/tkpacman || AUR : tkpacman

> GNOME/GTK+

-   GNOME PackageKit — Distribution-agnostic collection of utilities for
    managing packages. Using the alpm backend, it supports the following
    features:

-   Install and remove packages from the repos.
-   Periodically refresh package databases and prompt for updates.
-   Install packages from tarballs.
-   Search for packages by name, description, category or file.
-   Show package dependencies, files and reverse dependencies.
-   Ignore IgnorePkgs and hold HoldPkgs.
-   Report optional dependencies, .pacnew files, etc.

You can change the remove operation from -Rc to -Rsc by setting the
DConf key org.gnome.packagekit.enable-autoremove.

http://packagekit.org/ || gnome-packagekit

-   zenity_pacgui — Zenity GUI for Pacman.

http://sourceforge.net/projects/zenitypacgui/ || zenity_pacgui

-   Argon — lightweight python GUI package manager

-   package installation/removal and system update, including AUR (via
    pacaur)
-   top-level package list
-   configurable update notifier

http://code.google.com/p/arch-argon || argon

> KDE/Qt

-   KPackageKit/Apper — GUI frontend for PackageKit. Pacman integration
    is accomplished via the packagekit, which gained upstream support
    for pacman. This graphical tool allows to do the following from
    KDE's systemsettings:

-   Install/remove/upgrade packages
-   Search packages/filter packages
-   Retrieve package info
-   Refresh package database
-   Choose which repositories will be updated
-   Automatically refresh database (Hourly, daily etc.)
-   Automatically update packages

While pacman support in PackageKit is relatively new, it works with no
major problems, providing ease of use, simplicity, and good integration
with KDE (and PolicyKit).

Screenshots: http://kde-apps.org/content/show.php/Apper?content=84745

http://kde-apps.org/content/show.php/Apper?content=84745 || apper

-   AppSet — Advanced and feature rich GUI front-end for Package
    Managers. AppSet has the following features:

-   Software sections (games, office, multimedia, internet etc.)
-   Shows homepages for selected packages in an embedded web browser
-   Shows distributions news with an embedded feed reader
-   Upgrades, installs and removes packages
-   Shows available upgrades with a Tray Icon
-   Updates database periodically
-   Informs about dependencies (for example when trying to remove a
    package needed by others)
-   Cache clean command (to free disk space)
-   Intelligent launcher that uses what is already installed to get
    administrative privileges (by searching for kdesu, gksu or at last
    for an xterm where it starts with a sudo command)
-   Now with AUR support with Packer as backend

AppSet needs only QT libs as dependence for installation. It can be used
in any desktop environment. Currently only works for Archlinux using
pacman.

Screenshots
http://sourceforge.net/project/screenshots.php?group_id=376825

http://appset.sourceforge.net/ || appset-qt

-   Octopi — Powerful Pacman frontend written in Qt. Features include:

-   LOW in resource consumption (including memory)
-   FAST
-   Supports Arch, ArchBang, Chakra and Manjaro Linux
-   Supports KDE 4.x, XFCE, LXDE, MATE, Openbox and TDE
-   Systemtray icon providing notifier support
-   Pacman sync database, system upgrade and clean cache support
-   Yaourt support
-   Install/Re install/Upgrade/Remove selected packages – watching the
    output of these commands on demand – in a trasaction based
    abstraction
-   View the contents of installed packages (including opening and
    editing its files)
-   View the description of packages in tooltips, just moving the mouse
    over them

Octopi needs QT4 libs as dependence for installation.

Screenshots http://octopiproject.wordpress.com/screenshots/

http://octopiproject.wordpress.com/ || octopi-git

> Ncurses

-   pcurses — Package management in a curses frontend, including:

-   regexp filtering and searching any package property
-   customizable colorcoding
-   customizable sorting
-   external command execution with package list string replacements
-   user defined macros and hotkeys

Screenshots https://bbs.archlinux.org/viewtopic.php?id=122749

https://github.com/schuay/pcurses || pcurses

-   yaourt-gui — Designed for new users who want to start using Arch
    Linux. Written in Bash, it offers a GUI from terminal to the common
    tasks of yaourt and pacman.

Screenshots http://sourceforge.net/projects/yaourt-gui/   

Direct link to source:
http://sourceforge.net/projects/yaourt-gui/files/yaourt-gui-0.9.tar.gz

Web page:http://alexiobash.com/yaourt-gui-a-bash-gui-per-yaourt-3/ ||
AUR : yaourt-gui

Pacman/AUR package browser
--------------------------

-   PkgBrowser — Application for searching and browsing Arch packages,
    showing details on selected packages.

-   Search and browse Arch packages including the AUR
-   Purely an informational application that cannot be used to install,
    remove or update packages
-   By design, is an accessory to CLI package management via pacman
-   Further details on use via manual accessed from help menu

Forum page: https://bbs.archlinux.org/viewtopic.php?id=117297   

https://code.google.com/p/pkgbrowser/ || pkgbrowser

-   Pacinfo — Application to browse the installed packages and show
    information like screenshot, installed files, installation date and
    others. Written in Mono/GTK#

https://code.google.com/p/pacinfo/ || pacinfo

System tray notifiers
---------------------

-   Aarchup — Fork of archup. Has the same options as archup plus a few
    other features. For differences between both please check changelog.

Screenshots: http://i.imgur.com/yTNvg.png

https://github.com/aericson/aarchup/ || aarchup

-   pacman-notifier — Written in Ruby, uses GTK+. Shows an icon in the
    system tray and popup notifications (using libnotify) for new
    packages.

Screenshots: https://github.com/v01d/pacman-notifier/wiki

https://github.com/v01d/pacman-notifier/wiki || pacman-notifier

-   Pacupdate — Small application that notifies the user about new
    updates for Arch Linux. If Pacupdate finds out that a update is
    available, it will display a notification in SystemTray

https://code.google.com/p/pacupdate/ || pacupdate-svn

-   Yapan — Written in C++ and Qt. It shows an icon in the system tray
    and popup notifications for new packages and supports AUR helpers.

Forum page: https://bbs.archlinux.org/viewtopic.php?id=113078

http://code.google.com/p/arch-yapan/ || yapan

-   ZenMan — Pacman frontend (tray update notifier) for
    GTK+/GNOME/zenity/libnotify.

Screenshots: http://show.harvie.cz/screenshots/zenman-screenshot-2.png

https://aur.archlinux.org/packages.php?ID=25948 || zenman

-   pkgnotify.sh — Simple 14 line shell script that displays the number
    of available updates in the dzen2 title window and a list of these
    updates in the slave window. Depends on dzen2, inotify-tools,
    package-query and optionally an AUR helper (yaourt by default).

Screenshots:
http://andreasbwagner.tumblr.com/post/853471635/arch-linux-update-notifier-for-dzen2

http://pointfree.net/repo/?r=dzen2_scripts;a=headblob;f=/src/pkgnotify/pkgnotify.sh
|| not packaged? search in AUR

-   kalu — Small C application that adds an icon in the systray and can
    show notifications for Arch Linux News, Upgrades, AUR upgrades, and
    watched (AUR) upgrades (upgrades for packages not installed). Also
    includes a GUI system upgrader.

Screenshots: http://jjacky.com/kalu

Forum: https://bbs.archlinux.org/viewtopic.php?id=135773

https://github.com/jjk-jacky/kalu || kalu

Inactive software packages
--------------------------

-   Wakka - Next generation of gtkpacman
-   GtkPacman - GTK+ frontend
-   Guzuta - GTK+ frontend.
-   Shaman - GUI using Pacman’s libalpm library
-   pacmon - notification GUI.
-   Paku - GUI alternative to Pacman.
-   YAPG.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pacman_GUI_Frontends&oldid=305406"

Categories:

-   Arch User Repository
-   Package management

-   This page was last modified on 18 March 2014, at 07:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
