Gummiboot
=========

From Gummiboot homepage:

Gummiboot is a simple UEFI boot manager which executes configured EFI
images. The default entry is selected by a configured pattern (glob) or
an on-screen menu.

It is simple to configure, but can only start EFI executables, the Linux
kernel EFISTUB, UEFI Shell, grub.efi, and such.

Warning:Gummiboot simply provides a boot menu for EFISTUB kernels. In
case you have issues booting EFISTUB kernels like in FS#33745, you
should use a boot loader which does not use EFISTUB, like GRUB, Syslinux
or ELILO.

Note:In the entire article $esp denotes the mountpoint of the EFI System
Partition aka ESP.

Contents
--------

-   1 Installation
    -   1.1 Updating
-   2 Configuration
    -   2.1 Basic Configuration
    -   2.2 Adding boot entries
-   3 Inside the boot menu
    -   3.1 Keys
-   4 Troubleshooting
    -   4.1 Manual entry using efibootmgr
    -   4.2 Menu does not appear after Windows upgrade
-   5 References

Installation
------------

Install gummiboot and install gummiboot in ESP:

    # mount -t efivarfs efivarfs /sys/firmware/efi/efivars              # required even inside chroot if any, ignore if already mounted
    # pacman -S gummiboot
    # gummiboot --path=$esp install

This will automatically copy the gummiboot binary to your EFI System
Partition and create a boot entry in the EFI Boot Manager. If you are
not booted via EFI, creating the boot entry will fail. You should
however still be able to boot gummiboot as it copies the binary to the
default EFI binary location on your ESP ($esp/EFI/boot/bootx64.efi on
x64 systems) (unless a non-gummiboot $esp/EFI/boot/bootx64.efi is
already present).

Note:If gummiboot fails to create a boot entry, check whether all the
conditions mentioned here are met.

> Updating

Gummiboot assumes that your EFI System Partition is mounted on /boot. If
the ESP is not mounted on /boot, gummiboot will not be updated
automatically during pkg updates and you will have to call
gummiboot --path=$esp update after every package update. Additionally
you will have to make sure that the kernel and initramfs are copied onto
the ESP as gummiboot cannot load EFI binaries from other partitions. It
is therefore strongly recommended to mount your ESP to /boot if you use
gummiboot, in which case updating will happen automatically by the
post_install script of gummiboot during package updates.

Configuration
-------------

> Basic Configuration

The basic configuration is kept in $esp/loader/loader.conf, with just
two possible configuration options:

-   default – default entry to select (without the .conf suffix); can be
    a wildcard like arch-*

-   timeout – menu timeout in seconds. If this is not set, the menu will
    only be shown when you hold the space key while booting.

Example:

    $esp/loader/loader.conf

    default  arch
    timeout  4

Note that both options can be changed in the boot menu itself, which
will store them as EFI variables.

Note:If no timeout is configured, which is the default setting, and no
key pressed during bootup, the default entry is executed right away.

> Adding boot entries

Gummiboot searches for boot menu items in $esp/loader/entries/*.conf –
each file found must contain exactly one boot entry. The possible
options are:

-   title – operating system name. Required.

-   version – kernel version, shown only when multiple entries with same
    title exist. Optional.

-   machine-id – machine identifier from /etc/machine-id, shown only
    when multiple entries with same title and version exist. Optional.

-   efi – EFI program to start, relative to your ESP ($esp); e.g.
    /vmlinuz-linux. Either this or linux (see below) is required.

-   options – Command-line options to pass to the EFI program. Optional,
    but you will need at least initrd=efipath and root=dev if booting
    Linux.

For Linux, you can specify linux path-to-vmlinuz and
initrd path-to-initramfs; this will be automatically translated to
efi path and options initrd=path – this syntax is only supported for
convenience and has no differences in function.

You can find your PARTUUID with blkid -s PARTUUID -o value /dev/sdxx

An example entry for Arch Linux:

    $esp/loader/entries/arch.conf

    title          Arch Linux
    linux          /vmlinuz-linux
    initrd         /initramfs-linux.img
    options        root=PARTUUID=14420948-2cea-4de7-b042-40f67c618660 rw

Please note in the example above that PARTUUID/PARTLABEL identifies a
GPT partition, and differs from UUID/LABEL, which identifies a
filesystem. Using the PARTUUID/PARTLABEL is advantageous because it is
invariant if you reformat the partition with another filesystem. It is
also useful if you do not have a filesystem on the partition (or use
LUKS, which does not support LABELs).

An example entry for encrypted root (dm-crypt with LUKS)

    $esp/loader/entries/arch-encrypted.conf

    title          Arch Linux (Encrypted)
    linux          /path/to/vmlinuz-linux
    options        initrd=/path/to/initramfs-linux.img cryptdevice=UUID=<UUID>:luks-<UUID> root=UUID=<luks-UUID> rw

In the encrypted example, not that the initrd is in options -- this does
not appear to be discretionary at this time. Note that UUID is used for
in this example. PARTUUID should be able to replace the UUID, if so
desired.

You can also add other EFI programs such as \EFI\arch\grub.efi.

Note:Gummiboot will automatically check for "Windows Boot Manager"
(\EFI\Microsoft\Boot\Bootmgfw.efi), "EFI Shell" (\shellx64.efi) and "EFI
Default Loader" (\EFI\Boot\bootx64.efi), and display entries for them if
they are present, so you do not have to manually create entries for
them. However it does not autodetect other EFI applications (unlike
rEFInd), so for booting the kernel, manual config entries must be
created as mentioned above.

Inside the boot menu
--------------------

> Keys

The following keys are used inside the menu:

-   Up/Down - select entry
-   Enter - boot the selected entry
-   d - select the default entry to boot (stored in a non-volatile EFI
    variable)
-   -/T - decrease the timeout (stored in a non-volatile EFI variable)
-   +/t - increase the timeout (stored in a non-volatile EFI variable)
-   e - edit the kernel command line
-   v - show the gummiboot and UEFI version
-   Q - quit
-   P - print the current configuration
-   h/? - help

These hotkeys will, when pressed inside the menu or during bootup,
directly boot a specific entry:

-   l - Linux
-   w - Windows
-   a - OS X
-   s - EFI Shell
-   1-9 - number of entry

Troubleshooting
---------------

> Manual entry using efibootmgr

If gummiboot install command failed, you can create a EFI boot entry
manually using efibootmgr utility:

    # efibootmgr -c -d /dev/sdX -p Y -l /EFI/gummiboot/gummibootx64.efi -L "Gummiboot"

where /dev/sdXY is the EFISYS partition.

> Menu does not appear after Windows upgrade

For example, if you upgraded from Windows 8 to Windows 8.1, and you no
longer see a boot menu after the upgrade (i.e., Windows boots
immediately):

-   Make sure Secure Boot (BIOS setting) and Fast Startup (Windows power
    option setting) are both disabled.
-   Make sure your BIOS prefers Linux Boot Manager over Windows Boot
    Manager (depending on your BIOS, this might appear under a BIOS
    setting like Hard Disk Drive Priority).

References
----------

-   http://freedesktop.org/wiki/Software/gummiboot/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gummiboot&oldid=305135"

Category:

-   Boot loaders

-   This page was last modified on 16 March 2014, at 16:18.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
