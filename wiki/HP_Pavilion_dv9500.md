HP Pavilion dv9500
==================

Input devices
-------------

> Keyboard

To use multimedia keys you need to set keyboard model in
/etc/X11/xorg.conf

       Option "XkbModel" "hpdv9500"

Add this section into /usr/share/X11/xkb/symbols/inet

       // Hewlett-Packard Pavilion dv9500
       partial alphanumeric_keys
       xkb_symbols "hpdv9500" {
        key <I10> { [ XF86AudioPrev		] };
        key <I19> { [ XF86AudioNext		] };
        key <I20> { [ XF86AudioMute		] };
        key <I22> { [ XF86AudioPlay, XF86AudioPause ] };
        key <I24> { [ XF86AudioStop		] };
        key <I2E> { [ XF86AudioLowerVolume		] };
        key <I30> { [ XF86AudioRaiseVolume		] };
        key <I32> { [ XF86WWW			] };
        key <PAUS> { [ Pause			] };
       };

And finally add

       hpdv9500

to section "! $inetkbds = ..." in /usr/share/X11/xkb/rules/xorg. Now you
can restart X server and set keyboard shortcuts in your music player

> Touchpad

1)

       pacman -S synaptics

2) Open /etc/X11/xorg.conf

3) Add this section

       Section "InputDevice"
        Identifier      "Touchpad"
        Driver  "synaptics"
        Option  "Protocol" "auto"
        Option  "Device" "/dev/psaux"
        Option  "LeftEdge" "2000"
        Option  "RightEdge" "5300"
        Option  "TopEdge" "2000"
        Option  "BottomEdge" "4300"
        Option  "FingerLow" "25"
        Option  "FingerHigh" "30"
        Option  "MaxTapTime" "180"
        Option  "MaxTapMove" "220"
        #Option "VertScrollDelta" "100"
        Option  "HorizScrollDelta" "100"
        Option  "MinSpeed" "0.09"
        Option  "MaxSpeed" "0.3"
        Option  "AccelFactor" "0.002"
        Option  "SHMConfig" "on"
        Option  "HorizTwoFingerScroll" "false"
        Option  "VertTwoFingerScroll" "false"
        Option  "VertEdgeScroll" "false"
        Option  "CircularScrolling" "true"
        Option  "CircScrollTrigger" "3"
        Option  "RTCornerButton" "0"
        Option  "RBCornerButton" "2"
        Option  "LTCornerButton" "0"
       EndSection

4) You can modify it

5) Edit section "server layout"

       Section "ServerLayout"
        Identifier      "X.Org Configured"
        Screen  0       "Screen0" 0 0
        InputDevice     "Keyboard0" "CoreKeyboard"
        InputDevice     "USB Mouse" "SendCoreEvents"
        InputDevice     "Touchpad" "CorePointer"
       EndSection

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_dv9500&oldid=196645"

Category:

-   HP

-   This page was last modified on 23 April 2012, at 12:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
