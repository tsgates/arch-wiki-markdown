Gummiboot
=========

Gummiboot is a UEFI boot loader written by Kay Sievers and Harald Hoyer.
It is simple to configure, but can only start EFI executables, the Linux
kernel (with CONFIG_EFI_STUB enabled), grub.efi, and such.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 Configuring                                                        |
| -   3 Adding boot entries                                                |
| -   4 Inside the boot menu                                               |
| -   5 Troubleshooting                                                    |
|     -   5.1 Transferring to new HDD causes breakage                      |
|     -   5.2 Manual installation bootloader                               |
+--------------------------------------------------------------------------+

Installing
----------

Note:gummiboot assumes that your EFI System Partition is mounted on
/boot. If your ESP is mounted on /boot/efi you have to call the
following gummiboot install command with the additional --path switch.
This also means that gummiboot will not be able to update itself
automatically and you will have to call
gummiboot --path /boot/efi update after every package update.
Additionally you will have to make sure that the kernel and initramfs
are copied onto the ESP as gummiboot can't load EFI binaries from other
partitions. It is therefore strongly recommended to mount your ESP to
/boot if you use gummiboot. The rest of this article will assume that
your ESP is mounted on /boot.

Install gummiboot from [extra] and run the following to install
gummiboot:

    # gummiboot install

This will automatically copy the gummiboot binary to your EFI System
Partition and create a boot entry in the EFI Boot Manager. However,
creating the boot entry requires that you are already running in EFI
mode and are running kernel 3.8. If you are still running kernel 3.7 or
have not booted in EFI mode, creating the boot entry will fail. You
should however still be able to boot gummiboot as it copies the binary
to the default EFI binary location on your ESP
(/boot/EFI/BOOT/BOOTX64.EFI on x64 systems). Note that the installing
process only has to be done once, updating will happen automatically.

Configuring
-----------

The basic configuration is kept in /boot/loader/loader.conf, with just
two possible configuration options:

-   default – default entry to select (without the .conf suffix); can be
    a wildcard like arch-*

-   timeout – menu timeout in seconds. If this is not set, the menu will
    only be shown when you hold the space key while booting.

Example:

    /boot/loader/loader.conf

    default  arch
    timeout  4

Note that both options can be changed in the boot menu itself, which
will store them as EFI variables.

Adding boot entries
-------------------

Gummiboot searches for boot menu items in /boot/loader/entries/*.conf –
each file found must contain exactly one boot entry. The possible
options are:

-   title – operating system name. Required.

-   version – kernel version, shown only when multiple entries with same
    title exist. Optional.

-   machine-id – machine identifier from /etc/machine-id, shown only
    when multiple entries with same title and version exist. Optional.

-   efi – EFI program to start, relative to your ESP (/boot); e.g.
    /vmlinuz-linux. Either this or linux (see below) is required.

-   options – Command-line options to pass to the EFI program. Optional,
    but you will need at least initrd=efipath and root=dev if booting
    Linux.

For Linux, you can specify linux path-to-vmlinuz and
initrd path-to-initramfs; this will be automatically translated to
efi path and options initrd=path – this syntax is only supported for
convenience and has no differences in function.

An example entry for Arch Linux:

    /boot/loader/entries/arch.conf

    title          Arch Linux
    linux          /vmlinuz-linux
    initrd         /initramfs-linux.img
    options        root=PARTUUID=14420948-2cea-4de7-b042-40f67c618660 ro

You can also add other EFI programs such as \EFI\arch\grub.efi.

Note:Gummiboot will automatically check for binaries of a Windows
Installation (\EFI\Microsoft\Boot\Bootmgfw.efi) or an UEFI Shell
(\shellx64.efi) and display entries for them, so you don't have to
create these manually.

Inside the boot menu
--------------------

TODO: document keybindings from
http://freedesktop.org/wiki/Software/gummiboot

Troubleshooting
---------------

Transferring to new HDD causes breakage

Twice now I have transferred my installation from one disk to another,
ESP included, and both times this broke my gummiboot setup. With a lot
of trial and error, I have discovered that gummiboot does not like
configuration files that have been tranfserred from one disk to another
(I used rsync).

To solve this, delete the $ESP/loader directory and all of its contents,
and recreate the necessary configuration files.

Though it has no additional info, here is my relevent forum thread.

Manual installation bootloader

If gummiboot install command failed you can install EFI boot entry
manually with efibootmgr utility:

    # efibootmgr -c -g -d /dev/sdX -p Y -w -L "Gummiboot" -l '\EFI\gummiboot\gummibootx64.efi'

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gummiboot&oldid=254955"

Category:

-   Boot loaders
