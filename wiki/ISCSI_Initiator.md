ISCSI Initiator
===============

Summary

How to access an iSCSI Target with an initiator.

Series

iSCSI Target

iSCSI Initiator

Related

iSCSI Boot

With Wikipedia:iSCSI you can access storage over an IP-based network.

The exported storage entity is the target and the importing entity is
the initiator.

The preferred initiator is Open-iSCSI as of 2011. An older initiator,
Linux-iSCSI, was merged with Open-iSCSI. Linux-iSCSI should not be
confused with linux-iscsi.org, the website for the LIO target.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Setup With Open-iSCSI                                              |
|     -   1.1 Using the Daemon                                             |
|                                                                          |
| -   2 Using the Tools                                                    |
|     -   2.1 Target discovery                                             |
|     -   2.2 Delete obsolete targets                                      |
|     -   2.3 Login to available targets                                   |
|     -   2.4 Info                                                         |
|     -   2.5 Online resize of volumes                                     |
|                                                                          |
| -   3 Tips                                                               |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Setup With Open-iSCSI
---------------------

Even open-iscsi is not in the official repositories, so you need to
build it from AUR.

> Using the Daemon

You only have to include the IP of the target as SERVER in
/etc/conf.d/open-iscsi at the client.

At the server (target) you might need to include the client iqn from
/etc/iscsi/initiatorname.iscsi in the acl configuration.

After both steps are finished you should be able to start the initiator
with

    # systemctl enable open-iscsi.service
    # systemctl start open-iscsi.service

You can see the current sessions with

    # systemctl status open-iscsi.service

Using the Tools
---------------

iscsid has to be running.

> Target discovery

    # iscsiadm -m discovery -t sendtargets -p <portalip>

> Delete obsolete targets

    # iscsiadm -m discovery -p <portalip> -o delete

> Login to available targets

    # iscsiadm -m node -L all

or login to specific target

    # iscsiadm -m node --targetname=<targetname> --login

logout:

    # iscsiadm -m node -U all

> Info

For running session

    # iscsiadm -m session -P 3

For the known nodes

    # iscsiadm -m node

> Online resize of volumes

If the iscsi blockdevice contains a partitiontable, you will not be able
to do an online resize. In this case you have to unmount the filesystem
and alter the size of the affected partition.

1.  Rescan active nodes in current session

        # iscsiadm -m node -R

2.  If you use multipath, you also have to rescan multipath volume
    information.

        # multipathd -k"resize map sdx"

3.  Finally resize the filesystem.

        # resize2fs /dev/sdx

Tips
----

You can also check where the attached iSCSI devices are located in the
/dev tree with ls -lh /dev/disk/by-path/* .

See also
--------

-   iSCSI Boot Booting Arch Linux with / on an iSCSI target.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ISCSI_Initiator&oldid=244938"

Categories:

-   Storage
-   Networking
