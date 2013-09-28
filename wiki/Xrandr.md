Xrandr
======

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Dynamically testing different resolutions                          |
| -   2 Adding undetected resolutions                                      |
| -   3 Making xrandr changes persistent                                   |
|     -   3.1 Setting resolution changes in xorg.conf (Preferred)          |
|     -   3.2 Setting xrandr commands in xprofile                          |
|     -   3.3 Setting xrandr commands in kdm/gdm startup scripts           |
|                                                                          |
| -   4 Graphical frontends                                                |
|     -   4.1 ARandR                                                       |
|     -   4.2 LXrandR                                                      |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 Resolution lower than expected                               |
|         -   5.1.1 Try this first                                         |
|         -   5.1.2 Use cvt/xrandr tool to add the highest mode the LCD    |
|             can do                                                       |
|                                                                          |
| -   6 Obtaining modelines from Windows program PowerStrip                |
| -   7 Scripts                                                            |
| -   8 Using xrandr with VNC                                              |
| -   9 See also                                                           |
+--------------------------------------------------------------------------+

Dynamically testing different resolutions
-----------------------------------------

xrandr shows you the names of different outputs available on your system
(LVDS, VGA-0, etc.) and resolutions available on each:

    Screen 0: minimum 320 x 200, current 1400 x 1050, maximum 1400 x 1400
    VGA disconnected (normal left inverted right x axis y axis)
    LVDS connected 1400x1050+0+0 (normal left inverted right x axis y axis) 286mm x 214mm
       1400x1050      60.0*+   50.0  
    [...]

You can direct xrandr to set a different resolution like this:

     xrandr --output LVDS --mode 1024x768

The refresh rate may also be changed, either at the same time or
independently:

     xrandr --output LVDS --mode 1024x768 --rate 75

Note:Changes you make using xrandr only last through the current
session. xrandr has a lot more capabilities - see man xrandr for
details.

Adding undetected resolutions
-----------------------------

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

Then we create a new xrandr mode. Note that the Modeline keyword needs
to be ommited.

       xrandr --newmode "1280x1024_60.00"  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync

After creating it we need an extra step to add this new mode to our
current output (VGA1). We use just the name of the mode, since the
parameters have been set previously.

       xrandr --addmode VGA1 1280x1024_60.00

Now we change the resolution of the screen to the one we just added:

       xrandr --output VGA1 --mode 1280x1024_60.00

Note that these settings only take effect during this session.

If you are not sure about the resolution you will test, you may add a
"sleep 5" and a safe resolution command line following, like this :

       xrandr --output VGA1 --mode 1280x1024_60.00 && sleep 5 && xrandr --newmode "1024x768-safe" 65.00 1024 1048 1184 1344 768 771 777 806 -HSync -VSync && xrandr --addmode VGA1 1024x768-safe && xrandr --output VGA1 --mode 1024x768-safe

Also, change the output to the real one : VGA1 or DVI-I-1, ...

Making xrandr changes persistent
--------------------------------

There are several ways to make xrandr customizations permanent from
session to session:

-   xorg.conf ( Preferred)
-   .xprofile
-   kdm/gdm

> Setting resolution changes in xorg.conf (Preferred)

While xorg.conf is largely empty these days, it can still be used for
setting up resolutions. For example:

    /etc/X11/xorg.conf

    Section "Monitor"
        Identifier      "External DVI"
        Modeline        "1280x1024_60.00"  108.88  1280 1360 1496 1712  1024 1025 1028 1060  -HSync +Vsync
        Option          "PreferredMode" "1280x1024_60.00"
    EndSection
    Section "Device"
        Identifier      "ATI Technologies, Inc. M22 [Radeon Mobility M300]"
        Driver          "ati"
        Option          "Monitor-DVI-0" "External DVI"
    EndSection
    Section "Screen"
        Identifier      "Primary Screen"
        Device          "ATI Technologies, Inc. M22 [Radeon Mobility M300]"
        DefaultDepth    24
        SubSection "Display"
            Depth           24
            Modes   "1280x1024" "1024x768" "640x480"
        EndSubSection
    EndSection

    Section "ServerLayout"
            Identifier      "Default Layout"
            Screen          "Primary Screen"
    EndSection

See man xorg.conf for full details on how to craft an xorg.conf file.

> Setting xrandr commands in xprofile

See Execute commands after X start.

This method has the disadvantage of occurring fairly late in the startup
process thus it will not alter the resolution of the Display Manager if
you use one.

> Setting xrandr commands in kdm/gdm startup scripts

Both KDM and GDM have startup scripts that are executed when X is
initiated. For GDM, these are in /etc/gdm/ , while for KDM this is done
at /usr/share/config/kdm/Xsetup.

This process requires root access and mucking around in system config
files, but will take effect earlier in the startup process than using
xprofile.

Graphical frontends
-------------------

There are some graphical frontends available for xrandr:

> ARandR

ARandR provides a simple and convenient visual front end.

The package can be found in the community repository: arandr

> LXrandR

The default monitor configuration tool for the LXDE desktop environment.

This package is part of the community repository: lxrandr

Troubleshooting
---------------

> Resolution lower than expected

Try this first

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

Use cvt/xrandr tool to add the highest mode the LCD can do

The actual order was different, as I tried to add new mode to one LCD at
a time. Below is the combined/all-in-one quote

    $ cvt 1920 1200 60
    # 1920x1200 59.88 Hz (CVT 2.30MA) hsync: 74.56 kHz; pclk: 193.25 MHz
    Modeline "1920x1200_60.00"  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync
    $ cvt 1680 1050 60
    # 1680x1050 59.95 Hz (CVT 1.76MA) hsync: 65.29 kHz; pclk: 146.25 MHz
    Modeline "1680x1050_60.00"  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync
    $ xrandr --newmode "1920x1200_60.00"  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync
    $ xrandr --newmode "1680x1050_60.00"  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync
    $ xrandr --addmode DVI-1 "1920x1200_60.00"
    $ xrandr --addmode DVI-0 "1680x1050_60.00"

Obtaining modelines from Windows program PowerStrip
---------------------------------------------------

Obtaining modelines from Windows program PowerStrip.

Scripts
-------

Toggle only secondary monitor, leave the default display on:

    ~/bin/xdisplay

    #!/bin/bash
    #
    # This script toggles the extended monitor outputs if something is connected
    #

    # all available outputs
    OUTPUTS=$(xrandr |awk '$2 ~ /connected/ {print $1}')

    # your notebook LVDS monitor
    DEFAULT_OUTPUT=$(sed -ne 's/.*(LVDS[^ ]*).*/1/p' <<<$OUTPUTS)

    # get info from xrandr
    XRANDR=`xrandr`

    EXECUTE=""

    for CURRENT in $OUTPUTS
    do
            if [[ $XRANDR == *$CURRENT\ connected*  ]] # is connected
            then
                    if [[ $XRANDR == *$CURRENT\ connected\ \(* ]] # is disabled
                    then
                            EXECUTE+="--output $CURRENT --auto --above $DEFAULT_OUTPUT "
                    else
                            EXECUTE+="--output $CURRENT --off "
                    fi
            else # make sure disconnected outputs are off 
                    EXECUTE+="--output $CURRENT --off "
            fi
    done

    xrandr --output $DEFAULT_OUTPUT --auto $EXECUTE

Switches display, turning the others off:

    /usr/local/bin/toggle-display

    #!/bin/bash
    #
    # toggle-display.sh
    #
    # Iterates through connected monitors in xrander and switched to the next one
    # each time it is run.
    #

    # get info from xrandr
    xStatus=`xrandr`
    connectedOutputs=$(echo "$xStatus" | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
    activeOutput=$(echo "$xStatus" | grep -e " connected [^(]" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/") 
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

You can also use xrr-events (from AUR), a daemon which listens to XrandR
events and executes a script if a monitor has been plugged or unplugged.
For more information and examples see man page.

Using xrandr with VNC
---------------------

If you are using a VNC server that supports xrandr you can change the
vnc resolution on the fly by using "xrandr -s <width>x<height>".
tigervnc is an example of a client that supports xrandr

Example:

    xrandr -s 1920x1200

After you VNC in, if you open a console and type "xrandr" you will get a
list of currently configured modes. Each of these modes can be activated
with the xrandr -s option; however, if the mode you want does not exist
in the list, you can add it by doing the following:

Example: Say I want to add 1024x600 (a common netbook resolution)

First run CVT to get the correct modeline for the resolution you want to
add

    $ cvt 1024 600

You will get something like the following output

    # 1024x600 59.85 Hz (CVT) hsync: 37.35 kHz; pclk: 49.00 MHz
    Modeline "1024x600_60.00"   49.00  1024 1072 1168 1312  600 603 613 624 -hsync +vsync

Use that modeline output to run the commands below

    xrandr --newmode "1024x600"   49.00  1024 1072 1168 1312  600 603 613 624 -hsync +vsync
    xrandr --addmode default "1024x600"

Doing the above will give you the ability to change to 1024x600 by
typing xrandr -s 1024x600, but it will only last for the current x
session. To insure that you can use the newly added resolution each time
you start vncserver, add the following to ~/.vnc/xstartup

    xrandr --newmode "1024x600"   49.00  1024 1072 1168 1312  600 603 613 624 -hsync +vsync
    xrandr --addmode default "1024x600"r

See also
--------

-   DualScreen Arch wiki page. How to get dual screens with Xrandr
-   https://wiki.ubuntu.com/X/Config/Resolution
-   https://bbs.archlinux.org/viewtopic.php?pid=652861
-   http://nouveau.freedesktop.org/wiki/Randr12Howto
-   http://wiki.debian.org/XStrikeForce/HowToRandR12
-   man xrandr

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xrandr&oldid=256070"

Category:

-   X Server
