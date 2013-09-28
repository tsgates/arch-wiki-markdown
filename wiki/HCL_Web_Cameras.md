HCL/Web Cameras
===============

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Hardware Compatibility List (HCL)
  Full Systems
  Laptops - Desktops - Servers - Virtual Machines
  Components
  Video Cards - Sound Cards - Wired Net Adapters - Modems - Wireless Adapters - Monitors - Bluetooth Adapters - Printers - Scanners - TV Cards - Digital Cameras - Web Cameras - UPS - Floppy Drives - CD and DVD Writer/Readers - SCSI Adapters - Gadgets - SATA IDE Cards - Keyboards - Main Boards - RAID Controllers
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Acer                                                               |
|     -   1.1 CrystalEye                                                   |
|                                                                          |
| -   2 Creative labs                                                      |
|     -   2.1 Creative Live! Cam Vista IM                                  |
|     -   2.2 Creative Webcam Notebook                                     |
|                                                                          |
| -   3 Omega                                                              |
|     -   3.1 C 91                                                         |
|                                                                          |
| -   4 Genius                                                             |
|     -   4.1 Genius Eye 110                                               |
|                                                                          |
| -   5 Logitech                                                           |
|     -   5.1 QuickCam E 3500                                              |
|                                                                          |
| -   6 Microsoft                                                          |
|     -   6.1 LifeCam VX-800                                               |
|     -   6.2 LifeCam VX-1000                                              |
|                                                                          |
| -   7 Apple                                                              |
|     -   7.1 iSight                                                       |
+--------------------------------------------------------------------------+

Acer
====

CrystalEye
----------

Just installing the linux-uvc-svn package made it work. This driver
package is integrated into the Linux kernel 2.6.26 (so you need not to
install this package if you have a recent kernel). The camera is usable
from kopete with no configuration. Some programs to test your camera
(and record videos and take pictures) are ucview andluvcview(the latter
requires-f yuvparameter, and-wif you're using compiz).

Tested on:

-   Acer Extensa 5620 notebook (integrated webcam).
-   Acer TravelMate 6292 notebook (lsusb gives following description:
    "ID 064e:a101 Suyin Corp.")

Creative labs
=============

> Creative Live! Cam Vista IM

Uses the ov51x-jpeg module. Use directions described on Webcam Setup
page.

> Creative Webcam Notebook

Uses the gspca_zc3xx module.

Omega
=====

C 91
----

Works out of box as V4L2 device. Unfortunately Skype test fails - it
shows no image only in Skype. Dinth 05:03, 5 June 2009 (EDT)

Genius
======

Genius Eye 110
--------------

Detected by kernel and working without install any driver. Skype works
only using: "$ LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so skype" and Flash
does not work.

  

Logitech
========

QuickCam E 3500
---------------

Works perfectly out of the box

Microsoft
=========

LifeCam VX-800
--------------

Works out of the box (including Skype).

LifeCam VX-1000
---------------

Works out of box

Apple
=====

iSight
------

Working with aur/linux-uvc-svn (Tested on MacBook Pro Rev3)

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Web_Cameras&oldid=196375"

Category:

-   Hardware Compatibility List
