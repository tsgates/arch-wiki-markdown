Install from Existing Linux
===========================

This document describes the bootstrapping process required to install
Arch Linux from a running Linux host system. After bootstrapping, the
installation proceeds as described in the Installation guide.

Installing Arch Linux from a running Linux is useful for:

-   remotely installing Arch Linux, e.g. a (virtual) root server
-   replacing an existing Linux without a LiveCD (see #Replacing the
    Existing System without a LiveCD)
-   creating a new Linux distribution or LiveCD based on Arch Linux
-   creating an Arch Linux chroot environment, e.g. for a Docker base
    container
-   rootfs-over-NFS for diskless machines

The goal of the bootstrapping procedure is to setup an environment from
which arch-install-scripts (such as pacstrap and arch-root) run. This
goal is achieved by installing arch-install-scripts natively on the host
system, or setting up an Arch Linux-based chroot.

If the host system runs Arch Linux, installing arch-install-scripts is
straightforward.

Note:This guide requires that the existing host system be able to
execute the new target Arch Linux architecture programs. In the case of
an x86_64 host, it is possible to use i686-pacman to build a 32-bit
chroot environment. See Arch64 Install bundled 32bit system. However it
is not so easy to build a 64-bit environment when the host only supports
running 32-bit programs.

Contents
--------

-   1 Arch Linux-based chroot
    -   1.1 Method 1: Using the Bootstrap Image
    -   1.2 Method 2: Using the LiveCD Image
    -   1.3 Method 3: Assembling the chroot Manually (with a script)
    -   1.4 Using the chroot Environment
        -   1.4.1 Initializing pacman keyring
        -   1.4.2 Installation
            -   1.4.2.1 Debian-based host
        -   1.4.3 Configure the system
-   2 Replacing the Existing System without a LiveCD

Arch Linux-based chroot
-----------------------

The idea is to run an Arch system inside the host system. The actual
installation is then executed from this Arch system. This nested system
is contained inside a chroot. Three methods to setup and enter this
chroot are presented below, from the easiest to the most complicated.

Note:Your host system must run Linux 2.6.32 or later.

Note:Select only one of the following three methods and then read the
rest of the article to complete the install.

> Method 1: Using the Bootstrap Image

Download the bootstrap image from a mirror:

     $ curl -O http://mirrors.kernel.org/archlinux/iso/2014.03.01/archlinux-bootstrap-2014.03.01-x86_64.tar.gz

Extract the tarball:

     # cd /tmp
     # tar xzf <path-to-bootstrap-image>/archlinux-bootstrap-2014.03.01-x86_64.tar.gz

Select a repository server:

     # nano /tmp/root.x86_64/etc/pacman.d/mirrorlist

Note:If you are bootstrapping an i686 image from an x86_64 host system,
you must also edit /tmp/root.i686/etc/pacman.conf and explicitly define
Architecture = i686 in order for pacman to pull the proper i686
packages.

Enter the chroot

-   If you have bash 4 or later installed:

      # /tmp/root.x86_64/bin/arch-chroot /tmp/root.x86_64/

-   Else run the following commands:

      # cp /etc/resolv.conf /tmp/root.x86_64/etc
      # mount --rbind /proc /tmp/root.x86_64/proc
      # mount --rbind /sys /tmp/root.x86_64/sys
      # mount --rbind /dev /tmp/root.x86_64/dev
      # mount --rbind /run /tmp/root.x86_64/run
        (assuming /run exists on your system)
      # chroot /tmp/root.x86_64/

> Method 2: Using the LiveCD Image

It is possible to mount the root image of the latest Arch Linux
installation media and then chroot into it. This method has the
advantage of providing you with a working Arch Linux installation right
within your host system without the need to prepare it by installing
specific packages.

Note:Before proceeding, make sure the latest version of squashfs is
installed on the host system. Otherwise you will get errors like:
FATAL ERROR aborting: uncompress_inode_table: failed to read block.

-   The root image can be found on one of the mirrors under either
    arch/x86_64/ or arch/i686/ depending on the desired architecture.
    The squashfs format is not editable so we unsquash the root image
    and then mount it.

-   To unsquash the root image, run

    # unsquashfs -d /squashfs-root root-image.fs.sfs

-   Now you can loop mount the root image

    # mkdir /arch
    # mount -o loop /squashfs-root/root-image.fs /arch

-   Before chrooting to it, we need to set up some mount points and copy
    the resolv.conf for networking.

    # mount -t proc none /arch/proc
    # mount -t sysfs none /arch/sys
    # mount -o bind /dev /arch/dev
    # mount -o bind /dev/pts /arch/dev/pts # important for pacman (for signature check)
    # cp -L /etc/resolv.conf /arch/etc #this is needed to use networking within the chroot

-   Now everything is prepared to chroot into your newly installed Arch
    environment

    # chroot /arch bash

> Method 3: Assembling the chroot Manually (with a script)

The script creates a directory called archinstall-pkg and downloads the
required packages in it. It then extracts them in the archinstall-chroot
directory. Finally, it prepares mount points, configures pacman and
enters a chroot.

    archinstall-bootstrap.sh

    #!/bin/bash
    # last edited 02. March 2014
    # This script is inspired on the archbootstrap script.

    FIRST_PACKAGE=(filesystem)
    BASH_PACKAGES=(glibc ncurses readline bash)
    PACMAN_PACKAGES=(acl archlinux-keyring attr bzip2 coreutils curl e2fsprogs expat gnupg gpgme keyutils krb5 libarchive libassuan libgpg-error libgcrypt libssh2 lzo2 openssl pacman xz zlib)
    # EXTRA_PACKAGES=(pacman-mirrorlist tar libcap arch-install-scripts util-linux systemd)
    PACKAGES=(${FIRST_PACKAGE[*]} ${BASH_PACKAGES[*]} ${PACMAN_PACKAGES[*]})

    # Change to the mirror which best fits for you
    # USA
    MIRROR='http://mirrors.kernel.org/archlinux' 
    # Germany
    # MIRROR='http://archlinux.limun.org'

    # You can set the ARCH variable to i686 or x86_64
    ARCH=`uname -m`
    LIST=`mktemp`
    CHROOT_DIR=archinstall-chroot
    DIR=archinstall-pkg
    mkdir -p "$DIR"
    mkdir -p "$CHROOT_DIR"
    # Create a list of filenames for the arch packages
    wget -q -O- "$MIRROR/core/os/$ARCH/" | sed -n "s|.*href=\"\\([^\"]*xz\\)\".*|\\1|p" >> $LIST
    # Download and extract each package.
    for PACKAGE in ${PACKAGES[*]}; do
            FILE=`grep "$PACKAGE-[0-9]" $LIST|head -n1`
            wget "$MIRROR/core/os/$ARCH/$FILE" -c -O "$DIR/$FILE"
            xz -dc "$DIR/$FILE" | tar x -k -C "$CHROOT_DIR"
            rm -f "$CHROOT_DIR/.PKGINFO" "$CHROOT_DIR/.MTREE" "$CHROOT_DIR/.INSTALL"
    done
    # Create mount points
    mount -t proc proc "$CHROOT_DIR/proc/"
    mount -t sysfs sys "$CHROOT_DIR/sys/"
    mount -o bind /dev "$CHROOT_DIR/dev/"
    mkdir -p "$CHROOT_DIR/dev/pts"
    mount -t devpts pts "$CHROOT_DIR/dev/pts/"

    # Hash for empty password  Created by doing: openssl passwd -1 -salt ihlrowCo and entering an empty password (just press enter)
    # echo 'root:$1$ihlrowCo$sF0HjA9E8up9DYs258uDQ0:10063:0:99999:7:::' > "$CHROOT_DIR/etc/shadow"
    # echo "myhost" > "$CHROOT_DIR/etc/hostname"
    [ -f "/etc/resolv.conf" ] && cp "/etc/resolv.conf" "$CHROOT_DIR/etc/"

    mkdir -p "$CHROOT_DIR/etc/pacman.d/"
    echo "Server = $MIRROR/\$repo/os/$ARCH" >> "$CHROOT_DIR/etc/pacman.d/mirrorlist"

    chroot $CHROOT_DIR pacman-key --init
    chroot $CHROOT_DIR pacman-key --populate archlinux
    chroot $CHROOT_DIR pacman -Syu pacman --force
    [ -f "/etc/resolv.conf" ] && cp "/etc/resolv.conf" "$CHROOT_DIR/etc/"
    echo "Server = $MIRROR/\$repo/os/$ARCH" >> "$CHROOT_DIR/etc/pacman.d/mirrorlist"
    chroot $CHROOT_DIR

> Using the chroot Environment

Initializing pacman keyring

Before starting the installation, pacman keys need to be setup. Before
running the following two commands read pacman-key#Initializing the
keyring to understand the entropy requirements:

    # pacman-key --init
    # pacman-key --populate archlinux

Installation

Follow the Mount the partitions and Install the base system sections of
the Installation guide.

Debian-based host

On Debian-based host systems, pacstrap produces the following error:

    # pacstrap /mnt base
    # ==> Creating install root at /mnt
    # mount: mount point /mnt/dev/shm is a symbolic link to nowhere
    # ==> ERROR: failed to setup API filesystems in new root

In Debian, /dev/shm points to /run/shm. However, in the Arch-based
chroot, /run/shm does not exist and the link is broken. To correct this
error, create a directory /run/shm:

    # mkdir /run/shm

Configure the system

From that point, simply follow the Mount the partitions section of the
Installation guide and following sections.

Replacing the Existing System without a LiveCD
----------------------------------------------

Find ~500MB of free space somewhere on the disk, e.g. by partitioning a
swap partition. Install the new Arch Linux system there, reboot into the
newly created system, and rsync the entire system to the primary
partition. Fix the bootloader configuration before rebooting.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Install_from_Existing_Linux&oldid=303648"

Category:

-   Getting and installing Arch

-   This page was last modified on 8 March 2014, at 20:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
