Dell Chromebook 11
==================

The Dell Chromebook 11 (and newer chromebooks in general) features a
"legacy boot" mode that makes it easy to boot Linux and other operating
systems. The legacy boot mode is provided by the SeaBIOS payload of
coreboot. SeaBIOS behaves like a traditional BIOS that boots into the
MBR of a disk, and from there into your standard bootloaders like
Syslinux and GRUB.

The instructions for getting Arch Linux to work on this machine are
similar to the Acer C720 Chromebook, with a few differences.

Contents
--------

-   1 Installation
    -   1.1 Enabling Developer Mode
    -   1.2 SeaBIOS
    -   1.3 Installing Arch Linux
    -   1.4 Xorg Video Driver
    -   1.5 Touchpad Kernel Modules
        -   1.5.1 configuration
    -   1.6 Power Key and Lid Switch Handling
        -   1.6.1 Ignore using logind
        -   1.6.2 Fixing suspend
-   2 Hotkeys
-   3 Audio
-   4 Unresolved Issues

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

After changing to developer mode, configure Chrome OS so that you can
log in, or use the guest account.

> SeaBIOS

Warning:This may screw up the RW part of your firmware! If this happens,
you must use a ChromeOS recovery stick to reset it.

The version of SeaBIOS that ships with the Dell Chromebook doesn't work
properly, and therefore you must patch it in order to get it to work.

-   Open a crosh window with Ctrl+Alt+T.
-   Open a bash shell with the shell command.
-   Become superuser with sudo bash
-   Download the patched seabios.cbfs from
    https://code.google.com/p/chromium/issues/detail?id=348403#c4, and
    save it to Downloads.
-   Patch SeaBIOS with the following commands:

    # cd ~/Downloads
    # flashrom -r bios.rom
    # dd if=seabios.cbfs of=image.rom seek=2 bs=2M conv=notrunc
    # flashrom -w image.rom -i RW_LEGACY

-   Enable legacy boot with:

    # crossystem dev_boot_usb=1 dev_boot_legacy=1

-   Reboot the machine

You can now start SeaBIOS by pressing Ctrl-L at the white boot splash
screen.

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
cros-haswell-modules-archlinux.sh (tested with Linux 3.13).

    $ wget http://pastie.org/pastes/8901903/download -O cros-haswell-modules-archlinux.sh
    $ chmod +x cros-haswell-modules-archlinux.sh
    $ ./cros-haswell-modules-archlinux.sh

configuration

-   Edit Xorg touchpad configuration file

Add the Xorg touchpad configuration below for better usability
(increases touchpad sensitivity).

    /etc/X11/xorg.conf.d/50-cros-touchpad.conf

    Section "InputClass" 
        Identifier      "touchpad wolf cyapa" 
        MatchIsTouchpad "on" 
        MatchDevicePath "/dev/input/event*" 
        MatchProduct    "cyapa" 
        Option          "FingerLow" "5" 
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

The following are instructions to fix the suspend functionality.

Create the following cros-ehci-disable.conf file. This unbinds the
ehci-pci driver at boot, which spams the system journal on wakeup.

    /etc/tmpfiles.d/cros-ehci-wakeup.conf

    w /sys/bus/pci/drivers/ehci-pci/unbind - - - - "0000:00:1d.0"

Then, create the following wakeup file. This disables all resume
triggers from S3 except the lid, and therefore prevents random wakeups
due to hardware interrupts. Feel free to experiment to see which of the
/proc/acpi/wakeup switches actually causes this behavior, and update
this wiki page.

    /usr/lib/systemd/scripts/wakeup

    echo LID0 > /proc/acpi/wakeup
    echo TPAD > /proc/acpi/wakeup
    echo TSCR > /proc/acpi/wakeup
    echo EHCI > /proc/acpi/wakeup
    echo XHCI > /proc/acpi/wakeup

Create a systemd service file for it as well:

    /usr/lib/systemd/services/wakeup.service

    [Unit]
    Description=Prevent random wakeups

    [Service]
    Type=oneshot
    ExecStart=/usr/lib/systemd/scripts/wakeup

    [Install]
    WantedBy=multi-user.target

Enable and start the service:

    # systemctl enable wakeup.service
    # systemctl start wakeup

Then, add the following kernel boot parameters.

    /etc/default/grub.cfg

    GRUB_CMDLINE_LINUX_DEFAULT="quiet tpm_tis.force=1 tpm_tis.interrupts=0"

Finally, rebuild your grub config and reboot.

Hotkeys
-------

The hotkey configuration is similar to the Acer C720.

Audio
-----

The audio configuration is similar to the Acer C720.

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
"https://wiki.archlinux.org/index.php?title=Dell_Chromebook_11&oldid=304399"

Category:

-   Dell

-   This page was last modified on 14 March 2014, at 00:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
