HP Pavilion DV9757
==================

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This laptop is the one easiest computer so far I have been installing
linux on! Nearly everuthing works out of the box or by only making a few
easily accomplished trix.

> Specifications:

Processor Intel C2D T7500

Memory 4096 Mb (2x2048) DDR2

Hårddisk 500 Gb(2x250 Gb) 5400rpm

Graphic card nVidia 8600M GS

graphic memory 512/1791

graphic ports HDMI/VGA/S-video

Screen 17" Brightview 1440x900

Soundcard HD Audio

drive DVD+-RW DL LS

PC-express/ PC-mini Yes/Yes

Wlan-Network-Bluetooth 11g/10-100/Yes

USB/Firewire/Modem 4/Yes/Yes

Webcam

Fingerprint scanner

Card reader 5-in-1

1 x Microphone -in Jack

2 x Headphone -out Jack

1x Line in Jack

Pointer Touchpad

Preinstalled operative Vista Premium

Battery time 2,5 Hours

Weight 3,6 Kg

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preinstallation configuration                                      |
| -   2 Video                                                              |
| -   3 Xorg                                                               |
| -   4 Audio                                                              |
| -   5 Wifi                                                               |
| -   6 Webcam                                                             |
| -   7 Bluetooth                                                          |
| -   8 Card Reader                                                        |
| -   9 Pointer                                                            |
| -   10 Remote controle                                                   |
| -   11 Finger print reader                                               |
| -   12 Quick play function keys                                          |
| -   13 Function keys for sound                                           |
+--------------------------------------------------------------------------+

Preinstallation configuration
-----------------------------

The computer is preinstalled with 2 harddisks of which 1 is partitioned
into 2 parts; 1 small part where the installation resides. If you - like
me - wants to keep vista you can follow these easy steps:

1. Finish the installation that starts the first time you start the
computer

2. Then run the command diskmgmt.msc in vista

Using that tool you can modify the partitionsize where vista is
installed and make room for Archlinux.

After that you reboot with your Archlinux live-cd in the dvd-drive and
install linux on the free part of disk 1 and on disk 2.

Install your boot-manager in MBR on first disk and open up for windows
as one option

3. Continue to configure as usual.

  

Video
-----

     pacman -S nvidia nvidia-utils

add to modules in /etc/rc.conf

Xorg
----

Works without problem with nvidia driver

  
 Vga-out works in twin view or - as I prefer - xinerama using 2
x-servers. This could be configured with the nvidia-tool in kde.

TV-out works with nvidia setting

Audio
-----

Works out of the box

Wifi
----

     pacman -S ipw3945

add to modules in /etc/rc.conf

Webcam
------

r5u870 and r5u870-fw modules needed. Get from AUR

     pacman -S linux-uvc-svn 

from community

I added the line:

     modprobe r5u870

in /etc/rc.local in order to be sure the video module is loaded after
the sound modules After that it worked with kopete, skype, etc.

  

Bluetooth
---------

    pacman -S bluez-libs bluez-utils

  

Card Reader
-----------

not tested yet. Detected in dmesg

  

Pointer
-------

Works out of the box. Works better with synaptics though

     pacman -S synaptics

add module synaptics to xorg.conf

Remote controle
---------------

Works out of the box using this

     pacman -S lirc lirc-utils

Then you add the following line into rc.local

     modprobe lirc_serial
     /etc/rc.d/lircd start

Check with dmesg that the module works!

Finger print reader
-------------------

     pacman -S pam_fprint fprint_demo

  

Quick play function keys
------------------------

All are detected by dmesg and can be configured!

Function keys for sound
-----------------------

Works out of the box

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_DV9757&oldid=196647"

Category:

-   HP
