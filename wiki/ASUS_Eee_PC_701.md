ASUS Eee PC 701
===============

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Most of this information is from the Arch Forum. You can also find a lot
of helpful information from the EEEUser Forum.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Before You Begin                                                   |
|     -   1.1 Choosing Your Installation Media                             |
|                                                                          |
| -   2 Asus Eee PC model 701 repository from toofishes                    |
|     -   2.1 Package List                                                 |
|     -   2.2 Kernel-eee Installation Instruction                          |
|                                                                          |
| -   3 Additional Tips & Tweaks                                           |
|     -   3.1 Tweaking kernel-eee                                          |
|     -   3.2 Using Wine with toofishes' kernel                            |
|     -   3.3 Power down with the power button                             |
|     -   3.4 Use cpufreq for power saving                                 |
|     -   3.5 Update your BIOS without Xandros                             |
|     -   3.6 More usable font sizes                                       |
|         -   3.6.1 The_glu's method                                       |
|         -   3.6.2 Old method                                             |
|         -   3.6.3 Alternative Method                                     |
|                                                                          |
| -   4 Known problems and their solutions                                 |
|     -   4.1 Sound                                                        |
|     -   4.2 Webcam                                                       |
|     -   4.3 Microphone                                                   |
|     -   4.4 Wireless doesn't work, even after installing custom Madwifi  |
|         module                                                           |
|     -   4.5 Unclean unmount during shutdown when having home directory   |
|         mounted on SD card                                               |
|     -   4.6 Booting from card without initrd                             |
|     -   4.7 Sleeping and waking system on a card                         |
|     -   4.8 Display doesn't wake up properly                             |
|     -   4.9 DMA problems                                                 |
|                                                                          |
| -   5 Battery Tests                                                      |
+--------------------------------------------------------------------------+

Before You Begin
----------------

> Choosing Your Installation Media

The Eee PC does not have an optical drive installed on the machine. This
means you will need to install Arch Linux through one of the alternative
methods:

1.  USB stick (Recommended)
2.  External USB CD-ROM drive
3.  Network (PXE)

Asus Eee PC model 701 repository from toofishes
-----------------------------------------------

Toofishes created a repository for the 701. The repository contained
customized kernel built specifically for the 701 and some additional
packages.

While the stock Arch kernel works very well with the 701, toofishes
kernel have the following advantages:

-   Faster boot time – because most of the modules have been compile
    into the kernel, no time is wasted waiting for the modules to load
-   No need to generate initial ramdisk every time a kernel is upgrade
-   Small size (around 4MB)

To use the repository, add:

    [eee]
    Server = http://code.toofishes.net/packages/eee

to your /etc/pacman.conf and then issue:

    pacman -Syy

> Package List

Currently, toofishes' repository contains the following packages:

-   kernel-eee – customized kernel for Asus Eee PC model 701
-   luvcview – webcam program for testing webcam driver

> Kernel-eee Installation Instruction

Simply use pacman to install the package you need. Install the packages
with this command:

    # pacman -S kernel-eee

then, add the following to /etc/grub.d/40_custom, or to another file in
/etc/grub.d/ depending on the boot order you want.

    # (2) Arch Linux
    menuentry 'Arch Linux Eee kernel' {
      set root='(hd0,1)'; set legacy_hdbias='0'
      legacy_kernel   '/boot/vmlinuzeee' '/boot/vmlinuzeee' 'root=/dev/sda1' 'ro'
    }

Then run

     grub-mkconfig -o /boot/grub/grub.cfg

to regenerate your GRUB config file.

Restart and select Arch Linux Eee kernel from the grub boot menu.

Additional Tips & Tweaks
------------------------

> Tweaking kernel-eee

Toofishes' kernel, also known as kernel-eee, can be recompiled to
include custom features. You can download toofishes' kernel PKGBUILD and
all the nesseary files from his gitweb by installing the git package and
using the following command:

    $ git clone git://code.toofishes.net/dan/eee.git

or if you are behind a proxy and can't use the git protocol:

    $ git clone http://code.toofishes.net/git/dan/eee.git

There are two ways to tweak the kernel. The first is simply to edit the
kernelconfig file with your favorite editor and the second is to insert
a make menuconfig line into the PKGBUILD before the kernel's
compilation.

> Using Wine with toofishes' kernel

Note: Since kernel-eee 2.6.32eee, wine is working fine without the need
of customizing toofishes' kernel as explained below

Normally, Wine won't work with toofishes' kernel because it is compiled
with VMSPLIT_2G_OPT option. In order to use Wine with toofishes' kernel,
you have to recompile his kernel with VMSPLIT_3G option.

Download the kernel PKGBUILD and all the necessary files from toofishes'
gitweb using the above instructions, then change the following lines in
the kernelconfig file from this:

     ...
     230 CONFIG_NOHIGHMEM=y
     231 # CONFIG_HIGHMEM4G is not set
     232 # CONFIG_HIGHMEM64G is not set
     233 # CONFIG_VMSPLIT_3G is not set
     234 # CONFIG_VMSPLIT_3G_OPT is not set
     235 # CONFIG_VMSPLIT_2G is not set
     236 CONFIG_VMSPLIT_2G_OPT=y
     237 # CONFIG_VMSPLIT_1G is not set
     ...

to this:

     ...
     230 CONFIG_NOHIGHMEM=y
     231 # CONFIG_HIGHMEM4G is not set
     232 # CONFIG_HIGHMEM64G is not set
     233 CONFIG_VMSPLIT_3G=y
     234 # CONFIG_VMSPLIT_3G_OPT is not set
     235 # CONFIG_VMSPLIT_2G is not set
     236 # CONFIG_VMSPLIT_2G_OPT is not set
     237 # CONFIG_VMSPLIT_1G is not set
     ...

Compile and install the kernel and Wine should now work.

> Power down with the power button

Note: If you are using ighea's acpi-eee or dkite's acpid_eee package
then you should already be able to shutdown by pressing the power button
and should not need to do this.

The two alternatives here are described in Allow users to shutdown.

> Use cpufreq for power saving

CPU scaling with p4_clockmod has been dropped from Arch's kernel builds,
due to the fact, confirmed by users, that there were no effective power
savings with p4-clockmod's module, and it introduced "unacceptable
latency", even with relatively low percentage up thresholds.

> Update your BIOS without Xandros

Warning: You can break your system, do not update if you are not sure of
what you are doing!

First, you need to download the .rom file.

-   Asus' official BIOS
-   EeeUser's topic

You also need an USB stick formatted in FAT32. To format the USBStick,
use the cfdisk tool:

    # cfdisk /dev/sdc     # could be something else than "c"

Choose [delete], [type]: "fat32" (code 0B), [write] and then exit with
[quit].

NOTE to EEE PC 900 owners and possibly others: Using this method will
require a flash drive formatted with a FAT16 file-system. If the BIOS
update process hangs up at "Reading file 900.ROM" for more than a few
minutes then it should be safe to power down your EEE PC and reformat
your flashdrive's file-system to the correct one. You can force FAT16
creation with the following command:

    # mkdosfs -F 16 /dev/device-path

Now just copy the .rom on the USBStick :

    $ cp /somewhere/blabla/.../thecurrentnameofthefile.ROM /path/to/mounted/usb_stick/701.rom

The name of the copy must be xxxx.rom where xxxx is the model of your
eee PC. (i.e. 900 users it's 900.rom)

Next step, reboot the eeepc with the USB stick pluged-in, and press
Alt+F2. It will launch the built-in tool. Everything should be Ok, you
can make a coffee during the update. When it asks you to push the
power-button it has finished.

At the next boot, you'll be invited to configure the BIOS. Check if the
everything is enabled (my webcam and wireless were disabled after the
update) and if it displays the good version in the main screen. It's
done!

> More usable font sizes

The_glu's method

I found an easy solution that works on a 901:

Edit /etc/X11/xinit/xserverrc and add "-dpi 134":

    exec /usr/bin/X -nolisten tcp -dpi 134

Restart X and fonts should have the correct size. Notice it's won't
works if you have Xft*dpi: in your .XDefaults.

You do not need to edit your config file to set a smaller font size, I
you did you should set font-size to 10 or you will have to small
fonts...

Old method

On a default installation with Xfce 4 my font sizes were too big, here
is what I did to sort them out.

First, I set the DPI by adding the following to ~/.Xdefaults:

     Xft*dpi: 134

This then caused the fonts to be even bigger, so I set them all to be
font-size 6 by adding the following into ~/.gtkrc-2.0 (note that this
will be overwritten if you use any tools to change GTK settings):

     style "user-font"
     {
         font_name="Bitstream Vera Sans 6"
     }
     widget_class "*" style "user-font"

To do the same with KDE fonts (without KDE installed) you have to add
the following to ~/.kde/share/config/kdeglobals:

     [General]
      StandardFont=Bitstream Vera Sans,6,-1,5,50,0,0,0,0,0
      activeFont=Bitstream Vera Sans,6,-1,5,75,0,0,0,0,0
      fixed=Bitstream Vera Sans Mono,6,-1,5,50,0,0,0,0,0
      font=Bitstream Vera Sans,6,-1,5,50,0,0,0,0,0
      menuFont=Bitstream Vera Sans,6,-1,5,50,0,0,0,0,0
      taskbarFont=Bitstream Vera Sans,6,-1,5,50,1,0,0,0,0
      toolBarFont=Bitstream Vera Sans,6,-1,5,50,0,0,0,0,0

To make your fonts even prettier enable the LCD Fonts.

Alternative Method

For me it worked far better to open the gnome appearance control panel,
go to the fonts tab, click defaults, and change the resolution to be 96
dpi. Changing .Xdefaults doesnt work when running gnome, as
gnome-settings-daemon overrides it. You can then leave all font sizes at
their default, and things should look good. Simply changing the font
sizes and leaving the DPI at its technically correct value (~134) gave
me weird layout problems in some apps, and oddly large fonts in others.

Known problems and their solutions
----------------------------------

> Sound

For most people, sound should work right out of the box with no
troubles. However, others might need to add the following line to
/etc/modprobe.d/modprobe.conf

    options snd-hda-intel model=3stack-dig

or the following one for the Eee PC 900 model

    options snd-hda-intel model=auto

If your internal microphone doesn't work, you probably have to turn the
capture feature on. Simply fire up alsamixer, find your Capture control,
and press spacebar to enable it.

> Webcam

If for some reason webcam has been disabled on your 701, you can enable
it by issuing the following command as root:

    echo 1 > /sys/devices/platform/eeepc/camera

If you want the webcam application that the default Xandros installation
uses, install ucview from the AUR.

The webcam also works fine with the latest version of Skype.

If you already have mplayer installed you can launch:

    $ mplayer -fps 15 tv://

I have yet to get it working with vlc or any other software such as
xawtv. If you know how, please update this.

-   NOTE: For anyone who has accidentally disabled Auto Exposure for
    their webcam in luvcview (making the image dark), and can't enable
    it again, do the following:

Install libwebcam from the AUR.

Issue the following command:

    $ uvcdynctrl --set "Exposure, Auto" 4

Note: Be sure the "OS Installation" option is set to "finished" in the
BIOS' "Advanced" tab or your camera may not work in some applications
(like Skype).

Note: Make sure you are a member of the video group edit /etc/group and
add your username to video

> Microphone

Solution for problems with the internal microphone.

1. First of all set in alsamixer "Input Source" to "i-Mic"

2. Increase "Capture" and "i-Mic Boost" to your needs

3. Edit /etc/asound.state and change the 'Capture Switch' section,
change the 2 "false" to "true" like showing:

    ....snip.....
    control.11 {
                   comment.access 'read write'
                   comment.type BOOLEAN
                   comment.count 2
                   iface MIXER
                   name 'Capture Switch'
                   value.0 true
                   value.1 true
           }
    ....snip....

4. After editing run following as root

    # alsactl restore

5. Now your internal microphone should be working.

> Wireless doesn't work, even after installing custom Madwifi module

I found that Arch tried to use the ath5k module for wireless, and that
meant it took control of the card rather than ath_pci (the module I had
compiled and installed). I got a Madwifi status 3 message in dmesg when
this happened.

The solution is to blacklist the ath5k module.

> Unclean unmount during shutdown when having home directory mounted on SD card

If you experienced unclean unmount during shutdown when having your home
directory on SD card, then add the following 3 lines to "Write to wtmp
file before unmounting" section of your /etc/rc.shutdown file:

    ...

    stat_busy "Unmounting Filesystems"
    /bin/umount -a -t noramfs,notmpfs,nosysfs,noproc

    # Add these 3 lines
    sync;sync;sync;
    eject /dev/sdb  # Or whichever is your SD-card's device name. /dev/disk/by-uuid/ followed by the UUID identifier is preferable though.
    sleep 3
    # End of hack

    stat_done

    ...

> Booting from card without initrd

Let's say you decided to install Arch Linux on a card and compiled your
own kernel (or used the kernel26eee kernel) without initrd. Card reader
on EeePC is connected as an USB device. Unfortunately, USB storage
devices are detected with a delay, so we must tell the kernel to wait
until this device becomes available. You do this with "rootwait" option
passed to kernel at boot time.

> Sleeping and waking system on a card

If you have Arch Linux on a card, waking up from sleeping state will
most likely fail. The only solution is to enable the CONFIG_USB_PERSIST
option in kernel. The kernel26eee package should have this option
enabled.

The command to do this is:

    echo 1 >/sys/bus/usb/devices/.../power/persist

Replace the "..." with the device like 1-3 or 1-5 where the first number
is the bus and the second is the device

Each device that is connected to your computer gets an entry in the
sysfs "system file system" it is a virtual file system like proc

More info:

-   http://www.mjmwired.net/kernel/Documentation/usb/persist.txt
-   http://forum.eeeuser.com/viewtopic.php?id=22712

> Display doesn't wake up properly

If you encounter black display (but apparently working system) after
suspend/resume, consider using the "uswsusp" package (available in the
official repositories) and correcting suspend2ram script in /etc/acpi,
where you use this line to make the machine go to sleep:

    /usr/sbin/s2ram --force --vbe_post --vbe_mode

(Note on Eee PC 900 with uswsup-0.8-6: If your X goes blank or jerky
after resuming, disable vbe specific commands and parameters.)

> DMA problems

Some SSD have problem with read DMA event causing a long boot time.

    Feb 21 19:09:14 myhost kernel: ata2.01: failed command: READ DMA

You can bypass that by adding a kernel parameter in GRUB.

    libata.dma=0

Battery Tests
-------------

The following are reported battery runtimes:

Battery runtimes

Task

Series

Wireless

Screen Brightness

FSB Speed

Fan Speed

Runtime

Comments

DVD Playback

701

On

Max

85mhz

100%

134min

Reading DVD ISO from 16gig SDHC Card

DVD Playback

701

Off

Max

85mhz

100%

 ???

Reading DVD ISO from 16gig SDHC Card

AVI Playback

701

Off

Max

85mhz

100%

 ???

Reading AVI from SSD

IM and Surf

701

On

~30%

 ???

low

173min

Normal web-browsing, Flash should reduce runtime a lot !

Programming and PDF reading

1000HA

Off

~40%

 ???

low

+6hs

Using Evince and SPE under XFCE with camera and USB disabled

Surf and OOo

1000HA

On

~40%

 ???

low

+4hs

Stock kernel without laptop-mode

Surf and OOo

1000HA

On

~40%

 ???

low

5hs

Stock kernel with laptop-mode and other tweaks

N.B. - Will add battery runtimes as I am able to test them, please
contribute.

-- Grecko.1

Still tweaking, but disabling everything from BIOS got me about 6 hours
and a half. With eee-kernel, I *could* get a little more.

-- ekuber

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_701&oldid=248171"

Category:

-   ASUS
