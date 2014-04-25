xrandr
======

Summary help replacing me

Describes an official configuration utility to the RandR extension.

> Related

Xorg

Multihead

xrandr is an official configuration utility to the RandR X Window System
extension. It can be used to set the size, orientation or reflection of
the outputs for a screen. See Multihead for general informations.

Contents
--------

-   1 Installation
    -   1.1 Graphical frontends
-   2 Testing configuration
-   3 Configuration
    -   3.1 Scripts
        -   3.1.1 Example 1
        -   3.1.2 Example 2
        -   3.1.3 Example 3
        -   3.1.4 Example 3a
-   4 Using xrandr with VNC
-   5 Troubleshooting
    -   5.1 Adding undetected resolutions
    -   5.2 Resolution lower than expected
-   6 See also

Installation
------------

Install the xorg-xrandr package from the official repositories.

> Graphical frontends

There are some graphical frontends available for xrandr:

-   ARandR — Simple and convenient visual front end.

http://christian.amsuess.com/tools/arandr/ || arandr

-   LXrandR — The default monitor configuration tool for the LXDE
    desktop environment.

http://lxde.org/ || lxrandr

Testing configuration
---------------------

When run without any option, xrandr shows the names of different outputs
available on the system (LVDS, VGA-0, etc.) and resolutions available on
each:

    xrandr

    Screen 0: minimum 320 x 200, current 1440 x 900, maximum 8192 x 8192
    VGA disconnected (normal left inverted right x axis y axis)
    LVDS connected (normal left inverted right x axis y axis)
       1440x900       59.9*+
       1280x854       59.9  
       1280x800       59.8  
    ...

You can use xrandr to set different resolution (must be present in the
above list) on some output:

    $ xrandr --output LVDS --mode 1280x800

When multiple refresh rates are present in the list (not in the example
above), it may be changed by the --rate option, either at the same time
or independently. For example:

    $ xrandr --output LVDS --mode 1280x800 --rate 75

The --auto option will turn the specified output on if it is off and set
the preferred (maximum) resolution:

    $ xrandr --output LVDS --auto

It is possible to specify multiple outputs in one command, e.g. to turn
off LVDS and turn on HDMI-0 with preferred resolution:

    $ xrandr --output LVDS --off --output HDMI-0 --auto

> Note:

-   Changes you make using xrandr will only last through the current
    session.
-   xrandr has a lot more capabilities - see man xrandr for details.

Configuration
-------------

xrandr is just a simple interface to the RandR extension and has no
configuration file. However, there are multiple ways of achieving
persistent configuration:

1.  The RandR extension can be configured via X configuration files, see
    Multihead#RandR for details. This method provides only static
    configuration.
2.  If you need dynamic configuration, you need to execute xrandr
    commands each time X server starts. See Autostarting#Graphical for
    details. This method has the disadvantage of occurring fairly late
    in the startup process, thus it will not alter the resolution of the
    display manager if you use one.
3.  Custom scripts calling xrandr can be bound to events (for example
    when external monitor is plugged in), see acpid for details. The
    #Scripts section provides you with some example scripts that might
    be useful for this purpose.

Tip:Both KDM and GDM have startup scripts that are executed when X is
initiated. For GDM, these are in /etc/gdm/, while for KDM this is done
at /usr/share/config/kdm/Xsetup. This method requires root access and
mucking around in system config files, but will take effect earlier in
the startup process than using xprofile.

> Scripts

Example 1

This script toggles between external monitor (specified by $EXT) and
default monitor (specified by $IN), so that only one monitor is active
at a time.

The default monitor (specified by $IN) should be connected when running
the script, which is always true for a laptop.

    #!/bin/bash

    IN="LVDS1"
    EXT="VGA1"

    if (xrandr | grep "$EXT disconnected"); then
        xrandr --output $EXT --off --output $IN --auto
    else
        xrandr --output $IN --off --output $EXT --auto
    fi

Example 2

This script toggles only external monitor (specified by $EXT), leaves
the default monitor (specified by $IN) on.

The default monitor (specified by $IN) should be connected when running
the script, which is always true for a laptop.

    #!/bin/bash

    IN="LVDS1"
    EXT="VGA1"

    if (xrandr | grep "$EXT disconnected"); then
        xrandr --output $IN --auto --output $EXT --off 
    else
        xrandr --output $IN --auto --primary --output $EXT --auto --right-of $IN
    fi

Example 3

This script iterates through connected monitors, selects currently
active (primary) monitor, turns next one on and the others off:

    # get info from xrandr
    connectedOutputs=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
    activeOutput=$(xrandr | grep -e " connected [^(]" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/") 
    connected=$(echo $connectedOutputs | wc -w)

    # initialize variables
    execute="xrandr "
    default="xrandr "
    i=1
    switch=0

    for display in $connectedOutputs
    do
    	# build default configuration
    	if [ $i -eq 1 ]
    	then
    		default=$default"--output $display --auto "
    	else
    		default=$default"--output $display --off "
    	fi

    	# build "switching" configuration
    	if [ $switch -eq 1 ]
    	then
    		execute=$execute"--output $display --auto "
    		switch=0
    	else
    		execute=$execute"--output $display --off "
    	fi

    	# check whether the next output should be switched on
    	if [ $display = $activeOutput ]
    	then
    		switch=1
    	fi

    	i=$(( $i + 1 ))
    done

    # check if the default setup needs to be executed then run it
    echo "Resulting Configuration:"
    if [ -z "$(echo $execute | grep "auto")" ]
    then
    	echo "Command: $default"
    	`$default`
    else
    	echo "Command: $execute"
    	`$execute`
    fi
    echo -e "\n$(xrandr)"

  

  

Example 3a

This script iterates over all xrandr outputs. If anything is connected
it tries to figure out the best possible resolution places that right-of
the previous display. I am using it with "srandrd" in my "i3wm" like so

1.  ~/.xprofile

* * * * *

8< ----

srandrd /path/to/detect_displays.sh

* * * * *

>8 ----

(Example 3 didn't work for me for some reason or other)

    #!/bin/bash
    #
    # Copyright (C) 2014 Sascha Teske <sascha.teske@gmail.com>
    #
    # This program is free software; you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation; either version 2 of the License, or
    # (at your option) any later version.
    #
    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.
    #              

    XRANDR="xrandr"
    CMD="${XRANDR}"
    declare -A VOUTS
    eval VOUTS=$(${XRANDR}|awk 'BEGIN {printf("(")} /^\S.*connected/{printf("[%s]=%s ", $1, $2)} END{printf(")")}')
    declare -A POS
    #XPOS=0
    #YPOS=0
    #POS="${XPOS}x${YPOS}"

    POS=([X]=0 [Y]=0)

    find_mode() {
      echo $(${XRANDR} |grep ${1} -A1|awk '{FS="[ x]"} /^\s/{printf("WIDTH=%s\nHEIGHT=%s", $4,$5)}')
    }

    xrandr_params_for() {
      if [ "${2}" == 'connected' ]
      then
        eval $(find_mode ${1})  #sets ${WIDTH} and ${HEIGHT}
        MODE="${WIDTH}x${HEIGHT}"
        CMD="${CMD} --output ${1} --mode ${MODE} --pos ${POS[X]}x${POS[Y]}"
        POS[X]=$((${POS[X]}+${WIDTH}))
        return 0
      else
        CMD="${CMD} --output ${1} --off"
        return 1
      fi
    }


    for VOUT in ${!VOUTS[*]}
    do
      xrandr_params_for ${VOUT} ${VOUTS[${VOUT}]}
    done
    set -x
    ${CMD}
    set +x

  

Using xrandr with VNC
---------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: the -s option is 
                           for version 1.1          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: duplicates       
                           #Adding undetected       
                           resolutions (Discuss)    
  ------------------------ ------------------------ ------------------------

If you are using a VNC server that supports xrandr, you can change the
vnc resolution on the fly, for example by running xrandr -s 1920x1200.
tigervnc is an example of a client that supports xrandr.

If you run xrandr from a VNC session, you will get a list of currently
configured modes. Each of these modes can be activated with the
xrandr -s <width>x<height> command; however, if the mode you want does
not exist in the list, you must first add it. As an example, we will add
resolution 1024x600:

First run cvt to get the correct modeline for the resolution you want to
add:

    $ cvt 1024 600

    # 1024x600 59.85 Hz (CVT) hsync: 37.35 kHz; pclk: 49.00 MHz
    Modeline "1024x600_60.00"   49.00  1024 1072 1168 1312  600 603 613 624 -hsync +vsync

Use that modeline output to run the commands below:

    $ xrandr --newmode "1024x600"   49.00  1024 1072 1168 1312  600 603 613 624 -hsync +vsync
    $ xrandr --addmode default "1024x600"

Doing the above will give you the ability to change to 1024x600 by
running xrandr -s 1024x600, but it will only last for the current x
session. To ensure that you can use the newly added resolution each time
you start vncserver, add the above commands to ~/.vnc/xstartup.

Troubleshooting
---------------

> Adding undetected resolutions

Due to buggy hardware or drivers, your monitor's correct resolutions may
not always be detected by xrandr. For example, the EDID data block
queried from the monitor may be incorrect. However, we can add the
desired resolutions to xrandr.

First we run gtf or cvt to get the Modeline for the resolution we want:

For some LCD screens (samsung 2343NW), the command "cvt -r" (= with
reduced blanking) is to be used.

    $ cvt 1280 1024

    # 1280x1024 59.89 Hz (CVT 1.31M4) hsync: 63.67 kHz; pclk: 109.00 MHz
    Modeline "1280x1024_60.00"  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync

Note:If the Intel video driver xf86-video-intel is used, it may report
the desired resolution along with its properties in /var/log/Xorg.0.log
— use that first if it is different from the output of gtf or cvt. For
instance, the log and its use with xrandr:

    [    45.063] (II) intel(0): clock: 241.5 MHz   Image Size:  597 x 336 mm
    [    45.063] (II) intel(0): h_active: 2560  h_sync: 2600  h_sync_end 2632 h_blank_end 2720 h_border: 0
    [    45.063] (II) intel(0): v_active: 1440  v_sync: 1443  v_sync_end 1448 v_blanking: 1481 v_border: 0

    xrandr --newmode "2560x1440" 241.50 2560 2600 2632 2720 1440 1443 1448 1481 -hsync +vsync

Then we create a new xrandr mode. Note that the Modeline keyword needs
to be ommited.

    $ xrandr --newmode "1280x1024_60.00"  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync

After creating it we need an extra step to add this new mode to our
current output (VGA1). We use just the name of the mode, since the
parameters have been set previously.

    $ xrandr --addmode VGA1 1280x1024_60.00

Now we change the resolution of the screen to the one we just added:

    $ xrandr --output VGA1 --mode 1280x1024_60.00

Note that these settings only take effect during this session.

If you are not sure about the resolution you will test, you may add a
sleep 5 and a safe resolution command line following, like this :

    $ xrandr --output VGA1 --mode 1280x1024_60.00 && sleep 5 && xrandr --newmode "1024x768-safe" 65.00 1024 1048 1184 1344 768 771 777 806 -HSync -VSync && xrandr --addmode VGA1 1024x768-safe && xrandr --output VGA1 --mode 1024x768-safe

Also, change VGA1 to corret output name.

> Resolution lower than expected

Tip:Try #Adding undetected resolutions first, if it doesn't work, you
may try this method.

If you video card is recognized but the resolution is lower than you
expect, you may try this.

Background: ATI X1550 based video card and two LCD monitors DELL 2408(up
to 1920x1200) and Samsung 206BW(up to 1680x1050). Upon first login after
installation, the resolution default to 1152x864. xrandr does not list
any resolution higher than 1152x864. You may want to try editing
/etc/X11/xorg.conf, add a section about virtual screen, logout, login
and see if this helps. If not then read on.

Change xorg.conf

    /etc/X11/xorg.conf

    Section "Screen"
            ...
            SubSection "Display"
                    Virtual 3600 1200
            EndSubSection
    EndSection

About the numbers: DELL on the left and Samsung on the right. So the
virtual width is of sum of both LCD width 3600=1920+1680; Height then is
figured as the max of them, which is max(1200,1050)=1200. If you put one
LCD above the other, use this calculation instead: (max(width1, width2),
height1+height2).

See also
--------

-   https://wiki.ubuntu.com/X/Config/Resolution
-   RandR 1.2 tutorial
-   Xorg RandR 1.2 on ThinkWiki
-   FAQVideoModes - more information about modelines

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xrandr&oldid=306213"

Category:

-   X Server

-   This page was last modified on 21 March 2014, at 09:14.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
