Acer Aspire R3610
=================

  
 This page contains information on the Acer Aspire Revo R3610 nettop.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Device information                                                 |
|     -   1.1 lspci                                                        |
|     -   1.2 aplay -l                                                     |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 ALSA                                                         |
|         -   2.1.1 Analogue 2channel audio ouput                          |
|         -   2.1.2 S/PDIF audio output                                    |
|         -   2.1.3 HDMI audio output                                      |
|                                                                          |
|     -   2.2 Graphics                                                     |
|         -   2.2.1 Proprietary driver                                     |
|         -   2.2.2 Nouveau open source driver                             |
+--------------------------------------------------------------------------+

Device information
==================

lspci
-----

Here is the output from running the lscpi command.

    00:00.0 Host bridge: nVidia Corporation MCP79 Host Bridge (rev b1)
    00:00.1 RAM memory: nVidia Corporation MCP79 Memory Controller (rev b1)
    00:03.0 ISA bridge: nVidia Corporation MCP79 LPC Bridge (rev b3)
    00:03.1 RAM memory: nVidia Corporation MCP79 Memory Controller (rev b1)
    00:03.2 SMBus: nVidia Corporation MCP79 SMBus (rev b1)
    00:03.3 RAM memory: nVidia Corporation MCP79 Memory Controller (rev b1)
    00:03.5 Co-processor: nVidia Corporation MCP79 Co-processor (rev b1)
    00:04.0 USB Controller: nVidia Corporation MCP79 OHCI USB 1.1 Controller (rev b1)
    00:04.1 USB Controller: nVidia Corporation MCP79 EHCI USB 2.0 Controller (rev b1)
    00:08.0 Audio device: nVidia Corporation MCP79 High Definition Audio (rev b1)
    00:09.0 PCI bridge: nVidia Corporation MCP79 PCI Bridge (rev b1)
    00:0a.0 Ethernet controller: nVidia Corporation MCP79 Ethernet (rev b1)
    00:0b.0 SATA controller: nVidia Corporation MCP79 AHCI Controller (rev b1)
    00:0c.0 PCI bridge: nVidia Corporation MCP79 PCI Express Bridge (rev b1)
    00:10.0 PCI bridge: nVidia Corporation MCP79 PCI Express Bridge (rev b1)
    00:15.0 PCI bridge: nVidia Corporation MCP79 PCI Express Bridge (rev b1)
    00:16.0 PCI bridge: nVidia Corporation MCP79 PCI Express Bridge (rev b1)
    00:17.0 PCI bridge: nVidia Corporation MCP79 PCI Express Bridge (rev b1)
    00:18.0 PCI bridge: nVidia Corporation MCP79 PCI Express Bridge (rev b1)
    03:00.0 VGA compatible controller: nVidia Corporation ION VGA (rev b1)
    05:00.0 Network controller: RaLink RT3090 Wireless 802.11n 1T/1R PCIe

  

aplay -l
--------

Output of aplay -l

    card 0: NVidia [HDA NVidia], device 0: ALC662 rev1 Analog [ALC662 rev1 Analog]
      Subdevices: 0/1
      Subdevice #0: subdevice #0
    card 0: NVidia [HDA NVidia], device 1: ALC662 rev1 Digital [ALC662 rev1 Digital]
      Subdevices: 1/1
      Subdevice #0: subdevice #0
    card 0: NVidia [HDA NVidia], device 3: NVIDIA HDMI [NVIDIA HDMI]
      Subdevices: 0/1
      Subdevice #0: subdevice #0

Configuration
=============

ALSA
----

The nVidia Corporation MCP79 High Definition Audio (uses codec Realtek
ALC662 rev1) uses the snd_hda_intel kernel module which seems to work
correctly with a 2 channel setup. If you have problems with
multi-channel setup you can.

-   create /etc/modprobe.d/alsa.conf
-   In the file add the line

    options snd-hda-intel model=3stack-6ch-dig 

Check
/usr/src/linux-2.6.35-ARCH/Documentation/sound/alsa/HD-Audio-Models.txt
for other models.

> Analogue 2channel audio ouput

This is the setup that alsa will use by default which appears to work
correctly.

> S/PDIF audio output

To set this up do the following.

-   Make sure the output "S/PDIF" is unmuted in the alsamixer program
    (hint use arrow keys to select channel and press m and then ESC to
    exit)
-   Create a .asoundrc file in your home directory with following
    content.

    pcm.!default {
      type plug
      slave.pcm "dmix:0,1"
    }

Note this has NOT been tested!

> HDMI audio output

To set this up do the following.

-   Use a video driver that supports HDMI output. At the time of writing
    only the proprietary NVidia driver supports this.
-   Make sure the output "S/PDIF 1" is unmuted in the alsamixer program
    (hint use arrow keys to select channel and press m and then ESC to
    exit)
-   Create a .asoundrc file in your home directory with following
    content.

    pcm.!default {
      type plug
      slave.pcm "dmix:0,3"
    }

This has been tested and audio between applications can be multiplexed
fine but you may get popping sounds when audio starts and stops. This
happens even if the module parameter power saving is disabled, which is
the default anyway.

Graphics
--------

> Proprietary driver

The nVidia Corporation ION VGA is part of the NV50 family. See NVIDIA
for details.

> Nouveau open source driver

At the time of writing the open source nouveau driver is supported but
HDMI audio output has not been implemented. See
http://nouveau.freedesktop.org/wiki/FeatureMatrix for the current
progress on the driver.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_R3610&oldid=230970"

Category:

-   Acer
