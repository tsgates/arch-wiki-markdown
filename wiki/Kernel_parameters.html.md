Kernel parameters
=================

There are three ways to pass options to the kernel and thus control its
behaviour:

1.  When building the kernel. See Kernel Compilation for details.
2.  When starting the kernel (usually, when invoked from a boot loader).
3.  At runtime (through the files in /proc and /sys). See sysctl for
    details.

This page now explains in more detail the second method and shows a list
of most used kernel parameters in Arch Linux.

Contents
--------

-   1 Configuration
    -   1.1 Syslinux
    -   1.2 GRUB
    -   1.3 GRUB Legacy
    -   1.4 LILO
    -   1.5 Gummiboot
    -   1.6 rEFInd
-   2 Parameter list
-   3 See also

Configuration
-------------

Kernel parameters can be set either temporarily by editing the boot menu
when it shows up, or by modifying the boot loader's configuration file.

Here we are adding the parameters quiet and splash to Syslinux, GRUB,
GRUB Legacy, LILO, Gummiboot and rEFInd.

Syslinux

-   Press Tab when the menu shows up and add them at the end of the
    string:

    linux /boot/vmlinuz-linux root=/dev/sda3 initrd=/boot/initramfs-linux.img quiet splash

Press Enter to boot with these parameters.

-   To make the change persistent after reboot, edit
    /boot/syslinux/syslinux.cfg and add them to the APPEND line:

    APPEND root=/dev/sda3 quiet splash

For more information on configuring Syslinux, see the Syslinux article.

GRUB

-   Press e when the menu shows up and add them on the linux line:

    linux /boot/vmlinuz-linux root=UUID=978e3e81-8048-4ae1-8a06-aa727458e8ff quiet splash

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

    kernel /boot/vmlinuz-linux root=/dev/sda3 quiet splash

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

Gummiboot

-   Press e when the menu appears and add the parameters to the end of
    the string:

    initrd=\initramfs-linux.img root=/dev/sda2 rw quiet splash

Press Enter to boot with these parameters.

Note:If you have not set a value for menu timeout, you will need to hold
Space while booting for the Gummiboot menu to appear.

-   To make the change persistent after reboot, edit
    /boot/loader/entries/arch.conf (assuming you set up your EFI System
    Partition and configuration files according to the instructions in
    the Beginners' Guide) and add them to the options line:

    options root=/dev/sda2 rw quiet splash

For more information on configuring Gummiboot, see the Gummiboot
article.

rEFInd

-   To make the change persistent after reboot, edit
    /boot/EFI/arch/refind_linux.conf (ie. refind_linux.conf in the
    folder your kernel is located in) and append them to all/required
    lines, for example:

    "Boot to X"   "root=PARTUUID=978e3e81-8048-4ae1-8a06-aa727458e8ff ro rootfstype=ext4 quiet splash

-   If you've disabled auto-detection of OS's in rEFInd and are defining
    OS stanzas instead in /boot/EFI/refind/refind.conf to load your
    OS's, you can edit it like:

    menuentry "Arch" {
    	loader /EFI/arch/vmlinuz-arch.efi
    	options "quiet splash ro root=PARTUUID=978e3e81-8048-4ae1-8a06-aa727458e8ff"

For more information on configuring kernel parameters in rEFInd, see
Configuring the rEFInd Bootmanager

Parameter list
--------------

Parameters always come in parameter or parameter=value. All of these
parameters are case-sensitive.

Note:Not all of the listed options are always available. Most are
associated with subsystems and work only if the kernel is configured
with those subsystems built in. They also depend on the presence of the
hardware they are associated with.

  parameter                 Description
  ------------------------- --------------------------------------------------------------------------------------------
  root=                     Root filesystem.
  ro                        Mount root device read-only on boot.
  rw                        Mount root device read-write on boot (default).
  initrd=                   Specify the location of the initial ramdisk.
  init=                     Run specified binary instead of /sbin/init (symlinked to systemd in Arch) as init process.
  init=/bin/sh              Boot to shell.
  systemd.unit=             
  systemd.unit=multi-user   Boot to a specified runlevel.
  systemd.unit=rescue       Boot to single-user mode (root).
  nomodeset                 Disable Kernel Mode Setting.

For a complete list of all options, please see the kernel documentation.

See also
--------

-   Power saving#Kernel parameters
-   List of kernel parameters with further explanation and grouped by
    similar options

Retrieved from
"https://wiki.archlinux.org/index.php?title=Kernel_parameters&oldid=304885"

Category:

-   Kernel

-   This page was last modified on 16 March 2014, at 08:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
