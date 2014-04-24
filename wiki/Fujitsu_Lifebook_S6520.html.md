Fujitsu Lifebook S6520
======================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The LifeBook S6520’s compact size, light-weight, and travel-friendly
features make it my favorite laptop. The notebook features a 14.1-inch
LED screen with a 1280 x 800 resolution, while the dimensions and weight
of which are as a 13.3-inch model. The default Operation System is
Windows® Vista™, however Arch Linux runs well on it, because "Fujitsu
offer best-in-class support for Linux".

Contents
--------

-   1 Hardware specifications
-   2 Running Arch on the S6520
    -   2.1 Intel Core 2 Duo
    -   2.2 The TFT panel and graphics card
    -   2.3 Setting up X.Org
    -   2.4 Networking support
        -   2.4.1 Gigabit Ethernet controller
        -   2.4.2 Wireless LAN support
        -   2.4.3 Bluetooth support
        -   2.4.4 Infrared communication support
        -   2.4.5 General networking tips
    -   2.5 Sound support
    -   2.6 Modem
    -   2.7 FireWire
    -   2.8 AuthenTec AES2501 fingerprint reader
    -   2.9 ACPI
    -   2.10 Tactile strip
        -   2.10.1 Suspension and hibernation
-   3 Device information
    -   3.1 lspci output
    -   3.2 lsusb output
-   4 See also

Hardware specifications
-----------------------

-   BIOS: Phoenix (07/09/08)
-   Intel Core 2 Duo T8600 / T9400
-   Samsung 2 GB DDR3-1066 SDRAM
-   14.1" 1280x800 WXGA (FUJ5112)
-   WDC WD2500BEVS-16UST0 ATA Device (250G SATA hard disk)
-   MATSHITA DVD-RAM UJ862BJ ATA Device (DVD-RW & CD-RW)
-   FUJITSU FJNB1E6 Mainboard (Intel GM45) with Intel GMA 4500 MHD
    onboard GPU
-   Intel® WiFi Link 5300 AGN (IPW5300) with wireless hardware switch
-   Marvell Yukon 88E8055 PCI-E Gigabit Ethernet Controller
-   Realtek ALC269 - High Definition Audio Controller
-   AuthenTec Inc. AES2501A fingerprint reader
-   Logitech Webcam
-   Agere Systems HDA modem
-   built-in Bluetooth RFCOMM from Toshiba, and SMSC Fast Infrared
    Device
-   5-in-1 card reader (supporting MMC/SD, MS/xD, MemoryStick, etc.)
-   3 x USB 2.0, 1x FireWire 400 4-pin connector, VGA and S-Video ports

Running Arch on the S6520
-------------------------

In order to get the most out of the S6520, you had better choose a Linux
distribution that has a latest kernel, the version of which at least
2.6.27, otherwise your wireless card (and maybe the sound card) will not
work. Arch Linux is the very distribution that always has a latest
kernel.

> Intel Core 2 Duo

Automatic frequency throttling and voltage adjustment can be enabled by
loading the acpi_cpufreq module (this one is to be preferred over the
Intel Speedstep ones; those will be deprecated soon). Install cpufreqd,
which will pull in cpufreq-utils along with it. Set up both utilities,
and add cpufreqd as a daemon to your DAEMONS=() array (in /etc/rc.conf,
that is).

> The TFT panel and graphics card

The laptop's TFT panel features a resolution of 1280x800, which however
is not present on the i915 chipset's BIOS and one has to use KMS to
support this resolution mode.

The video card (Intel GMA 4500MHD) is supported by xf86-video-intel.

    # pacman -S xf86-video-intel

> Setting up X.Org

> Networking support

Gigabit Ethernet controller

No setup required for the wired LAN Controller (Marvell Yukon 88E8055),
it just needs the sky2 kernel module.

Wireless LAN support

It needs the iwlagn module. And a firmware also need to be installed:
iwlwifi-5000-ucode.

     # pacman -S iwlwifi-5000-ucode

Bluetooth support

Prerequisites:

-   bluez-libs
-   bluez-utils

The laptop's Bluetooth HCI is supported by BlueZ, the Linux Bluetooth
Stack. The device is detected automatically and using BlueZ's daemons I
even managed to get a TCP/IP-over-Bluetooth (PAN) network going. See
Bluetooth.

Infrared communication support

Prerequisites:

-   irda-utils

Under Linux the notebook's infrared port is viewed as /dev/ttyS3. Under
Arch Linux you just need to install the irda-utils package and configure
/etc/conf.d/irda as follows:

    # Parameters to be passed to irattach
    #
    DEVICE=/dev/ttyS3
    #DONGLE=actisys+
    DISCOVERY=yes

All you have to do next is start the IrDA subsystem:

    # /etc/rc.d/irda start

General networking tips

Related software:

-   ifplugd
-   netcfg

I use a handy little utility called ifplugd to manage the network
interfaces. In short, ifplugd monitors the network interfaces for
connect/disconnect events and runs predefined actions (usually a DHCP
client). You can edit /etc/ifplugd/ifplugd.conf:

    NET_IFS="eth0 wlan0"
    ARGS="-fwI -u0 -d8"

Apart from that, I also use netcfg to manage the different wireless
networks and support WPA/WPA2/IEEE 802.1x etc. See Network Profiles.

> Sound support

The on-board Intel High-Definition Audio chipset (Realtek ALC269) is
supported by the snd_hda_intel kernel module. The first time I tried
using the card the sound output was really horrible because the mixer
did not function properly. And then I found my headphone play together
with the speakers. Luckily both symptoms are fixed by adding the
following lines to /etc/modprobe.d/modprobe.conf or
/etc/modprobe.d/sound.conf:

    alias snd-card-0 snd-hda-intel
    alias sound-slot-0 snd-hda-intel
    options snd-card-0 index=0 position_fix=1
    options snd-hda-intel index=0 position_fix=1

> Modem

Prerequisites:

-   slmodem-utils

The modem is supported by the sound card module. The only thing needed
to make it work is slmodemd, a daemon designed for use with SmartLink
modems. This daemon, when compiled accordingly, supports the ALSA modem
drivers. If your slmodemd is ALSA-capable, then you only need to run:

    slmodemd --alsa modem:0

and then point your favourite dialer program (e.g. ppp, wvdial) to
/dev/ttySL0. You can also create a symlink from /dev/ttySL0 to
/dev/modem, something which most dialers use out-of-the-box.

Then edit /etc/conf.d/slmodem-alsa:

    # Parameters to be passed to slmodemd
    #
    SLMODEM_ARGS="--country=GR --alsa modem:0"

> FireWire

Just need the ohci1394 kernel module.

> AuthenTec AES2501 fingerprint reader

As duly pointed out on the forums, fingerprint readers are more a threat
to your privacy than a safeguard. Your fingerprints (unless you are
paranoid and type with gloves on) are likely to be all over your
keyboard, rendering the 'security' purpose of this device useless. Keep
this in mind if you intend to use the reader as a replacement for your
password; fingerprints can be duplicated easily with basic stuff
(graphite ea.).

There is a utility called fprint available, together with a libfprint
library it depends on. Both are packaged for Arch Linux.

     # pacman -S fprint

The fprint program is still called fprint_demo for the moment, but it
works :-).

Integration with the login manager seems possible - for that you will
need, among others, the pam_fprint module.

After installing the package, run

    pam_fprint_enroll

and follow the instructions to scan the finger you want to use for
authentication. The next step is to configure PAM. First, edit
/etc/pam.d/login, and make the first lines look like this:

    #% PAM-1.0
    auth            required        pam_securetty.so
    auth            requisite       pam_nologin.so
    auth            sufficient      pam_fprint.so
    auth            required        pam_unix.so nullok
    auth            required        pam_tally.so onerr=succeed file=/var/log/faillog

This will make PAM accept a successful fingerprint scan as a valid login
token, if the scan fails, it will fall back to a password. From this
moment on, you'll be able to log on with a scan on a tty - enter your
username, press Enter, and scan the finger you told pam_fprint_enroll to
use as default. Voilà :-).

On the forum you can also find a topic that covers setting up your
fingerprint reader with PAM and SLiM, but this is with the aes2501
kernel-space driver.

> ACPI

> Tactile strip

Suspension and hibernation

Nowadays, all you should need is the following:

    sudo pacman -S pm-utils

That will install the pm-utils package which contains the programs
pm-suspend, pm-hibernate, etc. To suspend to RAM, just do the following:

    sudo pm-suspend

...and to hibernate...

    sudo pm-hibernate

Pretty straight-forward! There is also a "hybrid", called
pm-suspend-hybrid. What this does is that it does everything it needs to
hibernate and then suspends the computer instead of shutting it down, as
it normally would when hibernating! So if you do not run out of power
during this suspended state, you can start the computer up again as if
it was a normal supension — if you do run out of power, it would just
act like a normal hibernation.

Device information
------------------

> lspci output

    00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
    00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
    00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
    00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
    00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
    00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
    00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 3 (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
    00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller (rev 03)
    00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
    08:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8055 PCI-E Gigabit Ethernet Controller (rev 14)
    18:00.0 Network controller: Intel Corporation PRO/Wireless 5300 AGN [Shiloh] Network Connection
    38:03.0 CardBus bridge: O2 Micro, Inc. OZ711SP1 Memory CardBus Controller (rev 01)
    38:03.2 SD Host controller: O2 Micro, Inc. Integrated MMC/SD Controller (rev 02)
    38:03.3 Mass storage controller: O2 Micro, Inc. Integrated MS/xD Controller (rev 01)
    38:03.4 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02)

> lsusb output

    Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 003 Device 002: ID 046d:c052 Logitech, Inc. 
    Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 006 Device 003: ID 0c24:0021 Taiyo Yuden 
    Bus 006 Device 002: ID 08ff:2580 AuthenTec, Inc. AES2501 Fingerprint Sensor
    Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 002 Device 004: ID 046d:09b2 Logitech, Inc. Fujitsu Webcam
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

See also
--------

-   Lifebook S7020

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fujitsu_Lifebook_S6520&oldid=299016"

Category:

-   Fujitsu

-   This page was last modified on 20 February 2014, at 00:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
