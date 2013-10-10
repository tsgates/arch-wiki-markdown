MacBook Pro 8,1 / 8,2 / 8,3 (2011 Macbook Pro)
==============================================

> Summary

Details the installation and configuration of Arch Linux on Apple's
MacBook Pro 8,1/8,2/8,3

> Related

MacBook

MacBookPro

MacBook_Pro_7,1

> MacBook_Pro_8,1_/_8,2_/_8,3_(2011_Macbook_Pro)

MacBook_Pro_9,2_(Mid-2012)

discuss at https://bbs.archlinux.org/viewtopic.php?pid=1021706

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 EFI Boot                                                     |
|         -   1.1.1 Using rEFInd and Kernel EFISTUB                        |
|                                                                          |
|     -   1.2 BIOS Boot                                                    |
|                                                                          |
| -   2 Network                                                            |
|     -   2.1 Wireless:                                                    |
|                                                                          |
| -   3 Keyboard & TouchPad                                                |
| -   4 Video & Screen                                                     |
| -   5 Sound                                                              |
| -   6 Suspend & Hibernate                                                |
| -   7 HFS+                                                               |
| -   8 Bluetooth                                                          |
|     -   8.1 Alternative solution                                         |
|                                                                          |
| -   9 Webcam                                                             |
|     -   9.1 With linux-mainline                                          |
|                                                                          |
| -   10 Others that works-out-of-the-box                                  |
| -   11 Troubleshooting                                                   |
+--------------------------------------------------------------------------+

Installation
------------

Use the latest Arch Installation Image from here:
https://www.archlinux.org/download/

> EFI Boot

Consult UEFI

Warning:efibootmgr may brick your Mac firmware.

radeon driver which only loads properly on Macs in BIOS emulation mode,
problem description and possible solution here.

> 8,1

Tested on macbook pro 8.1 . Forum thread: [1]

Add following to Kernel Parameters.

     i915.i915_enable_rc6=1 i915.i915_enable_fbc=1 i915.lvds_downclock=1 usbcore.autosuspend=1 h

8,2 and 8,3

While using EFI Boot, you will find

     radeon 0000:01:00.0: >Invalid ROM contents
     i915 0000:00:02.0: Invalid ROM contents

Which means you need disable KMS for amd and intel card. Add following
to Kernel Parameters.

     i915.modeset=0 radeon.modeset=0

newer versions of the Xorg Intel/i915 driver require KMS to work;
without it the X server will fallback to framebuffer mode, with poor
performance. The underlying issue is that the Intel KMS driver selects
the wrong video output; to fix this try the following settings (tested
on an 8,3/17" MBP):

     radeon.modeset=0 i915.modeset=1 i915.lvds_channel_mode=2

This should give you Intel graphics output. Note that this requires
kernel 3.5rc1 or higher; use linux-mainline from Aur if necessary. See
this bug for more details.

If you don't have KMS for intel driver, you need install
'xf86-video-fbdev'

     # pacman -S  xf86-video-intel and xf86-video-fbdev

If Xorg refuses to start with a "no screens found" message you may have
to tell Grub2 to turn off the Radeon card and turn on the Intel card
during boot. Edit /etc/grub.d/00_header and add the "outb" lines
immediately after "set gfxmode=" (Tested on an 8,2 MBP):

     ...
     set gfxmode=${GRUB_GFXMODE}
     outb 0x728 1
     outb 0x710 2
     outb 0x740 2
     outb 0x750 0
     load video
     ...

Then regenerate your grub.cfg:

     # grub-mkconfig -o /boot/grub/grub.cfg

Using rEFInd and Kernel EFISTUB

Install rEFInd

Consult Installing rEFInd

Boot into Mac OS X

     # mkdir -p /efi/refind
     # cp -r refind/* /efi/refind/
     # rm /efi/refind/refind_ia32.efi
     # mv /efi/refind/refind.conf-sample /efi/refind/refind.conf and adjust it
     # bless --setBoot --folder /efi/refind --file /efi/refind/refind_x64.efi

Setting up EFISTUB

Follow UEFI Bootloaders#Linux Kernel EFISTUB

Add Kernel MODULES

Without this, you will get 'root fs not found' error.

Edit /etc/mkinitcpio.conf

     MODULES="..ahci libahci.."

Then re-generate the boot img:

     # mkinitcpio -p linux

> BIOS Boot

Boot into BIOS emulation mode. AMD card works, but intel card doesn't.

Use refind to load grub-legacy.

Network
-------

> Wireless:

Note:need Kernel 3.3 or later

Install b43-firmware package from the AUR.

Unload b43 and bcma modules and load b43 module

    # rmmod b43 bcma
    # modprobe b43

That's it. The wireless should work now.

Ethernet: works out-of-the-box

Bluetooth: Unkown

Keyboard & TouchPad
-------------------

Keyboard:

default F1 key represents XF86MonBrightnessDown, if you want it
represents to F1.

     echo 2 > /sys/module/hid_apple/parameters/fnmode
     # value 1: F1 is XF86MonBrightnessDown
     # value 2: F1 is F1, Fn + F1 is XF86MonBrightnessDown.

and put that into /etc/rc.local

Touchpad:

Two finger scrolling and left-click works out of the box. Unfortunately
the right-click is not functional.

14/09/2012 : right click (2 fingers) and middle click (3 fingers) works
out of the box with KDE.

To enable most of the multitouch touchpad features (even right and
middle clik) use mtrack, which is avaible in AUR. The configuration is
done via the /etc/X11/xorg.conf.d/10-mtrack.conf file. Check if the
mtrack module is properly loaded in the /var/log/Xorg.0.log file.
Sometimes xorg loads other drivers before, like eg. synpatics, and the
mtrack driver is not used at all.

For an MBP 8,3 I needed to use the following config (in
/etc/X11/xorg.conf.d/10-mtrack.conf) to stop it picking up other input
devices by mistake:

    Section "InputClass"
      Identifier "Multitouch Touchpad"
      Driver "mtrack"
      MatchDevicePath "/dev/input/event*"
      MatchProduct "bcm5974"
      MatchIsTouchpad "true"
    EndSection

Video & Screen
--------------

13-inch

Intel HD Graphics 3000: works with xf86-video-intel

Adjust Brightness: works with xorg-xbacklight For example:

    xbacklight -inc 7 # increase brightness
    xbacklight -dec 7 # decrease brightness

or you can use a simple bash script that provides screen and keyboard
backlight management by simple cli (-d for display / -k for keyboard)

    #!/bin/bash
    case $1 in
           -d|--display)
               if [ "$2" != "0" ]
                   then
                       echo "$[(($2 * 4882) / 100) % 4883]" > /sys/class/backlight/intel_backlight/brightness
               fi;;
           -k|--keyboard)
               echo "$[(($2 * 255) / 100) % 256]" > /sys/class/leds/smc\:\:kbd_backlight/brightness;;
           -h|--help)
               echo -e "MacBook 8.1 brightness helper\n\t-d\tset display brightness (0-100%)\n\t-k\tset keyboard brightness (0-100%)\n";;
           *)
               echo -e "Unknown option try -h or --help";;
    esac

save it in

    /usr/bin/macbackl

mark executable

    # chown +x /usr/bin/macbackl

  
 for usage, run

    # macbackl --help

    NOTE: you must be root to edit the files in /sys/class/* but if you want you can chown "/sys/class/leds/smc\:\:kbd_backlight/brightness" and "/sys/class/backlight/intel_backlight/brightness"

15-inch and 17-inch

AMD Radeon HD 6490M: Unknown

AMD Radeon HD 6750M and 6770M: works with xf86-video-ati

Adjust Brightness: install AUR package apple-bl-gmux and reboot system.

     $ echo 34839 | sudo tee /sys/class/backlight/gmux_backlight/brightness

Sound
-----

8,1 and 8,2

     $ alsamixer # unmute 'Front Speaker' and 'Surround Speaker'

> 8,3

Using PulseAudio sound works out of the box. However some applications
(e.g. Vlc) have intermittent crackling; appending 'tsched=0' to
'module-udev-detect' in /etc/pulse/default.pa fixes this.

Suspend & Hibernate
-------------------

Consulte Suspend and Hibernate.

> 8,1

For s2ram install uswsusp-git and add to file /etc/pm/config.d/module
following content:

     SUSPEND_MODULES="bcma b43" 
     SLEEP_MODULE=uswsusp

Without this, system hangs after the machine wakes up and tries to
reconnect to the wireless network.

> 8,2

BIOS Boot: using linux >= 3.6.2, supend and resume works out-of-the-box.

EFI Boot: resume may not work.

> 8,3

Supend and resume work out of the box, including wireless reconnection.

HFS+
----

HFS is mounted as Read-Only. By turning journaling off in OS X, the HFS+
file system will be read/write under Linux.

Bluetooth
---------

I had problems pairing devices, nothing was detected with

    hcitool scan

There seems to be a conflict between the bluetooth module and the b43
one (wifi), as written in this blog post. The solution is to do the
following:

    # rmmod b43

pair your bluetooth device

    # modprobe b43

> Alternative solution

Create /etc/modprobe.d/b43.conf with the following content:

    options b43 btcoex=0

Webcam
------

In order to use your webcam you need to have permission to use
/dev/video0.

    # gpasswd -a <username> video

Test to see if it works

    $ mplayer tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0 -fps 15 -vf screenshot

> With linux-mainline

As noted elsewhere in this document, some MBP features work best (or
only) with the latest kernel; the usual way to install this is using the
linux-mainline AUR package. However, as of 3.6.rc3 the config for
linux-mainline disables webcam support (due to changed defaults in
kernel). This patch to the x86_64 config fixes this issue.

Others that works-out-of-the-box
--------------------------------

-   Sensors

Troubleshooting
---------------

Grub2-EFI boot: Intel invalid ROM contents

If you see this error on boot and notice the screen output seemingly
frozen, you need to disable KMS.

Append the following to your /etc/grub/defaults LINUX line:

    i915.modeset=0 radeon.modeset=0

However, newer versions of the Xorg Intel/i915 driver require KMS to
work; without it the X server will fallback to framebuffer mode, with
poor performance. The underlying issue is that the Intel KMS driver
selects the wrong video output; to fix this try the following settings
(tested on an 8,3/17" MBP):

    radeon.modeset=0 i915.modeset=1 i915.lvds_channel_mode=2

This should give you Intel graphics output. Note that this requires
kernel 3.5rc1 or higher; use linux-mainline from Aur if necessary. See
this bug for more details.

You may find you need to enable the Intel device; if using Grub, the
following should enable it at boot time:

    set gfxpayload=keep
    # Switch gmux to IGD
    outb 0x728 1
    outb 0x710 2
    outb 0x740 2

Alternatively, if you have OS X available you can use gfxCardStatus to
switch to the Intel device before booting into Linux.

Grub2-EFI boot: root fs not found

On boot, grub2-efi may complain that no root fs is found. This is due to
the ahci modules being improperly loaded.

chroot into the installed Arch system. Then edit the
/etc/mkinitcpio.conf MODULES array:

    MODULES="..ahci libahci.."

Then re-generate the boot img:

    mkinitcpio -p linux

Retrieved from
"https://wiki.archlinux.org/index.php?title=MacBook_Pro_8,1_/_8,2_/_8,3_(2011_Macbook_Pro)&oldid=253716"

Category:

-   Apple
