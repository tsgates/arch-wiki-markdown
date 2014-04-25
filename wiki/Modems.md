HCL/Modems
==========

  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Hardware Compatibility List (HCL)
  Full Systems
  Laptops - Desktops
  Components
  Video Cards - Sound Cards - Wired Net Adapters - Modems - Wireless Adapters - Printers - Scanners - TV Cards - Digital Cameras - CD and DVD Writer/Readers - Keyboards - Main Boards
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Contents
--------

-   1 Broadcom
    -   1.1 Broadcom V.92 Soft ModemV.92
-   2 Huawei
    -   2.1 E220
    -   2.2 E1550
    -   2.3 E392
-   3 Intel
    -   3.1 Intel 537E,v.9X,PCI,Modem

Broadcom
========

Broadcom V.92 Soft ModemV.92
----------------------------

detected and works with out of the box

Huawei
======

E220
----

Works with usbserial driver. (Huawei E220)

E1550
-----

Works with usbserial driver. (Huawei E1550 3G modem)

  

E392
----

Works with usbserial driver. Needs QMI support (recent ModemManager has
it).

Storage id = 12D1:1505

Modem id = 12D1:1506

To connect, first switch modem if needed (lsusb to see current mode):

       ~> sudo modprobe qmi_wwan
       ~> sudo modprobe usbserial vendor=0x12d1 product=0x1506
       ~> sudo usb_modeswitch -v 12d1 -p 1505 -V 12d1 -P 1506 -W -M “55534243123456780000000000000011062000000100000000000000000000″

If this method doesn't work create usb_modeswitch file

       DefaultVendor= 0x12d1
       DefaultProduct=0x1505
       
       TargetVendor=  0x12d1
       TargetProduct=0x1506
       
       MessageContent="55534243123456780000000000000011062000000100000000000000000000"

Next run command where -c is the file you saved

       sudo usb_modeswitch -W -c /etc/usb_modeswitch.d/12d1\:1505

Run ModemManager and connect to LTE network

       sudo ModemManager &
       sudo mmcli -m 0 --simple-connect="apn=yourapn,ip-type=ipv4"

Links: http://blog.bluedrive.ro/?p=28

http://www.modem-help.co.uk/HUAWEI/E392-LTE-USB-Stick-4G-Mobile-Broadband-Dongle.html?info=1

Intel
=====

Intel 537E,v.9X,PCI,Modem
-------------------------

detected and works with out of the box

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Modems&oldid=291696"

Category:

-   Hardware Compatibility List

-   This page was last modified on 5 January 2014, at 14:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
