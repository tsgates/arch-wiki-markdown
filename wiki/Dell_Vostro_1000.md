Dell Vostro 1000
================

-   Use Kernel 2.6.24 or greater
-   Use install disc 2008.03 or greater (see install)

Questions: IM diogo.urb@hotmail.com (MSN) .

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 Problems                                                           |
|     -   2.1 "Unknown Key Pressed"                                        |
|     -   2.2 Legacy Kernels                                               |
|     -   2.3 High Temperature                                             |
|                                                                          |
| -   3 Installation                                                       |
| -   4 Xorg                                                               |
|     -   4.1 Xorg 7.4                                                     |
|         -   4.1.1 Sample xorg.conf                                       |
|         -   4.1.2 Touchpad                                               |
|         -   4.1.3 Function Keys                                          |
|                                                                          |
| -   5 Wireless                                                           |
|     -   5.1 b43                                                          |
|     -   5.2 wl                                                           |
|     -   5.3 Ndiswrapper                                                  |
|     -   5.4 Wicd                                                         |
|                                                                          |
| -   6 Suspend/Hibernate                                                  |
|     -   6.1 Resume not working after suspend to RAM                      |
|     -   6.2 Backlight doesn't come back after Resume                     |
|                                                                          |
| -   7 Adjust Brightness                                                  |
+--------------------------------------------------------------------------+

Hardware
========

  ------------------- ---------- --------------------------
  Device              Status     Modules
  Ati Radeon Xpress   Working    fglrx (cataylst), radeon
  Ethernet            Working    b44
  Wireless            Working    wl, b43, ndiswrapper
  Audio               Working    snd_hda_intel
  Modem               Untested   
  PCMCIA Slot         Untested   
  Card Reader         Working    
  ------------------- ---------- --------------------------

Problems
========

"Unknown Key Pressed"
---------------------

-   You may occasionally run across an error (occurring in an extremely
    high frequency) in your messages.log/dmesg:

     atkbd.c: Unknown key pressed (translated set 2, code 0xee on isa0060/serio0).
     atkbd.c: Use 'setkeycodes e06e <keycode>' to make it known.

-   The fix for this issue is fairly simple. Power down your dell
    laptop, and reseat the battery.
-   Another possible cause may be due to your AC adapter being unplugged
    from the outlet, yet attached to the back of your laptop.
-   Yet another suggested fix for the problem is updating your BIOS..
    but since this is an extreme measure (found on the ubuntu forums..
    so take it with a grain of salt), try the first two solutions before
    moving on to this potentially dangerous measure.

  

Legacy Kernels
--------------

-   You must pass nolapic_timer as a boot option if you're using kernel
    2.6.26 (not needed for 2.6.27)

  

High Temperature
----------------

After the installation you will see that the temperature is around 60°C
(Too High). You can get the temperature through:

    cat /proc/acpi/thermal_zone/THRM/temperature

or

    cat /proc/acpi/thermal_zone/THM/temperature

  
 This is because the CPU frequency is at full usage always... so before
continuing with the install process install cpufrequtils, you can see
further details on Cpufrequtils

-   Note: using lm_sensors 'sensors' utility, k8temp-pci-00c3 reports
    much more reasonable temperatures (more along the lines of what
    windows reports) compared to this Virtual Thermal Zone. I have
    noticed no issues running without cpu scaling while on AC.

Installation
============

1.  Use installation disc 2008.03 or greater
2.  Follow the Beginners_Guide

Xorg
====

Xorg 7.4
--------

1.  Install xorg

        pacman -S xorg

2.  Install catalyst drivers

        pacman -S catalyst catalyst-utils

3.  Install Synaptic Mouse Driver

        pacman -S xf86-input-synaptics

4.  Copy and the paste the xorg configuration below and save it
    /etc/X11/xorg.conf  
    As of right now, Xorg 7.4 crashes when trying to auto generate (X
    -configure) a configuration file.
5.  Copy /usr/share/hal/fdi/policy/10osvendor/10-input-policy.fdi to
    /etc/hal/fdi/policy/  
    No Modifications should have to be made
6.  Follow the step below for the synaptic driver

> Sample xorg.conf

    Section "InputDevice"
     Identifier	"Keyboard"
     Driver	"kbd"
     Option	"CoreKeyboard"
     Option	"XkbRules"	"xorg"
     Option	"XkbModel"	"pc105"
     Option	"XkbLayout"	"us"
    EndSection

    Section "InputDevice"
     Identifier	"Mouse0"
     Driver	"evdev"
     Option	"SencCoreEvents"
    EndSection

    Section "Device"
     Identifier	"Card0"
     Driver	"fglrx"
     BusID		"PCI:1:5:0"
     VendorName	"ATI Technologies Inc"
     BoardName	"RS482 [Radeon Xpress 200]"
     BusID		"PCI:1:5:0"
    EndSection

    Section "Monitor"
     Identifier	"LCD Display"
     Option	"DPMS"
    EndSection

    Section "Screen"
     Identifier	"Screen0"
     Device	"Card0"
     Monitor	"LCD Display"
     DefaultDepth	24
    EndSection

    Section "ServerLayout"
     Identifier	"Default Layout"
     Screen	"Screen0"
     InputDevice	"Keyboard"
     InputDevice	"Mouse0"
    EndSection

    Section "DRI"
     Mode    0666
    EndSection

> Touchpad

The following configuration gives a vertical scroll and one-tap click.
Modify to suite your needs. The default file does not give you the
scroll or one-tap click.   
  
 Copy /usr/share/hal/fdi/policy/10osvendor/11-x11-synaptics.fdi to
/etc/hal/fdi/policy/   
  
 Edit /etc/hal/fdi/policy/11-x11-synaptics.fdi and In between

     
     <match key="info.product" contains="Synaptics TouchPad">
     <!--Insert the following here-->
     </match>

Insert:

     <merge key="input.x11_options.Emulate3Buttons"	type="string">true</merge>
     <merge key="input.x11_options.SHMConfig"	type="string">true</merge>
     <merge key="input.x11_options.HorizEdgeScroll"	type="string">false</merge>
     <merge key="input.x11_options.HorizScrollDelta"	type="string">100</merge>
     <merge key="input.x11_options.TapButton1"	type="string">1</merge>
     <merge key="input.x11_options.VertEdgeScroll"	type="string">true</merge>
     <!--
      <merge key="input.x11_options.VertScrollDelta"	type="string">100</merge>
     -->
     <merge key="input.x11_options.TapButton1"	type="string">1</merge>
     <merge key="input.x11_options.TapButton2"	type="string">2</merge>
     <merge key="input.x11_options.TapButton3"	type="string">3</merge>

  

> Function Keys

To set the Functions keys you can use xmodmap. In xorg 7.4 the function
keys are given keycodes. Xmodmap will bind the function key codes to a
keysymname.

Create an .Xmodmap and put the following in:

    keycode 123 = XF86AudioRaiseVolume
    keycode 122 = XF86AudioLowerVolume
    keycode 121 = XF86AudioMute

    keycode 213 = XF86Sleep
    keycode 246 = XF86Launch2
    keycode 244 = XF86Launch3
    keycode 170 = XF86Launch9

Next add xmodmap .Xmodmap to your start up

Then in your window manager you can bind the function key by providing
the keysymname. For example in openbox I just have to pass in the key
name XF86AudioMute and provide the action I want preformed when I hit
that key.

-   Gnome users should be able to open up the keyboard-shortcuts and
    just hit the Function which they would like to use

Wireless
========

b43
---

Native Linux Driver - Works with kernels >= 2.6.25

Install b43

1.  Install b43 fwcutter

        pacman -S b43-fwcutter

2.  Download version 4.80.53.0 of Broadcom's proprietary driver.

        wget http://downloads.openwrt.org/sources/broadcom-wl-4.150.10.5.tar.bz2

3.  Unpack the compressed file.

        tar xvf broadcom-wl-4.150.10.5.tar.bz2

4.  Change the current directory to the newly created directory, and
    then further to the kmod folder:

        cd broadcom-wl-4.150.10.5/driver

5.  Run

        b43-fwcutter-011/b43-fwcutter -w "/lib/firmware/" wl_apsta_mimo.o

    You may have to create /lib/firmware first.

6.  Load b43

        modprobe b43

7.  Edit rc.conf and add b43

        MODULES=(... b43)

wl
--

Broadcom's Official Binary Wireless Driver

1.  Download the pkgbuild from AUR: broadcom-wl
2.  Extract the pkgbuild
3.  Run makepkg
4.  Run pacman -U broadcom-wl-5.10.27.6-6-${arch}.tar.gz
5.  modprobe wl

If you add wl to your MODULES=(... wl) make sure you blacklist b43 (Open
Wireless) and b44 (Ethernet)

Note:The ssb module must be unloaded for this module to work. When the
b44 (Ethernet) module gets loaded, it loads sbb. This means you can only
use wireless or Ethernet with this module, not both!.

Note:Currently appears that you can use both, wireless and ethernet.
Just make sure your wireless network is loaded before the ethernet by
adding the following in your rc.conf in the MODULES section:
MODULES=(!b43 wl ...) !.

Ndiswrapper
-----------

1.  Install ndiswrapper

        pacman -S ndiswrapper ndiswrapper-utils

2.  Download Dell Wireless Drivers:

        http://support.dell.com/support/downloads/download.aspx?c=us&cs=04&l=en&s=bsd&releaseid=R157039&SystemID=VOS_N_1000&servicetag=&os=WLH&osl=en&deviceid=9805&devlib=0&typecnt=0&vercnt=3&catid=-1&impid=-1&formatcnt=1&libid=5&fileid=209641

3.  Extract drivers using wine:

        wine R157039.EXE

4.  Move the drivers to your home directory

        cp -R /home/youruser/.wine/drive_c/DELL/R157039 /home/youruser/wirelessdrivers

5.  As root run:

        ndiswrapper -i bcmwl5.inf

6.  Run:

        ndiswrapper -l 

    It should show something similar to:

         bcmwl5 : driver installed device (14E4:4311) present (alternate driver: bcm43xx)

7.  Run

        modprobe ndiswrapper

8.  Add ndiswrapper to your MODULES in rc.conf

Wicd
----

Wicd is a network manager which allows you to connect to wireless
networks very easily, you can follow this wiki page Wicd

Suspend/Hibernate
=================

-   Suspend and Hibernate works with pm-utils
-   Also works by issuing

        echo mem > /sys/power/state

Resume not working after suspend to RAM
---------------------------------------

To workaround this issue edit the file

    /boot/grub/menu.lst

and add the following to the kernel boot line:

    hpet=disable

Backlight doesn't come back after Resume
----------------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: radeontool no    
                           longer exists (Discuss)  
  ------------------------ ------------------------ ------------------------

You may need a workaround because the backlight doesn't come back after
Resuming.

Install Pm-utils, and create this file:

/etc/pm/sleep.d/radeonlight

    #!/bin/bash
    case $1 in
     hibernate)
      echo "Suspending to disk!"
     ;;
     suspend)
      echo "Suspending to RAM"
     ;;
     thaw)
      echo "Suspend to disk is over, Resuming. .."
     ;;
     resume)
      echo "Suspend to RAM is over, Resuming..."
      radeontool light on
      radeontool dac on
     ;;
     *)  echo "somebody is calling me totally wrong."
     ;;
    esac

    # chmod +x /etc/pm/sleep.d/radeonlight

Now to make it work you need radeontool.

And DONE, you can suspend and resume with pm-utils normally.

Adjust Brightness
=================

Adjust normally with the FN Keys if your using the kernel 2.6.24 or
greater

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Vostro_1000&oldid=226954"

Category:

-   Dell
