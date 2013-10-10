AIF Configuration File
======================

Note:AIF (the Arch Installation Framework) is no longer included since
2012.07.15. Instead some simple install scripts are provided to aid in
the installation process. See the news.

The Arch Installation Framework used to be the backbone to the Arch
Linux distribution installer. The AIF executes all of the routines used
to install Arch.

The AIF configuration file contains variables that define how Arch will
be installed. This article describes these variables, and how to make
use of the configuration file.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 The AIF configuration file                                         |
|     -   1.1 Optional variables                                           |
|         -   1.1.1 SOURCE                                                 |
|         -   1.1.2 FILE_URL                                               |
|         -   1.1.3 SYNC_URL                                               |
|         -   1.1.4 RUNTIME_REPOSITORIES                                   |
|         -   1.1.5 RUNTIME_PACKAGES                                       |
|         -   1.1.6 TARGET_GROUPS                                          |
|         -   1.1.7 TARGET_REPOSITORIES                                    |
|         -   1.1.8 TARGET_PACKAGES_EXCLUDE                                |
|         -   1.1.9 TARGET_PACKAGES                                        |
|                                                                          |
|     -   1.2 Mandatory variables                                          |
|         -   1.2.1 GRUB_DEVICE                                            |
|         -   1.2.2 PARTITIONS                                             |
|         -   1.2.3 BLOCKDATA                                              |
|             -   1.2.3.1 Simple file systems                              |
|             -   1.2.3.2 Advanced file systems                            |
|                                                                          |
| -   2 Using the AIF configuration file                                   |
| -   3 Examples                                                           |
| -   4 Links                                                              |
+--------------------------------------------------------------------------+

The AIF configuration file
--------------------------

The aif command can be executed with a configuration file which defines
how Arch is to be installed. This is a similar concept to Red Hat's
kickstart and Debian's preseed. But the similarities end with the
concept, thanks to the Arch KISS philosophy the pain involved in
automated installs is swept away. AIF is written entirely in bash, and
the AIF configuration file is just that, bash. All of the variables and
function definitions in the AIF configuration file are sourced shortly
after the install begins and applied to the install.

With this in mind, the AIF configuration file is simply a representation
of all of that data which can be defined in the global scope of the AIF.
This means that available variables can be found in the AIF source code.

> Optional variables

The following variables are available in the AIF configuration file:

SOURCE

The source variable will be either CD or net, and will define whether
the packages used are locally available or found over the
network/Internet.

for local files:

    SOURCE=cd

or for a source over the network/Internet

    SOURCE=net

FILE_URL

The local directory containing Arch Linux packages, used if SOURCE=cd

    FILE_URL=file:///src/repo/pkg

SYNC_URL

The network location used to sync packages over the network. What is
important about this variable is that it is the same line that is placed
in /etc/pacman.d/mirrorlist. So it is wise to use the $repo and $arch
variables:

    SYNC_URL=http://mirror.rit.edu/archlinux/$repo/os/$arch

RUNTIME_REPOSITORIES

RUNTIME_PACKAGES

TARGET_GROUPS

The groups to install, like base

    TARGET_GROUPS=base

TARGET_REPOSITORIES

TARGET_PACKAGES_EXCLUDE

Packages to exclude from the install

    TARGET_PACKAGES_EXCLUDE='reiserfsprogs nano'

TARGET_PACKAGES

Packages to include in the install

    TARGET_PACKAGES='openssh vim'

> Mandatory variables

These variables are the hard ones, and honestly the primary reason for
this wiki entry, because they, like the hard drives they configure, can
be complicated

GRUB_DEVICE

The GRUB_DEVICE variable is a simple one, it is the device that will
hold the grub mbr. This is almost always the primary hard drive.

    GRUB_DEVICE='/dev/sda'

PARTITIONS

The partitions line is used to load up sfdisk for disk carving. It is a
space delimited list which begins with the device to carve up and then a
set of colon delimited arguments which define the device sizes, type and
options.

    PARTITIONS='/dev/sda 100:ext2:+ 512:swap *:ext4'

Here the disk to be carved up is /dev/sda, 3 partitions will be created,
/dev/sda1 will be 100 Megabytes, Linux type, and the "+" sets the grub
bootable flag. /dev/sda2 is 512 Megabytes and the swap type, /dev/sda3
will take up the rest of the space, and have the type Linux.

Entry syntax:

    DEVICE_PATH PARTITIONING_SCHEME
     
      PARTITIONING_SCHEME  := PARTITION_SIZE:FILESYSTEM_TYPE[:PARTION_FLAGS] [ PARTITIONING_SCHEME ]

          PARTITION_SIZE  := [ MEBIBYTE_SIZE | * ]
          FILESYSTEM_TYPE := { raw | ext2 | ext3 | ext4 | xfs | jfs | vfat | brtfs | swap | lvm-pv | lvm-vg | lvm-lv }
          PARTITION_FLAGS := +

If you want to skip partitioning, override one of the worker functions
to do nothing:

     worker_prepare_disks () {
       true
     }

BLOCKDATA

The BLOCKDATA variable is used to determine which partitions are
formatted and how they are to be mounted. While static partitions are
simple and straightforward, LVM and crypt setups on the other hand can
get somewhat messy.

Since AIF translates components of the variables into arguments for
commands, understanding what the commands are and how the arguments are
passed will greatly assist in understanding how to use the variables.

Entry syntax:

    BLOCK_DEVICE TYPE LABEL_NAME FS_STRING
      FS_STRING      := { FS_DESCRIPTION | no_fs }

      FS_DESCRIPTION := TYPE;RECREATE;MOUNT_PATH;MOUNT_LOCATION;MOUNT_OPTS;LABEL_NAME;PARAMS[|FS_DESCRIPTION]

         RECREATE    := { yes | no }                     # Re-format?
         PARAMS      := { PARAMETERS | no_params }       # Formating utility parameters
         MOUNT_PATH  := { MOUNTPOINT | no_mountpoint }   # Partition mountpoint
         MOUNT_OPTS  := { MOUNTOPTS  | no_opts }         # Mounting options (see: man mount)
         MOUNT_LOCATION := { target | runtime | no }     # Where to mount partition:
                                                         #    target  - on system being installed
                                                         #    runtime - on host system
                                                         #    no      - do not mount

      TYPE        := { raw | ext2 | ext3 | ext4 | xfs | jfs |
                       vfat | brtfs | swap | lvm-pv | lvm-vg | lvm-lv }
      LABEL_NAME  := { LABEL | no_label }

     Notes:
       PARAMS/MOUNT_OPTS - spaces need to be replaced with underscores (_)

Simple file systems

Simple file systems can be defined on top of partitions derived from the
PARTITIONS variable.

A simple example:

    BLOCKDATA='/dev/vda1 raw no_label ext2;yes;/boot;target;no_opts;no_label;no_params
    /dev/vda2 raw no_label swap;yes;no_mountpoint;target;no_opts;no_label;no_params
    /dev/vda3 raw no_label ext4;yes;/;target;no_opts;no_label;no_params'

In this scenario, /dev/vda1 is a raw block device with no label, it is
to be formatted with the ext2 file system, yes verifies that it will be
formatted, /boot is the mount point, target <Not sure what target means
yet>, no_opts is where file system mount options are placed, no_label
can be replaced with a file system label. The parameters section is used
by more advanced partitioning mechanisms.

Advanced file systems

This example will create a /boot partition and a LVM volume group called
*system* with 5 partitions:

    /boot     => /dev/sda1              (ext3)
    /         => /dev/system/root [LVM] (xfs)
    /home     => /dev/system/home [LVM] (xfs)
    /tmp      => /dev/system/tmp  [LVM] (xfs)
    /var      => /dev/system/var  [LVM] (xfs)
    /usr      => /dev/system/usr  [LVM] (xfs)

The entry has extra whitespaces in order to increase readability (all
whitespaces get removed at the end).

    BLOCKDATA=$(echo '
    /dev/sda1               raw    no_label ext3;    yes; /boot        ; target; no_opts; no_label; no_params
    /dev/sda2               raw    no_label lvm-pv;  yes; no_mountpoint; target; no_opts; no_label; no_params
    /dev/sda2+              lvm-pv no_label lvm-vg;  yes; no_mountpoint; target; no_opts; system  ; /dev/sda2

    /dev/mapper/system      lvm-vg system   lvm-lv;  yes; no_mountpoint; target; no_opts; home    ; 1025M
    /dev/mapper/system      lvm-vg system   lvm-lv;  yes; no_mountpoint; target; no_opts; root    ; 1024M
    /dev/mapper/system      lvm-vg system   lvm-lv;  yes; no_mountpoint; target; no_opts; tmp     ; 1024M
    /dev/mapper/system      lvm-vg system   lvm-lv;  yes; no_mountpoint; target; no_opts; var     ; 1024M
    /dev/mapper/system      lvm-vg system   lvm-lv;  yes; no_mountpoint; target; no_opts; usr     ; 2048M

    /dev/mapper/system-home lvm-lv home     xfs;     yes; /home        ; target; no_opts; no_label; no_params
    /dev/mapper/system-root lvm-lv root     xfs;     yes; /            ; target; no_opts; no_label; no_params
    /dev/mapper/system-tmp  lvm-lv tmp      xfs;     yes; /tmp         ; target; no_opts; no_label; no_params
    /dev/mapper/system-var  lvm-lv var      xfs;     yes; /var         ; target; no_opts; no_label; no_params
    /dev/mapper/system-usr  lvm-lv usr      xfs;     yes; /usr         ; target; no_opts; no_label; no_params'| sed -r 's/ *; */;/g' | tr -s ' ')

Using the AIF configuration file
--------------------------------

> Note:

If you want to set the current keymap:

    # aif -p partial-keymap

and network settings:

    # aif -p partial-configure-network

(both settings are also automatically written to the installed system)

    # aif -p automatic -c <file>

Examples
--------

If the AIF is installed, examples can be found in
/usr/share/aif/examples/. Otherwise, see them on the project page.

Links
-----

-   https://github.com/Dieterbe/aif
-   https://github.com/Dieterbe/aif-configs/network

Retrieved from
"https://wiki.archlinux.org/index.php?title=AIF_Configuration_File&oldid=253459"

Category:

-   Getting and installing Arch
