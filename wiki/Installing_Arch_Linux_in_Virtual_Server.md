Installing Arch Linux in Virtual Server
=======================================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Referenced       
                           articles changed a lot   
                           since the creation of    
                           this article (March      
                           2011), some updated (16. 
                           Dec 2012) installation   
                           instructions can be      
                           found on GitHub.com      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page describes, how to install Arch Linux on a virtual server from
a webhoster.

Installing an Arch Linux server on JiffyBox
-------------------------------------------

The following was tested on a JiffyBox but should work also for other
providers with Xen virtualisation.

Create an JiffyBox account. I selected Ubuntu 10.04 since squashfs
needed later is too old on Debian Lenny. I think Linode works similar.
However, they provide Arch Linux by default.

-   Create additional hard disk (i.e. 20GB)
-   Add hard disk to the current profile

I did the stuff from:
https://wiki.archlinux.org/index.php/Install_from_Existing_Linux#Preparing_the_Installation_Environment

I needed to install squashfs tools:

    apt-get install squashfs-tools

Mount the empty arch partition:

     mount /dev/xvdc /mnt/arch/

aif does not find the partitions (/dev/xvdc) You have to mount it
manually and do the following hack to aif:
http://colinux.wikia.com/wiki/Howto:_ArchLinux_install_from_iso_with_rescue_fs#Stage_2:_Prepare_the_final_filesystem_and_install_ArchLinux_on_it

Copy /etc/resolf.conf

Chroot in the new OS:
https://wiki.archlinux.org/index.php/Install_from_Existing_Linux#Update_and_Install_packages_from_host_system_via_chroot

Install openssh and add it in rc.conf

Allow ssh from extern:
https://wiki.archlinux.org/index.php/Beginners_Guide#.2Fetc.2Fhosts.deny_and_.2Fetc.2Fhosts.allow

Change /boot/grub/menu.lst to:

    # (0) Arch Linux
    title  Arch Linux  [/boot/vmlinuz26]
    root   (hd0)
    kernel /boot/vmlinux root=/dev/xvda ro
    initrd /boot/kernel26.img

Add the following to /etc/fstab:

    /dev/xvdb swap swap defaults 0 0                                                
    /dev/xvda / ext3 defaults 0 1 

Uncomment the following line in /etc/inittab:

    h0:2345:respawn:/sbin/agetty -8 38400 hvc0 linux

Create an new JiffyBox Profile with kernel pvgrub64

pvgrub does not know lzma compression of the kernel. Thus booting will
fail. Thus the "raw" kernel hast to be copied to /boot form
/usr/src/linux-*/vmlinux

Note: I had problems using the current 2.6.37 kernel and switched back
to 2.6.36.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_Arch_Linux_in_Virtual_Server&oldid=270280"

Category:

-   Getting and installing Arch

-   This page was last modified on 8 August 2013, at 08:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
