Nokia booklet 3g
================

The Nokia Booklet 3G is a small, light and nice Netbook with some
interesting features:

-   Aluminium frame.
-   12h theoretical battery life (actually 8 to 10h of real use in Linux
    with low screen brightness, which is still nice).
-   1280x720 screen resolution, much better than the normal on other
    netbooks (1024x600).
-   3G modem, working well with Linux, so you can get connected
    everywhere.
-   GPS
-   HDMI output.
-   No fans, no noise, moderate hot.
-   Bluetooth and wifi integrated.

Most of the hardware of the Booklet if fairly compatible with Arch Linux
out of the box. The worst part is always the Intel GMA500 graphics card,
with good support for 2D acceleration (general experience is smooth and
good), but a total lack of 3D and video acceleration, and some problems
with HDMI output and suspend.

Probably the second bad thing is the hard disk speed, but there are some
tricks we can do with Arch to improve it.

The volume of the speakers are just incredible low (even at maximum
volume). It is recommended to use headphones, both wired and Bluetooth
works.

  

Contents
--------

-   1 Install
-   2 Graphics Card
-   3 Hard Disk
-   4 3G Modem
-   5 Software
-   6 Links

Install
-------

The installation is fairly standard using a pendrive.

  

Graphics Card
-------------

See Poulsbo for configuration and options (including brightness
control).

HDMI out only works with modesetting driver (which is the newer one).

Hard Disk
---------

The hard disk is stoping the spin very soon, causing a very bad usage
experience, specially with firefox (which access the HD very ofen).
There is a solution for this using hdparm:

# pacman -S hdparm

Now edit /etc/rc.local and add:

hdparm -a 512 -B 255 -S 241 /dev/sda

Run the command yourself to see the effect inmediatly. Se hdparm man
page to see possible values, specially for -S option.

Note: This may cause a slight decrese in battery life.

3G Modem
--------

The modem is working correctly with full speed (7.2mps) and good
reception, and the recommended way to manage it is using NetworkManager,
because you probably will need to connect or reconnect several times
along the day. Also, nm-applet indicates the signal strength in its
icon.

But sometimes it may stop working correctly, needing a full reboot. This
is due to corruption in the BIOS.

To avoid this, edit /etc/default/grub and add
memory_corruption_check_size=256K to GRUB_CMDLINE_LINUX variable. (Don't
forget to update grub with grub-mkconfig -o /boot/grub/grub.cfg).

Software
--------

Software recommended for this machine is the same recommended for most
netbooks:

-   xfce4 as a general desktop system is good.
-   wmii or awesome are very nice for managing windows. You can combine
    them both with xfce4 or run alone.
-   gnome or kde can run, but not smoothly with 3D effects, so it is
    better to avoid composition.
-   NetworkManager is the best to manage the modem and the wifi.
    Specially, nm-applet can show 3G signal strength in real time.
-   firestarter is a very good firewall because it can start and stop
    when you use the modem, and can share connection by wifi.
-   Chromium is preferred over firefox because it feels much faster on
    Atom procesors.

In general, try to keep simple and avoid bogus applications. Remember
that you're running a 1Gb-RAM system with no 3D acceleration with an
Atom processor.

Links
-----

-   Linux on the Nokia booklet 3g
-   Nokia official support

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nokia_booklet_3g&oldid=298315"

Category:

-   Nokia

-   This page was last modified on 16 February 2014, at 07:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
