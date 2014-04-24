Plymouth
========

Plymouth is a project from Fedora providing a flicker-free graphical
boot process. It relies on kernel mode setting (KMS) to set the native
resolution of the display as early as possible, then provides an
eye-candy splash screen leading all the way up to the login manager.

Contents
--------

-   1 Preparation
-   2 Installation
    -   2.1 The plymouth hook
    -   2.2 The kernel command line
-   3 Configuration
    -   3.1 Smooth transition
    -   3.2 Changing the Theme
-   4 See also

Preparation
-----------

Warning:Plymouth is currently under heavy development and may contain
bugs.

Plymouth primarily uses KMS (Kernel Mode Setting) to display graphics.
If you can't use KMS (e.g. because you are using a proprietary driver)
you will need to use framebuffer instead. Uvesafb is recommended as it
can function with widescreen resolutions.

If you have neither KMS nor a framebuffer, Plymouth will fall back to
text-mode.

Installation
------------

Plymouth is not presently available in the official repositories, and
will need to be installed from the AUR.

The stable package is plymouth and the development version is
plymouth-git. The package we refer to in this article is plymouth-git,
which actually is much tidier and contains several corrections and
additions.

> The plymouth hook

Add plymouth to the HOOKS array in /etc/mkinitcpio.conf. It must be
added after base and udev for it to work:

    /etc/mkinitcpio.conf

    HOOKS="base udev plymouth [...] "

Warning:If you use hard drive encryption with the encrypt hook, you must
replace the encrypt hook with plymouth-encrypt in order to get to the
TTY password prompts.

For early KMS start add the module radeon (for radeon cards), i915 (for
intel cards) or nouveau (for nvidia cards) to the MODULES line in
/etc/mkinitcpio.conf:

    /etc/mkinitcpio.conf

    MODULES="i915"
    or
    MODULES="radeon"
    or
    MODULES="nouveau"

> The kernel command line

You now need to set quiet splash as your kernel command line parameter
in your bootloader. See Kernel parameters for more info.

Rebuild your initrd image (see mkinitcpio article for details), for
example:

    # mkinitcpio -p linux

Configuration
-------------

> Smooth transition

For smooth transition to Display Manager you have to:

1.  See the Wiki Page (link in 5) to prepare your Display Manager
2.  Disable your Display Manager Unit, e.g.
    systemctl disable kdm.service
3.  Enable the respective DM-plymouth Unit (GDM, KDM, LXDM units
    provided), e.g. systemctl enable kdm-plymouth.service

> Changing the Theme

Plymouth comes with a selection of themes:

1.  Fade-in: "Simple theme that fades in and out with shimmering stars"
2.  Glow: "Corporate theme with pie chart boot progress followed by a
    glowing emerging logo"
3.  Script: "Script example plugin" (Despite the description seems to be
    a quite nice Arch logo theme)
4.  Solar: "Space theme with violent flaring blue star"
5.  Spinner: "Simple theme with a loading spinner"
6.  Spinfinity: "Simple theme that shows a rotating infinity sign in the
    center of the screen"
7.  (Text: "Text mode theme with tricolor progress bar")
8.  (Details: "Verbose fallback theme")

By default, spinfinity theme is selected. You can change the theme by
editing /etc/plymouth/plymouthd.conf, for example:

    /etc/plymouth/plymouthd.conf

    [Daemon]
    Theme=spinfinity

You will also need to rebuild your initrd image every time you change
your theme.

All currently installed themes can be listed by using this command:

    $ plymouth-set-default-theme -l

or:

    $ ls /usr/share/plymouth/themes

    details  glow    solar       spinner  tribar
    fade-in  script  spinfinity  text

Themes can be previewed without rebuilding, press Ctrl+Alt+F2 to change
to console, log in as root and type:

    # plymouthd
    # plymouth --show-splash

To quit the preview, press Ctrl+Alt+F2 again and type:

    # plymouth --quit

every time a theme is changed, the kernel image must be rebuilt with:

    # mkinitcpio -p <name of your kernel preset; e.g. linux>

To change theme and rebuild initrd image:

    # plymouth-set-default-theme -R <theme>

Reboot to apply the changes.

See also
--------

-   Original Spec
-   Related forum thread

Retrieved from
"https://wiki.archlinux.org/index.php?title=Plymouth&oldid=289088"

Category:

-   Bootsplash

-   This page was last modified on 18 December 2013, at 03:18.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
