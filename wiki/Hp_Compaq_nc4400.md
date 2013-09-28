Hp Compaq nc4400
================

I wanted a small and fast laptop that's capable of running Linux. My
choice is a HP Compaq nc4400 since the Lenovo Thinkpad X-serie is too
expensive. This HP and the Lenovo Thinkpad have a lot in common, for
example they both sport a pointing stick and both lack an optical
(cd/dvd) drive. My goal was to leave the pre-installed WinXP on the
laptop and install Arch from an usb stick since I do not own an USB
cd/dvd drive.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 System Specifications                                              |
| -   2 What works/What doesn't                                            |
| -   3 Xorg configuration                                                 |
| -   4 Wifi                                                               |
| -   5 SD/MMC memory card reader                                          |
| -   6 HDD failing sensors                                                |
|     -   6.1 ToDo                                                         |
|                                                                          |
| -   7 External links                                                     |
+--------------------------------------------------------------------------+

> System Specifications

HP Compaq nc4400 - Centrino Duo

-   Intel Core 2 Duo T5600, 2x1.83GHz (Speedstep, 667MHz FSB, 2MB L3)
    (VT support can be enabled in the BIOS)
-   Mobile Intel 945GM Express Chipset (ICH7 Family)
-   2x512MB 667MHz DDR2 SDRAM
-   80GB 2.5" 5400rpm Fujitsu-Siemens SATA HDD
-   12" 1024x768 TFT
-   Intel Graphics Media Accelerator 945GM
-   Intel HDA audio
-   56K Fax/Modem
-   Broadcom NetXtreme Gigabit Ethernet (BCM5753M)
-   3xUSB2.0, one giving a full ampere of power
-   Intel 3945ABG
-   Bluetooth (Broadcom)
-   TI SD/MMC Memory Card reader
-   Fingerprint reader (AuthenTec)
-   Infineon TPM and Smartcard reader
-   IRdA
-   VGA and Svideo for an external monitor/television
-   52W - 4698mAh battery (4-5h)
-   Synaptics Touchpad and a pointing stick!
-   One cardbus slot
-   65W adapter
-   Ambient Light Sensor

lshwd output:

-   00:00.0 Class 0600: Intel Corp.|Mobile Memory Controller Hub
    (intel-agp)
-   00:02.0 Class 0300: Intel Corp.|Mobile Integrated Graphics
    Controller (i810)
-   00:02.1 Class 0380: Intel Corp.|Mobile Integrated Graphics
    Controller (vesa)
-   00:1b.0 Class 0403: Intel Corp.|I/O Controller Hub High Definition
    Audio (snd-hda-intel)
-   00:1c.0 Class 0604: Intel Corp.|I/O Controller Hub PCI Express Port
    1 (unknown)
-   00:1c.1 Class 0604: Intel Corp.|I/O Controller Hub PCI Express Port
    2 (unknown)
-   00:1d.0 Class 0c03: Intel Corp.|I/O Controller Hub UHCI USB #1
    (unknown)
-   00:1d.1 Class 0c03: Intel Corp.|I/O Controller Hub UHCI USB #2
    (unknown)
-   00:1d.2 Class 0c03: Intel Corp.|I/O Controller Hub UHCI USB #3
    (unknown)
-   00:1d.3 Class 0c03: Intel Corp.|I/O Controller Hub UHCI USB #4
    (unknown)
-   00:1d.7 Class 0c03: Intel Corp.|I/O Controller Hub EHCI USB
    (unknown)
-   00:1e.0 Class 0604: Intel Corp.|82801 Hub Interface to PCI Bridge
    (hw_random)
-   00:1f.0 Class 0601: Intel Corp.|Mobile I/O Controller Hub LPC
    (i8xx_tco)
-   00:1f.1 Class 0101: Intel Corp.|I/O Controller Hub PATA (piix)
-   00:1f.2 Class 0106: Intel Corp.|Mobile I/O Controller Hub SATA
    cc=AHCI (ahci)
-   02:06.0 Class 0607: Texas Instruments|PCIxx12 CardBus Controller
    (yenta_socket)
-   02:06.2 Class 0180: Texas Instruments|5-in-1 Multimedia Card Reader
    (SD/MMC/MS/MS PRO/xD) (unknown)
-   02:06.3 Class 0805: Texas Instruments|5-in-1 Multimedia Card Reader
    (SD/MMC/MS/MS PRO/xD) (unknown)
-   02:06.4 Class 0780: Texas Instruments|5-in-1 Multimedia Card Reader
    (SD/MMC/MS/MS PRO/xD) (unknown)
-   08:00.0 Class 0200: Broadcom Corp.|NetXtreme BCM5753M Gigabit
    Ethernet PCI Express (tg3)
-   10:00.0 Class 0280: Intel Corporation|PRO/Wireless 3945ABG (ipw3945)
-   ---:--- Mouse: Generic PS/2 Wheel Mouse [/dev/psaux] (msintellips/2)

> What works/What doesn't

Pretty much everything needed works when you tweak. This wiki is an
excellent source of infomation. :) On windows the network controller
(nextreme) can be "safely removed" to save power. I think you can do the
same in linux with "rmmod tg3".

For the right console display size I set vga=792 (1024x768x16M@60Hz) as
a kernel boot parameter.

There's hardware mute and volume up/down buttons. They work but odly
every time I reboot it's always back to mute. More like a feature than a
bug.

The fn+brighter/dimmer display buttons and the Ambient Light Sensor work
software independent.

In my understanding, the TPM doesn't show anywhere even tho there's a
kernel module for the infineon TPM. I haven't tried to make it work and
probably won't even try. I believe the Irda and modem work as expected,
haven't tested.

I haven't tried to use an external monitor/TV, I expect making those
work is just matter of confing.

The ICH7 family sports a hpet multimedia timer that saves power. Kernel
boot parameter hpet=force just in case.

Bluetooth works (kdebluetooth, but probably also gnome-bluetooth).

Cpu frequency scaling works. (cpufrequtils with the p4_clockmod module).

Xorg configuration
------------------

The i810 driver works for graphics (and the intel driver, but I
(Tkjacobsen) find it buggy with composite (not anymore))

    pacman -S xf86-video-intel

Use Touchpad_Synaptics to tune the touthpad.

Wifi
----

The iwlwifi drivers works (also with (k)networkmanager).

    pacman -S iwlwifi-3945-ucode
    modprobe iwl3945

And put iwl3945 in your MODULES array.

SD/MMC memory card reader
-------------------------

This works with the tifm driver.

    modprobe tifm_core
    modprobe tifm_7xx1
    modprobe tifm_sd

Or you can put them in the MODULES array in /etc/rc.conf

HDD failing sensors
-------------------

See the S.M.A.R.T. howto. This line in /etc/smartd.conf does the job for
me (Tkjacobsen):

    /dev/sda -a -d sat -m root@localhost

> ToDo

-   The fingerprint reader is via USB, haven't looked into that yet
    either.

External links
==============

Gentoo Wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hp_Compaq_nc4400&oldid=196621"

Category:

-   HP
