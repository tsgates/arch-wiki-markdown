Uvesafb
=======

In contrast with other framebuffer drivers, uvesafb needs a userspace
virtualizing daemon, called v86d. It may seem foolish to emulate x86
code on a x86, but this is important if one wants to use the framebuffer
code on other architectures (notably non-x86 ones). A new framebuffer
driver has been added to kernel 2.6.24. It has many more features than
the standard vesafb, including:

1.  Proper blanking and hardware suspension after delay
2.  Support for custom resolutions as in the system BIOS.

It should support as much hardware as vesafb.

Contents
--------

-   1 Installation
-   2 Prepare the system
    -   2.1 Bootloader modifications
        -   2.1.1 GRUB2
        -   2.1.2 GRUB legacy
    -   2.2 Add a v86d HOOK
-   3 Configure uvesafb
    -   3.1 Define a resolution
    -   3.2 Regenerate initramfs images
    -   3.3 Reboot
-   4 Listing resolutions
-   5 Uvesafb compiled into the kernel
-   6 The homepage of uvesafb
-   7 Uvesafb and 915resolution
    -   7.1 915resolution-static
    -   7.2 The resolution
    -   7.3 The HOOKS array
-   8 Troubleshooting
    -   8.1 Uvesafb cannot reserve memory
    -   8.2 pci_root PNP0A08:00 address space collision + Uvesafb cannot
        reserve memory

Installation
------------

Install v86d from the official repositories.

Prepare the system
------------------

> Bootloader modifications

Remove any framebuffer-related kernel boot parameter from the bootloader
configuration to disable the old vesafb framebuffter for loading.

GRUB2

First edit /etc/default/grub commenting the GRUB_GFXPAYLOAD_LINUX=keep
line.

Then regenerate grub.cfg via the standard script:

    # grub-mkconfig -o /boot/grub/grub.cfg

In some cases you will have to disable KMS before attempting to boot
into framebuffer: failure to do so would result in a pitch-black screen,
leaving no option but to restart the machine with Ctrl+Alt+Del. For
Intel cards, this is accomplished by appending i915.modeset=0 to GRUB's
entry.

Warning:Disabling KMS may break X.

GRUB legacy

Remove all references to vga=xxx from kernel lines in
/boot/grub/menu.lst to allow correct operation of uvesafb.

> Add a v86d HOOK

Add the v86d hook to HOOKS in /etc/mkinitcpio.conf to allow uvesafb to
take over at boot time.

    HOOKS="base udev v86d ..."

Configure uvesafb
-----------------

> Define a resolution

The options for uvesafb are defined in /usr/lib/modprobe.d/uvesafb.conf:

    # This file sets the parameters for uvesafb module.
    # The following format should be used:
    # options uvesafb mode_option=<xres>x<yres>[-<bpp>][@<refresh>] scroll=<ywrap|ypan|redraw> ...
    #
    # For more details see:
    # http://www.kernel.org/doc/Documentation/fb/uvesafb.txt
    #
    options uvesafb mode_option=1280x800-32 scroll=ywrap

Documentation for mode_option can be found at
linux.git/tree/Documentation/fb/modedb.txt

To prevent your customizations being overwritten when the package is
updated, make any changes and copy this file to
/etc/modprobe.d/uvesafb.conf and then add an entry in the FILES section
of /etc/mkinitcpio.conf pointing to your configuration file, like so:

    FILES="/etc/modprobe.d/uvesafb.conf"

> Regenerate initramfs images

Changes are commited via booting into the initramfs images. Thus, users
need to regenerate the initramfs images for the kernel(s). The following
example assumes the default Arch Linux kernel:

    # mkinitcpio -p linux

> Reboot

Reboot the system to see the changes.

Listing resolutions
-------------------

A list of possible resolutions can be generated via the following
command:

    $ cat /sys/bus/platform/drivers/uvesafb/uvesafb.0/vbe_modes

Users can modify /usr/lib/modprobe.d/uvesafb.conf with any entry
returned.

Either of following commands can be used to show the current framebuffer
resolution as a sanity check to see that settings are honored:

    $ cat /sys/devices/virtual/graphics/fbcon/subsystem/fb0/virtual_size

    $ cat /sys/class/graphics/fb0/virtual_size

Uvesafb compiled into the kernel
--------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

If you compile your own kernel, then you can also compile uvesafb into
the kernel and run v86d later, e.g. from /etc/rc.local. In this case,
the options can be passed as kernel boot parameters in the format
video=uvesafb:<options>. Please note that this solution is not viable in
the case you want to combine uvesafb with 915resolution as suggested
below.

The homepage of uvesafb
-----------------------

The home page of uvesafb is
http://dev.gentoo.org/~spock/projects/uvesafb where you can find some
detailed information (you can ignore any information concerning patches
for the kernel, because uvesafb is now in the vanilla kernel; moreover
some information in the site assumes that uvesafb is compiled in the
kernel, while it is a module in the Arch Linux stock binary kernel).

Uvesafb and 915resolution
-------------------------

In the following, we address a more complex scenario. Many intel video
chipsets for widescreen laptops are known to have a buggy BIOS, which
does not support the main, native resolution of the wide screen! For
this reason, 915resolution was created to patch the BIOS at boot time
and allow the X server to use the widescreen resolution. Nowadays, the X
server is able to do this without the help of 915resolution. However,
915resolution can be combined with uvesafb in order to obtain a
widescreen framebuffer, without any need to launch X at all. In this
case, we need to load uvesafb after having run 915resolution, so that
uvesafb can resort to the proper resolution.

> 915resolution-static

In this scenario, 915resolution needs to be compiled statically (since
it is going to be in an initramfs, it can not be linked to external
libraries). Thus you CAN NOT use the 915resolution package in the
[community] repo. Look instead for 915resolution-static in the AUR. It
compiles 915 resolution statically and provides a 915 resolution hook,
so you can run 915resolution before loading uvesafb and get the patched
resolution. So install 915resolution-static via makepkg and pacman.

> The resolution

You need to edit the 915resolution hook in order to define the BIOS mode
you want to replace and and the resolution you want to get. You can get
information about all the options for 915resolution with:

    915resolution -h

So edit /lib/initcpio/hooks/915resolution and modify the options for
915resolution:

    run_hook ()
    {
       msg -n ":: Patching the VBIOS..."
       /usr/sbin/915resolution 5c 1280 800
       msg "done."
    }

In the default, 5c is the code of the BIOS mode to replace. You can get
a list of the available BIOS video modes with 915resolution -l.

Note:You want to choose the code of a mode that you DO NOT need (neither
in the framebuffer nor in X), because 915resolution will replace it with
a new user-defined mode. In the above example, 1280 800 is the new
desired resolution.

> The HOOKS array

Add the 915resolution hook and, after it, the v86d hook to HOOKS in
/etc/mkinitcpio.conf. Put them before the hooks for the keymap, the
resume from suspension and the filesystems.

    HOOKS="base udev 915resolution v86d ..."

Then you need to regenerate your initramfs with mkinitcpio (adjust the
following command to your setup):

    mkinitcpio -p linux

Troubleshooting
---------------

> Uvesafb cannot reserve memory

Check if you forgot to remove any vga=xxx kernel parameter -- this
overrides the UVESA framebuffer with a standard VESA one.

> pci_root PNP0A08:00 address space collision + Uvesafb cannot reserve memory

This occurs on the Acer Aspire One 751h with the 2.6.34-ARCH kernel;
whether it also occurs on other systems is unknown. Even without another
framebuffer interfering with the uvesafb setup, uvesafb cannot reserve
the necessary memory region.

You can fix this issue by adding the following to the kernel parameters
in your bootloader's configuration.

    pci=nocrs

Retrieved from
"https://wiki.archlinux.org/index.php?title=Uvesafb&oldid=293066"

Category:

-   Eye candy

-   This page was last modified on 16 January 2014, at 03:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
