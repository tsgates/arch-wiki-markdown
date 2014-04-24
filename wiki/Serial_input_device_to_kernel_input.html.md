Serial input device to kernel input
===================================

  
 Although USB is the most popular way to connect input devices such as
mice, serial input devices, such as older mice, and more exotic input
devices such as 3Dconnexion Spaceballs are still quite usable, either
with a serial port built into the computer, or via a USB to serial
converter dongle.

The traditional way to support these serially attached input devices was
to configure each application with the details such as which serial port
the input device was attached to and what protocol the device used. As
the most common application people used with a serial input device was
X.org / XFree86, this wasn't too much of a problem. However, if you used
a variety of applications that needed to talk to the serial input device
directly, you may encounter limitations to which serial input device or
protocol each application supported. Some applications may not have
supported a serial input device you'd have preferred to use.

A better approach is to have the Linux kernel input subsystem manage the
serially attached input device, and then present the input signals the
device generates in the same way that USB and PS/2 input device signals
are presented to applications, via the /dev/input/{mice|mouseX} device
files.

This guide describes the simple steps necessary to "attach" a serial
input device to the Linux kernel input subsystem.

Installation
------------

Firstly, you'll need to install the inputattach utility from
linuxconsole package. This utility tells the kernel input subsystem
which serial port the input device is attached to, and what type of
device is attached to the specified serial port. The linuxconsole
package is in community:

    # pacman -S linuxconsole

Configuration and usage
-----------------------

Once you have installed package, you can view the inputattach help, to
see the large list of serial input devices the Linux kernel input
subsystem supports. Here is an example of the help output:

    $ inputattach --help

    Usage: inputattach [--daemon] [--baud <baud>] [--always] [--noinit] <mode> <device>

    Modes:
      --sunkbd         -skb      Sun Type 4 and Type 5 keyboards
      --lkkbd          -lk       DEC LK201 / LK401 keyboards
      --vsxxx-aa       -vs       DEC VSXXX-AA / VSXXX-GA mouse and VSXXX-A tablet
      --spaceorb       -orb      SpaceOrb 360 / SpaceBall Avenger
      --spaceball      -sbl      SpaceBall 2003 / 3003 / 4000 FLX
      --magellan       -mag      Magellan / SpaceMouse
      --warrior        -war      WingMan Warrior
      --stinger        -sting    Gravis Stinger
      --mousesystems   -msc      3-button Mouse Systems mouse
      --sunmouse       -sun      3-button Sun mouse
      --microsoft      -bare     2-button Microsoft mouse
      --mshack         -ms       3-button mouse in Microsoft mode
      --mouseman       -mman     3-button Logitech / Genius mouse
      --intellimouse   -ms3      Microsoft IntelliMouse
      --mmwheel        -mmw      Logitech mouse with 4-5 buttons or a wheel
      --iforce         -ifor     I-Force joystick or wheel
      --newtonkbd      -newt     Newton keyboard
      --h3600ts        -ipaq     Ipaq h3600 touchscreen
      --stowawaykbd    -ipaqkbd  Stowaway keyboard
      --ps2serkbd      -ps2ser   PS/2 via serial keyboard
      --twiddler       -twid     Handykey Twiddler chording keyboard
      --twiddler-joy   -twidjoy  Handykey Twiddler used as a joystick
      --elotouch       -elo      ELO touchscreen, 10-byte mode
      --elo4002        -elo6b    ELO touchscreen, 6-byte mode
      --elo271-140     -elo4b    ELO touchscreen, 4-byte mode
      --elo261-280     -elo3b    ELO Touchscreen, 3-byte mode
      --mtouch         -mtouch   MicroTouch (3M) touchscreen
      --tsc            -tsc      TSC-10/25/40 serial touchscreen
      --touchit213     -t213     Sahara Touch-iT213 Tablet PC
      --touchright     -tr       Touchright serial touchscreen
      --touchwin       -tw       Touchwindow serial touchscreen
      --penmount9000   -pm9k     PenMount 9000 touchscreen
      --penmount6000   -pm6k     PenMount 6000 touchscreen
      --penmount3000   -pm3k     PenMount 3000 touchscreen
      --penmount6250   -pmm1     PenMount 6250 touchscreen
      --fujitsu        -fjt      Fujitsu serial touchscreen
      --ps2mult        -ps2m     PS/2 serial multiplexer
      --zhen-hua       -zhen     Zhen Hua 5-byte protocol
      --easypen        -ep       Genius EasyPen 3x4 tablet
      --taos-evm       -taos     TAOS evaluation module
      --dump           -dump     Just enable device
      --w8001          -w8001    Wacom W8001

    $

For example, if you have a Logitech TrackMan Marble serial mouse, as I
do, the device type you would specify would be either --mouseman or
-mman.

The default /etc/conf.d/inputattach.conf file assumes a Microsoft serial
mouse, and assumes the mouse is attached to the first serial port of the
computer. The IAPARAMS variable is an array of inputattach arguments. An
inputattach instance will be started for each element. See inputattach
--help for details on arguments.

Here's an example of a /etc/conf.d/inputattach.conf file, modified to
suit a Logitech TrackMan Marble serial mouse:

    $ cat /etc/conf.d/inputattach.conf 
    #
    # Configuration for inputattach
    #
    # IAPARAMS is an array of inputattach arguments, see 'inputattach --help'.
    # An inputattach instance will be started for each element.

    IAPARAMS=(
      "--mouseman /dev/ttyS0"
    )

    $

Once you have modified the /etc/conf.d/inputattach.conf file, you can
then attempt to start the inputattach service, by running

    # systemctl start inputattach

If you happen to be within Xorg when you do this, and have an
InputDevice mouse section that specifies /dev/input/mice as the input
device file, your new input device is likely to now be another source
for Xorg mouse pointer movements, in addition other input devices e.g.,
a USB mouse.

Another way to confirm that it worked is to check your system's kernel
log using the dmesg utility. For a Logitech TrackMan Marble serial
mouse, the kernel output is:

    serio: Serial port ttyS0
    input: Logitech M+ Mouse as /class/input/input6

To have your serial input device work everytime you boot, enable the
service:

    # systemctl enable inputattach

And that is all you have to do!

Retrieved from
"https://wiki.archlinux.org/index.php?title=Serial_input_device_to_kernel_input&oldid=283437"

Category:

-   Input devices

-   This page was last modified on 17 November 2013, at 14:34.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
