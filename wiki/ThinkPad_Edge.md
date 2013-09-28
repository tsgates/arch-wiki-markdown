ThinkPad Edge
=============

Note:This article will be updated from time to time and is currently (as
of 2010/09/5) processed by User:ProfWho

Summary

How to setup archlinux on Lenovo ThinkPad Edge 13

Required hardware

Thinkpad Edge 13 (Lenovo) - This guide has been written aside the
ThinkPad Edge AMD version with ATI-graphics.

Related

[[1]]

This article was written to assist you with getting archlinux run on the
Lenovo ThinkPad Edge 13. It is meant to be help you with some tricky
points aside to the Beginners' Guide: A guide through the whole process
of installing and configuring Arch Linux; written for new or
inexperienced users.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prerequisits                                                       |
|     -   1.1 BIOS-Update:                                                 |
|     -   1.2 Creating an installation medium                              |
|                                                                          |
| -   2 Installation                                                       |
|     -   2.1 WLAN driver installation                                     |
|         -   2.1.1 Deauthentication Issues                                |
|                                                                          |
|     -   2.2 Audio                                                        |
|     -   2.3 Video                                                        |
|     -   2.4 Touchpad                                                     |
|     -   2.5 Frequency scaling                                            |
|     -   2.6 Fan control                                                  |
|     -   2.7 Webcam                                                       |
|     -   2.8 Suspend                                                      |
+--------------------------------------------------------------------------+

Prerequisits
------------

First and important to do is an BIOS-Update (As of 2010/08/20 to Version
1.19.)

This was done, by using grub4dos, one can get here. Because a simple dd
didn't create a bootable USB-Stick for me.

> BIOS-Update:

Download grub4dos.

Unpack it on another *nix-box and run:

     sudo ./bootlace.com /dev/sdX

with /dev/sdX being your USB-Stick (as the Thinkpad Edge 13 has no
CDROM-Drive) in the directory, where you unpacked your files.

Afterwards copy grldr and menu.lst to the device:

     cp grldr /media/USBSTICK
     cp menu.lst /media/USBSTICK

Download the BIOS update from the BIOS section on this support site.
Pick the one that matches your current BIOS Id. Copy the iso-file to the
/ directory of the USB-Stick!

Finally you have to add the following code to the menu.lst on your
pendrive to make the USB-Stick boot the PC DOS program made by lenovo:

     title Thinkpad-Edge-BIOS-UPDATE
     find --set-root /6yuj06uc.iso
     map /6yuj06uc.iso (0xff) || map --mem /6yuj06uc.iso (0xff)
     map --hook
     chainloader (0xff)
     boot

Inserting such a prepared USB-Stick into your Thinkpad Edge, and things
should be self-explanatory after that.

> Creating an installation medium

To create a bootable USB-Stick with the archlinux*.iso you downloaded,
simply:

     dd bs=8M if=archlinux*.iso of=/dev/sdX

which will/should behave like a regular bootable CD-Rom in addition to a
capable BIOS and the correct bootsequence! In doubt or in case of
problems see Install from a USB flash drive for more detailed
instructions.

Installation
------------

After that it is recommended to follow the usual installation procedure
described in the Beginners' Guide up to the part 2, as the installation
of the wireless lan card needs some further work.

> WLAN driver installation

See Wireless Setup#rtl8192s.

Deauthentication Issues

If you are using the rtl8192ce module, you may experience some
intermittant deauthentication issues with newer kernels (tested on
3.4.4-2-ARCH). If this is the case, you need to add some options to
/etc/modprobe.d/rtl8192ce.conf (courtesy of Lord_Lizard in this thread
[2])

> Audio

To get jack sensing to work add:

     options snd-hda-intel model="olpc-xo-1_5"

to /etc/modprobe.d/modprobe.conf.

> Video

If you have the AMD-AMD model you can use the free ati drivers.

     pacman -S xorg-server xf86-video-ati

These drivers give enough horsepower for compiz and video playback.

> Touchpad

A synaptics touchpad with two-finger scrolling.

     pacman -S xf86-input-synaptics

> Frequency scaling

The Turion work well with powernow-k8. Please refer to the wiki for more
information on cpufrequtils. Dont forget to add powernow-k8 to your
modules array.

> Fan control

Add the follwing line to your /etc/modprobe.d/modprobe.conf

     options thinkpad_acpi fan_control=1

Then you can manually set your fanspeed with:

     echo level 7 > /proc/acpi/ibm/fan
     cat /proc/acpi/ibm/fan # for more commands.
     # Other files will report their status and commands when read too.

> Webcam

Works out of the box. Test with

     mplayer tv:// -tv driver=v4l2

If you use skype and the video is way to dark, skype forgot to enable
automatic exposure control. Install v4l2 control and set it yourself.
You need to to do it everytime you use skype.

     pacman -S v4l2-utils
     v4l2-utils -c exposure_auto_priority 1

Your video should gradually begin to brighten up. More options:

     v4l2-utils -l

> Suspend

First, you might need to add the following to your kernel commandline if
suspend does not work. Newer models do not require the following hacks,
so make sure that neither suspend nor wifi works.

     kernel root= ... acpi_osi=linux noapic

Second, your wifi card will delay resume by roughly 2 minutes. That
means that your laptop is not frozen but still resuming. Wifi wont want
to work, too. This can be worked around by removing the wifi modules
before suspend. You can do this automatically if you use pm-utils.
Please refer for more information to the pm-utils wiki article. Below
follows my /etc/pm/sleep.d/100wifiworkaround.sh script for automation

     #!/bin/bash
     #
     case $1 in
       hibernate)
         ifconfig wlan0 down
         rmmod rtl8192ce
         rmmod r8169
         ;;
       thaw)
         modprobe rtl8192ce # Pulls r8169 in
         ;;
       sleep)
         ifconfig wlan0 down
         rmmod rtl8192ce
         rmmod r8169
         ;;
       resume)
         modprobe rtl8192ce
         ;;
       *)
         echo "I dont do that. Read me first please."
         ;;
     esac

Retrieved from
"https://wiki.archlinux.org/index.php?title=ThinkPad_Edge&oldid=250565"

Category:

-   Lenovo
