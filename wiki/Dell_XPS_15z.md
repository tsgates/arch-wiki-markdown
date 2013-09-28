Dell XPS 15z
============

  

Device

Status

Network

Works

Wireless

Works

Sound

Works

Bluetooth

Works

Touchpad

Modify

Graphics

Modify

Screen

Modify

USB 3.0

Not tested

Webcam

Works

Card Reader

Modify

System info

Not tested

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 System Settings                                                    |
| -   2 System Setup                                                       |
|     -   2.1 Hangs on boot                                                |
|     -   2.2 Graphics                                                     |
|         -   2.2.1 Disabling Nvidia card with acpi_call                   |
|         -   2.2.2 Using Bumblebee                                        |
|         -   2.2.3 Video Performance                                      |
|         -   2.2.4 Boot time errors                                       |
|         -   2.2.5 X11: no screen found                                   |
|                                                                          |
|     -   2.3 Bluetooth                                                    |
|     -   2.4 Touchpad and Keyboard                                        |
|         -   2.4.1 Keyboard is not working                                |
|                                                                          |
|     -   2.5 Card Reader                                                  |
+--------------------------------------------------------------------------+

System Settings
===============

lspci

    00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
    00:01.0 PCI bridge: Intel Corporation 2nd Generation Core Processor Family PCI Express Root Port (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
    00:16.0 Communication controller: Intel Corporation 6 Series Chipset Family MEI Controller #1 (rev 04)
    00:1a.0 USB Controller: Intel Corporation 6 Series Chipset Family USB Enhanced Host Controller #2 (rev 05)
    00:1b.0 Audio device: Intel Corporation 6 Series Chipset Family High Definition Audio Controller (rev 05)
    00:1c.0 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 1 (rev b5)
    00:1c.1 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 2 (rev b5)
    00:1c.3 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 4 (rev b5)
    00:1c.4 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 5 (rev b5)
    00:1c.5 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 6 (rev b5)
    00:1d.0 USB Controller: Intel Corporation 6 Series Chipset Family USB Enhanced Host Controller #1 (rev 05)
    00:1f.0 ISA bridge: Intel Corporation HM67 Express Chipset Family LPC Controller (rev 05)
    00:1f.2 SATA controller: Intel Corporation 6 Series Chipset Family 6 port SATA AHCI Controller (rev 05)
    00:1f.3 SMBus: Intel Corporation 6 Series Chipset Family SMBus Controller (rev 05)
    01:00.0 VGA compatible controller: nVidia Corporation Device 0df5 (rev ff)
    03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6230 (rev 34)
    04:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04)
    06:00.0 Ethernet controller: Atheros Communications Device 1083 (rev c0)

System Setup
============

Hangs on boot
-------------

Sometimes when boot the laptop with the default kernel it would hang at
uevent detection, to prevent this from happening add kernel boot param
nox2apic edit /etc/default/grub

    GRUB_CMDLINE_LINUX_DEFAULT="nox2apic"

  

Graphics
--------

Dell XPS 15z has two graphics card installed, Intel integrated graphics
card and Nvidia 525m card. Nvidia card is using Optimus technology.
Initially, both the Intel integrated graphics and the Nvidia 525m card
will be active, consuming a lot of power. Unfortunately, Optimus is
currently not supported in Linux by Nvidia driver nor nouveau driver, so
you need to install the intel driver and disable Nvidia card.

See Intel for details on using the Intel GPU.

> Disabling Nvidia card with acpi_call

The following steps outline one method for disabling the Nvidia card via
acpi_call. This will only disable the card. If you wish to use it, use
Bumblebee instead. Ensure that have git installed:

    # pacman -S git

Obtain a copy of acpi_call:

    # git clone http://github.com/mkottman/acpi_call

Make acpi_call:

    # cd acpi_call
    # make

Download this script made by Ubuntu forum member sunilim. Open up the
script and modify the line

    insmod /home/sunil/acpi_call/acpi_call.ko

to

    insmod /home/YOUR-USER-NAME/acpi_call/acpi_call.ko

Close the script, make it executable, and place it in the bin folder

    # chmod +x dell.sh
    # cp dell.sh /usr/bin/dell.sh

Run the script to see that it works

    # dell.sh off

To make the solution permanent, open up the file /etc/rc.local and add
the following line

    sleep 5 && dell.sh off

> Using Bumblebee

Another way, which allows to use Optimus technology is via Bumblebee.
This program is available from AUR and even provides it's own drivers
for Nvidia card, available from AUR as well.

> Video Performance

Using the Intel card without any modifications can result in poor video
performance. A quick fix is to edit boot options of your boot loader and
append the following to the kernel parameters:

    # i915.semaphores=1

> Boot time errors

If you encounter boottime errors with intel, add i915 and intel_agp
modules to the MODULES section in /etc/mkinitcpio.conf:

    # MODULES="intel_agp i915"

Then regenerate the initramfs:

    # mkinitcpio -p linux

> X11: no screen found

This error may happen when you install Nvidia driver instead of intel
driver. More info here. Basic solution is to uninstall NVidia driver and
install intel driver.

Bluetooth
---------

See Bluetooth.

Touchpad and Keyboard
---------------------

As of kernel 3.6, out of the box the keyboard works perfectly and the
touchpad works with basic functionality (no multitouch). A driver has
been written to enable full multitouch support but has not yet been
included in the mainline kernel. To use this driver, you will need to
use a kernel with the driver built in. There are two kernels in the AUR
that include this driver: linux-xps15z and linux-mainline-dellxps. See
Kernels/Compilation/Arch_Build_System for information on compiling
kernel.

> Keyboard is not working

In case your keyboard is not working after installing Arch, or after
upgrading older installation add this to your kernel line:

    # acpi=noirq

As mentioned above, this problem shouldn't occur in new installations,
although may in some cases of customized installs.

Card Reader
-----------

To make the card reader function enter the following command:

    # echo 1 > /sys/bus/pci/rescan

This will allow it to auto mount cards until the next reboot

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_XPS_15z&oldid=241645"

Category:

-   Dell
