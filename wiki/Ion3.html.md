Ion3
====

Contents
--------

-   1 Introduction
-   2 Installation
-   3 Configuration
    -   3.1 cfg_ion.lua
    -   3.2 cfg_bindings.lua
    -   3.3 cfg_menus.lua
    -   3.4 cfg_ionws.lua
    -   3.5 look.lua

Introduction
------------

Ionis a tiling window manager with tabbed frames. It uses Lua as an
embedded interpreter which handles all of the configuration. It mainly
uses the keyboard to access the functions but also supports the mouse
for some things.

Installation
------------

Ion3 is no longer in any of the repositories as mentioned in this news
item [1]. So you will have to install it using the PKGBUILD available
from AUR: ion-3.

Copy the configurationfiles to your home directory:

    cp /etc/ion3/* ~/.ion3

To start Ion3 just append the following line in ~/.xinitrc :

    exec ion3

Now you are ready to begin to configure Ion as described below.

Configuration
-------------

Note: The files below have been heavily modified from the defaults to
better suit my needs. /xerxes2

> cfg_ion.lua

This is Ion3' main configurationfile.

    -- Ion main configuration file
    --

    --
    -- Some basic setup
    --

    -- Set default modifiers. Alt should usually be mapped to Mod1 on
    -- XFree86-based systems. The flying window keys are probably Mod3
    -- or Mod4; see the output of 'xmodmap'.
    MOD1="Mod4+"
    MOD2="Mod1+"

    ioncore.set{
        -- Maximum delay between clicks in milliseconds to be considered a
        -- double click.
        dblclick_delay=250,

        -- For keyboard resize, time (in milliseconds) to wait after latest
        -- key press before automatically leaving resize mode (and doing
        -- the resize in case of non-opaque move).
        kbresize_delay=1500,

        -- Opaque resize?
        opaque_resize=false,

        -- Movement commands warp the pointer to frames instead of just
        -- changing focus. Enabled by default.
        warp=true,
        
        -- Default workspace type.
        default_ws_type="WIonWS",
    }

    --
    -- Load some modules, extensions and other configuration files
    --

    -- Load some modules.
    dopath("mod_query")
    dopath("mod_menu")
    dopath("mod_ionws")
    dopath("mod_floatws")
    dopath("mod_panews")
    --dopath("mod_statusbar")
    --dopath("mod_dock")
    dopath("mod_sp")

    -- Load some kludges to make apps behave better.
    dopath("cfg_kludges")

    -- Make some bindings.
    dopath("cfg_bindings")

    -- Define some menus (mod_menu required)
    dopath("cfg_menus")

    -- Load additional user configuration. 'true' as second parameter asks
    -- Ion not to complain if the file is not found.
    dopath("cfg_user", true)

The Modkeyes handles your hotkeys when you holds them in(Modkey +
hotkey). The dopath command includes modules that Ion should load on
startup. Just uncomment those you do not want to load.

> cfg_bindings.lua

In this file you set your basic keybindings.

    -- 
    -- Ion bindings configuration file. Global bindings and bindings common 
    -- to screens and all types of frames only. See modules' configuration 
    -- files for other bindings.
    --

    -- WScreen context bindings
    --
    -- The bindings in this context are available all the time.
    --
    -- The variable MOD1 should contain a string of the form 'Mod1+'
    -- where Mod1 maybe replaced with the modifier you want to use for most
    -- of the bindings. Similarly MOD2 may be redefined to add a 
    -- modifier to some of the F-key bindings.

    defbindings("WScreen", {
        bdoc("Switch to n:th object (workspace, full screen client window) "..
             "within current screen."),
        kpress(MOD1.."1", "WScreen.switch_nth(_, 0)"),
        kpress(MOD1.."2", "WScreen.switch_nth(_, 1)"),
        kpress(MOD1.."3", "WScreen.switch_nth(_, 2)"),
        kpress(MOD1.."4", "WScreen.switch_nth(_, 3)"),
        kpress(MOD1.."5", "WScreen.switch_nth(_, 4)"),
        kpress(MOD1.."6", "WScreen.switch_nth(_, 5)"),
        kpress(MOD1.."7", "WScreen.switch_nth(_, 6)"),
        kpress(MOD1.."8", "WScreen.switch_nth(_, 7)"),
        kpress(MOD1.."9", "WScreen.switch_nth(_, 8)"),
        kpress(MOD1.."0", "WScreen.switch_nth(_, 9)"),
        
    --    bdoc("Switch to next/previous object within current screen."),
    --    kpress(MOD2.."comma", "ioncore.goto_previous()"),
    --    kpress(MOD2.."period", "ioncore.goto_next()"),
        
        kpress(MOD1.."Left", "WScreen.switch_prev(_)"),
        kpress(MOD1.."Right", "WScreen.switch_next(_)"),

        

        submap(MOD1.."K", {
            bdoc("Go to previous active object."),
            kpress("K", "ioncore.goto_previous()"),
            
            bdoc("Clear all tags."),
            kpress("T", "ioncore.clear_tags()"),
        }),
        
        bdoc("Go to n:th screen on multihead setup."),
        kpress(MOD1.."Shift+1", "ioncore.goto_nth_screen(0)"),
        kpress(MOD1.."Shift+2", "ioncore.goto_nth_screen(1)"),
        
        bdoc("Go to next/previous screen on multihead setup."),
        kpress(MOD1.."Shift+Left", "ioncore.goto_next_screen()"),
        kpress(MOD1.."Shift+Right", "ioncore.goto_prev_screen()"),
        
        bdoc("Create a new workspace of chosen default type."),
        kpress(MOD1.."F9", "ioncore.create_ws(_)"),
        
        bdoc("Display the main menu."),
        kpress(MOD1.."F12", "mod_menu.bigmenu(_, _sub, 'mainmenu')"),
        mpress("Button3", "mod_menu.pmenu(_, _sub, 'mainmenu')"),
        
        bdoc("Display the window list menu."),
        mpress("Button2", "mod_menu.pmenu(_, _sub, 'windowlist')"),
    })

    -- WMPlex context bindings
    --
    -- These bindings work in frames and on screens. The innermost of such
    -- contexts/objects always gets to handle the key press. Most of these 
    -- bindings define actions on client windows. (Remember that client windows 
    -- can be put in fullscreen mode and therefore may not have a frame.)
    -- 
    -- The "_sub:WClientWin" guards are used to ensure that _sub is a client
    -- window in order to stop Ion from executing the callback with an invalid
    -- parameter if it is not and then complaining.

    defbindings("WMPlex", {
        bdoc("Close current object."),
        kpress_wait(MOD1.."C", "WRegion.rqclose_propagate(_, _sub)"),
        
        bdoc("Nudge current client window. This might help with some "..
             "programs' resizing problems."),
        kpress_wait(MOD1.."L", 
                    "WClientWin.nudge(_sub)", "_sub:WClientWin"),

        bdoc("Toggle fullscreen mode of current client window."),
        kpress_wait(MOD1.."Return", 
                    "WClientWin.set_fullscreen(_sub, 'toggle')", 
                    "_sub:WClientWin"),

        submap(MOD1.."K", {
           bdoc("Kill client owning current client window."),
           kpress("C", "WClientWin.kill(_sub)", "_sub:WClientWin"),
                                    
           bdoc("Send next key press to current client window. "..
                "Some programs may not allow this by default."),
           kpress("Q", "WClientWin.quote_next(_sub)", "_sub:WClientWin"),
        }),

        bdoc("Query for manual page to be displayed."),
        kpress(MOD2.."F1", "mod_query.query_man(_, ':man')"),

        bdoc("Show the Ion manual page."),
        kpress(MOD1.."F1", "ioncore.exec_on(_, ':man ion3')"),

        bdoc("Run a terminal emulator."),
        kpress(MOD1.."F2", "ioncore.exec_on(_, 'urxvt')"),
        
        bdoc("Query for command line to execute."),
        kpress(MOD2.."F3", "mod_query.query_exec(_)"),

        bdoc("Query for Lua code to execute."),
        kpress(MOD1.."F3", "mod_query.query_lua(_)"),

        bdoc("Query for host to connect to with SSH."),
        kpress(MOD2.."F4", "mod_query.query_ssh(_, ':ssh')"),

        bdoc("Query for file to edit."),
        kpress(MOD2.."F5", 
               "mod_query.query_editfile(_, 'run-mailcap --action=edit')"),

        bdoc("Query for file to view."),
        kpress(MOD2.."F6", 
               "mod_query.query_runfile(_, 'run-mailcap --action=view')"),

        bdoc("Query for workspace to go to or create a new one."),
        kpress(MOD2.."F9", "mod_query.query_workspace(_)"),
        
        bdoc("Query for a client window to go to."),
        kpress(MOD1.."G", "mod_query.query_gotoclient(_)"),
    })

    -- WFrame context bindings
    --
    -- These bindings are common to all types of frames. The rest of frame
    -- bindings that differ between frame types are defined in the modules' 
    -- configuration files.

    defbindings("WFrame", {
        bdoc("Tag current object within the frame."),
        kpress(MOD1.."T", "WRegion.set_tagged(_sub, 'toggle')", "_sub:non-nil"),

        submap(MOD1.."K", {
            bdoc("Switch to n:th object within the frame."),
            kpress("1", "WFrame.switch_nth(_, 0)"),
            kpress("2", "WFrame.switch_nth(_, 1)"),
            kpress("3", "WFrame.switch_nth(_, 2)"),
            kpress("4", "WFrame.switch_nth(_, 3)"),
            kpress("5", "WFrame.switch_nth(_, 4)"),
            kpress("6", "WFrame.switch_nth(_, 5)"),
            kpress("7", "WFrame.switch_nth(_, 6)"),
            kpress("8", "WFrame.switch_nth(_, 7)"),
            kpress("9", "WFrame.switch_nth(_, 8)"),
            kpress("0", "WFrame.switch_nth(_, 9)"),
            
            bdoc("Switch to next/previous object within the frame."),
            kpress("N", "WFrame.switch_next(_)"),
            kpress("P", "WFrame.switch_prev(_)"),
            
            bdoc("Move current object within the frame left/right."),
            kpress("comma", "WFrame.dec_index(_, _sub)", "_sub:non-nil"),
            kpress("period", "WFrame.inc_index(_, _sub)", "_sub:non-nil"),
                   
            bdoc("Maximize the frame horizontally/vertically."),
            kpress("H", "WFrame.maximize_horiz(_)"),
            kpress("V", "WFrame.maximize_vert(_)"),

            bdoc("Attach tagged objects to this frame."),
            kpress("A", "WFrame.attach_tagged(_)"),
        }),

        kpress(MOD1.."comma", "WFrame.switch_prev(_)"),
        kpress(MOD1.."period", "WFrame.switch_next(_)"),

        bdoc("Query for a client window to attach to active frame."),
        kpress(MOD1.."A", "mod_query.query_attachclient(_)"),

        bdoc("Display frame context menu."),
        kpress(MOD1.."M", "mod_menu.menu(_, _sub, 'ctxmenu')"),
        mpress("Button3", "mod_menu.pmenu(_, _sub, 'ctxmenu')"),
        
        bdoc("Begin move/resize mode."),
        kpress(MOD1.."R", "WFrame.begin_kbresize(_)"),
        
        bdoc("Switch the frame to display the object indicated by the tab."),
        mclick("Button1@tab", "WFrame.p_switch_tab(_)"),
        mclick("Button2@tab", "WFrame.p_switch_tab(_)"),
        
        bdoc("Resize the frame."),
        mdrag("Button1@border", "WFrame.p_resize(_)"),
        mdrag(MOD1.."Button3", "WFrame.p_resize(_)"),
        
        bdoc("Move the frame."),
        mdrag(MOD1.."Button1", "WFrame.p_move(_)"),
        
        bdoc("Move objects between frames by dragging and dropping the tab."),
        mdrag("Button1@tab", "WFrame.p_tabdrag(_)"),
        mdrag("Button2@tab", "WFrame.p_tabdrag(_)"),
               
    })

    -- WMoveresMode context bindings
    -- 
    -- These bindings are available keyboard move/resize mode. The mode
    -- is activated on frames with the command begin_kbresize (bound to
    -- MOD1.."R" above by default).

    defbindings("WMoveresMode", {
        bdoc("Cancel the resize mode."),
        kpress("AnyModifier+Escape","WMoveresMode.cancel(_)"),

        bdoc("End the resize mode."),
        kpress("AnyModifier+Return","WMoveresMode.finish(_)"),

        bdoc("Grow in specified direction."),
        kpress("Left",  "WMoveresMode.resize(_, 1, 0, 0, 0)"),
        kpress("Right", "WMoveresMode.resize(_, 0, 1, 0, 0)"),
        kpress("Up",    "WMoveresMode.resize(_, 0, 0, 1, 0)"),
        kpress("Down",  "WMoveresMode.resize(_, 0, 0, 0, 1)"),
        kpress("F",     "WMoveresMode.resize(_, 1, 0, 0, 0)"),
        kpress("B",     "WMoveresMode.resize(_, 0, 1, 0, 0)"),
        kpress("P",     "WMoveresMode.resize(_, 0, 0, 1, 0)"),
        kpress("N",     "WMoveresMode.resize(_, 0, 0, 0, 1)"),
        
        bdoc("Shrink in specified direction."),
        kpress("Shift+Left",  "WMoveresMode.resize(_,-1, 0, 0, 0)"),
        kpress("Shift+Right", "WMoveresMode.resize(_, 0,-1, 0, 0)"),
        kpress("Shift+Up",    "WMoveresMode.resize(_, 0, 0,-1, 0)"),
        kpress("Shift+Down",  "WMoveresMode.resize(_, 0, 0, 0,-1)"),
        kpress("Shift+F",     "WMoveresMode.resize(_,-1, 0, 0, 0)"),
        kpress("Shift+B",     "WMoveresMode.resize(_, 0,-1, 0, 0)"),
        kpress("Shift+P",     "WMoveresMode.resize(_, 0, 0,-1, 0)"),
        kpress("Shift+N",     "WMoveresMode.resize(_, 0, 0, 0,-1)"),
        
        bdoc("Move in specified direction."),
        kpress(MOD1.."Left",  "WMoveresMode.move(_,-1, 0)"),
        kpress(MOD1.."Right", "WMoveresMode.move(_, 1, 0)"),
        kpress(MOD1.."Up",    "WMoveresMode.move(_, 0,-1)"),
        kpress(MOD1.."Down",  "WMoveresMode.move(_, 0, 1)"),
        kpress(MOD1.."F",     "WMoveresMode.move(_,-1, 0)"),
        kpress(MOD1.."B",     "WMoveresMode.move(_, 1, 0)"),
        kpress(MOD1.."P",     "WMoveresMode.move(_, 0,-1)"),
        kpress(MOD1.."N",     "WMoveresMode.move(_, 0, 1)"),
    })

> cfg_menus.lua

In this file you configure your main menu.

    --
    -- Ion menu definitions
    --

    -- Main menu
    defmenu("mainmenu", {
        submenu("Programs",         "appmenu"),
        menuentry("Lock screen",    "ioncore.exec_on(_, 'xlock')"),
        menuentry("Help",           "mod_query.query_man(_)"),
        menuentry("About Ion",      "mod_query.show_about_ion(_)"),
        submenu("Styles",           "stylemenu"),
        submenu("Session",          "sessionmenu"),
    })

    -- Application menu
    defmenu("appmenu", {
        menuentry("Firefox","ioncore.exec_on(_, 'firefox')"),
        menuentry("Thunderbird","ioncore.exec_on(_, 'thunderbird')"),
        menuentry("Editor","ioncore.exec_on(_, 'lazy-edit')"),
        menuentry("Player","ioncore.exec_on(_, 'lazy-player')"),
        menuentry("FTP","ioncore.exec_on(_, 'lazy-ftp')"),
        menuentry("GVim","ioncore.exec_on(_, 'gvim')"),
        menuentry("Run...", "mod_query.query_exec(_)"),
    })

    -- Session control menu
    defmenu("sessionmenu", {
        menuentry("Save",           "ioncore.snapshot()"),
        menuentry("Restart",        "ioncore.restart()"),
        menuentry("Restart PWM",    "ioncore.restart_other('pwm')"),
        menuentry("Restart TWM",    "ioncore.restart_other('twm')"),
        menuentry("Exit",           "ioncore.shutdown()"),
    })

    -- Context menu (frame/client window actions)
    defctxmenu("WFrame", {
        menuentry("Close",          "WRegion.rqclose_propagate(_, _sub)"),
        menuentry("Kill",           "WClientWin.kill(_sub)",
                                    "_sub:WClientWin"),
        menuentry("(Un)tag",        "WRegion.set_tagged(_sub, 'toggle')",
                                    "_sub:non-nil"),
        menuentry("Attach tagged",  "WFrame.attach_tagged(_)"),
        menuentry("Clear tags",     "ioncore.clear_tags()"),
        menuentry("Window info",    "mod_query.show_clientwin(_, _sub)",
                                    "_sub:WClientWin"),
    })

> cfg_ionws.lua

In this file you configure your ion workspaces.

    --
    -- Ion ionws module configuration file
    --

    -- Bindings for the tiled workspaces (ionws). These should work on any 
    -- object on the workspace.

    defbindings("WIonWS", {
        bdoc("Split current frame vertically."),
        kpress(MOD1.."V", "WIonWS.split_at(_, _sub, 'bottom', true)"),

        bdoc("Split current frame horizontally."),
        kpress(MOD1.."H", "WIonWS.split_at(_, _sub, 'right', true)"),
        
        bdoc("Destroy current frame."),
        kpress(MOD1.."Tab", "WIonWS.unsplit_at(_, _sub)"),

        bdoc("Go to frame above/below/right/left of current frame."),
        kpress(MOD2.."Up", "WIonWS.goto_dir(_, 'above')"),
        kpress(MOD2.."Down", "WIonWS.goto_dir(_, 'below')"),
        kpress(MOD2.."Right", "WIonWS.goto_dir(_, 'right')"),
        kpress(MOD2.."Left", "WIonWS.goto_dir(_, 'left')"),
        submap(MOD1.."K", {
            bdoc("Split current frame horizontally."),
            kpress("S", "WIonWS.split_at(_, _sub, 'right', true)"),
            
            bdoc("Destroy current frame."),
            kpress("X", "WIonWS.unsplit_at(_, _sub)"),
        }),
    })

    -- Frame bindings. These work in (Ion/tiled-style) frames. Some bindings
    -- that are common to all frame types and multiplexes are defined in
    -- ion-bindings.lua.

    --defbindings("WFrame-on-WIonWS", {
    --})

    -- WFloatFrame context menu extras

    if mod_menu then
        defctxmenu("WIonWS", {
            menuentry("Destroy frame", 
                      "WIonWS.unsplit_at(_, _sub)"),
            menuentry("Split vertically", 
                      "WIonWS.split_at(_, _sub, 'bottom', true)"),
            menuentry("Split horizontally", 
                      "WIonWS.split_at(_, _sub, 'right', true)"),
            menuentry("Flip", "WIonWS.flip_at(_, _sub)"),
            menuentry("Transpose", "WIonWS.transpose_at(_, _sub)"),
            submenu("Float split", {
                menuentry("At left", 
                          "WIonWS.set_floating_at(_, _sub, 'toggle', 'left')"),
                menuentry("At right", 
                          "WIonWS.set_floating_at(_, _sub, 'toggle', 'right')"),
                menuentry("Above",
                          "WIonWS.set_floating_at(_, _sub, 'toggle', 'up')"),
                menuentry("Below",
                          "WIonWS.set_floating_at(_, _sub, 'toggle', 'down')"),
            }),
            submenu("At root", {
                menuentry("Split vertically", 
                          "WIonWS.split_top(_, 'bottom')"),
                menuentry("Split horizontally", 
                          "WIonWS.split_top(_, 'right')"),
                menuentry("Flip", "WIonWS.flip_at(_)"),
                menuentry("Transpose", "WIonWS.transpose_at(_)"),
            }),
        })
    end

> look.lua

In this file you set your theme. Your default theme is set on the
bottom:

    dopath("look_xerxes") 

The themes are called look_<name>.lua and you can make your own by
switching the name.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ion3&oldid=277282"

Category:

-   Tiling WMs

-   This page was last modified on 1 October 2013, at 20:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
