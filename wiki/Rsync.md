rsync
=====

Related articles

-   Full System Backup with rsync
-   Backup Programs

rsync is an open source utility that provides fast incremental file
transfer.

Contents
--------

-   1 Installation
-   2 Usage
    -   2.1 As a cp alternative
    -   2.2 As a backup utility
        -   2.2.1 Automated backup
        -   2.2.2 Automated backup with SSH
        -   2.2.3 Automated backup with NetworkManager
        -   2.2.4 Automated backup with systemd and inotify
        -   2.2.5 Differential backup on a week
        -   2.2.6 Snapshot backup
-   3 Graphical frontends

Installation
------------

Install the rsync from the official repositories.

Usage
-----

For more examples, search the Community Contributions and General
Programming forums.

> As a cp alternative

rsync can be used as an advanced alternative for the cp command,
especially for copying larger files:

    $ rsync -P source destination

The -P option is the same as --partial --progress, which keeps partially
transferred files and shows a progress bar during transfer.

You may want to use the -r --recursive option to recurse into
directories, or the -R option for using relative path names (recreating
entire folder hierarchy on the destination folder).

> As a backup utility

The rsync protocol can easily be used for backups, only transferring
files that have changed since the last backup. This section describes a
very simple scheduled backup script using rsync, typically used for
copying to removable media. For a more thorough example and additional
options required to preserve some system files, see Full System Backup
with rsync.

Automated backup

For the sake of this example, the script is created in the
/etc/cron.daily directory, and will be run on a daily basis if a cron
daemon is installed and properly configured. Configuring and using cron
is outside the scope of this article.

First, create a script containing the appropriate command options:

    /etc/cron.daily/backup

    #!/bin/bash
    rsync -a --delete /folder/to/backup /location/to/backup &> /dev/null

 -a 
    indicates that files should be archived, meaning that most of their
    characteristics are preserved (but not ACLs, hard links or extended
    attributes such as capabilities)
 --delete 
    means files deleted on the source are to be deleted on the backup as
    well

Here, /folder/to/backup should be changed to what needs to be backed-up
(/home, for example) and /location/to/backup is where the backup should
be saved (/media/disk, for instance).

Finally, the script must be executable:

    # chmod +x /etc/cron.daily/rsync.backup

Automated backup with SSH

If backing-up to a remote host using SSH, use this script instead:

    /etc/cron.daily/backup

    #!/bin/bash
    rsync -a --delete -e ssh /folder/to/backup remoteuser@remotehost:/location/to/backup &> /dev/null

 -e ssh 
    tells rsync to use SSH
 remoteuser 
    is the user on the host remotehost
 -a 
    groups all these options -rlptgoD (recursive, links, perms, times,
    group, owner, devices)

Automated backup with NetworkManager

This script starts a backup when you plugin your wire.

First, create a script containing the appropriate command options:

    /etc/NetworkManager/dispatcher.d/backup

    #!/bin/bash

    if [ x"$2" = "xup" ] ; then
            rsync --force --ignore-errors -a --delete --bwlimit=2000 --files-from=files.rsync /folder/to/backup /location/to/backup
    fi

 -a 
    group all this options -rlptgoD recursive, links, perms, times,
    group, owner, devices
 --files-from 
    read the relative path of /folder/to/backup from this file
 --bwlimit 
    limit I/O bandwidth; KBytes per second

Automated backup with systemd and inotify

> Note:

-   Due to the limitations of inotify and systemd (see this question and
    answer), recursive filesystem monitoring is not possible. Although
    you can watch a directory and its contents, it will not recurse into
    subdirectories and watch the contents of them; you must explicitly
    specify every directory to watch, even if that directory is a child
    of an already watched directory.
-   This setup is based on a systemd/User instance.

Instead of running time interval backups with time based schedules, such
as those implemented in cron, it is possible to run a backup every time
one of the files you are backing up changes. systemd.path units use
inotify to monitor the filesystem, and can be used in conjunction with
systemd.service files to start any process (in this case your rsync
backup) based on a filesystem event.

First, create the systemd.path file that will monitor the files you are
backing up:

    ~/.config/systemd/user/backup.path

    [Unit]
    Description=Checks if paths that are currently being backed up have changed

    [Path]
    PathChanged=%h/documents
    PathChanged=%h/music

    [Install]
    WantedBy=default.target

Then create a systemd.service file that will be activated when it
detects a change. By default a service file of the same name as the path
unit (in this case backup.path) will be activated, except with the
.service extension instead of .path (in this case backup.service).

Note:If you need to run multiple rsync commands, use Type=oneshot. This
allows you to specify multiple ExecStart= parameters, one for each rsync
command, that will be executed. Alternatively, you can simply write a
script to perform all of your backups, just like cron scripts.

    ~/.config/systemd/user/backup.service

    [Unit]
    Description=Backs up files

    [Service]
    ExecStart=/usr/bin/rsync %h/./documents %h/./music -CERrltm --delete ubuntu:

Now all you have to do is start/enable backup.path like a normal systemd
service and it will start monitoring file changes and automatically
starting backup.service:

    systemctl --user start backup.path
    systemctl --user enable backup.path

Differential backup on a week

This is a useful option of rsync, creating a full backup and a
differential backup for each day of a week.

First, create a script containing the appropriate command options:

    /etc/cron.daily/backup

    #!/bin/bash

    DAY=$(date +%A)

    if [ -e /location/to/backup/incr/$DAY ] ; then
      rm -fr /location/to/backup/incr/$DAY
    fi

    rsync -a --delete --inplace --backup --backup-dir=/location/to/backup/incr/$DAY /folder/to/backup/ /location/to/backup/full/ &> /dev/null

 --inplace 
    implies --partial update destination files in-place

Snapshot backup

The same idea can be used to maintain a tree of snapshots of your files.
In other words, a directory with date-ordered copies of the files. The
copies are made using hardlinks, which means that only files that did
change will occupy space. Generally speaking, this is the idea behind
Apple's TimeMachine.

This script implements a simple version of it:

    /usr/local/bin/rsnapshot.sh

    #!/bin/bash

    ## my own rsync-based snapshot-style backup procedure
    ## (cc) marcio rps AT gmail.com

    # config vars

    SRC="/home/username/files/" #dont forget trailing slash!
    SNAP="/snapshots/username"
    OPTS="-rltgoi --delay-updates --delete --chmod=a-w"
    MINCHANGES=20

    # run this process with real low priority

    ionice -c 3 -p $$
    renice +12  -p $$

    # sync

    rsync $OPTS $SRC $SNAP/latest >> $SNAP/rsync.log

    # check if enough has changed and if so
    # make a hardlinked copy named as the date

    COUNT=$( wc -l $SNAP/rsync.log|cut -d" " -f1 )
    if [ $COUNT -gt $MINCHANGES ] ; then
            DATETAG=$(date +%Y-%m-%d)
            if [ ! -e $SNAP/$DATETAG ] ; then
                    cp -al $SNAP/latest $SNAP/$DATETAG
                    chmod u+w $SNAP/$DATETAG
                    mv $SNAP/rsync.log $SNAP/$DATETAG
                   chmod u-w $SNAP/$DATETAG
             fi
    fi

To make things really, really simple this script can be run from a
systemd unit.

Graphical frontends
-------------------

Install grsync from the official repositories.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Rsync&oldid=292749"

Categories:

-   Data compression and archiving
-   System recovery

-   This page was last modified on 13 January 2014, at 20:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
