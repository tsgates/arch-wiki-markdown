Install from Existing Linux
===========================

This guide is intended for anybody who wants to install Arch Linux from
any other running Linux -- be it off a LiveCD or a pre-existing install
of a different distro.

This is useful for:

-   remotely installing Archlinux (e.g. a (virtual) root server)
-   creating a new linux distribution or LiveCD based on Archlinux
-   creating an Archlinux chroot environments
-   rootfs-over-NFS for diskless machines

This guide requires that the existing host system be able to execute the
new target Arch Linux architecture programs. In the case of an x86_64
host, it is possible to use i686-pacman to build a 32-bit chroot
environment. See Arch64 Install bundled 32bit system. However it is not
so easy to build a 64-bit environment when the host only supports
running 32-bit programs.

Note:If you are already using Arch, instead of following this guide,
just install arch-install-scripts from the official repositories and
follow the Installation Guide

This guide provides additional steps to the Installation Guide. The
steps of that guide must still be followed as needed.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prepare the system                                                 |
| -   2 Setup the environment for pacman                                   |
|     -   2.1 Method 1: Chroot into LiveCD-image                           |
|     -   2.2 Method 2: Bootstrapping the arch installation scripts        |
|     -   2.3 Method 3: Install pacman natively on non-arch distro         |
|         (advanced)                                                       |
|         -   2.3.1 Download pacman source code and pacman packages        |
|         -   2.3.2 Install dependencies                                   |
|         -   2.3.3 Compile pacman                                         |
|         -   2.3.4 Prepare configuration files                            |
|                                                                          |
| -   3 Fix the Pacman Signature Keyring                                   |
| -   4 Setup the target system                                            |
|     -   4.1 Edit the fstab file                                          |
|     -   4.2 Finish the Installation                                      |
|                                                                          |
| -   5 Tips and tricks                                                    |
+--------------------------------------------------------------------------+

Prepare the system
------------------

Follow the Installation Guide steps, until you have your partitions,
keyboard and internet connection ready.

Setup the environment for pacman
--------------------------------

You need to create an environment where pacman and the arch install
scripts can run on your current linux distro.

Note:Choose one of this methods to create an environment able to execute
the arch install scripts. That environment is not your final
installation. You still need to do the rest of steps

There are in principle two different methods to prepare that
environment: either by installing pacman natively (Method 4 below) on
your linux distro or by setting up a chroot environment. The latter way
will generally be easier and is discussed next:

-   Using chroot as an installation environment: The prepared Archlinux
    chroot environment will be used temporarily to set up the actual
    Archlinux installation using the arch-install-scripts. This is a bit
    more work and takes longer but once you set up the installation
    system you can quickly install several Archlinux systems. However,
    if you want to set up only a single Archlinux this might be
    overkill. You are actually setting up the system twice, have a lot
    more network traffic and especially need a lot more RAM and disk
    space, mostly due to the quite big iso image.

The best advice is probably to use Direct bootstrapping to set up only a
small number of systems. If you set up many Archlinux systems the chroot
install environment or even the native pacman installation might suit
you better.

> Method 1: Chroot into LiveCD-image

It is possible to mount the root image of the latest Archlinux
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

-   To unsquash the x86_64 (or i686 respectively) root image, run

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

This chroot is able to execute the arch install scripts. The destination
partitions should be mounted under the /mnt directory from this chroot.

when chrooting Debian based host systems the /dev/shm points to /run/shm
. /run/shm does not exist in the chroot environment , the link is broken
and pacstrap returns an error. create a directory /run/shm in the chroot
environment when chrooting from debian based host systems

> Method 2: Bootstrapping the arch installation scripts

Contrary to the other methods, this method is one-step only; you only
have to execute the script below and thats it.

This method provides a chroot enviroment from where to execute the arch
install scripts (similar to Method 1), by using a bootstrapping script.

The script below is going to create a directory called archinstall-pkg
and download the required packages there. Then, is going to extract them
into the archinstall-chroot directory. Finally, is going to prepare
mount points, configure pacman and enter into a chroot.

Note:This is only an enviroment to execute the arch install scripts:
this is not your final installation.

This chroot is able to execute the arch install scripts. The destination
partitions should be mounted under the /mnt directory from this chroot.
After that, continue with the next step, which is #Fix the Pacman
Signature Keyring.

CHROOT_DIR=archinstall-chroot Must Change First, or you might ruin your
/etc/

    archinstall-bootstrap.sh

    #!/bin/bash
    # This script is inspired on the archbootstrap script.

    PACKAGES=(acl attr bzip2 curl expat glibc gpgme libarchive libassuan libgpg-error libssh2 openssl pacman xz zlib pacman-mirrorlist coreutils bash grep gawk file tar ncurses readline libcap util-linux pcre arch-install-scripts)
    # Change the mirror as necessary
    MIRROR='http://mirrors.kernel.org/archlinux' 
    # You can set the ARCH variable to i686 or x86_64
    ARCH=`uname -m`
    LIST=`mktemp`
    CHROOT_DIR=archinstall-chroot
    DIR=archinstall-pkg
    mkdir -p "$DIR"
    mkdir -p "$CHROOT_DIR"
    # Create a list with urls for the arch packages
    for REPO in core community extra; do  
            wget -q -O- "$MIRROR/$REPO/os/$ARCH/" |sed  -n "s|.*href=\"\\([^\"]*\\).*|$MIRROR\\/$REPO\\/os\\/$ARCH\\/\\1|p"|grep -v 'sig$'|uniq >> $LIST  
    done
    # Download and extract each package.
    for PACKAGE in ${PACKAGES[*]}; do
            URL=`grep "$PACKAGE-[0-9]" $LIST|head -n1`
            FILE=`echo $URL|sed 's/.*\/\([^\/][^\/]*\)$/\1/'`
            wget "$URL" -c -O "$DIR/$FILE" 
            xz -dc "$DIR/$FILE" | tar x -k -C "$CHROOT_DIR"
    done
    # Create mount points
    mkdir -p "$CHROOT_DIR/dev" "$CHROOT_DIR/proc" "$CHROOT_DIR/sys" "$CHROOT_DIR/mnt"
    mount -t proc proc "$CHROOT_DIR/proc/"
    mount -t sysfs sys "$CHROOT_DIR/sys/"
    mount -o bind /dev "$CHROOT_DIR/dev/"
    mkdir -p "$CHROOT_DIR/dev/pts"
    mount -t devpts pts "$CHROOT_DIR/dev/pts/"

    # Hash for empty password  Created by doing: openssl passwd -1 -salt ihlrowCo and entering an empty password (just press enter)
    echo 'root:$1$ihlrowCo$sF0HjA9E8up9DYs258uDQ0:10063:0:99999:7:::' > "$CHROOT_DIR/etc/shadow"
    echo "root:x:0:0:root:/root:/bin/bash" > "$CHROOT_DIR/etc/passwd" 
    touch "$CHROOT_DIR/etc/group"
    echo "myhost" > "$CHROOT_DIR/etc/hostname"
    test -e "$CHROOT_DIR/etc/mtab" || echo "rootfs / rootfs rw 0 0" > "$CHROOT_DIR/etc/mtab"
    [ -f "/etc/resolv.conf" ] && cp "/etc/resolv.conf" "$CHROOT_DIR/etc/"
    sed -ni '/^[ \t]*CheckSpace/ !p' "$CHROOT_DIR/etc/pacman.conf"
    sed -i "s/^[ \t]*SigLevel[ \t].*/SigLevel = Never/" "$CHROOT_DIR/etc/pacman.conf"
    echo "Server = $MIRROR/\$repo/os/$ARCH" >> "$CHROOT_DIR/etc/pacman.d/mirrorlist"

    chroot $CHROOT_DIR /usr/bin/pacman -Sy 
    chroot $CHROOT_DIR /bin/bash

> Method 3: Install pacman natively on non-arch distro (advanced)

Warning:This method is potentially difficult, your mileage may vary from
distro to distro. If you just want to do an arch installation from
another distro and you are not interested in have pacman as a regular
program under such distro, is better to use a different method.

This method is about installing pacman and the arch install scripts
directly under another distro, so they become regular programs on that
distro.

This is really useful if you are planning to use another distro
regularly to install arch linux, or do fancy things like updating
packages of an arch installation using another distro. This is the only
method that not imply creating a chroot to be able to execute pacman and
the arch install scripts. (but since part of the installation includes
entering inside a chroot, you'll end using a chroot anyway)

Download pacman source code and pacman packages

Visit the pacman homepage: https://www.archlinux.org/pacman/#_releases
and download the latest release.

Now, download the following packages:

-   pacman-mirrorlist:
    https://www.archlinux.org/packages/core/any/pacman-mirrorlist/download/
-   arch-install-scripts:
    https://www.archlinux.org/packages/extra/any/arch-install-scripts/download/
-   pacman (necessary for the config files):
    https://www.archlinux.org/packages/core/x86_64/pacman/download/
    (change x86_64 as necessary)

Install dependencies

Using your distribution mechanisms, install the required packages for
pacman and the arch install scripts. libcurl, libarchive, fakeroot, xz,
asciidoc, wget, and sed are among them. Of course, gcc, make and maybe
some other "devel" packages are necessary too.

Compile pacman

-   Decompress the pacman source code and cd inside.
-   Execute configure, adapting the paths as necessary:

         ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --enable-doc

If you get errors here, chances are you are missing dependencies, or
your current libcurl, libarchive or others, are too old. Install the
dependencies missing using your distro options, or if they are too old,
compile them from source.

-   Compile

        make

-   If there were no errors, install the files

        make install

-   You may need to manually call ldconfig to make your distro detect
    libalpm.

Prepare configuration files

Now is time to extract the configuration files. Change the x86_64 as
necessary.

-   Extract the pacman.conf and makepkg.conf files from the pacman
    package, and disable signature checking:

        tar xJvf pacman-*-x86_64.pkg.tar.xz etc -C / ; sed -i 's/SigLevel.*/SigLevel = Never/g' /etc/pacman.conf

-   Extract the mirror list:

        tar xJvf pacman-mirrorlist-*-any.pkg.tar.xz -C /

-   Enable some mirrors on /etc/pacman.d/mirrorlist
-   Extract the arch-install-scripts

        tar xJvf arch-install-scripts-*-any.pkg.tar.xz -C /

Another option is using the alien tool to convert the pacman-mirrorlist
and arch-install-scripts (but no pacman) to native packages of your
distro.

Fix the Pacman Signature Keyring
--------------------------------

It is necessary to initialize pacman's keyring for signature checking.

This is done using

    # pacman-key --init # read the note below!
    # pacman-key --populate archlinux

However, when connected via SSH you might run out of entropy. In this
case you can try something like

    # cat /usr/bin/* > /dev/null &
    # find / > /dev/null &

before executing pacman-key --init.

It might take some time. If nevertheless all this does help install
haveged and run prior to pacman-key --init

    # /usr/sbin/haveged -w 1024 -v 1

  

Setup the target system
-----------------------

At this point, follow the normal steps of Installation Guide. Remember
to mount the destination partition under the /mnt of the chroot.

    # pacstrap /mnt base base-devel
    # # ...

> Edit the fstab file

Probably the genfstab script won't work. In that case, you'll need to
edit the /mnt/etc/fstab file by hand. You can use the content of
/etc/mtab as reference.

> Finish the Installation

Now just do the rest of the steps normally.

Tips and tricks
---------------

-   In case you want to replace an existing system, but can for some
    reason not use a LiveCD, since, e.g., you have no physical access to
    the computer, the following tip might help: If you manage to get
    ~500MB of free space somewhere on the disk (e.g. by partitioning a
    swap partition) you can install the new Archlinux system there,
    reboot into the newly created system and rsync the entire system to
    the primary partition. Finally don't forget to fix the bootloader
    configuration before rebooting.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Install_from_Existing_Linux&oldid=255361"

Category:

-   Getting and installing Arch
