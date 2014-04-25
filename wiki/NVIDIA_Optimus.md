NVIDIA Optimus
==============

Related articles

-   Bumblebee
-   Nouveau
-   NVIDIA

NVIDIA Optimus is a technology that allows an Intel integrated GPU and
discrete NVIDIA GPU to be built into and accessed by a laptop. Getting
Optimus graphics to work on Arch Linux requires a few somewhat
complicated steps, explained below. There are several method available:

-   disabling one of the devices in BIOS, which may result in improved
    battery life if the NVIDIA device is disabled, but may not be
    available with all BIOSes and does not allow GPU switching

-   using the official Optimus support included with the proprietary
    NVIDIA driver, which offers the best NVIDIA performance but does not
    allow GPU switching and can be more buggy than the open-source
    driver

-   using the PRIME functionality of the open-source nouveau driver,
    which allows GPU switching but offers poor performance compared to
    the proprietary NVIDIA driver and does not currently implement any
    powersaving

-   using the third-party Bumblebee program to implement Optimus-like
    functionality, which offers GPU switching and powersaving but
    requires extra configuration

These options are explained in detail below.

Contents
--------

-   1 Disabling switchable graphics
-   2 Using nvidia
    -   2.1 Display Managers
        -   2.1.1 LightDM
    -   2.2 Checking 3D
    -   2.3 Further Information
-   3 Using nouveau
-   4 Using Bumblebee

Disabling switchable graphics
-----------------------------

If you only care to use a certain GPU without switching, check the
options in your system's BIOS. There should be an option to disable one
of the cards. Some laptops only allow disabling of the discrete card, or
vice-versa, but it is worth checking if you only plan to use one of the
cards. If you want to use both cards, or cannot disable the card you do
not want, see the options below.

Using nvidia
------------

The proprietary NVIDIA driver does not support dynamic switching like
the nouveau driver (meaning it can only use the NVIDIA device). It also
has notable screen-tearing issues that NVIDIA recognizes but has not
fixed. However, it does allow use of the discrete GPU and has (as of
October 2013) a marked edge in performance over the nouveau driver.

First install the modesetting and nvidia drivers:

    # pacman -S xf86-video-modesetting nvidia

Then install xrandr:

    # pacman -S xorg-xrandr

Next, you must create a custom xorg.conf. You will need to know the PCI
address of the NVIDIA card, which you can find by issuing

    $ lspci | grep VGA

The PCI address is the first 7 characters of the line that mentions
NVIDIA. It will look something like 01:00.0. In the xorg.conf, you will
need to format it as #:#:#; e.g. 01:00.0 would be formatted as 1:0:0.
Also, if the NVIDIA card has no display devices attached to it (all
video goes through the Intel chip), uncomment the line that reads
Option "UseDisplayDevice" "none".

    # nano /etc/X11/xorg.conf

    Section "ServerLayout"
        Identifier "layout"
        Screen 0 "nvidia"
        Inactive "intel"
    EndSection

    Section "Device"
        Identifier "nvidia"
        Driver "nvidia"
        BusID "PCI:PCI address determined earlier"
        # e.g. BusID "PCI:1:0:0"
    EndSection

    Section "Screen"
        Identifier "nvidia"
        Device "nvidia"
        #Option "UseDisplayDevice" "none"
    EndSection

    Section "Device"
        Identifier "intel"
        Driver "modesetting"
    EndSection

    Section "Screen"
        Identifier "intel"
        Device "intel"
    EndSection

Next, add the following two lines to the beginning of your ~/.xinitrc:

    $ nano ~/.xinitrc

    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto

Now reboot to load the drivers, and X should start.

If you get a black screen when starting X, make sure that there are no
ampersands after the two xrandr commands in ~/.xinitrc; if there are
ampersands, it seems that the window manager can run before the xrandr
commands finish executing, leading to the black screen.

> Display Managers

If you are using a display manager then you will need to create or edit
a display setup script for your display manager instead of using
~/.xinitrc.

LightDM

For the LightDM display manager:

    # nano /etc/lightdm/display_setup.sh

    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto

Make the script executable:

    # chmod +x /etc/lightdm/display_setup.sh

Now configure lightdm to run the script by editing the [SeatDefaults]
section in /etc/lightdm/lightdm.conf:

    # nano /etc/lightdm/lightdm.conf

    [SeatDefaults]
    display-setup-script=/etc/lightdm/display_setup.sh

Now reboot and your display manager should start.

> Checking 3D

You can check if the NVIDIA graphics are being used by installing
mesa-demos and running

    $ glxinfo | grep NVIDIA

> Further Information

For more information, look at NVIDIA's official page on the topic here.

Using nouveau
-------------

The open-source nouveau driver (xf86-video-nouveau)can dynamically
switch with the Intel driver (xf86-video-intel) using a technology
called PRIME. For more information, see the wiki article on PRIME.

Using Bumblebee
---------------

If you wish to use Bumblebee, which will implement powersaving and some
other useful features, see the wiki article on Bumblebee.

Retrieved from
"https://wiki.archlinux.org/index.php?title=NVIDIA_Optimus&oldid=305126"

Category:

-   Graphics

-   This page was last modified on 16 March 2014, at 15:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
