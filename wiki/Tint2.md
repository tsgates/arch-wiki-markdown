Tint2
=====

tint2 is a system panel for linux. It is described by its developers as
"simple panel/taskbar unobtrusive and light". It can be configured to
include (or not include) among other things a system tray, a task list,
a battery monitor and a clock. Its look can also be configured a great
deal, and it does not have many dependencies. This makes it ideal for
window manager users who want a panel but do not have one by default,
like Openbox users.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Application Launchers in tint2-svn (AUR)                     |
|     -   2.2 Applications Menu in OpenBox3                                |
|                                                                          |
| -   3 Running tint2                                                      |
|     -   3.1 Openbox                                                      |
|     -   3.2 GNOME 3                                                      |
|                                                                          |
| -   4 Enabling transparency                                              |
+--------------------------------------------------------------------------+

Installation
------------

tint2 can be installed with the package tint2, available in the official
repositories.

Configuration
-------------

tint2 has a configuration file in ~/.config/tint2/tint2rc. A skeleton
configuration file with the default settings is created the first time
you run tint2. You can then change this file to your liking. Full
documentation on how to configure tint2 is found here. You can configure
the fonts, colors, looks, location and more in this file. The tint2
package now contains a GUI configuration tool that can be accessed by
typing the command:

    $ tint2conf

Alternatively, you can edit your tint2rc configuration file graphically
with tintwizard from the AUR. The alternate and now outdated development
branch tintwizard-svn can also be used, but is the same as the tint2conf
command.

> Application Launchers in tint2-svn (AUR)

With the version of tint2 in subversion (available via AUR: tint2-svn),
it has become possible to add application launchers to tint2. In order
to do this it is necessary to manually edit your tint2 configuration
file, as tintwizard does not yet support the launchers.

Note:When you edit your tint2 config file using tintwizard after
manually adding your launchers, tintwizard will delete any configuration
options it does not recognize. I.e. it deletes your launchers.

It is necessary to add the following configuration options to your tint2
config file:

Under #Panel:

    # Panel
    panel_items = LTSBC

And under the new section #Launchers:

    # Launchers
    launcher_icon_theme = LinuxLex-8
    launcher_padding = 5 0 10
    launcher_background_id = 9
    launcher_icon_size = 85
    launcher_item_app = /some/where/application.desktop
    launcher_item_app = /some/where/anotherapplication.desktop

The option launcher_icon_theme seems not to be documented yet.

panel_items is a new configuration option which defines which items
tint2 shows and in what order:

 L
    Show Launcher
 T
    Show Taskbar
 S
    Show Systray
 B
    Show Battery status
 C
    Show Clock

> Applications Menu in OpenBox3

If running the tint2-svn from AUR, you have the ability to create
launchers. Unfortunately, tint2 does not support nested menus yet, so
there is no native function to enable an applications menu. With a
little ingenuity, one can trick tint2 and get an applications menu
anyway! This example will create such a launcher for Openbox3.

First, you have to install openbox, tint2-svn and xdotool. Next you want
to create a keybinding for opening the Openbox menu. For Openbox, this
would require the following entry between the <keyboard> and </keyboard>
tags in ~/.config/openbox/rc.xml:

     <keybind key="C-A-space">
       <action name="ShowMenu"><menu>root-menu</menu></action>
     </keybind>

This will set Ctrl+Alt+Space to open the root-menu (this is the menu
that opens when you right-click the desktop). You can change root-menu
to any menu-id that you have defined in ~/.config/openbox/menu.xml. Next
we need to make that keybinding into a .desktop file with xdotool. First
test that your keybind works with:

    $ xdotool key ctrl+alt+space

If the menu you chose pops up under your mouse cursor, you have done it
right! Now create a tint2.desktop file inside /usr/share/applications/
directory. Be sure to add the line Exec=xdotool key ctrl+alt+space where
Ctrl+Alt+Space are your chosen key combinations. Open your new
tint2.desktop file from your file manager and, once again, you should
see the menu appear under your cursor. Now just add this to tint2 as a
launcher, and you have your Openbox Applications Menu as a launcher for
tint2!

See Openbox Menus for further help on creating your own menu to use
here, and menumaker to generate a nice full menu.xml for most (possibly
all) of your installed programs.

Running tint2
-------------

> Openbox

You can run tint2 by simply typing the command:

    $ tint2

If you want to run it when starting X, simply add this to ~/.xinitrc.
For example if you run tint2 with Openbox:

    #!/bin/sh
    #
    # ~/.xinitrc
    #
    # Executed by startx (run your window manager from here)
    tint2 &
    exec openbox-session

If you want to run tint2 when starting Openbox, you will need to update
~/.config/openbox/autostart by adding the following:

    tint2 &

Note: if you do not have an autostart file in ~/.config/openbox, you can
copy the default one from /etc/xdg/openbox/autostart.

Refer to Openbox help for more information on autostart options for
Openbox.

> GNOME 3

In GNOME 3, the Activities view has replaced the bottom panel and
taskbar. To use tint2 in its place, run

    # gnome-session-properties

and add

    # /usr/bin/tint2

as an application to run on start-up. The next time GNOME starts, tint2
will run automatically.

Enabling transparency
---------------------

To make tint2 look its best, some form of compositing is required. If
your tint2 has a large black rectangular box behind it you are either
using a window manager without native compositing (like Openbox) or it
is not enabled.

To enable compositing under Openbox you can install Xcompmgr or Cairo
Compmgr, the packages are xcompmgr, respectively cairo-compmgr.

Xcompmgr can be started like this:

    $ xcompmgr

You will have to kill and restart tint2 to enable transparency.

If Xcompmgr is used solely to provide tint2 with transparency effects it
can be run at boot by changing the autostart section in
~/.config/openbox/autostart to this:

    # Launch Xcomppmgr and tint2 with openbox
    if which tint2 >/dev/null 2>&1; then
      (sleep 2 && xcompmgr) &
      (sleep 2 && tint2) &
    fi

Various other (better) ways to make Xcompmgr run at startup are
discussed in the Openbox article.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tint2&oldid=250173"

Category:

-   Eye candy
