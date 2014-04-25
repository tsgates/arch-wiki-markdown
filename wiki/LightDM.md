LightDM
=======

Related articles

-   Display manager
-   GDM
-   KDM
-   LXDM

LightDM is a cross-desktop display manager that aims to be the standard
display manager for the X server. Its key features are:

-   A lightweight codebase
-   Standards compliant (PAM, logind, etc)
-   A well defined interface between the server and the user interface.
-   Cross-desktop (user interfaces can be written in any toolkit).

More details about LightDM's design can be found here.

Contents
--------

-   1 Installation
    -   1.1 Greeter
-   2 Enabling LightDM
-   3 Command line tool
-   4 Testing
-   5 Optional configuration and Tweaks
    -   5.1 Changing Background Images/Colors
        -   5.1.1 GTK+ Greeter
        -   5.1.2 Unity Greeter
        -   5.1.3 KDE Greeter
    -   5.2 Changing your avatar
        -   5.2.1 The .face way
        -   5.2.2 The AccountsService way
        -   5.2.3 Sources of Arch-centric 64x64 Icons
    -   5.3 Enabling Autologin
    -   5.4 Hiding system and services users
    -   5.5 Migrating from SLiM
    -   5.6 NumLock ON
    -   5.7 User switching
    -   5.8 Default Session
-   6 Troubleshooting
    -   6.1 Power menu (restart, poweroff etc.) not available
    -   6.2 Wrong locale displayed
    -   6.3 Xresources not being parsed correctly
    -   6.4 Missing icons with GTK greeter
-   7 See Also

Installation
------------

Install lightdm from the official repositories. You can also install
lightdm-devel for the development branch or lightdm-bzr from the AUR.

> Greeter

You will also need to install a greeter (a user interface for LightDM).
The reference greeter is lightdm-gtk-greeter, which is provided by
lightdm-gtk2-greeter or lightdm-gtk3-greeter. KDE users can install
lightdm-kde-greeter, a greeter based on Qt.

Other greeters can be installed from the AUR as well:

-   lightdm-another-gtk-greeter: A GTK3 greeter with custom theme
    support
-   lightdm-webkit-greeter: A greeter that uses Webkit for theming.
-   lightdm-crowd-greeter: A 3D greeter that lets you select your
    profile from 3D characters walking around.
-   lightdm-unity-greeter: The greeter used by Ubuntu's Unity.
-   lightdm-razor-greeter: A greeter for the Razor-qt desktop
    environment.
-   lightdm-pantheon-greeter: A greeter from the ElementaryOS Project.

You can change the default greeter by changing the configuration file to
state:

    /etc/lightdm/lightdm.conf

    greeter-session=lightdm-yourgreeter-greeter

Enabling LightDM
----------------

Make sure to enable the lightdm daemon using systemctl so it will be
started at boot.

Command line tool
-----------------

LightDM offers a command line tool, dm-tool, which can be used to lock
the current seat, switch sessions, etc, which is useful with
'minimalist' window managers and for testing. To see a list of available
commands, execute:

    $ dm-tool --help

Testing
-------

First, install xorg-server-xephyr from the official repositories.

Then, run LightDM as an X application:

    $ lightdm --test-mode --debug

Optional configuration and Tweaks
---------------------------------

Some greeters have their own configuration files. For example,
lightdm-gtk2-greeter and lightdm-gtk3-greeter have:

    /etc/lightdm/lightdm-gtk-greeter.conf

and lightdm-kde-greeter has:

    /etc/lightdm/lightdm-kde-greeter.conf

as well as a section in KDE's System Settings (recommended).

LightDM can be configured by directly modifying its configuration script
or by using the lightdm-set-defaults applications that can be found in
/usr/lib/lightdm/lightdm/. To see some of the options available,
execute:

    $ man lightdm-set-defaults

There are, however, a lot more variables to modify in the configuration
file than by using the lightdm-set-defaults application.

> Changing Background Images/Colors

Users wishing to have a flat color (no image) may simply set the
background variable to a hex color.

Example:

    background=#000000

If you want to use an image instead, see below.

GTK+ Greeter

Users wishing to customize the wallpaper on the greeter screen need to
edit /etc/lightdm/lightdm-gtk-greeter.conf defining the background
variable.

Example:

    background=/usr/share/pixmaps/black_and_white_photography-wallpaper-1920x1080.jpg

Unity Greeter

Users using the lightdm-unity-greeter must edit the
/usr/share/glib-2.0/schemas/com.canonical.unity-greeter.gschema.xml file
and then execute:

    # glib-compile-schemas /usr/share/glib-2.0/schemas/

According to this page.

Note:It is recommended to place the PNG or JPG file in
/usr/share/pixmaps since the LightDM user needs read access to the
wallpaper file.

KDE Greeter

Go to System Settings > Login Screen (LightDM) and change the background
image for your theme.

> Changing your avatar

The .face way

Users wishing to customize their image on the greeter screen need to
place an PNG image called .face or .face.icon in their home directory.
Make sure it can be read by LightDM.

Note:As of December 2013, some people have issues where the icon file
does not get picked up. The preferred way is to install accountsservice
and use the following AccountsService way.

The AccountsService way

The .face way is known to cause issues, fortunately LightDM is able to
automatically use AccountsService if it is installed. First make sure
the accountsservice package (official repositories) is installed, then
set it up as follows:

-   A user file named after your user in
    /var/lib/AccountsService/users/johndoe containing:

    [User]
    Icon=/var/lib/AccountsService/icons/johndoe

-   A 96x96 PNG icon file in /var/lib/AccountsService/icons/johndoe

Sources of Arch-centric 64x64 Icons

The archlinux-artwork package from the AUR contains some nice examples
that install to /usr/share/archlinux/icons and that can be copied to
/usr/share/icons/hicolor/64x64/devices as follows:

    # find /usr/share/archlinux/icons -name "*64*" -exec cp {} /usr/share/icons/hicolor/64x64/devices \;

After copying, the archlinux-artwork package can be removed.

> Enabling Autologin

Edit the LightDM configuration file and change these lines to:

    /etc/lightdm/lightdm.conf

    autologin-user=USERNAME
    autologin-user-timeout=0

or execute:

    # /usr/lib/lightdm/lightdm/lightdm-set-defaults --autologin=USERNAME

LightDM goes through PAM even when autologin is enabled. You must be
part of the autologin group to be able to login without entering your
password:

    # groupadd autologin
    # gpasswd -a USERNAME autologin

Note:GNOME users, and by extension any gnome-keyring user will have to
set up a blank password to their keyring for it to be unlocked
automatically.

> Hiding system and services users

To prevent system users from showing-up in the login, install the
optional dependency accountsservice, or add the user names to
/etc/lightdm/users.conf under hidden-users. The first option has the
advantage of not needing to update the list when more users are added or
removed.

> Migrating from SLiM

Move the contents of xinitrc to xprofile, removing the call to start the
window manager or desktop environment.

> NumLock ON

Install the numlockx package and the edit /etc/lightdm/lightdm.conf
adding the following line:

    greeter-setup-script=/usr/bin/numlockx on

> User switching

LightDM supports user switching under a number of different desktop
environments. To enable user switching it is necessary to create a
symlink:

    # ln -s /usr/lib/lightdm/lightdm/gdmflexiserver /usr/local/bin/gdmflexiserver

For an alternative method see the XScreenSaver#Lightdm article.

> Default Session

Lightdm, like other DMs, stores the last-selected xsession in ~/.dmrc.
See Display manager#Session_list for more info.

Troubleshooting
---------------

If you encounter consistent screen flashing and ultimately no lightdm on
boot, ensure that you have defined the greeter correctly in lightdm's
config file. And if you have correctly defined the GTK greeter, make
sure the xsessions-directory (default: /usr/share/xsessions) exists and
contains at least one .desktop file.

The same error can happen on lightdm startup if the last used session is
not available anymore (eg. you last used gnome and then removed the
gnome-session package): the easiest workaround is to temporarily restore
the removed package. Another solution might be:

    # dbus-send --system --type=method_call --print-reply --dest=org.freedesktop.Accounts /org/freedesktop/Accounts/User1000 org.freedesktop.Accounts.User.SetXSession string:xfce

This example sets the session "xfce" as default for the user 1000.

> Power menu (restart, poweroff etc.) not available

If you have installed lightdm before lightdm-1:1.6.0-6, you might have
been struck by this bug: FS#36613, to fix it run:

    # chown polkitd:root /usr/share/polkit-1/rules.d

> Wrong locale displayed

In case of your locale not being displayed correctly in Lightdm add your
locale to /etc/environment

     LANG=pt_PT.utf8

> Xresources not being parsed correctly

LightDM has an upstream bug where your Xresources file will not be
loaded with a pre-processor. In practical terms, this means that
variables set with #define are not expanded when called later. You may
see this reflected as an all-pink screen if using a custom color set
with urxvt. To fix it, edit /etc/lightdm/Xsession and search for the
line:

    xrdb -nocpp -merge "$file"

Change it to read:

    xrdb -merge "$file"

Your Xresources will now be pre-processed so that variables are
correctly expanded.

> Missing icons with GTK greeter

If you're using lightdm-gtk2-greeter as a greeter and it shows
placeholder images as icons, make sure valids icon theme and theme are
configured. Check the following file:

    /etc/lightdm/lightdm-gtk-greeter.conf

    [greeter]
    theme-name=mate      # this should be the name of a directory under /usr/share/themes/
    icon-theme-name=mate # this should be the name of a fully featured icons set directory under /usr/share/icons/

See Also
--------

-   Ubuntu Wiki article
-   Gentoo Wiki article
-   Launchpad Page
-   LightDM blog

Retrieved from
"https://wiki.archlinux.org/index.php?title=LightDM&oldid=306016"

Category:

-   Display managers

-   This page was last modified on 20 March 2014, at 17:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
