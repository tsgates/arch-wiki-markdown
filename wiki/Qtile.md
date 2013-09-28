Qtile
=====

From Qtile web site:

Qtile is a full-featured, hackable tiling window manager written in
Python. Qtile is simple, small, and extensible. It's easy to write your
own layouts, widgets, and built-in commands.It is written and configured
entirely in Python, which means you can leverage the full power and
flexibility of the language to make it fit your needs.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 Starting Qtile                                                     |
| -   3 Configuration                                                      |
|     -   3.1 Groups                                                       |
|     -   3.2 Keys                                                         |
|     -   3.3 Screens and Bars                                             |
|     -   3.4 Widgets                                                      |
|     -   3.5 Startup                                                      |
|     -   3.6 Sound                                                        |
|                                                                          |
| -   4 Debugging                                                          |
| -   5 See Also                                                           |
+--------------------------------------------------------------------------+

Installing
----------

Install qtile-git from the Arch User Repository

A default configuration file is provided in the git repository. Copy it
to ~/.config/qtile/config.py by executing:

    $ mkdir -p ~/.config/qtile/
    $ wget https://raw.github.com/qtile/qtile/develop/libqtile/resources/default_config.py -O - > ~/.config/qtile/config.py

If this fails execute the commands:

    $ rm ~/.config/qtile/config.py
    $ cp  /usr/lib/python2.7/site-packages/libqtile/resources/default_config.py ~/.config/qtile/config.py

Starting Qtile
--------------

To start Qtile add exec qtile to your ~/.xinitrc and launch Xorg. The
default configuration includes the shortcut Alt+Enter to open a new
xterm terminal.

Configuration
-------------

Note:This chapter only explains the basics of the configuration of
Qtile. For more complete information, look at the official
documentation.

The configuration is fully done in Python in the file
~/.config/qtile/config.py. For a very quick introduction to Python, you
can read this tutorial. It will explain Python variables, functions,
modules and other things you need to know to quickly get started on
configuring Qtile.

Before restarting Qtile you can test your config file for syntax errors
using the command:

    $ python2 -m py_compile ~/.config/qtile/config.py

If the command gives no output, your script is correct.

> Groups

In Qtile, the workspaces (or views) are called Groups. They can be
defined as following:

    from libqtile.config import Group, Match
    ...
    groups = [
        Group("term"),
        Group("irc"),
        Group("web", match=Match(title=["Firefox"])),
       ]
    ...

> Keys

You can configure your shortcuts with the Key class. Here is an example
of the shortcut Alt+Shift+q to quit the window manager.

    from libqtile.config import Key
    from libqtile.command import lazy
    ...
    keys = [
        Key(
            ["mod1", "shift"], "q",
            lazy.shutdown())
       ]
    ...

You can find out which modX corresponds to which key with the command
Xmodmap.

> Screens and Bars

Create one Screen class for every monitor you have. The bars of Qtile
are configured in the Screen class as in the following example:

    from libqtile.config import Screen
    from libqtile import bar, widget
    ...
    screens = [
        Screen(
            bottom=bar.Bar([          # add a bar to the bottom of the screen
                widget.GroupBox(),    # display the current Group
                widget.WindowName()   # display the name of the window that currently has focus
                ], 30))
       ]
    ...

> Widgets

You can find a list of all the built-in widgets in the official
documentation.

If you want to add a widget to your bar, just add it like in the example
above (for the WindowName widget). For example, if we want to add a
battery notification, we can use the Battery widget:

    from libqtile.config import Screen
    from libqtile import bar, widget
    ...
    screens = [
        Screen(top=bar.Bar([
            widget.GroupBox(),    # display the current Group
            widget.Battery()      # display the battery state
           ], 30))
       ]
    ...

> Startup

You can start up applications using hooks, specifically the startup
hook. For a list of available hooks see the documentation.

Here is an example where an application starts only once:

    import subprocess, re

    def is_running(process):
        s = subprocess.Popen(["ps", "axw"], stdout=subprocess.PIPE)
        for x in s.stdout:
            if re.search(process, x):
                return True
        return False

    def execute_once(process):
        if not is_running(process):
            return subprocess.Popen(process.split())

    # start the applications at Qtile startup
    @hook.subscribe.startup
    def startup():
        execute_once("parcellite")
        execute_once("nm-applet")
        execute_once("dropboxd")
        execute_once("feh --bg-scale ~/Pictures/wallpapers.jpg")

> Sound

You can add shortcuts to easily control the sound volume and state by
adding a user to the audio group and using the alsamixer command-line
interface.

    keys= [
        ...
        # Sound
        Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
        Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -c 0 sset Master 1- unmute")),
        Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -c 0 sset Master 1+ unmute"))
       ]

Debugging
---------

If you want to locate the source of a problem, you can execute the
following line in your terminal:

    echo "exec qtile" > /tmp/.start_qtile ; xinit /tmp/.start_qtile -- :2

See Also
--------

-   Qtile website
-   The official documentation
-   Comparison of Tiling Window Managers
-   xinitrc

Retrieved from
"https://wiki.archlinux.org/index.php?title=Qtile&oldid=251737"

Category:

-   Tiling WMs
