iMac Aluminium
==============

I have written the following in the hope that it may help those
investigating the installation of Arch on their iMac. Parts of this
guide are specifically written for the Alu' 20" & 24" iMac.

  
 I have an aluminium 24" iMac, on which I have just (at the time of
writing) installed Arch 64bit, twice! I had a serious problem logging
into Gnome & anything that required the root password failed. I worked
around these problems but was never happy with the setup. I think that
the iMac aluminium keyboard may have caused the problem, due to it not
having a num-lock key, or an LED to indicate num-lock on/off; my
passwords were numerical. Of course I may be wrong. My second install
was done with an MS Digital Media keyboard & I do not have the above
problem, also my ctrl-alt-Fkeys work now.

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Deleting OS X?                                                     |
| -   2 Install additional bootloader                                      |
| -   3 Partitioning & Filesystems                                         |
|     -   3.1 Accessing the Ext2/3 file system from OS X                   |
|     -   3.2 The GPT partitioning scheme that Apple uses                  |
|                                                                          |
| -   4 rEFIt Re-sync                                                      |
| -   5 Install Arch                                                       |
| -   6 Installing & Configuring X                                         |
| -   7 Controlling the screen backlight and brightness                    |
|     -   7.1 backlight.c                                                  |
|     -   7.2 Brightness control on a 2011 27 inch iMac                    |
|                                                                          |
| -   8 Getting sound to work right                                        |
|     -   8.1 The iMac 20" & 24" models                                    |
|     -   8.2 The imac7,1 model:                                           |
|     -   8.3 The imac12,2 27" 2011 model                                  |
+--------------------------------------------------------------------------+

Deleting OS X?
--------------

Some people seriously consider dropping OS X altogether. I personally
think that there is a good reason to keep a small OS X partition, as it
allows you to be able to do firmware updates. Some people use an
external USB or Firewire drive with which to boot OS X for the firmware
updates, & I have heard that people have been able to do it via optical
drive, from experience I do not know about these other methods.

  

Install additional bootloader
-----------------------------

Apple computers have a built-in bootloader that can be accessed by
holding down the 'ALT' key when switched on. This allows you to boot
from CD, HDD and via WiFi. If your iMac has a separate EFI partition,
this menu will also allow you to boot Archlinux directly (follow these
instructions: GRUB#Create_GRUB2_Standalone_UEFI_Application). This
built-in bootloader sometimes has problems booting from USB, so it might
be a good idea to install rEFIt [1] on your OS X partition. You will
probably want to lower the timeout and make linux the default option,
for that you must edit the refit.conf file [2].

After succesfully installing Arch and Grub you may remove rEFIt (first
make sure your stand-alone UEFI app shows up in the Apple bootloader).
To change the default boot-option to Archlinux, you need to 'bless' the
earlier created stand-alone UEFI app. It is best to rename the created
'EFI/arch_grub/grubx64_standalone.efi' to 'EFI/BOOT/BOOTX64.EFI', then
run the following command from MacOSx, after mounting the EFI partition:

    sudo bless --folder=/Volumes/EFI --file=/Volumes/EFI/efi/BOOT/BOOTX64.EFI --setBoot

When booting through the Apple bootloader (instead of rEFIt) you will be
booting in full EFI mode, instead of BIOS compatibility. This means you
will probably need to boot your archlinux-fallback image the first time;
and update your mkinitcpio to succesfully switch from BIOS > EFI.

Partitioning & Filesystems
--------------------------

There are multiple ways to repartition the iMac drive, my favourite
(probably because it is the easiest & being graphical it is most likely
the safest) is to boot the Ubuntu 7.10 (or later) LiveCD & run GParted
from the desktop menu. I have shrunk the OS X, HFS+ partition, created
Ext3, JFS & Linux Swap partition, deleted & moved partitions on the iMac
using GParted & the Ubuntu LiveCD. Great stuff! The only present
limitation that GParted has with the HFS+ file system, is that it can
only shrink the HFS+ file system & can not enlarge it. I'm sure it won't
be too long & this limitation won't exist either.

Just a note on using GParted, or any other GUI type of partition
management tool, it is generally accepted to be good safe practice to
only Apply ONE process at a time. What that means for those unfamiliar
with GParted (& the other applications of it's ilk) is you can give it
multiple instructions which it stores up until you hit the "Apply"
button, after which it goes through the instructions one after the
other. If this doesn't make sense now, it very quickly will on using
GParted.

  
 My iMac partition scheme is as follows:

Partition...Filesystem......Size.........Mountpoint

sda1 ........ *FAT32* ....... 200Mb .... EFI system partition - While
the ESP looks like a FAT32 volume, it is actually an EFI file system,
which you want to know how to replace before you delete it. This means
do not delete it unless you are sure that you know what you are doing,
as it may become essential to Apple firmware updates in the future.
Currently the ESP is empty & the firmware boots OS X directly!? At least
it is only 200Mb's wasted drive space, though more importantly it counts
as one of the four partitions that can be seen by Apple's newly adopted
GPT partitioning scheme. More on GPT in the following paragraph.

sda2 ......... HFS+ ........... 50Gb ..... OS X - After thinning out OS
X some & keeping tools I use plus iWork, CrossOver Games & Guild Wars, I
have about 25Gb of free space to play with here, & for the odd game that
may arrive in the future (Guild Wars 2). :D

sda3 ......... Ext3 ............ 15Gb ...... / - Arch - there is
currently 12Gb free, it is a new install though.

sda4 ......... JFS .............. 30Gb ...... /home - that should be
more than enough space for me there, & I can always resize with GParted.

sda5 ......... Linux Swap .... 2Gb ..... swap - rarely if ever used, but
I have the space. It is questionable as to whether this partition needs
to exist at all.

Having now used Arch on the iMac with 1GB of RAM for some months I
deleted the /swap partition, as for my uses it was never needed.

sda6 ......... Ext3 ............ 200Gb ...... /thevoid - storage for
video's music, unsafe backup, whatever...

Accessing the Ext2/3 file system from OS X

I have been using the ExtFS for Mac from Paragon-Software, it is a
commercial package that is simple to install, configure & auto mounts
any Ext2/3 file system partitions in a read/write fashion when you boot
up OS X, 10.4.11 or later on an Intel Mac. It has been working superbly
for me, to the point that I have reformatted my 200GB partition called
/thevoid from JFS to Ext3 to give me access to it from OS X. For anyone
interested you can get a trial version on the Paragon-Software website.

There is also a free software application that is apparently somewhat
outdated, but works with Ext2/3 & is working with OS X, 10.5, its name
is ext2fsx. I have not used ext2fsx so I can't speak about it from
experience.

The GPT partitioning scheme that Apple uses

[3] used to limit OS X, to only being able to use 4 partitions from
which you could boot a system. If you haven't allowed your older Mactel,
Apple machines to upgrade for quite some time then their firmware is
still suffering under this limitation (I'm told) & you should be aware
of this fact.

Therefore you need to be sure to install your boot loader i.e.
GRUB/Lilo, & any other partition that you may want OS X, to see (like a
shared FAT32 data drive) on sda3 & sda4, Windows must also be on sda3 or
sda4.

Partitions beyond Apple's (previously) imposed limit of 4 can still be
created & used, e.g. Linux Swap, & other partitions, but they won't be
accessible by OS X, or directly bootable, though I see no reason why a
boot loader like GRUB positioned on sda3 or sda4 could not boot other
OS's on partitions numbered greater than sda4.

  
 This certainly does place limitations on what we can do if we do not
allow our systems to accept the appropriate Apple online upgrades.

  
 If you require more than this limited scheme will allow you, you could
do away with OS X, & set up the drive on MBR only, using an external
drive with OS X on it to update the firmware.

For those that DO accept the online upgrades from Apple, it would seem
that you can now place GRUB, Lilo or any other boot loader in partitions
beyond the 4th. I say "would seem", as I have been told this (& not read
the technical documentation), not read it, & am not prepared to test it
no "my" sacrosanct Arch machine. :)

The above section will be severely modified, when I have confirmed that
Apple have indeed made these changes to their firmware.

So just to sum up, if you are using a machine with out of date firmware:
& you have need to use sda3 & sda4, be sure to put any swap partitions
on a partition number greater than sda4. Also, it is worth considering
not using a swap partition at all, as the only computers running
Linux/BSD with 1 gigabyte of RAM that use their swap file are doing
intensive specialized work such as video editing, sound
recording/editing, 3D modelling...

rEFIt Re-sync
-------------

When partitioning is finished you must restart the iMac & re-sync your
partitions with rEFIt, which is quick & easy: You choose to start the
partitioning tool in the rEFIt boot-menu & follow the very simple
instructions there. rEFIt may prefer to have partitions in numerical
order on the drive, i.e. sda1, sda2, sda3, sda4, sda5, sda6 ... & not
shuffled. This is unconfirmed, any feedback on the subject will be
appreciated.

Then reboot & hold down the C key, or wait as I do for the rEFIt
boot-menu to appear & choose to boot the Arch install CD.

This is not necessary when booting through EFI.

Install Arch
------------

I used both the Arch Beginners Guide Beginners_Guide & the Official
Install Guide Official_Arch_Linux_Install_Guide. I used the Core install
from the CD & updated later. (The FTP install is a quicker method as it
installs the latest packages directly over the internet.)

The CD install & network setup went perfectly for me. The Beginners
Guide has all that was necessary for my install, though I used the
Official Guide to further my understanding, as well as other pages in
the Arch wiki & elsewhere.

Installing & Configuring X
--------------------------

When installing the Xserver, Xorg I installed as though I was not going
to use the proprietary ATi drivers (now called Catalyst), this allowed
me to use both the vesa & the xf86-video-ati open source drivers. I only
did this out of what turned out (at that time) to be a false sense of
fear of the approaching fight to get ATi's Catalyst drivers to work.

Having now had a couple of years experience with Arch since I wrote the
above, I have learned that Catalyst can be a real can of worms on Arch
in particular. This is due to the way that Arch uses cutting edge
versions of packages & the rolling release upgrade system. Which can
cause there to be occasional incompatibilities between Catalyst & the
version of packages that Arch uses.

This problem can be relatively easily side stepped once you know how. I
recommend the "Catalyst Bar & Grill" [4] thread in the Arch forum. It is
the best place to find out where things are up to currently, before you
install Catalyst.

Due to its being deemed too unreliable to be kept in the [extra] repo,
Catalyst must now be installed via AUR .

The good news is that the open-source driver support is as I write this,
improving dramatically due to AMD having opened up the tech' info' on
all of the ATi GPUs, & also of course because of the dedicated team that
has been working so hard on implementing this new found knowledge for
the open-source community.

I highly recommend using the xf86-vide-ati driver, as the 2D is the best
you can get & the 3D is continually improving dramatically. From the
stable repo's 3D is very useful right now.

Controlling the screen backlight and brightness
-----------------------------------------------

The iMac lacks physical buttons for controlling the backlight of the
screen. Depending on the version/model of the computer and how Linux is
booted, the brightness of the backlight may or may not be easily
controllable. See Backlight for various options.

> backlight.c

Below is the C code for a little program that adjusts the brightness on
many LCD Apple screens (I have been using it now for over 3 years). It
is easy to compile & setup using the following instructions.

  
 The instructions follow:

Copy & paste the C code (found below these instructions) to your /home.
Save the code as a file, backlight.c.

Now open a terminal in the directory where backlight.c is located.

Type the following in the Terminal:

    gcc -o backlight backlight.c

You now have a program called backlight. It should adjust the
brightness.

To change the brightness, you have to have direct access to video
memory, which means that you have to be superuser (root).

Type su, then your root password when prompted.

Now test the program by typing:

    ./backlight 10

in the terminal.

You can give it values from 1 to 15. Find a value you like.

Now enter the following in the Terminal:

    cp backlight /usr/local/bin/

Which copies the program to the standard location for user installed
programs.

Next, to run it at startup. Still as root, edit /etc/rc.local. Add a
line saying /usr/local/bin/backlight N, where N is the number code you
want for the brightness.

That should do it.

Source:

    /*
    * Apple Macbook Pro LCD backlight control
    *
    * Copyright (C) 2006 Nicolas Boichat <nicolas @boichat.ch>
    * Copyright (C) 2006 Felipe Alfaro Solana <felipe_alfaro @linuxmail.org>
    *
    * This program is free software; you can redistribute it and/or modify
    * it under the terms of the GNU General Public License as published by
    * the Free Software Foundation; either version 2 of the License, or
    * (at your option) any later version.
    *
    * This program is distributed in the hope that it will be useful,
    * but WITHOUT ANY WARRANTY; without even the implied warranty of
    * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    * GNU General Public License for more details.
    *
    * You should have received a copy of the GNU General Public License
    * along with this program; if not, write to the Free Software
    * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
    *
    */

    #include <stdio.h>
    #include <sys/io.h>
    #include <stdlib.h>

    void init()
    {
        if (ioperm(0xB2, 0xB3, 1) < 0)
        {
            perror("ioperm failed (you should be root).");
            exit(2);
        }
    }

    int get_current_value()
    {
        outb(0x03, 0xB3);
        outb(0xBF, 0xB2);
        char t = inb(0xB3) >> 4;
        return t;
    }

    int calculate_new_value(const char *arg)
    {
        int val, new = atoi(arg);

        if (arg[0] == '+' || arg[0] == '-')
            val = new + get_current_value();
        else
            val = new;

        if (val > 15)
            val = 15;
        else if (val < 1)
            val = 1;

        return val;
    }

    int main(int argc, char** argv)
    {
        if (argc > 2)
        {
            printf("Usage:\n");
            printf("%s : read current value\n", argv[0]);
            printf("%s value : write value [0-15]\n", argv[0]);
            exit(1);
        }

        init();

        if (argc < 2)
        {
            printf("Current value : %d\n", get_current_value());
            exit(0);
        }

        if (argc == 2)
        {
            int value = calculate_new_value(argv[1]);
            outb(0x04 | (value << 4), 0xB3);
            outb(0xBF, 0xB2);
            printf("new value: %d\n", value);
        }

        return 0;
    }

> Brightness control on a 2011 27 inch iMac

This program does not work on the 27" iMac released during spring 2011
(model 12,2). On this mac, the Backlight#ACPI can be used on the CLI of
the Arch Linux installation media. However, after the OS is installed
and booted using either rEFIt or Grub2 with BIOS
compatibility/emulation, the screen no longer responds to ACPI calls or
the backlight program. Currently, x86_64 EFI boot sadly does not work
with grub2 and the Arch kernel on the 12,2 iMac. The kernel loads but
does not find the SATA disk (likely some problem with initramfs) and
thus I have been unable to check the ACPI backlight method on the
installed OS.

An ok workaround until this is fixed is the Backlight#redshift method,
which dims the screen well.

Update : If you boot Legacy with Grub2 by holding down "option" at
startup and selecting the "Windows" disk, your backlight control will
work. Booting using EFI or rEFIt disables the backlight control.

Getting sound to work right
---------------------------

Sound does not always work nice out of the box using Linux on an iMac.
For instance, the sound can appear "thin" or tinny with too much treble
and too little base due to the built in subwoofer being muted by default
or the OS may not detect that the headphones have been plugged in. The
fixes are generally to load sound drivers with extra model flags
specifying relevent iMac model by manipulating
/etc/modprobe.d/sound.conf or /etc/modprobe.d/modprobe.conf, restart the
computer or the sound system and use alsamixer to make sure all desired
channels are not muted.

> The iMac 20" & 24" models

Add the following to /etc/modprobe.d/sound.conf

    options snd-hda-intel model=imac24

> The imac7,1 model:

The option above may produces tiny sound on imac7,1. To have OSX like
rich sound on imac 7,1, add following to /etc/modprobe.d/modprobe.conf

    options snd-hda-intel model=mb31

Using the above gives a workable alsamixer. I've found that using VLC &
its mixer is very helpful when watching DVD's. I have not tested the
line out or mic, though I believe that they are working properly with
this configuration.

> The imac12,2 27" 2011 model

Starting with the Linux kernel version 3.3 (at its release candidates)
the following setting should be used in /etc/modprobe.d/sound.conf to
handle headphone detection correcly:

    options snd-hda-intel model=imac27_122

* * * * *

A forum thread regarding installation of Arch Linux on the iMac can be
found here:

https://bbs.archlinux.org/viewtopic.php?id=35355

Retrieved from
"https://wiki.archlinux.org/index.php?title=IMac_Aluminium&oldid=238991"

Category:

-   Apple
