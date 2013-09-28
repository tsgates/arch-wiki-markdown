Aiptek Tablet
=============

This has been tested with an Aiptek HyperPen 12000U. I have no idea if
it works with a different tablet.

Installation
------------

You need to install xf86-input-aiptek from the Official Repositories.

Create /etc/udev/rules.d/20-aiptek.rules with the following content:

    ACTION!="add|change", GOTO="xorg_aiptek_end"
    KERNEL!="event[0-9]*", GOTO="xorg_aiptek_end"

    ATTRS{idVendor}=="08ca", ATTRS{idProduct}=="0010", ENV{x11_driver}="aiptek", SYMLINK+="input/aiptektablet"

    LABEL="xorg_aiptek_end"

Create /etc/X11/xorg.conf.d/20-aiptek.conf with the following content

    Section "InputClass"
           Identifier "pen"
           Driver "aiptek"
           Option "Device" "/dev/input/aiptektablet"
           Option "SendCoreEvents" "true"
           Option "USB" "on"
           Option "Type" "stylus"
           Option "Mode" "absolute"
           Option "zMin" "0"
           Option "zMax" "511"
    EndSection
    Section "InputClass"
           Identifier "pen"
           Driver "aiptek"
           Option "Device" "/dev/input/aiptektablet"
           Option "SendCoreEvents" "true"
           Option "USB" "on"
           Option "Type" "erasor"
           Option "Mode" "absolute"
           Option "zMin" "0"
           Option "zMax" "511"
    EndSection
    Section "InputClass"
           Identifier "pen"
           Driver "aiptek"
           Option "Device" "/dev/input/aiptektablet"
           Option "SendCoreEvents" "true"
           Option "USB" "on"
           Option "Type" "cursor"
           Option "Mode" "absolute"
           Option "zMin" "0"
           Option "zMax" "511"
    EndSection

Then restart udev and X or your display manager (gdm, kdm, slim, ...)

Gimp
----

Should work right away. If not, those settings worked for me:

Edit -> Input Devices -> Aiptek

-   Mode: Screen
-   X: 1
-   Y: 2
-   Pressure: 3
-   X-Tilt, Y-Tilt and Wheel shouldn't matter

Retrieved from
"https://wiki.archlinux.org/index.php?title=Aiptek_Tablet&oldid=233691"

Category:

-   Input devices
