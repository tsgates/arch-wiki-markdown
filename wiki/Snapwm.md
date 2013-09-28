Snapwm
======

Snapwm is a xinerama aware, very minimal and lightweight dynamic tiling
window manager based on dminiwm (same author), which is based on catwm
(by pyknite).

Snapwm has an emphasis on easy configurability and choice. It's
primarily keyboard driven but has some mouse support also.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Using the AUR                                                |
|     -   1.2 Using Git                                                    |
|     -   1.3 Alternative Method                                           |
|     -   1.4 Dmenu                                                        |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 RC.CONF                                                      |
|     -   2.2 KEY.CONF                                                     |
|     -   2.3 APPS.CONF                                                    |
|                                                                          |
| -   3 The Bar                                                            |
|     -   3.1 Colors                                                       |
|     -   3.2 Icons                                                        |
|                                                                          |
| -   4 Layout Modes                                                       |
|     -   4.1 Vertical                                                     |
|     -   4.2 Fullscreen                                                   |
|     -   4.3 Horizontal                                                   |
|     -   4.4 Grid                                                         |
|     -   4.5 Stacking                                                     |
|                                                                          |
| -   5 Window Manager Functions                                           |
| -   6 Transparency                                                       |
| -   7 Multi Monitor Support                                              |
| -   8 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

> Using the AUR

Download snapwm-git from the AUR. Then, as a non-root user, run:

    $ makepkg -i

while in the saved PKGBUILD's directory. The files will be retrieved,
built and installed.

The sample configuration files will be installed in
/usr/share/snapwm-git/. Create the directory ~/.config/snapwm/:

    $ mkdir -p ~/.config/snapwm/

Copy the three sample files to
~/.config/snapwm/{rc.conf, key.conf, apps.conf}  and edit to suit.

> Using Git

The latest version can be downloaded using Git. Initially, you can do:

    git clone https://github.com/moetunes/Nextwm 

and then update with git pull. See the Git wiki page or man git for more
info.

Note:While the official name of the window manager and executable is
snapwm, you will notice that in moetunes' GitHub, the directory is named
Nextwm which may cause some confusion.

Xlib is all that is required. To install it, do:

    $make
    #make install
    $make clean

> Alternative Method

Instead of actually installing it system-wide as above, you can simply
run make and then copy the executable to somewhere in your path, like
~/bin for example. You can then run it the same way(exec snapwm) on a
per user basis.

> Dmenu

Most users will want this. As the name implies, dmenu is a menu that
acts like an auto-complete for typing the name of binaries. It
integrates well with tiling window managers like snapwm. See the dmenu
wiki page or man dmenu for more info. To install it, do:

    pacman -S dmenu

The sample.key.conf file comes with a command to start demenu_run, which
will search $PATH for a matching executable as soon as you start typing.

     CMD dmenucmd;dmenu_run;-i;-nb;#666622;-nf;white;NULL;
     KEY Alt;v;spawn;dmenucmd;

  

Configuration
-------------

All user settings are read from three files in ~/.config/snapwm/ . Each
line in these files takes the form of :

     <Option><space><semi colon separated list>

and if there is more than one item in the list the line must end in a
semi colon.

snapwm comes with sample configurations files which make it easy to
start configuration.

All options and settings in the three configuration files are changeable
in the running window manager by editing and saving the configuration
file/s and updating. (default key Alt+u)

> RC.CONF

<option><space><semi colon separated list>

Should have the number of desktops as the first option, which is
changeable in the running window manager.

Colours, how new windows are handled and options for the bar are set
here.

> KEY.CONF

There are two options CMD and KEY . CMD should come before any key using
it.

CMD takes the form of :

     CMD<space><label>;<comand>;<command option1>;<command option2>...;NULL;

The line must end in NULL;

The label is passed to a KEY with spawn as the function and the label as
the variable

KEY takes the form of :

     KEY<space><Modifier>;<key>;<function>;<variable>;

There are eight modifying keys available :

       Alt  CtrlAlt  ShftAlt  Super  ShftSuper  Control CtrlSuper ALTSuper

An example for setting Alt+x to open xterm. The terminal command would
be

xterm -bg black -fg white

To make the command and the keyboard shortcut.

     CMD xtermcmd;xterm;-bg;black;-fg;white;NULL;
     KEY Alt;x;spawn;xtermcmd;

> APPS.CONF

There are two options DESKTOP and POSITION . Order isn't important.

DESKTOP is used to set the desktop that an app will open on and whether
to change to that desktop when the app opens.

POSITION is used to set the geometry of an app in stacking mode.

DESKTOP takes the form of :

     DESKTOP<space><window class>;<desktop to open on>;<zero to change to that desktop>;

<window class> is found by using xprop on the app and reading the
WM_CLASS value.

POSITION takes the form of :

     POSITION<space><window class>;<x>;<y>;<width>;<height>;

The Bar
-------

Snapwm has an integrated bar that has a clickable desktop switcher,
shows the tiling mode, shows the focused window's name and has space to
display some external text.

The desktop switcher can optionally show the number of windows open on
unfocused desktops and in fullscreen mode. Clicking on the current
desktop in the switcher will focus the next window. Clicking elsewhere
in the bar will change to the last desktop.

The bar uses the root window's name to display colored external text,
which can be changed with xsetroot -name.

For example, with conky, you could use something like:

    conky | while read -r; do xsetroot -name "$REPLY"; done &

You can toggle the bars' visibility.

     Default keyboard shortcut : Super+b

There's options in the rc file to have the bar shown at the top or the
bottom. The bars' position is changeable in the running wm by editing
the rc file.

> Colors

The colors for the desktop switcher are defined in SWITCHERTHEME in
rc.conf.

-   Color 0 : focused desktop in switcher.
-   Color 1 : unfocused desktop in switcher.
-   Color 2 : unfocused desktop in switcher with open windows.
-   Color 3 : the bar's border.

The colors for the rest of the bar and text in the bar are defined in
STATUSTHEME in rc.conf.

-   Color 0 : the default background colour for the bar
-   Color 1 : the current desktop font in the switcher and also for
    external text.
-   Color 2 : the unfocused desktops font in the switcher and also for
    external text.
-   Color 3 : the unfocused desktops with opened windows font in the
    switcher and also for external text.
-   Color 4 : the focused window name font and also the for external
    text.
-   Colors 5 - 9 : are for external text.

The colors for the windows are defined in WINDOWTHEME in rc.conf.

-   Color 0 : focused window border.
-   Color 1 : unfocused window border.

The colors for external text can be displayed by placing & in front of
the number of the color in your script. For example, using conky, you
could do something like this for displaying the time using the second
color for external text:

    &1${time %I:%M}

The background colour in the bar can be changed by placing &B in front
of the number of the wanted colour in your script. For example, using
conky, you could do something like this for displaying the time using
the third colour for the background and the second color for external
text:

    &B2&1${time %I:%M}&B0

  
 The colors in the running wm are changeable by editing the rc file and
updating.

> Icons

The bar does not support icons but you can draw "icons" into a font and
use those. You can find more info on that in the dwm hacking thread on
the forum. There are a few fonts in the AUR, such as terminusmod,
tamsynmod, termsyn, and ohsnap that have some icons. To have them shown
in the bar print them in a terminal then copy/paste them in rc.conf or
your script/conky. You can also use a font like stlarch_font that just
contains icons. You can use it in combination with another font using a
comma to separate them in your rc.conf:

    static const char defaultfontlist[] = "-*-stlarch-medium-r-*-*-10-*-*-*-*-*-*-*,-*-terminus-medium-r-*-*-12-*-*-*-*-*-*-*";

Layout Modes
------------

Snapwm has five layout modes: vertical, fullscreen, horizontal, grid and
center stacking. The tiling mode for each desktop is set in rc.conf, and
can be changed in the running wm.

It allows the "normal" method of tiling window managers, with the new
window as the master, or with the new window opened at the top or bottom
of the stack(attach aside). The default tiling method for all layout
modes is set in rc.conf, and can be changed in the running wm.

> Vertical

       --------------
       |        | W |
       |        |___|
       | Master |   |
       |        |___|
       |        |   |
       --------------

     Default keyboard shortcut : Alt+Shift+v

Windows can be added/removed from the master area with a keyboard
shortcut.

  

> Fullscreen

Takes up all the screen less the bar.

     Default keyboard shortcut : Alt+Shift+f

     There are no borders in fullscreen mode or if there is only one open window.

  

> Horizontal

       -------------
       |           |
       |  Master   |
       |-----------|
       | W |   |   |
       -------------

     Default keyboard shortcut : Alt+Shift+h

Windows can be added/removed from the master area with a keyboard
shortcut.

  

> Grid

       -------------
       |      |    |
       |Master|    |
       |------|----|
       |  w   |    |
       -------------

     Default keyboard shortcut : Alt+Shift+g

  

> Stacking

        ___________
       |   ______  |
       | _|__    | |
       ||    |   | |
       ||____|___| |
       |___________|

     Default keyboard shortcut : Alt+Shift+c

     Window placement strategy is set in rc.conf
       CENTER_STACK 0  all windows open centered on screen
       CENTER_STACK 1  windows set their preferred position

     Windows can be moved up/down
       Default keyboard shortcut : Alt+Shift+j/k
     Windows can be moved right/left
       Default keyboard shortcut : Alt+Shift+p/o
     Windows can be made wider/narrower
       Default keyboard shortcut : Alt+h/l
     Windows can be made taller/shorter
       Default keyboard shortcut : Alt+p/o

  

-   Changing the layout mode or resizing windows on one desktop doesn't
    affect the other desktops.
-   The Master window can be resized.
-   Windows can be added/removed to/from the master area with keyboard
    shortcuts Alt+Shift+m/l
-   The window *W* at the top of the stack can be resized with keyboard
    shortcuts Alt+o/p.
-   In stacking mode the windows can be resized/moved with
    Alt+right/left mouse button and
-   the size and position is remembered when the mode is changed

  

Window Manager Functions
------------------------

The functions available to the user are :

     next_win
       Default keyboard shortcut : Alt + j

     prev_win
       Default keyboard shortcut : Alt + k

     move_up
       Default keyboard shortcut : Alt + Shift + j
           move the current window up the stack

     move_down
       Default keyboard shortcut : Alt + Shift + k
           move the current window down the stack

     swap_master
       Default keyboard shortcut : Alt + Shift + Return
           move the current window to the master area

     change_desktop
       Default keyboard shortcut : Alt + [number]

     last_desktop
       Default keyboard shortcut : Alt + Tab

     rotate_desktop
       Default keyboard shortcut : Super + Right/Left

     follow_client_to_desktop
       Default keyboard shortcut : Alt + Shift + [number]
           send the current window to another desktop and open that desktop

     client_to_desktop
       Default keyboard shortcut : Super + Shift + [number]
           send the current window to another desktop

     switch_mode
       Default keyboard shortcut : Alt + Shift + v/f/h/g/c

     rotate_mode
       Default keyboard shortcut : Alt + a
           order is vertical, fullscreen, horizontal, grid, stacking

     resize_master
       Default keyboard shortcut : Alt + h/l

     more_master
       Default keyboard shortcut : Alt + Shift + m/l
           add/remove window from the master area in vert or horiz mode

     resize_stack
       Default keyboard shortcut : Alt + p/o
           increase/decrease the size of the window at the top of the stack

     kill_client
       Default keyboard shortcut : Alt + c

     quit
       Default keyboard shortcut : Control + Alt + q

     spawn
       Default keyboard shortcut : User defined for each application

     toggle_bar
       Default keyboard shortcut : Super + b

     update_config
       Default keyboard shortcut : Alt + u

  

Transparency
------------

Unfocused windows have an alpha value and can be transparent if used
with a compositing manager(like cairo-compmgr).

The value is a percent and can be changed in the running wm by editing
the rc file, 100 is opaque.

  

Multi Monitor Support
---------------------

With X aware of multiple connected monitors, snapwm will place different
desktops on each monitor.

Using xrandr, or the appropriate method for the graphics card, set the
second monitor to the right of the first, the third monitor to the right
of the second, etc.

Using two monitors and four desktops as an example:

     desktops 1 & 3 will show on monitor 1, the last focused one always visible

     desktops 2 & 4 will show on monitor 2, the last focused one always visible

To move an application to the other monitor, send it to the desktop
showing on that monitor with the follow_/client_to_desktop functions.

  

See also
--------

-   The README and ChangeLog for additional info.

-   Snapwm and dminiwm forum thread. The author(moetunes) is helpful,
    friendly and active on the forum.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Snapwm&oldid=247451"

Category:

-   Dynamic WMs
