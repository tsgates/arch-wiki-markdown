dwm
===

> Summary

Information on installing and configuring dwm

> Related

dmenu

dunst

wmii

dwm is a dynamic window manager for X. It manages windows in tiled,
stacked, and full-screen layouts, as well as many others with the help
of optional patches. Layouts can be applied dynamically, optimizing the
environment for the application in use and the task performed. dwm is
extremely lightweight and fast, written in C and with a stated design
goal of remaining under 2000 source lines of code. It provides
multi-head support for xrandr and Xinerama.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
|     -   1.1 Method 1: makepkg + ABS (recommended)                        |
|     -   1.2 Method 2: official repos (easier, but not configurable)      |
|                                                                          |
| -   2 Starting dwm                                                       |
|     -   2.1 Starting a customized dwm from a display manager             |
|                                                                          |
| -   3 Basic usage                                                        |
|     -   3.1 Using dmenu                                                  |
|     -   3.2 Controlling windows                                          |
|         -   3.2.1 Giving another tag to a window                         |
|         -   3.2.2 Closing a window                                       |
|         -   3.2.3 Window layouts                                         |
|                                                                          |
|     -   3.3 Exiting dwm                                                  |
|                                                                          |
| -   4 Configuring                                                        |
|     -   4.1 Method 1: ABS rebuild (recommended)                          |
|         -   4.1.1 Customizing config.h                                   |
|         -   4.1.2 Notes                                                  |
|                                                                          |
|     -   4.2 Method 2: Git (advanced)                                     |
|                                                                          |
| -   5 Statusbar configuration                                            |
|     -   5.1 Basic statusbar                                              |
|     -   5.2 Conky statusbar                                              |
|                                                                          |
| -   6 Extended usage                                                     |
|     -   6.1 Patches & additional tiling modes                            |
|         -   6.1.1 Enable one layout per tag                              |
|                                                                          |
|     -   6.2 Fixing gaps around terminal windows                          |
|     -   6.3 Space around font in dwm's bar                               |
|     -   6.4 Restart dwm without logging out or closing programs          |
|     -   6.5 Make the right Alt key work as if it were Mod4 (Windows Key) |
|     -   6.6 Disable focus follows mouse behaviour                        |
|     -   6.7 Adding custom keybinds/shortcuts                             |
|     -   6.8 Fixing misbehaving Java applications                         |
|                                                                          |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Installing
----------

> Method 1: makepkg + ABS (recommended)

These instructions will install dwm using makepkg along with the Arch
Build System, or ABS for short. This will allow reconfiguring dwm at a
later time without complications.

Basic programming tools present in base-devel are needed in order to
compile dwm and build a package for it, and the abs package is also a
requisite for fetching the necessary build scripts. Installing dmenu, a
fast and lightweight dynamic menu for X is a good idea.

    # pacman -S base-devel abs dmenu

Once the required packages are installed, use ABS to update and then
copy the dwm build scripts from the ABS tree to a temporary directory.
For example:

    # abs community/dwm
    $ cp -r /var/abs/community/dwm ~/dwm

Use cd to switch to the directory containing the build scripts (the
example above used ~/dwm). Then run:

    $ makepkg -i

This will compile dwm, build an Arch Linux package containing the
resulting files, and install the package file all in one step. If
problems are encountered, review the output for specific information.

Tip:If this directory (~/dwm) is saved, it can subsequently be used for
making changes to the default configuration.

> Method 2: official repos (easier, but not configurable)

If only interested in installing dwm for a test drive, simply install
the binary package from the repositories instead. You will probably also
want to consider installing dmenu, a fast and lightweight dynamic menu
for X:

    # pacman -S dwm dmenu

Note:By omitting compiling dwm from source a great deal of
customizability is lost, since dwm's entire configuration is performed
by editing its source code. Taking this in mind, the rest of the article
assumes that dwm has been compiled from source as explained in the
entirety of this section.

Starting dwm
------------

To start dwm with startx or the SLIM login manager, simply append the
following to ~/.xinitrc:

    exec dwm

For GDM, add it to ~/.Xclients instead, and select "Run XClient Script"
from the Sessions menu.

> Starting a customized dwm from a display manager

The default /usr/share/xsessions/dwm.desktop does not allow for a
customized start like can be done in .xinitrc. A solution to this
problem is to make a start script, for example /usr/bin/dwm-personalized
and make an alternative xsession .desktop file
(/usr/share/xsessions/dwm-personalized.desktop).

Example of /usr/share/xsessions/dwm-personalized

    [Desktop Entry]
    Encoding=UTF-8
    Name=Dwm-personalized
    Comment=Dynamic window manager
    Exec=dwm-personalized
    Icon=dwm
    Type=XSession

Example of /usr/bin/dwm-personalized

    #!/bin/zsh

    #Set swedish keyboard map
    setxkbmap se

    #Set chrome as default browser
    if [ -n "$DISPLAY" ]; then
         BROWSER=google-chrome
    fi

    #Set status bar & start DWM
    conky | while read -r; do xsetroot -name "$REPLY"; done &
    exec dwm

Basic usage
-----------

> Using dmenu

Dmenu is a useful addon to dwm. Rather than a standard list-style menu,
it acts as a sort of autocomplete to typing in the names of binaries. It
is more advanced than many program launchers and integrates well within
dwm.

To start it, press Mod1 + P (Mod1 should be the Alt key by default).
This can, of course, be changed if you so desire. Then, simply type in
the first few characters of the binary you wish to run until you see it
along the top bar. Then, simply use your left and right arrow keys to
navigate to it and press enter.

For more information, see dmenu.

> Controlling windows

Giving another tag to a window

Changing a window's tag is very simple. To do so, simply bring the
window into focus by hovering over it with your cursor, then press Shift
+ Mod1 + x, where 'x' is the number of the tag to which you want to move
the window. [Mod1] is, by default, the Alt key.

Closing a window

To cleanly close a window using dwm, simply press Shift + Mod1 + C.

Window layouts

By default, dwm will operate in tiled mode. This can be observed by new
windows on the same tag growing smaller and smaller as new windows are
opened. The windows will, together, take up the entire screen (except
for the menu bar) at all times. There are, however, two other modes:
floating and monocle. Floating mode should be familiar to users of
non-tiling window managers; it allows users to rearrange windows as they
please. Monocle mode will keep a single window visible at all times.

To switch to floating mode, simply press Mod1 + F. Mod1 is, by default,
the Alt key. To check if you are in floating mode, you should see
something like this next to the numbered tags in the top right corner of
the screen: ><>.

To switch to monocole mode, press Mod1 + M. To check if you are in
monocle mode, you can see an M in square brackets (if no windows are
open on that tag) or a number in square brackets (which corresponds with
the number of windows open on that tag). Thus, a tag with no windows
open would display this: [M], and a tag with 'n' windows open would
display this: [n].

To return to tiled mode, press Mod1 + T. You will see a symbol which
looks like this: []= .

> Exiting dwm

To cleanly exit dwm, press Shift + Mod1 + Q.

Source: dwm tutorial.

Configuring
-----------

dwm, as mentioned before, is exclusively configured at compile-time via
some of its source files, namely config.h and config.mk. While the
initial configuration provides a good set of defaults, it is reasonable
to expect eventual customization.

> Method 1: ABS rebuild (recommended)

Modifying dwm is quite simple using this route.

Customizing config.h

Browse to the dwm source code directory saved during the installation
process; ~/dwm in the example. The config.h found within this directory
is where the general dwm preferences are stored. Most settings within
the file should be self-explanatory. For detailed information on these
settings, see the dwm website.

Note:Be sure to make a backup copy of config.h before modifying it, just
in case something goes wrong.

Once changes have been made, pipe the new md5sums into the PKGBUILD:

    $ makepkg -g >> PKGBUILD

This will eliminate a checksum mismatch between the official config.h
and the new revised copy.

Now, compile and reinstall:

    $ makepkg -efi

Assuming the configuration changes were valid, this command will compile
dwm, build and reinstall the resulting package. If problems were
encountered, review the output for specific information.

Finally, restart dwm in order to apply the changes.

Notes

From now on, instead of updating the md5sums for every config.h
revision, which are known to become frequent, one may erase the md5sums
array and build dwm with the --skipinteg option:

    $ makepkg -efi --skipinteg

And after adding a few lines to dwm's start-up script, it is possible to
restart dwm without logging out or closing programs.

Tip:To recompile easily, make an alias by putting
(alias redwm='cd ~/dwm; makepkg -g >> PKGBUILD; makepkg -efi --noconfirm; killall dwm')
in your .bashrc.

> Method 2: Git (advanced)

dwm is maintained upstream within a git version control system at
suckless.org. Those already familiar with git may find it more
convenient to maintain configurations and patches within this system.
Learning how to do local branching and merging will make maintaining,
applying and removing patches easy.

Before building dwm from the git sources, be sure to alter config.mk
accordingly, because failure to do so may result in X crashes. Here are
the values that need changing:

Modify PREFIX:

    PREFIX = /usr

The X11 include folder:

    X11INC = /usr/include/X11

And the the X11 lib directory:

    X11LIB = /usr/lib/X11

Statusbar configuration
-----------------------

dwm uses the root window's name to display information in its statusbar,
which can be changed with xsetroot -name.

> Basic statusbar

This example prints the date in ISO 8601 format. Add it to files
~/.xinitrc or ~/.Xclients or see this page's discussion for more details
about the GDM-3 case :

    while true; do
       xsetroot -name "$( date +"%F %R" )"
       sleep 1m    # Update time every minute
    done &
    exec dwm

Here is an example intended for laptops that depends on the acpi package
for showing battery information:

    while true ; do
        xsetroot -name "$(acpi -b | awk 'sub(/,/,"") {print $3, $4}')"
        sleep 1m
    done &
    exec dwm

The script displays the amount of battery remaining besides its charging
status by using the awk command to trim away the unneeded text from
acpi, and tr to remove the commas.

An alternative to the above is to selectively show the battery status
depending on the current charging state:

    while true; do
    	batt=$(LC_ALL=C acpi -b)

    	case $batt in
    	*Discharging*)
    		batt="${batt#* * * }"
    		batt="${batt%%, *} "
    		;;
    	*)
    		batt=""
    		;;
    	esac

    	xsetroot -name "$batt$(date +%R)"

    	sleep 60
    done &

    exec dwm

Finally, make sure there is only one instance of dwm in ~/.xinitrc or
~/.Xclients, so combining everything together should resemble this:

    ~/.setbg
    autocutsel &
    termirssi &
    urxvt &

    while true; do
       xsetroot -name "$(date +"%F %R")"
       sleep 1m    # Update time every minute
    done &
    exec dwm

Here is another example that displays also the alsa volume and the
battery state. The latter only when the system is off-line.

    #set statusbar
    while true
    do
       if acpi -a | grep off-line > /dev/null; then
           xsetroot -name "Bat. $(awk 'sub(/,/,"") {print $3, $4}' <(acpi -b)) \
           | Vol. $(awk '/dB/ { gsub(/[\[\]]/,""); print $5}' <(amixer get Master)) \
           | $(date +"%a, %b %d %R")"
       else
           xsetroot -name "Vol. $(awk '/dB/ { gsub(/[\[\]]/,""); print $5}' <(amixer get Master)) \
           | $(date +"%a, %b %d %R")"
       fi
       sleep 1s   
    done &

> Conky statusbar

Conky can be printed to the statusbar with xsetroot -name:

    conky | while read -r; do xsetroot -name "$REPLY"; done &
    exec dwm

To do this, conky needs to be told to output text to the console only.
The following is a sample conkyrc for a dual core CPU, displaying
several stats:

    out_to_console yes
    out_to_x no
    background no
    update_interval 2
    total_run_times 0
    use_spacer none

    TEXT
    $mpd_smart :: ${cpu cpu1}% / ${cpu cpu2}%  ${loadavg 1} ${loadavg 2 3} :: ${acpitemp}c :: $memperc% ($mem) :: ${downspeed eth0}K/s ${upspeed eth0}K/s :: ${time %a %b %d %I:%M%P}

Extended usage
--------------

> Patches & additional tiling modes

The official website has a number of patches that can add extra
functionality to dwm. Users can easily customize dwm by applying the
modifications they like. The Bottom Stack patch provides an additional
tiling mode that splits the screen horizontally, as opposed to the
default vertically oriented tiling mode. Similarly, bstack horizontal
splits the tiles horizontally.

The gaplessgrid patch allows windows to be tiled like a grid.

Enable one layout per tag

The default behaviour of dwm is to apply the currently selected layout
for all tags.To have different layouts for different tags use the pertag
patch.

> Fixing gaps around terminal windows

If there are empty gaps of desktop space outside terminal windows, it is
likely due to the terminal's font size. Either adjust the size until
finding the ideal scale that closes the gap, or toggle resizehints to
False in config.h:

    static Bool resizehints = False; /* True means respect size hints in tiled resizals */

This will cause dwm to ignore resize requests from all client windows,
not just terminals. The downside to this workaround is that some
terminals may suffer redraw anomalies, such as ghost lines and premature
line wraps, among others.

> Space around font in dwm's bar

By default, dwm's bar adds 2px around the size of the font. To change
it, modify the following line in dwm.c:

    bh = dc.h = dc.font.height + 2;

> Restart dwm without logging out or closing programs

For restarting dwm without logging out or closing applications, change
or add a startup script so that it loads dwm in a while loop, like this:

    while true; do
        # Log stderror to a file 
        dwm 2> ~/.dwm.log
        # No error logging
        #dwm >/dev/null 2>&1
    done

dwm can now be restarted without destroying other X windows by pressing
the usual Mod-Shift-Q combination.

It is a good idea to place the above startup script into a separate
file, ~/bin/startdwm for instance, and execute it through ~/.xinitrc.
From this point on, when desiring to actually end the X session simply
execute killall startdwm, or bind it to a convenient key.

> Make the right Alt key work as if it were Mod4 (Windows Key)

When using Mod4 (aka Super/Windows Key) as the MODKEY, it may be equally
convenient to have the right Alt key (Alt_R) act as Mod4. This will
allow performing otherwise awkward keystrokes one-handed, such as
zooming with Alt_R+Enter.

First, find out which keycode is assigned to Alt_R:

    xmodmap -pke | grep Alt_R

Then simply add the following to the startup script (e.g. ~/.xinitrc),
changing the keycode 113 if necessary to the result gathered by the
previous xmodmap command:

    xmodmap -e "keycode 113 = Super_L"  # reassign Alt_R to Super_L
    xmodmap -e "remove mod1 = Super_L"  # make sure X keeps it out of the mod1 group

Now, any functions that are triggered by a Super_L (Windows) key press
will also be triggered by an Alt_R key press.

> Disable focus follows mouse behaviour

To disable focus follows mouse behaviour comment out the following line
in definiton of struct handler in dwm.c

    [EnterNotify] = enternotify, 

Note that this change can cause some difficulties. After it the first
click on inactive window will only bring the focus on it. To interact
with window contents (buttons, fields etc) you need to click again. Also
if you have several monitors you can notice that keyboard focus doesn't
switch to another monitor activated by clicking.

> Adding custom keybinds/shortcuts

Two entries are needed in config.h to create custom keybinds. One under
the "/* commands */" section, and another under the "static Key keys[] =
{" section.

    static const char *<keybindname>[]   = { "<command>", "<flags>", "<arguments>", NULL };

<keybindname> can be anything... <command> <-flags> and <arguments> can
be anything but they have to be individually enclosed in "",

    { MODKEY,            XK_<key>,      spawn,          {.v = <keybindname> } },

...would bind Mod+<key> to the command defined previously.

    { MODKEY|ShiftMask,  XK_<key>,      spawn,          {.v = <keybindname> } },

...would bind Mod+Shift+<key> Use ControlMask for Ctrl key.

Single keys such as Fn or multimedia keys have to be bound with the hex
codes obtainable from the program "xev"

    { 0,                 0xff00,    spawn,       {.v = <keybindname> } },

...would bind foo key 0xff00 to <keybindname>

-   How to check for keycodes

> Fixing misbehaving Java applications

As of JRE 6u20, Java applications misbehave in dwm because it is not a
known window manager to Java. This causes menus to close when the mouse
is released, and other little issues. First, install wmname from the
[community] repository:

    # pacman -S wmname

Now all you have to do is use wmname to set a WM name that Java
recognizes:

Note:This may cause some programs to behave oddly when tiled
(specifically Chromium).

    $ wmname LG3D

  
 This is not permanent, so you may want to add this command to your
.xinitrc.

It is also possible to change enable
export _JAVA_AWT_WM_NONREPARENTING=1 in /etc/profile.d/jre.sh

See also
--------

-   dwm's official website
-   Introduction to dwm video
-   dmenu - Simple application launcher from the developers of dwm
-   The dwm thread on the forums
-   Hacking dwm thread
-   Check out the forums' wallpaper thread for a selection of dwm
    wallpapers
-   Show off your dwm configuration forum thread
-   Moved to dwm
-   dwm: Tags are not workspaces

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dwm&oldid=255124"

Category:

-   Dynamic WMs
