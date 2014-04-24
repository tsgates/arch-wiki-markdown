USB Storage Devices
===================

This document describes how to use the popular USB memory sticks with
Linux. However, it is also valid for other devices such as digital
cameras that act as if they were just a USB storage device.

If you have an up-to-date system with the standard Arch kernel and a
modern Desktop environment your device should just show up on your
desktop, with no need to open a console.

Contents
--------

-   1 Auto-mounting with udisks
-   2 Manual mounting
    -   2.1 Getting a kernel that supports usb_storage
    -   2.2 Identifying device
    -   2.3 Mounting USB memory
        -   2.3.1 As root
        -   2.3.2 As normal user with mount
        -   2.3.3 As normal user with fstab
-   3 Unmounting devices mounted with udev or systemd/udev

Auto-mounting with udisks
-------------------------

This is the easiest and most frequently used method. It is used by many
desktop environments, but can be used separately too. See Udisks for
details.

Manual mounting
---------------

Note:Before you decide that Arch Linux does not mount your USB device,
be sure to check all available ports. Some ports might not share the
same controller, preventing you from mounting the device.

> Getting a kernel that supports usb_storage

If you do not use a custom-made kernel, you are ready to go, for all
Arch Linux stock kernels are properly configured. If you do use a
custom-made kernel, ensure it is compiled with SCSI-Support,
SCSI-Disk-Support and usb_storage. If you use the latest udev, you may
just plug your device in and the system will automatically load all
necessary kernel modules. Older releases of udev would need hotplug
installed too. Otherwise, you can do the same thing manually:

    # modprobe usb-storage
    # modprobe sd_mod      (only for non SCSI kernels)

Tip:In case of manually loading modules, you may also need to load the
sg module (SCSI generic driver).

> Identifying device

First thing one need to access storage device is it's identifier
assigned by kernel. See fstab#Identifying filesystems for details.

Tip:To see which device is your USB device, you can compare the output
of lsblk -f (explained in the linked article) when the USB device is
connected and when it is unconnected.

> Mounting USB memory

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           fstab#Writing to FAT32   
                           as Normal User.          
                           Notes: This section      
                           assumes that the         
                           partition on USB storage 
                           uses FAT32 or NTFS       
                           filesystem, so we have   
                           two sections covering    
                           the same topic. Either   
                           merge everything here or 
                           in the linked section.   
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

You need to create the directory in which you are going to mount the
device:

    # mkdir /mnt/usbstick

As root

Mount the device as root with this command (do not forget to replace
device_node by the path you found):

    # mount device_node /mnt/usbstick

or

    # mount -U UUID /mnt/usbstick

If mount does not recognize the format of the device you can try to use
the -t argument, see man mount for details.

Note:If mounting your stick does not work you can try to repartition it,
see Format a device.

As normal user with mount

If you want non-root users to be able to write to the USB stick, you can
issue the following command:

    # mount -o gid=users,fmask=113,dmask=002 /dev/sda1 /mnt/usbstick

As normal user with fstab

If you want non-root users to be able to mount a USB memory stick via
fstab, add the following line to your /etc/fstab file:

    /dev/sda1 /mnt/usbstick vfat user,noauto,noatime,flush 0 0

or better:

    UUID=E8F1-5438 /mnt/usbstick vfat user,noauto,noatime,flush 0 0

(see description of user and other options in the main article)

Note:Where /dev/sda1 is replaced with the path to your own usbstick, see
Mounting USB memory.

Now, any user can mount it with:

    $ mount /mnt/usbstick

And unmount it with:

    $ umount /mnt/usbstick

Unmounting devices mounted with udev or systemd/udev
----------------------------------------------------

Create an executable file (e.g. /usr/local/bin/unmount.sh):

    #!/bin/sh

    # Global variables
    TITLE="Unmount Utility"
    COLUMNS=3 # TARGET,SOURCE,FSTYPE
    #IFS=$'\n'

    # Populate list of unmountable devices
    deviceList=($(findmnt -Do TARGET,SOURCE,FSTYPE | grep -e "sd[b-z]"))
    deviceCount=$((${#deviceList[@]} / $COLUMNS))

    # Start of program output
    echo $TITLE

    # Display list of devices that can be unmounted
    for ((device=0; device<${#deviceList[@]}; device+=COLUMNS))
    do
      printf "%4s)   %-25s%-13s%-10s\n"\
        "$(($device / $COLUMNS))"\
        "${deviceList[$device]}"\
        "${deviceList[$(($device + 1))]}"\
        "${deviceList[$(($device + 2))]}"
    done

    printf "%4s)   Exit\n" "x"

    # Get input from user
    read -p "Choose a menu option: " input

    # Input validation
    if [ "$input" = "X" ] || [ "$input" = "x" ]
    then
      echo "Exiting"
      exit 0
    fi

    if (( $input>=0 )) && (( $input<$deviceCount ))
    then
      echo "Unmounting: ${deviceList[$(($input * $deviceCount))]}"
      sudo umount "${deviceList[$(($input * $deviceCount))]}"
      exit 0
    else
      echo "Invalid menu choice"
      exit 1
    fi

Note:This script requires that you have sudo installed and that you have
sudo rights.

Retrieved from
"https://wiki.archlinux.org/index.php?title=USB_Storage_Devices&oldid=286400"

Category:

-   Storage

-   This page was last modified on 5 December 2013, at 18:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
