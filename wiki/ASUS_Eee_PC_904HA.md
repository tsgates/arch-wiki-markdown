ASUS Eee PC 904HA
=================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing Arch                                                    |
| -   2 Custom Kernel                                                      |
|     -   2.1 Wifi                                                         |
|     -   2.2 Ethernet                                                     |
|     -   2.3 Sound/Microphone                                             |
|     -   2.4 Video/LCD backlight                                          |
|     -   2.5 Webcam                                                       |
|     -   2.6 Multimedia Keys/Hotkeys                                      |
|     -   2.7 Notes                                                        |
+--------------------------------------------------------------------------+

Installing Arch
===============

The installation process for the 904HA consists of a standard USB stick
installation. With installation version 2008.06, wifi will not work
after installing, and ethernet may not either. To be safe for now, you
may want to download the Core installation image and transfer the latest
kernel sources to your Eee through some means after installing Arch -
reuse your USB stick. You could then proceed to compiling a custom
kernel following the instructions on this page.

Custom Kernel
=============

Everything one needs to run a fully functional Eee 904HA is in the
vanilla 2.6.28 kernel. You need no patches or any other fancy thing. The
following will outline the bare essentials one would need in building a
custom kernel. If you do not want to build most of this stuff as
modules, don't, but module names are listed regardless for just-in-case
rc.conf convenience.

Several things require that you have the following enabled in the
menuconfig:

    General setup --->
         [*] Prompt for development and/or incomplete code/drivers

Wifi
----

    [*] Networking Support --->
         [*] Wireless --->
              [*] Generic IEEE 802.11 Networking Stack (mac80211)
         <*> RF switch subsystem support --->
              <*> Input layer to RF switch connector
    ...
    Device drivers --->
         [*] Networking device support --->
              Wireless LAN --->
                   [*] Wireless LAN (IEEE 802.11)
                        <M> Atheros 5xxx wireless cards support

Wifi card kernel module name: ath5k

Your Wifi toggle hotkey will not work unless you have the above RF
switch support.

Ethernet
--------

    Device drivers --->
         [*] Networking device support --->
              [*] Ethernet (1000 MBit) --->
                   <M> Atheros L1E Gigabit Ethernet support

Kernel module name: atl1e

Sound/Microphone
----------------

    <M> Sound card support --->
         <M> Advanced Linux Sound Architecture --->
              [*] PCI sound devices --->
                   <M> Intel HD Audio
                        [*] Build Realtek HD-audio codec support
                        [ ] Aggressive power-saving on HD-audio
                        (0)    Default time-out for HD-audio power-save mode

Kernel module name: snd-hda-intel

If your Eee isn't regularly playing any sounds or music, you may be
interested in enabling the Aggressive power-saving to power your sound
off.

Video/LCD backlight
-------------------

    Device Drivers --->
         Graphics Support --->
              <M> /dev/agpgart (AGP Support) --->
                   <M> Intel 440LX/BX/GX, I8xx and E7x05 chipset support
              <M> Direct Rendering Manager (XFree86 4.1.0 and higher DRI support) --->
                   <M> Intel 830M, 845G, 852GM, 855GM, 865G
                   <M>    i915 driver
              [*] Backlight & LCD device support --->
                   <*> Lowlevel LCD controls
                   <*> Lowlevel Backlight controls

Video driver kernel module name: intel-agp

Everything works out of the box when using this video driver. Xorg works
fine without a xorg.conf, including DRI.

Webcam
------

    Device Drivers --->
         Multimedia Devices --->
              <M> Video For Linux
              [*] Enable Video For Linux API 1 compatible Layer
              [*] Video capture adapters --->
                   [*] Autoselect pertinent encoders/decoders and other helper chips
                   [*] V4L USB devices --->
                        <M> USB Video Class (UVC)
                        [*]    UVC input events device support

Kernel module name: uvcvideo

Multimedia Keys/Hotkeys
-----------------------

The following driver will allow most (but not all at the time of
writing, kernel 2.6.28) of your Fn hotkeys to work properly, including
F8 through F12. Note that the LCD backlight buttons work without this
driver. Maybe the Wifi toggle does too.

    Device Drivers --->
             Misc devices --->
                  <M> Eee PC Hotkey Driver
         <M> Hardware Monitoring support --->

Yes, hardware monitoring support is required (module: hwmon - but would
be loaded automatically when loading the hotkey module of course), as is
the RF switch support from the Wifi section.

Hotkey driver kernel module name: eeepc-laptop

Notes
-----

Do not enable any of the "ASUS Laptop" options you might find in ACPI or
Misc devices menus (unless they're Eee specific, of course.) They do not
pertain to Eees and will fail to load if built as modules and manually
attempted.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_904HA&oldid=208423"

Category:

-   ASUS
