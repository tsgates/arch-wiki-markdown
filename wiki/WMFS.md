WMFS
====

> Summary

Information on installing and configuring WMFS

Related links

Comparison of Tiling Window Managers

WMFS (Window Manager From Scratch) is a lightweight and highly
configurable tiling window manager for X. It can be configured with a
configuration file, supports Xft (Freetype) fonts and is compliant with
the Extended Window Manager Hints (EWMH) specifications. It is still
under heavy development

The code structure of wmfs starts to become too old and is not adapted
to the new ideas and concepts of the project anymore. So it has been
rewritten (again from scratch). Changes and configuration is described
in this wiki.

Rest of this page can be applied only to older version of WMFS.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Configuration file                                           |
|     -   2.2 Tags & Rules                                                 |
|     -   2.3 Key Bindings                                                 |
|         -   2.3.1 Scratchpad                                             |
|                                                                          |
|     -   2.4 Statusbar configuration                                      |
|     -   2.5 Conky                                                        |
|     -   2.6 WMFS Status Toolkit                                          |
|                                                                          |
| -   3 Usage                                                              |
| -   4 Troubleshooting                                                    |
|     -   4.1 Status bar not working in last git version                   |
|                                                                          |
| -   5 Resources                                                          |
+--------------------------------------------------------------------------+

Installation
------------

WMFS is in AUR. Due the high development rate it is recommended to use
the git version, wmfs-git.

WMFS will look for a configuration file in $XDG_CONFIG_HOME/wmfs. To
configure WMFS to your liking, you will need to create a configuration
file; for most users this will be ~/.config/wmfs/wmfsrc. If
~/.config/wmfs does not exist, create it:

    mkdir -p ~/.config/wmfs

A default file is located in your XDG directory, normally in
/etc/xdg/wmfs, called wmfsrc. Copy it to your newly created .config/wmfs
folder and you can begin to modify it.

    cp /etc/xdg/wmfs/wmfsrc ~/.config/wmfs

To use wmfs as a window manager, add it to your .xinitrc:

    echo "exec wmfs" >> ~/.xinitrc

Configuration
-------------

> Configuration file

The configuration file is well commented. Make small changes
cumulatively and reload WMFS (default key to restart is Alt+Ctrl+r) to
test them.

By default two different mod keys are used for keybindings (Ctrl and
Alt) which may conflict with your existing set-up. These can be changed
in wmfsrc. For example, if you want to use the Win-key instead of Alt,
replace "Alt" with "Super" or "Mod4" in the configuration file, e.g:

    [key] mod = { "Super" } key = "p" func = "launcher" cmd = "launcher_exec" [/key]

Or in a single command

    sed --in-place=.bak 's/"Alt"/"Mod4"/' wmfsrc

To bind commands to special symbols you need to specify their name, like
"slash" for "/". You can find symbol names by using xev and typing the
symbol in question:

    xev | grep keycode
       state 0x10, keycode 61 (keysym 0x2f, slash), same_screen YES,
       state 0x10, keycode 60 (keysym 0x2e, period), same_screen YES,
       state 0x10, keycode 59 (keysym 0x2c, comma), same_screen YES,

> Tags & Rules

Assigning clients to a tag, eg., having Uzbl open in tag 2, is done
through rules. In wmfsrc, write a new rule in the [rules] section:

    [rule] instance = "Uzbl" screen = 0  tag = "2"  max =  "false" [/rule]

This will open Uzbl in tag 2 unmaximized. To specify a layout for that
tag, under [tags]:

    [tag] name = "WWW"  screen = 0 layout = "tile_right" [/tag] 

For some rules, eg., where an application is opened in a terminal, you
may need to specify a class as well as an instance:

    [rule] instance = "mutt" class = "mutt" screen = 0  tag = "3"  max = "true" [/rule]

Use xprop to determine the values for your rule.

> Key Bindings

The [keys] section of wmfsrc allows you to customize your keybindings.
As described above, this could mean just changing the default modifier
from Alt to Super.

By default, WMFS is set up to cycle through the 9 available layouts. You
might, for example, wish to include a keybind to set a specific layout,
say tile_right (the classic tiled mode). You could bind that function to
Super+t like so:

    [key] mod = {"Mod4"} key = "t" func = "set_layout" cmd = "tile_right" [/key]

Similarly, you can customize keybinds for any of the other functions. A
full list of the functions can be found in /src/config.c - search for
"func_name_list_t".

Scratchpad

By combining a rule with a keybind, you can create a basic scratchpad -
a terminal bound to a keypress that will open in floating mode in any
tag in a specific position; for example:

    [key] mod = {"Control", "Alt"} key = "p" func = "spawn" cmd = "urxvtc -name scratchpad -geometry 64x10+480+34" [/key]

    [rule] instance = "scratchpad"  name  = "scratchpad"   free = "true"  [/rule]

> Statusbar configuration

The text shown in the status bars (or infobars) is set on a running wmfs
instance using the "wmfs -s" command. You can set a different bar for
each screen. The bars can also be positioned at the top or bottom of
each tag in the configuration file. For example

    wmfs -s "hello world, I am visible on all screens"
    wmfs -s 3 "hello world, I am visible on screen 4 only" # screens begin at 0

Colors may be encoded like this:

    wmfs -s "This text is \\#ff0000\red, \\#00ff00\green and \\#0000ff\blue"

Rectangles may be drawn like this:

    wmfs -s "<--look rectangles \b[700;9;14;5;#00ff00]\ \b[715;4;14;10;#00ff00]\ \b[730;3;14;11;#ff0000]\ "

The format is \b[xx;yy;ww;hh;#cccccc]\ where xx and yy are absolute (not
relative) x and y positions, ww and hh are width and height, and cccccc
is a color. This feature could be used to create CPU barcharts, volume
displays and the like. Note: the absolute positioning makes it difficult
to accurately interleave text and graphics.

Images may be added like this:

     wmfs -s "there is sexy image at x;y on this statusbar \i[x;y;height;width;/home/you/img/sexyimg.ext]\ "

(Default image height and width can be set with height = 0 and width = 0
in the sequence.)

Graph may be user like this:

     wmfs -s "graph \g[x;y;width;height;#color;data1;data2;...;datan]\ "

For more info on images and graphs in status bar:
http://fu.rootards.org/viewtopic.php?pid=14#p14

To pipe data to the bar, write a bash script with the relevant data you
wish to display and source it in your wmfsrc. WMFS will call it at the
interval you specify:

    status_path = ".config/wmfs/wmfs-status"
    status_timing = 5

Note that the output in the status.sh is as explained before.

    wmfs -s "What ever you want to be displayed"

Some example status scripts are on the WMFS website.

Note:Currently in Git version the statusbar does not start by itself,
you will have to start it by yourself.

> Conky

You can use Conky to pipe output to the wmfs statusbar with the command:

    conky | while read -r; do wmfs -s -name "$REPLY"; done

> WMFS Status Toolkit

https://aur.archlinux.org/packages.php?ID=38463

Usage
-----

The keybinding Alt+p starts a launcher in the titlebar (similar to
dmenu). It supports tab-completion and command-line parameters. Multiple
presses of the tab key iterate through possible completions.

WMFS can be controlled from the command line with commands such as

    wmfs -V :ln

which selects the next layout. Equivalently press Alt+Escape followed by
":ln". Type "wmfs -V help" to see the full list.

Troubleshooting
---------------

> Status bar not working in last git version

Since some revision, the status_path variable from the misc section is
not being used anymore. However, you can exploit the background_command
from the root section to start your status.sh script.

    background_command = "bash $HOME/.config/wmfs/status.sh"

This solution has some flaws:

-   The script is running independently from WMFS, so it will keep
    running after WMFS has terminated (which will outputs errors
    indefinitely in the TTY).
-   Reloading WMFS (CTRL+ALT+R by default) will launch another process
    of the script, which will mess everything up.

Assuming your status.sh file is located in the wmfs config folder, you
may try to put this command at the very beginning of your script:

    ~/.config/wmfs/status.sh

    kill $(ps U $UID | awk '/wmfs/&&/status.sh/' | grep -vi "$$\|grep\|awk" | awk '{print $1}')

It will prevent it from running multiple times. To stop it once WMFS has
terminated, you can use an appropriate loop:

    ~/.config/wmfs/status.sh

    while [ "$(ps U $UID | awk '{print $5}' | grep ^wmfs$)" != "" ] ; do
    	wmfs -s "Blah"
    	sleep 1
    done

Resources
---------

-   WMFS website
-   Wiki for WMFS2
-   The WMFS thread
-   Share your WMFS desktop! thread
-   #wmfs on Freenode

Retrieved from
"https://wiki.archlinux.org/index.php?title=WMFS&oldid=206461"

Category:

-   Dynamic WMs
