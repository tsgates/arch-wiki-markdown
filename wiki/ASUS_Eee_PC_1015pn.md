ASUS Eee PC 1015pn
==================

  Summary
  ----------------------------------------------------------------------------------------------------------
  General information regarding Asus EEE PC 1015pn and related notes on installing/using Arch Linux on it.

Asus 1015PN is a dual-core netbook with Nvidia IOn graphics for better
gaming. It works fine with Linux OSs. This article provides some
information on hardwares specs and some knowledge base about it.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 System Specs                                                       |
| -   2 HDD important issue                                                |
|     -   2.1 Solution 1                                                   |
|     -   2.2 Solution 2                                                   |
|                                                                          |
| -   3 nVidia ION 2 with Optimus                                          |
|     -   3.1 Installing acpi_call                                         |
|     -   3.2 Selecting Video Card                                         |
|     -   3.3 Check consumption                                            |
|                                                                          |
| -   4 ACPI                                                               |
| -   5 Wireless                                                           |
| -   6 Bumblebee                                                          |
| -   7 To Do                                                              |
| -   8  Links                                                             |
+--------------------------------------------------------------------------+

System Specs
------------

-   CPU: Intel Atom Dual-Core N550 (1.5 GHz)

-   RAM: 1GB 1066MHz DDR3 (up to 2GB 1333Mhz)

-   HDD: 250 GB, 5400 RPM

-   GPU: nVidia GT218 ION2 with Optimus (Intel GMA 3150 built into the
    CPU)

-   Display: 10.1" 1024 x 600 pixels LCD display

-   Wireless: BCM4313

-   Bluetooth: Working (confirmed in linux 3.6.5)

-   Webcam: Working (remember to add yourself to video group)

-   Card Reader: Working

-   Extras: 3 USB 2.0 ports, Bluetooth 3

HDD important issue
-------------------

With the Western Digital hard disc (eg. WD2500BEVT), there is an
important issue: using the APM (Advanced Power Management) there are too
nomerous spin-down, that can damage the hard drive. To confirm this
issue, you have to install smartmontools from Official Repositories.

And you have to run multiple times this command (once in a minute for
like 5 minutes):

    # smartctl -a /dev/sda|grep Load_Cycle_Count

If the number under Load_Cycle_Count is increasing in a small amount of
time (1 or 2 in a minute) you have this issue.

> Solution 1

The problem is easily solvable using laptop-mode-tools. In your
/etc/laptop-mode/laptop-mode.conf, you have to set:

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
feature (it parks the heads away from disk) however can save the hard
disk in case of a fall.

> Solution 2

This method correct this issue once and for all: WDIDLE3

[This page] contains a pre-built DOS boot disk to fix this issue. It can
be installed a run from a USB.

nVidia ION 2 with Optimus
-------------------------

Optimus doesn't work at all but it is possible to choose which graphical
card will be used on next reboot.

You can get 2 'modes' :

-   By default (if you do not do anything) the machine starts with the
    Nvidia beeing the only VGA controller visible (so it will use the
    ION chip).
-   Using some tools you can start with the Intel and Nvidia
    VGA controller visible. In this mode the Intel controller is used
    and it is possible to power-down the Nvidia part.

To switch between those modes you will need acpi_call-git.

> Installing acpi_call

Install acpi_call-git from the AUR. Add acpi_call module into
/etc/modules-load.d/.

> Selecting Video Card

The ACPI method \OSGS is used for selecting the video card for the next
boot. The first argument to it determines the card(s) to be enabled.
Only the two rightmost bits are used. If bit 0 is enabled, the intel
card is enabled as well. Bit 1 correspondends with the nvidia card. If
no bits are enabled, only the nvidia card will be enabled. Hence:

-   \OSGS 3 - enable Intel + Nvidia (Optimus mode)
-   \OSGS 2 (or even \OSGS 0x00) - enable Nvidia only (discrete mode)
-   \OSGS 1 - enable Intel only (integrated mode)

Using the acpi_call module, you can execute these commands. Example: to
select Intel + Nvidia on next reboot:

    echo '\OSGS 3' > /proc/acpi/call

  
 Note: You will need to do this at each boot as long as you want to stay
with the Intel part (If you do not do this the Eee will start with only
the Nvidia Ion VGA controller). Adding the above command to
/etc/rc.local will run the command on every boot (for the next boot).
This is ideal if you want to run X on the Intel VGA controller.

You can check the current mode with :

    echo "\AMW0.DSTS 0x90013" > /proc/acpi/call
    cat /proc/acpi/call

Substract 0x30000 from the result and interpret the remaining two bits
as the first argument passed to \OSGS. Thus:

-   0x30003 - intel + nvidia are on (Optimus mode)
-   0x30002 - only the nvidia card is on (discrete mode)
-   0x30001 - only the intel card is on (integrated mode)

After reboot you can see which controllers are enabled with:

    lspci -nn | grep '\[03'

You can now power down the ion part with (you'll need the acpi_call
module loaded):

    echo "\_SB.PCI0.P0P4.DGPU.DOFF" > /proc/acpi/call

Note: when the nvidia card is the only enabled card, the above function
does nothing.

Note: When leaving suspend you need to do this again because the Nvidia
part reactivates itself.

rc script to disable nvidia:

     #!/bin/bash
     
     . /etc/rc.conf
     . /etc/rc.d/functions
     
     
     if lsmod | grep -q acpi_call; then
             stat_busy 'Swith per ACPI_CALL to Optimus'
             echo "\OSGS 0x03" > /proc/acpi/callrayt5
             echo "\_SB.PCI0.P0P4.DGPU.DOFF" > /proc/acpi/call
             echo "\AMW0.DSTS 0x90013" > /proc/acpi/call
             result=$(cat /proc/acpi/call)
             case "$result" in
             0x30003)
                     stat_done
             ;;
             *)
                     stat_fail
             ;;
             esac
     else
             stat_busy 'ACPI_CALL mod not loaded'
             stat_fail
     fi

> Check consumption

You can check consumption with:

    cat /sys/class/power_supply/BAT0/current_now

-   Before disabling: ~1700mA.
-   After disabling: ~1000mA.

As you can see this method saves a lot of battery!

ACPI
----

As of kernel 3.1, appending acpi_osi=Linux to the kernel line in your
bootloader configuration file (e.g. grub, lilo, syslinux...) is no
longer necessary to enable ACPI. The proper modules should be
automatically called at boot.

Wireless
--------

Since linux kernel version 2.6.37, the needed module for BCM4313 is
natively included in it. If you by any chance you a kernel equal or
older than 2.6.36, then you will need compat-wireless-brcm80211.

For kernel 3.0 or higher, wireless card seems to be blocked by other
wrong module (I notice a module called 'bcma-pci-bridge' being loaded --
josephgbr). To solve this issue, you have to blacklist the kernel module
{{Ic|bcma}. In the next reboot, the wireless card should be working.

Bumblebee
---------

The 1015pn can be configured to run automatically on the Intel video
card, turn on and use the Nvidia part for specific processes when
requested, and otherwise leave the Nvidia part turned off.

First, add the command

    echo "\OSGS 0x03" > /proc/acpi/call

to /etc/rc.local to ensure that the Intel VGA controller is used on
every subsequent boot. Next, install and configure Bumblebee. Finally,
remove any automated or otherwise scripted acpi calls to turn off the
Nvidia VGA controller.

Power management of the Nvidia VGA controller can also be handled by
Bumblebee. Please note, however, that Bumblebee support for power
management is currently experimental. To use automatic power management
of the Nvidia card, first go to /etc/bumblebee/bumblebee.conf, and
change ENABLE_POWER_MANAGEMENT=Y and STOP_SERVICE_ON_EXIT=Y. This gives
Bumblebee permission to turn on and off the Nvidia card. Stop service on
exit means that the Nvidia card will be turned off when not currently
being used by any process.

Next, two new files, cardon and cardoff, must be created in
/etc/bumblebee/, with the following contents:

    cardon

    \_SB.PCI0.P0P4.DGPU.DON

    cardoff

    \_SB.PCI0.P0P4.DGPU.DOFF

These are the acpi calls that Bumblebee will use to dynamically control
the power of the Nvidia card. Now if bumblebee is included in the
MODULES section of /etc/rc.conf, Bumblebee will automatically power down
the Nvidia VGA controller unless it is being used with the optirun
command.

  

To Do
-----

1.  Manage to get the xf86-video-intel, and xf86-video-nouveau or nvidia
    packages installed (specific libgl being used by each one)
2.  Fix notes about rc.conf and initscripts.

 Links
------

-   http://linux-hybrid-graphics.blogspot.com/
-   https://sites.google.com/site/mtrons/howtos/eeepc-1015pn
-   https://github.com/Bumblebee-Project/acpi_call
-   https://github.com/Bumblebee-Project/Bumblebee

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_1015pn&oldid=241541"

Category:

-   ASUS
