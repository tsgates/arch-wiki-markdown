Xfwm
====

Related articles

-   Desktop environment
-   Window manager
-   Xfce
-   Xorg

From Xfwm - Introduction:

The Xfce 4 Window Manager is part of the Xfce Desktop Environment... The
window manager is responsible for the placement of windows on the
screen, provides the window decorations and allows you for instance to
move, resize or close them. xfwm4 adheres strongly to the standards
defined on freedesktop.org.

Consequently, special features such as making windows borderless, or
providing an icon for the application must now be implemented in the
application; you can no longer use the window manager to force different
behaviour.

xfwm4 includes its own compositing manager, which takes advantage of the
new X.org's server extensions. The compositor is like a WM on its own,
it manages a stack of all windows, monitor all kinds on X event and
reacts accordingly. Having the compositing manager embedded in the
window manager also helps keeping the various visual effects in sync
with window events.

Contents
--------

-   1 Installation
    -   1.1 Starting Xfwm
-   2 Configuration
    -   2.1 Changing settings through the binaries provided
        -   2.1.1 Change the default theme, keybinding, focus settings,
            and workspace settings
        -   2.1.2 Extra settings provided by the xfce settings manager
    -   2.2 Additional Themes
-   3 Troubleshooting
    -   3.1 No icons shown in browser for downloaded items

Installation
------------

Install xfwm4 from the official repositories.

> Starting Xfwm

To run xfwm as stand-alone, edit your ~/.xinitrc and add the following
line

    exec xfwm4

It can also be started with its compositor turned off by adding the
following line instead of the one above

    exec xfwm4 -compositor=off

Configuration
-------------

> Changing settings through the binaries provided

Most of the xfwm settings can be accessed through the three binaries
provided by the xfwm package from the official repository. These are
 xfwm4-settins, xfwm4-tweaks-settings, and xfwm4-workspace-settings.

Change the default theme, keybinding, focus settings, and workspace settings

To change the xfwm default theme, keybindings, focus settings and a few
other options, execute:

    xfwm4-settings

Additional settings relevant to the topics above can be changed by
executing

    xfwm4-tweaks-settings

To edit the number of workspaces and their names, execute

    xfwm4-workspace-settings

Extra settings provided by the xfce settings manager

Install xfce4-settings from the official repositories

Warning: Installing xfce4-settings may change the default applications
for certain tasks. See xdg-open to set the default applications to your
liking.

> Additional Themes

Install xfwm4-themes from the official repositories

The themes installed will be shown in the xfwm4-settings window.

Troubleshooting
---------------

> No icons shown in browser for downloaded items

This is fixed by installing xfce4-settings from the official
repositories.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xfwm&oldid=301262"

Category:

-   Window managers

-   This page was last modified on 24 February 2014, at 11:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
