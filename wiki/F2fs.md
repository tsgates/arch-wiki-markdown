F2fs
====

F2FS (Flash-Friendly File System) is a file system intended for
NAND-based flash memory. It is supported from kernel 3.8 onwards.

Creating a F2FS partition
-------------------------

In order to create a F2FS partition, install f2fs-tools from the
official repositories.

Create the partition:

    # mkfs.f2fs -l mylabel /dev/sdxY

where /dev/sdxY is the target volume to format in F2FS.

Mounting a F2FS partition
-------------------------

Users will likely need to manually load the F2FS kernel module before
mounting. Issue as root:

    # modprobe f2fs

The partition can then be mounted:

    # mount -t f2fs /dev/sdxY /mnt

Install Arch Linux on F2FS partition
------------------------------------

With the latest installation media (2013.04.01) it is possible to
install system on F2FS partition:

1.  Install f2fs-tools from official repositories while running arch
    from installation media.
2.  Load f2fs kernel module as described.
3.  Create root partition as F2FS as described.
4.  Create /boot partition as ext4 (or any other supported filesystem).
5.  Mount, install and chroot system as per official installation guide.
6.  On installed system add f2fs to modules section in
    /etc/mkinitcpio.conf.
7.  Don't forget to regenerate the initramfs image after that:

# mkinitcpio -p linux

Retrieved from
"https://wiki.archlinux.org/index.php?title=F2fs&oldid=298343"

Category:

-   File systems

-   This page was last modified on 16 February 2014, at 10:18.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
