Taking a Screenshot
===================

This article explain different methods to take screenshots on your
system.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 General methods                                                    |
|     -   1.1 import                                                       |
|         -   1.1.1 Screenshot of multiple X screens                       |
|         -   1.1.2 Screenshot of individual Xinerama heads                |
|         -   1.1.3 Screenshot of the active/focused window                |
|                                                                          |
|     -   1.2 GIMP                                                         |
|     -   1.3 xwd                                                          |
|     -   1.4 scrot                                                        |
|     -   1.5 imlib2                                                       |
|                                                                          |
| -   2 Desktop environment specific                                       |
|     -   2.1 KDE                                                          |
|     -   2.2 Xfce                                                         |
|     -   2.3 GNOME                                                        |
|     -   2.4 Other Desktop Environments or Window Managers                |
|                                                                          |
| -   3 Taking and uploading screenshots                                   |
|     -   3.1 zscreen                                                      |
|                                                                          |
| -   4 Terminal                                                           |
|     -   4.1 Output with ansi codes                                       |
|     -   4.2 Virtual console                                              |
+--------------------------------------------------------------------------+

General methods
---------------

> import

An easy way to take a screenshot of your current system is using the
import command:

    $ import -window root screenshot.jpg

import is part of the imagemagick package.

Running import without the -window option allows selecting a window or
an arbitrary region interactively.

Screenshot of multiple X screens

If you run twinview or dualhead, simply take the screenshot twice and
use imagemagick to paste them together:

    import -window root -display :0.0 -screen /tmp/0.png
    import -window root -display :0.1 -screen /tmp/1.png
    convert +append /tmp/0.png /tmp/1.png screenshot.png
    rm /tmp/{0,1}.png

Screenshot of individual Xinerama heads

Xinerama-based multi-head setups have only one virtual screen. If the
physical screens are different in height, you will find dead space in
the screenshot. In this case, you may want to take screenshot of each
physical screen individually. As long as Xinerama information is
available from the X server, the following will work:

    #!/bin/bash
    xdpyinfo -ext XINERAMA | sed '/^  head #/!d;s///' |
    while IFS=' :x@,' read i w h x y; do
        import -window root -crop ${w}x$h+$x+$y head_$i.png
    done

Screenshot of the active/focused window

The following script takes a screenshot of the currently focused window.
It works with EWMH/NetWM compatible X Window Managers. To avoid
overwriting previous screenshots, the current date is used as the
filename.

    #!/bin/bash
    activeWinLine=$(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)")
    activeWinId=${activeWinLine:40}
    import -window "$activeWinId" /tmp/$(date +%F_%H%M%S_%N).png

Alternatively, the following should work regardless of EWMH support:

    $ import -window "$(xdotool getwindowfocus -f)" /tmp/$(date +%F_%H%M%S_%N).png

> GIMP

You also can take screenshots with GIMP (File -> Create ->
Screenshot...).

> xwd

xwd is part of the xorg-xwd package.

Take a screenshot of the root window:

    $ xwd -root -out screenshot.xwd

See the man xwd for more information.

> scrot

Note:According This Thread, scrot does not work with dwm nor xbindkeys.

  
 scrot, which is available in the official repositories, enables taking
screenshots from the CLI and offers features such as a user-definable
time delay. Unless instructed otherwise, it saves the file in the
current working directory.

    $ scrot -t 20 -d 5

The above command saves a dated .png file, along with a thumbnail (20%
of original), for Web posting. It provides a 5 second delay before
capturing in this instance.

You can also use standard date and time formatting when saving to a
file. e.g.,

    $ scrot ~/screenshots/%Y-%m-%d-%T-screenshot.png

saves the screenshot in a filename with the current year, month, date,
hours, minutes, and seconds to a folder in your home directory called
"screenshots"

See man scrot for more information. You can simply automate the file to
uploaded like so
https://github.com/kaihendry/Kai-s--HOME/tree/master/bin

> imlib2

imlib2 provides a binary imlib2_grab to take screenshots. To take a
screenshot of the full screen, type:

    $ imlib2_grab screenshot.png

Note that scrot actually uses imlib2.

Desktop environment specific
----------------------------

> KDE

If you use KDE, you might want to use KSnapshot, which can also be
activated using Prnt Scr.

KSnapshot is provided by the kdegraphics-ksnapshot package in [extra].

> Xfce

If you use Xfce you can install xfce4-screenshooter and then add a
keyboard binding:

Xfce Menu --> Settings --> Keyboard >>> Application Shortcuts.

If you want to skip the Screenshot prompt, type $ xfce4-screenshooter -h
in terminal for the options.

> GNOME

GNOME users can press Prnt Scr or Apps->Accessories->Take Screenshot.

Note:If Prnt Scr complains about not finding gnome-screenshot or there
is no "Take Screenshot" entry in your menu, you will need to install the
gnome-utils package from [extra].

> Other Desktop Environments or Window Managers

For other desktop environments such as LXDE or window managers such as
Openbox and Compiz, one can add the above commands to the hotkey to take
the screenshot. For example,

    $ import -window root ~/Pictures/`date '+%Y%m%d-%H%M%S'`.png

Adding the above command to the Prnt Scr key to Compiz allows to take
the screenshot to the Pictures folder according to date and time. Notice
that the rc.xml file in Openbox does not understand commas; so, in order
to bind that command to the Prnt Scr key in Openbox, you need to add the
following to the keyboard section of your rc.xml file:

    rc.xml

    <!-- Screenshot -->
        <keybind key="Print">
          <action name="Execute">
            <command>sh -c "import -window root ~/Pictures/`date '+%Y%m%d-%H%M%S'`.png"</command>
          </action>
        </keybind>

Taking and uploading screenshots
--------------------------------

> zscreen

zscreen provides a lightweight GUI which allows you to take a screenshot
of the entire screen or to select an area and then uploading the
screenshot automatically to imgur. For taking the screenshot it uses
scrot and zenity for the GUI.

Terminal
--------

> Output with ansi codes

You can use the script command, part of the util-linux package.

Just enter

    $ script

and from that moment, all the output is going to be saved to the
typescript file, including the ansi codes.

Once you are done, just type exit and the typescript would ready.

The resulting file can be converted to html using the package ansi2html,
from the AUR.

To convert the typescript file to typescript.html, do the following:

    $ ansi2html --bg=dark <typescript >typescript.html

Actually, some commands can be piped directly to ansi2html:

    $ ls --color|ansi2html --bg=dark >output.html

That does not work on every single case, so in those cases, using script
is mandatory.

> Virtual console

Install a framebuffer and use fbgrab, fbshot, or fbdump to take a
screenshot.

If you merely want to capture the text in the console and not an actual
image, you can use setterm, which is part of the util-linux package. The
following command will dump the textual contents of virtual console 1 to
a file screen.dump in the current directory:

    # setterm -dump 1 -file screen.dump

Root permission is needed because the contents of /dev/vcs1 need to be
read.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Taking_a_Screenshot&oldid=255108"

Category:

-   Graphics and desktop publishing
