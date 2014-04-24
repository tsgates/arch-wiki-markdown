Sony Vaio Pro SVP-1x21
======================

This document will guide you through the process of installing Arch
Linux on the 2013 Sony Vaio Pro Haswell based Ultrabook. From what we've
seen, this laptop seems to be very Arch friendly! :)

Contents
--------

-   1 Features
-   2 Pre-installation
    -   2.1 BIOS Configuration
    -   2.2 Install media
    -   2.3 Internet connection
-   3 Installation
    -   3.1 Picking a bootloader
        -   3.1.1 UEFI
            -   3.1.1.1 Gummiboot
            -   3.1.1.2 GRUB
            -   3.1.1.3 Dual-boot Windows 8
        -   3.1.2 Legacy
            -   3.1.2.1 GRUB
-   4 Post-intallation
-   5 Hardware support
    -   5.1 CPU
    -   5.2 Video
    -   5.3 Sound
    -   5.4 WiFi
    -   5.5 Touch screen
    -   5.6 Keyboard backlight
    -   5.7 Monitor backlight control
    -   5.8 Trackpad
    -   5.9 Keyboard and buttons
        -   5.9.1 Toggle TouchPad via Fn+F1
    -   5.10 Fan control
    -   5.11 Charging
    -   5.12 USB ports
    -   5.13 SD card slot
    -   5.14 NFC
    -   5.15 Bluetooth
    -   5.16 Webcam
    -   5.17 Internal mic
-   6 Summary of known issues

Features
--------

-   Intel Haswell Series CPU (4200U/4500U)
-   4/8GB of DDR3 1600MHz RAM
-   128 to 512GB SSD with read speeds over 1GB/s
-   11/13" LED-backlit 1080p IPS screen
-   Optional touchscreen
-   Backlit keyboard
-   Webcam
-   Wireless: WiFi 802.11n, Bluetooth, NFC
-   Sensors: ambilight
-   Ultra low weight; around 1.1kg for the 13" model

Pre-installation
----------------

> BIOS Configuration

Get into the BIOS by pushing the assist button when the system is shut
off and then hitting Start BIOS Setup. Do not try to boot from your usb
key using recovery mode, instead change the boot order in the BIOS. Make
the following changes:

    Intel(R) AT Support System	[Disabled]
    Secure Boot			[Disabled]
    External Device Boot		[Enabled]
    Select 1st Boot Priority	[External Device]

If you want to use the legacy boot (non-EFI), change:

    Boot Mode			[Legacy]

> Install media

-   Important! Do NOT use the usb port labelled with a lightning bolt,
    you will never get it to even boot.
-   When booting from USB you might need to append libata.force=noncq to
    the kernel parameters to avoid problems with the SSD. You may even
    need to make this a persistent kernel parameter when booting from
    the SSD after installation.
-   When installing via UEFI from USB create an UEFI bootable USB from
    ISO

> Internet connection

Works as expected as of kernel version 3.11

Installation
------------

> Picking a bootloader

UEFI

Inside the chroot UEFI variables might not be available. To make them
available for installing the bootloader, run

       mount -t efivarfs efivarfs /sys/firmware/efi/efivars

Gummiboot

Works as expected. Make sure to mount /dev/sda3 under /boot to install
Gummiboot to the existing EFI system partiton.

GRUB

Some users are unable to run the install.

Note:Grub should install fine if UEFI boot mode is turned on in the
BIOS.

Dual-boot Windows 8

Windows 8 fast boot mode overwrites your EFI variables. To keep your
bootloader in working order, fast boot needs to be disabled. In cmd.exe
as Administrator:

       powercfg /h off

The laptop firmware seems to have a preference to boot Windows even when
other bootmanagers are present.

A solution is to move your bootloader to a recognised location such as
/EFI/Boot/bootx64.efi [1]

Legacy

GRUB

Works as expected.

Post-intallation
----------------

-   For a faster boot, don't forget to undo these BIOS settings:

    External Device Boot		[Disabled]
    Select 1st Boot Priority	[Internal Drive]

-   If you want all the power from the Haswell CPU, install a RC of the
    3.12 kernel (linux-mainline).

Hardware support
----------------

> CPU

Issues regarding getting full performance are being fixed in Linux
kernel 3.12. 3.11 is working fine, just has no turbo.

> Video

Works good with the xf86-video-intel driver. For instuctions on
installing and configuring, see the Intel Graphics article.

> Sound

As the Installation guide suggests, install alsa-utils and follow this
guide to get started. Works out of the box, although main sound card may
have index 1, making it non-default (index 0 is taken by Intel HDMI). To
fix this, edit /usr/share/alsa/alsa.conf (near line 68):

    /usr/share/alsa/alsa.conf

    defaults.ctl.card 1
    defaults.pcm.card 1

> WiFi

The Intel 7260 WiFi card is supported in Linux kernel 3.11 or newer.

> Touch screen

Tapping works out of the box. Multitouch gestures do not work.

> Keyboard backlight

Works out of the box. Enables in low amblient light and a key press,
turns off after about 20s. Can be customized by modifying kbd_backlight
and kbd_backlight_timeout found in:

    /sys/devices/platform/sony-laptop/

A simple shell script for toggling the backlight, bind to a keyboard
shortcut for easy use:

    #!/bin/sh
    path="/sys/devices/platform/sony-laptop/kbd_backlight"
    if [ $(<$path) -eq 1 ]
    then
    	newval=0
    else
    	newval=1
    fi
    echo "$newval" > $path

Make sure that you can write to this file without root privileges:

    # chmod 777 /sys/devices/platform/sony-laptop/kbd_backlight

> Monitor backlight control

Works out of the box with xorg-xbacklight. By default the backlight is
only adjusted by 1% per button press. This can easily be fixed by
binding those keys to a xorg-xbacklight command. DM:s like Xfce does
take larger steps by default.

With KDE 1% adjustment can be fixed by kernel module parameter
video.brightness_switch_enabled=0. This will disable kernel driver 1%
adjustment, then KDE PowerDevil correctly adjust brightness by 10% and
shows gauge window. There is no need to bind keys.

> Trackpad

Works great with the xf86-input-synaptics driver. A good base config can
be found here.

> Keyboard and buttons

Works very well out of the box.

Toggle TouchPad via Fn+F1

The hotkey that toggles the TouchPad can be configured using acpid.
Create the following two files to do so:

    /etc/acpi/events/toggle-touchpad

    event=button.fnf1 FNF1
    action=/etc/acpi/actions/toggle-touchpad.sh "%e"

Note:This file must be marked as executable.

    /etc/acpi/actions/toggle-touchpad.sh

    #! /bin/sh
    PATH="/bin:/usr/bin:/sbin:/usr/sbin"

    # Modern method, for Linux 3.11 or later.
    sys_enable_file=/sys/devices/platform/sony-laptop/touchpad
    if [ -r "$sys_enable_file" ]; then
      read -r is_currently_enabled < "$sys_enable_file"
      echo > "$sys_enable_file" $((1 - $is_currently_enabled))
    else

    # Older method: have the X11 driver do it
      export DISPLAY=:0
      USER=`who | grep ':0' | grep -o '^\w*' | head -n1`

      if [ "$(su "$USER" -c "synclient -l" | grep TouchpadOff | awk '{print $3}')" == "0" ]; then
          su "$USER" -c "synclient TouchpadOff=1"
      else
          su "$USER" -c "synclient TouchpadOff=0"
      fi
    fi

Note:Restart acpid using systemctl after adding the files.

> Fan control

Works well out of the box. It stays quiet during normal load. Change
profile by editing thermal_control found in:

    /sys/devices/platform/sony-laptop/

Available profiles can be found in thermal_profiles in the same
directory.

> Charging

Set the maximum charge to 50/80/100% by modifying battery_charge_limiter
found in:

    /sys/devices/platform/sony-laptop/

In order for changes to take effect, it may be necessary to execute:

    echo 0 | sudo tee /sys/devices/platform/sony-laptop/battery_care_limiter

> USB ports

Some users are having issues with the usb port labeled with a lightning
bolt not working for anything but charging. This is a known issue for
many Sony laptops.

> SD card slot

Works out of the box.

> NFC

Works out of the box with neard.

> Bluetooth

Works out of the box.

> Webcam

Works out of the box.

> Internal mic

Not working for some users. A fix has been committed to the kernel in
3.12-rc5.

Summary of known issues
-----------------------

-   Haswell turbo is not supported in kernel 3.11.
-   Some users are having trouble with the internal Mic showing as
    "Unavailable" to pulse and not working. (fix is merged linux
    3.12-rc5)
-   Only one usb port fully working for some users.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sony_Vaio_Pro_SVP-1x21&oldid=306100"

Category:

-   Sony

-   This page was last modified on 20 March 2014, at 17:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
