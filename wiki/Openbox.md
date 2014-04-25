Openbox
=======

Related articles

-   Desktop environment
-   Display manager
-   File manager functionality
-   Window manager
-   Oblogout

Openbox is a lightweight, powerful, and highly configurable stacking
window manager with extensive standards support. It may be built upon
and run independently as the basis of a unique desktop environment, or
within other integrated desktop environments such as KDE and Xfce, as an
alternative to the window managers they provide. The LXDE desktop
environment is itself built around Openbox.

A comprehensive list of features are documented at the official Openbox
website. This article pertains to specifically installing Openbox under
Arch Linux.

Contents
--------

-   1 Installation
-   2 Openbox Sessions
    -   2.1 Standalone
    -   2.2 Within other desktop environments
        -   2.2.1 GNOME
        -   2.2.2 KDE
        -   2.2.3 Xfce
-   3 System configuration
    -   3.1 D-Bus
    -   3.2 GTK+ 2
    -   3.3 XDG
    -   3.4 Home folders
    -   3.5 Authentication and passwords
-   4 Configuration
    -   4.1 rc.xml
    -   4.2 menu.xml
    -   4.3 autostart
        -   4.3.1 Listing commands
    -   4.4 environment
    -   4.5 Optional GUI configuration packages
-   5 Openbox reconfiguration
-   6 Keybinds
    -   6.1 Special keys
        -   6.1.1 Modifiers
        -   6.1.2 Multimedia keys
        -   6.1.3 Navigation keys
    -   6.2 Volume Control
        -   6.2.1 ALSA
        -   6.2.2 Pulseaudio
        -   6.2.3 OSS
    -   6.3 Brightness control
    -   6.4 Window snapping
    -   6.5 Desktop menu
-   7 Menus
    -   7.1 Static
        -   7.1.1 menumaker
        -   7.1.2 obmenu
        -   7.1.3 xdg-menu
        -   7.1.4 logout menu options
    -   7.2 Pipes
        -   7.2.1 Examples
    -   7.3 Generators
        -   7.3.1 obmenu-generator
        -   7.3.2 openbox-menu
        -   7.3.3 obmenugen
    -   7.4 Menu icons
    -   7.5 Desktop menu as a panel menu
-   8 GTK+ desktop theming
    -   8.1 Configuration
    -   8.2 Installation: official and AUR
    -   8.3 Installation: other sources
        -   8.3.1 Zip and tar files
    -   8.4 Troubleshooting
        -   8.4.1 Theme cannot be used
        -   8.4.2 Theme looks broken
    -   8.5 Edit or create new themes
-   9 Compositing effects
-   10 Mouse cursor and application icon themes
    -   10.1 xcursor themes (mouse)
    -   10.2 Application icon themes
-   11 Desktop icons and wallpapers
    -   11.1 Desktop management using file managers
    -   11.2 Wallpaper / background programs
        -   11.2.1 nitrogen
        -   11.2.2 feh
        -   11.2.3 hestroot
        -   11.2.4 xsetroot
    -   11.3 Icon programs
        -   11.3.1 idesk
        -   11.3.2 xfdesktop
    -   11.4 conky reconfiguration
-   12 File managers
-   13 oblogout
-   14 Openbox for multihead users
-   15 Tips and tricks
    -   15.1 Packages for beginners
    -   15.2 Set default applications / file associations
    -   15.3 Terminal content copy and paste
    -   15.4 Ad-hoc window transparency
    -   15.5 Using obxprop for faster configuration
    -   15.6 Xprop values for applications
        -   15.6.1 Firefox
    -   15.7 Switching between keyboard layouts
-   16 Troubleshooting
    -   16.1 Windows load behind the active window
-   17 See also

Installation
------------

Install openbox, available in the official repositories.

Openbox Sessions
----------------

Again, Openbox may be run independently as a standalone window manager,
or within other integrated desktop environments such as KDE and XFCE as
an alternative to the window managers they provide.

> Standalone

Many popular display managers such as LXDM, SLiM, and LightDM will
automatically detect Openbox, allowing for it to be run as a standalone
session.

However, it may be necessary to manually specify the command to start an
openbox session where intending to set it as a default session for SLiM,
or where not using a display manager at all (e.g. logging in at the
command line, followed by the command startx). In either instance, it
will be necessary to modify the Xinitrc file in order to add the
following command:

    exec openbox-session

> Within other desktop environments

When replacing the native window manager of a desktop environment with
Openbox, any desktop compositing effects - such a transparency -
provided by that native window manager will be lost. This is because
Openbox itself does not provide any compositing functionality. However,
it is easily possible to use a separate compositing program to re-enable
compositing.

GNOME

Openbox does not seem to work with GNOME 3. The Gnome-Shell touch-style
interface requires both its native window manager and its native
gtk-window-decorator packages to function. Furthermore, attempting to
run Openbox within the Classic-Gnome-Shell interface results in the loss
of the gnome-panel. Ceasing Openbox and attempting to restore the native
window manager will result in crashing the desktop. Gnome 3 is tightly
integrated, and is therefore deliberately designed not to be modular in
nature (i.e. allowing components to be changed).

KDE

See the using Openbox in KDE section of the main KDE article.

Xfce

See the replacing the native window manager section of the main Xfce
article.

System configuration
--------------------

Those installing Openbox - particularly as a stand-alone Window Manager
- will have noticed that several elements may fail to work properly, or
even work at all. Examples of the common problems encountered are:

-   File Managers: Other partitions are not displayed or accessable. The
    trash function - where provided - does not work
-   Authentication: Passwords are not stored / remembered during
    sessions
-   Secure Shell (SSH): SSH agent will not start
-   Wireless Connection: Instant failure when attempting to connect to
    wifi (related to authentication)
-   Themes: Application windows are mismatched or haphazard-looking
-   Folders: Expected folders such as Documents, Downloads and so forth
    are missing from the Home folder
-   System Tray: Installed packages fail to autostart or can be seen
    running twice

Most of these problems are actually the result of Dbus and GTK issues,
both of which can be fixed simultaneously by editing the ~/.xprofile
file - or if using SLiM as a display manager instead - by editing the
~/.xinitrc file. It will also be necessary to install some key packages
to ensure full functionality.

> D-Bus

File manager, authentication, SSH agent, and WiFi-connection problems
will likely be due to that D-Bus is not functioning correctly. Most
display managers such as GDM, KDM, LightDM and LXDM will handle this for
you.

When using xinit or certain other DMs (such as XDM and SLiM), make sure
~/.xinitrc is based on /etc/skel/.xinitrc (so that it sources
/etc/X11/xinit/xinitrc.d/, see xinitrc for more information).

> GTK+ 2

Problems with the theme and look will likely be due to the absence of
the appropriate command to ensure that a uniform look must be applied to
applications that use GTK 2. Again, edit ~/.xinitrc and/or ~/.xprofile
with the following command:

    export GTK2_RC_FILES="$HOME/.gtkrc-2.0" 

The ~/.gtkrc-2.0 file will be automatically generated where using
lxappearance to set themes.

It will also be necessary to install libgnomeui to ensure that Qt is
also able to find GTK themes.

> XDG

In addition to sourcing the local ~/.config/openbox/autostart file to
autostart applications, Openbox will also source .desktop files
automatically installed by some packages in the global
/etc/xdg/autostart directory. The package responsible for allowing
Openbox to additionally source the /etc/xdg/autostart directory is
python2-xdg.

For example, where initially autostarting a package such as the Network
Manager applet (nm-applet) locally, should python2-xdg be installed at a
later time - either explicitly or as a dependency for another package -
its global XDG .desktop file will then also be sourced as a consequence,
resulting in seeing two icons running in the system tray. It is
therefore recommended to install python2-xdg explicitly, as this will
ensure that applications that should automatically autostart when
installed will do so.

> Home folders

Tip:This fix will be especially helpful for those who wish to use a file
manager to manage their desktop, as it will automatically create a
special ~/Desktop directory, which will house all files and application
shortcuts stored on the desktop itself.

Where expected Home folders such as Downloads, Documents, etc., are not
present, then please review the Xdg user directories article.

> Authentication and passwords

For authentication (e.g. WiFi passwords, etc.), it will be necessary to
install the appropriate packages. They are:

-   polkit: Application development toolkit for controlling system-wide
    privileges; see polkit
-   lxpolkit: Simple policykit authentication agent for LXDE
    (polkit-gnome currently does not work properly)
-   gnome-keyring: store / remember passwords; see GNOME Keyring

Configuration
-------------

Warning:Edit these files as the user you will be using Openbox with. Not
as root!

Tip:Local configuration files will always override global equivalents.
These files may also be manually edited by any appropriate text editor,
such as Leafpad or Geany; there is no need to use sudo or gksu commands
to edit them.

Four key files form the basis of the openbox configuration, each serving
a unique role. They are: rc.xml, menu.xml, autostart, and environment.
Although these files are discussed in more detail below, to start
configuring Openbox, it will first be necessary to create a local
Openbox profile (i.e for your specific user account) based on them. This
can be done by copying them from the global /etc/xdg/openbox profile
(applicable to any and all users) as a template:

    $ mkdir -p ~/.config/openbox
    $ cp -R /etc/xdg/openbox/* ~/.config/openbox

> rc.xml

Tip:Custom keyboard shortcuts (keybindings) must be added to the
<keyboard> section of this file, and underneath the
<!-- Keybindings for running aplications --> heading.

~/.config/openbox/rc.xml is the main configuration file, responsible for
determining the behaviour and settings of the overall session,
including:

-   Keyboard shortcuts (e.g. starting applications; controlling the
    volume)
-   Theming
-   Desktop and Virtual desktop settings, and
-   Application Window settings

This file is also pre-configured, meaning that it will only be necessary
to amend existing content in order to customise behaviour to suit
personal preference.

> menu.xml

~/.config/openbox/menu.xml defines the type and behaviour of the desktop
menu, accessable by right-clicking the background. Although the default
provided is a static menu (meaning that it will not automatically update
when new applications are installed), it is possible to employ the use
of dynamic menus that will automatically update as well.

The available options are discussed extensively below in the Menus
section.

> autostart

Tip:Be aware that some applications will automatically start via
.desktop files installed in the /etc/xdg/autostart/ or
~/.config/autostart/ directories.

~/.config/openbox/autostart determines which applications are to be
launched upon beginning the Openbox session. These may include:

-   Panels and/or docks
-   Compositors
-   Background providers
-   Screensavers
-   Applications to autoload or autostart (e.g. Conky)
-   Daemon processes (e.g. File Managers for automounting and other
    functions)
-   Other appropriate commands (e.g. disable DPMS)

Listing commands

There are two very important points to note when adding commands to the
~/.config/openbox/autostart file:

-   Each and every command must be terminated with an ampersand (&).
    Where a command does not end with an ampersand, then no further
    commands listed below it will be executed.
-   It is strongly recommended to add delays to the execution of some or
    all commands in the autostart file, even if only by a single second.
    The consequence of not doing so is that all commands will be
    executed simultaneously, potentially resulting in the mis- or
    non-starting of items. The syntax of the command to delay the
    execution of commands (in seconds) is:

    (sleep <number of seconds>s && <command>) &

For example, to delay the execution of Conky by 3 seconds, the command
would be (and note the termination of it with an ampersand):

    (sleep 3s && conky) &

Here is a more complete example of a possible
~/.config/openbox/autostart file:

    ## Autostart File ##

    ##Disable DPMS
    xset -dpms; xset s off &

    ##Compositor
    compton -CGb &

    ##Background
    (sleep 1s && nitrogen --restore) &

    ##tint2 panel
    (sleep 1s && tint2) &

    ##Sound Icon
    (sleep 1s && volumeicon) &

    ##Screensaver
    (sleep 1s && xscreensaver -no-splash) &

    ##Conky
    (sleep 3s && conky) &

    ##Disable touchpad
    /user/bin/synclient TouchpadOff=1 &

> environment

Note:This is the least important file, and many users may not need to
edit it at all.

~/.config/openbox/environment can be used to export and set relevant
environmental variables such as to:

-   Define new pathways (e.g. execute commands that would otherwise
    require the entire pathway to be listed with them)
-   Change language settings, and
-   Define other variables to be used (e.g. the fix for GTK theming
    could be listed here)

> Optional GUI configuration packages

Several GUIs are available to quickly and easily configure your Openbox
desktop. From the official repositories these include:

-   obconf: Basic Openbox configuration manager
-   lxappearance-obconf: LXDE configuration manager (provides additional
    options)
-   lxinput: LXDE keyboard and mouse configuration
-   lxrandr: LXDE monitor configuration

Others, such as obkey (configure keyboard shortcuts via the rc.xml file)
and ob-autostart (configure the Openbox autostart file) are available
from the AUR. Programs and applications relating to the configuration of
Openbox's desktop menu are discussed in the Menus section.

Openbox reconfiguration
-----------------------

Tip:where not already present, it would be worthwhile adding this
command to a menu and/or as a keybind for convenience.

Openbox will not always automatically reflect any changes made to its
configuration files within a session. As a consequence, it will be
necessary to manually reload those files after they have been edited. To
do so, enter the following command:

    $ openbox --reconfigure

Where intending to add this command as a keybinnd to
~/.config/openbox/rc.xml, it will only be necessary to list the command
as reconfigure. An example has been provided below, using the Super+F11
keybind:

    <keybind key="W-F11">
      <action name="Reconfigure"/>
    </keybind>

Keybinds
--------

All keybinds must be added to the ~/.config/openbox/rc.xml file, and
below the <!-- Keybindings for running aplications --> heading. Although
a brief overview has been provided here, a more in-depth explanation of
keybindings can be found at openbox.org. There is a utility 'obkey' in
AUR for adjust key-binding. Before use obkey, you should use obconf to
create ~/.config/openbox/rc.xml.

> Special keys

While the use of standard alpha-numeric keys for keybindings is
self-explanatory, special names are assigned to other types of keys,
such as modifers, multimedia keys and navigation keys.

Modifiers

Modifer keys play an important role in keybindings (e.g. holding down
the shift or CTRL / control key in combination with another key to
undertake an action). Using modifers helps to prevent conflicting
keybinds, whereby two or more actions are linked to the same key or
combination of keys. The syntax to use a modifer with another key is:

    "<modifier>-<key>"

The modifer codes are as follows:

-   S: Shift
-   C: Control / CTRL
-   A: Alt
-   W: Super / Windows
-   M: Meta
-   H: Hyper (If it is bound to something)

For example, the code below would use super and t to launch lxterminal

    <keybind key="W-t">
        <action name="Execute">
            <command>lxterminal</command>
        </action>
    </keybind>

Multimedia keys

Where available, it is possible to set the appropriate multimedia keys
to perform their intended functions, such as to control the volume
and/or the screen brightness. These will usually be integrated into the
function keys, and are identified by their appropriate symbols. See the
Multimedia Keys article for further information.

The volume and brightness multimedia codes are as follows (note that
commands will still have to be assigned to them to actually function):

-   XF86AudioRaiseVolume: Increase volume
-   XF86AudioLowerVolume: Decrease volume
-   XF86AudioMute: Mute / unmute volume
-   XF86MonBrightnessUp: Increase screen brightess
-   XF86MonBrightnessDown: Decrease screen brightness

Examples of how these may be used in ~/.config/openbox/rc.xml have been
provided below.

Navigation keys

These are the directional / arrow keys, usually used to move the cursor
up, down, left, or right. The (self-explanatory) navigation codes are as
follows:

-   Up: Up
-   Down: Down
-   Left: Left
-   Right: Right

> Volume Control

What commands should be used for controlling the volume will depend on
whether ALSA, PulseAudio, or OSS is used for sound.

ALSA

If ALSA is used for sound, the amixer program can be used to adjust the
volume, which is part of the alsa-utils package. The following example -
using the multimedia keys intended to control the volume - will adjust
the volume by +/- 5% (which may be changed, as desired):

    <keybind key="XF86AudioRaiseVolume">
        <action name="Execute">
            <command>amixer set Master 5%+ unmute</command>
        </action>
    </keybind>
    <keybind key="XF86AudioLowerVolume">
        <action name="Execute">
            <command>amixer set Master 5%- unmute</command>
        </action>
    </keybind>
    <keybind key="XF86AudioMute">
        <action name="Execute">
            <command>amixer set Master toggle</command>
        </action>
    </keybind>

Pulseaudio

Where using PulseAudio with ALSA as a backend, the amixer program
commands will have to be modifed, as illustrated below in comparison to
the ALSA example:

    <keybind key="XF86AudioRaiseVolume">
        <action name="Execute">
            <command>amixer -D pulse set Master 5%+ unmute</command>
        </action>
    </keybind>
    <keybind key="XF86AudioLowerVolume">
        <action name="Execute">
            <command>amixer -D pulse set Master 5%- unmute</command>
        </action>
    </keybind>
    <keybind key="XF86AudioMute">
        <action name="Execute">
            <command>amixer set Master toggle</command>
        </action>
    </keybind>

OSS

Note:This option may be suitable for more experienced users.

Where using OSS, it is possible to create keybindings to raise or lower
specific mixers. This allows, for example, the volume of a specific
application (such as an audio player) to be changed without changing the
overall system volume settings in turn. In this instance, the
application must first have been configured to use its own mixer.

In the following example, MPD has been configured to use its own mixer -
also named mpd - to increase and decrease the volume by a single decibel
at a time. The -- that appears after the ossmix command has been added
to prevent a negative value from being treated as an argument:

    <keybind key="[chosen keybind]">
        <action name="Execute">
            <command>ossmix -- mpd +1</command>
        </action>
    </keybind>
    <keybind key="[chosen keybind]">
        <action name="Execute">
            <command>ossmix -- mpd -1</command>
        </action>
    </keybind>

> Brightness control

The xbacklight program is used to control screen brightness, which is
part of the Xorg X-Window system. In the example below, the multimedia
keys intended to control the screen brightness will adjust the settings
by +/- 10%:

    <keybind key="XF86MonBrightnessUp">
         <action name="Execute">
           <command>xbacklight +10</command>
         </action>
    </keybind>
    <keybind key="XF86MonBrightnessDown">
         <action name="Execute">
           <command>xbacklight -10</command>
         </action>
    </keybind>

> Window snapping

Many desktop environments and window managers support window snapping
(e.g. Windows 7 Aero snap), whereby they will automatically snap into
place when moved to the edge of the screen. This effect can also be
simulated in Openbox through the use of keybinds on focused windows.

As illustrated in the example below, percentages must be used to
determine window sizes (see openbox.org for further information). In
this instance, The super key is used in conjunction with the navigation
keys:

    <keybind key="W-Left">
        <action name="UnmaximizeFull"/>
        <action name="MaximizeVert"/>
        <action name="MoveResizeTo">
            <width>50%</width>
        </action>
        <action name="MoveToEdge"><direction>west</direction></action>
    </keybind>
    <keybind key="W-Right">
        <action name="UnmaximizeFull"/>
        <action name="MaximizeVert"/>
        <action name="MoveResizeTo">
            <width>50%</width>
        </action>
        <action name="MoveToEdge"><direction>east</direction></action>
    </keybind>

However, it should be noted that once a window has been 'snapped' to an
edge, it will remain vertically maximised unless subsequently maximised
and then restored. The solution is to implement additional keybinds - in
this instance using the down and up keys - to do so. This will also make
pulling 'snapped' windows from screen edges faster as well:

    <keybind key="W-Down">
       <action name="Unmaximize"/>
    </keybind>
    <keybind key="W-Up">
       <action name="Maximize"/>
    </keybind>

This Ubuntu forum thread provides more information. Applications such as
opensnap-git are also available from the AUR to automatically simulate
window snapping behaviour without the use of keybinds.

> Desktop menu

It is also possible to create a keybind to access the desktop menu. For
example, the following code will bring up the menu by pressing CTRL + m:

    <keybind key="C-m">
        <action name="ShowMenu">
           <menu>root-menu</menu>
        </action>
    </keybind>

Menus
-----

It is possible to employ three types of menu in Openbox: static, pipes
(dynamic), and generators (static or dynamic). They may also be used
alone or in any combination.

> Static

As the name would suggest, this default type of menu does not change in
any way, and may be manually edited and/or (re)generated automatically
through the use on an appropriate software package.

Fast and efficient, while this type of menu can be used to select
applications, it can also be useful to access specific functions and/or
perform specific tasks (e.g. desktop configuration), leaving the access
of applications to another process (e.g. the synapse or xfce4-appfinder
applications).

The ~/.config/openbox/menu.xml file will be the sole source of static
desktop menu content.

menumaker

Warning:A root terminal must be installed in order to use MenuMaker,
even though a standard user terminal may be used to run it. xterm is a
good choice.

menumaker automatically generates xml menus for several window managers,
including Openbox, Fluxbox, IceWM and XFCE. It will search for all
installed executable programs and consequently create a menu file for
them. It is also possible to configure MenuMaker to exclude certain
application types (e.g. relating to Gnome or KDE), if desired.

Once installed and executed, it will automatically generate a new
~/.config/openbox/menu.xml file. To avoid overwriting an existing file,
enter:

    $ mmaker -v OpenBox3

Otherwise, to overwrite an existing file, add the force argument (f):

    $ mmaker -vf OpenBox3

Once a new ~/.config/openbox/menu.xml file has been generated it may
then be manually edited, or configured using a GUI menu editor, such as
obmenu.

obmenu

Warning:obm-xdg - a pipe menu to generate a list of GTK+ and Gnome
applications - is also provided with obmenu. However, it has
long-running bugs whereby it may produce an invalid output, or even not
function at all. Consequently it has been omitted from discussion.

obmenu is a "user-friendly" GUI application to edit
~/.config/openbox/menu.xml, without the need to code in xml.

xdg-menu

archlinux-xdg-menu will automatically generate a menu based on xdg files
contained within the /etc/xdg/ directory for numerous Window Managers,
including Openbox. Review the Xdg-menu#OpenBox article for further
information.

logout menu options

Tip:The commands provided can also be attached to keybinds.

The ~/.config/openbox/menu.xml file can be edited in order to provide a
sub-menu with the same options as provided by oblogout. The sample
script below will provide all of these options, with the exception of
the ability to lock the screen:

    <menu id="exit-menu" label="Exit">
    	<item label="Log Out">
    		<action name="Execute">
    			<command>openbox --exit</command>
    		</action>
    	</item>
    	<item label="Shutdown">
    		<action name="Execute">
    			<command>systemctl poweroff</command>
    		</action>
    	</item>
    	<item label="Restart">
    		<action name="Execute">
    		        <command>systemctl reboot</command>
    		</action>
    	</item>
    	<item label="Suspend">
    		<action name="Execute">
    		        <command>systemctl suspend</command>
    		</action>
    	</item>
    	<item label="Hibernate">
    		<action name="Execute">
    		        <command>systemctl hibernate</command>
    		</action>
    	</item>
    </menu>

Once the entries have been composed, add the following line to present
the sub-menu where desired within the main desktop menu (usually as the
last entry):

    <menu id="exit-menu"/>

> Pipes

Tip:It is entirely feasible for a static menu to contain one or more
pipe sub-menus. The functionality of some pipe menus may also rely on
the installation of relevant software packages.

This type of menu is in essence a script that provides dynamic,
refreshed lists on-the-fly as and when run. These lists may be used for
multiple purposes, including to list applications, to provide
information, and to provide control functions. Pre-configured pipe menus
can be installed, although not from the official repositories. More
experienced users can also modify and/or create their own custom
scripts. Again, ~/.config/openbox/menu.xml may and commonly will contain
several pipe menus.

Examples

-   openbox-xdgmenu: fast xdg-menu converter to xml-pipe-menu
-   obfilebrowser: Application and file browser
-   obdevicemenu: Management of removable media with Udisks
-   wifi pipe menu: Wireless networking using Netctl

Openbox.org also provides a further list of pipe menus.

> Generators

This type of menu is akin to those provided by the taskbars of desktop
environments such as XFCE or LXDE. Automatically updating on-the-fly,
this type of menu can be powerful and very convenient. It may also be
possible to add custom categories and menu entries; read the
documentation for your intended dynamic menu to determine if and how
this can be done.

A menu generator will have to be executed from the
~/.config/openbox/menu.xml file.

obmenu-generator

Tip:icons can still be disabled in obmenu-generator, even where enabled
in ~/.config/openbox/rc.xml.

obmenu-generator is currently only available from the AUR, although it
is still highly recommended. With the ability to be used as a static or
dynamic menu, it is highly configurable, powerful, and versatile. Menu
categories and individual entries may also be easily hidden, customised,
and/or added with ease. The official homepage provides further
information and screenshots.

Below is an example of how obmenu-generator would be dynamically
executed without icons in ~/.config/openbox/menu.xml:

    <?xml version="1.0" encoding="utf-8"?>
    <openbox_menu>
        <menu id="root-menu" label="OpenBox 3" execute="/usr/bin/obmenu-generator">
        </menu>
    </openbox_menu>

To automatically iconify entries, the -i option would be added:

    <menu id="root-menu" label="OpenBox 3" execute="/usr/bin/obmenu-generator -i">

openbox-menu

Tip:If this menu produces an error, it may be solved by enabling icons
in ~/.config/openbox/rc.xml.

openbox-menu uses the LXDE menu-cache to create dynamic menus. The
official homepage provides further information and screenshots.

obmenugen

Obmenugen is currently only available from the AUR, and can be used to a
generate static or dynamic application menu based on .desktop files. The
official homepage provides further information.

> Menu icons

To show icons next to menu entries, it will be necessary to ensure they
are enabled in the <menu> section of the ~/.config/openbox/rc.xml file:

    <applicationIcons>yes</applicationIcons>

Where using a static menu, it will then be necessary to edit the
~/.config/openbox/menu.xml file to provide both the icon = command,
along with the full path and icon name for each entry. An example of the
syntax used to provide an icon for a category is:

    <menu id="apps-menu" label="[label name]" icon="[pathway to icon]/[icon name]">

> Desktop menu as a panel menu

Tip:XDoTool can simulate any keybind for any action, and as such, it may
therefore be used for many other purposes...

xdotool is a package that can issue commands to simulate key presses /
keybinds, meaning that it is possible to use it to invoke
keybind-related actions without having to actually press their assigned
keys. As this includes the ability to invoke an assigned keybind for the
Openbox desktop menu, it is therefore possible to use XDoTool to turn
the Openbox desktop menu into a panel menu. Especially where the desktop
menu is heavily customised and feature-rich, this may prove very useful
to:

-   Replace an existing panel menu
-   Implement a panel menu where otherwise not provided or possible
    (e.g. for tint2-svn)
-   Compensate where losing access to the desktop menu due to the use of
    an application like xfdesktop to manage the desktop.

Once XDoTool has been installed - if not already present - it will be
necessary to create a keybind to access the root menu in
~/.config/openbox/rc.xml, and again below the
<!-- Keybindings for running aplications --> heading. For example, the
following code will bring up the menu by pressing CTRL + m:

    <keybind key="C-m">
        <action name="ShowMenu">
           <menu>root-menu</menu>
        </action>
    </keybind>

Openbox must then be re-configured. In this instance, XDoTool will be
used to simulate the CTRL + m keypress to access the desktop menu with
the following command (note the use of + in place of -):

    xdotool key control+m

How this command may be used as a panel launcher / icon is largely
dependent on the features of panel used. While some panels will allow
the above command to be executed directly in the process of creating a
new launcher, others may require the use of an executable script. As an
example, a custom executable script called obpanelmenu.sh will be
created in the ~/.config folder:

    $ text editor ~/.config/obpanelmenu.sh

Once the empty file has been opened, the appropriate XDoTool command
must be added to the empty file (i.e. to simulate the CTRL + m keypress
for this example):

    xdotool key control+m

After the file has been saved and closed, it may then be made into an
executable script with the following command:

    $ chmod +x ~/.config/obpanelmenu.sh

Executing it will bring up the Openbox desktop menu. Consequently, where
using a panel that supports drag-and-drop functionality to add new
launchers, simply drag the executable script onto it before changing the
icon to suit personal taste. For instructions on how to use this
executable script with tint2-svn - a derivative of the popular tint2
panel that allows launchers to be added - see Tint2-Svn launchers.

GTK+ desktop theming
--------------------

Tip:It is strongly advised to install the obconf and lxappearance-obconf
GUI applications to configure visual settings and theming. The latter is
particularly important as it is responsible for generating the
~/.gtkrc-2.0 file (see the GTK fix section).

It is important to note that a substantial range of both
Openbox-specific and generalised, Openbox-compatible GTK themes are
available to change the look of window decorations and the desktop menu.
Generalised themes are designed to be simultaneously compatible with a
range of popular desktop environments and/or window managers, commonly
including Openbox. For example, gtk-theme-numix-blue supports both
Openbox and XFCE.

> Configuration

obconf and/or lxappearance-obconf should be used to select and configure
available GTK themes. See Uniform Look for Qt and GTK Applications for
information about theming Qt based applications like Virtualbox or
Skype.

> Installation: official and AUR

A good selection of openbox-themes are available from the official
repositories.

Both Openbox-specific and Openbox-compatible themes installed from the
official repositories and/or the AUR will be automatically installed to
the /usr/share/themes directory. Both will also be immediately available
for selection.

> Installation: other sources

box-look.org is an excellent and well-established source of themes.
deviantART.com is another excellent resource. Many more can be found
through the utilisation of a search engine.

Zip and tar files

Themes downloaded from other sources such as box-look.org will usually
be compressed in a .tar.gz or .zip format. Although tar will have been
installed as part of the base arch installation to extract .tar.gz
files, it will be necessary to install a program such as unzip to
extract .zip files in the terminal. user-friendly GUI archivers are also
available; see List_of_Applications#Compression_tools for further
information.

Extracted theme files should also be placed in the /usr/share/themes
directory. For example, assuming downloaded content is automatically
stored in the ~/Downloads folder, to simultaneously extract and move a
.tar.gz theme file, the syntax of the command would be:

    # tar xvf ~/Downloads/<theme file name>.tar.gz -C /usr/share/themes/

To use unzip in the same scenario for a .zip theme file, the syntax of
the command would be:

    # unzip ~/Downloads/<theme file name>.zip -d /usr/share/themes/

Alternatively, it is also possible to simply move / copy and paste the
extracted files to the /usr/share/themes directory using an installed
file manager as root.

> Troubleshooting

There are two particular problems that may be encountered on rare
occasions, especially where downloading themes from unsupported
websites. These have been addressed below.

Theme cannot be used

If for any reason the newly extracted theme cannot be selected, open the
theme directory to first ensure that it is indeed compatible with
Openbox by determining that an openbox-3 directory is present, and that
within this directory a themerc file is also present. An .obt (OpenBox
Theme) file may also be present in some instances, which can then be
manually loaded in obconf.

Where expected files and directories are present and correct, then on
occasion it is possible that the theme author has not correctly set
permission to access the file (e.g. permission may still be for the
account of the author, rather than for root). To eliminate this
possibility, ensure the folder and file permissions are for root:

    # chown -R root /user/share/themes

Theme looks broken

Of course, the first line of enquiry would be to check that it is not
just a badly made, broken theme! Otherwise, ensure that the Openbox GTK
fix has been implemented, and then re-start the session. Unfortunately
some older themes can simply break if not maintained sufficiently to
keep pace with the changes incurred by GTK updates. To avoid such
occurrences, it is best to check that desired themes have recently been
created or at least updated / patched.

> Edit or create new themes

Tip:Where deciding to modify an existing theme (e.g. the colour scheme),
it would be best to work on a copy of it, rather than the original. This
will retain the original should anything go wrong, and ensure that your
changes are not over-written through an update.

The process of creating new or modifying existing themes is covered
extensively at the official openbox.org website. A user-friendly GUI to
do so - obtheme - is also available from the AUR.

Compositing effects
-------------------

Openbox does not natively provide support for compositing, and it will
therefore be necessary to install a compositor for this purpose. The use
of compositing enables various desktop visual effects, including
transparency, fading, and shadows. Although compositing is not a
necessary component, it can help to provide a more pleasant-looking
environment, and avoid common issues such as screen distortion when
oblogout is used, and visual glitches when terminal window transparency
has been enabled. Three of the most common choices are:

-   Compton: Powerful and reliable, with extensive options
-   Xcompmgr: Older and simpler version of compton
-   Cairo Compmgr: Advanced compositing effects, plugin support, and a
    user-friendly GUI. Also more buggy and far heavier use of system
    resources.

Mouse cursor and application icon themes
----------------------------------------

Any mouse cursor and/or application icon theme may be used with Openbox.
Numerous themes are available from both the official repositories and
the AUR.

> xcursor themes (mouse)

Tip:Review the Xcursor article for an in-depth explanation.

Standard xcursor theme packages available from the official repositories
include xcursor-themes, xcursor-bluecurve, xcursor-vanilla-dmz, and
xcursor-pinux. To search the official repositories for all available
xcursor themes, enter the following command:

    $ pacman -Ss xcursor

Installed x-cursor themes may then be set though using the obconf and
lxappearance-obconf GUI applications. It may then be necessary to either
log out and back in again to implement the change, or to reconfigure
Openbox.

> Application icon themes

Standard xcursor theme packages available from the official repositories
include the gnome-icon-theme and lxde-icon-theme. A nice icon theme
currently available from the AUR is numix-icon-theme-git. To search the
official repositories for all available icon themes, enter the following
command:

    $ pacman -Ss icon-theme

Again, installed icon themes may then be set though using the obconf and
lxappearance-obconf GUI applications. It may then be necessary to either
log out and back in again to implement the change, or to reconfigure
Openbox.

Desktop icons and wallpapers
----------------------------

Openbox does not natively support the use of desktop icons or
wallpapers. As a consequence, it will be necessary to install additional
applications for this purpose, where desired.

> Desktop management using file managers

Some file managers have the capacity to fully manage the desktop,
meaning that they may be used to provide wallpapers and enable the use
if icons on the desktop. The LXDE desktop environment itself uses
PCManFM for this purpose.

-   PCManFM: See the PCManFM desktop management article.
-   SpaceFM: See the SpaceFM desktop management article.

> Wallpaper / background programs

Tip:The wallpaper programs listed here will have many more options than
shown in this brief overview, including the ability to use solid colours
for backgrounds. Review their documentation and man pages for more
information.

There are numerous packages available to set desktop backgrounds in
Openbox, each of which will need to be autostarted in the
~/.config/openbox/autostart file. A few of the most well known have been
listed.

nitrogen

Tip:If nitrogen does not show in the desktop menu, then it can be
manually added.

nitrogen is a user-friendly choice, as it also provides a GUI window to
browse and set installed images. To access the GUI, enter the following
command in a terminal:

    $ nitrogen

To use nitrogen as the background provider, add the following command to
the ~/.config/openbox/autostart file so that it will restore the last
set wallpaper:

    nitrogen --restore &

feh

Feh is a popular image viewer that may also be used to set wallpapers.
In this instance, it will be necessary to add the full directory path
and name of the image to be used as the wallpaper. To use Feh as the
background provider, add the following command to the
~/.config/openbox/autostart file:

    feh --bg-scale /path/to/image.file &

hestroot

hsetroot is a command-line tool specifically designed to set wallpapers.
As with Feh, it will be necessary to add the full directory path and
name of the image to be used as the wallpaper. To use HSetRoot as the
background provider, add the following command to the
~/.config/openbox/autostart file:

    hsertroot -fill /path/to/image.file &

xsetroot

xsetroot is installed as part of the Xorg X-Windows system, and may be
used to set simple background colours. For example, to use XSetRoot to
set a black background, the following would be added to the
~/.config/openbox/autostart file:

    xsetroot -solid "#000000" &

> Icon programs

While there are programs dedicated to enabling desktop icons alone, it
would seem that they have greater drawbacks than the utilisation of file
managers for the task. These programs are discussed briefly, below.

idesk

idesk is a simple program that can enable icons in addition to managing
wallpaper. It will be necessary to create an ~/.idesktop directory, and
desktop icons must also be manually created. To use idesk to provide
icons, add the following command to the ~/.config/openbox/autostart
file:

    idesk &

xfdesktop

xfdesktop is the desktop manager for XFCE. The Thunar file manager will
also be downloaded as a dependency. Where this is used, the Openbox
desktop menu will no longer be accessible by right-clicking the
background.

As such, it will consequently be necessary to access it by other means,
such as by creating a keybind, and/or by - where permitted -
re-configuring an installed panel to use the desktop menu as a panel
menu. To use xfdesktop to provide icons, add the following command to
the ~/.config/openbox/autostart file:

    xfdesktop &

> conky reconfiguration

Particularly where using a file manager to manage the desktop, it will
be necessary to edit ~/.conkyrc to change the own_window_type command in
order for conky to continue to be displayed (where used). The revised
command that should be used is:

    own_window_type normal

File managers
-------------

Multiple file managers may be used with Openbox, including PCManFM,
SpaceFM, Thunar, xfe, and qtfm. Thunar is the native file manager for
Xfce, and if installing be aware that some Xfce-related dependencies
will also be installed, including exo (set default applications) and
xfce4-about (provide information about the Xfce deskop environment). The
menu entries for these may consequently have to be hidden.

A file manager alone will not provide the same features and
functionality as provided by default in full desktop environments like
Xfce and KDE. For example, it may not be initially possible to view or
access other partitions or access removable media. See File manager
functionality for further information.

oblogout
--------

See the Oblogout article for an overview on how to use this useful,
graphical logout script.

Openbox for multihead users
---------------------------

While Openbox provides better than average multihead support on its own,
the openbox-multihead-git package from the AUR provides a development
branch called Openbox Multihead that gives multihead users per-monitor
desktops. This model is not commonly found in floating window managers,
but exists mainly in tiling window managers. It is explained well on the
Xmonad web site. Also, please see README.MULTIHEAD for a more
comprehensive description of the new features and configuration options
found in Openbox Multihead.

Openbox Multihead will function like normal Openbox when only a single
head is available.

A downside to using Openbox Multihead is that it breaks the EWMH
assumption that one and only one desktop is visible at any time. Thus,
existing pagers will not work well with it. To remedy this,
pager-multihead-git can be found in the AUR and is compatible with
Openbox Multihead. Screenshots.

Finally, a new version of PyTyle that will work with Openbox Multihead
can also be found in the AUR: pytyle3-git.

Both pytyle3 and pager-multihead-git will work without Openbox Multihead
if only one monitor is active.

Tips and tricks
---------------

> Packages for beginners

Tip:See the List of Applications article for many more possibilities.

The packages listed below have been listed to aid newer users:

-   Display Manager: LXDM or LightDM
-   Audio: ALSA
-   Volume: volumeicon or pnmixer with gnome-alsamixer
-   Network: Network manager with network-manager-applet
-   Panel: Tint2 or Tint2-svn
-   Background: Nitrogen or Feh
-   Menu: OBMenu-Generator
-   Compositor: Compton
-   Desktp Notifications: xfce4-notifyd
-   Logout script: Oblogout
-   File Manager: PCManFM, SpaceFM, or Thunar
-   Clipboard Manager: parcellite
-   Configuration GUIs: obconf, lxappearance-obconf, lxrandr, lxinput,
    tintwizard or tintwizard-svn

> Set default applications / file associations

See the Default applications article.

> Terminal content copy and paste

Within a terminal, either:

-   Ctrl+Ins will copy and Shift+Ins will paste.
-   Ctrl+Shift+c will copy and mouse middle-click will paste.

> Ad-hoc window transparency

Warning:This may not work where other actions are defined within the
action group.

The program transset-df is available in the official repositories, and
can enable window transparency on-the-fly.

For example, using the following code in the <mouse> section of the
~/.config/openbox/rc.xml file will enable control of application window
transparency by hovering the mouse-pointer over the title bar and
scrolling with the middle button:

    <context name="Titlebar">
        ...
        <mousebind button="Up" action="Click">
            <action name= "Execute" >
            <execute>transset-df -p .2 --inc  </execute>
            </action>
        </mousebind>
        <mousebind button="Down" action="Click">
            <action name= "Execute" >
            <execute>transset-df -p .2 --dec </execute>
            </action>
        </mousebind>
        ...
    </context>

> Using obxprop for faster configuration

openbox package provides a obxprop binary that can parse relevant values
for applications settings in rc.xml. Officially
obxprop | grep "^_OB_APP" is recommended for this task. Doing so for
multiple applications and its windows can be very inefficient however.
The following script obxprop2obrc makes it much easier to configure even
a large number of applications.

    #!/bin/bash
    ##Script: obxprop-to-openbox-rc.sh
    ##Recommended executable name: obxprop2obrc

    while [ $# -ne 0 ]; do
    case $1 in
        -f*)
            shift;
            FILE="$1";
    	shift;
        ;;
        -t*)
            shift;
            TIME="$1";
    	shift;
        ;;
        *)
            echo Usage: $0 [-f FILE_TEMPLATE] [-t WAIT_TO_KILL_TIME] 
            exit 1;
        ;;
    esac
    done

    if [ $TIME ]; then
        OBXPROPS=( $(obxprop | cat & (sleep $TIME && pkill -13 cat) | awk -F \" '/_OB_APP/{ print "\x22"$2"\x22" }' ) );
    else
        OBXPROPS=( $(obxprop | awk -F \" '/_OB_APP/{ print "\x22"$2"\x22" }' ) );
    fi
    OBPROPS=(TYPE TITLE GROUP_CLASS GROUP_NAME CLASS NAME ROLE);
    j=0;
    for i in $( seq 2 2 14 ); do
        OBPROP="$( echo ${OBXPROPS[@]} | awk -F \" '{ print $'$i'}' )";
        if [[ -z $OBPROP ]]; then 
            declare ${OBPROPS[$j]}='"*"';
        else 
            declare ${OBPROPS[$j]}="\"$OBPROP\"";
        fi
        j=$(($j+1));
    done;

    echo "    <application type="$TYPE" title="$TITLE" class="$CLASS" name="$NAME" role="$ROLE">"
    if [ -f "$FILE"  ]; then cat "$FILE" && exit; fi
    cat << EOF
          <desktop>1</desktop>
          <desktop>all</desktop>
          <decor>yes</decor>
          <decor>no</decor>
          <focus>yes</focus>
          <focus>no</focus>
          <fullscreen>yes</fullscreen>
          <fullscreen>no</fullscreen>
          <iconic>yes</iconic>
          <iconic>no</iconic>
          <maximized>yes</maximized>
          <maximized>no</maximized>
          <maximized>both</maximized>
          <maximized>horizontal</maximized>
          <maximized>vertical</maximized>
          <monitor>0</monitor>
          <monitor>1</monitor>
          <position force="no">
          <position force="yes">
            <width>40%</width>
            <height>30%</height>
            <x>-1</x>
            <y>-1</y>
            <x>center</x>
            <y>center</y>
          </position>
          <layer>above</layer>
          <layer>normal</layer>
          <layer>below</layer>
          <shade>yes</shade>
          <shade>no</shade>
          <skip_pager>yes</skip_pager>
          <skip_pager>no</skip_pager>
          <skip_taskbar>yes</skip_taskbar>
          <skip_taskbar>no</skip_taskbar>
        </application>
    EOF

If no further options are used default configuration, that can be edited
by deleting unnecessary lines, is printed out. This script can use
templates with default values when using -f switch:

    $ obxprop2obrc -f templates-rc-inkscape-dialogs.sc > part-rc-applications-inkscape.xml
    $ cat part-rc-applications-inkscape.xml

    <application type="normal" title="Align and Distribute (Shift+Ctrl+A)" class="Inkscape" name="inkscape" role="*">
      <desktop>3</desktop>
      <decor>yes</decor>
      <maximized>no</maximized>
      <position force="yes">
        <width>20%</width>
        <height>30%</height>
        <x>-1</x>
        <y>-1</y>
      </position>
      <layer>normal</layer>
      <shade>yes</shade>
    </application>

It also has a time switch -t which kills obxprop and thus can reduce
time significantly in certain situations, although it may not work
perfectly.

> Xprop values for applications

xorg-xprop is available in the official repositories, and can be used to
relay property values for selected applications. Where frequently using
per-application settings, the following Bash Alias may be useful: dy:

    alias xp='xprop | grep "WM_WINDOW_ROLE\|WM_CLASS" && echo "WM_CLASS(STRING) = \"NAME\", \"CLASS\""'

To use Xorg-XProp, run using the alias given xp, and click on the active
program desired to define with per-application settins. The results
displayed will only be the information that Openbox itself requires,
namely the WM_WINDOW_ROLE and WM_CLASS (name and class) values:

    WM_WINDOW_ROLE(STRING) = "roster"
    WM_CLASS(STRING) = "gajim.py", "Gajim.py"
    WM_CLASS(STRING) = "NAME", "CLASS"

Firefox

For whatever reason, Firefox and like-minded equivalents ignore
application rules (e.g. <desktop>) unless class="Firefox*" is used. This
applies irrespective of whatever values xprop may report for the
program's WM_CLASS.

> Switching between keyboard layouts

See the article section switching between keyboard layouts for
instructions.

Troubleshooting
---------------

> Windows load behind the active window

Some application windows (such as Firefox windows) may load behind the
currently active window, causing you to need to switch to the window you
just created to focus it. To fix this behavior add this to your
~/.config/openbox/rc.xml file, inbetween the <openbox_config> and
</openbox_config> tags:

    <applications>
      <application class="*">
        <focus>yes</focus>
      </application>
    </applications>

See also
--------

-   Openbox Website - Official website
-   Planet Openbox - Openbox news portal
-   Box-Look.org - A good resource for themes and related artwork
-   Openbox Hacks and Configs Thread @ Arch Linux Forums
-   Openbox Screenshots Thread @ Arch Linux Forums
-   An Openbox guide

Retrieved from
"https://wiki.archlinux.org/index.php?title=Openbox&oldid=305583"

Category:

-   Stacking WMs

-   This page was last modified on 19 March 2014, at 11:56.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
