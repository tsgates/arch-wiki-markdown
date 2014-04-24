Btrfs - Tips and tricks
=======================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Btrfs.      
                           Notes: This article      
                           should have been a "Tips 
                           and tricks" sub-section  
                           instead of a new page.   
                           See discussion:          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Snapshots
    -   1.1 Automatic snapshots on each boot
        -   1.1.1 Requirements
        -   1.1.2 Snapshot script
        -   1.1.3 systemd unit file
    -   1.2 Booting into snapshots
        -   1.2.1 GRUB
-   2 Backup solutions

Snapshots
---------

> Automatic snapshots on each boot

It is possible to automatically save the then current state of a btrfs
subvolume during system boot. Two files are needed to accomplish this, a
script which snapshots btrfs subvolumes and a systemd unit file to run
the script during the boot process.

Requirements

The root filesystem must have been installed into its own dedicated
btrfs subvolume and the btrfs-root where all subvolumes reside has to be
accessible.

    /etc/fstab

    # ...
    UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX   /                 btrfs   defaults,subvol=__current/ROOT   0 0
    UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX   /run/btrfs-root   btrfs   defaults,compress=lzo            0 0

    # just for the below example:
    UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX   /var              btrfs   defaults,subvol=__current/var    0 0
    UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX   /opt              btrfs   defaults,subvol=__current/opt    0 0
    UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX   /home             btrfs   defaults,subvol=__current/home   0 0
    # ...

Snapshot script

An example script to snapshot the btrfs subvolumes mounted under / is
listed further below. The script will automatically detect the names of
all subvolumes mounted under / and create snapshots of the same names
under a directory specified by the caller.

What the script does, is to delete all snapshots from the state the
system was in at last boot, make new snapshots, and alter the /etc/fstab
file of the snapshot of the root subvolume to allow it to be booted
without manual configuration.

When called like this ...

    # bash /usr/local/bin/snapshot_current_system_state.sh '/run/btrfs-root' '__current/ROOT' '__snapshot/__state_at_last_successful_boot'

the following structure will result:

    $ btrfs subvolume list '/'

    ID 257 gen 1134 top level 5 path __current/ROOT
    ID 258 gen 1137 top level 5 path __current/var
    ID 259 gen 1129 top level 5 path __current/opt
    ID 260 gen 1137 top level 5 path __current/home
    ID 277 gen 1128 top level 5 path __snapshot/__state_at_last_successful_boot/__current/ROOT
    ID 278 gen 1128 top level 5 path __snapshot/__state_at_last_successful_boot/__current/var
    ID 279 gen 1129 top level 5 path __snapshot/__state_at_last_successful_boot/__current/opt
    ID 280 gen 1130 top level 5 path __snapshot/__state_at_last_successful_boot/__current/home

Note that var, opt and home are subvolumes created by the caller in this
example and mounted under '/'. The script detected and snapshotted them
automatically. The resulting directory structure is:

    /run/btrfs-root/__current/ROOT
    /run/btrfs-root/__current/var
    /run/btrfs-root/__current/opt
    /run/btrfs-root/__current/home
    /run/btrfs-root/__current/net
    /run/btrfs-root/__current/bak
    /run/btrfs-root/__snapshot/__state_at_last_successful_boot/__current/ROOT
    /run/btrfs-root/__snapshot/__state_at_last_successful_boot/__current/var
    /run/btrfs-root/__snapshot/__state_at_last_successful_boot/__current/opt
    /run/btrfs-root/__snapshot/__state_at_last_successful_boot/__current/home

The script below takes 3 parameters:

1.  The path of the btrfs filesystem root. E. g. /run/btrfs-root,
2.  The name of the btrfs root subvolume as specified in /etc/fstab. E.
    g. __current/ROOT,
3.  The path where the newly created snapshots will reside without its
    1st parameter portion. E. g.
    __snapshot/__state_at_last_successful_boot (if the actual path is
    /run/btrfs-root/__snapshot/__state_at_last_successful_boot)

Warning:This script will delete all snapshots of the same names as the
regular subvolume names in the path its third parameter is pointing to.
Be careful that the 3rd parameter is not pointing at the place where
your subvolumes reside in --- In this example, /run/btrfs-root/__current
as the 3rd parameter would be incorrect and lead to data loss.

    /usr/local/bin/snapshot_current_system_state.sh


    #!/bin/sh

    # example call: # bash /usr/local/bin/snapshot_current_system_state.sh '/run/btrfs-root' '__current/ROOT' '__snapshot/__state_at_last_successful_boot' 

    if [ $# -ne 3 ]
    then
      /usr/bin/echo -e "This script requires three parameters:\n1st parameter: The path of the btrfs filesystem root. e. g. /run/btrfs-root\n2nd parameter: The name of the btrfs root volume as specified in /etc/fstab. E. g. __current/ROOT\n3rd parameter: The path where the newly created snapshots will reside without its 1st parameter portion. E. g. __snapshot/__state_at_last_successful_boot\nCAUTION: This script will delete all snapshots of the same name as the regular volume names in the path parameter 3 is pointing to."
      exit 0
    fi

    btrfs_root="${1}" # example: '/run/btrfs-root'
    path_to_root_volume="${2}" # example: '__current/ROOT'
    path_to_snapshots="${3}" # example: '__snapshot/__state_at_last_successful_boot'

    # take no snapshots when booted into a snapshot
    if [ -e '/SNAPSHOT-TIMESTAMP' ]
    then
      exit 0
    fi

    # anti recursive snapshots
    for subvolume in $(/usr/bin/btrfs subvolume list '/' | /usr/bin/awk '{print $NF}') # scan
    do
      path_to_snapshot="${btrfs_root}/${path_to_snapshots}/${subvolume}"

      if [ -d "${path_to_snapshot}" ]
      then
        /usr/bin/btrfs subvolume delete "${path_to_snapshot}"
      fi  
    done

    subvolumes="$(/usr/bin/btrfs subvolume list '/' | /usr/bin/awk '{print $NF}')" # rescan
    for subvolume in $subvolumes
    do
      snapshot_directory="${btrfs_root}/${path_to_snapshots}/$(/usr/bin/dirname ${subvolume})"

      if [ ! -d "${snapshot_directory}" ]
      then
        /usr/bin/mkdir -p "${snapshot_directory}" 
      fi  

      /usr/bin/btrfs subvolume snapshot "${btrfs_root}/${subvolume}" "${btrfs_root}/${path_to_snapshots}/${subvolume}" 

      if [ "${subvolume}" = "${path_to_root_volume}" ]
      then
        timestamp="$(/usr/bin/date +%d.%m.%Y-%H:%M:%S)"

        /usr/bin/echo -e "Arch Linux --- state at last successful boot (nonpersistent) [${timestamp}]\n" > "${btrfs_root}/${path_to_snapshots}/${path_to_root_volume}/etc/issue"

        /usr/bin/echo "${timestamp}" > "${btrfs_root}/${path_to_snapshots}/${path_to_root_volume}/SNAPSHOT-TIMESTAMP"

        sed_path_to_snapshots="$(/usr/bin/echo ${path_to_snapshots} | /usr/bin/sed --posix --regexp-extended 's/\//\\\//g')"

        for subvolumeX in $(echo $subvolumes | /usr/bin/sed --posix --regexp-extended 's/\//\\\//g')
        do
          /usr/bin/sed --posix --regexp-extended "s/subvol=${subvolumeX}/subvol=${sed_path_to_snapshots}\/${subvolumeX}/g" --in-place "${btrfs_root}/${path_to_snapshots}/${path_to_root_volume}/etc/fstab"
        done
      fi
    done

    /usr/bin/sync

systemd unit file

Following systemd unit file will run the script every time the system
manages to successfully boot into multi-user.target:

-   Example unit file
    /etc/systemd/system/snapshot_current_system_state_upon_boot.service:

    [Unit]
    Description=Takes a snapshot of each btrfs subvolume mounted under / after multi-user.target has been reached.
    After=multi-user.target

    [Service]
    Type=oneshot
    ExecStart=/bin/sh /usr/local/bin/snapshot_current_system_state.sh '/run/btrfs-root' '__current/ROOT' '__snapshot/__state_at_last_successful_boot'

    [Install]
    WantedBy=multi-user.target

The unit file has to be symlinked by systemd:

    # systemctl enable snapshot_current_system_state_upon_boot.service

> Booting into snapshots

In order to boot into a subvolume the rootflags=subvol= option has to be
used on the kernel line. The subvol= mount options in /etc/fstab of the
snapshot to boot into also have to be specified correctly.

Note:If using the example script above, the /etc/fstab of the snapshot
of the root subvolume is set automatically.

GRUB

-   Example menue entry /etc/grub.d/40_custom:

    # ....
    menuentry "Arch Linux --- state at last successfull boot (nonpersistent)" {
      linux /vmlinuz-linux root=/dev/disk/by-uuid/<UUID of btrfs-root> rootflags=subvol=__snapshot/__state_at_last_successful_boot/__current/ROOT init=/usr/lib/systemd/systemd ro quiet
      initrd /initramfs-linux.img
    }
    # ...

/etc/grub.d/40_custom has to be executable:

    # chmod 700 /etc/grub.d/40_custom

/boot/grub/grub.cfg has to be recreated:

    # grub-mkconfig -o /boot/grub/grub.cfg

Backup solutions
----------------

-   Snapper is a command-line program for filesystem snapshot
    management. It can create and compare snapshots, revert between
    snapshots, and supports automatic snapshots timelines.

More tools are available, see official btrfs wiki.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Btrfs_-_Tips_and_tricks&oldid=290654"

Category:

-   File systems

-   This page was last modified on 28 December 2013, at 13:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
