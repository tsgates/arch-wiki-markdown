UMID SE
=======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This guide assumes that you are experienced in installing Archlinux. If
you are not experienced, please read this guide in parallel with the
Beginners' guide or the Installation guide. No assumptions are made on
your desired environment (DE/WM). Note that the SSD will completely be
wiped if you follow this guide without alterations.

Contents
--------

-   1 Installing Archlinux
    -   1.1 SSD partitining
    -   1.2 Running the installer
    -   1.3 Installing the bootloader
-   2 Configuring the system
    -   2.1 Power saving and thermal monitoring
    -   2.2 Graphics driver
    -   2.3 X
    -   2.4 Screen brightness
    -   2.5 Touchscreen
    -   2.6 Optical mouse
    -   2.7 Keyboard
        -   2.7.1 Special keys
        -   2.7.2 Capacitive stripe
    -   2.8 Suspend and hibernation
    -   2.9 Webcam
-   3 Additional Information
    -   3.1 BIOS password recovery

Installing Archlinux
--------------------

> SSD partitining

You'll also need to manually format the SSD before using the installer.
Install GPT tools from gptfdisk as described in the SSD Article. This
ensures that your partitions are properly aligned. Run it:

    gdisk /dev/sda

Type o to clear out the partition table and then create at least 3
partitions by typing n and answering the questions (type ? or m for
help). You need at least a 2MiB Partition at the beginning for the boot
loader as well as a bit more than 1GiB of swap space to be able to use
hibernation. Your partition table should look something like this in the
end (for example using 8GiB for / and the rest for /home :

    Number  Start (sector)    End (sector)  Size       Code  Name
      1            2048            6143   2.0 MiB     EF02  BIOS boot partition
      2            6144         2463743   1.2 GiB     8200  Linux swap
      3         2463744        19240959   8.0 GiB     8300  Linux filesystem
      4        19240960        61865950   20.3 GiB    8300  Linux filesystem

Type w to write the partition table. Note that the SSD doesn't seem to
support TRIM. Make sure to leave plenty of free space on each partition
so you don't run into performance issues.

> Running the installer

Progress through the installer as usual, but mind these things:

-   When configuring the hard drive, select to configure the mountpoints
    manually and choose the mountpoints accordingly. Regarding
    filesystems, you can select ext2 for the BIOS boot partition. For
    the root and any other regular partitions ext4 is a good choice.
-   You absolutely have to select wireless-tools from core to be
    installed in order to be able to connect to the wifi network in your
    freshly installed system. You may also want to select netctl.
-   When editing the config files, edit /etc/fstab and add the
    noatime,nodiratime,discard options to your ext4 partitions. Also
    remove disable network daemon.
-   Skip the bootloader installation, exit the installer but do not
    reboot!

> Installing the bootloader

After exiting the installer, do this while still running from the
install medium. Prepare the environment:

    # cp /etc/resolv.conf /tmp/install/etc/resolv.conf
    # modprobe dm-mod
    # mount -o bind /dev /mnt/dev
    # mount -t proc /proc /mnt/proc/
    # mount -t sysfs /sys /mnt/sys/

Chroot into your fresh installation:

    # chroot /mnt bash

Install GRUB:

    # pacman-db-upgrade
    # pacman -Syy
    # rm -rf /boot/grub
    # pacman -S grub2-bios
    # grub-install --directory=/usr/lib/grub/i386-pc --target=i386-pc --boot-directory=/boot --recheck --debug /dev/sda
    # grub-mkconfig -o /boot/grub/grub.cfg

Now you're ready to reboot!

Configuring the system
----------------------

> Power saving and thermal monitoring

The UMID SE can get quite hot because of the relatively powerful CPU and
lack of air flow. This happens especially when charging the batteries.
Keep an eye on the thermals at all times. Refer to dzen for an example
on how to do this efficiently. Enable cpu scaling, configure the thermal
sensor and enable all power saving options as follows:

See power saving.

> Graphics driver

There are several drivers and they're all terrible. The probably best
option at the time of writing is the pbs_gfx driver used with fbdev. The
performance (for playing videos for example) will nevertheless be awful
but it works well for regular work. Install it as follows: Add psb_gfx
to MODULES in /etc/mkinitcpio.conf and rebuild the kernel initramfs:

    # mkinitcpio -p linux

Install the xf86-video-fbdev driver.

You should now be able to install and run X.

> X

Install Xorg and whatever DE/WM you want to use. You don't need any
xorg.conf yet. Launch X.

> Screen brightness

The psb_gfx driver allows for easy brightness settings via
/sys/class/backlight/psb-bl/brightness. Just echo a value between 0 and
100 to that file and the brightness will be set. Here's a suitable
script for changing the brightness using keyboard shortcuts.

    #!/bin/sh
    #increase or decrease the brightness by about 10%
    current="$(cat /sys/class/backlight/psb-bl/brightness)"
    if [[ "$1" == "up" ]]; then
            current=$((current+((current/10+1))))
            [[ $current -ge 100 ]] && current=100
    elif [[ "$1" == "down" ]]; then
            current=$((current-((current/10+1))))
    else
            echo "1st argument should be 'up' or 'down'"
            exit 1
    fi
    echo "$current" > /sys/class/backlight/psb-bl/brightness

Place it in /usr/local/bin or similar, allow it to be run by regular
users using visudo and then you can bind it to the brightnes key combo
on your keyboard by whatever means, for example through your WM. You may
want to write the new value to a file and reload it upon boot-up or you
can just set it to a default upon boot-up by adding this to a systemd
tmpfile:

    w /sys/class/backlight/psb-bl/brightness - - - - 40

> Touchscreen

At the time of writing, the touchscreen works out of the box as a
relative "touch-pad-like" pointer device. After some correspondence with
EETI, the following can be said:

-   The official "eGalax Touch driver" 3.06.5625 from EETI does only
    work up until xorg 1.8.
-   The newer "eGTouch daemon driver" does not support the PS/2
    interface used in the UMID SE.
-   I have been given an update driver via email but I cannot disclose
    it at this time. Feel free to contact EETI through the email address
    mentioned at EETI and ask for the updated egalax_drv.so for Xorg
    1.11.

When you have the updated egalax_drv.so, do the following. Add this to a
systemd tmpfile, enabling raw access to the device at /dev/serio_raw0:

    w /sys/bus/serio/devices/serio1/drvctl - - - - serio_raw

The following kernel options must supposedly be enabled by adding them
in /etc/default/grub:

    GRUB_CMDLINE_LINUX_DEFAULT="quiet i8042.nomux=1 i8042.noloop=1"

Install the 3.06.5625 driver via AUR by editing the PKGBUILD for
xf86-input-egalax-beta, updating the Version to 3.06.5625 and the source
URL to

    http://home.eeti.com.tw/web20/drivers/touch_driver/Linux/20110831/eGalaxTouch-3.06.5625-32b-k26.tar.gz

Run the PKGBUILD and install the package. Then copy over the updated
egalax_drv.so overwriting the outdated one:

    cp ./egalax_drv.so /usr/lib/xorg/modules/input/

Use the following /etc/X11/xorg.conf

    Section "InputDevice"
        Identifier "EETI"
        Driver "egalax"
        Option "Device" "/dev/serio_raw0"
        Option "Parameters" "/var/lib/eeti.param"
        Option "ScreenNo" "0"
    EndSection

    Section "ServerLayout"
        Identifier "Default Layout"
        InputDevice "EETI" "SendCoreEvents"
    EndSection

Reboot. You can now run TKCal to calibrate your touchscreen and it
should work as a proper absolute pointing device.

> Optical mouse

Not working. A bug has been filed at the Kernel bug tracker.

> Keyboard

Special keys

Create a file /lib/udev/keymaps/umid-se containing:

    0xEE battery           # Fn+Q
    0xDF sleep             # Fn+W
    0xD5 switchvideomode   # Fn+E
    0xF0 record            # Fn+R
    0xF6 camera            # Fn+T
    0xF9 brightnessdown    # Fn+A
    0xF8 brightnessup      # Fn+S
    0xA0 mute              # Fn+D
    0xAE volumedown        # Fn+F
    0xB0 volumeup          # Fn+G
    0xFC wlan              # Fn+J

Edit /lib/udev/rules.d/95-keymap.rules adding this after
LABEL="keyboard_vendorcheck":

    ENV{DMI_VENDOR}=="UMiDCorp", ATTR{[dmi/id]product_name}=="M-BOOK", RUN+="keymap $name umid-se"

The above vendor and product IDs can be found under /sys/class/dmi/id/*.
The codes themselves are written to dmesg when hitting the keys. Reboot
to apply the changes.

Capacitive stripe

The UMID SE comes with a capacitive touch area above the keyboard (where
the grey dots are). Input is given as keycodes. This is relatively
useless and also litters dmesg with warnings about unknown scan codes.
To remedy this, you can append this to /lib/udev/keymaps/umid-se as
pointed out above:

    0x75 prog1
    0xF5 prog1
    0x6F prog1
    0xDA prog1
    0x5A prog1
    0x62 prog1
    0xD9 prog1
    0xE0 prog1
    0xE2 prog1
    0xEF prog1
    0x59 prog1

This will associate the whole general area with the XF86Launch1 keycode.
You can now use the area as a hotkey like any other key. It's quite
sensible though and may fire unintentionally, which is why it best left
unused.

> Suspend and hibernation

Should work in theory when using the psb_gfx driver for Poulsbo and
using pm-suspend. Doesn't seem to work yet. TODO

> Webcam

Doesn't seem to be even connected. Not visible at all. Probably needs to
be enabled by some sort of kill switch instruction. TODO

Additional Information
----------------------

> BIOS password recovery

The AMI BIOS of the UMID SE can be read out and decrypted using cmospwd
which is in AUR.

Retrieved from
"https://wiki.archlinux.org/index.php?title=UMID_SE&oldid=298268"

Category:

-   Laptops

-   This page was last modified on 16 February 2014, at 07:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
