Dell Inspiron N5010
===================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Intro                                                              |
|     -   1.1 Summary                                                      |
|     -   1.2 To do                                                        |
|                                                                          |
| -   2 Hardware                                                           |
|     -   2.1 Working                                                      |
|         -   2.1.1 Ethernet                                               |
|         -   2.1.2 DVDRW                                                  |
|         -   2.1.3 Touchpad                                               |
|         -   2.1.4 Wireless                                               |
|         -   2.1.5 Bluetooth                                              |
|         -   2.1.6 VGA                                                    |
|         -   2.1.7 Graphic adapter                                        |
|         -   2.1.8 Audio                                                  |
|         -   2.1.9 Display                                                |
|         -   2.1.10 Suspending to disk (Hibernation)                      |
|         -   2.1.11 Suspending to ram (Sleep)                             |
|         -   2.1.12 Sensors                                               |
|                                                                          |
|     -   2.2 Partially Working                                            |
|     -   2.3 Not Working                                                  |
|         -   2.3.1 Processor frequency control                            |
|                                                                          |
|     -   2.4 Unknown / Untested                                           |
|         -   2.4.1 HDMI Video                                             |
|         -   2.4.2 Redwood HDMI Audio 5600                                |
|         -   2.4.3 eSata port                                             |
|                                                                          |
| -   3 Installation                                                       |
|     -   3.1 Kernel                                                       |
|     -   3.2 ATI Mobility Raedon 5600                                     |
|     -   3.3 Troubleshoot                                                 |
|                                                                          |
| -   4 Links                                                              |
|     -   4.1 General                                                      |
+--------------------------------------------------------------------------+

Intro
-----

> Summary

> To do

-   eSata test
-   HDMI test

Hardware
--------

> Working

Ethernet

Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast
Ethernet controller (rev 02) Works out of the box.

DVDRW

ATAPI: TSSTcorp DVD+/-RW TS-L633J, D200, max UDMA/100

CD-ROM TSSTcorp DVD+-RW TS-L633J D200 PQ: 0 ANSI: 5

Using driver: scsi3-mmc

Supported extensions:

24x/24x writer dvd-ram cd/rw xa/form2 cdda tray

Successfully burns both cd mediums and dvd mediums, tested using K3B
2.0.2-1.

Touchpad

It is using the synaptic driver.

Works ok after installing the package xf86-input-synaptics.

Todo: Needs tweaking, cause it is too anoying.

Use this script to disable the touch pad when you do not like it:

    #!/bin/bash

    if [ $(synclient -l | grep TouchpadOff | gawk -F '= ' '{ print $2 }') -eq 0 ]; then
        synclient TouchpadOff=1
    else
        synclient TouchpadOff=0
    fi

Wireless

Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller (rev
01) In kernel 2.6 it works out of the box, but in kernel 3.0 there is no
wlan0, we have to blacklist some modules.

So open "/etc/modprobe.d/modprobe.conf" and append the following line:

blacklist bcma

now, reboot or restart the kernel.

When we issue iwconfig, it should now list wlan0:

    lo        no wireless extensions.

    eth0      no wireless extensions.

    wlan0     IEEE 802.11bgn  ESSID:"*******"  
              Mode:Managed  Frequency:2.427 GHz  Access Point: XX:XX:XX:XX:XX:XX   
              Bit Rate=72.2 Mb/s   Tx-Power=19 dBm   
              Retry  long limit:7   RTS thr:off   Fragment thr:off
              Power Management:off
              Link Quality=70/70  Signal level=-32 dBm  
              Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
              Tx excessive retries:0  Invalid misc:968   Missed beacon:0

Bluetooth

Both pairing, sending files and receiving files works out of the box,
tested with blueman.

VGA

Tested on an external CRT monitor, works out of the box on KDE 4.7.

Graphic adapter

ATI Mobility Radeon HD 5600 working out of the box.

Audio

Intel Corporation 5 Series/3400 Series Chipset High Definition Audio

Display

Available sizes:

    1366x768       60.0*+
    1280x720       59.9  
    1152x768       59.8  
    1024x768       59.9  
    800x600        59.9  
    848x480        59.7  
    720x480        59.7  
    640x480        59.4

Brightness controls work out of the box.

Suspending to disk (Hibernation)

works out of the box - tested on KDE 4.7

Suspending to ram (Sleep)

works out of the box - tested on KDE 4.7

Sensors

We got 3 sensors:

-   radeon-pci-0100
-   acpitz-virtual-0
-   acpi termal zone 0 Temperature

They work out of the box.

> Partially Working

> Not Working

Processor frequency control

-   says unsupported I think:

    :: Setting cpufreq governing rules                                                                                     [BUSY]
    grep: /sys/devices/system/cpu/cpu* /cpufreq/scaling_available_governors: No such file or directory, cpu 0 wrong, unknown or unhandled CPU?
    Error setting new values. Common errors:
    - Do you have proper administration rights? (super-user?)
    - Is the governor you requested available and modprobed?
    - Trying to set an invalid policy?
    - Trying to set a specific frequency, but userspace governor is not available,
      for example because of hardware which cannot be set to a specific frequency
      or because the userspace governor is not loaded?
                                              1wrong, unknown or unhandled CPU?
    Error setting new values. Common errors:
    - Do you have proper administration rights? (super-user?)
    - Is the governor you requested available and modprobed?
    - Trying to set an invalid policy?
    - Trying to set a specific frequency, but userspace governor is not available,
       for example because of hardware which cannot be set to a specific frequency
       or because the userspace governor is not loaded?
                                                2wrong, unknown or unhandled CPU?
    Error setting new values. Common errors:
    - Do you have proper administration rights? (super-user?)
    - Is the governor you requested available and modprobed?
    - Trying to set an invalid policy?
    - Trying to set a specific frequency, but userspace governor is not available,
       for example because of hardware which cannot be set to a specific frequency
       or because the userspace governor is not loaded?
                                                  3wrong, unknown or unhandled CPU?
    Error setting new values. Common errors:
    - Do you have proper administration rights? (super-user?)
    - Is the governor you requested available and modprobed?
    - Trying to set an invalid policy?
    - Trying to set a specific frequency, but userspace governor is not available,
       for example because of hardware which cannot be set to a specific frequency
       or because the userspace governor is not loaded?
                                                                                                                          [DONE]

> Unknown / Untested

HDMI Video

Redwood HDMI Audio 5600

eSata port

Installation
------------

Normal installation with no issues to report.

> Kernel

> ATI Mobility Raedon 5600

To do: Synaptic guide

> Troubleshoot

-   On boot the following error is printed:

boot error message:

intel ips 0000:00:1f.6: failed to get i915 symbols, graphics turbo
disabled

Workaround:

Blacklist the intel_ips module, open configuration file
"/etc/modprobe.d/modprobe.conf" and add:

blacklist intel_ips

Links
-----

> General

-   Archlinux bug report
-   Ubuntu bug report

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Inspiron_N5010&oldid=221376"

Category:

-   Dell
