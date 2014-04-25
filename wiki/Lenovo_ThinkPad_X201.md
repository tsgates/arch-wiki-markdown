Lenovo ThinkPad X201
====================

The X201 is a 4-core subnotebook produced by Lenovo. See Thinkwiki for
more information.

Arch installs and runs flawlessly. Some specials features need tweaks,
though.

Contents
--------

-   1 Graphics
-   2 Hibernation
-   3 Fbsplash
-   4 Power Saving
    -   4.1 Fan control
    -   4.2 TLP
    -   4.3 Frequency Scaling
    -   4.4 Undervolting
    -   4.5 Bootloader kernel options
        -   4.5.1 grub2
        -   4.5.2 grub1

Graphics
--------

Xorg should automatically load the intel driver without any
configuration. Have a look at Intel if something is wrong.

As of the first quarter of 2013 there seems to be an issue related to
Mesa 9.0, described at the freekdesktop Bugtracker (#59593), that makes
the integrated Intel Ironlake Mobile GPU crash and will only resolve
after a reboot.

Hibernation
-----------

Install pm-utils and uswsusp and configure it as pm-util's backend. See
Pm-utils#Using_another_sleep_back-end_.28like_uswsusp.29 for
instructions.

Fbsplash
--------

To make fbsplash work, i915 has to be added to the modules array in
mkinitcpio.conf:

    /etc/mkinitcpio.conf

    MODULES="i915"

Power Saving
------------

> Fan control

There are some discussions concerning overheating-related shutdowns when
running under full load (video encoding, etc) ([1] [2]).

Thinkpad Fan Control contains instructions to install tpfand as a custom
replacement for hardware (bios-) fan control.

Warning:Wrong settings may damage your machine! Use with caution!

Start tpfan-admin and adjust the settings (by clicking on the sensor's
graph). You should split the graph (via context menu) and set the fan to
full-speed when the sensor reaches, say, 65 °C. You may also edit the
config file directly.

> TLP

You may install TLP instead of Laptop Mode Tools to automate power
saving operations.

> Frequency Scaling

Use cpufrequtils to enable frequency scaling.

> Undervolting

Undervolting is not possible with the intel core iX cpu.

> Bootloader kernel options

Add these kernel options to your bootloader's config file to make use of
power saving mechanismens which are turned off by default because of
reported instabilities. For me, they do a great job on my X201.

Warning:These options can cause instability on your system! Try them and
remove them if you are experiencing problems.

grub2

    /etc/default/grub

    GRUB_CMDLINE_LINUX_DEFAULT="[...] i915_enable_rc6=1 i915_enable_fbc=1"

Update grub.cfg afterwards: grub-mkconfig -o /boot/grub/grub.cfg

grub1

Add the options above to /boot/grub/menu.lst.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_X201&oldid=251987"

Category:

-   Lenovo

-   This page was last modified on 26 March 2013, at 15:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
