Arch Terminology
================

This page is intended to be a page to demystify common terms used among
the Arch Linux community. Feel free to add or modify any terms, but
please use that particular section's edit option. If you decide to add
one, please put it in alphabetical order.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Arch Linux                                                         |
| -   2 ABS                                                                |
| -   3 AUR                                                                |
| -   4 PKGBUILD                                                           |
| -   5 TU, Trusted User                                                   |
| -   6 TUR, Trusted User Repository (obsolete)                            |
| -   7 bbs                                                                |
| -   8 community/[community]                                              |
| -   9 core/[core]                                                        |
| -   10 custom/user repository                                            |
| -   11 developer                                                         |
| -   12 devfs                                                             |
| -   13 /etc/network-profiles                                             |
| -   14 /etc/rc.conf                                                      |
| -   15 /etc/rc.d                                                         |
| -   16 /etc/rc.local                                                     |
| -   17 extra/[extra]                                                     |
| -   18 hwd                                                               |
| -   19 hwdetect                                                          |
| -   20 initramfs                                                         |
| -   21 initrd                                                            |
| -   22 makepkg                                                           |
| -   23 namcap                                                            |
| -   24 package                                                           |
| -   25 pacman                                                            |
| -   26 pacman.conf                                                       |
| -   27 release/[release]                                                 |
| -   28 repository/repo                                                   |
| -   29 RTFM                                                              |
| -   30 taurball                                                          |
| -   31 testing/[testing]                                                 |
| -   32 udev                                                              |
| -   33 wiki                                                              |
+--------------------------------------------------------------------------+

Arch Linux
----------

Arch should be referred to as:

-   Arch Linux
-   Arch (Linux implied)
-   archlinux (UNIX name)

Archlinux, ArchLinux, archLinux, aRcHlInUx, etc. are all weird, and
weirder mutations.

Officially, the 'Arch' in "Arch Linux" is pronounced /ˈɑrtʃ/ as in an
"archer"/bowman, or "arch-nemesis", and not as in "ark" or "archangel".

ABS
---

The Arch Build System (ABS) is useful to:

-   Make new packages of software for which no packages are yet
    available
-   Customize/modify existing packages to fit your needs (enabling or
    disabling options)
-   Re-build your entire system using your compiler flags, "a la Gentoo"
-   Getting kernel modules working with your custom kernel

ABS is not necessary to use Arch Linux, but it is useful.

AUR
---

The Arch User Repository (AUR) is a community driven repository for Arch
users. The AUR was initially conceived to organize the sharing of
PKGBUILDs amongst the wider community and to expedite the inclusion of
popular user-contributed packages into the [core] and [extra]
repositories via the AUR [community] repository.

The AUR is the birthplace of new Arch packages. Users contribute their
own packages to the AUR. The AUR community votes for their favourite
packages and eventually, once a package has garnered enough votes, an
AUR Trusted User may take it to the [community] repository, which is
accessible via pacman and the ABS.

You can access the Arch Linux User Community Repository here.

PKGBUILD
--------

PKGBUILDs are small scripts that are used to build Arch Linux packages.
See Creating Packages for more detail.

TU, Trusted User
----------------

A trusted user is someone who maintains the AUR and the [community]
repository. Trusted Users may move a package into the [community]
repository if it has been voted as popular. TUs are appointed by a
majority vote by the existing TUs.

Trusted users follow the AUR Trusted User Guidelines and TU by-laws

TUR, Trusted User Repository (obsolete)
---------------------------------------

Before the AUR and [community], TUs had their own repositories with
applications that were not available in the official ones. Anyone can
make a repository, but TURs were thought to be of higher quality,
because TUs are voted for their knowledge and effort.

bbs
---

Bulletin board system, but in Arch's case, it is just the support forum
located here.

community/[community]
---------------------

The [community] repository is where pre-built packages are made
available by Trusted Users. A majority of the packages in [community]
come from the AUR.

To access the [community] repository, uncomment it in /etc/pacman.conf.

core/[core]
-----------

The [core] repository contains the bare packages needed for an Arch
Linux system. [core] has everything needed to get a working command-line
system.

custom/user repository
----------------------

Anyone can create a repository and put it online for other users. To
create a repository, you need a set of packages and a pacman-compatible
database file for your packages. Host your files online and everyone
will be able to use your repository by adding it as a regular
repository.

See Custom local repository.

developer
---------

Half-gods working to improve Arch for no financial gain. Developers are
outranked only by our gods, Judd Vinet and Aaron Griffin, who in turn
are outranked by tacos.

devfs
-----

The device file system. DevFS handles, dynamically, the creation,
deletion and permission management of device nodes in the /dev
directory. It was the default kernel device manager in Arch Linux until
release 0.7. Now DevFS is deprecated and is in the process of being
removed from the Linux kernel. DevFS has been superseded by udev.

Note that Arch installation CDs prior to 0.7.1 use the devfs naming
scheme when creating /etc/fstab entries.

/etc/network-profiles
---------------------

In this, you can create various network configurations.

This is very useful for laptop users that switch networks very often,
for example between a home and an office network.

Additionally it can be used with wpa_supplicant that can manage all of
you wireless networks. For each configuration, you need to make a
configuration file. The easiest way to do this is by copying the
template. After you are done with this, you need to enable these in
/etc/rc.conf.

After applying changes, you should restart your network by running the
following command as root:

     /etc/rc.d/network restart

/etc/rc.conf
------------

/etc/rc.conf was the main system configuration file for Arch Linux. It
allows you to set your network and daemons to run at bootup. Detailed
description of the configuration options is given here: Rc.conf

/etc/rc.d
---------

/etc/rc.d is a directory that contains the scripts that handle starting
and stopping of services. On every boot, the services that are present
in the DAEMONS= array in /etc/rc.conf are started by running the
corresponding scripts in /etc/rc.d.

It is also possible to control the services from the command line (as
root), e.g.,

    /etc/rc.d/cupsd start

would start the CUPS daemon. Typical arguments for the scripts are
start, stop, and restart.

/etc/rc.local
-------------

This script is run at the end of every boot. It is intended for
miscellaneous commands that you might want to execute before the login
prompt. It is not recommended to add any services or settings in
/etc/rc.local that could be started or set from /etc/rc.conf instead.

extra/[extra]
-------------

Arch's official package set is fairly streamlined, but we supplement
this with a larger, more complete "extra" repository that contains a lot
of the stuff that never made it into our core package set. This
repository is constantly growing with the help of packages submitted
from our strong community. This is where desktop environments, window
managers and common programs are found.

hwd
---

Hwd; hardware detect for Arch Linux, is for both devfs and udev device
systems and also for kernels 2.4.x and 2.6.x. Instead of running an auto
configure script which may be expected, Hwd (/usr/bin/hwd) does not
change existing configurations. It detects hardware and modules, and
provides information on how to make changes manually. This allows the
user to have control over his or her system; the basic philosophy of
Arch Linux.

hwd is available in the AUR.

hwdetect
--------

hwdetect is a hardware detection script primarily used to load or list
modules for use in /etc/rc.conf or /etc/mkinitcpio.conf. The script
makes use of information exported by the sysfs subsystem employed by the
Linux kernel.

initramfs
---------

See mkinitcpio.

initrd
------

The special file /dev/initrd is a read-only block device. Device
/dev/initrd is a RAM disk that is initialized (e.g. loaded) by the boot
loader before the kernel is started. The kernel then can use the block
device /dev/initrd's contents for a two phased system boot-up.

In the first boot-up phase, the kernel starts up and mounts an initial
root file-system from the contents of /dev/initrd (e.g. RAM disk
initialized by the boot loader). In the second phase, additional drivers
or other modules are loaded from the initial root device's contents.
After loading the additional modules, a new root file system (i.e. the
normal root file system) is mounted from a different device.

makepkg
-------

makepkg will build packages for you. makepkg will read the metadata
required from a PKGBUILD file. All it needs is a build-capable Linux
platform, wget, and some build scripts. The advantage to a script-based
build is that you only really do the work once. Once you have the build
script for a package, you just need to run makepkg and it will do the
rest: download and validate source files, check dependencies, configure
the build time settings, build the package, install the package into a
temporary root, make customizations, generate meta-info, and package the
whole thing up for pacman to use.

namcap
------

namcap is a package analysis utility that looks for problems with Arch
Linux packages or their PKGBUILD files. It can apply rules to the file
list, the files themselves, or individual PKGBUILD files.

Rules return lists of messages. Each message can be one of three types:
error, warning, or information (think of them as notes or comments).
Errors (designated by 'E:') are things that namcap is very sure are
wrong and need to be fixed. Warnings (designated by 'W:') are things
that namcap thinks should be changed but if you know what you are doing
then you can leave them. Information (designated 'I:') are only shown
when you use the info argument. Information messages give information
that might be helpful but is not anything that needs changing.

package
-------

A package is an archive containing

-   all of the (compiled) files of an application
-   metadata about the application, such as application name, version,
    dependencies, ...
-   installation files and directives for pacman
-   (optionally) extra files to make your life easier, such as a
    start/stop script

Arch's package manager pacman can install, update and remove programs
cleanly those packages. Using packages instead of compiling and
installing programs yourself has various benefits:

-   easily updatable: pacman will update existing packages as soon as
    updates are available
-   dependency checks: pacman handles dependencies for you, you only
    need to specify the program and pacman installs it together with
    every other program it needs
-   clean removal: pacman has a list of every file in a package. This
    way, no files are left behind when you decide to remove a package.

Note:Different GNU/Linux distributions use different packages and
package managers, meaning that you cannot use pacman to install a Debian
package on Arch.

pacman
------

The pacman package manager is one of the great highlights of Arch Linux.
It combines a simple binary package format with an easy-to-use build
system (see ABS). Pacman makes it possible to easily manage and
customize packages, whether they be from the official Arch repositories
or the user's own creations. The repository system allows users to build
and maintain their own custom package repositories, which encourages
community growth and contribution (see AUR).

Pacman can keep a system up to date by synchronizing package lists with
the master server, making it a breeze for the security-conscious system
administrator to maintain. This server/client model also allows you to
download/install packages with a simple command, complete with all
required dependencies (similar to Debian's apt-get).

NB: Pacman was written by Judd Vinet, the creator of Arch Linux. It is
used as a package management tool by other distributions as well, such
as FrugalWare, Rubix, UfficioZero (in Italian, based on Ubuntu), and, of
course, Arch based distributions such as Archie and AEGIS.

pacman.conf
-----------

This is the configuration file of pacman. It is located in /etc. For a
full explanation of its powers, type this at the command line:

    man pacman.conf

release/[release]
-----------------

The [release] repository follows the semi-regular snapshot releases and
does not update until the next snapshot/ISO has been released. For
example, the [release] repository will point to all packages on the 0.5
ISO until we release 0.6; then it will point to 0.6 packages until 0.7
is released. This is useful if you only want to update your system when
a new release is available.

repository/repo
---------------

The repository has the pre-compiled packages of one or (usually) more
PKGBUILDs. Official repositories are

-   [core]: containing the latest version of packages required for a
    full CLI system
-   [extra]: containing the latest version of packages not needed for a
    working system but are needed for an enjoyable system ;)
-   [community]: containing packages that came from AUR and got enough
    user votes

Pacman uses these repositories to search for packages and install them.
A repository can be local (i.e. on your own computer) or remote (i.e.
the packages are downloaded before they are installed).

RTFM
----

"Read The Fucking (or Fine) Manual". This simple message is replied to a
lot of new Linux/Arch users who ask about the functionality of a program
when it is clearly defined in the program's manual.

It is often used when a user fails to make any attempt to find a
solution to the problem themselves. If someone tells you this, they are
not trying to offend you; they are just frustrated with your lack of
effort.

The best thing to do if you are told to do this is to read the manual
page.

-   To read the program manual page for a particular program, type this
    at the command line:

    man PROGRAM-NAME

where PROGRAM-NAME is the name of the program you need more information
about.

If you do not find the answer to your question in the program manual,
there are more ways to find the answer. You can:

-   search the wiki
-   search the forum
-   search the mailing lists
-   search the web

taurball
--------

The tarballed PKGBUILD and local source files that are required by
makepkg to create an installable binary package. The name is derived
from the practice of uploading such tarballs to the AUR, whence
"tAURball".

testing/[testing]
-----------------

This is the repository where major packages/updates to packages are kept
prior to release into the main repositories, so they can be bug tested
and upgrade issues can be found. It is disabled by default but can be
enabled in /etc/pacman.conf

udev
----

udev provides a dynamic device directory containing only the files for
actually present devices. It creates or removes device node files in the
/dev directory, or it renames network interfaces.

Usually udev runs as udevd(8) and receives uevents directly from the
kernel if a device is added/removed to/from the system.

If udev receives a device event, it matches its configured rules against
the available device attributes provided in sysfs to identify the
device. Rules that match may provide additional device information or
specify a device node name and multiple symlink names and instruct udev
to run additional programs as part of the device event handling.

wiki
----

This! A place to find documentation about Arch Linux. Anyone can add and
modify the documentation.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_Terminology&oldid=241341"

Category:

-   About Arch
