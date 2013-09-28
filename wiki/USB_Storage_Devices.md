USB Storage Devices
===================

This document describes how to use the popular USB memory sticks with
Linux. However, it is also valid for other devices such as digital
cameras that act as if they were just a USB storage device.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Mounting USB devices                                               |
|     -   1.1 Auto-mounting with udev                                      |
|     -   1.2 Manual mounting                                              |
|         -   1.2.1 Getting a kernel that supports usb_storage             |
|         -   1.2.2 Identifying device                                     |
|             -   1.2.2.1 Using device node names ( /sd* )                 |
|             -   1.2.2.2 Using UUID                                       |
|                                                                          |
|         -   1.2.3 Mounting USB memory                                    |
|             -   1.2.3.1 As root                                          |
|             -   1.2.3.2 As normal user with mount                        |
|             -   1.2.3.3 As normal user with fstab                        |
|             -   1.2.3.4 Poor copy performance to USB pendrive            |
+--------------------------------------------------------------------------+

Mounting USB devices
--------------------

If you have an up-to-date system with the standard Arch kernel and a
modern Desktop Environment your device should just show up on your
desktop, with no need to open a console.

Otherwise see sections below.

> Auto-mounting with udev

See Udev:Auto mounting USB devices.

A lightweight solution to automount harddrives using udev, for
single-user systems, is the following: create a file named
/etc/udev/rules.d/automount.rules with the following content:

    ACTION=="add", ENV{DEVTYPE}=="partition", RUN+="domount %N"

and a file (executable by root) named /usr/lib/udev/domount with (set
the variables on top to the correct values):

    #!/bin/sh

    #edit the following variables to suit your needs
    MYUID=1000              # your user uid
    MYGID=100               # your user gid
    MYLOGIN=al              # your login
    TERM=lxterminal         # your terminal emulator
    MYSHELL=zsh             # your shell
    export DISPLAY=:0       # your X display


    TMPFILE=/run/automount.$RANDOM
    DIR=`cat /etc/fstab | grep -v '#' | grep $* | awk '{print $2;}'`
    if [ "x$DIR" = "x" ]; then
            MYUUID=`blkid -o value -s UUID $*`
            if [ "x$MYUUID" = "x" ]; then
                    MYUUID="unknown"
            fi
            DIR=/run/media/$MYUUID
    fi
    mkdir -p /run/media
    mkdir -p $DIR
    cat > $TMPFILE << EOF
    #!/bin/sh
    echo "$* will be mounted on $DIR. "
    sudo /bin/mount -o uid=$MYUID,gid=$MYGID $* $DIR
    cd $DIR
    $MYSHELL
    cd
    sudo /bin/umount $DIR
    EOF
    chmod a+x $TMPFILE
    su $MYLOGIN -c "$TERM -t 'Terminal - $* mounted on $DIR' -e $TMPFILE"
    sleep 1; rm -f $TMPFILE

When an harddrive is inserted, it will be mounted, and a Terminal will
pop-up. To umount the device, simply press Control+D in the terminal
window. The mountpoint is looked for in /etc/fstab or, if absent,
generated from the UUID of the partition.

To prevent your password to be asked at umount, add (replace you with
your login name) to /etc/sudoers using the visudo command. See
Sudo#Configuration

    you	ALL=(ALL) NOPASSWD: /bin/umount

If the terminal doesn't appear as expected, that may because wrong
options are used. For example, in xfce4, we use "Terminal -T <title> -e
<script-file> instead"

> Manual mounting

Note:Before you decide that Arch Linux does not mount your USB device,
be sure to check all available ports. Some ports might not share the
same controller, preventing you from mounting the device.

Getting a kernel that supports usb_storage

If you do not use a custom-made kernel, you are ready to go, for all
Arch Linux stock kernels are properly configured. If you do use a
custom-made kernel, ensure it is compiled with SCSI-Support,
SCSI-Disk-Support and usb_storage. If you use the latest udev, you may
just plug your device in and the system will automatically load all
necessary kernel modules. Older releases of udev would need hotplug
installed too. Otherwise, you can do the same thing manually:

    # modprobe usb-storage
    # modprobe sd_mod      (only for non SCSI kernels)

Identifying device

First thing one need to access storage device is it's identifier
assigned by kernel.

Using device node names ( /sd* )

This is the simplest way, but assigned name depends on order of
insertion. Ways to get node name:

-   search in the output of dmesg for the kernel device name, you can
    use grep to help you find what you are looking for:

    $ dmesg | grep -E "sd[a-z]"

-   running

    # fdisk -l

lists all available partition tables.

Note:If you cannot find your device you can use lsusb to verify that it
is indeed recognized by the system.

Using UUID

Every drive creates a UUID (Universally Unique Identifier), these
identifiers can be used to track individual drive no matter their device
node (ie /dev/sda).

To find the current UUIDs execute (as root):

    # blkid -o list -c /dev/null

    device         fs_type  label     mount point        UUID
    ------------------------------------------------------------------------------------------
    /dev/sda1      ext2               /boot              7f4cef7e-7ee2-489a-b759-d52ba23b692c
    /dev/sda2      swap               (not mounted)      a807fff3-e89f-46d0-ab17-9b7ad3efa7b5
    /dev/sda3      ext4               /                  81917291-fd1a-4ffe-b95f-61c05cfba76f
    /dev/sda4      ext4               /home              c4c23598-19fb-4562-892b-6fb18a09c7d3
    /dev/sdb1      ext4     X2        /mnt/X1            4bf265f7-da17-4575-8758-acd40885617b
    /dev/sdc1      ext4     X1        /mnt/X2            4bf265f7-da17-4575-8758-acd40885617b
    /dev/sdd1      ext4     Y2        /mnt/Y2            8a976a06-3e56-476f-b73a-ea3cad41d915
    /dev/sde1      ext4     Z2        /mnt/Z2            9d35eaae-983f-4eba-abc9-434ecd4da09c
    /dev/sdf1      ext4     Y1        /mnt/Y1            e2ec37a9-0689-46a8-a07b-0609ce2b7ea2
    /dev/sdg1      ext4     Z1        /mnt/Z1            9fa239c1-720f-42e0-8aed-39cf53a743ed
    /dev/sdj1      ext4     RAPT      (not mounted)      a9ed7ecb-96ce-40fe-92fa-e07a532ed157
    /dev/sdj2      swap               <swap>             20826c74-eb6d-46f8-84d8-69b933a4bf3f

Or to find this information with non-root privileges, use:

    $ lsblk -o name,kname,uuid

    NAME                     KNAME UUID
    sda                      sda   
    ├─sda1                   sda1  A103-2001
    └─sda2                   sda2  6i2E71-zJzL-KXuG-juYv-mbNY-kROA-XsIPlm
      ├─vg0-var (dm-0)       dm-0  cebi84r5-0401-491e-a0d6-de0j3bnw867c
      ├─vg0-home (dm-1)      dm-1  cceguid6-f3mc-4d7a-a1f2-83f2mkpds3q1
      └─vg0-root (dm-2)      dm-2  973ed4rf-6611-47ed-877c-b66yhn5tgbc7
    sdb                      sdb   
    └─sdb1                   sdb1  j1Pr1X-b0uM-bkWZ-KNYQ-gezL-YliV-ScRufFyD
      └─vg0-home (dm-1)      dm-1  cefmkbe6-f4n8-4d7a-al32-83f259ijn6t7
    sr0                      sr0   

  
 At this point you should see a list of your system drives and a long
strings of characters. These long strings are the uuids.

-   Now connect your USB device and wait for a few seconds . . .

-   Reexecute blkid -o list -c /dev/null

Notice a new device and UUID? That is your USB storage

Tip: If blkid does not work as expected, You can look for the UUIDs in
/dev/disk/by-uuid/:

    $ ls -lF /dev/disk/by-uuid/

Mounting USB memory

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

    $ sudo mount -o gid=users,fmask=113,dmask=002 /dev/sda1 /mnt/usbstick

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

Poor copy performance to USB pendrive

If you experienced slow copy speed to pendrive (mainly in KDE), then
merge this three line to the end of your /etc/rc.local:

    echo madvise > /sys/kernel/mm/transparent_hugepage/enabled
    echo madvise > /sys/kernel/mm/transparent_hugepage/defrag
    echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag

And paste these at the end of your /etc/sysctl.conf

    kernel.shmmax=134217728
    vm.dirty_background_bytes = 4194304
    vm.dirty_bytes = 4194304

And reboot. This also reduces the freezes of the KDE's panel.

Retrieved from
"https://wiki.archlinux.org/index.php?title=USB_Storage_Devices&oldid=246317"

Category:

-   Storage
