Fluxbox
=======

Fluxbox is yet another window manager for X11. It is based on the (now
abandoned) Blackbox 0.61.1 code, but with significant enhancements and
continued development. Fluxbox is very light on resources and fast, yet
provides interesting window management tools such as tabbing and
grouping. Its configuration files are easy to understand and edit and
there are hundreds of fluxbox "styles" to make your desktop look great.
ArchLinux with FluxBox can turn an old Pentium 800 box with just 256MB
of RAM into a very usable computer.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Starting Fluxbox                                                   |
|     -   2.1 Method 1: KDM/GDM/LightDM Login Managers                     |
|     -   2.2 Method 2: ~/.xinitrc                                         |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 Menu Management                                              |
|         -   3.1.1 fluxbox-generate_menu                                  |
|         -   3.1.2 MenuMaker                                              |
|         -   3.1.3 Arch Linux Xdg menu                                    |
|         -   3.1.4 Manually create/edit the menu                          |
|                                                                          |
|     -   3.2 Init                                                         |
|     -   3.3 Hotkeys                                                      |
|     -   3.4 Workspaces                                                   |
|     -   3.5 Tabbing and Grouping                                         |
|     -   3.6 Background (Wallpaper)                                       |
|         -   3.6.1 Swapping Multiple Backgrounds Easily                   |
|         -   3.6.2 Using Feh with FluxBox                                 |
|                                                                          |
|     -   3.7 Theming                                                      |
|     -   3.8 The Slit                                                     |
|     -   3.9 Autostarting Applications                                    |
|     -   3.10 Other Menus                                                 |
|     -   3.11 True Transparency                                           |
|     -   3.12 Notifications                                               |
|     -   3.13 A life after xorg.conf                                      |
|         -   3.13.1 Setting your keyboard right                           |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Installing Fluxbox is as easy as:

    # pacman -S fluxbox

Unless of course you have not yet installed Xorg, in which case, do that
as well.

Starting Fluxbox
----------------

> Method 1: KDM/GDM/LightDM Login Managers

Users of KDM, GDM or Lightdm should find a new fluxbox entry added to
their session menu automatically. Simply choose the fluxbox option from
the session menu when logging in.

> Method 2: ~/.xinitrc

Edit ~/.xinitrc and add the following code:

    exec startfluxbox

See xinitrc for details, such as preserving the logind (and/or
consolekit) session.

Configuration
-------------

System-wide fluxbox configuration files are in /usr/share/fluxbox while
user configuration files are in ~/.fluxbox. The user config files are:

-   init: the main fluxbox resource configuration file. See Editing the
    init file
-   menu: the fluxbox menu config. See below and Editing the menu file
-   keys: the fluxbox keyboard shortcuts (hotkeys) file. See below and
    here
-   startup: where to launch startup apps but see below for .xinitrc and
    also here
-   overlay: a config file to override elements of styles. See here.
-   apps: a config file for remembering the window configuration of
    specific apps. See here
-   windowmenu: a config file for altering the Window Menu itself: read
    this

There are a couple of other less important config files in the
directory. But the main ones to be concerned with are init, menu, keys
and perhaps startup.

> Menu Management

When you first install fluxbox a very basic applications menu will be
created at ~/.fluxbox/menu. You access the menu via a right mouse button
click on the desktop. As with other lightweight window managers Fluxbox
does not automatically update its menu when you install new
applications. It is therefore recommended that you install most of the
apps you want on your system first and then re-generate or edit the
menu. To enhance the menu and add/edit items there are basically four
ways to do it:

fluxbox-generate_menu

There is a built-in command provided with fluxbox:

    $ fluxbox-generate_menu

This command will auto-generate a ~/.fluxbox/menu/ file based on your
installed programs. However, the menu it generates will not be as
comprehensive as that generated by "menumaker" (see immediately below).

MenuMaker

MenuMaker is a powerful tool that creates XML-based menus for a variety
of Window Managers, including Fluxbox. MenuMaker will search your
computer for executable programs and create a menu based on the results.
It can be configured to exclude Legacy X, GNOME, KDE, or Xfce
applications if desired.

To install MenuMaker:

    # pacman -S menumaker

Once installed, you can generate a complete menu and overwrite the
default one by running:

    $ mmaker -f FluxBox

To see MenuMaker options:

    $ mmaker --help

Arch Linux Xdg menu

Requires XdgMenu which is available via pacman:

    # pacman -S archlinux-xdg-menu

To then create a fluxbox menu:

    $ xdg_menu --fullmenu --format fluxbox --root-menu /etc/xdg/menus/arch-applications.menu >~/.fluxbox/menu

More info:

    $ xdg_menu --help

Manually create/edit the menu

Use your favourite text editor and edit the file: "~/.fluxbox/menu" .
The basic syntax for a menu item to appear is:

    [exec] (name) {command} <path to icon>

...where "name" is the text you wish to appear for that menu item and
"command" is the location of the binary, e.g.:

    [exec] (Firefox Browser) {/usr/bin/firefox} <path to firefox icon>

Note that the "<path to icon>" is optional. If you want to create a
submenu the syntax is:

    [submenu] (Name)
    ...
    ...
    [end]

When done editing save the file and exit. There is no need to restart
fluxbox. For more info read editing the fluxbox menu.

> Init

The ~/.fluxbox/init file is FluxBox's primary configuration resource
file. You can change the basic functionality of fluxbox, windows,
toolbar, focus, etc. Some of these options are also available from the
Fluxbox, Configuration Menu. For more detail read Editing the init file.

> Hotkeys

Fluxbox offers basic hotkeys functionality. The fluxbox hotkey file is
located at ~/.fluxbox/keys. The Control key is represented by "Control".
Mod1 corresponds to the Alt key and Mod4 corresponds to Meta (not a
standard key but most users map Meta to the "Win" key). When installed
and first run Fluxbox will provide you with a very usable, almost
complete set of hotkeys. You should peruse and learn the ~/.fluxbox/keys
file to enhance your FluxBox experience.

Example: here is a quick way to control the Master volume:

    Control Mod1 Up :Exec amixer set Master,0 5%+  
    Control Mod1 Down :Exec amixer set Master,0 5%-

> Workspaces

Fluxbox defaults to having four workspaces. These are accessible using
Ctrl+F1-F4 shortcuts, or by using the left mouse button to click the
arrows on the toolbar. You can also access workspaces via a middle mouse
button click on desktop which pops up the Workspaces Menu.

> Tabbing and Grouping

With at least two windows visible on your desktop use ctrl +left click
on the upper window tab of one window and drag it into the other open
window. The two windows will now be grouped together with window tabs in
the upper window tab bar. You may now perform a window operation that
will affect the entire window "group". To reverse the tabbing use ctrl
+left click on a tab and drag it to an empty space on the desktop.

> Background (Wallpaper)

Setting the background in Fluxbox has historically been convoluted,
especially where transparency was required. The fluxbox-wiki now has an
entry for background setting, so please refer to that.

The easiest way to do it with ArchLinux is to first of all check that
you have a background setting application available:

     $ fbsetbg -i

If not, install either feh, esetroot or wmsetbg using pacman. Then add
this "fbsetbg" line to your ~/.xinitrc file, before the "exec" line,
e.g.:

     fbsetbg /path/to/my/image.image

Swapping Multiple Backgrounds Easily

Place the following submenu in your fluxbox menu:

    [submenu] (Backgrounds)
    [wallpapers] (~/.fluxbox/backgrounds) {feh --bg-scale}
    [wallpapers] (/usr/share/fluxbox/backgrounds) {feh --bg-scale}
    [end]

Then put your background images into ~/.fluxbox/backgrounds or any other
folder you specify, they will then appear in the same fashion as your
styles.

The same applies to a dual screen wallpaper on a system without
'xinerama' (NVidia TwinView for example) :

    [submenu] (Backgrounds)
    [wallpapers] (/path/to/your/backgrounds) {feh --bg-scale --no-xinerama }
    [end]

Using Feh with FluxBox

Install feh with:

    # pacman -S feh

To make sure fluxbox will load feh background next time start:

1. Make .fehbg executable:

    $ chmod 770 ~/.fehbg

2. Then add (or modify) the following line to the file ~/.fluxbox/init:

    session.screen0.rootCommand:	~/.fehbg

3. or add (or modify) the following line to the file ~/.fluxbox/startup:

    ~/.fehbg

> Theming

To install a fluxbox theme extract the theme archive file to a styles
directory. The default directories are:

-   global - /usr/share/fluxbox/styles
-   user only - ~/.fluxbox/styles

The ArchLinux AUR currently contains a compilation of good looking
fluxbox themes called "fluxbox-styles". Get it here and install this
package for more themes than you could possibly use. When installed
correctly they will appear in the Fluxbox, Styles section of your
Fluxbox menu.

To create your own Fluxbox styles read Fluxbox_Style_Guide and this
style guide.

If you use mmaker -f FluxBox to create your menus, you will not see the
styles menu selection after you install the styles. To correct this add
the following to ~/.fluxbox/menu after the restart menu item:

                   [submenu] (System Styles) {Choose a style...}
                         [stylesdir] (/usr/share/fluxbox/styles)
                           [end]
                   [submenu] (User Styles) {Choose a style...}
                         [stylesdir] (~/.fluxbox/styles)
                           [end]

  

> The Slit

Fluxbox, WindowMaker and a couple of other lightweight window managers
have a "Slit". This is a dock for any application that can be
'dockable'. A docked application is anchored and appears on every
workspace. It cannot be moved freely and is not influenced by any
manipulation to windows. It is basically a small widget. Dock apps that
are useful in such a situation tend to be clocks, system monitors,
weather, etc. Visit dockapps.windowmaker.org

> Autostarting Applications

The ArchLinux way to autostart apps is to put all code into ~/.xinitrc.
Please read Xinitrc. However, fluxbox provides functionality to
autostart applications on its own. The ~/.fluxbox/startup file is a
script for autostarting applications as well as starting fluxbox itself.
The # symbol denotes a comment.

A sample file:

    fbsetbg -l # sets the last background set, very useful and recommended.
    # In the below commands the ampersand symbol (&) is required on all applications that do not terminate immediately. 
    # failure to provide them will cause fluxbox not to start.
    idesk & 
    xterm &
    # exec is for starting fluxbox itself, do not put an ampersand (&) after this or fluxbox will exit immediately
    exec /usr/bin/fluxbox
    # or if you want to keep a log, uncomment the below command and comment out the above command:
    # exec /usr/bin/fluxbox -log ~/.fluxbox/log

> Other Menus

In the "Menu Management" section (above) we were discussing the main
"Applications" Menu, called the "Root" menu in fluxbox lingo. FluxBox
also has other menus available to the user:

-   Workspaces Menu: middle click on desktop.
-   Configuration Menu: located within the "Fluxbox" section of the
    "Root" menu.
-   Window menu: right click on the titlebar of any window, or its bar
    if minimized. Can be edited. See fluxbox-menu man page.
-   Toolbar menu: right click on empty part of toolbar. Also found as a
    sub-menu within the Configuration Menu.
-   Slit Menu: found as a sub-menu within the configuration menu.

> True Transparency

To enable true transparency in fluxbox you need an X compositor such as
Xcompmgr.

> Notifications

To enable connection notifications on-screen for fluxbox read this Arch
forum thread.

> A life after xorg.conf

Xorg no longer requires an xorg.conf file. Traditionally this is where
you would change your keyboard settings and powersave settings. Luckily
there are elegant solutions not using xorg.conf.

Setting your keyboard right

Just add the following line to ~/.fluxbox/startup:

    setxkbmap us -variant intl & # to have a us keyboard with special characters enabled (like éóíáú)

Instead of 'us' you can also pass your language code and remove the
variant option (ex.: 'us_intl', which works like the command above in
some setups). See man setxkbmap for more options.

To make a help function in your menu, just add in ~/.fluxbox/menu:

    [submenu] (Keyboard)
          [exec] (normal) {setxkbmap us}
          [exec] (international) {setxkbmap us -variant intl}
    [end]

See also
--------

-   Fluxbox Homepage
-   Fluxbox Wiki
-   Gentoo Wiki about Fluxbox
-   Gentoo Fluxbox Documentation
-   Themes for Fluxbox
-   Fluxbox Style Guide
-   Narada's Fluxbox Guide
-   The fluxbox man pages: fluxbox, fluxbox-menu, fluxbox-style,
    fluxbox-keys, fluxbox-apps, fluxbox-remote, fbsetroot, fbsetbg,
    fbrun, startfluxbox.
-   Archlinux-FluxBox screenshots

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fluxbox&oldid=248044"

Category:

-   Stacking WMs
