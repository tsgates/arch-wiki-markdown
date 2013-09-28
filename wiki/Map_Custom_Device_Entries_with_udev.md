Map Custom Device Entries with udev
===================================

This process allows to map a specific device to a constant device-node,
located in /dev, by using udev rules. This can then be used in fstab,
among other places, to ensure that the device can be mounted with a
unchanging device-node--ideal for desktop shortcuts and other mounting
operations.

This article focuses on USB devices and was copied almost verbatim from
the Gentoo wiki, later supplemented with additional hints.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Get USB device udev information                                    |
| -   2 Manual method                                                      |
| -   3 Create udev rule                                                   |
| -   4 Make fstab entry                                                   |
| -   5 Restart udev                                                       |
| -   6 Examples                                                           |
+--------------------------------------------------------------------------+

Get USB device udev information
-------------------------------

Here is script that facilitates this operation. Simply plug in the
device before running the script. Save it as usb-show-serial, for
example, and run it like so:

    $ ./usb-show-serial /dev/sdX label

    add the following to /etc/udev/rules.d/90-automounter.rules
    BUS=="usb", ATTRS{serial}=="23560716050834460007" , KERNEL=="sd?1", NAME="%k", SYMLINK+="foo",  GROUP="storage"

Manual method
-------------

Make sure one of the target devices is plugged in and then run the
following (replacing sda as needed):

    $ udevadm info -a -p $(udevadm info -q path -n /dev/sda)

    Udevadm starts with the device specified by the devpath and then
    walks up the chain of parent devices. It prints for every device
    found, all possible attributes in the udev rules key format.
    A rule to match, can be composed by the attributes of the device
    and the attributes from one single parent device.

      looking at device '/block/sda':
        KERNEL=="sda"
        SUBSYSTEM=="block"
        DRIVER==""
        ATTR{stat}=="      19      111      137      160        0        0        0        0        0      152      160"
        ATTR{size}=="2007040"
        ATTR{removable}=="1"
        ATTR{range}=="16"
        ATTR{dev}=="8:0"

      looking at parent device '/devices/pci0000:00/0000:00:02.2/usb1/1-5/1-5:1.0/host5/target5:0:0/5:0:0:0':
        KERNELS=="5:0:0:0"
        SUBSYSTEMS=="scsi"
        DRIVERS=="sd"
        ATTRS{ioerr_cnt}=="0x0"
        ATTRS{iodone_cnt}=="0x1c"
        ATTRS{iorequest_cnt}=="0x1c"
        ATTRS{iocounterbits}=="32"
        ATTRS{timeout}=="30"
        ATTRS{state}=="running"
        ATTRS{rev}=="1.20"
        ATTRS{model}=="01GB Tiny       "
        ATTRS{vendor}=="Pretec  "
        ATTRS{scsi_level}=="3"
        ATTRS{type}=="0"
        ATTRS{queue_type}=="none"
        ATTRS{queue_depth}=="1"
        ATTRS{device_blocked}=="0"
        ATTRS{max_sectors}=="240"

      looking at parent device '/devices/pci0000:00/0000:00:02.2/usb1/1-5/1-5:1.0/host5/target5:0:0':
        KERNELS=="target5:0:0"
        SUBSYSTEMS==""
        DRIVERS==""

      looking at parent device '/devices/pci0000:00/0000:00:02.2/usb1/1-5/1-5:1.0/host5':
        KERNELS=="host5"
        SUBSYSTEMS==""
        DRIVERS==""

      looking at parent device '/devices/pci0000:00/0000:00:02.2/usb1/1-5/1-5:1.0':
        KERNELS=="1-5:1.0"
        SUBSYSTEMS=="usb"
        DRIVERS=="usb-storage"
        ATTRS{modalias}=="usb:v4146pBA01d0100dc00dsc00dp00ic08isc06ip50"
        ATTRS{bInterfaceProtocol}=="50"
        ATTRS{bInterfaceSubClass}=="06"
        ATTRS{bInterfaceClass}=="08"
        ATTRS{bNumEndpoints}=="03"
        ATTRS{bAlternateSetting}==" 0"
        ATTRS{bInterfaceNumber}=="00"

      looking at parent device '/devices/pci0000:00/0000:00:02.2/usb1/1-5':
        KERNELS=="1-5"
        SUBSYSTEMS=="usb"
        DRIVERS=="usb"
        ATTRS{configuration}==""
        ATTRS{serial}=="14AB0000000096"
        ATTRS{product}=="USB Mass Storage Device"
        ATTRS{maxchild}=="0"
        ATTRS{version}==" 2.00"
        ATTRS{devnum}=="7"
        ATTRS{speed}=="480"
        ATTRS{bMaxPacketSize0}=="64"
        ATTRS{bNumConfigurations}=="1"
        ATTRS{bDeviceProtocol}=="00"
        ATTRS{bDeviceSubClass}=="00"
        ATTRS{bDeviceClass}=="00"
        ATTRS{bcdDevice}=="0100"
        ATTRS{idProduct}=="ba01"
        ATTRS{idVendor}=="4146"
        ATTRS{bMaxPower}==" 98mA"
        ATTRS{bmAttributes}=="80"
        ATTRS{bConfigurationValue}=="1"
        ATTRS{bNumInterfaces}==" 1"

      looking at parent device '/devices/pci0000:00/0000:00:02.2/usb1':
        KERNELS=="usb1"
        SUBSYSTEMS=="usb"
        DRIVERS=="usb"
        ATTRS{configuration}==""
        ATTRS{serial}=="0000:00:02.2"
        ATTRS{product}=="EHCI Host Controller"
        ATTRS{manufacturer}=="Linux 2.6.18-ARCH ehci_hcd"
        ATTRS{maxchild}=="6"
        ATTRS{version}==" 2.00"
        ATTRS{devnum}=="1"
        ATTRS{speed}=="480"
        ATTRS{bMaxPacketSize0}=="64"
        ATTRS{bNumConfigurations}=="1"
        ATTRS{bDeviceProtocol}=="01"
        ATTRS{bDeviceSubClass}=="00"
        ATTRS{bDeviceClass}=="09"
        ATTRS{bcdDevice}=="0206"
        ATTRS{idProduct}=="0000"
        ATTRS{idVendor}=="0000"
        ATTRS{bMaxPower}=="  0mA"
        ATTRS{bmAttributes}=="e0"
        ATTRS{bConfigurationValue}=="1"
        ATTRS{bNumInterfaces}==" 1"

      looking at parent device '/devices/pci0000:00/0000:00:02.2':
        KERNELS=="0000:00:02.2"
        SUBSYSTEMS=="pci"
        DRIVERS=="ehci_hcd"
        ATTRS{broken_parity_status}=="0"
        ATTRS{enable}=="1"
        ATTRS{modalias}=="pci:v000010DEd00000068sv00001043sd00000C11bc0Csc03i20"
        ATTRS{local_cpus}=="f"
        ATTRS{irq}=="17"
        ATTRS{class}=="0x0c0320"
        ATTRS{subsystem_device}=="0x0c11"
        ATTRS{subsystem_vendor}=="0x1043"
        ATTRS{device}=="0x0068"
        ATTRS{vendor}=="0x10de"

      looking at parent device '/devices/pci0000:00':
        KERNELS=="pci0000:00"
        SUBSYSTEMS==""
        DRIVERS==""

The only part of this that is needed is ATTRS{serial}, so use grep to
filter the information:

    $ udevadm info -a -p $(udevadm info -q path -n /dev/sda) | grep ATTRS{serial}

    ATTRS{serial}=="14AB0000000096"
       ATTRS{serial}=="0000:00:02.2"

This narrows down the search to a much greater degree; however, one of
the two serials is irrelevant. Trim down the grep:

    $ udevadm info -a -p $(udevadm info -q path -n /dev/sda) | grep ATTRS{product}

    ATTRS{product}=="USB Mass Storage Device"
       ATTRS{product}=="EHCI Host Controller"

The first choice is obviously the correct one.

Create udev rule
----------------

Use the ATTRS{serial} in a udev rule as follows. Place it in
/etc/udev/rules.d/00.rules:

    SUBSYSTEMS=="usb", ATTRS{serial}=="14AB0000000096", KERNEL=="sd?1", NAME="%k", SYMLINK+="usbdrive", GROUP="storage"

Note:When creating a file with a different naming scheme that those in
the directory, remember that udev processes these files in alphabetical
order.

Make fstab entry
----------------

Create a directory for mounting:

    # mkdir /mnt/usbdrive

In /etc/fstab, create an entry as:

    /dev/usbdrive /mnt/usbdrive vfat rw,noauto,group,flush,quiet,nodev,nosuid,noexec,noatime,dmask=000,fmask=111 0 0

Options nodev, nosuid, and noexec are unnecesary; they are stated for
security reasons only. Additionally, depending on your locale
preferences, add codepage and iocharset options (such as
codepage=866,iocharset=utf-8) in order to be able to display non-Latin
file-names correctly.

Now, root and users who belongs to the storage group can mount the USB
device by:

    mount /mnt/usbdrive

To allow a non-root user to access to USB devices, add them to the
storage group:

    # gpasswd -a username storage

Restart udev
------------

To load the updated rules, run:

    # udevadm control --reload-rules

Examples
--------

Here are some mapping and mounting examples. This system's devices
sometimes made nodes as sda or sda1 so I two rules for each needed to be
specified, which aid "device not found" problems. The sda node is also
needed for disk-level activities; e.g., fdisk /dev/sda.

This always maps a specific USB device (in this case, a pendrive) to
/dev/usbpen, which is then set in fstab to mount on /mnt/usbpen:

    # Symlink USB pen
    SUBSYSTEMS=="usb", ATTRS{serial}=="1730C13B18000B84", KERNEL=="sd?", NAME="%k", SYMLINK+="usbpen", GROUP="storage"
    SUBSYSTEMS=="usb", ATTRS{serial}=="1730C13B18000B84", KERNEL=="sd?1", NAME="%k", SYMLINK+="usbpen", GROUP="storage"

If for devices with multiple partitions, the following example maps the
device to /dev/usbdisk, and partitions 1, 2, 3 etc., to /dev/usbdisk1,
/dev/usbdisk2, /dev/usbdisk3, etc.

    # Symlink multi-part device
    SUSSYSTEMS=="usb", ATTRS{serial}=="1730C13B18000B84", KERNEL=="sd?", NAME="%k", SYMLINK+="usbdisk", GROUP="storage"
    SUBSYSTEMS=="usb", ATTRS{serial}=="1730C13B18000B84", KERNEL=="sd?[1-9]", NAME="%k", SYMLINK+="usbdisk%n", GROUP="storage"

The above rules are equivalent to the following one:

    # Symlink multi-part device
    SUBSYSTEMS=="usb", ATTRS{serial}=="1730C13B18000B84", KERNEL=="sd*", NAME="%k", SYMLINK+="usbdisk%n", GROUP="storage"

It's also possible to omit the NAME and GROUP statements, so that the
defaults from udev.rules are used. Meaning that the shortest and
simplest solution would be adding this rule:

    # Symlink multi-part device
    SUBSYSTEMS=="usb", ATTRS{serial}=="1730C13B18000B84", KERNEL=="sd*", SYMLINK+="usbdisk%n"

This always maps a Olympus digicam to /dev/usbcam, which can be stated
in fstab to mount on /mnt/usbcam:

    # Symlink USB camera
    SUBSYSTEMS=="usb", ATTRS{serial}=="000207532049", KERNEL=="sd?", NAME="%k", SYMLINK+="usbcam", GROUP="storage"
    SUBSYSTEMS=="usb", ATTRS{serial}=="000207532049", KERNEL=="sd?1", NAME="%k", SYMLINK+="usbcam", GROUP="storage"

And this maps a Packard Bell MP3 player to /dev/mp3player:

    # Symlink MP3 player
    SUBSYSTEMS=="usb", ATTRS{serial}=="0002F5CF72C9C691", KERNEL=="sd?", NAME="%k", SYMLINK+="mp3player", GROUP="storage"
    SUBSYSTEMS=="usb", ATTRS{serial}=="0002F5CF72C9C691", KERNEL=="sd?1", NAME="%k", SYMLINK+="mp3player", GROUP="storage"

To map a selected usb-key to /dev/mykey and all of other keys to
/dev/otherkey:

    # Symlink USB keys
    SUBSYSTEMS=="usb", ATTRS{serial}=="insert serial key", KERNEL=="sd?1", NAME="%k", SYMLINK+="mykey"
    SUBSYSTEMS=="usb", KERNEL=="sd?1", NAME="%k", SYMLINK+="otherkey"

Note the order of the lines. Since all the USB keys should create the
/dev/sd<a||b> node, udev will first check if it is a rules-stated
USB-key, defined by serial number. But if an unknown USB-key is plugged,
it will create also create a node, using the previously stated generic
name, "otherkey". That rule should be the last one in rules file so that
it does not override the others.

This is an example on how to distinguish USB HDD drives and USB sticks:

    BUS=="usb", ATTRS{product}=="USB2.0 Storage Device", KERNEL=="sd?", NAME="%k", SYMLINK+="usbdisk", GROUP="storage"
    BUS=="usb", ATTRS{product}=="USB2.0 Storage Device", KERNEL=="sd?[1-9]", NAME="%k", SYMLINK+="usbdisk%n", GROUP="storage"
    BUS=="usb", ATTRS{product}=="USB Mass Storage Device", KERNEL=="sd?1", NAME="%k", SYMLINK+="usbflash", GROUP="storage"

Note that this udev rule doesn't use serials at all.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Map_Custom_Device_Entries_with_udev&oldid=225243"

Categories:

-   Hardware detection and troubleshooting
-   File systems
