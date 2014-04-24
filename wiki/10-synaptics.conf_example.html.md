Touchpad Synaptics/10-synaptics.conf example
============================================

Additional descriptions would be welcome by anyone that has the time to
do so.

    Section "InputClass"
      Identifier "touchpad catchall"
      Driver "synaptics"
      MatchIsTouchpad "on"
        # Enable touchpad
        Option "TouchpadOff"        "0"
        # Allow run-time configuration
        # Option "SHMConfig"           "on"  # deprecated
        # Edge Limits
        Option "LeftEdge" "1748"
        Option "RightEdge" "5640"
        Option "TopEdge" "1274"
        Option "BottomEdge" "4752"
        # Speed
        Option "MinSpeed" "0.4"
        Option "MaxSpeed" "0.7"
        Option "AccelFactor" "0.00995223"
        # Pressure
        Option "FingerLow" "24"
        Option "FingerHigh" "29"
        Option "FingerPress" "255"
        # Tapping Detection
        Option "MaxTapTime" "0"             # 0 disables tap
        Option "MaxTapMove" "29"
        Option "MaxDoubleTapTime" "180"
        Option "SingleTapTimeout" "180"
        Option "ClickTime" "100"
        Option "FastTaps" "0"
        # Tapping as Buttons (number of fingers)
        Option "TapButton1" "1"
        Option "TapButton2" "2"
        Option "TapButton3" "3"
        # Tap Dragging
        Option "LockedDrags" "0"
        Option "LockedDragTimeout" "5000"
        # Tap Gesture Dragging
        Option "TapAndDragGesture" "0"
        # Corner Tap Buttons
        Option "RTCornerButton" "0"
        Option "RBCornerButton" "0"
        Option "LTCornerButton" "0"
        Option "LBCornerButton" "0"
        # Scrolling Edges
        Option "VertEdgeScroll" "1"
        Option "VertScrollDelta" "100"
        Option "HorizEdgeScroll" "0"
        Option "HorizScrollDelta" "100"
        # Circular Scrolling
        Option "CircularScrolling" "0"
        Option "CircScrollDelta" "0.1"
        Option "CircScrollTrigger" "0"
        # Two Finger Scrolling
        Option "VertTwoFingerScroll" "0"
        Option "HorizTwoFingerScroll" "0"
        # Corner Coasting
        Option "CornerCoasting" "0"
        Option "CoastingSpeed" "20"
        Option "CoastingFriction" "50"
        # Kernel Event Protocol
        Option "GrabEventDevice" "1"
        # Edge Ignore Boundaries
        Option "AreaLeftEdge" "0"
        Option "AreaRightEdge" "0"
        Option "AreaTopEdge" "0"
        Option "AreaBottomEdge" "0"
        # Trackstick
        Option "TrackstickSpeed" "40"
        # Circular Trackpad
        Option "CircularPad" "0"
        # Multi-function Buttons
        Option "ClickFinger1" "1"
        Option "ClickFinger2" "1"
        Option "ClickFinger3" "1"
        # Edge Movements
        Option "EdgeMotionMinZ" "29"
        Option "EdgeMotionMaxZ" "159"
        Option "EdgeMotionMinSpeed" "1"
        Option "EdgeMotionMaxSpeed" "401"
        Option "EdgeMotionUseAlways" "0"
        # Pressure Motion
        Option "PressureMotionMinZ" "29"
        Option "PressureMotionMaxZ" "159"
        Option "PressureMotionMinFactor" "1"
        Option "PressureMotionMaxFactor" "1"
        # Emulations
        Option "EmulateMidButtonTime" "75"
        Option "EmulateTwoFingerMinZ" "280"
        Option "EmulateTwoFingerMinW" "7"
        # Palm Detection
        Option "PalmDetect" "0"
        Option "PalmMinWidth" "10"
        Option "PalmMinZ" "199"
    EndSection

You can print all available options on your own (and their current
values with this line:

    synclient  -l | awk '/=/{printf "Option \"%s\" \"%s\"\n",$1,$3}'

Retrieved from
"https://wiki.archlinux.org/index.php?title=Touchpad_Synaptics/10-synaptics.conf_example&oldid=195614"

Category:

-   Input devices

-   This page was last modified on 21 April 2012, at 17:37.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
