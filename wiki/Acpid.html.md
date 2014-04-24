acpid
=====

Related articles

-   ACPI modules
-   DSDT

acpid is a flexible and extensible daemon for delivering ACPI events. It
listens on /proc/acpi/event and when an event occurs, executes programs
to handle the event. These events are triggered by certain actions, such
as:

-   Pressing special keys, including the Power/Sleep/Suspend button
-   Closing a notebook lid
-   (Un)Plugging an AC power adapter from a notebook
-   (Un)Plugging phone jack etc.

Note:Desktop environments, such as GNOME, systemd login manager and some
extra key handling daemons may implement own event handling schemes,
independent of acpid. Running more than one system at the same time may
lead to unexpected behaviour, such as suspending two times in a row
after one sleep button press. You should be aware of this and only
activate desirable handlers.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Alternative configuration
-   3 Tips and tricks
    -   3.1 Example events
    -   3.2 Enabling volume control
    -   3.3 Enabling backlight control
    -   3.4 Enabling Wi-fi toggle
    -   3.5 Laptop monitor power off
    -   3.6 Getting user name of the current display
    -   3.7 ACPI hotkey
-   4 See also

Installation
------------

Install the acpid package, available in the official repositories.

To have acpid started on boot, enable acpid.service.

Configuration
-------------

acpid comes with a number of predefined actions for triggered events,
such as what should happen when you press the Power button on your
machine. By default, these actions are defined in /etc/acpi/handler.sh,
which is executed after any ACPI events are detected (as determined by
/etc/acpi/events/anything).

The following is a brief example of one such action. In this case, when
the Sleep button is pressed, acpid runs the command
echo -n mem >/sys/power/state which should place the computer into a
sleep (suspend) state:

    button/sleep)
        case "$2" in
            SLPB) echo -n mem >/sys/power/state ;;
    	 *)    logger "ACPI action undefined: $2" ;;
        esac
        ;;

Unfortunately, not every computer labels ACPI events in the same way.
For example, the Sleep button may be identified on one machine as SLPB
and on another as SBTN.

To determine how your buttons or Fn shortcuts are recognized, run the
following command from a terminal as root:

    # journalctl -f

Now press the Power button and/or Sleep button (e.g. Fn+Esc) on your
machine. The result should look something this:

    logger: ACPI action undefined: PBTN
    logger: ACPI action undefined: SBTN

If that does not work, run:

    # acpi_listen

Then press the power button and you will see something like this:

    power/button PBTN 00000000 00000b31

The output of acpi_listen is sent to /etc/acpi/handler.sh as $1, $2 , $3
& $4 parameters. Example:

    $1 power/button
    $2 PBTN
    $3 00000000
    $4 00000b31

As you might have noticed, the Sleep button in the sample output is
actually recognized as SBTN, rather than the SLPB label specified in the
default /etc/acpi/handler.sh. In order for Sleep function to work
properly on this machine, we would need to replace SLPB) with SBTN).

Using this information as a base, you can easily customize the
/etc/acpi/handler.sh file to execute a variety of commands depending on
which event is triggered. See the Tips & Tricks section below for other
commonly used commands.

> Alternative configuration

By default, all ACPI events are passed through the /etc/acpi/handler.sh
script. This is due to the ruleset outlined in
/etc/acpi/events/anything:

    # Pass all events to our one handler script
    event=.*
    action=/etc/acpi/handler.sh %e

While this works just fine as it is, some users may prefer to define
event rules and actions in their own self-contained scripts. The
following is an example of how to use an individual event file and
corresponding action script:

As root, create the following file:

    /etc/acpi/events/sleep-button

    event=button sleep.*
    action=/etc/acpi/actions/sleep-button.sh %e

Now create the following file:

    /etc/acpi/actions/sleep-button.sh

    #!/bin/sh
    case "$3" in
        SLPB) echo -n mem >/sys/power/state ;;
        *)    logger "ACPI action undefined: $3" ;;
    esac

Finally, make the script executable:

    # chmod +x /etc/acpi/actions/sleep-button.sh

Using this method, it is easy to create any number of individual
event/action scripts.

Tips and tricks
---------------

Tip:Some of actions, described here, such as Wi-Fi toggle and backlight
control, may already be managed directly by driver. You should consult
documentation of corresponding kernel modules, when this is the case.

> Example events

The following are examples of events that can be used in the
/etc/acpi/handler.sh script. These examples should be modified so that
they apply your specific environment e.g. changing the event variable
names interpreted by acpi_listen.

To lock the screen with xscreensaver when closing the laptop lid:

    button/lid)
        case $3 in
            close)
                # The lock command need to be run as the user who owns the xscreensaver process and not as root.
                # See: man xscreensaver-command. $xs will have the value of the user owning the process, if any.

                xs=$(ps -C xscreensaver -o user=)
                if test $xs; then su $xs -c "xscreensaver-command -lock"; fi
                ;;

To suspend the system and lock the screen using slimlock when the lid is
closed:

    button/lid)
        case $3 in
            close)
                #echo "LID switched!">/dev/tty5
    	     /usr/bin/pm-suspend &
    	     DISPLAY=:0.0 su -c - username /usr/bin/slimlock
                ;;

To set the laptop screen brightness when plugged in power or not (the
numbers might need to be adjusted, see
/sys/class/backlight/acpi_video0/max_brightness):

    ac_adapter)
        case "$2" in
            AC*|AD*)
                case "$4" in
                    00000000)
                        echo -n 50 > /sys/class/backlight/acpi_video0/brightness
                        ;;
                    00000001)
                        echo -n 100 > /sys/class/backlight/acpi_video0/brightness
                        ;;
                esac

> Enabling volume control

Find out the acpi identity of the volume buttons (see above) and
susbtitute it for the acpi events in the files below. We create a script
to control the volume (assuming an ALSA sound card):

    /etc/acpi/handlers/vol

    #!/bin/sh
    step=5

    case $1 in
      -) amixer set Master $step-;;
      +) amixer set Master $step+;;
    esac

and connect these to new acpi events:

    /etc/acpi/events/vol_d

    event=button/volumedown
    action=/etc/acpi/handlers/vol -

    /etc/acpi/events/vol_u

    event=button/volumeup
    action=/etc/acpi/handlers/vol +

as well as another event to toggle the mute setting:

    /etc/acpi/events/mute

    event=button/mute
    action=/usr/bin/amixer set Master toggle

> Enabling backlight control

Similar to volume control, acpid also enables you to control screen
backlight. To achieve this you write some handler, like this:

    /etc/acpi/handlers/bl

    #!/bin/sh
    bl_dev=/sys/class/backlight/acpi_video0
    step=1

    case $1 in
      -) echo $(($(< $bl_dev/brightness) - $step)) >$bl_dev/brightness;;
      +) echo $(($(< $bl_dev/brightness) + $step)) >$bl_dev/brightness;;
    esac

and again, connect keys to ACPI events:

    /etc/acpi/events/bl_d

    event=video/brightnessdown
    action=/etc/acpi/handlers/bl -

    /etc/acpi/events/bl_u

    event=video/brightnessup
    action=/etc/acpi/handlers/bl +

> Enabling Wi-fi toggle

You can also create a simple wireless-power switch by pressing the WLAN
button. Example of event:

    /etc/acpi/events/wlan

    event=button/wlan
    action=/etc/acpi/handlers/wlan

and its' handler:

    /etc/acpi/handlers/wlan

    #!/bin/sh
    rf=/sys/class/rfkill/rfkill0

    case $(< $rf/state) in
      0) echo 1 >$rf/state;;
      1) echo 0 >$rf/state;;
    esac

> Laptop monitor power off

Adapted from the Gentoo Wiki comes this little gem. Add this to the
button/lid section of /etc/acpi/handler.sh. This will turn off the LCD
back-light when the lid is closed, and restart when the lid is opened.

    case $(awk '{print $2}' /proc/acpi/button/lid/LID0/state) in
        closed) XAUTHORITY=$(ps -C xinit -f --no-header | sed -n 's/.*-auth //; s/ -[^ ].*//; p') xset -display :0 dpms force off ;;
        open)   XAUTHORITY=$(ps -C xinit -f --no-header | sed -n 's/.*-auth //; s/ -[^ ].*//; p') xset -display :0 dpms force on  ;;
    esac

If you would like to increase/decrease brightness or anything dependent
on X, you should specify the X display as well as the MIT magic cookie
file (via XAUTHORITY). The last is a security credential providing read
and write access to the X server, display, and any input devices.

Here is another script not using XAUTHORITY but sudo:

    case $(awk '{print $2}' /proc/acpi/button/lid/LID0/state) in
        closed) sudo -u $(ps -o ruser= -C xinit) xset -display :0 dpms force off ;;
        open)   sudo -u $(ps -o ruser= -C xinit) xset -display :0 dpms force on  ;;
    esac

With certain combinations of Xorg and stubborn hardware,
xset dpms force off only blanks the display leaving the backlight turned
on. This can be fixed using vbetool from the official repositories.
Change the LCD section to:

    case $(awk '{print $2}' /proc/acpi/button/lid/LID0/state) in
        closed) vbetool dpms off ;;
        open)   vbetool dpms on  ;;
    esac

If the monitor appears to shut off only briefly before being re-powered,
very possibly the power management shipped with xscreensaver conflicts
with any manual dpms settings.

> Getting user name of the current display

You can use the function getuser to discover the user of the current
display:

    getuser ()
        {
         export DISPLAY=$(echo $DISPLAY | cut -c -2)
         user=$(who | grep " $DISPLAY" | awk '{print $1}' | tail -n1)
         export XAUTHORITY=/home/$user/.Xauthority
         eval $1=$user
        }

This function can be used for example, when you press the power button
and want to shutdown KDE properly:

    button/power)
        case "$2" in
            PBTN)
                getuser "$user"
                echo $user > /dev/tty5
                su $user -c "dcop ksmserver ksmserver logout 0 2 0"
                ;;
              *) logger "ACPI action undefined $2" ;;
        esac
        ;;

On newer systems using systemd, X11 logins are no longer necessarily
displayed in who, so the getuser function above does not work. An
alternative is to use loginctl to obtain the required information, e.g.
using xuserrun.

> ACPI hotkey

You can either directly edit /etc/acpi/handler.sh, to react to the ACPI
events, or you can point it to another shell script (i.e.
/etc/acpi/hotkeys.sh)

Under the section

    case "$1" in

Add the following lines:

    hkey)
    	case "$4" in
    		00000b31)
    		echo "PreviousButton pressed!"
    		exailectl p
    		;;
    	00000b32)
    		echo "NextButton pressed!"
    		exailectl n
    		;;
    	00000b33)
    		echo "Play/PauseButton pressed!"
    		exailectl pp
    		echo "executed.."
    		;;
    	00000b30)
    		echo "StopButton pressed!"
    		exailectl s
    		;;
    	*)
    		echo "Hotkey Else: $4"
    		;;
    	esac
    	;;

The '00000b31' etc. values are the response received from acpi_listen.

Also, the exailectl script is a brief shell script I created for
controlling Exaile music player. As the ACPID is run from root, you will
need to use

    $ sudo -u username exaile

for example, otherwise it will not detect your user-level program and
recreate another.

See also
--------

-   http://acpid.sourceforge.net/ - acpid homepage
-   http://www.gentoo-wiki.info/ACPI/Configuration - Gentoo wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acpid&oldid=298830"

Category:

-   Power management

-   This page was last modified on 18 February 2014, at 22:48.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
