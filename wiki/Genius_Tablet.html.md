Genius Tablet
=============

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Introduction
-   2 Installation
-   3 Configuration
-   4 Calibration

Introduction
------------

This is a guide to getting a Genius Wizardpen or MousePen tablet set up
in Arch Linux. It also work with G-Pen Series.

Installation
------------

First, you need to install the X11 drivers. The wizardpen package in aur
provides them:

https://aur.archlinux.org/packages.php?ID=42671

Configuration
-------------

First you have to know if your tablet is in the udev .rules file:

1.  lsusb

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

Bus 001 Device 002: ID 0402:5602 ALi Corp. M5602 Video Camera Controller

Bus 002 Device 005: ID 172f:0038 Waltop International Corp. Genius G-Pen
F509

The last one is our tablet. 172f is the vendor id, 0038 the model id

Now we have to search the /etc/udev/rules.d/67-xorg-wizardpen.rules for
the 2 id's which identifies our tablet ...

1.  Waltop

ENV{ID_VENDOR_ID}=="172f", ENV{ID_MODEL_ID}=="0038",
ENV{x11_driver}="wizardpen" ...

In our case we are lucky, our tablet is here.

If it doesn't, just copy-paste the line from above and replace the
VENDOR_ID and the MODEL_ID with ours.

Now restart the computer, or restart X server and plug out an in your
tablet( so udev rule take effect ).

Test your tablet, mine had a wrong calibration , i.e. the resolution of
monitor didn't match the whole surface of tablet.

Calibration
-----------

Just do the following:

1.  su
2.  wizardpen-calibrate /dev/input/by-id/usb-WALTOP_Tablet-event-mouse

(just find yours there, and be sure that is the *event* one.)

Follow the instruction there, and what you receive is the configuration
for your tablet.

.......................................................................................................................................... 
    Please, press the stilus at ANY
    corner of your desired working area: ok, got 189,77
    
    Please, press the stilus at OPPOSITE
    corner of your desired working area: ok, got 17920,10734
    
    According to your input you may put the following
    lines into your XF86Config/X.Org configuration file:
    
    Driver "wizardpen"
    Option "Device" "/dev/input/by-id/usb-WALTOP_Tablet-event-mouse"
    Option "TopX" "189"
    Option "TopY" "77"
    Option "BottomX" "17920"
    Option "BottomY" "10734"
    .........................................................................................................................................

The package will create /etc/X11/xorg.conf.d/70-wizardpen.conf file
which you can access for configuration.

Now edit that file, and replace with the configuration you receive. ( be
careful not to remove everything from that file, just replace these you
received from wizardpen-calibrate)

Most likely you will also need to disable ABI version checking in Xorg
since otherwise wizardpen driver module will not load because of ABI
version mismatch. Do it by adding the following to your
/etc/X11/xorg.conf:

    Section "ServerFlags"
       Option "IgnoreABI" "True"
    EndSection

After this, reboot or restart your X server.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Genius_Tablet&oldid=291252"

Category:

-   Graphics tablet

-   This page was last modified on 1 January 2014, at 14:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
