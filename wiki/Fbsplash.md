Fbsplash
========

Fbsplash (formerly gensplash) is a userspace implementation of a splash
screen for Linux systems. It provides a graphical environment during
system boot using the Linux framebuffer layer.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Fbsplash                                                     |
|     -   1.2 Scripts                                                      |
|     -   1.3 Themes                                                       |
|     -   1.4 Suspend to Disk                                              |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Kernel Command Line                                          |
|     -   2.2 Configuration Files                                          |
|                                                                          |
| -   3 Starting Fbsplash early in the initcpio                            |
| -   4 Console backgrounds                                                |
| -   5 Links                                                              |
+--------------------------------------------------------------------------+

Installation
------------

> Fbsplash

The fbsplash package is available in the AUR. For console backgrounds
(discussed later in this article) you should install a kernel patched
with fbcondecor such as linux-fbcondecor.

> Scripts

The fbsplash package provides the scripts for basic functionality. If
you want more bells and whistles, like smooth progress, filesystem-check
progress messages, support for boot-services/'daemons'-icons and theme
hook scripts, you may also install the fbsplash-extras package.

> Themes

Themes can be found by searching the AUR for fbsplash-theme, in
GNOME-Look.org or in KDE-Look.org.

Note:The package fbsplash does not contain a default theme.

> Suspend to Disk

If you want suspend to disk with Uswsusp using Fbsplash, install the
uswsusp-fbsplash package from the AUR. For more info have a look at
Pm-utils#Using_another_sleep_backend_.28like_uswsusp.29 or
Suspend_to_Disk#Uswsusp_method (hibernate-script). Additionally there is
limited support for using Fbsplash in the tuxonice-userui package for
those using a kernel with the TuxOnIce patch.

Configuration
-------------

> Kernel Command Line

You now need to set something like
quiet loglevel=3 logo.nologo vga=790 console=tty1 splash=silent,fadein,fadeout,theme:arch-banner-icons
as you kernel command line parameters in your bootloader. See Kernel
parameters for more info.

The parameter loglevel=3 prevents kernel messages from garbling the
splash even with funny hardware (as recent initscripts do not set this
by default any more). quiet is needed additionally for silencing
initcpio messages. logo.nologo removes the boot logo (not needed with
linux-fbcondecor since it does not have one anyway). console=tty1
redirects system messages to tty1 and
splash=silent,fadein,fadeout,theme:arch-banner-icons creates a silent,
splash-only boot with fading in/out arch-banner-icons theme.

> Configuration Files

Put one or more of the themes you installed into /etc/conf.d/splash. You
can also specify screen resolutions to save some initcpio space:

    /etc/conf.d/splash

    SPLASH_THEMES="
        arch-black
        arch-banner-icons/1280x1024.cfg
        arch-banner-noicons/1280x1024.cfg"

Note:The theme arch-banner-icons contains mainly symlinks to
arch-banner-noicons. So if one of them is included in total, not much
space will be saved by limiting the resolutions.

If you start Xorg using a DAEMON (kdm, gdm, etc.), also set the
appropriate rc.d-script name to avoid VT/keyboard struggle between Xorg
and the splash daemon:

    SPLASH_XSERVICE="gdm"

Note:Fbsplash will be stopped without changing to the tty1 console
before the named script is started. If not set (or not enabled in
DAEMONS), Fbsplash is stopped at the very end of Rc.multi. In the latter
case it will change to the tty1 console if not booting into runlevel 5.

Starting Fbsplash early in the initcpio
---------------------------------------

If uresume and/or encrypt HOOKS are used, add fbsplash after them in
/etc/mkinitcpio.conf, e.g.:

    /etc/mkinitcpio.conf

    HOOKS="base udev autodetect [...] keymap encrypt uresume fbsplash"

Rebuild your initcpio via mkinitcpio. See the Mkinitcpio article for
more info.

Tip:For a quick resume, it is recommended to put uswsusp before fbsplash
or even drop fadein, if using a Fbcondecor kernel.

If you have trouble getting fbsplash to work and your machine uses KMS
(Kernel Mode Setting), try adding the appropriate driver to
mkinitcpio.conf.

Console backgrounds
-------------------

If you have a kernel that supports Fbcondecor (eg. linux-fbcondecor),
you can get nice graphical console backgrounds beside the splash screen.
Just search the AUR for fbsplash-theme.

After installing your patched kernel and fbsplash, add fbcondecor to
your DAEMONS array in /etc/rc.conf:

    /etc/rc.conf

    DAEMONS=(... fbcondecor ...)

There is also a configuration file /etc/conf.d/fbcondecor to set up the
virtual terminals to be used.

You may even boot up with a nice console background and the plain Arch
Linux boot messages instead of a splash screen. Just change your kernel
command line to use the verbose mode:

    quiet console=tty1 splash=verbose,theme:arch-banner-icons

Links
-----

-   http://fbsplash.alanhaggai.org
-   http://dev.gentoo.org/~spock/projects/fbcondecor/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fbsplash&oldid=243160"

Category:

-   Bootsplash
