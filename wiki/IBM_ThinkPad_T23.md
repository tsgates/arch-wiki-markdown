IBM ThinkPad T23
================

Works with no known issues.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Configuration                                                      |
|     -   1.1 Power Management                                             |
|         -   1.1.1 Suspend and Hibernate                                  |
|         -   1.1.2 Sleepmode                                              |
|         -   1.1.3 Laptop Mode Tools                                      |
|         -   1.1.4 CPU frequency scaling                                  |
|                                                                          |
|     -   1.2 Hotkeys                                                      |
|         -   1.2.1 tpb                                                    |
|         -   1.2.2 NumLock                                                |
|                                                                          |
|     -   1.3 Xorg                                                         |
|                                                                          |
| -   2 See also                                                           |
+--------------------------------------------------------------------------+

Configuration
-------------

> Power Management

Suspend and Hibernate

Works flawlessly. See Suspend to Disk. Also known to work with Pm-utils.

Sleepmode

An easy way is to use "suspend to swap" by appending

    resume=/dev/sdx 

to the kernel line in /boot/grub/menu.lst

Sleepmode

Laptop Mode Tools

Works flawlessly. See Laptop Mode Tools.

CPU frequency scaling

Works as described in CPU Frequency Scaling.

> Hotkeys

They work better after loading the thinkpad_acpi module, to assign the
generated keycodes to their supposed functions.

tpb

Install tpb, available in the Arch User Repository.

tpb (for Thinkpad Buttons) adds an on-screen volume bar for the volume
buttons, THINKPAD button assignment, on-screen messages for Thinklight,
(on and off) and more.

NumLock

If not already working, this key may be configured by adding:

    keycode 77 = Num_Lock 

to ~/.xmodmap.

> Xorg

Works fine with driver xf86-video-savage. Eye-candy like compositing
will not work with this card.

Please note, if you have an SXGA+, the graphics card will not support a
higher depth than 16 bit.

See also
--------

-   Thinkwiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=IBM_ThinkPad_T23&oldid=238888"

Category:

-   IBM
