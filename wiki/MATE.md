MATE
====

Related articles

-   GNOME
-   Cinnamon
-   Desktop environment
-   Display manager

From MATE homepage:

The MATE Desktop Environment is the continuation of GNOME 2. It provides
an intuitive and attractive desktop environment using traditional
metaphors for Linux and other Unix-like operating systems. MATE is under
active development to add support for new technologies while preserving
a traditional desktop experience.

Contents
--------

-   1 MATE Applications
-   2 Installation
    -   2.1 Additional MATE packages
-   3 Upgrading from 1.6 to 1.8
-   4 Upgrading from 1.4 to 1.6
-   5 Starting MATE
    -   5.1 Graphical log-in
    -   5.2 Manually
-   6 Accessibility
-   7 Network Management
-   8 Bluetooth
-   9 PulseAudio and GStreamer
-   10 Tips & Tricks
    -   10.1 Enabling compositing
    -   10.2 Enabling new window centering
    -   10.3 Enabling window snapping
    -   10.4 Show or hide desktop icons
        -   10.4.1 Hide all desktop icons
        -   10.4.2 Hide individual icons
    -   10.5 Use a different window manager with MATE
    -   10.6 Change window decoration button order
    -   10.7 Auto open file manager after drive mount
    -   10.8 Screensaver
    -   10.9 Lock screen & default background image
    -   10.10 Styling Qt applications
    -   10.11 Consistent cursor theme
-   11 See also

MATE Applications
-----------------

MATE is largely composed of GNOME 2 applications and utilities, forked
and renamed to avoid conflicting with their GNOME 3 counterparts. Below
is a list of common GNOME applications which have been renamed in MATE.

-   Alacarte is renamed Mozo.
-   Nautilus is renamed Caja.
-   Metacity is renamed Marco.
-   Gedit is renamed Pluma.
-   Eye of GNOME is renamed Eye of MATE.
-   Evince is renamed Atril.
-   File Roller is renamed Engrampa.
-   GNOME Terminal is renamed MATE Terminal.

Other applications and core components prefixed with GNOME (such as
GNOME Panel, GNOME Menus etc) have had the prefix changed to MATE so
they become MATE Panel, MATE Menus etc.

Installation
------------

MATE is available in the official repositories and can be installed with
one of the following:

-   The mate-panel package provides a minimal desktop shell.
-   The mate group contains the core desktop environment required for
    the standard MATE experience.
-   The mate-extra group contains additional utilities and applications
    that integrate well with the MATE desktop. Installing just the
    mate-extra group will not pull in the whole mate group via
    dependencies. If you want to install all MATE packages then you will
    need to explicitly install both groups.

> Additional MATE packages

There is an additional package not included in the mate or mate-extra
because it is not neccessarily useful to everyone.

-   The mate-netbook package provides a MATE panel applet that might be
    useful to owners of small screen devices, such as a Netbook. The
    applet will automatically maximize all windows and provides an
    application switcher applet.

There are also a number of other MATE applications that are contributed
and maintained by the MATE community and therefore not included in the
mate or mate-extra groups.

-   mate-applet-lockkeys - A MATE panel applet that shows which of the
    CapsLock, NumLock and ScrollLock keys are on and which are off.
-   mate-applet-softupd - A MATE panel applet to notify when software
    updates become available.
-   mate-applet-streamer - A MATE panel applet to let you play your
    favourite online radio station with a single click.
-   mate-color-manager - Color management application for MATE.
-   mate-accountsdialog - An application to view and modify user
    accounts information for MATE.
-   mate-disk-utility - Disk management application for MATE.
-   mate-mplayer - mplayer frontend for MATE
-   mate-nettool - MATE interface for various networking tools.
-   mate-themes-extras - Collection of GTK2/3 desktop themes for MATE.
-   gnome-main-menu - A mate-panel applet similar to the traditional
    main-menu, but with a few additions.
-   variety - Variety changes the wallpaper on a regular interval using
    user-specified or automatically downloaded images.

The following is also available via the AUR and integrates with MATE but
the package is not maintained by the MATE team.

-   mintmenu - Linux Mint Menu for MATE.

Upgrading from 1.6 to 1.8
-------------------------

Do the upgrade:

    pacman -Syu

Agree to all the package replacements, it should look something like
this.

    :: Starting full system upgrade...
    :: Replace mate-document-viewer with community/atril? [Y/n] y
    :: Replace mate-file-archiver with community/engrampa? [Y/n] y
    :: Replace mate-file-manager with community/caja? [Y/n] y
    :: Replace mate-file-manager-gksu with community/caja-extensions? [Y/n] y
    :: Replace mate-file-manager-image-converter with community/caja-extensions? [Y/n] y
    :: Replace mate-file-manager-open-terminal with community/caja-extensions? [Y/n] y
    :: Replace mate-file-manager-sendto with community/caja-extensions? [Y/n] y
    :: Replace mate-file-manager-share with community/caja-extensions? [Y/n] y
    :: Replace mate-image-viewer with community/eom? [Y/n] y
    :: Replace mate-menu-editor with community/mozo? [Y/n] y
    :: Replace mate-text-editor with community/pluma? [Y/n] y
    :: Replace mate-window-manager with community/marco? [Y/n] y

When the MATE 1.8 upgrade is complete there are a few packages you can
remove because some of the MATE 1.6 libraries are not required by MATE
1.8.

    pacman -Rs libmatekeyring libmatewnck mate-character-map mate-keyring

Upgrading from 1.4 to 1.6
-------------------------

MATE 1.6 migrated from gconf to gsettings. If you are updating from an
MATE 1.4 you might end up with an empty panel. To resolve the issue
reset the panel configuration to its defaults using

    # mate-panel --reset

Then use...

    # mate-conf-import

to restore most of your old settings. After upgrading from MATE 1.4 to
MATE 1.6 you should remove the some of the old MATE 1.4 libraries that
are not required by MATE 1.6, this can also improve the start-up time of
MATE.

    # pacman -R ffmpegthumbnailer-caja libmate libmatecanvas libmatecomponent libmatecomponentui libmatenotify libmateui mate-conf mate-conf-editor mate-corba mate-mime-data mate-vfs python-corba python-mate python-mate-desktop

You can also use:

    # pacman -R $(pacman -Qtdq)

to remove any orphaned packages. Packages which are not orphaned are
probably still required.

Note:The command to remove orphaned packages will need to be executed
multiple times to ensure that all packages are cleaned up.

Warning:When removing the deprecated libraries take care to not remove
other important packages as well.

Starting MATE
-------------

MATE can be started via a display manager or manually.

> Graphical log-in

Just select MATE from the Sessions list of your favorite Display
manager. The MATE team recommends LightDM as the display manager with
the GTK+ (2) greeter, which can be installed with the
lightdm-gtk2-greeter package.

> Manually

If you prefer to start MATE manually from the console, add the following
line to your ~/.xinitrc file:

    ~/.xinitrc

    exec mate-session

Then MATE can be launched by typing startx.

See xinitrc for details, such as preserving the logind session.

Accessibility
-------------

MATE is well suited for use by individuals with sight or mobility
impairment. First install orca and espeak (Screen reader for individuals
who are blind or visually impaired) and onboard (On-screen keyboard
useful for mobility impaired users)

    pacman -Syy orca espeak onboard 

Now create /etc/profile.d/gtk-accessibility.sh and add the following to
it.

    export GTK_MODULES=gail:atk-bridge

Reboot to make the change take affect and you can configure the
accessibility applications via
System -> Preferences -> Assistive Technologies.

Network Management
------------------

It is recommended that you use Network Manager for managing networks in
MATE. Please see the wiki page for more details on installing and
configuring it.

Bluetooth
---------

Bluetooth support for MATE 1.8 is pending the completion of a new
version of Blueman. Details will be added here shortly.

PulseAudio and GStreamer
------------------------

MATE supports two audio backends, PulseAudio and GStreamer. By default,
the PulseAudio backend is installed but if you want to switch to the
GStreamer backend, do the following:

    # pacman -S mate-settings-daemon-gstreamer mate-media-gstreamer

Tips & Tricks
-------------

> Enabling compositing

Compositing is not be enabled by default. To enable it navigate to run
System -> Preferences -> Windows and click the tick box alongside Enable
software compositing window manager in the General tab. Alternatively,
you can run the following from the terminal:

    $ dconf write /org/mate/marco/general/compositing-manager true

> Enabling new window centering

By default, new windows are placed in the top-left corner. To center new
windows on creation navigate to run System -> Preferences -> Windows and
click the tick box alongside Center new windows in the Placement tab.
Alternatively, you can run the following from the terminal:

    $ dconf write /org/mate/marco/general/center-new-windows true

> Enabling window snapping

Window snapping is not be enabled by default, to enable it navigate to
run System -> Preferences -> Windows and click the tick box alongside
Enable side by side tiling in the Placement tab.

> Show or hide desktop icons

By default, MATE shows multiple icons on the desktop: The content of
your desktop directory, computer, home and network directories, the
trash and mounted drives. You can show or hide them individually or all
at once using dconf.

Hide all desktop icons

    $ dconf write /org/mate/desktop/background/show-desktop-icons false

Hide individual icons

Hide computer icon:

    $ dconf write /org/mate/caja/desktop/computer-icon-visible false

Hide user directory icon:

    $ dconf write /org/mate/caja/desktop/home-icon-visible false

Hide network icon:

    $ dconf write /org/mate/caja/desktop/network-icon-visible false

Hide trash icon:

    $ dconf write /org/mate/caja/desktop/trash-icon-visible false

Hide mounted volumes:

    $ dconf write /org/mate/caja/desktop/volumes-visible false

Replace false with true for the icons to reappear.

> Use a different window manager with MATE

The default window manager in MATE is called marco, a fork of the GNOME
2 window manager metacity. You can replace marco with another window
manager via a number of different methods:

-   The easiest way to change the window manager is to autostart it
    using mate-session-properties. Open the System menu, navigate to the
    Preferences menu and click on Startup Applications. In the dialog
    click Add. Enter a name and comment in the name and comment sections
    and in the command section add a command of the following syntax:
    "name of window manager" "--replace"

For example: for openbox you would use the command openbox --replace.

Log out and log in again and marco should be replaced by the window
manager of your choice. To revert to marco simply delete the entry you
created in Startup Applications.

-   Alternatively you can specify the desired window manager in dconf:

    $ dconf write /org/mate/desktop/session/required-components/windowmanager "'mywindowmanager'"

replace "mywindowmanager" with the name of the window manager of your
choice e.g. openbox or metacity.

-   Killing MATE's window manager (marco) and starting your prefered one
    (this method is not recommended!)

Edit your .xinitrc as follow:

    exec mate-session
    killall marco
    exec mywindowmanager

and replace "mywindowmanager" with the name of the window manager of
your choice.

Note:This method is relevant only for those who start the MATE session
using the startx command. Users of display managers will need to use one
of the previous two methods.

> Change window decoration button order

You can change the button using dconf. The key is in
org.mate.marco.general.button-layout. Use the graphical dconf-editor or
the dconf command line tool to change it:

    $ dconf write /org/mate/marco/general/button-layout "'close,maximize,minimize:'"

and put menu, close, minimize and maximize in your desired order,
separated by commas. The colon is the window title (it is necessary for
the changes to apply).

> Auto open file manager after drive mount

By default, MATE automatically opens a new file manager window when a
drive is mounted. To disable this, change the following key in dconf:

    $ dconf write /org/mate/desktop/media-handling/automount-open false

> Screensaver

MATE uses mate-screensaver to lock your session. By default there are a
limited number of lock-screens available. To make more lock-screens
available, install the mate-screensaver-hacks package. This will allow
you to use Xscreensaver lock-screens with mate-screensaver.

> Lock screen & default background image

You can change the background of the lock screen by creating the
following file:

    /usr/share/glib-2.0/schemas/mate-background.gschema.override

    [org.mate.background]
    picture-filename='/path/to/the/background.jpg'

Then, re-compile the schemas:

    # glib-compile-schemas /usr/share/glib-2.0/schemas/

Finally, restart your X session for the change to effect.

> Styling Qt applications

To make Qt4 applications inherit the MATE theme, do the following:

    * Navigate to System -> Preferences -> Qt4 Config or execute qtconfig-qt4 from a shell.
    * Change GUI Style to GTK+.
    * File --> Save.

See Uniform Look for Qt and GTK Applications for more details.

> Consistent cursor theme

To ensure a consistent cursor theme edit ~/.icons/default/index.theme to
include:

    [Icon Theme]
    Inherits=mate

See also
--------

-   MATE homepage
-   MATE wiki for Arch Linux
-   MATE desktop screenshots
-   The MATE Desktop Environment - Arch Linux forum discussion about
    MATE

Retrieved from
"https://wiki.archlinux.org/index.php?title=MATE&oldid=305863"

Category:

-   Desktop environments

-   This page was last modified on 20 March 2014, at 14:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
