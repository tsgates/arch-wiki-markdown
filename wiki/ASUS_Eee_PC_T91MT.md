ASUS Eee PC T91MT
=================

  ------------------------- ------------- ---------------
  Device                    Status        Modules
  Graphics                  Not working   Intel GMA 500
  Ethernet                  Working        ???
  Wireless                  Working        ???
  Audio                     Working        ???
  Camera                    Working       
  Card Reader               Working       
  Function Keys             Not working   
  Suspend2RAM               Working       pm-utils
  Hibernate                 Not working   
  Multi-touch touchscreen   Working       
  TV tuner                  Not working   
  ------------------------- ------------- ---------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing Arch                                                    |
|     -   1.1 Ethernet                                                     |
|     -   1.2 Sound                                                        |
|     -   1.3 Video                                                        |
|     -   1.4 Wireless                                                     |
|     -   1.5 Multi Touchscreen                                            |
|                                                                          |
| -   2 Suspend                                                            |
| -   3 Hardware                                                           |
| -   4 More Resources                                                     |
+--------------------------------------------------------------------------+

Installing Arch
===============

This wiki page supplements these pages: Beginners Guide, the Official
Install Guide, and Installing Arch Linux on the Asus EEE PC. Please
refer to those guides first before following the eeepc-specific pointers
on this page.

Ethernet
--------

Ethernet works "out of the box" with no additional configuration.

Sound
-----

Sound works as per the Beginners Guide instructions.

Video
-----

Check how to use Poulsbo. Works fine with the psb driver, mplayer-vaapi
and libva-freeworld.

Wireless
--------

Wireless works as described in the Beginners Guide with the 2.6.33
kernel. Unencrypted, WEP, WPA-PSK and WPA2 connections are confirmed
working.

Multi Touchscreen
-----------------

Seems to work out of the box with Xorg 1.9 and kernel 2.6.36, but needs
to be calibrated.

  
 to install driver do these steps:

1. install dkms [1] from AUR

2. download the hid-mosart driver for multitouch support for Asus
T91MT : [2]

unpack it with 'ar vx hid-mosart-dkms_1.0.0_all.deb'

unpack data.tar.gz and copy hid-mosart-1.0.0.dkms.tar.gz file in
data.tar.gz/usr/src to /usr/src/hid-mosart-1.0.0.dkms.tar.gz

unpack control.tar.gz and run './postinst configure' in control.tar.gz
as root user

4. reboot

Note that you do not need to change xorg.conf but ensure that the module
installed by 'modprobe -l "hid-mosart*"'

Suspend
=======

The system can be suspended using pm-suspend without additional
configuration:

    pm-suspend

Hardware
========

    $ lspci
    00:00.0 Host bridge: Intel Corporation System Controller Hub (SCH Poulsbo) (rev 07)
    00:02.0 VGA compatible controller: Intel Corporation System Controller Hub (SCH Poulsbo) Graphics Controller (rev 07)
    00:1b.0 Audio device: Intel Corporation System Controller Hub (SCH Poulsbo) HD Audio Controller (rev 07)
    00:1c.0 PCI bridge: Intel Corporation System Controller Hub (SCH Poulsbo) PCI Express Port 1 (rev 07)
    00:1c.1 PCI bridge: Intel Corporation System Controller Hub (SCH Poulsbo) PCI Express Port 2 (rev 07)
    00:1d.0 USB Controller: Intel Corporation System Controller Hub (SCH Poulsbo) USB UHCI #1 (rev 07)
    00:1d.1 USB Controller: Intel Corporation System Controller Hub (SCH Poulsbo) USB UHCI #2 (rev 07)
    00:1d.2 USB Controller: Intel Corporation System Controller Hub (SCH Poulsbo) USB UHCI #3 (rev 07)
    00:1d.7 USB Controller: Intel Corporation System Controller Hub (SCH Poulsbo) USB EHCI #1 (rev 07)
    00:1f.0 ISA bridge: Intel Corporation System Controller Hub (SCH Poulsbo) LPC Bridge (rev 07)
    00:1f.1 IDE interface: Intel Corporation System Controller Hub (SCH Poulsbo) IDE Controller (rev 07)
    01:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
    03:00.0 Ethernet controller: Atheros Communications Atheros AR8132 / L1c Gigabit Ethernet Adapter (rev c0)

More Resources
==============

Asus Eee PC General Guide for EEE PCs on Arch

Using Poulsbo on Arch

Ubuntu T91MT Howto lots of detailed information, most of it applicable
to Arch

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_T91MT&oldid=208431"

Category:

-   ASUS
