Dell Vostro 1320
================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page is about setting up Arch Linux on the Dell Vostro 1320 laptop,
which has replaced the former Dell Vostro 1310. Basically it runs just
fine, although there are some things you should know. Furthermore is is
advisable to read the article about laptops to get a idea about the
topic in general.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Hardware                                                           |
|     -   2.1 Overview                                                     |
|     -   2.2 CPU                                                          |
|     -   2.3 Graphics                                                     |
|         -   2.3.1 NVIDIA® GeForce™ 9300M GS                              |
|         -   2.3.2 GMA X4500 HD                                           |
|                                                                          |
|     -   2.4 Multimedia                                                   |
|         -   2.4.1 Audio                                                  |
|         -   2.4.2 Webcam                                                 |
|         -   2.4.3 Biometric Fingerprint Reader                           |
|         -   2.4.4 Extra Keyboard Keys                                    |
|         -   2.4.5 Card Reader                                            |
|                                                                          |
|     -   2.5 Wireless Lan                                                 |
|         -   2.5.1 Dell Wireless 1397 Mini-Card                           |
|         -   2.5.2 Dell Wireless 1510 Mini-Card                           |
|         -   2.5.3 Intel Pro Wireless WI-FI 5100                          |
|         -   2.5.4 Intel WiFi Link 5300 Mini-Card                         |
|                                                                          |
|     -   2.6 Bluetooth                                                    |
|         -   2.6.1 Dell™ Wireless 355 Bluetooth® Module ROW               |
|                                                                          |
| -   3 Issues                                                             |
|     -   3.1 Suspend                                                      |
|     -   3.2 Framebuffer                                                  |
|     -   3.3 Card Reader                                                  |
+--------------------------------------------------------------------------+

Installation
============

It is highly recommendable to setup Windows Vista first, because during
the setup the region code of the dvd drive is set.

If you want to install Arch Linux over a wireless connection you have to
setup the connection manually. Since kernel 2.6.24 and above are
containing the appropriate drivers already, it should work with both the
"Netinstall ISO" as well as the "Core ISO", although using the
"Netinstall ISO" is the preferred install media for Arch Linux. Don't
forget to choose the source "net" and the wlan interface (normally
wlan0).

Apart from that you can follow the Beginners Guide, which should deliver
you a good insight how to install Arch Linux.

Further attention has to be drawn during the partitioning, as Dell uses
an uncommon partition table, which may you run into some trouble. You'll
get a "FATAL ERROR", whenever you try to partition "/dev/sda" using the
setup. Therefore switch to another terminal (Ctrl + Alt + F2, for
instance) and delete the partition table using "fdisk /dev/sda". Follow
the program options. More instructions can be found in the man page or
the help option (m). It is sufficient to delete all partitions (and
writing the table to the disc), from there on you can use the setup in
the first terminal again (Ctrl + Alt + F1).

Note: When you remove all partitions the Dell Utility won't work
anymore, so consider to leave the first partition, which contains the
utility program. However the partition can be recreated. You can also
run the diagnostic utility from an usb stick or a cd.

Hardware
========

This section is about getting the hardware of the Dell Vostro 1320
running properly. Generally speaking the hardware is supported just
great, but due to the possibility of customisation (from Dell) not all
of the components have been tested (yet).

Overview
--------

A quick overview which components do work correctly, and which don't.
Look at the appropiate section in order to get more details about a
component.

Dell Vostro 1320 - Overview of the hardware support

Graphics

NVIDIA® GeForce™ 9300M GS Graphic Card

> working

Integrated GMA X4500 HD Graphics

untested

Multimedia

Audio

> working

Webcam

> working

Biometric Fingerprint Reader

untested

Extra Keyboard Keys

working

Card Reader

working

Wireless Lan

Dell Wireless 1397 Mini-Card (802.11 b/g)

reported working

Dell Wireless 1510 Mini-Card (802.11n)

reported working

Intel Pro Wireless WI-FI 5100 (802.11a/g/Draft-n)

> working

Intel WiFi Link 5300 Mini-Card (802.11 a/g/n)

> working

Bluetooth

Dell™ Wireless 355 Bluetooth® Module ROW

working

CPU
---

As all of the available configurations are using a Intel® Core™2 Duo
processor all of them should work just fine. Nevertheless you should
take a look at the CPU frequency scaling article.

Graphics
--------

> NVIDIA® GeForce™ 9300M GS

Setting up the NVIDIA® GeForce™ 9300M GS graphic card is quite easy.

> GMA X4500 HD

Setting up the Integrated GMA X4500 HD graphics wasn't tested yet, but
as it works fine for various other devices it should work just fine.

Multimedia
----------

> Audio

The audio works just fine out of the box using ALSA. You need to have
the "snd_hda_intel" module loaded, it is advisable to put it into your
modules array in your /etc/rc.conf:

    MODULES=(snd_hda_intel)

Note: There is just a mono built-in speaker , so do not wonder when you
can't balance the channel properly.

> Webcam

The webcam works just fine out-of-the-box. If you have the automatic
module loading disabled you have to load the module "uvcvideo".

> Biometric Fingerprint Reader

The Biometric Fingerprint Reader itself wasn't tested yet, but it should
work following these steps.

> Extra Keyboard Keys

Works, using keytouchd. Have a look at Extra Keyboard Keys

> Card Reader

Works out of the box, using the modules: mmc_block, mmc_core and sdhci

Wireless Lan
------------

In order to find out which chipset you have, you can use hwd, which can
be installed quite easily:

     pacman -S hwd

Afterwards you have to run hwd with the following command:

     hwd -s

The output should tell you which wireless lan chipset is built into your
notebook.

> Dell Wireless 1397 Mini-Card

Reported to work with the nids-wrapper (not self tested).

> Dell Wireless 1510 Mini-Card

Reported to work with the nids-wrapper (not self tested).

> Intel Pro Wireless WI-FI 5100

Look at the section for the Intel WiFi Link 5300 Mini-Card, as the
driver is excactly the same.

> Intel WiFi Link 5300 Mini-Card

Make sure to have installed the package "iwlwifi-5000-ucode" as well as
"wireless_tools".

    pacman -S iwlwifi-5000-ucode wireless_tools

You can then follow the instruction given on the Wireless Setup page in
order to configure your connection.

Make sure to have the "iwlagn" module loaded, just put it into the
modules array in your /etc/rc.conf:

    MODULES=(iwlagn)

Alternatively you can use the module auto-loading, which should detect
the chipset just fine and load the appropriate modules.

Bluetooth
---------

> Dell™ Wireless 355 Bluetooth® Module ROW

If your Vostro comes with Windows Vista installed (most of all), you
need to update the bluetooth driver in Windows Vista. Among other
things, the driver changes the firmware of the module. Only after that
bluetooth will work under linux.

Issues
======

Suspend
-------

If you have a dedicated Nvidia chipset, and want to suspend your laptop
(Suspend2RAM) using pm-utils you need to have the nvidia driver
installed (and therefore a running X server).

Framebuffer
-----------

You may experience some problems using the X server and console
simultaneously, as soon as you work with different resolutions. In order
to change the resolution of the console (using framebuffer) you should
look at this. For me adding "vga=0x0361" to the /boot/grub/menu.lst
worked.

Card Reader
-----------

It can be that some cards are not readable and you get the dmesg

    [    8.790027] mmc0: error -110 whilst initialising SD card
    [    8.790764] sdhci-pci 0000:1a:00.1: Will use DMA mode even though HW doesn't fully claim to support it.

This problem is easy to solve.Just add this line to your modprobe.conf

    options sdhci debug_quirks=0x40

This will disable ADMA.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Vostro_1320&oldid=212755"

Category:

-   Dell
