Acer Aspire 1652 ZWLMi
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

Article based on Acer Aspire 1691 WLMi, but added/changed many things.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
|     -   1.1 Wireless NIC                                                 |
|                                                                          |
| -   2 Installing Arch Linux                                              |
| -   3 Kernel                                                             |
| -   4 Power Management                                                   |
|     -   4.1 ACPI                                                         |
|     -   4.2 Dynamic CPU frequency scaling                                |
|     -   4.3 Suspend to disk                                              |
|                                                                          |
| -   5 Xorg                                                               |
|     -   5.1 Synaptics touchpad                                           |
|                                                                          |
| -   6 Extra resources                                                    |
+--------------------------------------------------------------------------+

Hardware
--------

-   Audio: HDA Intel Realtek ALC833 - snd_hda_intel - compiled
    alsa-driver (1.0.12) with patch!
-   Video: ATI Mobility Radeon X1300 - fglrx (extra/ati-fglrx-beyond)
-   Modem:
-   Wired NIC: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+
    (rev 10) - rtl8139too
-   Wireless NIC: Intel Corporation PRO/Wireless 2200BG (rev 05) -
    ipw2200 (extra/ipw2200-fw)

> Wireless NIC

Install driver:

    pacman -S extra/ipw2200-fw 

Get WiFi LED signalization working:

    echo "options ipw2200 led=1" > /etc/modprobe.d/modprobe.conf

Installing Arch Linux
---------------------

I used Arch Linux 0.7.2 FTP Install and I haven't had to do any
specialities. I just connected thru ethernet card (rtl8139too module was
autoloaded) and it worked fine.

Kernel
------

To get all the things working, use Beyond kernel (extra/kernel26beyond).

Power Management
----------------

> ACPI

Install ACPI daemon.

    pacman -S current/acpid

Add this daemon to rc.conf:

    acpid

> Dynamic CPU frequency scaling

Install some packages:

    pacman -S extra/cpufreqd extra/cpufrequtils extra/powernowd

Add these modules to rc.conf:

    speedstep_centrino cpufreq_userspace

Add this daemon to rc.conf:

    powernowd

> Suspend to disk

I followed Suspend_to_Disk HOWTO and it works fine.

Xorg
----

> Synaptics touchpad

Install synaptics driver for notebook touchpads and X.org evdev input
driver.

    pacman -S extra/synaptics current/xf86-input-evdev

    Section "InputDevice"
     	Identifier    "Mouse1"
           Driver        "synaptics"
     	Option        "Device"          "/dev/psaux"
     	Option        "Protocol"        "auto-dev"
     	Option        "LeftEdge"        "1700"
     	Option        "RightEdge"       "5300"
     	Option        "TopEdge"         "1700"
     	Option        "BottomEdge"      "4200"
     	Option        "FingerLow"       "25"
     	Option        "FingerHigh"      "30"
     	Option        "MaxTapTime"      "180"
     	Option        "MaxTapMove"      "220"
     	Option        "VertScrollDelta" "100"
     	Option        "MinSpeed"        "0.06"
     	Option        "MaxSpeed"        "0.12"
     	Option        "AccelFactor"     "0.0010"
     	Option        "SHMConfig"       "true"
    EndSection

To use this you'll need to change your InputDevice line in your
"ServerLayout" section to use the synaptics mouse.

Extra resources
---------------

-   Acer Hotkey driver for Linux - maybe this could be useful too.
-   I written this article in few minutes. I hope that there are some
    valuable informations, but many things I forget, I know. If you have
    some problems with this notebook in Arch Linux, send me an email to
    beretux at gmail.com.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_1652_ZWLMi&oldid=196462"

Category:

-   Acer
