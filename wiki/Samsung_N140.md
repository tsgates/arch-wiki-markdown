Samsung N140
============

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This article provides information about installing and setting up Arch
Linux on the Samsung N140. It is also relevant for the Samsung N130
which is identical except for the omission of Bluetooth and stereo
speakers (and possibly a different battery capacity). There are versions
of the N130 which include a 3G cellular modem, available from Vodafone
and China Mobile. The Samsung NC10 is similar but not identical to the
N140, so you may or may not find useful information on that page.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Issues                                                             |
|     -   1.1 BIOS Issues                                                  |
|         -   1.1.1 No backlight setting via ACPI                          |
|         -   1.1.2 No key releases for some Fn keys                       |
|                                                                          |
| -   2 Installation                                                       |
|     -   2.1 Custom kernel: without initrd (AUR)                          |
|                                                                          |
| -   3 Configure your installation                                        |
|     -   3.1 Ethernet                                                     |
|     -   3.2 Wifi                                                         |
|         -   3.2.1 Atheros AR9285                                         |
|         -   3.2.2 Realtek RTL8192E                                       |
|             -   3.2.2.1 Open source driver                               |
|             -   3.2.2.2 Ndiswrapper                                      |
|                                                                          |
|     -   3.3 Cellular 3G Modem                                            |
|     -   3.4 Graphics Adapter                                             |
|         -   3.4.1 Kernel Mode Setting                                    |
|             -   3.4.1.1 Method A                                         |
|             -   3.4.1.2 Method B                                         |
|             -   3.4.1.3 KMS with KDE                                     |
|                                                                          |
|         -   3.4.2 Backlight Brightness                                   |
|         -   3.4.3 External VGA                                           |
|                                                                          |
|     -   3.5 Audio                                                        |
|     -   3.6 Suspend and Hibernate                                        |
|     -   3.7 Fn Keys                                                      |
|         -   3.7.1 Binding Fn keys with xbindkeys                         |
|         -   3.7.2 Binding Fn keys in Openbox                             |
|                                                                          |
|     -   3.8 Saving Power                                                 |
+--------------------------------------------------------------------------+

Issues
======

BIOS Issues
-----------

> No backlight setting via ACPI

A workaround is to use "setpci" as shown below.

Alternatively there is a kernel patch (unrelated to the SATA freeze
problem) available which changes the backlight brightness using SMI
instead of poking PCI config space. It provides a kernel module called
"samsung-laptop". Interestingly we see from a version of this patch
which is included in OpenSUSE 11.1 that a special (as yet unreleased?)
BIOS for the N130 can be informed that the OS is Linux. The effect of
this hasn't been published. Suggestion: run the samsung-laptop module
with its debug parameter set to 1 to check whether it does anything at
all.

> No key releases for some Fn keys

Some of the Fn keys give key press events but no key releases. This
problem was also seen on the NC10 and NC20. A workaround is given below.
For kernels 2.6.32 and later this can be done from userspace.

Installation
============

Do the standard Arch installation procedure from the ARCH CD ISO using
an external USB CDROM drive. Alternatively boot the Arch installer from
a USB flash drive.

The standard Arch kernel is recommended (2.6.34 or later).

A number of users have used a custom kernel for the following reasons:

-   to boot with a minimal kernel containing just the required modules
    and without an initial ramdisk.

Custom kernel: without initrd (AUR)
-----------------------------------

An AUR package linux-n130 is available. In this kernel most drivers are
compiled in and there is no initial ramdisk. The drivers for cpu
frequency scaling (acpi-cpufreq), wifi (ath9k, rtl8192e) and webcam
(uvcvideo) are compiled as modules (i.e. not compiled in) so they can be
inserted or removed from the kernel to enable or disable those features.
MODULES in /etc/rc.conf can be used to enable or disable loading at
boot.

Prepare the directory

    $ mkdir ~/builds
    $ mkdir ~/builds/linux-n130
    $ cd ~/builds/linux-n130

Get the AUR package and untar it

    $ wget https://aur.archlinux.org/packages/li/linux-n130/linux-n130.tar.gz
    $ tar zxvf linux-n130.tar.gz
    $ cd linux-n130

At this point you can edit the PKGBUILD file if you need to (i) change
the name or version number, (ii) change options or (iii) add additional
patches.

Check the PKGBUILD. Don't experiment with the CK patchset at this point:

    _USE_CK_PATCHSET=0

Compile it (this will take some time...):

    $ makepkg -s

Install the kernel from the new .pkg.tar.gz file

    $ sudo pacman -U linux-n130-2.6.<xx.yy>-<rr>.pkg.tar.gz

Then, assuming you are using GRUB, insert a new item in your
/boot/grub/menu.lst to boot the new kernel "linux-N130". Note that no
initrd line is necessary for this kernel.

    # (0) Arch Linux N130
    title  Arch Linux Custom N130 Kernel
    root   (hd0,YOURROOT-1)
    kernel /boot/vmlinuz-N130 root=/dev/sdaYOURROOT resume=/dev/sdaYOURSWAP ro quiet

And reboot. If you have problems the standard Arch kernel is still
installed and selectable from the GRUB menu.

For GRUB2 /boot/grub/grub.cfg the syntax looks like this (sda1 = your
root partition; sda2 = your swap partition)

    menuentry "Arch Linux N130" {
            set root=(hd0,1)
            linux /boot/vmlinuz-N130 root=/dev/sda1 resume=/dev/sda2 ro quiet 
    }

Note:The linux-n130 has the i915 module compiled in with KMS enabled by
default. There is no need to set up KMS as described below unless you
wish to disable it.

Configure your installation
===========================

Ethernet
--------

RTL8101e/8102e fast ethernet. Works out of the box.

Wifi
----

The supplied wifi device is either an Atheros AR9285 (PCI ID =
168c:002b) (European markets) or a Realtek RTL8192E (US and UK markets).

> Atheros AR9285

    02:00.0 Network controller [0280]: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) [168c:002b] (rev 01)

The kernel module for this device is "ath9k" (AR9285 is supported since
2.6.29).

Kernels 2.6.30 and 2.6.32-rcN release candidates seem to work fine.
However with kernel 2.6.31 the wireless connection exhibits frequent
disconnects and reattachments, resulting in periods of bad througput and
periods of good throughput. There is no sign of any patches for 2.6.31.y
to fix this regression. Complain to linux-wireless@vger.kernel.org. To
get it working either downgrade to 2.6.30 or preferably upgrade to
2.6.32.

The following patch was included in 2.6.32 just before the final
release:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=54ab040d24904d1fa2c0a6a27936b7c56a4efb24
. It disables PS (power saving) mode by default, since this mode was
found to have problems. See here
http://bugzilla.kernel.org/show_bug.cgi?id=14267 . PS mode can also be
disabled with the following command, which can be placed in
/etc/rc.local:

    iwconfig wlan0 power off

> Realtek RTL8192E

Open source driver

The native Linux driver for this wireless device is still in
preparation, but it is available as a kernel module "rtl8192e" in
"staging" -- i.e. in preparation for inclusion in the kernel and
available to try out, but likely to still have some problems. It has
been reported as working [1]. Firmware is required. See
http://lkml.org/lkml/2009/12/15/410.

The firmware is available in the linux-firmware package:

    # pacman -S linux-firmware 

Then

    $ md5sum /lib/firmware/RTL8192E/*

should return

    bb9f64de23939ec247d15dfbeb0ed91e  /lib/firmware/RTL8192E/boot.img
    db83def0338769de1d4658a00b6f738d  /lib/firmware/RTL8192E/data.img
    0034020e5a32571f486849aa90a389a7  /lib/firmware/RTL8192E/main.img

On rebooting, the kernel messages (visible with "dmesg") should now
indicate that rtl819xE finds the firmware for loading into the device.

Note: wicd may cause excessive dropped connections with this driver,
while NetworkManager appears to work better.

Ndiswrapper

It has been reported as working with ndiswrapper which makes use of the
closed source Windows driver under Linux.

Cellular 3G Modem
-----------------

Specifications required

Graphics Adapter
----------------

The video controller is an Intel chipset that works with the
xf86-video-intel driver.

    00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 945GME Express Integrated Graphics Controller [8086:27ae] (rev 03)
    00:02.1 Display controller [0380]: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller [8086:27a6] (rev 03)

> Kernel Mode Setting

See also Intel#KMS_.28Kernel_Mode_Setting.29.

KMS works providing real consoles at the native LCD resolution,
1024x600. There is a known problem with 2.6.32 kernels (later release
candidates up to at least release 2.6.32.8), which results in screen
flickering and blackouts about 5 minutes after resuming from
suspend-to-RAM or suspend-to-disk.

Note:If you encounter screen flickering or blackouts with KMS enabled,
try setting i915.powersave=0 as a kernel boot option.

Note:Since version 2.10.0 of xf86-video-intel, support for UMS has been
removed from the intel driver. This means that KMS is a requirement now.

Method A

If you are using a kernel with no inital ramdisk and you can simply add
the required options to the GRUB kernel line:h

    # (0) Arch Linux N130
    title  Arch Linux Custom N130 Kernel
    root   (hd0,YOURROOT-1)
    kernel /boot/vmlinuz26-N130 root=/dev/sdaYOURROOT resume=/dev/sdaYOURSWAP ro quiet i915.powersave=0 i915.modeset=1

Method B

If you are using an initial ramdisk (either the standard kernel or the
custom kernel method B above) then do the following:

Edit /etc/modprobe.d/modprobe.conf:

           options i915 powersave=0 
           options i915 modeset=1

Edit /etc/mkinitcpio.conf:

           MODULES="intel_agp i915"
           FILES="/etc/modprobe.d/modprobe.conf"

Put keymap early in /etc/mkinitcpio.conf HOOKS. Regenerate the init
ramdisk for the kernel(s) you are running:

           $ mkinitcpio -p linux
           or 
           $ mkinitcpio -p linux-n140

Remove any vga= or video= from grub /boot/grub/menu.lst kernel line, and
reboot.

KMS with KDE

With earlier versions of KDE, on logout it returned to the F1 real
console instead of to KDM. Uncommenting this entry in
/usr/share/config/kdm/kdmrc solved the problem:

     TerminateServer=true

This setting is now the default.

> Backlight Brightness

xbacklight does not work currently. However the brightness can be set
with the following command

    setpci -s 00:02.1 F4.B=hh

where hh is the level of brightness, in the range 00 to FF. Don't set it
to zero because your backlight will turn off!

Note this does not require the samsung-laptop patch mentioned above.

Use the following script to increase and decrease the brightness. Put it
in /sbin/backlight for example. Use xbindkeys to bind commands to the
backlight Fn keys. Obtain sudo permission for user to use those commands
with visudo.

     #!/bin/bash
     # increase/decrease/set/get the backlight brightness (range 0-255) by 16
     #
     #get current brightness in hex and convert to decimal
     var1=`setpci -s 00:02.1 F4.B`
     var1d=$((0x$var1))
     case "$1" in
           up)
                   #calculate new brightness
                   var2=`echo "ibase=10; obase=16; a=($var1d+16);if (a<255) print a else print 255" | bc`
                   echo "$0: increasing brightness from 0x$var1 to 0x$var2"
                   setpci -s 00:02.1 F4.B=$var2
                   ;;
           down)
                   #calculate new brightness
                   var2=`echo "ibase=10; obase=16; a=($var1d-16);if (a>15) print a else print 15" | bc`
                   echo "$0: decreasing brightness from 0x$var1 to 0x$var2"
                   setpci -s 00:02.1 F4.B=$var2
                   ;;
           set)
                   #n.b. this does allow "set 0" i.e. backlight off
                   echo "$0: setting brightness to 0x$2"
                   setpci -s 00:02.1 F4.B=$2
                   ;;
           get)
                   echo "$0: current brightness is 0x$var1"
                   ;;
           toggle)
                   if [ $var1d -eq 0 ] ; then
                           echo "toggling up"
                           setpci -s 00:02.1 F4.B=FF
                   else
                           echo "toggling down"
                           setpci -s 00:02.1 F4.B=0
                   fi
                   ;;
           *)
                   echo "usage: $0 {up|down|set <val>|get|toggle}"
                   ;;
     esac
     exit 0

> External VGA

External VGA works out of the box with xrandr / krandrtray. Tested at
1920x1080 resolution.

Audio
-----

The audio device is an Intel HD.

    00:1b.0 Audio device [0403]: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller [8086:27d8] (rev 02)

Suspend and Hibernate
---------------------

Suspend to RAM with pm-suspend works.

It is most useful to trigger suspends using acpid.

To catch the "sleep" function key, edit /etc/acpi/handler.sh so that the
button/sleep) event calls /usr/sbin/pm-suspend (instead of "echo mem >
/sys/power/state" which may leave wifi down after resume):

         button/sleep)
            case "$2" in
                SLPB)   logger "Sleep button pressed, suspending to RAM"
                        /usr/sbin/pm-suspend
                        ;;
                *)      logger "ACPI action undefined: $2"
                        ;;
            esac
            ;;

When catching the lid closure, the button/lid event will be seen twice
-- once on suspend and again on resume. So use the lid state to
distinguish between these so that pm-suspend is not triggered twice:

Enter the following lines in /etc/acpi/handler.sh:

        button/lid)
           if [ `/bin/awk '{print $2}' /proc/acpi/button/lid/LID0/state` = closed ]; then
               /usr/sbin/pm-suspend
           fi
           ;;

Hibernate works correctly (see pm-utils article).

If you are a KDE4 user you can take advantage of powerdevil (included in
kdemod-core/kdemod-kdebase-workspace since release 4.2) to manipulate
the screen brightness, cpu scaling and hibernate. Suspend from KDE works
too, but if you are using handler.sh to suspend on the button/lid and
button/sleep acpi events, then KDE only needs to lock the screen. Note
that cpu scaling requires acpi-cpufreq module to be loaded in MODULES in
/etc/rc.conf.

Fn Keys
-------

Firstly edit
/usr/share/hal/fdi/information/10freedesktop/30-keymap-misc.fdi and
insert N140 into the list where you see NC10 already.

Now in a real console

     showkey

will show presses for the function keys, but no releases for some of
them.

This is a BIOS issue which was also found on the Samsung NC10. A
workaround quirk was put in the kernel in atkbd.c for the NC10. Patching
this routine to apply the same quirk also works for the N140, and is
recommended for 2.6.31 and earlier. However for 2.6.32 and later (i.e.
any current Arch installation) there is a much simpler solution because
this quirk can now be applied from user space. Simply edit /etc/rc.local
and add the following line:

     echo 130,131,132,134,136,137,179,247,249 > /sys/devices/platform/i8042/serio0/force_release

After this is run, doing "showkey" in a real console will show key
presses and releases.

> Binding Fn keys with xbindkeys

The following has been tested with KDE, but should also work for other
DEs.

To bind the Fn keys to action, read Extra_Keyboard_Keys#The_quick_way
and also Extra Keyboard Keys in Xorg.

The suspend key (Fn+ESC) and disable touchpad (Fn+F10) keys, numlock,
scroll lock, volume controls and mute work out of the box.

Note, that suspend key is handled in /etc/acpi/handler.sh (see
"button/sleep" case entry) as shown above.

1) install xbindkeys

     pacman -S xbindkeys

2) check the key values with

     xbindkeys -mk

3) edit .xbindkeysrc

     "sudo /sbin/backlight up"
         m:0x0 + c:233
     "sudo /sbin/backlight down"
         m:0x0 + c:232
     "/home/user/bin/systeminfo_battery"
         m:0x0 + c:244
     "sudo /sbin/backlight toggle"
         m:0x0 + c:156
     "/home/user/bin/systeminfo_disk"
         m:0x0 + c:157
     "/home/user/bin/systeminfo_cpu"
         m:0x0 + c:210
     "/home/user/bin/systeminfo_wifi"
         m:0x0 + c:246

4) run xbindkeys, and try it out

    xbindkeys

For KDE4 put a link to /usr/bin/xbindkeys in ~/.kde4/Autostart

     ln -s /usr/bin/xbindkeys ~/.kde4/Autostart/xbindkeys.link

The Fn+F3 ("Euro") key: here Samsung implemented what has been called an
entertaingly hilarious hack:
http://lists.freedesktop.org/archives/hal/2009-August/013536.html ROFL!
Does anyone know a practical use for this key? Fortunately some
(eurozone) models have a real Euro key as well.

> Binding Fn keys in Openbox

In Openbox one can use the internal keybind setup instead of xbindkeys.
Here is an excerpt from rc.xml:

        <keybind key="XF86Battery">
          <action name="Execute">
            <command>~/.PersonalBin/batteryDisplay</command>
          </action>
        </keybind>
        <keybind key="XF86Display">
          <action name="Execute">
            <command>~/.PersonalBin/monitor</command>
          </action>
        </keybind>
        <keybind key="XF86Launch1">
          <action name="Execute">
            <command>~/.PersonalBin/brightnessToggle</command>
          </action>
        </keybind>
        <keybind key="XF86Launch2">
          <action name="Execute">
            <command>nice python ~/.config/openbox/scripts/checkmail.py --update</command>
          </action>
        </keybind>
        <keybind key="XF86Launch3">
          <action name="Execute">
            <command>~/.PersonalBin/powersaveToggle</command>
          </action>
        </keybind>
        </keybind>
        <keybind key="XF86AudioMute">
          <action name="Execute">
            <command>~/.PersonalBin/volume mute</command>
          </action>
        </keybind>
        <keybind key="XF86WLAN">
          <action name="Execute">
            <command>~/.PersonalBin/wlanToggle</command>
          </action>
        </keybind>
        <keybind key="XF86AudioLowerVolume">
          <action name="Execute">
            <command>~/.PersonalBin/volume -</command>
          </action>
        </keybind>
        <keybind key="XF86AudioRaiseVolume">
          <action name="Execute">
            <command>~/.PersonalBin/volume +</command>
          </action>
        </keybind>
        <keybind key="XF86MonBrightnessDown">
          <action name="PreviousWindow">
            <bar>no</bar>
            <allDesktops>yes</allDesktops>
            <finalactions>
              <action name="Focus"/>
              <action name="Raise"/>
            </finalactions>
          </action>
        </keybind>
        <keybind key="XF86MonBrightnessUp">
          <action name="NextWindow">
            <bar>no</bar>
            <allDesktops>yes</allDesktops>
            <finalactions>
              <action name="Focus"/>
              <action name="Raise"/>
            </finalactions>
          </action>
        </keybind>

Saving Power
------------

Read Laptop#Power_Management

Read Lightweight Applications

Note:Caution is advised here with hdparm settings because the issue with
SATA freezing is related to power management and spindowns. Before you
tune the Samsung N130/N140 to minimize power consumption it is strongly
recommended that you resolve the SATA freezing issue as discussed above.

The Samsung N130/N140 contains a 1.6 GHz Intel Atom ULV (ultra low
voltage) N270 processor, designed for low power consumption. The power
consumption of the netbook (not just the processor) can be as low as 6W
on idle with HDD spun down, although a typical figure under normal usage
would be considerably higher.

Obviously the battery life depends on battery capacity as well as power
consumption. The supplied battery varies in different markets. This list
is a guideline only. Do not rely on this information before purchase --
check with YOUR vendor and update this wiki if it is incorrect:

    Voltage 11.1V

    N130             = 4000mAh [44Wh] (most markets), 5200mAh [57Wh] (Sweden)
    N130 (Vodafone)  = ? [?] (Spain)
    N130 (CMCC)      = ? [?] (China)
    N140             = 5200mAh [57Wh] (US, Germany, France, Sweden), 5900mAh [65Wh] (UK)
    Extended battery = 7800mAh [86Wh]

Install powertop which is a very useful tool for measuring and tuning
power consumption, and htop which is useful for checking the CPU and
memory usage of running processes

    # pacman -S powertop htop

Enable CPU frequency scaling (P-states) by loading the driver module
"acpi-cpufreq". This is most conveniently done in /etc/rc.conf:

    MODULES=(acpi-cpufreq ... )

Select the CPU frequency governor by adding the following lines to
/etc/rc.local:

    # Set the CPU frequency scaling governor for each core
    echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor

Note:Contrary to the advice in many places "hdparm -B 255 /dev/sda" does
NOT necessarily turn off advanced power management. What happens depends
on the disk model. With the Samsung HM160HI disk 255 results in very
frequent spindowns

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samsung_N140&oldid=254491"

Category:

-   Samsung
