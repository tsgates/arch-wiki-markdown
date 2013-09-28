Change Root
===========

Chroot is the process of changing of the apparent disk root directory
(and the current running process and its children) to another root
directory. When you change root to another directory you cannot access
files and commands outside that directory. This directory is called a
chroot jail. Changing root is commonly done for system maintenance, such
as reinstalling the bootloader or resetting a forgotten password.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Requirements                                                       |
| -   2 Mount the partitions                                               |
| -   3 Change root                                                        |
| -   4 Run graphical chrooted applications                                |
| -   5 Perform system maintenance                                         |
| -   6 Exit the chroot environment                                        |
| -   7 Example                                                            |
+--------------------------------------------------------------------------+

Requirements
------------

-   You'll need to boot from another working Linux environment (e.g.
    from a LiveCD or USB flash media, or from another installed Linux
    distribution).

-   Root privileges are required in order to chroot.

-   Be sure that the architecture of the Linux environment you have
    booted into matches the architecture of the root directory you wish
    to enter (i.e. i686, x86_64). You can find the architecture of your
    current environment with:

    # uname -m

-   If you need any kernel modules loaded in the chroot environment,
    load them before chrooting. It may also be useful to initialize your
    swap (swapon /dev/sdxY) and to establish an internet connection
    before chrooting.

Mount the partitions
--------------------

The root partition of the Linux system that you're trying to chroot into
needs to be mounted first. To find out the device name assigned by the
kernel, run:

    # lsblk /dev/sda

You can also run the following to get an idea of your partition layout.

    # fdisk -l

Now create a directory where you would like to mount the root partition
and mount it:

    # mkdir /mnt/arch
    # mount /dev/sda3 /mnt/arch

Next, if you have separate partitions for other parts of your system
(e.g. /boot, /home, /var, etc), you should mount them, as well:

    # mount /dev/sda1 /mnt/arch/boot/
    # mount /dev/sdb5 /mnt/arch/home/
    # mount ...

While it's possible to mount filesystems after you've chrooted, it is
more convenient to do so beforehand. The reasoning for this is that
you'll have to unmount the temporary filesystems after you exit the
chroot, so this lets you umount all the filesystems with a single
command. This also allows for a safer shutdown. Because the external
Linux environment knows all mounted partitions, it can safely unmount
them during shutdown.

Change root
-----------

Mount the temporary filesystems as root:

Note:Using a newer (2012) Arch release, the following commands can be
replaced with arch-chroot /mnt/arch. You must have arch-install-scripts
installed to run arch-chroot. The following commands may still be used
if you're using a different Linux distribution.

    cd /mnt/arch
    mount -t proc proc proc/
    mount -t sysfs sys sys/
    mount -o bind /dev dev/
    mount -t devpts pts dev/pts/

If you have established an internet connection and want to use it in the
chroot environment, you may have to copy over your DNS configuration to
be able to resolve hostnames.

    cp -L /etc/resolv.conf etc/resolv.conf

Now chroot into your installed system and define your shell:

    chroot /mnt/arch /bin/bash

Note:If you see the error
chroot: cannot run command '/bin/bash': Exec format error, it is likely
that the two architectures do not match.

Note:If you see the error chroot: '/bin/bash': permission denied,
remount with the exec permission: mount -o remount,exec /mnt/arch.

Optionally, to source your Bash configuration (~/.bashrc and
/etc/bash.bashrc), run:

    source ~/.bashrc
    source /etc/profile

Optionally, create a unique prompt to be able to differentiate your
chroot environment:

    export PS1="(chroot) $PS1"

Run graphical chrooted applications
-----------------------------------

If you have X running on your system, you can start graphical
applications from the chroot environment.

To allow the chroot environment to connect to an X server, open a
terminal inside the X server (i.e. inside the desktop of the user that
is currently logged in), then run the following command which gives
permission to anyone to connect to the user's X server:

    $ xhost +

Then, to direct the applications to the X server from chroot, set the
DISPLAY environment variable inside the chroot to match the DISPLAY
variable of the user that owns the X server. So for example, run

    $ echo $DISPLAY

as the user that owns the X server to see the value of DISPLAY. If the
value is ":0" (for example), then in the chroot environment run

    # export DISPLAY=:0

Now you can launch GUI apps from the chroot command line. ;)

Perform system maintenance
--------------------------

At this point you can perform whatever system maintenance you require
inside the chroot environment. A few common examples are:

-   Reinstall the bootloader.
-   Rebuild your initramfs image.
-   Upgrade or downgrade packages.
-   Reset a forgotten password.

Exit the chroot environment
---------------------------

When you're finished with system maintenance, exit the chroot:

    # exit

Then unmount the temporary filesystems and any mounted devices:

    # umount {proc,sys,dev,boot,[...],}

Finally, attempt to unmount your root partition:

    # cd ..
    # umount arch/

Note:If you get an error saying that /mnt (or any other partition) is
busy, this can mean one of two things:

-   A program was left running inside of the chroot.

-   Or, more frequently, a sub-mount still exists (e.g. /mnt/arch/boot
    within /mnt/arch). Check with lsblk to see if there are any
    mountpoints left:

    lsblk /dev/sda

If you are still unable to unmount a partition, use the --force option:

    # umount -f /mnt

After this, you will be able to safely reboot.

Example
-------

This may protect your system from Internet attacks during browsing:

    # # as root: 
    # cd /home/user
    # mkdir myroot
    # pacman -S arch-install-scripts
    # # pacstrap must see myroot as mounted: 
    # mount --bind myroot myroot
    # pacstrap -i myroot base base-devel
    # mount -t proc proc myroot/proc/
    # mount -t sysfs sys myroot/sys/
    # mount -o bind /dev myroot/dev/
    # mount -t devpts pts myroot/dev/pts/
    # cp -i /etc/resolv.conf myroot/etc/
    # chroot myroot
    # # inside chroot: 
    # passwd # set a password 
    # useradd -m -s /bin/bash user
    # passwd user # set a password
    # # in a shell outside the chroot: 
    # pacman -S xorg-server-xnest
    # # in a shell outside the chroot you can run this as user: 
    $ Xnest -ac -geometry 1024x716+0+0 :1
    # # continue inside the chroot: 
    # pacman -S xterm
    # DISPLAY=:1
    # xterm
    # # xterm is now running in Xnest 
    # pacman -S xorg-server xorg-xinit xorg-server-utils
    # pacman -S openbox
    # # for java we need icedtea-web which requires some fonts: 
    # nano /etc/locale.gen
    # # uncomment en_US.UTF-8 UTF-8, save and exit 
    # locale-gen
    # echo LANG=en_US.UTF-8 > /etc/locale.conf
    # export LANG=en_US.UTF-8
    # pacman -S ttf-dejavu
    # pacman -S icedtea-web
    # pacman -S firefox
    # firefox
    # # firefox is now running in Xnest 
    # exit
    # # outside chroot: 
    # chroot --userspec=user myroot
    # # inside chroot as user: 
    $ DISPLAY=:1
    $ openbox &
    $ HOME="/home/user"
    $ firefox

See also: Basic Chroot

Retrieved from
"https://wiki.archlinux.org/index.php?title=Change_Root&oldid=252447"

Category:

-   System recovery
