Kernel parameters
=================

There are three ways to pass options to the kernel and thus control its
behaviour:

1.  When building the kernel.
2.  When starting the kernel (usually, when invoked from a boot loader).
3.  At runtime (through the files in /proc and /sys).

This page now explains in more detail the second method and shows a list
of most used kernel parameters in Arch Linux.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Configuration                                                      |
|     -   1.1 Syslinux                                                     |
|     -   1.2 GRUB                                                         |
|     -   1.3 GRUB Legacy                                                  |
|     -   1.4 LILO                                                         |
|                                                                          |
| -   2 Parameters list                                                    |
| -   3 See Also                                                           |
+--------------------------------------------------------------------------+

Configuration
-------------

Kernel parameters can be set either temporarily by editing the boot menu
when it shows up, or by modifying the boot loader's configuration file.

Here we are adding the parameters quiet and splash to Syslinux, GRUB,
GRUB Legacy and LILO.

Syslinux

-   Press Tab when the menu shows up and add them at the end of the
    string:

    > .linux ../vmlinuz-linux root=/dev/sda3 ro initrd=../initramfs-linux.img quiet splash

Press Enter to boot with these parameters.

-   To make the change persistent after reboot, edit
    /boot/syslinux/syslinux.cfg and add them to the APPEND line:

    APPEND root=/dev/sda3 ro quiet splash

For more information on configuring Syslinux, see the Syslinux article.

GRUB

-   Press e when the menu shows up and add them on the linux line:

    linux   /boot/vmlinuz-linux root=UUID=978e3e81-8048-4ae1-8a06-aa727458e8ff ro  quiet splash

Press b to boot with these parameters.

-   To make the change persistent after reboot, while you could manually
    edit /boot/grub/grub.cfg with the exact line from above, for
    beginners it's recommended to:

Edit /etc/default/grub and append your kernel options to the
GRUB_CMDLINE_LINUX_DEFAULT line:

    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"

And then automatically re-generate the grub.cfg file with:

    # grub-mkconfig -o /boot/grub/grub.cfg

For more information on configuring GRUB, see the GRUB article.

GRUB Legacy

-   Press e when the menu shows up and add them on the kernel line:

    kernel /boot/vmlinuz-linux root=/dev/sda3 ro quiet splash

Press b to boot with these parameters.

-   To make the change persistent after reboot, edit /boot/grub/menu.lst
    and add them to the kernel line, exactly like above.

For more information on configuring GRUB Legacy, see the GRUB Legacy
article.

LILO

-   Add them to /etc/lilo.conf:

    image=/boot/vmlinuz-linux
            ...
            quiet splash

For more information on configuring LILO, see the LILO article.

Parameters list
---------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: The list needs   
                           more parameters.         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Note:Not all of the listed options are always available. Most are
associated with subsystems and work only if the kernel is configured
with those subsystems built in. They also depend on the presence of the
hardware they are associated with.

  SysVinit          systemd                         Description
  ----------------- ------------------------------- ---------------------------------------------------------------------------------------------------------------------
  3                 systemd.unit=multi-user         Boot to a specified runlevel (3, in this case). Works with 1-6.
  1                 systemd.unit=rescue             Boot to Single-user mode (root).
  nomodeset         nomodeset                       Disable Kernel Mode Setting.
  loglevel=3        loglevel=3                      Removes "misaligned reg" and "unknown connector type" messages during boot with the Nouveau driver. See this topic.
  --                init=/usr/lib/systemd/systemd   Boot using systemd instead of SysVinit.
  init=/bin/sh rw   init=/bin/sh rw                 Boot to Shell.

All of these parameters are case-sensitive.

For a complete list of all known options, please see the kernel
documentation.

See Also
--------

-   sysctl
-   List of kernel parameters with further explanation and grouped by
    similar options

Retrieved from
"https://wiki.archlinux.org/index.php?title=Kernel_parameters&oldid=238419"

Category:

-   Kernel
