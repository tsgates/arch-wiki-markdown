Arch filesystem hierarchy
=========================

Arch Linux is among the many distributions that follow the filesystem
hierarchy standard. In addition to explaining each directory along with
their designations, this article also covers Arch-specific
modifications.

Contents
--------

-   1 Filesystem Hierarchy Standard
    -   1.1 Shareable and Unshareable files
-   2 Directories
    -   2.1 The root filesystem
    -   2.2 /bin: Essential command binaries (deprecated)
    -   2.3 /boot: Static bootloader files
    -   2.4 /dev: Device files
    -   2.5 /etc: Host-specific configuration
        -   2.5.1 /etc/X11
            -   2.5.1.1 /etc/X11/xinit
            -   2.5.1.2 /etc/X11/xinit/xinitrc
    -   2.6 /home: User directories
    -   2.7 /lost+found: Filesystem-specific recoverable data
    -   2.8 /mnt: Temporary mount points
    -   2.9 /opt: Problematic packages
    -   2.10 /proc: Process information
    -   2.11 /root: Administrator directory
    -   2.12 /run: Ephemeral runtime data
    -   2.13 /sbin: System binaries (deprecated)
    -   2.14 /srv: Service data
    -   2.15 /tmp: Temporary files
    -   2.16 /usr: Shareable, read-only data
        -   2.16.1 /usr/bin: Binaries
        -   2.16.2 /usr/include: Header files
        -   2.16.3 /usr/lib: Libraries
        -   2.16.4 /usr/sbin: System binaries (deprecated)
        -   2.16.5 /usr/share: Architecture independent data
        -   2.16.6 /usr/src: Source code
        -   2.16.7 /usr/local: Local hierarchy
    -   2.17 /var: Variable files
        -   2.17.1 /var/abs
        -   2.17.2 /var/cache/pacman/pkg
        -   2.17.3 /var/lib: State information
        -   2.17.4 /var/log: Log files
        -   2.17.5 /var/mail: User mail
        -   2.17.6 /var/spool: Queues
            -   2.17.6.1 /var/spool/mail
        -   2.17.7 /var/tmp: Preservable temporary files
-   3 See also

Filesystem Hierarchy Standard
-----------------------------

From the home of the Filesystem Hierarchy Standard (FHS):

"The filesystem standard has been designed to be used by Unix
distribution developers, package developers, and system implementors.
However, it is primarily intended to be a reference and is not a
tutorial on how to manage a Unix filesystem or directory hierarchy."

> Shareable and Unshareable files

Shareable files are defined as those that can be stored on one host and
used on others. Unshareable files are those that are not shareable. For
example, the files in user home directories are shareable whereas device
lock files are not.

Static files include binaries, libraries, documentation files and other
files that do not change without system administrator intervention.
Variable files are defined as files that are not static.

Directories
-----------

> The root filesystem

The root filesystem, represented by the slash symbol by itself (/), is
the primary filesystem from which all other filesystems stem; the top of
the hierarchy. All files and directories appear under the root directory
"/", even if they are stored on different physical devices. The contents
of the root filesystem must be adequate to boot, restore, recover,
and/or repair the system.

> /bin: Essential command binaries (deprecated)

Traditionally the place for binaries that must be available in single
user mode and accessible by all users (e.g., cat, ls, cp). /bin/
provides programs that must be available even if only the partition
containing / is mounted. In practice, this is not the case on Arch as
all the necessary libraries are in /usr/lib. As of June 2013, /bin was
merged into /usr/bin. The filesystem package provides symlinks from /bin
to /usr/bin, and all packages should be updated to explicitly install to
/usr/bin.

> /boot: Static bootloader files

Unsharable, static directory containing the kernel and ramdisk images as
well as the bootloader configuration file, and bootloader stages. /boot
also stores data that is used before the kernel begins executing
userspace programs. This may include saved master boot sectors and
sector map files.

> /dev: Device files

Essential device nodes created by udev during the boot process and as
machine hardware is discovered by events. This directory highlights one
important aspect of the UNIX filesystem - everything is a file or a
directory. Exploring this directory will reveal many files, each
representing a hardware component of the system. The majority of devices
are either block or character devices; however other types of devices
exist and can be created. In general, 'block devices' are devices that
store or hold data, whereas 'character devices' can be thought of as
devices that transmit or transfer data. For example, hard disk drives
and optical drives are categorized as block devices while serial ports,
mice and USB ports are all character devices.

> /etc: Host-specific configuration

Host-specific, unsharable configuration files shall be placed in the
/etc directory. If more than one configuration file is required for an
application, it is customary to use a subdirectory in order to keep the
/etc/ area as clean as possible. It is considered good practice to make
frequent backups of this directory as it contains all system related
configuration files.

/etc/X11

Configuration files for the X Window System

/etc/X11/xinit

xinit configuration files. 'xinit' is a configuration method of starting
up an X session that is designed to be used as part of a script.

/etc/X11/xinit/xinitrc

Global xinitrc file, used by all X sessions started by xinit (startx).
Its usage is of course overridden by a .xinitrc file located in the home
directory of a user.

> /home: User directories

UNIX is a multi-user environment. Therefore, each user is also assigned
a specific directory that is accessible only to them and to the root
user. These are the user home directories, which can be found under
'/home/$USER' (~/). Within their home directory, a user can write files,
delete them, install programs, etc. Users' home directories contain
their data and personal configuration files, the so-called 'dot files'
(their name is preceded by a dot), which are 'hidden'. To view dotfiles,
enable the appropriate option in your file manager or run ls with the -a
switch. If there is a conflict between personal and system wide
configuration files, the settings in the personal file will prevail.
Dotfiles most likely to be altered by the end user include .xinitrc and
.bashrc files. The configuration files for xinit and Bash respectively.
They allow the user the ability to change the window manager to be
started upon login and also aliases, user-specified commands and
environment variables respectively. When a user is created, their
dotfiles shall be taken from the /etc/skel directory where system sample
files reside.

Directory /home can become quite large as it is typically used for
storing downloads, compiling, installing and running programs, mail,
collections of multimedia files etc.

> /lost+found: Filesystem-specific recoverable data

UNIX-like operating systems must execute a proper shutdown sequence. At
times, a system might crash or a power failure might take the machine
down. Either way, at the next boot, a filesystem check using the fsck
program shall be performed. Fsck will go through the system and try to
recover any corrupt files that it finds. The result of this recovery
operation will be placed in this directory. The files recovered are not
likely to be complete or make much sense but there always is a chance
that something worthwhile is recovered.

> /mnt: Temporary mount points

This is a generic mount point for temporary filesystems or devices.
Mounting is the process of making a filesystem available to the system.
After mounting, files will be accessible under the mount-point.
Additional mount-points (subdirectories) may be created under /mnt/.
There is no limitation to creating a mount-point anywhere on the system,
but by convention and for practicality, littering a file system with
mount-points should be avoided.

> /opt: Problematic packages

Packages and large static files that do not fit cleanly into the above
GNU filesystem layout can be placed in /opt. FHS 2.3 denotes /ops as
reserved for the installation of add-on application software packages. A
package placing files in the /opt/ directory creates a directory bearing
the same name as the package. This directory in turn holds files that
otherwise would be scattered throughout the file system. For example,
the acrobat package has Browser, Reader, and Resource directories
sitting at the same level as the bin directory. This doesn't fit into a
normal GNU filesystem layout, so Arch places all the files in a
subdirectory of /opt.

> /proc: Process information

Directory /proc is very special in that it is also a virtual filesystem.
It is sometimes referred to as the process information pseudo-file
system. It doesn't contain 'real' files, but rather, runtime system
information (e.g. system memory, devices mounted, hardware
configuration, etc). For this reason it can be regarded as a control and
information center for the kernel. In fact, quite a lot of system
utilities are simply calls to files in this directory. For example,
'lsmod' is the same as 'cat /proc/modules' while 'lspci' is a synonym
for 'cat /proc/pci'. By altering files located in this directory, kernel
parameters may be read/changed (sysctl) while the system is running.

The most distinctive facet about files in this directory is the fact
that all of them have a file size of 0, with the exception of kcore,
mounts and self.

> /root: Administrator directory

Home directory of the System Administrator, 'root'. This may be somewhat
confusing, ('/root under root') but historically, '/' was root's home
directory (hence the name of the Administrator account). To keep things
tidier, 'root' eventually got his own home directory. Why not in
'/home'? Because '/home' is often located on a different partition or
even on another system and would thus be inaccessible to 'root' when -
for some reason - only '/' is mounted.

> /run: Ephemeral runtime data

The /run mountpoint is supposed to be a tmpfs mounted during early boot,
available and writable to for all tools at any time during bootup.
systemd, udev or mdadm that are required early in the boot process
require this directory, because /var can be implemented as a separate
file system to be mounted at a later stage in the start-up process. It
replaces /var/run/, which becomes a symlink of /run.

> /sbin: System binaries (deprecated)

Traditionally UNIX discriminates between 'normal' executables and those
used for system maintenance and/or administrative tasks. The latter were
supposed to reside either here or - the less important ones - in
/usr/sbin. Programs executed after /usr is known to be mounted (when
there are no problems) are generally placed into /usr/sbin. In practice,
programs in /sbin require /usr to be mounted as all the necessary
libraries are in /usr/lib. As of June 2013, /sbin and /usr/sbin were
merged into /usr/bin. The filesystem package provides symlinks from
/sbin and /usr/sbin to /usr/bin, and all packages should be updated to
explicitly install to /usr/bin.

> /srv: Service data

Site-specific data which is served by the system. The main purpose of
specifying this is so that users may find the location of the data files
for a particular service, and so that services which require a single
tree for read-only data, writable data and scripts (such as CGI scripts)
can be reasonably placed. Data of interest to a specific user shall be
placed in that user's home directory.

> /tmp: Temporary files

This directory contains files that are required temporarily. Many
programs use this to create lock files and for temporary storage of
data. Do not remove files from this directory unless you know exactly
what you are doing! Many of these files are important for currently
running programs and deleting them may result in a system crash. On most
systems, old files in this directory are cleared out at boot or at daily
intervals.

> /usr: Shareable, read-only data

While root is the primary filesystem, /usr is the secondary hierarchy,
for user data, containing the majority of (multi-)user utilities and
applications. /usr is shareable, read-only data. This means that /usr
shall be shareable between various hosts and must not be written to,
except by the package manager (installation, update, upgrade). Any
information that is host-specific or varies with time is stored
elsewhere.

Aside from /home/, /usr/ usually contains by far the largest share of
data on a system. Hence, this is one of the most important directories
in the system as it contains all the user binaries, their documentation,
libraries, header files, etc. X and its supporting libraries can be
found here. User programs like telnet, ftp, etc., are also placed here.
In the original UNIX implementations, /usr/ (for user), was where the
home directories of the system's users were placed (that is to say,
/usr/someone was then the directory now known as /home/someone). Over
time, /usr/ has become where userspace programs and data (as opposed to
'kernelspace' programs and data) reside. The name has not changed, but
its meaning has narrowed and lengthened from everything user related to
user usable programs and data. As such, the backronym 'User System
Resources' was created.

/usr/bin: Binaries

Command binaries. This directory contains the vast majority of binaries
(applications) on your system. Executables in this directory vary
widely. For instance vi, gcc, and gnome-session reside here.
Traditionally, this contained only binaries that did not require root
privileges and that were not necessary in single-user mode. However,
this is no longer enforced and the Arch devs plan to move all binaries
here.

/usr/include: Header files

Header files needed for compiling userspace source code..

/usr/lib: Libraries

Note:The /lib directory becomes a symlink to /usr/lib. Here is the news.
If you encounter error during this update. Please see
DeveloperWiki:usrlib for solution.

Contains application private data (kernel modules, systemd services,
udev rules, etc) and shared library images (the C programming code
library). Libraries are collections of frequently used program routines
and are readily identifiable through their filename extension of *.so.
They are essential for basic system functionality. Kernel modules
(drivers) are in the subdirectory /lib/modules/<kernel-version>.

/usr/sbin: System binaries (deprecated)

Non-essential system binaries of use to the system administrator. As of
June 2013, /usr/sbin was merged into /usr/bin. The filesystem package
provides symlinks from /usr/sbin to /usr/bin, and all packages should be
updated to explicitly install to /usr/bin.

/usr/share: Architecture independent data

This directory contains 'shareable', architecture-independent files
(docs, icons, fonts etc). Note, however, that '/usr/share' is generally
not intended to be shared by different operating systems or by different
releases of the same operating system. Any program or package which
contains or requires data that do not need to be modified should store
these data in '/usr/share/' (or '/usr/local/share/', if manually
installed - see below). It is recommended that a subdirectory be used in
/usr/share for this purpose.

/usr/src: Source code

The 'linux' sub-directory holds the Linux kernel sources, and
header-files.

/usr/local: Local hierarchy

Optional tertiary hierarchy for local data. The original idea behind
'/usr/local' was to have a separate ('local') '/usr/' directory on every
machine besides '/usr/', which might be mounted read-only from somewhere
else. It copies the structure of '/usr/'. These days, '/usr/local/' is
widely regarded as a good place in which to keep self-compiled or
third-party programs. This directory is empty by default in Arch Linux.
It may be used for manually compiled software installations if desired.
pacman installs to /usr/, therefore, manually compiled/installed
software installed to /usr/local/ may peacefully co-exist with
pacman-tracked system software.

> /var: Variable files

Variable files, such as logs, spool files, and temporary e-mail files.
On Arch, the ABS tree and pacman cache also reside here. Why not put the
variable and transient data into /usr/? Because there might be
circumstances when /usr/ is mounted as read-only, e.g. if it is on a CD
or on another computer. '/var/' contains variable data, i.e. files and
directories the system must be able to write to during operation,
whereas /usr/ shall only contain static data. Some directories can be
put onto separate partitions or systems, e.g. for easier backups, due to
network topology or security concerns. Other directories have to be on
the root partition, because they are vital for the boot process.
'Mountable' directories are: '/home', '/mnt', '/tmp', '/usr' and '/var'.
Essential for booting are: '/bin', '/boot', '/dev', '/etc', '/lib',
'/proc' and '/sbin'.

/var/abs

The ABS tree. A ports-like package build system hierarchy containing
build scripts within subdirectories corresponding to all installable
Arch software.

/var/cache/pacman/pkg

The pacman package cache.

/var/lib: State information

Persistent data modified by programs as they run (e.g. databases,
packaging system metadata etc.).

/var/log: Log files

Log files.

/var/mail: User mail

Deprecated location for users' mailboxes.

/var/spool: Queues

Spool for tasks waiting to be processed (e.g. print queues and unread
mail).

/var/spool/mail

Shareable directory for users' mailboxes.

/var/tmp: Preservable temporary files

Temporary files to be preserved between reboots.

See also
--------

-   wikipedia:Filesystem Hierarchy Standard
-   Linux FHS Homepage

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_filesystem_hierarchy&oldid=291042"

Category:

-   File systems

-   This page was last modified on 31 December 2013, at 04:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
