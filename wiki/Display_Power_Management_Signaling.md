Display Power Management Signaling
==================================

DPMS (Display Power Management Signaling) is a technology that allows
power saving behaviour of monitors when the computer is not in use.

For details on each Timeout, see the Description section here.

Contents
--------

-   1 Setting up DPMS in X
-   2 Modifying DPMS and screensaver settings using xset
    -   2.1 xset screen-saver control
    -   2.2 To see your current settings
-   3 Examples
    -   3.1 Turn off DPMS
    -   3.2 Disable screen saver blanking
    -   3.3 Disable DPMS and prevent screen from blanking
    -   3.4 Turn off screen immediately
    -   3.5 Put screen into standby
    -   3.6 Put screen into suspend
    -   3.7 Change Blank time from 5 min to 1 hour
    -   3.8 xset display.sh
-   4 DPMS interaction in a Linux console with setterm
    -   4.1 Prevent screen from turning off
    -   4.2 Pipe the output to a cat to see the escapes
    -   4.3 Pipe the escapes to any tty (with write/append perms) to
        modify that terminal
        -   4.3.1 Bash loop to set ttys 0-256
-   5 Troubleshooting
    -   5.1 xset DPMS settings do not work with xscreensaver
        -   5.1.1 xscreensaver DPMS
-   6 See also

Setting up DPMS in X
--------------------

Note:As of Xorg 1.8 DPMS is auto detected and enabled if ACPI is also
enabled at kernel runtime.

Add the following to a file in /etc/X11/xorg.conf.d/ in the Monitor
section:

    Option "DPMS" "true"

Add the following to the ServerLayout section, change the times (in
minutes) as necessary:

    Option "StandbyTime" "10"
    Option "SuspendTime" "20"
    Option "OffTime" "30"

Note:If the "OffTime" option does not work replace it with the
following, (change the "blanktime" to "0" to disable screen blanking)

    Option         "BlankTime" "30"

An example file /etc/X11/xorg.conf.d/10-monitor.conf could look like
this.

    Section "Monitor"
        Identifier "LVDS0"
        Option "DPMS" "false"
    EndSection

    Section "ServerLayout"
        Identifier "ServerLayout0"
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime" "0"
    EndSection

Modifying DPMS and screensaver settings using xset
--------------------------------------------------

It is possible to turn off your monitor using the xset tool which is
provided by the xorg-xset package in the official repositories.

Note:If using this command manually in a shell you may need to prefix it
with sleep 1; for it to work correctly. For example:

    $ sleep 1; xset dpms force off

To control Energy Star (DPMS) features (a timeout value of zero disables
the mode):

    $ xset -dpms Energy Star features off
    $ xset +dpms Energy Star features on
    $ xset dpms [standby [suspend [off]]]     
    $ xset dpms force standby 
    $ xset dpms force suspend 
    $ xset dpms force off 
    $ xset dpms force on  (also implicitly enables DPMS features)

> xset screen-saver control

You can use xset to control your screensaver:

    $ xset s [timeout [cycle]]  
    $ xset s default    
    $ xset s on
    $ xset s blank              
    $ xset s noblank    
    $ xset s off
    $ xset s expose             
    $ xset s noexpose
    $ xset s activate           
    $ xset s reset

> To see your current settings

    $ xset q


    ...

    Screen Saver:
      prefer blanking:  yes    allow exposures:  yes
      timeout:  600    cycle:  600
    DPMS (Energy Star):
      Standby: 600    Suspend: 600    Off: 600
      DPMS is Enabled
      Monitor is On

Examples
--------

> Turn off DPMS

    $ xset -dpms

> Disable screen saver blanking

    $ xset s off

> Disable DPMS and prevent screen from blanking

Useful when watching movies or slideshows:

    $ xset -dpms; xset s off

> Turn off screen immediately

If you leave your computer, you do not need to wait for the timeout you
set that the display turns off. Simply enforce it by using the xset
command.

    $ xset dpms force off

> Put screen into standby

    $ xset dpms force standby

> Put screen into suspend

    $ xset dpms force suspend

> Change Blank time from 5 min to 1 hour

    $ xset s 3600 3600

> xset display.sh

You could also copy this script:

    /usr/local/bin/display.sh

    #!/bin/bash
    # Small script to set display into standby, suspend or off mode
    # 20060301-Joffer

    case $1 in
        standby|suspend|off)
            xset dpms force $1
        ;;
        *)
            echo "Usage: $0 standby|suspend|off"
        ;;
      esac

Make it executable (chmod u+x /usr/local/bin/display.sh) and just run
display.sh off. For the latter to work you need to include
/usr/local/bin into your path.

DPMS interaction in a Linux console with setterm
------------------------------------------------

The setterm utility issues terminal recognized escape codes to alter the
terminal. Essentially it just writes/echos the terminal sequences to the
current terminal device, whether that be in screen, a remote ssh
terminal, console mode, serial consoles, etc.

setterm Syntax: (0 disables)

    setterm -blank [0-60|force|poke]
    setterm -powersave [on|vsync|hsync|powerdown|off]
    setterm -powerdown [0-60]

Note:If you haven't already read the brief DPMS article linked to below,
please skim it to understand how DPMS can be used in the console the
same as in X.

> Prevent screen from turning off

You can run this command:

    $ setterm -blank 0 -powerdown 0

Alternatively you can disable console blanking permanently using the
following command:

    # echo -ne "\033[9;0]" >> /etc/issue

> Pipe the output to a cat to see the escapes

    $ setterm -powerdown 2>&1 | exec cat -v 2>&1 | sed "s/\\^\\[/\\\\033/g"

> Pipe the escapes to any tty (with write/append perms) to modify that terminal

    $ setterm -powerdown 0 >> /dev/tty3

Note:>> is used instead of >. For permission issues using sudo in a
script or something, you can use the tee program to append the output of
setterm to the tty device, which tty's let appending sometimes but not
writing.

Bash loop to set ttys 0-256

    $ for i in {0..256}; do setterm -powerdown 0 >> /dev/tty$i; done; unset i;

Troubleshooting
---------------

> xset DPMS settings do not work with xscreensaver

xscreensaver uses its own DPMS settings. See the settings for
xscreensaver for more information.

xscreensaver DPMS

You can configure xscreensaver's DPMS settings manually by editing your
~/.xscreensaver file as below, or using the xscreensaver-demo GUI.

    timeout:	1:00:00
    cycle:		0:05:00
    lock:		False
    lockTimeout:	0:00:00
    passwdTimeout:	0:00:30
    fade:		True
    unfade:		False
    fadeSeconds:	0:00:03
    fadeTicks:	20
    dpmsEnabled:	True
    dpmsStandby:	2:00:00
    dpmsSuspend:	2:00:00
    dpmsOff:	4:00:00

See also
--------

-   PC Monitor DPMS specification explanation

Retrieved from
"https://wiki.archlinux.org/index.php?title=Display_Power_Management_Signaling&oldid=291242"

Categories:

-   X Server
-   Power management

-   This page was last modified on 1 January 2014, at 11:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
