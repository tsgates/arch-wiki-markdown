ASUS Eee PC 1201NL
==================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Asus Eee PC 
                           1201n.                   
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ---------------------- ---------------- --------------------
  Device                 Status           Modules
  Nvidia GeForce 9400M   Working          nvidia
  Ethernet               Working          atl1e
  Wireless               Working          rtl8192se
  Audio                  Working          snd_hda_intel
  Camera                 Working          
  Card Reader            Working          
  Function Keys          Working          acpi-eeepc-generic
  Suspend2RAM            Working          pm-utils
  Hibernate              Working          uswsusp-git
  Multi-input touchpad   Only emulation   
  ---------------------- ---------------- --------------------

This is just a draft - more detailed instructions coming up soon + more
detailed tests

Netbook works flawlessly with Arch Linux (if you encounter freezes see
Troubleshooting below)

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 HDD important issue                                                |
| -   2 Graphics                                                           |
|     -   2.1 Nvidia's Closed-Source Driver                                |
|     -   2.2 Open-Source Driver                                           |
|                                                                          |
| -   3 Wireless                                                           |
| -   4 ACPI Functions                                                     |
|     -   4.1 Function Keys                                                |
|                                                                          |
| -   5 Power Management with Laptop Mode Tools                            |
|     -   5.1 Super Hybrid Engine                                          |
|     -   5.2 Wifi Power Management                                        |
|     -   5.3 Suspend2RAM                                                  |
|     -   5.4 Hibernate                                                    |
|     -   5.5 LCD brightness                                               |
|                                                                          |
| -   6 Troubleshooting                                                    |
|     -   6.1 Machine does not resume after suspend2ram                    |
|     -   6.2 After suspending the machine immediately resumes             |
|                                                                          |
| -   7 Tips                                                               |
|     -   7.1 1366x768 in console with NVIDIA proprietary driver           |
+--------------------------------------------------------------------------+

HDD important issue
===================

With the Western Digital hard drive (not SSD), there is an important
issue: using the APM (Advanced Power Management) there are too nomerous
spin-down, that can damage the hard drive. To confirm this issue you
have to install smartmontools:

    # pacman -S smartmontools

And you have to run multiple times this command (once in a minute for
like 5 minutes):

    # smartctl -a /dev/sda|grep Load_Cycle_Count

If the number under Load_Cycle_Count is increasing in a small amount of
time (1 or 2 in a minute) you have this issue. The problem is easily
solvable using laptop-mode-tools. In your
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

Graphics
========

Nvidia's Closed-Source Driver
-----------------------------

Just install the official closed source drivers from arch extra repo:

    pacman -S nvidia

Open-Source Driver
------------------

If you desire Kernel Mode Setting and xinerama (better multihead
support), then install nouveau instead of the closed-source driver.

    pacman -S xf86-video-nouveau

And (experimental) 3D support:

    pacman -S nouveau-dri

Wireless
========

There is native support from 3.0 kernel version with rtl8192se module.

ACPI Functions
==============

In order to use the function keys and extend battery life, you can set
up the ACPI Driver, then install and configure the tools below.

The driver for the ACPI functions of the 1201N is called eeepc_laptop.
It is part of the mainline kernel, so all that needs to be done is to
load the module:

    modprobe eeepc_laptop

If the command fails with such error message:

    FATAL: Error inserting eeepc_laptop (/lib/modules/2.6.32-ARCH/kernel/drivers/platform/x86/eeepc-laptop.ko): No such device

you need to add acpi_osi=Linux to kernel parameters in your bootloader
configuration.

Function Keys
-------------

You must have acpid installed to use the Function keys:

    pacman -S acpid 

After installing acpid, you will have to add it to your DAEMONS array in
rc.conf.

Then, you need to install acpi-eeepc-generic package from AUR and edit
file /etc/conf.d/acpi-eeepc-generic.conf:

    EEEPC_MODEL="1201N"

Comment out EEEPC_CONF_DONE option:

    #EEEPC_CONF_DONE="no"

If you are using linux drivers for wifi you should also edit the
WIFI_DRIVERS array:

    WIFI_DRIVERS=("r8192se_pci")

Otherwise the wifi toggle button won't work.

Afterward, you must restart acipd:

    /etc/rc.d/acpid restart

Power Management with Laptop Mode Tools
=======================================

You can use Laptop Mode to substantially increase your battery life on
Linux. To do so, Install the [Laptop Mode Tools|laptop-mode-tools] from
extra repo:

    pacman -S laptop-mode-tools

and add "laptop-mode" to your DAEMONS array in rc.conf. Many of the
power managment settings in laptop-mode are disbaled by default, so it
is encouraged that you explore the configuration files throroughly. Here
are some highlights of configuration options worth exploring:

Super Hybrid Engine
-------------------

Super Hybrid Engine is a simple FSB tweaker that can radically reduce
power consumption.

To enable automatic SHE manipulation just edit
/etc/laptop-mode/conf.d/eee-superhe.conf:

    CONTROL_SUPERHE=1

If you've configured function keys using acpi-eeepc-generic, you can
manually change SHE mode by using Fn+Space.

Wifi Power Management
---------------------

The linux native wifi driver supports wifi power management. If you are
using the linux-native wifi driver, you can enable basic power
management by editing /etc/laptop-mode/conf.d/wireless-power.conf:

    CONTROL_WIRELESS_POWER_SAVING=1

Suspend2RAM
-----------

Install pm-utils:

    pacman -S pm-utils

If you are using linux wifi driver you need to unload it before
suspending otherwise the machine won't resume. To do this automatically
uncomment and edit appropriate line in /etc/pm/config.d/config file:

    SUSPEND_MODULES="ehci_hcd r8192se_pci"

The ehci_hcd module is responsible for usb hub. Removing it solves the
immediate resume issue (see Troubleshooting) You can try out the
suspend2ram either by using function key Fn+F1 (if you've configured
them to use pm-utils in /etc/conf.d/acpi-eeepc-generic.conf) or by
running:

    pm-suspend

Hibernate
---------

Install uswsusp-git package from AUR.

Set resume device parameter (your swap partition) in /etc/suspend.conf

    resume device = /dev/sda3

Add possibility to suspend2disk with closing laptop if you installed
acpi-eeepc-generic.

Modify /etc/conf.d/acpi-eeepc-generic.conf

Add next lines

    COMMANDS_HIBERNATE=("/etc/acpi/eeepc/acpi-eeepc-generic-suspend2disk.sh")
    SUSPEND2DISK_COMMANDS=("s2disk")

Edit variable COMMANDS_LID_CLOSE_ON_BATTERY value like this

    COMMANDS_LID_CLOSE_ON_BATTERY=("${COMMANDS_HIBERNATE[@]}")

Now copy /etc/acpi/eeepc/acpi-eeepc-generic-suspend2ram.sh to
/etc/acpi/eeepc/acpi-eeepc-generic-suspend2disk.sh and edit command to
run

    execute_commands "${SUSPEND2DISK_COMMANDS[@]}"

Now restart acpid

    #/etc/rc.d/acpid restart

LCD brightness
--------------

To enable LCD brightness automatic manipulation you need to edit
/etc/laptop-mode/conf.d/lcd-brightness.conf and set proper
BRIGHTNESS_OUTPUT path:

    BATT_BRIGHTNESS_COMMAND="echo 8"
    LM_AC_BRIGHTNESS_COMMAND="echo 15"
    NOLM_AC_BRIGHTNESS_COMMAND="echo 15"
    BRIGHTNESS_OUTPUT="/proc/acpi/video/IGPU/LCDD/brightness"

Troubleshooting
===============

Machine does not resume after suspend2ram
-----------------------------------------

You have to unload r8192se_pci module right before suspending. See
Suspend2RAM section of this article for details.

After suspending the machine immediately resumes
------------------------------------------------

You have to unload usb module(s) before suspending. See Suspend2RAM
section of this article for details.

Tips
====

1366x768 in console with NVIDIA proprietary driver
--------------------------------------------------

Load kernel with parameter acpi_osi=Linux

Reboot

Load kernel with parameters acpi_osi=Linux vga=0x034d

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_1201NL&oldid=208397"

Category:

-   ASUS
