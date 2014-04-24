Remote Arch Linux Install
=========================

This is a guide to replace a running Linux system on a remote server.
While Arch makes a good server system, it is not usually the
pre-installed distribution of choice.

Warning:Please make sure you understand each step before proceeding. It
is easy to destroy your system or to lose critical data, and your
service provider will likely charge a lot to help you recover.

Contents
--------

-   1 Introduction
-   2 Backup and Preparation
-   3 Prepare the intermediate system
    -   3.1 Create a new swap file
    -   3.2 Set old swap partition as new root partition
    -   3.3 Install the intermediate system
    -   3.4 Things to check before you boot
    -   3.5 Prepare a home for your new production server
-   4 Set up your new system
    -   4.1 Final Remarks

Introduction
------------

Many providers offer systems called rescue systems or remote consoles,
which is often just a bootdisc stored on a network card. This boots into
a rudimentary system which just exists in your RAM. Thus you will have
the ability to partition your harddrive as you like.

This document outlines the solution for servers without a rescue systems
but have a swap partition. You can disable the swap partition and set up
your intermediate system there. When you finish this tutorial you will
have a base Arch Linux, which can be accessed via SSH.

Backup and Preparation
----------------------

During the procedure you WILL ERASE ALL DATA on your former server.
Backup all your data including mails, webservers, etc. Have all
information at your fingertips. Preserve all your server configurations,
hostnames, etc.

Here is a list of data you will likely need:

-   IP address
-   hostname(s), (note: rootserver are mostly also part of the providers
    domain, check or save your /etc/hosts before you delete)
-   DNS server (check /etc/resolv.conf)
-   SSH keys (if other people work on your server, they will have to
    accept new keys otherwise. This includes keys from your Apache, your
    mail servers, your SSH server and others.)
-   Hardware info (network card, etc. Refer to your pre-installed
    /etc/modules.conf )
-   Grub configuration files.

In general, it is a good idea to have a local copy of your original /etc
directory on your local hard drive.

Prepare the intermediate system
-------------------------------

The intermediate system is the system which is used as a place where you
setup your new disc layout and install the final system. There is no
need to install more then the absolutely necessary packages in it. In
addition to the base system you will need wget to fetch some software
and an ssl server.

> Create a new swap file

If you're paranoid or have very little RAM available you might want to
add a swap file as swapspace before you disable the swap partition. Note
that you do not need running daemons such as mailserver, http-server
etc. When you stop them you can free memory at the remote machine.

The following commands create a file filed with zeros, formats it as
swap space, activates the swap file, forces writing of the buffer cache
to the disk, and then checks for active swap files.

    # dd if=/dev/zero of=/swapfile bs=1024 count=512288
    # mkswap /swapfile
    # swapon /swapfile
    # sync
    # cat /proc/swaps

> Set old swap partition as new root partition

Check cfdisk, /proc/swaps or /etc/fstab to find your swap partition.
Assuming your hard drive is located on sdaX (X will be a number).

Do the following:

Disable the swap space:

    # swapoff /dev/sdaX

Create a filesystem on it

    # fdisk /dev/sda
    (set /dev/sdaX ID field to "Linux" - Hex 83)
    # mke2fs -j /dev/sdaX

Create a directory to mount it in

    # mkdir /mnt/newsys

Finally, mount the new directory for installing the intermediate system.

    # mount -t ext4 /dev/sdaX /mnt/newsys

> Install the intermediate system

Setup the intermedia system environment for pacman following a method in
Install from Existing Linux.

> Things to check before you boot

You will have to chroot into your new system to bring up a kernel. When
you're in it you will have to setup a root password, otherwise SSH will
not let you into your system. Also your bootloader must be directed to
your new system. You might want to configure your bootloader to be able
to boot into your old system. This makes it easier to use the recovery
console in case you have one.

mount essential systems

    # mount -o bind /dev /mnt/newsys/dev
    # mount -t proc none /mnt/newsys/proc

Chroot into your new system:

    # chroot /mnt/newsys /bin/bash

Make sure you have a network and check by this method.

Now you should have pacman available to manage your system. You will
need a kernel and an ssh server to reboot into your rescue system. Once
you are installing stuff also consider the editor of your choice (nano,
joe) if you dislike vi.

    # pacman -S linux openssh

Set up a bootloader following guide in Installation guide. Set up your
bootmanager to the new system

Before proceeding double check that you:

    # start sshd  
    # set a root password

All this is necessary to get a working system. Enter reboot.

> Prepare a home for your new production server

Give the server time to reboot and then ping it to ensure you can access
it.

SSH into your new Arch system. Make sure you understand where you are -
at your former swap partition.

Create filesystems as desired and mount your new root partition to
/mnt/newsys.

     # mkdir /mnt/newsys
     # mount -t ext4 /dev/discs/disc0/part3 /mnt/newsys

Set up your new system
----------------------

At this point, follow the normal steps of Installation guide. Probably
the genfstab script won't work. In that case, you'll need to edit the
/mnt/etc/fstab file by hand. You can use the content of /etc/mtab as
reference.

Double check that you have performed all necessary steps (as for setting
up the rescue system), exit chroot, and reboot.

> Final Remarks

Now you have Arch Linux running at your server. More things need to be
done to turn it into something useful.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Remote_Arch_Linux_Install&oldid=298222"

Category:

-   Getting and installing Arch

-   This page was last modified on 16 February 2014, at 07:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
