Acer Aspire S7-392
==================

This page contains instructions, tips, pointers, and links for
installing and configuring Arch Linux on the Acer Aspire S7-392 Laptop.

This page only applies to the 392 model (4th Gen Intel CPU), and may not
be entirely correct for the 391 or 191 models (3rd Gen Intel CPU).

Contents
--------

-   1 Compatibility
    -   1.1 What works?
    -   1.2 What doesn't work, or is weird?
-   2 BIOS Setup
-   3 Booting
    -   3.1 Change Boot from UEFI to BIOS
    -   3.2 Boot from USB
-   4 Graphics Drivers
-   5 Multitouch Gestures

Compatibility
-------------

The laptop works surprisingly well with Arch Linux, requiring minimal or
no configuration hacking, depending on your desired setup.

> What works?

-   Touchscreen
-   Touchpad Multitouch Gestures
-   Screen Brightness Adjustment
    -   Requres a window manager or desktop environment with the
        functionality, such as XFCE, Gnome, or Mate.
    -   Alternatively, a hotkey daemon such as acpid may provide hotkey
        functionality (Not tested).
-   Keyboard Backlight (And adjustment)
-   Most Keyboard Hotkeys
    -   Wireless Toggle may not work. acpid may work with it (Not
        tested)
-   Wireless Networking

> What doesn't work, or is weird?

-   Nothing as far as I can tell

BIOS Setup
----------

The BIOS Setup utility is accessed by pressing Fn+2 at the Acer Logo
screen during startup.

Booting
-------

The information in Boot loaders applies here. GRUB is confirmed to work.

> Change Boot from UEFI to BIOS

If desired, you can optionally select whether to use BIOS or UEFI when
booting. This is an option in the BIOS Setup utility.

> Boot from USB

Booting from USB is possible by reordering boot devices in the BIOS
setup, or by accessing the Boot Menu by pressing the "Fn" key and "="
key simultaneously (Translates to F12).

Graphics Drivers
----------------

Note:With the default setup, there will be graphics tearing on the
S7-392. You can check the "Tear-free video" section of the Intel
Graphics page for information on fixing tearing

The standard xf86-video-intel driver works with the laptop. For 32-bit
games or other cases where necessary, you'll want to install
lib32-intel-dri in addition to the xf86 driver.

Multitouch Gestures
-------------------

The touchpad works well with xf86-input-synaptics, and with touchegg for
advanced multitouch gestures.

Note:Contrary to what most of the internet says, you don't need to use
xf86-input-evdev to make Touchegg work.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_S7-392&oldid=306126"

Category:

-   Acer

-   This page was last modified on 20 March 2014, at 17:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
