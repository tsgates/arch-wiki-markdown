Compiz Configuration
====================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Compiz.     
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 General                                                            |
|     -   1.1 edge bindings                                                |
|                                                                          |
| -   2 Workspace                                                          |
|     -   2.1 Desktop Plane                                                |
|     -   2.2 Expo                                                         |
|     -   2.3 Widget Layer                                                 |
|                                                                          |
| -   3 Accessibility                                                      |
|     -   3.1 Magnifier                                                    |
|                                                                          |
| -   4 window management                                                  |
|     -   4.1 Grid                                                         |
|     -   4.2 Scale                                                        |
|                                                                          |
| -   5 Sample Configurations                                              |
+--------------------------------------------------------------------------+

General
-------

> edge bindings

While there are many things you can do with the edge bindings (not
wasting key combinations / mouse-buttons for short-cuts), the standard
settings of some plug-ins might be rather annoying or confusing. If you
notice any seemingly random view-port changes, plug-in activations or
just "stuff moving away and around wtf!?", check your activated plug-ins
for edge bindings.

Workspace
---------

> Desktop Plane

While many seem to switch to Compiz in the first place because of having
seen the Desktop Cube, some might find the Plane more attractive, as it
offers some work-flow enhancements like being able to drag windows up or
down from the current Desktop to Desktop-2 / Desktop+2

> Expo

Can be used to see all your Desktops at once. Also if you do not like
using a window decorator, it is a good way to drag your windows around
on a or between viewpoints (just put expo on a mouse button, if you got
one to spare). Blends in especially good with Desktop plane, as 2x2 (/
3x3) view-ports enable it to use to full screen without deforming them.

  

> Widget Layer

As quite a few auto-hiding applications do not seem to work that well
with compiz, the widget plug-in comes in handy. You can set it to show
all windows you defined as widgets using the same screen border /
mouse-over. Resizing (maximized) windows when adding/removing a dock
seems to be more painless with widget layer than with built-in auto-hide
for most docks / panels (well - the ones I tried).

Accessibility
-------------

> Magnifier

The magnifier comes in especially handy if you use your Desktop from a
bigger Desktop (p.E. as media-centre). Using the fish eye mode with a
big radius might be most effective while trying to do minor "menu / file
navigation" and setting zoom in/out to <TopEdge>Button4 / 5 lets you
easily zoom with mouse only without wasting a mouse button (mouse wheel
@ very top of screen).

window management
-----------------

> Grid

Part of the compiz-fusion unsupported plug-in package available from the
AUR; use keys (standard: ctrl+alt+[numpad]) to resize and arrange
windows to an imaginary grid. Works & looks best without window
decorations as sort of "tiling window manager".

> Scale

The scale Add-on lets you easily choose a window from thumbnails to
switch to, to close, or to switch it to the current view-port (see
utilities / scale extensions) offering an efficient window chooser if
you do not have too many open at once (10 per screen work fine for me).
This one might be especially useful on a mouse button, too, if you've
got one to spare.

Sample Configurations
---------------------

Compiz as tiling window manager without window decorations:

-   ctrl+alt+[numpad] arranges the current window
-   left and right bottom corner shows Taskbar
-   mouse control for everything (but typing ;))
-   some effects
-   & more

    [core]
    as_active_plugins = core;session;glib;grid;notification;workarounds;place;put;wall;regex;blur;dbus;fs;inotify;widget;animation;resize;text;mousepoll;obs;expo;fade;move;staticswitcher;mag;scale;scaleaddon;
    s0_hsize = 2
    s0_vsize = 2

    [wall]
    as_show_switcher = false
    s0_edgeflip_dnd = true
    as_flip_down_edge = 

    [expo]
    as_reflection = false
    as_vp_brightness = 100.000000
    as_expo_edge = 
    as_expo_button = Button9
    as_mipmaps = true
    as_zoom_time = 0.150000
    as_vp_distance = 0.000000

    [scale]
    as_initiate_edge = 
    as_initiate_all_button = Button8
    s0_darken_back = false
    s0_opacity = 100
    s0_overlay_icon = 0
    s0_multioutput_mode = 1
    as_show_desktop = false
    s0_hover_time = 100
    s0_spacing = 4
    s0_timestep = 0.100000
    s0_speed = 2.615500

    [scaleaddon]
    s0_window_highlight = true
    s0_highlight_color = #ffffff08
    s0_window_title = 0

    [mag]
    as_zoom_in_button = <TopEdge>Button4
    as_zoom_out_button = <TopEdge>Button5
    s0_mode = 2
    s0_radius = 600

    [place]
    s0_multioutput_mode = 3
    s0_mode = 2

    [workarounds]
    as_notification_daemon_fix = true
    as_firefox_menu_fix = true
    as_legacy_fullscreen = true
    as_qt_fix = true
    as_convert_urgency = true

    [move]
    as_opacity = 85 

    [blur]
    s0_filter = 1
    s0_independent_tex = true
    s0_mipmap_lod = 1.700000
    s0_gaussian_radius = 7
    s0_alpha_blur_match = (any) & !(class=Conky)

    [put]
    as_put_next_output_button = Button10
    s0_speed = 10.441400
    s0_timestep = 0.100000 

    [obs]
    s0_opacity_matches = type=dock | Tooltip | Menu | PopupMenu | DropdownMenu;(any) & !(class=Whaawmp.py | class=Gimp | class=Inkscape | class=Xfdesktop | class=Ristretto);
    s0_opacity_values = 70;90;

    [animation]
    s0_close_effects = animation:Dream;animation:Fade;animation:Fade;
    s0_open_effects = animation:Magic Lamp;animation:Fade;animation:Fade;
    s0_focus_effects = animation:Dodge;
    s0_open_durations = 150;100;100;
    s0_close_durations = 150;100;100;
    s0_minimize_durations = 150;
    s0_shade_durations = 150;
    s0_focus_durations = 150;

    [widget]
    s0_bg_brightness = 100
    s0_fade_time = 0.250000
    s0_match = type=Dock
    as_toggle_edge = BottomLeft|BottomRight
    s0_end_on_click = false

    [staticswitcher]
    s0_highlight_mode = 2
    s0_highlight_rect_hidden = 2
    as_next_key = Disabled
    as_next_no_popup_key = <Alt>Tab
    as_prev_all_key = Disabled

Retrieved from
"https://wiki.archlinux.org/index.php?title=Compiz_Configuration&oldid=198075"

Categories:

-   Eye candy
-   Stacking WMs
