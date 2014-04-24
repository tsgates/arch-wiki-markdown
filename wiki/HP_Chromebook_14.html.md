HP Chromebook 14
================

This is a work in progress with information about the HP Chromebook 14
(FALCO)

The HP Chromebook 14 (and newer chromebooks in general) features a
"legacy boot" mode that makes it easy to boot Linux and other operating
systems. The legacy boot mode is provided by the SeaBIOS payload of
coreboot. SeaBIOS behaves like a traditional BIOS that boots into the
GPT of a disk, and from there into your standard bootloaders like
Syslinux and GRUB.

Contents
--------

-   1 Installation
    -   1.1 Enabling Developer Mode
    -   1.2 Partitioning the drive
    -   1.3 Create Filesystem and BIOS Partition
    -   1.4 Install Arch and GRUB
-   2 HP Chromebook 14 Specific Fixes
    -   2.1 Touchpad
    -   2.2 Suspend
    -   2.3 Hotkeys
-   3 Shortening the Developer Mode Splash Screen
    -   3.1 Opening the case
    -   3.2 Removing the bios screw
    -   3.3 Modifying the BIOS

Installation
------------

> Enabling Developer Mode

Enabling developer mode on this laptop is the same as the Acer C720. The
procedure can be found on the official page for the Acer C720.

Remember that enabling developer mode wipes all local data off of the
Chromebook.

> Partitioning the drive

In order to partition the drive, we will run the first stage of the
ChruBuntu script. After logging it, open a shell with Ctrl + Alt + Right
and run the following in your home directory:

    curl -L -O http://goo.gl/9sgchs; sudo bash 9sgchs

It will ask how much space to partition for the alternate partition. 8GB
is a safe number for the 16GB SSD. More than 9 may not work. After
rebooting, ChromeOS will repair itself. Once this is done, verify that
the disk space has been reduced by opening a file manager and clicking
the gear in the top right of the window.

Open a terminal again and open a shell. Run
crossystem dev_boot_usb=1 dev_boot_legacy=1 to enable booting off of the
install usb drive and the new partition.

> Create Filesystem and BIOS Partition

Boot off of your usb drive by pressing Ctrl + U at the developer mode
screen on boot, and choose i686.

Run the command fdisk -l to list drives and partitions. Find the
internal drive and note the name of the partition matching the size you
specified in the ChrUbuntu script.

Use mkfs.ext4 /dev/sdxY (where xY is drive letter and partition number,
eg. /dev/sda7) This will create the filesystem for arch. Following the
instructions for installing GRUB on GPT, use gdisk to create a 1007kb
partition and set the type to EF02.

> Install Arch and GRUB

From here, use the beginner's guide to use pacstrap to install the Arch
base system. Install grub using official instructions as well.

HP Chromebook 14 Specific Fixes
-------------------------------

> Touchpad

A working fix for the touchpad comes from the Acer wiki page:

Enabling the touchpad currently requires building a set of patched
Haswell Chromebook kernel modules. Fortunately, ChrUbuntu provides a
script for automatically building and installing these modules:
cros-haswell-modules.sh.

A modified version for Arch Linux is available here
cros-haswell-modules-archlinux.sh (tested with Linux 3.12.6).

    $ wget http://pastie.org/pastes/8540561/download -O cros-haswell-modules-archlinux.sh
    $ chmod +x cros-haswell-modules-archlinux.sh
    $ ./cros-haswell-modules-archlinux.sh

Add the Xorg touchpad configuration below for better usability.

    /etc/X11/xorg.conf.d/50-cros-touchpad.conf

    Section "InputClass" 
        Identifier      "touchpad peppy cyapa" 
        MatchIsTouchpad "on" 
        MatchDevicePath "/dev/input/event*" 
        MatchProduct    "cyapa" 
        Option          "FingerLow" "10" 
        Option          "FingerHigh" "10" 
    EndSection

Reboot for the touchpad to become operational.

-   Haswell Kernel Module for Touchpad Fix

An alternative can be located here:

-   Untested Custom Kernel

> Suspend

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

Then add the following kernel boot parameters. Different combinations
have been mentioned, with tpm_tis.force=1 being the most important.

    /etc/default/grub.cfg

    GRUB_CMDLINE_LINUX_DEFAULT="quiet add_efi_memmap boot=local noresume noswap i915.modeset=1 tpm_tis.force=1 tpm_tis.interrupts=0 nmi_watchdog=panic,lapic"

Then rebuild your grub config.

> Hotkeys

Hotkeys may be configured by using xbindkeys to capture the hotkeys and
run commands. Additionally, xDoTool can be installed to have a hotkey
simulate other keypresses (eg, forward/F2 simulates a media next track
key).

My config is shown below:

    ###########################
    # xbindkeys configuration #
    ###########################
    #
    # Version: 0.1.3
    #
    # If you edit this, do not forget to uncomment any lines that you change.
    # The pound(#) symbol may be used anywhere for comments.
    #
    # A list of keys is in /usr/include/X11/keysym.h and in
    # /usr/include/X11/keysymdef.h 
    # The XK_ is not needed. 
    #
    # List of modifier (on my keyboard): 
    #   Control, Shift, Mod1 (Alt), Mod2 (NumLock), 
    #   Mod3 (CapsLock), Mod4, Mod5 (Scroll). 
    #
    # Another way to specifie a key is to use 'xev' and set the 
    # keycode with c:nnn or the modifier with m:nnn where nnn is 
    # the keycode or the state returned by xev 
    #
    # This file is created by xbindkey_config 
    # The structure is : 
    # # Remark 
    # "command" 
    # m:xxx + c:xxx 
    # Shift+... 




    #keystate_numlock = enable
    #keystate_scrolllock = enable
    #keystate_capslock = enable



    #Mute
    "amixer sset Master toggle"
        m:0x4 + c:74
        Control + F8 

    #Volume Down
    "amixer -c 1 sset Master 2%-"
        m:0x4 + c:75
        Control + F9 

    #Volume Up
    "amixer -c 1 sset Master 2%+"
        m:0x4 + c:76
        Control + F10 

    #Dim
    "xbacklight -dec 10"
        m:0x4 + c:72
        Control + F6 

    #Brighten
    "xbacklight -inc 10"
        m:0x4 + c:73
        Control + F7 

    #Play/Pause
    "xdotool key XF86AudioPlay"
        m:0x4 + c:69
        Control + F3 

    #Prev Track
    "xdotool key XF86AudioPrev"
        m:0x4 + c:67
        Control + F1 

    #Next Track
    "xdotool key XF86AudioNext"
        m:0x4 + c:68
        Control + F2 

    #
    # End of xbindkeys configuration

Shortening the Developer Mode Splash Screen
-------------------------------------------

This process shortens the developer mode screen on boot to ~2-3 seconds
as opposed to the normal 30 seconds, and it also silences the system
beep that plays if a key isn't pressed. The steps are as follows:

-   Open case
-   Remove bios screw and pull battery
-   Read bios
-   Edit flags using gbb_utility
-   Write new bios
-   Replace bios screw (optional)

> Opening the case

There is only 1 disassembly I have been able to find:
http://imgur.com/a/aGSQC

Important notes:

-   There are 4 hidden screws under rubber stubs (not the rubber feet)
    of the bottom.
-   Once the screws on the bottom are removed, flip the laptop right
    side up and use a thin blunt object to pry the keyboard surface from
    the bottom half.

> Removing the bios screw

The bios screw is located to the left of the fan. It can be recognized
by the fact that the copper circle it sits on is split in half "( )" vs
"O". The screw connects the two halves, making the bios unwriteable.

Once this screw is removed, it's advisable to unplug the battery and
plug it back in to ensure that the removal is recognized.

This picture shows the location of the bios writable screw on the inside
of the laptop.

> Modifying the BIOS

Boot and use Ctrl + Alt + F2 to access the terminal and log in as root.
Run the following commands:

    cd ~/home/user/*/Downloads #Where * is the long string of numbers
    flashrom -r bios.bin
    gbb_utility --set --flags=0×01 bios.bin bios.new
    flashrom -w bios.new

If the flashrom commands fail, check to make sure the right screw is
removed, and that you are in the user's downloads directory. You can
also try running "flashrom --wp-disable".

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Chromebook_14&oldid=299310"

Category:

-   HP

-   This page was last modified on 20 February 2014, at 21:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
