Migrating Between Architectures Without Reinstalling
====================================================

This page documents two potential methods of migrating installed systems
between i686 (32-bit) and x86_64 (64-bit) architectures, in either
direction. The methods avoid reinstalling the entire system. One method
uses a liveCD, the other modifies the system from within.

Warning:Unless explicitly stated, all these methods are UNTESTED and may
irreparably damage your system. Continue at your own risk.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 General preparation                                                |
|     -   1.1 Confirm 64-bit architecture                                  |
|     -   1.2 Disk space                                                   |
|     -   1.3 Power supply                                                 |
|     -   1.4 Fallback packages                                            |
|                                                                          |
| -   2 Method 1: Utilising the Arch LiveCD                                |
| -   3 Method 2: From a running system                                    |
|     -   3.1 Package preparation                                          |
|         -   3.1.1 Cache old packages                                     |
|         -   3.1.2 Change Pacman architecture                             |
|         -   3.1.3 Download new packages                                  |
|                                                                          |
|     -   3.2 Package installation                                         |
|         -   3.2.1 Install kernel (64-bit)                                |
|         -   3.2.2 Console terminal                                       |
|         -   3.2.3 Install Pacman                                         |
|         -   3.2.4 Install remaining packages                             |
|                                                                          |
| -   4 Cleanup                                                            |
|     -   4.1 Makepkg compiler flags                                       |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 Busybox                                                      |
|     -   5.2 Lib32-glibc                                                  |
|     -   5.3 KDE doesn't start after switching from 32bit to 64bit        |
|     -   5.4 Mutt issues with cache enabled                               |
|                                                                          |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

General preparation
-------------------

> Confirm 64-bit architecture

If you are already running x86_64 but want to install i686 this is not
relevant and you can skip this step.

In order to run 64-bit software, you must have a 64-bit capable CPU.
Most modern CPUs are capable of running 64-bit software. You may check
your CPU with the following command:

    grep --color '\<lm\>' /proc/cpuinfo

For CPUs that support x86_64, this will return the lm flag (“long mode”)
highlighted. Beware that lahf_lm is a different flag and does not
indicate 64-bit capability itself.

> Disk space

You should be prepared for /var/cache/pacman/pkg to grow approximately
twice its current size during the migration. This is assumes only
packages that are currently installed are in the cache, as if “pacman
-Sc” (clean) was recently run. The disk space increase is due to
duplication between the i686 and x86_64 versions of each package.

If you have not enough disk, please use gparted to resize the relevant
partition, or mount another partition to /var/cache/pacman.

Please do not remove packages of the old architecture from the cache
until the system is fully operating in the new architecture. Removing
the packages too early may leave you unable to fall back and revert
changes.

> Power supply

The migration may take a substantial amount of time, and it would be
inconvenient to interrupt the process. You should plan on at least an
hour, depending on the number and size of your installed packages and
internet connection speed (although you can download everything before
starting the critical part). Please make sure you are connected to a
stable power source, preferably with some sort of failover or battery
backup.

> Fallback packages

If the migration fails halfway through, there are packages that can help
sort out the situation, but they should be installed before the main
packages are migrated. More details about using them under
#Troubleshooting below.

One package is busybox, which can be used to revert changes. It is
statically linked and does not depend on any libraries. The 32-bit
(i686) version should be installed, using

    # pacman -S busybox

Another package is lib32-glibc, from the Multilib x86_64 repository. It
is probably only useful when migrating away from 32 bits; in any case
you may safely skip this package. You can use the package to run 32 bit
programs by explicitly calling /lib/ld-linux.so.2. Install with:

    # pacman -S lib32-glibc

Method 1: Utilising the Arch LiveCD
-----------------------------------

1.  Download, burn and boot the 64-bit Arch ISO LiveCD
2.  Configure your network on the LiveCD, then pacman to use your new
    architecture repos
3.  Mount your existing installation to /mnt directory. For example:
    mount /dev/sda1 /mnt
4.  Use the following script to update the local pacman database, get a
    list of all your installed packages and then reinstall them.
5.  You should probably run the script twice, because many packages fail
    to run their post-install scripts first time. This is due to sed,
    grep, perl, etc. being of the wrong architecture.
6.  You might also need to update the initrd, chroot into /mnt and run
    mkinitcpio -p linux.

    #!/bin/bash

    MOUNTED_INSTALL='/mnt'
    TEMP_FILE='/tmp/packages.list'

    pacman --root $MOUNTED_INSTALL -Sy
    pacman --root $MOUNTED_INSTALL --cachedir $MOUNTED_INSTALL/var/cache/pacman/pkg --noconfirm -Sg base base-devel
    pacman --root $MOUNTED_INSTALL -Qq > $TEMP_FILE
    for PKG in $(cat $TEMP_FILE) ; do
       pacman --root $MOUNTED_INSTALL --cachedir $MOUNTED_INSTALL/var/cache/pacman/pkg --noconfirm -S $PKG
    done

    exit 0

After rebooting to your new 64-bit system, run this command to find out
what 32-bit binaries you still have and reinstall them:

    find /usr/bin -type f -exec bash -c 'file {} | grep 32-bit' \;

Method 2: From a running system
-------------------------------

Ensure that your system is fully updated and functioning before
proceeding.

    # pacman -Syu

> Package preparation

Cache old packages

Note:If you have any packages installed from the AUR or third-party
repositories without new architecture availability, pacman will let you
know it cannot find a suitable replacement. Make a list of these
packages so you may re-install them after the update process and then
remove them using pacman -Rsn package_name.

If you do not have all your installed packages in your cache, download
them (for the old architecture) for fallback purposes.

    # pacman -Sw $(comm -23 <(pacman -Qq|sort) <(pacman -Qmq|sort))

or use bacman from pacman package to generate them.

The command above redownloads ALL packages, even the ones already in the
cache. This script only downloads the ones not in the cache:

    #!/bin/bash

    cache=`pacman -v 2>/dev/null|grep "Cache Dirs"|cut -d ':' -f 2| sed 's/ //g'`

    for pkg in `comm -23 <(pacman -Qq|sort) <(pacman -Qmq|sort)`
    do
            if ! ls $cache/`pacman -Q $pkg|sed 's/ /-/g'`* 2>/dev/null >&2;then
                    echo 'Y'|pacman -Sw $pkg
            fi
    done

If you are migrating away from 32 bits, now is the time to install
32-bit Busybox:

    # pacman -S busybox

Change Pacman architecture

Edit the /etc/pacman.conf file and change Architecture from auto to the
new value. These sed commands may be used:

For x86_64:

    # sed -i  '/^Architecture =/s/auto/x86_64/' /etc/pacman.conf

and for i686:

    # sed -i  '/^Architecture =/s/auto/i686/' /etc/pacman.conf

Make sure the server lists in /etc/pacman.conf and
/etc/pacman.d/mirrorlist use $arch instead of explicitly specifying i686
or x86_64. Now force Pacman to synchronize with the new repositories:

    # pacman -Syy                     # force sync new architecture repositories

Download new packages

Download the new architecture versions of all our currently installed
packages:

    # pacman -Sw $(pacman -Qq|sed '/^lib32-/ d')  # download new package versions

If there are some packages, likely from the AUR, that cannot be
downloaded, remove them from the list generated by pacman -Qq.

    # pacman -Sw $(comm <(pacman -Qq|sed '/^lib32-/ d'|sort) <(pacman -Qqm|sort) -23)

If migrating to 32 bits, install the 32-bit Busybox fallback now that
Pacman has been configured with the 32-bit architecture:

    # pacman -S busybox

Warning:Don't install the lib32-glibc package now. After a ldconfig,
when you install linux, the generated image will have libraries like
librt.so in /usr/lib32, where binaries during boot won't search,
resulting in a boot failure.

> Package installation

Install kernel (64-bit)

Upgrading the kernel to 64 bits (x86_64) is safe and straightforward: 32
bit and 64 bit applications run equally well under a 64-bit kernel. For
migration away from 64 bits, leave the 64-bit kernel installed and
running for now and skip this step.

To install the standard Arch Linux kernel, use the following command:

    # pacman -S linux

Now is the time to install the lib32-glibc fallback (you will need to
add the [multilib] repository in pacman.conf if you have not already):

    # pacman -S lib32-glibc

Note:If this fails due to an existing file of a differently named
package, use pacman's -f flag.

Reboot and verify it is running the x86_64 architecture:

    $ uname -m

    x86_64

Console terminal

This is the time to switch to a text-mode virtual console (e.g.
Ctrl+Alt+F1) for the rest of the process, if possible. Pseudo-terminals
like SSH should work, but direct access is recommended as a precaution.
There will be several packages removed and replaced during the update
process that may cause X11 desktops to become unstable and leave your
system in an unbootable state.

Install Pacman

Warning:Once you start updating pacman and its dependencies it can not
be interrupted. Pacman and all of its dependencies must be installed at
the same time in a single command line.

Use pactree to install Pacman and all its dependencies:

    # pactree -l pacman | pacman -S -

Errors may be printed but they will not cause a problem as long as
Pacman works. Immediately following this command only Busybox, Bash and
Pacman will be executable until the other packages are migrated below.
You must not reboot your system until the following commands have been
completed. You have been warned.

Install remaining packages

Install all of the previously downloaded replacements for the new
architecture. (Go get a drink and make a sandwich; this could take a
while.)

    # pacman -S $(pacman -Qq)

If some packages didn't install correctly, you should now be able to
reinstall them successfully; if you're lazy, you can just re-run the
last command to reinstall everything.

For migration away from 64 bits, you may want to skip installing a
32-bit kernel in the commands above, since the old 64-bit kernel will
still run 32-bit programs.

After this step the migration in either direction should be complete and
it should be safe to reboot the computer.

Cleanup
-------

You are now free to remove Busybox and lib32-glibc.

    # pacman -Rcn busybox lib32-glibc

Makepkg compiler flags

During the upgrade the new version of /etc/makepkg.conf may be stored as
/etc/makepkg.conf.pacnew. You will have to replace the old version or
modify it, if you want to compile anything with makepkg in the future.

    # mv /etc/makepkg.conf /etc/makepkg.conf.backup && mv /etc/makepkg.conf.pacnew /etc/makepkg.conf

It might also be a good idea to just get a list of "new" additions to
/etc. You can get a list with the following command:

    # find /etc/ -type f -name \*.pac\*

Troubleshooting
---------------

During the upgrade, when glibc is replaced by the new architecture
version, old architecture versions of many programs will not run. If
problems occur, you can solve them with busybox and lib32-glibc.

> Busybox

In Arch, Busybox is statically linked; it can run without any libraries.
There are many commands available to you. For example, to extract an
i686 version of Pacman from a cached package:

    # busybox tar xf /var/cache/pacman/pkg/pacman-3.3.2-1-i686.pkg.tar.gz -C <some folder>

> Lib32-glibc

Example run 32 bit /bin/ls:

    # /lib/ld-linux.so.2 /bin/ls

> KDE doesn't start after switching from 32bit to 64bit

KDE will crash when starting after switching from 32bit to 64bit. The
cause are some leftover cached files from the 32 bit KDE packages in
/var/tmp To fix this remove all kdecache folders in with

    # rm -rf /var/tmp/kdecache-*

> Mutt issues with cache enabled

If, after completion, you find that mutt hangs on opening mail folders,
try renaming the cache directory. If this works, the renamed one can be
deleted as mutt will have recreated a new one.

See also
--------

-   Migrate installation to new hardware

Retrieved from
"https://wiki.archlinux.org/index.php?title=Migrating_Between_Architectures_Without_Reinstalling&oldid=252950"

Categories:

-   Arch64
-   Getting and installing Arch
