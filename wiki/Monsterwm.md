Monsterwm
=========

Monsterwm is a minimal, lightweight, tiny but monstrous dynamic tiling
window manager. It will try to stay as small as possible. Currently
under 700 lines with the config file included. It provides a set of four
different layout modes (vertical stack, bottom stack, grid and
monocle/fullscreen) by default, and has floating mode support. Each
virtual desktop has its own properties, unaffected by other desktops'
settings. Finally monsterwm supports multiple monitors setups.

Monsterwm is written with Xlib but there is also an XCB fork available.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Floating Mode                                                      |
| -   4 Panel                                                              |
| -   5 Patches                                                            |
| -   6 Customization                                                      |
|     -   6.1 Application Rules                                            |
|     -   6.2 Add custom keybinds                                          |
|                                                                          |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Download the monsterwm-git or monsterwm-xcb-git package from the AUR.

Configuration
-------------

Monsterwm uses its config.h file for configuration. By default, some
hotkeys are already set. MOD1 is the Alt and MOD4 is the Windows/Super
key.

-   MOD1 + h (decrease the size of a current window)
-   MOD1 + l (increase the size of a current window)
-   MOD1 + Shift + c (close current window)
-   MOD1 + Tab (move to last desktop)
-   MOD1 + k (change to previous window)
-   MOD1 + j (change to next window)
-   MOD1 + Shift + k (move current window up)
-   MOD1 + Shift + j (move current window down)
-   MOD1 + Enter (change master to current window)
-   MOD1 + t (switch to tile mode)
-   MOD1 + b (switch to bottomstack mode)
-   MOD1 + g (switch to grid mode)
-   MOD1 + m (switch to monocle mode)
-   MOD4 + v (open dmenu - requires dmenu)
-   MOD1 + Shift + Enter (open xterm)
-   MOD1 + Left (previous desktop)
-   MOD1 + Right (next desktop)
-   MOD1 + F1-4 (change to desktop #)
-   MOD1 + Ctrl + q (quit monsterwm with exit value 1)
-   MOD1 + Ctrl + r (quit monsterwm with exit value 0)

  
 You can find more information in the man page (man monsterwm).

Floating Mode
-------------

In floating mode one can freely move and resize windows in the screen
space. Changing desktops, adding or removing floating windows, does not
affect the floating status of the windows. Windows will revert to their
tiling mode position once the user selects a tiling mode. To enter the
floating mode, either change the layout to FLOAT, or enabled it by
moving or resizing a window with the mouse, the window is then marked as
being in floating mode.

Panel
-----

The user can define an empty space on the bottom or top of the screen,
to be used by a panel. The panel is toggleable, but will be visible if
no windows are on the screen. Monsterwm does not provide a panel and/or
statusbar itself. Instead it adheres to the UNIX philosophy and outputs
information about the existing desktops suchs as the number of windows
and the tiling mode/layout of each desktop, the current desktop and
urgent hints whenever needed. The user can use whatever tool or panel
suits him best (dzen2, conky, some-sorta-bar, bar, bipolarbar, mopag,
w/e), to process and display that information.

To disable the panel completely set PANEL_HEIGHT to zero 0. The
SHOW_PANELL setting controls whether the panel is visible on startup, it
does not control whether there is a panel or not.

You can find an example of how to achieve this here. You can actually
parse that information with any language you want, build anything you
want, and display the information however you'd like. Do not be limited
by that example.

Patches
-------

Some extensions to the code are supported in the form of patches. See
other branches for the patch and code. Easiest way to apply a patch, is
to git merge that branch.

Currently:

-   centerwindow : center new floating windows on the screen and center
    any window with a shortcut
-   fibonacci : adds fibonacci layout mode
-   initlayouts : define initial layouts for every desktop
-   monocleborders : adds borders to the monocle layout
-   nmaster : adds nmaster layout - multiple master windows for BSTACK
    and TILE layouts
-   rectangle : draws only a rectangle when moving/resizing windows to
    keep resources low (ie through an ssh forwarded session)
-   showhide : adds a function to show and hide all windows on all
    desktops
-   uselessgaps : adds gaps around every window on screen
-   warpcursor : cursors follows and is placed in the center of the
    current window
-   windowtitles : along with the rest desktop info, output the title of
    the current window

Another branch called [core], is an even more stripped and minimal
version of monsterwm, on top of which the master branch is built and
extended.

There is also xinerama support for multiple monitors.

-   xinerama-core : the equivalent of core branch with xinerama support
-   xinerama-master : the equivalent of master branch with xinerama
    support
-   xinerama-init : configurable initial values for each desktop on each
    monitor

To install monsterwm with a patch, simply change the _gitbranch= line in
the PKGBUILD to the name of the patch.

* * * * *

If you installed monsterwm with the #Compile from source method, you can
change to the desired branch with:

    $ git checkout <branch>

and then continue normally. For example to build monsterwm with the
fibonacci layout one would do:

    $ git checkout fibonacci
    $ make
    # make clean install

That way you can also combine patches. To do that one would merge
another branch to the current one. For example to build monsterwm with
uselessgaps, warpcursor and showhide, one would do:

    $ git config user.email <mailaddress>
    $ git config user.name <name>
    $ git checkout uselessgaps
    $ git checkout warpcursor
    $ git checkout showhide
    $ git checkout master
    $ git merge -m merge uselessgaps warpcursor showhide
    $ make
    # make install

Note that you can skip the first two lines if you've previously defined
them globally:

    $ git config --global user.email <mailaddress>
    $ git config --global user.name <name>

Customization
-------------

> Application Rules

One can define rules for a specific application, which will be applied
once the application spawns. A rule is composed of four parts.

    /* class      desktop  follow  float */
    { "MPlayer",     2,    True,   False },

-   the class or instance name of the application
-   the desktop in which the application should appear - index starts
    from 0
-   whether that desktop should be focused when the application is
    started
-   whether the application should start in floating mode

So the above rule, would place MPlayer to desktop 3 and change from the
current desktop to that desktop, because follow is True. MPlayer will be
tiled as every other window.

To get the application class or instance name you can use xprop . If the
desktop is set to a 'negative' number then the window spawns in the
current desktop.

If we change the above rule to this one:

    /* class      desktop  follow  float */
    { "MPlayer",     -1,   True,   True },

then MPlayer will be spawned in the current desktop, floating.

> Add custom keybinds

To add custom keybindings, you must edit config.h and recompile
monsterwm. That's why it is important to set them up on the initial
installation to avoid having to do this again. Below is a scenario in
which you would need to add a keybinding to open the thunar filemanager
with MOD1+t.

First, you must add a line such as the following, underneath the
already-defined const char*:

    config.h

    /**
     * custom commands
     * must always end with ', NULL };'
     */
    static const char *termcmd[] = { "xterm",     NULL };
    const char* thunarcmd[] = {"thunar", NULL};
    ...

Note: You can name it whatever you want. In this case, it is named
thunarcmd.

thunarcmd is just a title for the command you want to construct and run.
Inside the curly brackets is where you define the command to be
executed. Each command fragment that is separated by a space has its own
value. For example the command sequence ncmpcpp next, would be entered
as {"ncmpcpp", "next", NULL}. The NULL value must be included at the end
of each hotkey.

To actually register the hotkey with the window manager, you must look
below that at the struct named keys[]. This is where monsterwm stores
all of its keybindings. An example entry for the thunarcmd made above
would be:

    { MOD1,     XK_t,     spawn,     {.com = thunarcmd}},

-   The first element specifies the first keypress which is either:
    -   MOD1 for the modkey only,
    -   MOD1 for the modkey and then the shift key,
    -   MOD1 for the modkey and then the control key,
    -   0 for no key at all.

You can also use MOD4 which is the super or windows key instead of MOD1.

-   The second element specifies the actual key that is pressed to
    differentiate it from other similar hotkeys.

In this case, we set it to t, which has XK_ in front of it because that
is how Xorg reads key presses. Just remember to include XK_ in front of
it. Some examples of these include XK_a for the a key, XK_Space for the
space bar and XK_1 for the 1 key.

Note that these are case-sensitive, so XK_a is not the same as XK_A. So
for this example, the entire hotkey sequence that needs to be pressed is
MOD1+t.

-   The third element just specifies the function spawn, which has been
    written to be passed a command to execute.

Whenever you need to start an application or do anything that is not
related to the internals of monsterwm spawn will be used.

-   The final element inside the brackets specifies which command that
    was previously defined will be run.

In our case, it is thunarcmd[], so we would do {.com = thunarcmd}. The
.com stands for command.

You can do the same with the buttons[] structure. The buttons structure,
uses the mouse instead of the keyboard.

-   Button1 is the left button
-   Button2 is the middle click
-   Button3 is the right button

* * * * *

After this, recompile, hope for no errors, and install.

See also
--------

-   monsterwm thread on the forums
-   monsterwm screenshot thread
-   monsterwm repository on github
-   monsterwm-xcb repository on github
-   Comparison of tiling window managers

Retrieved from
"https://wiki.archlinux.org/index.php?title=Monsterwm&oldid=254046"

Category:

-   Dynamic WMs
