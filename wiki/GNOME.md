GNOME
=====

> Summary

GNOME 3 provides a modern desktop, rewritten from scratch, using the
GTK3+ toolkit.

> Overview

The Xorg project provides an open source implementation of the X Window
System – the foundation for a graphical user interface. Desktop
environments such as Enlightenment, GNOME, KDE, LXDE, and Xfce provide a
complete graphical environment. Various window managers offer
alternative and novel environments, and may be used standalone to
conserve system resources. Display managers provide a graphical login
prompt.

> Related

GTK+

GDM

Nautilus

From About Us | GNOME:

The GNOME Project was started in 1997 by two then university students,
Miguel de Icaza and Federico Mena. Their aim: to produce a free (as in
freedom) desktop environment. Since then, GNOME has grown into a hugely
successful enterprise. Used by millions of people across the world, it
is the most popular desktop environment for GNU/Linux and UNIX-type
operating systems. The desktop has been utilised in successful,
large-scale enterprise and public deployments, and the project’s
developer technologies are utilised in a large number of popular mobile
devices.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installation                                                       |
|     -   2.1 Starting GNOME                                               |
|                                                                          |
| -   3 Using the shell                                                    |
|     -   3.1 GNOME cheat sheet                                            |
|     -   3.2 Restarting the shell                                         |
|     -   3.3 Shell crashes                                                |
|     -   3.4 Shell freezes                                                |
|                                                                          |
| -   4 Customizing GNOME appearance                                       |
|     -   4.1 Overall appearance                                           |
|         -   4.1.1 Gsettings                                              |
|         -   4.1.2 GNOME tweak tool                                       |
|         -   4.1.3 GTK3 theme via settings.ini                            |
|         -   4.1.4 Icon theme                                             |
|                                                                          |
|     -   4.2 Nautilus                                                     |
|     -   4.3 Totem                                                        |
|     -   4.4 GNOME panel                                                  |
|         -   4.4.1 Show date in top bar                                   |
|         -   4.4.2 Always show the "Log Out" entry in the user menu       |
|         -   4.4.3 Hiding icons in the top bar                            |
|             -   4.4.3.1 Hiding icons with shell extensions               |
|             -   4.4.3.2 Manually editing the GNOME panel script          |
|                                                                          |
|         -   4.4.4 Show battery icon                                      |
|         -   4.4.5 Disable "Suspend" in the status and gdm menu           |
|         -   4.4.6 Eliminate delay when logging out                       |
|         -   4.4.7 Show system monitor                                    |
|         -   4.4.8 Show weather information                               |
|                                                                          |
|     -   4.5 Activity view                                                |
|         -   4.5.1 Remove entries from Applications view                  |
|         -   4.5.2 To Remove Wine Launchers from the Applications menu    |
|         -   4.5.3 Change application icon size                           |
|         -   4.5.4 Change dash icon size                                  |
|         -   4.5.5 Change switcher (alt-tab) icon size                    |
|         -   4.5.6 Change system tray icon size                           |
|         -   4.5.7 Disable Activity hot corner hovering                   |
|         -   4.5.8 Disable Message Tray hovering                          |
|                                                                          |
|     -   4.6 Titlebar                                                     |
|         -   4.6.1 Remove title bar                                       |
|         -   4.6.2 Reduce title bar height                                |
|         -   4.6.3 Reorder titlebar buttons                               |
|         -   4.6.4 Hide titlebar when maximized                           |
|                                                                          |
|     -   4.7 Login screen                                                 |
|         -   4.7.1 Login background image                                 |
|         -   4.7.2 Larger font for login                                  |
|         -   4.7.3 Turning off the sound                                  |
|         -   4.7.4 Make the power button interactive                      |
|         -   4.7.5 Prevent suspend when closing the lid                   |
|         -   4.7.6 Change Critical Battery Level Action (for Laptops)     |
|         -   4.7.7 GDM keyboard layout                                    |
|                                                                          |
|     -   4.8 Other tips                                                   |
|                                                                          |
| -   5 Miscellaneous settings                                             |
|     -   5.1 Automatic program launch upon logging in                     |
|     -   5.2 Editing applications menu                                    |
|     -   5.3 Some 'System Settings' not preserved                         |
|     -   5.4 Disable sound effects in Terminal                            |
|     -   5.5 Move dialog windows                                          |
|     -   5.6 Show context menu icons                                      |
|     -   5.7 GNOME shell extensions                                       |
|     -   5.8 Default file browser/replace Nautilus                        |
|     -   5.9 Default PDF viewer                                           |
|     -   5.10 Default terminal                                            |
|     -   5.11 Middle mouse button                                         |
|     -   5.12 Display dimming                                             |
|     -   5.13 Alternate window manager                                    |
|                                                                          |
| -   6 Hidden features                                                    |
|     -   6.1 Changing hotkeys                                             |
|         -   6.1.1 Nautilus 3.4 and older                                 |
|                                                                          |
|     -   6.2 Shutdown via the status menu                                 |
|     -   6.3 Screencast recording                                         |
|     -   6.4 Modify Keyboard with XkbOptions                              |
|     -   6.5 Toggle keyboard layouts                                      |
|                                                                          |
| -   7 Integrated messaging (Empathy)                                     |
| -   8 Forcing fallback mode                                              |
| -   9 Troubleshooting                                                    |
|     -   9.1 When an extension breaks GNOME                               |
|     -   9.2 Extensions do not work after GNOME 3 update                  |
|     -   9.3 The "Windows" key                                            |
|     -   9.4 Keyboard Shortcut do not work with only conky running        |
|     -   9.5 X freezes with black screen after Gnome 3.8 upgrade          |
|     -   9.6 xf86-video-ati driver: flickers from time to time            |
|     -   9.7 Window opens behind other windows when using multiple        |
|         monitors                                                         |
|     -   9.8 Multiple monitors and dock extension                         |
|     -   9.9 No event sounds for Empathy and other programs               |
|     -   9.10 Gnome sets the keyboard layout to USA after every log in    |
|     -   9.11 Panels do not respond to right-click in fallback mode       |
|     -   9.12 "Show Desktop" keyboard shortcut does not work              |
|     -   9.13 Nautilus does not start                                     |
|     -   9.14 Epiphany does not play Flash videos                         |
|     -   9.15 Unable to apply stored configuration for monitors           |
|     -   9.16 Lock button fails to re-enable touchpad                     |
|     -   9.17 Unable to connect to secured Wi-Fi networks                 |
|     -   9.18 "Any command has been defined 33"                           |
|     -   9.19 GDM and GNOME use X11 cursors                               |
|     -   9.20 Tracker & Documents don't list any local files              |
|     -   9.21 Passwords are not remembered                                |
|     -   9.22 Windows can't be modified with Alt-Key + Mouse-Button       |
|     -   9.23 Gnome-shell 3.8.x fails to load with a black screen +       |
|         cursor                                                           |
|                                                                          |
| -   10 External links                                                    |
+--------------------------------------------------------------------------+

Introduction
------------

GNOME 3 has two interfaces:

-   GNOME Shell is the new standard layout using the Mutter window
    manager. It acts as a composite manager for the desktop, employing
    hardware graphics acceleration to provide effects aimed at reducing
    screen clutter.

-   Classic mode is the successor of the discontinued "fallback mode"
    starting with GNOME 3.8. It aims at implementing a more traditionnal
    desktop interface while using standard GNOME 3 technologies
    (including graphic acceleration). It does so through the use of
    pre-activated extensions and paramaters (see here for a list) and
    relies on llvmpipe for graphic acceleration. Hence it consists more
    of a customized GNOME Shell than a truly distinct mode.

GNOME-session automatically detects if your computer is incapable of
running GNOME Shell and starts Classic mode with llvmpipe when
appropriate.

Installation
------------

GNOME 3 is available in the official repositories and can be installed
with two groups of packages:

-   gnome contains the core desktop environment and applications
    required for the standard GNOME experience.

-   gnome-extra contains various optional tools such as a media player,
    a calculator, an editor and other non-critical applications that go
    well with the GNOME desktop. Installing this group is optional.

Note that installing only gnome-extra will not pull the whole gnome
group by dependencies: if you really want everything you must explicitly
install both groups.

> Starting GNOME

Graphical log-in

For the best desktop integration, login manager GDM is recommended.
Other login managers can be used in place of GDM. Check out the wiki
article on display managers to learn how desktop environments are
started.

The login manager is a limited process entrusted with duties that impact
the system. The PolicyKit wiki article addresses the topic of
system‑wide access control.

Tip:Refer to the GDM article for installation and configuration
instructions.

Starting GNOME manually

If you prefer to start GNOME manually from the console, add the
following line to your ~/.xinitrc file:

    ~/.xinitrc

     exec gnome-session

After the exec command is placed, GNOME can be launched by typing
startx.

See xinitrc for details, such as preserving the logind (and/or
consolekit) session.

Using the shell
---------------

> GNOME cheat sheet

The GNOME web site has a helpful GNOME Shell cheat sheet explaining task
switching, keyboard use, window control, the panel, overview mode, and
more.

> Restarting the shell

After appearance tweaks you are often asked to restart the GNOME shell.
You could log out and log back in, but it is simpler and faster to issue
the following keyboard command. Restart the shell by pressing Alt + F2
then r then Enter

> Shell crashes

Certain tweaks and/or repeated shell restarts may cause the shell to
crash when a restart is attempted. In this case, you are informed about
the crash and then forced to log out. Some shell changes, such as
switching between GNOME Shell and fallback mode, cannot be accomplished
via a keyboard restart; you must log out and log back in to effect them.

It is common sense — but worth repeating — that valuable documents
should be saved (and perhaps closed) before attempting a shell restart.
It is not strictly necessary; open windows and documents usually remain
intact after a shell restart.

> Shell freezes

Sometimes shell extensions freeze the GNOME Shell. In this case a
possible strategy is to switch to another terminal via Ctrl+Alt+F2
through Ctrl+Alt+F6, log in, and restart gnome-shell with:

    # pkill -HUP gnome-shell

All open applications will still be available after restarting the
shell.

Sometimes, however, merely restarting the shell might not be enough.
Then you will have to restart X, losing all work in progress. You can
restart X by:

    # pkill X

The GNOME Shell then restarts automatically.

If this doesn't work, you can try to restart your login manager. For
instance, if you use GDM, try:

    # systemctl restart gdm.service

Tip:You can also use htop in tty; press t, select the gnome-shell tree,
press k and send SIGKILL.

Customizing GNOME appearance
----------------------------

> Overall appearance

GNOME 3 may have "started from scratch", but like most large software
projects it is assembled from parts dating to different eras. There is
not one all-encompassing configuration tool. The new Systems Settings
tool is a big improvement over previous control panels. System Settings
is well-organized, but you may find yourself wishing for more control
over system appearance.

You may be familiar with existing configuration tools: some of these
still work; many will not. Some settings are not readily exposed for you
to change. Indubitably, many settings will migrate to newer tools and/or
become exposed as time progresses and the wider community embraces and
extends the latest GNOME desktop.

Gsettings

A new command-line tool gsettings stores data in a binary format, unlike
previous tools using XML text. A tutorial Customizing the GNOME Shell
explores the power of gsettings.

GNOME tweak tool

This graphical tool customizes fonts, themes, titlebar buttons and other
settings.

    # pacman -S gnome-tweak-tool

GTK3 theme via settings.ini

Like ~/.gtkrc-2.0 with GTK2+, it is possible to set a GTK3 theme via
${XDG_CONFIG_HOME}/gtk-3.0/settings.ini.

Variable $XDG_CONFIG_HOME is usually set to ~/.config

Adwaita, the default GNOME 3 theme, is a part of gnome-themes-standard.
Additional GTK3 themes can be found at Deviantart web site. For example:

    ${XDG_CONFIG_HOME}/gtk-3.0/settings.ini

    [Settings]
    gtk-theme-name = Adwaita
    gtk-fallback-icon-theme = gnome
    # next option is applicable only if selected theme supports it
    gtk-application-prefer-dark-theme = true
    # set font name and dimension
    gtk-font-name = Sans 10

It is necessary to restart the GNOME shell for settings to be applied.
More GTK options are found at GNOME developer documentation.

Icon theme

Using gnome-tweak-tool version 3.0.3 and later, you can place any icon
theme you wish to use inside ~/.icons.

Usefully, GNOME 3 is compatible with GNOME 2 icon themes, which means
you are not stuck with the default icons. To install a new set of icons,
copy your desired icon theme's directory to ~/.icons. As an example:

    $ cp -R /home/user/Desktop/my_icon_theme ~/.icons

The new theme my_icon_theme is now selectable using gnome-tweak-tool
under interface.

Alternatively, you may textually select your icon theme with no need for
gnome-tweak-tool. Add the GTK icon theme name to
${XDG_CONFIG_HOME}/gtk-3.0/settings.ini. Please note, not to use "" as
your settings would not be recognised then.

    ${XDG_CONFIG_HOME}/gtk-3.0/settings.ini

    ... previous lines ...

    gtk-icon-theme-name = my_new_icon_theme

> Nautilus

See Nautilus.

> Totem

To play back h.264 videos, you need to install gst-libav

For more information on gstreamer hardware acceleration, see Gstreamer:
Hardware Acceleration.

> GNOME panel

Show date in top bar

By default GNOME displays only the weekday and time in the top bar. This
can be changed with the following command. Changes take effect
immediately.

GNOME 3.4.2:

    # gsettings set org.gnome.shell.clock show-date true

GNOME 3.6.2:

    # gsettings set org.gnome.desktop.interface clock-show-date true

Always show the "Log Out" entry in the user menu

Since GNOME 3.6, the "Log Out" entry in the user menu is only shown when
multiple non-root users are present in the system.

To always enable this entry, run the following command from a terminal:

    # gsettings set org.gnome.shell always-show-log-out true

You can also change this in dconf-editor: Navigate to org.gnome.shell,
then check the "always-show-log-out" checkbox.

Then, restart the GNOME shell:

1.  Alt+F2
2.  r
3.  Enter

Hiding icons in the top bar

When doing a GNOME install, some unwanted icons might appear in the
panel. These icons can be removed either with GNOME shell extensions or
by manually editing the GNOME panel script.

Hiding icons with shell extensions

To remove the accessibility icon, one can use the
https://extensions.gnome.org/extension/112/remove-accesibility/.

The best way to use extensions is installing them from the gnome
extensions web page like the one above.

Manually editing the GNOME panel script

For example, to remove the universal access icon, comment out the 'a11y'
line in PANEL_ITEM_IMPLEMENTATIONS:

    /usr/share/gnome-shell/js/ui/panel.js

    const PANEL_ITEM_IMPLEMENTATIONS = {
        'activities': ActivitiesButton,
        'appMenu': AppMenuButton,
        'dateMenu': imports.ui.dateMenu.DateMenuButton,
    //    'a11y': imports.ui.status.accessibility.ATIndicator,
        'volume': imports.ui.status.volume.Indicator,
        'battery': imports.ui.status.power.Indicator,
        'lockScreen': imports.ui.status.lockScreenMenu.Indicator,
        'keyboard': imports.ui.status.keyboard.InputSourceIndicator,
        'powerMenu': imports.gdm.powerMenu.PowerMenuButton,
        'userMenu': imports.ui.userMenu.UserMenuButton
    };

Then, save your results and restart the shell:

1.  Alt+F2
2.  r
3.  Enter

Show battery icon

To show the battery tray icon, install gnome-power-manager from the
official repositories.

Disable "Suspend" in the status and gdm menu

A quick way to do it system-wide for GNOME 3.2 is to change line 539 of
/usr/share/gnome-shell/js/ui/userMenu.js and line 103 of
/usr/share/gnome-shell/js/gdm/powerMenu.js. (For GNOME versions prior to
3.2, look at line 153 of /usr/share/gnome-shell/js/ui/statusMenu.js.)
This change takes effect the next time GNOME Shell is started.

    /usr/share/gnome-shell/js/ui/userMenu.js

     // this._haveSuspend = this._upClient.get_can_suspend();  //  Comment this line out.
     this._haveSuspend = false;                                //  Use this line instead.

To accomplish this, paste the following command(s) in your terminal:

     GNOME_SHELL=/usr/share/gnome-shell
     SCRIPTS=`grep -lr get_can_suspend $GNOME_SHELL/js`
     for FILE in $SCRIPTS ; do
           sed -r -i -e 's/[^= ]+.get_can_suspend\(\)/false/' "$FILE"
     done

The above change does not persist after a GNOME version update, however.
A more perennial solution is to add the code above in some gdm or system
startup script (eg: /etc/rc.local), to keep the "suspend" option
disabled after updates.

Alternatively you can install the GNOME shell extension
alternative status menu in package
gnome-shell-extension-alternative-status-menu.

Eliminate delay when logging out

The following tweak removes the confirmation dialog and sixty second
delay for logging out.

This dialog normally appears when you log out with the status menu. This
tweak affects the Power Off dialog as well. This is not a system-wide
change; it affects only the user who enters this command. The change
takes effect immediately after entering the command.

    $ gsettings set org.gnome.SessionManager logout-prompt 'false'

Show system monitor

Install the gnome-shell-system-monitor-applet-git extension available in
the AUR.

Show weather information

Install gnome-shell-extension-weather-git from AUR.

> Activity view

Remove entries from Applications view

Like other desktop environments, GNOME uses .desktop files to populate
its Applications view. These text files are in /usr/share/applications.
It is not possible to edit these files from a folder view ‒ Nautilus
does not treat their icons as text files. Use a terminal to display or
edit .desktop file entries.

    # ls /usr/share/applications
    # nano /usr/share/applications/foo.desktop

For system wide changes, edit files in /usr/share/applications. For
local changes, make a copy of foo.desktop in your home folder.

    $ cp /usr/share/applications/foo.desktop ~/.local/share/applications/

Edit .desktop files to fit your wishes.

Note:Removing a .desktop file does not uninstall an application, but
instead removes its desktop integration: MIME types, shortcuts, and so
forth.

The following command appends one line to a .desktop file and hides its
associated icon from Applications view:

    $ echo "NoDisplay=true" >> foo.desktop

To Remove Wine Launchers from the Applications menu

Enter ~/.local/share/applications/wine/Programs/ and look for the wine
application's name. In the directories are the ".desktop" files which
configure the launchers. Remove the program directory to easily remove
the launchers.

Change application icon size

One awkward selection of the GNOME designers is their choice of large
icons for Applications view. This view is painful when working with a
small screen containing many large application icons. There is a way to
reduce the icon size. It is done by editing the GNOME-Shell theme.

Edit system files directly (make a backup first) or copy theme files to
your local folder and edit these files.

-   For the default theme, edit
    /usr/share/gnome-shell/theme/gnome-shell.css

-   For user themes, edit
    /usr/share/themes/<UserTheme>/gnome-shell/gnome-shell.css

Edit gnome-shell.css and replace the following values. Afterward,
restart the GNOME shell.

    gnome-shell.css

     ...
     /* Application Launchers and Grid */
     
     .icon-grid {
         spacing: 18px;
         -shell-grid-horizontal-item-size: 82px;
         -shell-grid-vertical-item-size: 82px;
     }
     
     .icon-grid .overview-icon {
         icon-size: 48px;
     }
     ...

Change dash icon size

GNOME's Activities view has a dash on the left hand side, the size of
the icons in this dash will scale depending on the amount of icons set
to display. The scaling can be manipulated or set to a constant icon
size. To do so, edit /usr/share/gnome-shell/js/ui/dash.js.

    dash.js

     ...

            let iconSizes = [ 16, 22, 24, 32, 48, 64 ];

     ...

Change switcher (alt-tab) icon size

GNOME comes with a built in task switcher, the size of the icons in this
task switcher will scale depending on the amount of icons set to
display. The scaling can be manipulated or set to a constant icon size.
To do so, edit /usr/share/gnome-shell/js/ui/altTab.js

    altTab.js

     ...

            const iconSizes = [96, 64, 48, 32, 22];

     ...

Change system tray icon size

GNOME comes with a built in system tray, visible when the mouse is
hovered over the bottom right corner of the screen. The size of the
icons in this tray is set to a fixed value of 24. To change this value,
edit /usr/share/gnome-shell/js/ui/messageTray.js

    messageTray.js

     ...

        ICON_SIZE: 24,

     ...

Disable Activity hot corner hovering

To disable automatic activity view when the hot corner is hovered, edit
/usr/share/gnome-shell/js/ui/layout.js (that was panel.js in GNOME
3.0.x) :

    layout.js

     this._corner = new Clutter.Rectangle({ name: 'hot-corner',
                                           width: 1,
                                           height: 1,
                                           opacity: 0,
                                           reactive: true });icon-size: 48px;
     }

and set reactive to false. GNOME Shell needs to be restarted.

Disable Message Tray hovering

The message tray is shown when the mouse hovers at the bottom of the
screen for one second. To disable this behavior, comment out the
following line in /usr/share/gnome-shell/js/ui/messageTray.js:

    messageTray.js

            //pointerWatcher.addWatch(TRAY_DWELL_CHECK_INTERVAL, Lang.bind(this, this._checkTrayDwell));

GNOME Shell needs to be restarted. The message tray is still visible in
activity view.

> Titlebar

Remove title bar

Install Maximus GNOME shell extension.

It can also have white list / black list of application.

This extension requires xorg-xprop, install it if you don't have it
already.

    pacman -S xorg-xprop

More about GNOME shell extensions.

Reduce title bar height

-   global - edit
    /usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml, search
    for title_vertical_pad and and reduce its value to a minimum of 0.
-   user-only - copy
    /usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml to
    /home/$USER/.themes/Adwaita/metacity-1/metacity-theme-3.xml, search
    for title_vertical_pad and reduce its value to a minimum of 0.

Then Restart the GNOME shell.

To restore the original values, install the package
gnome-themes-standard from the official repositories or remove
/home/$USER/.themes/Adwaita/metacity-1/metacity-theme-3.xml

Reorder titlebar buttons

At present this setting can be changed through dconf-editor.

For example, we move the close and minimize buttons to the left side of
the titlebar. Open dconf-editor and locate the
org.gnome.shell.overrides.button_layout key. Change its value to
close,minimize: (Colon symbol designates the spacer between left side
and right side of the titlebar.) Use whichever buttons in whatever order
you prefer. You cannot use a button more than once. Also, keep in mind
that certain buttons are deprecated. Restart the shell to see your new
button arrangement.

Hide titlebar when maximized

    # sed -i -r 's|(<frame_geometry name="max")|\1 has_title="false"|' /usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml

Restart the GNOME shell. After this tweak, you may find it difficult to
un-maximize a window when there is no titlebar to grab.

With suitable keybindings, you should be able to use Alt+F5, Alt+F10 or
Alt+Space to remedy the situation.

To prevent metacity-theme-3.xml from being overwritten each time package
gnome-themes-standard is upgraded, add its name to /etc/pacman.conf with
NoUpgrade.

    /etc/pacman.conf

    ... previous lines ...

    # Pacman won't upgrade packages listed in IgnorePkg and members of IgnoreGroup
    # IgnorePkg   =
    # IgnoreGroup =

    NoUpgrade = usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml    # Do not add a leading slash to the path

    ... more lines ...

To restore original Adwaita theme values, install the
gnome-themes-standard package.

> Login screen

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with GDM.        
                           Notes: Login managers    
                           have their own wiki      
                           pages and information    
                           should be maintained     
                           separately. (Discuss)    
  ------------------------ ------------------------ ------------------------

To modify characteristics of the login screen (GDM, the GNOME display
manager) the following lines can be executed. The first command allows
all users, including "gdm", to access X settings (albeit temporarily).
This command creates a temporary vulnerability, so be advised. The
second command opens a bash session with the credentials of user "gdm".

Note:For exposition, user gdm's terminal prompt is shown as $. In
actuality, it shows something like -bash-4.2$.

    # xhost +
    # su - gdm -s /bin/bash
    $ dbus-launch

The third command prints DBUS_SESSION_BUS_ADDRESS and
DBUS_SESSION_BUS_PID. We must export these variables. Either manually
export the below two variables shown in the output of dbus-launch like
this:

    $ export DBUS_SESSION_BUS_ADDRESS=unix:abstract=/tmp/dbus-Jb433gMQHS,guid=fc14d4bf3d000e38276a5a2200000d38
    $ export DBUS_SESSION_BUS_PID=4283

Or use the follow command:

    $ `dbus-launch | sed "s/^/export /"`

Check to see if dconf-service is running and if not, start it like this

    $ /usr/lib/dconf/dconf-service &

Login background image

Once session variables have been exported as explained above, you may
issue commands to retrieve or set items used by GDM.

The easiest way to changes all the settings is by launching the
Configuration Editor gui with the command

    $ dconf-editor

The location of each setting is the same as in the command line style of
configuration shown below:

The following is the command-line approach to retrieve or set the file
name used for GDM's wallpaper.

     $  GSETTINGS_BACKEND=dconf gsettings get org.gnome.desktop.background picture-uri
     $  GSETTINGS_BACKEND=dconf gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/SundownDunes.jpg'
     
     $  GSETTINGS_BACKEND=dconf gsettings set org.gnome.desktop.background picture-options 'zoom'
     ## Possible values: centered, none, scaled, spanned, stretched, wallpaper, zoom

Note:You must specify a file which user "gdm" has permission to read.
GDM cannot read files in your home directory.

An alternative graphical interface to changing themes (gtk3, icons and
cursor), the wallpaper and minor other settings of the GDM login screen,
you can install gdm3setup from AUR.

Larger font for login

This tweak enlarges the login font with a scaling factor. It is the same
method employed by Accessibility Manager on the desktop.

You must export the GDM session variables before performing this tweak.

    $ GSETTINGS_BACKEND=dconf gsettings set org.gnome.desktop.interface text-scaling-factor '1.25'

Turning off the sound

This tweak disables the audible feedback heard when the system volume is
adjusted (via keyboard) on the login screen. You must first export the
GDM session variables.

    $ GSETTINGS_BACKEND=dconf gsettings set org.gnome.desktop.sound event-sounds 'false'

If the above tweak does not work for you or you are unable to export the
GDM session variables, there is always the easiest solution to the
"ready sound" problem: mute or lower the sound while in GDM login screen
using the media keys (if available) of your keyboard.

Make the power button interactive

The default installation sets the power button to suspend the system.
Power off or Show dialog is a better choice. You must first export the
GDM session variables as outlined previously.

     $ GSETTINGS_BACKEND=dconf gsettings set org.gnome.settings-daemon.plugins.power button-power 'interactive'
     $ GSETTINGS_BACKEND=dconf gsettings set org.gnome.settings-daemon.plugins.power button-hibernate 'interactive'
     $ gsettings list-recursively org.gnome.settings-daemon.plugins.power

Warning:Please note that the acpid daemon also handle the "power button"
an "hibernate button" event. Running both systems at the same time may
lead to unexpected behaviour.

Prevent suspend when closing the lid

On some systems it happens that your laptop suspends when you are
closing the lid despite having set the options Laptop lid close action
on battery and Laptop lid close action on AC to blank. If this is the
case, append the following line to /etc/systemd/logind.conf:

    HandleLidSwitch=ignore

Change Critical Battery Level Action (for Laptops)

The gnome-power-manager gui doesn't have a choice for "do nothing" on
laptops at critical battery level. To manually edit this, open the
dconf-editor -> org -> gnome -> settings-daemon -> plugins -> power.
Edit the "critical-battery-action" value to "nothing".

GDM keyboard layout

GDM does not know about your GNOME 3 desktop keyboard settings. To
change keyboard settings used by GDM, set your layout using Xorg
configuration. Refer to this section of the Beginner's Guide.

> Other tips

See GNOME Tips.

Miscellaneous settings
----------------------

> Automatic program launch upon logging in

Specify which programs start automatically after logging in using
gnome-session-properties. This tool is part of the gnome-session
package.

    $ gnome-session-properties

> Editing applications menu

gnome-menus provides gmenu-simple-editor which can show/hide menu
entries.

alacarte provides a more complete menu editor for adding/editing menu
entries.

> Some 'System Settings' not preserved

GNOME 3 is using systemd (an init daemon for Linux) with more modern
capabilities. Previously GNOME programs were altered to use Arch's init
functionalities to gather settings but either the maintenance required
to do this or possibly this is because of a transitioning to the new
init system (read more about this here). Areas that settings will not be
preserved are Date and Time and adding ICC profiles in the Color menu
and possibly others.

To gain the functionality back, systemd needs to be installed and the
gdm.service and NetworkManager.service services need to be enabled.

> Disable sound effects in Terminal

By default the terminal has these annoying sound effects when e.g.
pushing the tab button on your keyboard. One solution is to turn off or
mute all sound effects in the settings menu of Gnome. However, this will
also turn off notification sounds in other application such as Skype. A
better solution is to open a terminal, go to Edit -> Profile Preferences
-> General and untick Terminal bell.

> Move dialog windows

The default configuration for dialogs will not allow you to move them
which causes problems in some cases. To change this you will need to use
gconf-editor and change this setting:

    /desktop/gnome/shell/windows/attach_modal_dialogs

After the change you will need to restart the shell for it to take
affect.

> Show context menu icons

Some programs do have context menu icons which, however, are disabled by
default to show up in Gnome. In order to show them set
 org.gnome.desktop.interface menus-have-icons to true.

> GNOME shell extensions

GNOME Shell can be customized with extensions. These provide features
such as a dock or a widget for changing the theme.

Many extensions are collected and hosted by extensions.gnome.org. They
can be browsed and installed simply activating them in the browser. More
information about gnome shell extensions can be found here.

See when an extension breaks GNOME for troubleshooting information.

> Default file browser/replace Nautilus

You can trick GNOME into using another file browser by editing the Exec
line in /usr/share/applications/nautilus.desktop. See the correct
parameters in the .desktop file of the file manager of your choice,
e.g.:

    /usr/share/applications/nautilus.desktop

    [...]
    Exec=thunar %F
    OR
    Exec=pcmanfm %U
    OR
    Exec=nemo %U
    [...]

> Default PDF viewer

In some cases when you have installed Inkscape or other graphic programs
Evince Document Viewer might no longer be selected as the default PDF
application. If it is not available in the Open With entry which would
be the GUI solution, you can use the following user command to make it
the default application again.

    xdg-mime default evince.desktop application/pdf

> Default terminal

gsettings (which replaces gconftool-2) is used to set the default
terminal. The setting affects nautilus-open-terminal (a Nautilus
extension). To make urxvt the default, run:

    gsettings set org.gnome.desktop.default-applications.terminal exec urxvtc
    gsettings set org.gnome.desktop.default-applications.terminal exec-arg "'-e'"

Note:The -e flag is for executing a command. When nautilus-open-terminal
invokes urxvtc, it puts a cd command at the end of the command line so
that the new terminal starts in the directory you opened it from. Other
terminals will require a different (perhaps empty) exec-arg.

> Middle mouse button

By default, GNOME 3 disables middle mouse button emulation regardless of
Xorg settings (Emulate3Buttons). To enable middle mouse button emulation
use:

    $ gsettings set org.gnome.settings-daemon.peripherals.mouse middle-button-enabled true

> Display dimming

By default GNOME 3 has a ten second idle timeout to dim the screen
regardless of the battery and AC state:

    gsettings get org.gnome.settings-daemon.plugins.power idle-dim-time

To set a new value type the following

    gsettings set org.gnome.settings-daemon.plugins.power idle-dim-time <int>

where <int> is the value in seconds

> Alternate window manager

You can use an alternate window manager with GNOME by forcing fallback
mode and creating two files:

Note:Xmonad is used as an example, but this works for other window
managers.

    /usr/share/gnome-session/sessions/xmonad.session

    [GNOME Session]
    Name=Xmonad session
    RequiredComponents=gnome-panel;gnome-settings-daemon;
    RequiredProviders=windowmanager;notifications;
    DefaultProvider-windowmanager=xmonad
    DefaultProvider-notifications=notification-daemon

    /usr/share/xsessions/xmonad-gnome-session.desktop

    [Desktop Entry]
    Name=Xmonad GNOME
    Comment=Tiling window manager
    TryExec=/usr/bin/gnome-session
    Exec=gnome-session --session=xmonad
    Type=XSession

The next time you log in, you should have the ability to choose Xmonad
GNOME as your session.

If there isn't a .desktop file for the window manager, you'll need to
create one. Example for wmii:

    /usr/share/applications/wmii.desktop

    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=wmii
    TryExec=wmii
    Exec=wmii

For more information, see this article on running awesome as the window
manager in GNOME.

Hidden features
---------------

GNOME 3 hides many useful options which you can customize with
dconf-editor. GNOME 3 also supports gconf-editor for settings that have
not yet migrated to dconf.

> Changing hotkeys

It is possible to manually change the keys via an application's
so-called accel map file. Where it is to be found is up to the
application: For instance, Thunar's is at ~/.config/Thunar/accels.scm,
whereas Nautilus's is located at ~/.config/nautilus/accels and
~/.gnome2/accels/nautilus on old release.

The file should contain a list of possible hotkeys, each unchanged line
commented out with a leading ";" that has to be removed for a change to
become active. For example to replace the hotkey used by Nautilus to
move files to the trash folder, change the line :

    ; (gtk_accel_path "<Actions>/DirViewActions/Trash" "<Primary>Delete")

to this :

    (gtk_accel_path "<Actions>/DirViewActions/Trash" "Delete")

The file is regenerate regularly so don't waist time on commenting the
file. The uncommented line will stay but every comment you may add will
be lost.

Nautilus 3.4 and older

Firstly, use dconf-editor to place a checkmark next to can-change-accels
in the key named org.gnome.desktop.interface.

We will replace the hotkey — a.k.a. keyboard shortcut, keyboard
accelerator — used by Nautilus to move files to the trash folder. The
default assignment is a somewhat-awkward Ctrl+Delete.

-   Open Nautilus, select any file, and click Edit on the menu bar.
-   Hover over the Move to Trash menu item.
-   While hovering, press Delete. The current accelerator is now unset.
-   Press the key that you wish to become the new keyboard accelerator.
-   Press Delete to make the new accelerator be the Delete key.

Unless you select a file or folder, Move to Trash will be grayed-out.
Finally, disable can-change-accels to prevent accidental hotkey changes.

> Shutdown via the status menu

Currently, the GNOME designers have hidden the Shutdown option inside
the status menu. To shut down your system with the status menu, click
the menu and hold down the Alt key so that the Suspend item changes to
Power Off. The subsequent dialog allows you to shut down or restart your
system.

If you disable the Suspend menu item system-wide as described elsewhere
in this document you do not have to go through these motions.

Another option is to install the Alternative Status Menu extension. See
the section on shell extensions. The alternative menu extension installs
a new status menu with a non-hidden Power Off entry.

> Screencast recording

Gnome features the built-in possbility to create screencasts easily.
Thereby Control+Shift+Alt+R keybinding starts and stops the recording. A
red circle is displayed in the bottom right corner of the screen when
the recording is in progress. After the recording is finished, a file
named 'Screencast from %d%u-%c.webm' is saved in the Videos directory.
In order to use the screencast feature you need to have installed the
gst plugins which are:

    $ pacman -Qs gst

> Modify Keyboard with XkbOptions

Using the dconf-editor, navigate to the key named
org.gnome.desktop.input-sources.xkb-options and add desired XkbOptions
(e.g. 'caps:swapescape') to the list.

See /usr/share/X11/xkb/rules/xorg for all XkbOptions and then
/usr/share/X11/xkb/symbols/* for the respective descriptions.

> Toggle keyboard layouts

Since Gnome does not consider any configuration in
/etc/X11/conf.d/*.conf you have to set the command for layout switching
either via the control center with the options Switch to previous source
and Switch to next source or if you want to use Alt - Shift combination
you have to use the Gnome-Tweak-Tool and set Typing -> Modifiers-only
input sources -> select Alt-shift. For more information see also the
forum thread.

Integrated messaging (Empathy)
------------------------------

Empathy, the engine behind integrated messaging, and all system settings
based on messaging accounts will not show up unless the telepathy group
of packages or at least one of the backends (telepathy-gabble, or
telepathy-haze, for example) is installed.

These packages are not included in default Arch GNOME installs. You can
install the Telepathy and optionally any backends with:

    # pacman -S telepathy

Without telepathy, Empathy will not open the account management dialog
and can get stuck in this state. If this happens -- even after quitting
Empathy cleanly -- the /usr/bin/empathy-accounts application can remain
running and will need to be killed before you can add any new accounts.

View descriptions of telepathy components on the Freedesktop.org
Telepathy Wiki.

Forcing fallback mode
---------------------

Your session automatically starts in fallback mode when gnome-shell is
not present, or when your hardware cannot handle graphics acceleration —
such as running within a virtual machine or running on old hardware.

If you wish to enable fallback mode while still having gnome-shell
installed, make the following system change:

Go to System Settings (gnome-control-center) -> Details -> Graphics and
set Forced Fallback Mode to ON.

You can alternatively choose the type of session from a terminal with
gsettings:

    $ gsettings set org.gnome.desktop.session session-name gnome-fallback

You may want to log out after making the change. You will see the chosen
type of session upon your next login.

To disable the forced-fallback mode change it back to gnome.

Troubleshooting
---------------

> When an extension breaks GNOME

When enabling shell extensions causes GNOME breakage, you should first
remove the user-theme and auto-move-windows extensions from their
installation directory.

The installation directory could be one of
~/.local/share/gnome‑shell/extensions,
/usr/share/gnome‑shell/extensions, or
/usr/local/share/gnome‑shell/extensions. Removing these two
extension-containing folders may fix the breakage. Otherwise, isolate
the problem extension with trial‑and‑error.

Removing or adding an extension-containing folder to the aforementioned
directories removes or adds the corresponding extension to your system.
Details on GNOME Shell extensions are available at the GNOME web site.

> Extensions do not work after GNOME 3 update

Locate the folder where your extensions are installed. It might be
~/.local/share/gnome-shell/extensions or
/usr/share/gnome-shell/extensions.

Edit each occurrence of metadata.json which appears in each extension
sub-folder.

  --------------------------- --------------------------
  Insert:                     "shell-version": ["3.6"]
  Instead of (for example):   "shell-version": ["3.4"]
  --------------------------- --------------------------

  
 "3.x" indicates the extension works with every Shell version. If it
breaks, you'll know to change it back.

> The "Windows" key

By default, this key is mapped to the "overlay-key" to launch the
Overview. You can remove this key mapping to free up your Windows Key
(also called Mod4), which GNOME calls Super_L, by utilizing gsettings.

Example:  gsettings set org.gnome.mutter overlay-key 'Foo';. You can
leave out Foo to simply remove any binding to that function.

Note: GNOME also uses Alt+F1 to launch the Overview.

> Keyboard Shortcut do not work with only conky running

The gnome-shell keyboard shortcuts like Alt+F2, Alt+F1, and the media
key shortcuts do not work if conky is the only program running. However
if another application like gedit is running, then the keyboard
shortcuts work.

solution: edit .conkyrc

    own_window yes
    own_window_transparent yes
    own_window_argb_visual yes
    own_window_type dock
    own_window_class Conky
    own_window_hints undecorated,below,sticky,skip_taskbar,skip_pager

> X freezes with black screen after Gnome 3.8 upgrade

Possibly you don't have SNA enabled. Therefore, just add SNA
acceleration like written here.

> xf86-video-ati driver: flickers from time to time

If you use that driver, your desktop might flicker a lot when you hover
the bottom right corner, and also when you start up gdm. Write the
following in your /etc/X11/xorg.conf.d/20-radeon.conf and see if it
works then:

    Section "Device"
           Identifier "Radeon"
           Driver "radeon"
           Option "EnablePageFlip" "off"
    EndSection

https://wiki.archlinux.org/index.php/Intel_Graphics#Choose_acceleration_method

> Window opens behind other windows when using multiple monitors

This is possibly a bug in GNOME Shell which causes new windows to open
behind others. Unchecking "workspaces_only_on_primary" in
desktop/gnome/shell/windows using gconf-editor solves this problem.

> Multiple monitors and dock extension

If you have multiple monitors configured using Nvidia Twinview, the dock
extension may get sandwiched in-between the monitors. You can edit the
source of this extension to reposition the dock to a position of your
choosing.

Edit
/usr/share/gnome-shell/extensions/dock@gnome-shell-extensions.gnome.org/extension.js
and locate this line in the source:

    this.actor.set_position(primary.width-this._item_size-this._spacing-2, (primary.height-height)/2);

The first parameter is the X position of the dock display, by
subtracting 15 pixels as opposed to 2 pixels from this it correctly
positioned on my primary monitor, you can play around with any X,Y
coordinate pair to position it correctly.

    this.actor.set_position(primary.width-this._item_size-this._spacing-15, (primary.height-height)/2);

> No event sounds for Empathy and other programs

If you are using OSS, you may want to install libcanberra-oss from the
AUR.

> Gnome sets the keyboard layout to USA after every log in

See the [this] bug report for more information. It is related to GDM and
can be fixed by choosing the correct layout at GDM login startup.
However, users who do not use GDM or any login manager but a pure startx
approach have to use a workaround. Create the file ~/.keyboard and make
it executable chmod +x:

    # Set the correct keyboard layout after Gnome start
    setxkbmap -layout "us,pl" -variant altgr-intl -option "grp:alt_shift_toggle" nodeadkeys

Now run gnome-session-properties and add this .keyboard file to the
programs run at startup:

    Name: Keyboard layout 
    Command: /home/username/.keyboard
    Comment: Sets the correct keyboard layout after Gnome start

Further you need to create the executable file
/etc/pm/sleep.d/90_keyboard with the following content in order to run
the script on resume from suspend and hibernation.

    #!/bin/bash
    case $1 in
        resume|thaw)
            /home/username/.keyboard
            ;;
    esac

> Panels do not respond to right-click in fallback mode

Check Configuration Editor:
/apps/metacity/general/mouse_button_modifier. This modifier key (Alt,
Super, etc) used for normal windows is also used by panels and their
applets.

> "Show Desktop" keyboard shortcut does not work

GNOME developers treated the corresponding binding as bug (see
https://bugzilla.gnome.org/show_bug.cgi?id=643609) due to Minimization
being deprecated. To show the desktop again assign ALT+STRG+D to the
following setting:

    System Settings --> Keyboard --> Shortcuts --> Navigation --> Hide all normal windows

> Nautilus does not start

1.  Press Alt+F2
2.  Enter gnome-tweak-tool
3.  Select the File Manager tab.
4.  Locate option Have file manager handle the desktop and assure it is
    toggled off.

> Epiphany does not play Flash videos

Adobe Flash Player is buggy and does not work directly in Epiphany. See
Epiphany#Flash for a workaround involving nspluginwrapper.

> Unable to apply stored configuration for monitors

If you encounter this message try to disable the xrandr
gnome-settings-daemon plugin :

    $ dconf write /org/gnome/settings-daemon/plugins/xrandr/active false

> Lock button fails to re-enable touchpad

Some laptops have a touchpad lock button that disables the touchpad so
that users can type without worrying about touching the touchpad. It
appears currently that although GNOME can lock the touchpad by pressing
this button, it cannot unlock it. If the touchpad gets locked you can do
the following to unlock it.

1.  Start a terminal. You can do this by pressing Alt+F2, then typing
    gnome-terminal followed by pressing Enter.
2.  Type in the following command

    $ xinput set-prop "SynPS/2 Synaptics TouchPad" "Device Enabled" 1

> Unable to connect to secured Wi-Fi networks

You can see the network connections listing, but choosing an encrypted
network fails to show a dialog for key entry. You may need to install
network-manager-applet. See GNOME NetworkManager setup.

> "Any command has been defined 33"

When you press the Print Screen key (sometimes labeled PrntScr or PrtSc)
to take a screenshot, and you got "Any command has been defined 33",
install metacity.

> GDM and GNOME use X11 cursors

To fix this issue, become root and put the following into
/usr/share/icons/default/index.theme (creating the directory
/usr/share/icons/default if necessary):

    /usr/share/icons/default/index.theme

    [Icon Theme]
    Inherits=Adwaita

Note: Instead of "Adwaita", you can choose another cursor theme (e.g.
Human). Alternatively, you can install gnome-cursors-fix from the AUR.

> Tracker & Documents don't list any local files

In order for Tracker (and, therefore, Documents) to detect your local
files, they must be stored in directories that it knows of. If your
documents are contained in one of the usual XDG standard directories
(i.e. "Documents" or "Music"), you should install xdg-user-dirs and run:

     # xdg-user-dirs-update

This will create all of the usual XDG home directories if they don't
already exist and it will create the config file definining these
directories that Tracker and Documents depend upon.

> Passwords are not remembered

If you get a password prompt every time you login, and you find password
are not saved, you might need to create/set a default keyring:

    $ pacman -S seahorse

Open "Passwords and Keys" from the menu or run "seahorse". Select View >
By Keyring. If there is no keyring in the left column (it will be marked
with a lock icon), go to File > New > Password Keyring and give it a
nice name. You will be asked to enter a password. If you do not give it
a password it will be unlocked automatically even when using autologin,
but passwords will not be stored securely. Finally, right-click on the
keyring you just created and select "Set as default".

> Windows can't be modified with Alt-Key + Mouse-Button

Change the dconf-setting
"org.gnome.desktop.wm.preferences.mouse-button-modifier" from <Super>
back to <Alt>. It is not possible to change this with System Settings >
"Keyboard" > "Shortcuts", you will find there only the regular
keybindings. The developers of GNOME decided to change this from 3.4 to
3.6 because of this bug report
https://bugzilla.gnome.org/show_bug.cgi?id=607797

> Gnome-shell 3.8.x fails to load with a black screen + cursor

If you have a non-UTF8 language enabled, Gnome 3 can fail to load.
Disable non-UTF-8 locales and perform a locale-gen until this is
resolved. For more information see this bug report:
https://bugzilla.gnome.org/show_bug.cgi?id=698952

External links
--------------

-   The Official Website of GNOME
-   Extensions for GNOME-shell
-   Themes, icons, and backgrounds:
    -   GNOME Art
    -   GNOME Look

-   GTK/GNOME programs:
    -   GNOME Files
    -   GNOME Project Listing

Retrieved from
"https://wiki.archlinux.org/index.php?title=GNOME&oldid=255877"

Category:

-   Desktop environments
