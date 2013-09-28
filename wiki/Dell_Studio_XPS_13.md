Dell Studio XPS 13
==================

I have just bought a new Dell Studio XPS 13. I have not been able to
find any information for installing Arch Linux on this machine. It is a
very nice looking laptop, and runs fast and smooth. I have had a
successful install (32-bit only, 64-bit). I still have a few things to
get working, like the Bluetooth, and media buttons.

System Specs:

-   Processor
    -   Intel(R) Core(TM)2 Duo CPU P8600 @ 2.40GHz

-   RAM Memory
    -   4 GB DDR3

-   Webcam
    -   2.0 Megapixel Webcam

-   Hard Disk
    -   320GB SATA 7200 rpm HDD
    -   500GB SATA 7200 rpm HDD

-   Video Card
    -   NVIDIA 9400M
    -   NVIDIA 9500M (9400M G + 9200M GS)

-   Wireless
    -   Broadcom Corporation BCM4322 802.11a/b/g/n Wireless LAN
        Controller
    -   Atheros Communications Inc. AR928X Wireless Network Adapter

The basic installation performs normally, with the core cd, also the
wireless modules ( Atheros wifi card ) were well recognised and worked
out of the box.

Power Management
----------------

> HDD important issue

With the Western Digital hard drive (not SSD), there is an important
issue: using the APM (Advanced Power Management) there are too nomerous
spin-down, that can damage the hard drive [1]. To confirm this issue you
have to install smartmontools:

    # pacman -S smartmontools

And you have to run multiple times this command (once in a minute for
like 5 minutes):

    # smartctl -a /dev/sda|grep Load_Cycle_Count

If the number under Load_Cycle_Count is increasing in a small amount of
time (1 or 2 in a minute) you have this issue.

The problem is easily solvable using laptop-mode-tools. In your
/etc/laptop-mode/laptop-mode.conf you have to set:

    #
    # Should laptop mode tools control the hard drive power management settings?
    #
    CONTROL_HD_POWERMGMT=1


    #
    # Power management for HD (hdparm -B values)
    #
    BATT_HD_POWERMGMT=255
    LM_AC_HD_POWERMGMT=255
    NOLM_AC_HD_POWERMGMT=255

This disable all power management systems of the hard drive cause a
light heat up (maybe). The same behaviour can be obtained running this
command:

    # hdparm -B 255 /dev/sda

the 255 number is the power-management level, in a range of 1-255 where
1 is maximum powersaving and 255 powersaving disabled. However setting
the value to 253 causes a lot of spin-down. Setting the spin-down
feature (it parks the heads away from disk) however can save hdd in case
of fall.

> Hybernation - Suspend

This feature works very well, See pm-utils

Make sure acpid is installed and running. You can add it to the DAEMONS
array in /etc/rc.conf.

Then edit these files...

/etc/acpi/actions/lm_lid.sh:

    sh ~/bin/suspend

(Taken from
http://www.linux.com/news/hardware/laptops/8253-how-to-suspend-and-hibernate-a-laptop-under-linux
[+] with a little modification)

~/bin/suspend:

    #!/bin/sh

    # discover video card's ID
    ME=`whoami`
    if [ "$ME" != "root" ]; then
        echo "You must be root!"
        exit 1
    fi

    ID=`lspci | grep VGA | awk '{ print $1 }' | sed -e 's@0000:@@' -e 's@:@/@'`

    # securely create a temporary file

    TMP_FILE=`mktemp /var/tmp/video_state.XXXXXX`trap 'rm -f $TMP_FILE' 0 1 15

    # switch to virtual terminal 1 to avoid graphics
    # corruption in X

    chvt 1

    # write all unwritten data (just in case)

    sync

    # dump current data from the video card to the
    # temporary filecat 

    /proc/bus/pci/$ID > $TMP_FILE

    # suspend

    echo -n mem > /sys/power/state

    # restore video card data from the temporary file
    # on resume

    cat $TMP_FILE > /proc/bus/pci/$ID

    # switch back to virtual terminal 7 (running X)
    chvt 7

    # remove temporary file
    rm -f $TMP_FILE

This should suspend your laptop to RAM when the lid is closed.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Studio_XPS_13&oldid=254492"

Category:

-   Dell
