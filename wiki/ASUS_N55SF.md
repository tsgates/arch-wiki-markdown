ASUS N55SF
==========

  ------------------ -------------------- ----------------------
  Device             Status               Modules
  Intel graphics     Working              xf86-video-intel
  Nvidia graphics    Working, see below   nvidia, bumblebee
  Graphic outputs    Not working          nvidia, bumblebee
  Ethernet           Working              atl1c
  Wireless           Working              iwlan
  Audio              Working, see below   snd_hda_intel
  Touchpad           Working              xf86-input-synaptics
  Camera             Working              uvcvideo
  USB 3.0            Working              xhci_hcd
  Card Reader        Working              
  Special Keys       Untested             
  Power management   Working, see below   
  ------------------ -------------------- ----------------------

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
|         -   2.2.3 Outputs                                                |
|                                                                          |
|     -   2.3 Audio                                                        |
|     -   2.4 Touchpad                                                     |
|     -   2.5 Webcam                                                       |
|     -   2.6 Power management                                             |
+--------------------------------------------------------------------------+

Hardware
--------

CPU: Intel Core i7-2630QM @ 2.00GHz

Mainboard: Intel HM65 Express

RAM: 6/8GB DDR3

Display: 15,6" HD LED (1920x1080)

Graphics adapter: Intel Core Processor Integrated Graphics Controller,
NVIDIA GeForce GT 555M

Soundcard: Integrated Intel HDA, Bang & Olufsen speakers with external
subwoofer

Network: Atheros Gigabit Ethernet Controller, Intel Centrino Wireless-N
1030

Hard disk: Seagate Momentus 750GB 5400rpm SATA

Webcam: IMC Networks

Touchpad: Synaptics

Configuration
-------------

There is a BIOS update (v207) on Asus support website (go to the english
one if you don't find) that fix the numpad bug.

> CPU

Works out of the box.

Follow the CPU Frequency Scaling guide to enable speed-stepping.
Processor has Intel Turbo Boost which works out of the box, but you
can't see the frequencies above 2.4GHz in /proc/cpuinfo. To see the
actual frequency install i7z.

> Video

Intel

Follow these guides: Xorg and Intel. You will need to blacklist the
nouveau driver (the kernel detects the nvidia card and loads it).
Bumblebee will load it as needed, see next section.

    /etc/modprobe.d/blacklist-nouveau.conf

    blacklist nouveau

Nvidia

The official proprietary nvidia drivers for linux do not support Nvidia
Optimus yet, but there is a workaround in the form of bumblebee. It
enables the use of Nvidia graphic card via virtualgl. Just follow the
instructions for setting up bumblebee in our wiki.

Outputs

VGA working.

HDMI not working, but still testing. I'm not sure if it can work on this
laptop. See [Bumblebee FAQ]

> Audio

Follow the official documentation: ALSA and/or Pulseaudio

To make the external subwoofer work edit/create
/etc/modprobe.d/alsa-base.conf and add these options:

    /etc/modprobe.d/alsa-base.conf

    options snd-hda-intel model=asus-mode4

As explained in this bug report, by default, the subwoofer plays the
right channel. To correct this, add the following:

    /usr/share/pulseaudio/alsa-mixer/profile-sets/extra-hdmi.conf

    [Mapping analog-surround-21]
    device-strings = surround40:%f
    channel-map = front-left,front-right,lfe,lfe
    paths-output = analog-output analog-output-speaker
    priority = 7
    direction = output

And enable this:

    /etc/pulse/daemon.conf

    enable-lfe-remixing = yes

> Touchpad

Follow the Synaptics guide.

> Webcam

Working.

> Power management

The USB unbind hook is no longer necessary as of Linux 3.5.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_N55SF&oldid=234406"

Category:

-   ASUS
