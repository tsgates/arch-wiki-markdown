Installing Arch with only Wireless Network Interface
====================================================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: The wireless     
                           drivers and utilities    
                           are now available in the 
                           installation media. See  
                           Beginners' Guide#Package 
                           groups (Discuss)         
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction and Disclaimers                                       |
| -   2 Install Base System                                                |
| -   3 Boot using Live CD                                                 |
|     -   3.1 Configure Wireless connection - Simple Knoppix Example       |
|                                                                          |
| -   4 Mount Arch Linux Volume                                            |
| -   5 Set resolv.conf properly                                           |
| -   6 Chroot into your system                                            |
| -   7 Check Wireless Connection                                          |
| -   8 Install Necessary Wireless Tools                                   |
| -   9 Reboot!                                                            |
| -   10 References                                                        |
+--------------------------------------------------------------------------+

Introduction and Disclaimers
============================

This guide will show you how to install Arch Linux if you have only a
wireless network interface. It is useful because the ISO images
currently available do not include certain wireless tools like madwifi
or ndiswrapper. I have used this method to install Arch Linux on various
PCs that have no immediate connection to hardwire Ethernet.

These notes are spartan. They aren't written to explain to you how to
install or upgrade your Arch Linux system. Nor are they written to
explain how to configure a wireless adapter. Other Arch wikis on
installation and wireless configuration can help you with these things.

It assumes you know how to use the basic wireless tools like "iwconfig",
and that you know which drivers or wireless packages you need to
install. Madwifi is mentioned in my example, you may be using that, or
ndiswrapper, or something else. Ndiswrapper ought to work, too, but
you'll have to add the step to install the vendor drivers to the Arch
base system hard drive somehow.

It uses a live Knoppix CD. I usually have one around for emergencies.
You can do the same thing using any live CD that will recognize and
allow you to configure your wireless adapter. I make reference to
specific hard drive partitions for example. You may need to adjust for
your circumstances.

Install Base System
===================

Boot and install the base system from the Arch Linux installation CD.
The base is all you should need to get started. Make note of the hard
drive to which you install, in my case sda1. You should reboot following
the installation, just to make sure you've got a stable installation.

Boot using Live CD
==================

Now, reboot the computer again, this time using the Knoppix CD. Knoppix
does a good job, usually, of identifying wireless adapters. It picks up
mine and I've cards from 3 vendors in 4 configurations.

Other live CDs will work, if you know how or it will automatically
detect your wireless interface.

Configure Wireless connection - Simple Knoppix Example
------------------------------------------------------

You can either use a su terminal session or the Knoppix wireless
configuration tools to configure the network adapter. I usually use a
super user command prompt. Knoppix doesn't seem to have a root password,
so you get a root prompt by just entering "su":

    su
    iwconfig ath0 essid MYESSID
    iwconfig ath0 key ...
    pump -i ath0

Knoppix uses "pump" to acquire an access point. My Arch systems
typically use "dhcpcd". Ping www.google.com, or something, to test the
network access. Don't continue until you have a good connection.

Mount Arch Linux Volume
=======================

Assuming you still have that super user terminal prompt open (if not,
open one), mount the hard drive with the Arch base system. For example:

    mount /dev/sda1 /mnt/sda1

Set resolv.conf properly
========================

Edit /etc/resolv.conf to add your domain name servers configurations. If
you do not know them, get an active copy of the file that Knoppix has
created.

    cp /etc/resolv.conf /mnt/sda1/etc/

Chroot into your system
=======================

Bind devices and establish root relative to the Arch Linux base
installed system. This is the magic, well not magic so much, but fun
nonetheless.

    mount -t proc none /mnt/sda1/proc
    mount -o bind /dev /mnt/sda1/dev
    chroot /mnt/sda1 /bin/bash
    source /etc/profile

You should now be as if you'd booted to the Arch base system, and have
access to all of the Arch utilities, read: pacman.

Check Wireless Connection
=========================

The cool thing is that the wireless connection you established above
should still be active. Check it again by pinging google. If you have a
problem, you may have skipped or did something wrong above (step 6
maybe?). No need to continue until you resolve it.

Install Necessary Wireless Tools
================================

You may need to edit /etc/pacman.conf to include the "extra" repository.
This is where madwifi and ndiswrapper packages are currently deposited.
Synchronize and install the package you need.

    pacman -S madwifi

Reboot!
=======

Now reboot your computer and you should be all set. Make sure you take
out the Knoppix or other live CD when you reboot. After booting to Arch,
you should be able to configure your wireless connection using any of
the other prescribed methods. Good luck!

References
==========

Knoppix home page if you need to download

    http://www.knoppix.org/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_Arch_with_only_Wireless_Network_Interface&oldid=196236"

Category:

-   Getting and installing Arch
