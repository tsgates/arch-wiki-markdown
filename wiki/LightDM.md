LightDM
=======

> Summary

Provides an overview and setup of the Light Display Manager.

> Related

Display Manager

GDM

KDM

SLiM

LightDM is a cross-desktop display manager that aims to be the standard
display manager for the X server. Its key features are:

-   A lightweight codebase
-   Standards compliant (PAM, ConsoleKit, etc)
-   A well defined interface between the server and the user interface.
-   Cross-desktop (user interfaces can be written in any toolkit).

More details about LightDM's design can be found here.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Greeter                                                      |
|                                                                          |
| -   2 Enabling LightDM                                                   |
|     -   2.1 Testing                                                      |
|                                                                          |
| -   3 Optional Configuration and Tweaks                                  |
|     -   3.1 Changing Background Images/Colors                            |
|         -   3.1.1 GTK+ Greeter                                           |
|         -   3.1.2 Unity Greeter                                          |
|         -   3.1.3 KDE Greeter                                            |
|                                                                          |
|     -   3.2 Changing the Icon                                            |
|         -   3.2.1 Sources of Arch-centric 64x64 Icons                    |
|                                                                          |
|     -   3.3 Enabling Autologin                                           |
|     -   3.4 Migrating from SLiM                                          |
|     -   3.5 NumLock ON                                                   |
|     -   3.6 User switching under xfce4                                   |
|                                                                          |
| -   4 See Also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install lightdm from the official repositories. You can also install
lightdm-devel for the development branch or lightdm-bzr from the AUR.

> Greeter

You will also need to install a greeter (a user interface for LightDM).
The reference greeter is lightdm-gtk-greeter, which is provided by
lightdm-gtk3-greeter. KDE users can install lightdm-kde-greeter, a
greeter based on Qt.

Other greeters can be installed from the AUR as well:

-   lightdm-webkit-greeter: A greeter that uses Webkit for theming.
-   lightdm-crowd-greeter: A 3D greeter that lets you select your
    profile from 3D characters walking around.
-   lightdm-unity-greeter: The greeter used by Ubuntu's Unity.
-   razor-lightdm-greeter: A greeter for the Razor-qt desktop
    environment.
-   lightdm-pantheon-greeter: A LightDM greeter from the ElementaryOS
    Project.

You can change the default greeter by changing the configuration file to
state:

    /etc/lightdm/lightdm.conf

    greeter-session=lightdm-yourgreeter-greeter

It is also possible to change the default greeter at compile time by
changing the line containing:

    --with-greeter-session=lightdm-gtk-greeter

to

    --with-greeter-session=lightdm-yourgreeter-greeter

Enabling LightDM
----------------

Make sure that the lightdm daemon is started at boot.

> Testing

First, install xorg-server-xephyr from the official repositories.

Then, run LightDM as an X application:

    $ lightdm --test-mode --debug

Optional Configuration and Tweaks
---------------------------------

Some greeters have their own configuration files. For example,
lightdm-gtk3-greeter has:

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

> Changing the Icon

Users wishing to customize the icon on the greeter screen need to edit
/etc/lightdm/lightdm-gtk-greeter.conf defining the logo variable.

Example:

    logo=/usr/share/icons/hicolor/64x64/devices/archlinux-icon-crystal-64.svg

Sources of Arch-centric 64x64 Icons

The archlinux-artwork package from the official repositories contains
some nice examples that install to /usr/share/archlinux/icons and that
can be copied to /usr/share/icons/hicolor/64x64/devices as follows:

    # find /usr/share/archlinux/icons -name "*64*" -exec cp {} /usr/share/icons/hicolor/64x64/devices \;

After copying, the archlinux-artwork package can be removed.

> Enabling Autologin

Edit the LightDM configuration file and change these lines to:

    /etc/lightdm/lightdm.conf

    autologin-user=<your_username>
    autologin-user-timeout=0

or execute:

    # /usr/lib/lightdm/lightdm/lightdm-set-defaults --autologin=USERNAME

LightDM goes through PAM even when autologin is enabled. You must be
part of the autologin group to be able to login without entering your
password:

    # groupadd autologin
    # gpasswd -a username autologin

Note:GNOME users, and by extension any gnome-keyring user will have to
set up a blank password to their keyring for it to be unlocked
automatically.

> Migrating from SLiM

Move the contents of xinitrc to xprofile, removing the call to start the
window manager or desktop environment.

> NumLock ON

Install the numlockx package and the edit  /etc/lightdm/lightdm.conf
adding the following line:

    greeter-setup-script=/usr/bin/numlockx on

> User switching under xfce4

With the release of Xfce4 4.10, user switching is supported natively. To
use it with LightDM, users need only to create a symlink:

    # ln -s /usr/lib/lightdm/lightdm/gdmflexiserver /usr/bin/gdmflexiserver

Alternatively, see the XScreenSaver#Lightdm article.

See Also
--------

-   Ubuntu Wiki article
-   Gentoo Wiki article
-   Launchpad Page
-   LightDM blog

Retrieved from
"https://wiki.archlinux.org/index.php?title=LightDM&oldid=253541"

Category:

-   Display managers
