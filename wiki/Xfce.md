Xfce
====

Related articles

-   Desktop environment
-   Window manager
-   Xfwm
-   Thunar
-   LXDE
-   GNOME

From Xfce - About:

Xfce embodies the traditional UNIX philosophy of modularity and
re-usability. It consists of a number of components that provide the
full functionality one can expect of a modern desktop environment. They
are packaged separately and you can pick among the available packages to
create the optimal personal working environment.

Xfce is a lightweight and modular Desktop environment currently based
upon GTK+ 2 though in the future it may be ported to GTK+ 3. Xfce
contains a suite of applications such as a window manager, a file
manager, and a panel to provide a complete user experience. Xfce is
popular with many users, partly because it is lightweight but also
because a large amount of settings are exposed in a GUI. This is in
sharp contrast to desktops such as GNOME Shell which hide many settings
from the user.

Contents
--------

-   1 Installation
-   2 Starting Xfce
    -   2.1 Graphical login
    -   2.2 Virtual console
-   3 Configuration
    -   3.1 Xfconf settings
        -   3.1.1 Graphical Settings Manager Commands
    -   3.2 Menu
        -   3.2.1 Menu applet replacement
        -   3.2.2 Removing entries from the System menu
            -   3.2.2.1 Method 1
            -   3.2.2.2 Method 2
            -   3.2.2.3 Method 3
            -   3.2.2.4 Method 4
            -   3.2.2.5 Method 5
        -   3.2.3 Missing applications
    -   3.3 Desktop
        -   3.3.1 Transparent Background for Icon Titles
        -   3.3.2 Hide Selected Partitions
        -   3.3.3 Remove Thunar Options from Right-click
        -   3.3.4 Kill Window Shortcut
        -   3.3.5 Manage Keyboard Shortcuts
    -   3.4 Window Manager
        -   3.4.1 Enabling the Compositor
        -   3.4.2 Window roll-up
        -   3.4.3 Toggle Automatic Tiling of Windows at Edge of Screen
        -   3.4.4 Replacing the native window manager
            -   3.4.4.1 Re-enabling Compositing effects
    -   3.5 Session
        -   3.5.1 Custom Startup Applications
            -   3.5.1.1 Via the Settings Menu
            -   3.5.1.2 Startup Script
        -   3.5.2 Lock the screen
        -   3.5.3 User switching
        -   3.5.4 Manually Modifying XML settings
    -   3.6 Look and Feel
        -   3.6.1 Add themes to XFCE
        -   3.6.2 Application theme consistency
        -   3.6.3 Cursors
        -   3.6.4 Icons
        -   3.6.5 Fonts
    -   3.7 Sound
        -   3.7.1 Configuring xfce4-mixer
        -   3.7.2 Xfce4-mixer and OSS4
        -   3.7.3 Keyboard Volume Buttons
            -   3.7.3.1 ALSA
            -   3.7.3.2 OSS
            -   3.7.3.3 PulseAudio
            -   3.7.3.4 Xfce4-volumed
            -   3.7.3.5 Volumeicon
            -   3.7.3.6 Extra keyboard keys
        -   3.7.4 Adding startup/boot sound
-   4 Tips & Tricks
    -   4.1 xdg-open integration (Preferred Applications)
    -   4.2 Screenshots
        -   4.2.1 Print Screen key
    -   4.3 Disable Terminal F1 and F11 shortcut
    -   4.4 Terminal color themes or pallets
        -   4.4.1 Changing default color theme
        -   4.4.2 Terminal tango color theme
    -   4.5 Colour management
        -   4.5.1 Loading a profile
        -   4.5.2 Creating a profile
    -   4.6 Multiple Monitors
    -   4.7 XDG User Directories
    -   4.8 SSH Agents
    -   4.9 Bluetooth functionality
    -   4.10 Scroll a background window without shifting focus on it
-   5 Troubleshooting
    -   5.1 Getting "Not Authorized" when attempting to mount drives
        with a file manager
    -   5.2 xfce4-power-manager
    -   5.3 xfce4 keeps blanking display
    -   5.4 xfce4-xkb-plugin
    -   5.5 Locales ignored with GDM
    -   5.6 Restore default settings
    -   5.7 Xfce desktop icons rearrange themselves
    -   5.8 NVIDIA and xfce4-sensors-plugin
    -   5.9 Session failure
    -   5.10 Preferred Applications preferences have no effect
    -   5.11 Action Buttons/Missing Icons
    -   5.12 Enable cedilla ç/Ç instead of ć/Ć
    -   5.13 Non ASCII characters when mounting USB sticks
    -   5.14 Video tearing when Xfwm compositing is enabled
    -   5.15 Blurred and distorted characters when compositing is
        enabled (Intel graphics)
    -   5.16 GTK themes not working with multiple monitors
-   6 See also

Installation
------------

Xfce can be installed from the xfce4 group which is available in the
official repositories. It is recommended that you install the
xfce4-goodies group as well which includes extra plugins and a number of
useful utilities such as the mousepad editor.

Starting Xfce
-------------

> Graphical login

Simply choose Xfce Session from the menu in your favourite display
manager.

> Virtual console

There are two methods to start Xfce manually:

-   Run startxfce4 directly from the console.
-   Configure ~/.xinitrc to exec startxfce4 and then run xinit or startx
    from the console. See xinitrc for details.

Note:The proper command for launching Xfce is startxfce4, do not start
xfce4-session directly.

Tip:You can have Xfce started automatically at login by following Start
X at Login.

Configuration
-------------

> Xfconf settings

Xfconf is XFCE's system for storing configuration options, and most XFCE
configuration is done by editing settings in Xfconf (one way or
another). There are several ways to modify these settings:

-   The most obvious and easiest way is to go to "Settings" in the main
    menu and select the category you want to customize. However, not all
    customization options are available this way.
-   A less user-friendly but more general way is to go to

        Main menu -> Settings -> Settings Editor

    where you can see and modify all the customization options. Any
    settings modified here will take effect immediately. The Settings
    Editor can also be launched from the command line by invoking
    xfce4-settings-editor.

-   Customization can be done completely from the command line using the
    program xfconf-query. See the XFCE online documentation for more
    information and examples and the rest of this wiki page for more
    examples. Settings changed here will take effect immediately.
-   The settings are stored in XML files in
    ~/.config/xfce4/xfconf/xfce-perchannel-xml/ which can be edited by
    hand. However, changes made here will not take effect immediately.
-   For more information: Xfconf documentation

Graphical Settings Manager Commands

There is no official documentation for the commands executed. One must
look at .desktop files /usr/share/applications/ folder. For the people
who like to know exactly what is happening, here is a handy list to save
the effort:

    xfce4-accessibility-settings
    xfce4-power-manager-settings
    xfce4-settings-editor
    xfdesktop-settings
    xfce4-display-settings
    xfce4-keyboard-settings
    xfce4-mouse-settings
    xfce4-session-settings
    xfce4-settings-manager
    xfce4-appearance-settings
    xfwm4-settings
    xfwm4-tweaks-settings
    xfwm4-workspace-settings
    orage -p

To review all the available setting manager commands run the following
in a terminal:

    $ grep '^Exec=' /usr/share/applications/xfce*settings* | sed -e 's_^.*=_ _'

> Menu

Menu applet replacement

Whisker Menu is a full-featured replacement for the default Xfce menu
applet. Add it to your panel and optionally remove the built-in default
menu.

It is available in the AUR as the xfce4-whiskermenu-plugin package.

Removing entries from the System menu

Method 1

With the built-in menu editor, you cannot remove menu entries from the
System menu. Here’s how to hide them:

1.  Open Terminal (Xfce menu > System > Terminal) and go to the
    /usr/share/applications folder:

        $ cd /usr/share/applications

2.  This folder should be full of .desktop files. To see a list type:

        $ ls

3.  Add NoDisplay=true to the .desktop file. For example, if you want to
    hide Firefox, type in the terminal:

        # echo "NoDisplay=true" >> firefox.desktop

    This command appends the text NoDisplay=true to the end of the
    .desktop file.

Method 2

Another method is to copy the entire contents of the global applications
directory over to your local applications directory, and then proceed to
modify and/or disable unwanted .desktop entries. This will survive
application updates that overwrite changes under
/usr/share/applications/.

1.  In a terminal, copy everything from /usr/share/applications to
    ~/.local/share/applications/:

        $ cp /usr/share/applications/* ~/.local/share/applications/

2.  For any entry you wish to hide from the menu, add the NoDisplay=true
    option:

        $ echo "NoDisplay=true" >> ~/.local/share/applications/foo.desktop

You can also edit the application's category by editing the .desktop
file with a text editor and modifying the Categories= line.

Method 3

The third method is the cleanest and recommended in the Xfce wiki.

Create the file ~/.config/menus/xfce-applications.menu and copy the
following in it:

    <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
      "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">

    <Menu>
        <Name>Xfce</Name>
        <MergeFile type="parent">/etc/xdg/menus/xfce-applications.menu</MergeFile>

        <Exclude>
            <Filename>xfce4-run.desktop</Filename>

            <Filename>exo-terminal-emulator.desktop</Filename>
            <Filename>exo-file-manager.desktop</Filename>
            <Filename>exo-mail-reader.desktop</Filename>
            <Filename>exo-web-browser.desktop</Filename>

            <Filename>xfce4-about.desktop</Filename>
            <Filename>xfhelp4.desktop</Filename>
        </Exclude>

        <Layout>
            <Merge type="all"/>
            <Separator/>

            <Menuname>Settings</Menuname>
            <Separator/>

            <Filename>xfce4-session-logout.desktop</Filename>
        </Layout>

    </Menu>

The <MergeFile> tag includes the default Xfce menu in our file. This is
important.

The <Exclude> tag excludes applications which we do not want to appear
in the menu. Here we excluded some Xfce default shortcuts, but you can
exclude firefox.desktop or any other application.

The <Layout> tag defines the layout of the menu. The applications can be
organized in folders or however we wish. For more details see the
aforementioned Xfce wiki page.

Method 4

Alternatively a tool called xame can be used. XAME is a GUI tool written
in Gambas designed specifically for editing menu entires in Xfce, it
will NOT work in other DEs. XAME is available in the xame package from
the AUR. An alternative to XAME that works quite well with Xfce is
menulibre.

Method 5

The GNOME menu editor alacarte mostly works with Xfce. Entries and
submenus can be customised. The only problem with Alacarte is that menu
items created from .desktop files which contain the line
OnlyShowIn=Xfce; will not show up in the Alacarte editor. Also, menu
items created from .desktop files which contain the line
OnlyShowIn=GNOME; will not show in the Xfce menu even if it is selected
as visible in Alacarte. There are two patched versions of Alacarte in
the AUR: alacarte-xfce and alacarte-lxde. The latter package, despite
its name, is not for LXDE only - it should work in most desktop
environments.

Missing applications

When some applications are installed (for example via WINE), they may
not be listed in /usr/share/applications. Shortcuts might be found in
the category “Other” in this directory:
~/.local/share/applications/wine/.

> Desktop

Transparent Background for Icon Titles

To change the default white background of desktop icon titles to
something more suitable, create or edit the GTK config file:

    ~/.gtkrc-2.0

    style "xfdesktop-icon-view" {
        XfdesktopIconView::label-alpha = 10
        base[NORMAL] = "#000000"
        base[SELECTED] = "#71B9FF"
        base[ACTIVE] = "#71B9FF"
        fg[NORMAL] = "#fcfcfc"
        fg[SELECTED] = "#ffffff"
        fg[ACTIVE] = "#ffffff"
    }
    widget_class "*XfdesktopIconView*" style "xfdesktop-icon-view"

Hide Selected Partitions

If you wish to prevent certain partitions or drives appearing on the
desktop, you can create a udev rule, for example
/etc/udev/rules.d/10-local.rules:

    KERNEL=="sda1", ENV{UDISKS_PRESENTATION_HIDE}="1"
    KERNEL=="sda2", ENV{UDISKS_PRESENTATION_HIDE}="1"

Would show all partitions with the exception of sda1 and sda2 on your
desktop. Notice, if you are using udisk2 the above will not work, due to
the UDISKS_PRESENTATION_HIDE no longer being supported, instead you must
use UDISKS_IGNORE as follows

    KERNEL=="sda1", ENV{UDISKS_IGNORE}="1"
    KERNEL=="sda2", ENV{UDISKS_IGNORE}="1"

Remove Thunar Options from Right-click

    xfconf-query -c xfce4-desktop -v --create -p /desktop-icons/style -t int -s 0

Kill Window Shortcut

Xfce does not support the kill window shortcut directly, but you can add
one with a simple script. Ensure you have the xorg-xkill package
installed.

Create a script in ~/.config/xfce4/killwindow.sh with this content and
make it executable (you can use chmod 755 killwindow.sh).

    xkill -id "`xprop -root -notype | sed -n '/^_NET_ACTIVE_WINDOW/ s/^.*# *\|\,.*$//g p'`"

Now associate a shortcut using Settings -> Keyboard to that script.

Manage Keyboard Shortcuts

Keyboard shortcuts can be managed with the Xfce Settings Manager
application, which is available through the xfce4-settings package and
the xfce4 group. The Settings Manager can be started from the
application menu (click Settings -> Keyboard) or command line (run
xfce4-keyboard-settings). The Xfce Docs include detailed instructions
for using the Settings Manager.

> Window Manager

The default window manager for Xfce is Xfwm.

Enabling the Compositor

Xfwm has a builtin compositor adding the option for fancy window
effects, shadows and transparency and so on. It can be enabled in the
Window Manager Tweaks and works on the fly. No additional settings are
needed in your /etc/xorg.conf. To enable and adjust settings, go to:

    Menu  -->  Settings  -->  Window Manager Tweaks

Tip:The built-in compositor for Xfwm (the Xfce window manager) often
causes video tearing in applications. If you wish for a lightweight
compositor with some minimal effects, consider using Compton.

Window roll-up

Double clicking on the titlebar or clicking on the window menu and
choosing 'role window up' will cause the window's contents to disappear
leaving only the titlebar. If you would like to disable this
functionality you can do so graphically using the xconf editor or
through the command line, as shown below, which achieves the same
result.

xfconf-query -c xfwm4 -p /general/mousewheel_rollup -s false

Toggle Automatic Tiling of Windows at Edge of Screen

XFWM4 has the ability to "tile" a window automatically when it is moved
to the edge of the screen by resizing it to fill the top half of the
screen. (The official XFCE website says this feature is disabled by
default in XFCE 4.10, but it seems to be enabled by default on Arch
Linux.) This behavior can be enabled or disabled in
Window Manager Tweaks --> Accessibility --> Automatically tile windows when moving toward the screen edge,
or:

    xfconf-query -c xfwm4 -p /general/tile_on_move -s false  # To disable
    xfconf-query -c xfwm4 -p /general/tile_on_move -s true   # To enable

Replacing the native window manager

To replace xfwm4 with another Window manager you can use the syntax
'name of window manager' '--replace' in a terminal.

For example:

-   For Openbox the command is: openbox --replace
-   For Metacity the command is: metacity --replace

To restore the native window manager again , first cancel the command by
pressing CTRL and c, and then enter the following command:

    $ xfwm4 --replace

Once the other window manager has taken over you can simply save the
session. The Save session for future logins option is available in the
logout... dialog box. It is also important to note that where restoring
xfwm4 during a session, the Save session for future logins option will
have to be enabled on that occasion to make this change permanent. Not
doing so may result in Openbox being restored again, as the previous
saved session may be loaded instead. However, once xfwm4 has been
restored, from the next session onwards there will no longer be any need
to save future sessions.

As an alternative you can add the window manager to the autostart list
in Xfce. To do this, from the main menu, first select Settings Manager,
and then session and startup. Once the application window opens, select
the Application Autostart tab to show all autostarted applications and
programs, and click the Add button to bring up the Add Application
window.

The following details can be entered for each field:

-   Name: openbox-wm
-   Description: openbox-wm
-   Command: openbox --replace

> Tip:

-   The name and description fields are unimportant and are just there
    to indicate what the entry does. The command section has the same
    syntax as earlier e.g. 'Name of window manager' '--replace' as shown
    in the entries above.
-   Compiz may require commands different from the ones shown as there
    are several different ways to start it. For more information please
    see the Xfce section in the Compiz article.

Once complete, click OK, ensure that the checkbox next to the openbox-wm
entry is ticked, and then restart the session for the change to take
place. The benefit of this method is that autostarted applications can
be easily enabled and disabled at will via their autostart checkboxes.
Consequently, to allow the native window manager - xfwm4 - to take back
over, just clear the openbox-wm tickbox and restart the session.

Re-enabling Compositing effects

If you replace Xfwm with a window manager that does not have a composite
manager then you can use a standalone composite manager such as Xcompmgr
or Compton.

> Session

Custom Startup Applications

Via the Settings Menu

To launch custom applications when Xfce starts up, click the
Applications Menu -> Settings -> Settings Manager and then choose the
"Session and Startup" option and click the tab "Application Autostart".
You will see a list of programs that get launched on startup. To add an
entry, click the "Add" button and fill out the form, specifying the path
to an executable you want to run.

Startup Script

Alternatively you can use this method, to run a command line script to
launch your applications. This includes getting necessary environment
variables into the GUI runtime.

-   Copy the file /etc/xdg/xfce4/xinitrc to ~/.config/xfce4/
-   Edit this file. For example, you can add something like this
    somewhere in the middle:

    source $HOME/.bashrc
    # start rxvt-unicode server
    urxvtd -q -o -f

Lock the screen

To lock an Xfce4 session (through xflock4) one of xscreensaver,
gnome-screensaver, slock or xlockmore packages needs to be installed.
Xscreensaver is the recommended option. Please consult its wiki page for
more information.

User switching

Xfce4 has support for user switching when used with a Display manager
that has this functionality - examples being lightdm and gdm. Please
consult your display manager's wiki page for more information. When you
have a display manager installed and configured correctly you can switch
users from the 'action buttons' menu item in the panel.

Manually Modifying XML settings

It may be useful, especially when upgrading, to manually edit .xml files
in the ~/.config/xfce4/xfconf/ folder. For application keyboard
shortcuts for example, the file is
~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml.

> Look and Feel

Add themes to XFCE

1. Go to www.xfce-look.org and click "Themes" in the left navbar. Look
around for a theme you want and click "Download".

2. Go to the directory where you downloaded the tarball/file and extract
it using an archive manager such as file-roller

3. Move the extracted folder to /usr/share/themes (for all users) or
~/.themes (for just you). Inside /usr/share/themes/abc, there is a
folder that you create called xfwm4 that will contain whatever files
that is included with that theme.

4. Selecting the theme.

-   The GTK+ theme can be changed from:

    Menu --> Settings --> Appearance

-   The xfwm4 theme can be changed from:

    Menu --> Settings --> Window Manager

Application theme consistency

Applications do not always have a consistent look. There are two
possible reasons for this:

1. The application is based upon a toolkit that the current theme does
not support. Applications based upon the GTK+ 2 toolkit will need a GTK+
2 theme whilst applications based upon the GTK+ 3 toolkit will need a
GTK+ 3 theme.

2. The theme is out of date.

To achieve a uniform look for all applications it is advisable to use an
up to date GTK+ 3 theme such as Adwaita as GTK+ 3 themes have inbuilt
support for GKT+ 2 applications. Adwaita can be installed from the
gnome-themes-standard package. Applications based upon the Qt toolkit
can mimic the current GTK+ theme using the qtconfig-qt4 dialogue.

For information please consult these wiki pages: GTK+#GTK+ 3.x for gtk3
and Uniform Look for Qt and GTK Applications for qt.

Cursors

Main article: X11 Cursors

If you have alternative X cursor themes installed, Xfce can find them
with:

    Menu --> Settings --> Mouse --> Theme

Icons

1.  First find and download your desired icon pack. Recommended places
    to download icons from are Customize.org, Opendesktop.org and
    Xfce-look.org; the AUR provides several PKGBUILDs for icon packs.
2.  Go to the directory where you downloaded the icon pack and extract
    it. Example tar -xzf /home/user/downloads/icon-pack.tar.gz.
3.  Move the extracted folder containing the icons to ~/.icons (if only
    you want to use the icons) or to /usr/share/icons (if you want all
    users on the system to make use of the icons), and in the lattter
    case consider creating a PKGBUILD for that.
4.  Optional: run gtk-update-icon-cache -f -t ~/.icons/<theme_name> to
    update icon cache
5.  Switch your icons by going to:

    Menu --> Settings --> Appearance --> Icons

When you have icon theme problems, it is also recommended to install the
hicolor-icon-theme package if it was not already installed.

Fonts

If you find the standard fonts rather thick and or slightly out of focus
open Settings>Appearance click on the Fonts tab and under Hinting:
change to Full

You could also try using a custom DPI setting.

> Sound

Configuring xfce4-mixer

xfce4-mixer is the GUI mixer app / panel plugin made by the Xfce team.
It is part of the xfce4 group, so you probably already have it
installed. Xfce 4.6 uses gstreamer as the backend to control volume, so
first you have to make gstreamer cooperate with xfce4-mixer. One or more
of the gstreamer plugin packages listed as optional dependencies to
xfce4-mixer must be installed. Without one of these required plugins
packages, the following error arises when clicking on the mixer panel
item.

     GStreamer was unable to detect any sound devices. Some sound system specific GStreamer packages may be missing. 

Which plugins are needed depends on the hardware. Most people should be
fine with gstreamer0.10-base-plugins which can be installed from
Official repositories.

If the xfce4-mixer panel item was already running before one of the
plugins packages was installed, logout and login to see if it worked, or
just remove the mixer plugin from the panel and add it again. If that
does not work, you might need more or different gstreamer plugins. Try
to install package gstreamer0.10-good-plugins or
gstreamer0.10-bad-plugins.

If you had to change the soundcard in the audio mixer, then you should
log out and back in to hear sound.

For further details, for example how to set the default sound card, see
Advanced Linux Sound Architecture. Alternatively you can use PulseAudio
together with pavucontrol.

Xfce4-mixer and OSS4

If you tried the above section to get xfce4-mixer to work and it does
not work at all, then you may have to compile gstreamer0.10-good-plugins
yourself. Download the PKGBUILD and other files needed from ABS or here,
edit the PKGBUILD, add --enable-oss.

     ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
       --enable-oss \
       --disable-static --enable-experimental \
       --disable-schemas-install \
       --disable-hal \
       --with-package-name="GStreamer Good Plugins (Archlinux)" \
       --with-package-origin="https://www.archlinux.org/"

and then run makepkg -i.

     makepkg -i

Other LINKS: OSS forum

Keyboard Volume Buttons

Go to

    Settings --> Keyboard

Click the "Application Shortcuts" tab and add click the "Add" button.
Add the following by entering the command, then pressing the
corresponding button at the next window:

ALSA

For the raise volume button:

    amixer set Master 5%+

For the lower volume button:

    amixer set Master 5%-

For the mute button:

    amixer set Master toggle

You can also run these commands to set the above commands to the
standard XF86Audio keys:

    xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioRaiseVolume -n -t string -s "amixer set Master 5%+ unmute"
    xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioLowerVolume -n -t string -s "amixer set Master 5%- unmute"
    xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioMute -n -t string -s "amixer set Master toggle"

If amixer set Master toggle does not work, try the PCM channel
(amixer set PCM toggle) instead.

The channel must have a "mute" option for the toggle command to work. To
check whether or not your Master channel supports toggling mute, run
alsamixer in a terminal and look for the double M's (MM) under the
Master channel. If they are not present, then it does not support the
mute option. If, for example, you had to change the toggle button to use
the PCM channel, make sure to also set the PCM channel as the Mixer
Track under Xfce Mixer properties.

OSS

Use one of these scripts:
http://www.opensound.com/wiki/index.php/Tips_And_Tricks#Using_multimedia_keys_with_OSS

If using ossvol (recommended), add:

    ossvol -i 1

for the volume up button

    ossvol -d 1

for the volume down button

    ossvol -t

for the mute/unmute button

PulseAudio

For the raise volume button:

    sh -c "pactl set-sink-mute 0 false ; pactl set-sink-volume 0 +5%"

For the lower volume button:

    sh -c "pactl set-sink-mute 0 false ; pactl -- set-sink-volume 0 -5%"

For the mute button:

    pactl set-sink-mute 0 toggle

These settings assume the device you want to control has index 0. Use
pactl list sinks short to list sinks.

Xfce4-volumed

xfce4-volumed daemon from the AUR automatically maps volume keys of your
keyboard to Xfce-mixer. Additionally you get OSD through Xfce4-notifyd
when changing volume. Xfce4-volumed does not need any configuration and
is started automatically with Xfce.

If you use pulseaudio and xfce4-volumed unmute does not work then change
the keyboard commands to the pactl commands for pulseaudio as shown
above in the pulseaudio section.

Volumeicon

volumeicon is an alternative to xfce4-volumed in the community repo also
handling keybindings and notifications through xfce4-notifyd.

Note:volumeicon can only handle ALSA keybindings. If you are using
pulseaudio and volumeicon is handling the media keys you may notice
issues such as not being able to unmute the volume.

Extra keyboard keys

If you are coming from another distro, you may be interested in enabling
extra keys on your keyboard, see Extra Keyboard Keys.

Adding startup/boot sound

Arch does not have a built-in startup sound configuration tool, but
there is a workaround by adding the following command to your
Application Autostart settings:

    aplay /boot/startupsound.wav

The file location and filename can be whatever you want, but naming it
descriptively and putting it in /boot keeps things tidy.

Tips & Tricks
-------------

> xdg-open integration (Preferred Applications)

Most applications rely on xdg-open for opening a preferred application
for a given file or URL.

In order for xdg-open and xdg-settings to detect and integrate with the
XFCE desktop environment correctly, you need to install the xorg-xprop
package.

If you do not do that, your preferred applications preferences (set by
exo-preferred-applications) will not be obeyed. Installing the package
and allowing xdg-open to detect that you are running XFCE makes it
forward all calls to exo-open instead, which correctly uses all your
preferred applications preferences.

To make sure xdg-open integration is working correctly, ask xdg-settings
for the default web browser and see what the result is:

    # xdg-settings get default-web-browser

If it replies with:

    xdg-settings: unknown desktop environment

it means that it has failed to detect XFCE as your desktop environment,
which is likely due to a missing xorg-xprop package.

> Screenshots

XFCE has its own screenshot tool, xfce4-screenshooter. It is part of the
xfce4-goodies group.

Print Screen key

Go to:

    XFCE Menu  -->  Settings  -->  Keyboard  >>>  Application Shortcuts.

Add the "xfce4-screenshooter -f" command to use the "PrintScreen" key in
order to take fullscreen screenshots. See screenshooter's man page for
other optional arguments.

Alternatively, an independent screenshot program like scrot can be used.

> Disable Terminal F1 and F11 shortcut

The xfce terminal binds F1 and F11 to help and fullscreen, respectively,
which can make using programs like htop difficult. To disable those
shortcuts, create or edit its configuration file, then log out and log
back in. F10 can disabled in the Preferences menu.

    ~/.config/xfce4/terminal/accels.scm

    (gtk_accel_path "<Actions>/terminal-window/fullscreen" "")
    (gtk_accel_path "<Actions>/terminal-window/contents" "")

> Terminal color themes or pallets

Terminal color themes or pallets can be changed in GUI under Appearance
tab in Preferences. These are the colors that are available to most
console applications like Emacs, Vi and so on. Their settings are stored
individually for each system user in ~/.config/xfce4/terminal/terminalrc
file. There are also so many other themes to choose from. Check forum
thread Terminal Colour Scheme Screenshots for hundreds of available
choices and themes.

Changing default color theme

XFCE's extra/terminal package comes with a darker color palette. To
change this, append the following in your terminalrc file for a lighter
color theme, that is always visible in darker Terminal backgrounds.

    ~/.config/xfce4/terminal/terminalrc

    ColorPalette5=#38d0fcaaf3a9
    ColorPalette4=#e013a0a1612f
    ColorPalette2=#d456a81b7b42
    ColorPalette6=#ffff7062ffff
    ColorPalette3=#7ffff7bd7fff
    ColorPalette13=#82108210ffff

Terminal tango color theme

To switch to tango color theme, open with your favorite editor

    ~/.config/xfce4/terminal/terminalrc

And add(replace) these lines:

    ColorForeground=White
    ColorBackground=#323232323232
    ColorPalette1=#2e2e34343636
    ColorPalette2=#cccc00000000
    ColorPalette3=#4e4e9a9a0606
    ColorPalette4=#c4c4a0a00000
    ColorPalette5=#34346565a4a4
    ColorPalette6=#757550507b7b
    ColorPalette7=#060698989a9a
    ColorPalette8=#d3d3d7d7cfcf
    ColorPalette9=#555557575353
    ColorPalette10=#efef29292929
    ColorPalette11=#8a8ae2e23434
    ColorPalette12=#fcfce9e94f4f
    ColorPalette13=#72729f9fcfcf
    ColorPalette14=#adad7f7fa8a8
    ColorPalette15=#3434e2e2e2e2
    ColorPalette16=#eeeeeeeeecec

> Colour management

xfce4-settings-manager does not yet have any colour management /
calibration settings, nor is there any specific XFCE program to
characterise your monitor.

There is a very good article on how to do colour profiling with dispwin
etc. under XFCE, below are the basics:

Loading a profile

If you wish to load an icc profile (that you have previously created or
downloaded) to calibrate your display on startup, you can download
xcalib from AUR, then open the XFCE4 Settings Manager, click Session and
Startup icon, the Autostart tab, and add a new entry where the command
is /usr/bin/xcalib /path/to/your/profile.icc. You still need to tell
your applications, which display profile should be used to have the
displayed images colour managed.

Another option is dispwin. Dispwin not only calibrates the display, but
also sets the _ICC_PROFILE atom in X so that some applications can use a
"system" display profile instead of requiring the user to set the
display profile manually (GIMP, Inkscape, darktable, UFRaw, etc.).

See ICC Profiles#Loading ICC Profiles for more information.

Creating a profile

If you wish to create an icc profile for your display (ie.
characterising/profiling, e.g. with the ColorHug, or some other
colorimeter, or a spectrophotometer, or "by eye"), the simplest option
may be to install dispcalgui from AUR.

Another option is to install gnome-settings-daemon and
gnome-color-manager (available in extra). In order to start the
calibration from the command line, first do
/usr/lib/gnome-settings-daemon/gnome-settings-daemon & (note: this might
change your keyboard layout and who knows what else, so probably good to
do it on a throwaway account), then colormgr get-devices and look for
the "Device ID" line of your monitor. If this is e.g. "xrandr-Lenovo
Group Limited", you start calibration with the command
gcm-calibrate --device "xrandr-Lenovo Group Limited".

Note:The reason you need gnome-settings-daemon running is because XFCE
does not yet have a session component for colord:
https://bugzilla.xfce.org/show_bug.cgi?id=8559 . A lightweight daemon,
xiccd, may (and probably should) be used instead.

See ICC Profiles for more information.

> Multiple Monitors

If you have configured X.org so that your display spans multiple
monitors, usually when you login to an XFCE session, it will appear as
if your monitors are simple clones of one another. You can use an xrandr
tool to tweak your setup but if this is not called at an appropriate
time in the startup sequence, some functionality may be lost with parts
of your display being inaccessible to the mouse pointer.

A better way is to configure XFCE to match your desired display
arrangement. However, at present (xfce-settings 4.10), there is no tool
available to assist with configuring multiple monitors directly.

-   The Settings -> Display tool does allow configuration of screen
    resolution, rotation and enabling individual monitors; warning:
    using this tool to adjust display settings will reset or lose
    settings made manually for properties not explicitly offered as
    buttons in the tool (see below).
-   The Settings -> Settings Editor allows manipulation of all
    configuration items in particular the displays settings which are
    saved in the file displays.xml below

    ~/.config/xfce4/xfconf/xfce-perchannel-xml

-   Alternatively, the displays.xml can be edited using your favourite
    editor.

The main requirement for multiple monitors is their arrangement relative
to one another. This can be controlled by setting the Position
properties (X and Y) to suit; an (x,y) position of 0,0 corresponds to
the top, left position of the monitor array. This is the default
position for all monitors and if several monitors are enabled they will
appear as a cloned display area extending from this point.

To extend the display area correctly across both monitors:

-   for side-by-side monitors, set the X property of the rightmost
    monitor to equal the width of the left-most monitor
-   for above-and-below monitors, set the Y property of the bottom
    monitor to equal the height of the upper monitor
-   for other arrangements, set the X and Y properties of each monitor
    to correspond to your layout

Measurements are in pixels. As an example, a pair of monitors with
nominal dimensions of 1920x1080 which are rotated by 90 and placed
side-by-side can be configured with a displays.xml like this:

    <channel name="displays" version="1.0">
     <property name="Default" type="empty">
       <property name="VGA-1" type="string" value="Idek Iiyama 23"">
         <property name="Active" type="bool" value="true"/>
         <property name="Resolution" type="string" value="1920x1080"/>
         <property name="RefreshRate" type="double" value="60.000000"/>
         <property name="Rotation" type="int" value="90"/>
         <property name="Reflection" type="string" value="0"/>
         <property name="Primary" type="bool" value="false"/>
         <property name="Position" type="empty">
           <property name="X" type="int" value="0"/>
           <property name="Y" type="int" value="0"/>
         </property>
       </property>
       <property name="DVI-0" type="string" value="Digital display">
         <property name="Active" type="bool" value="true"/>
         <property name="Resolution" type="string" value="1920x1080"/>
         <property name="RefreshRate" type="double" value="60.000000"/>
         <property name="Rotation" type="int" value="90"/>
         <property name="Reflection" type="string" value="0"/>
         <property name="Primary" type="bool" value="false"/>
         <property name="Position" type="empty">
           <property name="X" type="int" value="1080"/>
           <property name="Y" type="int" value="0"/>
         </property>
       </property>
     </property>
    </channel>

Usually, editing settings in this way requires a logout/login to action
them.

A new method for configuring multiple monitors will be available in the
forthcoming xfce-settings 4.12 release.

> XDG User Directories

freedesktop.org specifies the "well known" user directories like the
desktop folder and the music folder. See Xdg user directories for
detailed info.

> SSH Agents

By default Xfce 4.10 will try to load gpg-agent or ssh-agent in that
order during session initialization. To disable this, create an xfconf
key using the following command:

    xfconf-query -c xfce4-session -p /startup/ssh-agent/enabled -n -t bool -s false

To force using ssh-agent even if gpg-agent is installed, run the
following instead:

    xfconf-query -c xfce4-session -p /startup/ssh-agent/type -n -t string -s ssh-agent

To use GNOME Keyring, simply tick the checkbox Launch GNOME services on
startup in the Advanced tab of Session Manager in Xfce's settings. This
will also disable gpg-agent and ssh-agent.

Source: http://docs.xfce.org/xfce/xfce4-session/advanced

> Bluetooth functionality

Users have 3 options for using Bluetooth in Xfce:

-   Blueman - this applet currently uses the, now unmaintained, Bluez4
    bluetooth stack however a version of Blueman compatible with Bluez5
    is in development.

-   GNOME Bluetooth - this applet is compatible with Bluez5.

-   You can use command line tools to access Bluetooth functionality.
    Obex can be used for sending and receiving files and bluetoothctl
    can be used for device pairings.

> Scroll a background window without shifting focus on it

Go to

    Main Menu -> Settings -> Window Manager Tweaks -> Acessibility tab

Uncheck Raise windows when any mouse button is pressed

Troubleshooting
---------------

> Getting "Not Authorized" when attempting to mount drives with a file manager

A polkit Authentication Agent is required for this (alongside polkit and
gvfs), but not included with Xfce. Make sure one is installed and
autostarted on login, as explained in polkit#Authentication agents.

> xfce4-power-manager

Power-related ACPI events can be configured using systemd via options
from /etc/systemd/logind.conf to give control to xfce4-power-manager.

    /etc/systemd/logind.conf

    HandlePowerKey=ignore
    HandleSuspendKey=ignore
    HandleHibernateKey=ignore
    HandleLidSwitch=ignore

This also solves the problem when the computer registers multiple
suspend events.

> xfce4 keeps blanking display

Xfce4 (as of 4.12) does not seem to respect monitor power settings in
xfce4-power-manager. It attempts to run the screensaver every 10
minutes. You can check this by reading out the output of $ xset q. Run
$ xset s noblank to stop it. Alternatively add the following
configuration file to /etc/X11/xorg.conf.d/ ( I would save it as
20-noblank.conf).

    Section "ServerFlags"
    	Option "BlankTime" "0"
    EndSection

> xfce4-xkb-plugin

There is a bug in version xfce4-xkb-plugin 0.5.4.1-1 which causes
xfce4-xkb-plugin to lose keyboard, layout switching and compose key
settings. As a workaround you may enable Use system defaults option in
keyboard settings. To do so run

    xfce4-keyboard-settings

Go to Layout tab and set the Use system defaults flag, then reconfigure
xfce4-xkb-plugin.

> Locales ignored with GDM

Add your locale to /var/lib/AccountsService/users/$USER (replace
hu_HU.UTF-8 with your own locale):

    [User]
    Language=hu_HU.UTF-8
    XSession=xfce

You may also do it with sed. Note the backslash before .UTF-8:

    # sed -i 's/Language=.*/Language=hu_HU\.UTF-8/' /var/lib/AccountsService/users/$USER

Restart GDM to take effect.

> Restore default settings

If for any reason you need to revert back to the default settings, try
renaming ~/.config/xfce4-session/ and ~/.config/xfce4/

    $ mv ~/.config/xfce4-session/ ~/.config/xfce4-session-bak
    $ mv ~/.config/xfce4/ ~/.config/xfce4-bak

Logout and login for changes to take effect. If upon logging in you get
an error window with the heading "Unable to load a failsafe session,"
see the Session Failure section on this page.

> Xfce desktop icons rearrange themselves

You may find that at certain events (such as opening the panel settings
dialog) the icons on the desktop rearrange themselves. This is because
icon positions are determined by files in the ~/.config/xfce4/desktop/
directory. Each time a change is made to the desktop (icons are added or
removed or change position) a new file is generated in this directory
and these files can conflict.

To solve the problem, navigate to the directory and delete all the files
other than the one which correctly defines the icon positions. You can
determine which file defines the correct icon positions by opening it
and examining the locations of the icons. The topmost row is defined as
row 0 and the leftmost column is defined by col 0. Therefore an entry
of:

    [Firefox]
    row=3
    col=0

means that the Firefox icon will be located on the 4th row of the
leftmost column.

> NVIDIA and xfce4-sensors-plugin

To detect and use sensors of nvidia gpu you need to install libxnvctrl
and then recompile xfce4-sensors-plugin package.

> Session failure

If the window manager does not load correctly, you maybe got a session
error. Typical symptoms of this can include:

-   the mouse is an X and/or does not appear at all
-   window decorations have disappeared and windows cannot be closed
-   "Window Manager" settings tool (xfwm4-settings) will not start,
    reporting

    These settings cannot work with your current window manager (unknown)

-   errors being reported by slim or your login manager like

    No window manager registered on screen 0

Restarting xfce or rebooting your system may resolve the problem but
more likely the problem is a corrupt session. Delete the session folder
below the .cache folder:

    $ rm -r ~/.cache/sessions/

> Preferred Applications preferences have no effect

If you have set your preferred applications with
exo-preferred-applications, but they do not seem to be taken into
consideration, see #xdg-open integration (Preferred Applications)

> Action Buttons/Missing Icons

This happens if icons for some actions (Suspend, Hibernate) are missing
from the icon theme, or at least do not have the expected names. First,
find out the currently used icon theme in the Settings Manager
(→Appearance→Icons). Match this with a subdirectory of /usr/share/icons.
For example, if the icon theme is GNOME, make a note of the directory
name /usr/share/icons/gnome.

    icontheme=/usr/share/icons/gnome

Make sure that the xfce4-power-manager is installed as this contains the
needed icons. Now create symbolic links from the current icon theme into
the hicolor icon theme.

    ln -s /usr/share/icons/hicolor/16x16/actions/xfpm-suspend.png   ${icontheme}/16x16/actions/system-suspend.png
    ln -s /usr/share/icons/hicolor/16x16/actions/xfpm-hibernate.png ${icontheme}/16x16/actions/system-hibernate.png
    ln -s /usr/share/icons/hicolor/22x22/actions/xfpm-suspend.png   ${icontheme}/22x22/actions/system-suspend.png
    ln -s /usr/share/icons/hicolor/22x22/actions/xfpm-hibernate.png ${icontheme}/22x22/actions/system-hibernate.png
    ln -s /usr/share/icons/hicolor/24x24/actions/xfpm-suspend.png   ${icontheme}/24x24/actions/system-suspend.png
    ln -s /usr/share/icons/hicolor/24x24/actions/xfpm-hibernate.png ${icontheme}/24x24/actions/system-hibernate.png
    ln -s /usr/share/icons/hicolor/48x48/actions/xfpm-suspend.png   ${icontheme}/48x48/actions/system-suspend.png
    ln -s /usr/share/icons/hicolor/48x48/actions/xfpm-hibernate.png ${icontheme}/48x48/actions/system-hibernate.png

Log out and in again, and you should see icons for all actions.

> Enable cedilla ç/Ç instead of ć/Ć

When you select the keyboard layout "U.S., alternative international" in
Settings --> Keyboard --> Layout to enable accents, the typical
combination for the cedilla ' + c results in ć instead of ç.To change
this suffice edit files gtk.immodules for gtk-2.0 and immodules.cache
for gtk-3.0 in line that contains "cedilla" adding both "en" in the list
"az:ca:co:fr:gv:oc:pt:sq:tr:wa" but in alphabetical order, staying that
way in /etc/gtk-2.0/gtk.immodules

    "/usr/lib/gtk-2.0/2.10.0/immodules/im-cedilla.so" 
    "cedilla" "Cedilla" "gtk20" "/usr/share/locale" "az:ca:co:en:fr:gv:oc:pt:sq:tr:wa"

and this in /usr/lib/gtk-3.0/3.0.0/immodules.cache

    "/usr/lib/gtk-3.0/3.0.0/immodules/im-cedilla.so" 
    "cedilla" "Cedilla" "gtk30" "/usr/share/locale" "az:ca:co:en:fr:gv:oc:pt:sq:tr:wa"

Then, do

    # echo "export GTK_IM_MODULE=cedilla" >> /etc/environment

Done. Simply just close and reopen the gtk programs like gedit.

> Non ASCII characters when mounting USB sticks

A common problem when automounting USB sticks formatted with fat
filesystem is the inability to properly show characters as umlauts, ñ,
ß, etc. This may be solved by changing the default iocharset to UTF-8,
which is easily done adding a line to /etc/xdg/xfce4/mount.rc:

    [vfat]
    uid=<auto>
    shortname=winnt
    utf8=true
    # FreeBSD specific option
    longnames=true
    flush=true

Note that when using utf-8, the system will distinct between upper- and
lowercases, potentially corrupting your files, so be careful.

It is possible to mount vfat devices with flush option, so that when
copying to USB sticks data flushes more often, thus making thunar's
progress bar to stays up until finished. Adding async instead will speed
up write ops, but make sure to use Eject option in Thunar to unmount the
stick. Globally, mount options for storage devices present at boot can
be set in fstab, and for other devices in udev rules.

> Video tearing when Xfwm compositing is enabled

This is a known problem. Consider using a standalone compositor like
Compton or Xcompmgr. Alternatively, you could replace your window
manager with something like Compiz or Kwin (kwin-standalone-git) which
provide their own compositors.

> Blurred and distorted characters when compositing is enabled (Intel graphics)

Users with Intel graphics may find that text becomes blurred or
distorted when compositing is enabled. This is due to the
xf86-video-intel driver using the SNA acceleration backend by default.
This bug can be corrected by changing the backend to the older UXA
method. See the Intel Graphics page for further instruction.

> GTK themes not working with multiple monitors

Some configuration tools might corrupt displays.xml, which results in
GTK themes under Applications Menu -> Settings -> Appearance ceasing to
work. To fix the issue, delete
~/.config/xfce4/xfconf/xfce-perchannel-xml/displays.xml and reconfigure
your screens.

See also
--------

-   http://docs.xfce.org/ - The complete documentation.
-   Xfce-Look - Themes, wallpapers, and more.
-   Xfce Wikia - How to edit the auto generated menu with the menu
    editor
-   Xfce Wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xfce&oldid=305925"

Category:

-   Desktop environments

-   This page was last modified on 20 March 2014, at 17:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
