KDE
===

Related articles

-   Desktop environment
-   Display manager
-   Window manager
-   Plasma
-   Qt
-   KDM
-   KDevelop 4
-   Uniform Look for Qt and GTK Applications

From KDE Software Compilation and Getting KDE Software:

The KDE Software Compilation is the set of frameworks, workspaces, and
applications produced by KDE to create a beautiful, functional and free
desktop computing environment for Linux and similar operating systems.
It consists of a large number of individual applications and a desktop
workspace as a shell to run these applications.

The KDE upstream has a well maintained UserBase wiki. Users can get
detailed information about most KDE applications there.

Contents
--------

-   1 Installation
    -   1.1 Full install
    -   1.2 Minimal install
    -   1.3 Language pack
-   2 Upgrading
-   3 Starting KDE
    -   3.1 Using a Display Manager
        -   3.1.1 KDM (KDE Display Manager)
        -   3.1.2 LightDM
    -   3.2 Using xinitrc
-   4 Configuration
    -   4.1 Personalization
        -   4.1.1 Plasma desktop
            -   4.1.1.1 Themes
            -   4.1.1.2 Widgets
            -   4.1.1.3 Sound applet in the system tray
            -   4.1.1.4 Adding a Global Menu to the desktop
        -   4.1.2 Window decorations
        -   4.1.3 Icon themes
        -   4.1.4 Fonts
            -   4.1.4.1 Fonts in KDE look poor
            -   4.1.4.2 Fonts are huge or seem disproportional
        -   4.1.5 Space efficiency
    -   4.2 Networking
    -   4.3 Printing
    -   4.4 Samba/Windows support
    -   4.5 KDE Desktop activities
    -   4.6 Power saving
    -   4.7 Monitoring changes on local files and directories
-   5 System administration
    -   5.1 Set keyboard
    -   5.2 Terminate Xorg server through KDE system settings
    -   5.3 KCM
-   6 Desktop search and semantic desktop
    -   6.1 Virtuoso and Soprano
    -   6.2 Nepomuk
        -   6.2.1 Using and configuring Nepomuk
        -   6.2.2 KDE without Nepomuk
    -   6.3 Akonadi
        -   6.3.1 Disabling Akonadi
        -   6.3.2 Database configuration
        -   6.3.3 Running KDE without Akonadi
-   7 Phonon
    -   7.1 What is Phonon?
    -   7.2 Which backend should I choose?
-   8 Useful applications
    -   8.1 Yakuake
    -   8.2 KDE Telepathy
-   9 Tips and tricks
    -   9.1 Using Openbox in KDE
        -   9.1.1 When using KDM
        -   9.1.2 Re-enabling compositing effects
    -   9.2 Integrate Android with the KDE Desktop
    -   9.3 Get notifications for software updates
    -   9.4 Configure KWin to use OpenGL ES
    -   9.5 Enabling audio/video thumbnails under Konqueror/Dolphin file
        managers
    -   9.6 Speed up application startup
    -   9.7 Hiding partitions
    -   9.8 Konqueror tips
        -   9.8.1 Disabling smart key tooltips (browser)
        -   9.8.2 Using WebKit
    -   9.9 Firefox integration
    -   9.10 Setting the screensaver background to the same as the
        current one
    -   9.11 Setting lockscreen wallpaper to arbitrary image
-   10 Troubleshooting
    -   10.1 Configuration related
        -   10.1.1 Reset all KDE configuration
        -   10.1.2 File Indexer Service not working even after enabling
            everything properly
        -   10.1.3 Plasma desktop behaves strangely
        -   10.1.4 Clean cache to resolve upgrade problems
    -   10.2 Clean akonadi configuration to fix KMail
    -   10.3 Getting current state of KWin for support and debug
        purposes
    -   10.4 KDE4 does not finish loading
    -   10.5 KDE and Qt programs look bad when in a different window
        manager
    -   10.6 Graphical related problems
        -   10.6.1 Low 2D desktop performance (or) artifacts appear when
            on 2D
            -   10.6.1.1 GPU driver problem
            -   10.6.1.2 The Raster engine workaround
        -   10.6.2 Low 3D desktop performance
        -   10.6.3 Desktop compositing is disabled on my system with a
            modern Nvidia GPU
        -   10.6.4 Flickering in fullscreen when compositing is enabled
        -   10.6.5 Screen Tearing with desktop compositing enabled
        -   10.6.6 Display settings lost on reboot (multiple monitors)
    -   10.7 Sound problems under KDE
        -   10.7.1 ALSA related problems
            -   10.7.1.1 "Falling back to default" messages when trying
                to listen to any sound in KDE
            -   10.7.1.2 MP3 files cannot be played when using the
                GStreamer Phonon backend
    -   10.8 Konsole does not save commands' history
    -   10.9 KDE password prompts display three bullets per char
    -   10.10 Nepomukserver process still autostarts even with semantic
        desktop disabled
    -   10.11 Dolphin and File Dialogs are extremely slow to start
    -   10.12 Default PDF viewer in GTK applications under KDE
-   11 Unstable releases
-   12 Other KDE projects
    -   12.1 Trinity
-   13 Bugs
-   14 See also

Installation
------------

Before installing KDE, make sure you have a working Xorg installation on
your system.

KDE 4.x is modular. You can install an entire set of packages or only
install your preferred KDE applications.

> Full install

Install kde or kde-meta available in the official repositories. For
differences between kde and kde-meta see the KDE Packages article.

> Minimal install

If you want to have a minimal installation of the KDE Software
Compilation, install kdebase.

> Language pack

If you need language files, install kde-l10n-yourlanguagehere (e.g.
kde-l10n-de for the German language).

For a full list of available languages see this link.

Upgrading
---------

KDE 4.12 Software Compilation is the current major release of KDE.
Important hints for upgraders:

-   Always check if your mirror is up to date.
-   Do not force an update using # pacman --force. If pacman complains
    about conflicts please file a bug report.
-   You can remove the meta packages and the sub packages you do not
    need after the update.
-   If you do not like split packages just keep using the kde-meta
    packages.

Starting KDE
------------

Starting KDE depends on your preferences. Basically there are two ways
of starting KDE. Using KDM or xinitrc.

> Using a Display Manager

A display manager, or login manager, is typically a graphical user
interface that is displayed at the end of the boot process in place of
the default shell. It allows easily logging in straight to KDE. KDE has
its own display manager, KDM.

KDM (KDE Display Manager)

See the KDM page for more information.

Enable/start kdm.service to start the display manager.

LightDM

See the LightDM page for more information.

To ensure the best integration with KDE, it is recommended to make sure
the following packages are installed:

-   lightdm-kde-greeter: add the ability to configure LightDM via the
    KDE system settings;
-   accountsservice and kdebase-kdepasswd: add the ability to change
    your LightDM avatar picture via the KDE Settings.

> Using xinitrc

See the xinitrc page for more information.

    ~/.xinitrc

    exec startkde

Execute startx or xinit to start KDE.

Note:If you want to start Xorg at boot, please read the Start X at Login
article.

Configuration
-------------

All KDE configuration is saved in the ~/.kde4 folder. If KDE is giving
you a lot of trouble or if you ever want a fresh installation of KDE,
just backup and rename this folder and restart your X session. KDE will
re-create it with all the default configuration files. If you want very
fine-grained control over KDE programs, you may want to edit the files
in this folder.

However, configuring KDE is primarily done in System Settings. A few
other options for the desktop are available in Default Desktop Settings
in the desktop's context menu.

For other personalization options not covered below such as activities,
different wallpapers on one cube, etc., please refer to the Plasma wiki
page.

> Personalization

How to set up the KDE desktop to your personal style: use different
Plasma themes, window decorations and icon themes.

Plasma desktop

Plasma is a desktop integration technology that provides many functions
like displaying the wallpaper, adding widgets to the desktop, and
handling the panel(s), or "taskbar(s)".

Themes

Plasma themes can be installed through the Desktop Settings control
panel. Plasma themes define the look of panels and plasmoids. For easy
system-wide installation, some such themes are available in both the
official repositories and the AUR.

Widgets

Plasmoids are little scripted (plasmoid scripts) or coded (plasmoid
binaries) KDE applications designed to enhance the functionality of your
desktop.

Plasmoid binaries can be installed using PKGBUILDs from AUR, or you can
write your own PKGBUILD.

The easiest way to install plasmoid scripts is by right-clicking onto a
panel or the desktop:

    Add Widgets > Get new Widgets > Download Widgets

This will present a nice frontend for kde-look.org that allows you to
install, uninstall, or update third-party plasmoid scripts with
literally just one click.

Most plasmoids are not created officially by KDE developers. You can
also try installing Mac OS X widgets, Microsoft Windows Vista/7 widgets,
Google Widgets, and even SuperKaramba widgets.

Sound applet in the system tray

Install Kmix (kdemultimedia-kmix) from the official repositories and
start it from the application launcher. Since KDE, by default,
autostarts programs from the previous session, it does not need to be
started manually upon every login.

Note:To adjust the step size of volume increments/decrements, add e.g.
VolumePercentageStep=1 in the [Global] section of
~/.kde4/share/config/kmixrc

Adding a Global Menu to the desktop

Install appmenu-qt from the official repositories and appmenu-gtk and
appmenu-qt5 from the AUR in order to complete the preliminaries for a
Mac OS X style always-on global menu. To get Firefox and LibreOffice to
use the global menu as well, install firefox-extension-globalmenu and
libreoffice-extension-menubar from the AUR.

Warning:firefox-extension-globalmenu has been deprecated as of Firefox
25 and there is no other recommended method for getting the global menu.
However, there is a patched package, firefox-ubuntu available in the AUR
which has Canonical's patch for getting the global menu to work with the
current version of Firefox (as of this writing).

To actually get the global menu, install kdeplasma-applets-menubar from
the AUR. Create a plasma-panel on top of your screen and add the window
menubar applet to the panel. To export the menus to your global menu, go
to System Settings > Application Appearance > Style. Now click the
fine-tuning tab and use the drop-down list to select only export as your
menubar style.

Window decorations

Window decorations can be changed in:

    System Settings > Workspace Appearance > Window Decorations

There you can also directly download and install more themes with one
click, and some are available in the AUR.

Icon themes

Not many full system icons themes are available for KDE 4. You can open
up System Settings > Application Appearance > Icons and browse for new
ones or install them manually. Many of them can be found on
kde-look.org.

Official logos, icons, CD labels and other artwork for Arch Linux are
provided in the archlinux-artwork package. After installing you can find
such artwork at /usr/share/archlinux/.

Fonts

Fonts in KDE look poor

Try installing the ttf-dejavu and ttf-liberation packages.

After the installation, be sure to log out and back in. You should not
have to modify anything in System Settings > Fonts.

If you have personally set up how your Fonts render, be aware that
System Settings may alter their appearance. When you go System Settings
> Appearance > Fonts, System Settings will likely alter your font
configuration file (fonts.conf).

There is no way to prevent this, but, if you set the values to match
your fonts.conf file, the expected font rendering will return (it will
require you to restart your application or in a few cases restart your
desktop). Note that Gnome's Font Preferences also does this.

Fonts are huge or seem disproportional

Try to force font DPI to 96 in System Settings > Application Appearance
> Fonts.

If that does not work, try setting the DPI directly in your Xorg
configuration as documented here.

Space efficiency

Users with small screens (e.g. netbooks) can change some setting to make
KDE more space efficient. See the upstream wiki for more information.
Also, you can use KDE's Plasma Netbook which is a workspace made
specifically for small, lightweight netbook devices.

> Networking

You can choose from the following tools:

-   NetworkManager. See NetworkManager for more information.
-   Wicd. See Wicd for more information.

> Printing

Tip:Use the CUPS web interface for faster configuration. Printers
configured in this way can be used in KDE applications.

You can also configure printers in System Settings > Printer
Configuration. To use this method, you must first install
kdeutils-print-manager and cups.

The avahi-daemon and cupsd daemons must be started first; otherwise, you
will get the following error:

    The service 'Printer Configuration' does not provide an interface 'KCModule'
    with keyword 'system-config- printer-kde/system-config-printer-kde.py'
    The factory does not support creating components of the specified type.

If you are getting the following error, you need to give your user the
right to manage printers.

    There was an error during CUPS operation: 'cups-authorization-canceled'

For CUPS, this is set in /etc/cups/cups-files.conf.

Adding lp to SystemGroup allows anyone who can print to configure
printers. You can, of course, add another group instead of lp.

    /etc/cups/cups-files.conf

    # Administrator user group...
    SystemGroup sys root lp

Tip:Read the CUPS#CUPS_administration Article to get more details on how
to configure CUPS.

> Samba/Windows support

If you want to have access to Windows services, install Samba (package
samba).

You can then configure Samba shares through:

    System Settings > Sharing > Samba

> KDE Desktop activities

KDE Desktop Activities are Plasma-based virtual-desktop-like sets of
Plasma Widgets where you can independently configure widgets as if you
have more than one screen or desktop.

On your desktop, click the Cashew Plasmoid and, on the pop-up window,
press "Activities".

A plasma bar presenting you the current existing Plasma Desktop
Activities will appear at the bottom of the screen. You can navigate
between them by pressing the correspondent icons.

> Power saving

KDE has an integrated power saving service called "Powerdevil Power
Management" that may adjust the power saving profile of the system
and/or the brightness of the screen (if supported).

Since KDE 4.6, CPU frequency scaling is no longer managed by KDE.
Instead it is assumed to be handled automatically by the the hardware
and/or kernel. Arch has used ondemand as the default CPU frequency
governor since kernel version 3.3, so no additional configuration in
needed in most cases. For details on fine-tuning the governor, see CPU
Frequency Scaling.

> Monitoring changes on local files and directories

KDE now uses inotify directly from the kernel with kdirwatch (included
in kdelibs), so Gamin or FAM are no longer needed. You may want to
install this kdirwatch from AUR which is a GUI frontend for kdirwatch.

System administration
---------------------

> Set keyboard

Navigate to:

    System Settings > Hardware > Input Devices > Keyboard

In the first tab, you can choose your keyboard model.

In the "Layouts" tab, you can choose the languages you may want to use
by pressing the "Add Layout" button and subsequently choosing the
variant and the language.

In the "Advanced" tab, you can choose the keyboard combination you want
in order to change the layouts in the "Key(s) to change layout"
sub-menu.

> Terminate Xorg server through KDE system settings

Navigate to the submenu:

    System Settings > Input Devices > Keyboard > Advanced (tab) > "Key Sequence to kill the X server"

and tick the checkbox.

> KCM

KCM stands for KConfig Module. KCMs can help you configure your system
by providing interfaces in System Settings.

Configuration for look and feel of GTK applications.

-   kde-gtk-config
-   kcm-gtk
-   kcm-qt-graphicssystem

Configuration for the GRUB bootloader.

-   grub2-editor

Configuration for Synaptics touchpads.

-   synaptiks
-   kcm_touchpad
-   kcm-touchpad-git

Configuration for the Uncomplicated Firewall (UFW)

-   kcm-ufw

Configuration for PolicyKit

-   kcm-polkit-kde-git

Configuration for Wacom tablets

-   kcm-wacomtablet

More KCMs can be found at kde-apps.org.

Desktop search and semantic desktop
-----------------------------------

According to Wikipedia, "the Semantic Desktop is a collective term for
ideas related to changing a computer's user interface and data handling
capabilities so that data is more easily shared between different
applications or tasks and so that data that once could not be
automatically processed by a computer can be (automatically processed)."

The KDE implementation of this concept is tied to (as of KDE 4.10) two
major pieces of software, Akonadi and Nepomuk. Between the two of them,
these programs look at your data and make an easily searchable index of
it. The idea behind these pieces of software is to make your system
"aware" of your data and give it context using meta-data and
user-supplied tags.

Soprano and Virtuoso are two dependencies of the Nepomuk Semantic
Desktop. Since the relationship between the two major components and
their dependencies is not very clear, the following sections try to shed
some light on their inner workings.

> Virtuoso and Soprano

The database used to store all the metadata used by the semantic desktop
is a Resource Description Framework (RDF) database called Virtuoso.
Internally, Virtuoso may be looked as a relational database. (A
relational database is different from a traditional single-table based
database in the sense that it uses multiple tables related by a single
key in order to store data.) It is currently controlled by OpenLink and
is available under a commercial and an open source license.

From the KDE Techbase, Soprano is a Qt abstraction over databases. It
provides a friendly Qt-based API for accessing different RDF stores. It
currently supports 3 database backends - Sesame, Redland and Virtuoso.
The KDE Semantic Stack only works with Virtuoso. Soprano also provides
additional features such as serializing, parsing RDF data, and a client
server architecture that is heavily used in Nepomuk.

> Nepomuk

Nepomuk stands for "Networked Environment for Personal, Ontology-based
Management of Unified Knowledge". It is what allows all the tagging and
labeling of files as well to take place and also serves as the way to
actually read the Virtuoso databases. It provides an API to application
developers which allows them to read the data collected by it.

In the past, the "Strigi" service was used to collect data about the
various files present on the system. However, due to many reasons, the
most important of them being CPU and Memory usage, Strigi was replaced
by a homegrown indexing service which is integrated with Nepomuk-Core.

For further information about Nepomuk, this page is a good resource.
However, some of the information in the previous page has been rendered
outdated according to this blog post.

Using and configuring Nepomuk

In order to search using Nepouk on the KDE desktop, press ALT+F2 and
type in your query. Nepomuk is enabled by default. It can be turned on
and off in:

    System Settings > Desktop Search

Nepomuk has to keep track of a lot of files. It is for this reason that
it is recommended to increase the number of files that can be watched
with inotify. In order to do that this command is a good option.

    # sysctl fs.inotify.max_user_watches=524288

To do it persistently:

    # echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.d/99-inotify.conf

Restart Nepomuk to see the changes.

KDE without Nepomuk

If you wish to run KDE without Nepomuk, there exists a nepomuk-core-fake
package in the AUR.

Warning:As of now, Dolphin depends on nepomuk-widgets and hence will
break if used with the fake Nepomuk package.

> Akonadi

Akonadi is a system meant to act as a local cache for PIM data,
regardless of its origin, which can be then used by other applications.
This includes the user's emails, contacts, calendars, events, journals,
alarms, notes, and so on. It interfaces with the Nepomuk libraries to
provide searching capabilities.

Akonadi does not store any data by itself: the storage format depends on
the nature of the data (for example, contacts may be stored in vCard
format).

For more information on Akonadi and its relationship with Nepomuk, see
[1] and [2].

Disabling Akonadi

See this section in the KDE userbase.

Database configuration

Start akonaditray from package kdepim-runtime. Right click on it and
select configure. In the Akonadi server configure tab, you can:

-   Configuring Akonadi to use MySQL/MariaDB Server
    -   If your home directory is on a ZFS pool, you will need to create
        & edit ~/.config/akonadi/mysql-local.conf to include:

[mysqld]

innodb_use_native_aio = 0

This is issue is highlighted in MySQL#OS_error_22_when_running_on_ZFS

-   Configuring Akonadi to use PostgreSQL Server
-   Configuring Akonadi to use SQLite

Running KDE without Akonadi

The package akonadi-fake is a good option for those who wish to run KDE
without Akonadi.

Phonon
------

> What is Phonon?

From Wikipedia: Phonon is the multimedia API for KDE 4. Phonon was
created to allow KDE 4 to be independent of any single multimedia
framework such as GStreamer or xine and to provide a stable API for KDE
4's lifetime. It was done for various reasons: to create a simple KDE/Qt
style multimedia API, to better support native multimedia frameworks on
Windows and Mac OS X, and to fix problems of frameworks becoming
unmaintained or having API or ABI instability.

Phonon is being widely used within KDE, for both audio (e.g., the System
notifications or KDE audio apps) and video (e.g., the Dolphin video
thumbnails).

> Which backend should I choose?

You can choose between various backends like GStreamer
(phonon-gstreamer) or VLC (phonon-vlc), available in the official
repositories, and MPlayer (phonon-mplayer-git), QuickTime
(phonon-quicktime-git) or AVKode (phonon-avkode-git), available in the
AUR.

Most users will want VLC which has the best upstream support. GStreamer
is currently not well maintained. Note that multiple backends can be
installed at once and chosen at System Settings > Multimedia > Phonon >
Backend.

> Note:

-   According to the Feature Matrix, the GStreamer backend has some more
    features that the VLC backend.
-   According to the KDE UserBase, Phonon-MPlayer is currently
    unmaintained.

Useful applications
-------------------

The official set of KDE applications may be found here.

> Yakuake

Yakuake provides a Quake-like terminal emulator whose visibility is
toggled by the F12 key. It also has support for multiple tabs. Yakuake
is available in the package yakuake.

> KDE Telepathy

KDE Telepathy is a project with the goal to closely integrate Instant
Messaging with the KDE desktop. It utilizes the Telepathy framework as a
backend and is intended to replace Kopete.

To install all Telepathy protocols, install the telepathy group. To use
the KDE Telepathy client, install the kde-telepathy-meta package that
includes all the packages contained in the kde-telepathy group .

Tips and tricks
---------------

> Using Openbox in KDE

Tip:The native window manager for KDE is kwin.

The Openbox window manager works very well within KDE, combined with a
noticable improvement in performance and responsiveness. By default, a
KDE/Openbox session will be made automatically available upon installing
Openbox, even if the KDE environment itself has not been installed. Most
popular display managers will therefore allow KDE with Openbox as the
window manager to be selected as a session.

To manually start KDE with Openbox as the window manager - as a default
session for SLiM, or where not using a display manager at all - add the
following command to the Xinitrc file:

    exec openbox-kde-session

When using KDM

To use Openbox as a default windows manager when logging in with KDM
just go to Default Applications -> Window Manager -> Use a different
windows manager then select Openbox within the dropdown box.

  

Re-enabling compositing effects

Where replacing the native kwin window manager with Openbox, any desktop
compositing effects - such a transparency - provided will also be lost.
This is because Openbox itself does not provide any compositing
functionality. However, it is easily possible to use a seperate
compositing program to re-enable compositing.

> Integrate Android with the KDE Desktop

Install kdeconnect and KDE Connect from the Google Play store for great
Android-KDE integration.

> Get notifications for software updates

Install apper to get notifications about package updates in your KDE
system tray and a basic package manager GUI. See the PackageKit website
for more information.

> Configure KWin to use OpenGL ES

Beginning with KWin version 4.8 it is possible to use the separately
built binary kwin_gles as a replacement for kwin. It behaves almost the
same as the kwin executable in OpenGL2 mode with the slight difference
that it uses egl instead of glx as the native platform interface. To
test kwin_gles you just have to run kwin_gles --replace in Konsole. If
you want to make this change permanent you have to create a script in
$(kde4-config --localprefix)/env/ which exports KDEWM=kwin_gles.

> Enabling audio/video thumbnails under Konqueror/Dolphin file managers

For thumbnails of videos in konqueror and dolphin install
kdemultimedia-mplayerthumbs or kdemultimedia-ffmpegthumbs. For
thumbnails of audio files in Konqueror and Dolphin install audiothumbs
from AUR.

> Speed up application startup

User Rob wrote on his blog this "magic trick" to improve application
start-up time by 50-150ms. To enable it, create this folder in your
home:

    $ mkdir -p ~/.compose-cache/

Note:For those curious about what is going on here, this enables an
optimization which Lubos (of general KDE speediness fame) came up with
some time ago and was then rewritten and integrated into libx11.
Ordinarily, on startup, applications read input method information from
/usr/share/X11/locale/your locale/Compose. This file is quite long
(>5000 lines for the en_US.UTF-8 one) and takes some time to process.
libX11 can create a cache of the parsed information which is much
quicker to read subsequently, but it will only re-use an existing cache
or create a new one in ~/.compose-cache if the directory already exists.

> Hiding partitions

In Dolphin, it is as simple as right-clicking on the partition in the
Places sidebar and selecting Hide partition. Otherwise...

If you wish to prevent your internal partitions from appearing in your
file manager, you can create an udev rule, e.g:

    /etc/udev/rules.d/10-local.rules

    KERNEL=="sda[0-9]", ENV{UDISKS_IGNORE}="1"

The same thing for a certain partition:

    KERNEL=="sda1", ENV{UDISKS_IGNORE}="1"
    KERNEL=="sda2", ENV{UDISKS_IGNORE}="1"

> Konqueror tips

Disabling smart key tooltips (browser)

To disable those smart key tooltips in Konqueror (pressing Ctrl on a web
page), use Settings > Configure Konqueror > Web Browsing and uncheck
Enable Access Key activation with Ctrl key o

    ~/.kde4/share/config/konquerorrc

    [Access Keys]
    Enabled=false

Using WebKit

WebKit is an open source browser engine developed by Apple Inc. It is a
derivative from the KHTML and KJS libraries and contains many
improvements. WebKit is used by Safari, Google Chrome and rekonq.

It is possible to use WebKit in Konqueror instead of KHTML. First
install the kwebkitpart package.

Then, after executing Konqueror, navigate to Settings > Configure
Konqueror > General > Default web browser engine and set it as WebKit.

> Firefox integration

See Firefox.

> Setting the screensaver background to the same as the current one

Kscreensaver's background can be changed from the default.

KDE by default is not able to change this for the 'Simple Lock', but a
workaround exists:

    /usr/share/apps/ksmserver/screenlocker/org.kde.passworddialog/contents/ui/

    [...]
            #source: theme.wallpaperPathForSize(parent.width, parent.height)
            source: "1920x1080.jpg"
    [...]

Now you copy your current background image to "1920x1080.jpg".

Note you have to redo this for each update of the package
kdebase-workspace.

> Setting lockscreen wallpaper to arbitrary image

Copy an existing wallpaper profile as a template:

    $ cp -r /usr/share/wallpapers/ExistingWallpaper ~/.kde4/share/wallpapers/

Change the name of the directory, and edit metadata.desktop:

    ~/.kde4/share/wallpapers/MyWallpaper/metadata.desktop

    [Desktop Entry]
    Name=MyWallpaper
    X-KDE-PluginInfo-Name=MyWallpaper

Remove existing images (contents/screenshot.png and images/*):

    $ rm ~/.kde4/share/wallpapers/MyWallpaper/contents/screenshot.png
    $ rm ~/.kde4/share/wallpapers/MyWallpaper/contents/images/*

Copy new image in:

    $ cp path/to/MyWallpaper.png MyWallpaper/contents/images/1920x1080.png

Edit the metadata profile for the current theme:

    ~/.kde4/share/apps/desktoptheme/MyTheme/metadata.desktop

    [Wallpaper]
    defaultWallpaperTheme=MyWallpaper
    defaultFileSuffix=.png
    defaultWidth=1920
    defaultHeight=1080

Lock the screen to check that it worked.

Note:This method sets the lockscreen background without changing any
system-wide settings. For a system-wide change, create the new wallpaper
profile in /usr/share/wallpapers.

Troubleshooting
---------------

> Configuration related

Many problems in KDE are related to configuration. One way to resolve
upgrade problems is to start over with a fresh KDE config.

Reset all KDE configuration

To test whether your config is the problem try quitting your KDE session
by logging out and, in a tty, run

    $ cp ~/.kde4 ~/.kde4.safekeeping
    $ rm .kde4/{cache,socket,tmp}-$(hostname)

The rm command just removes symbolic links which will be recreated by
KDE automatically. Now start a new KDE session to see the results.

If the problem is resolved, you will have a fresh, problem-free
~/.kde4/. You can gradually move parts of your saved configuration back,
restarting your session regularly to test, to identify the problematic
parts of your config. Some files here are named after applications so
you will probably be able to test these without needing to restart KDE.

File Indexer Service not working even after enabling everything properly

This is caused due to a corrupted Nepomuk database. It may be remedied
by moving the database or deleting it all together. Log out of KDE and
issue this command from a virtual console:

    $ mv ~/.kde4/share/apps/nepomuk ~/.kde4/share/apps/nepomuk_backup

to move your existing (and corrupt) nepomuk database. It will be
recreated when you log in again.

Plasma desktop behaves strangely

Plasma problems are usually caused by unstable plasmoids or plasma
themes. First, find which was the last plasmoid or plasma theme you had
installed and disable it or uninstall it.

So, if your desktop suddenly exhibits "locking up", this is likely
caused by a faulty installed widget. If you cannot remember which widget
you installed before the problem began (sometimes it can be an irregular
problem), try to track it down by removing each widget until the problem
ceases. Then you can uninstall the widget, and file a bug report
(bugs.kde.org) only if it is an official widget. If it is not, it is
recommended you find the entry on kde-look.org and inform the developer
of that widget about the problem (detailing steps to reproduce, etc).

If you cannot find the problem, but you do not want all the KDE settings
to be lost, do:

    $ rm -r ~/.kde4/share/config/plasma*

This command will delete all plasma related configs of your user and
when you will relogin into KDE, you will have the default settings back.
You should know that this action cannot be undone. You should create a
backup folder and copy all the plasma related configs in it.

Clean cache to resolve upgrade problems

The problem may be caused by old cache. Sometimes after an upgrade, the
old cache might introduce strange, hard to debug behaviour such as
unkillable shells, hangs when changing various settings and several
other problems such as ark being unable to unrar or unzip or amarok not
recognizing any of your musics. This solution can also resolve problems
with KDE and QT programmes looking bad following upgrade.

Rebuild your cache with the following commands:

    $ rm ~/.config/Trolltech.conf
    $ kbuildsycoca4 --noincremental

Hopefully, your problems are now fixed.

> Clean akonadi configuration to fix KMail

First, make sure that KMail is not running. Then backup configuration:

    $ mv ~/.local/share/akonadi ~/.local/share/akonadi-old
    $ mv ~/.config/akonadi ~/.config/akonadi-old

Start SystemSettings > Personal and remove all the resources. Go back to
Dolphin and remove the original ~/.local/share/akonadi and
~/.config/akonadi - the copies you made ensure that you can back-track
if necessary.

Now go back to the System Settings page and carefully add the necessary
resources. You should see the resource reading in your mail folders.
Then start Kontact/KMail to see if it work properly.

> Getting current state of KWin for support and debug purposes

This command prints out a wonderful summary of the current state of KWin
including used options, used compositing backend and relevant OpenGL
driver capabilities. See more on Martin's blog.

    $ qdbus org.kde.kwin /KWin supportInformation

> KDE4 does not finish loading

There might be a situation in which the graphic driver might create a
conflict when starting KDE4. This situation happens after the login but
before finishing loading the desktop, making the user wait indefinitely
at the loading screen. Until now the only users confirmed to be affected
by this are the ones that use Nvidia drivers and KDE4.

A solution for Nvidia users:

    ~/.kde4/share/config/kwinrc

    [Compositing]
    Enabled=false

For more information, see this thread.

If a minimal install was done, make sure you installed the required font
by your phonon backend listed here: #Minimal install

> KDE and Qt programs look bad when in a different window manager

If you are using KDE or Qt programs but not in a full KDE session
(specifically, you did not run startkde), then as of KDE 4.6.1 you will
need to tell Qt how to find KDE's styles (Oxygen, QtCurve etc.)

You just need to set the environment variable QT_PLUGIN_PATH. E.g. put:

    export QT_PLUGIN_PATH=$HOME/.kde4/lib/kde4/plugins/:/usr/lib/kde4/plugins/

into your /etc/profile (or ~/.profile if you do not have root access).
qtconfig should then be able to find your KDE styles and everything
should look nice again!

Alternatively, you can symlink the Qt styles directory to the KDE styles
one:

    # ln -s /usr/lib/kde4/plugins/styles/ /usr/lib/qt/plugins/styles

Under Gnome you can try to install the package libgnomeui.

> Graphical related problems

Low 2D desktop performance (or) artifacts appear when on 2D

GPU driver problem

Make sure you have the proper driver for your card installed, so that
your desktop is at least 2D accelerated. Follow these articles for more
information: ATI, NVIDIA, Intel for more information, in order to make
sure that everything is all right. The open-source ATI and Intel drivers
and the proprietary (binary) Nvidia driver should theoretically provide
the best 2D and 3D acceleration.

The Raster engine workaround

If this does not solve your problems, your driver may not provide a good
XRender acceleration which the current Qt painter engine relies on by
default.

You can change the painter engine to software based only by invoking the
application with the -graphicssystem raster command line. This rendering
engine can be set as the default one by recompiling Qt with the same as
configure option, -graphicssystem raster.

The raster paint engine enables the CPU to do the majority of the
painting, as opposed to the GPU. You may get better performance,
depending on your system. This is basically a work-around for the
terrible Linux driver stack, since the CPU should obviously not be doing
graphical computations since it is designed for fewer threads of greater
complexity, as opposed to the GPU which is many threads but lesser
computational strength. So, only use Raster engine if you are having
problems or your GPU is much slower than you CPU, otherwise is better to
use XRender.

Since Qt 4.7+, recompiling Qt is not needed. Simply export
QT_GRAPHICSSYSTEM=raster, or opengl, or native (for the default). Raster
depends on the CPU, OpenGL depends on the GPU and high driver support,
and Native is just using the X11 rendering (mixture, usually).

The best and automatic way to do that is to install
kcm-qt-graphicssystem from AUR and configure this particular Qt setting
through:

    System Settings > Qt Graphics System

For more information, consult this KDE Developer blog entry and/or this
Qt Developer blog entry.

Low 3D desktop performance

KDE begins with desktop effects enabled. Older cards may be insufficient
for 3D desktop acceleration. You can disable desktop effects in:

    System Settings > Desktop Effects

and you can toggle desktop effects with Alt+Shift+F12.

Note: You may encounter such problems with 3D desktop performance even
when using a more powerful graphics card, especially the catalyst
proprietary driver (fglrx). This driver is known for having problems
with 3D acceleration. Visit the ATI Wiki page for more troubleshooting.

Desktop compositing is disabled on my system with a modern Nvidia GPU

Sometimes, KWin may have settings in its configuration file (kwinrc)
that may cause a problem on re-activating the 3D desktop OpenGL
compositing. That could be caused randomly (for example, due to a sudden
Xorg crash or restart, and it gets corrupted), so, in case that happens,
delete your ~/.kde4/share/config/kwinrc file and relogin. The KWin
settings will turn to the KDE default ones and the problem should be
probably gone.

Flickering in fullscreen when compositing is enabled

As of KDE SC 4.6.0, there is an option in Sytem Settings > Desktop
Effect > Advanced > Suspend desktop effects for fullscreen windows.
Uncheck it would tell kwin to disable unredirect fullscren.

Screen Tearing with desktop compositing enabled

Note:With the release of KDE 4.11, several new Vsync options have been
added, which may help with screen tearing.

KWin may suffer from screen tearing while desktop effects are enabled.
Uncheck the VSync option under System Settings > Desktop Effects >
Advanced > Use Vsync.

For proprietary driver users, ensure that the driver's VSync option is
enabled (amdccle for Catalyst users, and nvidia-settings for NVIDIA
users).

Display settings lost on reboot (multiple monitors)

Installing kscreen might fix the problem unless your screens share the
same EDID. Kscreen is the improved screen management software for KDE,
more information can be found here.

> Sound problems under KDE

ALSA related problems

Note:First make sure you have alsa-lib and alsa-utils installed.

"Falling back to default" messages when trying to listen to any sound in KDE

When you encounter such messages:

    The audio playback device name_of_the_sound_device does not work.
    Falling back to default

Go to:

    System Settings > Multimedia > Phonon

and set the device named default above all the other devices in each box
you see.

MP3 files cannot be played when using the GStreamer Phonon backend

This can be solved by installing the GStreamer plugins (package group
gstreamer0.10-plugins). If you still encounter problems, you can try
changing the Phonon backend used by installing another such as
phonon-vlc. Then, make sure the backend is preferred via:

    System Settings > Multimedia > Phonon > Backend (tab)

> Konsole does not save commands' history

By default console command history is saved only when you type 'exit' in
console. When you close Konsole with 'x' in the corner it does not
happen. To enable autosaving after every command execution:

    ~/.bashrc

    shopt -s histappend
    [[ "${PROMPT_COMMAND}" ]] && PROMPT_COMMAND="$PROMPT_COMMAND;history -a" || PROMPT_COMMAND="history -a"

> KDE password prompts display three bullets per char

This setting can be changed at System Settings > Account Details >
Password & User Account:

-   Show one bullet for each letter
-   Show three bullets for each letter
-   Show nothing

> Nepomukserver process still autostarts even with semantic desktop disabled

Go to System Settings > Startup and Shutdown > Service Manager > Startup
Services and uncheck the Nepomuk Search Module.

> Dolphin and File Dialogs are extremely slow to start

This may be caused by the upower service. If the upower service is not
needed on your system, it can be disabled:

    # systemctl disable upower
    # systemctl mask upower

Obviously this will not have any side effect on a desktop system.

> Default PDF viewer in GTK applications under KDE

In some cases when you have installed Inkscape, Gimp or other graphic
programs, GTK applications (Firefox among all) might not select Okular
as the default PDF application, and they are not going to follow the KDE
settings on default applications. You can use the following user command
to make Okular the default application again.

    $ xdg-mime default kde4-okularApplication_pdf.desktop application/pdf

If you are using a different PDF viewer application, or a different
mime-type is misbehaving, you should change
kde4-okularApplication_pdf.desktop and application/pdf respectively
according to your needs.

For more information, consult Default applications wiki page.

Unstable releases
-----------------

When KDE is reaching beta or RC milestone, KDE "unstable" packages are
uploaded to the [kde-unstable] repository. They stay there until KDE is
declared stable and passes to [extra].

You can add [kde-unstable] with:

    /etc/pacman.conf

    [kde-unstable]
    Include = /etc/pacman.d/mirrorlist

Warning: Make sure to add these lines before the [extra] section. Adding
the section after [extra] will cause pacman to prefer the older packages
in the extra repository. pacman -Syu will not install them, and will
warn that they are "too new" if installed manually. Also, some of the
libraries will stay at the older versions, which may cause file
conflicts and/or instability!

1.  [kde-unstable] is based upon testing. Therefore, you need to enable
    the repositories in the following order: [kde-unstable], [testing],
    [core], [extra], [community-testing], [community].
2.  To update from a previous KDE installation, run: # pacman -Syu or
    # pacman -S kde-unstable/kde
3.  If you do not have KDE installed, you might have difficulties to
    install it by using groups (limitation of pacman)
4.  Subscribe and read the arch-dev-public mailing list
5.  Make sure you make bug reports if you find any problems.

Other KDE projects
------------------

> Trinity

From the release of KDE 4.x, the developers dropped support for KDE
3.5.x. Trinity Desktop Environment is a fork of KDE3 developed by
Timothy Pearson (trinitydesktop.org). This project aims to keep the
KDE3.5 computing style alive, as well as polish off any rough edges that
were present as of KDE 3.5.10. See Trinity for more info.

Warning:KDE 3 is no longer maintained and supported by the KDE
developers. The "Trinity KDE" is maintained by the Trinity project
commmunity. Use KDE 3 on your own risk, regarding any bugs, performance
problems or security risks.

Bugs
----

It is preferrable that if you find a minor or serious bug, you should
visit the Arch Bug Tracker or/and KDE Bug Tracker in order to report
that. Make sure that you are clear about what you want to report.

If you have any problem and you write about in on the Arch forums, first
make sure that you have fully updated your system using a good sync
mirror (check here) or try Reflector.

See also
--------

-   [3] - KDE homepage
-   [4] - KDE bug tracker
-   [5] - Arch Linux bug tracker
-   [6] - KDE Projects

Retrieved from
"https://wiki.archlinux.org/index.php?title=KDE&oldid=306156"

Category:

-   KDE

-   This page was last modified on 20 March 2014, at 19:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
