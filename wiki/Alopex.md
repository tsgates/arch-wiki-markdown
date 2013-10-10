Alopex
======

> Summary

Information on installing and configuring Alopex

> Related

dmenu

dwm

i3

Alopex (formerly, TTWM) is a minimal tiling window manager combining
concepts or elements from tinywm, dwm, and i3wm. Inspiration has also
been drawn from other great tilers like monsterwm. It manages windows
using tiling, horizontal or vertical stacking layouts with transient
floating and fullscreen modes.

Note:TTWM 1.0 can still be installed using ttwm.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Recommended Reading                                                |
| -   3 Basic usage                                                        |
|     -   3.1 Launching programs                                           |
|     -   3.2 Using tags                                                   |
|     -   3.3 Window layouts                                               |
|     -   3.4 Exiting                                                      |
|                                                                          |
| -   4 Extended Usage                                                     |
|     -   4.1 Custom Configuration                                         |
|         -   4.1.1 Custom Keybindings                                     |
|         -   4.1.2 Customizing Tags                                       |
|                                                                          |
|     -   4.2 Statusbar                                                    |
|         -   4.2.1 Custom Icons                                           |
|                                                                          |
|     -   4.3 Multi-Monitor Support                                        |
|     -   4.4 Window Rules                                                 |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Installing alopex-git, from the AUR, is as simple as fetching the
PKGBUILD and running the following:

    $ makepkg -si

Tip:As configuration is done at compile-time, modifications (such as
customized keybindings or colorschemes) can be achieved by moving a copy
of config.h (from upstream) to $HOME/.alopex_config.h or
$XDG_CONFIG_HOME/alopex/config.h and editing it to reflect any user
preferences. See #Configuration

Recommended Reading
-------------------

Alopex provides three manpages (alopex.1, alopex.config.5 and
alopex.icons.5). They provide much more in-depth detail about much of
the information on this page.

Note:As the manpages reach finalization, this page's information will be
modified to reflect default settings and some clarification.

Basic usage
-----------

By Default, Alopex tracks the following four modifier masks:

Reference

Key

Mod1

"Super"

Mod2

"Alternate"

Mod3

"Control"

Mod4

"Shift"

> Launching programs

Dmenu is a useful addon to Alopex. As opposed to list-style or drop-down
menus, dmenu is a type-to-complete program launcher. It is the
recommended launcher for Alopex, and the default configuration maps
running dmenu to Mod1 + p.

Note:The creator of Alopex has also made a very small, light-weight
alternative to dmenu called interrobang. It can be installed easily
using interrobang-git. To replace dmenu with interrobang, read on how to
customize keybindings in #Custom Configuration.

> Using tags

To move or assign a window to a given tag, the intended window must
first be focused. This can be accomplished by using Mod1 + j and/or Mod1
+ k.

Action

Keybind

View Tag "x"

Mod1 + x

Move to Tag "x"

Mod1 + Mod2 + x

Assign to Tag "x"

Mod1 + Mod3 + x

Toggle Visibility of Tag "x"

Mod1 + Mod4 + x

Note:As with dwm, Alopex makes a distinction between tags and views
(workspaces). By default, Alopex has six tags enabled and two views
available. You can switch between the two views using Mod2 + Tab. To
better understand the difference and how you can arrange your workflow
to utilize the difference, this article (written for dwm) may be
helpful.

Tip:It is possible to customize how tags are labeled using a custom
config.h and icons.h. See #Customizing Tags.

> Window layouts

Alopex has three rule-based layouts complimented by transient fullscreen
and floating modes: Vertical and Horizontal Stacking and "Monocle" (Full
screen with statusbar tabs). By default, the vertical stacking layout
will be used. Cycling through all three layouts can be done by pressing
Mod1 + space. You can select each mode more directly with the following
shortcuts:

Mode

Keybind

Windows visible

Arrangement

V-Stack (rstack)

Mod1 + Mod2 + r

3

Master on left, stack on right

H-Stack (bstack)

Mod1 + Mod2 + b

3

Master on top, stack on bottom

Monocle

Mod1 + Mod2 + m

1

Variable sized tabs for each window

Using the stackcount option, you can specify how many windows you would
like to be visible in the stack. You can also use Mod1 + = and Mod1 + -
to dynamically increment and decrement the number of visible windows in
the stack (respectively). Furthermore, using Mod1 + . will keep all open
windows visible.

Tip:You can toggle a window to and from Fullscreen mode by pressing Mod1
+ f, and, similarly, you can toggle floating mode by pressing Mod1 +
Mod2 + f.

> Exiting

Cleanly killing a window can be done by pressing Mod2 + F4. Cleanly
exiting Alopex can be done by pressing Mod1 + Mod4 + Q.

Extended Usage
--------------

> Custom Configuration

As mentioned previously, Alopex is almost entirely configured at
compile-time via the editing of its source files, primarily config.h and
icons.h. The upstream configuration provides sane defaults, but
configuration per user-preference is easy to achieve.

As mentioned in #Installation, alopex-git will check for
$HOME/.alopex_config.h and $XDG_CONFIG_HOME/alopex/config.h, and, if
either exists, use them to replace the default config.h before
commencing the build. After using makepkg to grab the source, simply
copy the config.h to either $HOME/.alopex_config.h or
$XDG_CONFIG_HOME/alopex/config.h and make your modifications.

Once the desired modifications have been made, return to the package
directory and compile/install:

    $ makepkg -si

Tip:If you have already compiled, you may need to use the f switch to
force a recompile

Assuming the configuration changes were valid, the customized Alopex
will have been compiled and installed. If problems were encountered,
review the output for specific information.

For any changes to take effect, it will be necessary to (re)start
Alopex.

Custom Keybindings

One of the main customizations that must be made in a custom config.h is
the use of custom keybindings. To map a custom keybinding, add the
necessary lines to the keys array using the following syntax:

    { MODKEY, <key>, spawn, CMD("program") },

Tip:To map a single key to a function (that is, without a modifier key),
use 0 for MODKEY.

<key> can either be a hex keycode (e.g., 0x68) or an X keysym (e.g.,
XK_h). You can check for keycodes and keysyms by using xorg-xev. If you
would like to use the XF86 keysyms (for instance, for media keys), you
can do so, but you must have the following line uncommented in your
config.h:

    #include <X11/XF86keysym.h>

You can also define special functions for more complex commands by using
#define:

    #define FUNCTION "program -switches --options arguments"

which could then be mapped to a keybind using CMD(FUNCTION) in the above
syntax.

Note:Using #define FUNCTION, you do not quote FUNCTION in the keybinding
declaration.

Customizing Tags

It is possible, using the tagcons array, to customize how tags appear on
the statusbar. By default, the default tags are named one through six.
Using the tagcons array, you can have them appear with any combination
of a prefix, an icon and a suffix. You can add, or customize tag
appearances using the following syntax:

    static const Tagcon tagcons=[] = {
       { "prefix",   #,   "suffix" },
    };

With this syntax # refers to the position of the icon in the array at
the bottom of icons.h; "prefix" and "suffix" refer to the labels of text
given to the tag before and after the icon, respectively. If you do not
want the tag to appear with an icon, replace # with NO_ICON or -1. If
you would rather a tag appear without any label, replace "prefix" and
"suffix" with NULL. The order each tag appears on the bar depends on the
order in which they appear in the tagcons array.

Note:NULL should appear without quotes, whereas text prefixes and
suffixes must be quoted.

> Statusbar

By passing a script or program as an argument to Alopex, it can create a
minimalistic statusbar. To avoid a CPU race, Alopex provides a default
statusbar script if none is passed to it. This default script displays
only a simple clock. For a more powerful statusbar, you can either write
a script (or your own small program) or use a statusbar program such as
conky. If the script (or program) you use takes arguments itself,
remember to quote the whole statusbar argument. For example, the
following commands would start Alopex with a script or conky
(respectively):

    $ xinit /usr/bin/alopex "/home/username/script.sh -args"

    $ xinit /usr/bin/alopex "conky -c /path/to/conkyrc"

To colorize parts (or all) of the output of the script, you can use
{#RRGGBB} . "#RRGGBB" is a standard hex color code and using these in
brackets will colorize everything on the statusbar following it until
another color code is passed.

Custom Icons

As with config.h, Alopex supports custom iconsets using a customized
icons.h which should be placed at $HOME/.alopex_icons.h or
$XDG_CONFIG_HOME/alopex/icons.h.

Icons, similar to the bracketed color codes, are referenced in the
statusbar script or program using {i X}  where "X" is the number of the
icon. View the default icons.h to see which icons are available and what
their value for X is (it is determined by the order in which each icon
appears in the array at the bottom of the file).

Note:Because these icons are sourced at compile-time, any customization
of the icon-set will require the user to recompile, reinstall and
restart Alopex.

> Multi-Monitor Support

Alopex has experimental support for up to 16 external monitors using
xrandr. Though auto-detection of external montiors is not yet supported,
it is planned for version 2.1. Unlike with the internal monitor, Alopex
handles windows with slightly different rulesets on external monitors.
Each window is assigned a monitor number (in addition to tags/flags and
other info). If the monitor number is higher than the number of
available monitors, the window is placed on the highest numbered
monitor, otherwise it is placed on the monitor matching its number. See
the documentation in the manpages and in config.h for more details.

> Window Rules

Alopex also has the ability to define limited window rules based on the
WM_NAME and WM_CLASS strings from X11. You can modify, or add to, these
rules by editing the rules array in config.h using the following syntax:

    static Rule rules[] = {
       { "name",   "class",  tags,   flags },
    }

You can replace either "name" or "class" with NULL to ignore those
values in a given rule. If both are specified, then the rule will only
apply if both conditions are met. To determine what values you should
use for "name" or "class", you can use xorg-xprop. The value you give
for tags allows you to specify what tags a window will be given by
default when it opens. If you wish not to affect this behavior, use 0 in
place of tags. Finally, the flags value allows you to specify special
properties to be given to the window (e.g., force floating mode). If you
wish to not affect this behavior, you can replace flags with 0. For
further explanation, consult the manpages (See, #Recommended Reading).

See also
--------

-   Alopex Homepage
-   Alopex Sourcecode on GitHub
-   dmenu - Simple application launcher from the developers of dwm
-   The Alopex thread on the forums
-   The Interrobang thread on the forums

Retrieved from
"https://wiki.archlinux.org/index.php?title=Alopex&oldid=255752"

Category:

-   Dynamic WMs
