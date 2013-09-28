Flashcache
==========

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installation                                                       |
|     -   2.1 Getting the kernel module                                    |
|     -   2.2 Preparing the fast drive                                     |
|     -   2.3 Creating flashcache                                          |
|     -   2.4 Starting Drives on Boot                                      |
|         -   2.4.1 Late Boot Start Using systemd                          |
|         -   2.4.2 Early Boot Start with initcpio                         |
|             -   2.4.2.1 Setting up the ramdisk                           |
|             -   2.4.2.2 Other file changes                               |
|                                                                          |
| -   3 Tweaks                                                             |
| -   4 Troubleshooting                                                    |
| -   5 More resources                                                     |
+--------------------------------------------------------------------------+

Introduction
------------

Flashcache is a module originally written and released by Facebook(Mohan
Srinivasan, Paul Saab and Vadim Tkachenko) in April of 2010. It is a
kernel module that allows Writethrough caching of a drive on another
drive. This is most often used for caching a rotational drive on a
smaller solid-state drive for performance reasons. This gives you the
speed of an SSD and the size of a standard rotational drive for recently
cached files. Facebook originally wrote the module to speed up database
I/O, but it is easily extended to any I/O.

An alternative to Flashcache is Bcache

Warning:Installation of flashcache at this point is *not* a simple task
and should only be attempted by people comfortable with such things.
Please read the instructions thoroughly before attempting to install
this driver. It is very easy to get a non-booting machine if you are not
careful.

It is important to note that this driver is intended to speed up a
slower drive with a faster one. It is not required that one of the
drives is a solid-state drive. It could be useful in a situation with
widely different speed drives such as a fast and small SCSI drive and a
larger SATA drive or even a slower "green" drive and a super-fast 10k
rpm drive.

Warning:I have read that this module doesn't compile properly on a
32-bit machine, but I have not tested this.

Installation
------------

Tip:Throughout the page, /dev/sda will be used to indicate the slow
drive and /dev/sdb will used to indicate the fast drive. The two
partitions sda3 and sda4 are being cached on sdb1 and sdb2 respectively.
Be sure to change these examples to match your setup.

> Getting the kernel module

Warning:You must have the full kernel source with device-mapper enabled
or built as a module.

At this time the kernel module is not included in the arch packages or
AUR, so you must download the file directly from github at
https://github.com/facebook/flashcache. Extract the image and compile
the module/utils:

    # tar -xzvf facebook-flashcache-1.0-64-g085b7ba.tar.gz
    # cd facebook-flashcache-085b7ba
    # make KERNEL_TREE=<root of kernel source tree> (most likely in /usr/src)

If all goes well you're ready to install the module(you need root access
for this):

    # sudo make KERNEL_TREE=<root of kernel source tree> install

From there I copied the executables to /usr/sbin for ease of use:

    # sudo cp src/utils/{flashcache_create,flashcache_load,flashcache_destroy} /usr/sbin

> Preparing the fast drive

To prepare the fast drive for the caching required, we need to simply
partition it based on our desired cache sizes. I wanted to cache a good
deal of the root partition and some of my home partition, so I made my
partitions 4 gigs and 116 gigs respectively. Take a look at your
partitions and make an informed decision about the partition sizes you
require.

> Creating flashcache

    # flashcache_create cached_part1 /dev/sdb1 /dev/sda3
    # flashcache_create cached_part2 /dev/sdb2 /dev/sda4

> Starting Drives on Boot

Depending on where you intend to use flashcache, you can choose either
to start the drives at early boot, essential if you are caching the root
file-system, or to start the drives later during the boot cycle, for
example for a /home drive partition. Starting the drives during the
later boot stages is much easier.

Late Boot Start Using systemd

Tip:In this section I am ignoring the root filesystem flashcache, as
this method is not appropriate for it

In this method, you will create and activate a systemd script to load
the flashcache module and mount the flashcache drives.

First, edit /etc/fstab and make sure that /home is being mounted using
its UUID. If it is not, then get the UUID from /dev/disk/by-uuid.
Flashcache will give the flashcache drive the same UUID as the parent,
so this method will allow booting even if the flashcache drive could not
be loaded. The relevant line should look something like:

    ...
    UUID=5ebee55d-8871-44ea-b159-58c103970f54   /home               ext4        rw,relatime
    ...

Next, create an init script to actually do the work.

/lib/initcpio/hooks/flashcache:

    #!/bin/bash

    # Check if /home is mounted
    HOMEMOUNT=$(mount | grep home | sed 's/ .*//' | sed 's#.*/##' )

    # Load module if not already loaded
    if [[ ! "$(eval lsmod | grep "^flashcache")" ]]; then
      modprobe flashcache
    fi

    # Mount flashcache /home if not already mounted
    if [[ ! "$HOMEMOUNT" == "cached_part2" ]]; then
      umount /home
      if [ ! -e /dev/mapper/cached_part2 ]; then
        flashcache_load /dev/sdb2
      fi  
      mount /home
    fi

Now create the systemd script that will use that init script.
/lib/systemd/system/flashcache.service

    [Unit]
    Description=FlashCache

    [Service]
    Type=oneshot
    RemainAfterExit=no
    ExecStart=/usr/local/bin/flashcache

    [Install]
    WantedBy=multi-user.target

Finally, you can enable the service like this:

    systemctl enable flashcache

That should be it!

Early Boot Start with initcpio

This method requires that you edit the kernel's initial ramdisk to load
flashcache at early boot time.

Setting up the ramdisk

If you are setting up a cache that uses your root partition or you do
not want to unmount your partitions while running, the best option is to
change your ramdisk to support flashcache and do your administration
with busybox. If you have unmounted filesystems that you are trying to
cache, skip down to #Other file changes.

I used lvm as a base for my ramdisk changes, but it is very possible
that there is a better way to do this. First, I created(be sure to
update to match your system!) /lib/initcpio/hooks/flashcache

    # vim:set ft=sh:
    run_hook ()
    {
        /sbin/modprobe -q dm-mod >/dev/null 2>&1
        if [ -e "/sys/class/misc/device-mapper" ]; then
            if [ ! -e "/dev/mapper/control" ]; then
                /bin/mknod "/dev/mapper/control" c $(cat /sys/class/misc/device-mapper/dev | sed 's|:| |')
            fi

            [ "${quiet}" = "y" ] && LVMQUIET=">/dev/null"

            msg "Activating cache volumes..."
            eval /usr/sbin/flashcache_load cached_part1 /dev/sdb1 /dev/sda3 $LMQUIET
            eval /usr/sbin/flashcache_load cached_part2 /dev/sdb2 /dev/sda4 $LMQUIET
        fi
    }

/lib/initcpio/install

    # vim: set ft=sh:

    install ()
    {
        MODULES="dm-mod"
        BINARIES=""
        FILES=""
        SCRIPT="flashcache"

        add_dir "/dev/mapper"
        add_binary "/sbin/dmsetup"
        add_binary "/usr/sbin/flashcache_create"
        add_binary "/usr/sbin/flashcache_load"
        add_binary "/usr/sbin/flashcache_destroy"
        add_file "/lib/udev/rules.d/10-dm.rules"
        add_file "/lib/udev/rules.d/13-dm-disk.rules"
        add_file "/lib/udev/rules.d/95-dm-notify.rules"
        add_file "/lib/udev/rules.d/11-dm-lvm.rules"
    }

    help ()
    {
    cat<<HELPEOF
      This hook loads the necessary modules for a flash drive as a cache device for your root device.
    HELPEOF
    }

Note: I left in the files dm-disk.rules, dm-notify.rules and
dm-lvm.rules, but I do not believe these are required.

Update your /etc/mkinitcpio.conf:

Add flashcache to your modules

    # MODULES="flashcache"

Add flashcache to your hooks(be sure to add it before filesystems)

    # HOOKS="... flashcache ..."

Tip:You might need to add usbinput to your hooks as well if you are
using a usb keyboard.

Now rebuild your ramdisk image:

    # mkinitcpio -g /boot/<your ramdisk filename>.img

You might want to make this a different ramdisk image than your normal
one and create a new entry in your grub config to use this ramdisk.

Other file changes

The new partitions will show up in /dev/mapper and you need to mount
these partitions instead of the original /dev/sd* partitons. You need to
edit grub and your fstab to mount these new partitions. In this example,
the root partition is /dev/mapper/cached_part1 and the home directory is
/dev/mapper/cached_part2.

/boot/grub/menu.lst

    # (0) Arch Linux
    title  Arch Linux(flashcache)
    root   (hd0,0)
    kernel /vmlinuz26 root=/dev/mapper/cached_part1 ro 5
    initrd /kernel-2.6.38.4.img

/etc/fstab

    ...
    /dev/mapper/cached_part1 / ext3 defaults 0 1
    /dev/mapper/cached_part2 /home ext3 defaults,user_xattr 0 1
    ...

If you're caching your root partition, reboot and press e in grub to
edit the kernel command line options. Select the line with the kernel
options and press e again. Append 'break=y' without quotes to the end
and press enter. Press b to boot. This tells the ramdisk image to stop
after loading modules and drop into a shell to allow us to do some work.

Now reboot(make sure you use the flashcache ramdisk) and verify the
mounted partitions are the newly created ones.

Tweaks
======

There are a lot of options for controlling the cache, check the system
administrators guide in the documentation for flashcache for all of
them. I added the following changes to /etc/sysctl.conf:

    #####################
    # flashcache settings
    #####################

    # disable writing dirty cache data at shutdown
    dev.flashcache.fast_remove = 1

    # change the reclaim policy to LRU from FIFO 
    dev.flashcache.reclaim_policy = 1

    # do not write "stale" data to disk until evicted due to lack of space
    dev.flashcache.fallow_delay = 0

Troubleshooting
===============

    * If you get an error trying to create the cache 'device-mapper: reload ioctl failed: Invalid argument', you could be trying to create a cache of a mounted filesystem.
    * If boot fails, an easy way to check on the cache is to edit your kernel command line in grub to add break=y and use the ramdisk's shell to poke around.
    * /proc/flashcache_stats has interesting information and can tell you if the cache is properly working.

More resources
==============

-   Original announcement -
    http://www.facebook.com/note.php?note_id=388112370932
-   Github source - https://github.com/facebook/flashcache

Retrieved from
"https://wiki.archlinux.org/index.php?title=Flashcache&oldid=249474"

Category:

-   File systems
