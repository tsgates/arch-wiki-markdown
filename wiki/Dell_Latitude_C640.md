Dell Latitude C640
==================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Specification                                                      |
| -   2 Kernel                                                             |
| -   3 Audio                                                              |
| -   4 Xorg                                                               |
| -   5 Network                                                            |
| -   6 PCMCIA                                                             |
|     -   6.1 Wireless                                                     |
|                                                                          |
| -   7 ACPI                                                               |
+--------------------------------------------------------------------------+

Specification
=============

CPU: 1,8 Ghz

RAM: 256 Mb

HDD: 20 Gb

LCD: 1024x768 ( do not know exactly)

Video: Ati Radeon Mobility 7500 - 32 Mb shared memory

Kernel
======

Get the suspend2 enabled kernel:

    pacman -S kernel26suspend2

Now we have to make the initrd image which is loaded after kernel
booting. Use the command

    mkinitcpio

and the instruction which appear after pacman-ing the suspend2 kernel

Then add the new kernel to LILO or GRUB (in my case Lilo). Be careful
not to remove your old kernel, because of troubleshooting. Just add the
new suspend2 enabled kernel to your bootloader and append the initrd
(kernel26suspend2.img) image to it.

Audio
=====

Should be automaticaly recognized.

-   Assign your user to the "audio" group so you have permission to
    adjust the volume
-   Make sure you unmute all the channels using "alsamixer"
-   use the command

    alsactl store

to save your alsa settings. Make sure you execute

    /etc/rc.d/alsa start

in the boot process. I do this at the end of the boot process, because
otherwise the settings of mixer are not being restored.

Xorg
====

-   Get the Ati open source driivers, since the proprietary driver does
    not support radeon 7500:

    pacman -S xf86-video-ati

-   Afterwords ensure you have the following modules loaded by issuing
    "lsmod"
    -   intel_agp
    -   agpgart
    -   radeon

If there is no any, make shure you load them in the above order.

-   Configure your X:

    xorgconfig

Your acceleration should be automaticaly recognized.

Network
=======

PCMCIA
======

In order to use the PCMCIA load the module

    modprobe yenta_socket

Wireless
--------

-   I use wireless pcmcia wireless card with RaLink chipset
-   Get the kernel module:

    pacman -S rt2500-suspend2

ACPI
====

I use APM instead of ACPI, because my Fn+Fx laptop keys do not work
under ACPI. The only problem is that the laptop doesn't shut down, but
only halt.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Latitude_C640&oldid=196573"

Category:

-   Dell
