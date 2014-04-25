Asus U32U Series
================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page is aimed to collect the recipes needed after a fresh install
of archlinux on a laptop from the Asus U32U serie.

Note: You may not need those tricks if you are using a desktop
environment such as Gnome, KDE, XFCE,...

Contents
--------

-   1 Bootloader
    -   1.1 System Recovery
-   2 RF-kill issue
-   3 Sound issue
-   4 Microphone
-   5 Video
-   6 Touchpad
    -   6.1 Multitouch
-   7 SD Card Reader
-   8 LEDs
-   9 Special Keys
-   10 LID
-   11 SD Card Reader

Bootloader
----------

To show the boot menu press Esc during startup.

> System Recovery

In order to restore to Factory Default Settings you'll have to press F10
at startup AND Recovery from the grub.

RF-kill issue
-------------

In order to get rid of the RF-kill issue after a fresh install you
should add options asus_nb_wmi wapf=1 to
/etc/modprobe.d/asus_nb_wmi.conf

Sound issue
-----------

To get sound working you should create a user specific file ~/.asoundrc
or a system-wide file /etc/asound.conf with the folowing content:


    pcm.!default {
    	type hw
    	card 1
    }

    ctl.!default {
    	type hw           
    	card 1
    }

A good configuration for the sound could be as follow:


    Master: 100
    Headphone: 100
    Speaker 100
    PCM: 100
    Mic: 34
    Mic Boost: 51
    S/PDIF: M
    S/PDIF D: 0
    Auto-Mut: Enabled
    Internal: 22
    Internal: 51

  

Microphone
----------

A good configuration for the microphone could be as follow:


    Mic Boost: 51
    Capture: 47
    Digital: 81
    Internal Mic Boost: 51

Video
-----

Brand

Type

Driver

Multilib Package  
(for 32-bit applications on Arch x86_64)

 Documentation 

>  AMD/ATI 

 Open source 

xf86-video-ati

lib32-ati-dri

ATI

Proprietary

catalyst-dkms

lib32-catalyst-utils

AMD Catalyst

Touchpad
--------

To get the touchpad working, install the synaptics package:

    # pacman -S xf86-input-synaptics

> Multitouch

It seems that aur/touchégg can be used

SD Card Reader
--------------

// TODO

LEDs
----

Out of the box the wifi led does not work. Other leds seem to work.

Special Keys
------------

 Fn + F1 (Suspends) works out of the box

 Fn + F2 (Toggle Wi-Fi) works out of the box

 Fn + F5 (Dim brightness) works out of the box

 Fn + F6 (Dim brightness) works out of the box

 Fn + F7 (Toggle brightness) works out of the box

Other keys need remaping

LID
---

Closing Lid seems to suspend computer (to be confirmed, otherwise
install acpi)

SD Card Reader
--------------

Works out of the box

Retrieved from
"https://wiki.archlinux.org/index.php?title=Asus_U32U_Series&oldid=303488"

Category:

-   ASUS

-   This page was last modified on 7 March 2014, at 14:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
