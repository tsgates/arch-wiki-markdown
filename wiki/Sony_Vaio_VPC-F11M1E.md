Sony Vaio VPC-F11M1E
====================

Contents
--------

-   1 Introduction
-   2 Xorg
-   3 Display backlight regulation
-   4 Automatic Backlight Regulation
-   5 Special Keys
    -   5.1 Using udev
    -   5.2 Using the kernel tool setkeycodes
-   6 Hardware Controls
-   7 Suspend to RAM
-   8 DTS/AC3 Over HDMI with ALSA
-   9 DTS/AC3 Over HDMI with PULSE
-   10 Sources

Introduction
------------

This is a mini guide to configure a Sony Vaio VPC-F11M1E on Arch Linux.

Processor - Intel Core i5-520M

Memory - 4 GB RAM DDR3

Graphics chipset - nVidia GeForce GT 330M

    $ lspci

    00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 02)
    00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16 Root Port (rev 02)
    00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 05)
    00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 05)
    00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 (rev 05)
    00:1c.2 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 3 (rev 05)
    00:1c.5 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 6 (rev 05)
    00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5)
    00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 05)
    00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI Controller (rev 05)
    00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 05)
    00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem (rev 05)
    01:00.0 VGA compatible controller: nVidia Corporation GT216 [GeForce GT 330M] (rev a2)
    01:00.1 Audio device: nVidia Corporation High Definition Audio Controller (rev a1)
    02:00.0 Network controller: Intel Corporation Centrino Advanced-N 6200 (rev 35)
    03:00.0 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller
    03:00.1 System peripheral: Ricoh Co Ltd Memory Stick Host Controller
    03:00.3 FireWire (IEEE 1394): Ricoh Co Ltd FireWire Host Controller
    03:00.4 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller
    04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8057 PCI-E Gigabit Ethernet Controller (rev 10)
    3f:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers (rev 02)
    3f:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 02)
    3f:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
    3f:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 02)
    3f:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
    3f:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)

Xorg
----

X server works with the standard nvidia package but shows a blank screen
when exiting the X server or just switching terminals using Ctrl+Alt+Fx.

To resolve the blank screen issue you need to use vesafb.

Install v86d and remove any vga=<foo> kernel boot parameters.

Next ensure that /etc/modprobe.d/uvesafb.conf contains:

    options uvesafb mode_option=1280x800-32 scroll=ywrap

This isn't the largest resolution available (1280x1024-32 is) but it
best fits the aspect ratio of the screen.

Finally add the v86d hook to HOOKS in mkinitcpio.conf:

    HOOKS="base udev v86d ..."

and regenerate your initramfs with mkinitcpio (adjust the following
command to your setup):

    mkinitcpio -p linux

Display backlight regulation
----------------------------

I found this solution -
http://code.google.com/p/vaio-f11-linux/wiki/NVIDIASetup. It's for Vaio
F11, but it works for my F13 too.

I've added this line in section "Device" in /etc/X11/xorg.conf :

    Option    "RegistryDwords"    "EnableBrightnessControl=1;PowerMizerEnable=0x1;PerfLevelSrc=0x3333;PowerMizerLevel=0x3;PowerMizerDefault=0x3;PowerMizerDefaultAC=0x3"

Plus I use module sony_laptop .. MODULES=(sony_laptop) in /etc/rc.conf

The patched kernel is available in the AUR: linux-sony

The sony-acpid daemon is also available in the AUR: sony-acpid-git

Keep in mind that you will need a custom nvidia package for each custom
kernel. Alternatively, you can install nvidia-all

Automatic Backlight Regulation
------------------------------

This requires the linux-sony and sony-acpid-git packages.

Once those two packages are installed, add sony-acpid to the DAEMONS
array in rc.conf:

    DAEMONS=(hwclock syslog-ng !network !netfs crond @net-profiles alsa sony-acpid)

Special Keys
------------

The 'Display Off' and media keys work out of the box.

The 'ASSIST', 'S1' and 'VAIO' keys require configuring the appropriate
keymap.

> Using udev

Firstly run:

    $ /lib/udev/findkeyboards

Then do:

    # /lib/udev/keymap -i input/eventX

BUT switch input/eventX for the keyboard outputted in the first command.
I got 'AT keyboard' and 'module' from the first command. 'AT keyboard'
is the normal keyboard for mapping 'Fn+X' and 'module' is the hotkey
keyboard.

After doing the second command you need to press the buttons that you
want to map, then Control-C to exit keymap.

Then edit /lib/udev/keymaps/module-sony, adding the relevant scan code
from the second command and then the event you want. All valid events
are listed in http://hal.freedesktop.org/quirk/quirk-keymap-list.txt

Here is an example module-sony keymap file for the VPC-F11M1E:

    0xA0 mute # Fn+F2
    0xAE volumedown # Fn+F3
    0xB0 volumeup # Fn+F4
    0x10 brightnessdown # Fn+F5
    0x11 brightnessup # Fn+F6
    0x12 switchvideomode # Fn+F7
    0x14 zoomout # Fn+F9
    0x15 zoomin # Fn+F10
    0x17 suspend # Fn+F12
    0x28 help #Assist
    0x20 prog1 #S1
    0x49 vendor #VAIO Hotkey

> Using the kernel tool setkeycodes

See the detailed article: setkeycodes.

Hardware Controls
-----------------

Many VAIO specific hardware controls can be adjusted using the VAIO
control centre, which is in the vaio-control-center-git package.

Suspend to RAM
--------------

Out of the box, a "sudo pm-suspend" will result in a proper suspending
but a failure to resume, resulting in a new reboot. The solution is to
add the following parameter to your kernel (into the line )

    acpi_sleep=nonvs

Your grub kernel entry should look like this

    linux /boot/vmlinuz-linux-sony root=/dev/dm-1 acpi_sleep=nonvs

DTS/AC3 Over HDMI with ALSA
---------------------------

Make sure you installed ALSA.

    $ aplay -l

    **** List of PLAYBACK Hardware Devices ****
    card 0: Intel [HDA Intel], device 0: ALC275 Analog [ALC275 Analog]
      Subdevices: 1/1
      Subdevice #0: subdevice #0
    card 0: Intel [HDA Intel], device 1: ALC275 Digital [ALC275 Digital]
      Subdevices: 1/1
      Subdevice #0: subdevice #0
    card 1: NVidia [HDA NVidia], device 3: HDMI 0 [HDMI 0]
      Subdevices: 1/1
      Subdevice #0: subdevice #0
    card 1: NVidia [HDA NVidia], device 7: HDMI 0 [HDMI 0]
      Subdevices: 1/1
      Subdevice #0: subdevice #0
    card 1: NVidia [HDA NVidia], device 8: HDMI 0 [HDMI 0]
      Subdevices: 1/1
      Subdevice #0: subdevice #0
    card 1: NVidia [HDA NVidia], device 9: HDMI 0 [HDMI 0]
      Subdevices: 1/1
      Subdevice #0: subdevice #0

The right ALSA device to use to get a working sound over HDMI is the
device 7.

To get mplayer to use it,

    mplayer -ao alsa:device=hw=1.7 -channels 8 -ac hwdts,hwac3, <file>

The comma after hwac3 is not a typo.

DTS/AC3 Over HDMI with PULSE
----------------------------

After installing pulseaudio, you will need to edit

    /etc/pulse/default.pa

and add the following line

    load-module module-alsa-sink device=hw:1,7 channels=8

Put channels to the highest number of channels supported by the
combination of your hardware (computer + receiver/TV).

Sources
-------

http://code.google.com/p/vaio-f11-linux/w/list?q=label:State-Solution

https://wiki.archlinux.org/index.php/Map_scancodes_to_keycodes

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sony_Vaio_VPC-F11M1E&oldid=292110"

Category:

-   Sony

-   This page was last modified on 9 January 2014, at 04:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
