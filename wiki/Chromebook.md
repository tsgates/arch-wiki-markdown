Chromebook
==========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Draft...          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This article is to provide information on how to get Arch up and running
on the Chromebook series of laptops (or netbooks) as built by Samsung,
Acer, Google.

Discussion of this topic began in this forum thread:
https://bbs.archlinux.org/viewtopic.php?id=148602

Initially written with the intention of getting a Samsung Series 5 550
to dual boot with Arch. (Only reason for the dual boot is to potentially
collect firmware changes pushed downward from Chromeos).

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Model Specific Overview                                            |
| -   2 General Chromebook Installation                                    |
|     -   2.1 Pre-requisites                                               |
|     -   2.2 Developer Mode                                               |
|     -   2.3 Repartitioning                                               |
|     -   2.4 cgpt command                                                 |
|         -   2.4.1 Example                                                |
|                                                                          |
| -   3 Samsung Series 5 550                                               |
|     -   3.1 Developer Mode                                               |
+--------------------------------------------------------------------------+

Model Specific Overview
-----------------------

(as copied from Wikipedia)

  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Manufacturer   Model                 Available   Generation   Processor                       RAM         Storage                   Screen size   Weight           Base price
  -------------- --------------------- ----------- ------------ ------------------------------- ----------- ------------------------- ------------- ---------------- ---------------------
  Google         Cr-48                 Dec 2010    Prototype    1.66 GHz Intel Atom N455        2 GB DDR3   16 GB Solid-state drive   12.1 in       3.8 lb           Not for retail sale

  Samsung        Series 5 (XE500C21)   Jun 2011    1            1.66 GHz Intel Atom N570        2 GB DDR3   16 GB Solid-state drive   12.1 in       3.06 - 3.26 lb   $349.99 Wi-Fi  
                                                                                                                                                                     $449.99 3G

  Acer           AC700                 Jul 2011    1            1.66 GHz Intel Atom N570        2 GB DDR3   16 GB Solid-state drive   11.6 in       3.19 lb          $299.99 Wi-Fi  
                                                                                                                                                                     $399.99 3G

  Samsung        Series 5              May 2012    2            1.3 GHz Intel Celeron 867       4 GB DDR3   16 GB Solid-state drive   12.1 in       3.3 lb           $449.99 Wi-Fi  
                 XE550C22                                                                                                                                            $549.99 3G

  Samsung        Series 3              Oct 2012    3            1.7 GHz Samsung Exynos 5 Dual   2 GB DDR3   16 GB Solid-state drive   11.6 in       2.43 lb          $249.99 Wi-Fi  
                 XE303C12                                                                                                                                            $329.99 3G

  Acer           C7 Chromebook         Nov 2012    3            1.1 GHz Intel Celeron 847       2 GB DDR3   320 GB HDD                11.6 in       3 lb             $199.99 Wi-Fi
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  :  Chromebook models

  

General Chromebook Installation
-------------------------------

> Pre-requisites

One thing to note is that if you need to claim your free 100gb of google
drive space, you probably want to do that before your install of arch.
This needs to happen from chromeos (version > 23) and will not work from
linux. It is a good idea to use this google drive before installing Arch
as it will sync/backup the chromeos system as designed.

> Developer Mode

A wealth of information is at
http://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices/samsung-sandy-bridge#TOC-Entering-Developer-Mode
. The notes below are primarily taken from there.

The first step is to enable developer mode on the Chromebook system. Be
aware that although everything in the "Downloads" area goes to your
online google drive account, this will delete all stored data.

> Repartitioning

A script referenced from
http://chromeos-cr48.blogspot.co.uk/2012/04/chrubuntu-1204-now-with-double-bits.html
points to the shell script at http://goo.gl/i817v and discusses
repartitioning. The script should be run as the chronos user.

> cgpt command

You'll save your self a lot of time if you understand this command
before you attempt to install Arch on a chromebook.

This is NON-EXHAUSTIVE but it'll help most people reading this. cgpt
--help is nice too.

Use:

    cgpt showpartiton /dev/sda

to list all partitions on disk with boot information for each.

Use:

    cgpt add [options] /dev/sda

used to modify boot options

Example

     cgpt add -i 6 -P 5 -S 0 -T 1 /dev/sda

Example: modify partition #6, set priority to 5, successful to false,
and boot tries to once(1), on device /dev/sda

    cgpt add -i 1-12 

Partition number to change

    cgpt add -P 9-0

Priority 9 > 1 (Higher number will try to boot first)

    cgpt add -T 0-99

Tries, used with the successful flag. Will try to boot this partition x
times until tries = 0 then it will try next lower priority partition.

    cgpt add -S 0-1

Successful flag, if 1 will try to boot this partition forever. Be
careful with this one! If 0 and tries > 0 it will try to boot this
partition until it' out of tries.

If installing yourself, don't forget to copy this onto your arch
partition!.

Samsung Series 5 550
--------------------

> Developer Mode

Developer mode on the Samsung Series 5 has two levels of access,
"dev-switch on" and "dev-mode BIOS". With the first level you enable a
command line shell, which lets you look around inside the GNU/Linux
operating system, but does not let you run your own versions.

The second level of access installs a special BIOS component that
provides the ability to boot your own operating systems from either
removable (USB/SD) or fixed (SSD) drives. Both levels of access are
completely reversible, so don't be afraid to experiment.

The second level (described above) is what we want in order to install
Arch.

http://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices/samsung-series-5-chromebook/b.jpg

The switch is behind a little door on the right-hand side of the
chromebook (as linked above). To enable the developer switch you open
the door, use something pointy (paperclip or toothpick) to move the
switch towards the back of the device, and reboot.

Warning:Be gentle with the developer switch! Some people have reported
that the developer switch breaks easily.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Chromebook&oldid=252004"

Category:

-   Laptops
