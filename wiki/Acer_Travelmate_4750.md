Acer Travelmate 4750
====================

  --------------------- ---------------------- ------------------
  Device                Status                 Modules/package
  Intel graphics        Working                xf86-video-intel
  Ethernet & Wireless   Working                ath9k
  Audio                 Working                intel
  Touchpad              Working                
  Camera                Working                uvcvideo
  Card Reader           untested               
  Function Keys         partial Work           
  Suspend               Working, look bellow   
  --------------------- ---------------------- ------------------

2012/08/02 Setup ArchLinux by just copy file system from old machine. I
changed the /etc/fstab and install xf86-video-intel, it works now.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
|     -   1.1 Standard Hardware                                            |
|     -   1.2 Command Outputs                                              |
|         -   1.2.1 lsusb                                                  |
|         -   1.2.2 lspci                                                  |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 CPU                                                          |
|     -   2.2 Video                                                        |
|         -   2.2.1 Intel                                                  |
|                                                                          |
|     -   2.3 Audio                                                        |
|     -   2.4 Touchpad                                                     |
|     -   2.5 Webcam                                                       |
|     -   2.6 Function keys                                                |
|                                                                          |
| -   3 Testing baseline                                                   |
| -   4 TODO                                                               |
+--------------------------------------------------------------------------+

Hardware
--------

> Standard Hardware

This is dlin's machine spec. For full spec, refer acer site.

-   CPU & Chipset:Intel® Core™ i5-2410M/i5-2520M/i5-2540M processor (3
    MB L3 cache, 2.30/2.50/2.60 GHz with Turbo Boost up to
    2.90/3.20/3.30 GHz, DDR3 1333 MHz, 35 W), supporting Intel® 64
    architecture, Intel® Smart Cache
-   RAM: Dual-channel DDR3 SDRAM 1333MHz 4GB
-   Display: 14.0" HD 1366 x 768 resolution, Acer ComfyView LED-backlit
    TFT LCD

> Command Outputs

lsusb

    Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 001 Device 004: ID 15d9:0a4f Trust International B.V. 
    Bus 001 Device 003: ID 064e:c21c Suyin Corp.

lspci

    00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
    00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04) 
    00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev  04)
    00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 04)
    00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b4)
    00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 (rev b4)
    00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b4)
    00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
    00:1f.0 ISA bridge: Intel Corporation HM65 Express Chipset Family LPC Controller (rev 04)
    00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 04)
    00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 04)
    02:00.0 Network controller: Atheros Communications Inc. AR9287 Wireless Network Adapter (PCI-Express) (rev 01)
    03:00.0 Ethernet controller: Broadcom Corporation NetLink BCM57785 Gigabit Ethernet PCIe (rev 10)

Configuration
-------------

> CPU

Works out of the box.

Follow the CPU Frequency Scaling guide to enable speed-stepping.
Processor has Intel Turbo Boost which works out of the box, but you
can't see the frequncies above 2.5GHz in /proc/cpuinfo. To see the
actual frequency use i7z package.

-   energy save: cpufrequtils (800Mhz-2.5Mhz)

> Video

Intel

Follow these guides: Xorg and Intel

Not tested: VGA out and HDMI.

> Audio

Follow the official documentation: ALSA and Pulseaudio

In order to make integrated speakers work add to
/etc/modprobe.d/modprobe.conf:

    options snd-hda-intel index=0 model=auto

And to /etc/modprobe.d/sound.conf add:

    alias snd-card-0 snd-hda-intel
    alias sound-slot-0 snd-hda-intel

> Touchpad

Follow the Synaptics guide.

> Webcam

Working, you may install cheese(with gstreamer-0.10-plugins) to view.

> Function keys

-   workable

    * Fn+F3: Toggle Wifi (or use slider on right-bottom corner of keyboard)
    * Fn+F4: Suspend to ram
    * Fn+F6: Toggle back-light to save battery
    * Fn+F7: Toggle touchpad
    * Fn+Left/Right adjust back-light (XF86MonBrightnessDown/XF86MonBrightnessUp) (add acpi_osi=Linux option on linux boot)

-   Failed Fn keys

    * Fn+F5 toggle VGA (XF86Display)
    * Fn+F8 toggle speaker (XF86AudioMute)
    * Fn+Up/Down adjust speaker volume (XF86AudioRaiseVolume/XF86AudioLowerVolume)
    * Fn+Home Play/Pause(XF86AudioPlay)
    * Fn+PgUp Stop(XF86AudioStop)
    * Fn+PgDn Seek back(XF86AudioPrev)
    * Fn+End Seek Forward(XF86AudioNext)
    * 'Euro','$' key

Testing baseline
----------------

-   kernel: linux 3.4.7-1 2012-08-02

  

TODO
----

-   turn off bluetooth

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Travelmate_4750&oldid=220680"

Category:

-   Acer
