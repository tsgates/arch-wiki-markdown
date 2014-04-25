Unity
=====

Related articles

-   Desktop environment
-   GNOME
-   Compiz

Unity is a desktop shell for the GNOME desktop environment developed by
Ubuntu. Unity is implemented as a plugin of the Compiz window manager.

Contents
--------

-   1 Installation
    -   1.1 From source
    -   1.2 From repository (recommended)
    -   1.3 From testing repository
-   2 Update
-   3 Troubleshooting
    -   3.1 Unity notifications doesn't work
    -   3.2 Screensaver locking doesn't work
    -   3.3 online accounts doesn't work
    -   3.4 ssh keys aren't remembered by keyring
    -   3.5 KDE apps aren't integrated into the HUD and menubar
    -   3.6 Files and Folder lens doesn't seem to work or display
        anything
    -   3.7 Cannot right click on desktop
    -   3.8 Unity stops working after update
    -   3.9 Window decoration doesn't work properly
    -   3.10 Window decoration can't use certain theme
    -   3.11 Some GTK+ themes look ugly after update to GNOME 3.6
    -   3.12 Workspace switcher widget dissappeared
    -   3.13 Newly opened window is always placed at (0,0) on the screen
    -   3.14 Window's titlebar still exists when maximized
    -   3.15 Indicator-messages doesn't work properly

Installation
------------

There are two ways to install Unity on Arch Linux: from the source and
from a repository.

> From source

All of the PKGBUILDs can be browsed on the Github repository, where
Unity-For-Arch provides a minimal working Unity shell, and
Unity-For-Arch-Extra provides some additional applications, including
lightdm-ubuntu (lightdm with ubuntu patches), light-themes,
unity-tweak-tool (a popular ubuntu tool) and some more.

To install a minimal Unity shell:

1. 'cd' into a directory, where you want to keep the sources, and run:

    $ git clone https://github.com/chenxiaolong/Unity-for-Arch.git

For this to work, git is required.

2 Open the README file and build packages according to the ordered list.
Basically run:

    $ cd packagename
    $ rm -rvf src pkg # Clears out any files from a previous build
    $ makepkg -sci # '-s' means install needed dependencies, '-c' means clear left files after build and '-i' means install the package after it is built.

3. Log out and log into the Unity session.

To use lightdm to start Unity, follow the same steps mentionned above to
install lightdm-ubuntu and lightdm-unity-greeter from the
Unity-For-Arch-Extra repository. lightdm needs to be added to autostart
daemons. For Systemd users, check the Systemd wiki page.

Tip:To complete this procedure automatically, this script can be used.

> From repository (recommended)

    [Unity-for-Arch]
    SigLevel = Optional TrustAll
    Server = http://dl.dropbox.com/u/486665/Repos/Unity-for-Arch/$arch

    [Unity-for-Arch-Extra]
    SigLevel = Optional TrustAll
    Server = http://dl.dropbox.com/u/486665/Repos/Unity-for-Arch-Extra/$arch

to /etc/pacman.conf

Run:

    $ pacman -Suy
    $ pacman -S $(pacman -Slq Unity-for-Arch)

> Tip:

-   There are many ubuntu-patched packages that replace original Arch
    packages. It is also recommended to use freetype2-ubuntu from the
    AUR.
-   You may want to view packages (yaourt -Sl Unity-for-Arch-Extra) from
    Unity-for-Arch-Extra and install packages from there as you require.

> Warning:

-   Remember that you are installing unofficial packages which are not
    supported by the Arch Linux developers.
-   Almost all packages related to Unity in AUR are outdated. Do not mix
    those packages with the ones provided from the repository.

Note:Compiled packages are also available at unity.humbug.in and
unity.xe-xe.org however these are mostly outdated.

> From testing repository

There is also a testing repository which provides bleeding edge features
and is almost always synchronized to the changes made in Github
repository. You may want to use it if you prefer newest features or if
you've encountered some package conflicts while using the repositories
mentioned above.

    [Unity-for-Arch]
    SigLevel = Optional TrustAll
    Server = http://dl.dropbox.com/u/486665/Repos/Unity-for-Arch/$arch

    [Unity-for-Arch-Extra] 
    SigLevel = Optional TrustAll 
    Server = http://dl.dropbox.com/u/486665/Repos/Unity-for-Arch-Extra/$arch

Update
------

For Unity repository, the update is the same as packages from official
repositories.

Otherwise:

1. change directory into the 'Unity-for-Arch' directory where it was
originally cloned

2. pull all of changes from github repository:

    $ git pull

3. Check if packages need to be updated:

    $ ./What_can_I_update\?.py

4. If any packages need to be updated, just build them like mentioned in
From source section.

Note:Sometimes if certain crucial package is updated, those package
which depend on it will also need to be recompiled though they won't be
reported. For example, Unity is often required to be recompiled if nux
gets updated

Troubleshooting
---------------

> Unity notifications doesn't work

Ensure following is installed: notify-osd

> Screensaver locking doesn't work

Ensure following is installed: gnome-screensaver . For now you need to
also create this file

    /usr/share/dbus-1/services/org.gnome.ScreenSaver.service

    [D-BUS Service]
    Name=org.gnome.ScreenSaver
    Exec=/usr/bin/gnome-screensaver --no-daemon

> online accounts doesn't work

Ensure following is installed: signon-keyring-extension and
gnome-keyring. You may also require telepathy to get certain accounts to
work.

> ssh keys aren't remembered by keyring

Ensure following is installed: gnome-keyring

> KDE apps aren't integrated into the HUD and menubar

Ensure following is installed: appmenu-qt

> Files and Folder lens doesn't seem to work or display anything

Ensure following is installed: zeitgeist and zeitgeist-datahub

> Cannot right click on desktop

Few things this addresses/fixes:

-   Cannot right click on the desktop
-   Title bar at top doesn't display 'Arch Linux Desktop'
-   Shortcut keys like Super and Alt doesn't work when there are no
    active windows

Simply install gnome-tweak-tool then open Tweak Tool and check Have file
manager handle the desktop. You might want to uncheck Home icon visible
on desktop and Trash icon visible on desktop.

> Unity stops working after update

Try to run:

    $ compiz.reset

and Log out and log into the Unity session.

If it still doesn't work, report an issue on github or discuss it on
Arch forum.

> Window decoration doesn't work properly

Try to install gnome-tweak-tool to adjust the theme.

> Window decoration can't use certain theme

Install metacity-ubuntu instead of metacity. metacity-ubuntu is now
included in Unity-for-Arch again.

> Some GTK+ themes look ugly after update to GNOME 3.6

It also happens for unity default theme light-themes. Put

    GtkLabel {
    background-color: @transparent;
    }

in .config/gtk3.0/gtk.css

> Workspace switcher widget dissappeared

Check this setting: go to Settings > Appearance > Behaviour > Enable
workspaces.

> Newly opened window is always placed at (0,0) on the screen

metacity-ubuntu needs to be used instead of metacity.

> Window's titlebar still exists when maximized

metacity-ubuntu needs to be used instead of metacity.

> Indicator-messages doesn't work properly

Pidgin and a bunch of other applications can not be integrated into
indicator-messages due to its API changes. Wait for the upstream
software updates or you can help file a bug report.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Unity&oldid=305630"

Category:

-   Desktop environments

-   This page was last modified on 19 March 2014, at 17:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
