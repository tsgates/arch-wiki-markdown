Lenovo Ideapad G580
===================

The 15.6" Lenovo G580 laptop PC combines top notch essentials – such as
cutting-edge 3rd generation Intel® Core™ i Series processors – with a
price you can afford. This ideal entry-level PC also boasts solid
multimedia features like stereo speakers, HD visuals and the latest
Intel® HD Graphics.

Installation
------------

A basic Arch Linux installation will do just fine for about everything
except network cards. No custom kernel needed. However, for network cars
you need to install following packages:

-   broadcom-wl and wireless_tools for wireless
-   (This backport driver is not need anymore in newer kernel 3.10)
    backports-patched for Atheros Network driver (Choose Alx) (find more
    information at linuxfoundation.org)

Graphic
-------

G580 is one of those laptop with hybrid technology, Using Nvidia 610m
and Intel® HD Graphics 4000, manually Intel HD graphic works like a
charm! if you want to use Nvidia graphic card you have to install nvidia
and nvidia-utils drivers. for switching between graphic cards you need
bumblebee and bbswitch follow nvidia article for more information.

Powertop
--------

To see additional sources of power drain, install powertop from official
repositories. And run it while on battery power.

See Powertop for more information.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_Ideapad_G580&oldid=268495"

Category:

-   Lenovo

-   This page was last modified on 28 July 2013, at 04:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
