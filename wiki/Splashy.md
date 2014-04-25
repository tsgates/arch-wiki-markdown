Splashy
=======

Splashy is a userspace implementation of a splash screen for Linux
systems. It provides a graphical environment during system boot using
the Linux framebuffer layer via directfb.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 /etc/rc.conf
    -   2.2 Including Splashy in initramfs
    -   2.3 The kernel command line
    -   2.4 Themes

Installation
------------

Before you can use Splashy, you should enable Kernel Mode Setting.
Please refer to the specific instructions for ATI cards, Intel cards or
Nvidia cards.

Install splashy-full from the Arch User Repository.

You may also check out this topic on the Arch Linux forum for a
repository you can add with working splashy packages.

Configuration
-------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Update for       
                           systemd. (Discuss)       
  ------------------------ ------------------------ ------------------------

> /etc/rc.conf

Add this in /etc/rc.conf:

    /etc/rc.conf

    SPLASH="splashy"

> Including Splashy in initramfs

Add Splashy to the HOOKS array in /etc/mkinitcpio.conf. It must be added
after base, udev and autodetect for it to work:

    /etc/mkinitcpio.conf

    HOOKS="base udev autodetect splashy [...]"

For early KMS start add the module radeon (for radeon cards), i915 (for
intel cards) or nouveau (for nvidia cards) to the MODULES line in
/etc/mkinitcpio.conf:

    /etc/mkinitcpio.conf

    MODULES="i915"
    or
    MODULES="radeon"
    or
    MODULES="nouveau"

Rebuild your kernel image (refer to the mkinitcpio article for more
info):

    # mkinitcpio -p [name of your kernel preset]

> The kernel command line

You now need to set quiet splash as you kernel command line parameters
in your bootloader. See Kernel parameters for more info.

> Themes

You can install splashy-themes from the AUR. After installing, look at
the available themes like so:

    ls /usr/share/splashy/themes

The folder name is the theme name. Now change the theme to the one you
want, eg.:

    # splashy_config -s darch-white

Note:Themes ending in 43 are of 4:3 aspect ratio - the others are
widescreen.

Rebuild your kernel image with:

    # mkinitcpio -p [name of your kernel preset]

and reboot.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Splashy&oldid=269232"

Category:

-   Bootsplash

-   This page was last modified on 1 August 2013, at 13:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
