ASUS N82JV
==========

  

  ---------------- ------------------- ------------------
  Device           Status              Modules
  Intel            Working             xf86-video-intel
  Nvidia           Partially Working   nouveau
  Ethernet         Working             atl1c
  Wireless         Working             ath9k
  Audio            Working             snd_hda_intel
  Touchpad         Working             
  Camera           Working             uvcvideo
  USB 3.0          Working             xhci-hcd
  USB 2.0          Working             ehci-hcd
  eSATA            Untested            
  Card Reader      Working             
  Function Keys    Partially Working   
  Suspend to RAM   Working             
  ---------------- ------------------- ------------------

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
|             -   2.2.2.1 Switching / Using Nvidia card                    |
|             -   2.2.2.2 Disabling the Nvidia card                        |
|                 -   2.2.2.2.1 acpi_call (manual)                         |
|                     -   2.2.2.2.1.1 Run on Startup                       |
|                     -   2.2.2.2.1.2 Enable/Disable Scripts               |
|                                                                          |
|     -   2.3 Audio                                                        |
|         -   2.3.1 HDMI                                                   |
|                                                                          |
|     -   2.4 Touchpad                                                     |
|         -   2.4.1 Working 10-synaptics.conf                              |
|                                                                          |
|     -   2.5 Suspend to RAM                                               |
|                                                                          |
| -   3 Webcam                                                             |
| -   4 Function Keys                                                      |
+--------------------------------------------------------------------------+

Hardware
========

CPU Intel Core i5 430M

Mainboard | Intel HM55

RAM 4096 MB, 2x 2048 MByte DDR3-10700 (1066 MHz)

Display 14" HD LED (1366x768)

Graphics adapter NVIDIA GeForce GT 335M - 1024 MB, Core: 450 MHz,
Memory: 790 MHz, Shader rate: 1080 MHz

Soundcard Realtek ALC269 @ Intel Ibex Peak PCH

Network Atheros AR8131 PCI-E Gigabit Ethernet Controller (1000MBit),
Atheros AR9285 Wireless Network

Hard disk 320GB 5400rpm SATA

Webcam Chicony Electronics

Touchpad Elantech

Configuration
=============

My particular model is Asus N82JV-VX038V but the contents of the page
should remain valid for every N82JV[1] model.

CPU
---

Works out of the box.

Follow the SpeedStep guide to enable speed-stepping.

Video
-----

This laptop sports two gpus. The Intel GMA HD (Core ix integrated) and
the Nvidia Geforce GT 335M, with the ability to switch granted by Nvidia
Optimus technology.

> Intel

Follow these guides: Xorg and Intel

No problems detected. VGA out and HDMI working.

> Nvidia

The official proprietary Nvidia drivers for linux do not support Nvidia
Optimus yet.

Switching / Using Nvidia card

While it still isn't possible to switch in the manner that Optimus is
supposed to switch, in order to make use of the dedicated graphic card
you need to use Bumblebee. In short, it is possible to run a specific
program with Nvidia, while the rest of the system is relying on the
Intel card.

Note: Bumblebee's development is rapidly progressing, so be sure to
check it's website[2] regularly; it's also worth checking Linux Hybrid
Graphics blog[3] and the mailing list[4].

Disabling the Nvidia card

There's more than one method to do this. Namely with vgaswitcheroo (not
working reliably yet with these cards) and acpi_call (AUR[5]), which is
recommended.

Note:If you use the AUR version, the steps are different than the ones
below, but they are explained during/after install; the scripts can be
easily adapted to the new locations, if necessary

acpi_call (manual)

In order to switch following hack is available[6][7].

What it is: A kernel module that enables you to call parameterless ACPI
methods by writing the method name to /proc/acpi/call, e.g. to turn off
discrete graphics card in a dual graphics environment (like NVIDIA
Optimus).

Instalation:

    git clone http://github.com/mkottman/acpi_call.git
    cd acpi_call
    make
    sudo insmod acpi_call.ko
    ./test_off.sh

Usage:

    # turn off discrete graphics card
    echo '\_SB.PCI0.PEG1.GFX0.DOFF' > /proc/acpi/call
    # turn it back on
    echo '\_SB.PCI0.PEG1.GFX0.DON' > /proc/acpi/call

Run on Startup

If you want run it on every startup add these lines to /etc/rc.local

Note:Running this without a delay on Kernel 2.6.35.x has issues (Boots
fine but X and tty do not show up; to avoid that, simply add
sleep <time> before these lines and remember that sleep affects every
line below it. If you mess up or decide to test it, just boot into
recovery mode and edit /etc/rc.local from cli, to either add the delay
or remove the lines altogether

    # Disable Nvidia
    insmod <path to acpi_call dir>/acpi_call.ko
    echo '\_SB.PCI0.PEG1.GFX0.DOFF' > /proc/acpi/call

If want, you may verify the power usage, on battery, with
grep rate /proc/acpi/battery/BAT0/state. There should be a difference of
about 7500 mW in battery usage.

Enable/Disable Scripts

You can easily create a couple of scripts to enable and disable it.

    #/bin/sh
    # Disable Nvidia
    sudo insmod /home/xehoz/build/acpi_call/acpi_call.ko
    echo '\_SB.PCI0.PEG1.GFX0.DOFF' > /proc/acpi/call

    #/bin/sh
    # Enable Nvidia
    sudo insmod /home/xehoz/build/acpi_call/acpi_call.ko
    echo '\_SB.PCI0.PEG1.GFX0.DON' > /proc/acpi/call

chmod +x both of them and type sh <name you've given them> to use them.

Audio
-----

Follow the official documentation: ALSA and Pulseaudio

Note:From my experience OSS doesn't work

While it outputs sound to the speakers, the headphone jack won't work,
and the speakers won't mute when a headphone is plugged in and the
integrated mic won't work either.

In order to fix this, follow these steps.

1. Install ALSA drivers available at Realtek [8]

    tar xvf LinuxPkg_x.x
    tar xvf alsa-driver-1.0.xx
    cd alsa-driver-1.0.xx
    ./configure --with-cards=hda-intel
    make
    make install

Note:Realtek's ALSA drivers, currently 1.0.23-5.15rc5, aren't compiling
properly in kernel 2.6.35. As an alternative, download the latest
alsa-driver snapshot from here[9] (tested with 01/09/2010 snapshot)

2. Add options snd-hda-intel index=0 model=auto to
/etc/modprobe.d/modprobe.conf.

Open /etc/modprobe.d/sound.conf and add:

    alias snd-card-0 snd-hda-intel
    alias sound-slot-0 snd-hda-intel

> HDMI

Sound through HDMI works, but requires that the sound profile (mixer) be
changed manually (not really an issue).

Touchpad
--------

1. Follow the Synaptics guide.

Type <codegrep pointer>xinput list </code>. What you want to see:

    ⎜   ↳ ETPS/2 Elantech Touchpad                	id=16	[slave  pointer  (2)]

However, you'll see that the system is misinterpreting the touchpad for
a wheel mouse. This is because this laptop (and so many others recently)
is using an Elantech Touchpad. In order to fix it, enter this in the
command line:

    echo "options psmouse force_elantech=1" | sudo tee -a /etc/modprobe.d/psmouse.conf
    sudo rmmod psmouse && sudo modprobe psmouse

Then, open /etc/X11/xorg.conf.d/10-synaptics.conf. A bare minimum
configuration requires this text:

    Section "InputClass"
            Identifier      "touchpad catchall"
            Driver          "synaptics"
            MatchIsTouchpad "on"
                  Option    "LeftEdge"              "130"
                  Option    "RightEdge"             "840"
                  Option    "TopEdge"               "130"
                  Option    "BottomEdge"            "640"
    EndSection

Note:While I settled with these coordinates, they may require tuning:
Touchpad_Synaptics#fine-tuning_with_synclient

.

> Working 10-synaptics.conf

Here's a fully working 10-synaptics.conf with Edge Scrolling, Two Finger
Scrolling and with middle mouse click (LTCornerButton and
RTCornerButton) on the top corners activated. Circular Scrolling works,
but it's deactivated.

    /etc/X11/xorg.conf.d/10-synaptics.conf

    Section "InputClass"
            Identifier      "touchpad catchall"
            Driver          "synaptics"
            MatchIsTouchpad "on"
    		Option	"SHMConfig"		"on"
    		Option 	"LeftEdge"          	"130"
    		Option	"RightEdge"         	"840"
    		Option	"TopEdge"           	"130"
    		Option	"BottomEdge"        	"640"
    		Option	"VertEdgeScroll"	"on"
    		Option	"HorizEdgeScroll"	"on"
    		Option	"CornerCoasting"	"on"
    		Option	"CoastingSpeed"		"0.30"
    		Option	"VertTwoFingerScroll"   "on"
    		Option	"HorizTwoFingerScroll"  "on"
    		Option	"CircularScrolling"	"off"
    		Option	"CricularTrigger"	"0"
    		Option	"TapButton1" 		"1"
    		Option	"TapButton2" 		"2"
    		Option	"TapButton3" 		"3"
    		Option	"LTCornerButton"	"2"
    		Option	"RTCornerButton"	"2"
    EndSection

Suspend to RAM
--------------

Note:As far as I can tell, there is a general issue with USB 3.0 and
suspending at the kernel level.

Note:This is section was written in kernel 2.6.36.2-1 and with the
packages available on 18th December.

I achieved Suspension to RAM by using pm-utils with either the uswsusp
and kernel method.

1. Follow the pm-utils article . It is quite extense and can be
confusing, but, if I recall, this is the very minimum of what is needed
to do:

1.1 Type pacman -S pm-utils uswsusp

1.2 To a file inside /etc/pm/config.d/, add:

    SLEEP_MODULE="uswsusp"
    #SLEEP_MODULE="kernel"
    HIBERNATE_MODE="shutdown"

1.3 Add the resume hook to /etc/mkinitcpio.conf, before filesystems.

    HOOKS="base udev autodetect pata scsi sata resume filesystems"

1.4 Rebuild the initrd image with mkinitcpio -p linux.

Now, to the hardware specific part.

2. Add

    SUSPEND_MODULES="xhci-hcd ehci-hcd"

to /etc/pm/config.d/usb3-suspend-workaround.

After a surge of updates, somewhere on the end of November/start of
December (bug report), suspend to ram only works if nouveau is
explicitly disabled in rc.conf. Since nouveau isn't related to the
ability to power the nvidia card off, powering it off is still possible,
even after disabling that module.

3. Add !nouveau to the MODULES line in rc.conf. It should look like
this:

    MODULES=(fuse acpi-cpufreq cpufreq_ondemand cpufreq_powersave !snd-pcm-oss vboxdrv !nouveau)

Webcam
======

Working, since version v4l-utils 0.8.1-1 (in previous versions the
picture was upside down).

    $ lsusb |grep Chicony
    Bus 002 Device 003: ID 04f2:b1bb Chicony Electronics Co., Ltd

Function Keys
=============

Most of them do work. Exceptions are the multimedia player commands
(fn+arrows), fn+c, fn+v and fn+F9 (which should disable the touchpad).
It should be possible to have them all working by following Extra
Keyboard Keys.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_N82JV&oldid=208447"

Category:

-   ASUS
