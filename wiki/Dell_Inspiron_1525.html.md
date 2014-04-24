Dell Inspiron 1525
==================

This is an install and configuration guide for the Dell Inspiron 1525
laptop, testing with the 2010.05 installer snapshot.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Audio
    -   2.2 Video
    -   2.3 Keyboard
    -   2.4 Touchpad
    -   2.5 Wireless
        -   2.5.1 Intel PRO wireless
        -   2.5.2 Broadcom BCM4312
    -   2.6 Modem
    -   2.7 USB, SD card slot, ethernet, firewire, VGA, S-video, HDMI,
        webcam and mediakeys
    -   2.8 PCMCIA

Installation
------------

When the installation media has boot, hit TAB in the first entry and add
i915.modeset=0 to the options. Then hit ENTER to install.

Configuration
-------------

There are different many variants of this notebook. You will notice
differences in CPU and Wireless. Some models also have a webcam.

> Audio

There are two options to get audio working: ALSA and OSS. With ALSA the
sound works well, both headphone jacks work and volume can be set
independently. With OSS you will generally get better quality and louder
sound.

> Video

The notebook comes with the Intel GMA X3100 GPU, which uses the
xf86-video-intel driver. See Intel for datails.

Since xf86-video-intel 2.10, using KMS is mandatory, so do not use GRUB
Frame Buffer.

> Keyboard

Keyboard worked out of the box.

> Touchpad

Touchpad worked out of the box. To enable scroll and more, install
xf86-input-synaptics. With the default configuration file it will work
well, but if you want to fine tune the behavior, read Touchpad
Synaptics.

> Wireless

We have variations...

Intel PRO wireless

If

    $ lspci | grep -i net

shows something like:

    Network: PRO/Wireless 3945ABG [Golan] Network Connection module: iwl3945

You are required to get iwlwifi-3945-ucode out of [core].

    # pacman -S iwlwifi-3945-ucode

Then add iwl3945 to your MODULES array in /etc/rc.conf

    MODULES=( ... iwl3945 ... )

Broadcom BCM4312

If

    $ lspci | grep -i net

shows:

    Network controller: Broadcom Corporation BCM4312 802.11b/g LP-PHY (rev 01)

You can try two drivers, broadcom-wl from AUR, or b43 with the
b43-firmware from the kernel. The last one do not need to be rebuild
every time the kernel is upgraded.

> Modem

You need hsfmodem package from AUR in order to get modem working. After
you install that package you need to:

1.  Run hsfconfig as root to build the module and initialize the modem.
    A reboot is required before the modem can be initialized. Run
    hsfconfig again after reboot.
2.  The modules are automatically loaded and a /dev/modem symlink is
    setup for use with the modem. Now use wvdial or other dialer
    programs to connect to the internet.

Dialing has not been tested, however the modem device will show in /dev.

> USB, SD card slot, ethernet, firewire, VGA, S-video, HDMI, webcam and mediakeys

All work out of the box.

> PCMCIA

Not tested.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Inspiron_1525&oldid=239023"

Category:

-   Dell

-   This page was last modified on 6 December 2012, at 01:26.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
