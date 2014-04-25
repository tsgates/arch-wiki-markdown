Arch64 FAQ
==========

Below is a list of frequently asked questions about Arch Linux on
64-bit.

Contents
--------

-   1 How do I determine if my processor is x86_64 compatible?
    -   1.1 Linux users
    -   1.2 Windows users
-   2 Should I use the 32 or 64 bit version of Arch?
-   3 How can I install Arch64?
-   4 How complete is the port?
-   5 Will I have all the packages from my 32-bit Arch I am used to?
-   6 Why 64-bit?
-   7 How can I file bugs?
-   8 What repositories should I set up for pacman to use?
-   9 How can I patch existing PKGBUILDs for use with Arch64?
-   10 What will I miss in Arch64?
-   11 Can I run 32-bit apps inside Arch64?
-   12 Can I build 32-bit packages for i686 inside Arch64?
    -   12.1 Multilib repository
    -   12.2 Chroot
-   13 Can I upgrade/switch my system from i686 to x86_64 without
    reinstalling?

How do I determine if my processor is x86_64 compatible?
--------------------------------------------------------

> Linux users

Run the following command:

    $ less /proc/cpuinfo

Look for the flags entry. If you see the lm flag then your processor is
x86_64 compatible.

Or you can run this command:

    $ grep -q "^flags.*\blm\b" /proc/cpuinfo && echo "x86_64" || echo "not x86_64"

> Windows users

Using the freeware CPU-Z you can determine whether your CPU is 64-bit
compatible. CPUs with AMD's instruction set "AMD64" or Intel's solution
"EM64T" should be compatible with the x86_64 releases and binary
packages.

Should I use the 32 or 64 bit version of Arch?
----------------------------------------------

If your processor is x86_64 compatible, you should use Arch64.

How can I install Arch64?
-------------------------

Just use our official installation ISO CD.

How complete is the port?
-------------------------

The port is ready for daily use in a desktop or server environment.

Will I have all the packages from my 32-bit Arch I am used to?
--------------------------------------------------------------

The repositories are ported and pretty much everything should work as
expected.

Rarely, an old package in the AUR will only have 'i686' listed, but
typically they work for 64-bit too. Just try adding 'x86_64'.

Why 64-bit?
-----------

It is faster under most circumstances and as an added bonus also
inherently more secure due to the nature of Address space layout
randomization (ASLR) in combination with Position-independent code (PIC)
and the NX Bit which is not available in the stock i686 kernel due to
disabled PAE. If your computer is running 4 GB or more of usable RAM,
64-bit should be strongly considered as any additional RAM cannot be
allocated by a 32-bit OS.

Programmers also increasingly tend to care less about 32-bit ("legacy")
as "new" x86 CPUs typically support the 64-bit extensions.

There are many more reasons we could list here to tell you to avoid
32-bit, but between the kernel, userspace and individual programs it is
simply not viable to list every last thing that 64-bit does much better
these days.

For further details watch our differences reports. There you will find a
list comparing 32-/64-bit package versions.

How can I file bugs?
--------------------

Simply use Arch's Flyspray but select x86_64 in the Architecture field
if you think it is a port-related problem!

What repositories should I set up for pacman to use?
----------------------------------------------------

All repositories are supported for the port.

How can I patch existing PKGBUILDs for use with Arch64?
-------------------------------------------------------

Add the following variable to all ported packages:

    arch=('i686' 'x86_64') 

Add small patches directly to the sources and md5sums area but use for
complete different sources:

    [ "$CARCH" = "x86_64" ] && source=(${source[@]} 'other source')
    [ "$CARCH" = "x86_64" ] && md5sums=(${md5sums[@]} 'other md5sum')

For any small fix use this in the build area:

    [ "$CARCH" = "x86_64" ] && (patch -Np0 -i ../foo_x86_64.patch)

Or when you need more changes:

    if [ "$CARCH" = "x86_64" ]; then
        configure/patch/sed      # for x86_64
      else configure/patch/sed   # for i686
    fi

What will I miss in Arch64?
---------------------------

Nothing, really. Almost all applications support 64-bit by now or are in
the transition to become 64-bit compatible.

The biggest problem are packages that are either closed source or
contain x86-specific assembly that is cumbersome to port to 64-bit
(typical for emulators).

These applications were previously problematic but are now available in
the AUR and work fine:

-   Acrobat Reader is not available in 64-bit, but you can run the
    32-bit version in compatibility mode. There are also many other open
    source alternatives that can be used to read PDF files.

Everything else should work perfectly fine. If you miss any Arch32
package in our port and you know that it will compile on x86_64 (perhaps
you have found it as native packages in another 64-bit distribution),
just contact the developers or request a new package in the forums.

Can I run 32-bit apps inside Arch64?
------------------------------------

Yes!

-   You can install lib32-* libraries from the [multilib] repository. To
    use this repository, you should add the following lines to your
    /etc/pacman.conf:

    [multilib]
    SigLevel = PackageRequired
    Include = /etc/pacman.d/mirrorlist

At this time (December 2011), [multilib] contains wine and Skype.
Furthermore, a multilib compiler is available.

-   Or you can create another chroot with 32-bit system (refer to Arch64
    Install bundled 32bit system):

Boot into Arch64, startx, open a terminal.

    $ xhost +local:
    $ su
    # mount /dev/sda1 /mnt/arch32
    # mount --bind /proc /mnt/arch32/proc
    # chroot /mnt/arch32
    # su your32bitusername
    $ /usr/bin/command-you want # or eg: /opt/mozilla/bin/firefox

Some 32-bit apps (like OpenOffice) may require additional bindings. The
following lines can be placed in /etc/rc.local to ensure you get all you
need for the 32-bit apps (assuming /mnt/arch32 is mounted in
/etc/fstab):

    mount --bind /dev /mnt/arch32/dev
    mount --bind /dev/pts /mnt/arch32/dev/pts
    mount --bind /dev/shm /mnt/arch32/dev/shm
    mount --bind /proc /mnt/arch32/proc
    mount --bind /proc/bus/usb /mnt/arch32/proc/bus/usb
    mount --bind /sys /mnt/arch32/sys
    mount --bind /tmp /mnt/arch32/tmp
    #comment the following line if you do not use the same home folder
    mount --bind /home /mnt/arch32/home

You can then type in a terminal:

    $ xhost +localhost
    $ sudo chroot /mnt/arch32 su your32bitusername /opt/openoffice/program/soffice

Can I build 32-bit packages for i686 inside Arch64?
---------------------------------------------------

Yes. You can either use

-   the multilib versions of the relevant packages from the [multilib]
    repository or
-   an i686 chroot.

> Multilib repository

To use the [multilib] repository, edit your /etc/pacman.conf and
uncomment following lines:

    [multilib]
    SigLevel = PackageRequired
    Include = /etc/pacman.d/mirrorlist

upgrade your system with pacman -Syu and install the gcc-multilib
package.

> Note:

-   If the system has the base-devel package group installed, users must
    replace the [extra] versions with the [mutlilib] versions as shown
    below.
-   gcc-multilib is capable of building 32-bit and 64-bit code. You can
    safely install multilib-devel to replace the packages shown below,
    but you still need base-devel for the other packages it includes.
    See https://bbs.archlinux.org/viewtopic.php?id=102828 for more
    information.

    # pacman -S gcc-multilib

    resolving dependencies...
    warning: dependency cycle detected:
    warning: lib32-gcc-libs will be installed before its gcc-libs-multilib dependency
    looking for inter-conflicts...
    :: gcc-libs-multilib and gcc-libs are in conflict. Remove gcc-libs? [y/N] y
    :: binutils-multilib and binutils are in conflict. Remove binutils? [y/N] y
    :: gcc-multilib and gcc are in conflict. Remove gcc? [y/N] y
    :: libtool-multilib and libtool are in conflict. Remove libtool? [y/N] y

    Remove (4): gcc-libs-4.6.1-1  binutils-2.21.1-1  gcc-4.6.1-1  libtool-2.4-4

    Total Removed Size:   87.65 MB

    Targets (7): lib32-glibc-2.14-4  lib32-gcc-libs-4.6.1-1  gcc-libs-multilib-4.6.1-1  binutils-multilib-2.21.1-1
                 gcc-multilib-4.6.1-1  lib32-libtool-2.4-2  libtool-multilib-2.4-2

    Total Download Size:    25.04 MB
    Total Installed Size:   108.27 MB

    Proceed with installation? [Y/n]

Compiling packages on x86_64 for i686 is as easy as adding the following
lines to an alternate configuration file (e.g. ~/.makepkg.i686.conf)

    CARCH="i686"
    CHOST="i686-pc-linux-gnu"
    CFLAGS="-m32 -march=i686 -mtune=generic -O2 -pipe -fstack-protector --param=ssp-buffer-size=4 -D_FORTIFY_SOURCE=2"
    CXXFLAGS="${CFLAGS}"

and invoking makepkg via the following

    $ linux32 makepkg -src --config ~/.makepkg.i686.conf

> Chroot

To use an i686 chroot (installation with i686 ISO "quickinstall" is
recommended for the quick way to install it inside Arch64 or see Arch64
Install bundled 32bit system), install "linux32" wrapper pkg from
current to make the chroot behave like a real i686 system. Then use this
script to login into the chroot environment as root:

    #!/bin/bash
    mount --bind /dev /path-to-your-chroot/dev
    mount --bind /dev/pts /path-to-your-chroot/dev/pts
    mount --bind /dev/shm /path-to-your-chroot/dev/shm
    mount -t proc none /path-to-your-chroot/proc
    mount -t sysfs none /path-to-your-chroot/sys
    linux32 chroot /path-to-your-chroot

If you keep the sources on the x86_64 host system, you can add

    "mount --bind /path-to-your-stored-sources /path-to-your-chroot/path-to-your-stored-sources" 

to share sources from host to chroot system for pkg building used in
/etc/makepkg.conf.

Can I upgrade/switch my system from i686 to x86_64 without reinstalling?
------------------------------------------------------------------------

No. Strictly speaking any kind of migration implies that all packages or
nearly all packages must be reinstalled for the newer architecture.
However, it is possible to move your system without performing a fresh
install, and even from within your current installation. A forum thread
has been created here which outlines steps taken to successfully migrate
an install from 32 to 64 bit without losing any
configurations/settings/data. Note: A large external hard drive was used
for the transfer.

However, you can also start the system with the Arch64 installation CD,
mount the disk, backup anything you may want to keep that is not a
32-bit binary (e.g: /home & /etc), and install.

You may also want to read Migrating Between Architectures Without
Reinstalling.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch64_FAQ&oldid=300739"

Category:

-   Arch64

-   This page was last modified on 23 February 2014, at 16:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
