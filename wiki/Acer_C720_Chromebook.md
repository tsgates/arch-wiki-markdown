Acer C720 Chromebook
====================

The Acer C720 Chromebook (and newer chromebooks in general) features a
"legacy boot" mode that makes it easy to boot Linux and other operating
systems. The legacy boot mode is provided by the SeaBIOS payload of
coreboot. SeaBIOS behaves like a traditional BIOS that boots into the
MBR of a disk, and from there into your standard bootloaders like
Syslinux and GRUB.

Contents
--------

-   1 Preview
-   2 Installation
    -   2.1 Enabling Developer Mode
    -   2.2 Enabling SeaBIOS
    -   2.3 Installing Arch Linux
    -   2.4 Xorg Video Driver
    -   2.5 Touchpad Kernel Modules
        -   2.5.1 configuration
    -   2.6 Touchscreen (C720P model)
    -   2.7 Power Key and Lid Switch Handling
        -   2.7.1 Ignore using logind
        -   2.7.2 Fixing suspend
-   3 Hotkeys
    -   3.1 Sxhkd configuration
    -   3.2 xbindkeys configuration
-   4 Audio
-   5 Unresolved Issues

Preview
-------

You can watch the preview on what Arch on Acer C720 looks like
https://www.youtube.com/watch?v=dEbCFlyUw5c

Installation
------------

First enable legacy boot / SeaBIOS from the developer mode of Chrome OS.
Then install and boot Linux as you would on a traditional x86 BIOS
system.

> Enabling Developer Mode

Warning:This will wipe all of your data!

To enter developer mode:

-   Press and hold the Esc+F3 (Refresh) keys, then press the Power
    button. This enters recovery mode.
-   Now, press Ctrl+D (no prompt). It will ask you to confirm, then the
    system will revert its state and enable developer mode.
-   Press Ctrl+D (or wait 30 seconds for the beep and boot) at the white
    boot splash screen to enter Chrome OS.

> Enabling SeaBIOS

After changing to developer mode, configure Chrome OS so that you can
log in.

To enable the legacy bios:

-   Open a crosh window with Ctrl+Alt+T.
-   Open a bash shell with the shell command.
-   Become superuser with sudo bash
-   Enable legacy boot with:

    # crossystem dev_boot_usb=1 dev_boot_legacy=1

-   Reboot the machine

You can now start SeaBIOS by pressing Ctrl-L at the white boot splash
screen. If you want to make SeaBIOS default, you MUST first remove the
write protect screw and then run:

Warning:I'm serious! You HAVE to remove the write-protect screw first!
Otherwise the system will be corrupted and you'll need to recover it

    # set_gbb_flags.sh 0×489

> Installing Arch Linux

Create a USB drive with the Arch Linux installer. Plug the USB drive
into the Chromebook, and start SeaBIOS with Ctrl-L at the white boot
splash screen. Press Esc to get a boot menu and select the number
corresponding to your USB drive. The Arch Linux installer boot menu
should appear. Follow your favorite installation guide.

A few installation notes:

-   For a 64-bit installation, use the 2013.10.01 ISO, and boot into the
    x86_64 installer with the mem=1536m kernel option. (You can download
    torrent on linuxtracker.org)
-   A fresh DOS partition table on the SSD with one bootable 16GB root
    partition works. Note that this will wipe Chrome OS.
-   Choose GRUB as your bootloader, for now, instead of Syslinux.
-   After installing it's not Ctrl + D to boot OS it's Ctrl + L (To save
    you hours figuring out why you can't boot)
-   Use GUID_Partition_Table (GPT) instead of MBR, you can use cgdisk to
    create partiton. And don't forget a 1-2M size BIOS boot partition
    for GRUB is needed.

> Xorg Video Driver

Use the xf86-video-intel driver.

    $ sudo pacman -S xf86-video-intel

> Touchpad Kernel Modules

Enabling the touchpad currently requires building a set of patched
Haswell Chromebook kernel modules. Fortunately, ChrUbuntu provides a
script for automatically building and installing these modules:
cros-haswell-modules.sh.

A modified version for Arch Linux is available here
cros-haswell-modules-archlinux.sh (tested with Linux 3.13). For kernel
3.12 or earlier, the earlier script can be found here.

    $ wget http://pastie.org/pastes/8763538/download -O cros-haswell-modules-archlinux.sh
    $ chmod +x cros-haswell-modules-archlinux.sh
    $ ./cros-haswell-modules-archlinux.sh

configuration

-   Edit Xorg touchpad configuration file

Add the Xorg touchpad configuration below for better usability
(increases touchpad sensitivity).

    /etc/X11/xorg.conf.d/50-cros-touchpad.conf

    Section "InputClass" 
        Identifier      "touchpad peppy cyapa" 
        MatchIsTouchpad "on" 
        MatchDevicePath "/dev/input/event*" 
        MatchProduct    "cyapa" 
        Option          "FingerLow" "10" 
        Option          "FingerHigh" "10" 
    EndSection

If you want to remove the "Right Click" behavior from the touchpad from
the bottom right area (you can still right click with two finger
clicks), you should comment out the following section from
/etc/X11/xorg.conf.d/50-synaptics.conf

    /etc/X11/xorg.conf.d/50-synaptics.conf

    #Section "InputClass"
    #        Identifier "Default clickpad buttons"
    #        MatchDriver "synaptics"
    #        Option "SoftButtonAreas" "50% 0 82% 0 0 0 0 0"
    #       To disable the bottom edge area so the buttons only work as buttons,
    #       not for movement, set the AreaBottomEdge
    #       Option "AreaBottomEdge" "82%"
    #EndSection

-   Use graphical tool

Synaptiks is a touchpad configuration and management tool for KDE. It
provides a System Settings module to configure basic and advanced
features of the touchpad. Although it is said to be currently
unmaintained. and seems to crash under KDE 4.11, it works well with this
Chromebook, KDE 4.12.2. Another untility, kcm_touchpad, does not work at
all.

Reboot for the touchpad to become operational.

> Touchscreen (C720P model)

If you're using a touchscreen-enabled model (such as the C720P), you may
use a modified version of the previous script to install patched modules
for the touchscreen as well

It is available here cros-haswell-modules-archlinux.sh (tested with
Linux 3.13). For kernel 3.12 or earlier, the earlier script can be found
here.

    $ wget http://pastie.org/pastes/8834223/download -O cros-haswell-modules-archlinux.sh
    $ chmod +x cros-haswell-modules-archlinux.sh
    $ ./cros-haswell-modules-archlinux.sh

> Power Key and Lid Switch Handling

Ignore using logind

Out of the box, systemd-logind will catch power key and lid switch
events and handle them: it will do a poweroff on a power key press, and
a suspend on a lid close. However, this policy might be a bit harsh
given that the power key is an ordinary key at the top right of the
keyboard that might be pressed accidentally.

To configure logind to ignore power key presses and lid switches, add
the lines to logind.conf below.

    /etc/systemd/logind.conf

    HandlePowerKey=ignore
    HandleLidSwitch=ignore

Then restart logind for the changes to take effect.

    $ sudo systemctl restart systemd-logind

Power key and lid switch events will still be logged to journald by
logind. See
http://www.freedesktop.org/software/systemd/man/logind.conf.html for
additional handling options.

Fixing suspend

The following are instructions to fix the suspend functionality. There
have been a few alternatives discussed and those may work better for
some.

Create the following cros-acpi-wakeup.conf file.

    /etc/tmpfiles.d/cros-acpi-wakeup.conf

    w /proc/acpi/wakeup - - - - EHCI
    w /proc/acpi/wakeup - - - - HDEF
    w /proc/acpi/wakeup - - - - XHCI
    w /proc/acpi/wakeup - - - - LID0
    w /proc/acpi/wakeup - - - - TPAD
    w /proc/acpi/wakeup - - - - TSCR

Then, create the following cros-sound-suspend.sh file. Only the ehci
binding/unbinding lines are listed below; see the alternatives linked
above for additional sound suspend handling if you experience issues.

    /usr/lib/systemd/system-sleep/cros-sound-suspend.sh

    #!/bin/bash
    case $1/$2 in
      pre/*)
        # Unbind ehci.
        echo -n "0000:00:1d.0" | tee /sys/bus/pci/drivers/ehci-pci/unbind
        ;;
      post/*)
        # Bind ehci.
        echo -n "0000:00:1d.0" | tee /sys/bus/pci/drivers/ehci-pci/bind
        ;;
    esac

Make sure to make the scrip executable:
 # chmod +x /usr/lib/systemd/system-sleep/cros-sound-suspend.sh  Then
add the following kernel boot parameters. Different combinations have
been mentioned, with tpm_tis.force=1 being the most important.

    /etc/default/grub.cfg

    GRUB_CMDLINE_LINUX_DEFAULT="quiet add_efi_memmap boot=local noresume noswap i915.modeset=1 tpm_tis.force=1 tpm_tis.interrupts=0 nmi_watchdog=panic,lapic"

Then rebuild your grub config.

Hotkeys
-------

The c720 has function keys with dedicated Chromebook shortcuts within
Chrome OS. By default these work as regular function keys, but they can
be mapped to match their appearance.

> Sxhkd configuration

Below is an Sxhkd configuration file that specifies behavior similar to
the shortcut defaults in Chrome OS. Besides the sxhkd daemon, this
requires amixer, xorg-xbacklight, and xautomation.

    ~/.config/sxhkd/sxhkdrc

    # Web browser Back/Forward shortcuts
    {@F1,@F2}
      xte 'keydown Alt_L' 'key {Left,Right}' 'keyup Alt_L'

    # Web browser Refresh shortcut
    @F3
      xte 'keydown Control_L' 'key r' 'keyup Control_L'

    # Awesome WM maximize current window
    # Adjust as necessary for different window managers
    @F4
      xte 'keydown Super_L' 'key m' 'keyup Super_L'

    # Awesome WM move one desktop right
    @F5
      xte 'keydown Super_L' 'key Right' 'keyup Super_L'

    {F6,F7}
      xbacklight -{dec,inc} 10

    F8
      amixer set Master toggle

    {F9,F10}
      amixer set Master 10{-,+} unmute

> xbindkeys configuration

There is another way to configure hot keys using xbindkeys.Below is an
xbindkeys configuration file that specifies behavior very similar to the
shortcut defaults in Chrome OS. This requires amixer and
xorg-xbacklight.Besides, xvkbd is needed for sending string (key
shortcuts) to focus window. Some of the configuration comes from thread
vilefridge's xbindkeys configuration.

    ~/.xbindkeysrc


    # Backward, Forward, Full Screen & Refresh is just for web browser
    #Backward
    "xvkbd -xsendevent -text "\A\[Left]""
        m:0x0 + c:67
        F1 

    #Full Screen
    "xvkbd -xsendevent -text "\[F11]""
        m:0x0 + c:70
        F4 

    #Forward
    "xvkbd -xsendevent -text "\A\[Right]""
        m:0x0 + c:68
        F2 

    #Refresh
    "xvkbd -xsendevent -text "\Cr""
        m:0x0 + c:69
        F3 

    # on ChromeBook, it "Enter Overview mode, which shows all windows (F5)", see also https://support.google.com/chromebook/answer/1047364?hl
    # here it work at KDE, it "Switch to next focused window", see also http://community.linuxmint.com/tutorial/view/47
    #Switch Window
    "xvkbd -xsendevent -text "\A\t""
        m:0x0 + c:71
        F5 

    #Backlight Down
    "xbacklight -dec 5"
        m:0x0 + c:72
        F6 

    #Backlight Up
    "xbacklight -inc 5"
        m:0x0 + c:73
        F7 

    #Mute
    "amixer set Master toggle"
        m:0x0 + c:74
        F8 

    #Decrease Volume
    "amixer set Master 5- unmute"
        m:0x0 + c:75
        F9 

    #Increase Volume
    "amixer set Master 5+ unmute"
        m:0x0 + c:76
        F10 

    # added Home, End, Pg Up, Pg Down, and Del keys using the Alt+arrow key combos
    #Delete
    "xvkbd -xsendevent -text '\[Delete]'"
        m:0x8 + c:22
        Alt + BackSpace 

    #End
    "xvkbd -xsendevent -text '\[End]'"
        m:0x8 + c:114
        Alt + Right 

    #Home
    "xvkbd -xsendevent -text '\[Home]'"
        m:0x8 + c:113
        Alt + Left 

    #Page Down
    "xvkbd -xsendevent -text '\[Page_Down]'"
        m:0x8 + c:116
        Alt + Down 

    #Page Up
    "xvkbd -xsendevent -text '\[Page_Up]'"
        m:0x8 + c:111
        Alt + Up 

    #
    # End of xbindkeys configuration

Once you're done configuring xbindkeys, edit your ~/.xinitrc and place

    xbindkeys

before the line that starts your window manager or DE.

Audio
-----

Getting alsa to work with the C720 is as simple as creating or editing
your /etc/modprobe.d/alsa.conf and adding the line

    /etc/modprobe.d/alsa.conf

    options snd_hda_intel index=1

Unresolved Issues
-----------------

-   The 64-bit installer in Arch Linux installation ISOs newer than
    2013.10.01 causes an immediate system reset
-   Syslinux fails to set the bootable flag with
    syslinux-install_update -i -a -m. After setting the bootable flag
    manually in fdisk and installing Syslinux to the MBR with
    syslinux-install_update -i -m, SeaBIOS boots syslinux, but syslinux
    then complains about a missing OS. Use GRUB for now.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_C720_Chromebook&oldid=306194"

Category:

-   Acer

-   This page was last modified on 21 March 2014, at 03:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
