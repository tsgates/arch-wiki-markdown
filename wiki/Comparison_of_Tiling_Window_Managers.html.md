Comparison of Tiling Window Managers
====================================

This article provides an unbiased comparison of the most popular tiling
window managers (as opposed to floating window managers).

Contents
--------

-   1 Comparison table
    -   1.1 Management style
    -   1.2 Layouts
    -   1.3 Key bindings
-   2 External links

Comparison table
----------------

The following table lists the most popular tiling window managers
alongside notable features, providing readers with a quick overview.

Comparison of tiling window managers

Window Manager

Written in

Configured with

Management style

System tray support

On-the-fly reload

Information bars

Compositing

Default layouts

Pixel usage

External control

Library

Multiple (n) monitor behavior

Maintenance

alopex

C

C (recompile)

Hybrid

None

No

Built-in; call script/program as first argument

external

max, h-stack, v-stack, h-tab

Variable borders; titles in-statusbar

Xlib

six tags, two views available by default

active

Awesome

C

Lua

Dynamic

Built-in

Yes

Built-in, images and text

external

variable borders, optional h-tab titles

dbus (if enabled)

XCB

n-tags (workspaces). Per default 9 are enabled. Example

Active

bspwm

C

Anything

Hybrid

None

Yes

Can write internal state to a FIFO

External

v-split, h-split

Variable borders

via bspc

XCB

Monitors hold Desktops

Active

catwm

C

C (recompile)

Dynamic

None

No

None

No

v-stack, max

1-pix borders

Xlib

Abandoned

dswm

Lisp

Lisp

Manual

None

Yes

Yes

No

Active

dwm

C

C (recompile)

Dynamic

Optional Patch

Optional

Built-in, reads from root window name

external

v-stack, max

Xlib

n regions, 9 workspaces fixed to each region

Active

echinus

C

Text

Dynamic

None

Yes

ourico

external

v-stack, b-stack, max

Variable borders & optional titles

Xlib

Unknown

euclid-wm

C

Text

Hybrid

None

Yes

External (dzen)

rows, columns

1-pix borders

Xlib

Dormant

herbstluftwm

C

Text

Manual

None

Yes

rows, columns

1-pix borders

commands via herbstclient

Xlib and Glib

n regions, 9 workspaces visible in any region

Active

i3

C

Text

Manual

i3bar

Yes (Layout is preserved)

text piped to i3bar (i3status/conky and others can be used)

external

tree, v-split, h-split, stacked, tabbed, max, can be nested infinitely

none, 1-pix or 2-pix, optional titlebars, can hide edge borders

commands via ipc (or i3-msg, which uses ipc)

XCB

n regions

Active

Ion3

C

Lua

Manual

trayion

Yes

configurable

 ?

h-tab, max

Abandoned

monsterwm

C

C (recompile)

Dynamic

None

Optional, but windows are lost

No, outputs information to stdout, which can easily be parsed and
displayed by an external monitor or panel (dzen2, conky, etc)

external

h-stack, v-stack, grid, max

supports _NET_ACTIVE_WINDOW, so external control can be supplied by
xdotool and similar tools

Xlib primary and XCB fork

n workspaces per monitor

Active

Musca

C

Text, own command set, C(recompile)

Manual

None

No, but allows running of musca commands on the fly

None

No

h-split, v-split, max

commands, hooks

Xlib

Abandoned

Notion

C, Lua

Lua, compatible with Ion3 configs

Manual

trayion, stalonetray

Yes

configurable

 ?

h-tab, max

Configurable borders and titlebars/tabs

EWMH, arbitrary Lua scripts which have access to the rich internal API

Xlib

n workspaces on each monitor. Supports on-the-fly changes in topology

Active

qtile

Python

Python

Dynamic

Yes

Yes

Yes

 ?

tree, v-split, h-split, stacked, tabbed, max

No borders, although customizable

Hooks, Server mode

XCB

Active

Ratpoison

C

Text

Manual

None

Yes

Yes

external

max

Active

Snapwm

C

Text

Dynamic

None

Yes

Built-in, reads from root window name

External

nVertical, Fullscreen, nHorizontal, Grid, Center Stacking

variable borders, no titles

Xlib

Number of desktops distributed evenly between monitors

Active

Spectrwm

C

Text

Dynamic

None

Yes

Built-in, reads from user script

No

nv-stack, nh-stack, max

1-pix borders, no titles

XCB

n regions, 10 workspaces visible in any region

Active

Stumpwm

Lisp

Lisp

Manual

None

Yes

Yes

No

Dormant

subtle

C

Ruby

Manual

Built-in

Yes

Built-in (Ruby), external can be used as well

external

Variable grid

Variable borders, no titles

Hooks (Ruby), subtler (CLI), subtlext (Ruby extension)

Xlib

One workspace (view) per monitor (screen), placement on views via tags
and per runtime

Active

Wingo

Go

Text

Dynamic

None

Yes

No

external

floating, nv-stack, nh-stack, max

title bars in floating, skinny borders in tiling

via wingo-cmd or UNIX sockets in any programming language

X Go Binding

n regions, workspaces visible in any region

Active

WMFS

C

Text

Dynamic

Built-in

Yes

Built-in, set with command, color text, images

external

nh-stack (and invert), nv-stack (and invert), mirror-v, mirror-h, grid,
free, max

variable borders, titles or no titles

commands

Xlib

Up to 36 tags(workspaces) per screen

Active

wmii

C

Anything

Manual

witray

Yes

Built-in

external

columns, max, v-tab

titles

9P filesystem

one big region

active

xmonad

Haskell

Haskell

Dynamic

None

Yes

No

Yes, with xmonad-contrib and an external manager

nv-stack, nh-stack, max

variable borders, no titles

via XMonad-Hooks-ServerMode

Xlib

n regions, 9 workspaces visible in any region

Active

Window Manager

Written in

Configured with

Management style

System tray support

On-the-fly reload

Information bars

Compositing

Default layouts

Pixel usage

External control

Library

Multiple (n) monitor behavior

Maintenance

Tip:External control can also be achieved by programs like xdotool which
simulate keystrokes.

> Management style

Dynamic management emphasizes automatic management of window layouts for
speed and simplicity. Manual management emphasizes manual adjustment of
layout and sizing with potentially more precise control, at the cost of
more time spent moving and sizing windows.

> Layouts

A number of common layout types appear in several tiling WMs, although
the terminology varies somewhat.

-   max: one window shown fullscreen (with or without a status bar,
    title and borders). Aka: monocle (dwm, monsterwm).
-   h-stack: master area in top half, other windows stack up
    horizontally in the bottom half. The master area may be resizable.
    May be inverted top-bottom (wmfs). Aka: bottom stack (dwm),
    bstack(monsterwm).
-   v-stack: master area in left half, other windows stack up vertically
    in the right half. The master area may be resizable. May be inverted
    left-right (wmfs). Aka: tile (dwm, monsterwm).
-   nh-stack: h-stack allowing >=1 windows in master area. Aka: nbstack
    (dwm)
-   nv-stack: v-stack allowing >=1 windows in master area. Aka: ntile
    (dwm)
-   mirror-h: nh-stack with stacks above and below the master area
-   mirror-v: nv-stack with stacks to the left and right of the master
    area
-   h-tab: one window shown fullscreen with all window titles shown
    horizontally (like browser tabs)
-   v-tab: one window shown fullscreen with all window titles shown
    vertically. Aka: stack (wmii).
-   h-split: a keybinding splits the current window horizontally
    creating space for another
-   v-split: a keybinding splits the current window horizontally
    creating space for another
-   columns: manual layout style which treats windows as belonging to
    vertical columns
-   rows: manual layout style which treats windows as belonging to
    horizontal rows
-   grid: window positions and sizes based on a regular NxM grid. May be
    automatic (like wmfs, monsterwm) or manual (like Subtle).

> Key bindings

Tiling window managers are usually designed to be used entirely with the
keyboard or with keyboard & mouse. This is for speed (reaching for and
moving a mouse is slow) and ease of use. Sensible key bindings are
crucial to making workflow fast and efficient. Some default sets are
better than others, but generally the keys can be rebound as desired by
the user.

External links
--------------

-   Comparison of extensible window managers compares WMs "extensible"
    by scripting, like Xmonad and Sawfish.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Comparison_of_Tiling_Window_Managers&oldid=304789"

Category:

-   Tiling WMs

-   This page was last modified on 16 March 2014, at 07:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
