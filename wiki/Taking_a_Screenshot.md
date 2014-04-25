Taking a Screenshot
===================

This article explain different methods to take screenshots on your
system.

Contents
--------

-   1 Dedicated software
-   2 Packages including a screenshot utility
-   3 Details: general methods
    -   3.1 ImageMagick/GraphicsMagick
        -   3.1.1 Screenshot of multiple X screens
        -   3.1.2 Screenshot of individual Xinerama heads
        -   3.1.3 Screenshot of the active/focused window
    -   3.2 GIMP
    -   3.3 xwd
    -   3.4 scrot
    -   3.5 escrotum
    -   3.6 imlib2
-   4 Details: desktop environment specific
    -   4.1 KSnapshot
    -   4.2 Xfce Screenshooter
    -   4.3 GNOME
    -   4.4 Other desktop environments or window managers
-   5 Terminal
    -   5.1 Output with ansi codes
    -   5.2 Virtual console

Dedicated software
------------------

-   Deepin Screenshot — Provide a quite easy-to-use screenshot tool.
    Features: global hotkey to trigger screenshot tool, take screenshot
    of a selected area, easy to add text and line drawings onto the
    screenshot. Python/GTK2 based.

http://www.linuxdeepin.com/ || deepin-screenshot

-   KSnapshot — KDE application for taking screenshots. It is capable of
    capturing images of the whole desktop, a single window, a section of
    a window, a selected rectangular region or a freehand region. Part
    of kdegraphics.

http://kde.org/applications/graphics/ksnapshot/ || kdegraphics-ksnapshot

-   Scrot — Simple command-line screenshot utility for X.

http://freecode.com/projects/scrot || scrot

-   Escrotum — Screen capture using pygtk, inspired by scrot.

https://github.com/Roger/escrotum || escrotum-git

-   Shutter — Rich screenshot and editing program.

http://shutter-project.org/ || shutter

-   Xfce4 Screenshooter — This application allows you to capture the
    entire screen, the active window or a selected region. You can set
    the delay that elapses before the screenshot is taken and the action
    that will be done with the screenshot: save it to a PNG file, copy
    it to the clipboard, open it using another application, or host it
    on ZimageZ, a free online image hosting service. Part of
    xfce4-goodies.

http://goodies.xfce.org/projects/applications/xfce4-screenshooter ||
xfce4-screenshooter

-   xwd — X Window System image dumping utility

http://xorg.freedesktop.org/ || xorg-xwd

-   zscreen — Lightweight GUI which allows you to take a screenshot of
    the entire screen or to select an area and then uploading the
    screenshot automatically to imgur. For taking the screenshot it uses
    scrot and zenity for the GUI.

https://github.com/ChrisZeta/Scrot-and-imgur-zenity-GUI || zscreen

Packages including a screenshot utility
---------------------------------------

-   GIMP — Image editing suite in the vein of proprietary editors such
    as Adobe Photoshop. GIMP (GNU Image Manipulation Program) has been
    started in the mid 1990s and has acquired a large number of plugins
    and additional tools.

http://www.gimp.org/ || gimp

-   GraphicsMagick — Fork of ImageMagick designed to have API and
    command-line stability. It also supports multi-CPU for enhanced
    performance and thus is used by some large commercial sites (Flickr,
    etsy) for its performance.

http://www.graphicsmagick.org/ || graphicsmagick

-   ImageMagick — Command-line image manipulation program. It is known
    for its accurate format conversions with support for over 100
    formats. Its API enables it to be scripted and it is usually used as
    a backend processor.

http://www.imagemagick.org/script/index.php || imagemagick

-   Imlib2 — Library that does image file loading and saving as well as
    rendering, manipulation, arbitrary polygon support.

http://sourceforge.net/projects/enlightenment/ || imlib2

Details: general methods
------------------------

> ImageMagick/GraphicsMagick

An easy way to take a screenshot of your current system is using the
import command:

    $ import -window root screenshot.jpg

import is part of the imagemagick package.

Running import without the -window option allows selecting a window or
an arbitrary region interactively.

Note:If you prefer graphicsmagick alternative, just prepend "gm", e.g.
$ gm import -window root screenshot.jpg.

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

    #!/bin/sh
    xdpyinfo -ext XINERAMA | sed '/^  head #/!d;s///' |
    while IFS=' :x@,' read i w h x y; do
            import -window root -crop ${w}x$h+$x+$y head_$i.png
    done

Screenshot of the active/focused window

The following script takes a screenshot of the currently focused window.
It works with EWMH/NetWM compatible X Window Managers. To avoid
overwriting previous screenshots, the current date is used as the
filename.

    #!/bin/sh
    activeWinLine=$(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)")
    activeWinId=${activeWinLine:40}
    import -window "$activeWinId" /tmp/$(date +%F_%H%M%S_%N).png

Alternatively, the following should work regardless of EWMH support:

    $ import -window "$(xdotool getwindowfocus -f)" /tmp/$(date +%F_%H%M%S_%N).png

Note:If screenshots of some programs (dwb and zathura) appear blank, try
appending -frame or removing -f from the xdotool command.

> GIMP

You also can take screenshots with GIMP (File > Create > Screenshot...).

> xwd

Take a screenshot of the root window:

    $ xwd -root -out screenshot.xwd

Note:The methods for taking shots of active windows with import can also
be used with xwd.

> scrot

Note:According to this thread, scrot does not work with dwm nor
xbindkeys.

scrot, enables taking screenshots from the CLI and offers features such
as a user-definable time delay. Unless instructed otherwise, it saves
the file in the current working directory.

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
uploaded like so [1].

> escrotum

escrotum-git screen capture using pygtk, inspired by scrot

Created because scrot has glitches when selection mode is used with
refreshing windows.

Because the command line interface its almost the same as scrot, can be
used as a replacement of it.

> imlib2

imlib2 provides a binary imlib2_grab to take screenshots. To take a
screenshot of the full screen, type:

    $ imlib2_grab screenshot.png

Note that scrot actually uses imlib2.

Details: desktop environment specific
-------------------------------------

> KSnapshot

If you use KDE, you might want to use KSnapshot, which can also be
activated using Prnt Scr.

KSnapshot is provided by the kdegraphics-ksnapshot.

> Xfce Screenshooter

If you use Xfce you can install xfce4-screenshooter and then add a
keyboard binding:

Xfce Menu > Settings > Keyboard > Application Shortcuts

If you want to skip the Screenshot prompt, type $ xfce4-screenshooter -h
in terminal for the options.

> GNOME

GNOME users can press Prnt Scr or Apps > Accessories > Take Screenshot.
You may need to install gnome-screenshot.

> Other desktop environments or window managers

For other desktop environments such as LXDE or window managers such as
Openbox and Compiz, one can add the above commands to the hotkey to take
the screenshot. For example,

    $ import -window root ~/Pictures/$(date '+%Y%m%d-%H%M%S').png

Adding the above command to the Prnt Scr key to Compiz allows to take
the screenshot to the Pictures folder according to date and time. Notice
that the rc.xml file in Openbox does not understand commas; so, in order
to bind that command to the Prnt Scr key in Openbox, you need to add the
following to the keyboard section of your rc.xml file:

    rc.xml

    <!-- Screenshot -->
        <keybind key="Print">
          <action name="Execute">
            <command>sh -c "import -window root ~/Pictures/$(date '+%Y%m%d-%H%M%S').png"</command>
          </action>
        </keybind>

Terminal
--------

> Output with ansi codes

You can use the script command, part of the util-linux package. Just
enter $ script and from that moment, all the output is going to be saved
to the typescript file, including the ansi codes.

Once you are done, just type exit and the typescript would ready. The
resulting file can be converted to html using the package ansi2html,
from the AUR.

To convert the typescript file to typescript.html, do the following:

    $ ansi2html --bg=dark < typescript > typescript.html

Actually, some commands can be piped directly to ansi2html:

    $ ls --color|ansi2html --bg=dark >output.html

That does not work on every single case, so in those cases, using script
is mandatory.

> Virtual console

Install a framebuffer and use fbgrab or fbdump to take a screenshot.

If you merely want to capture the text in the console and not an actual
image, you can use setterm, which is part of the util-linux package. The
following command will dump the textual contents of virtual console 1 to
a file screen.dump in the current directory:

    # setterm -dump 1 -file screen.dump

Root permission is needed because the contents of /dev/vcs1 need to be
read.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Taking_a_Screenshot&oldid=305911"

Category:

-   Graphics and desktop publishing

-   This page was last modified on 20 March 2014, at 17:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
