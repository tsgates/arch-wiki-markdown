Bspwm
=====

bspwm is a tiling window manager that represents windows as the leaves
of a full binary tree. It has support for EWMH and multiple monitors,
and is configured and controlled through messages.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Note for multi-monitor setups
    -   2.2 Rules
    -   2.3 Panels
-   3 Troubleshooting
    -   3.1 Help! I get a blank screen and my keybindings don't work!
-   4 See also

Installation
------------

Install bspwm or bspwm-git from the AUR. You will also want to install
sxhkd or sxhkd-git, a simple X hotkey daemon used to communicate with
bspwm through bspc as well as launch your applications of choice.

To start bspwm on login, add the following to ~/.xinitrc:

    sxhkd &
    exec bspwm

Configuration
-------------

Example configuration is found on GitHub.

Copy bspwmrc to ~/.config/bspwm/bspwmrc, sxhkdrc to
~/.config/sxhkd/sxhkdrc and make bspwmrc executable with
chmod +x ~/.config/bspwm/bspwmrc.

These two files are where you will be setting wm settings and
keybindings, respectively.

Documentation for bspwm is found by running man bspwm.

There is also documentation for sxhkd found by running man sxhkd.

Note for multi-monitor setups

The example bspwmrc configures ten desktops on one monitor like this:

    bspc monitor -d I II III IV V VI VII VIII IX X

You will need to change this line and add one for each monitor, similar
to this:

    bspc monitor DVI-I-1 -d I II III IV
    bspc monitor DVI-I-2 -d V VI VII
    bspc monitor DP-1 -d VIII IX X

You can use `xrandr -q` or `bspc query -M` to find the monitor names.

The total number of desktops were maintained at ten in the above
example. This is so that each desktop can still be addressed with 'super
+ {1-9,0}' in the sxhkdrc.

> Rules

There are two ways to set window rules (as of cd97a32).

The first is by using the built in rule command, as shown in the example
bspwmrc:

    bspc rule -a Gimp desktop=^8 follow=on floating=on
    bspc rule -a Chromium desktop=^2
    bspc rule -a mplayer2 floating=on
    bspc rule -a Kupfer.py focus=on
    bspc rule -a Screenkey manage=off

The second option is to use an external rule command. This is more
complex, but can allow you to craft more complex window rules. See these
examples for a sample rule command. These scripts require lua-posix, lua
and xwinfo.

If a particular window does not seem to be behaving according to your
rules, check the class name of the program. This can be accomplished by
running  xprop | grep WM_CLASS to make sure you're using the proper
string.

> Panels

Currently, bar and dzen2 are supported with bspwm. Check the examples
folder on the GitHub page for ideas or the Bar wiki page. The panel will
be executed by placing  panel & for bar or  panel dzen2 & for dzen2 in
your bspwmrc. Check the opt-depends in the bspwm package for
dependencies that may be required in either case.

To display system information on your status bar you can use various
system calls. This example will show you how to edit your  panel  to get
the volume status on your BAR:

    panel_volume()
    {
            volStatus=$(amixer get Master | tail -n 1 | cut -d '[' -f 4 | sed 's/].*//g')
            volLevel=$(amixer get Master | tail -n 1 | cut -d '[' -f 2 | sed 's/%.*//g')
            # is alsa muted or not muted?
            if [ "$volStatus" == "on" ]
            then
                    echo "\f6"$volLevel
            else
                    # If it is muted, make the font red
                    echo "\f1"$volLevel
            fi
    }

Next, we will have to make sure it is called and piped to  $PANEL_FIFO:

    while true; do
    echo "S" "$(panel_volume) $(panel_clock) > "$PANEL_FIFO"
            sleep 1s
    done &

Troubleshooting
---------------

> Help! I get a blank screen and my keybindings don't work!

There are a few ways to debug this. First, a blank screen is good. That
means bspwm is running.

I would confirm that your xinitrc looks something like

    sxhkd &
    exec bspwm

The ampersand is important. Next, try spawning a terminal in your
xinitrc to see if its getting positioned properly. It should appear
somewhat "centered" on the screen. To do this, use this .xinitrc:

    sxhkd &
    urxvt &
    exec bspwm

If nothing shows up, that means you probably forgot to install urxvt. If
it shows up but isn't centered or taking up most of your screen, that
means BSPWM isn't getting started properly. Make sure that you've
 chmod +x ~/.config/bspwm/bspwmrc .

Next, type pidof sxhkd in that terminal you spawned. It should return a
number. If it doesn't, that means sxhd isn't running. Try to be explicit
and run  sxhkd -c ~/.config/sxhkd/sxhkdrc . You could also try changing
the Super key to something like Alt in your sxhkdrc and see if that
helps. Another common problem is copying the text from the example files
instead of physically copying the file over. Copying / pasting code
usually leads to indentation issues which sxhkd can be sensative to.

See also
--------

-   Mailing List: bspwm at librelist.com.
-   #bspwm - IRC channel at irc.freenode.net
-   https://bbs.archlinux.org/viewtopic.php?id=149444 - Arch BBS thread
-   https://github.com/baskerville/bspwm - GitHub project
-   https://github.com/windelicato/dotfiles/wiki/bspwm-for-dummies -
    earsplit's "bspwm for dummies"

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bspwm&oldid=302814"

Category:

-   Tiling WMs

-   This page was last modified on 2 March 2014, at 01:34.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
