dmenu
=====

dmenu is a fast and lightweight dynamic menu for X. It reads arbitrary
text from stdin, and creates a menu with one item for each line. The
user can then select an item, through the arrow keys or typing a part of
the name, and the line is printed to stdout. dmenu_run is a wrapper that
ships with the dmenu distribution that allows its use as an application
launcher.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Displaying Custom Items
    -   2.2 Manually Adding Items
    -   2.3 Fonts
    -   2.4 Support for custom aliases
-   3 Troubleshooting
    -   3.1 Strange segfaulting
-   4 See Also

Installation
------------

Install dmenu from the official repositories. If you want the latest
development pull, install dmenu-git.

You may run dmenu with

    $ dmenu_run

For dmenu various patches exist that extend the default functionality.
Consider installing one of the following packages:

-   dmenu-xft-height: Xft font support and setting a custom height for
    the bar using -h <pixels> flag
-   dmenu-xft: Xft font support
-   dmenu-xft-mouse-height: Xft font support, custom height, and mouse
    support
-   dmenu-xft-transparency: Xft font support and transparency

Configuration
-------------

Now, you will want to attach the dmenu_run command to a keystroke
combination. This can be done either via your window manager or desktop
environment configuration, or with a program like xbindkeys. See the
Hotkeys article for more information. Also, it is helpful to Prelink
dmenu.

> Displaying Custom Items

Custom items may be shown by piping them into dmenu. For example:

    $ echo -e "first\nsecond\nthird" | dmenu

> Manually Adding Items

dmenu will look for executables in /usr/bin, other items can be added
and then found by dmenu by creating a symlink. For example:

    # ln /path/to/your/file /usr/bin/symlinkname -s

> Fonts

dmenu can be patched to allow using xft fonts which do not seem to be
working with the version from upstream. The patched version can be found
in the dmenu-xft package from the AUR. Using this version, fonts like
Droid Sans Mono can be set.

    $ dmenu_run -fn 'Droid Sans Mono-9'

> Support for custom aliases

dmenu does not support custom aliases located for instance in
~/.bash_aliases or ~/.zsh_aliases. If you want to have support for
aliases, run dmenu_run_aliases from dmenu-aliases and make sure to have
your aliases stored in one of the two user config files above.

Troubleshooting
---------------

> Strange segfaulting

If executing dmenu_run results in an error similar to this:

     $ dmenu_run
     /usr/bin/dmenu_run: line 15: 1879 Segmentation fault           dmenu "$@" < "$cache"

And running dmenu crashes like the following:

     $ echo "blahblahblah" 

Make sure $LANG is set to something valid. For example, this problem may
occur if one needs to set $LANG to en_US.UTF_8 or something similar in
/etc/locale.conf (see locale.conf).

Keep in mind that the value contained in $LANG must be uncommented in
/etc/locale.gen and generated via locale-gen as well.

See Also
--------

-   dmenu – The official dmenu website
-   Yeganesh – a light wrapper that reorders commands based on
    popularity. Written in Haskell
-   xboomx – yet another light wrapper that reorders commands based on
    popularity. Written in Python. Minimal dependencies
-   j4-dmenu-desktop (AUR) – Very fast dmenu application launcher
-   dmenu-launch (AUR) – A simple Dmenu-based application launcher.
    Launches binaries and XDG shortcuts.
-   fyr (AUR) – Manages menus of application launchers, either
    executables or desktop files. Also opens files with launchers,
    desktop files, or applications associated by MIME-type.
    Dmenu-driven.
-   goa (AUR) – Opens files with any desktop application or executable,
    chosen from a menu of all possibilities found in standard locations
    on the system. Dmenu-driven.
-   Dmenu Hacking thread – Dmenu hacking thread in arch linux forums. An
    overview of scripts is provided in the dmenu_scripts collection.
-   dswitcher-git (AUR) – Dmenu-based window switcher that works
    regardless of workspace or minimization.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dmenu&oldid=304667"

Category:

-   Application launchers

-   This page was last modified on 15 March 2014, at 23:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
