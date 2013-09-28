Compiz
======

  Summary
  ----------------------
  Compiz Configuration
  AIGLX
  Composite
  Xcompmgr
  Cairo Compmgr

Compiz is a compositing window manager. It provides its own window
manager, Emerald. Therefore it cannot be used simultaneously with other
window managers such as Openbox, Fluxbox, or Enlightenment. Users who
want to keep their current window managers and add some effects to it
may wish to try Xcompmgr instead.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Requirements                                                       |
| -   2 Installation                                                       |
|     -   2.1 Initial configuration                                        |
|                                                                          |
| -   3 Additional software                                                |
|     -   3.1 Decorators                                                   |
|     -   3.2 Other                                                        |
|                                                                          |
| -   4 Starting Compiz Fusion                                             |
|     -   4.1 Manually (with "fusion-icon")                                |
|     -   4.2 Manually (without "fusion-icon")                             |
|     -   4.3 KDE4                                                         |
|         -   4.3.1 Use System Settings (easiest)                          |
|         -   4.3.2 Autostart with "fusion-icon"                           |
|         -   4.3.3 Autostart Link without "fusion-icon"                   |
|         -   4.3.4 Export KDEWM without "fusion-icon" (preferred)         |
|                                                                          |
|     -   4.4 GNOME                                                        |
|         -   4.4.1 Alternate Session for GNOME (Preferred Method for      |
|             Experienced Compiz/Dock Users)                               |
|         -   4.4.2 Autostart (without "fusion-icon") (Preferred Method)   |
|         -   4.4.3 Autostart (without "fusion-icon") (With gnome3         |
|             fallback mode session)                                       |
|         -   4.4.4 Autostart (without "fusion-icon", Gnome prior to 2.24) |
|         -   4.4.5 Autostart (with "fusion-icon")                         |
|                                                                          |
|     -   4.5 Mate Desktop                                                 |
|         -   4.5.1 Autostart (without "fusion-icon") (Preferred Method)   |
|                                                                          |
|     -   4.6 XFCE                                                         |
|         -   4.6.1 Xfce autostart (without "fusion-icon")                 |
|         -   4.6.2 Xfce autostart (with "fusion-icon")                    |
|             -   4.6.2.1 Method 1:                                        |
|             -   4.6.2.2 Method 2:                                        |
|             -   4.6.2.3 Method 3:                                        |
|                                                                          |
|     -   4.7 As a Standalone Window Manager                               |
|         -   4.7.1 Add a root menu                                        |
|         -   4.7.2 Allow users to shutdown/reboot                         |
|                                                                          |
| -   5 Misc                                                               |
|     -   5.1 Configuration                                                |
|     -   5.2 Using compiz-manager                                         |
|     -   5.3 Using gtk-window-decorator                                   |
|     -   5.4 gconf: Additional Compiz Configurations                      |
|     -   5.5 ATI R600/R700 Notes                                          |
|                                                                          |
| -   6 Tips and tricks                                                    |
|     -   6.1 Fallback                                                     |
|     -   6.2 Keyboard Shortcuts                                           |
|                                                                          |
| -   7 Troubleshooting                                                    |
|     -   7.1 Missing GLX_EXT_texture_from_pixmaps                         |
|         -   7.1.1 On ATI cards (first solution)                          |
|         -   7.1.2 On ATI cards (second solution)                         |
|         -   7.1.3 On Intel chips                                         |
|                                                                          |
|     -   7.2 Compiz starts, but no effects are visible                    |
|     -   7.3 Compiz starts, but gtk-window-decorator does not             |
|     -   7.4 Compiz appears to start, but there are no window borders     |
|     -   7.5 Compiz starts and borders appear, but windows won't move     |
|     -   7.6 Blank screen on resume from suspend-to-ram using the Nvidia  |
|         binary drivers                                                   |
|     -   7.7 fusion-icon doesn't start                                    |
|     -   7.8 Choppy animations, even though everything configured         |
|         correctly                                                        |
|     -   7.9 Fix Gnome Screenshot                                         |
|     -   7.10 Get GNOME Workspace Switcher work with Compiz-Fusion        |
|     -   7.11 Screen flicks with NVIDIA card                              |
|     -   7.12 Fix Custom Cursor Theme on Gnome 2.30                       |
|     -   7.13 Screen artifacts on Firefox / Thunderbird                   |
|     -   7.14 Setting the window manager back to Metacity after uninstall |
|     -   7.15 Context menu in applications (firefox, ...?) disappears on  |
|         mouseover                                                        |
|     -   7.16 External notes                                              |
|                                                                          |
| -   8 See also                                                           |
+--------------------------------------------------------------------------+

Requirements
------------

Users of major DEs can make good use of compiz-manager, performing brief
requirements checking and switching to fallback WM in case of errors.
Discovering setup and hardware issues can also be done with compiz-check
script (available in AUR).

Installation
------------

All compiz packages, available in official repositories, can be
installed with group compiz-fusion.

For those who do not want to install EVERYTHING there are also groups
compiz-fusion-gtk and compiz-fusion-kde for Gnome or KDE
correspondingly.

Users who wish to select the packages individually may start with
compiz-core and one of decorators.

Note:Lack of configured window decorator can render your X workspace
slightly unusable.

> Initial configuration

While the appearance of the windows and their contents is a function of
GTK+ and Qt, the frames around the windows are controlled by the Window
Decoration plugin. To use it make sure you have a window decorator
installed. Depending on what packages you have downloaded you can choose
among several window decorators. The most common ones are Emerald,
kde-window-decorator, and gtk-window-decorator. The emerald decorator
has the advantage that it fits better to compiz's screen handling and
offers transparency effects.To set your default window decorator type
the following command string in the "Window Decoration" plugin's
settings under the field "Command". To set emerald as your default
window-decorator type:

    emerald --replace

To set the kde-window-decorator as an alternative to Emerald type:

    kde4-window-decorator --replace

To set the compiz-decorator-gtk as an alternative to Emerald type:

    gtk-window-decorator --replace

Activate important plugins!

There is high possibility that you will want to activate a few plugins
that provide basic window manager behavior or else you will have no
ability to drag, scale or close any windows as soon as compiz is
activated. Among those plugins are "Window Decoration" under Effects and
"Move Window" & "Resize Window" under Window Management. Ccsm may be
used to achieve this. Launch CompizConfig Settings Manager:

    $ ccsm

Simply put check marks next to those plugins to activate them.

Additional software
-------------------

> Decorators

-   Emerald — Compiz's own window decorator with few dependencies.
    (Note: Works but is buggy and no longer maintained)

http://www.compiz.org || emerald

-   compiz-decorator-gtk and compiz-decorator-kde – alternatives to
    Emerald, using your desktop environment's configuration backends and
    looks

> Other

-   ccsm (CompizConfig settings manager) – GUI application that lets you
    configure all of Compiz's plugins
-   fusion-icon – offers a tray icon and a nice way to start compiz,
    start ccsm and change the WM / Window Decorator
-   Lots of quickly dying packages in AUR

Starting Compiz Fusion
----------------------

> Manually (with "fusion-icon")

Launch the Compiz Fusion tray icon:

    $ fusion-icon

Note:If it fails (almost never), you may try it with dbus-launch:

    $ dbus-launch "fusion-icon"

Right click on the icon in the panel and go to 'select window manager'.
Choose "Compiz" if it isn't selected already, and you should be set.

If this fails you can start compiz-fusion by using the following
additional command to replace your default window decorator with
Compiz's window decorator (Emerald):

    $ emerald --replace

Again, note: If you want to use compiz window decorations make sure you
have the "Window Decoration" plugin marked in the compiz settings
through ccsm.

> Manually (without "fusion-icon")

Launch Compiz with the following command (which replaces your current
window manager):

    $ compiz --replace ccp &

A quick overview over common compiz command-line options:

-   --indirect-rendering: use indirect-rendering (AIGLX)
-   --loose-binding: can help performance issues (nVidia?)
-   --replace: replace current window-manager
-   --keep-window-hints: keep the gnome window-manager gconf-settings
    for available viewports, ...
-   --sm-disable: disable session-management
-   ccp: the "ccp" command loads the last configured settings from ccsm
    (CompizConfig Settings Manager) otherwise Compiz will load with no
    settings and you won't be able to do anything with your windows like
    dragging, maximizing/minimizing, or moving.

> KDE4

Note: The first and last methods will load Compiz-Fusion as the default
window manager instead of KWin. This is faster than loading Compiz with
'fusion-icon' because it avoids loading two window managers at startup.
This also prevents that annoying black screen flicker you might see
using other methods (when KWin switches to Compiz on KDE's desktop
loading screens). The downside is that if Compiz crashes, it may be more
difficult to recover your desktop

Use System Settings (easiest)

Go to: System Settings --> Default Applications --> Window Manager -->
Use a different window manager

If you need to run compiz with custom options select "Compiz custom"
(when you run fusion-icon from a terminal you can see the command line
with which compiz was started). Create a file called
"compiz-kde-launcher" in /usr/bin. Then make the file executable:
chmod +x /usr/bin/compiz-kde-launcher.

For example:

     #!/bin/bash
     LIBGL_ALWAYS_INDIRECT=1
     compiz --replace ccp &
     wait

Autostart with "fusion-icon"

Add a symbolic link, that points to the fusion-icon executable, in your
KDE Autostart directory:

    $ ln -s /usr/bin/fusion-icon ~/.kde4/Autostart/fusion-icon

Next time KDE is started, it will load fusion-icon automatically.

Autostart Link without "fusion-icon"

Warning:DO NOT create compiz.desktop if you intend to install
compiz-decorator-gtk; it will create a file conflict.

-   Append a desktop entry in the KDE Autostart directory. If it doesn't
    already exist (it should), create the file
    ~/.kde4/Autostart/compiz.desktop with the following:

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

Note: If compiz.desktop already exists, you may have to add "--replace"
and/or "ccp" to the Exec variable. Without "--replace", Compiz won't
load since it will detect another window manager already loaded. Without
"ccp", Compiz will not load any of the settings and plugins that you
have enabled through CompizConfig Settings Manager (ccsm) and you won't
be able to manipulate any of your windows.

-   If you want to use the optional fusion-icon application, launch
    fusion-icon. If you log out normally with fusion-icon running, KDE
    should restore your session and launch fusion-icon the next time you
    log in if this setting is enabled. If it doesn't appear to be
    working, ensure you have the following line in
    ~/.kde4/share/config/ksmserverrc:

    loginMode=restorePreviousLogout

Note: This is a KDE specific setting that will allow you to restore
other apps next time you log in, not just fusion-icon.

Export KDEWM without "fusion-icon" (preferred)

As root you must create a short script by doing the following in your
terminal. This will allow you to load compiz with the switches because
doing it directly via export KDEWM="compiz --replace ccp --sm-disable"
doesn't seem to work.

    $ echo "compiz --replace ccp --sm-disable &" > /usr/bin/compiz-fusion

Note: If this line doesn't work, make sure the "fusion-icon" package is
installed and then use this line instead:

    $ echo "fusion-icon &" > /usr/bin/compiz-fusion

Be sure to complete the whole method before trying this substitute.

Ensure that /usr/bin/compiz-fusion has executable (+x) permissions.

    $ chmod a+x /usr/bin/compiz-fusion

Choose one of the following:

1) Compiz for your user only --> Edit the file ~/.kde4/env/compiz.sh and
add the following line so KDE will load compiz (via the script you just
created) instead of loading KWin.

    KDEWM="compiz-fusion"

2) Compiz system wide --> Edit the file /etc/kde/env/compiz.sh and add
the following line so KDE will load compiz (via the script you just
created) instead of loading KWin.

    KDEWM="compiz-fusion"

Note: If that still doesn't work, yet another alternate way to
accomplish the above method is to include the line

    export KDEWM="compiz-fusion"

in your user's ~/.bashrc file.

Note: If you optionally use the /usr/local/bin directory it may not
work. In that case you should export the script including the whole
path:

    export KDEWM="/usr/local/bin/compiz-fusion"

> GNOME

If you have installed GNOME3 with gnome-shell, either enable forced
Fallback Mode (System Info > Graphics) or simply uninstall gnome-shell.

Note:Fallback Mode is not necessary if you choose the Compiz/Cairo-Dock
session method below.

Alternate Session for GNOME (Preferred Method for Experienced Compiz/Dock Users)

The gnome-session-compiz can be used to add an additional menu entry in
the GNOME session login dialog. This method does not require foced
fallback mode and/or modifications to sensitive system files/settings.
Also, you can switch between GNOME Shell and Compiz/Cairo-Dock between
sessions. If you can't get it working, you can always go back to your
original GNOME session.

For this method to work, Compiz and Cairo-Dock (Taskbar/Panel) may have
to be configured initially for fresh accounts, from another working
session (ccsm in GNOME Shell worked fine for me).

This method completely replaces the GNOME's window manager and panel
(they are not launched at all, rather than being replaced or killed
later). So, before actually switching to this alternate session, you may
want to configure corresponding/alternate features of the original panel
application in Cairo-Dock:

-   Add Application Menu icon to Cairo-Dock and remember its
    key-bindings.
-   Remap Application Menu key-bindings to ALT+F1 and ALT+F2, for
    convenience.
-   Add Clock, WiFi, NetSpeed icons to the dock as applicable.
-   Add Log-out icon:
    -   Set the command for logout to "gnome-session-quit --logout"
    -   Set the command for shutdown to "gnome-session-quit --power-off"

-   Add the Notification Area Old (systray) icon to Cairo-Dock.

Autostart (without "fusion-icon") (Preferred Method)

This Method makes use of the Desktop Entry Specification to specify a
Compiz Desktop Entry and of the GConf default windowmanager setting.
Thanks to the Desktop Entry you should be able to select Compiz as a
windowmanager out of GDM.

1)If the following file doesn't already exist (it should), create it
/usr/share/applications/compiz.desktop containing the following:

    [Desktop Entry]
    Type=Application
    Encoding=UTF-8
    Name=Compiz
    Exec=/usr/bin/compiz ccp  #Make sure ccp is included so that Compiz loads your previous settings.
    NoDisplay=true
    # name of loadable control center module
    X-GNOME-WMSettingsModule=compiz
    # autostart phase
    ##-> the folloing line cause gnome-session warning and slow startup, so try not to enable this
    # X-GNOME-Autostart-Phase=WindowManager 
    X-GNOME-Provides=windowmanager
    # name we put on the WM spec check window
    X-GNOME-WMName=Compiz
    # back compat only
    X-GnomeWMSettingsLibrary=compiz

Note: If compiz.desktop already exists, you must make sure that the
"ccp" is included in the Exec variable. Having "ccp" included simply
tells Compiz to load your previous settings, otherwise you won't have
any functionality.

If the above doesn't work (in most cases it does), for example if you
notice some issues with windows refreshing or low performance, try:

    Exec=/usr/bin/compiz ccp --indirect-rendering

or

    Exec=/usr/bin/compiz --replace --sm-disable --ignore-desktop-hints ccp --indirect-rendering

Instead of

    Exec=/usr/bin/compiz ccp

Some Users noticed a "lag" of 4-10 seconds when loging in from a login
manager. The solution is to change the command to:

    Exec=bash -c 'compiz ccp decoration --sm-client-id $DESKTOP_AUTOSTART_ID'

as noted in the forum. You can also add the extra parameters as
described above if needed.

2) Set some GConf parameters using the gconftool-2 command in a terminal
window or do it visually with Configuration Editor (gconf-editor). The
following outlines using the command line method, but you can also see
which keys to change using gconf-editor:

Note: Since those parameters apply to a given user, you must logout from
the root account and log in as that other user before proceeding with
the next steps. GConf will fail, if called from a root account.

    gconftool-2 --set -t string /desktop/gnome/session/required_components/windowmanager compiz

The following are optional and in most cases not necessary (the
respective keys are deprecated since GNOME 2.12). But iny any case, if
the above didn't succeed the next two statements are still valid and
should be tried.

    gconftool-2 --set -t string /desktop/gnome/applications/window_manager/current /usr/bin/compiz
    gconftool-2 --set -t string /desktop/gnome/applications/window_manager/default /usr/bin/compiz

Autostart (without "fusion-icon") (With gnome3 fallback mode session)

Edit file /usr/share/gnome-session/sessions/gnome-fallback.session:

Replace your windows manager (gnome-shell,metacity...) with compiz in
RequiredComponents line.

Change DefaultProvider-windowmanager line to
DefaultProvider-windowmanager=compiz

Here is part of my gnome-fallback.session:

    RequiredComponents=compiz;gnome-settings-daemon;
    RequiredProviders=windowmanager;notifications;
    DefaultProvider-windowmanager=compiz
    DefaultProvider-notifications=notification-daemon

Note: I took out gnome-panel as I am using avant-window-navigator as my
panel. I'am using gnome3 fallback mode with compiz, make
gtk-window-decorator start with compiz, and make avant-window-navigator
start automatically.

Autostart (without "fusion-icon", Gnome prior to 2.24)

This is a way that works if you use GDM (and I'd assume KDM too).

Make a file called /usr/local/bin/compiz-start-boot with the contents:

    #!/bin/bash
    export WINDOW_MANAGER="compiz ccp"
    exec gnome-session

and make it executable (chmod +x /usr/local/bin/compiz-start-boot). Next
create the file /etc/X11/sessions/Compiz.desktop containing the
following:

    [Desktop Entry]
    Version=1.0
    Encoding=UTF-8
    Name=Compiz on GNOME
    Exec=/usr/local/bin/compiz-start-boot
    Icon=
    Type=Application

Select Compiz on Gnome as your session and you're good to go.

Autostart (with "fusion-icon")

To start Compiz fusion automatically when starting a session go to
System > Preferences > Startup Applications. In the Startup Programs
tab, click the Add button.

You will now see the Add Startup Program dialogue. Fill it in as
follows.

Name:

    Compiz Fusion

Command:

    fusion-icon

Comment: (Put anything you like or leave blank.)

Note: You can also use "compiz --replace ccp" instead of "fusion-icon"
to load compiz but there will be no fusion-icon. The ccp value will tell
compiz to load your previous Compiz settings as configured with
CompizConfig Settings Manager (ccsm).

When you're done hit the Add button. You should now see your startup
program in the list in the Startup Programs tab. It must be checked to
be enabled. You can uncheck it to disable Compiz on startup and switch
back to Metacity.

You may also need to use the gconftool-2 command in a terminal window to
set the following parameter, otherwise fusion-icon might not load the
windows decorator.

    gconftool-2 --type bool --set /apps/metacity/general/compositing_manager false

Note: This method will be slower due to the fact that Gnome will first
load the default window manager (Metacity), then will launch fusion-icon
which will load the Compiz window manager to replace Metacity.
Essentially, it will take the amount of time that it takes to load two
window manangers to get Compiz loaded. The first method is preferred and
eliminates this issue.

> Mate Desktop

Autostart (without "fusion-icon") (Preferred Method)

As with Gnome, create a compiz.desktop file (see
Compiz#Autostart_.28without_.22fusion-icon.22.29_.28Preferred_Method.29),
then set Compiz as the default window manager :

-   on Mate prior to 1.6, edit the following mateconf entries (note: the
    last two are deprecated values):

    mateconftool-2 --set -t string /desktop/mate/session/required_components/windowmanager compiz
    mateconftool-2 --set -t string /desktop/mate/applications/window_manager/current /usr/bin/compiz
    mateconftool-2 --set -t string /desktop/mate/applications/window_manager/default /usr/bin/compiz

-   on Mate 1.6 and higher, edit the following gsettings value

    gsettings set org.mate.session.required-components windowmanager compiz

> XFCE

Xfce autostart (without "fusion-icon")

This method will start Compiz directly through the XFCE session manager
without loading Xfwm.

Please note the change to xml config files in XFCE newer than 4.2

To install the session manager, install xfce4-session.

Now we have to configure the default/failsafe session of XFCE.

Edit the ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml or
(to make the change for all XFCE users)
/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml:

Replace the xfwm startup command,

     <property name="Client0_Command" type="array">
       <value type="string" value="xfwm4"/>
     </property>

with the following:

     <property name="Client0_Command" type="array">
       <value type="string" value="compiz"/>
       <value type="string" value="ccp"/>
     </property>

Note: the ccp value will tell compiz to load your previous Compiz
settings as configured with CompizConfig Settings Manager (ccsm).

To prevent the default session from being overwritten you may also add
this:

     <property name="general" type="empty">
       ...
       ...
       <property name="SaveOnExit" type="bool" value="false"/>
     </property>

To remove the existing sessions, run:

    $ rm -r ~/.cache/sessions

Xfce autostart (with "fusion-icon")

Method 1:

This will load Xfwm first then replace it with Compiz.

Open the XFCE Settings Manager & then Sessions & Startup. Click the
Application Autostart tab.

Add

      (Name:) Compiz Fusion

      (Command:) fusion-icon

Note: You can also use "compiz --replace ccp" instead of "fusion-icon"
to load compiz but there will be no fusion-icon. The ccp value will tell
compiz to load your previous Compiz settings as configured with
CompizConfig Settings Manager (ccsm).

Note: This method is the least preferred since it loads both window
managers. All the other XFCE methods only load Compiz without loading
Xfwm.

Method 2:

Edit the following file (settings in this file is used in preference)

    $ nano ~/.config/xfce4-session/xfce4-session.rc

Or to make the change for all XFCE users (root access required)

    # nano /etc/xdg/xfce4-session/xfce4-session.rc

Add the following

    [Failsafe Session]
    Client0_Command=fusion-icon

Comment out Client0_Command=xfwm4 if it exists.

This will cause xfce to load Compiz instead of Xfwm when the user has no
existing sessions.

To prevent the default session from being overwritten you may also add

    [General]
    AutoSave=false
    SaveOnExit=false

To remove the existing sessions

    rm -R ~/.cache/sessions

Method 3:

Check if this file exists:

    ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml

If not do:

    cp /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml

and edit ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml

or (to make the changes for all xfce4 users)
/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml:

Edit Client0_Command that it look like this:

    <property name="Client0_Command" type="array">
        <value type="string" value="fusion-icon"/>
        <value type="string" value="--force-compiz"/>
    </property>

if --force-compiz dosen't work use compiz --replace --sm-disable
--ignore-desktop-hints ccp instead.

Add the SaveOnExit property if missing and set it to false:

    <property name="general" type="empty">
       <property name="FailsafeSessionName" type="string" value="Failsafe"/>
       <property name="SessionName" type="string" value="Default"/>
       <property name="SaveOnExit" type="bool" value="false"/>
     </property>

finally remove old xfce4 sessions:

    rm -r ~/.cache/sessions

Now xfce4 will load compiz instead of Xfwm.

> As a Standalone Window Manager

The package compiz-core by itself is sufficient to start using
compiz-fusion. However ccsm and emerald (or another window-decorator)
are additional highly recommended packages. You may install fusion-icon,
compiz-fusion-plugins-main, compiz-fusion-plugins-extra or any other
package later on at any time.

To autostart compiz-fusion configure .xinitrc to launch compiz as:

    ~/.xinitrc

    exec compiz ccp

You can also add other command-line options to your .xinitrc

Or if using fusion-icon, configure .xinitrc as

    ~/.xinitrc

    exec fusion-icon

However chances are you will need additional apps (e.g a panel) for
optimal usability. So to autostart such apps simply add them to your
.xinitrc as:

    ~/.xinitrc

    tint2 &
    cairo-dock &
    exec fusion-icon

Note: Add a terminal-emulator to this autostart list while starting for
the first time to help configure compiz.

An alternative method, utilizing a simple script entitled
start-fusion.sh:

    start-fusion.sh

    #!/bin/sh
    # add more apps here if necessary or start another panel, tray like pypanel, bmpanel, stalonetray
    xfce4-panel&
    fusion-icon

If this script dosn't work for you, or you get issues with dbus utilize
this script:

    start-fusion.sh

    #!/bin/sh
    cd /home/<yourusername>
    eval `dbus-launch --sh-syntax --exit-with-session`
    /usr/bin/X :0.0 -br -audit 0 -nolisten tcp vt7 &
    export DISPLAY=:0.0
    sleep 1
    compiz-manager decoration move resize > /tmp/compiz.log 2>&1 &
    # add more apps here if necessary or start another panel, tray like pypanel, bmpanel, stalonetray
    xfce4-panel&
    fusion-icon

Make it executable

    chmod +x start-fusion.sh

And add it to .xinitrc, like this:

    ~/.xinitrc

    exec /path/to/file/start-fusion.sh

Feel free to use a different panel, tray, or start a whole bunch of
applications with your session. See this forum thread for more info.

Note: Using a separate script instead of running everything from xinitrc
is the only way to let all launching applications use ConsoleKit: see
this article.

Add a root menu

To add a root menu similar to that in Openbox, Fluxbox, Blackbox etc.
you must install the package compiz-deskmenu. Upon a restart of
Compiz-Fusion, you should be able to middle click on your desktop to
launch the menu.

If it does not automatically work, enter the CompizConfig Settings
Manager, and in Commands tab, within the General Settings menu, ensure
that there is a command to launch Compiz-Deskmenu, and the appropriate
key binding is set to Control+Space.

If it still does not work, enter the Viewport Switcher menu, and change
"Plugin for initiate action" to core (NOTE: for versions 0.8.2+ it's
'commands' instead of 'core'), and "Action name for initiate" to
run_command0_key.

An alternative is to use mygtkmenu, also in AUR.

Allow users to shutdown/reboot

Refer to this wiki page. If using "The Modern way" of policykit You can
add the command to ccsm->General->Commands and assign a short-cut key to
it or alternatively you can use a launcher application.

Misc
----

> Configuration

You must do this so your windows function like you expect them to!

> Using compiz-manager

In order to use compiz-manager, you need to install it from community:

    pacman -S compiz-manager

Compiz-manager, that is now installed in /usr/bin/compiz-manager, is a
simple wrapper for Compiz and ALL of its options. For example, you can
run

    compiz-manager 

and see what the console returns for more info. You can use it in all
the scripts that start Compiz. Very simple!

> Using gtk-window-decorator

In order to use gtk-window-decorator, install the package
compiz-decorator-gtk and select "GTK Window Decorator" instead of
"Emerald" as your window decorator in fusion-icon or whatever other
program you are using to configure compiz.

> gconf: Additional Compiz Configurations

To achieve more satisfying results from Compiz, you can tweak its config
with gconf-editor:

    $ gconf-editor

Note that now compiz-core isn't built with gconf support; It is now
built with gconf support through compiz-decorator-gtk. So, you need to
install it if you want to use gconf-editor to edit your Compiz
configuration. The Compiz gconf configuration is located in in the key
apps > compiz > general > allscreens > options.

"Active plugins" is where you specify the plugins you would like to use.
Simply edit the key and add a value(refer to the key apps > compiz >
plugins to see possible values). Plugins I’ve found useful are
screenshot, png, fade, and minimize. Please do not remove those enabled
by default.

> ATI R600/R700 Notes

While using fusion-icon you shouldn't experience any problems because it
takes care of everything for you, but if you are using one of the
autostart methods that do not involve fusion-icon you will run into
trouble. For example when using the Xfce autostart method without fusion
icon you must edit
~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml per the
instructions above. However, if you follow the directions above
explicity you will find that compiz does not load. You must instead make
your xfce4-session.xml file look like this

    <property name="Client0_Command" type="array">
     <value type="string" value="LIBGL_ALWAYS_INDIRECT=1"/>
     <value type="string" value="compiz"/>
     <value type="string" value="--sm-disable"/>
     <value type="string" value="--ignore-desktop-hints"/>
     <value type="string" value="ccp"/>
     <value type="string" value="--indirect-rendering"/>
    </property>

This example targeted Xfce specifically, but it can be adapted to any
desktop environment. It's just a matter of figuring out how to add it to
the proper config file. The key thing is the required command which if
typed on a command line would look like this

    LIBGL_ALWAYS_INDIRECT=1 compiz --sm-disable --ignore-desktop-hints ccp --indirect-rendering

This is how Xfce's session manager interprets the above XML code. Notice
that you do not need --replace because you are not first loading xfwm
and then compiz.

Tips and tricks
---------------

> Fallback

If you are using KDE, GNOME or XFCE and something is not right, for
example you don’t see borders for your window, you can switch back to
default DE window manager with this command:

    wm_name --replace

with kwin, metacity or xfwm4 instead of wm_name.

> Keyboard Shortcuts

Default plugin keyboard shortcuts (plugins have to be activated!)

-   Switch windows = Alt + Tab
-   Switch desktops on cube = Ctrl + Alt + Left/Right Arrow
-   Move window = Alt + left-click
-   Resize window = Alt + right-click

A more detailed list can be found under CommonKeyboardShortcuts in the
Compiz wiki or you can always just look at your plugin's configuration
(ccsm).

Troubleshooting
---------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

> Missing GLX_EXT_texture_from_pixmaps

On ATI cards (first solution)

https://bbs.archlinux.org/viewtopic.php?id=50073 If you run into the
following error when trying to run Compiz Fusion on an ATI card:

    Missing GLX_EXT_texture_from_pixmap

This is because Compiz Fusion's binary was compiled against Mesa's
OpenGL library rather than ATI's OpenGL library (which is what you are
using). Re-install libgl-dri (yes you will have to uninstall fglrx
temporarily) to get Mesa's OpenGL library.

copy the library into a directory to keep it because ATI's drivers will
over write it.

    mkdir /lib/mesa
    cp /usr/lib/libGL.so.1.2 /lib/mesa

Once you have it copied, you can reinstall your fglrx drivers (It should
have been removed when you installed libgl-dri). Now you can start
Compiz Fusion using the following example syntax:

    LD_PRELOAD=/lib/mesa/libGL.so.1.2 compiz --replace &

On ATI cards (second solution)

An other problem could arise with GLX_EXT_texture_from_pixmap, it is
possible that the card could only render it indirectly, then you have to
pass the option to your libgl like that :

     LIBGL_ALWAYS_INDIRECT=1 compiz --replace ccp &

(Workaround tested on the following card : ATI Technologies Inc Radeon
R250 [Mobility FireGL 9000] (rev 02))

On Intel chips

First off, check that you're using the intel driver as opposed to i810.
Then, run the following command to run compiz (must use this every
time.).

    LIBGL_ALWAYS_INDIRECT=true compiz --replace --sm-disable ccp &

If you then do not have borders, run

    emerald --replace

As at 17-Oct-07 the Compiz-Fusion Wiki states: "If you are using an
Intel GMA card with AIGLX, you will need to start Compiz Fusion with
LIBGL_ALWAYS_INDIRECT=1 appended."

> Compiz starts, but no effects are visible

If you have installed compiz-decorator-gtk: Check if GConf schema was
correctly installed:

     gconftool-2 -R /apps/compiz/plugins | grep plugins

make sure that all plugins are listed (not only fade!). If not, try to
install compiz schema manually (do this as normal user, not as root!!!):

     gconftool-2 --install-schema-file=/usr/share/gconf/schemas/compiz-decorator-gtk.schemas

Note: Compiz basic plugins are not enabled by default. You should enable
"Move Window", "Resize Window", and "Window decoration" plugins in
settings manager from fusion-icon to have a usable window manager.

> Compiz starts, but gtk-window-decorator does not

It is a configuration problem for gconf and gconfd. I solved it by
removing ".gconf" dir in my home, but I'm using KDE. If you are using
Gnome you should enter your ".gconf" directory and remove all compiz
keys. This will erase your compiz settings, so be sure to reconfigure.
Finally exec as user:

     gconftool-2 --install-schema-file=/usr/share/gconf/schemas/compiz-decorator-gtk.schemas

> Compiz appears to start, but there are no window borders

When you run fusion-icon from commandline, you get output like this:

    * Detected Session: gnome
    * Searching for installed applications...
    * NVIDIA on Xorg detected, exporting: __GL_YIELD=NOTHING
    * Using the GTK Interface
    * Metacity is already running
    * Setting window manager to Compiz
    ... executing: compiz --replace --sm-disable --ignore-desktop-hints ccp
    compiz (core) - Warn: No GLXFBConfig for depth 32
    compiz (core) - Warn: No GLXFBConfig for depth 32
    compiz (core) - Warn: No GLXFBConfig for depth 32
    compiz (core) - Warn: No GLXFBConfig for depth 32
    compiz (core) - Warn: No GLXFBConfig for depth 32
    compiz (core) - Warn: No GLXFBConfig for depth 32

All you need to do is edit your /etc/X11/xorg.conf and find the "Depth"
directive inside the "Screen" section; change all occurences of this
value to 24. This occured to me with my colour depth set to 16; but also
happens when it is set to 32.

* * * * *

You may also try adding Option "AddARGBGLXVisuals" "True" & Option
"DisableGLXRootClipping" "True" to your "Screen" section if you are
using the Nvidia binary driver. (Radeon, and the open 'nv' driver will
not work with this option as far as I can tell.) If you used any other
Options elsewhere in xorg.conf to get compiz working and still have no
luck, try commenting them out and using only the aformentioned
ARGBGLXVisuals and GLXRootClipping Options.

Note: Check that "Window decoration", "Move" and "Resize" plugins are
enabled with Compiz Settings Manager or gconf-editor.

With gconf-editor you can easly enable "Window decoration", "Move" and
"Resize" plugins.

     $ gconf-editor

Navigate to apps/compiz/general/allscreens/options

Add/Edit "active_plugins" Key (Name: active_plugins, Type: List, List
type: String).

Add "decoration", "move", and "resize" to the list.

* * * * *

Another way to fix this:

-   Launch ccsm.
-   Find windows decoration and make sure it is enabled.
-   Now click on it, to edit the options.
-   If the entry behind command is empty, put the value
    gtk-window-decorator there.
    -   Alternatives are kde-window-decorator and emerald

-   Click Back and Close
-   If all went well, the borders should appear.

> Compiz starts and borders appear, but windows won't move

Be sure you have the "Move Window" plugin installed and enabled in the
compiz settings manager.

> Blank screen on resume from suspend-to-ram using the Nvidia binary drivers

If you receive a blank screen with a responsive cursor upon resume, try
disabling sync to vblank:

    gconftool -s /apps/compiz/general/screen0/options/sync_to_vblank-t boolean false

> fusion-icon doesn't start

If you get an output like this from the command line:

    [andy@andylaptop ~]$ fusion-icon
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

the problem is with the permission on ~/.config/compiz. You have set the
owner of a folder in your area as root. To change this, run (as root)

    chown <username> /home/<username>/.config/compiz

> Choppy animations, even though everything configured correctly

If everything is configured correctly but you still have poor
performance on some effects, try disabling CCSM->General
Options->Display Settings->"Detect Refresh Rate" and instead choose a
value manually. Tested on both nvidia and intel chips. Can work wonders.

Alternatively, if your chip is nvidia and you are experiencing an
inadequate refresh rate with "Detect Refresh Rate" enabled in Compiz,
it's likely due to an option called DynamicTwinView being enabled by
default which plays a factor in accurately reporting the maximum refresh
rate that your card and display support. You can disable DynamicTwinView
by adding the following line to the "Device" or "Screen" section of your
xorg.conf file, and then restarting your computer:

    Option "DynamicTwinView" "False"

Doing so will allow XrandR to accurately report the refresh rate to
anything that detects it, including Compiz. You should be able to leave
"Detect Refresh Rate" enabled and get excellent performance. Once again,
this only applies to nvidia chips.

> Fix Gnome Screenshot

To re-enable gnome-screenshot (the default behavior caused by hitting
PrtScn) simply go to Settings Manager>Commands and map
'gnome-screenshot' to the 'PrtScn' key. This is advantageous because you
can also use the Compiz-Fusion 'Screenshot' plugin at the same time
since the action that enables it is <Super>Button1 thereby giving you
two methods to do a screen capture (one of which gives a full screen
capture in a single keystroke).

> Get GNOME Workspace Switcher work with Compiz-Fusion

In older versions of Compiz, the Gnome Workspace Switcher applet would
actually work with Compiz-Fusion (i.e. rotate cube/move plane etc.), but
recent versions seem not to. This is due to a new feature introduced in
Compiz, which allows real seperate workspaces. For example, if you have
a desktop plane with four planes, and have four desktops enabled in
Gnome, it sums up to a total of 16 different workspaces. Currently,
there is no animation associated with "real" workspace changing. To get
the Workspace Switcher work, do the following:

In GConf, set the following options:

    /apps/compiz/general/screen0/options/number_of_desktops = 1
    /apps/compiz/general/screen0/options/hsize = 4 (this is an example)
    /apps/compiz/general/screen0/options/vsize = 1 (this is an example)

> Screen flicks with NVIDIA card

For fixing it, create /etc/modprobe.d/nvidia.conf file and add line:

    options nvidia NVreg_RegistryDwords="PerfLevelSrc=0x2222"

> Fix Custom Cursor Theme on Gnome 2.30

Create or edit /usr/share/icons/default/index.theme for default, or per
user (non-root) ~/.icons/default/index.theme, and add this lines:

    [Icon Theme]
    #Name=foo
    Name=foo
    #Inherits=foo
    Inherits=foo
    [Desktop Entry]
    Name[en_US]=index.theme

"Foo" is the name of the cursor theme.

> Screen artifacts on Firefox / Thunderbird

Note:Altough this issue is not strictly related to Compiz, it has been
added here due to popular misconception that Compiz itself may be the
cause.

Some users noticed a strange behavior with AMD/ATI Catalyst drivers
starting from 10.6 release. Artifacts are visible mainly with Mozilla
applications, where the GUI shows black spots of variable size. This is
caused by different 2D acceleration tecnique introduced with Catalyst
10.6. The problem can be fixed following the troubleshooting steps in
the ATI Catalyst page

> Setting the window manager back to Metacity after uninstall

Removing compiz with pacman does not set your window manager back to
metacity. This can result in no window borders being drawn, an inability
to minimize, and an inability to change the focus. To change it back,
run the command "gconf-editor" in the terminal (install it if you do not
have it already). Use this to set the value of the key
/desktop/gnome/session/required_components/window_manager from "compiz"
to "metacity". Log out and back in for this change to take effect.

> Context menu in applications (firefox, ...?) disappears on mouseover

Try disabling "focus stealing prevention" (general options).

> External notes

Troubleshooting page on compiz.org

See also
--------

-   Compiz Website -- including wiki and forum

Retrieved from
"https://wiki.archlinux.org/index.php?title=Compiz&oldid=253150"

Categories:

-   Eye candy
-   Stacking WMs
