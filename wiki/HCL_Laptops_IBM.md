HCL/Laptops/IBM
===============

  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Hardware Compatibility List - Laptops main page   
   Acer - Apple - Asus - Compaq - Dell - Digital - ECS - Siemens-Fujitsu - Gateway - Hitachi - Higrade - HP - IBM/Lenovo - Medion - Micron - Mitac - Mitsubishi - NEC - Panasonic - Samsung - Sony - Toshiba - Zenith - Other
  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
| -   1 IBM/Lenovo                                                         |
|     -   1.1 ThinkPad                                                     |
|                                                                          |
| -   2 Special Notes (*):                                                 |
|     -   2.1 IBM ThinkPad T21                                             |
|     -   2.2 Lenovo Thinkpad T61                                          |
|     -   2.3 Lenovo 3000 N200                                             |
|     -   2.4 IBM ThinkPad R50,R52                                         |
|     -   2.5 IBM ThinkPad R52                                             |
|     -   2.6 Lenovo IdeaPad S10                                           |
|     -   2.7 Lenovo ThinkPad T420                                         |
|     -   2.8 Lenovo ThinkPad T420s                                        |
|     -   2.9 Lenovo ThinkPad E430                                         |
+--------------------------------------------------------------------------+

IBM/Lenovo
==========

ThinkPad
--------

Model Version:

Harware Support:

Remark:

Video:

Sound:

Ethernet:

Wireless:

Bluetooth:

Power  
Management:  

Modem:

Other:

IBM ThinkPad 380ED

NA

NA

NA

NA

No

NA

NA

NA

IBM ThinkPad T21

Yes*

Yes

Yes

NA

NA

Yes*

NA

NA

See below

IBM ThinkPad T23

Yes

Yes

Yes

NA

NA

Yes

NA

NA

IBM ThinkPad T42

Yes

Yes

Yes

Yes

NA

Yes

NA

NA

IBM ThinkPad T60

Yes

Yes

Yes

Yes

Yes

Yes

 ?

NA

IBM ThinkPad T60p

Yes

Yes

Yes

Yes

Yes

Yes

 ?

ThinkFinger

IBM ThinkPad T61

Yes

Yes

Yes

Yes*

NA

Yes

NA

IBM Thinkpad T61p

Yes

Yes

Yes

Yes

Yes

Yes

NA

IBM ThinkPad X23

Yes

Yes

Yes

NA

NA

Yes

NA

NA

IBM ThinkPad X60s

Yes

Yes

Yes

Yes

Yes

Yes

NA

NA

Lenovo ThinkPad X61s

Yes

Yes

Yes

Yes

Yes

Yes

NA

SD slot

Lenovo ThinkPad R60

Yes

Yes

Yes

Yes

Yes

Yes

NA

NA

Lenovo 3000 N200

Yes

Yes*

Yes

Yes

Yes

Yes*

NA

NA

See Below

IBM ThinkPad R50,R52

Yes

Yes

Yes

Yes

NA

Yes

Yes

Infrared*

Lenovo ThinkPad X200

Yes

Yes

Yes

Yes

Yes

Yes

NA

NA

Lenovo IdeaPad S10

Yes

Yes

Yes

Yes*

NA

Yes

NA

NA

Lenovo ThinkPad T400

Yes

Yes

Yes

Yes

Yes

Yes

NA

NA

Lenovo ThinkPad T400s

Yes

Yes

Yes

Yes

Yes

Yes

NA

NA

Lenovo ThinkPad T420

Yes

Yes

Yes

Yes

Not Tested

Yes*

NA

NA

Lenovo ThinkPad T420s

Yes

Yes

Yes

Yes

Yes

Yes

NA

Card Reader

See below

Lenovo ThinkPad T500

Yes

Yes

Yes

Yes

Not Tested

Yes

NA

NA

Lenovo ThinkPad T520

Yes

Yes

Yes

Not Tested

Not Tested

Yes

NA

NA

Lenovo ThinkPad T530

Yes

Yes

Yes

Not Tested

Not Tested

Not Tested

NA

NA

Lenovo ThinkPad E420s

Yes

Yes

Yes

Yes

Not Tested

Yes

NA

Lenovo ThinkPad Edge E430

Yes

Yes

Yes*

Yes*

Not Tested

Yes

NA

SDCard (yes)

Lenovo ThinkPad Edge E530

Yes

Yes

Yes*

Yes*

Yes

Yes

NA

SDCard (yes)/Finger Print(Not tested)

Special Notes (*):
==================

IBM ThinkPad T21
----------------

-   Video:
    -   Incapable of running DRM at 1024x768 and 24-bit color due to 8
        MB VRAM. Must drop color or resolution to get DRM.
    -   For whatever reason, external VGA output (for an external
        monitor) was disabled. This was fixed by doing this:
        -   echo 1 > /proc/acpi/video/VID/DOS

Lenovo Thinkpad T61
-------------------

-   Wireless:
    -   While both the iwl3945 and ipw3956 drivers work, the iwl3956
        driver provides better transfer speeds, and a working wifi LED
        activity light.

Lenovo 3000 N200
----------------

-   Sound:
    -   You may have to append options snd_hda_intel model=lenovo to
        /etc/modprobe.d/modprobe.conf for sound to work.

IBM ThinkPad R50,R52
--------------------

-   Infrared:
    -   Still not tested

IBM ThinkPad R52
----------------

-   USB Internet Tethering
    -   Inbound inet via usb0 works. # dhcpcd usb0

Lenovo IdeaPad S10
------------------

-   Wireless :
    -   You should install broadcom wl driver. See:
        https://wiki.archlinux.org/index.php/Broadcom_BCM4312

Lenovo ThinkPad T420
--------------------

-   Power Management
    -   TP_smapi is not currently supported.

Lenovo ThinkPad T420s
---------------------

Multi-touch trackpad works along with scrolling and gestures, just
install xf86-input-synaptics with pacman.

For more info on the installation process check here

Lenovo ThinkPad E430
--------------------

-   Ethernet:
    -   Default card is a Realtek RTL8111/8168B. Thus the r8168 module
        should be used.

-   Wireless
    -   r8192ce can be moody. So far best fix is to disable firmware low
        power state (fwlps=0).

-   SD Card

As of 3.8 3rd party module is un-needed, device will be accessable @
/dev/mmcX

**To make SD Card slot work, rts5229 is needed. See Lenovo ThinkPad Edge
E430 for more info.

-   Power Management
    -   tp_smapi is not supported, but normal power management may be
        achieved in the usual ways.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Laptops/IBM&oldid=253187"

Category:

-   Hardware Compatibility List
