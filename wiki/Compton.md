Compton
=======

  Summary
  -----------------------------------------------------------
  Introduces chjj's fork of xcompmgr (fork of fork indeed).

Compton is a fork of xcompmgr-dana by chjj, where xcompmgr-dana is a
fork of xcompmgr by Dana. It is therefore, like xcompmgr, a standalone
composite manager and can be used as a companion to lightweight window
managers which don't do composition on themselves.

This fork fixed many bugs, and is very usable by this time of writing.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
| -   3 Transparency                                                       |
|     -   3.1 Problem with slock                                           |
|                                                                          |
| -   4 Multihead                                                          |
+--------------------------------------------------------------------------+

Installation
------------

Install the compton-git package, available in the AUR.

Usage
-----

To start manually, just run:

    $ compton

To use fancy shadows, you can run

    $ compton -c

Additionally, -C can be used to avoid shadows on panels and docks, and
-G can be used to avoid shadows on drag-and-drop objects (you probably
want this).

If you want it started automatically, put this in xprofile:

    compton -cGb

where -b means to daemonize after composite manager registered.

An example of a more customised command:

    compton -cCGfF -o 0.38 -O 200 -I 200 -t 0.02 -l 0.02 -r 3.2 -D2 -m 0.88

You can also put your configuration in a file ~/.config/compton.conf or
~/.compton.conf.

A sample configuration file.

    ~/.compton.conf

    # Shadow
    shadow = true;			# Enabled client-side shadows on windows.
    no-dock-shadow = true;		# Avoid drawing shadows on dock/panel windows.
    no-dnd-shadow = true;		# Don't draw shadows on DND windows.
    clear-shadow = true;		# Zero the part of the shadow's mask behind the window (experimental).
    shadow-radius = 7;		# The blur radius for shadows. (default 12)
    shadow-offset-x = -7;		# The left offset for shadows. (default -15)
    shadow-offset-y = -7;		# The top offset for shadows. (default -15)
    # shadow-opacity = 0.7;		# The translucency for shadows. (default .75)
    # shadow-red = 0.0;		# Red color value of shadow. (0.0 - 1.0, defaults to 0)
    # shadow-green = 0.0;		# Green color value of shadow. (0.0 - 1.0, defaults to 0)
    # shadow-blue = 0.0;		# Blue color value of shadow. (0.0 - 1.0, defaults to 0)
    shadow-exclude = [ "n:e:Notification" ];	# Exclude conditions for shadows.
    # shadow-exclude = "n:e:Notification";
    shadow-ignore-shaped = true;

    # Opacity
    menu-opacity = 0.9;			# The opacity for menus. (default 1.0)
    inactive-opacity = 0.9;			# Opacity of inactive windows. (0.1 - 1.0)
    #frame-opacity = 0.8;			# Opacity of window titlebars and borders. (0.1 - 1.0)
    inactive-opacity-override = true;	# Inactive opacity set by 'inactive-opacity' overrides value of _NET_WM_OPACITY.

    # Fading
    fading = true;			# Fade windows during opacity changes.
    # fade-delta = 30;		# The time between steps in a fade in milliseconds. (default 10).
    fade-in-step = 0.03;		# Opacity change between steps while fading in. (default 0.028).
    fade-out-step = 0.03;		# Opacity change between steps while fading out. (default 0.03).
    # no-fading-openclose = true;	# Fade windows in/out when opening/closing.

    # Other
    #inactive-dim = 0.5;		# Dim inactive windows. (0.0 - 1.0, defaults to 0).
    mark-wmwin-focused = true;	# Try to detect WM windows and mark them as active.
    mark-ovredir-focused = true;
    detect-rounded-corners = true;

    # Window type settings
    wintypes:
    {
      tooltip = { fade = true; shadow = false; opacity = 0.75; };
    };

To run compton with config file:

    $ compton --config ~/.compton.conf

To automatically start compton put following in any of your Startup
files:

    compton --config ~/.compton.conf -b

Transparency
------------

Besides what is provided in xcompmgr, compton introduces two new
auto-transparency options:

          -i opacity
                 Specifies inactive window transparency. (0.1 - 1.0)
          -e opacity
                 Specifies window frame transparency. (0.1 - 1.0)

Try them out on your own.

> Problem with slock

Note that inactive window transparency (-i option) will make all
inactive window became transparent, and if you use slock it may not be a
good result. Try this in config file instead:

    inactive-dim = 0.2;

This will work with slock better.

Multihead
---------

If you use a multihead configuration without Xinerama, which means you
start a X server with more than one screen, then compton will start on
only one screen by default. You can start on all screen by starting
multiple compton on all screens with -d. For example, if you have 4
monitors then you can start compton by:

    seq 0 3 | xargs -l1 -I@ compton -b -d :0.@

Retrieved from
"https://wiki.archlinux.org/index.php?title=Compton&oldid=251127"

Categories:

-   X Server
-   Eye candy
