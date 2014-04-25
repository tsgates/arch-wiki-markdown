ASUS AT3IONT-I
==============

This page describes the steps necessary to get all of the features of
the ASUS AT3IONT-I working correctly. It assumes you already
successfully installed Arch Linux and installed the basic software (ALSA
for audio, wireless_tools and wpa_supplicant packages for wireless in
the Deluxe edition, etc.)

Contents
--------

-   1 Audio over HDMI
    -   1.1 Alsa
    -   1.2 Pulseaudio
-   2 Deluxe Edition
    -   2.1 Bluetooth
    -   2.2 Wireless
    -   2.3 RCA Stereo Output
    -   2.4 Remote
-   3 Resources

Audio over HDMI
---------------

> Alsa

Many ION boards exhibit problems when trying to play sound through HDMI.
They usually require a custom ALSA configuration via /etc/asound.conf
(or, alternatively, on a per-user basis via ~/.asound.conf).

    /etc/asound.conf

    # Needed in order to get sound over HDMI to function

    #$ aplay -l
    # **** List of PLAYBACK Hardware Devices ****
    # card 0: NVidia [HDA NVidia], device 0: ALC887 Analog [ALC887 Analog]
    #   Subdevices: 1/1
    #   Subdevice #0: subdevice #0
    # card 0: NVidia [HDA NVidia], device 1: ALC887 Digital [ALC887 Digital]
    #   Subdevices: 1/1
    #   Subdevice #0: subdevice #0
    # card 0: NVidia [HDA NVidia], device 3: NVIDIA HDMI [NVIDIA HDMI]
    #   Subdevices: 1/1
    #   Subdevice #0: subdevice #0

    pcm.!default {
      type plug
      slave.pcm "dmix:0,3"
    }

Note:Audio over HDMI is designated by the S/PDIF 1 channel in alsamixer.
You will need to unmute that channel in addition to configuring
/etc/asound.conf.

Also, please note that audio over HDMI currently only works in an X
session (graphical environment). If you are trying to get the sound to
work when running on a virtual terminal, it won't work. Please see this
post on the Arch Forums.

Tip:Please also see ALSA for more information

> Pulseaudio

If you are loathe to mess with your pulseaudio settings in asound.conf,
it might be enough to just unmute the S/PDIF 1 channel in alsamixer.
It's hidden, as you need to press F6, then select "HDA NVidia" and
scroll to the far right before you can find it. Highlight it, and then
press "M" to unmute.

Deluxe Edition
--------------

The deluxe edition comes with a few extra goodies, such as DC power
on-board, mini-PCI WiFi, RCA stereo output, on-board Blutooth, and an
included IR Remote.

> Bluetooth

The Bluetooth chip is an Atheros with a device ID of 0cf3:3002. It uses
the ath3k driver which has been included in the kernel since ~2.6.33 and
works out of the box with the default Arch kernel.

Tip:Please see Bluetooth for more information.

> Wireless

The wireless chipset is an Atheros AR9285.

    $ lspci | grep Net

    05:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)

It uses the ath9k driver, which has been included in the default kernel
since 2.6.27. In other words, udev should load the driver without
problems -- there should be no extra configuration to get wireless
working on the ASUS AT3IONT-I.

Tip:Please see Wireless network configuration#ath9k for more information

> RCA Stereo Output

Untested.

> Remote

Special thanks to pj7 of the Ubuntu forums for putting together a
working driver for the receiver.

The included IR receiver requires a kernel module to be built to
accommodate it. Apparently, it is a rather tricky little device. It
seems to work best with the included remote -- it coverts the included
remotes' button presses directly to keyboard keystrokes, but when using
another MCE remote it reports to the system the raw code. It seems to
understand other signals, but you will need a remote that sends the
right signal. This results in limited functionality of the device where
it can only use the included ASUS remote, a JP1 Programmable remote (to
program the known signals), or a universal remote that has the ability
to learn the IR signals of the ASUS remote.

As a result, this section will focus on getting the included remote
working with the included receiver, based on pj7's driver.

Tip:It might be easier to just buy a decent IR receiver/remote combo
that is know to work well in Linux to get the most functionality. But if
you're stubborn, read on!

 Note: 
    If you know more about the nitty gritty aspects of kernel driver
    development and IR remotes, please take a look at this thread to see
    if functionality can be added to this driver, especially for basic
    MCE remotes.

Download the source and then extract with tar -xvf hid-philips-asus.tar.
The resulting directory will include the source files, along with a
Linux-to-X11 input key map. Before you build the source, you must edit
mappings.h. This file maps the button presses to Linux input keys. Be
aware that Linux input does not equal X11 input. Graphical programs,
such as media players, XBMC, and the like, are only aware of X11 inputs,
and so you must match a X11 input with a Linux input to. That's what the
map_linux_to_x11.txt file is for.

For example, if you wish to define the "Next Track" button as
"XF86AudioNext" (which most programs will look for to play the next item
in the playlist), you will need to define BUTTON_NEXT in mappings.h as
KEY_NEXTSONG rather than KEY_NEXT. This is because KEY_NEXTSONG maps to
"XF86AudioNext" (KEY_NEXT doesn't register as anything).

Once you've finished mapping the buttons, run make:

    $ make

    make -C /lib/modules/2.6.36-ARCH/build M=/home/user/hid-philips-asus modules
    make[1]: Entering directory `/usr/src/linux-2.6.36-ARCH'
      CC [M]  /home/user/hid-philips-asus/hid-philips-asus.o
      Building modules, stage 2.
      MODPOST 1 modules
      CC      /home/user/hid-philips-asus/hid-philips-asus.mod.o
      LD [M]  /home/user/hid-philips-asus/hid-philips-asus.ko
    make[1]: Leaving directory `/usr/src/linux-2.6.36-ARCH'

Install the driver with make install (as root).

Now we must make sure the driver loads correctly. One thing that you
must do is blacklist the mceusb driver that tries to load whenever the
IR Reciever is detected. Then you must make sure that the new
hid-philips-asus driver loads before usbhid as usbhid will try to take
over the receiver. This can all be easilly accomplished by the MODULES
line in /etc/rc.conf:

    /etc/rc.conf

    MODULES=(... hid-philips-asus usbhid ...)

You have to blacklist mceusb in /etc/modprobe.d:

    /etc/modprobe.d/modprobe.conf

    blacklist mceusb

(rebooting the computer might be necessary)

After that, all the buttons on the Asus remote should work. If you find
that you would rather assign different actions to button presses, it is
easy to edit the mappings.h file and make && make install again.
Alternatively, you may be interested in Xmodmap.

Resources
---------

ASUS AT3IONT-I deluxe on Ubuntu forums

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_AT3IONT-I&oldid=297871"

Category:

-   Mainboards and BIOS

-   This page was last modified on 15 February 2014, at 15:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
