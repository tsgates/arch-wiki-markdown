Sony Vaio VGN-B3VP
==================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Out of date.     
                           Info already covered by  
                           Beginners' guide.        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This wiki entry describes the installation of ArchLinux on a Sony Vaio
VGN-B3VP laptop. The procedure should be the same for other VGN-B
laptops, quite similar for many Vaio's (series VGN especially), and once
completed it might help as a guideline for laptop installations in
general.

Contents
--------

-   1 System Specs
-   2 Basic Installation
    -   2.1 GRUB Configuration for 1024x768 in console
    -   2.2 Power Saving
    -   2.3 X.org Configuration
    -   2.4 Synaptics Mouse Driver
    -   2.5 LCD Screen Dimming
    -   2.6 Audio
    -   2.7 Wireless Network
-   3 Links

System Specs
------------

Vaio VGN-B3VP is a small (14.1") laptop that weighs 2.3kg and it is
loaded with the following:

-   Pentium M 1.6GHz proccessor
-   512mb Ram
-   60gb HDD
-   Wireless & Wired Lan
-   X-Black lcd screen 14.1"
-   Intel 855 graphics chipset with 64mb shared ram
-   DVD+-RW Double Layer
-   2 USB & 1 Firewire Port
-   One PCMCIA slot
-   MemoryStick reader

Sony sells it with estimated battery life of 8 hours... With some nice
management that we will try to explain in here you will pass 4 hours!

lspci gives this output:

    00:00.0 Host bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
    00:00.1 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
    00:00.3 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
    00:02.0 VGA compatible controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02)
    00:02.1 Display controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83)
    00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 03)
    00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 03)
    00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
    00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 03)
    02:04.0 CardBus bridge: Texas Instruments PCI7420 CardBus Controller
    02:04.2 FireWire (IEEE 1394): Texas Instruments PCI7x20 1394a-2000 OHCI Two-Port PHY/Link-Layer Controller
    02:04.3 Mass storage controller: <pci_lookup_name: buffer too small>
    02:08.0 Ethernet controller: Intel Corporation 82801DB PRO/100 VE (MOB) Ethernet Controller (rev 83)
    02:0b.0 Network controller: Intel Corporation PRO/Wireless 2200BG (rev 05)

The laptop is also labeled (at the bottom) PCG-5B1M. This might be the
chassis code number, since it is the same with the VGN-B1VP.

Basic Installation
------------------

Boot with your Arch cd-rom and install the system! Nothing special here,
but in case you are a first-timer in arch or Linux I will cover some
stuff. You can partition your disc any way you like, only "/" and swap
are needed for a correct Linux installation. As a general guideline you
need to now that your swap area is good to be 2-3 times your ram size.
hda5 (everything more than hda4 actually) indicates a logical partition.
Hard disks can have 4 primary partitions maximum, or less primary and
one logical. Inside the logical partition more partitions can be added.
If you want more than 4 partitions total you should use logical
partitions. Auto configuration of the hard disk is always an option (and
not a bad one) if you do not care of loosing all your data.

My partition table is like this:

    /hda1  /boot  64mb (also market as bootable from cfdisk)
    /hda5  swap   2048mb
    /hda6  /var   4096mb
    /hda7  /home  40961mb (~41gb)
    /hda8  /      12839mb (~2.8gb)

Install the packages you want, install a kernel and a boot loader. I
always prefer a base installation and GRUB (placed in the MBR of hda).
But you should feel free to to your own installation

> GRUB Configuration for 1024x768 in console

In the GRUB configuration, it is not a bad idea to add vga=773 at the
end of your kernel line. This way once your laptop boots into console
you will have a 1024x768 resolution (handy and nice)

    # (0) Arch Linux
    title  Arch Linux
    root   (hd0,0)
    kernel /vmlinuz-linux root=/dev/hda8 ro vga=773
    initrd /initramfs-linux.img

> Power Saving

See CPU Frequency Scaling, Laptop Mode Tools

> X.org Configuration

See Xorg

> Synaptics Mouse Driver

Your Vaio is using a synaptics touchpad, although it works in X without
drivers it is better to add them, after all they are installable through
pacman. After that you should be able to scroll down by simply rolling
your finger in the right area of the touchpad (like the windows driver)

    pacman -S xf86-input-synaptics

> LCD Screen Dimming

By lowering your LCD's brightness you can gain battery life and reduce
eye fatigue. There are many sites on the Internet explaining how to dim
the brightness on your Vaio, however most of the sites mention info for
older laptops, and not for the VGN series.

Simply add the sony_laptop module to the list of modules in rc.conf, and
then reboot. Screen dimming applets (such as the LCD Brightness applet
for Gnome Panel) should then work correctly.

> Audio

See ALSA

For your card to work correctly you must mute the External Amplifier. To
do so run alsamixer (from alsa-utils). Find the "EXTERNAL" option and
mute it. Also unmute and give a setting in "Master" and "PCM" (give
something not to loud, just an option to have after every boot, values
about 40 will do fine)

See Alsa#Restore ALSA Mixer settings at startup to make the settings
persistent between boots.

> Wireless Network

These modules are fully supported in the kernel, but they require
additional firmware. See Wireless network configuration for detail.

Links
-----

For More Info about Linux & Laptops:

-   This report is listed at the TuxMobil: Linux Laptop and Notebook
    Installation Guides Survey: Sony.
-   http://www.linux-on-laptops.com

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sony_Vaio_VGN-B3VP&oldid=302851"

Category:

-   Sony

-   This page was last modified on 2 March 2014, at 08:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
