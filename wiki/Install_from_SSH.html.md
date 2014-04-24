Install from SSH
================

Contents
--------

-   1 Intro
-   2 Boot from Media
-   3 Setup the Live Environment to use SSH
-   4 Connect to the Target PC via SSH
    -   4.1 Notes
-   5 Next Steps

Intro
-----

This article is intended to show users how to install Arch remotely via
an SSH connection. Consider this approach over the standard one in
scenarios such as the following:

Setting up Arch on...

-   HTPC without a proper monitor (i.e. an SDTV).
-   A PC located in another city, state, country (friend's house,
    parent's house, etc.)
-   A PC that you would rather setup remotely, for example from the
    comfort of one's own workstation with copy/paste abilities from the
    Arch Wiki.

Note:The first two steps require physical access to the machine.
Obviously, if physically located elsewhere, this will need to be
coordinated with another person!

Boot from Media
---------------

Boot into a live Arch environment via the Live CD/USB image.

Setup the Live Environment to use SSH
-------------------------------------

Note: The following commands should be executed as the root user, hence
the # before the commands.

One should be logged in as root at this point. (This is the default user
when running the livecd)

First, setup the network on the target machine.

Assuming a wired connection, running dhclient or dhcpcd is sufficient to
get a lease. For more info, visit configuring network.

If on a wireless connection, see Wireless network configuration and
Wpa_supplicant for details on establishing a connection to your access
point.

Secondly, start the openssh daemon:

    # systemctl start sshd

Finally, setup a root password which is needed for an ssh connection;
the default arch password for root is empty.

    passwd

Connect to the Target PC via SSH
--------------------------------

Connect to the target machine via the following command:

    $ ssh root@ip.address.of.target

From here one is presented with the live environment's welcome message
and is able to administer the target machine as-if sitting at the
physical keyboard.

    ssh root@10.1.10.105
    root@10.1.10.105's password: 
    Last login: Thu Dec 23 08:33:02 2010 from 10.1.10.200
    [root@archiso ~]#

> Notes

-   If the target machine is behind a firewall/router, the default ssh
    port of 22 will obviously need to be forward to the target machine's
    LAN IP address. The use of port forwarding is not covered in this
    guide.
-   One can edit /etc/ssh/sshd_config on the live environment prior to
    starting the daemon for example to run on a non-standard port if
    desired.

Next Steps
----------

The sky is the limit. If the intent is to simply install Arch from the
live media, follow the guide at Installation guide. If the intent is to
edit an existing Linux install that got broken, follow the Install from
Existing Linux wiki article.

Want grub2 or the ability to use GPT hard drives?

-   Manually partition the target HDD/SDD using the gdisk utility
    installed via pacman -S gdisk before starting the arch installer and
    when presented with the option to install a boot loader in the
    installation framework, simply answer no and drop back to the live
    environment's root prompt.
-   Installation of grub2 is trivial at this point. Simply chroot into
    the fresh arch install (default pre-mounted if coming out of the
    installer) then install and setup grub2:

    cd /mnt
    rm console ; mknod -m 600 console c 5 1
    rm null ; mknod -m 666 null c 1 3
    rm zero ; mknod -m 666 zero c 1 5
    mount -t proc proc /mnt/proc
    mount -t sysfs sys /mnt/sys
    mount -o bind /dev /mnt/dev
    chroot /mnt /bin/bash

Now inside the fresh Arch chroot:

    pacman -S grub2
    grep -v rootfs /proc/mounts > /etc/mtab

Edit /etc/default/grub to your liking. Install grub and generate a
grub.cfg

    grub-install /dev/sdX --no-floppy
    grub-mkconfig -o /boot/grub/grub.cfg

Note:The above assumes that if the user intends to boot from a GPT disk,
the user has fully read and understood the aforementioned wiki articles
and has made a 1M partition ef02 for grub2.

When ready to reboot into the new Arch install, exit the chroot and
unmount the partitions prior to a reboot of the system.

    exit
    umount /mnt/boot   # if mounted this or any other separate partitions
    umount /mnt/{proc,sys,dev}
    umount /mnt

Retrieved from
"https://wiki.archlinux.org/index.php?title=Install_from_SSH&oldid=303416"

Categories:

-   Getting and installing Arch
-   Secure Shell

-   This page was last modified on 6 March 2014, at 21:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
