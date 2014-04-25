Toshiba Satellite A300D
=======================

Contents
--------

-   1 ACPI and Power Saving
-   2 Networking
-   3 Wireless
-   4 Audio
-   5 Graphics
-   6 Framebuffer
-   7 Modem
-   8 Touchpad
-   9 SD card reader
-   10 FireWire
-   11 DVD-RW

ACPI and Power Saving
---------------------

Power saving works well. Screen dimming works, CPU frequency can be
controlled with cpufreq. Sleep and resume, reboot, and other options
will work out of the box with XFCE, untested otherwise.

Networking
----------

Marvell Technology Group Ltd. 88E8040T Ethernet Controller. Works fine.

Wireless
--------

Atheros Communications Inc. AR5008 Wireless Network Adapter. Works fine
with ath9k (included in kernel since 2.6.27), tested with wicd and
netcfg.

Audio
-----

All audio works fine. Hardware volume control works with hotkeys in XFCE
and in Openbox by adding the following to the keyboard section of
~/.config/openbox/rc.xml:

    <!-- keybindings for media keys -->
        <keybind key="XF86AudioLowerVolume">
          <action name="Execute">
            <execute>amixer set Master 5- unmute</execute>
          </action>
        </keybind>
        <keybind key="XF86AudioRaiseVolume">
          <action name="Execute">
            <execute>amixer set Master 5+ unmute</execute>
          </action>
        </keybind>
      

Graphics
--------

ATI Technologies Inc. Mobility Radeon HD 3650. 2D support works fine
with xf86-video-ati. WARNING: HD video will be laggy and full of
artifacts. Catalyst drivers not recommended - will provide 3D support,
but are buggy and cause crashes and freezing.

Framebuffer
-----------

Works fine at 1024x768.

Modem
-----

Not tested.

Touchpad
--------

ALPS touchpad, will work fine with Synaptics configuration options.
Works out of the box with XFCE and Openbox.

SD card reader
--------------

O2 Micro, Inc. Somewhat tested, does not work well.

FireWire
--------

Untested but should work.

DVD-RW
------

From /proc/scsi/scsi:

    Host: scsi0 Channel: 00 Id: 00 Lun: 00
      Vendor: PIONEER  Model: DVD-RW  DVRTD08A Rev: 1.50
      Type:   CD-ROM                           ANSI  SCSI revision: 0

Tested for reading, ripping, and burning CDs and DVDs. Works fine.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Toshiba_Satellite_A300D&oldid=196742"

Category:

-   Toshiba

-   This page was last modified on 23 April 2012, at 13:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
