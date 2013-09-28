F2fs
====

F2FS (Flash-Friendly File System) is a file system intended for
NAND-based flash memory. It is supported from kernel 3.8 onwards.

Creating a f2fs partition
-------------------------

In order to create a f2fs partition, you need f2fs-tools from AUR

Create the partition:

    # mkfs.f2fs /dev/sdxY

Mounting a f2fs partition
-------------------------

You may need to load the f2fs kernel module before mounting. Issue as
root:

    # modprobe f2fs

Then you can mount the partition:

    # mount -t f2fs /dev/sdxY /mnt

Install Arch Linux on f2fs partition
------------------------------------

With the latest installation media (2013.04.01) it is possible to
install system on f2fs partition:

1.  Install f2fs-tools from [community] while running arch from
    installation media.
2.  Load f2fs kernel module as described above.
3.  Create root partition as f2fs as described above.
4.  Create boot partition as ext4 (or any other supported filesystem).
5.  Mount, install and chroot system as per official installation guide.
6.  (On installed sytem) add  f2fs to modules section in
    /etc/mkinitcpio.conf and remove  fsck from hooks section since f2fs
    doesn't have fsck implementation yet.
7.  Don't forget to regenerate the initramfs image after that:

    # mkinitcpio -p linux

Retrieved from
"https://wiki.archlinux.org/index.php?title=F2fs&oldid=255865"

Category:

-   File systems
