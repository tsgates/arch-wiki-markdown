KDE
===

Summary

For users on Linux and Unix, KDE offers a full suite of user workspace
applications which allow interaction with these operating systems in a
modern, graphical user interface. This article covers its installation,
configuration, and troubleshooting.

KDE uses the Qt toolkit.

Overview

The Xorg project provides an open source implementation of the X Window
System – the foundation for a graphical user interface. Desktop
environments such as Enlightenment, GNOME, KDE, LXDE, and Xfce provide a
complete graphical environment. Various window managers offer
alternative and novel environments, and may be used standalone to
conserve system resources. Display managers provide a graphical login
prompt.

Related

Plasma

Qt

KDM

KDevelop 4

Uniform Look for Qt and GTK Applications

From KDE - KDE Software Compilation:

The KDE Software Compilation grew out of the history of the KDE Project.
In its inception, KDE was formed to create a beautiful, functional and
free desktop computing environment for Linux and similar operating
systems. At the time, these systems lacked a graphical user environment
that could rival the offerings from the larger proprietary operating
system vendors. KDE was created to fill this gap.

The KDE Software Compilation is the set of libraries, workspaces, and
applications produced by KDE that share this common heritage, and
continue to use the synchronized release cycle. Software may move in and
out of this semi-formally defined collection depending on the particular
needs of the contributors who are working on that software, with
exceptions made to ensure that binary compatibility remains at the
library level throughout any major release of the compilation.

From KDE - Getting KDE Software:

KDE software consists of a large number of individual applications and a
desktop workspace as a shell to run these applications. You can run KDE
applications just fine on any desktop environment. KDE applications are
built to integrate well with your system's components. By using also KDE
workspace, you get even better integration of your applications with the
working environment while lowering system resource needs.

The KDE upstream has a well maintained UserBase wiki. Users can get
detailed information about most KDE applications there.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Overview                                                           |
| -   2 Installation                                                       |
|     -   2.1 Full install                                                 |
|     -   2.2 Minimal install                                              |
|     -   2.3 Language pack                                                |
|                                                                          |
| -   3 Starting KDE                                                       |
|     -   3.1 Using KDM (KDE Display Manager)                              |
|     -   3.2 Using xinitrc                                                |
|                                                                          |
| -   4 Configuration                                                      |
|     -   4.1 Personalization                                              |
|         -   4.1.1 Plasma Desktop                                         |
|             -   4.1.1.1 Themes                                           |
|             -   4.1.1.2 Widgets                                          |
|             -   4.1.1.3 Sound applet in the System Tray                  |
|                                                                          |
|         -   4.1.2 Window Decorations                                     |
|         -   4.1.3 Icon Themes                                            |
|         -   4.1.4 Fonts                                                  |
|             -   4.1.4.1 Fonts in KDE look poor                           |
|             -   4.1.4.2 Fonts are huge or seems disproportional          |
|                                                                          |
|         -   4.1.5 Space efficiency                                       |
|                                                                          |
|     -   4.2 Networking                                                   |
|     -   4.3 Printing                                                     |
|     -   4.4 Samba/Windows support                                        |
|     -   4.5 KDE Desktop Activities                                       |
|     -   4.6 Power Saving                                                 |
|         -   4.6.1 How to enable Cpufreq based power saving               |
|                                                                          |
|     -   4.7 Monitoring changes on local files and directories            |
|                                                                          |
| -   5 System Administration                                              |
|     -   5.1 Set keyboard layout in order switch language inputs          |
|     -   5.2 Terminate Xorg-server through KDE system settings            |
|     -   5.3 Useful KCM                                                   |
|                                                                          |
| -   6 Desktop Search and Semantic Desktop                                |
|     -   6.1 Virtuoso and Soprano                                         |
|     -   6.2 Nepomuk                                                      |
|         -   6.2.1 Using and configuring Nepomuk                          |
|         -   6.2.2 KDE without Nepomuk                                    |
|                                                                          |
|     -   6.3 Akonadi                                                      |
|         -   6.3.1 Disabling Akonadi                                      |
|         -   6.3.2 Database configuration                                 |
|         -   6.3.3 Running KDE without Akonadi                            |
|                                                                          |
| -   7 Phonon                                                             |
|     -   7.1 What is Phonon?                                              |
|     -   7.2 Which backend should I choose?                               |
|                                                                          |
| -   8 Useful Applications                                                |
|     -   8.1 Yakuake                                                      |
|     -   8.2 KDE Telepathy                                                |
|                                                                          |
| -   9 Tips and tricks                                                    |
|     -   9.1 Configure KWin to use OpenGL ES                              |
|     -   9.2 Enabling video thumbnails under Konqueror/Dolphin file       |
|         managers                                                         |
|     -   9.3 Speed up application startup                                 |
|     -   9.4 Hiding partitions                                            |
|     -   9.5 Konqueror Tips                                               |
|         -   9.5.1 Disabling Smart Key Tooltips (Browser)                 |
|         -   9.5.2 Disabling The Sidebar Tab (Filemanager)                |
|         -   9.5.3 Using WebKit                                           |
|                                                                          |
|     -   9.6 Firefox integration                                          |
|                                                                          |
| -   10 Troubleshooting                                                   |
|     -   10.1 Getting current state of KWin for support and debug         |
|         purposes                                                         |
|     -   10.2 KDE4 does not finish loading                                |
|     -   10.3 KDE and Qt programs look bad when in a different window     |
|         manager                                                          |
|     -   10.4 KDE and Qt programs look bad after upgrade (using kwin)     |
|     -   10.5 Graphical related issues                                    |
|         -   10.5.1 Low 2D desktop performance (or) Artifacts appear when |
|             on 2D                                                        |
|             -   10.5.1.1 GPU driver problem                              |
|             -   10.5.1.2 The Raster engine workaround                    |
|                                                                          |
|         -   10.5.2 Low 3D desktop performance                            |
|         -   10.5.3 Desktop compositing is disabled on my system with a   |
|             modern Nvidia GPU                                            |
|         -   10.5.4 Flickering in fullscreen when compositing is enabled  |
|                                                                          |
|     -   10.6 Sound problems under KDE                                    |
|         -   10.6.1 ALSA related problems                                 |
|             -   10.6.1.1 "Falling back to default" messages when trying  |
|                 to listen to any sound in KDE                            |
|             -   10.6.1.2 I cannot play MP3 files when using the          |
|                 GStreamer Phonon backend                                 |
|                                                                          |
|     -   10.7 I want a fresh installation of KDE for my system. What      |
|         should I do?                                                     |
|     -   10.8 Plasma desktop behaves strangely                            |
|     -   10.9 Konsole does not save commands' history                     |
|     -   10.10 KDE password prompts display three bullets per char        |
|     -   10.11 Nepomukserver process still autostart even with semantic   |
|         desktop disabled                                                 |
|     -   10.12 File Indexer Service not working even after enabling       |
|         everything properly                                              |
|     -   10.13 Desktop does not respond for several seconds at startup    |
|     -   10.14 KDE Notifications do not go away even after being          |
|         dismissed                                                        |
|     -   10.15 Mysterious hangs/slowness after upgrade                    |
|                                                                          |
| -   11 Other KDE projects                                                |
|     -   11.1 Official kde-unstable                                       |
|     -   11.2 Trinity                                                     |
|                                                                          |
| -   12 Bugs                                                              |
|     -   12.1 Distro and Upstream bug report                              |
|                                                                          |
| -   13 External Links                                                    |
+--------------------------------------------------------------------------+

Overview
--------

KDE 4.10 Software Compilation is the current major [release of KDE.
Important hints for upgraders:

-   Always check if your mirror is up to date.
-   Do not force an update using pacman --force. If pacman complains
    about conflicts please file a bug report.
-   You can remove the meta packages and the sub packages you do not
    need after the update.
-   If you do not like split packages just keep using the kde-meta
    packages.

Installation
------------

KDE 4.x is modular. You can install an entire set of packages or only
install your preferred KDE applications.

Note:If you do not have Xorg installed on your system, be sure to
install it before KDE.

> Full install

Install kde or kde-meta available in the official repositories. For
differences between kde and kde-meta see the KDE Packages article.

> Minimal install

If you want to have a minimal installation of the KDE SC, install:

-   kdebase
-   phonon-vlc or phonon-gstreamer as phonon backend
-   A ttf-* font package such as ttf-dejavu. For more information see
    FS#26012.

> Language pack

If you need language files, install kde-l10n-yourlanguagehere (e.g.
kde-l10n-de for the German language).

For a full list of available languages see this link.

Starting KDE
------------

Starting KDE depends on your preferences. Basically there are two ways
of starting KDE. Using KDM or xinitrc.

> Using KDM (KDE Display Manager)

It is highly recommended to get familiar with the full article
concerning display managers, before you make any changes. See also KDM
Wiki page.

Enable/start kdm.service.

> Using xinitrc

The meaning and usage of xinitrc is very well described here.

kdebase-workspace provides startkde. Make sure it is installed. Then
edit ~/.xinitrc, uncomment:

    exec startkde

After a reboot and/or log-in, each execution of Xorg (startx or xinit)
will start KDE automatically.

Note: If you want to start Xorg at boot, please read Start X at Login
article.

Configuration
-------------

All KDE configuration is saved in the ~/.kde4 folder. If your KDE is
giving you a lot of trouble or if you ever want a fresh installation of
KDE, just back this folder up and restart your X session. KDE will
re-create this folder with all the default config files. If you want
very fine-grained control over your KDE programs, then you may want to
edit the files in this folder.

However, configuring KDE is primarily done in 'System Settings'. There
are also a few other options available for the desktop with 'Default
Desktop Settings' when you right click the desktop.

For other personalization options not covered below such as activities,
different wallpapers on one cube, etc please refer to the Plasma wiki
page.

> Personalization

How to set up the KDE desktop to your personal style; use different
Plasma themes, window decorations and icon themes.

Plasma Desktop

Plasma is a desktop integration technology that provides many functions
from displaying the wallpaper, adding widgets to the desktop, and
handling the panels or "taskbar".

Themes

Plasma themes can be installed through the Desktop Settings control
panel. Plasma themes define how your panels and plasmoids look like. If
you like to have them installed system-wide, themes can be found in both
the official repositories and AUR.

Widgets

Plasmoids are little scripted or coded KDE apps that enhance the
functionality of your desktop. There are two kinds, plasmoid scripts and
plasmoid binaries.

Plasmoid binaries must be installed using PKGBUILDS from AUR. Or write
your own PKGBUILD.

The easiest way to install plasmoid scripts is by right-clicking onto a
panel or the desktop:

    Add Widgets -> Get new Widgets -> Download Widgets

This will present a nice frontend for kde-look.org and allows you to
(un)install or update third-party plasmoid scripts with just one click.

Most plasmoids are not created officially by KDE developers. You can
also try installing Mac OS X widgets, Microsoft Windows Vista/7 widgets,
Google Widgets, and even SuperKaramba widgets.

Sound applet in the System Tray

Install Kmix (kdemultimedia-kmix) from the official repositories and
start it from the appliocation launcher. Since KDE autostarts programs
from the previous session, the program need not be started manually
every time one logs in.

Window Decorations

Window decorations can be changed in

    System Settings -> Workspace Appearance -> Window Decorations

There you can also directly download and install more themes with one
click and some are available on AUR.

Icon Themes

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
have to modify any settings in the "Fonts" panel of the KDE System
Settings application.

If you have personally set up how your Fonts render, be aware that
System Settings may alter their appearance. When you go System Settings
> Appearance > Fonts System Settings will likely alter your font
configuration file (fonts.conf).

There is no way to prevent this but if you set the values to match your
fonts.conf file the expected font rendering will return (it will require
you to restart your application or in a few cases for you to have to
restart your desktop).

Note too that Gnomes' Font Preferences will also do this if you use both
desktop environments.

Fonts are huge or seems disproportional

Try to force fonts DPI to 96 on System Settings > Application Appearance
> Fonts.

If it does not work try set DPI directly on Xorg configuration here.

Space efficiency

Users with small screens (eg Netbooks) can change some setting to make
KDE more space efficient. See upstream wiki for more info. Also you can
use KDE's Plasma Netbook which is a workspace made specifically for
small, lightweight netbook devices.

> Networking

You can choose from the following tools:

-   NetworkManager. See NetworkManager for more information.
-   Wicd and its KDE front end wicd-kde. See Wicd for more information.

> Printing

Tip:Use the CUPS web interface for faster configuration.

The printers are configured in this way can be found in applications
KDE.

You can also choose the printer configuration through System Settings ->
Printer Configuration. To use this method, you must first install the
packages kdeutils-print-manager and cups.

You need to start the avahi-daemon and cupsd daemons first or you will
get the following error:

    The service 'Printer Configuration' does not provide an interface 'KCModule' 
    with keyword 'system-config- printer-kde/system-config-printer-kde.py' 
    The factory does not support creating components of the specified type.

If you are getting the following error, you need to give the user rights
to manage printers:

    There was an error during CUPS operation: 'cups-authorization-canceled'

For CUPS, this is set in /etc/cups/cupsd.conf.

Adding lp to SystemGroup allows anyone who can print to configure
printers. You can, of course, add another group instead of lp.

    /etc/cups/cupsd.conf

    # Administrator user group...
    SystemGroup sys root lp

> Samba/Windows support

If you want to have access to Windows services install Samba (package
samba).

You may then configure your Samba shares through

     System Settings -> Sharing -> Samba

> KDE Desktop Activities

KDE Desktop Activities are Plasma based "virtual desktop"-like set of
Plasma Widgets where you can independently configure widgets as if you
had more than one screens/desktops.

On your desktop, click the Cashew Plasmoid and on the pop-up window
press "Activities".

A plasma bar will appear at the bottom of the screen which presents you
the current Plasma Desktop Activities which exist. You can then navigate
between them by pressing their correspondent icon.

> Power Saving

KDE has an integrated power saving service called "Powerdevil Power
Management" that may adjust the power saving profile of the system
and/or the brightness of the screen (if supported).

How to enable Cpufreq based power saving

NOTE: Cpufreq seems have been dropped from arch linux in favour of
cpupower (ref)

Since KDE 4.6, CPU frequency scaling is no longer managed by KDE.
Instead it is assumed to be handled automatically by the the hardware
and/or kernel. Arch uses ondemand as default cpufreq governor from
kernel vesion 3.3. See wiki article on cpufreq.

If you are happy with setting your governor once at boot (with the
cpufreq daemon script, for example) then this section is not relevant
and can be skipped.

1. If you have not already done so, install the cpufrequtils package
(for the cpufreq-set utility).

2. Next, you will need to grant access to cpufreq-set for the
appropriate users by configuring sudo. For example, if you are part of
the wheel group, you could use visudo to add

    %wheel ALL = (ALL) NOPASSWD: /usr/bin/cpufreq-set

to your sudoers file.

3. From System Settings > Power Management > Power Profiles select a
profile to edit or create a new one. Check the Run Script option and add
an appropriate cpufreq-set command for the selected power profile. For
example, your "Powersave" profile might have:

    sudo cpufreq-set -r -g ondemand

Your "Performance" profile might have

    sudo cpufreq-set -r -g performance

Note: The cpufreq-set examples above may be insufficient for setting the
governor for all processors/cores.

For some CPU families the -r switch may not set the governor for all
cores/cpus and instead only set the governor for CPU 0. In this case you
will need to write a script to iterate through all your cores. A simple
script for a four core system could look like:

    #!/bin/bash
    for i in {0..3}; do
      sudo /usr/bin/cpufreq-set -c${i} -gondemand
    done

Note: You can check which governors are active with cpufreq-info -o or
less intuitively by inspecting
/sys/devices/system/cpu/cpu*/cpufreq/scaling_governor.

> Monitoring changes on local files and directories

KDE now uses inotify directly from the kernel with kdirwatch (included
in kdelibs), so Gamin or FAM are no longer needed. You may want to
install this kdirwatch from AUR which is a GUI frontend for kdirwatch.

System Administration
---------------------

> Set keyboard layout in order switch language inputs

In order to do that, navigate to

       System Settings > Hardware > Input Devices > Keyboard

There you may choose your keyboard model at first.

Note: It is preferable that, if you use Evdev, that means Xorg automatic
configuration for keyboards, you should choose "Evdev-managed keyboard".

In the "Layouts" tab, you choose the languages you may want to use by
pressing the "Add Layout" button and therefore the variant and the
language. In the "Advanced" tab, you can choose the keyboard combination
you want in order to change the layouts in the "Key(s) to change layout"
sub-menu.

> Terminate Xorg-server through KDE system settings

Navigate to

       System Settings -> Input Devices -> Keyboard -> Advanced (tab) > "Key Sequence to kill the X server" submenu

and tick the checkbox.

> Useful KCM

KCM means KConfig Module. This modules help you to configure you system
providing a interface on System Settings.

Configuration for look&feel of your GTK apps.

-   kde-gtk-config (formerly known as chakra-gtk-config).
-   kcm-gtk
-   kcm-qt-graphicssystem

Configuration for the GRUB2 bootloader.

-   grub2-editor
-   kcm-grub2

Configuration for Synaptics driver based touchpads.

-   synaptiks
-   kcm_touchpad

Configuration for UFW

-   kcm-ufw

Configuration for PolicyKit

-   kcm-polkit-kde-git

Configuration for Wacom Tablet

-   kcm-wacomtablet

More KCM can be found here.

Desktop Search and Semantic Desktop
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
key in order to store data.) It is currently controlled by OpenLink, and
is available under commercial and an open source license.

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
and off in

    System Settings -> Desktop Search

Nepomuk has to keep track of a lot of files. It is for this reason that
it is recommended to increase the number of files that can be watched
with inotify. In order to do that this command is a good option.

    sysctl fs.inotify.max_user_watches=524288

To do it persistently:

    echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.conf

Restart Nepomuk to see the changes.

KDE without Nepomuk

If you wish to run KDE without Nepomuk, there exists a nepomuk-core-fake
package in the AUR.

Warning:As of now, Dolphin depends on nepomuk-widgets and hence will
break if used with the fake Nepomuk package

> Akonadi

Akonadi is a system meant to act as a local cache for PIM data,
regardless of its origin, which can be then used by other applications.
This includes the user's emails, contacts, calendars, events, journals,
alarms, notes, and so on. It interfaces with the Nepomuk libraries to
provide searching capabilities.

Akonadi does not store any data by itself: the storage format depends on
the nature of the data (for example, contacts may be stored in vcard
format).

For more information on Akonadi and its relationship with Nepomuk, see
[1] and [2].

Disabling Akonadi

See this section in the KDE userbase.

Database configuration

Start akonaditray from package kdepim-runtime. Right click on it and
select configure. In the Akonadi server configure tab, you can:

-   Configuring Akonadi to use MySQL Server running on the System
-   Configuring Akonadi to use sqlite

Running KDE without Akonadi

The package akonadi-fake is a good option for those who wish to run KDE
without Akonadi.

Phonon
------

> What is Phonon?

Phonon is the multimedia API for KDE 4. Phonon was created to allow KDE
4 to be independent of any single multimedia framework such as GStreamer
or xine and to provide a stable API for KDE 4's lifetime. It was done
for various reasons: to create a simple KDE/Qt style multimedia API, to
better support native multimedia frameworks on Windows and Mac OS X, and
to fix problems of frameworks becoming unmaintained or having API or ABI
instability.

from Wikipedia.

Phonon is being widely used within KDE, for both audio (e.g., the System
notifications or KDE audio apps) and video (e.g., the Dolphin video
thumbnails).

> Which backend should I choose?

You can choose between various backends, like GStreamer
(phonon-gstreamer) or VLC (phonon-vlc) available in extra, Xine
(phonon-xine) or MPlayer (phonon-mplayer-git) available on AUR. Most
users will want GStreamer or VLC which have the best upstream support.
Note that multiple backends can be installed at once and you can switch
between them via System Settings -> Multimedia -> Phonon -> Backend.

Note:According to the KDE UserBase, Phonon-MPlayer and Phonon-Xine are
currently unmaintained

According to announcement of KDE 4.6 in Arch and mail in Phonon dev
list, users should prefer GStreamer over VLC due to the feature
difference.

Useful Applications
-------------------

The official set of KDE applications may be found here.

> Yakuake

This application provides a Quake-like terminal emulator, which is
toggled visible using the F12 key. It also has support for multiple
tabs. Yakuake can be installed by package yakuake.

> KDE Telepathy

KDE Telepathy is a project with the goal to closely integrate Instant
Messaging with the KDE desktop. It utilizes the Telepathy framework as a
backend, and is intended to replace Kopete.

To install all Telepathy protocols install the telepathy group. To use
the KDE Telepathy client, install the kde-telepathy-meta package that
includes all the packages contained in the kde-telepathy group .

Tips and tricks
---------------

> Configure KWin to use OpenGL ES

Beginning with KWin version 4.8 it is possible to use the separately
built binary kwin_gles as a replacement for kwin. It behaves almost the
same as the kwin executable in OpenGL2 mode with the slight difference
that it uses egl instead of glx as the native platform interface. To
test kwin_gles you just have to run kwin_gles --replace in Konsole. If
you want to make this change permanent you have to create a script in
`kde4-config --localprefix`/env/ which exports KDEWM=kwin_gles.

> Enabling video thumbnails under Konqueror/Dolphin file managers

For thumbnails of videos in konqueror and dolphin install
kdemultimedia-mplayerthumbs or kdemultimedia-ffmpegthumbs.

> Speed up application startup

User Rob wrote on his blog this "magic trick" to improve applications
start up by 50-150ms. To enable it, create this folder in your home:

    $ mkdir -p ~/.compose-cache

"For those curious about what is going on here, this enables an
optimization which Lubos (of general KDE speediness fame) came up with
some time ago and was then rewritten and integrated into libx11.
Ordinarily on startup applications read input method information from
/usr/share/X11/locale/<your locale>/Compose. This Compose file is quite
long (>5000 lines for the en_US.UTF-8 one) and takes some time to
process. libX11 can create a cache of the parsed information which is
much quicker to read subsequently, but it will only re-use an existing
cache or create a new one in ~/.compose-cache if the directory already
exists." [Cit. Rob]

> Hiding partitions

In Dolphin, it is as simple as right-clicking on the partition in the
'Places' sidebar and selecting 'Hide <partition>'. Otherwise...

If you wish to prevent your internal partitions from appearing in your
file manager, you can create an udev rule, for example
/etc/udev/rules.d/10-local.rules:

    KERNEL=="sda[0-9]", ENV{UDISKS_IGNORE}="1"

The same thing for a certain partition:

    KERNEL=="sda1", ENV{UDISKS_IGNORE}="1"
    KERNEL=="sda2", ENV{UDISKS_IGNORE}="1"

> Konqueror Tips

Disabling Smart Key Tooltips (Browser)

To disable those smart key tooltips in Konqueror (pressing CTRL on a web
page), open ~/.kde4/share/config/konquerorrc and add this section:

    [Access Keys]
    Enabled=false

Disabling The Sidebar Tab (Filemanager)

To disable this small sidebar tab on the left side, open
~/.kde4/share/config/konqsidebartng.rc and set HideTabs to true.

Using WebKit

WebKit is an open source browser engine developed by Apple Inc. It is a
derivative from the KHTML and KJS libraries and contains many
improvements. WebKit is used by Safari, Google Chrome and rekonq.

It is possible to use WebKit in Konqueror instead of KHTML. First
install the kwebkitpart package.

Then, after executing Konqueror, press Settings > Configure Konqueror.

On the "General" submenu, select the "WebKit" as the "Default web
browser engine".

> Firefox integration

See Firefox#KDE_integration.

Troubleshooting
---------------

> Getting current state of KWin for support and debug purposes

This command prints out a wonderful summary of the current state of KWin
including used options, used compositing backend and relevant OpenGL
driver capabilities. See more at Martin's blog

    qdbus org.kde.kwin /KWin supportInformation

> KDE4 does not finish loading

There might be a situation in which the graphic driver might create a
conflict when starting KDE4. This situation happens after the login but
before finishing loading the desktop, making the user wait indefinitely
at the loading screen. Until now the only users confirmed to be affected
by this are the ones that use Nvidia drivers and KDE4.

A solution for Nvidia users is to edit the file at
/home/user/.kde4/share/config/kwinrc and change the option Enabled=true
to false in the [Compositing] section. For more information look at this
thread.

If a minimal install was done, make sure you installed the required font
by your phonon backend listed here: KDE#Minimal_install

> KDE and Qt programs look bad when in a different window manager

If you are using KDE or Qt programs but not in a full KDE session
(specifically, you did not run "startkde"), then as of KDE 4.6.1 you
will need to tell Qt how to find KDE's styles (Oxygen, QtCurve etc.)

You just need to set the environment variable QT_PLUGIN_PATH. E.g. put

    export QT_PLUGIN_PATH=$HOME/.kde4/lib/kde4/plugins/:/usr/lib/kde4/plugins/

into your /etc/profile (or ~/.profile if you do not have root access).
qtconfig should then be able to find your kde styles and everything
should look nice again!

Alternatively, you can symlink the Qt styles directory to the KDE styles
one:

    # ln -s /usr/lib/kde4/plugins/styles/ /usr/lib/qt/plugins/styles

Under Gnome you can try to install the package libgnomeui.

> KDE and Qt programs look bad after upgrade (using kwin)

The problem is caused by old cache. Run the following to rebuild it

     $ rm ~/.config/Trolltech.conf
     $ kbuildsycoca4 --noincremental

from https://bbs.archlinux.org/viewtopic.php?id=135301

> Graphical related issues

Low 2D desktop performance (or) Artifacts appear when on 2D

GPU driver problem

Make sure you have the proper driver for your card installed, so that
your desktop is at least 2D accelerated. Follow these articles for more
information: ATI, NVIDIA, Intel for more information, in order to make
sure that everything is all right. The open-source ATI and Intel drivers
and the proprietary (binary) Nvidia driver should theoretically provide
the best 2D and 3D acceleration.

The Raster engine workaround

If this does not solve your problems, maybe your driver does not provide
a good XRender acceleration which the current Qt painter engine relies
on by default.

You can change the painter engine to software based only by invoking the
application with the "-graphicssystem raster" command line. This
rendering engine can be set as the default one by recompiling Qt with
the same as configure option, "-graphicssystem raster".

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
QT_GRAPHICSSYSTEM=raster, or "opengl", or "native" (for the default).
Raster depends on the CPU, OpenGL depends on the GPU and high driver
support, and Native is just using the X11 rendering (mixture, usually).

The best and automatic way to do that is to install
kcm-qt-graphicssystem from AUR and configure this particular Qt setting
through

     System Settings > Qt Graphics System

For more information, consult this KDE Developer blog entry and/or this
Qt Developer blog entry.

Low 3D desktop performance

KDE begins with desktop effects enabled. Older cards may be insufficient
for 3D desktop acceleration. You can disable desktop effects in

    System Settings -> Desktop Effects

or you can toggle desktop effects with Alt+Shift+F12.

Note: You may encounter such problems with 3D desktop performance even
when using a more powerful graphics card, but using catalyst proprietary
driver (fglrx). This driver is known for having issues with 3D
acceleration. Visit the ATi Wiki page for more troubleshooting.

Desktop compositing is disabled on my system with a modern Nvidia GPU

Sometimes, KWin may have settings in its configuration file (kwinrc)
that may cause a problem on re-activating the 3D desktop OpenGL
compositing. That could be caused randomly (for example, due to a sudden
Xorg crash or restart, and it gets corrupted), so, in case that happens,
delete your ~/.kde4/share/config/kwinrc file and relogin. The KWin
settings will turn to the KDE default ones and the problem should be
probably gone.

Flickering in fullscreen when compositing is enabled

As of KDE SC 4.6.0, there is an option in systemsettings -> Desktop
Effect -> Advanced -> "Suspend desktop effects for fullscreen windows"
Uncheck it would tell kwin to disable unredirect fullscren.

> Sound problems under KDE

ALSA related problems

Note:First make sure you have alsa-lib and alsa-utils installed.

"Falling back to default" messages when trying to listen to any sound in KDE

When you encounter such messages:

The audio playback device <name-of-the-sound-device> does not work.

Falling back to default

Go to

    System Settings -> Multimedia -> Phonon

and set the device named "default" above all the other devices in each
box you see.

I cannot play MP3 files when using the GStreamer Phonon backend

That can be solved by installing the GStreamer plugins (package
gstreamer0.10-plugins. If you still encounter problems, you can try
changing the Phonon backend used by installing another such as
phonon-vlc. Then make sure the backend is preferred via:

     System Settings -> Multimedia -> Phonon -> Backend (tab)

> I want a fresh installation of KDE for my system. What should I do?

Just rename the settings directory of KDE (just in case you will want to
go back to your original settings):

    mv ~/.kde4 ~/.kde4-backup

> Plasma desktop behaves strangely

Plasma issues are usually caused by unstable plasmoids or plasma themes.
First, find which was the last plasmoid or plasma theme you had
installed and disable it or uninstall it.

So, if your desktop suddenly exhibits "locking up", this is likely
caused by a faulty installed widget. If you cannot remember which widget
you installed before the problem began(sometimes it can be an irregular
problem), try to track it down by removing each widget until the problem
ceases. Then you can uninstall the widget, and file a bug report
(bugs.kde.org) only if it is an official widget. If it is not, I
recommend you find the entry on kde-look.org and inform the developer of
that widget about the issue (detailing steps to reproduce, etc).

If you cannot find the problem, but you do not want all the KDE settings
to be lost, do:

     rm -r ~/.kde4/share/config/plasma*

This command will delete all plasma related configs of your user and
when you will relogin into KDE, you will have the default settings back.
You should know that this action cannot be undone. You ought to create a
backup folder and copy all the plasma related configs in it.

> Konsole does not save commands' history

By default console commands' history is saved only when you type 'exit'
in console. When you close Konsole with 'x' in the corner it does not
happen. To enable autosaving after every command execution you should
add following lines into your .bashrc

    shopt -s histappend
    [[ "${PROMPT_COMMAND}" ]] && PROMPT_COMMAND="$PROMPT_COMMAND;history -a" || PROMPT_COMMAND="history -a"

> KDE password prompts display three bullets per char

You can change it under System Settings > Account Details. At Password &
User Account the options are:

-   Show one bullet for each letter
-   Show three bullets for each letter
-   Show nothing

> Nepomukserver process still autostart even with semantic desktop disabled

Go to System Settings > Startup and Shutdown > Service Manager > Startup
Services and uncheck the Nepomuk Search Module.

> File Indexer Service not working even after enabling everything properly

Use the following command to find Nepomuk's configuration files.

    find $HOME/.kde4/share/ -name "*nepomuk*"

Delete all files and folders in the output and then restart KDE.

> Desktop does not respond for several seconds at startup

There is a bug in either pulseaudio or kde that makes the desktop not
being usable for a few seconds after it has showed up (for example if
you click on the K-menu it does not appears until that waiting time has
elapsed).

The workaround is to disable /etc/xdg/autostart/pulseaudio.desktop by
adding the following line at the end (do not omit the semicolon):

    NotShowIn=KDE;

Note that you could also remove that file, or renaming it (to
pulseaudio.desktop.disable or the like) but then it will not load in
other Desktop Managers, and will be restored by a package update.

Source:
http://linuxadvantage.blogspot.fr/2013/01/kde-rather-slow-to-start-pulseaudio.html

> KDE Notifications do not go away even after being dismissed

This is a known bug filed in December. It has a patch, but there seems
to be no target release specified to fix it which will be out in release
4.10.3. This discussion may be referred to for more details.

> Mysterious hangs/slowness after upgrade

Try cleaning up your cache. Sometimes after an upgrade, the old cache
might introduce strange, hard to debug behaviour such as unkillable
shells, hangs when changing various settings and several other problems
such as ark being unable to unrar or unzip or amarok not recognizing any
of your musics.

To clean up your cache run as your normal user:

     rm ~/.config/Trolltech.conf
     kbuildsycoca4 --noincremental

Hopefully, your problems are now fixed.

Other KDE projects
------------------

> Official kde-unstable

When KDE is reaching beta or RC milestone, KDE "unstable" packages are
uploaded to the [kde-unstable] repo. They stay there until KDE is
declared stable and passes to [extra].

You may add it by adding:

    [kde-unstable]
    SigLevel = PackageRequired
    Include = /etc/pacman.d/mirrorlist

to /etc/pacman.conf

1.  kde-unstable is based upon testing. Therefore, you need to enable
    the repositories in the following order: kde-unstable, testing,
    core, extra, community-testing, community.
2.  To update from a previous KDE installation, run: pacman -Syu or
    pacman -S kde-unstable/kde
3.  If you don't have KDE installed, you might have difficulties to
    install it by using groups (limitation of pacman)
4.  Subscribe and read the arch-dev-public mailing list
5.  Make sure you make bug reports if you find any issues.

> Trinity

From the release of KDE 4.x, the developers dropped support for KDE
3.5.x. Trinity Desktop Environment is a fork of KDE3 developed by
Timothy Pearson (trinitydesktop.org). This project aims to keep the
KDE3.5 computing style alive, as well as polish off any rough edges that
were present as of KDE 3.5.10. See Trinity for more info.

Warning: KDE 3 is no longer maintained and supported by the KDE
developers. The "Trinity KDE" is maintained by the Trinity project
commmunity. Use KDE 3 on your own risk, regarding any bugs, performance
issues or security risks.

Bugs
----

> Distro and Upstream bug report

It is preferrable that if you find a minor or serious bug, you should
visit the Arch Bug Tracker or/and KDE Bug Tracker in order to report
that. Make sure that you be clear on what you want to report.

If you have any issue and you write about in on the Arch forums, first
make sure that you have FULLY updated your system using a good sync
mirror (check here) or try Reflector.

KDE 4 config files are usually located at

    ~/.kde4/share/config/

and for app-specific configs

    ~/.kde4/share/apps/

External Links
--------------

-   KDE Homepage
-   KDE Bug Tracker
-   Arch Linux Bug Tracker
-   KDE WebSVN

Retrieved from
"https://wiki.archlinux.org/index.php?title=KDE&oldid=255695"

Category:

-   Desktop environments
