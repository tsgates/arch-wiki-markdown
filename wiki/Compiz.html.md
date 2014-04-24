Compiz
======

Related articles

-   Compiz Configuration
-   Window manager
-   Desktop environment
-   Cairo Compmgr
-   Xfce
-   MATE
-   Unity

Compiz is a compositing window manager. It can replace the native window
managers in desktop environments such as MATE and Xfce. The first
version of Compiz was released in January 2006. In September 2006
several changes proposed for Compiz were rejected by the Compiz team.
This led to the formation of Beryl - a fork of Compiz. In 2007 the
Compiz and Beryl communities merged and Compiz was split into two
projects: 'compiz-core' (the window manager) and 'compiz-fusion' (the
decorator and plugins). In 2009 the two projects merged into a single
unified project and the 'fusion' name was dropped. There are currently
two branches of Compiz: the older 0.8.x branch which is written in C and
the newer 0.9.x branch which is written in C++. Compiz is at the core of
the Unity desktop shell - Unity is a Compiz plugin.

Contents
--------

-   1 Installation
    -   1.1 Installing the 0.9.x branch
    -   1.2 Installing the 0.8.x branch
    -   1.3 Installing a window decorator
-   2 Starting the window decorator
    -   2.1 Changing the decorator theme
-   3 Starting Compiz
    -   3.1 Enabling important plugins
    -   3.2 With fusion-icon
    -   3.3 Without fusion-icon
    -   3.4 Starting Compiz automatically without fusion-icon
        -   3.4.1 KDE4
            -   3.4.1.1 Use System Settings
            -   3.4.1.2 Autostart link
            -   3.4.1.3 Export KDEWM
        -   3.4.2 GNOME
            -   3.4.2.1 GNOME Shell & Cinnamon
            -   3.4.2.2 Alternate Session for GNOME (Cairo dock and
                Compiz)
            -   3.4.2.3 GNOME Flashback
        -   3.4.3 MATE
            -   3.4.3.1 Using gsettings
            -   3.4.3.2 Using mate-session-properties
        -   3.4.4 Xfce
            -   3.4.4.1 Modifying the failsafe session
            -   3.4.4.2 Using Xfce application autostart
        -   3.4.5 LXDE
-   4 Using Compiz as a standalone window manager
    -   4.1 Starting the session with a display manager
        -   4.1.1 Autostarting programs when using a display manager
    -   4.2 Starting the session with startx
    -   4.3 Add a root menu
    -   4.4 Allow users to shutdown/reboot
    -   4.5 Utilities
        -   4.5.1 Panels & docks
        -   4.5.2 Run dialog
-   5 Tips and tricks
    -   5.1 Restoring the native window manager
    -   5.2 Keyboard shortcuts
        -   5.2.1 Edge bindings
    -   5.3 Enable window snapping in Compiz
    -   5.4 Screen Magnification
    -   5.5 Using the Widget Layer
    -   5.6 Profiles
    -   5.7 Backends
    -   5.8 Workspaces and Viewports
        -   5.8.1 View all windows in the current viewport
    -   5.9 Centered window placement for all windows in Compiz 0.9.x
    -   5.10 Enabling the Alt+F2 run dialog in MATE
-   6 Troubleshooting
    -   6.1 Missing GLX_EXT_texture_from_pixmaps
        -   6.1.1 On ATI cards (first solution)
        -   6.1.2 On ATI cards (second solution)
        -   6.1.3 On Intel chips
    -   6.2 Compiz starts without window borders with NVIDIA binary
        drivers
    -   6.3 Blank screen on resume from suspend-to-ram using the NVIDIA
        binary drivers
    -   6.4 Poor performance from capable graphics cards
    -   6.5 Screen flicks with NVIDIA card
    -   6.6 Compiz effects not working (GConf backend)
    -   6.7 fusion-icon doesn't start
    -   6.8 All windows start maximised
    -   6.9 Alt+F4 keybinding not working (Xfce)
    -   6.10 Mouse scroll wheel not working in GTK+ 3 applications
    -   6.11 Emerald refuses to start (crashes with a segfault)
    -   6.12 Changing the Metacity theme has no effect on
        gtk-window-decorator
-   7 See also

Installation
------------

As of May 2013, Compiz is no longer available in the official
repositories. There are a number of packages in the AUR which can
provide a full Compiz experience. The packages listed in this section
are known to provide a working Compiz configuration. Other Compiz
packages are also available.

> Installing the 0.9.x branch

Install one of the following two packages:

-   compiz-dev - This package provides the latest stable release of the
    0.9.x branch. It includes the window manager, gtk-window-decorator,
    settings panel and plugins.
-   compiz-bzr - This package provides the latest development version of
    the 0.9.x branch. It includes the window manager,
    gtk-window-decorator, settings panel and plugins.

> Installing the 0.8.x branch

The window manager can be installed from one of the following two
packages:

-   compiz-core - This package provides the window manager.
-   compiz - This package provides the window manager, the
    gtk-window-decorator and the kde-window-decorator

The following packages provide extra functionality and are highly
recommended:

-   ccsm - a settings panel for compiz
-   compizconfig-python - Compizconfig bindings for python (required by
    ccsm)
-   libcompizconfig - Compiz configuration system library (required by
    compizconfig-python)
-   compiz-fusion-plugins-main - important plugins for Compiz
-   compiz-fusion-plugins-extra - extra plugins for Compiz
-   compiz-bcop - Compiz option code generator (required by all
    compiz-fusion-plugins)

The following packages are optional:

-   compiz-fusion-plugins-unsupported - unsupported plugins for Compiz
-   fusion-icon - a tray applet that starts Compiz and can load
    different window managers and decorators during a session

The following packages provide a Compiz install that is optimised for a
particular desktop environment:

-   compiz-xfce - this package provides the window manager,
    gtk-window-decorator, settings panel and plugins.
-   compiz-mate - this package provides the window manager and the
    gtk-window-decorator.

> Installing a window decorator

The window decorator is the program which provides windows with borders.
Unlike window managers such as mutter, Kwin or Xfwm, Compiz does not
include a window decorator by default so you will need to install one
yourself. Depending on which packages you used to install Compiz you may
have a window decorator installed already. There are three main
decorators used with Compiz:

-   Emerald - For those installing the 0.8.x branch, this decorator can
    be installed from the emerald package in the AUR. For those
    installing the 0.9.x branch, the emerald-git package provides the
    0.9.x version of Emerald which should be compatible with the latest
    versions of Compiz. Users of either package may also wish to install
    the emerald-themes package which provides a number of extra themes.
    Emerald supports a number of effects and has a wide variety of
    themes available.

-   gtk-window-decorator - For those installing the 0.8.x branch, this
    decorator is provided by the compiz, compiz-xfce and compiz-mate
    packages. If you are installing the compiz-core package instead, you
    can install the gtk-window-decorator separately from the
    compiz-decorator-gtk-no-gnome package. For those installing the
    0.9.x branch, gtk-window-decorator is provided by the compiz-bzr and
    compiz-dev packages. This decorator can use Metacity or Cairo
    themes.

-   kde-window-decorator - For those installing the 0.8.x branch, this
    decorator is provided by the compiz package. For those installing
    the 0.9.x branch, before building compiz-dev or compiz-bzr, modify
    the PKGBUILD of the respective package and set KDEWINDOWDECORATOR to
    "on". . Be aware that this decorator requires the kdebase-workspace
    package which installs a significant proportion of the KDE desktop.
    The kde-window-decorator uses the current Kwin theme.

Starting the window decorator
-----------------------------

Firstly, ensure that you have a window decorator installed. Then, in a
terminal enter the command: ccsm. In the settings panel, navigate to the
'Effects' section and ensure that the 'Window Decoration' plugin is
ticked. Now click on the 'Window Decoration' button and in the 'Command'
field enter the relevant command for your decorator - see below:

-   Emerald - to set this decorator as the default for Compiz, use the
    following command:

    $ emerald --replace

-   gtk-window-decorator - to set this decorator as the default for
    Compiz, use the following command:

    $ gtk-window-decorator --replace

-   kde-window-decorator - to set this decorator as the default for
    Compiz, use the following command:

    $ kde4-window-decorator --replace

Tip:If you are using fusion-icon, there is no need to set the decoration
command as fusion-icon will set this automatically.

> Changing the decorator theme

-   Emerald - Many Emerald themes are available for download here.
    Emerald themes can be installed and managed using the
    emerald-theme-manager program. For downloaded themes, unzip the
    tarball and then install it using the 'Import' option in the theme
    manager.

-   gtk-window-decorator - Many Metacity themes are available for
    download here. Once downloaded, they should be unpacked into the
    user's ~/.themes directory (create it if it doesn't exist.) To
    select the theme open dconf-editor and expand org --> gnome -->
    desktop --> wm and click on 'preferences.' Change the value of the
    key 'Theme' to the name of the theme you wish to use. If changing
    the Metacity theme has no effect, see this section.

-   kde-window-decorator - Kwin themes can be downloaded, installed and
    managed using the KDE systemsettings panel.

Starting Compiz
---------------

> Enabling important plugins

Before starting Compiz, you should activate some plugins to provide
basic window manager behaviour or else you will have no ability to drag,
scale or close any windows. Important plugins are listed below:

-   Window Decoration - provides window borders (discussed in the
    section above)
-   Move Window
-   Resize Window
-   Place Windows - configure window placement options
-   Application Switcher - provides an Alt+Tab switcher (there are
    numerous alternative application switcher plugins e.g. 'Shift
    Switcher,' 'Static Application Switcher' etc. Not all of them use
    the Alt+Tab keybinding.)
-   OpenGL
-   Composite

To be able to switch to different viewports you will need to enable one
of the following:

-   Desktop Cube & Rotate Cube - provides the spinning cube with each
    side being a different viewport
-   Desktop Wall - viewports are arranged next to each other (animation
    is similar to the workspace switching animation in Cinnamon and
    GNOME Shell.)
-   Expo - creates a view of all viewports and windows when the mouse is
    moved into the top left corner (this plugin can be used on its own
    or in conjunction with either of the two previous plugins)

> With fusion-icon

Note:If fusion-icon is used, the native window manager will start first
and will then be replaced by Compiz unless fusion-icon is being used to
start a standalone Compiz session.

You can launch fusion-icon with the following command:

    $ fusion-icon

Right click on the icon in the panel and go to 'select window manager'.
Choose 'Compiz' if it isn't selected already. To enable fusion-icon on
startup you need to autostart it. Refer to the Autostarting article and
your desktop environment's article for further instruction.

> Without fusion-icon

You can start Compiz using the following command:

    $ compiz --replace ccp &

A quick overview over common Compiz command-line options:

-   --indirect-rendering: use indirect-rendering (AIGLX)
-   --loose-binding: can help performance issues (NVIDIA?)
-   --replace: replace current window-manager
-   --keep-window-hints: keep the gnome window manager gconf-settings
    for available viewports
-   --sm-disable: disable session-management
-   ccp: the 'ccp' command loads the last configured settings from CCSM
    (CompizConfig Settings Manager) otherwise Compiz will load with no
    settings and you won't be able to do anything with your windows like
    dragging, maximizing/minimizing, or moving.

> Starting Compiz automatically without fusion-icon

The following section provides a number methods for autostarting Compiz
in various desktop environments. Methods which involve starting the
native window manager and then replacing it with Compiz have been
indicated as such.

KDE4

Use System Settings

Go to: System Settings > Default Applications > Window Manager > Use a
different window manager

If you need to run Compiz with custom options select "Compiz custom",
then create the following script:

    /usr/local/bin/compiz-kde-launcher

    #!/bin/bash
    LIBGL_ALWAYS_INDIRECT=1
    compiz --replace ccp &
    wait

Then make it executable:

    $ chmod +x /usr/local/bin/compiz-kde-launcher

Autostart link

Warning:Do not create compiz.desktop if you intend to install the
gtk-window-decorator as it will create a file conflict.

Append a desktop entry in the KDE Autostart directory. If it doesn't
exist already (it should), create it:

    ~/.kde4/Autostart/compiz.desktop

    [Desktop Entry]
    Type=Application
    Encoding=UTF-8
    Name=Compiz
    Exec=/usr/bin/compiz ccp --replace
    NoDisplay=true
    # name of loadable control center module
    X-GNOME-WMSettingsModule=compiz
    # autostart phase
    X-GNOME-Autostart-Phase=WindowManager
    X-GNOME-Provides=windowmanager
    # name we put on the WM spec check window
    X-GNOME-WMName=Compiz
    # back compat only
    X-GnomeWMSettingsLibrary=compiz

Note:If compiz.desktop already exists, you may have to add --replace
and/or ccp to the Exec variable.

Export KDEWM

As root you must create a short script. This will allow you to load
Compiz with extra switches as doing it directly via
$ export KDEWM="compiz --replace ccp --sm-disable" may not work.

Create the file with the necessary text by using the command below:

    $ echo "compiz --replace ccp --sm-disable &" > /usr/bin/compiz-fusion

Ensure that /usr/bin/compiz-fusion has executable (+x) permissions.

    $ chmod +x /usr/bin/compiz-fusion

Choose one of the following:

1) For your user only:

    ~/.kde4/env/compiz.sh

    KDEWM="compiz-fusion"

2) System-wide:

    /etc/kde/env/compiz.sh

    KDEWM="compiz-fusion"

> Note:

-   If the above method does not work, an alternate approach is to
    include the line:

    $ export KDEWM="compiz-fusion"

in your user's ~/.bashrc file.

-   If you optionally use the /usr/local/bin directory it may not work.
    In that case you should export the script including the whole path:

    $ export KDEWM="/usr/local/bin/compiz-fusion"

GNOME

GNOME Shell & Cinnamon

GNOME Shell is implemented as a plugin of the mutter window manager.
Likewise, the Cinnamon shell is implemented as a plugin of the muffin
window manager. This means that it is impossible to use either GNOME
Shell or Cinnamon with Compiz or any other window manager.

Alternate Session for GNOME (Cairo dock and Compiz)

The gnome-session-compiz package can be used to add an additional
session in a display manager. Simply select the 'gnome-session-compiz'
option in your display manager.

Ensure that Compiz and Cairo Dock (Taskbar/Panel) have been configured
correctly.

In CCSM ensure that a window decorator is selected and the necessary
plugins for window management have been enabled. See this section.

See below for recommended Cairo dock configuration:

-   Add Application Menu icon to Cairo Dock and remember its
    key-bindings.
-   Remap Application Menu key-bindings to ALT+F1 and ALT+F2, for
    convenience.
-   Add Clock, WiFi, NetSpeed icons to the dock as applicable.
-   Add Log-out icon:
    -   Set the command for logout to gnome-session-quit --logout
    -   Set the command for shutdown to gnome-session-quit --power-off
-   Add the Notification Area Old (systray) icon to Cairo Dock.

GNOME Flashback

Note:If this method is used, Metacity will start first and will then be
replaced by Compiz.

Compiz can replace the metacity window manager in the GNOME Flashback
session. In a terminal enter the command:

    $ gnome-session-properties

Click on the add button and in the command section enter the
compiz --replace ccp & command. The name and comment sections are
unimportant and are just there to indicate what the entry does. Log out
and log in again and Compiz should start.

Warning:Ensure that the Compiz entry is disabled when starting GNOME
Shell as it could cause the shell to crash or freeze.

MATE

Using gsettings

Use the following gsettings command to change the default window manager
from marco to Compiz.

    $ gsettings set org.mate.session.required-components windowmanager compiz

Using mate-session-properties

Note:If this method is used, Marco will start first and will then be
replaced by Compiz.

Another approach is to start Compiz using mate-session-properties. In a
terminal enter the command:

    $ mate-session-properties

Click on the add button and in the command section enter the
compiz --replace ccp & command. The name and comment sections are
unimportant and are just there to indicate what the entry does. Log out
and log in again and Compiz should start.

Xfce

Modifying the failsafe session

To configure the default/failsafe session of Xfce, edit the
~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml or (to make
the change for all Xfce users)
/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml:

Replace the Xfwm startup command,

     <property name="Client0_Command" type="array">
       <value type="string" value="xfwm4"/>
     </property>

with the following:

     <property name="Client0_Command" type="array">
       <value type="string" value="compiz"/>
       <value type="string" value="ccp"/>
     </property>

Note:If the xfce4-session.xml file does not exist in
~/.config/xfce4/xfconf/xfce-perchannel-xml then you will need to edit
the file in /etc/xdg/xfce4/xfconf/xfce-perchannel-xml

To prevent the default session from being overwritten you may also add
this:

     <property name="general" type="empty">
       ...
       ...
       <property name="SaveOnExit" type="bool" value="false"/>
     </property>

Then remove the existing sessions:

    $ rm -r ~/.cache/sessions

Now you will need to log out. Ensure that the 'Save session for future
logins' option in the logout dialogue is unticked or the edit will not
take effect. Log in again and Compiz should start. Once you are sure
Compiz is running you can tick the 'Save session for future login'
option again.

Using Xfce application autostart

Note:If this method is used, Xfwm will start first and will then be
replaced by Compiz.

In the Xfce main menu navigate to 'Settings' and click on 'Session and
Startup.' Click on the 'Application Autostart' tab. Click the add button
and in the command section enter the compiz --replace ccp & command. The
name and comment sections are unimportant and are just there to indicate
what the entry does. Log out and log in again and Compiz should start.

When using this method, it is possible that Compiz will be started twice
at login. This is because Xfce saves its sessions at logout. Compiz will
be started by the restored session and then it will be started again by
the autostart entry. There are two possible solutions to this problem:

-   Disable saved sessions. This will mean that the default (Failsafe)
    session is run each time. Compiz will always be started by the
    autostart entry. To disable saved sessions, open the 'Session and
    Startup' menu entry, click on the 'Session' tab and click the 'Clear
    saved sessions' button. Then, untick the 'Save session for future
    logins' option in the Xfce logout dialog.
-   Disable the Compiz autostart entry. This will mean that Compiz is
    always started as a result of the previous session being restored.
    Just untick the Compiz autostart entry you created in Application
    Autostart.

LXDE

Please consult this section of the LXDE article

Using Compiz as a standalone window manager
-------------------------------------------

> Starting the session with a display manager

A standalone Compiz session can be started from a display manager. For
most display manager's (LightDM, LXDM, GDM etc) all that's required is
to create a .desktop file in /usr/share/xsessions defining the Compiz
session. See the article for your display manager to check if this is
the case.

Firstly, create the /usr/share/xsessions directory if it does not
already exist. Then create the .desktop file. A basic example is
provided below:

    /usr/share/xsessions/compiz.desktop

    [Desktop Entry]
    Version=1.0
    Name=Compiz
    Comment=Start a standalone Compiz session
    Exec=compiz ccp
    Type=Application

Then just choose 'Compiz' from your sessions list and log in.

Note:Some display managers are stricter than others regarding the syntax
of .desktop files. If a Compiz option does not appear in your display
manager's session menu you will need to edit your .desktop file to make
it compatible. The example above should work in most cases.

Autostarting programs when using a display manager

One way in which you could start programs with your Compiz session, when
it is started from a display manager, is to use an xprofile file. The
xprofile file is similar in syntax to xinitrc - it can contain commands
for programs you wish to start with your session. Most display managers
will parse commands from an xprofile file by default. See the xprofile
wiki article for more details.

Alternatively, you could use Compiz's 'Session Management' plugin. This
plugin will save running programs on exit and restore them when the
session is next started. Simply enable the 'Session Management' plugin
in ccsm.

> Starting the session with startx

To start Compiz with the startx command, add the following line to your
~/.xinitrc file:

    ~/.xinitrc

    exec compiz ccp

You can also use fusion icon as shown below:

    ~/.xinitrc

    exec fusion-icon

You can autostart additional programs (such as a panel) by adding the
relevant command to your ~/.xinitrc file. Below is an example of a
~/.xinitrc file which starts Compiz, the tint2 panel and the Cairo dock.

    ~/.xinitrc

    tint2 &
    cairo-dock &
    exec compiz ccp

See the xinitrc article for more details.

> Add a root menu

To add a root menu similar to that in Openbox and other standalone
window managers you can install the compiz-boxmenu package. This program
is a fork of compiz-deskmenu. Among the changes that the fork introduces
are the addition of some extra features such as a window list and a
recent documents list.

After installing the compiz-boxmenu package, copy the config files to
your home directory as shown below:

    # cp -R /etc/xdg/compiz /home/username/.config
    # chown -R username:group /home/username/.config/compiz

where username is your username and group is the primary group for your
user.

Then, open ccsm, navigate to the 'Commands' plugin and in 'Command line
0' enter the command compiz-boxmenu. In the 'Key Bindings' tab, set 'Run
command 0' to Control+Space (you can use the 'Grab key combination'
option to simplify this process.)

Now navigate to the 'Viewport Switcher' plugin and click on the
'Desktop-based Viewport Switching' tab. Change the 'Plugin for initiate
action' to core and change 'Action name for initiate' to
run_command0_key.

You should now find that a menu appears when you click Control+Space. To
launch a graphical menu editor, click on the 'Edit' option or run
compiz-boxmenu-editor in a terminal. If you would prefer to edit your
menu manually, open the following file in your favourite editor:
~/.config/compiz/boxmenu/menu.xml. For your changes to take effect, you
must click the 'Reload' option in your menu.

Warning:Whilst Control+Space is the default keybinding for
compiz-boxmenu you can assign the menu to other keybindings or
mousebindings as well. Take extreme care if doing so as Compiz bindings
will take precedence over keybindings of all other programs. For
instance, if you assign compiz-boxmenu to Button3 then you may lose
right click functionality in all programs. If the
keybinding/mousebinding you are attempting to create has any conflicts,
cssm will notify you.

> Allow users to shutdown/reboot

An unprivileged user should be able to execute commands such as
systemctl poweroff and systemctl reboot. You could assign a keyboard
shortcut to one of these commands using the 'Commands' plugin in ccsm.
Alternatively, you could create a launcher for one of these commands in
compiz-boxmenu (See the above section.) For more detailed information on
shutting down see this article.

> Utilities

Panels & docks

There are a number of panels and docks available in Arch - see this
article - however only a few are compatible with Compiz's viewports:

-   xfce4-panel
-   mate-panel
-   perlpanel
-   gnome-panel
-   cairo-dock

Run dialog

-   mate-panel provides a run dialog. See this section.
-   gnome-panel provides a run dialog. To use it, enable the 'Gnome
    Compatibility' plugin in ccsm.

Note:GNOME Panel or MATE Panel must be running in order to use their
respective run dialogs.

Alternatively you could install one of the following:

-   xfce4-appfinder - use the following command to launch a run dialog:
    xfce4-appfinder --collapsed
-   bbrun - use the following command to launch a run dialog: bbrun -w
-   gmrun - use the following command to launch a run dialog: gmrun

In each case, simply map the command to Alt+F2 (or a key combination of
your choice) via the 'Commands' plugin in ccsm

Tips and tricks
---------------

> Restoring the native window manager

You can switch back to your desktop environment's default window manager
with the following command:

    wm_name --replace

with kwin, metacity or xfwm4 instead of wm_name.

> Keyboard shortcuts

Below is a list of the default keyboard shortcuts for Compiz.

-   Switch windows = Alt+Tab.
-   Switch to next desktops = Ctrl+Alt+←.
-   Switch to previous desktop = Ctrl+Alt+→.
-   Move window = Alt+Left click.
-   Resize window = Alt+Right click.

A more detailed list can be found under CommonKeyboardShortcuts in the
Compiz wiki or you can always just look at your plugin's configuration.

Extra shortcuts can be added using the commands plugin in ccsm.

Edge bindings

Besides mouse and key bindings, Compiz can also assign commands to
certain actions involving the screen edges e.g. dragging a window to the
screen edge. For instance: the 'Rotate Cube' plugin has an option to
switch to the next viewport if a window is dragged to the screen edge.
Edge bindings can usually be disabled, through ccsm, by unticking 'Edge
Flip' options in the plugin's settings section or by disabling actions
which have the screen icon next to them in the 'Bindings' section of the
relevant plugin.

> Enable window snapping in Compiz

If you want to compare two windows side by side by dragging them to the
edges of the screen, similar to the 'Aero Snap' feature introduced in
Windows 7, enable the 'Grid' plugin in ccsm. If you are using the
'Desktop Wall' or 'Rotate Cube' plugin then disable the 'Edge Flip'
options in that plugin's section to ensure that windows do not move to
the next desktop when dragged to the screen edge.

Tip:The plugin in ccsm labelled 'Snapping Windows' merely adds
resistance to the edges of the screen. It does not resize windows that
are dragged to the screen edge.

> Screen Magnification

There are two Compiz plugins that can provide magnification
functionality. The first is 'Magnifier' which acts much like a
magnifying glass (everything within the rectangular box will be zoomed.)
The magnifier can be used by enabling the plugin in ccsm and pressing
Super+m.

The other plugin is called 'Enhanced Desktop Zoom.' When this plugin is
enabled, pressing the Super key and scrolling the middle mouse button
will magnify the part of the desktop that is under the mouse cursor.

> Using the Widget Layer

The 'Widget Layer' plugin allows you to define certain windows as
widgets. Widget windows are shown on a separate 'layer' of the screen.
When the widget layer is hidden, all windows defined as widget windows
will be iconified. By default, the widget layer is shown and hidden
using F9 key.

To define a window as a widget, open ccsm and navigate to the 'Widget
Layer' plugin. Click on the 'Behaviour' tab and click on the plus sign
button next to the 'Widget Windows' field. In the dialog box that
appears, enter title=window title where window title is the title of the
window you wish to define as a widget e.g. galculator.

> Profiles

Profiles allow you to switch between different sets of Compiz settings
easily. To create a new profile open ccsm and click on the 'Preferences'
tab. Under 'Profile' click the plus sign to add a new profile or the
minus sign to delete one. All changes made in ccsm will be written to
your current profile.

Profiles are specific to the backend you are using. For instance, if you
are using the gsettings backend then any new profile you create will be
a gsettings profile. If you switch to a different backend then your
current profile will not work and you will automatically switch to a
profile available for that backend.

Note:If you see more than one profile named 'Default' this is likely
because you have used more than one backend e.g. you will have a default
profile for ini and a default profile for gsettings or GConf.

> Backends

By default, Compiz stores its configuration settings in a plain text
file ~/.config/compiz-1/compizconfig/Default.ini. In ccsm this is known
as 'Flat-file Configuration Backend.'

Compiz can also store its settings in the gsettings or GConf databases.
To change how Compiz saves its settings open ccsm and click on the
'Preferences' tab in the left hand column. Then choose your desired
backend from the list under 'Backend.'

You can also change the backend manually by editing the
~/.config/compiz-1/compizconfig/config file.

Edit the line below:

    backend = ini

-   ini = Flat File Configuration Backend
-   gsettings = GSettings Configuration Backend
-   gconf = GConf Configuration Backend

Once you have edited and saved the file the change will take place
immediately. There is no need to log out.

> Workspaces and Viewports

Unlike many other window managers, Compiz does not use multiple
workspaces by default. Instead, it uses one workspace but splits it into
multiple sections known as viewports.

If you would like to use standard workspaces, open ccsm and navigate to
'General Options' --> 'Desktop Size.' Set the 'Horizontal Virtual Size'
and 'Vertical Virtual Size' to 1. Change the 'Number of Desktops' from 1
to your desired number of workspaces.

Plugins such as 'Desktop Cube' and 'Desktop Wall' are incompatible with
standard workspaces. They must use Compiz's viewports. For the 'Desktop
Cube' plugin to work properly, the 'Vertical Virtual Size' and 'Number
of Desktops' should be set to 1. The 'Horizontal Virtual Size' should be
set to 4 if you want a cube. You can set this value to other sizes if
you wish e.g. you could set the value to 5 and end up with a pentagon.
Set the value to 2 if you want a desktop plane.

Tip:If you are switching from viewports to standard workspaces or vice
versa, you will need to restart any panels, docks or pagers that are
running.

View all windows in the current viewport

The 'Scale' plugin provides an option to view scaled thumbnails of all
windows in the current viewport, similar to the 'Present Windows'
feature in KDE or the 'Overview Mode' in GNOME Shell. First, enable the
plugin in ccsm. Then, to access the view, move the mouse cursor into the
top right corner. The hotcorner position can be configured in the
'Bindings' tab of the plugin's settings section.

> Centered window placement for all windows in Compiz 0.9.x

In the 0.9.x version of ccsm, the 'Centered' option for the 'Place
Windows' plugin no longer exists in the 'Placement Mode' menu. However,
the option for centered window placement still exists in the 'Fixed
Window Placement' tab and it is possible to apply this setting to all
windows, effectively overriding the 'Placement Mode' setting. To ensure
that all windows are started in the center of the screen, navigate to
the 'Fixed Window Placement' tab of the 'Place Windows' plugin. Under
the 'Windows with fixed placement mode' section click on the 'New'
button. A dialog box should appear. In the 'Windows' field enter
type=Normal. From the 'Mode' menu, select the 'Centered' option.

Tip:If you only want to ensure that a particular window starts centered,
then enter title=window title where 'window title' is the title of the
window. If you have xorg-xprop installed then window properties can be
filled automatically using the 'Grab' button.

> Enabling the Alt+F2 run dialog in MATE

If you are using Compiz in MATE follow the instructions below to restore
the Alt+F2 run dialog.

Start ccsm. Ensure that the 'Commands' plugin is ticked. Click on the
'Commands' button and enter the following command in a free command line
box e.g. 'Command line 0'

    mate-panel --run-dialog

Then click on the 'Key Bindings' tab. Click on the button labelled
'Disabled' for the appropriate command line box e.g. if you entered the
command in 'Command line 0' click the 'Disabled' box next to 'Run
command 0.' In the box that appears tick the 'Enabled' option. Then
click the 'Grab key combination' button and hit Alt+F2. Click 'Ok.'

Tip:If the Alt+F2 run dialog window is always launched out of focus then
start ccsm, click on 'General Options' and click on the 'Focus & Raise
Behaviour' tab. Change the 'Focus Prevention Level' setting to 'Off.'

Troubleshooting
---------------

> Missing GLX_EXT_texture_from_pixmaps

On ATI cards (first solution)

You may run into the following error when trying to run Compiz on an ATI
card:

    Missing GLX_EXT_texture_from_pixmap

This is because Compiz's binary was compiled against Mesa's OpenGL
library rather than ATI's OpenGL library.

Firstly, copy the library into a directory to keep it because ATI's
drivers will over write it:

    $ install -Dm644 /usr/lib/libGL.so.1.2 /usr/lib/mesa/libGL.so.1.2

Then you can reinstall your fglrx drivers. Now start Compiz as shown
below:

    LD_PRELOAD=/usr/lib/mesa/libGL.so.1.2 compiz --replace ccp &

On ATI cards (second solution)

Another possible problem with 'GLX_EXT_texture_from_pixmap' on ATI cards
is that the card can only render it indirectly. If so, you have to pass
the option to your libgl as shown below:

    LIBGL_ALWAYS_INDIRECT=1 compiz --replace ccp &

(Workaround tested on the following card : ATI Technologies Inc Radeon
R250 [Mobility FireGL 9000] (rev 02))

On Intel chips

Firstly, check that you're using the intel driver as opposed to i810.
Then, run the following command to run Compiz (This must be used every
time).

    LIBGL_ALWAYS_INDIRECT=true compiz --replace --sm-disable ccp &

From the Compiz Wiki:

If you are using an Intel GMA card with AIGLX, you will need to start
Compiz with LIBGL_ALWAYS_INDIRECT=1 prepended to the command line and
run compiz with the --indirect-rendering option.

> Compiz starts without window borders with NVIDIA binary drivers

Firstly ensure that you have configured the settings discussed here
correctly. If window borders still do not start try adding Option
"AddARGBGLXVisuals" "True" and Option "DisableGLXRootClipping" "True" to
your "Screen" section in /etc/X11/xorg.conf.d/20-nvidia.conf. If window
borders still do not load and you have used other Options elsewhere in
/etc/X11/xorg.conf.d/ try commenting them out and using only the
aformentioned ARGBGLXVisuals and GLXRootClipping Options.

> Blank screen on resume from suspend-to-ram using the NVIDIA binary drivers

If you receive a blank screen with a responsive cursor upon resume, try
disabling sync to vblank. To do so, open ccsm, navigate to the 'OpenGL'
plugin and untick the 'Sync to VBlank' option.

> Poor performance from capable graphics cards

NVIDIA and Intel chips: If everything is configured correctly but you
still have poor performance with some effects, try disabling CCSM >
General Options > Display Settings > Detect Refresh Rate and instead
choose a value manually.

NVIDIA chips only: The inadequate refresh rate with 'Detect Refresh
Rate' may be due to an option called 'DynamicTwinView' being enabled by
default which plays a factor in accurately reporting the maximum refresh
rate that your card and display support. You can disable
'DynamicTwinView' by adding the following line to the "Device" or
"Screen" section of your /etc/X11/xorg.conf.d/20-nvidia.conf, and then
restarting your computer:

    Option "DynamicTwinView" "False"

> Screen flicks with NVIDIA card

To fix this behaviour create the file below:

    /etc/modprobe.d/nvidia.conf

    options nvidia NVreg_RegistryDwords="PerfLevelSrc=0x2222"

> Compiz effects not working (GConf backend)

If you have installed the gtk-window-decorator, check if the GConf
schema was correctly installed:

    $ gconftool-2 -R /apps/compiz/plugins | grep plugins

Make sure that all plugins are listed. If they are not, try to install
the Compiz schema manually (do not run this command as root):

    $ gconftool-2 --install-schema-file=/usr/share/gconf/schemas/compiz-decorator-gtk.schemas

> fusion-icon doesn't start

If you get an output like this from the command line:

    $ fusion-icon

    * Detected Session: gnome
    * Searching for installed applications...
    Traceback (most recent call last):
      File "/usr/bin/fusion-icon", line 57, in <module>
        from FusionIcon.interface import choose_interface
      File "/usr/lib/python2.5/site-packages/FusionIcon/interface.py", line 23, in <module>
        import start
      File "/usr/lib/python2.5/site-packages/FusionIcon/start.py", line 36, in <module>
        config.check()
      File "/usr/lib/python2.5/site-packages/FusionIcon/util.py", line 362, in check
        os.makedirs(self.config_folder)
      File "/usr/lib/python2.5/os.py", line 172, in makedirs
        mkdir(name, mode)
    OSError: [Errno 13] Permission denied: '/home/andy/.config/compiz'

the problem is with the permission on ~/.config/compiz/. To fix it, use:

    # chown -R username /home/username/.config/compiz/

Tip:If ~/.config/compiz/ does not exist, the directory in question may
be ~/.config/compiz-1/ instead.

> All windows start maximised

This behaviour appears to be a bug affecting the 'Pointer' window
placement mode in the 'Place Windows' plugin. Changing the placement
mode should resolve this issue. To do so, open ccsm, click on the 'Place
Windows' plugin and set the 'Placement Mode' to another setting such as
'Smart.'

> Alt+F4 keybinding not working (Xfce)

If you are using Compiz in Xfce and you are experiencing behaviour where
the Alt+F4 keybinding does not close windows, this is probably because
Compiz is getting started twice at login. Please implement one of the
solutions discussed in this section.

> Mouse scroll wheel not working in GTK+ 3 applications

You may find that the scroll wheel on your mouse allows you to scroll in
GTK+ 2 applications but not in GTK+ 3 applications. This is probably
because you have enabled the 'Viewport Switcher' plugin in ccsm.
Enabling this plugin creates a conflict between the 'Viewport Switcher'
bindings and scrolling in GTK+ 3 applications. To fix the issue, open
ccsm, navigate to the 'Viewport Switcher' plugin and click on the
'Desktop-based Viewport Switching' tab. Map the 'Move Next' and 'Move
Prev' options to a different binding or disable them altogether.

> Emerald refuses to start (crashes with a segfault)

You may find that Emerald fails to start with your Compiz session and
attempting to start it from a terminal gives you the following output
(or something similar):

    Segmentation fault (core dumped)

In this case, the solution is to reset the Emerald theme settings:

    $ rm -rf ~/.emerald/theme

Emerald should now start successfully.

> Changing the Metacity theme has no effect on gtk-window-decorator

If changing the Metacity theme has no effect, this is probably because
the decorator is using a Cairo theme instead. To make the
gtk-window-decorator use Metacity themes, you need to first find out
whether gtk-window-decorator is using GConf or gsettings to store its
settings.

-   If gtk-window-decorator is using GConf, the apps/gwd/ schema should
    be installed.
-   If gtk-window-decorator is using gsettings, the org.compiz.gwd
    schema should be installed.

Once you have ascertained which backend gtk-window-decorator is using,
you just need to set the appropriate key.

-   If using GConf, apps/gwd/use_metacity_theme needs to be set to TRUE.
-   If using gsettings, org.compiz.gwd use-metacity-theme needs to be
    set to true.

See also
--------

-   Compiz website, including wiki and forum (website and wiki are
    unmaintained)
-   Compiz development, on Launchpad
-   Troubleshooting page on Compiz wiki (page unmaintained, may be out
    of date)
-   Emerald page on Compiz wiki (page unmaintained, may be out of date)
-   Emerald Theme Manager page on Compiz wiki (page unmaintained, may be
    out of date)
-   Additional themes

Retrieved from
"https://wiki.archlinux.org/index.php?title=Compiz&oldid=306154"

Categories:

-   Eye candy
-   Stacking WMs

-   This page was last modified on 20 March 2014, at 19:08.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
