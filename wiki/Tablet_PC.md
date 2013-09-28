Tablet PC
=========

Here are some hints for getting Arch Linux working on your tablet PC.
These instructions contain information for getting the stylus, stylus
rotation, and screen rotation to work properly on a tablet PC.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Stylus                                                             |
| -   2 Rotation                                                           |
|     -   2.1 Script for Stylus Rotation and Screen Rotation               |
|                                                                          |
| -   3 Tablet PC Tips                                                     |
|     -   3.1 CellWriter                                                   |
|     -   3.2 Easystroke                                                   |
|         -   3.2.1 Launching CellWriter Under Pen                         |
|         -   3.2.2 Gestures for the Alphabet                              |
|                                                                          |
|     -   3.3 Xournal                                                      |
|     -   3.4 Disable gksu Grab Mode                                       |
|     -   3.5 Gnome-screensaver                                            |
|     -   3.6 GDM                                                          |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 Wacom Drivers                                                |
|     -   4.2 Screen Rotation                                              |
+--------------------------------------------------------------------------+

Stylus
------

First install the xf86-input-wacom package. You can get this package
from the extra repository.

Then add the following lines to the ServerLayout section of your Xorg
configuration file (/etc/X11/xorg.conf).

    InputDevice    "stylus" "SendCoreEvents"
    InputDevice    "eraser" "SendCoreEvents"
    InputDevice    "cursor" "SendCoreEvents"

And add the following sections to the file:

    Section "InputDevice"
        Identifier     "stylus"
        Driver         "wacom"
        Option         "Device" "/dev/ttyS0"
        Option         "Type" "stylus"
        Option         "ForceDevice" "ISDV4"
        Option         "Button2" "3"
    EndSection

    Section "InputDevice"
        Identifier     "eraser"
        Driver         "wacom"
        Option         "Device" "/dev/ttyS0"
        Option         "Type" "eraser"
        Option         "ForceDevice" "ISDV4"
        Option         "Button2" "3"
    EndSection

    Section "InputDevice"
        Identifier     "cursor"
        Driver         "wacom"
        Option         "Device" "/dev/ttyS0"
        Option         "Type" "cursor"
        Option         "ForceDevice" "ISDV4"
    EndSection

Rotation
--------

Unless you are running a very old Xserver, rotation capabilities
(xrandr) should already be on by default. If not, you can enable xrandr
by adding the following option to the Screen section of the xorg.conf
file.

    Option         "RandRRotation" "on"

Save the file and restart the xserver for changes to take effect.

> Script for Stylus Rotation and Screen Rotation

The following script will rotate the display 90 degrees clockwise every
time it is executed.

Create a new file called rotate.sh:

    #!/bin/bash

    # Rotate the screen clockwise 90 degrees.
    # Also, rotate the wacom pointer so the stylus will still work.
    # Additionally, since Compiz does not work rotated, replace it with Metacity.

    # REQUIRES: linuxwacom (http://linuxwacom.sourceforge.net/)

    # Ben Wong,  October 1, 2010
    # Public domain.  No rights reserved. 

    case $(xsetwacom get stylus Rotate) in
        ccw)  # Currently top is rotated left, we should set it normal (0°)
    	  xrandr -o 0
    	  xsetwacom set stylus Rotate 0
    	  compiz --replace &
    	  ;;
        none)  # Screen is not rotated, we should rotate it right (90°)
    	   xrandr -o 3
    	   xsetwacom set stylus Rotate 1
    	   metacity --replace &
    	   ;;
        cw)    # Top of screen is rotated right, we should invert it (180°)
    	   xrandr -o 2
    	   xsetwacom set stylus Rotate 3
    	   ;;
        half)  # Screen is inverted, we should rotate it left (270°)
    	   xrandr -o 1
    	   xsetwacom set stylus Rotate 2
    	   ;;
        *)
    	   echo "Unknown result from 'xsetwacom get stylus Rotate'" >&2
    	   exit 1
    	   ;;
    esac

Save the file and make it executable (chmod +x rotate.sh). You can
create a link to it on your desktop or panel, or link it to a keyboard
shortcut or special button on your tablet. Note that this script assumes
you have Compiz ("Advanced desktop effects") running and that it fails
to work when the screen is rotated. Simply remove the lines referring to
compiz and metacity if this is not the case for you.

Tablet PC Tips
--------------

Here are some extra tips for setting up your Tablet PC.

> CellWriter

CellWriter is a grid-entry natural handwriting input panel. As you write
characters into the cells, your writing is instantly recognized at the
character level. cellwriter is available in community repository.

> Easystroke

Easystroke is a gesture recognition application, recognizing gestures by
a variety of input devices, to include pen stylus, mouse, and touch.
Gestures can be used to launch programs, enter text, emulate buttons and
keys, and scroll. Easystroke is available in the AUR.

Launching CellWriter Under Pen

One useful application of Easystroke is to use it to launch CellWriter
right under your mouse pointer, using the following script:

    #!/bin/bash
    # Original author: mr_deimos (ubuntuforums.org). February 14, 2010
    # Many bugs fixed and improvements made by Ben Wong.  October 20, 2010

    # This script toggles the cellwriter letter recognizer window.
    # If a cellwriter window is visible, it will be hidden.
    # If cellwriter is not already running, this will create a new process.
    # If coordinates are specified, the window pops up at those coordinates. 
    # If coordinates are not specified, the window is toggled, but not moved.

    # Implementation Note: this script is trickier than it should be
    # because cellwriter does two stupid things. First, it has no
    # --get-state option, so we can't tell if it is hidden or not. Second,
    # both the notification area applet and the actual program window have
    # the same window name in X, which means we can't simply use xwininfo
    # to find out if it is showing or not. 
    #
    # (Of course, we wouldn't have to be doing this crazy script at all,
    # if cellwriter had a --toggle-window option to toggle showing the
    # keyboard, but that's another rant...)
    #
    # To work around the problem, we'll assume that if the window we got
    # information about from xwininfo is smaller than 100 pixels wide, it
    # must be an icon in the notification area. This may be the wrong
    # assumption, but, oh well...

    if [[ "$1" == "-v" || "$1" == "--verbose" ]]; then
        verbose=echo
        shift
    else
        verbose=:
    fi

    if [[ "$1" && -z "$2"  ||  "$1" == "-h"  ||  "$1" == "--help" ]] ; then 
        cat >&2 <<EOF
    $(basename $0): Toggle showing the cellwriter window, optionally moving it."

    Usage:  $(basename $0) [x y]"
    	Where x and y are the desired position of the cellwriter window."
    	If x and y are omitted, the window is not moved."
    EOF
        exit 1
    fi

    if [[ "$1" && "$2" ]]; then
        x=$[$1-20]			# Offset slightly so cursor will be in window 
        y=$[$2-30]
        [ $x -lt 0 ] && x=0		# Minimum value is zero
        [ $y -lt 0 ] && y=0
    fi

    if ! xwininfo -root >/dev/null; then
        echo "$(basename $0): Error: Could not connect to your X server." >&2
        exit 1
    fi

    # Try to obtain CellWriter's window id.
    # We can't use "xwininfo -name" b/c that might find the notification icon. 
    OLDIFS="$IFS"
    IFS=$'\n'
    for line in $(xwininfo -root -tree | grep CellWriter); do
        line=0x${line#*0x}		# Just to get rid of white space before 0x.
        $verbose -en "Checking: $line\t"
        if [[ $line =~ (0x[A-Fa-f0-9]+).*\)\ *([0-9]+)x([0-9]+) ]]; then
    	id=${BASH_REMATCH[1]}
    	width=${BASH_REMATCH[2]}
    	height=${BASH_REMATCH[3]}
    	if [[ $width -gt 100 ]]; then
    	    $verbose "looks good."
    	    CW_WIN_ID=$id
    	    break;
    	else
    	    $verbose "too small, ignoring."
    	fi
        else
    	echo "BUG: The xwininfo regular expression in $0 is broken." >&2
        fi
    done
    IFS="$OLDIFS"

    #Check if Cellwriter's window is visible
    if [ "$CW_WIN_ID" ] ; then
        CW_MAP_STATE=`xwininfo -id "$CW_WIN_ID"|grep "Map State"|cut -f 2 -d :`
    else
        $verbose "Can't find cellwriter window, checking for a running process..."
        if ! pgrep -x cellwriter >& /dev/null; then
    	$verbose "No cellwriter process running, starting a new one."
    	if [[ "$x" && "$y" ]]; then
    	    cellwriter --show-window --window-x=$x --window-y=$y &
    	else
    	    cellwriter --show-window &
    	fi
    	exit 0
        else
    	$verbose "Found a process, so the window has not been created yet."
    	$verbose "Pretending the window is UnMapped."
    	CW_MAP_STATE=IsUnMapped
        fi
    fi

    $verbose "Map state: $CW_MAP_STATE"

    case "$CW_MAP_STATE" in

        *IsViewable*)		# Window is currently visible.
    	$verbose "hiding window"
    	cellwriter --hide-window &
    	;;

        *IsUnMapped*)		# Window is currently hidden or non-existent.
    	if [[ "$x" && "$y" && "$CW_WIN_ID" ]]; then
    	    $verbose "moving window to $x $y"
    	    xdotool windowmove $CW_WIN_ID $x $y
    	fi
    	$verbose "showing window"
    	cellwriter --show-window &    # In bg in case cw is not already running
    	;;

        *) 				# This will never happen...
    	echo "BUG: cellwriter is neither viewable nor unmapped" >&2
    	echo "BUG: ...which means this script, $0, is buggy." >&2
    	exit 1
    	;;
    esac

    exit 0

Save the script as cellwriter.sh in either /usr/local/bin/ or $HOME/bin,
and give it executable rights:

    chmod +x cellwriter.sh

Then create a gesture in Easystroke tied to the following command:

    cellwriter.sh $EASYSTROKE_X1 $EASYSTROKE_Y1

When you launch it (using the gesture you created) it will open right
under your pen.

Note:This script requires the xdotool package, which is not installed by
default.

Gestures for the Alphabet

You can also use Easystroke to make gestures for the entire alphabet,
replacing much of the need for CellWriter. To avoid having to make
seperate gestures for the uppercase-letters, you can use the following
script to activate the shift key.

    #!/bin/bash
    if [ -f /tmp/shift ]
    then
      xte "keydown Shift_L" "key $1" "keyup Shift_L"
      rm -f /tmp/shift
    else
      xte "key $1"
    fi

Save the script as keypress.sh in either /usr/local/bin/ or $HOME/bin,
and give it executable rights:

    chmod +x keypress.sh

Then create a gesture in Easystroke tied to the following command:

    touch /tmp/shift

This will activate the shift key. To activate the letter keys, tie your
gestures to the following command:

    keypress.sh $LETTER

Replace $LETTER with the letter in the alphabet in question.

So when you want to enter an upper-case letter, use your gesture for the
shift key followed by the letter. If you want a lower-case letter,
simply use your gesture for the letter.

Note:This script requires the xautomation package, which is not
installed by default.

> Xournal

Xournal is an application for notetaking, sketching, and keeping a
journal using a stylus. Xournal aims to provide superior graphical
quality (subpixel resolution) and overall functionality. Xournal can be
installed from the extra repository.

You can also extend the functionality of Xournal with patches, to enable
such things as autosaving documents and inserting images. See
SourceForge for links to all the available patches. To apply a patch,
download the PKGBUILD for Xournal from the ABS, and reference the
article Patching in ABS.

> Disable gksu Grab Mode

If you are using gksu/gksudo, you may want to disable grab mode so that
you can authenticate by using the stylus to enter the password. In a
terminal, run the following command:

    $ gksu-properties

Change the Grab Mode to disable.

Note:This will make it possible for other X applications to listen to
keyboard input events, thus making it not possible to shield from
malicious applications which may be running, such as keyloggers, etc.

> Gnome-screensaver

To unlock your gnome-screensaver using Cellwriter to enter your
password, first start Gconf-editor:

    $ gconf-editor

Under /apps/gnome-screensaver, set embedded_keyboard_command to
cellwriter --xid --keyboard-only, and check the
embedded_keyboard_enabled checkbox.

Alternatively, instead of using the graphical registry editor, you can
simply paste these into your command-line:

    $ gconftool-2 --set /apps/gnome-screensaver/embedded_keyboard_command "cellwriter --xid --keyboard-only" --type string
    $ gconftool-2 --set /apps/gnome-screensaver/embedded_keyboard_enabled true --type boolean

If you are administrating a multi-user system and would like to set the
system-wide default, you can do so like so,

    $ sudo gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.defaults --set /apps/gnome-screensaver/embedded_keyboard_command "cellwriter --xid --keyboard-only" --type string
    $ sudo gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.defaults --set /apps/gnome-screensaver/embedded_keyboard_enabled true --type boolean

> GDM

You can also use CellWriter with GDM. First open /etc/gdm/Init/Default
as root with a text editor. Then near the bottom of the file, add the
lines in bold as shown

    fi
    cellwriter --keyboard-only &
    exit 0

You can add --window-x and --window-y to adjust the position of
CellWriter accordingly. For example:

    cellwriter --keyboard-only --window-x=512 --window-y=768 &

Note:You can only use CellWriter with a Plain style GDM.

To start a fully fledged CellWriter instance within the user session,
you might want to terminate the instance started with the keyboard-only
switch within the gdm context. Add something like

    killall cellwriter

to you newly created file /etc/gdm/PostLogin/Default .

Note:This works for me in a single-user setup, if you have a multi-user
setup, you might want to develop and post your more elaborate solution.

Troubleshooting
---------------

Some tips on troubleshooting:

> Wacom Drivers

These commands are useful in troubleshooting:

    wacdump -f tpc /dev/ttyS0
    xidump -l
    xidump -u stylus

If xidump shows that your tablet's max resolution is the same as screen
resolution, then your wacom driver has rescaled your wacom coordinates
to the X server's resolution. To fix this, try recompiling you
linuxwacom driver with:

    ./configure --disable-quirk-tablet-rescale

> Screen Rotation

Some video drivers do not support rotation. To check if your driver
supports rotation, check the output of xrandr for the list orientations:

    normal left inverted right

Note:The following driver(s) are known not to support rotation: fglrx

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tablet_PC&oldid=214094"

Category:

-   Mobile devices
