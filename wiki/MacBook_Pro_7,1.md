MacBook Pro 7,1
===============

> Summary

Details the installation and configuration of Arch Linux on Apple's
MacBook Pro 7,1

> Related

MacBook

MacBookPro

> MacBook_Pro_7,1

MacBook_Pro_8,1_/_8,2_/_8,3_(2011_Macbook_Pro)

MacBook_Pro_9,2_(Mid-2012)

Installation
------------

Using mid 2012/12 installation media, I primarily followed this GIST in
conjunction with the MacBook EFI installation instructions to install an
x86_64 system. The GRUB2 page is invaluable. Installing rEFIt is not
necessary.

As per GRUB2, it is recommended to read the UEFI, GPT and UEFI
Bootloaders pages before trying any of this on your machine.

Network
-------

Wireless Setup provides instructions on how to identify your card, but
if your MacBook Pro 7,1 is like mine then you'll head to Broadcom
Wireless and use this command.

    $ lspci -vnn -d 14e4:

If from this you discover that your full PCI-ID is [14e4:432b], then the
following advice applies to you: Don't waste time on the b43 driver.
I've been fiddling with it for weeks, and switching to broadcom-wl made
all the problems go away. broadcom-wl might make your device names
funky, but that's easily fixed with the udev rule documented on Broadcom
Wireless.

I also recommend netctl.

Video
-----

According to the Debian Wiki and the other sources I've searched out,
the MacBook Pro 7,1 has an NVIDIA GeForce GT 320M in it.

I have yet to get the video driver to work. The monitor seizes up when I
startx with the NVIDIA drivers, but if you have a preexisting ssh
connection you should be able to kill Xorg and start again.

To be continued..

Retrieved from
"https://wiki.archlinux.org/index.php?title=MacBook_Pro_7,1&oldid=253717"

Category:

-   Apple
