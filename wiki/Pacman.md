pacman
======

Summary

Pacman is the Arch Linux package manager. Package managers are used to
install, upgrade, and remove software. This article covers basic usage
and troubleshooting tips.

Overview

Packages in Arch Linux are built using makepkg and a custom build script
for each package (known as a PKGBUILD). Once packaged, software can be
installed and managed with pacman. PKGBUILDs for software in the
official repositories are available from the ABS tree; thousands more
are available from the (unsupported) Arch User Repository.

Related

Downgrading Packages

Improve Pacman Performance

Pacman GUI Frontends

Pacman Rosetta

Pacman Tips

Pacman package signing

FAQ#Package Management

pacman-key

Pacnew and Pacsave Files

Resources

libalpm(3) Manual Page

pacman(8) Manual Page

pacman.conf(5) Manual Page

repo-add(8) Manual Page

The pacman package manager is one of the major distinguishing features
of Arch Linux. It combines a simple binary package format with an
easy-to-use build system. The goal of pacman is to make it possible to
easily manage packages, whether they are from the official Arch
repositories or the user's own builds.

Pacman keeps the system up to date by synchronizing package lists with
the master server. This server/client model also allows the user to
download/install packages with a simple command, complete with all
required dependencies.

Pacman is written in the C programming language and uses the .pkg.tar.xz
package format.

Tip:The official pacman package also contains other useful tools, such
as makepkg, pactree, vercmp and more: run pacman -Ql pacman | grep bin
to see the full list.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Configuration                                                      |
|     -   1.1 General options                                              |
|         -   1.1.1 Skip package from being upgraded                       |
|         -   1.1.2 Skip package group from being upgraded                 |
|         -   1.1.3 Skip files from being installed to system              |
|                                                                          |
|     -   1.2 Repositories                                                 |
|     -   1.3 Package security                                             |
|                                                                          |
| -   2 Usage                                                              |
|     -   2.1 Installing packages                                          |
|         -   2.1.1 Installing specific packages                           |
|         -   2.1.2 Installing package groups                              |
|                                                                          |
|     -   2.2 Removing packages                                            |
|     -   2.3 Upgrading packages                                           |
|     -   2.4 Querying package databases                                   |
|     -   2.5 Additional commands                                          |
|     -   2.6 Partial upgrades are unsupported                             |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 Q: An update to package XYZ broke my system!                 |
|     -   3.2 Q: I know an update to package ABC was released, but pacman  |
|         says my system is up to date!                                    |
|     -   3.3 Q: I get an error when updating: "file exists in             |
|         filesystem"!                                                     |
|     -   3.4 Q: I get an error when installing a package: "not found in   |
|         sync db"                                                         |
|     -   3.5 Q: Pacman is repeatedly upgrading the same package!          |
|     -   3.6 Q: Pacman crashes during an upgrade!                         |
|     -   3.7 Q: I installed software using "make install"; these files do |
|         not belong to any package!                                       |
|     -   3.8 Q: I need a package with a specific file. How do I know what |
|         provides it?                                                     |
|     -   3.9 Q: Pacman is completely broken! How do I reinstall it?       |
|     -   3.10 Q: After updating my system, I get a "unable to find root   |
|         device" error after rebooting and my system will no longer boot  |
|     -   3.11 Q: Signature from "User <email@gmail.com>" is unknown       |
|         trust, installation failed                                       |
|     -   3.12 Q: I keep getting a "failed to commit transaction (invalid  |
|         or corrupted package)" error                                     |
|     -   3.13 Q: I get an error every time I use pacman saying 'warning:  |
|         current locale is invalid; using default "C" locale'. What do I  |
|         do?                                                              |
|     -   3.14 Q: How can I get Pacman to honor my proxy settings?         |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Configuration
-------------

Pacman's settings are located in /etc/pacman.conf. This is the place
where the user configures the program to work in the desired manner.
In-depth information about the configuration file can be found in man
pacman.conf.

> General options

General options are in the [options] section. Read the man page or look
in the default pacman.conf for information on what can be done here.

Skip package from being upgraded

To skip upgrading a specific package, specify it as such:

    IgnorePkg=linux

For multiple packages use a space-separated list, or use additional
IgnorePkg lines.

Skip package group from being upgraded

As with packages, skipping a whole package group is also possible:

    IgnoreGroup=gnome

Skip files from being installed to system

To always skip installation of specific directories list them under
NoExtract. For example, to avoid installation of systemd units use this:

    NoExtract=usr/lib/systemd/system/*

> Repositories

This section defines which repositories to use, as referred to in
/etc/pacman.conf. They can be stated here directly or included from
another file (such as /etc/pacman.d/mirrorlist), thus making it
necessary to maintain only one list. See here for mirror configuration.

    /etc/pacman.conf

    #[testing]
    #SigLevel = PackageRequired
    #Include = /etc/pacman.d/mirrorlist

    [core]
    SigLevel = PackageRequired
    Include = /etc/pacman.d/mirrorlist

    [extra]
    SigLevel = PackageRequired
    Include = /etc/pacman.d/mirrorlist

    #[community-testing]
    #SigLevel = PackageRequired
    #Include = /etc/pacman.d/mirrorlist

    [community]
    SigLevel = PackageRequired
    Include = /etc/pacman.d/mirrorlist

    # If you want to run 32 bit applications on your x86_64 system,
    # enable the multilib repositories as required here.

    #[multilib-testing]
    #SigLevel = PackageRequired
    #Include = /etc/pacman.d/mirrorlist

    #[multilib]
    #SigLevel = PackageRequired
    #Include = /etc/pacman.d/mirrorlist

    # An example of a custom package repository.  See the pacman manpage for
    # tips on creating your own repositories.
    #[custom]
    #SigLevel = Optional TrustAll
    #Server = file:///home/custompkgs

Warning:Care should be taken when using the [testing] repository. It is
in active development and updating may cause some packages to stop
working. People who use the [testing] repository are encouraged to
subscribe to the arch-dev-public mailing list for current information.

> Package security

Pacman 4 supports package signatures, which add an extra layer of
security to the packages. The default configuration,
SigLevel = Required DatabaseOptional, enables signature verification for
all the packages on a global level: this can be overridden by
per-repository SigLevel lines as shown above. For more details on
package signing and signature verification, take a look at pacman-key.

Usage
-----

What follows is just a small sample of the operations that pacman can
perform. To read more examples, refer to man pacman. For an
introduction, see pacman - An Introduction.

> Installing packages

Installing specific packages

To install a single package or list of packages (including
dependencies), issue the following command:

    # pacman -S package_name1 package_name2 ...

Sometimes there are multiple versions of a package in different
repositories, e.g. [extra] and [testing]. To install the former version,
the repository needs to be defined in front:

    # pacman -S extra/package_name

Installing package groups

Some packages belong to a group of packages that can all be installed
simultaneously. For example, issuing the command:

    # pacman -S gnome

will prompt you to select the packages from the gnome group that you
wish to install.

Sometimes a package group will contain a large amount of packages, and
there may be only a few that you do or do not want to install. Instead
of having to enter all the numbers except the ones you do not want, it
is sometimes more convenient to select or exclude packages or ranges of
packages with the following syntax:

    Enter a selection (default=all): 1-10 15

which will select packages 1 through 10 and 15 for installation, or:

    Enter a selection (default=all): ^5-8 ^2

which will select all packages except 5 through 8 and 2 for
installation.

To see what packages belong to the gnome group, run:

    # pacman -Sg gnome

Also visit https://www.archlinux.org/groups/ to see what package groups
are available.

Note:If a package in the list is already installed on the system, it
will be reinstalled even if it is already up to date. This behavior can
be overridden with the --needed option.

Warning:When installing packages, do not refresh the package list
without upgrading the system (i.e. pacman -Sy package_name); this can
lead to dependency issues. See #Partial upgrades are unsupported and
https://bbs.archlinux.org/viewtopic.php?id=89328.

> Removing packages

To remove a single package, leaving all of its dependencies installed:

    # pacman -R package_name

To remove a package and its dependencies which are not required by any
other installed package:

    # pacman -Rs package_name

To remove a package, its dependencies and all the packages that depend
on the target package:

Warning:This operation is recursive, and must be used with care since it
can remove many potentially needed packages.

    # pacman -Rsc package_name

To remove a package, which is required by another package, without
removing the dependent package:

    # pacman -Rdd package_name

Pacman saves important configuration files when removing certain
applications and names them with the extension: .pacsave. To prevent the
creation of these backup files use the -n option:

    # pacman -Rn package_name

Note:Pacman will not remove configurations that the application itself
creates (for example "dotfiles" in the home folder).

> Upgrading packages

Pacman can update all packages on the system with just one command. This
could take quite a while depending on how up-to-date the system is. This
command can synchronize the repository databases and update the system's
packages (excluding 'local' packages that are not in the configured
repositories):

    # pacman -Syu

Warning:Instead of immediately updating as soon as updates are
available, users must recognize that due to the nature of Arch's rolling
release approach, an update may have unforeseen consequences. This means
that it is not wise to update if, for example, one is about to deliver
an important presentation. Rather, update during free time and be
prepared to deal with any problems that may arise.

Pacman is a powerful package management tool, but it does not attempt to
handle all corner cases. Read The Arch Way if this causes confusion.
Users must be vigilant and take responsibility for maintaining their own
system. When performing a system update, it is essential that users read
all information output by pacman and use common sense. If a
user-modified configuration file needs to be upgraded for a new version
of a package, a .pacnew file will be created to avoid overwriting
settings modified by the user. Pacman will prompt the user to merge
them. These files require manual intervention from the user and it is
good practice to handle them right after every package upgrade or
removal. See Pacnew and Pacsave Files for more info.

Tip:Remember that pacman's output is logged in /var/log/pacman.log.

Before upgrading, it is advisable to visit the Arch Linux home page to
check the latest news (or subscribe to the RSS feed): when updates
require out-of-the-ordinary user intervention (more than what can be
handled simply by following the instructions given by pacman), an
appropriate news post will be made.

If one encounters problems that cannot be solved by these instructions,
make sure to search the forum. It is likely that others have encountered
the same problem and have posted instructions for solving it.

> Querying package databases

Pacman queries the local package database with the -Q flag; see:

    $ pacman -Q --help

and queries the sync databases with the -S flag; see:

    $ pacman -S --help

Pacman can search for packages in the database, searching both in
packages' names and descriptions:

    $ pacman -Ss string1 string2 ...

To search for already installed packages:

    $ pacman -Qs string1 string2 ...

To display extensive information about a given package:

    $ pacman -Si package_name

For locally installed packages:

    $ pacman -Qi package_name

Passing two -i flags will also display the list of backup files and
their modification states:

    $ pacman -Qii package_name

To retrieve a list of the files installed by a package:

    $ pacman -Ql package_name

For packages not installed, use pkgfile.

One can also query the database to know which package a file in the file
system belongs to:

    $ pacman -Qo /path/to/file_name

To list all packages no longer required as dependencies (orphans):

    $ pacman -Qdt

To list a dependency tree of a package:

    $ pactree package_name

To list all the packages depending on an installed package, use whoneeds
from pkgtools:

    $ whoneeds package_name

> Additional commands

Upgrade the system and install a list of packages (one-liner):

    # pacman -Syu package_name1 package_name2 ...

Download a package without installing it:

    # pacman -Sw package_name

Install a 'local' package that is not from a remote repository (e.g. the
package is from the AUR):

    # pacman -U /path/to/package/package_name-version.pkg.tar.xz

Tip:To keep a copy of the local package in pacman's cache, use:

    # pacman -U file://path/to/package/package_name-version.pkg.tar.xz

Install a 'remote' package (not from a repository stated in pacman's
configuration files):

    # pacman -U http://www.example.com/repo/example.pkg.tar.xz

Clean the package cache of packages that are not currently installed
(/var/cache/pacman/pkg):

Warning:Only do this if certain that the installed packages are stable
and that a downgrade will not be necessary, since it will remove all of
the old versions from the cache folder, leaving behind only the versions
of the packages that are currently installed. Having older versions of
packages comes in handy in case a future upgrade causes breakage.

    # pacman -Sc

Clean the entire package cache:

Warning:This clears out the entire package cache. Doing this is
considered a bad practice; it prevents the ability to downgrade
something directly from the cache folder. Users will be forced to have
to use an alternative source of deprecated packages such as the Arch
Rollback Machine.

    # pacman -Scc

Tip:As an alternative to both the -Sc and -Scc switches, consider using
paccache from pacman. This offers more control over what and how many
packages are deleted. Run paccache -h for instructions.

> Partial upgrades are unsupported

Arch Linux is a rolling release, and new library versions will be pushed
to the repositories. The developers and Trusted Users will rebuild all
the packages in the repositories that need to be rebuilt against the
libraries. If the system has locally installed packages (such as AUR
packages), users will need to rebuild them when their dependencies
receive a soname bump.

This means that partial upgrades are not supported. Do not use
pacman -Sy package or any equivalent such as pacman -Sy and then
pacman -S package. Always upgrade before installing a package --
particularly if pacman has refreshed the sync repositories. Be very
careful when using IgnorePkg and IgnoreGroup for the same reason.

If a partial upgrade scenario has been created, and binaries are broken
because they cannot find the libraries they are linked against, do not
"fix" the problem simply by symlinking. Libraries receive soname bumps
when they are not backwards compatible. A simple pacman -Syu to a
properly synced mirror will fix the problem as long as pacman is not
broken.

Troubleshooting
---------------

Q: An update to package XYZ broke my system!

A: Arch Linux is a rolling-release cutting-edge distribution. Package
updates are available as soon as they are deemed stable enough for
general use. However, updates sometimes require user intervention:
configuration files may need to be updated, optional dependencies may
change, etc.

The most important tip to remember is to not "blindly" update Arch
systems. Always read the list of packages to be updated. Note whether
"critical" packages are going to be updated (linux, xorg-server, and so
on). If so, it is usually a good idea to check for any news at
https://www.archlinux.org/ and scan recent forum posts to see if people
are experiencing problems as a result of an update.

If a package update is expected/known to cause problems, packagers will
ensure that pacman displays an appropriate message when the package is
updated. If experiencing trouble after an update, double-check pacman's
output by looking at the log (/var/log/pacman.log).

At this point, only after ensuring there is no information available
through pacman, there is no relative news on https://www.archlinux.org/,
and there are no forum posts regarding the update, consider seeking help
on the forum, over IRC, or downgrading the offending package.

Q: I know an update to package ABC was released, but pacman says my system is up to date!

A: Pacman mirrors are not synced immediately. It may take over 24 hours
before an update is available to you. The only options are be patient or
use another mirror. MirrorStatus can help you identify an up-to-date
mirror.

Q: I get an error when updating: "file exists in filesystem"!

A: ASIDE: Taken from https://bbs.archlinux.org/viewtopic.php?id=56373 by
Misfit138.

    error: could not prepare transaction
    error: failed to commit transaction (conflicting files)
    package: /path/to/file exists in filesystem
    Errors occurred, no packages were upgraded.

Why this is happening: pacman has detected a file conflict, and by
design, will not overwrite files for you. This is a design feature, not
a flaw.

The problem is usually trivial to solve. A safe way is to first check if
another package owns the file (pacman -Qo /path/to/file). If the file is
owned by another package, file a bug report. If the file is not owned by
another package, rename the file which 'exists in filesystem' and
re-issue the update command. If all goes well, the file may then be
removed.

If you had installed a program manually without using pacman or a
frontend, you have to remove it and all its files and reinstall properly
using pacman.

Every installed package provides
/var/lib/pacman/local/$package-$version/files file that contains
metadata about this package. If this file gets corrupted - is empty or
missing - it results in "file exists in filesystem" errors when trying
to update the package. Such an error usually concerns only one package
and instead of manually renaming and later removing all the files that
belong to the package in question, you can run
pacman -S --force $package to force pacman to overwrite these files.

Do not run pacman -Syu --force.

Q: I get an error when installing a package: "not found in sync db"

A: Firstly, ensure the package actually exists (and watch out for
typos!). If certain the package exists, your package list may be
out-of-date or your repositories may be incorrectly configured. Try
running pacman -Syy to force a refresh of all package lists.

Q: Pacman is repeatedly upgrading the same package!

A: This is due to duplicate entries in /var/lib/pacman/local/, such as
two linux instances. pacman -Qi outputs the correct version, but
pacman -Qu recognizes the old version and therefore will attempt to
upgrade.

Solution: delete the offending entry in /var/lib/pacman/local/.

Note:Pacman version 3.4 should display an error in case of duplicate
entries, which should make this note obsolete.

Q: Pacman crashes during an upgrade!

A: In the case that pacman crashes with a "database write" error whilst
removing packages, and reinstalling or upgrading packages fails:

1.  Boot using the Arch install media.
2.  Mount your root filesystem.
3.  Update the pacman database via pacman -Syy.
4.  Reinstall the broken package via pacman -r /path/to/root -S package.

Q: I installed software using "make install"; these files do not belong to any package!

A: If receiving a "conflicting files" error, note that pacman will
overwrite manually-installed software if supplied with the --force
switch (pacman -S --force). See Pacman Tips#Identify files not owned by
any package for a script that searches the file system for disowned
files.

Warning:Take care when using the --force switch because it can cause
major problems if used improperly.

Q: I need a package with a specific file. How do I know what provides it?

A: Install pkgfile which uses a separate database with all files and
their associated packages.

Q: Pacman is completely broken! How do I reinstall it?

A: In the case that pacman is broken beyond repair, manually download
the necessary packages (openssl, libarchive, and pacman) and extract
them to root. The pacman binary will be restored along with its default
configuration file. Afterwards, reinstall these packages with pacman to
maintain package database integrity. Additional information and an
example (outdated) script that automates the process is available in
this forum post.

Q: After updating my system, I get a "unable to find root device" error after rebooting and my system will no longer boot

A: Most likely your initramfs got broken during a kernel update
(improper use of pacman's --force option can be a cause). You have two
options:

1. Try the Fallback entry.

Tip:In case you removed this entry for whatever reason, you can always
press the Tab key when the bootloader menu shows up (for Syslinux) or e
(for GRUB), rename it initramfs-linux-fallback.img and press Enter or b
(depending on your bootloader) to boot with the new parameters.

Once the system starts, run this command (for the stock linux kernel)
either from the console or from a terminal to rebuild the initramfs
image:

    # mkinitcpio -p linux

2. If that does not work, from a 2012 Arch release (CD/DVD or USB
stick), run:

Note:If you do not have a 2012 release or if you only have some other
"live" Linux distribution laying around, you can chroot using the old
fashion way. Obviously, there will be more typing than simply running
the arch-chroot script.

    # mount /dev/sdxY /mnt         #Your root partition.
    # mount /dev/sdxZ /mnt/boot    #If you use a separate /boot partition.
    # arch-chroot /mnt
    # pacman -Syu mkinitcpio systemd linux

Reinstalling the kernel (the linux package) will automatically
re-generate the initramfs image with mkinitcpio -p linux. There is no
need to do this separately.

Afterwards, it is recommended that you run exit, umount /mnt/{boot,} 
and reboot.

Note:If you cannot enter the arch-chroot or chroot environment but need
to re-install packages you can use the command
pacman -r /mnt -Syu foo bar to use pacman on your root partition.

Q: Signature from "User <email@gmail.com>" is unknown trust, installation failed

A: Follow pacman-key#Resetting all the keys. Or you can try to manually
upgrade archlinux-keyring package first, i.e.
pacman -S archlinux-keyring.

Q: I keep getting

error: PackageName: signature from "User <email@archlinux.org>" is
invalid

error: failed to commit transaction (invalid or corrupted package (PGP
signature))

Errors occured, no packages were upgraded.

A: It happens when the system clock is wrong. Set the time and run:

    # hwclock -w

before to try to install/upgrade a package again.

Q: I keep getting a "failed to commit transaction (invalid or corrupted package)" error

A: Look for *.part files (partially downloaded packages) in
/var/cache/pacman/pkg and remove them (often caused by usage of custom
XferCommand in pacman.conf).

Q: I get an error every time I use pacman saying 'warning: current locale is invalid; using default "C" locale'. What do I do?

A: As the error message says, your locale is not correctly configured.
See Locale.

Q: How can I get Pacman to honor my proxy settings?

A: Make sure that the relevant environment variables ($http_proxy,
$ftp_proxy etc.) are set up. If you use Pacman with sudo, you need to
configure sudo to pass these environment variables to Pacman.

See also
--------

-   Common Applications/Utilities#Package management

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pacman&oldid=256031"

Category:

-   Package management
