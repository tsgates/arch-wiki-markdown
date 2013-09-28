spectrwm
========

From spectrwm's website:

  “spectrwm is a small dynamic tiling window manager for Xorg. It tries
  to stay out of the way so that valuable screen real estate can be used
  for much more important stuff. It has sane defaults and does not
  require one to learn a language to do any configuration. It was
  written by hackers for hackers and it strives to be small, compact and
  fast.”

Spectrwm is written in C and configured with a text configuration file.
It was previously known as scrotwm.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Starting spectrwm                                                  |
|     -   3.1 Starting spectrwm with XDM                                   |
|     -   3.2 Starting spectrwm with KDM                                   |
|                                                                          |
| -   4 Multiple monitors (Xinerama)                                       |
| -   5 Statusbar configuration                                            |
|     -   5.1 Bash scripts                                                 |
|     -   5.2 Conky                                                        |
|                                                                          |
| -   6 Alternative status bar                                             |
| -   7 Screenshots                                                        |
| -   8 Screen locking                                                     |
| -   9 Using spectrwm                                                     |
| -   10 Troubleshooting                                                   |
| -   11 See also                                                          |
+--------------------------------------------------------------------------+

Installation
------------

spectrwm is available in the [community] repository.

The modkey (the main key to issue commands with) is set to Mod4, which
is usually the Windows key.

spectrwm can make use of the dmenu package, so you may want to install
that too.

It can also execute a screenshot command from a keybinding which may be
used to call scrot using the script given below.

There is also a screen lock keybinding. By default calls xlock, provided
in Arch by the xlockmore package.

xscreensaver is also useful for screen saving and power management after
an idle period, and screen locking.

See Xdefaults for details of how to set up fonts, colours and other
settings for xterm and xscreensaver. Run xscreensaver-demo to select the
animation (or blank) and display power management (recommended).

Configuration
-------------

spectrwm first tries to open the user specific file, ~/.spectrwm.conf.
If that file is unavailable, it tries to open the global configuration
file, /etc/spectrwm.conf. The initial configuration provides a good set
of defaults.

Optionally, spectrwm can call baraction.sh (in the user's path), which
should output a text status message to stdout for the status bar at the
top of the screen.

Starting spectrwm
-----------------

To start spectrwm via startx or the SLIM login manager, simply append
the following to ~/.xinitrc:

    exec spectrwm

> Starting spectrwm with XDM

For XDM, create ~/.xsession with the following contents:

    # .xsession
    # This file is sourced by xdm
    spectrwm

Make sure ~/.xsession is executable:

    chmod a+x ~/.xsession

Note: if you do not create ~/.xsession then ~/.xinitrc will be used, but
you might want different settings depending on if you use startx or XDM.
Remember to make ~/.xinitrc executable, or XDM won't start, if you use
that method.

For a nice simple Arch themed xdm, try xdm-arch-theme.

> Starting spectrwm with KDM

For KDM, make sure /usr/share/xsessions is listed in SessionDirs in
/usr/share/config/kdm/kdmrc as described here. SpectrWM will then be
available as an option in the Session Type menu in KDM.

To start other tasks when the session is launched, for example to launch
xscreensaver and set the background image, copy
/usr/share/config/kdm/Xsession to a custom version as described here,
and then edit it, for example like this:

    case $session in
     "")
       exec xmessage -center -buttons OK:0 -default OK "Sorry, $DESKTOP_SESSION is no valid session."
       ;;
     failsafe)
       exec xterm -geometry 80x24-0-0
       ;;
     custom)
       exec $HOME/.xsession
       ;;
     default)
       exec /usr/bin/startkde
       ;;
     /usr/bin/spectrwm|otherwm)
       feh --bg-scale /usr/share/wallpapers/Plasmalicious/contents/images/1280x1024.jpg
       xscreensaver -no-splash &
       eval exec "$session"
       ;;
     *)
       eval exec "$session"
       ;;
    esac

Multiple monitors (Xinerama)
----------------------------

With a non-Xrandr multiple monitor setup create regions to split the
total desktop area into one region per monitor:

    region                = screen[1]:1280x1024+0+0
    region                = screen[1]:1280x1024+1280+0

Statusbar configuration
-----------------------

To enable the statusbar, uncomment these two items in /etc/spectrwm.conf
(or ~/.spectrwm.conf). By default they are commented out and the
statusbar is disabled.

    bar_action              = baraction.sh
    bar_delay               = 5

> Bash scripts

To test the status bar, place the following simple baraction.sh in a
~/scripts (or ~/bin) directory which you have previously added to your
$PATH in your ~/.bashrc file.

    #!/bin/bash
    # baraction.sh script for spectrwm status bar

    SLEEP_SEC=5  # set bar_delay = 5 in /etc/spectrwm.conf
    COUNT=0
    #loops forever outputting a line every SLEEP_SEC secs
    while :; do
    	let COUNT=$COUNT+1
            echo -e "         Hello World! $COUNT"
            sleep $SLEEP_SEC
    done

Press Modkey+Q to restart spectrwm and after a few seconds you should
see the output in the status bar. If you have problems at this stage,
make sure the script is executable, test it from the command line, and
check the path/filename you specified in bar_action.

Next replace baraction.sh with the more useful file below. Note it needs
these packages, and whatever you need for WiFi:

    pacman -S bc lm_sensors

You should configure lm_sensors.

Note:You may need to modify this script slightly for your computer. You
may have different units in the acpi battery info, different temperature
output from sensors or a different wifi interface than wlan0.

    #!/bin/bash
    #baraction.sh for spectrwm status bar

    SLEEP_SEC=5
    #loops forever outputting a line every SLEEP_SEC secs
    while :; do

     	eval $(cat /proc/acpi/battery/BAT0/state | awk '/charging state/ {printf "BAT_CHGSTATE=%s;", $3}; /remaining capacity/ {printf "BAT_REMNG=%s;",$3}; /present rate/ {printf "BAT_RATE=%s;",$3};' -)
     	eval $(cat /proc/acpi/battery/BAT0/info | awk '/present/ {printf "BAT_PRESENT=%s;", $2}; /last full capacity/ {printf "BAT_LASTFULL=%s;",$4};' -)
     
    	BAT_REMNG_WH=`echo "scale=1; a=($BAT_REMNG+50)/1000; print a" | bc -l`
    	BAT_RATE_W=`echo "scale=1; a=($BAT_RATE+50)/1000; print a" | bc -l`
    	BCSCRIPT="scale=0; a=(100*$BAT_REMNG / $BAT_LASTFULL); print a"
    	BAT_PCT=`echo $BCSCRIPT | bc -l`%

    	case $BAT_PRESENT in
    		no)
    		POWER_STR="AC, NO BATTERY"
    		;;
    		yes)

    		case $BAT_CHGSTATE in
    			charged)
    			#on ac
    			AC_STATUS="ON AC"
    			TIME_REMNG="N/A"
    			POWER_STR="$AC_STATUS $BAT_CHGSTATE $BAT_PCT"
    			;;
    			charging)
    			#on ac
    			AC_STATUS="ON AC"
    			BCSCRIPT="scale=1; a=(60*($BAT_LASTFULL - $BAT_REMNG) / $BAT_RATE); print a"
    			TIMETOFULL_MIN=`echo $BCSCRIPT | bc -l`
    			POWER_STR="$AC_STATUS $BAT_CHGSTATE $BAT_PCT C="$BAT_REMNG_WH"Wh Rate="$BAT_RATE_W"W TTF="$TIMETOFULL_MIN"min"
    			;;
    			discharging)
    			AC_STATUS="ON BATT"
    			TIME_REMNG_MIN=`echo "scale=0; a=(60*$BAT_REMNG / $BAT_RATE); print a" | bc -l`
    			TIME_REMNG_HH=`echo "scale=0; a=($BAT_REMNG / $BAT_RATE); if (a<10) {print "0"; print a} else {print a}" | bc -l`

    			TIME_REMNG_MM=`echo "scale=0; a=($TIME_REMNG_MIN-60*$TIME_REMNG_HH); if (a<10) {print "0"; print a} else {print a}" | bc -l`
    			POWER_STR="$AC_STATUS $BAT_PCT C="$BAT_REMNG_WH"Wh P="$BAT_RATE_W"W R="$TIME_REMNG_HH":"$TIME_REMNG_MM
    			;;
    			*)
    			POWER_STR=$BAT_CHGSTATE
    			;;
    		esac

    		;;
    		*)
    		POWER_STR="error"
    		;;
    	esac

    	#spectrwm bar_print can't handle UTF-8 characters, such as degree symbol
    	#Core 0:      +67.0°C  (crit = +100.0°C)
    	eval $(sensors 2>/dev/null | sed s/[°+]//g | awk '/^Core 0/ {printf "CORE0TEMP=%s;", $3}; /^Core 1/ {printf "CORE1TEMP=%s;",$3}; /^fan1/ {printf "FANSPD=%s;",$2};' -)
    	TEMP_STR="Tcpu=$CORE0TEMP,$CORE1TEMP F=$FANSPD"

    	WLAN_ESSID=$(iwconfig wlan0 | awk -F "\"" '/wlan0/ { print $2 }')
    	eval $(cat /proc/net/wireless | sed s/[.]//g | awk '/wlan0/ {printf "WLAN_QULTY=%s; WLAN_SIGNL=%s; WLAN_NOISE=%s", $3,$4,$5};' -)
    	BCSCRIPT="scale=0;a=100*$WLAN_QULTY/70;print a"
    	WLAN_QPCT=`echo $BCSCRIPT | bc -l`
    	WLAN_POWER=`iwconfig 2>/dev/null| grep "Tx-Power"| awk {'print $4'}|sed s/Tx-Power=//`
    	WLAN_STR="$WLAN_ESSID: Q=$WLAN_QPCT% S/N="$WLAN_SIGNL"/"$WLAN_NOISE"dBm T="$WLAN_POWER"dBm"

    	CPUFREQ_STR=`echo "Freq:"$(cat /proc/cpuinfo | grep 'cpu MHz' | sed 's/.*: //g; s/\..*//g;')`
    	CPULOAD_STR="Load:$(uptime | sed 's/.*://; s/,//g')"

    	eval $(awk '/^MemTotal/ {printf "MTOT=%s;", $2}; /^MemFree/ {printf "MFREE=%s;",$2}' /proc/meminfo)
    	MUSED=$(( $MTOT - $MFREE ))
    	MUSEDPT=$(( ($MUSED * 100) / $MTOT ))
    	MEM_STR="Mem:${MUSEDPT}%"

    	echo -e "$POWER_STR  $TEMP_STR  $CPUFREQ_STR  $CPULOAD_STR  $MEM_STR  $WLAN_STR"
            #alternatively if you prefer a different date format
            #DATE_STR=`date +"%H:%M %a %d %b"`
    	#echo -e "$DATE_STR   $POWER_STR  $TEMP_STR  $CPUFREQ_STR  $CPULOAD_STR  $MEM_STR  $WLAN_STR"

    	sleep $SLEEP_SEC
    done

Here are some other ideas for status bar items : ethernet, email
notification, disk space, mounts, now playing (mpc current).

The baraction.sh script may also show the date, in which case the
built-in clock can be disabled:

    clock_enabled     = 0

> Conky

Instead of a bash script, conky may be used. It should be used in
non-graphical mode as shown below to output a text string to stdout
which can be read in by spectrwm. First install conky. It is not
necessary to install the cut-down "conky-cli" from AUR (although that
would work too).

In ~/.spectrwm.conf set

    bar_action = conky

Then in each user's ~/.conkyrc file place for example:

    out_to_x no
    out_to_console yes
    update_interval 1.0
    total_run_times 0
    use_spacer none
    TEXT
    ${time %R %a,%d-%#b-%y} |Mail:${new_mails} |Up:${uptime_short} |Temp:${acpitemp}C |Batt:${battery_short} |${addr wlan0} |RAM:$memperc% |CPU:${cpu}% | ${downspeedf wlan0}

Alternative status bar
----------------------

An alternative is to use dzen2 to create a status bar. This has the
advantage that colors and even icons may be used, but the disadvantage
that the bar is not integrated with spectrwm. So the current workspace
number and layout and the bar-toggle keybinding are not available. The
"region" option can be used to reserve the required screen space. For
example to reserve 14 pixels at the top of the screen in spectrwm.conf
change

    bar_enabled             = 1
    region                  = screen[1]:1024x768+0+0

to

    bar_enabled             = 0
    region                  = screen[1]:1024x754+0+14

(adjust for your screen resolution).

Then, for example using i3status to supply the information:

    $ i3status | dzen2 -fn -*-terminus-medium-*-*-*-*-*-*-*-*-*-*-* &

Spectrwm's own bar can still be enabled and disabled with Meta+b.

Screenshots
-----------

Spectrwm has the facility to execute a script called screenshot.sh with
the keybindings

    Meta+s       for a full screenshot
    Meta+Shift+s for a screenshot of a single window

First install scrot Then copy the default script supplied in the
spectrwm package to a location in your $PATH, for example:

    $ cp /usr/share/spectrwm/screenshot.sh ~/bin

Screen locking
--------------

By default the lock keybinding (Mod+Shift+Delete) executes xlock

    program[lock]      = xlock

An alternative, if xscreensaver is already running, is to use

    program[lock]      = xscreensaver-command -lock

Using spectrwm
--------------

-   To save space, window title bars are not shown. Window borders are
    one pixel wide. The border changes colour to indicate focus.

-   Layouts are handled dynamically and can be changed on the fly. There
    are three standard layouts (stacking algorithms): vertical,
    horizontal and maximized (indicated in the status bar as [|], [-]
    and [ ])

-   There is the concept of a master area (a working area). Any window
    can be switched to become the master and will then be shown in the
    master area. The master area is the left (top) portion of the screen
    in vertical (horizontal) mode. The size of the master area can be
    adjusted with the keys. By default the master area holds one window,
    but this can be increased.

-   The area excluding the master area is called the stacking area. New
    windows are added to the stacking area. By default the stacking area
    has one column (row) in vertical (horizontal) mode, but his can be
    increased.

-   Windows may be moved to a floating layer -- i.e. removed from the
    tiling management. This is useful for programs which are not
    suitable for tiling.

Some of the most useful key bindings:

    Meta+Shift+Return: open terminal
    Meta+p: dmenu (then type the start of the program name and return)
    Meta+1/2/3/4/5/6/7/8/9/0: select workspaces 1-10
    Meta+Shift+1/2/3/4/5/6/7/8/9/0: move window to workspace 1-10
    Meta+Right/Left: select next/previous workspace
    Meta+Shift+Right/Left: select next/previous screen
    Meta+Spacebar: cycle through layouts (vertical, horizontal, maximized)
    Meta+j/k: cycle through windows forwards/backwards
    Meta+Tab/Meta+Shft+Tab: same as Meta+j/k
    Meta+Return: move current window to master area
    Meta+h/l:  increase/decrease size of master area

Advanced stacking

    Meta+,/. : increase/decrease the number of windows in master area (default is 1)
    Meta+Shift+,/. : increase/decrease number of columns(rows) in stacking area in vertical(horizontal) mode (default is 1)
    Meta+Shift+j/k: swap window position with next/previous window
    Meta+t: float<->tile toggle

Mouse bindings

    Mouseover: focus window
    Meta+LeftClick+Drag: move window (and float it if tiled)
    Meta+RightClick+Drag: resize floating window
    Meta+Shift+RightClick+Drag: resize floating window keeping it centred

Other useful bindings

    Meta+x: close window
    Meta+Shift+x: kill window
    Meta+b: hide/show status bar
    Meta+q: restart spectrwm (reset desktops and reread spectrwm config without stopping running programs)
    Meta+Shift+q: exit spectrwm

Troubleshooting
---------------

-   Q: Help, I just logged in and all I see is a blank screen.
-   A: Press Shift + WindowsKey + Return and an xterm will start. Then
    read the manual (man spectrwm) to see the other default key
    bindings. Also check your configuration file.

See also
--------

-   spectrwm - spectrwm's official website

-   dmenu - Simple application launcher from the developers of dwm

-   #spectrwm at irc.freenode.net - (un)official IRC channel

-   The scrotwm thread

Retrieved from
"https://wiki.archlinux.org/index.php?title=Spectrwm&oldid=230175"

Category:

-   Dynamic WMs
