HP Pavilion dv9510eo
====================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Wireless                                                           |
| -   3 Sound                                                              |
| -   4 Xorg                                                               |
| -   5 USB Auto Mounting                                                  |
| -   6 Other                                                              |
| -   7 Untested                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Unlike many distributions' install processes, you do not need to change
any boot parameters in order to install arch on this laptop.

Wireless
--------

In order to use wireless, install the b43-firmware package from AUR, and
add "b43" to your MODULES array in rc.conf Following the rest of the
wireless setup guide to suit my needs worked for me.

Sound
-----

when installing ALSA, add the following lines
/etc/modprobe.d/modprobe.conf

    alias snd-card-0 snd_hda_intel
    alias sount-slot-0 snd_hda_intel

For a long time I had issues with the headphone jack on this laptop: the
speaker wouldn't mute out when I inserted a headphone. Thankfully , this
seems to work flawlessly with this ALSA version.

Xorg
----

Install Xorg and the NVIDIA drivers. I had some strange issues with some
files being truncated, I do not know whether this was a problem with the
server or with my network connection, but I a similiar installation on
another laptop, so I just scp'd them over. You may or may not have these
issues. Also be sure to install the xf86-input-synaptics package.

Run nvidia-xconfig once you have the nvidia drivers installed correctly.
You might need to edit the screen section in your xorg.conf in order to
get the correct screen resolution. Note mvidia-auto-select didn't
recognize the full resolution for me, so I had to manually add
1440x1050, which is the maxx resolution.

  

    Section "Screen"
        Identifier     "Screen0"
        Device         "Device0"
        Monitor        "Monitor0"
        DefaultDepth    24
        SubSection     "Display"
            Modes       "1440x1050" "nvidia-auto-select"
            Depth       24
        EndSubSection
    EndSection

  
 See the HP Pavilion dv9500 wiki page to get the hotkeys and synaptics
touchpad working in x.

USB Auto Mounting
-----------------

I think I read somewhere that this is a problem with the new hal, that a
lot of people are having problems auto mounting their USB devices in X
since upgrading. A useful alternative which I used is to use Udev to
auto-mount your USB devices. See the section on auto mounting USB
storage devices on the Udev wiki page or copy the following configured
code.

    #/etc/udev/rules.d/10-usb.rules
    KERNEL=="sd[b-z]", NAME="%k", SYMLINK+="usbhd-%k", GROUP="users", OPTIONS="last_rule"
    ACTION=="add", KERNEL=="sd[b-z][0-9]", SYMLINK+="usbhd-%k", GROUP="users", NAME="%k"
    ACTION=="add", KERNEL=="sd[b-z][0-9]", RUN+="/bin/mkdir -p /media/usbhd-%k"
    ACTION=="add", KERNEL=="sd[b-z][0-9]", RUN+="/bin/ln -s /media/usbhd-%k /mnt/usbhd-%k"
    ACTION=="add", KERNEL=="sd[b-z][0-9]", PROGRAM=="/lib/udev/vol_id -t %N", RESULT=="vfat", RUN+="/bin/mount -t vfat -o   rw,noauto,flush,quiet,nodev,nosuid,noexec,noatime,dmask=000,fmask=111 /dev/%k /media/usbhd-%k", OPTIONS="last_rule"
    ACTION=="add", KERNEL=="sd[b-z][0-9]", RUN+="/bin/mount -t auto -o rw,noauto,sync,dirsync,noexec,nodev,noatime /dev/%k /media/usbhd-%k", OPTIONS="last_rule"
    ACTION=="remove", KERNEL=="sd[b-z][0-9]", RUN+="/bin/rm -f /mnt/usbhd-%k"
    ACTION=="remove", KERNEL=="sd[b-z][0-9]", RUN+="/bin/umount -l /media/usbhd-%k"
    ACTION=="remove", KERNEL=="sd[b-z][0-9]", RUN+="/bin/rmdir /media/usbhd-%k", OPTIONS="last_rule"

You can do the same for the SD card reader:

    #/etc/udev/rules.d/11-sd.rules
    KERNEL=="mmcblk[0-9]", NAME="%k", SYMLINK+="sd-%k", GROUP="users", OPTIONS="last_rule"
    ACTION=="add", KERNEL=="mmcblk[0-9]p[0-9]", SYMLINK+="sd-%k", GROUP="users", NAME="%k"
    ACTION=="add", KERNEL=="mmcblk[0-9]p[0-9]", RUN+="/bin/mkdir -p /media/sd-%k"
    ACTION=="add", KERNEL=="mmcblk[0-9]p[0-9]", RUN+="/bin/ln -s /media/sd-%k /mnt/sd-%k"
    ACTION=="add", KERNEL=="mmcblk[0-9]p[0-9]", PROGRAM=="/lib/udev/vol_id -t %N", RESULT=="vfat", RUN+="/bin/mount -t vfat -o rw,noauto,flush,quiet,nodev,nosuid,noexec,noatime,dmask=000,fmask=111 /dev/%k /media/sd-%k", OPTIONS="last_rule"
    ACTION=="add", KERNEL=="mmcblk[0-9]p[0-9]", RUN+="/bin/mount -t auto -o rw,noauto,sync,dirsync,noexec,nodev,noatime /dev/%k /media/sd-%k", OPTIONS="last_rule"
    ACTION=="remove", KERNEL=="mmcblk[0-9]p[0-9]", RUN+="/bin/rm -f /mnt/sd-%k"
    ACTION=="remove", KERNEL=="mmcblk[0-9]p[0-9]", RUN+="/bin/umount -l /media/sd-%k"
    ACTION=="remove", KERNEL=="mmcblk[0-9]p[0-9]", RUN+="/bin/rmdir /media/sd-%k", OPTIONS="last_rule"

Other
-----

The SD card reader works, but in X the device might not be auto-mounted.

Additionally, the IR remote seems to work out of the box also!

Untested
--------

Bluetooth, HDMI, Modem, Fingerprint reader

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_dv9510eo&oldid=196646"

Category:

-   HP
