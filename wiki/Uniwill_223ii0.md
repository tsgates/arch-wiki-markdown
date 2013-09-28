Uniwill 223ii0
==============

This computer discussed here is a 12.1" widescreen laptop. It used to be
sold in the US by Alienware and is still offered by the good, always
helpful folks at LinuxCertified, probably among others. Advantages of
this computer:

-   truly excellent screen
-   simple, compact design
-   small weight
-   excellent Linux compatibility (e.g. modem)

Inconvenients:

-   not-so-great battery life (~2h)

A review can be found here. Note: the problems reported by the reviewer
have been solved in the meantime, more details below.

  

Arch Linux on Uniwill 223ii0
============================

This laptop works very well under Arch. Almost everything works out of
the box.

-   modem - you need to use the slmodem driver from Smartlink:

    pacman -S slmodem

and add slmodem-alsa in the daemons section of /etc/rc.conf. In my
experience, slmodem-alsa is more reliable, but depending on the kernel
version you may have to use the slmodem instead.

You may experience a few oddities every now and then when using the
modem (slow connection, being disconnected unexpectedly), but it works
overall.

  

-   suspend to ram - Used to work without complicated workarounds with
    Arch stock kernel 2.16.9-1. A mere (as root)

    echo -n "mem" > /sys/power/state

suspended the machine. With kernel 2.6.20.4-1, suspend to disk still
works, but strange things happen when the computer wakes up (no mouse
cursor, etc.). Hibernate (suspend to disk) still doesn't work. You may
have more success with other Arch kernels.

  

-   touchpad - best when used with synaptics:

    pacman -S synaptics

Don't forget to modify your xorg.conf file accordingly, following the
post-install instructions.

A useful graphical tool to fine-tune the reactivity of the touchpad is
gsynaptics, which can be found in the 'community' repository.

     pacman -S gsynaptics

-   Xorg - good compatibility using the i810 driver, full resolution can
    be achieved, and decent results (500-600fps) with glxgears,
    considering we're using an integrated graphic card.

One further note
================

If you find the computer to be too noisy because of continuous fan
activity, a solution (probably among others) is to tweak the BIOS. By
disabling the "Maximum Efficiency" features you will have a quieter
computer.

External Links
==============

-   This report is listed at the TuxMobil: Linux Laptop and Notebook
    Installation Guides Survey: Uniwill.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Uniwill_223ii0&oldid=254237"

Category:

-   Laptops
