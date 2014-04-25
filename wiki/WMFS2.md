WMFS2
=====

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: A new WM, in     
                           need of more varied and  
                           in-depth information     
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Summary help replacing me

An introduction to WMFS2, a dynamic tiling window manager.

> Related

WMFS

Comparison of Tiling Window Managers

From the project home page:

WMFS2 is a lightweight and highly configurable tiling window manager for
X written in C. WMFS2 is a free software distributed under the BSD
license. it can be drive from keyboard or mouse and it's configuration
stands in one text file easily understandable.

Contents
--------

-   1 Differences from WMFS
-   2 Installation
-   3 Basic usage
-   4 Configuration
    -   4.1 Themes
    -   4.2 Clients
    -   4.3 Statusbar
        -   4.3.1 Elements
            -   4.3.1.1 Tags
            -   4.3.1.2 Launchers
            -   4.3.1.3 Statustext

Differences from WMFS
---------------------

For those moving from the original WMFS, there are a few differences to
be aware of:

-   Window management no longer revolves around preset tiling layouts;
    rather, clients are arranged manually using the mouse or keyboard
    shortcuts
-   The syntax of ~/.config/wmfs/wmfsrc (the default configuration file)
    has changed slightly; those wishing to merge config files should do
    so carefully
-   There is no longer an application menu
-   Xft is no longer supported
-   Aesthetically, WMFS2 is more minimalistic than its predecessor

And of course, the new, fun stuff:

-   Multiple status bars are supported, and statusbars are more
    configurable
-   Tags may be dynamically created and destroyed
-   Custom text- and icon-based launchers may be created, including a
    click-able "dock"
-   Icons may be used in place of tag names

Installation
------------

WMFS2 can be installed via the wmfs2-git package in the AUR.

Basic usage
-----------

WMFS2 primarily differs from the original WMFS in the way windows are
managed. While in the previous version windows were arranged according
to predefined layouts - as they are in window managers such as DWM and
Awesome - WMFS2 features key and mouse bindings allowing the user to
manually configure layouts on each tag - as is the case with wmii, i3
and others.

If one opens, say, multiple instances of a terminal (by default,
Super+Enter opens urxvt), they will be arranged in a diminishing
"spiral" on the screen, with each one opening on the left side in
smaller and smaller sizes. These can then be rotated, changing the
orientation of the master window (the one that takes up have the screen
on its own) and slave windows (the ones that shrink as you open more).
Also, windows may be "tabbed" together, maximizing all clients and
placing independent tabs in a single titlebar at the top of the window.
This keeps the focused window maximized while placing the others
"behind" it, and allowing the user to cycle through them using a key
binding, thus preventing the need to click on a taskbar or dock to
repeatedly minimize/maximize individual windows.

Individual clients can be rearranged using keyboard shortcuts;
alternatively, a window can be clicked-and-dragged by its titlebar, or
may be clicked-and-dragged from any point in the client while holding
down a mod key such as Alt or Super (the "Windows" key). Finally, they
may also be toggled into "free" or "floating" mode, and moved around
like stacked windows on a traditional desktop.

Both key and mouse bindings are specified under the [keys] section of
wmfsrc, and the keybindings and possible functions are explained on the
WMFS2 wiki.

Configuration
-------------

Copy the default configuration file to your home folder:

     $ cp /etc/xdg/wmfs/wmfsrc ~/.config/wmfs/wmfsrc

By default, this single configuration file is all that is required. If
so desired, the file can be split into separate parts (e.g. one file for
themes, one for keybindings, etc.) by using the @include command near
the top of wmfsrc. For example,

    @include ~/.config/wmfs/themes

tells WMFS to source a text file named "themes." Various
themes/colorschemes can be written to the file, and on start-up WMFS
will apply the one specified in wmfsrc. Themes are applied independently
for the panel itself, tags ("virtual desktop" markers) and window
borders and titlebars.

> Themes

The [themes] section of wmfsrc dictates the color and width of
statusbars, tags, window borders and titlebars. Colors are specified by
way of their hex codes, e.g. "#FFFFFF" specifies pure white, while
"#000000" specifies pure black. As mentioned above, multiple themes can
be written out in a separate text file, and then applied to each element
individually by adding a "theme" section to the relevant section.

> Clients

The [client] section of wmfsrc specifies general rules on how clients
behave, while the [rules] section dictates how individual applications
are to be handled by the window manager.

    [client]

      theme = "default"
      key_modifier = "Super"

      [mouse] button = "1" func = "client_focus_click"    [/mouse]
      [mouse] button = "1" func = "mouse_swap"            [/mouse]
      [mouse] button = "2" func = "mouse_tab"             [/mouse]
      [mouse] button = "3" func = "mouse_resize"          [/mouse]
      [mouse] button = "4" func = "client_focus_next_tab" [/mouse]
      [mouse] button = "5" func = "client_focus_prev_tab" [/mouse]

    [/client]

    [rules]

      [rule]
          instance = "chromium"
          # class = ""
          # role   = ""
          # name   = ""
          # theme  = "default"

          tag    = 1  # 2nd tag
          screen = 0

          free       = false
          tab        = false
      [/rule]

    [/rules]

By default, all clients open on the currently active tag, and can be
manipulated using the default mouse or key bindings. By specifying
per-application rules, the user can control which applications open on
which tags, whether they will be floating by default, and whether they
will be tabbed or not.

-   theme: The chosen colors of window borders and titlebars, as
    specified under [theme] (Note: if name is not set under [theme] it
    defaults to name = "default")
-   key_modifier: The modifier key(s) ("Alt," "Shift," "Super," "Ctrl")
    to use in order to click-and-drag a client
-   tag: Which tag to open the window on. Tag numbers begin with zero
    (0), and correspond with the order of tags from left-to-right
-   screen: If multiple monitors are used, which screen to display the
    client on, beginning with zero (0) as the primary display
-   free: Whether the client is openend "floating" or not
-   tab: Whether to tab the client with another, existing client when
    opened
-   ignore_tag: Specify to client to ignore tags (client is displayed on
    every tag)
-   autofocus: Give focus to new created clients. default is false

The first several options are essentially all the potential names a
running program/process might have, as specified in the output of xprop.
So long as the instance entry correctly displays the "WM_Class" portion
of the xprop output, there should be no need to worry about the class,
role or name sections, and they may be left commented out.

> Statusbar

The "statusbar" is a panel at the edge of the screen that displays
pertinent information about tags and clients. System data can also be
called by external scripts and then passed to wmfs via the wmfs -c
status command, which displays the information in the specified
statusbar. Those wishing to take advantage of multiple statusbars in
WMFS2 will need to specify distinct names in wmfsrc in order to print
different data in each bar. Something as simple as "top" and "bottom"
will suffice.

    # Position:
      #
      # 0  Top
      # 1  Bottom
      # 2  Hide

      # Element type:
      #
      # t  Tags
      # s  Statustext (will take available space)
      # y  Systray (can be set only ONE time among all element)
      # l  Launcher (will be expended at launcher use)

      [bar]
         name = "top"
         position = 0
         screen = 0
         elements = "tsy"   # element order in bar
         theme = "default"
      [/bar]
      
      [bar]
         name = "bottom"
         position = 1
         screen = 0
         elements = "s"   # element order in bar
         theme = "default"
      [/bar]

If only one statusbar/panel is desired, the name entry is not required.

Elements

-   Tags: Displays all available tags, and indicates which one(s) is
    currently visible and which have open clients
-   Statustext: Displays system information in the panel/bar, which is
    fed to it from external sources like BASH scripts or Conky
-   Systray: A simple system tray displaying icons for programs that are
    minimized/running in the background
-   Launcher: Refers to the text-based, dmenu-like process launcher

The options for each element use relatively similar syntax, which can be
found on the WMFS2 wiki. Additionally, each element features specialized
status options, discussed below.

Tags

As with most tiling window managers, WMFS2 utilizes "tags" to help
organize windows. Tags are similar to virtual desktops or workspaces,
but with a few important differences: For example, multiple tags can be
displayed on one screen, or clients can be assigned to more than one
tag.

Tags are displayed on the left end of the statusbar, and can be assigned
either numbers (the default) or names in [tags] section of wmfsrc.

    [tags]

      # Use no screen option or screen = -1 to set tag on each screen
      [tag]
          screen = -1
          name = "1"
          # statusline ""
      [/tag]

      [tag] name = "2" [/tag]
      [tag] name = "3" [/tag]
      [tag] name = "4" [/tag]
      [tag] name = "5" [/tag]
      [tag] name = "6" [/tag]
      [tag] name = "7" [/tag]

      # Mousebinds associated to Tags element button
      [mouse] button = "1" func = "tag_click" [/mouse]
      [mouse] button = "4" func = "tag_next"  [/mouse]
      [mouse] button = "5" func = "tag_prev"  [/mouse]

    [/tags]

If desired, icons may also be used; simply change the default tag
entries as follows:

    [tag] screen = 0 name = "   " statusline = "^i[x;y;ww;hh;path/to/image/file]" [/tag]

The "x" and "y" represent the horizontal and vertical positions; "ww"
and "hh" the width and height.

By default the status of the tags--whether they contain clients or not,
and which tag is currently visible on the screen--is indicated by colors
specified in the [theme] section of wmfsrc. However, they can also be
marked using small boxes, a la DWM and Awesome, by modifying the
appropriate line in the [theme] section of wmfsrc.

    tags_sel_statusline = "\R[2;2;4;4;#BD0406]"

    tags_occupied_statusline = "\R[7;13;13;2;#C68709] " 

The first option will place a small red box next to the currently active
tag; the second will place a think yellow line underneath occupied tags.
A similar options exist for urgent notifications.

Launchers

Unlike its predecessor, WMFS2 does not have a drop-down application
menu. Instead, it features a text-based application launcher, which can
be called by pressing Alt+p.

Custom launchers using either text or icons can be created as well. The
following string places a launcher for Firefox on the left end of the
statusbar (next to the tags display), and opens firefox when clicked:

    ^s[left;<color>; wall ·](1;spawn;firefox)

The text can be positioned either to the left or right. The first number
in the parenthases (1) specifies which mouse button calls the command
when pressed.

Alternatively, one can use an external launcher such as dmenu as a
launcher by binding it to a key combination, for example:

    [key] mod = {"Super"} key = "space" func = "spawn" cmd = "dmenu_run" [/key]

Dmenu customization options can be used just as easily; just add them to
the string.

    [key] mod = {"Super"} key = "space" func = "spawn" cmd = "dmenu_run -p 'Arch Linux' -fn '-*-bitocra-medium-*-*-*-11-*-*-*-*-*-*-*' -nf '#4F4F4F' -nb '#363636' -sf '#FFA500' -sb '#4F4F4F' " [/key]

Statustext

This is the section of the statusbar dedicated to displaying various
system data, such as available hard drive space, CPU frequency, or
information about the currently playing song in mpd. The text is fed
into the bar from external scripts via the wmfs -c status command. The
information can be displayed as plain or colored text, colored boxes,
progressbars, positionbars, graphs, icons and pop-up tooltips. This can
be accomplished using either individual bash scripts written to suit the
user's needs, or by piping conky data directly into the statusbar.

Retrieved from
"https://wiki.archlinux.org/index.php?title=WMFS2&oldid=263849"

Category:

-   Tiling WMs

-   This page was last modified on 22 June 2013, at 13:34.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
