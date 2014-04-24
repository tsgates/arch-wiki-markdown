Enhancing Arch Linux Stability
==============================

The purpose of this wiki article is to provide tips on how to make an
Arch Linux system as stable as possible. While Arch Developers and
Trusted Users work hard to produce high quality packages, given Arch's
rolling release system and rapid package turnover, an Arch system may
not be suitable for a mission critical, commercial production
environment.

However, Arch is inherently stable due to its commitment to simplicity
in configuration, coupled with a rapid bug-report/bug-fix cycle, and the
use of unpatched upstream source code. Thus, by following the advice
below on setting up and maintaining Arch, the user should be able enjoy
a very stable system. Furthermore, advice is included that will ease
system repair in the event of a major malfunction.

How stable can Arch Linux really be? There are numerous reports in the
Arch forums of skilled system administrators successfully using Arch for
production servers. Archlinux.org is one such example. On the desktop, a
properly configured and maintained Arch installation can offer excellent
stability.

Contents
--------

-   1 Setting Up Arch
    -   1.1 Arch Specific Tips
        -   1.1.1 Keeping old packages in a large /var partition
        -   1.1.2 Use recommended configurations
        -   1.1.3 Be careful with unofficial and less tested packages
        -   1.1.4 Use up-to-date mirrors
        -   1.1.5 Avoid development packages
        -   1.1.6 Install the linux-lts package
    -   1.2 Generic Best Practices
        -   1.2.1 Use the package manager to install software
        -   1.2.2 Use proven, mainstream software packages
        -   1.2.3 Choose open-source drivers
-   2 Maintaining Arch
    -   2.1 Arch Specific Tips
        -   2.1.1 Upgrade entire system with reasonable frequency
        -   2.1.2 Read before upgrading the system
        -   2.1.3 Act on alerts during an upgrade
        -   2.1.4 Deal promptly with .pacnew, .pacsave, and .pacorig
            files
        -   2.1.5 Consider using pacmatic
        -   2.1.6 Avoid certain pacman commands
        -   2.1.7 Revert package upgrades that cause instability
        -   2.1.8 Regularly back up a list of installed packages
        -   2.1.9 Regularly back up the pacman database
            -   2.1.9.1 Systemd Automation
    -   2.2 Generic Best Practices
        -   2.2.1 Subscribe to NVD/CVE alerts and only upgrade on a
            security alert
        -   2.2.2 Test updates on a non-critical system
        -   2.2.3 Always back up config files before editing
        -   2.2.4 Regularly back up the /etc, /home, /srv, and /var
            directories

Setting Up Arch
---------------

When first installing and configuring Arch Linux, the user has a variety
of choices to make about configuration, software, and drivers. These
choices will impact overall system stability.

> Arch Specific Tips

Keeping old packages in a large /var partition

Pacman archives all of the previously installed packages in
/var/cache/pacman/pkg, which over time may grow to a few GB in size. If
you are setting up separate partitions during installation, always be
sure to allocate plenty of space for a large /var partition. 4 to 8 GB
should do, although more may be required for some server uses. Retaining
these packages is helpful in case a recent package upgrade causes
instability, requiring a downgrade to an older, archived package. See
the section below entitled, #Revert package upgrades that cause
instability.

Use recommended configurations

In the detailed Arch Linux installation and configuration documentation,
there is often more than one way to configure a specific aspect of the
system. Always choose the recommended, default configuration when
setting up the system. The recommended, default configurations reflect
best practices, chosen for optimum system stability and ease of system
repair.

Be careful with unofficial and less tested packages

Avoid any use of the testing repository, or individual packages from
testing. These experimental packages are for development and testing,
and are not suitable for a stable system.

Use precaution when using packages from AUR. Most of the packages in AUR
are supplied by user and thus might not have the same packaging standard
as those in official repositories. Always check AUR package's PKGBUILD
for any signs of mistake or malicious code before you build and install
them.

Be careful with AUR helpers which highly simplify installation of AUR
packages and could lead to user build and install package that have
malformed or malicious PKGBUILD. You should always sanity check
PKGBUILDs before building and/or installing the package.

Finally, it is extremely unwise to ever run any AUR helpers, or the
makepkg command as root user.

Only use 3rd party repository if absolutely necessary or if you know
what you're doing. Always use 3rd party repository from a trusted
source.

Use up-to-date mirrors

Use mirrors that are frequently updated with the latest packages from
the main Arch FTP server. Review the Mirror Status webpage to verify
that your chosen mirror is up to date. By using recently rsync'd
mirrors, this ensures that your system will always have the freshest
packages and package databases available during the course of routine
maintenance.

Also, if it is used, edit the mirror list in /etc/pacman.d by placing
local mirrors, those within your country or region, at the top of the
list. Refer to the Enabling your favorite mirror Arch wikipage section
for additional details, including the installation of the rankmirrors
script to enable the fastest mirrors. These steps will ensure that the
system uses the fastest, most reliable mirrors.

After changing the server mirror used for updates, ensure that your
system is up-to-date by doing pacman -Syu.

Avoid development packages

To prevent serious breakage of the system, do not install any
development packages, which are usually found in AUR and occasionally in
community. These are packages taken directly from upstream development
branches, and usually feature one of the following words appended to the
package name: dev, devel, svn, cvs, git, hg, bzr, or darcs.

Most especially, avoid installing any development version of crucial
system packages such as the kernel or glibc.

If building a custom package using makepkg, be sure that the PKGBUILD
follows the Arch Packaging Standards, including a provides array. Use
namcap to check the final .tar.gz or PKGBUILD file.

Install the linux-lts package

The linux-lts package is an alternative Arch kernel package based upon
Linux kernel 3.10 and is available in the [core] repository. This
particular kernel version enjoys long-term support (LTS) from upstream,
including security fixes and some feature backports, especially useful
for Arch users seeking to use such a kernel on a server, or who want a
fallback kernel in case a new kernel version causes problems.

To make it available as a boot option, you will need to update the
bootloader's configuration file. For example, if you use Syslinux, you
have to edit /boot/syslinux/syslinux.cfg and duplicate the current
entries, except using vmlinuz-linux-lts and initramfs-linux-lts.img. For
GRUB, the recommended method is to automatically re-generate the .cfg.

Some prefer to install the linux-lts package in addition to the regular
linux package and edit the Fallback entry to use the LTS kernel.

> Generic Best Practices

Use the package manager to install software

Pacman does a much better job than you at keeping track of files. If you
install things manually you will, sooner or later forget what you did,
where you installed to, install conflicting software, install to the
wrong locations, etc.

From a stability standpoint you should try to avoid unsupported package
and custom software, but if you really need such things making a package
is better than manually compiling and installing.

You could also add an alias to disable make install command in
/root/.bashrc:

     make() {
       [ "$1" == 'install' ] &&
         echo -e "WARNING:\nDON'T INSTALL SOFTWARE MANUALLY\nDON'T USE unset make TO OVERRIDE" &&
         echo "Tip: It's easy to make own custom package see: man PKGBUILD makepkg" &&
         return 1;
       /usr/bin/make $@;
     }

Use proven, mainstream software packages

Install mature, proven, mainstream software; while avoiding cutting edge
software that is still buggy. Try to avoid installing "point-oh", aka
x.y.0, software releases. For example, instead of installing Foobar
2.5.0, wait until Foobar 2.5.1 is available. Do not deploy newly
developed software until it is proven to be reliable. For example,
PulseAudio's early versions could be unreliable. Users interested in
maximum stability would use the ALSA sound system instead. Finally, use
software that has a strong and active development community.

Choose open-source drivers

Wherever possible, choose open source drivers. Try to avoid proprietary
drivers. Most of the time, open source drivers are more stable and
reliable than proprietary drivers. Open source driver bugs are fixed
more easily and quickly. While proprietary drivers can offer more
features and capabilities, this can come at the cost of stability. To
avoid this dilemma, choose hardware components known to have mature open
source driver support with full features. Information about hardware
with open source Linux drivers is available at linux-drivers.org.

Maintaining Arch
----------------

In addition to configuring Arch for stability, there are steps one can
take during maintenance which will enhance stability. Paying attention
to a few SysAdmin details will help to ensure continued system
reliability.

> Arch Specific Tips

Upgrade entire system with reasonable frequency

Many Arch users update frequently, even upgrading their systems daily
using pacman -Syu. While updating so frequently is not necessary, one
should upgrade fairly often to enjoy the latest bugfix and security
updates. Weekly or biweekly upgrades are thus a good idea.

If the system has packages from the AUR, carefully upgrade all AUR
packages.

Read before upgrading the system

Before upgrading Arch, always read the latest Arch News to find out if
there are any major software or configuration changes with the latest
packages. Before upgrading fundamental software, such as the kernel,
xorg, or glibc to a new version, look over the appropriate forum to see
if there have been any reported problems.

Act on alerts during an upgrade

When upgrading the system, be sure to pay attention to the alert notices
provided by pacman. If any additional actions are required by the user,
be sure to take care of them right away. If a pacman alert is confusing,
search the forums and the recent news posts for more detailed
instructions.

Deal promptly with .pacnew, .pacsave, and .pacorig files

When pacman removes a package that has a configuration file, it normally
creates a backup copy of that config file and appends .pacsave to the
name of the file. Likewise, when pacman upgrades a package which
includes a new config file created by the maintainer differing from the
currently installed file, it writes a .pacnew config file. Occasionally,
under special circumstances, a .pacorig file is created. Pacman provides
notice when these files are written.

Users must deal with these files promptly when pacman creates them, in
order to ensure optimum system stability. The pacdiff tool, provided by
pacman, can assist with this. Users are referred to the Pacnew and
Pacsave Files wiki page for detailed instructions.

Consider using pacmatic

Pacmatic is a pacman wrapper which automates the process of checking
Arch News prior to upgrading. Pacmatic also ensures that the local
pacman database is correctly synchronized with online mirrors, thus
avoiding potential problems with botched pacman -Sy database updates.
Finally, it provides more stringent warnings about updated or obsolete
config files. pacman can be aliased to pacmatic, and various AUR helpers
can be configured to use it instead of pacman.

Avoid certain pacman commands

Arch being a rolling release distribution, it can be dangerous to
refresh pacman databases without doing a full system upgrade immediately
after. Avoid using pacman -Sy package to install a package, but always
use pacman -S package instead. And upgrade your system regularly with
pacman -Syu.

Avoid using the -f option with pacman, especially in commands such as
pacman -Syuf involving more than one package. The --force option ignores
file conflicts and can even cause file loss when files are relocated
between different packages! In a properly maintained system, it should
never need to be used.

Do not use pacman -Rdd package. Using the -d flag skips dependency
checks during package removal. As a result, a package providing a
critical dependency could be removed, resulting in a broken system.

Never run pacman -Scc unless there is a desperate need for the disk
space, and little or no need for archived package files. It is safer to
keep older packages available in the cache archives in the event a
package upgrade causes problems, requiring a package reversion. Instead,
just use pacman -Sc to clean out the archived packages in the pacman
cache, of packages previously removed from the pacman database.

Make sure to only use this command if there is no intention of
re-installing recently removed packages. If such packages are
re-installed after this command has been executed, there will be no
older, archived versions of the packages in the pacman cache.

In the event that /var disk space becomes scarce, move all archived
packages to the home directory using the fduparch.sh script. Use the
fduppkg script to move all but the last previously installed package
versions in the pacman cache archives, to the home directory.

Revert package upgrades that cause instability

In the event that a particular package upgrade results in system
instability, install the last known stable version of the package from
the local pacman cache using the following command:

    pacman -U /var/cache/pacman/pkg/Package-Name.pkg.tar.gz

For more detailed information on reverting to older packages, consult
the Arch wikipage, Downgrading Packages.

Once the package is reverted, temporarily add it to the IgnorePkg
section of pacman.conf, until the difficulty with the updated package is
resolved. Consult the Arch wiki and/or webforums for advice, and file a
bug report if necessary.

Regularly back up a list of installed packages

At regular intervals, create a list of installed packages and store a
copy on one or more offline media, such as a USB stick, external hard
drive, or CD-R. Use the following command to create a pkglist:

    pacman -Qqne > /path/to/chosen/directory/pkg.list

In the event of a catastrophic system failure requiring a complete
re-installation, these packages can be quickly reinstalled using the
command:

    pacman -S --needed $(< /path/to/chosen/directory/pkg.list )

Regularly back up the pacman database

The following command can be used to back up the local pacman database,
and can be run as a cronjob:

    tar -cjf /path/to/chosen/directory/pacman-database.tar.bz2 /var/lib/pacman/local

Store the backup pacman database file on one or more offline media, such
as a USB stick, external hard drive, or CD-R.

Restore the backup pacman database file by moving the
pacman-database.tar.bz2 file into the / directory and executing the
following command:

    tar -xjvf pacman-database.tar.bz2

If the pacman database files are corrupted, and there is no backup file
available, there exists some hope of rebuilding the pacman database.
Consult the Arch wikipage, How To Restore Pacman's Local Database.

Systemd Automation

You can configure systemd to back up the pacman database everytime a new
package is installed or updated, save and run the following scripts. See
here.

> Generic Best Practices

Subscribe to NVD/CVE alerts and only upgrade on a security alert

Subscribe to the Common Vulnerabilities and Exposure Security Alert
updates, made available by National Vulnerability Database, and found on
the NVD Download webpage. Only update the Arch system when a security
alert is issued for a package installed on that particular system.

This is the alternative to upgrading the entire system frequently. It
ensures that security problems in various packages are resolved
promptly, while keeping all the rest of the packages frozen in a known,
stable configuration. However, reviewing the frequent CVE Alerts to see
if any apply to installed Arch packages can be tedious and time
consuming.

Warning:Partial updates are not supported by Arch Linux, the whole
system should be upgraded when upgrading a component. Infrequent system
updates could potentially complicate the update process.

Test updates on a non-critical system

If possible, test changes to configuration files, as well as updates to
software packages, on a non-critical duplicate system first. Then, if no
problems arise, roll out the changes to the production system.

Always back up config files before editing

Before editing any configuration file, always back up a known working
version of that config file. In the event that changes in the config
file cause problems, one can revert to the previous stable config file.
Do this from a text editor by first saving the file to a backup copy
before making any alterations; or execute the following command:

    cp config config~

Using ~ will ensure there is a readily distinguishable human-made backup
conf file if pacman creates a .pacnew, .pacsave, or .pacorig file using
the active config file.

etckeeper can help dealing with config files. It keeps the whole /etc
directory in a version control.

Regularly back up the /etc, /home, /srv, and /var directories

Since /etc, /home, /srv and /var directories contain important system
files and configs, it is advisable to make backups of these folders at
regular intervals. The following is a simple guide on how to go about
it.

-   /etc: Back up the /etc directory by executing the following command
    as root or as a cronjob:

    tar -cjf /path/to/chosen/directory/etc-backup.tar.bz2 /etc

Store the /etc backup file on one or more offline media, such as a USB
stick, external hard drive, or CD-R. Occasionally verify the integrity
of the backup process by comparing original files and directories with
their backups.

Restore corrupted /etc files by extracting the etc-backup.tar.bz2 file
in a temporary working directory, and copying over individual files and
directories as needed. To restore the entire /etc directory with all its
contents, move the etc-backup.tar.bz2 files into the / directory. As
root, execute the following command:

    tar -xvjf etc-backup.tar.bz2

-   /home: At regular intervals, back up the /home directory to an
    external hard drive, Network Attached Server, or online backup
    service. Occasionally verify the integrity of the backup process by
    comparing original files and directories with their backups.

-   /srv: Server installations should have the /srv directory regularly
    backed up.

-   /var: Additional directories in /var, such a /var/spool/mail or
    /var/lib, which also require backup and occasional verification.

If you want to back up much faster (using parallel compression, SMP),
you should use pbzip2 (Parallel bzip2). The steps are slightly
different, but not by much.

First we will back up the files to a plain tarball with no compression:

    tar -cvf /path/to/chosen/directory/etc-backup.tar /etc

Then we will use pbzip2 to compress it in parallel (Make sure you
install it with pacman -S pbzip2)

    pbzip2 /path/to/chosen/directory/etc-backup.tar.bz2

and that's it. Your files should be backing up using all of your cores.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Enhancing_Arch_Linux_Stability&oldid=301544"

Category:

-   System administration

-   This page was last modified on 24 February 2014, at 11:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
