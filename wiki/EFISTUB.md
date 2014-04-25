EFISTUB
=======

Warning:A bug has been noticed where booting EFISTUB can fail depending
on kernel version and motherboard model. See [1] and [2] for more
information.

The Linux Kernel (linux>=3.3) supports EFISTUB (EFI BOOT STUB) booting.
It is enabled by default on Arch Linux kernels or can be activated by
setting CONFIG_EFI_STUB=y in the Kernel configuration (see The EFI Boot
Stub for more information).

A single EFISTUB kernel is not capable of launching other kernels, hence
each EFISTUB Kernel + Initramfs pair requires a separate boot menu
entry. Because of this, when working with multiple kernels, it is
recommended to use a UEFI Boot Manager.

Contents
--------

-   1 Setting up EFISTUB
    -   1.1 Copying Kernel and Initramfs to ESP
        -   1.1.1 Using systemd
        -   1.1.2 Incron
        -   1.1.3 Mkinitcpio hook
        -   1.1.4 /etc/fstab bind mount
-   2 Booting EFISTUB
    -   2.1 Using gummiboot
    -   2.2 Using rEFInd
    -   2.3 Using UEFI Shell
    -   2.4 Directly, without boot manager

Setting up EFISTUB
------------------

1.  Create a EFI System Partition.
2.  Mount the EFI System Partition either at /boot (recommended) or some
    other location of your choice (most other distro's and tools use
    /boot/efi). The mountpoint will be mentioned as $esp hereafter.

> Copying Kernel and Initramfs to ESP

Warning:The below steps are required only if you DID NOT use /boot as
the EFISYS mountpoint. If you did choose /boot as mountpoint, you can
continue to #Booting EFISTUB.

1.  Create $esp/EFI/arch/
2.  Copy the following files from source to destination

  Boot File Source                     UEFI Destination
  ------------------------------------ -------------------------------------------
  /boot/vmlinuz-linux                  $esp/EFI/arch/vmlinuz-arch.efi
  /boot/initramfs-linux.img            $esp/EFI/arch/initramfs-arch.img
  /boot/initramfs-linux-fallback.img   $esp/EFI/arch/initramfs-arch-fallback.img

Warning:The EFISTUB Kernel must be updated each time the kernel is
updated. Failure to do so will result in failure to boot. One can
automatically update the EFISTUB kernel using one of the following
methods:

Using systemd

Systemd features event triggered tasks. In this particular case, the
ability to detect a change in path is used to sync the EFISTUB kernel
and initramfs files when they are updated in boot.

Warning:Since mkinitcpio takes time to build the kernel stub and the
initramfs. It is possible for the following systemd services to copy
older kernel stubs and initramfs instead of the new ones. To reduce the
chance of this error, it is better to bind the efistub copying service
to check if the initramfs-linux-fallback.img was changed (since it is
the last thing built by mkinitcpio).

    /etc/systemd/system/efistub-update.path

    [Unit]
    Description=Copy EFISTUB Kernel to UEFISYS Partition

    [Path]
    PathChanged=/boot/initramfs-linux-fallback.img

    [Install]
    WantedBy=multi-user.target

    /etc/systemd/system/efistub-update.service

    [Unit]
    Description=Copy EFISTUB Kernel to UEFISYS Partition

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/cp -f /boot/vmlinuz-linux $esp/EFI/arch/vmlinuz-arch.efi
    ExecStart=/usr/bin/cp -f /boot/initramfs-linux.img $esp/EFI/arch/initramfs-arch.img
    ExecStart=/usr/bin/cp -f /boot/initramfs-linux-fallback.img $esp/EFI/arch/initramfs-arch-fallback.img

Enable these services with:

    # systemctl enable efistub-update.path

Incron

incron can run a script to sync the EFISTUB Kernel after updates

Tip:Save the following script as /usr/local/bin/efistub-update.sh

    #!/usr/bin/env bash
    /usr/bin/cp -f /boot/vmlinuz-linux $esp/EFI/arch/vmlinuz-arch.efi
    /usr/bin/cp -f /boot/initramfs-linux.img $esp/EFI/arch/initramfs-arch.img
    /usr/bin/cp -f /boot/initramfs-linux-fallback.img $esp/EFI/arch/initramfs-arch-fallback.img

Tip:Save the following script as /etc/incron.d/efistub-update.conf

Note:The first parameter /boot/initramfs-linux-fallback.img is the file
to watch. The second parameter IN_CLOSE_WRITE is the action to watch
for. The third parameter /usr/local/bin/efistub-update.sh is the script
to execute.

    /boot/initramfs-linux-fallback.img IN_CLOSE_WRITE /usr/local/bin/efistub-update.sh

Tip:In order to use this method, incron must be activated, if it is not
run

    # systemctl enable incrond.service

Mkinitcpio hook

Mkinitcpio can generate a hook that does not need a system level daemon
to function. It spawns a background process which waits for the
generation of vm-linuz, initramfs-linux.img, and
initramfs-linux-fallback.img; then follows step 4 in Setting up EFISTUB

Tip:Save the following script as
/usr/lib/initcpio/install/efistub-update

    #!/usr/bin/env bash

    build() {
    	/root/watch.sh &
    }

    help() {
    	cat <<HELPEOF
    This hook waits for mkinitcpio to finish and copies the finished ramdisk and kernel to the ESP
    HELPEOF
    }

Tip:Save the following script as /root/watch.sh and make it executable

    #!/usr/bin/env bash

    while [[ -d "/proc/$PPID" ]]; do
    	sleep 1
    done

    /usr/bin/cp -f /boot/vmlinuz-linux $esp/EFI/arch/vmlinuz-arch.efi
    /usr/bin/cp -f /boot/initramfs-linux.img $esp/EFI/arch/initramfs-arch.img
    /usr/bin/cp -f /boot/initramfs-linux-fallback.img $esp/EFI/arch/initramfs-arch-fallback.img

    echo "Synced kernel with ESP"

Tip:Add efistub-update to the list of hooks in /etc/mkinitcpio.conf

/etc/fstab bind mount

> Note:

-   The following method should work similarly with any distribution
    that does not symlink in /boot. See Warnings for caveats.
-   This involves no special scripts, services, or bootloader filesystem
    drivers.
-   This centralizes and organizes kernels and initrds across
    installations on one partition.
-   This avoids possible limitations imposed by firmware and/or the
    bootloader on boot device configuration as can often occur with RAID
    and/or LVM (excepting the standard FAT32 EFI system partition, of
    course).
-   Beyond initial configuration this should persist without special
    consideration or maintenance.
-   This should be transparent to any action normally affecting /boot
    and the files therein.

> Warning:

-   This requires both a kernel and a bootloader compatible with the
    FAT32 filesystem.
-   Because the FAT32 filesystem cannot handle symlinks, this will not
    behave as intended with an installation that requires them in /boot.
-   Initial configuration requires root level access.
-   This may require a large EFI system partition in order to accomodate
    multiple installations.
-   All kernels will require at least a root=system root parameter
    passed at boot.
-   per rEFInd's author: OpenSUSE definitely uses symbolic links in
    /boot... Fedora, Ubuntu, and ... OpenSUSE all refuse a FAT partition
    as /boot in ... setup [which] can be worked around [in] /etc/fstab.
    Forum post [here].

 Method
    Whereas the general convention is to mount the EFI system partition
    to a /boot/efi subfolder, the following will achieve the opposite.

-   Create a ef00 type EFI system partition of FAT32 format as described
    elsewhere.

> Tip:

-   It may be beneficial to make it several gigabytes in size to
    accomodate multiple installations.
-   Use the GPT partition name feature for added convenience. For
    example name the partition esp.

-   Create a mount-point and mount the EFI system partition somewhere on
    the filesystem. For example:

$ mkdir /esp$ mount -L esp /esp

-   Create a folder in /EFI/boot on the EFI system partition to contain
    your system's /boot files. For example:

$ mkdir /esp/EFI/boot/arch64-laptop

> Tip:

-   The refind bootloader automatically detects and adds EFI loadable
    kernel files installed to the EFI system partition in /EFI/boot/*/
    by default.
-   Keying F2 on a highlighted refind boot menu entry enables adding the
    required root= kernel parameter to an auto-added or otherwise
    unconfigured menu entry.

-   Move all files in /boot to the newly created folder on your EFI
    system partition. For example:

$ mv /boot/* /esp/EFI/boot/arch64-laptop/

-   Bind mount the newly populated folder on your EFI system partition
    to /boot. For example:

$ mount --bind /esp/EFI/boot/arch64-laptop /boot

-   Verify your files are available as expected with $ ls /boot/ then
    persist the configuration by editing /etc/fstab. For example:

##/etc/fstabLABEL=arch64-laptop_rootfs / ext4 defaults 0 0LABEL=esp /esp vfat defaults 0 0/esp/EFI/boot/arch64-laptop /boot none defaults,bind 0 0

-   Update your bootloader to apply the root= kernel boot parameter as
    necessary. For example:

##/boot/refind_linux.conf... root=LABEL=arch64-laptop_rootfs ...

Note: As of refind-efi 0.2.7, refind automatically detects kernels in
/boot. They do not have to be renamed to have a .efi extension either.
Hence, the following sync scripts aren't needed if using refind. You do
need to isntall an EFI driver to read the Linux filesystem on which the
kernel is stored, though.

Booting EFISTUB
---------------

Warning:Linux Kernel EFISTUB initramfs path should be relative to the
EFI System Partition's root. For example, if the initramfs is located in
$esp/EFI/arch/initramfs-linux.img, the corresponding UEFI formatted line
should be initrd=/EFI/arch/initramfs-linux.img or
initrd=\EFI\arch\initramfs-linux.img.

EFISTUB kernel can be booted using one of the following ways :

> Using gummiboot

Gummiboot is a UEFI Boot Manager which provides a nice menu for EFISTUB
Kernels. It is the recommended boot manager for EFISTUB booting. See
gummiboot for more info.

> Using rEFInd

rEFInd is a fork of rEFIt Boot Manager (used in Intel Macs) by Rod Smith
(author of gdisk). rEFInd fixes many issues in rEFIt with respect to
non-Mac UEFI booting and also has support for booting EFISTUB kernels
and contains some features specific to them. See rEFInd for detail.

> Using UEFI Shell

It is possible to launch EFISTUB kernel form UEFI Shell as if it is a
normal UEFI application. In this case the kernel parameters are passed
as normal parameters to the launched EFISTUB kernel file.

    > fs0:
    > cd \EFI\arch
    > vmlinuz-arch.efi root=PARTUUID=3518bb68-d01e-45c9-b973-0b5d918aae96 rootfstype=ext4 add_efi_memmap initrd=EFI/arch/initramfs-arch.img

You can also write a simple archlinux.nsh file with your boot parameters
and put it in your UEFI System Partition, then run it with:

    > fs0:
    > archlinux

Example Script:

    $ESP/archlinux.nsh

    echo -on
    \EFI\arch\vmlinuz-arch.efi root=PARTUUID=3518bb68-d01e-45c9-b973-0b5d918aae96 rootfstype=ext4 add_efi_memmap initrd=/EFI/arch/initramfs-arch.img

This way you can specify UUID's without needing to remember the name or
type out 20-30 characters.

> Directly, without boot manager

Warning:Some kernel and efibootmgr combinations might not work without
manual intervention [3]. You will be able to delete but not create boot
entries.

Note:Some UEFI firmwares may not support embedding command line
parameters to uefi applications in the boot entries.

It is possible to directly embed the kernel parameters within the UEFI
boot entry. This means that you can use your UEFI boot order/motherboard
GUI to directly boot Arch Linux without a separate boot manager. Change
X and Y to reflect the disk and partition where the ESP is located.
Change the root= parameter to reflect your Linux root.

    # mount -t efivarfs efivarfs /sys/firmware/efi/efivars              # ignore if already mounted
    # efibootmgr -d /dev/sdX -p Y -c -L "Arch Linux" -l /vmlinuz-linux -u "root=/dev/sda2 rw initrd=/initramfs-linux.img"

It is a good idea to run

    # efibootmgr -v

to verify that the resulting entry is correct. You should also consider
reordering the boot options (efibootmgr -o) to place the Arch entry
last, which could make the system easier to recover if it fails.

Tip:Save the command for creating your boot entry in a shell script
somewhere, which makes it easier to modify (when changing kernel
parameters, for example).

More info about efibootmgr at UEFI#efibootmgr. Forum post
https://bbs.archlinux.org/viewtopic.php?pid=1090040#p1090040 .

Retrieved from
"https://wiki.archlinux.org/index.php?title=EFISTUB&oldid=305301"

Category:

-   Boot loaders

-   This page was last modified on 17 March 2014, at 09:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
