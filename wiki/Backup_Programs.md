Backup Programs
===============

This wiki page contains information about various backup programs. It's
a good idea to have regular backups of important data, most notably
configuration files (/etc/*) and the local pacman database (usually
/var/lib/pacman/local/*).

Contents
--------

-   1 Introduction
-   2 Incremental backups
    -   2.1 Rsync-type backups
        -   2.1.1 Console
        -   2.1.2 Graphical
    -   2.2 Other backups
        -   2.2.1 Console
        -   2.2.2 Graphical
-   3 Cloud backups
-   4 Cooperative storage cloud backups
-   5 Non-incremental backups
-   6 Versioning systems
    -   6.1 Version control systems
    -   6.2 VCS-based backups
-   7 External Resources

Introduction
------------

Before you start trying various programs out, try to think about your
needs, e.g. consider the following questions:

-   What backup medium do I have available? (CD, DVD, remote server,
    external hard drive, etc.)
-   How often do I plan to backup? (daily, weekly, monthly, etc.)
-   What features do I expect from the backup solution? (compression,
    encryption, handles renames, etc.)
-   How do I plan to restore backups if needed?

Incremental backups
-------------------

Applications that can do incremental backups remember and take into
account what data has been backed up during the last run and eliminate
the need to have duplicates of unchanged data. Restoring the data to a
certain point in time would require locating the last full backup and
all the incremental backups from then to the moment when it is supposed
to be restored. This sort of backup is useful for those who do it very
often.

> Rsync-type backups

The main characteristic of this type of backups is that they maintain a
copy of the directory you want to keep a backup of, in a traditional
"mirror" fashion.

Certain rsync-type packages also do snapshot backups by storing files
which describe how the contents of files and folders changed from the
last backup (so-called 'diffs'). Hence, they are inherently incremental,
but usually they do not have compression or encryption. On the other
hand, a working copy of everything is immediately available, no
decompression/decryption needed. A downside to rsync-type programs is
that they cannot be easily burned and restored from a CD or DVD.

Console

-   rsync — A file transfer program to keep remote files in sync.
    -   rsync almost always makes a mirror of the source.
    -   It is possible to restore a full backup before the most recent
        backup if hardlinks are allowed in the backup file system. See
        Back up your data with rsync for more information.
    -   If hard links are not allowed, it is impossible to restore a
        full backup before the most recent backup (but you can use
        --backup to keep old versions of the files).
    -   Standard install on all distros.
    -   Can run over SSH (port 22) or native rsync protocol (port 873).
    -   Win32 version available.

http://rsync.samba.org/ || rsync

-   rdiff-backup — A utility for local/remote mirroring and incremental
    backups.
    -   Stores the most recent backup as regular files.
    -   To revert to older versions, you apply the diff files to
        recreate the older versions.
    -   It is granularly incremental (delta backup), it only stores
        changes to a file; will not create a new copy of a file upon
        change.
    -   Win32 version available.

http://www.nongnu.org/rdiff-backup/ || rdiff-backup

-   rsnapshot — A remote filesystem snapshot utility.
    -   Does not store diffs, instead it copies entire files if they
        have changed.
    -   Creates hard links between a series of backed-up trees
        (snapshots).
    -   It is differential in that the size of the backup is only the
        original backup size plus the size of all files that have
        changed since the last backup.
    -   Destination filesystem must support hard links.
    -   Win32 version available.

http://www.rsnapshot.org/ || rsnapshot

-   SafeKeep — A client/server backup system which uses rdiff-backup.
    -   Integrates with Linux LVM and databases to create consistent
        backups.
    -   Bandwidth throttling.

http://safekeep.sourceforge.net/ || safekeep

-   Link-Backup — A tool similar to rsync based scripts, but which does
    not use rsync. NOTE: no upstream activity since 2008.
    -   Creates hard links between a series of backed-up trees
        (snapshots).
    -   Intelligently handles renames, moves, and duplicate files
        without additional storage or transfer.
    -   The backup directory contains .catalog, a catalog of all unique
        file instances; backup trees hard-link to this catalog.
    -   Transfer occurs over standard I/O locally or remotely between a
        client and server instance of this script.
    -   It copies itself to the server; it does not need to be installed
        on the server.
    -   Requires SSH for remote backups.
    -   It resumes stopped backups; it can even be told to run for an
        arbitrary number of minutes.

http://www.scottlu.com/Content/Link-Backup.html || link-backup

-   Unison — A program that synchronizes files between two machines over
    network (LAN or Inet) using a smart diff method + rsync. Allows the
    user to interactively choose which changes to push, pull, or merge.

http://www.cis.upenn.edu/~bcpierce/unison/ || unison

-   rsync-snapshot.sh — Another rsync shellscript with smart rotation
    (non-linear distribution) of backups. Integrity protection, Quotas,
    Rules and many more features.

http://blog.pointsoftware.ch/index.php/howto-local-and-remote-snapshot-backup-using-rsync-with-hard-links/
|| not packaged? search in AUR

-   oldtime — A bash script using rsync to provide a backup solution.

https://github.com/GutenYe/oldtime || oldtime

-   trinkup — A 60-lines bash script which holds specified amount of
    incremental backups using rsync and "cp -al" to minimize amount of
    disk operations.

https://gist.github.com/ei-grad/7610406/raw/trinkup || trinkup

Graphical

-   Back In Time — A simple backup tool for Linux inspired by the
    FlyBack and TimeVault projects.
    -   Creates hard links between a series of backed-up trees
        (snapshots).
    -   Really is just a front-end to rsync, diff, cp.
    -   A new snapshot is created only if something changed since the
        last snapshot.

http://backintime.le-web.org/ || backintime or as a prebuild package
from codercun's repo

-   FlyBack — A clone of Apple's Time Machine, a backup utility for Mac
    OS X.

http://www.flyback-project.org/ || flyback

-   Areca Backup — An easy to use and reliable backup solution for Linux
    and Windows.
    -   Written in Java.
    -   Primarily archive-based (zip), but will do file-based backup as
        well.
    -   Delta backup supported (stores only changes).

http://areca.sourceforge.net/ || areca

-   luckyBackup — An easy program to backup and sync your files.
    -   It is written in Qt and C++.
    -   It has sync, backup (with include and exclude options) and
        restore capabilities.
    -   It can do remote connection backups, scheduled backups.
    -   A command line mode.

http://luckybackup.sourceforge.net/index.html || luckybackup

-   syncBackup — A front-end for rsync that provides a fast and
    extraordinary copying tool. It offers the most common options that
    control its behavior and permit very flexible specification of the
    set of files to be copied.

http://www.darhon.com/syncbackup || syncbackup

-   BackupPC — A high-performance, enterprise-grade system for backing
    up Unix, Linux, Windows, and Mac OS X desktops and laptops to a
    remote server.
    -   Deduplication: Identical files across multiple backups of the
        same or different PCs are stored only once resulting in
        substantial savings in disk storage and disk I/O.
    -   Optional compression support further reducing disk storage.
    -   No client-side software is needed.
    -   Simple but powerful web-based UI.

http://backuppc.sourceforge.net/index.html || backuppc

> Other backups

Most other backup applications tend to create (big) archive files and
(of course) keep track of what's been archived. Creating .tar.bz2 or
.tar.gz archives has the advantage that you can extract the backups with
just tar/bzip2/gzip, so you do not need to have the backup program
around.

Console

-   Arch Backup — A trivial backup script with simple configuration.
    -   Configurable compression method.
    -   Multiple backup targets.

http://code.google.com/p/archlinux-stuff/ || arch-backup

-   hdup — A very simple command line backup tool.
    -   Creates tar.gz or tar.bz2 archives.
    -   Supports gpg encryption.
    -   Supports pushing over SSH.
    -   Multiple backup targets.

http://miek.nl/projects/hdup2/ || hdup

-   rdup — A platform for backups that provides scripts to facilitate
    backups and delegates the encryption, compression, transfer and
    packaging to other utilities in a true Unix-way.
    -   Creates tar.gz archives or rsync-type copy.
    -   Encryption (gpg, blowfish and others); also applies for
        rsync-type copy.
    -   Compression (also for rsync-type copy).

http://miek.nl/projects/rdup || rdup

-   Duplicity — A simple command-line utility which allows encrypted
    compressed incremental backup to nearly any storage.
    -   Supports gpg encryption and signing.
    -   Supports gzip compression.
    -   Supports full or incremental backups, incremental backup stores
        only difference between new and old file.
    -   Supports pushing over FTP, SSH, rsync, WebDAV, WebDAVs, HSi and
        Amazon S3 or local filesystem.

http://www.nongnu.org/duplicity/ || duplicity

-   DAR — A full-featured command-line backup tool, short for Disk
    ARchive.
    -   It uses its own format for archives (so you need to have it
        around when you want to restore).
    -   Supports splitting backups into more files by size.
    -   Makefile-type config files, some custom scripts are available
        along with it.
    -   Supports basic encryption.
    -   Automatic backup using cron is possible with sarab.

http://dar.linux.free.fr/ || dar kdar (fontend)

-   Manent — An algorithmically strong backup and archival program.
    NOTE: no upstream activity since 2009.
    -   Efficient backup to anything that looks like a storage.
    -   Works well over a slow and unreliable network.
    -   Offers online access to the contents of the backup.
    -   Backed up storage is completely encrypted.
    -   Several computers can use the same storage for backup,
        automatically sharing data.
    -   Not reliant on timestamps of the remote system to detect
        changes.
    -   Cross-platform support for Unicode file names.

http://code.google.com/p/manent/ || manent

-   btar — tar-compatible archiver
    -   Fast archive creation (multicore compression or ciphering)
    -   Arbitrary chain of compression/ciphers (calls any
        compression/ciphering programs)
    -   Indexed archive retrieval or listing
    -   Redundancy
    -   Serialization through pipes (and only one file per backup)
    -   Can be extracted or checked with gnutar
    -   Differential backups of multiple levels
    -   Optional encoding of big files with rsync-differences

http://viric.name/cgi-bin/btar || btar

-   burp — Burp is a network backup and restore program
    -   Uses librsync in order to save network traffic and to save on
        the amount of space that is used by each backup.
    -   It also uses VSS (Volume Shadow Copy Service) to make snapshots
        when backing up Windows computers.
    -   deduplication
    -   SSL/TLS connections
    -   automation the process of generating SSL certificates
    -   data encryption
    -   security models [1]

http://burp.grke.org || burp-backup

-   obnam — Easy, secure backup program
    -   Uses snapshots instead of full/incremental backups

http://liw.fi/obnam/ || obnam

-   System Tar & Restore — A set of bash scripts for full system backup
    and restore
    -   CLI and Dialog interfaces
    -   Easy backup and restore wizards
    -   Uses tar / bsdtar to create and restore backups
    -   Creates .tar.gz, .tar.bz2 or .tar.xz archives
    -   Uses rsync to transfer a running system
    -   Supports Grub2 and Syslinux

https://github.com/tritonas00/system-tar-and-restore ||
system-tar-and-restore

-   Packrat — A simple, modular backup system using DAR
    -   Full or incremental backups stored locally, on a remote system
        via SSH, or on Amazon S3

http://www.zeroflux.org/projects || packrat

-   Attic — A deduplicating backup program for efficient and secure
    backups.
    -   Space efficient storage: Variable block size deduplication is
        used to reduce the number of bytes stored by detecting redundant
        data.
    -   Optional data encryption: All data can be protected using
        256-bit AES encryption and data integrity and authenticity is
        verified using HMAC-SHA256.
    -   Off-site backups: Any data can be stored on any remote host
        accessible over SSH (as long as Attic is installed).
    -   Backups mountable as filesystems: Backup archives are mountable
        as userspace filesystems for easy backup verification and
        restores.

https://github.com/jborg/attic/ || attic

Graphical

-   Backerupper — A simple program for backing up selected directories
    over a local network. Its main intended purpose is backing up a
    user's personal data.
    -   Creates .tar.gz archives.
    -   Configurable backup frequency, backup time and max copies.

http://sourceforge.net/projects/backerupper/ || backerupper

-   Déjà Dup — A simple GTK+ backup program. It hides the complexity of
    doing backups the 'right way' (encrypted, off-site, and regular) and
    uses duplicity as the backend.
    -   Automatic, timed backup configurable in GUI.
    -   Restore wizard.
    -   Integrated into the Nautilus file manager.
    -   Inherits several features of duplicity.

https://launchpad.net/deja-dup || deja-dup

-   Synkron — A folder synchronization tool.
    -   Syncs multiple folders.
    -   Can exclude files from sync based on wildcards.
    -   Restores files.
    -   Cross-platform support.

http://synkron.sourceforge.net/ || synkron

Cloud backups
-------------

See the Wikipedia article on this subject for more information:
Comparison of online backup services

-   Copy — A fair solution to shared folders.
    -   15GB free.
    -   Shared folders size are split between people.
    -   Daemon to sync files between the cloud and the computer.
    -   Almost any platform supported.
    -   Offers AES-256 encryption.

https://www1.copy.com/home/ || copy

-   CrashPlan — An online/offsite backup solution.
    -   Unlimited online space for very reasonable pricing.
    -   Automatic and incremental backups to multiple destinations.
    -   Intuitive GUI.
    -   Offers encryption and de-duplication.
    -   Software is generally free.

http://www.crashplan.com/ || crashplan

-   Dropbox — A popular file-sharing service.
    -   A daemon monitors a specified directory, and uploads incremental
        changes to dropbox.com.
    -   Changes automatically show up on your other computers.
    -   Includes file sharing and a public directory.
    -   You can recover deleted files.
    -   Community written add-ons.
    -   Free accounts have 2GB storage.

http://www.getdropbox.com || dropbox nautilus-dropbox

-   Google Drive — A file storage and synchronization service provided
    by Google.
    -   Provides cloud storage, file sharing and collaborative editing.
    -   Multiple clients are available.

https://drive.google.com || google-drive-ocamlfuse (free), insync
(non-free)

-   Jungle Disk — An online backup tool that stores its data in Amazon
    S3 or Rackspace Cloud Files.
    -   A Nautilus extension.
    -   Only paid plans available.

http://www.jungledisk.com/ || nautilus-jungledisk

-   MEGA — Successor to the MegaUpload file-sharing service.
    -   Free accounts are 50GB with paid plans available for more space.
    -   Offers encryption and de-duplication.
    -   Usualy accessed through its web interface but other tools exist.

https://mega.co.nz || megatools

-   SpiderOak — An online backup tool for Windows, Mac and Linux users
    to back up, share, sync, access and store their data.
    -   Free and paid version available.
    -   Free account holds 2GB.
    -   Includes file sharing and a public directory.
    -   Incremental backup and sync are both supported.

https://spideroak.com/ || spideroak

-   Tarsnap — A secure online backup service for BSD, Linux, OS X,
    Solaris and Windows (through Cygwin).
    -   Compressed encrypted backups to Amazon S3 Servers.
    -   Automate via cron.
    -   Incremental backups.
    -   Backup any files or directories.
    -   Command line only client.
    -   Pay only for usage (bandwidth and storage).

http://www.tarsnap.com || tarsnap

-   Ubuntu One — An online storage service with sync and sharing across
    platforms.
    -   Free and paid versions available.
    -   Free account with 5GB.
    -   Mobile access.
    -   Music streaming.

https://one.ubuntu.com/services/ || ubuntuone-client

-   Wuala — A secure online storage, file synchronization, versioning
    and backup service.
    -   Closed source, free and paid version available.
    -   Free account holds 5GB.
    -   Includes file sharing and a public directory.
    -   Incremental backup and sync are both supported.
    -   Social networking features.
    -   All files in the cloud are first encrypted locally.

http://www.wuala.com/ || wuala, wuala-daemon – to run as daemon

Cooperative storage cloud backups
---------------------------------

A cooperative storage cloud is a decentralized model of networked online
storage where data is stored on multiple computers, hosted by the
participants cooperating in the cloud.

-   Symform — A peer-to-peer cloud backup service.
    -   Unlimited free backup in exchange for 2:1 storage space
        contribution with an always-connected device (at least 80%
        uptime).
    -   Payment options exist.
    -   First 10GB of backup storage is free (no contribution needed).
    -   In addition to paid support, support plans in exchange for
        extended contribution (300GB+) exist.
    -   Automatic and incremental backups.
    -   Data is encrypted before leaving the computer, though keys are
        also stored on the Symform's servers.
    -   Customizable limits for bandwidth consumption.
    -   Ability to have a local copy ("Hot Copy") of the backed up data
        on a different disk or computer.
    -   Ability to have synchronized folders between nodes
        (Dropbox-like).
    -   Closed source, using mono. Windows clients available.

http://www.symform.com/ || symform

Non-incremental backups
-----------------------

Another type of backups are those used in case of a disaster. These
include application that allow easy backup of entire filesystems and
recovery in case of failure, usually in the form of a Live CD or USB
drive. The contains complete system images from one or more specific
points in time and are frequently used by to record known good
configurations.

-   Q7Z — P7Zip GUI for Linux, which attempts to simplify data
    compression and backup. It can create the following archive types:
    7z, BZip2, Zip, GZip, Tar.
    -   Updates existing archives quickly.
    -   Backup multiple folders to a storage location.
    -   Create or extract protected archives.
    -   Lessen effort by using archiving profiles and lists.

http://k7z.sourceforge.net/ || q7z

-   Partclone — A tool that can be used to back up and restore a
    partition while considering only used blocks.
    -   Supports ext2, ext3, hfs+, reiser3.5, reiser3.6, reiser4, ext4
        and btrfs.
    -   Supports compression.

http://partclone.nchc.org.tw/trac/ || partclone

-   Redo Backup and Recovery — A backup and disaster recovery
    application that runs from a bootable Linux CD image.
    -   Is capable of bare-metal backup and recovery of disk partitions.
    -   Uses xPUD and Partclone for the backend.

http://www.redobackup.org/ || not packaged? search in AUR

-   Clonezilla — A disaster recovery, disk cloning, disk imaging and
    deployment solution.
    -   Boots from live CD, USB flash drive, or PXE server.
    -   Supports ext2, ext3, ext4, reiserfs, reiser4, xfs, jfs, btrfs
        FAT32, NTFS, HFS+ and others.
    -   Uses Partclone (default), Partimage (optional), ntfsclone
        (optional), or dd to image or clone a partition.
    -   Multicasting server to restore to many machines at once.

http://clonezilla.org/ || clonezilla

-   Partimage — A disk cloning utility for Linux/UNIX environments.
    -   Has a Live CD.
    -   Supports the most popular filesystems on Linux, Windows and Mac
        OS.
    -   Compression.
    -   Saving to multiple CDs or DVDs or across a network using
        Samba/NFS.

http://www.partimage.org/Main_Page || partimage

-   FSArchiver — A safe and flexible file-system backup and deployment
    tool
    -   Support for basic file attributes (permissions, owner, ...).
    -   Support for multiple file-systems per archive.
    -   Support for extended attributes (they are used by SELinux).
    -   Support the basic file-system attributes (label, uuid,
        block-size) for all linux file-systems.
    -   Support for ntfs filesystems (ability to create flexible clones
        of a Windows partitions).
    -   Checksumming of everything which is written in the archive
        (headers, data blocks, whole files).
    -   Ability to restore an archive which is corrupt (it will just
        skip the current file).
    -   Multi-threaded lzo, gzip, bzip2, lzma compression.
    -   Support for splitting large archives into several files with a
        fixed maximum size.
    -   Encryption of the archive using a password. Based on blowfish
        from libcrypto from OpenSSL.
    -   Support backup of a mounted root filesystem (-A option).

http://www.fsarchiver.org/Main_Page || fsarchiver

-   Mondo Rescue — A disaster recovery solution to create backup media
    that can be used to redeploy the damaged system.
    -   Image-based backups, supporting Linux/Windows.
    -   Compression rate is adjustable.
    -   Can backup live systems (without having to halt it).
    -   Can split image over many files.
    -   Supports booting to a Live CD to perform a full restore.
    -   Can backup/restore over NFS, from CDs, tape drives and and other
        media.
    -   Can verify backups.

http://www.mondorescue.org/ || mondo

Versioning systems
------------------

These are traditionally used for keeping track of software development;
but if you want to have a simple way to manage your config files in one
directory, it might be a good solution.

> Version control systems

See the Wikipedia article on this subject for more information:
Comparison of revision control software

-   Git — A distributed revision control and source code management
    system with an emphasis on speed.
    -   Very easy creation, merging, and deletion of branches.
    -   Nearly all operations are performed locally, giving it a huge
        speed advantage on centralized systems.
    -   Has a "staging area" or "index", this is an intermediate area
        where commits can be formatted and reviewed before completing
        the commit.
    -   Does not handle binary files very well.

http://git-scm.com/ || git

-   Subversion — A full-featured centralized version control system
    originally designed to be a better CVS.
    -   Renamed/copied/moved/removed files retain full revision history.
    -   Native support for binary files, with space-efficient
        binary-diff storage.
    -   Costs proportional to change size, not to data size.
    -   Allows arbitrary metadata ("properties") to be attached to any
        file or directory.

http://subversion.apache.org/ || subversion

-   Mercurial — A distributed version control system written in Python
    and similar in many ways to Git.
    -   Platform independent.
    -   Support for extensions.
    -   A set of commands consistent with Subversion.
    -   Supports tags.

http://mercurial.selenic.com/ || mercurial

-   Bazaar — A distributed version control system that helps you track
    project history over time and to collaborate easily with others.
    -   Similar commands to Subversion.
    -   Supports working with or without a central server.
    -   Support for working with some other revision control systems
    -   Complete Unicode support.

http://bazaar.canonical.com/en/ || bzr

-   Darcs — A distributed revision control system that was designed to
    replace traditional, centralized source control systems such as CVS
    and Subversion.
    -   Offline mode.
    -   Easy branching and merging.
    -   Written in Haskell.
    -   Not very fast.

http://darcs.net/ || darcs

> VCS-based backups

-   Gibak — A backup system based on Git.
    -   Supports binary diffs.
    -   Uses all of Git's features (such as .gitignore for filtering
        files).
    -   Uses Git's hook system to save information that Git does not
        (permissions, mtime, empty directories, etc).

https://github.com/pangloss/gibak || gibak

-   bup — A fledgling Git-based backup solution written in Python and C.
    -   Uses a rolling checksum algorithm (similar to rsync) to split
        large files into chunks.
    -   Can back up directly to a remote bup server.
    -   Has an improved index format to allow you to track many files.

https://github.com/bup/bup || bup

-   ColdStorage — Another backup tool using Git at its core, written in
    Qt.

http://gitorious.org/coldstorage || coldstorage-git

External Resources
------------------

-   Backing up Linux and other Unix(-like) systems
-   Mirroring an Entire Site using Rsync over SSH

Retrieved from
"https://wiki.archlinux.org/index.php?title=Backup_Programs&oldid=306144"

Categories:

-   Data compression and archiving
-   System recovery

-   This page was last modified on 20 March 2014, at 18:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
