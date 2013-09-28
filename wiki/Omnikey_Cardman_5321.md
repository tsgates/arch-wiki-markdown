Omnikey Cardman 5321
====================

This page will explain how to get the Omnikey Cardman 5321 SmartCard
Reader up and running under Archlinux. This guide may work for other
models to, but this has not been tested.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Packages                                                     |
|         -   1.1.1 pcsclite                                               |
|         -   1.1.2 pcsc-tools                                             |
|         -   1.1.3 Driver                                                 |
|                                                                          |
| -   2 Usage                                                              |
|     -   2.1 Start pcscd                                                  |
|     -   2.2 Test with pcsc_scan                                          |
+--------------------------------------------------------------------------+

Installation
============

Packages
--------

> pcsclite

You need to install pcsclite, a middleware to access a smart card using
the SCard API. pcsclite availible in [community].

> pcsc-tools

In addition you can install pcsc-tools which provide you some tools that
you can use with smart cards and PC/SC: pcsc-tools.

> Driver

At least you have to install the driver, that is now also available
through the AUR: omnikey_cardman_5x2x.

Usage
=====

Start pcscd
-----------

To start pcscd you have to run the following command:

For legacy init systems:

    # /etc/rc.d/pcscd start

For systemd systems:

    # systemctl start pcscd.service

Test with pcsc_scan
-------------------

You can test the installation by running pcsc_scan. If everything worked
fine, you should get something like that:

    PC/SC device scanner
    V 1.4.16 (c) 2001-2009, Ludovic Rousseau <ludovic.rousseau@free.fr>
    Compiled with PC/SC lite version: 1.5.5
    Scanning present readers...
    0: OMNIKEY CardMan 5x21 00 00
    1: OMNIKEY CardMan 5x21 00 01

    Sun Feb 21 18:21:05 2010
     Reader 0: OMNIKEY CardMan 5x21 00 00
      Card state: Card removed, 

    Sun Feb 21 18:21:05 2010
     Reader 1: OMNIKEY CardMan 5x21 00 01
      Card state: Card removed, 

    Sun Feb 21 18:21:11 2010
     Reader 1: OMNIKEY CardMan 5x21 00 01
      Card state: Card inserted, 
      ATR: 3B 89 80 01 4A 43 4F 50 34 31 56 32 32 4D

    ATR: 3B 89 80 01 4A 43 4F 50 34 31 56 32 32 4D
    + TS = 3B --> Direct Convention
    + T0 = 89, Y(1): 1000, K: 9 (historical bytes)
      TD(1) = 80 --> Y(i+1) = 1000, Protocol T = 0 
    -----
      TD(2) = 01 --> Y(i+1) = 0000, Protocol T = 1 
    -----
    + Historical bytes: 4A 43 4F 50 34 31 56 32 32
      Category indicator byte: 4A (proprietary format)
    + TCK = 4D (correct checksum)

    Possibly identified card (using /usr/share/pcsc/smartcard_list.txt):
    3B 89 80 01 4A 43 4F 50 34 31 56 32 32 4D
    	New Zealand e-Passport

Retrieved from
"https://wiki.archlinux.org/index.php?title=Omnikey_Cardman_5321&oldid=245614"

Category:

-   Other hardware
