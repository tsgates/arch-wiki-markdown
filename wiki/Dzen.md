Dzen
====

Dzen is "a general purpose messaging, notification and menuing program
for X11. It was designed to be scriptable in any language and integrate
well with window managers like dwm, wmii and xmonad though it will work
with any window manager."

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Tips & Tricks                                                      |
|     -   3.1 Using custom fonts with dzen                                 |
|     -   3.2 Dzen & Conky                                                 |
|     -   3.3 Enabling Xft support for dzen                                |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install the dzen2 package which is available in the official
repositories. The official dzen2 package includes Xft, XPM, and Xinerama
support.

Note:Xft doesn't seem to work with the official package. Alternatively,
you can install the dzen2-xft-xpm-xinerama-svn package located in the
AUR with Xft, XPM and Xinerama support.

Configuration
-------------

Dzen is able to read font and color settings from X resources. As an
example, you can add following lines to ~/.Xresources:

    dzen2.font:       -*-fixed-*-*-*-*-*-*-*-*-*-*-*-*
    dzen2.foreground: #22EE11
    dzen2.background: black

Tips & Tricks
-------------

> Using custom fonts with dzen

Some fonts like terminus-font are installed in /usr/share/fonts/local,
which is not added to the font path by default. If you would like to use
these custom fonts with dzen2 you can either add the path to your local
fonts directory into /etc/X11/xorg.conf:

    Section "Files"
         ...
         FontPath     "/usr/share/fonts/local"
         ...
    EndSection

Or, if you do not have permission to change xorg.conf, you can add the
following to ~/.xinitrc:

    xset +fp /usr/share/fonts/local
    xset fp rehash

For further information see the Font Configuration and Fonts articles.

> Dzen & Conky

Conky can be used to pipe information directly to dzen for output in a
status bar. This can be done with Conky in the official repositories and
also with conky-cli, a stripped-down version of the Conky status utility
from the AUR.

The following example displays the average load values in red and the
current time in the default dzen foreground colour:

    ~/.conkyrc

     background no
     out_to_console yes
     out_to_x no
     update_interval 1.0
     total_run_times 0
     use_spacer none
     
     TEXT
     ^fg(\#ff0000)${loadavg 1 2 3} ^fg()${time %a %b %d %I:%M%P}

    ~/bin/dzconky

     #!/bin/sh
     
     FG='#aaaaaa'
     BG='#1a1a1a'
     FONT='-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*'
     conky | dzen2 -e - -h '16' -w '600' -ta r -fg $FG -bg $BG -fn $FONT &

Simply execute dzconky in your startup scripts.

> Enabling Xft support for dzen

Note:You need to install the libxft package.

As of SVN revision 241 (development), dzen2 has optional support for
Xft. To enable Xft support, build dzen2 with these options by editing
config.mk:

    config.mk

     ## Option: With Xinerama and XPM and XFT
     LIBS = -L/usr/lib -lc -L${X11LIB} -lX11 -lXinerama -lXpm `pkg-config --libs xft`
     CFLAGS = -Wall -Os ${INCS} -DVERSION=\"${VERSION}\" -DDZEN_XINERAMA -DDZEN_XPM -DDZEN_XFT `pkg-config --cflags xft`

To check libxft support, you can use this command:

    echo "hello world" | dzen2 -fn 'Times New Roman' -p

See also
--------

-   Official website, wiki, and source

Forum threads

-   2007-12-04 - Arch Linux - dzen & xmobar Hacking Thread

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dzen&oldid=226218"

Categories:

-   Application launchers
-   Eye candy
-   Status monitoring and notification
