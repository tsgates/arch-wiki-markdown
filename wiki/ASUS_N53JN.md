ASUS N53JN
==========

  --------------- ---------------------- ------------------
  Device          Status                 Modules
  Intel           Working                xf86-video-intel
  Nvidia          Partially Working      bumblebee
  Ethernet        Working                atl1c
  Wireless        Working                ath9k
  Audio           Working                snd_hda_intel
  Touchpad        Working                
  Camera          Working                uvcvideo
  USB 3.0         Working                xhci_hcd
  eSATA           Working                
  Card Reader     Working                
  Function Keys   Working                
  Suspend         Working, look bellow   
  --------------- ---------------------- ------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 Configuration                                                      |
|     -   2.1 CPU                                                          |
|     -   2.2 Video                                                        |
|         -   2.2.1 Intel                                                  |
|         -   2.2.2 Nvidia                                                 |
|             -   2.2.2.1 Switching graphic cards                          |
|                                                                          |
|     -   2.3 Audio                                                        |
|     -   2.4 Touchpad                                                     |
|     -   2.5 Webcam                                                       |
|     -   2.6 Suspend                                                      |
+--------------------------------------------------------------------------+

Hardware
--------

CPU: Intel Core i5 450M, 2.4GHz

Mainboard: Intel HM55

RAM: 4096 MB, 2x 2048 MByte DDR3

Display: 15,6" HD LED (1366x768)

Graphics adapter: NVIDIA GeForce GT 335M - 1024 MB and Intel Core
Processor Integrated Graphics Controller

Soundcard: integrated Intel HDA

Network: Atheros Gigabit Ethernet Controller, Atheros AR9285 Wireless
Network

Hard disk: Seagate Momentus 500GB 5400rpm SATA

Webcam: IMC Networks

Touchpad: Elantech

Configuration
-------------

> CPU

Works out of the box.

Follow the CPU Frequency Scaling guide to enable speed-stepping.
Processor has Intel Turbo Boost which works out of the box, but you
can't see the frequncies above 2.4GHz in /proc/cpuinfo. To see the
actual frequency use i7z.

> Video

Intel

Follow these guides: Xorg and Intel

No problems detected. VGA out and HDMI working.

Nvidia

The official proprietary nvidia drivers for linux do not support Nvidia
Optimus yet, but there is a workaround in the form of bumblebee. It
enables the use of Nvidia graphic card via virtualgl. Just follow the
instructions for setting up bumblebee in our wiki. Please note that this
laptop has software switch that turns Nvidia graphics card off. You can
turn it on using acpi_call.

Switching graphic cards

Look at Asus_N82JV page.

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

Working, but the picture is refreshing slowly.

> Suspend

The USB unbind hook is no longer necessary as of Linux 3.5.

The laptop still hangs if you disable nVidia GPU and try to suspend!
However, a workaround that works with Asus N82JV consists in
blacklisting nouveau. That still allows the user to power the card off
in that laptop.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_N53JN&oldid=233235"

Category:

-   ASUS
