Gparted-Live
============

GParted-live is a live Linux environment providing users with a minimal
graphical interface for GParted. It is available for download in several
formats including both .iso and .zip for users to make a bootable CD or
run directly from one's Grub menu respectively.

Contents
--------

-   1 Obtaining GParted-Live
-   2 Running GParted-Live
    -   2.1 Bootable CD
    -   2.2 Bootable USB Drive
    -   2.3 From HDD via GRUB
        -   2.3.1 Download the GParted-Live files
        -   2.3.2 Modify your GRUB config files
        -   2.3.3 Re-generate grub.cfg
        -   2.3.4 Reboot

Obtaining GParted-Live
----------------------

Several formats are available as mentioned above. See the Official
GParted webpage for more.

Running GParted-Live
--------------------

> Bootable CD

Simply download the .iso formated gparted image from the link above and
burn it to CD using your favorite image writer. If you are totally new
to Linux, you can burn an iso directly to CD from the shell. See the
Burning_with_cdrecord wiki article for instructions.

> Bootable USB Drive

Putting GParted live on a USB stick is trivial if you have the right
tool. In this case, you want unetbootin which is a very powerful
GUI-based utility that will allow you to put the GParted-live.iso onto a
USB stick and boot from it.

Warning:You will lose all your data on the USB stick so backup the data
first!

1.  Insert your USB stick you want to use and make sure its partitioned
2.  Start UNetbootin as root user
3.  Select "Diskimage/ISO" from the GUI
4.  Point it to your gparted-live.x.xx.x-x.iso
5.  Select the correct partition on your USB stick
6.  Hit OK to start and wait to umount then remove the USB stick
    (unetbootin will tell you when it is finished)

> From HDD via GRUB

Assuming you are using GRUB as your boot loader, the following will show
you how to boot directly into the GParted-Live environment from GRUB's
menu. The result is the same environment as the Live CD gives, but with
much faster boot times.

Download the GParted-Live files

Download the appropriate ISO file [GParted-Live iso] and save it to a
folder of your choosing.

Modify your GRUB config files

Warning: It is not recommended to modify /boot/grub/grub.cfg directly.
Instead, modify files in /etc/grub.d/ and use the grub-mkconfig tool.

Add the following to /etc/grub.d/40_custom, replacing the path to the
iso file (/gparted/gparted-live-0.18.0-1-amd64.iso in the example below)
with the path to the GParted iso you downloaded earlier.

    menuentry "GParted Live" {
          set isofile="/gparted/gparted-live-0.18.0-1-amd64.iso"
          loopback loop $isofile
          linux (loop)/live/vmlinuz boot=live config union=aufs noswap noprompt vga=788 ip=frommedia toram=filesystem.squashfs findiso=$isofile
          initrd (loop)/live/initrd.img
          }

Re-generate grub.cfg

Re-generate your grub.cfg file with

     sudo grub-mkconfig -o /boot/grub/grub.cfg

Warning: Visually check /boot/grub/grub.cfg and ensure that the
grub-mkconfig tool worked as expected. A misconfigured grub.cfg is
likely to be detrimental to your system's ability to boot.

Reboot

Upon rebooting, you should see an entry in GRUB called "GParted Live".

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gparted-Live&oldid=304552"

Category:

-   File systems

-   This page was last modified on 15 March 2014, at 00:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
