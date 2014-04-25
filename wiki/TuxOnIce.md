TuxOnIce
========

Related articles

-   Suspending to RAM with hibernate-script
-   Suspending to Disk with hibernate-script
-   Pm-utils
-   Uswsusp

This is a quick start guide for installing TuxOnIce (formerly suspend2),
an advanced suspend/hibernate framework which supports suspending to a
swap-disk or a regular file with fast LZO-compression. Visit the
TuxOnIce website for a full list of features.

Contents
--------

-   1 Preparing the kernel
-   2 Recreating the initramfs
-   3 Setting up the bootloader
    -   3.1 Suspend to swap partition
    -   3.2 Suspend to swap file
    -   3.3 Suspend to file
-   4 Suspending and resuming
-   5 Additional pm-utils setup
-   6 userui - user interface for TuxOnIce (optional)
-   7 References

Preparing the kernel
--------------------

TuxOnIce consists of a kernel patch, plus an optional user interface.
Only the kernel patch is necessary, the user interface merely provides a
graphical interface displayed during the hibernation/resume cycle.

You can use the linux-ice or the linux-pf packages available in the Arch
User Repository. They automate all the patch routines, the compilation
and installation of the kernel, and the regeneration of the initramfs
with an appropriate hook. You maintain control over the install process,
and its easy to make changes if you want to repeat the process. More
detailed information at installing linux-pf and configuring it with
TuxOnIce can be found at its wiki page.

Otherwise, you need to patch, configure and compile your own kernel,
visit Kernel Compilation From Source and Kernel Compilation with ABS for
instructions. The required patch can be obtained from the TuxOnIce
website mentioned above.

Next, install the hibernate-script package from the AUR which we will
use to call TuxOnIce. Hibernate-script is the default script developed
by the TuxOnIce development team.

The configuration files for hibernate-script are in /etc/hibernate, we
will get back to them shortly.

Recreating the initramfs
------------------------

If you use an initramfs (default Arch systems do), you must add the
resume hook in the HOOKS in the configuration of mkinitcpio.
Additionally, if you want to speed things up by using LZO compression,
add the lzo module to the MODULES array in the same file.

/etc/mkinitcpio.conf example:

    MODULES="lzo"
    HOOKS="base udev autodetect block resume filesystems"

(for linux-pf you also need tuxonice_compress, tuxonice_swap and
optionally tuxonice_userui in MODULES)

Rebuild the initramfs:

    # mkinitcpio -p linux-ice

or

    # mkinitcpio -p linux-pf

Setting up the bootloader
-------------------------

Before your can use the suspend function, you need to add the resume
parameter in your bootloader (unless you have hard-coded your swap
partition during the kernel configuration). The resume parameter points
to the swap partition or swap file, below are the steps involved for
both methods.

> Suspend to swap partition

Note:As of the latest version of TuxOnIce (3.0.99.44), adding the kernel
resume parameter is no longer necessary, it will auto-detect if your
swap drive contains a bootable image. You only need to set the swap
method appropriately. For more details, check out [1].

Set the swap method (make sure the right partition is indicated) in
/etc/hibernate/tuxonice.conf:

    SuspendDevice swap:/dev/sda3

> Suspend to swap file

Note:Auto-detection as mentioned previously does not seem to work with
swap files, you will still need to manually set the kernel resume
parameter.

Note:The BTRFS filesystem does not currently support swapfiles.

If you use a swap file instead of a swap partition, you will need to
pass the location of its header to TuxOnIce. TuxOnIce can list all
available swap headers.

    cat /sys/power/tuxonice/swap/headerlocations

Use the given string as-is in both /etc/hibernate/tuxonice.conf and
passed to your kernel as a resume parameter.

    SuspendDevice swap:/dev/sda7:0x1087070

Append the following to your kernel parameters in your bootloader's
configuration file:

    resume=swap:/dev/sda7:0x1087070

Note:Specifying the resume device by UUID is supposed to work, but I was
not able to get it to work. This may be a TuxOnIce or a mkinitcpio
issue, YMMV. Specifying /dev/sdxx should work in all cases though.

> Suspend to file

For the file allocator, you will have to prepare a hibernation file.
This is different from the standard swap file in that this file is ONLY
used for hibernation and not as a general system swap file. The previous
method is recommended as being more efficient in terms of disk space.
First configure the /etc/hibernate/tuxonice.conf file, uncomment the
"FilewriterLocation" option:

    FilewriterLocation /suspend_file 1000

1000 is the amount of disk space reserved for the hibernation file, in
this case 1000 megabytes. Usually an amount of 50% - 75% of your total
amount of RAM will suffice.

Next, we need to create the file, something like [2]:

    # echo TuxOnIce > /suspend_file
    # dd if=/dev/zero bs=1M count=1000 >> /suspend_file
    # echo /suspend_file > /sys/power/tuxonice/file/target
    # cat /sys/power/tuxonice/resume

The output of /sys/power/tuxonice/resume is what you need to pass to
your kernel. You should see something like file:/dev/sda2:0xdc008, in
which case you should append resume=file:/dev/sda2:0xdc008 as a kernel
parameter in your /etc/lilo.conf file (for LILO),
/boot/syslinux/syslinux.cfg (for syslinux) or /boot/grub/grub.cfg (for
Grub2).

Suspending and resuming
-----------------------

With hibernate-script, your preferred hibernation method can be set in
the file /etc/hibernate/hibernate.conf. See Suspending to Disk with
hibernate-script for more info.

Additional pm-utils setup
-------------------------

If using GNOME as your DE, or using any other environment that uses
pm-utils to shutdown and suspend the system, some additional setup is
required for TuxOnIce.

Configuration made in /etc/hibernate/hibernate.conf is still useful, but
some options do not seem to be used by pm-utils. Compression, for
example, will default to lzo unless more action is taken. Editing files
under /etc/pm/sleep.d/ is a good way to make sure wanted settings are
used.

To change the compressor used by TuxOnIce, for example, edit
/etc/pm/sleep.d/00doit and add a line like so:

    #!/bin/bash
     case $1 in
     hibernate)
     #Possible compressors include lzo, lzf, and none
     echo none > /sys/power/tuxonice/compression/algorithm
    ;;

Additional lines can be used to change other options, such as the
default logging level (found in
/sys/power/tuxonice/user_interface/default_console_level).

userui - user interface for TuxOnIce (optional)
-----------------------------------------------

Optionally, you can use a text or graphical (Fbsplash) interface with a
progress bar with TuxOnIce. To do this, install the tuxonice-userui
package from the AUR.

In /etc/hibernate/tuxonice.conf, set the desired user interface:

    ProcSetting userui_program "/usr/sbin/tuxoniceui"      # Text interface

or

    ProcSetting userui_program "/usr/sbin/tuxoniceui -f"   # Graphical fbsplash interface

The fbsplash interface also needs a symlink to the fbsplash theme, like
so:

    # ln -s /etc/splash/arch-banner-noicons/ /etc/splash/tuxonice

Without this symlink, there will be no progress indicators during
suspend/resume.

It is probably necessary to regenerate the initramfs after changing the
symlink above.

The text interface may be good for debugging TuxOnIce, as it displays
some messages.

You will not see a user interface for the first few seconds of the
resume process unless you add the userui hook to your mkinitcpio (before
the resume hook) configuration and regenerate your initramfs, but this
is also optional.

Generate initramfs:

    # mkinitcpio -p linux-ice

To test if userui works, switch to a text console and run:

    # tuxoniceui --test

For the graphical interface run:

    # tuxoniceui -f --test

References
----------

-   The TuxOnIce website and TuxOnIce wiki are excellent sources of
    documentation.
-   More general information about suspend/hibernate with
    hibernate-script can be found on the Suspend to Disk page of this
    wiki. This also covers some advanced topics like problems with
    specific hardware and configurations.
-   Another good source of information is the Gentoo wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=TuxOnIce&oldid=289827"

Category:

-   Power management

-   This page was last modified on 22 December 2013, at 00:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
