NEC Versa S950
==============

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Overview                                                           |
| -   2 Specs                                                              |
| -   3 Setup                                                              |
|     -   3.1 CPU                                                          |
|     -   3.2 Text Console                                                 |
|     -   3.3 Xorg/video                                                   |
|     -   3.4 Xorg/input                                                   |
|     -   3.5 Hitachi HDD                                                  |
|     -   3.6 Sound and Ethernet                                           |
|     -   3.7 Wi-Fi                                                        |
|     -   3.8 Bluetooth                                                    |
|     -   3.9 IrDA                                                         |
|     -   3.10 FireWire                                                    |
|     -   3.11 CardBus (PCMCIA)                                            |
|     -   3.12 Card reader                                                 |
|     -   3.13 Framebuffer                                                 |
|     -   3.14 Modem                                                       |
|                                                                          |
| -   4 External display                                                   |
| -   5 Hibernation                                                        |
| -   6 Basic disassembly                                                  |
| -   7 Usage notes                                                        |
+--------------------------------------------------------------------------+

Overview
--------

NEC Versa S950 is a relatively small Pentium M based laptop with
non-glare 14" display. Its weight is around 2.2 kg, and supplied 4800
mAh battery lets it run for ~3h in autonomous mode.

Linux support is complete for this device, all built-in peripherals have
functional linux drivers. Arch Linux installation goes smoothly. Aside
from local sources (DVD, USB or possibly SD) you can use Ethernet for
network installation, but probably not Wi-Fi.

In this guide I'll describe describe what may be done after installation
to get all the hardware working. I assume reader has some general linux
knowledge, and skip nonspecific parts of installation and Arch
configuration.

Specs
-----

-   Processor: Pentium M 735A 1.73GHz (socket 479)
-   Screen: 14.0" non-glare WXGA 1280x768 (AUO B140EW01, TN/CCFL)
-   Memory size: 1G DDR2 PC2 4300 SDRAM (max. 2G)
-   Motherboard: DA0CH1MB8E1 rev.E
-   North Bridge: Intel 915GM (QG82915GM SL8G6)
-   South Bridge: Intel ICH6-M
-   BIOS: Phoenix NoteBIOS ver.4 rev.6.1 (last update: 3A23)
-   Hard disk drive: 60G Hitachi Travelstar 5K100
-   Optical disk drive: Philips SDVD8441
-   Sound: SigmaTel STAC9200
-   Ethernet: Broadcom BCM5788
-   Wi-Fi: Intel PRO/Wireless 2200BG in miniPCI slot
-   Bluetooth: Broadcom 2101
-   IrDA: NSC unknown
-   Modem: Agere Athens AM2
-   Card reader: TI FlashMedia SD (PCI7114 based)
-   FireWire: TI OHCI compilant
-   Touchpad: AVC Finger sensing pad

There are several other modifications, with different RAM and HDD sizes.
CPU is upgradeable up to Pentium M 780 2.26GHz.

Setup
-----

> CPU

Use acpi-cpufreq module together with some governor to control CPU speed
(cpufreq_ondemand seems to be the most popular choice, though I myself
prefer cpufreq_powersave).

There's a standard Arch way to do this: install cpufrequtils from
[extra], check /etc/conf.d/cpufreq:

    	governor="ondemand"
    	#min_freq commented out
    	#max_freq commented out

then add cpufreq to DAEMONS in /etc/rc.conf (and/or run it manually).

See Cpufrequtils, CPU_Frequency_Scaling.

> Text Console

No useful BIOS textmodes. Pity. Either leave it as is, or use
framebuffer.

> Xorg/video

Video is handled by intel driver. Relevant section of my xorg.conf is

    	Section "Device"
    		Identifier		"i915G"
    		Driver			"intel"
    		Option "DRI"		"true"
    	EndSection
    	
    	Section "Screen"
    		Identifier		"Screen0"
    		Device			"i915G"
    		Monitor			"Versa display"
    		DefaultColorDepth	24
    		SubSection "Display"
    			Depth 		24
    			Modes		"1280x768"

Virtual 1280 1536

    		EndSubSection
    	EndSection

DRI is backed by i915.ko, which seems to be autoloaded — no need to
mention it in rc.conf.

You should get native 1280x768 without running 915resolution, but in
some cases I had to use it; check carefully which mode X uses!

Virtual is set to accomodate two 1280x768 displays, one atop another;
you may need to tweak it for your needs. See [NEC_Versa_S950#External
display|xrandr setup]. Beware, setting any of Virtual dimensions to
anything greater than 2048 will effectively disable DRI.

Note: seems like there's no software way to control backlight
brightness.

> Xorg/input

Laptop keyboard may require keymap tweaking, but that's not necessary.
Fn key is processed somewhere in BIOS and you have no control over it.
Two additional buttons near power switch generate codes 178 and 236 -
bind them if you need them. Audio Mute, Raise/Lower key codes are 140,
176/174, respectively. See Multimedia keys on Arch forum.

Touchpad is dumb crappy AVC unit connected via PS/2 — just use
/dev/input/mice and do not bother trying to configure it. It's a good
idea to turn Emulate3Buttons on, there's no hardware button 3. Buttons 4
and 5 (scroll), on the other hand, are there: tap on the upper
right/lower right corners of the pad.

Relevant section from xorg.conf:

    	Section "InputDevice"
    		Identifier		"Main mouse"
    		Driver 			"mouse"
    		Option "Protocol"	"auto"
    		Option "Device"		"/dev/input/mice"
    		Option "Emulate3Buttons" "true"
    		Option "ZAxisMapping"	"4 5"
    	EndSection

> Hitachi HDD

To avoid excessive load/unload cycles, add

    	hdparm -q -B 255 /dev/sda

to rc.local, tweaking -B value according to your needs.

Beware: head parking can be useful; in particular, it can save your HDD
when laptop falls. Do not use hdparm -B unless you known exactly what
you are doing.

See laptop harddrive Load_Cycle_Count issue.

> Sound and Ethernet

No additional setup required, modules (snd_hda_intel and tg3 resp.) are
guessed by Arch installer.

> Wi-Fi

Driver module, ipw2200, is guessed correctly by installer, but it won't
work unless you install firmware — ipw2200-fw from [core]. Add

    	options ipw2200 led=1

to modprobe.conf (or modprobe.d/ipw2200) to enable front panel LED. Also
note, you can turn it on/off by pressing Fn+F2, but current device state
can be hard to guess. "Failed to send SCAN_ABORT" in kern.log means card
is being turned on, and LED should show some activity (flash from time
to time at least).

> Bluetooth

Bluetooth dongle is connected via USB and handled by hci_usb module,
which is autoloaded when necessary. Pressing Fn+F4 actually
(dis)connects it from the bus, this can be seen in kern.log. The driver
does NOT reports anything when it finds device; mount usb fs:

    	mount -t usbfs none /proc/bus/usb

and examine /proc/bus/usb/devices to find "Foxconn Bluetooth", then
check whether Driver=hci_usb.

Note: for "hcitool dev" to work, you need the whole pack of daemons
running. Install bluez-utils and examine /etc/rc.d/bluetooth.

See Bluetooth for more information.

> IrDA

Load nsc-ircc module, and/or add it to MODULES in rc.conf. Should work,
though I didn't test it with any real device.

> FireWire

No setup needed, ohci1394 module is autoloaded.

> CardBus (PCMCIA)

No setup needed.

> Card reader

No setup needed, tifm_sd module seem to be autoloaded. Your card will be
accessible as /dev/mmcblk0, with partitions mmcblk0p1 etc.

> Framebuffer

To get native resolution in framebuffer, you have to use uvesafb. This
thing is quite tricky, my recipes may or may not work for you, so get
ready to read the real docs.

You need to put v86d together with 915resolution to initrd. Both can be
found in Arch repositories, but you probably won't be able to use those.
Check if prebuilt v86d runs, then examine it with ldd — you should not
get segfaults. If you do, reconfigure it --with-x86emu. Then rebuild
915resolution using klibc instead of glibc (set CC=klcc for make),
otherwise it won't be usable within initrd.

You need hook files for mkinitcpio, namely
/lib/initcpio/{install,hooks}/{915resolution,v86d}. Get them from
prebuilt packages, then modify HOOKS in /etc/mkinitcpio.conf:

    	HOOKS = (base udev 915resolution v86d ... )

resolution settings in /lib/initcpio/hooks/915resolution

    	msg -n ":: Patching the VBIOS..."
    	/usr/sbin/915resolution 5c 1280 768

and /etc/modprobe.d/uvesafb:

    	options uvesafb mode=1280x768 scroll=ywrap

(note: module parameter is mode=, not mode_option= as default
configuration suggests). At this point, you may try to modprobe uvesafb
— text console should switch to framebuffer.

If everything's ok, run

    # mkinitcpio -p linux

to rebuild initrd and reboot.

Note: this is one of possible ways to setup uvesafb. You can insert the
module later, say, in rc.local; initcpio won't be involved at all. You
can try to compile it statically into kernel and possibly get graphical
console much earlier.

Warning: suspend-to-RAM and uvesafb are mutually exclusive, at least for
this laptop. You can't choose both.

See uvesafb in Arch wiki and official site.

> Modem

There's no modem in this laptop. Ok, nowadays such things are sometimes
called "modems", but, well, they aren't. Agere Athens (or Athena
according to some NEC specs) is and AMR-type card, which is in fact a
sound card add-on with fancy (phone) connector, nothing more. It is
handled by snd_hda_intel, and you can see some of its controls in
alsamixer.

To make a real modem out of this, you need some software DSP to analyze
and make all those hissing, chirping and beeping which real modems use
to communicate. There's one called slmodem. Make sure it is built with
SUPPORT_ALSA=1, and run

    	slmodemd -a modem:0

It will create virtual serial port, /dev/ttySL0 usually, which can be
used for pppd etc.

See Smartlink_Modem_drivers, slmodem page

External display
----------------

There's no hardware hotkeys to control external display, so your only
option is xrandr. Typical usage:

-   turn display on: xrandr --output VGA --auto
-   turn display off: xrandr --output VGA --off
-   clone primary display: xrandr --output VGA --same-as LVDS
-   twinhead setup: xrandr --output VGA --below LVDS

Twinhead mode requires Virtual from xorg.conf to be large enough to hold
both displays together, i.e., for 1280x768 below 1280x768 you need at
least Virtual 1280 1536.

Hibernation
-----------

S4 (suspend-to-disk) seems to work well. S3 (suspend-to-ram) works well
too unless you use uvesafb, in which case X server will die on wakeup
and won't be able to start until next reboot. Maybe this will change in
future releases of xf86-video-intel and/or uvesafb.

You should POST video card after S3 wakeup, otherwise console will be
blank. Also, hdpart -B should be run again as HDD is turned off and
forgets its settings.

Plain kernel interface: To activate S4, just

    	echo 4 > /proc/acpi/sleep

uswsusp: Use s2disk for S4 and s2ram for S3. s2ram requires --vbe_post
option (or with appropriate line added to whitelist.c, having VBE_POST
in last field) to handle video card properly. See Suspend_to_Disk,
Suspend_to_RAM for more information.

pm-utils: Use pm-suspend for S3 and pm-hibernate for S4.

To reanimate sleeping laptop, press Power button.

When using S4, do not forget to specify resume=/dev/sdXN in kernel
command line (sdXN being your swap partition).

Basic disassembly
-----------------

Taking out some parts of the laptop may be necessary for upgrade or
routine maintenance. Seems like the official disassembly guide is not
available, so here's quick guide how to gain access to different parts
of the laptop.

Memory and Wi-Fi card: open lid at the bottom (fixed by two screws).

Optical drive: remove shallow screw (not the deeper one) left to bottom
lid, open the lid and push shiny metallic handle visible on the left
side next to Wi-Fi card until the drive comes out.

Keyboard: you need to remove plastic panel with buttons and LEDs above
the keyboard first. Open screen to full 180°, remove two screws at the
back of screen handlers, remove the battery, then push the plate from
below. You should push the side closer to the screen while keeping
keyboard side in place. Little screwdriver may be necessary to lift it
left and right of the battery place.

After the panel is done, remove two screws on the top of keyboard, and
one marked with K in circle from behind, then slide the keyboard forward
(to the screen). Again, you may need to use small screwdriver to help it
come out.

Fan: right under the keyboard.

To get access to the motherboard, you need to untie 14 screws from the
bottom plus some more around the memory and mini-PCI bay. Don't forget
the screw right under the keyboard (marked with an arrow). At this point
you should also detach Wi-Fi antenna wires and LCD interface, and remove
the screen lid.

To detach the motherboard from the case, make sure to remove HDD cover
and two screws on external VGA connector. Remove three screws that fix
the board on the base and two more that hold the fan. Carefully pull the
board, pay attention on the sound jacks, you might need to help them
out.

Usage notes
-----------

Do not press too hard on laptop lid, you can damage display (scratch it
against keyboard rim). If you did, first of all wipe the screen
carefully — display coating is apparently much harder than keyboard
paint, it may be not as bad as it seems.

When working under full load while standing on a flat surface, laptop
tends to heat above 70°C (ACPI termzone). To mend this, raise it above
the surface — a couple centimeters will be enough — to let cool air to
fan inlet. If temperature under load gets above 90°C, it means you need
to clean the fan from the dust and lint. In the worst cases, you may
need to replace the grease or the fan itself.

Retrieved from
"https://wiki.archlinux.org/index.php?title=NEC_Versa_S950&oldid=238185"

Category:

-   Laptops
