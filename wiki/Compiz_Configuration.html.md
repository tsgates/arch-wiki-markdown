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
"https://wiki.archlinux.org/index.php?title=Compiz_Configuration&oldid=305656"

Categories:

-   Eye candy
-   Stacking WMs

-   This page was last modified on 19 March 2014, at 19:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
