HCL/Video Cards
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
| -   1 ATI                                                                |
|     -   1.1 Radeon 7000                                                  |
|     -   1.2 Radeon 9550, 9800, X300                                      |
|     -   1.3 Radeon 9600XT 128MB                                          |
|     -   1.4 Radeon Express 200m                                          |
|     -   1.5 Radeon X850 XT PE                                            |
|     -   1.6 Radeon X1650 PRO                                             |
|     -   1.7 ATI Mobility-P 8Mb                                           |
|     -   1.8 Radeon Mobility HD3450                                       |
|     -   1.9 Radeon HD 3650                                               |
|     -   1.10 Radeon HD 4830                                              |
|     -   1.11 Radeon HD 5450                                              |
|                                                                          |
| -   2 Intel                                                              |
|     -   2.1 i855                                                         |
|     -   2.2 915                                                          |
|     -   2.3 i945                                                         |
|     -   2.4 945GM                                                        |
|     -   2.5 x3100/GM965                                                  |
|                                                                          |
| -   3 NVIDIA                                                             |
|     -   3.1 Fx 5550                                                      |
|     -   3.2 Fx 570M                                                      |
|     -   3.3 Quadro FX 2700M                                              |
|     -   3.4 Quadro Nvs 110M                                              |
|     -   3.5 GeForce MX420 Go (32MB)                                      |
|     -   3.6 GeForce 6200 Silent AGP (256MB)                              |
|     -   3.7 GeForce 6610 XL (128MB)                                      |
|     -   3.8 GeForce 6600 GT (128MB)                                      |
|     -   3.9 GeForce 7100 GS (128MB)                                      |
|     -   3.10 GeForce 7300 GS (512MB)                                     |
|     -   3.11 GeForce 7600 GS (128MB)                                     |
|     -   3.12 GeForce 7600 GT (256MB)                                     |
|     -   3.13 GeForce 8400 GS (512MB)                                     |
|     -   3.14 GeForce 8600M GT (128MB)                                    |
|     -   3.15 GeForce 8600 GTS (256MB)                                    |
|     -   3.16 GeForce 8800 GT (512 MB)                                    |
|     -   3.17 GeForce 9600 GT (512MB)                                     |
|     -   3.18 GeForce 9800 GT (1024MB)                                    |
|     -   3.19 GeForce GT 130M (1GB)                                       |
|     -   3.20 GeForce GT 240 (1GB)                                        |
|                                                                          |
| -   4 S3                                                                 |
|     -   4.1 ProSavage IX-MV                                              |
|                                                                          |
| -   5 SiS - Silicon Integrated Systems                                   |
| -   6 VIA                                                                |
| -   7 Matrox                                                             |
| -   8 Intel chipsets                                                     |
+--------------------------------------------------------------------------+

ATI
===

For more details on the different chipsets, see:
http://www.x.org/wiki/RadeonFeature

Radeon 7000
-----------

Works with xf86-video-ati

Radeon 9550, 9800, X300
-----------------------

Autodetected If you do not have the proprietary driver. See the HOWTO -
ATI Radeon & Kernel 2.6   
 3D Support Yes with the fglrx driver. AIXGL No. Arch Linux Release(s):
0.7.2 Gimmick, 0.8 Voodoo, 2007.05 Duke

Radeon 9600XT 128MB
-------------------

Works with the catalyst driver. catalyst driver package is still
referred to as fglrx in xorg.conf.

Radeon Express 200m
-------------------

Autodetected If you do not have the proprietary driver. See the HOWTO -
ATI Radeon & Kernel 2.6   
 3D Support Yes with the fglrx driver. AIXGL No. Arch Linux Release(s):
2007.05 Duke, 2007.05-Linuxtag2007

Radeon X850 XT PE
-----------------

Works with the package "xf86-video-ati", including hardware accelerated
graphics.

Radeon X1650 PRO
----------------

Works with the package "xf86-video-ati", including hardware accelerated
graphics.

ATI Mobility-P 8Mb
------------------

Works only with vesa. Arch Linux Release(s): 0.7.2 Gimmick, 0.8 Voodoo,
2007.05 Duke

Radeon Mobility HD3450
----------------------

Works with the package xf86-video-ati or "xf86-video-radeonhd",
including hardware accelerated graphics.

Radeon HD 3650
--------------

Works with the package xf86-video-ati including 3D support and power
management. Also works with the proprietary catalyst driver with full 3D
and power management support

Radeon HD 4830
--------------

Works with the package xf86-video-ati including 3D support but no power
management. Full 3D support and power management with proprietary
catalyst driver available in AUR

Radeon HD 5450
--------------

Works with the package xf86-video-ati including 3D support but no power
management. Full 3D support and power management with proprietary
catalyst driver available in AUR

Intel
=====

i855
----

Works perfectly with xf86-video-intel

915
---

Works perfectly with xf86-video-intel-2.0. Compositing works fine.

i945
----

Works flawlessly with xf86-video-intel-2.0 and xorg-server-1.3 (be sure
to use intel as driver in xorg.conf, or do not use xorg.conf at all).
Native resolution (1440x900) automatically detected by driver
eliminating the need for 915resolution. Compiz-Fusion runs without a
hitch, resuming from suspend/hibernate may cause the background not to
render properly, but this is easily fixed by rotating the cube.

945GM
-----

Works perfectly with xf86-video-intel-2.10. About 1800fps.

x3100/GM965
-----------

Works with xf86-video-intel-2.0.

NVIDIA
======

Fx 5550
-------

Works with both i686 and x86_64 version with module nv/vesa and with the
Nvidia driver(but this driver taints the kernel).

Fx 570M
-------

Works perfectly with the nvidia driver, i just needed nvclock to dimm
the display

Quadro FX 2700M
---------------

Works perfectly with the nvidia driver with one exception, the favorite
1680x1050 resolution isn't an option for some reason.

Quadro Nvs 110M
---------------

Works perfectly with module nv/vesa and with the Nvidia driver.

GeForce MX420 Go (32MB)
-----------------------

Works perfectly with the nv driver and the legacy nvidia 96xx driver.

GeForce 6200 Silent AGP (256MB)
-------------------------------

Works perfectly with the nvidia driver.

GeForce 6610 XL (128MB)
-----------------------

Works perfectly with the nvidia driver.

GeForce 6600 GT (128MB)
-----------------------

Works perfectly with the nvidia driver.

GeForce 7100 GS (128MB)
-----------------------

Works perfectly with the nvidia driver

GeForce 7300 GS (512MB)
-----------------------

Works perfectly with the nvidia driver

GeForce 7600 GS (128MB)
-----------------------

Works perfectly with the nvidia driver.

GeForce 7600 GT (256MB)
-----------------------

Works perfectly with the nvidia driver.

GeForce 8400 GS (512MB)
-----------------------

Works perfectly with the nvidia driver.

GeForce 8600M GT (128MB)
------------------------

Works perfectly with the nvidia driver.

GeForce 8600 GTS (256MB)
------------------------

Works perfectly with the nvidia driver.

GeForce 8800 GT (512 MB)
------------------------

Works perfectly with the nvidia driver (from 169.12). Works with both
i686 and x86_64 systems.

GeForce 9600 GT (512MB)
-----------------------

Works perfectly with the nvidia driver.

GeForce 9800 GT (1024MB)
------------------------

Works perfectly with the nvidia driver.

GeForce GT 130M (1GB)
---------------------

Works perfectly with the nvidia driver.

GeForce GT 240 (1GB)
--------------------

Seems to work perfectly with the nvidia driver.

S3
==

ProSavage IX-MV
---------------

Works perfectly with savage driver. Potential drawbacks depending on
VRAM. See IBM ThinkPad T21 for details.

SiS - Silicon Integrated Systems
================================

VIA
===

Matrox
======

Intel chipsets
==============

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Video_Cards&oldid=238812"

Category:

-   Hardware Compatibility List
