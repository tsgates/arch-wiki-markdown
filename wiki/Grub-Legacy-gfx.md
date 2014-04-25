Grub-Legacy-gfx
===============

Note:GRUB Legacy has been deprecated and replaced by GRUB in Arch Linux.
See the news here. GRUB also offers enhanced graphical capabilities,
such as background images and bitmap fonts. Users are recommended to
switch to GRUB or Syslinux instead.

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Related articles

-   GRUB Legacy
-   GRUB

grub-gfx is a version of GRUB Legacy patched to enable background images
on your bootloader screen.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Splash images
-   4 Troubleshooting
    -   4.1 Black screen; no menu; blinking prompt
-   5 External links

Installation
------------

The grub-gfx package is in the AUR. Note that the package can be
compiled on x86_64 architecture only with gcc-multilib.

Backup your current GRUB Legacy configuration. (During the package
installation, this should happen automatically; this is a precautionary
step.)

    # cp /boot/grub/menu.lst /boot/grub/menu.lst.bak

The grub package will be replaced if it is installed.

After the installation check /boot/grub/menu.lst. Edit it accordingly to
match the boot entries in your backup. If you failed to create your own
backup, look for /boot/grub/menu.lst.pacsave. You could also just
overwrite your backup copy over the new menu.lst and proceed to the
configuration below.

Configuration
-------------

The only change in configuration is the addition of the splashimage
line. In the default /boot/grub/menu.lst you will see the following:

    # general configuration:
    timeout   5
    default   0
    color light-blue/black light-cyan/blue
    splashimage /boot/grub/splash.xpm.gz

Otherwise, you will simply be adding the last line to your existing
menu.lst. This line will point to the image you want to use as the
background during your boot selection screen.

Note:This line is relative to GRUB's root partition, meaning if you have
your own /boot partition, the above should read:

    splashimage /grub/splash.xpm.gz

Finally, it is necessary to (re)install GRUB to overwrite your current
GRUB installation or bootloader. Please read GRUB Legacy if you have no
experience doing this. On a fairly "standard" install this would mean
executing something like:

    # grub-install /dev/sda

But remember to adjust according to your system.

Splash images
-------------

Splash images have to be .xpm.gz file type, 640x480, and only 14 colors.

To install a new splash image, copy the image to the GRUB directory
(i.e. /boot/grub/) then update your menu.lst to point to the image. No
need to reinstall GRUB; just reboot and you should see the new image.

Troubleshooting
---------------

> Black screen; no menu; blinking prompt

You should still be able to select an OS and boot from this screen. Once
you are back into your system check your menu.lst file again. Ensure the
path to your splash screen is correct. Remember, splashimage line is
relative to GRUB's root partition. If you have GRUB on its own /boot
partition, the line will read splashimage /grub/splash.xpm.gz. Then
remember to make sure you actually have the splash screen you wish to
use in that directory.

External links
--------------

Collection of GRUB splashes

Retrieved from
"https://wiki.archlinux.org/index.php?title=Grub-Legacy-gfx&oldid=290086"

Categories:

-   Boot loaders
-   Eye candy

-   This page was last modified on 23 December 2013, at 09:23.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
