Acer Travelmate 4750
====================

  --------------------- ----------- ------------------
  Device                Status      Modules/package
  Intel graphics        Working     xf86-video-intel
  Ethernet & Wireless   Working     ath9k
  Audio                 Working     intel
  Touchpad              Working     
  Camera                Working     uvcvideo
  Card Reader           Working     
  Function Keys         most Work   
  Suspend               Working     
  --------------------- ----------- ------------------

2012/08/02 Setup ArchLinux by just copy file system from old machine. I
changed the /etc/fstab and install xf86-video-intel, it works now.

Contents
--------

-   1 Hardware
    -   1.1 Standard Hardware
    -   1.2 Command Outputs
        -   1.2.1 lsusb
        -   1.2.2 lspci
-   2 Configuration
    -   2.1 kernel boot parameters
    -   2.2 CPU
    -   2.3 Video
        -   2.3.1 Intel
    -   2.4 Audio
    -   2.5 Touchpad
    -   2.6 Webcam
    -   2.7 Function keys
-   3 Testing baseline
-   4 TODO

Hardware
--------

> Standard Hardware

This is dlin's machine spec. For full spec, refer cnet site.

-   CPU & Chipset:Intel® Core™ i5-2410M/i5-2520M/i5-2540M processor (3
    MB L3 cache, 2.30/2.50/2.60 GHz with Turbo Boost up to
    2.90/3.20/3.30 GHz, DDR3 1333 MHz, 35 W), supporting Intel® 64
    architecture, Intel® Smart Cache
-   RAM: Dual-channel DDR3 SDRAM 1333MHz 4GB
-   Display: 14.0" HD 1366 x 768 resolution, Acer ComfyView LED-backlit
    TFT LCD

> Command Outputs

lsusb

    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 001 Device 004: ID 064e:c21c Suyin Corp. 
    Bus 002 Device 004: ID 0489:e03c Foxconn / Hon Hai 

lspci

    00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
    00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
    00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
    00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 04)
    00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b4)
    00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 (rev b4)
    00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b4)
    00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
    00:1f.0 ISA bridge: Intel Corporation HM65 Express Chipset Family LPC Controller (rev 04)
    00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 04)
    00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 04)
    02:00.0 Network controller: Qualcomm Atheros AR9287 Wireless Network Adapter (PCI-Express) (rev 01)
    03:00.0 Ethernet controller: Broadcom Corporation NetLink BCM57785 Gigabit Ethernet PCIe (rev 10)
    03:00.1 SD Host controller: Broadcom Corporation NetXtreme BCM57765 Memory Card Reader (rev 10)
    03:00.2 System peripheral: Broadcom Corporation Device 16be (rev 10)
    03:00.3 System peripheral: Broadcom Corporation Device 16bf (rev 10)

Configuration
-------------

> kernel boot parameters

To let kernel bootable, acpi workable, and CPU on demand. These
pararmeters should be added into boot loader kernel option (eg. grub).

acpi_osi=Linux intel_pstate=disable

> CPU

Follow the CPU Frequency Scaling guide to enable speed-stepping.
Processor has Intel Turbo Boost which works out of the box, but you
can't see the frequncies above 2.5GHz in /proc/cpuinfo. To see the
actual frequency use i7z package.

-   energy save: cpupower (800Mhz-2.5Mhz)

> Video

Intel

Follow these guides: Xorg and Intel

VGA out: workable by xrandr settings.

Not tested: HDMI.

> Audio

Follow the official documentation: ALSA and Pulseaudio

In order to make integrated speakers work add to
/etc/modprobe.d/modprobe.conf:

    options snd-hda-intel index=0 model=auto

And to /etc/modprobe.d/sound.conf add:

    alias snd-card-0 snd-hda-intel
    alias sound-slot-0 snd-hda-intel

> Touchpad

-   Follow the Synaptics guide.
-   Disable touchpad upon external mouse detection

> Webcam

Install cheese(with gstreamer-0.10-plugins) to view.

> Function keys

-   support by kernel

    * Fn+F3: Toggle Wifi (or use slider on right-bottom corner of keyboard)
    * Fn+F6: Toggle back-light to save battery
    * Fn+F7: Toggle touchpad
    * Fn+Left/Right adjust back-light (XF86MonBrightnessDown/XF86MonBrightnessUp) (add acpi_osi=Linux option on linux boot)

-   supported by acpid /etc/acpi/handler.sh

    systemctl start acpid
    systemctl enable acpid  # keep it workable for next boot

    * Fn+F4: Suspend to ram
    * Fn+F5 toggle VGA (XF86Display)
    * Fn+F8 toggle speaker (XF86AudioMute)
    * Fn+Up/Down adjust speaker volume (XF86AudioRaiseVolume/XF86AudioLowerVolume)
    * Fn+Home Play/Pause(XF86AudioPlay)
    * Fn+PgUp Stop(XF86AudioStop)
    * Fn+PgDn Seek back(XF86AudioPrev)
    * Fn+End Seek Forward(XF86AudioNext)

    # use acpi_listen to check button name, modify /etc/acpi/handler.sh

        #...
        button/sleep)
            case "$2" in
                SLPB|SBTN)
                    logger 'SleepButton pressed'
    		echo -n mem > /sys/power/state
                    ;;
                *)
                    logger "ACPI action undefined: $2"
                    ;;
            esac
            ;;
        #...
        button/volumeup)
    		logger "VOLUP"
    		amixer set Master 5%+
    		;;
        button/volumedown)
            logger "VOLDN"
    		amixer set Master 5%-
    		;;
        button/mute)
            logger "MUTE" # still buggy, require 4 times to turn on
    		amixer set Master toggle
    		amixer set Headphone toggle
    		amixer set Speaker toggle
    		;;
        cd/play)
            logger "CDPLAY"
    		;;
        cd/stop)
            logger "CDSTOP"
    		;;
        cd/prev)
            logger "CDPREV"
    		;;
        cd/next)
            logger "CDNEXT"
    		;;

-   keys which can not workable

    * 'Euro','$' key

Testing baseline
----------------

-   kernel: 3.10.3-1-aufs_friendly 2013-08-17

TODO
----

-   turn off bluetooth

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Travelmate_4750&oldid=271414"

Category:

-   Acer

-   This page was last modified on 17 August 2013, at 05:23.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
