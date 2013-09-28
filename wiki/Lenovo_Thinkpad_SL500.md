Lenovo Thinkpad SL500
=====================

The support for this laptop is not as bad as it first seems. In fact,
pretty much everything works fine. I am very happy with this machine!

While this guide if for the Thinkpad SL500, the steps should be easily
applicable to the SL300 and SL400 models.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Wireless                                                           |
| -   3 Sound                                                              |
| -   4 lenovo-sl-laptop Kernel Module                                     |
|     -   4.1 Configuration                                                |
|     -   4.2 Building Manually                                            |
|                                                                          |
| -   5 USB and SD auto mounting                                           |
| -   6 xD-Picture Card                                                    |
| -   7 Other notes                                                        |
| -   8 Untested                                                           |
| -   9 Power management                                                   |
|     -   9.1 Modules array                                                |
|     -   9.2 /etc/rc.local                                                |
|     -   9.3 /etc/acpid/handler.sh                                        |
|     -   9.4 /etc/pm/sleep.d/60rc.local                                   |
|     -   9.5 /path/to/powermanagement.sh                                  |
|                                                                          |
| -   10 References                                                        |
+--------------------------------------------------------------------------+

Introduction
------------

Despite the Thinkpad name, the SL series laptops actually contain
IdeaPad firmware, making it incompatible with the thinkpad_acpi modules.
A new module, lenovo-sl-laptop has been written to expose most of the
lost functionality. Thinkwiki has a page for the SL series with good
general information and howtos.

Wireless
--------

There are two possible wireless chipsets: Intel WiFi Link 5100 or a
Atheros AR5007EG.

With the Intel WiFi Link 5100 series all functionality is supported out
of the box. Follow the wireless setup guide for further information.

Sound
-----

The sound card is supported in the kernel, and following the
instructions in the Beginner's guide and also the ALSA guide should be
sufficient to get sound working.

lenovo-sl-laptop Kernel Module
------------------------------

This modules is no longer required in 2.6.32 for most hotkey support;
the mainline asus-laptop module has been patched to support these
models. However, some features still require the lenovo-sl-laptop. Check
the git commit for clarification. Note that it's recommened to blacklist
the asus-laptop module when the lenovo-sl-laptop module is used to avoid
problems with hotkey support.

This experimental kernel module was written to control bluetooth,
hotkeys, fan, and screen brightness in place of the incompatible
thinkpad_acpi module. A package is currently available in the AUR. After
installation, be sure to load the module, and to load on startup, add
lenovo-sl-laptop to the MODULES array in rc.conf.

Despite it's experimental status, it works quite well. Sadly, there is
no support for the HDAPS.

Configuration

To allow control of the backlight, first edit
/etc/modprobe.d/modprobe.conf as follows:

    options lenovo-sl-laptop control_backlight=1

Then turn off ACPI control of the backlight by performing the command on
startup.

    echo 0 > /sys/module/video/parameters/brightness_switch_enabled

A preferable alternative is to add the following to your kernel boot
line to do so on startup.

    acpi_backlight=vendor

Building Manually

Instead of installing the AUR package, the module can built manually
from source.

To do so, first obtain the source from here and perform the following

    make
    sudo install -m=644 -D lenovo-sl-laptop.ko /lib/modules/`uname -r`/kernel/lenovo_sl_laptop/lenovo-sl-laptop.ko
    depmod -a
    modprobe lenovo-sl-laptop control_backlight=1

The bluetooth light on the front of your laptop should turn on.

Finally, add lenovo-sl-laptop to your MODULES array in your rc.conf.

USB and SD auto mounting
------------------------

Check out the Udev rules for automounting USB and sd cards, very handy.

xD-Picture Card
---------------

In order to be able to access a xd-Picture card one has to enable the
following two modules. This will enable the card to be mounted as a
block device with the proper file system, recognised by device managers
such as tunar-volman.

    $ modprobe r852 ssfdc

Other notes
-----------

The SD card reader seems a bit buggy.

Untested
--------

Fingerprint reader, Bluetooth, Modem.

Power management
----------------

This section covers tools and settings which help to establish a
suitable power management to reduce power consumption and determine the
optimal settings depending on the AC state. This is particularly useful
for systems which use window managers rather than desktop environments
and their power management.

> Modules array

There are certain modules to be enabled in /etc/rc.conf in order to have
a proper working power management.

    MODULES=(lenovo-sl-laptop asus-laptop acpi-cpufreq cpufreq_powersave)

> /etc/rc.local

The /etc/rc.local enables fan control which requires the
lenovo-sl-laptop module from AUR to be installed. Furthermore there must
be entered the right path to the powermanagement.sh script.

    #!/bin/bash
    #
    # /etc/rc.local: Local multi-user startup script.
    #

    # Enable fan control
    # The following if statement is necessary because the folder containing the fan control changes between hwmon1 and hwmon0 from time to time
    fanDirectory="/sys/devices/platform/lenovo-sl-laptop/hwmon/hwmon1"

    if [ -d $fanDirectory ]; then
     	 echo 1 > /sys/devices/platform/lenovo-sl-laptop/hwmon/hwmon1/pwm1_enable
    	 echo 70 > /sys/devices/platform/lenovo-sl-laptop/hwmon/hwmon1/pwm1

    else
     
    	 echo 1 > /sys/devices/platform/lenovo-sl-laptop/hwmon/hwmon0/pwm1_enable
            echo 70 > /sys/devices/platform/lenovo-sl-laptop/hwmon/hwmon0/pwm1
    	
    fi


    # Set settings according to AC state
    exec /path/to/powermanagement.sh

> /etc/acpid/handler.sh

The Acpid daemon is a very handy tool which listens for Acpi changes.
However getting it to work with the Lenovo SL500 is not able by default
as this laptop listens on different acpi signals. The following
handler.sh changes the governor and the brightness level depending on
whether the system is connected to AC or not. Furthermore it suspends
the system using pm-suspend and locks the screen using slimlock after
the lid is closed or the sleep button is pressed.

    #!/bin/sh
    # Default acpi script that takes an entry for all actions

    # NOTE: This is a 2.6-centric script.  If you use 2.4.x, you'll have to
    #       modify it to not use /sys

    minspeed=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq`
    maxspeed=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq`
    setspeed="/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed"

    set $*

    case "$1" in
        button/power)
            #echo "PowerButton pressed!">/dev/tty5
            case "$2" in
                PBTN|PWRF)  logger "PowerButton pressed: $2" ;;
                *)          logger "ACPI action undefined: $2" ;;
            esac
            ;;
        button/sleep)
           case "$2" in
               SLPB)   #echo -n mem >/sys/power/state ;;

    		    # Suspend the system and lock the screen
    		    /usr/sbin/pm-suspend 
    		    DISPLAY=:0.0 su -c - robert /usr/bin/slimlock
    	    ;;
               *)      logger "ACPI action undefined: $2" ;;
           esac
           ;;
        ac_adapter)
            case "$2" in
                AC0|ACAD|ADP0)
                    case "$4" in
                        00000001)
                            #echo -n $minspeed >$setspeed
                            #/etc/laptop-mode/laptop-mode start
    			 
                            # System is connected to AC 

    			 # Set governor to performance level for both CPUs
    			 echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    			 echo "performance" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor

    			 # Set brightness to maximum
    			 echo "15" > /sys/class/backlight/acpi_video0/brightness
                        ;;
                        00000000)
                            #echo -n $maxspeed >$setspeed
                            #/etc/laptop-mode/laptop-mode stop
    			 
                            # System is not connected to AC 
    	
    			 # Set governor to powersave level for both CPUs
    			 echo "powersave" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    			 echo "powersave" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
     
    			 # Set brightness to a minimum level 
    			 echo "5" > /sys/class/backlight/acpi_video0/brightness
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
                        ;;
                        00000001)   #echo "online"  >/dev/tty5
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
    	 # Suspend the system and lock the screen
    	 /usr/sbin/pm-suspend  
     	 DISPLAY=:0.0 su -c - user /usr/bin/slimlock
            ;;
        *)
            logger "ACPI group/action undefined: $1 / $2"
            ;;
    esac

> /etc/pm/sleep.d/60rc.local

This script executes the rc.local after suspend to ensure that the right
settings according to AC state are set.

    #!/bin/sh

    . "${PM_FUNCTIONS}"

    case $1 in
        resume|thaw)
            [ -e /etc/rc.local ] && /etc/rc.local &
            ;;
        *)
            exit $NA
            ;;
    esac
    exit 0

> /path/to/powermanagement.sh

This script actually changes the governor and the brightness depending
on the AC state.

    #!/bin/bash

    if [ "`sed -e "s/.[^ ]* *//" /proc/acpi/ac_adapter/AC0/state`" = "on-line" ]
            then
                   # System is on-line
    		# Set governor to performance level for both CPUs
    		echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    		echo "performance" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor

    		# Set brightness to maximum
    		echo "15" > /sys/class/backlight/acpi_video0/brightness
    		
            else
                   # System is off-line
    		# Set governor to powersave level for both CPUs
    		echo "powersave" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    		echo "powersave" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor

    		# Set brightness to a minimum level
    		echo "5" > /sys/class/backlight/acpi_video0/brightness
    fi

References
----------

Thread on the forums concerning configuration of Arch Linux on the SL
series

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_Thinkpad_SL500&oldid=238320"

Category:

-   Lenovo
