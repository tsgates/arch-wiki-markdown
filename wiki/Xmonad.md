Xmonad
======

xmonad is a tiling window manager for X. Windows are arranged
automatically to tile the screen without gaps or overlap, maximizing
screen use. Window manager features are accessible from the keyboard: a
mouse is optional.

xmonad is written, configured and extensible in Haskell. Custom layout
algorithms, key bindings and other extensions may be written by the user
in config files.

Layouts are applied dynamically, and different layouts may be used on
each workspace. Xinerama is fully supported, allowing windows to be
tiled on several physical screens.

For more information, please visit the xmonad website:
http://xmonad.org/

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Development version (xmonad-darcs)                           |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Starting xmonad                                              |
|     -   2.2 Configuring xmonad                                           |
|     -   2.3 Exiting xmonad                                               |
|                                                                          |
| -   3 Tips and tricks                                                    |
|     -   3.1 Complementary applications                                   |
|     -   3.2 Increase the number of workspaces                            |
|     -   3.3 Making room for Conky or tray apps                           |
|     -   3.4 Using xmobar with xmonad                                     |
|         -   3.4.1 Option 1: Quick, less flexible                         |
|         -   3.4.2 Option 2: More Configurable                            |
|         -   3.4.3 Verify XMobar Config                                   |
|                                                                          |
|     -   3.5 Controlling xmonad with external scripts                     |
|     -   3.6 Launching another window manager within xmonad               |
|     -   3.7 Example configurations                                       |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 GNOME 3 and xmonad                                           |
|         -   4.1.1 Compositing in GNOME and Xmonad                        |
|                                                                          |
|     -   4.2 GDM 2.x/KDM cannot find xmonad                               |
|     -   4.3 Missing xmonad-i386-linux or xmonad-x86_64-linux             |
|     -   4.4 Problems with Java applications                              |
|     -   4.5 Empty space at the bottom of gvim or terminals               |
|     -   4.6 Chromium/Chrome will not go fullscreen                       |
|     -   4.7 Multitouch / touchegg                                        |
|     -   4.8 Keybinding issues with an azerty keyboard layout             |
|     -   4.9 GNOME 3 mod4+p changes display configuration instead of      |
|         launching dmenu                                                  |
|                                                                          |
| -   5 Other Resources                                                    |
+--------------------------------------------------------------------------+

Installation
------------

xmonad and xmonad-contrib are currently available in the official
repositories. A build for the current development snapshot (darcs) is in
the AUR. The following instructions are for xmonad-darcs, the
development snapshot.

> Development version (xmonad-darcs)

The xmonad-darcs development version can be installed from the AUR, with
some additional dependencies in the official repositories. Install them
in the following order:

-   xmonad-darcs -- The core window manager
-   xmonad-contrib-darcs -- Contributed extensions providing custom
    layouts, configurations, etc.

Configuration
-------------

> Starting xmonad

To start xmonad automatically, simply add the command xmonad to your
startup script (e.g. ~/.xinitrc if you use startx, ~/.xsession if you
use xdm login manager). GDM and KDM users can create a new session file
and then select xmonad from the appropriate Session menu.

Note:By default, xmonad does not set an X cursor, therefore the "cross"
cursor is usually displayed which can be confusing for new users
(thinking that xmonad has not launched correctly). To set the expected
left-pointer, add the following to your startup file (e.g.
~/.xinitrc):  

    xsetroot -cursor_name left_ptr

Also, xmonad defaults to the U.S. keyboard layout, so if you want, for
example, the German keyboard layout, add the following to ~/.xinitrc or
read more about setting keyboard layouts here:

     setxkbmap -layout de

Example ~/.xinitrc:

     # set the cursor
     xsetroot -cursor_name left_ptr
     # set German keyboard layout
     setxkbmap -layout de
     # start xmonad
     exec xmonad

If, for some reason, xmonad does not start, check if you have an .xmonad
directory in your home directory. If not, create it:

     mkdir ~/.xmonad

See xinitrc for details, such as preserving the logind (and/or
consolekit) session.

> Configuring xmonad

xmonad users can modify, override or extend the default settings with
the ~/.xmonad/xmonad.hs configuration file. Recompiling is done on the
fly, with the Mod+q shortcut.

If you find you do not have a directory at ~/.xmonad, run
xmonad --recompile to create it.

The "default config" for xmonad is quite usable and it is achieved by
simply running without an xmonad.hs entirely. Therefore, even after you
run xmonad --recompile you will most likely not have an
~/.xmonad/xmonad.hs file. If you would like to start tweaking things,
simply create the file and edit it as described below.

Because the xmonad configuration file is written in Haskell,
non-programmers may have a difficult time adjusting settings. For
detailed HOWTO's and example configs, we refer you to the following
resources:

-   xmonad wiki
-   xmonad config archive
-   xmonad FAQ
-   Arch Linux forum thread

The best approach is to only place your changes and customizations in
~/.xmonad/xmonad.hs and write it such that any unset parameters are
picked up from the built-in defaultConfig.

This is achieved by writing an xmonad.hs like this:

     import XMonad
     
     main = do
       xmonad $ defaultConfig
         { terminal    = "urxvt"
         , modMask     = mod4Mask
         , borderWidth = 3
         }

This simply overrides the default terminal and borderWidth while leaving
all other settings at their defaults (inherited from the function
defaultConfig).

As things get more complicated, it can be handy to call configuration
options by function name inside the main function, and define these
separately in their own sections of your ~/.xmonad/xmonad.hs. This makes
large customizations like your layout and manage hooks easier to
visualize and maintain.

The simple xmonad.hs from above could have been written like this:

     import XMonad

     main = do
       xmonad $ defaultConfig
         { terminal    = myTerminal
         , modMask     = myModMask
         , borderWidth = myBorderWidth
         }

     -- yes, these are functions; just very simple ones
     -- that accept no input and return static values
     myTerminal    = "urxvt"
     myModMask     = mod4Mask -- Win key or Super_L
     myBorderWidth = 3

Also, order at top level (main, myTerminal, myModMask etc.), or within
the {} does not matter in Haskell, as long as imports come first.

The following is taken from the 0.9 config file template found here. It
is an example of the most common functions one might want to define in
their main do block.

     {
       terminal           = myTerminal,
       focusFollowsMouse  = myFocusFollowsMouse,
       borderWidth        = myBorderWidth,
       modMask            = myModMask,
       -- numlockMask deprecated in 0.9.1
       -- numlockMask        = myNumlockMask,
       workspaces         = myWorkspaces,
       normalBorderColor  = myNormalBorderColor,
       focusedBorderColor = myFocusedBorderColor,

       -- key bindings
       keys               = myKeys,
       mouseBindings      = myMouseBindings,

       -- hooks, layouts
       layoutHook         = myLayout,
       manageHook         = myManageHook,
       handleEventHook    = myEventHook,
       logHook            = myLogHook,
       startupHook        = myStartupHook
     }

Also consider copying/starting with
/usr/share/xmonad-VERSION/man/xmonad.hs, which is the latest official
example xmonad.hs that comes with the xmonad Haskell module.

> Exiting xmonad

To end the current xmonad session, press Mod+Shift+Q. By default, Mod is
the Alt key.

Tips and tricks
---------------

The keyboard-centered operation in Xmonad can be further supported with
a keyboard shortcut for X-Selection-Paste.

> Complementary applications

There are number of complementary utilities that work well with xmonad.
The most common of these include:

-   dmenu
-   xmobar
-   dzen
-   Conky and conky-cli
-   gmrun
-   Unclutter - a small utility to hide the mouse pointer
-   XMonad-log-applet - a GNOME applet for the gnome-panel (the package
    is in the Official Repositories)

> Increase the number of workspaces

By default, xmonad uses 9 workspaces. You can increase this to 14 by
extending the following line like this:

    xmonad.hs

    -- (i, k) <- zip (XMonad.workspaces conf) [xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9]
    (i, k) <- zip (XMonad.workspaces conf) [xK_grave, xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0, xK_minus, xK_equal, xK_BackSpace]

> Making room for Conky or tray apps

Wrap your layouts with avoidStruts from XMonad.Hooks.ManageDocks for
automatic dock/panel/trayer spacing:

     import XMonad
     import XMonad.Hooks.ManageDocks

     main=do
       xmonad $ defaultConfig
         { ...
         , layoutHook=avoidStruts $ layoutHook defaultConfig
         , manageHook=manageHook defaultConfig <+> manageDocks
         , ...
         }

If you ever want to toggle the gaps, this action can be added to your
key bindings:

    ,((modMask x, xK_b     ), sendMessage ToggleStruts)

> Using xmobar with xmonad

xmobar is a light and minimalistic text-based bar, designed to work with
xmonad. To use xmobar with xmonad, you will need two packages in
addition to the xmonad package. These packages are xmonad-contrib and
xmobar from the official repositories, or you can use xmobar-git from
the AUR instead of the official xmobar package.

Here we will start xmobar from within xmonad, which reloads xmobar
whenever you reload xmonad.

Open ~/.xmonad/xmonad.hs in your favorite editor, and choose one of the
two following options:

Option 1: Quick, less flexible

Note:There is also dzen2 which you can substitute for xmobar in either
case.

Common imports:

    import XMonad
    import XMonad.Hooks.DynamicLog

The xmobar action starts xmobar and returns a modified configuration
that includes all of the options described in the xmonad:Option2: More
configurable choice.

    main = xmonad =<< xmobar defaultConfig { modMask = mod4Mask {- or any other configurations here ... -}}

Option 2: More Configurable

As of xmonad(-contrib) 0.9, there is a new statusBar function in
XMonad.Hooks.DynamicLog. It allows you to use your own configuration
for:

-   The command used to execute the bar
-   The PP that determines what is being written to the bar
-   The key binding to toggle the gap for the bar

The following is an example of how to use it:

    ~/.xmonad/xmonad.hs

    -- Imports.
    import XMonad
    import XMonad.Hooks.DynamicLog

    -- The main function.
    main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

    -- Command to launch the bar.
    myBar = "xmobar"

    -- Custom PP, configure it as you like. It determines what is being written to the bar.
    myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

    -- Key binding to toggle the gap for the bar.
    toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

    -- Main configuration, override the defaults to your liking.
    myConfig = defaultConfig { modMask = mod4Mask }

Verify XMobar Config

The template and default xmobarrc contains this.

At last, open up ~/.xmobarrc and make sure you have StdinReader in the
template and run the plugin. E.g.

    ~/.xmobarrc

    Config { ...
           , commands = [ Run StdinReader .... ]
             ...
           , template = " %StdinReader% ... "
           }

Now, all you should have to do is either to start, or restart, xmonad.

> Controlling xmonad with external scripts

There are at least two ways to do this.

Firstly, you can use the following xmonad extension,
XMonad.Hooks.ServerMode.

Secondly, you can simulate keypress events using xdotool or similar
programs. See this Ubuntu forums thread. The following command would
simulate the keypress Super+n:

    xdotool key Super+n

> Launching another window manager within xmonad

If you are using xmonad-darcs, as of January of 2011, you can restart to
another window manager from within xmonad. You just need to write a
small script, and add stuff to your ~/.xmonad/xmonad.hs. Here is the
script.

    ~/bin/obtoxmd

    #!/bin/sh
    openbox
    xmonad

And here are the modifications you need to add to your
~/.xmonad/xmonad.hs:

    ~/.xmonad/xmonad.hs

    import XMonad
    --You need to add this import
    import XMonad.Util.Replace

    main do
        -- And this "replace"
        replace
        xmonad $ defaultConfig
        {
        --Add the usual here
        }

You also need to add the following key binding:

    ~/xmonad/xmonad.hs

    --Add a keybinding as follows:
    ((modm .|. shiftMask, xK_o     ), restart "/home/abijr/bin/obtoxmd" True)

Just remember to add a comma before or after and change the path to your
actual script path. Now just Mod+q (restart xmonad to refresh the
config), and then hit Mod+Shift+o and you should have Openbox running
with the same windows open as in xmonad. To return to xmonad you should
just exit Openbox. Here is a link to adamvo's ~/.xmonad/xmonad.hs which
uses this setup Adamvo's xmonad.hs

> Example configurations

Below are some example configurations from fellow xmonad users. Feel
free to add links to your own.

-   brisbin33 :: simple, useful, readable :: config screenshot
-   jelly :: Configuration with prompt, different layouts, twinview with
    xmobar :: xmonad.hs
-   MrElendig :: Simple configuration, with xmobar :: xmonad.hs,
    .xmobarrc, screenshot.
-   thayer :: A minimal mouse-friendly config ideal for netbooks ::
    configs screenshot
-   vicfryzel :: Beautiful and usable xmonad configuration, along with
    xmobar configuration, xinitrc, dmenu, and other scripts that make
    xmonad more usable. :: git repository, screenshot.
-   vogt :: Check out adamvo's config and many others in the official
    Xmonad/Config archive

Troubleshooting
---------------

> GNOME 3 and xmonad

With the release of GNOME 3, some additional steps are necessary to make
GNOME play nicely with xmonad.

Either install xmonad-gnome3 from the AUR, or, manually:

Add an xmonad session file for use by gnome-session
(/usr/share/gnome-session/sessions/xmonad.session):

    [GNOME Session]
    Name=Xmonad session
    RequiredComponents=gnome-panel;gnome-settings-daemon;
    RequiredProviders=windowmanager;notifications;
    DefaultProvider-windowmanager=xmonad
    DefaultProvider-notifications=notification-daemon

Create a desktop file for GDM
(/usr/share/xsessions/xmonad-gnome-session.desktop):

    [Desktop Entry]
    Name=Xmonad GNOME
    Comment=Tiling window manager
    TryExec=/usr/bin/gnome-session
    Exec=gnome-session --session=xmonad
    Type=XSession

Create or edit this file (/usr/share/applications/xmonad.desktop):

    [Desktop Entry]
    Type=Application
    Encoding=UTF-8
    Name=Xmonad
    Exec=xmonad
    NoDisplay=true
    X-GNOME-WMName=Xmonad
    X-GNOME-Autostart-Phase=WindowManager
    X-GNOME-Provides=windowmanager
    X-GNOME-Autostart-Notify=false

Finally, install xmonad-contrib and create or edit ~/.xmonad/xmonad.hs
to have the following

    import XMonad
    import XMonad.Config.Gnome

    main = xmonad gnomeConfig

Xmonad should now appear in the list of GDM sessions and also play
nicely with gnome-session itself.

Compositing in GNOME and Xmonad

Some applications look better (e.g. GNOME Do) when composition is
enabled. This is, however not, the case in the default Xmonad window
manager. To enable it add an additional .desktop file
/usr/share/xsessions/xmonad-gnome-session-composite.desktop:

    [Desktop Entry]
    Name=Xmonad GNOME (Composite)
    Comment=Tiling window manager
    TryExec=/usr/bin/gnome-session
    Exec=/usr/sbin/gnome-xmonad-composite
    Type=XSession

And create /usr/sbin/gnome-xmonad-composite and
chmod +x /usr/sbin/gnome-xmonad-composite:

    xcompmgr &
    gnome-session --session=xmonad

Now choose "Xmonad GNOME (Composite)" in the list of sessions during
login. Reference man xcompmgr for additional "eye candy".

> GDM 2.x/KDM cannot find xmonad

You can force GDM to launch xmonad by creating the file xmonad.desktop
in the /usr/share/xsessions directory and add the contents:

    [Desktop Entry]
    Encoding=UTF-8
    Name=xmonad
    Comment=This session starts xmonad
    Exec=/usr/bin/xmonad
    Type=Application

Now xmonad will show in your GDM session menu. Thanks to Santanu
Chatterjee for the hint.

For KDM, you will need to create the file here as
/usr/share/apps/kdm/sessions/xmonad.desktop

Official documentation can be found here: Haskell Documentation Page

> Missing xmonad-i386-linux or xmonad-x86_64-linux

Xmonad should automatically create the xmonad-i386-linux file (in
~/.xmonad/). If this it not the case you can grab a cool looking config
file from the xmonad wiki or create your own. Put the .hs and all others
files in ~/.xmonad/ and run this command from the folder:

    xmonad --recompile

Now you should see the file.

Note:A reason you may get an error message saying that
xmonad-x86_64-linux is missing is that xmonad-contrib is not installed.

> Problems with Java applications

The standard Java GUI toolkit has a hard-coded list of "non-reparenting"
window managers. Since xmonad is not in that list, there can be some
problems with running some Java applications. One of the most common
problems is "gray blobs", when the Java application renders as a plain
gray box instead of rendering the GUI.

There are several things that may help:

-   If you are using jre7-openjdk, uncomment the line
    export _JAVA_AWT_WM_NONREPARENTING=1 in /etc/profile.d/jre.sh. Then,
    source the file /etc/profile.d/jre.sh or log out and log back in.
-   If you are using Oracle's JRE/JDK, the best solution is usually to
    use SetWMName. However, its effect may be nullified if one also uses
    XMonad.Hooks.EwmhDesktops, in which case

     >> setWMName "LG3D"

added to the LogHook may help.

For more details about the problem, refer to the xmonad FAQ.

> Empty space at the bottom of gvim or terminals

See Vim#Empty space at the bottom of gVim windows for a solution which
makes the area match the background color.

For rxvt-unicode, you can use rxvt-unicode-patched.

You can also configure xmonad to respect size hints, but this will leave
a gap instead. See the documentation on Xmonad.Layout.LayoutHints.

> Chromium/Chrome will not go fullscreen

If Chrome fails to go fullscreen when F11 is pressed, you can use the
XMonad.Hooks.EwmhDesktops extension found in the xmonad-contrib package.
Simply add the import statement to your ~/.xmonad/xmonad.hs:

    import XMonad.Hooks.EwmhDesktops

and then add handleEventHook = fullscreenEventHook to the appropriate
place; for example:

    ...
            xmonad $ defaultConfig
                { modMask            = mod4Mask
                , handleEventHook    = fullscreenEventHook
                }
    ...

After a recompile/restart of xmonad, Chromium should now respond to F11
(fullscreen) as expected.

> Multitouch / touchegg

Touchégg polls the window manager for the _NET_CLIENT_LIST (in order to
fetch a list of windows it should listen for mouse events on.) By
default, xmonad does not supply this property. To enable this, use the
XMonad.Hooks.EwmhDesktops extension found in the xmonad-contrib package.

> Keybinding issues with an azerty keyboard layout

Users with a keyboard with azerty layout can run into issues with
certain keybindings. Using the XMonad.Config.Azerty module will solve
this.

> GNOME 3 mod4+p changes display configuration instead of launching dmenu

If you do not need the capability to switch the display-setup in the
gnome-control-center, just execute

    dconf write /org/gnome/settings-daemon/plugins/xrandr/active false

as your user, to disable the xrandr plugin which grabs Super+p.

Other Resources
---------------

-   xmonad - The official xmonad website
-   xmonad.hs - Template xmonad.hs
-   xmonad: a guided tour
-   dzen - General purpose messaging and notification program
-   dmenu - Dynamic X menu for the quick launching of programs
-   Comparison of Tiling Window Managers - Arch wiki article providing
    an overview of mainstream tiling window managers
-   Share your xmonad desktop!
-   xmonad hacking thread

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xmonad&oldid=255538"

Category:

-   Tiling WMs
