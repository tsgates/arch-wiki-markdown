Toshiba Satellite L775D S7340
=============================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 Troubleshooting                                                    |
|     -   2.1 Touchpad and keyboard are not working                        |
|     -   2.2 Graphics                                                     |
|     -   2.3 Audio                                                        |
|     -   2.4 Webcam                                                       |
|     -   2.5 Hibernate/Suspend                                            |
+--------------------------------------------------------------------------+

Hardware
--------

    # lspci

    00:00.0 Host bridge: Advanced Micro Devices [AMD] Device 1705
    00:01.0 VGA compatible controller: ATI Technologies Inc Device 9647
    00:01.1 Audio device: ATI Technologies Inc Device 1714
    00:02.0 PCI bridge: Advanced Micro Devices [AMD] Device 1707
    00:11.0 SATA controller: Advanced Micro Devices [AMD] Hudson SATA Controller [AHCI mode] (rev 40)
    00:12.0 USB Controller: Advanced Micro Devices [AMD] Hudson USB OHCI Controller (rev 11)
    00:12.2 USB Controller: Advanced Micro Devices [AMD] Hudson USB EHCI Controller (rev 11)
    00:13.0 USB Controller: Advanced Micro Devices [AMD] Hudson USB OHCI Controller (rev 11)
    00:13.2 USB Controller: Advanced Micro Devices [AMD] Hudson USB EHCI Controller (rev 11)
    00:14.0 SMBus: Advanced Micro Devices [AMD] Hudson SMBus Controller (rev 13)
    00:14.1 IDE interface: Advanced Micro Devices [AMD] Hudson IDE Controller
    00:14.2 Audio device: Advanced Micro Devices [AMD] Hudson Azalia Controller (rev 01)
    00:14.3 ISA bridge: Advanced Micro Devices [AMD] Hudson LPC Bridge (rev 11)
    00:14.4 PCI bridge: Advanced Micro Devices [AMD] Hudson PCI Bridge (rev 40)
    00:15.0 PCI bridge: Advanced Micro Devices [AMD] Device 43a0
    00:15.1 PCI bridge: Advanced Micro Devices [AMD] Device 43a1
    00:15.2 PCI bridge: Advanced Micro Devices [AMD] Device 43a2
    00:16.0 USB Controller: Advanced Micro Devices [AMD] Hudson USB OHCI Controller (rev 11)
    00:16.2 USB Controller: Advanced Micro Devices [AMD] Hudson USB EHCI Controller (rev 11)
    00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 0 (rev 43)
    00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 1
    00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 2
    00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 3
    00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 4
    00:18.5 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 6
    00:18.6 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 5
    00:18.7 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 7
    04:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter (rev 01)
    05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 05) 

    # lsusb

    Bus 002 Device 002: ID 04f2:b289 Chicony Electronics Co., Ltd 
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 003 Device 002: ID 05ac:1293 Apple, Inc. iPod Touch 2.Gen
    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Troubleshooting
---------------

> Touchpad and keyboard are not working

The solution is to add i8042.nomux=1 i8042.reset to the end of the
kernel line of the grub menu config at /boot/grub/menu.lst.

Example:

    # (0) Arch Linux
    title  Arch Linux
    root   (hd0,2)
    kernel /boot/vmlinuz-linux root=/dev/sda3 ro i8042.nomux=1 i8042.reset nomodeset quiet vga=0
    initrd /boot/initramfs-linux.img

> Graphics

This model has the a6-3400m apu with an integrated radeon HD 6520g. This
is problematic during the livecd install. If you do not hit tab at the
arch boot screen and add "radeon.modeset=0" to the kernel line, you will
end up with a black screen. After install, use the proprietary Catalyst
driver if you want to make best use of the 3D support. As of 1/26/2012,
the opensource driver has support for the gpu. The 2D support is better,
especially for KDE effects. Under Catalyst, having parts of the plasma
desktop become unresponsive for the entirety of the session, even after
restart, is a known bug. Also, for sleep to work under catalyst, you
must add the nomodeset and vga=0 options to grub, as shown above. This
isn't required for the opensource driver. Sleep works more smoothly, and
the console can use framebuffer support with KMS. For a smoother
experience, xf86-video-ati is a better choice, but for opencl and better
gaming support use catalyst.

> Audio

Alsa does not work. The central speaker, PCM, won't show up under alsa
until pulseaudio is installed. Pulseaudio works perfectly with the audio
system, even enabling mic input without a hitch. If you hear no sound,
don't panic. Pulseaudio in later versions will automatically set the
hmdi port as the default audio output. The solution is to go in and
change the sound output on a single application that should be playing
sound to the non-hdmi card. Pulseaudio learns quickly.

Vlc and skype have a known problem with pulseaudio on this soundcard.
The scheduling leads to a "crackling" noise. To fix this,

Try adding tsched=0 to the load-module module-udev-detect line in
/etc/pulse/default.pa so it reads:

     load-module module-udev-detect tsched=0

All credit to heftig in the forums.

> Webcam

It is a v4l2 webcam, works perfectly.

> Hibernate/Suspend

There is a problem in which trying to sleep will cause a black screen,
followed by flickers which persist until an acpi poweroff. Upon booting,
the laptop will not make it to the bios until the battery and charger
are removed. The fix for this is documented at
http://thecodecentral.com/2011/01/18/fix-ubuntu-10-10-suspendhibernate-not-working-bug

Step 1: Create a file at /etc/pm/sleep.d/20_custom-ehci_hcd, with the
following code:

    #!/bin/sh
    #inspired by http://art.ubuntuforums.org/showpost.php?p=9744970&postcount=19
    #...and http://thecodecentral.com/2011/01/18/fix-ubuntu-10-10-suspendhibernate-not-working-bug    
    # tidied by tqzzaa :)

    VERSION=1.1
    DEV_LIST=/tmp/usb-dev-list
    DRIVERS_DIR=/sys/bus/pci/drivers
    DRIVERS="ehci xhci" # ehci_hcd, xhci_hcd
    HEX="[[:xdigit:]]"
    MAX_BIND_ATTEMPTS=2
    BIND_WAIT=0.1

    unbindDev() {
      echo -n > $DEV_LIST 2>/dev/null
      for driver in $DRIVERS; do
        DDIR=$DRIVERS_DIR/${driver}_hcd
        for dev in `ls $DDIR 2>/dev/null | egrep "^$HEX+:$HEX+:$HEX"`; do
          echo -n "$dev" > $DDIR/unbind
          echo "$driver $dev" >> $DEV_LIST
        done
      done
    }

    bindDev() {
      if [ -s $DEV_LIST ]; then
        while read driver dev; do
          DDIR=$DRIVERS_DIR/${driver}_hcd
          while [ $((MAX_BIND_ATTEMPTS)) -gt 0 ]; do
              echo -n "$dev" > $DDIR/bind
              if [ ! -L "$DDIR/$dev" ]; then
                sleep $BIND_WAIT
              else
                break
              fi
              MAX_BIND_ATTEMPTS=$((MAX_BIND_ATTEMPTS-1))
          done  
        done < $DEV_LIST
      fi
      rm $DEV_LIST 2>/dev/null
    }

    case "$1" in
      hibernate|suspend) unbindDev;;
      resume|thaw)       bindDev;;
    esac

Step 2: Make this file executable with this command:

sudo chmod 755 /etc/pm/sleep.d/20_custom-ehci_hcd

Step 3: Enjoy. The screen still flickers, but the laptop goes into
proper sleep.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Toshiba_Satellite_L775D_S7340&oldid=207187"

Category:

-   Toshiba
