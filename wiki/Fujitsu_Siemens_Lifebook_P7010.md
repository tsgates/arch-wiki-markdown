Fujitsu Siemens Lifebook P7010
==============================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The Fujitsu-Siemens P7010(D) is a neat little laptop with a 10"
widescreen. It weighs little more than a kilo, has a relatively long
battery life and sports many things that low-weight laptops normally
lack.

Contents
--------

-   1 Overview
    -   1.1 System Specifications
    -   1.2 What works/What does not
-   2 Video
-   3 Audio
-   4 Wireless Network
-   5 Card Readers
    -   5.1 PCMCIA
    -   5.2 Compact Flash
    -   5.3 Secure Digital
-   6 Important Config files
    -   6.1 cpufreqd.conf
    -   6.2 rc.conf (modules array)
-   7 Other Tweaks
-   8 External Links

Overview
--------

> System Specifications

Fujitsu Siemens LifeBook P7010 - Pentium M 753 1.2 GHz - 10.6" TFT

-   26.1 cm x 19.9 cm x 3.5 cm
-   1.3 kg
-   Pentium M 753 1.2 GHz ULV, 2MB L2-cache
-   512MB DDR SDRAM 333MHz PC2700 (maximum: 1024MB)
-   SD-card reader (ricoh)
-   CF reader
-   PCMCIA
-   80GB 5400 rpm Harddrive
-   10.6" TFT active matrix WXGA (1280 x 768)
-   Intel 855GME
-   Ethernet
-   Intel PRO/Wireless 2200BG
-   Modem
-   2 USB ports, 1 firewire
-   Battery time: 7.5 hours
-   Port for external screen
-   TV-out
-   1 modular bay (I have filled it out with a
    DVD-burner(MATSHITADVD-RAM UJ-822S)

Output of lshwd

    00:00.0 Host bridge: Intel Corp.: Unknown device 3580 (intel-agp)
    00:00.1 System peripheral: Intel Corp.: Unknown device 3584 (unknown)
    00:00.3 System peripheral: Intel Corp.: Unknown device 3585 (unknown)
    00:02.0 VGA compatible controller: Intel Corp.: Unknown device 3582 (vesa)
    00:02.1 Display controller: Intel Corp.: Unknown device 3582 (vesa)
    00:1d.0 USB Controller: Intel Corp. 82801DB USB (Hub #1) (uhci_hcd)
    00:1d.1 USB Controller: Intel Corp. 82801DB USB (Hub #2) (uhci_hcd)
    00:1d.7 USB Controller: Intel Corp. 82801DB USB EHCI Controller (ehci-hcd)
    00:1e.0 PCI bridge: Intel Corp. 82801BAM/CAM PCI Bridge (hw_random)
    00:1f.0 ISA bridge: Intel Corp.: Unknown device 24cc (unknown)
    00:1f.1 IDE interface: Intel Corp.: Unknown device 24ca (piix)
    00:1f.3 SMBus: Intel Corp. 82801DB SMBus (i2c-i801)
    00:1f.5 Multimedia audio controller: Intel Corp. 82801DB AC'97 Audio (snd-intel8x0)
    00:1f.6 Modem: Intel Corp. 82801DB AC'97 Modem (slamr)
    01:0a.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (yenta_socket)
    01:0a.1 CardBus bridge: Ricoh Co Ltd RL5c476 II (yenta_socket)
    01:0a.2 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (ohci1394)
    01:0a.3 System peripheral: Ricoh Co Ltd: Unknown device 0576 (unknown)
    01:0a.4 System peripheral: Ricoh Co Ltd: Unknown device 0592 (unknown)
    01:0c.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (8139too)
    01:0d.0 Network controller: Intel Corp.: Unknown device 4220 (ipw2200)
    003:003 USB Mass Storage: FireWire/USB2.0 Combo (usb-storage)
    003:001 USB Hub:  (hub)
    002:001 USB Hub:  (hub)
    001:002 USB Wireless: USAWireless Bluetooth Device (hci_usb)
    001:001 USB Hub:  (hub)
    ---:--- Mouse: Generic PS/2 Wheel Mouse [/dev/psaux] (msintellips/2)

> What works/What does not

Pretty much everything works on this laptop except the TV-out and the
SD-card reader. The screen needs a little tweaking to get working. The
preferred resolution (1280x768) is not part of the VBIOS, and
consequently the VBIOS needs to be patched with Alain Poirier's software
855resolution (to be found in the AUR).

Video
-----

Note:relevant modules:

-   intel-agp
-   i915

In order to get the video working fine at 1280x768 you need to patch the
VBIOS with Alain Poirier's 855resolution for which there is a PKGBUILD
in the AUR. This application allows you to replace any of the modes in
the VBIOS with something else. After you have compiled the package and
installed it, run the following command.

    855resolution 5c 1280 768

This will replace mode 5c with 1280 768. You can list the modes with

    855resolution -l

which should return something like this:

    855resolution version 0.4, by Alain Poirier

    Chipset: 855GM (id=0x35808086)
    VBIOS type: 2
    VBIOS Version: 3181 

    Mode 30 : 640x480, 8 bits/pixel
    Mode 32 : 800x600, 8 bits/pixel
    Mode 34 : 1024x768, 8 bits/pixel
    Mode 38 : 1280x1024, 8 bits/pixel
    Mode 3a : 1600x1200, 8 bits/pixel
    Mode 3c : 1280x768, 8 bits/pixel
    Mode 41 : 640x480, 16 bits/pixel
    Mode 43 : 800x600, 16 bits/pixel
    Mode 45 : 1024x768, 16 bits/pixel
    Mode 49 : 1280x1024, 16 bits/pixel
    Mode 4b : 1600x1200, 16 bits/pixel
    Mode 4d : 1280x768, 16 bits/pixel
    Mode 50 : 640x480, 32 bits/pixel
    Mode 52 : 800x600, 32 bits/pixel
    Mode 54 : 1024x768, 32 bits/pixel
    Mode 58 : 1280x1024, 32 bits/pixel
    Mode 5a : 1600x1200, 32 bits/pixel
    Mode 5c : 1280x768, 32 bits/pixel

Before everything is set, you will also need to add the proper modelines
in xorg.conf. This is done in the monitor section

    Section "Monitor"
            Identifier      "InternalMonitor"
            Option  "DPMS"
            HorizSync    28.0 - 96.0
            VertRefresh  50.0 - 75.0
            Modeline "1280x768" 80.14 1280 1344 1480 1680 768 769 772 795
            Modeline "1024x768" 65.00 1024 1047 1183 1343 768 770 776 805
    EndSection

Audio
-----

Note:relevant modules:

-   snd-intel8x0

The audio is really not a big deal, at least not if you use ALSA (which
is the only sound system I have ever used under Linux). The only
weirdness is that the Master channel has no effect on the sound, you
have to play around with the Headphone and PCM channels in order to set
the sound.

Wireless Network
----------------

Note:relevant modules:

-   ipw2200

Wireless network is an Intel Pro Wireless 2200BG and has very good Linux
drivers nowadays. If you are using the stock arch kernel, all you need
to do is

    pacman -S ipw2200

and add the proper modules to your rc.conf (see the rc.conf section of
this page) if you are not using hotplug or hwd.

Card Readers
------------

> PCMCIA

Note:relevant modules:

-   yenta_socket

As far as I have understood from other reports, the pcmcia card works as
expected. I do not have one at this time, so I cannot confirm it.

> Compact Flash

The same goes for the Compact Flash. It is supposed to work as it uses
the same interfaces as the PCMCIA does, but I cannot confirm anything
since I do not have a CF-card.

> Secure Digital

There is now a driver in alpha test stage on Sourceforge
http://sourceforge.net/projects/sdricohcs/ it supports only the SD Card
driver so far and must be compiled from source. Arch packages found here
https://aur.archlinux.org/packages.php?do_Details=1&ID=9884.

Important Config files
----------------------

> cpufreqd.conf

I have had quite a hard time deciding what the best cpufreqd setup would
be for me. Right now I am using this:

    # this is a comment
    #
    # you need: 1 [General] section, 
    #           1 or more [Profile] sections
    #	          1 or more [Rule] sections
    #
    # a section ends at the first blank line
    #
    # [Rule] sample:
    #           [Rule]
    #           name=sample_rule
    #           ac=on                    # (on/off)
    #           battery_interval=0-10
    #           cpu_interval=30-60
    #           programs=xine,mplayer
    #           profile=sample_profile
    #
    # [Profile] sample:
    #           [Profile]
    #           name=sample_profile
    #           minfreq=10%
    #           maxfreq=100%
    #           policy=performance
    #
    # see CPUFREQD.CONF(5) manpage for a complete reference

    [General]
    pidfile=/var/run/cpufreqd.pid
    poll_interval=2
    pm_type=acpi #(acpi, apm or pmu)
    # Uncomment the following line to enable ACPI workaround (see cpufreqd.conf(5))
    # acpi_workaround=1
    verbosity=5 #(if you want a minimal logging set to 5)

    [Profile]
    name=hi_boost
    minfreq=1000000
    maxfreq=1200000
    policy=performance

    [Profile]
    name=medium_boost
    minfreq=800000
    maxfreq=1000000
    policy=conservative

    [Profile]
    name=lo_boost
    minfreq=600000
    maxfreq=800000
    policy=performance

    [Profile]
    name=lo_power
    minfreq=0
    maxfreq=600000
    policy=powersave

    # conservative mode when not AC
    [Rule]
    name=low_bat_conservative
    ac=off
    battery_interval=0-100
    cpu_interval=0-35
    profile=lo_power

    #[Rule]
    name=conservative
    ac=off                   # (on/off)
    battery_interval=0-100   
    cpu_interval=35-60
    profile=lo_boost

    # need some power

    [Rule]
    name=lo_cpu_boost
    ac=off                   # (on/off)
    battery_interval=0-100
    cpu_interval=60-80
    profile=medium_boost

    # need big power (not if battery very low)
    [Rule]
    name=hi_cpu_boost
    ac=off                   # (on/off)
    battery_interval=50-100
    cpu_interval=80-100
    profile=hi_boost

    full power when AC
    [Rule]
    name=AC_on
    ac=on                   # (on/off)
    profile=hi_boost

> rc.conf (modules array)

This is just a starting point, you might want to load other modules or
you might have some of these compiled into the kernel.

    MODULES=(evdev \
            snd-intel8x0 snd-pcm-oss snd-mixer-oss snd-seq-oss \
            uhci-hcd ehci-hcd ohci1394 \
            ieee80211_crypt ieee80211 ipw2200 \
            i2c-i801 agp-intel i915)

Other Tweaks
------------

I have a repository with some tweaked packages. Most noticably, there is
an archck8-kernel, compiled for the lifebook p7010, as well as other
packages compiled for the pentium-m processor (which could be used for
other laptops too), such as a few of the KDE 3.4.3 packages, e17, and a
few other things. Information on how to use my repository can be found
here

External Links
--------------

-   This report is listed at the TuxMobil: Linux Laptop and Notebook
    Installation Guides Survey: Fujitsu-Siemens - FSC.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fujitsu_Siemens_Lifebook_P7010&oldid=273948"

Category:

-   Fujitsu

-   This page was last modified on 1 September 2013, at 16:56.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
