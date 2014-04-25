Joy2key
=======

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: ConsoleKit is    
                           deprecated,              
                           ck-launch-session should 
                           not be used. See also    
                           General                  
                           Troubleshooting#Session  
                           permissions.             
                           Further, initscripts are 
                           mentioned                
                           (/etc/inittab), also     
                           deprecated. (Discuss)    
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

> Use a joystick/gamepad to control applications which accept keyboard commands

Note:This solution may not work with XBMC 11.0 and joy2key 1.6.3-1. An
alternative and more direct approach is described in the Joystick wiki
page.

  
 I use joy2key to work around issues with the Logitech Cordless
RumblePad 2 "hat" (a.k.a. d-pad) in XBMC.

XBMC 10.0 or probably a recent Arch update (SDL?) broke the joystick hat
functionality for me. On XBMC startup, xbmc.log shows 0 hats and 6 -
instead of 4 - axes:

    17:00:36 T:3020363648 M:1703337984  NOTICE: Enabled Joystick: Logitech Logitech Cordless RumblePad 2
    17:00:36 T:3020363648 M:1703337984  NOTICE: Details: Total Axis: 6 Total Hats: 0 Total Buttons: 12

  
 My solution was to install joy2key from the AUR. Here is my config
which could potentially save you hours of frustration or fun, depending
on how you look at it:

    #
    # ~/.joy2keyrc
    #

    COMMON
    -dev /dev/input/js0
    -thresh -16383 16383 -16383 16383 -16383 16383 -16383 16383 -16383 16383 -16383 16383
    #-autorepeat 5
    #-deadzone 50

    START xbmc
    -X
    # -axis <axis0min> <axis0max> <axis1min> <axis1max> ...
    #       0 = left analog stick X-axis
    #       1 = left analog stick Y-axis
    #       2 = right analog stick X-axis
    #       3 = right analog stick Y-axis
    #       4 = hat (d-pad) X-axis
    #       5 = hat (d-pad) Y-axis
    #
    # actions: Left/Right/Up/Down (arrow keys) - first letter capital!
    #          plus/minus (ASCII characters) - lower case!
    #          blank = special
    # more info in /usr/include/X11/keysymdef.h
    #
    # .....0..........1.......2..........3..........4..........5......
    #-axis Left Right Up Down minus plus plus minus Left Right Up Down
    -axis blank blank blank blank blank blank blank blank Left Right Up Down

    # EoF

  
 joy2key needs to start after XBMC to be able to see its window. Here's
my XBMC standalone system config:

    #
    # ~/.xinitrc
    #

    # Enable Ctrl+Alt+Bksp.
    setxkbmap -option terminate:ctrl_alt_bksp &

    # Start joy2key after XBMC has been detected running. (Function takes arguments, some optional.)
    start_joy2key()
    {
      for n in $(seq $4 || seq 5)
      do
        xwininfo -display :0 -name "$1" >/dev/null 2>&1 && joy2key "$1" -config "$2"
        sleep $3 || sleep 3
      done
    }
    # syntax: start_joy2key <window name> <config file> [wait # of sec between tries] [repeat # of times]
    start_joy2key "XBMC Media Center" xbmc 3 5 &

    # Start XBMC.
    ck-launch-session xbmc-standalone

    # EoF

  
 And here is my joy2key config section for controlling Boxee-source:

    START boxee
    -X
    -axis blank blank Page_Up Page_Down blank blank plus minus Left Right Up Down
    # .......1.2......3......4.5....6.....7...........8............9.0.1.2
    -buttons v Return Escape c Left Right bracketleft bracketright i z s h

  
 Add this to ~/.xinitrc below the XBMC section to alternate between
launching XBMC and Boxee:

    start_joy2key Boxee boxee 3 3 &
    ck-launch-session /opt/boxee/run-boxee-desktop

  
 This gets respawned over and over from /etc/inittab:

    x:5:respawn:/bin/su xbmc -l -c "/bin/bash --login -c /usr/bin/startx >/dev/null 2>&1"

  
 References to the sources where I learned about this:

-   [1] blog entry: Joystick Hat in X-Plane in Linux
-   [2] Ubuntu forum post: How to use joy2key for SIXAXIS joypad (or any
    really!)
-   [3] XBMC wiki: Installing XBMC for Linux > Autostarting XBMC

Retrieved from
"https://wiki.archlinux.org/index.php?title=Joy2key&oldid=270293"

Category:

-   Input devices

-   This page was last modified on 8 August 2013, at 09:59.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
