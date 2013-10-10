ISCSI Target
============

> Summary

How to set up an iSCSI Target using different tools.

> Series

iSCSI Target

iSCSI Initiator

> Related

iSCSI Boot

With Wikipedia:iSCSI you can access storage over an IP-based network.

The exported storage entity is the target and the importing entity is
the initiator.

There are different modules available to set up the target. The SCSI
Target Framework (STGT/TGT) was the standard before linux 2.6.38. The
current standard is the LIO target. The iSCSI Enterprise Target (IET) is
an old implementation and SCSI Target Subsystem (SCST) is the successor
of IET and was a possible candidate for kernel inclusion before the
decision fell for LIO.

There are packages available for LIO, STGT and IET in the AUR (see
below).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Setup with LIO Target                                              |
|     -   1.1 Using targetcli                                              |
|         -   1.1.1 Authentication                                         |
|             -   1.1.1.1 Disable Authentication                           |
|             -   1.1.1.2 Set Credentials                                  |
|                                                                          |
|     -   1.2 Using (plain) LIO utils                                      |
|     -   1.3 Tips & Tricks                                                |
|     -   1.4 Upstream Documentation                                       |
|                                                                          |
| -   2 Setup with SCSI Target Framework (STGT/TGT)                        |
| -   3 Setup with iSCSI Enterprise Target (IET)                           |
|     -   3.1 Create the Target                                            |
|         -   3.1.1 Hard Drive Target                                      |
|         -   3.1.2 File based Target                                      |
|                                                                          |
|     -   3.2 Start server services                                        |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Setup with LIO Target
---------------------

LIO target is included in the kernel since 2.6.38. However, the iSCSI
target fabric is included since linux 3.1.

The important kernel modules are target_core_mod and iscsi_target_mod,
which should be in the kernel and loaded automatically.

/etc/rc.d/target is included in targetcli-fb when you use the free
branch or a less clean version in lio-utils when you use the original
targetcli or lio-utils directly.

You start LIO target with

    # /etc/rc.d/target start

This will load necessary modules, mount the configfs and load previously
saved iscsi target configuration.

With

    # /etc/rc.d/target status

you can show some information about the running configuration.

You might want to include target in your rc.conf#Daemons.

You can use targetcli to create the whole configuration or you can
alternatively use the lio utils tcm_* and lio_* directly (deprecated).

> Using targetcli

It is recommended to install the free branch targetcli-fb from AUR with
the dependencies rtslib-fb and configshell-fb.

There is also the original targetcli package available, but it is
additionally dependent on lio-utils and epydoc. The external manual is
only available in the free branch. targetd is not in AUR yet, but this
depends on the free branch.

The config shell creates most names and numbers for you automatically,
but you can also provide your own settings. At any point in the shell
you can type help in order to see what commands you can issue here.

Tip:You can use tab-completion in this shell

After starting the target (see above) you enter the configuration shell
with

    # targetcli

In this shell you include a block device (here:
/dev/disk/by-id/md-name-nas:iscsi) to use with

    /> cd backstores/block/backstores/block> create md_block0 /dev/disk/by-id/md-name-nas:iscsi

Note:You can use any block device, also raid and lvm devices. You can
also use files when you go to fileio instead of block.

You then create an iSCSI Qualified Name (iqn) and a target portal group
(tpg) with

    ...> cd /iscsi/iscsi> create

Note:With appending an iqn of your choice to create you can keep
targetcli from automatically creating an iqn

In order to tell LIO that your block device should get used as backstore
for the target you issue

    .../tpg1> cd luns.../tpg1/luns> create /backstores/block/md_block0

Then you need to create a portal, making a daemon listen for incoming
connections:

    .../luns/lun0> cd ../../portals.../portals> create

Targetcli will tell you the IP and port where LIO is listening for
incoming connections (defaults to 0.0.0.0 (all)). You will need at least
the IP for the clients. The port should be the standard port 3260.

In order for a client/initiator to connect you need to include the iqn
of the initiator in the target configuration:

    ...> cd ../../acls.../acls> create iqn.2005-03.org.open-iscsi:SERIAL

Instead of iqn.2005-03.org.open-iscsi:SERIAL you use the iqn of an
initiator. It can normally be found in /etc/iscsi/initiatorname.iscsi.
You have to do this for every initiator that needs to connect. Targetcli
will automatically map the created lun to the newly created acl.

Note:You can change the mapped luns and whether the access should be rw
or ro. See help create at this point in the targetcli shell.

The last thing you have to do in targetcli when everything works is
saving the configuration with:

    ...> cd /
    /> saveconfig

The will the configuration in /etc/target/saveconfig.json. You can now
safely start and stop /etc/rc.d/target without losing your
configuration.

Tip:You can give a filename as a parameter to saveconfig and also clear
a configuration with clearconfig

Authentication

Authentication per CHAP is enabled per default for your targets. You can
either setup passwords or disable this authentication.

Disable Authentication

Navigate targetcli to your target (i.e. /iscsi/iqn.../tpg1) and

    .../tpg1> set attribute authentication=0

Warning:With this setting everybody that knows the iqn of one of your
clients (initiators) can access the target. This is for testing or home
purposes only.

Set Credentials

Navigate to a certain acl of your target (i.e.
/iscsi/iqn.../tpg1/acls/iqn.../) and

    ...> get auth

will show you the current authentication credentials.

    ...> set auth userid=foo
    ...> set auth password=bar

Would enable authentication with foo:bar.

> Using (plain) LIO utils

You have to install lio-utils from AUR and the dependencies (python2).

> Tips & Tricks

-   With targetcli sessions you can list the current open sessions. This
    command is included in the targetcli-fb package, but not in
    lio-utils or the original targetcli.

> Upstream Documentation

-   targetcli
-   LIO utils
-   You can also use man targetcli when you installed the free branch
    version targetcli-fb.

Setup with SCSI Target Framework (STGT/TGT)
-------------------------------------------

You will need the Package tgt from AUR.

See: TGT iSCSI Target

Setup with iSCSI Enterprise Target (IET)
----------------------------------------

You will need iscsitarget-kernel and iscsitarget-usr from AUR.

> Create the Target

Modify /etc/iet/ietd.conf accordingly

Hard Drive Target

    Target iqn.2010-06.ServerName:desc
    Lun 0 Path=/dev/sdX,Type=blockio

File based Target

Use "dd" to create a file of the required size, this example is 10GB.

    dd if=/dev/zero of=/root/os.img bs=1G count=10

    Target iqn.2010-06.ServerName:desc
    Lun 0 Path=/root/os.img,Type=fileio

> Start server services

    rc.d start iscsi-target

Also you can "iscsi-target" to DAEMONS in /etc/rc.conf so that it starts
up during boot.

See also
--------

-   iSCSI Boot Booting Arch Linux with / on an iSCSI target.
-   Persistent block device naming in order to use the correct block
    device for a target

Retrieved from
"https://wiki.archlinux.org/index.php?title=ISCSI_Target&oldid=250134"

Categories:

-   Storage
-   Networking
