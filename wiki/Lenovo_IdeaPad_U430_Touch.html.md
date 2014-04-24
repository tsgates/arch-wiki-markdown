Lenovo IdeaPad U430 Touch
=========================

The Lenovo IdeaPad U430 Touch offers great compatibility with Arch
Linux.

Contents
--------

-   1 Installation
-   2 Graphics
-   3 Networking
-   4 Track-pad
-   5 Touchscreen
-   6 Hot-keys
-   7 Power management

Installation
------------

To install Arch turn your device completely off (shutdown Windows). Now
press the little switch on the left side of the device near the ethernet
port. You are now able to enter the BIOS and disable "Secure Boot".
After that, save your settings and shutdown the machine once more. After
pressing the small button again, you may enter the boot menu and choose
your USB installation medium.

You are probably greeted now by complete darkness, press F12 a few times
to brighten up your screen.

Graphics
--------

There are at least two graphics options for the U430, Intel Haswell-ULT
Integrated Graphics Controller (rev 09) and the Nvidia card described
below.

Graphics work well out of the box after installing xf86-video-intel.
Bumblebee works very well too, if you want to use the integrated Nvidia
card. Be sure to also install bbswitch and primus, without primus I
wasn't able to launch games from Steam.

If you don't want to utilize Optimus, it may be of benefit to disable it
in the BIOS, there is thankfully an option for this.

Networking
----------

Works perfectly. At least with my unit I also don't experience
connection dropping on Wifi, which seems to be a problem for some.

Track-pad
---------

Works, but the out-of-box experience is not great. Copy and edit
/etc/X11/xorg.conf.d/50-synaptics.conf until it fits your needs. Here's
mine:

    # /etc/X11/xorg.conf.d/55-synaptics-u430t.conf

    # prevent the settings app from overwriting our settings:
    # gsettings set org.gnome.settings-daemon.plugins.mouse active false
     
     
    Section "InputClass"
        Identifier "nathan touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "synaptics"
     
        Option "TapButton1" "1"
        Option "TapButton2" "3"
        Option "TapButton3" "2"

        # accurate tap-to-click!
        Option "FingerLow" "50"
        Option "FingerHigh" "55"
     
        # prevents too many intentional clicks
        Option "PalmDetect" "0"
     
        # vertical and horizontal scrolling, use negative delta values for "natural" scrolling
        Option "VertTwoFingerScroll" "1"
        Option "VertScrollDelta" "75"
        Option "HorizTwoFingerScroll" "1"
        Option "HorizScrollDelta" "75"
     
        Option "MinSpeed" "1"
        Option "MaxSpeed" "1"
     
        Option "AccelerationProfile" "2"
        Option "ConstantDeceleration" "4"

        # Disable Soft buttons
        Option "SoftButtonAreas" "0 0 0 0 0 0 0 0"
    EndSection

Touchscreen
-----------

Works perfectly. Be aware that many applications are not designed with
touchscreens in mind and may not work that great. Gnome 3 works very
well, though.

Hot-keys
--------

Work perfectly. There is a setting in the BIOS to switch the fn-button,
so that the function-keys (F1-F12) work as intended.

Power management
----------------

There is a noticeable drop in battery run-time compared to Windows 8,
but there are tools to improve from about 3h to almost 6h.

First, if you're using it, make sure Bumblebee and most important
bbswitch are properly set up. If not, it may happen that your Nvidia
card runs at all times! If that's the case your device will get a lot
hotter and louder than in normal operation.

Check if your card is on or off with cat /proc/acpi/bbswitch

For general power management and if you don't want to tweak every
setting yourself, install and enable tlp, it worked wonders on my
device.

DO NOT install laptop-mode, cpupower, or any other power-management
tools in addition to tlp. cpupower may even break p-state (powersaving)
of your Haswell CPU, modern CPUs know how to handle themselves.

There are also a lot of tools and services especially for Thinkpads –
none of these worked on my Ideapad.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_IdeaPad_U430_Touch&oldid=303784"

Category:

-   Lenovo

-   This page was last modified on 9 March 2014, at 14:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
