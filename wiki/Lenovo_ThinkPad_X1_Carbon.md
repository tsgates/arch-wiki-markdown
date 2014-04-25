Lenovo ThinkPad X1 Carbon
=========================

Contents
--------

-   1 Model description
    -   1.1 Legacy-BIOS
    -   1.2 UEFI
-   2 Hardware
    -   2.1 Audio
    -   2.2 Network
        -   2.2.1 Wired
        -   2.2.2 Wireless
    -   2.3 Touchscreen
    -   2.4 Video
        -   2.4.1 Brightness control
        -   2.4.2 EDID bug
    -   2.5 KMS
    -   2.6 Webcam
    -   2.7 Fingerprint Reader
    -   2.8 WWAN (Mobile broadband)
    -   2.9 GPS
    -   2.10 Keyboard backlight
    -   2.11 Bluetooth
-   3 Other hardware
    -   3.1 Docking

Model description
-----------------

Lenovo ThinkPad X1 Carbon (X1C). There is also a touch version. Comes
without optical drive. Has UEFI BIOS with BIOS-legacy fallback mode.

Tip: A great resource for thinkpads is
http://www.thinkwiki.org/wiki/ThinkWiki

> Legacy-BIOS

This procedure is far less involved than UEFI and works perfectly.

In order to turn off UEFI booting you will need to boot into your BIOS
and change the boot mode to Legacy. Afterward, follow the Beginners'
guide for standard installation instructions.

> UEFI

Use archboot to install or see
https://bbs.archlinux.org/viewtopic.php?pid=1288500#p1288500

1. You follow the guide from here and skip the part about errors and
refind: Create_UEFI_bootable_USB_from_ISO

2. Make sure you USB is mounted to /boot/efi and install grub, like so:

    $ grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --boot-directory=/boot/efi/ --recheck --debug

OBS: You can remove the entry from your EFI bootmanger, with efibootmgr
by issuing:

    $ efibootmgr -b XX -B

3. Now you can choose if you wanna hack you grub.cfg or use the custom
config in grub.d. Either way generate the grub.cfg:

    $ grub-mkconfig -o /boot/efi/grub/grub.cfg

4. Make certain appropriate changes have been made to grub.cfg. My
working example, which could use cleaning:

    /etc/grub.d/10_linux

    ### BEGIN /etc/grub.d/10_linux ###
    menuentry 'Arch Linux test'  {
    	load_video
    	set gfxpayload=keep
    	insmod gzio
    	insmod part_gpt
    	insmod ext2
    	set root='hd0,gpt1'
    	if [ x$feature_platform_search_hint = xy ]; then
    	  search --no-floppy --fs-uuid --set=root --hint-bios=hd0,gpt1 --hint-efi=hd0,gpt1  B35D-FE34
    	else
    	  search --no-floppy --fs-uuid --set=root B35D-FE34
    	fi
    	echo	'Loading Linux core repo kernel ...'
    	linux	/arch/boot/x86_64/vmlinuz root=UUID=B35D-FE34 ro  archisobasedir=arch archisolabel=ARCH_201306
    	echo	'Loading initial ramdisk ...'
    	initrd	/arch/boot/x86_64/archiso.img
    }


    ### END /etc/grub.d/10_linux ###

5. Move the grub.efi to overwrite the archiso supplied one (which btw
works on my desktop. I guess GRUB includes more workarounds for buggy
firmware from manufactureres. See this video, if you have time:
http://mjg59.dreamwidth.org/10014.html

    $ mv /boot/efi/EFI/arch_grub/grubx64.efi /mnt/efi/EFI/boot/bootx64.efi

Success. Somethings are implied, like GPT partitiontable etc.

Hardware
--------

Almost everything works out of the box.

> Audio

Sound works out of the box.

> Network

Wired

Comes with USB->Ethernet plug. Works out of the box.

Wireless

Works out of the box. Uses the following module

-   iwlwifi

* * * * *

lspci output: Network controller: Intel Corporation Centrino Advanced-N
6205 [Taylor Peak] (rev 96)

> Touchscreen

Works out of the box. Haven't looked for possibilities to configure
multi-touch.

> Video

The video card installed is Intel HD Graphics 4000. See intel for more
info.

Install the video driver with pacman -S xf86-video-intel

Brightness control

Default brightness adjustment keys work but need to be pressed multiple
times to increase/decrease the screen brightness. Writing your own acpi
handlers for those buttons seems to have no effect. In order to use it
properly you need to append a new kernel parameter and make new grub
config. Make sure to escape double quotes.

    /etc/default/grub

    GRUB_CMDLINE_LINUX_DEFAULT="acpi_osi=\"!Windows 2012\""

    sudo grub-mkconfig -o /boot/grub/grub.cfg

Read more about why it's necessary at Backlight#ACPI

Some depending on their desktop environment may lack granularity while
changing brightness. This is due to the DE (e.g. gnome-settings-daemon)
along with the internal graphics module changing the brightness when
brightness adjustment keys are pressed causing multiple steps per press.
To work around this one can add the following to their boot parameters:

    video.brightness_switch_enabled=0

EDID bug

Note:Update: This is due to the use of a mini-DP->VGA-adapter. Tested
without bugs with a mini-DP->DP-cable.

  
 There is a bug getting EDID for the external screen when connected at
bootup.

I get this error message

    [ 93.736330] [drm:intel_dp_i2c_aux_ch] *ERROR* too many retries, giving up

If external screen is connected after bootup everything works fine.

I had to manually add a modeline and set the preferred resolution with
this script.

    /usr/local/bin/dp-output

    # Monitor setup
    EXTERNAL_OUTPUT="DP1"
    INTERNAL_OUTPUT="LVDS1"

    xrandr |grep $EXTERNAL_OUTPUT | grep " connected " | if [ $? -eq 0 ]; then
            xrandr --newmode 1920x1200_60 154 1920 1968 2000 2080 1200 1203 1209 1235 -hsync +vsync
            xrandr --addmode DP1 1920x1200_60
            xrandr --output $INTERNAL_OUTPUT --off --output $EXTERNAL_OUTPUT --mode 1920x1200_60
    fi

And add the script to startup at X-session start. Since I use slim it`s
done with this setting in slim.conf

    /etc/slim.conf

    sessionstart_cmd dp-output

> KMS

Get KMS working by adding i915 to the modules line

    /etc/mkinitcpio.conf

    MODULES="i915"

    $ mkinitcpio -p linux

You also have to enable VT in BIOS.

> Webcam

Works out of the box. Tested with guvcview

> Fingerprint Reader

fingerprint-gui from the AUR is already patched to work with the X1's
newer fingerprint reader. To get the gui's dropdown to recognize your
device, you'll have to add your user to the plugdev group:

    $ gpasswd -a <username> plugdev

See fingerprint-gui for more information about config

* * * * *

lsusb output: 147e:2020 Upek TouchChip Fingerprint Coprocessor (WBF
advanced mode)

> WWAN (Mobile broadband)

This model includes a Ericsson H5321gw adapter that can be used as a
mobile broadband adapter and GPS.

The SIM-card must be inserted in the back of the laptop.

Add text to the following file and reboot

    /etc/modprobe.d/avoid-mbib.conf

    options cdc_ncm prefer_mbim=N

Tested OK with networkmanager with modemmanager installed

* * * * *

lsusb output: 0bdb:1926 Ericsson Business Mobile Networks BV

> GPS

Install gpsd from extra and mbm-gpsd-git from AUR. Add this to the
following file

    /etc/udev/rules.d/99-mbm.rules

    ATTRS{idVendor}=="0bdb", ATTRS{idProduct}=="1926", ENV{ID_USB_INTERFACE_NUM}=="09", ENV{MBM_CAPABILITY}="gps_nmea"
    ATTRS{idVendor}=="0bdb", ATTRS{idProduct}=="1926", ENV{ID_USB_INTERFACE_NUM}=="03", ENV{MBM_CAPABILITY}="gps_ctrl"

Reboot to reload udev rules.

Run sudo mbm-gpsd

See if there's GPS-output cat /dev/gps0

Run sudo gpsd -b -N /dev/gps0

To test it xgps

Or use e.g. foxtrotgps in AUR.

See this link for more info.

* * * * *

lsusb output: 0bdb:1926 Ericsson Business Mobile Networks BV

> Keyboard backlight

Works out of the box. Use FN+Space

> Bluetooth

Works out of the box. Test with:

    $ systemctl start bluetooth
    $ bluetoothctl

    [bluetooth]# power on

Other hardware
--------------

> Docking

This model comes without a docking port.

Since the video for USB 3 Docking Stations currently isn't supported[1],
I had to go for USB Port Replicator with Digital Video (USB 2.0)

This works:

-   USB-devices connected to dock
-   Audio
-   Microphone
-   Ethernet
-   Video (follow DisplayLink guide)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_X1_Carbon&oldid=301071"

Category:

-   Lenovo

-   This page was last modified on 24 February 2014, at 08:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
