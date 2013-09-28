Advanced Format
===============

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
|     -   1.1 More Detailed Explanation                                    |
|     -   1.2 External Links                                               |
|                                                                          |
| -   2 Current HDD Models that Employ a 4k Sectors                        |
| -   3 How to determine if HDD employ a 4k sector                         |
| -   4 Aligning Partitions                                                |
|     -   4.1 Check your partitions alignment                              |
|     -   4.2 GPT (Recommended)                                            |
|     -   4.3 MBR (Not Recommended)                                        |
|                                                                          |
| -   5 Special Consideration for WD Green HDDs                            |
|     -   5.1 Disable via hdparm                                           |
|         -   5.1.1 Is this safe?                                          |
|                                                                          |
|     -   5.2 Disable via changing firmware value (persistent)             |
+--------------------------------------------------------------------------+

Introduction
------------

The 'advanced format' feature reduces overhead by using 4 kilobyte
sectors instead of the traditional 512 byte sectors. The old format gave
a format efficiency of 87%. Advanced Format results in a format
efficiency of 96% which increases space by up to 11%. The 4k sector is
slated to become the next standard for HDDs by 2014.

> More Detailed Explanation

The main idea behind using 4096-byte sectors is to increase the bit
density on each track by reducing the number of gaps which hold Sync/DAM
and ECC (Error Correction Code) information between data sectors. For
eight 512-byte sectors, the track also holds eight sector gaps.

By having one single sector of size 4096-byte (8 x 512-byte), the track
holds only 1 sector gap for each data sector thus reducing an overhead
for a need to support multiple Sync/DAM and ECC blocks and at the same
time increasing bit density.

Linux partitioning tools by default start each partition on sector 63
which leads to a bad performance in HDDs that use this 4K sector size
due to misalignment to 4K sector from the beginning of the track.

> External Links

-   Western Digital’s Advanced Format: The 4K Sector Transition Begins
-   White paper entitled "Advanced Format Technology."
-   Failure to align one's HDD results in poor read/write performance.
    See this article for specific examples.

Current HDD Models that Employ a 4k Sectors
-------------------------------------------

As of June 2011, there are a limited number of HDDs that support
"Advanced Format" or 4k sectors as shown below.

All drives in this list have a physical sector size of 4096 bytes, but
not all drives correctly report this to the OS. The actual value
reported (via new fields in the ATA-8 spec) is shown in the table as the
physical reported sector size. As this is the value partitioning tools
use for alignment, it is important that it should be 4096 to avoid
misalignment issues.

The logical sector size is the sector size used for data transfer. This
value multiplied by the number of LBA sectors on the disk gives the disk
capacity. Thus a disk with 4096 byte logical sectors will have a lower
maximum LBA for the same capacity compared to a drive with 512 byte
sectors. Drives with 512 byte logical sectors offer better compatibility
with legacy operating systems (roughly those released before 2009)
however drives with 4096 byte logical sectors may offer marginally
better performance (e.g. more read/write requests may fit into the NCQ
buffer.)

Manufacturer

Model

Capacity

Reported sector size (bytes)

Logical

Physical

3.5"

Western Digital

WD30EZRX

3.0 TB

512

4096

Western Digital

WD30EZRSDTL

3.0 TB

Western Digital

WD25EZRSDTL

2.5 TB

Samsung

HD204UI

2.0 TB

512

512

Seagate

ST1000DL002

1.0 TB

512

4096

Seagate

ST1000DM003

1.0 TB

512

4096

Seagate

ST2000DL003

2.0 TB

512

512

Seagate

ST2000DM001

2.0 TB

512

4096

Seagate

ST3000DM001

3.0 TB

512

4096

Western Digital

WD20EARS

2.0 TB

512

512

Western Digital

WD20EARX

2.0 TB

512

4096

Western Digital

WD20EFRX

2.0 TB

512

4096

Western Digital

WD15EARS

1.5 TB

512

4096

Western Digital

WD10EARS

1.0 TB

Western Digital

WD10EURS

1.0 TB

Western Digital

WD8000AARS

800.0 GB

Western Digital

WD6400AARS

640.0 GB

2.5"

Seagate

ST9750420AS

750 GB

512

4096

Western Digital

WD10JPVT

1.0 TB

512

4096

Western Digital

WD10TPVT

1.0 TB

Western Digital

WD7500BPVT

750.0 GB

Western Digital

WD7500KPVT

750.0 GB

Western Digital

WD6400BPVT

640.0 GB

Western Digital

WD5000BPVT

500.0 GB

Western Digital

WD3200BPVT

320.0 GB

Western Digital

WD2500BPVT

250.0 GB

512

4096

Western Digital

WD1600BPVT

160.0 GB

TOSHIBA

MQ01ABD100

1.0 TB

512

4096

Note: Readers are encouraged to add to this table.

How to determine if HDD employ a 4k sector
------------------------------------------

Tools which will report the physical sector of a drive (provided the
drive will report it correctly) includes

-   smartmontools (since 5.41 ; smartmontools -a, in information
    section)
-   hdparm (since 9.12 ; hdparm -I, in configuration section)

Note that both works even for USB-attached discs (if the USB bridge
supports SAT aka SCSI/ATA Translation, ANSI INCITS 431-2007).

Aligning Partitions
-------------------

Note:This should no longer require manual intervention. Any tools using
recent libblkid versions are capable of handling Advanced Format
automatically.

Versions with this support include:

-   fdisk, since util-linux >= 2.15. You should start with ‘-c -u’ to
    disable DOS compatibility and use sectors instead of cylinders.
-   parted, since parted >= 2.1.
-   mdadm, since util-linux >= 2.15
-   lvm2, since util-linux >= 2.15
-   mkfs.{ext,xfs,gfs2,ocfs2} all support libblkid directly.

Refer to this page for further information.

> Check your partitions alignment

Note:This only works with MBR, not GPT.

    # fdisk -lu /dev/sda
    ...
    # Device     Boot      Start   End         Blocks      Id System
    # /dev/sda1            2048    46876671    23437312    7  HPFS/NTFS

2048 (default since fdisk 2.17.2) means that your HDD is aligned
correctly. Any other value divisible by 8 is good as well.

> GPT (Recommended)

When using GPT partition tables, one need only use gdisk to create
partitions which are aligned by default. For an example, see
SSD#Detailed_Usage_Example.

> MBR (Not Recommended)

One can employ fdisk to align partitions to sector 2048 which will
ensure that the partitions are aligned to the 4k sector. Interestingly,
in sector mode, the default starting point is not 63 or 64 but 2048 in
the current version of fdisk (2.17.2) so it is automatically taking care
of the 4k sector size!

    # fdisk -c -u /dev/sda

Special Consideration for WD Green HDDs
---------------------------------------

FYI - this section has nothing to do with Advanced Format technology,
but this is an appropriate location to share it with users. The WD20EARS
(and other sizes include 1.0 and 1.5 TB driver in the series) will
attempt to park the read heads once every 8 seconds FOR THE LIFE OF THE
HDD which is just horrible! To see if you are affected use the smartctl
command (part of smartmontools). If the last column changes rapidly,
this section applies to your drive.

    # smartctl /dev/sdb -a | grep Load_Cycle
    193 Load_Cycle_Count        0x0032   001   001   000    Old_age   Always       -       597115

> Disable via hdparm

Use hdparm in /etc/systemd/system/lcc_fix.service to disable this
'feature' and likely add life to your hdd:

    /etc/systemd/system/lcc_fix.service 

    [Unit]
    Description=WDIDLE3

    [Service]
    Type=oneshot
    ExecStart=/sbin/hdparm -J 300 --please-destroy-my-drive /dev/sdX
    TimeoutSec=0
    StandardInput=tty
    RemainAfterExit=yes

    [Install]
    WantedBy=multi-user.target

Start the service

    # systemctl start lcc_fix.service

Enable the service to autorun at boot.

    # systemctl enable lcc_fix.service

Is this safe?

    Why do we need to pass the "--please-destroy-my-drive" flag?  Here is an email from hdparm author, Mark Lord:

    > I have a Western DIgital \"Green\" drive (wd20ears).  I noticed you added a -J switch and that 
    > it is said to adjust the idle3 timeout.  What frightens me is the output you gave it:
    > 
    > How safe or not is this to use?

    I use it on my own drives.  It works for me.

    If you can run the WDIDLE3.EXE MS-Dos program,
    then use it instead -- it was written by WD,
    and only they know how things really work there.

    If you cannot use the WDIDLE3.EXE, then you
    could consider "hdparm -J".  It works for me,
    but it may or may not void some kind of warranty.

    Cheers
    -- 
    Mark Lord
    Real-Time Remedies Inc.
    mlord@pobox.com

> Disable via changing firmware value (persistent)

Warning:The tool used in this process is experimental, use at your own
risk!

Note:This method is persistant, you only need to do this once for every
drive.

This method will use a utility called idle3ctl to alter the firmware
value for the idle3 timer on WD hard drives (similar to wdidle3.exe from
WD). The advantage compared to the official utility is you do not need
to create a DOS bootdisk first to change the idle3 timer value.
Additionally idle3ctl might also work over USB-to-S-ATA bridges (in some
cases). Download idle3ctl, extract and compile it. Within the folder
that contains the newly compiled binary, execute

     $ sudo ./idle3ctl -g /dev/your_wd_hdd

to get the raw idle3 timer value. You can disable the Intellipark
feature completely, with:

     $ sudo ./idle3ctl -d /dev/your_wd_hdd

or set it to a different value (0-255) with (e.g. 10 seconds):

     $ sudo ./idle3ctl -s 100 /dev/your_wd_hd

The range 0-128 is in 0.1s and 129-255 in 30s. For the chages to take
effect, the drive needs to go through one powercycle, meaning powering
it off and on again (on internal drives, a reboot is not sufficient).

If your WD hard drive is not recognized, you can use the --force option.
For more options see:

     $ ./idle3ctl -h

Retrieved from
"https://wiki.archlinux.org/index.php?title=Advanced_Format&oldid=255118"

Category:

-   Storage
