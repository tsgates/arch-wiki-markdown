Compton
=======

Compton is a lightweight, standalone composite manager, suitable for use
with window managers that do not natively provide compositing
functionality. Compton itself is a fork of xcompmgr-dana, which in turn
is a fork of xcompmgr. See the compton github page for further
information.

Compton in particular is notable for fixing numerous bugs found in its
predecessors, and as such, is popular due to its relability and
stability. Numerous additional improvements and configuration options
have also been implemented, including a faster GLX (OpenGL) backend
(disabled by default), default inactive/active window opacity, window
frame transparency, window background blur, window color inversion,
painting rate throttling, VSync, condition-based fine-tune control,
configuration file reading, and D-Bus control.

Contents
--------

-   1 Installation
-   2 Use
    -   2.1 Autostarting
    -   2.2 Command only
    -   2.3 Using a configuration file
        -   2.3.1 Disable conky shadowing
-   3 Multihead
-   4 Troubleshooting
    -   4.1 Slock

Installation
------------

Install compton or its git version, compton-git, both available from the
AUR.

Use
---

Compton may be manually enabled or disabled at any time during a
session, or autostarted as a background (Daemon) process for sessions.
There are also several optional arguments that may be used to tweak the
compositing effects provided. These include:

-   -b: Run as a background (Daemon) process for a session (e.g. when
    autostarting for a window manager such as Openbox)
-   -c: Enable shadow effects
-   -C: Disable shadow effects on panels and docks
-   -G: Disable shadow effects for application windows and drag-and-drop
    objects
-   --config: Use a specified configuration file

Many more options are availble, including to set timing, displays to be
managed, and the opacity of menus, window borders, and inactive
application menus. See the Compton Man Page for further information.

> Autostarting

How compton would be autostarted as a Daemon process will depend on the
desktop environment or window manager used. For example, for Openbox the
~/.config/openbox/autostart file must be edited, while for i3 it would
be the ~/.i3/config file. Where necessary, compton may also be
autostarted from xprofile or Xinitrc. Read the startup files article for
further information.

> Command only

To manually enable default compositing effects during a session, use the
following command:

    $ compton

Alternatively, to disable all shadowing effects during a session, the -C
and -G arguments must be added:

    $ compton -CG

To autostart compton as a background (Daemon) process for a session, the
-b argument must be used:

    compton -b

To disable all shadowing effects from the Daemon process, the -C and -G
arguments must again be added:

    compton -CGb

Finally, this is an example where additional arguments that require
values to be set have been used:

    compton -cCGfF -o 0.38 -O 200 -I 200 -t 0 -l 0 -r 3 -D2 -m 0.88

> Using a configuration file

To use a custom configuration file with compton during a session, use
the following command:

    compton --config <path/to/compton.conf>

To autostart compton as a background (Daemon) process for a session, the
-b argument must again be used:

    compton --config <path/to/compton.conf> -b

It is recommended to either create the configuration file in the hidden
~/.config directory (~/.config/compton.conf) or as a hidden file in the
Home directory (~/.compton.conf). A sample script has been provided:

    # Shadow
    shadow = true;			# Enabled client-side shadows on windows.
    no-dock-shadow = true;		# Avoid drawing shadows on dock/panel windows.
    no-dnd-shadow = true;		# Don't draw shadows on DND windows.
    clear-shadow = true;		# Zero the part of the shadow's mask behind the 
    				# window. Fix some weirdness with ARGB windows.
    shadow-radius = 7;		# The blur radius for shadows. (default 12)
    shadow-offset-x = -7;		# The left offset for shadows. (default -15)
    shadow-offset-y = -7;		# The top offset for shadows. (default -15)
    # shadow-opacity = 0.7;		# The translucency for shadows. (default .75)
    # shadow-red = 0.0;		# Red color value of shadow. (0.0 - 1.0, defaults to 0)
    # shadow-green = 0.0;		# Green color value of shadow. (0.0 - 1.0, defaults to 0)
    # shadow-blue = 0.0;		# Blue color value of shadow. (0.0 - 1.0, defaults to 0)
    shadow-exclude = [ "n:e:Notification" ];	# Exclude conditions for shadows.
    # shadow-exclude = "n:e:Notification";
    shadow-ignore-shaped = true;	# Avoid drawing shadow on all shaped windows
     				# (see also: --detect-rounded-corners)

    # Opacity
    menu-opacity = 0.9;			# The opacity for menus. (default 1.0)
    inactive-opacity = 0.9;			# Default opacity of inactive windows. (0.0 - 1.0)
    # active-opacity = 0.8;			# Default opacity for active windows. (0.0 - 1.0)
    # frame-opacity = 0.8;			# Opacity of window titlebars and borders. (0.1 - 1.0)
    # inactive-opacity-override = true;	# Let inactive opacity set by 'inactive-opacity' overrides
     					# value of _NET_WM_OPACITY. Bad choice.
    alpha-step = 0.06;			# XRender backend: Step size for alpha pictures. Increasing
    					# it may result in less X resource usage,
    					# Yet fading may look bad.
    # inactive-dim = 0.2;			# Dim inactive windows. (0.0 - 1.0)
    # inactive-dim-fixed = true;		# Do not let dimness adjust based on window opacity.
    # blur-background = true;		# Blur background of transparent windows.
    					# Bad performance with X Render backend.
    					# GLX backend is preferred.
    # blur-background-frame = true;		# Blur background of opaque windows with transparent
    					# frames as well.
    blur-background-fixed = false;		# Do not let blur radius adjust based on window opacity.
    blur-background-exclude = [ "window_type = 'dock'", "window_type = 'desktop'" ];
    					# Exclude conditions for background blur.

    # Fading
    fading = true;			# Fade windows during opacity changes.
    # fade-delta = 30;		# The time between steps in a fade in milliseconds. (default 10).
    fade-in-step = 0.03;		# Opacity change between steps while fading in. (default 0.028).
    fade-out-step = 0.03;		# Opacity change between steps while fading out. (default 0.03).
    # no-fading-openclose = true;	# Avoid fade windows in/out when opening/closing.
    fade-exclude = [ ];		# Exclude conditions for fading.

    # Other
    backend = "xrender"		# Backend to use: "xrender" or "glx". GLX backend is typically
    				# much faster but depends on a sane driver.
    mark-wmwin-focused = true;	# Try to detect WM windows and mark them as active.
    mark-ovredir-focused = true;	# Mark all non-WM but override-redirect windows active (e.g. menus).
    use-ewmh-active-win = false;	# Use EWMH _NET_WM_ACTIVE_WINDOW to determine which window is focused
    				# instead of using FocusIn/Out events. Usually more reliable but
    				# depends on a EWMH-compliant WM.
    detect-rounded-corners = true;	# Detect rounded corners and treat them as rectangular when --shadow-ignore- shaped is on.
    detect-client-opacity = true;	# Detect _NET_WM_OPACITY on client windows, useful for window
    				# managers not passing _NET_WM_OPACITY of client windows to frame
    				# windows.
    refresh-rate = 0;		# For --sw-opti: Specify refresh rate of the screen. 0 for auto.
    vsync = "none";		# "none", "drm", "opengl", "opengl-oml", "opengl-swc", "opengl-mswc" 
    				# See man page for more details.
    dbe = false;			# Enable DBE painting mode. Rarely needed.
    paint-on-overlay = false;	# Painting on X Composite overlay window. Recommended.
    sw-opti = false;		# Limit compton to repaint at most once every 1 / refresh_rate.
    				# Incompatible with certain VSync methods.
    unredir-if-possible = false;	# Unredirect all windows if a full-screen opaque window is
    				# detected, to maximize performance for full-screen windows.
    focus-exclude = [ ];		# A list of conditions of windows that should always be considered
    				# focused.
    detect-transient = true;	# Use WM_TRANSIENT_FOR to group windows, and consider windows in
    				# the same group focused at the same time.
    detect-client-leader = true;	# Use WM_CLIENT_LEADER to group windows.
    invert-color-include = [ ];	# Conditions for windows to be painted with inverted color.

    # GLX backend			# GLX backend fine-tune options. See man page for more info.
    # glx-no-stencil = true;	# Recommended.
    glx-copy-from-front = false;	# Useful with --glx-swap-method,
    # glx-use-copysubbuffermesa = true; # Recommended if it works. Breaks VSync.
    # glx-no-rebind-pixmap = true;	# Recommended if it works.	
    glx-swap-method = "undefined";	# See man page.

    # Window type settings
    wintypes:
    {
      tooltip = { fade = true; shadow = false; opacity = 0.75; focus = true; };
      # fade: Fade the particular type of windows.
      # shadow: Give those windows shadow
      # opacity: Default opacity for the type of windows.
      # focus: Whether to always consider windows of this type focused.
    };

Disable conky shadowing

To disable shadows around conky windows - where used - first amend the
conky configuration file ~/.conkyrc as follows:

    own_window_class conky

Then amend the compton configuration file as follows:

    shadow-exclude = "class_g = 'conky'";

Multihead
---------

If a multihead configuration is used without xinerama - meaning that X
server is started with more than one screen - then compton will start on
only one screen by default. It can be started on all screens by using
the -d argument. For example, compton can be executed for 4 monitors
with the following command:

    seq 0 3 | xargs -l1 -I@ compton -b -d :0.@

Troubleshooting
---------------

The use of compositing effects may on occasion cause issues such as
visual glitches when not configured correctly for use with other
applications and programs.

> Slock

Note:Use of the --focus-exclude argument may be a cleaner solution.

Where inactive window transparancy has been enabled (the -i argument
when running as a command), this may provide troublesome results when
also using slock. The solution is to amend the transparency to 0.2. For
example, where running compton arguments as a command:

    compton <any other arguments> -i 0.2

Otherwise, where using a configuration file:

    inactive-dim = 0.2;

Retrieved from
"https://wiki.archlinux.org/index.php?title=Compton&oldid=301233"

Categories:

-   X Server
-   Eye candy

-   This page was last modified on 24 February 2014, at 11:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
