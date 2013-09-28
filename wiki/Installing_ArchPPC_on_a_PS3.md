Installing ArchPPC on a PS3
===========================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Project is no    
                           longer maintained;       
                           documentation is         
                           therefore useless        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This is not yet a guide. This is merely a log of steps to put ArchPPC
onto my PS3 as I am taking them.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Download and boot to a Gentoo PS3 ppc or ppc64 minimal install cd. |
| -   2 Disk Setup                                                         |
|     -   2.1 Partitioning                                                 |
|     -   2.2 Swapfile                                                     |
|     -   2.3 Make Filesystems                                             |
|     -   2.4 Mount Filesystems                                            |
|                                                                          |
| -   3 Install Arch                                                       |
|     -   3.1 Additional files                                             |
|         -   3.1.1 addedpacks                                             |
|         -   3.1.2 pacman.conf                                            |
|                                                                          |
|     -   3.2 Install packages                                             |
|     -   3.3 Additional configuration and setup                           |
|         -   3.3.1 /etc/fstab                                             |
|         -   3.3.2 Setting up SSH                                         |
|         -   3.3.3 Generate locales                                       |
|         -   3.3.4 Set the sticky bit on /tmp                             |
|                                                                          |
|     -   3.4 Compile Kernel                                               |
|         -   3.4.1 Compile your own                                       |
|         -   3.4.2 Install Erroneous' kernel                              |
|                                                                          |
|     -   3.5 Kboot                                                        |
|     -   3.6 Compile additional PS3 packages                              |
|         -   3.6.1 libspe                                                 |
|         -   3.6.2 ps3-utils                                              |
|         -   3.6.3 ps3pfutils                                             |
|         -   3.6.4 spu-newlib                                             |
+--------------------------------------------------------------------------+

Download and boot to a Gentoo PS3 ppc or ppc64 minimal install cd.
------------------------------------------------------------------

The Gentoo PPC Live CD's are a bit hefty, but the big plus is they can
run with the SSH daemon enabled, easily. This will simplify further
installation and configuration a lot. To do so,

    # /etc/init.d/sshd start

and set the root password so you can login via ssh:

    # passwd

Disk Setup
----------

> Partitioning

Now, setup the partitions for the drive. Note that the PS3 doesn't let
you even touch the partition that contains the PS3 data, so you are
safe.

    # cfdisk /dev/ps3da

My partition scheme was as follows:

    ps3da1 boot primary ext3(83) 10298.06 MB
    ps3da2      primary swap(82) 435.94 MB

> Swapfile

You should have a swap partition, or at least a swapfile. If you are
making a swapfile, make your other partitions, and mount your /
partition to a folder (I do it to /arch), and finally make your swapfile

    $ dd if=/dev/zero of=/arch/swapfile bs=1024 count=<# of KiB>

> Make Filesystems

Now, time to make the partition after saving the partition table.

    # mke2fs -j -O dir_index /dev/ps3da1
    # mkswap /dev/ps3da2
    # swapon /dev/ps3da2

or if you used a swapfile, replace /dev/ps3da2 with the swapfile
location once it is mounted.

> Mount Filesystems

    # mkdir /arch
    # mount /dev/ps3da1 /arch

Install Arch
------------

Update: The current pacman package (3.2.0 as I write this) has NO
pacman.static onboard anymore. You can, however, grab this older package
from the Archlinux PPC site which does contain a static version, so you
can install to the future root partition without problems. This implies
the script below will fail partially (actually mostly). Since I am not
the original author of this entry I'll consult the script author about a
rewrite or complete removal of this script, if necessary.

cd into /root and copy and paste the following into cat > <filename>. Be
sure to change the PACVER variable to the current pacman version at
ftp://ftp.archlinuxppc.org/core/os/ppc/. Here is the newarch script:

    #! /bin/bash
    #
    # newarch
    #
    # Author: gradgrind <mt.42@web.de>
    #
    # This file is part of the larch project.
    #
    #    larch is free software; you can redistribute it and/or modify
    #    it under the terms of the GNU General Public License as published by
    #    the Free Software Foundation; either version 2 of the License, or
    #    (at your option) any later version.
    #
    #    larch is distributed in the hope that it will be useful,
    #    but WITHOUT ANY WARRANTY; without even the implied warranty of
    #    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    #    GNU General Public License for more details.
    #
    #    You should have received a copy of the GNU General Public License
    #    along with larch; if not, write to the Free Software
    #    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA #
    #----------------------------------------------------------------------------
    # 

    #----------------------------- CONFIGURATION ------------------
    # WARNING! Relative paths (those not starting with /) are relative
    # to the directory containing this file, and should be processed
    # with 'readlink -f' in order to make them absolute, e.g.:
    #      VAR1=$( readlink -f ../dir/file )

    # directory to contain the freshly installed Arch Linux
    DESTDIR=/arch

    # Allows customizing of the cache for downloaded packages, default:
    PKGCACHE=$DESTDIR/var/cache/pacman/pkg
    # setting it to "" will cause the cache to be built and left in
    # the destination directory
    #PKGCACHE=""
    #PKGCACHE=/var/cache/pacman/pkg

    # pacman version, for ease of maintaining in case it get's updated.
    PACVER="3.1.1-1"

    # choose method for acquiring list of base packages
    #getbasepacks=basepacks_cvs
    getbasepacks=basepacks_ftp

    # list of base packages which should NOT be installed
    # e.g. BASEVETO="pkga pkgb"
    BASEVETO="devfsd lshwd"
    # devfsd is deprecated, but apparently still in base
    # lshwd is buggy and not usually needed any more

    #----------------------------- END OF CONFIGURATION -----------

    # Get path to directory containing this script
    SCRIPTDIR="`dirname \`readlink -f $0\``"

    echo "Changing current directory to $SCRIPTDIR"
    cd $SCRIPTDIR

    echo
    echo "newarch will do an automated Archlinux installation to the directory"
    echo "            $DESTDIR"
    echo
    echo "It only installs the packages, without configuration."
    echo
    echo "It runs two stages:"
    echo "                    install base packages - should generally be left unaltered"
    echo "       (optional)   install additional packages - main point of customization"
    echo

    if [ "$(whoami)" != 'root' ]; then
           echo "You must run this as 'root'"
           exit 1
    fi

    if [ -z "`echo $DESTDIR | grep '^/'`" ]; then
           DESTDIR=`pwd`/$DESTDIR
    fi

    echo "**********************************************************"
    echo "This will delete EVERYTHING under"
    echo
    echo "       $DESTDIR"
    echo
    echo "I really mean it ... Are you sure you want to do this?"
    echo "**********************************************************"
    # Await yes or no
    read -p "[y/N]: " ans
    if [ -z "`echo $ans | grep '^ *[yY]'`" ]; then exit 0; fi

    echo
    echo "Downloaded packages will be cached at      $PKGCACHE"
    echo
    # Await yes or no
    read -p "OK? [y/N]: " ans
    if [ -z "`echo $ans | grep '^ *[yY]'`" ]; then exit 0; fi

    if [ ! -d $DESTDIR ]; then
           mkdir -p $DESTDIR
    else
           rm -rf $DESTDIR/*
           if [ $? -ne 0 ]; then
                   echo "ERROR: couldn't remove $DESTDIR"
                   exit 1
           fi
    fi

    if [ -x /usr/bin/pacman ]; then
        PACMAN="pacman --config pacman.conf --noconfirm --cachedir $PKGCACHE"
    else
        echo
        echo "Downloading pacman"
        echo
        # use wget to download pacman
        # Updated to core and removed the setup/ subdir as noted in the discussion.
        # Please note: Apparently somebody removed the 'pacman.pkg.tar.gz' file, I'm
        # changing to it's current version. I would appreciate if somebody re-upload
        # the pacman.pkg.tar.gz or give me a better solution. :-) -- Felipe Mendes
        wget -c ftp://ftp.archlinuxppc.org/core/os/ppc/pacman-$PACVER-ppc.pkg.tar.gz
        (($? > 0)) && echo 'Looks like your pacman download failed. Please ensure the PACVER \
                       variable is set to the latest pacman version and release.' && exit 1
        tar -xzf pacman-$PACVER-ppc.pkg.tar.gz -O usr/bin/pacman.static >pacman.static
        chmod 755 pacman.static
        PACMAN="./pacman.static --config pacman.conf --noconfirm --cachedir $PKGCACHE"
    fi

    # Generate the list of base packages using cvs.archlinux.org
    basepacks_cvs ()
    {
        echo
        echo "*********** Getting base package list from cvs.archlinuxppc.org ***********"
        echo
        # Download index.html file for current/base
        rm -f index.html
        wget http://cvs.archlinuxppc.org/cgi-bin/viewcvs.cgi/base/
        # bad style, but working thou
        # There was a problem with this function. Somebody forgot to close sed quotes:
        cat index.html | grep '^<a name="[^A]' | sed 's|.*name="\(.\+\)" h.*|\1|' > packages.temp
        BASEPKGS=`cat packages.temp | sed 's|-|[^-]\+-[0-9].[0-9]\+\.pkg.*||'`
    }

    # Generate the list of base packages from ftp.archlinuxppc.org/.../packages.txt
    basepacks_ftp ()
    {
        echo
        echo "** Getting base package list from ftp.archlinuxppc.org/.../packages.txt **"
        echo
        rm -f packages.txt
        wget ftp://ftp.archlinuxppc.org/core/os/ppc/packages.txt
        # The sed regexp didn't worked with versions such as:
        # pam-0.99.8.1-3.1.pkg.tar.gz
        # and gcc-4.2.1-3.1.pkg.tar.gz
        # So I adapted it.
        BASEPKGS=`cat packages.txt | egrep '^base/' | \
                sed 's|^.*/||;s/-[0-9]\+.*//'`
    }

    # Fetch the list of packages from core/base to BASEPKGS
    $getbasepacks
    # Build basepacks by filtering BASEPKGS
    echo -n "" > basepacks
    #
    # I'm sure this next bit (filter out vetoed packages) can be done better,
    # any ideas? bash has so much weird syntax ... too complicated for me.
    #
    for p in $BASEPKGS; do
           for v in $BASEVETO; do
                   if [ "$v" == "$p" ]; then
                           p=""
                           break
                   fi
           done
           if [ -n "$p" ]; then
                   echo $p >> basepacks
           fi
    done

    doInstall() {
        echo "Installing following packages:"
        echo $PKGLIST
        $PACMAN -r $DESTDIR -S $PKGLIST
        if [ $? -gt 0 ]; then
           echo
           echo "Package installation from $pklist FAILED."
           echo
           exit 1
        fi
    }

    # This redirects the package cache, so that an existing one can be used.
    if [ -n "$PKGCACHE" ]; then
        mkdir -p $DESTDIR/var/cache/pacman
        mkdir -p $PKGCACHE
        ln -s $PKGCACHE $DESTDIR/var/cache/pacman/pkg
    fi

    echo
    echo "************** Synchronising package dbs **************"
    echo
    mkdir -p $DESTDIR/var/lib/pacman
    $PACMAN -r $DESTDIR -Sy

    echo
    echo "************** Installing base package set **************"
    echo
    pklist="basepacks"
    PKGLIST=`cat $pklist | grep -v "#"`
    doInstall

    echo
    echo "************** Additional packages **************"
    echo
    pklist="addedpacks"
    if [ -f $pklist ]; then
        PKGLIST=`cat $pklist | grep -v "#"`
        doInstall
    else
        echo " ... package list file 'addedpacks' not found"
        echo
    fi

    if [ -n "$PKGCACHE" ]; then
    # Remove the package cache redirection
        rm $DESTDIR/var/cache/pacman/pkg
    fi

    echo
    echo "Would you like to create a 'tar.gz' of the installation?"
    # Await yes or no
    read -p "[y/N]: " ans
    if [ -z "`echo $ans | grep '^ *[yY]'`" ]; then exit 0; fi
    echo "Doing     tar -czf archiball.tar.gz -C $DESTDIR ."
    echo "This could take a while ..."
    tar -czf archiball.tar.gz -C $DESTDIR .
    echo
    echo "+++ All done! +++"
    echo

> Additional files

Before running, you will also need the following files:

addedpacks

    # addedpacks - a simple list of packages (just package name, not file
    # name, e.g. 'python'), one per line,   _no other content!_ This is the primary
    # place for configuring which packages are installed.

    # place this file in the same directory as 'newarch'

    # You'll need a kernel!
    #kernel26 #We'll build our own kernel for the PS3
    #Must be built for ps3
    # Just some suggestions

    #for abs:
    cvsup

    # generally useful tools which do not require X:
    openssh
    rsync
    #dosfstools
    #lynx #Not in syncdb
    mc
    unzip
    zip
    fakeroot
    alsa-lib
    alsa-oss
    alsa-utils
    nano

pacman.conf

And quite importantly, pacman.conf:

    #
    # pacman.conf - for newarch
    #          put it in the same directory as newarch
    #
    # NOTE: If you find a mirror that is geographically close to you, please
    #       move it to the top of the server list, so pacman will choose it
    #       first.
    #

    # See the pacman manpage for option directives

    #
    # GENERAL OPTIONS
    #
    [options]
    LogFile     = /var/log/pacman.log
    NoUpgrade   = etc/passwd etc/group etc/shadow etc/sudoers
    NoUpgrade   = etc/fstab etc/raidtab etc/ld.so.conf
    NoUpgrade   = etc/rc.conf etc/rc.local
    NoUpgrade   = etc/modprobe.d/modprobe.conf etc/modules.conf
    NoUpgrade   = etc/lilo.conf boot/grub/menu.lst
    HoldPkg     = pacman glibc
    #XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u

    #
    # REPOSITORIES
    #   - can be defined here or included from another file
    #   - pacman will search repositories in the order defined here.
    #   - local/custom mirrors can be added here or in separate files
    #

    #[testing]
    #Server = ftp://ftp.archlinuxppc.org/testing/os/ppc

    [core]
    # Add your preferred servers here, they will be used first
    Server = ftp://ftp.archlinuxppc.org/core/os/ppc

    [extra]
    # Add your preferred servers here, they will be used first
    Server = ftp://ftp.archlinuxppc.org/extra/os/ppc

> Install packages

I placed all the files into my root's home directory. Run newarch by
entering:

    # sh newarch

> Additional configuration and setup

Since the Arch installer scripts are not run here, you should do things
manually.

/etc/fstab

Be sure to edit fstab so your / is in (and preferably swap too). If not,
/ will get mounted read-only and generate some ugly errors on boot
(without doing permanent damage though - it's read-only ;-)). Keep in
mind only reiserfs is not supported by Erroneous' kernel.

    /dev/ps3da1 	/ 			ext3 		defaults,noatime 	0 	1
    /dev/ps3da2 	swap 			swap 		swap            	0 	0

Add other partitions to your liking. If you didn't already do so, be
sure to activate swap:

    # swapon /dev/ps3da2

otherwise it will not get used and just sit there. This has to be done
only once.

Setting up SSH

Just like with the Live CD you want SSH to just log in from a
comfortable system (even if your keyboard and mouse are wireless staring
at a 40" screen can make your neck hurt after a while). Start the sshd
daemon, add it to the DAEMONS=() array, and - last but not least - add
it to /etc/hosts.allow:

    #
    # /etc/hosts.allow
    #

    sshd: ALL

    # End of file

Generate locales

Edit /etc/locale.gen as root and uncomment the locale you want to use
(in most cases you'll want a UTF-8 one). After that, run

    # locale-gen

Set the sticky bit on /tmp

Somehow /tmp had regular permissions while it should be sticky (so a
user can only remove stuff he created and not someone else's). You fix
that by doing

    # chmod 1777 /tmp

> Compile Kernel

Compile your own

I compiled the kernel from a working Archlinux i686 installation on
another computer. Currently, the ps3toolchain script doesn't quite work
on the ArchlinuxPPC because the gcc/binutils/glibc packages do not work
like the vanilla versions. Download the ps3toolchain from [1] and create
a toolchain for the PS3.

    # pacman -S autoconf automake bison flex gcc make ncurses patch subversion wget gmp mpfr
    $ wget http://ps2dev.org/ps3/Tools/Toolchain/ps3toolchain-20070626.tar.bz2.download
    $ tar xjf ps3toolchain-20070626.tar.bz2.download
    $ cd ps3toolchain
    $ export PS3DEV=/usr/ps3dev
    $ export PATH=$PATH:/$PS3DEV/bin
    $ export PATH=$PATH:/$PS3DEV/ppu/bin
    $ export PATH=$PATH:/$PS3DEV/spu/bin
    # sh toolchain.sh

This should take some time. When all is said and done, you'll have a
full gcc with patches for PPU and SPU systems (the PS3). We only need
the ppu-gcc right now though. Time to download the kernel.

    $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/geoff/ps3-linux.git ps3-linux

This may take some time depending on your connection. This also takes
quite a bit of space (1.5 GB at time of writing).

    $ cd ps3-linux
    $ nano Makefile

Add the following lines to the top of the Makefile:

    ARCH=powerpc
    CROSS_COMPILE=ppu-

Then make the config:

    $ make ps3_defconfig
    $ make menuconfig

Unselect "Enable loadable module support", exit, save as .config. This
must be done because the toolchain's version of gcc doesn't support
loadable module support...

    $ make

Copy vmlinux to PS3. This is easy if you ran /etc/init.d/sshd start and
set the root password using `passwd` on the PS3.

    $ scp vmlinux root@IP_OF_PS3:/arch/boot/

Install Erroneous' kernel

    $ wget http://theerroneous.net/kernel26-ps3-2.6.25-1-i686.pkg.tar.gz
    # pacman -U kernel26-ps3-2.6.25-1-ppc.pkg.tar.gz

Update: On a current (September 9th, 2008) Arch i686 system the binutils
build - the very first one - seems to fail. Alternatively, one can use
the cross-compiling toolchain available here (for i686) and here for
x86_64. Many thanks to kth5 for providing these - take note however
you'll only be able to build 32 bit PPC packages with these, no 64 bit
ones (and thus no 64bit PS3 kernel). Distros like Fedora at least come
with a 64 bit PPC kernel, and seemingly a 32 bit PPC userland. Gentoo,
unsurprisingly, seems to go fully 64 bit. Ubuntu is a bit fuzzy - at
least from the naming scheme of the packages you can't tell whether they
do mixed or don't.

> Kboot

Luckily this doesn't need to be installed, but rather you need to have
/etc/kboot.conf loaded with the proper information so that your install
will boot. This is fairly simple. Just run:

    # cat > /etc/kboot.conf

and copy and paste the following (ssh is good for this):

    default=archlinux
    root=/dev/ps3da1
    archlinux='/boot/vmlinuz26 init=/sbin/init 4 video=ps3fb:mode:1 rhgb'

Then press ctrl+c. This is a quick and dirty method for writing files to
disk by copying and pasting that doesn't worry about linewrap which is
enabled by default in nano.

While this kboot configuration does specify a kernel and accompanying
boot commands, kboot will not pick it up automatically. This can be a
pain if you set your system to be managed over SSH - you do not seem to
be able to use the joysticks to tell kboot to boot the kernel; that
would mean you would have to hook up a keyboard to stroke that Enter key
every single time you boot into Arch. This can be solved by adding the
following line to kboot.conf under the default= line:

    timeout=10

As you could have guessed the integer you specify is the amount of
seconds kboot waits before booting the default entry.

Before you boot: You need to install makedev:

    # pacman -S makedev

And from within a chroot of your system, do the following (uppercase is
intentional):

    # MAKEDEV console zero null

Now you can reboot, take out the CD, and boot into Archlinux!

> Compile additional PS3 packages

libspe

ps3-utils

Get the PKGBUILD from the AUR and run

    $ makepkg -i

This package supplies the following utilities:

-   ps3-boot-game-os (boots Sony's PS3 game os, essential to get back to
    the 'vanilla' state of the PS3)
-   ps3-dump-bootloader (dumps the otheros data to a file)
-   ps3-flash-util (loads otheros data)
-   ps3-rtc-init (initializes the RTC diff value)
-   ps3-video-mode (lists and sets the available display modes for the
    screen onto which the PS3 is connected)

ps3pfutils

This package normally provides the ps3-video-mode too, which is provided
by the vanilla ps3utils build, and thus included in the package built
with the PKGBUILD linked to above.

spu-newlib

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_ArchPPC_on_a_PS3&oldid=254495"

Category:

-   Getting and installing Arch
