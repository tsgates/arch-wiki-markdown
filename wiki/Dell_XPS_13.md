Dell XPS 13
===========

This page is a work in progress.

Contents
--------

-   1 Installation
    -   1.1 Booting the install media
    -   1.2 Partitioning
    -   1.3 BIOS and USB keys
-   2 Post-installation
    -   2.1 Screen brightness
    -   2.2 Trackpad

Installation
============

Installation largely runs smoothly. See below for potential problems.

Booting the install media
-------------------------

Booting from the install media runs with almost no issues. If the screen
corrupts, append nomodeset to the kernel parameters. I had some issues
with the cord of my external optical drive functioning weirdly, but I
suspect it's specific to my device.

Partitioning
------------

By default, this computer comes with an MBR with all four partitions
already used. Additionally, I have read that if you delete any of the
partitions, the boot process will break. (I can confirm this, although
for obvious reasons, I only tested it once.) Therefore, a dual-boot with
Windows is impossible on this machine, although just Arch would probably
be fine. One solution could be booting from a permanent USB
installation. However, that has its caveats too. See the next section.

BIOS and USB keys
-----------------

Unfortunately, if you install to a USB key and select GPT instead of an
MBR, the BIOS will fail to boot with "operation system not found", even
of you use the hack where you set the boot flag in the protective MBR.

So far I have tried upgrading the BIOS, which did nothing. I still have
more experiments to run before I conclude that this configuration is
impossible.

Post-installation
=================

Screen brightness
-----------------

On a stock install, the screen brightness does not work. When you use
the function keys, the change is recognized by the system (if you have
an indicator or something for brightness it will change), but this will
have zero effect on the actual screen brightness.

You can add udev rule to solved this problem,see:
Udev#Writing_udev_rules.

     /etc/udev/rules.d/40-brightness.rules

    ACTION=="add", KERNEL=="intel_backlight", SUBSYSTEM=="backlight", ATTR{brightness}="0"

Trackpad
--------

Apparently there's issues with the trackpad, but I haven't tested it
yet. The situation around this is is the exact same as the screen
brightness: it's also present in Ubuntu, where it's fixed by the
hardware enablement kernel; try linux-mainline-dellxps.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_XPS_13&oldid=272251"

Category:

-   Dell

-   This page was last modified on 23 August 2013, at 15:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
