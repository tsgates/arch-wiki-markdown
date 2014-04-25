IBM ThinkPad X31
================

The IBM Thinkpad X31 is a wonderful little laptop which contains
everything you need for your everyday work, and even some gaming, if you
tweak things a little. The X31 is rock solid, light (3.7 lbs), and
nowadays very cheap. The only drawback is the lack of internal optical
drive. You can see the specs of the X31 on ThinkWiki, a wonderful
resource with additional information.

Contents
--------

-   1 Installation
-   2 Hibernation
-   3 Xorg and direct rendering
    -   3.1 Rovclock
    -   3.2 Dual Screen
-   4 Powersaving
    -   4.1 Laptop-mode
    -   4.2 Undervolting
    -   4.3 Modprobe
    -   4.4 Powertop
    -   4.5 Hard drive dilemma
-   5 ACPI and Hardware-related
    -   5.1 Fan-control
    -   5.2 thinkpad_acpi and tp_smapi kernel modules
-   6 Wireless
-   7 Audio keys

Installation
------------

A basic Arch Linux installation will do just fine for about everything,
so I won't talk about sound or other basic stuff. No custom kernel
needed. However, you will need the following particular packages:

-   ipw2100-fw and wireless_tools for wireless
-   xf86-video-ati for direct rendering (see above)
-   uswsusp for hibernation (see above)

The following useful packages are in the AUR.

-   rovclock for boosting direct rendering (see above)

Hibernation
-----------

To hibernate using pm-utils (tested with kernel 2.6.37), you have to
adjust some screws of the default setup. Doing this, hibernation works
flawlessly. You have to setup pm-utils first. If it's working out of the
box, do not read further.

Don't forget to install radeontool from the AUR, as it's needed to turn
off the lcd backlight.

If your X31 freezes during hibernation or just reboots instead of
resume, when you power on again, this might help you:

Append the following to your kernel line in grub's config:

    /boot/grub/menu.lst

    nomodeset acpi_sleep=nonvs 

-   nomodeset will turn off kernel modesetting, which tries to
    automatically handle the resolution during boot. Take a look at [1].
-   acpi_sleep=nonvs is a workaround, see
    Pm-utils#Reboot_instead_of_resume_from_suspend for detailed
    information.

Xorg and direct rendering
-------------------------

This section assumes the ATI Radeon Mobility M6 LY video card. This can
be verified using:

    $ lspci | grep Mobility

Here is a minimal xorg.conf, optimized for performance:

    /etc/X11/xorg.conf

    Section "ServerFlags"
    	Option "AutoAddDevices" "False"
    EndSection

    Section "Device"
    	Identifier	"Card0"
    	Driver		"ati"
    	BusID		"PCI:1:0:0"
    	Option		"AGPMode" "4"
    	Option		"AGPFastWrite" "on" #Faster than default (off)
    	Option		"SWcursor" "off" #Faster than default (on)
    	Option		"EnablePageFlip" "on" #Faster than default (off)
    	Option		"AccelMethod" "EXA" # or XAA, EXA, XAA more stable, XAA is deafult
    	Option		"DynamicClocks" "on"
    	Option		"BIOSHotkeys"   "on"
    	Option		"AGPSize" "32" # default: 8
    	Option		"EnableDepthMoves" "true"
    EndSection

    Section "Extensions"
      Option "Composite" "Disable"
    EndSection

Note:This configuration disables compositing to improve performance. If
you need this feature, set Composite to Enable. Also, if you want to use
Xorg Input Hotplugging, set AutoAddDevices to true.

> Rovclock

You can also overclock your graphic card. As far as I know, there is no
real drawback, but you can play it safe and only use it while running a
game or compiz or any application using your graphic card:

    rovclock -c 220 -m 210

Use this command to get back to default settings:

    rovclock -c 144 -m 144

If you want to enable it permanently, add the first command in xprofile.

If, on the contrary, you barely use your graphic card, you can lower
both power usage and temperature slightly by underclocking your graphic
card at boot by adding this command to xprofile:

    rovclock -c 90 -m 100

> Dual Screen

If you want to use an external screen for a presentation or as an
extended desktop, you can use xrandr. For an extended desktop, you
should first add one line in your /etc/x11/xorg.conf configuration file
in the SubSection "Display" area:

Before:

    SubSection "Display"
     		Depth     24
     		Modes "1024x768" "800x600" "640x480"
    EndSubSection

After:

    SubSection "Display"
    		Depth     24
    		Modes "1024x768" "800x600" "640x480"
    		Virtual 2304 1024
    EndSubSection

The numbers are the total rectangular resolution that you need to use.
In this case, I'm using the internal 1024x768 screen and an external
1280x1024 screen on the right. The total resolution is 1024+1280=2304
pixels large and 1024>768=1024 pixels height.

Note that in 24 bits with this option, the performance is affected for
3D drawing, so you may need to comment it and use only one screen when
you need the graphical power.

Then restart your X server. You can issue this command in a shell:

    xrandr --output VGA-0 --right-of LVDS

To find the exact name of the monitors and the maximum resolution that
you set up in the configuration file, you can type just xrandr without
arguments.

Powersaving
-----------

> Laptop-mode

This will put your screen brightness to the minimum level when on
battery and restore it to maximum when on ac power:

    echo -e '#!/bin/bash\necho 0 > /sys/class/backlight/thinkpad_screen/brightness' > /etc/laptop-mode/batt-start/battscript
    chmod 0755 /etc/laptop-mode/batt-start/battscript
    echo -e '#!/bin/bash\necho 7 > /sys/class/backlight/thinkpad_screen/brightness' > /etc/laptop-mode/lm-ac-start/acscript
    chmod 0755 /etc/laptop-mode/lm-ac-start/acscript
    ln -s /etc/laptop-mode/lm-ac-start/acscript /etc/laptop-mode/onlm-ac-start/acscript

It will create scripts, executed by the laptop-mode daemon when
switching the power source, that change the brightness of your screen
using the thinkpad_acpi module.

> Undervolting

The X31 CPUs can be undervolted, which means they will offer you the
same performance, but with more battery life and a cooler laptop. From
personal experience, my CPU temperature,during 100% activity, dropped by
15-20°C just by using this patch. This is extremely easy using the
linux-phc patch, but only if you know the proper values to give the CPU.
Informations on how to find them is available here or here. I know it
can be hard to find your own values, so here is a table were you can
indicate what are the good values for each of the X31 CPUs:

-   Pentium-m 1600MHz : 34 26 18 12 8 5

Warning:Your computer may freeze once a month because of those values.
If you find more stable ones, please indicate them.

Once you have your values, just run:

    # echo VALUES > /sys/devices/system/cpu/cpu0/cpufreq/phc_vids

For example:

    # echo 34 26 18 12 8 5 > /sys/devices/system/cpu/cpu0/cpufreq/phc_vids

You can add this command to your /etc/rc.local to make the undervolting
permanent.

> Modprobe

Create the following file:

    /etc/modprobe.d/powersave.conf

     options usbcore autosuspend=1
     options ipw2100 associate=0
     options thinkpad-acpi experimental=1 fan_control=1

The three first lines put some of your devices in power-saving mode,
respectively the USB ports, and the wireless card. Note that you need
the last line in order to control your fan speed (see above).

See power saving for more details.

> Powertop

To see additional sources of power drain, install powertop:

    # pacman -S powertop

And run it while on battery power. See Powertop for more information.

> Hard drive dilemma

As set earlier, the hard drive is on a power-saving mode that can make
it spin off and on often. It may reduce its lifetime. You can install
the smartmontools package and issue this command:

    # smartctl -A /dev/sda | grep Load_Cycle_Count

If the number is growing too fast, you might want to set off the
powersaving mode by issuing:

    # hdparm -B 254 /dev/sda

Put it in /etc/rc.local to modify it at boot time.

ACPI and Hardware-related
-------------------------

> Fan-control

You can use a script from ThinkWiki to considerably lower your CPU
temperature. Simply download it from here, rename it to tp-fancontrol,
and run:

    # chmod 0755 tp-fancontrol
    # mv tp-fancontrol /usr/bin

To run the script at each boot, add this line to your /etc/rc.local:

    tp-fancontrol -d

Also, I suggest changing the first maximum temperature threshold (the
CPU one) to 55. Just edit /usr/bin/tp-fancontrol, the file is
self-explanatory.

> thinkpad_acpi and tp_smapi kernel modules

To make use of all hardware, use Tp_smapi and thinkpad_acpi. The former
is in the AUR, thinkpad_acpi is merged into the kernel and has just to
be loaded.

Have a look at Thinkwiki for scripts and tweaks:

-   Thinkpad_acpi
-   Tp_smapi

Wireless
--------

If you have the Cisco neta504 wifi card, it's a bit tricky to use the
wpa encryption with it. First, unload the airo and the airo_cs modules.
remove the module airo from the kernel

    # rmmod airo
    # rmmod airo_cs

Next, blacklist the modules in /etc/modprobe.d/.

then install ndiswrapper

    # pacman -S ndiswrapper

download the neta504 driver for windows and unpack it (Be sure that you
have unpacked the whole driver !) Then run :

    # ndiswrapper -i /path/to/your/dir/netA504.inf

Save the ndiswrapper conf file :

    # ndiswrapper -m
    # ndiswrapper -ma
    # ndiswrapper -mi

Now you can add to your kernel the module :

    # modprobe ndiswrapper

and voilà ! I've tried this with wicd and it works flawlessly !

Audio keys
----------

To have an on-screen Display for volume change or thinklight activation
you can use Tpb: ThinkPad_OSD. The audio volume up/down keys will change
audio volume independently from ALSA/OSS mixer. This works quite well,
so try it out.

To enable the audio keys interfacing with ALSA, add:

    event=ibm/hotkey HKEY 00000080 *
    action=/etc/acpi/soundkey.sh %e

to /etc/acpi/events/soundkey, create the following file and make it
executable:

    /etc/acpi/soundkey.sh

    #!/bin/bash

    echo here > /tmp/fish
    echo $4 >> /tmp/fish
    case "$4" in
    	00001015)
    		amixer -c 0 set Master playback unmute
    		amixer -c 0 set Master playback 3%+
    		;;
    	00001016)
    		amixer -c 0 set Master playback unmute
    		amixer -c 0 set Master playback 3%-
    		;;
    	00001017)
    		amixer -c 0 set Master playback mute
    		;;
    esac

You'll also need to add:

    echo enable,0xffffffff >/proc/acpi/ibm/hotkey

to /etc/rc.local or somewhere similar for the events to be recognized.

Retrieved from
"https://wiki.archlinux.org/index.php?title=IBM_ThinkPad_X31&oldid=230967"

Category:

-   IBM

-   This page was last modified on 24 October 2012, at 01:08.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
