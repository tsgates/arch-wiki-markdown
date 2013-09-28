dmenu
=====

  
 dmenu is a fast and lightweight dynamic menu for X. It reads arbitrary
text from stdin, and creates a menu with one item for each line. The
user can then select an item, through the arrow keys or typing a part of
the name, and the line is printed to stdout. dmenu_run is a wrapper that
ships with the dmenu distribution that allows its use as an application
launcher.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Strange segfaulting                                                |
| -   4 More font support                                                  |
| -   5 External Resources                                                 |
+--------------------------------------------------------------------------+

Installation
------------

Installing dmenu is simple:

    # pacman -S dmenu

run it

    $ dmenu_run

Configuration
-------------

Now, you will want to attach the dmenu_run command to a keystroke
combination. This can be done either via your window manager or desktop
environment configuration, or with a program like xbindkeys. See the
Hotkeys article for more information. Also, it is helpful to Prelink
dmenu.

Strange segfaulting
-------------------

If executing dmenu_run results in an error similar to this:

    $ dmenu_run
    /usr/bin/dmenu_run: line 15: 1879 Segmentation fault           dmenu "$@" < "$cache"

And running dmenu crashes like the following:

    $ echo "blahblahblah" | dmenu
    no locale support
    Segmentation fault

Make sure $LANG is set to something valid. For example, I was
experiencing this problem because I had set $LANG to "en_US.UTF_8" in
/etc/locale.conf. In my case it should have been "en_US.UTF-8".

Keep in mind that the value contained in $LANG must be uncommented in
/etc/locale.gen and generated via locale-gen as well.

More font support
-----------------

dmenu can be patched to allow using more fonts which don't seem to be
working with the version from mainstream. The patched version can be
found on AUR. Using this version, fonts like Droid Sans mono can be set.

    $ dmenu_run -fn 'Droid Sans Mono-9'

External Resources
------------------

-   dmenu – The official dmenu website
-   Yeganesh – a light wrapper that reorders commands based on
    popularity
-   dmenu-launch (AUR) – A simple Dmenu-based application launcher.
    Launches binaries and XDG shortcuts.
-   Dmenu Hacking thread – Dmenu hacking thread in arch linux forums.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dmenu&oldid=246866"

Category:

-   Application launchers
