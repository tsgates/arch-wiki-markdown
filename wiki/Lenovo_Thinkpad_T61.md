Lenovo Thinkpad T61
===================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 System Specifications                                              |
|     -   1.1 What works/What doesn't                                      |
|                                                                          |
| -   2 Pre installation notes                                             |
| -   3 Accessing the recovery partition with GRUB                         |
| -   4 Configuration                                                      |
|     -   4.1 Video Driver                                                 |
|         -   4.1.1 Intel                                                  |
|         -   4.1.2 Nvidia                                                 |
|                                                                          |
|     -   4.2 Audio                                                        |
|     -   4.3 Network                                                      |
|         -   4.3.1 Wired                                                  |
|         -   4.3.2 Wireless                                               |
|         -   4.3.3 Modem                                                  |
|                                                                          |
|     -   4.4 USB                                                          |
|     -   4.5 Bluetooth                                                    |
|     -   4.6 Trackpoint                                                   |
|     -   4.7 Touchpad                                                     |
|     -   4.8 ThinkFinger                                                  |
|     -   4.9 ACPI                                                         |
|     -   4.10 Hotswap UltraBay devices                                    |
|     -   4.11 Multimedia Keys                                             |
|     -   4.12 HDAPS                                                       |
|     -   4.13 Card Readers                                                |
|         -   4.13.1 PCMCIA                                                |
|         -   4.13.2 Compact Flash                                         |
|         -   4.13.3 Secure Digital                                        |
|                                                                          |
| -   5 Other Tweaks                                                       |
|     -   5.1 HDD clicks                                                   |
|                                                                          |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

System Specifications
---------------------

Lenovo Thinkpad T61 - Intel Centrino Pro

-   Intel(R) Core(TM)2 Duo CPU T7300 (2.00GHz, 4MB, 800MHz)
-   Mobile Intel 965GM Express Chipset
-   2GB PC2-5300/677MHz
-   80-GB 5400 rpm SATA Harddrive
-   14.1-inch color TFT WXGA+ (1440 x 900, 200 nit)
-   Intel® Graphics Media Accelerator GM965 (128MB)
-   82801H ICH8 Family HD Audio Controller
-   DVD-ROM, CD-RW/DVD Combo, Multi-Burner Plus
-   Modem; Gigabit Ethernet
-   Intel® Wireless Wi-Fi Link 4965AG
-   1 Type II PC Card slot
-   1 ExpressCard 34/54
-   Dual pointing devices (both Pointstick and Touchpad)

Output of lshwd

    00:00.0 Class 0600: Intel Corporation|Mobile Memory Controller Hub (unknown)
    00:02.0 Class 0300: Intel Corporation|Mobile Integrated Graphics Controller (vesa)
    00:02.1 Class 0380: Intel Corporation|Mobile Integrated Graphics Controller (vesa)
    00:19.0 Class 0200: Intel Corporation|Mobile Integrated Graphics Controller (unknown)
    00:1a.0 Class 0c03: Intel Corporation|USB UHCI Controller #4 (unknown)
    00:1a.1 Class 0c03: Intel Corporation|USB UHCI Controller #5 (unknown)
    00:1a.7 Class 0c03: Intel Corporation|USB2 EHCI Controller #2 (unknown)
    00:1b.0 Class 0403: Intel Corp.|ICH8 HD Audio DID (snd-hda-intel)
    00:1c.0 Class 0604: Intel Corporation|PCI Express Port 1 (unknown)
    00:1c.1 Class 0604: Intel Corporation|PCI Express Port 2 (unknown)
    00:1c.2 Class 0604: Intel Corporation|PCI Express Port 3 (unknown)
    00:1c.3 Class 0604: Intel Corporation|PCI Express Port 4 (unknown)
    00:1c.4 Class 0604: Intel Corporation|PCI Express Port 5 (unknown)
    00:1d.0 Class 0c03: Intel Corporation|USB UHCI Controller #1 (unknown)
    00:1d.1 Class 0c03: Intel Corporation|USB UHCI Controller #2 (unknown)
    00:1d.2 Class 0c03: Intel Corporation|USB UHCI Controller #3 (unknown)
    00:1d.7 Class 0c03: Intel Corporation|USB2 EHCI Controller #1 (unknown)
    00:1e.0 Class 0604: Intel Corp.|82801 Hub Interface to PCI Bridge (hw_random)
    00:1f.0 Class 0601: Intel Corporation|Mobile LPC Interface Controller (unknown)
    00:1f.2 Class 0101: Intel Corporation|Mobile SATA Controller cc=IDE (ata_piix)
    00:1f.3 Class 0c05: Intel Corporation|SMBus Controller (i2c-i801)
    03:00.0 Class 0280: Intel Corporation|SMBus Controller (unknown)
    15:00.0 Class 0607: Ricoh Co Ltd.|RL5c476 II (yenta_socket)
    15:00.1 Class 0c00: Ricoh Co Ltd.|RL5c476 II (unknown)
    15:00.2 Class 0805: Ricoh Co Ltd.|SD Card reader (unknown)
    15:00.3 Class ffff: Ricoh Co Ltd.|SD Card reader (unknown)
    15:00.4 Class 0880: Ricoh Co Ltd.|R5C592 Memory Stick Bus Host Adapter (unknown)
    15:00.5 Class 0880: Ricoh Co Ltd.|xD-Picture Card Controller (unknown)

> What works/What doesn't

Pretty much everything works on this laptop. The modem is untested.

Pre installation notes
----------------------

Remember to back up the restore partition if you plan to restore it, or
leave it.

Follow the official Archlinux install guide

Accessing the recovery partition with GRUB
------------------------------------------

Edit your /boot/grub/menu.lst file and add the following:

    # booting "Rescue and Recovery" partition from Lenovo
    title Thinkpad Maintenance
    unhide (hd0,0)
    rootnoverify (hd0,0)
    chainloader +1

Configuration
-------------

> Video Driver

Intel

The Intel® Graphics Media Accelerator GM965 uses the xf86-video-intel
driver.

    #pacman -S xf86-video-intel

The relevent kernel drivers include:

-   DRM_I915

For framebuffer graphics one of the kernel drivers:

-   intelfb
-   fb_uvesa
-   fb_vesa

Should work. It is up to you which one you wish to use. Intelfb is known
to have a few problems with hardware acceleration and requires grub2
patched with 915resolution to properly set the correct resolution.

The package grub2-915resolution in the AUR has the necessary patch to
make intelfb work with laptops that use the 965GM card.

Here is a sample /etc/X11/xorg.conf:

       Section "Module"
           Load        "dbe"   # Double buffer extension
           SubSection  "extmod"
             Option    "omit xfree86-dga"
           EndSubSection
           Load        "freetype"
           Load        "GLcore"
           Load        "glx"
           Load        "bitmap"
           Load        "dri"
    #        Load        "int10"
    #        Load        "ddc"
    #        Load        "vbe"
    #        Load        "xtrap"
       EndSection

       Section "Files"
           ModulePath "/usr/lib/xorg/modules"
           FontPath   "/usr/share/fonts/local/"
           FontPath   "/usr/share/fonts/misc/:unscaled"
           FontPath   "/usr/share/fonts/75dpi/:unscaled"
           FontPath   "/usr/share/fonts/100dpi/:unscaled"
           FontPath   "/usr/share/fonts/misc/"
           FontPath   "/usr/share/fonts/75dpi/"
           FontPath   "/usr/share/fonts/100dpi/"
           FontPath   "/usr/share/fonts/TTF/"
           FontPath   "/usr/share/fonts/Type1/"
           FontPath   "/usr/share/fonts/local/"
       EndSection

       Section "ServerFlags"
           Option      "blank time"    "3"
           Option      "standby time"  "5"
           Option      "suspend time"  "10"
           Option      "off time"      "15"
           Option      "RandR"
           Option      "AutoAddDevices" "False"
       EndSection

       Section "InputDevice"
           Identifier  "Keyboard0"
           Driver      "kbd"
           Option      "CoreKeyboard"
           Option      "XkbRules" "xorg"
           Option      "XkbModel" "thinkpad60"
           Option      "XkbLayout" "us"
       EndSection

       Section "InputDevice"
           Identifier  "UltraNav Trackpoint"
           Driver      "mouse"
           Option      "CorePointer"
           Option      "Device"              "/dev/input/mice"
           Option      "Protocol"            "ImPS/2"
           Option      "Emulate3Buttons"     "off"
           Option      "EmulateWheel"        "on"
           Option      "EmulateWheelTimeOut" "250"
           Option      "EmulateWheelButton"  "2"
           Option      "YAxisMapping"        "4 5"
           Option      "XAxisMapping"        "6 7"
           Option      "ZAxisMapping"        "4 5"
       EndSection

    #    Section "InputDevice"
    #           Identifier  "Synaptics"
    #           Driver      "synaptics"
    #           Option      "Device" "/dev/input/mice"
    #           Option      "Protocol" "auto-dev"
    #           Option      "Emulate3Buttons" "yes"
    #           Option      "SHMConfig" "on"
    #    EndSection

       Section "Monitor"
           Identifier  "Thinkpad Monitor"
           Option      "DPMS"
    #        HorizSync   31.5-50.0
    #        VertRefresh 59.9-60.1
        EndSection

       Section "Device"
           Identifier  "Intel GMA X3100"
           Driver      "intel"
           BusID       "PCI:0:2:0"
           Option      "AccelMethod"  "exa"
           Option      "MigrationHeuristic"     "greedy"
       EndSection

       Section "Screen"
           Identifier          "Thinkpad Screen"
           Device              "Intel GMA X3100"
           Monitor             "Thinkpad Monitor"
           DefaultDepth        24
           SubSection "Display"
                Depth 24
                Modes "1280x800" "1024x768"  "832x624" "800x600" "640x480" "720x400" "640x400" "640x350"
                Virtual     2048 2048
           EndSubSection
       EndSection

       Section "DRI"
           Mode        0666
       EndSection

       Section "Extensions"
           Option      "Composite"     "Enable"
           Option      "RENDER"        "Enable"
       EndSection

       Section "ServerLayout"
           Identifier  "Default Layout"
           Screen "Thinkpad Screen"
           InputDevice "UltraNav Trackpoint" "CorePointer"
    #        InputDevice "Synaptics" "CorePointer"
           InputDevice "Keyboard0" "CoreKeyboard"
       EndSection

Please note that this has the touchpad and xorg input hotplugging
disabled.

Nvidia

Follow the instructions in NVIDIA.

Note: If you're following the Beginners Guide and you're not seeing the
cursor after the NVIDIA logo, you should try the simple baseline X test.

> Audio

Sound works out of the box. The relevant module for sound is:

-   SND_HDA_INTEL

Refer to following guides to set it up:

OSS

ALSA

PulseAudio

Use whichever you wish.

> Network

Wired

The wired connection works out of the box and uses the following module:

-   e1000e

Wireless

Uses either module, varies with different setups:

-   iwl3945
-   iwl4965

Requires firmware be installed to work.

Refer to Wireless Setup for iwl3945, iwl4965 and iwl5000 series

Modem

Untested.

> USB

Works out of the box.

Following modules are used:

-   uhci_hcd
-   ehci_hcd
-   usbhid

> Bluetooth

Works out of the box.

Following modules are used:

-   bluetooth
-   btusb
-   l2cap
-   rfcomm
-   hci_usb
-   ehci-hcd
-   uhci-hcd

> Trackpoint

Works, if you want to scroll while holding the middle mouse button down
you can add the following to an .fdi file:

/etc/hal/fdi/policy/mouse-wheel.fdi:

     <match key="info.product" string="TPPS/2 IBM TrackPoint">
       <merge key="input.x11_options.EmulateWheel" type="string">true</merge>
       <merge key="input.x11_options.EmulateWheelButton" type="string">2</merge>
       <merge key="input.x11_options.YAxisMapping" type="string">4 5</merge>
       <merge key="input.x11_options.Emulate3Buttons" type="string">true</merge>
       <merge key="input.x11_options.EmulateWheelTimeout" type="string">200</merge>
     </match>

What it does is that it sets emulates wheel on button two, which is
middle button and maps in what directions it will emulate the scroll
wheel, it will at the same time emulate 3 mouse buttons.

You can read more about the new Xorg input hotplugging here

More info on configuring it can be found at thinkwiki.org.

> Touchpad

There is a synaptic touchpad on this laptop. If you follow this howto,
you should have no problems getting this to work.

The relevant kernel driver is:

-   mouse_ps2_synaptics

> ThinkFinger

Works, read ThinkFinger for reference and examples.

> ACPI

To get all the special keys working requires the module:

-   THINKPAD_ACPI

It is necessary to edit the default /etc/acpi/handler.sh included with
the acpid package to get these keys working.

    #!/bin/sh
    # Default acpi script that takes an entry for all actions, modified to include thinkpad special keys.

    # NOTE: This is a 2.6-centric script.  If you use 2.4.x, you'll have to
    #       modify it to not use /sys

    minspeed=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq`
    maxspeed=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq`
    setspeed="/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed"

    set $*

    case "$1" in
       ibm/hotkey)
       case "$2" in
           HKEY)
               case "$4" in
                   00001002) # Lock screen
                   #Enter your xlock or xscreensaver command here
                       ;;
                   00001003) # switching display off
                       xset dpms force off
                       ;;
                   00001004) # Suspend to RAM
                       /usr/sbin/pm-suspend
                       ;;
                   00001005) # Switch Bluetooth
                       ;;
                   00001007) # Toggle external display
                       if [ "$(xrandr -q | grep "VGA connected")" ]; then
                           if [ "$(xrandr -q | grep "VGA connected [0-9]")" ]; then
                               xrandr --output VGA --off
                           else
                               xrandr --output VGA --auto
                           fi
                       else
                           xrandr --output VGA --off
                       fi
                       ;;
                   #00001008) # Toggle Trackpoint/Touchpad
                   #    ;;
                   #00001009) # Eject from dock
                   #    ;;
                   0000100c) # Hibernate
                       /usr/sbin/pm-hibernate
                       ;;
                   00001011) #Brightness down
                       CUR="xbacklight -get"
                       CUR="echo $CUR | awk '{print $1-5}'"
                       xbacklight -set $CUR
                       ;;
                   00001012) #Brightness up
                       CUR=`xbacklight -get`
                       CUR="echo $CUR | awk '{print $1+5}'"
                       xbacklight -set $CUR
                       ;;
                   #00001014) # Toggle zoom
                   #    ;;
                   00001018) # ThinkVantage button
                       ;;
               esac
               ;;
       esac
       ;;
       button/power)
           #echo "PowerButton pressed!">/dev/tty5
           case "$2" in
               PWRF)   
                  logger "PowerButton pressed: $2"
                  /sbin/init 0
                  ;;
               *)      logger "ACPI action undefined: $2" ;;
           esac
           ;;
       button/sleep)
           case "$2" in
               SLPB)   /usr/sbin/pm-suspend ;;
               *)      logger "ACPI action undefined: $2" ;;
           esac
           ;;
       ac_adapter)
           case "$2" in
               AC)
                   case "$4" in
                       00000000)
                           #/etc/laptop-mode/laptop-mode start
                       ;;
                       00000001)
                           #/etc/laptop-mode/laptop-mode stop
                       ;;
                   esac
                   ;;
               *)  logger "ACPI action undefined: $2" ;;
           esac
           ;;
       battery)
           case "$2" in
               BAT0)
                   case "$4" in
                       00000000)   #echo "offline" >/dev/tty5
                       #Enter whatever power scripts you have here.
                       ;;
                       00000001)   #echo "online"  >/dev/tty5
                       #Enter whatever power scripts you may have here.
                       ;;
                   esac
                   ;;
               CPU0)	
                   ;;
               *)  logger "ACPI action undefined: $2" ;;
           esac
           ;;
       button/lid)
           #echo "LID switched!">/dev/tty5
           /usr/sbin/pm-suspend
           ;;
       *)
           logger "ACPI group/action undefined: $1 / $2"
           ;;
    esac

> Hotswap UltraBay devices

If you want to be able to eject devices from Thinkpad's UltraBay using
Fn+F9 create a scipt named for example "tp_ultrabay_eject.sh" with the
following content (source can be found at
http://www.thinkwiki.org/wiki/How_to_hotswap_Ultrabay_devices):

    #!/bin/bash

    # Change the following DEVPATH= to match your system, if you want to run this directly instead of having it called by the udev eject script
    # To find the right value, insert the UltraBay optical drive and run:
    # udevadm info --query=path --name=/dev/sr0 | perl -pe 's!/block/...$!!'
    if [ "$DEVPATH" = "" ]
    then
       DEVPATH="/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0"
    fi

    shopt -s nullglob
    export DISPLAY=:0.0 # required for notify-send
    ULTRABAY_SYSDIR=/sys$DEVPATH

    # Find generic dock interface for UltraBay
    dock=$( /bin/grep -l ata_bay /sys/devices/platform/dock.?/type )
    dock=${dock%%/type}
    if [ -n "$dock" -a -d "$dock" ]; then
            logger ultrabay_eject starting eject of $dock
    else
            logger ultrabay_eject cannot locate bay dock device
            notify-send -u critical -t 100000 "ThinkPad Ultrabay eject failed" "Cannot locate bay dock device"
    fi

    # Umount the filesystem(s) backed by the given major:minor device(s)
    unmount_rdev() { perl - "$@" <<'EOPERL'  # let's do it in Perl
            for $major_minor (@ARGV) {
                    $major_minor =~ m/^(\d+):(\d+)$/ or die;
                    push(@tgt_rdevs, ($1<<8)|$2);
            }
            # Sort by reverse length of mount point, to unmount sub-directories first
            open MOUNTS,"</proc/mounts" or die "$!";
            @mounts=sort { length($b->[1]) <=> length($a->[1]) } map { [ split ] } <MOUNTS>;
            close MOUNTS;
            foreach $m (@mounts) {
                    ($dev,$dir)=@$m;
                    next unless -b $dev;  $rdev=(stat($dev))[6];
                    next unless grep($_==$rdev, @tgt_rdevs);
                    system("umount","-v","$dir")==0  or  $bad=1;
                    if ($bad == 1) {
                            system("logger","ultrabay_eject","ERROR unmounting",$dev,$dir);
                            system("notify-send -u critical -t 100000 \"Error unmounting $dir\" \"Unmounting of $dir on $dev failed!\"");
                    } else {
                            system("logger","ultrabay_eject","unmounted",$dev,$dir);
                            system("notify-send -u normal -t 5000 \"Unmounted $dir\"");
                    };
            }
            exit 1 if $bad;
    EOPERL
    }

    # Get the UltraBay's /dev/foo block device node
    ultrabay_dev_node() {
            UDEV_PATH="`readlink -e "$ULTRABAY_SYSDIR/block/"*`" || return 1
            UDEV_NAME="`udevadm info --query=name --path=$UDEV_PATH`" || return 1
            echo /dev/$UDEV_NAME
    }

    if [ $( cat $dock/docked ) == 0 ]; then
            logger ultrabay_eject dock reports empty
    else 
    	if [ -d $ULTRABAY_SYSDIR ]; then
    		logger ultrabay_eject dock occupied, shutting down storage device $DEVPATH
    		sync
    		# Unmount filesystems backed by this device
    		## This seems to be very inelegant and prone to failure
    		unmount_rdev `cat $ULTRABAY_SYSDIR/block/*/dev     \
    				  $ULTRABAY_SYSDIR/block/*/*/dev`  \
    		|| {
    			logger ultrabay_eject umounting failed
    			echo 2 > /proc/acpi/ibm/beep  # triple error tone
    			notify-send -u critical -t 100000 "ThinkPad Ultrabay eject failed" "Please do not pull the device, doing so could cause file corruption and possibly hang the system. Unmounting of the filesystem on the ThinkPad Ultrabay device failed. Please put the eject leaver back in place, and try to unmount the filesystem manually. If this succeeds you can try the eject again"
    			exit 1;
    		}
    		sync
    		# Nicely power off the device
    		DEVNODE=`ultrabay_dev_node` && hdparm -Y $DEVNODE
    		# Let HAL+KDE notice the unmount and let the disk spin down
    		sleep 0.5
    		# Unregister this SCSI device:
    		sync
    		echo 1 > $ULTRABAY_SYSDIR/delete
    	else
    		logger ultrabay_eject bay occupied but incorrect device path $DEVPATH
    		notify-send -u critical -t 100000 "ThinkPad Ultrabay eject failed" "Bay occupied but incorrect device path"
    		echo 2 > /proc/acpi/ibm/beep  # triple error tone
    		exit 1
    	fi
    fi

    # We need sleep here so someone can disconnect the bay and the drive
    sleep 1

    # Turn off power to the UltraBay
    logger ultrabay_eject undocking $dock
    echo 1 > $dock/undock

    # Tell the user we're OK
    logger ultrabay_eject done
    echo 12 > /proc/acpi/ibm/beep
    notify-send -u normal -t 10000 "Safe to remove device" "The ThinkPad Ultrabay device can now safely be removed"

As stated at the top of the script, the variable "DEVPATH" (near the top
of the script) has to be changed to match your system. Insert the
UltraBay optical drive and run:

    udevadm info --query=path --name=/dev/sr0 | perl -pe 's!/block/...$!!'

Replace the value of "DEVPATH" with the output of that command.

Now change ownership and permissions of the script:

    chown root:root tp_ultrabay_eject.sh
    chmod 555 tp_ultrabay_eject.sh

Move it somewhere save and add it to your /etc/acpi/handler.sh (under
section "ibm/hotkey)"):

                  00001009) # Eject from dock
                      DISPLAY=:0.0 /path/to/tp_ultrabay_eject.sh
                      ;;

"DISPLAY=:0.0" is necessary to tell X where to send notifications to.

Now, pressing Fn+F9 unmounts the relevant filesystems, powers off the
UltraBay and notifies you (using notify-send) about whats happening. If
a filesystem can't be unmounted you get a warning message.

It is also possible to achieve the above by just releasing the UltraBay
eject lever (without pressing Fn+F9 before). Consult
http://www.thinkwiki.org/wiki/How_to_hotswap_Ultrabay_devices for
detailed instructions on how to get it working.

> Multimedia Keys

Now it is necessary to install xmodmap and xbindkeys via pacman for the
multimedia keys. Now create a file at ~/.Xmodmap

    keycode 234 = XF86Back
    keycode 233 = XF86Forward
    keycode 144 = XF86AudioPrev
    keycode 164 = XF86AudioStop
    keycode 162 = XF86AudioPlay
    keycode 153 = XF86AudioNext
    keycode 160 = XF86AudioMute
    keycode 174 = XF86AudioLowerVolume
    keycode 176 = XF86AudioRaiseVolume

Note: The keycode numbers may be different than these (they are on my
T61.) Also, new versions of the X server may already give your
multimedia keys the correct name, and if so you do not need to make a
.Xmodmap file. To check this, run "xev" and press your volume keys to
see what keycodes and keysyms it gives.

Once you know X gives your keys the right names, you can set up the
shortcuts to run the amixer or mpc commands. You can do this in your
window manager/desktop environment's key settings, or using xbindkeys by
making a ~/.xbindkeysrc like this one:

       "mpc toggle"
       XF86AudioPlay

       "mpc stop"
       XF86AudioStop

       "mpc prev"
       XF86AudioPrev

       "mpc next"
       XF86AudioNext

       "amixer sset PCM 2-"
       XF86AudioLowerVolume

       "amixer sset PCM 2+"
       XF86AudioRaiseVolume

       "amixer sset PCM toggle"
       XF86AudioMute

Make sure you start the xbindkeys daemon! To start the daemon on
startup, just add it to your ~/.xinitrc.

> HDAPS

To get the hard drive APS working, it is neccessary to have a kernel
patched with the tp_smapi patches. Both the packages:

-   kernel26tp
-   kernel26zen-git

Provide the needed module (in addition to many other useful patches.)
Install either one, though it is reccomended that you try the
kernel26zen-git package. Read Kernel Compilation with ABS, Custom Kernel
Compilation with ABS, and Kernel Compilation From Source for more info.

Now all that is required is the hdapsd daemon. This can be had from the
AUR package hdapsd.

> Card Readers

PCMCIA

Works as expected. Uses the module:

-   yenta

Compact Flash

The same goes for the Compact Flash. It's supposed to work as it uses
the same interfaces as the PCMCIA does, but I can't confirm anything
since I do not have a CF-card.

Secure Digital

The SD-card reader works out of the box with SD cards.

Other Tweaks
------------

> HDD clicks

    # pacman -S hdparm

Put following line to /etc/rc.local (replace /dev/sda with other device
if needed):

    hdparm -B 244 /dev/sda

Details: http://www.thinkwiki.org/wiki/Problem_with_hard_drive_clicking

See also
--------

-   http://www.thinkwiki.org/wiki/ThinkWiki
-   This report is listed at the TuxMobil: Linux Laptop and Notebook
    Installation Guides Survey: Fujitsu-Siemens - FSC.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_Thinkpad_T61&oldid=238897"

Category:

-   Lenovo
