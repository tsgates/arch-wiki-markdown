Create root filesystem snapshots with LVM
=========================================

> Summary

Setup root filesystem LVM snapshot creation during system start.

Such snapshots can be used for full system backups with minimal downtime
or testing system updates with the option to revert them.

Required software

lvm2, systemd

> Related

LVM

Full System Backup with tar

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prerequisites                                                      |
| -   2 Setup                                                              |
| -   3 Usage                                                              |
|     -   3.1 Backup                                                       |
|     -   3.2 Revert updates                                               |
|                                                                          |
| -   4 Known issues                                                       |
+--------------------------------------------------------------------------+

Prerequisites
-------------

You need a system with LVM root filesystem and systemd. Ensure that LVM
snapshots prerequisites are correctly setup.

Setup
-----

During system start a clean snapshot of the root volume is created using
a new systemd service. Create
/etc/systemd/system/mk-lvm-snapshots.service containing:

    [Unit]
    Description=make LVM snapshots
    Requires=local-fs-pre.target
    DefaultDependencies=no
    Conflicts=shutdown.target
    After=local-fs-pre.target
    Before=local-fs.target

    [Install]
    WantedBy=make-snapshots.target

    [Service]
    Type=oneshot
    ExecStart=/usr/sbin/lvcreate -L10G -n snap-root -s lvmvolume/root

Adapt the lvcreate command to match your root volume group and volume
name. Adjust the snapshot size if necessary. If additional filesystems
should be snapshotted during startup you may extend the ExecStart
property with addtional lvcreate commands, separated with  ; .

Note:You should test the # lvcreate command in the running system until
it works as desired.

Remove the test snapshots with # lvremove. The snapshots taken from a
running system are

not as consistent as snapshots taken in single user mode or during
startup.

Create a new systemd target /etc/systemd/system/make-snapshots.target:

    [Unit]
    Description=Make Snapshots
    Requires=multi-user.target

Adapt the base target, if multi-user.target is not your default target.

Enable the new service with # systemctl enable mk-lvm-snapshots.service.

If the system is started with the new target, LVM snapshot(s) are
created just after mounting the local filesystems. To get a grub menu
entry starting this target create /boot/grub/custom.cfg based on the
grub.cfg entry for your normal startup. The kernel command line is
extended to start the new make-snapshots.target:

    ### make snapshots ###
    menuentry 'Arch GNU/Linux, make snapshots' --class arch --class gnu-linux --class gnu --class os {
    ...
            echo    'Loading Linux core repo kernel ...'
            linux   /boot/vmlinuz-linux root=/dev/mapper/lvmvolume-root ro systemd.unit=make-snapshots.target
            echo    'Loading initial ramdisk ...'
            initrd  /boot/initramfs-linux.img
    } 

Remember to adjust custom.cfg if grub.cfg changes.

After restarting the system with this grub entry # lvs should show up
the newly created snapshot.

Tip:To get the messages of the new service use
# journalctl -u mk-lvm-snapshots.service.

Usage
-----

> Backup

To use this functionality for a full system backup, restart your system
with the snapshot creation target. Mount the snapshot volume (and
further volumes, if required), preferably using the read only (-o)
option. Then backup your system, for example with tar as described in
Full_System_Backup_with_tar.

During backup you can continue to use your system normally, since all
changes to your regular volumes are invisible in the snapshots. Do not
forget to delete the snapshot volume after the backup – changes to your
regular volume will use up space in the snapshot due to the
copy-on-write operations. If the snapshot space becomes fully used, and
LVM is not able to automatically grow the snapshot, LVM will deny
further writes to your regular volumes or drop the snapshot, which
should be avoided.

> Revert updates

An other use for LVM snapshots is testing and reverting of updates. In
this case create a snapshot for the system in a known good state and
perform updates or changes afterwards.

If you want to permantly stick to the updates just drop the snapshot
with # lvremove. If you want to revert to the snapshotted state issue a
# lvchange --merge for the snapshot. During the next restart of the
system (use the default target) the snapshot is merged back into your
regular volume. All changes to the volume happened after the snapshot
are undone.

Note:After merging the snapshot no longer exists. Recreate a new
snapshot if further testing with rollback option is desired.

Known issues
------------

Due to bug 681582 shutting down the system with active snapshots may
hang for some time (currently 1...3 minutes). As a workaround a shorter
job timeout can be set. Create a copy of
/usr/lib/systemd/system/dmeventd.service in /etc/systemd/system and
insert JobTimeoutSec=10:

    [Unit]
    Description=Device-mapper event daemon
    Documentation=man:dmeventd(8)
    Requires=dmeventd.socket
    After=dmeventd.socket
    DefaultDependencies=no
    JobTimeoutSec=10

    [Service]
    Type=forking
    ExecStart=/usr/sbin/dmeventd
    ExecReload=/usr/sbin/dmeventd -R
    Environment=SD_ACTIVATION=1
    PIDFile=/run/dmeventd.pid
    OOMScoreAdjust=-1000

Retrieved from
"https://wiki.archlinux.org/index.php?title=Create_root_filesystem_snapshots_with_LVM&oldid=255793"

Category:

-   System recovery
