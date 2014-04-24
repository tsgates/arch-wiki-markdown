Window Maker
============

Window Maker is a window manager (WM) for the X Window System. It is
designed to emulate the NeXT user interface as an OpenStep-compatible
environment, and is characterized by low memory demands and high
flexibility. As one of the lighter WMs, it is well suited for machines
with modest performance specifications.

Contents
--------

-   1 Installation
    -   1.1 Start Window Maker without a display manager
    -   1.2 Start Window Maker with a display manager
-   2 Configuration
    -   2.1 Files
    -   2.2 Styles
-   3 Dock
-   4 Clip
-   5 Dockapps
-   6 System-tray
-   7 Troubleshooting
    -   7.1 Can't disable smooth fonts
-   8 See Also

Installation
------------

The latest official release can be found in the windowmaker package from
the Official repositories.

Before starting Window Maker, take some time to setup GNUstep and the
default Window Maker settings. Create a directory for your Window Maker
settings. Traditionally, it is in $HOME/GNUstep.

    $ mkdir ~/GNUstep

Set the GNUSTEP_USER_ROOT variable to your GNUstep settings directory.
You can set this variable in a file such as $HOME/.bashrc.

    export GNUSTEP_USER_ROOT="${HOME}/GNUstep"

Make sure the file is sourced, for example, by logging out and back in.

Run the Window Maker settings installation program to setup the default
settings.

    $ wmaker.inst

> Start Window Maker without a display manager

Once installed create or edit the file ~/.xinitrc as follows:

    exec wmaker

To start Window Maker:

    $ startx

> Start Window Maker with a display manager

Once installed you should restart your display manager and you are now
able to select Window Maker as session.

The windowmaker package installs a .desktop file at

    /usr/share/xsessions/wmaker.desktop

Configuration
-------------

> Files

All of the settings for Window Maker can be found in the
GNUSTEP_USER_ROOT directory, under Default and Library. They are saved
as simple text files. You can use the Preferences Utility (WPrefs) GUI
application to change the settings, or edit them by hand.

-   Defaults/WindowMaker - The current Window Maker settings.
-   Defaults/WMGLOBAL
-   Defaults/WMRootMenu - The desktop main menu. It uses a simple text
    format that can be edited by hand. For more details, see the menu
    editing section in the Preferences Utility application.
-   Defaults/WMState - Used to restore a Window Maker session.
-   Defaults/WMWindowAttributes - Individual application and window
    settings, such as application icon settings and title bar settings.
    You can also edit this by right clicking on any application or
    window icon and selecting "Attributes".
-   Defaults/WPrefs - Settings for the Preferences Utility.
-   Library/Colors/
-   Library/Icons/ - One of the default locations Window Maker looks for
    application icons. You can personally save your favorite icons here
    and use them by changing application or window attributes.
-   Library/WindowMaker/autostart - Add applications that you want to
    automatically start when Window Maker starts. Be sure to run them in
    the background by using "&".
-   Library/exitscript - Same as autostart, but used when exiting.
-   Library/Backgrounds - One of the default locations where Window
    Maker looks for desktop wallpapers.
-   Library/Styles - One of the default locations where Window Maker
    looks for styles.

> Styles

Styles are simple text files that change the appearance of Window Maker.
They are very similar in appearance to the Defaults/WindowMaker file.
Whatever settings are in the style file will be applied to the
Defaults/WindowMaker file. Here is an example style that gives Window
Maker a blue and gray Arch Linux like look:

Arch.style

    {
      FTitleBack = (solid, "#0088CC");
      FTitleColor = white;
      UTitleBack = (solid, "#333333");
      UTitleColor = "#999999";
      PTitleBack = (solid, "#333333");
      PTitleColor = "#999999";
      MenuTextBack = (solid, "#ECF2F5");
      MenuTextColor = black;
      IconTitleBack = "#333333";
      IconTitleColor = white;
      MenuTitleBack = (solid, "#0088CC");
      MenuTitleColor = white;
      HighlightTextColor = white;
      HighlightColor = "#333333";
      MenuDisabledColor = "#999999";
      ClipTitleColor = black;
      IconBack = (solid, "#ECF2F5");
      ResizebarBack = (solid, "#333333");
      MenuStyle = flat;
      WorkspaceBack = (solid, black);
      ClipTitleFont = "Arial:slant=0:weight=200:width=100:pixelsize=10";
      IconTitleFont = "Arial:slant=0:weight=80:width=100:pixelsize=9";
      LargeDisplayFont = "Arial:slant=0:weight=80:width=100:pixelsize=24";
      MenuTextFont = "Arial:slant=0:weight=80:width=100:pixelsize=12";
      MenuTitleFont = "Arial:slant=0:weight=200:width=100:pixelsize=12";
      WindowTitleFont = "Arial:slant=0:weight=200:width=100:pixelsize=12";
    }

Styles can also be edited by using the Preferences Utility application.

Dock
----

The user interface of Mac OS X evolved from the style of user interface
that Window Maker uses. There is a "dock" that contains applications
icons that are "pinned" to the dock by the user. Also, the dock can hold
special small applications called "dockapps", which run only inside the
dock. By default, all applications run in Window Maker will have an
application icon, which you can use to run a new instance of the
application, hide and unhide all windows of the application, or kill the
application. The application icon does not represent a window. Instead,
if you minimize a window, a small icon representing the window will
appear on the desktop.

After starting any application, (for example, from the command line) the
application icon will appear on the desktop. You can pin it to the dock
by clicking and dragging the icon into the dock area. To remove the
application icon from the dock, click and drag the icon away from the
dock area. You change settings, such as making an application
automatically start when Window Maker starts, by right clicking on the
application icon in the dock.

The default action to activate application icons and window icons is to
double click them. You can change a setting to allow you to activate
them with a single click.

Clip
----

The "clip" is a button that has the image of a paperclip on it. You can
change the name of the current workspace by right clicking on the clip.
You can change workspaces by clicking the arrows that are on the clip.

The clip also has similar functionality to the dock. Application icons
that are added to the dock are visible on all workspaces, while
application icons that are attached to the clip are only seen on the
workspace where they are attached. This allows you to conveniently
associate specific application icons with specific workspaces.

Double click the clip to hide and unhide the application icons that are
attached to it.

Dockapps
--------

Dockapps are small applications that run in the dock. They can be useful
for showing system information. Some useful dockapps that are in the AUR
include:

-   wmclockmon - Show time and date.
-   wmcpuload - Show CPU status and usage.
-   wmnetload - Show network status. Usage: wmnetload -i eth0
-   wmdiskmon - Show disk usage. Usage:
    wmdiskmon -p /dev/sda1 -p /dev/sda2

See the Window Maker website for more information about dockapps.

System-tray
-----------

Well; there is no native system-tray for the windowmaker but there is
one or two options around. this is potentially helpful if you want to
have let's say nm-applet or so in your desktop.

The first one is stalonetray which Prior to version 0.8, stalonetray
does not work as a dockapp in WindowMaker, use Docker instead. Moreover,
NW is the only grow gravity that works reliably in WindowMaker for those
versions.

Starting from version 0.8, there is very basic support for WindowMaker
dockapp mode which can be enabled via --dockapp-mode wmaker. Following
options are also required:
--slot-size 32 --geometry 2x2 --parent-bg --scrollbars none.

But also there are some easy ways, too:

-   wmsystray : which practically do the job for you.
-   wmsystemtray : The same but with no border and it suppose to work
    nicely on other desktops too.
-   Peksystray : which is a small system tray (also called notification
    tray) designed for all the light window managers supporting docking.

Peksystray provides a window where icons will automatically add up
depending on the requests from the applications. Both the size of the
window and the size of the icons can be selected by the user. If the
window is full, it can automatically display another window in order to
display more icons.

Troubleshooting
---------------

> Can't disable smooth fonts

Delete (but keep a backup) the ~/.fontconfig/ directory and
~/.fonts.conf file, then restart Window Maker.

See Also
--------

-   Official website
-   Window Maker (Wikipedia)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Window_Maker&oldid=301534"

Category:

-   Stacking WMs

-   This page was last modified on 24 February 2014, at 11:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
