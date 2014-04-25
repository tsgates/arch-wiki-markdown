GNOME
=====

Related articles

-   Desktop environment
-   Display manager
-   Window manager
-   GTK+
-   GDM
-   Nautilus
-   Gedit
-   Epiphany
-   GNOME Flashback

GNOME is a desktop environment developed by The GNOME Project.

GNOME 3 has two sessions:

-   GNOME is the default, innovative layout.
-   GNOME Classic is a traditional desktop layout, similar to the GNOME
    2 user interface whilst using GNOME 3 technologies. It does so
    through the use of pre-activated extensions and parameters (see here
    for a list). Hence it is more of a customized GNOME Shell than a
    truly distinct mode.

Both of them use GNOME Shell, a desktop shell and plugin of the Mutter
window manager. Mutter acts as a composite manager for the desktop,
employing hardware graphics acceleration to provide effects aimed at
reducing screen clutter. GNOME session manager automatically detects if
your video driver is capable of running GNOME Shell and if not, falls
back to software rendering using llvmpipe.

Contents
--------

-   1 Installation
-   2 Starting GNOME
-   3 Using the shell
    -   3.1 GNOME cheat sheet
    -   3.2 Restarting the shell
    -   3.3 Shell crashes
    -   3.4 Shell freezes
-   4 Pacman integration: GNOME PackageKit
    -   4.1 Packages updates notifications
-   5 Customizing GNOME appearance
    -   5.1 Overall appearance
        -   5.1.1 Gsettings
        -   5.1.2 GNOME tweak tool
        -   5.1.3 dconf
        -   5.1.4 GTK3 theme via settings.ini
        -   5.1.5 Icon theme
    -   5.2 GNOME panel
        -   5.2.1 Show date in top bar
        -   5.2.2 Hiding icons in the top bar
            -   5.2.2.1 Hiding icons with shell extensions
            -   5.2.2.2 Manually editing the GNOME panel script
        -   5.2.3 Eliminate delay when logging out
        -   5.2.4 Show system monitor
        -   5.2.5 Show weather information
    -   5.3 Activity view
        -   5.3.1 Remove entries from Applications view
        -   5.3.2 Change application icon size
        -   5.3.3 Change dash icon size
        -   5.3.4 Change switcher (alt-tab) icon size
        -   5.3.5 Change system tray icon size
        -   5.3.6 Disable Activity hot corner hovering
        -   5.3.7 Disable Message Tray hovering
    -   5.4 Titlebar
        -   5.4.1 Reduce title bar height
        -   5.4.2 Reorder titlebar buttons
        -   5.4.3 Hide titlebar when maximized
-   6 Miscellaneous settings
    -   6.1 Power Management
        -   6.1.1 Prevent Suspend-To-RAM (S3) when closing the LID
        -   6.1.2 No reaction on lid close
        -   6.1.3 Change Critical Battery Level Action (for Laptops)
    -   6.2 Switch back scrolling behavior
    -   6.3 Autostarting / Automatic program launch upon logging in
    -   6.4 Editing applications menu
    -   6.5 Inner padding in Gnome Terminal
    -   6.6 Disable blinking cursor in Terminal
    -   6.7 Make new tabs inherit current directory in Gnome Terminal
        (3.8+)
    -   6.8 Move dialog windows
    -   6.9 GNOME shell extensions
    -   6.10 Default Applications
        -   6.10.1 Default file browser/replace Nautilus
        -   6.10.2 Default PDF viewer
        -   6.10.3 Default terminal
        -   6.10.4 Default web browser for gnome-gmail-notifier
    -   6.11 Middle mouse button
    -   6.12 Display dimming
    -   6.13 Changing hotkeys
        -   6.13.1 Hotkeys in Nautilus 3.4 and older
    -   6.14 Screencast recording
    -   6.15 Modify Keyboard with XkbOptions
    -   6.16 Toggle keyboard layouts
    -   6.17 Other tips
-   7 Tracker (search program)
-   8 Totem (movie player)
-   9 Empathy (integrated messaging) and Gnome Online Accounts
-   10 Troubleshooting
    -   10.1 Cannot change settings in dconf-editor
    -   10.2 When an extension breaks GNOME
    -   10.3 Extensions do not work after GNOME 3 update
    -   10.4 Remove Gnome Shell Extensions
    -   10.5 The "Windows" key
    -   10.6 Keyboard Shortcut do not work with only conky running
    -   10.7 Window opens behind other windows when using multiple
        monitors
    -   10.8 Multiple monitors and dock extension
    -   10.9 "Show Desktop" keyboard shortcut does not work
    -   10.10 Unable to apply stored configuration for monitors
    -   10.11 Lock button fails to re-enable touchpad
    -   10.12 GDM and GNOME use X11 cursors
    -   10.13 Tracker & Documents do not list any local files
    -   10.14 Passwords are not remembered
    -   10.15 Windows cannot be modified with Alt-Key + Mouse-Button
    -   10.16 Gnome-shell 3.8.x fails to load with a black screen +
        cursor
    -   10.17 Gnome 3.10 UI elements scale incorrectly
    -   10.18 Tear-free video with Intel HD Graphics
-   11 External links

Installation
------------

GNOME 3 is available in the official repositories and can be installed
with one of the following:

-   The gnome-shell package provides a minimal desktop shell.
-   The gnome group contains the core desktop environment and
    applications required for the standard GNOME experience.
-   The gnome-extra group contains various optional tools such as an
    editor, an archive manager, a disk burner, a mail client, games,
    development tools and other non-critical applications that integrate
    well with the GNOME desktop. Installing just the gnome-extra group
    will not pull in the whole gnome group via dependencies. If you want
    to install all GNOME packages then you will need to explicitly
    install both groups.

Starting GNOME
--------------

Graphical log-in

For the best desktop integration, GDM (the GNOME Display manager) is
recommended. GDM is installed as part of the gnome group and can be used
by enabling gdm.service using systemd.

Other display managers can be used in place of GDM if desired.

Note:Native support for screenlocking in GNOME is provided by GDM. If
you choose to not use GDM you will need to use a different screenlocking
program such as Xscreensaver.

Starting GNOME manually

If you prefer to start GNOME manually from the console, add the
following line to your ~/.xinitrc file:

    ~/.xinitrc

     exec gnome-session

Or exec gnome-session --session=gnome-classic for GNOME Classic. After
editing your ~/.xinitrc, GNOME can be launched by typing startx.

See xinitrc for details, such as preserving the logind session.

Using the shell
---------------

> GNOME cheat sheet

The GNOME web site has a helpful outdated GNOME Shell cheat sheet
explaining task switching, keyboard use, window control, the panel,
overview mode, and more.

> Restarting the shell

After appearance tweaks you are often asked to restart the GNOME shell.
You could log out and log back in, but it is simpler and faster to issue
the following keyboard command. Restart the shell by pressing Alt + F2
then r then Enter

> Shell crashes

Certain tweaks and/or repeated shell restarts may cause the shell to
crash when a restart is attempted. In this case, you are informed about
the crash and then forced to log out. Some shell changes cannot be
accomplished via a keyboard restart; you must log out and log back in to
effect them.

Note:Valuable documents should be saved (and perhaps closed) before
attempting a shell restart. It is not strictly necessary; open windows
and documents usually remain intact after a shell restart however there
is a risk that data could be lost if documents are not saved.

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

If this does not work, you can try to restart your login manager. For
instance, if you use GDM, try:

    # systemctl restart gdm.service

Tip:You can also use htop in tty; press t, select the gnome-shell tree,
press k and send SIGKILL.

Pacman integration: GNOME PackageKit
------------------------------------

GNOME has its own Pacman GUI: gnome-packagekit.

Using the alpm backend, it supports the following features:

-   Install and remove packages from the repos.
-   Periodically refresh package databases and prompt for updates.
-   Install packages from tarballs.
-   Search for packages by name, description, category or file.
-   Show package dependencies, files and reverse dependencies.
-   Ignore IgnorePkgs and hold HoldPkgs.
-   Report optional dependencies, .pacnew files, etc.

You can change the remove operation from -Rc to -Rsc by setting the
DConf key org.gnome.packagekit.enable-autoremove.

> Packages updates notifications

If you want GNOME to check automatically for updates, you must install
gnome-settings-daemon-updates from the official repository.

Customizing GNOME appearance
----------------------------

> Overall appearance

There is no all-encompassing configuration tool however a variety of
tools are available to ensure that all customisations that the user
needs to make can be made. The new Systems Settings tool (provided by
gnome-control-center) is a simple and streamlined panel which covers
most basic settings however more extensive customisation may require the
use of some of the tools below.

Gsettings

A new command-line tool gsettings stores data in a binary format, unlike
previous tools using XML text. See Customizing the GNOME Shell for a
tutorial on using gsettings.

GNOME tweak tool

This graphical tool customizes fonts, themes, titlebar buttons and other
settings. gnome-tweak-tool is available from the official repositories.
It is set up as a user friendly frontend to the gsettings tool.

dconf

The dconf tool is a tree based graphical frontend to gsettings. It is
somewhat similar to the regedit tool in Windows. Most GNOME
configuration settings are exposed in this tool.

GTK3 theme via settings.ini

It is possible to set a GTK3 theme via
${XDG_CONFIG_HOME}/gtk-3.0/settings.ini (usually
~/.config/gtk-3.0/settings.ini).

Adwaita, the default GNOME 3 theme, is a part of gnome-themes-standard.
Additional GTK3 themes can be found at Deviantart web site. For example:

    ${XDG_CONFIG_HOME}/gtk-3.0/settings.ini

    [Settings]
    gtk-theme-name = Adwaita
    # next option is applicable only if selected theme supports it
    gtk-application-prefer-dark-theme = true
    # set font name and dimension
    gtk-font-name = Sans 10

It is necessary to restart the GNOME shell for settings to be applied.
More GTK options are found at GNOME developer documentation.

Icon theme

Using gnome-tweak-tool version 3.0.3 and later, you can place any icon
theme you wish to use inside ~/.icons.

GNOME 3 is compatible with a number of icon themes including GNOME 2
icon themes. To install a new set of icons, copy your desired icon
theme's directory to ~/.icons. As an example:

    $ cp -R /home/user/Desktop/my_icon_theme ~/.icons

The new theme my_icon_theme is now selectable using gnome-tweak-tool
under interface.

Alternatively, you may manually select your icon theme without the use
of gnome-tweak-tool or dconf. Add the GTK icon theme name to
${XDG_CONFIG_HOME}/gtk-3.0/settings.ini. Please note, not to use "" as
your settings would not be recognised then.

    ${XDG_CONFIG_HOME}/gtk-3.0/settings.ini

    ... previous lines ...

    gtk-icon-theme-name = my_new_icon_theme

> GNOME panel

Show date in top bar

By default GNOME displays only the weekday and time in the top bar. This
can be changed with the following command. Changes take effect
immediately.

    # gsettings set org.gnome.desktop.interface clock-show-date true

You can also change this setting using dconf or gnome-tweak-tool. In
dconf-editor expand org -> gnome -> desktop -> interface and tick the
option labelled clock-show-date.

In gnome-tweak-tool click on the "Top Bar" tab and tick the option
labelled Show Date.

Hiding icons in the top bar

When installing GNOME, some unwanted icons might appear in the panel.
These icons can be removed either with GNOME shell extensions or by
manually editing the GNOME panel script.

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

Note:As of GNOME 3.8 the accessibility icon is hidden from the panel by
default.

Eliminate delay when logging out

The following tweak removes the confirmation dialog and sixty second
delay for logging out.

This dialog normally appears when you log out with the status menu. This
tweak affects the Power Off dialog as well. This is not a system-wide
change; it affects only the user who enters this command. The change
takes effect immediately after entering the command.

    $ gsettings set org.gnome.SessionManager logout-prompt 'false'

Show system monitor

The system-monitor extension is included in the gnome-shell-extensions
package. The git version is available as
gnome-shell-system-monitor-applet-git in the AUR.

Show weather information

The Weather extension can be installed from the official extension
website. The git version is available as
gnome-shell-extension-weather-git in the AUR.

> Activity view

Remove entries from Applications view

Like most desktop environments, GNOME uses .desktop files to populate
its Applications view. These text files are located in the
/usr/share/applications folder. It is not possible to edit these files
from a folder view ‒ Nautilus does not treat their icons as text files.
Use a terminal to display or edit .desktop file entries. You will need
root privileges to edit the .desktop files.

    # ls /usr/share/applications
    # nano /usr/share/applications/foo.desktop

For system wide changes, edit files in /usr/share/applications. For
local changes, make a copy of foo.desktop in your home folder.

    $ cp /usr/share/applications/foo.desktop ~/.local/share/applications/

Edit .desktop files to fit your wishes.

Note:Removing a .desktop file does not uninstall an application, but
instead removes its desktop integration: MIME types, shortcuts, and so
forth.

To hide an application launcher open its .desktop file in a text editor
and add the following line:

    NoDisplay=true

Change application icon size

To change the application icon size it is necessary to edit the
GNOME-Shell theme.

You can edit system files directly (make a backup first) or copy theme
files to your local folder and edit these files.

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

Tip:There are also GNOME Shell extensions that can be installed which
will modify this behaviour.

Disable Message Tray hovering

The message tray is shown when the mouse hovers at the bottom of the
screen for one second. To disable this behavior, comment out the
following line in /usr/share/gnome-shell/js/ui/messageTray.js:

    messageTray.js

            //pointerWatcher.addWatch(TRAY_DWELL_CHECK_INTERVAL, Lang.bind(this, this._checkTrayDwell));

GNOME Shell needs to be restarted. The message tray is still visible in
activity view.

> Titlebar

Reduce title bar height

-   global - edit
    /usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml, search
    for title_vertical_pad and and reduce its value to a minimum of 0.
-   user-only - copy
    /usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml to
    /home/$USER/.themes/Adwaita/metacity-1/metacity-theme-3.xml, search
    for title_vertical_pad and reduce its value to a minimum of 0.

Then restart the GNOME shell.

To restore the original values, install the package
gnome-themes-standard from the official repositories or remove
/home/$USER/.themes/Adwaita/metacity-1/metacity-theme-3.xml

Reorder titlebar buttons

At present this setting can be changed through dconf-editor.

For example, to move the close and minimize buttons to the left side of
the titlebar, open dconf-editor and locate the
org.gnome.shell.overrides.button_layout key. Change its value to
close,minimize: (Colon symbol designates the spacer between left side
and right side of the titlebar.) Place the buttons in your preferred
order. You cannot use a button more than once. Also, keep in mind that
certain buttons are deprecated. Restart the shell to see your new button
arrangement.

Hide titlebar when maximized

The command below will hide the titlebar when windows are maximised:

    # sed -i -r 's|(<frame_geometry name="max")|\1 has_title="false"|' /usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml

After entering the command restart the GNOME shell. After this tweak,
you may find it difficult to un-maximize a window when there is no
titlebar to grab.

With suitable keybindings, you should be able to use Alt+F5, Alt+F10 or
Alt+Space to remedy the situation.

To prevent metacity-theme-3.xml from being overwritten each time package
gnome-themes-standard is upgraded, add its name to /etc/pacman.conf with
NoUpgrade.

    /etc/pacman.conf

    ... previous lines ...

    # Pacman will not upgrade packages listed in IgnorePkg and members of IgnoreGroup
    # IgnorePkg   =
    # IgnoreGroup =

    NoUpgrade = usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml    # Do not add a leading slash to the path

    ... more lines ...

To restore original Adwaita theme values, install the
gnome-themes-standard package.

Miscellaneous settings
----------------------

> Power Management

Prevent Suspend-To-RAM (S3) when closing the LID

This setting is not exposed in GNOME's System Settings or in dconf. The
current approach is to manage this on the level of Systemd. Change the
variable HandleLidSwitch to ignore in /etc/systemd/logind.conf

    /etc/systemd/logind.conf

    HandleLidSwitch=ignore

See the Power management#ACPI_events article for more information.

Note:Ensure that the HandleLidSwitch entry is uncommented or the setting
will not take effect.

No reaction on lid close

When configuring the lid close events via Systemd#ACPI_power_management,
the settings may seem to have no effect. If you have an external monitor
connected to your laptop, this is default GNOME behaviour. Disconnect
the monitor and the settings should work, otherwise your
/etc/systemd/logind.conf may be incorrect. To change default behaviour
open the dconf-editor and change org -> gnome -> settings-daemon ->
plugins -> xrandr -> default-monitors-setup to "do-nothing".

Change Critical Battery Level Action (for Laptops)

The System Settings panel only allows the user to choose between Suspend
or Hibernate. To choose another option such as Do Nothing open the
dconf-editor and navigate to -> org -> gnome -> settings-daemon ->
plugins -> power. Edit the "critical-battery-action" value to "nothing".

> Switch back scrolling behavior

If you do not like the new scrollbar behavior just put
gtk-primary-button-warps-slider = false under the [Settings] section in
~/.config/gtk-3.0/settings.ini:

    ~/.config/gtk-3.0/settings.ini

    [Settings]
    gtk-primary-button-warps-slider = false
    ...

> Autostarting / Automatic program launch upon logging in

Specify which programs start automatically after logging in using
gnome-session-properties. This tool is part of the gnome-session
package.

    $ gnome-session-properties

> Editing applications menu

alacarte provides a more complete menu editor for adding/editing menu
entries.

> Inner padding in Gnome Terminal

To move the terminal output away from the window borders create the
stylesheet ~/.config/gtk-3.0/gtk.css with the following setting:

       TerminalScreen {
         -VteTerminal-inner-border: 10px 10px 10px 10px;
       }

> Disable blinking cursor in Terminal

Since Gnome 3.8 and the migration to gsettings and dconf the key
required to modify in order to disable the blinking cursor in the
Terminal differs slightly in contrast to the old gconf key. To disable
the blinking cursor in Gnome 3.8 use:

    gsettings set org.gnome.desktop.interface cursor-blink false

If you prefer dconf to the gsettings CLI then open dconf-editor and
expand expand org -> gnome -> desktop -> interface and untick the option
labelled cursor-blink.

> Make new tabs inherit current directory in Gnome Terminal (3.8+)

In Gnome 3.8, the behaviour of how current directories are tracked has
changed. To restore this behaviour, you need to source the
/etc/profile.d/vte.sh file, put this in your ~/.bashrc or ~/.zshrc for
zsh users:

    source /etc/profile.d/vte.sh

For more information refer to the Gnome wiki

> Move dialog windows

The default configuration for dialogs will not allow you to move them
which causes problems in some cases. To change this you will need to use
gconf-editor and change this setting:

    /desktop/gnome/shell/windows/attach_modal_dialogs

After the change you will need to restart the shell for it to take
affect.

> GNOME shell extensions

GNOME Shell can be customized with extensions. These provide features
such as a dock or a widget for changing the theme.

Many extensions are collected and hosted by extensions.gnome.org. They
can be browsed and installed simply activating them in the browser. More
information about gnome shell extensions can be found here.

See when an extension breaks GNOME for troubleshooting information.

> Default Applications

While one can right click any file and set the default applications in
'Preferences', the settings are actually saved in
 $HOME/.local/share/applications/mimeapps.list and
 $HOME/.local/share/applications/mimeinfo.cache

For systemwide preferences create or edit the file
/usr/share/applications/mimeapps.list.

Tip:If you are making the change systemwide you may to create the
/usr/share/applications/mimeapps.list file yourself.

Default file browser/replace Nautilus

You can specify a different file manager in the mimeapps.list file as
shown below:

User only: add the line inode/directory=myfilemanager.desktop to
~/.local/share/applications/mimeapps.list

Systemwide: add the line inode/directory=myfilemanager.desktop to
/usr/share/applications/mimeapps.list

Where my filemanager.desktop is the correct .desktop file for the file
manager of your choice.

  
 Alternatively you can trick GNOME into using another file browser by
editing the Exec line in /usr/share/applications/nautilus.desktop. See
the correct parameters in the .desktop file of the file manager of your
choice, e.g.:

    /usr/share/applications/nautilus.desktop

    [...]
    Exec=thunar %F
    OR
    Exec=pcmanfm %U
    OR
    Exec=nemo %U
    [...]

Default PDF viewer

In some cases when you have installed Inkscape or other graphic programs
Evince Document Viewer might no longer be selected as the default PDF
application. If it is not available in the Open With entry which would
be the GUI solution, you can use the following user command to make it
the default application again.

    xdg-mime default evince.desktop application/pdf

Default terminal

gsettings (which replaces gconftool-2) is used to set the default
terminal. The setting affects nautilus-open-terminal (a Nautilus
extension). To make urxvt the default, run:

    gsettings set org.gnome.desktop.default-applications.terminal exec urxvtc
    gsettings set org.gnome.desktop.default-applications.terminal exec-arg "'-e'"

Note:The -e flag is for executing a command. When nautilus-open-terminal
invokes urxvtc, it puts a cd command at the end of the command line so
that the new terminal starts in the directory you opened it from. Other
terminals will require a different (perhaps empty) exec-arg.

Default web browser for gnome-gmail-notifier

To configure the web browser used by the AUR package
gnome-gmail-notifier, open gconf-editor and edit the
/desktop/gnome/url-handlers/http/ key. You may want to change https/,
about/, and unknown/ keys while you are at it.

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

> Changing hotkeys

Certain hotkeys cannot be changed directly via the System Settings
panel. In order to change these keys, use dconf-editor. An example of
particular note is the hotkey Alt-Above_Tab. On US keyboards, this is
Alt-`: is a hotkey often used in the Emacs editor. It can be changed by
opening dconf-editor and modifying the switch-group key found in
org.gnome.desktop.wm.keybindings.

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

The file is regenerated regularly so do not comment the file. The
uncommented line will stay but every comment you add will be lost.

Hotkeys in Nautilus 3.4 and older

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

Note:To enable the Ctrl+Alt+Backspace combination to terminate Xorg, use
the gnome-tweak-tool from official repositories. Within the Gnome Tweak
Tool, navigate to Typing > Terminate and select the option
Ctrl+Alt+Backspace from the dropdown menu.

> Toggle keyboard layouts

Since Gnome does not consider any configuration in
/etc/X11/conf.d/*.conf you have to set the command for layout switching
either via the control center with the options Switch to previous source
and Switch to next source or if you want to use Alt - Shift combination
you have to use the Gnome-Tweak-Tool and set Typing -> Modifiers-only
input sources -> select Alt-shift. For more information see also the
forum thread.

> Other tips

See GNOME Tips.

Tracker (search program)
------------------------

The tracker provides the Tracker program, an indexing application. You
can configure it with tracker-preferences, and monitor status with
tracker-control. Once installed, indexing should start automatically
when you log in. You can explicitly start indexing with
tracker-control -s. Search settings can also be configured in the System
Settings panel.

Totem (movie player)
--------------------

Totem is a movie player based on GStreamer. For information about adding
codecs or hardware acceleration, see GStreamer.

Empathy (integrated messaging) and Gnome Online Accounts
--------------------------------------------------------

Empathy, the engine behind integrated messaging, and all system settings
based on messaging accounts will not show up unless the telepathy group
of packages or at least one of the backends (telepathy-gabble, or
telepathy-haze, for example) is installed. You will also need to install
the telepathy group to add accounts in the GNOME Online Accounts
interface found in the System Settings panel.

These packages are not included in either the gnome or gnome-extra
groups . You can install the Telepathy and optionally any backends with:

    # pacman -S telepathy

Without telepathy, Empathy will not open the account management dialog
and can get stuck in this state. If this happens -- even after quitting
Empathy cleanly -- the /usr/bin/empathy-accounts application can remain
running and will need to be killed before you can add any new accounts.

View descriptions of telepathy components on the Freedesktop.org
Telepathy Wiki.

Troubleshooting
---------------

> Cannot change settings in dconf-editor

When one cannot set settings in dconf, it is possible their dconf user
settings are corrupt. In this case it is best to delete the user dconf
files in ~/.config/dconf/user* and set the settings in dconf-editor
after.

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
breaks, you will know to change it back.

> Remove Gnome Shell Extensions

If you have trouble with uninstalling Gnome Extensions via
https://extensions.gnome.org/local/, then probably they have been
installed as system-wide extensions with
pacman -S gnome-shell-extensions before. To remove them, you have to be
careful, because the following instruction removes all extensions from
other user's, too.

    pacman -R gnome-shell-extensions

Following that, you refresh Gnome Shell by pressing ALT+F2 and entering
restart

Then go to https://extensions.gnome.org/local/ again and have a look for
your installed extensions list. It should have changed.

All other extensions should be removable by pressing the red X icon to
the right. If not, something may be broken.

As a final step, you can remove them manually from
~/.local/share/gnome-shell/extensions/* and/or
/usr/share/gnome-shell/extensions. Restart Gnome Shell again and you
should be fine.

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

> "Show Desktop" keyboard shortcut does not work

GNOME developers treated the corresponding binding as bug (see
https://bugzilla.gnome.org/show_bug.cgi?id=643609) due to Minimization
being deprecated. To show the desktop again assign ALT+STRG+D to the
following setting:

    System Settings --> Keyboard --> Shortcuts --> Navigation --> Hide all normal windows

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

> GDM and GNOME use X11 cursors

To fix this problem, become root and put the following into
/usr/share/icons/default/index.theme (creating the directory
/usr/share/icons/default if necessary):

    /usr/share/icons/default/index.theme

    [Icon Theme]
    Inherits=Adwaita

Note: Instead of "Adwaita", you can choose another cursor theme (e.g.
Human).

> Tracker & Documents do not list any local files

In order for Tracker (and, therefore, Documents) to detect your local
files, they must be stored in directories that it knows of. If your
documents are contained in one of the usual XDG standard directories
(i.e. "Documents" or "Music"), you should install xdg-user-dirs and run:

     # xdg-user-dirs-update

This will create all of the usual XDG home directories if they do not
already exist and it will create the config file definining these
directories that Tracker and Documents depend upon.

> Passwords are not remembered

If you get a password prompt every time you login, and you find password
are not saved, you might need to create/set a default keyring:

Install seahorse. Open "Passwords and Keys" from the menu or run
seahorse. Select View > By Keyring. If there is no keyring in the left
column (it will be marked with a lock icon), go to File > New > Password
Keyring and give it a nice name. You will be asked to enter a password.
If you do not give it a password it will be unlocked automatically even
when using autologin, but passwords will not be stored securely.
Finally, right-click on the keyring you just created and select "Set as
default".

> Windows cannot be modified with Alt-Key + Mouse-Button

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

Additionally, if multiple locales of different languages are enabled, it
may be necessary to disable all locales except for one (which is UTF-8).

> Gnome 3.10 UI elements scale incorrectly

With 3.10 Gnome introduced HDPI support. If your displays EDID info does
not contain the correct screen size, but the resolution is right, this
can lead to incorrectly scaled UI elements. As a workaround you can open
dconf-editor and find the key scaling-factor in
org.gnome.desktop.interface. Set it to 1 to get the standard scale.

> Tear-free video with Intel HD Graphics

Enabling the Xorg Intel TearFree option is a known workaround to tearing
problems on Intel adapters, however the way this option acts makes it
redundant with the use of a compositor (adds up memory consumption and
lowers performance, see the original bug report's final comment).

On the other hand, GNOME Shell uses Mutter as a compositor which has a
tweak known to address tearing problems (see the original suggestion for
this fix and its mention in the Freedesktop bug report): the line
CLUTTER_PAINT=disable-clipped-redraws:disable-culling must be appended
to /etc/environment and Xorg server restarted. This tweak solved tearing
problems.

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
"https://wiki.archlinux.org/index.php?title=GNOME&oldid=305768"

Category:

-   GNOME

-   This page was last modified on 20 March 2014, at 02:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
