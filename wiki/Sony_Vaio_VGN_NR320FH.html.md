Sony Vaio VGN NR320FH
=====================

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Summary
-   2 lspci Output
-   3 Hardware Howto
-   4 Not tested

> Summary

This 15.4" laptop is really cool. It's affordable and comes with a
Pentium Dual Core ( 2370 @1.73 GHz), 1 GB DDR2 RAM and a 200GB Hard
Drive. The best of all is that it supports linux pretty well. I have
been able to setup a working arch system (practical software and most of
the hardware) in less than 3 hours. What was most annoying was getting
the correct framebuffer resolution (yes I like fancy boot splash
screens). But in the end it had a rather easy solution.It had 3D
acceleration working as soon as I installed the driver and configured
Xorg.conf properly. Right now I'm still trying to get the Brightness
working, and after that nothing more comes to mind. It's one of the
easiest-to-setup laptops I've had. I'd recommend it to anyone.

-   Video: Intel GMA965 (X3100)
-   Audio: Intel HDA (Realtek ALC262)
-   Wireless: Atheros AR5006EG (AR242X)
-   Dunno what else... just keep reading :D
-   SD Card Reader Works out of the box.

> lspci Output

    00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
    00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
    00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
    00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 03)
    00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 03)
    00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
    00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
    00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 03)
    00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 3 (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
    00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 03)
    00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03)
    00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
    02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8039 PCI-E Fast Ethernet Controller (rev 15)
    06:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
    08:03.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
    08:03.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant IEEE 1394 Host Controller
    08:03.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD)

> Hardware Howto

Works out of the box
    

-   Wireless (madwifi)
-   Brightness
-   Video (xf86-video-intel) <-- With 3D Acceleration
-   Audio (Alsa) -- Some minor headphones and speaker issue: see Note
-   Touchpad (Synaptics)

Note: When I plugged my headphones to the jack the speakers were still
turned on. This was due to some alsa options. Solution: Add the
following line to /etc/modprobe.d/modprobe.conf:

    options snd-hda-intel model=sony-assamd

Also here's my alsa-info.sh output: [link[1]]

  

Needs some work

-   FN Keys (Volume)
    -   Solution: Use xev to map the keyodes. Then load them:

My .Xdefaults:

    keycode 174 = XF86AudioLowerVolume
    keycode 176 = XF86AudioRaiseVolume
    keycode 160 = XF86AudioMute
    keycode 151 = XF86AudioPlay

-   A 1280x800 framebuffer (Needed for splashy, and I guess other boot
    splash managers)
    -   Solution: This guide: Uvesafb

-   S1 and AV Mode Buttons (to the left of the power button) work weird.
    S1 prints keycode 101 but when triggered (mapped or not) it also
    triggers Brightness down in Gnome. AV Mode does nothing, however it
    prints some output to xev:

    FocusOut event, serial 34, synthetic NO, window 0x3800001,
       mode NotifyGrab, detail NotifyAncestor

    FocusIn event, serial 34, synthetic NO, window 0x3800001,
       mode NotifyUngrab, detail NotifyAncestor

    KeymapNotify event, serial 34, synthetic NO, window 0x0,
       keys:  2   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   
              0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0

> Not tested

-   Card Reader (MemoryStick Pro). Don't have a MSPro card to test. BTW
    the lap has 2 separate slots: 1 for SD (wich works) 1 for MSPro (idk
    if it works, but I'm pretty sure it will work)
-   VGA Out
-   PCMCIA Slot (or whatever name that slot on the right has)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sony_Vaio_VGN_NR320FH&oldid=196726"

Category:

-   Sony

-   This page was last modified on 23 April 2012, at 13:11.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
