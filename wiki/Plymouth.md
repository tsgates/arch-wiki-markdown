Plymouth
========

Plymouth is a project from Fedora providing a flicker-free graphical
boot process. It relies on kernel mode setting (KMS) to set the native
resolution of the display as early as possible, then provides an
eye-candy splash screen leading all the way up to the login manager.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preparation                                                        |
| -   2 Installation                                                       |
| -   3 Configuration                                                      |
|     -   3.1 Including Plymouth in the Initcpio                           |
|     -   3.2 The kernel command line                                      |
|     -   3.3 Changing the Theme                                           |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

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

Plymouth is not presently available in the Official Repositories, and
will need to be installed from the AUR.

The stable one is called plymouth and the git version plymouth-git.

Configuration
-------------

> Including Plymouth in the Initcpio

Add Plymouth to the HOOKS array in /etc/mkinitcpio.conf. It must be
added after base, udev and autodetect for it to work:

    /etc/mkinitcpio.conf

    HOOKS="base udev autodetect [...] plymouth"

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

Rebuild your initrd image (refer to the mkinitcpio article for more
info):

    # mkinitcpio -p [name of your kernel preset]

> The kernel command line

You now need to set quiet splash as you kernel command line parameters
in your bootloader. See Kernel parameters for more info.

> Changing the Theme

Plymouth comes with a selection of themes:

1.  Fade-in: "Simple theme that fades in and out with shimmering stars"
2.  Glow: "Corporate theme with pie chart boot progress followed by a
    glowing emerging logo"
3.  Script: "Script example plugin" (Despite the description seems to be
    a quite nice Arch logo theme)
4.  Solar: "Space theme with violent flaring blue star" and
5.  Spinfinity: "Simple theme that shows a rotating infinity sign in the
    center of the screen" (default)
6.  (Text: "Text mode theme with tricolor progress bar")
7.  (Details: "Verbose fallback theme")

To show the current theme:

    $ plymouth-set-default-theme

    spinfinity

To list all currently installed themes:

    $ plymouth-set-default-theme -l

To preview the themes without rebooting, hit Ctrl+Alt+F2 to change to
console, log in as root and type:

    # plymouthd# plymouth --show-splash

To quit the preview hit Ctrl+Alt+F2 again and type:

    # plymouth --quit

To set your desired theme and rebuild your kernel image:

    # plymouth-set-default-theme -R <theme name>

And reboot.

See also
--------

Original Spec

A related forum thread

Retrieved from
"https://wiki.archlinux.org/index.php?title=Plymouth&oldid=242525"

Category:

-   Bootsplash
