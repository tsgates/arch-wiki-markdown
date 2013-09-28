IBM ThinkPad R40
================

System configuration:

Graphics: You need the following packages: xorg-server xf86-input-mouse
xf86-input-keyboard xf86-video-ati After installed, it works well, even
3D hardware acceleration seems available, no xorg.conf needed.

    [root@arch gl]# glxinfo 
    name of display: :0.0
    display: :0  screen: 0
    direct rendering: Yes
    server glx vendor string: SGI
    server glx version string: 1.2

but to have the right side of the TouchPad for scrolling pages up and
down and avoid trouble with beryl, please refer to this xorg.conf,

    Section "Files"
        FontPath "/usr/share/fonts"
    EndSection

    Section "ServerFlags"
        AllowMouseOpenFail # allows the server to start up even if the mouse does not work
    EndSection

    Section "Module"
        Load "extmod"
        Load "type1"
        Load "freetype"
        Load "synaptics"
        Load "glx" # 3D layer
        Load "dri" # direct rendering
    EndSection

    Section "InputDevice"
        Identifier "Generic Keyboard"
        Driver "kbd"
        Option "XkbModel" "pc105"
        Option "XkbLayout" "us"
        Option "XkbOptions" "compose:rwin"
    EndSection

    Section "InputDevice"
        Identifier "Configured Mouse"
        Driver "mouse"
        Option "Protocol" "ExplorerPS/2"
        Option "Device" "/dev/input/mice"
        Option "ZAxisMapping" "4 5"
    EndSection

    Section "InputDevice"
        Identifier "Synaptics Touchpad"
        Driver "synaptics"
        Option "Protocol" "auto-dev"
        Option "Device" "/dev/psaux"
        Option "MinSpeed" "0.09"
        Option "MaxSpeed" "0.18"
        Option "BottomEdge" "4200"
        Option "SHMConfig" "on"
        Option "FingerLow" "25"
        Option "LeftEdge" "1700"
        Option "MaxTapMove" "220"
        Option "MaxTapTime" "180"
        Option "FingerHigh" "30"
        Option "VertScrollDelta" "100"
        Option "TopEdge" "1700"
        Option "AccelFactor" "0.0015"
        Option "RightEdge" "5300"
    EndSection

    Section "Monitor"
        Identifier "Generic Monitor"
        VendorName "Generic"
        ModelName "Flat Panel 1400x1050"
        HorizSync 31.5-90
        VertRefresh 59-75
    EndSection

    Section "Device"
        Identifier "ATI Technologies Inc Radeon Mobility M7 LW [Radeon Mobility 7500]"
        Driver "radeon"
        Option "DPMS"
        Option "AGPSize" "32" # default:8
    EndSection

    Section "Screen"
        Identifier "Default Screen"
        Device "ATI Technologies Inc Radeon Mobility M7 LW [Radeon Mobility 7500]"
        Monitor "Generic Monitor"
        DefaultColorDepth 24
        
        Subsection "Display"
            Depth 24
            Virtual 1400 1050
        EndSubsection
    EndSection

    Section "ServerLayout"
        Identifier "Default Layout"
        InputDevice "Generic Keyboard" "CoreKeyboard"
        InputDevice "Configured Mouse" "CorePointer"
        InputDevice "Synaptics Touchpad" "AlwaysCore"
        Screen "Default Screen"
    EndSection

Sound: Work out of box and the (three) loudspeaker buttons at the upper
left of the keyboard can be used to control the sound level.

Ethernet: Work out of box and recognize as eth1

Wireless (WiFi): Correctly detected and wrote "ipw2100" in your rc.conf,
but you need ipw2100 firmware to make it work. Try: pacman -S ipw2100-fw

Retrieved from
"https://wiki.archlinux.org/index.php?title=IBM_ThinkPad_R40&oldid=196658"

Category:

-   IBM
