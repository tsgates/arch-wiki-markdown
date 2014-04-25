Chromebook
==========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Draft...          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This article is to provide information on how to get Arch up and running
on the Chromebook series of laptops built by Acer, HP, Samsung, Toshiba,
and Google. Currently overhauling all of this and trying to get more
specific model pages built with uniform methods listed here.

Contents
--------

-   1 Model Specific Overview
-   2 General Chromebook Installation
    -   2.1 Pre-requisites
    -   2.2 Developer Mode
    -   2.3 Repartitioning
    -   2.4 cgpt command
        -   2.4.1 Example
-   3 Samsung Series 5 550
    -   3.1 Developer Mode
-   4 Chromebook Pixel

Model Specific Overview
-----------------------

Chromebook Models

Available

Brand

Model

Processor

RAM

Storage

Screen

Resolution

Weight

Base Price

Dec 2010

Google

Cr-48

1.66 GHz Intel Atom N455

2 GB  
DDR3

16 GB SSD

12.1 in  
(30.7 cm)

1280x800  
(16:10)

3.8 lb  
(1.7 kg)

Not for sale.

Jun 2011

Samsung

Series 5  
XE500C21

1.66 GHz Intel Atom N570

3.06-3.26 lb  
(1.4–1.5 kg)

$349.99 Wi-Fi  
$449.99 3G

Jul 2011

Acer

AC700

11.6 in  
(29.5 cm)

1366x768  
(16:9)

3.19 lb  
(1.4 kg)

$299.99 Wi-Fi  
$399.99 3G

May 2012

Samsung

Series 5  
XE550C22

1.3 GHz Intel Celeron 867  
1.6 Ghz Intel Core i5 2467M

4 GB  
DDR3

12.1 in  
(30.7 cm)

1280x800  
(16:10)

3.3 lb  
(1.5 kg)

$449.99 Wi-Fi  
$549.99 3G

Oct 2012

Series 3  
XE303C12

1.7 GHz Samsung Exynos 5250

2 GB  
DDR3

11.6 in  
(29.5 cm)

1366x768  
(16:9)

2.43 lb  
(1.1 kg)

$249.99 Wi-Fi  
$329.99 3G

Nov 2012

Acer

C7

1.1 GHz Intel Celeron 847  
1.5 GHz Intel Celeron 1007U

2-4 GB  
DDR3

320 GB HDD  
16 GB SSD

3-3.05 lb  
(1.4 kg)

$199.99 Wi-Fi

Feb 2013

HP

Pavilion 14  
Chromebook

1.1 GHz Intel Celeron 847

14 in  
(35.6 cm)

3.96 lb  
(1.8 kg)

$329.99 Wi-Fi

Lenovo

ThinkPad X131e  
Chromebook

1.5 GHz Intel Celeron 1007U

4 GB  
DDR3

16 GB SSD

11.6 in  
(29.5 cm)

3.92 lb  
(1.8 kg)

$429 Wi-Fi

Google

Chromebook  
Pixel

1.8 GHz Intel Core i5 3427U

32 GB SSD  
64 GB SSD

12.85 in  
(32.6 cm)

2560x1700  
(3:2)

3.35 lb  
(1.5 kg)

$1249 Wi-Fi  
$1499 LTE

Oct 2013

HP

Chromebook 11

1.7 GHz Samsung Exynos 5250

2 GB  
DDR3

16 GB SSD

11.6 in  
(29.5 cm)

1366x768  
(16:9)

2.3 lb  
(1.04 kg)

$279 Wi-Fi

Nov 2013

Chromebook 14

1.4 GHz Intel Celeron 2955U

2 GB DDR3  
4 GB DDR3

14 in  
( 35.6 cm)

4.07 lb  
(1.84 kg)

$299 Wi-Fi  
$349 HSPA+

Unknown

Acer

C720

2 GB  
DDR3

11.6 in  
(29.5 cm)

2.76 lb  
(1.25 kg)

$199 Wi-Fi

General Chromebook Installation
-------------------------------

> Pre-requisites

You should claim your free 100GB-1TB of Google Drive space before you
install Arch. This needs to happen from ChromeOS(version > 23), not
linux. This will sync/backup ChromeOS, as designed.

> Developer Mode

Developer Mode information on all models is at
http://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices.

First, enable developer mode on your Chromebook. Although everything in
the "Downloads" area syncs to your Google Drive account, this will
delete data stored on the hard or solid state drive.

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

Reminder- Needs to be moved to its own page given the boatload of new
development surrounding this model including with coreboot / seabios.

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

Chromebook Pixel
----------------

Suspending more than once causes a reboot unless the tpm module is
enabled with specific options:

    modprobe tpm_tis force=1 interrupts=0

Retrieved from
"https://wiki.archlinux.org/index.php?title=Chromebook&oldid=304166"

Category:

-   Laptops

-   This page was last modified on 12 March 2014, at 14:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
