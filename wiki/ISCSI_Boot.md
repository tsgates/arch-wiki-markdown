ISCSI Boot
==========

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The actual boot will use an extra drive / usb drive or pxe boot?

Summary

How to install Arch on an iSCSI target.

Related

iSCSI Target

iSCSI Initiator

You can install Arch on an iSCSI Target. This howto will guide you
through the process.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Server / Target Setup                                              |
| -   2 Client / Initiator Setup                                           |
|     -   2.1 Install over iSCSI                                           |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 Device not found                                             |
+--------------------------------------------------------------------------+

Server / Target Setup
---------------------

You can set up an iSCSI target with any hosting server OS. Follow the
procedure outlined in iSCSI Target if you use Arch Linux as the hosting
server OS.

Client / Initiator Setup
------------------------

> Install over iSCSI

Download Arch Linux ISO image [1] and boot Arch Linux using the ISO
image. After Arch Linux is booted, either use net as the install source
or manually ifconfig and dhcp.

Now before you continue to "Prepare Hard Drive(s)" install open-iscsi
and connect to target.

Be sure to your servers IP address, Name, etc.

    wget https://aur.archlinux.org/packages/op/open-iscsi/open-iscsi.tar.gz

    tar xzvf open-iscsi.tar.gz

    cd open-iscsi

    pacman -Sy

    pacman -S patch make gcc

    makepkg --asroot

    pacman -U open-iscsi...pkg.tar.xz

    modprobe iscsi_tcp

    iscsistart -i iqn.2010-06.ClientName:desc -t iqn.2010-06.ServerName:desc -g 1 -a 192.168.1.100

During the above procedures, if "pacman -Sy" asks you to upgrade pacman,
answer "no" otherwise pacman may fail to install patch, make, and gcc,
which are essential to the compilation of the open-iscsi source.

(Optional) If you want to make sure that your iSCSI target is up and
running, you may start "iscsid" and check whether the iSCSI target is
available.

    # iscsid
    # iscsiadm -m discovery -t sendtargets -p <server-IP>

Continue to prepare the hard drive, using the iSCSI target drive. It is
suggested that you manually create a partition that uses the entire
iSCSI target drive.

Note:When you "Manually Configure block devices, filesystems and
mountpoints" make sure that you use UUID. This way there won't be any
issues booting if the number of devices changes (/dev/sda /dev/sdb ...)
by adding or removing hard drives, usb thumb drives, etc... or booting
it on different machines.

Note:It is recommended that you NOT include swap on the iSCSI drive when
creating the partitions, you can just ignore the warning.

Before you "Configure System" you must install open-iscsi to the
"future" root filesystem, and download and install the hook for booting
from iSCSI. This should be done after all selected packages are
installed.

Create these hook files, replacing the IP, etc. You may create these
hook files after open-iscsi is installed to the "future" filesystem.

1. /mnt/usr/lib/initcpio/install/iscsi: It should look like the
following.

    # vim: set ft=sh:

    build ()
    {
        local mod
        for mod in iscsi_tcp libiscsi libiscsi_tcp scsi_transport_iscsi crc32c; do
            add_module "$mod"
        done

        add_checked_modules "/drivers/net"
        add_binary "/sbin/iscsistart"
        add_runscript
    }

    help ()
    {
    cat <<HELPEOF
      This hook allows you to boot from an iSCSI target.
    HELPEOF
    }

2. /mnt/usr/lib/initcpio/hooks/iscsi: It should look like the following.

    # vim: set ft=sh:

    run_hook ()
    {
        modprobe iscsi_tcp
        ifconfig eth0 192.168.1.101 netmask 255.255.255.0 broadcast 192.168.1.255
        sleep 10
        iscsistart -i iqn.2010-06.ClientName:desc -t iqn.2010-06.ServerName:desc -g 1 -a 192.168.1.100
    }

If you want to use dhcp for the above script, you may try to replace the
"ifconfig" line with "dhcpcd eth0", but make sure that dhcpcd is
installed.

Now, you can install open-iscsi into the "future" root filesystem.

    mv open-iscsi...pkg.tar.xz /mnt/root

    chroot /mnt/ /bin/bash

    cd /root/

    pacman -U open-iscsi...pkg.tar.xz

Now you can create the above hook files by pasting the above scripts.

    nano /lib/initcpio/install/iscsi

    nano /lib/initcpio/hooks/iscsi

    exit

Now you are ready to "Configure System." Most of the configuration files
can remain unchanged.

Add "iscsi" to the HOOKS in /etc/mkinitcpio.conf. The "mkinitcpio" will
generate a new kernel image after you are done with "Configure System."

Note:If you plan on booting this installation of Arch on machines with
nic cards that require different modules, remove "autodetect" from HOOKS

Note:Rebuilding the initial ramdisk will take some time if autodetect is
removed from HOOKS

When configuring grub find the lines for Arch that are

    root (hdX,0)

and change to

    root (hd0,0)

Troubleshooting
---------------

> Device not found

If you are having problems with detecting your eth0 interface, simply
install mkinitcpio-nfs-utils package from the official repositories and
dhcpcd on your iSCSI drive and add net HOOK to /etc/mkinitcpio.conf.

Also add ip=::::::dhcp to your kernel parameters and now you can use
dhcpcd eth0 as described before.

For more informations, please refer to [2].

Retrieved from
"https://wiki.archlinux.org/index.php?title=ISCSI_Boot&oldid=244295"

Categories:

-   Getting and installing Arch
-   Networking
-   Storage
