Maximizing Performance
======================

This article is a retrospective analysis and basic rundown about gaining
performance in Arch Linux.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 The basics                                                         |
|     -   1.1 Know your system                                             |
|     -   1.2 The first thing to do                                        |
|     -   1.3 Compromise                                                   |
|     -   1.4 Benchmarking                                                 |
|                                                                          |
| -   2 Storage devices                                                    |
|     -   2.1 Device Layout                                                |
|         -   2.1.1 Swap Files                                             |
|         -   2.1.2 RAID Benefits                                          |
|         -   2.1.3 Multiple Hardware Paths                                |
|                                                                          |
|     -   2.2 Partitioning                                                 |
|     -   2.3 Choosing and tuning your filesystem                          |
|         -   2.3.1 Summary                                                |
|         -   2.3.2 Mount options                                          |
|         -   2.3.3 Ext3                                                   |
|         -   2.3.4 Ext4                                                   |
|         -   2.3.5 JFS                                                    |
|         -   2.3.6 XFS                                                    |
|         -   2.3.7 Reiserfs                                               |
|         -   2.3.8 Btrfs                                                  |
|                                                                          |
|     -   2.4 Compressing /usr                                             |
|     -   2.5 Tuning for an SSD                                            |
|     -   2.6 RAM disks / tuning for really slow disks                     |
|                                                                          |
| -   3 CPU                                                                |
|     -   3.1 Verynice                                                     |
|     -   3.2 Ulatencyd                                                    |
|                                                                          |
| -   4 Graphics                                                           |
|     -   4.1 Xorg.conf configuration                                      |
|     -   4.2 Driconf                                                      |
|     -   4.3 GPU Overclocking                                             |
|                                                                          |
| -   5 RAM and swap                                                       |
|     -   5.1 Relocate files to tmpfs                                      |
|     -   5.2 Swappiness                                                   |
|     -   5.3 Compcache / Zram                                             |
|     -   5.4 Using the graphic card's RAM                                 |
|     -   5.5 Preloading                                                   |
|         -   5.5.1 Go-preload                                             |
|         -   5.5.2 Preload                                                |
|         -   5.5.3 Readahead                                              |
|                                                                          |
| -   6 Boot time                                                          |
|     -   6.1 Suspend to RAM                                               |
|                                                                          |
| -   7 Application-specific tips                                          |
|     -   7.1 Firefox                                                      |
|     -   7.2 Gcc/Makepkg                                                  |
|     -   7.3 LibreOffice                                                  |
|     -   7.4 Pacman                                                       |
|     -   7.5 SSH                                                          |
|                                                                          |
| -   8 Laptops                                                            |
+--------------------------------------------------------------------------+

The basics
----------

> Know your system

The best way to tune a system is to target the bottlenecks, that is the
subsystems that limit the overall speed. They usually can be identified
by knowing the specifications of the system, but there are some basic
indications:

-   If the computer becomes slow when big applications, like
    OpenOffice.org and Firefox, are running at the same time, then there
    is a good chance the amount of RAM is insufficient. To verify
    available RAM, use this command, and check for the line beginning
    with -/+buffers:

    $ free -m

-   If boot time is really slow, and if applications take a lot of time
    to load the first time they are launched, but run fine afterwards,
    then the hard drive is probably too slow. The speed of a hard drive
    can be measured using the hdparm command:

    $ hdparm -t /dev/sdx

This is only the pure read speed of the hard drive, and is not a valid
benchmark, but a value superior to 40MB/s (assuming drive tested while
idle) can be considered decent on an average system. hdparm can be found
in the Official Repositories.

-   If the CPU load is consistently high even when RAM is available,
    then lowering CPU usage should be a priority. CPU load can be
    monitored in many ways, like using the top command:

    $ top

-   If the only applications lagging are the ones using direct
    rendering, meaning they use the graphic card, like video players and
    games, then improving the graphic performance should help. First
    step would be to verify if direct rendering simply is not enabled.
    This is indicated by the glxinfo command:

    $ glxinfo | grep direct

> The first thing to do

The simplest and most efficient way of improving overall performance is
to run lightweight environments and applications.

-   Use a window manager instead of a Desktop Environment. Choices
    include dwm, wmii, Awesome, Openbox, Fluxbox and JWM.
-   Choose a minimal Desktop Environment over a heavier one like GNOME
    or KDE. Something like LXDE or Xfce.
-   Using lightweight applications. Search Common Applications for
    console applications and the Light and Fast Applications Awards
    threads in the forum: 2007, 2008, 2009, 2010, 2011, and 2012
-   Remove unnecessary daemons.

> Compromise

Almost all tuning brings drawbacks. Lighter applications usually come
with less features and some tweaks may make a system unstable, or simply
require time to implement and maintain. This page tries to highlight
those drawbacks, but the final judgment rests on the user.

> Benchmarking

The effects of optimization are often difficult to judge. They can
however be measured by benchmarking tools

Storage devices
---------------

> Device Layout

One of the biggest performance gains comes from having multiple storage
devices in a layout that spreads the operating system work around.
Having / /home /var and /usr on separate disks is dramatically faster
than a single disk layout where they are all on the same hard drive.

Swap Files

Creating your swap files on a separate disk can also help quite a bit,
especially if your machine swaps frequently. It happens if you do not
have enough RAM for your environment. Using KDE with all the features
and applications that come along may require several GiB of memory,
whereas a tiny window manager with console applications will perfectly
fit in less than 512 MiB of memory.

RAID Benefits

If you have multiple disks (2 or more) available, you can set them up as
a software RAID for serious speed improvements. In a RAID 0 array there
is no redundancy in case of drive failure, but for each additional disk
you add to the array, the speed of the disk becomes that much faster.
The smart choice is to use RAID 5 which offers both speed and data
protection.

Multiple Hardware Paths

An internal hardware path is how the storage device is connected to your
motherboard. There are different ways to connect to the motherboard such
as TCP/IP through a NIC, plugged in directly using PCIe/PCI, Firewire,
Raid Card, USB, etc. By spreading your storage devices across these
multiple connection points you maximize the capabilities of your
motherboard, for example 6 hard-drives connected via USB would be much
much slower than 3 over USB and 3 over Firewire. The reason is that each
entry path into the motherboard is like a pipe, and there is a set limit
to how much can go through that pipe at any one time. The good news is
that the motherboard usually has several pipes.

More Examples

1.  Directly to the motherboard using pci/PCIe/ata
2.  Using an external enclosure to house the disk over USB/Firewire
3.  Turn the device into a network storage device by connecting over
    tcp/ip

Note also that if you have a 2 USB ports on the front of your machine,
and 4 USB ports on the back, and you have 4 disks, it would probably be
fastest to put 2 on front/2 on back or 3 on back/1 on front. This is
because internally the front ports are likely a separate Root Hub than
the back, meaning you can send twice as much data by using both than
just 1. Use the following commands to determine the various paths on
your machine.

    USB Device Tree

    $ lsusb -tv

    PCI Device Tree

    $ lspci -tv

> Partitioning

The partition layout can influence the system's performance. Sectors at
the beginning of the drive (closer to the center of the disk) are faster
than those at the end. Also, a smaller partition requires less movements
from the drive's head, and so speed up disk operations. Therefore, it is
advised to create a small partition (10gb, more or less depending on
your needs) only for your system, as near to the beginning of the drive
as possible. Other data (pictures, videos) should be kept on a separate
partition, and this is usually achieved by separating the home directory
(/home/user) from the system (/).

> Choosing and tuning your filesystem

Choosing the best filesystem for a specific system is very important
because each has its own strengths. The beginner's guide provides a
short summary of the most popular ones. You can also find relevant
articles here.

Summary

-   XFS: Excellent performance with large files. Low speed with small
    files. A good choice for /home.
-   Ext3: Average performance, reliable.
-   Ext4: Great overall performance, reliable, has performance issues
    with sqlite and some other databases.
-   JFS: Good overall performance, very low CPU usage, extremely fast
    resume after power failure.
-   Btrfs: Probably best overall performance (with compression) and lots
    of features. Still in heavy development and fully supported, but
    considered as unstable. Do not use this filesystem yet unless you
    know what you are doing and are prepared for potential data loss.

Mount options

Mount options offer an easy way to improve speed without reformatting.
They can be set using the mount command:

    $ mount -o option1,option2 /dev/partition /mnt/partition

To set them permanently, you can modify /etc/fstab to make the relevant
line look like this:

    /dev/partition /mnt/partition partitiontype option1,option2 0 0

The mount options noatime,nodiratime are known for improving performance
on almost all file-systems. The former is a superset of the latter
(which applies to directories only -- noatime applies to both files and
directories). In rare cases, for example if you use mutt, it can cause
minor problems. You can instead use the relatime option (NB relatime is
the default in >2.6.30)

Ext3

See Ext3.

Ext4

See Ext4.

JFS

See JFS Filesystem.

XFS

For optimal speed, just create an XFS file-system with:

    $ mkfs.xfs /dev/thetargetpartition

Yep, so simple — since all of the "boost knobs" are already "on" by
default.

Reiserfs

The data=writeback mount option improves speed, but may corrupt data
during power loss. The notail mount option increases the space used by
the filesystem by about 5%, but also improves overall speed. You can
also reduce disk load by putting the journal and data on separate
drives. This is done when creating the filesystem:

    $ mkreiserfs –j /dev/hda1 /dev/hdb1

Replace /dev/hda1 with the partition reserved for the journal, and
/dev/hdb1 with the partition for data. You can learn more about reiserfs
with this article.

Btrfs

See defragmentation and compression.

> Compressing /usr

Note:As of version 3.0 of the Linux kernel, aufs2 is no longer
supported.

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: aufs is no       
                           longer in the official   
                           repos. Also, read the    
                           Note box above.          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

A way to speed up reading from the hard drive is to compress the data,
because there is less data to be read. It must however be decompressed,
which means a greater CPU load. Some file systems support transparent
compression, most notably Btrfs and reiserfs4, but their compression
ratio is limited by the 4k block size. A good alternative is to compress
/usr in a squashfs file, with a 64k(128k) block size, as instructed in
this Gentoo forums thread. What this tutorial does is basically to
compress the /usr folder into a compressed squashfs file-system, then
mounts it with aufs. A lot of space is saved, usually two thirds of the
original size of /usr, and applications load faster. However, each time
an application is installed or reinstalled, it is written uncompressed,
so /usr must be re-compressed periodically. Squashfs is already in the
kernel, and aufs2 is in the official repositories, so no kernel
compilation is needed if using the stock kernel. Since the linked guide
is for Gentoo, the next commands outline the steps specifically for
Arch. To get it working, install the packages aufs2 and squashfs-tools.
These packages provide the aufs-modules and some userspace-tools for the
squash-filesystem.

Now we need some extra directories where we can store the archive of
/usr as read-only and another folder where we can store the data changed
after the last compression as writeable:

    # mkdir -p /squashed/usr/{ro,rw}

Now that we got a rough setup you should perform a complete
system-upgrade since every change of content in /usr after the
compression will be excluded from this speedup. If you use prelink you
should also perform a complete prelink before creating the archive. Now
it is time to invoke the command to compress /usr:

    # mksquashfs /usr /squashed/usr/usr.sfs -b 65536

These parameters/options are the ones suggested by the Gentoo link but
there might be some room for improvement using some of the options
described here. Now to get the archive mounted together with the
writeable folder it is necessary to edit /etc/fstab and add the
following lines:

    /squashed/usr/usr.sfs   /squashed/usr/ro   squashfs   loop,ro   0 0 
    usr    /usr    aufs    udba=reval,br:/squashed/usr/rw:/squashed/usr/ro  0 0

Now you should be done and able to reboot. The original author suggests
to delete all the old content of /usr, but this might cause some
problems if anything goes wrong during some later re-compression. It is
safer to leave the old files in place.

A Bash script has been created that will automate the process of
re-compressing (read updating) the archive since the tutorial is meant
for Gentoo and some options do not correlate to what they should be in
Arch.

> Tuning for an SSD

SSD#Tips_for_Maximizing_SSD_Performance

> RAM disks / tuning for really slow disks

-   USB stick RAID
-   Combine RAM disk with disk in RAID

CPU
---

The only way to directly improve CPU speed is overclocking. As it is a
complicated and risky task, it is not recommended for anyone except
experts. The best way to overclock is through the BIOS. When purchasing
your system, keep in mind that most Intel motherboards are notorious for
disabling the capacity to overclock.

Many Intel i5 and i7 chips, even when overclocked properly through the
BIOS or UEFI interface, will not report the correct clock frequency to
acpi_cpufreq and most other utilities. This will result in excessive
messages in dmesg about delays unless the module acpi_cpufreq is
unloaded and blacklisted. The only tool known to correctly read the
clock speed of these overclocked chips under Linux is i7z. The i7z
package is available in the community repo and i7z-svn is available in
the AUR.

A way to modify performance (ref) is to use Con Kolivas' desktop-centric
kernel patchset, which, among other things, replaces the Completely Fair
Scheduler (CFS) with the Brain Fuck Scheduler (BFS).

Kernel PKGBUILDs that include the BFS patch can be installed from the
AUR or Unofficial User Repositories. See the respective pages for
linux-ck and Linux-ck wiki page, linux-bfs or linux-pf for more
information on their additional patches.

Note:BFS/CK are designed for desktop/laptop use and not servers. They
provide low latency and work well for 16 CPUs or less. Also, Con Kolivas
suggests setting HZ to 1000. For more information, see the BFS FAQ and
Kernel patch homepage of Con Kolivas.

> Verynice

Verynice is a daemon, available in the AUR as verynice, for dynamically
adjusting the nice levels of executables. The nice level represents the
priority of the executable when allocating CPU resources. Simply define
executables for which responsiveness is important, like X or multimedia
applications, as goodexe in /etc/verynice.conf. Similarly, CPU-hungry
executables running in the background, like make, can be defined as
badexe. This prioritization greatly improves system responsiveness under
heavy load.

> Ulatencyd

Ulatencyd is a daemon that controls how the Linux kernel will spend its
resources on the running processes. It uses dynamic cgroups to give the
kernel hints and limitations on processes. It supports prioritizing
processes for disk I/O as well as CPU shares, and uses more clever
heuristics than Verynice. In addition, it comes with a good set of
configs out of the box.

One note of warning, by default it changes the default scheduler of all
block devices to cfq, to disable behavior see Ulatencyd.

Graphics
--------

> Xorg.conf configuration

Graphic performance heavily depends on the settings in
/etc/X11/xorg.conf. There are tutorials for Nvidia, ATI and Intel cards.
Improper settings may stop Xorg from working, so caution is advised.

> Driconf

Driconf is a small utility that can be found in the official
repositories that allows you to change the direct rendering settings for
open source drivers. Enabling HyperZ can drastically improve
performance.

> GPU Overclocking

Overclocking a graphics card is typically more expedient than with a
CPU, since there are readily accessible software packages which allow
for on-the-fly GPU clock adjustments. For ATI users, get rovclock, and
Nvidia users should get nvclock in the extra repository. Intel chipsets
users can install GMABooster from with the gmabooster AUR package.

The changes can be made permanent by running the appropriate command
after X boots, for example by adding it to ~/.xinitrc. A safer approach
would be to only apply the overclocked settings when needed.

RAM and swap
------------

> Relocate files to tmpfs

Relocate files, such as your browser profile, to a tmpfs file system,
including /tmp, or /dev/shm for improvements in application response as
all the files are now stored in RAM.

Use an active management script for maximal reliability and ease of use.

Refer to the Profile-sync-daemon wiki article for more information on
syncing browser profiles.

Refer to the Anything-sync-daemon wiki article for more information on
syncing any specified folder.

> Swappiness

The swappiness represent how much the kernel prefers swap to RAM.
Setting it to a very low value, meaning the kernel will almost always
use RAM, is known to improve responsiveness on many systems. To do that,
simply add these lines to /etc/sysctl.conf:

    vm.swappiness=20
    vm.vfs_cache_pressure=50

To test and more on why this may work, take a look at this article.

> Compcache / Zram

Compcache, nowadays replaced by the zram kernel module, creates a device
in RAM and compresses it. If you use for swap means that part of the RAM
can hold much more information but uses more CPU. Still, it is much
quicker than swapping to a hard drive. If a system often falls back to
swap, this could improve responsiveness. Zram is in mainline staging
(therefore its not stable yet, use with caution).

The AUR package zramswap provides an automated script fot setting up
such swap devices with optimal settings for your system (such as RAM
size and CPU core number). The script creates one zram device per CPU
core with a total space equivalent to the RAM available. To do this
automatically on every boot:

-   If you use initscripts, add zramswap to the DAEMONS array in
    /etc/rc.conf.
-   If you use systemd, enable zramswap.service via systemctl.

You will have a compressed swap with higher priority than your regular
swap which will utilize multiple CPU cores for compessing data.

Tip:Using zram is also a good way to reduce disk read/write cycles due
to swap on SSDs.

Note:The service file (and rc.d script) have been moved to a separate
package in the AUR called zramswap.

> Using the graphic card's RAM

In the unlikely case that you have very little RAM and a surplus of
video RAM, you can use the latter as swap. See Swap on video ram.

> Preloading

Preloading is the action of putting and keeping target files into the
RAM. The benefit is that preloaded applications start more quickly
because reading from the RAM is always quicker than from the hard drive.
However, part of your RAM will be dedicated to this task, but no more
than if you kept the application open. Therefore preloading is best used
with large and often-used applications like Firefox and OpenOffice.

Go-preload

Go-preload is a small daemon created in the Gentoo forum. To use it,
first run this command in a terminal for each program you want to
preload at boot:

    # gopreload-prepare program

Then, as instructed, press Enter when the program is fully loaded. This
will add a list of files needed by the program in
/usr/share/gopreload/enabled. To load all lists at boot, add gopreload
to your DAEMONS array in /etc/rc.conf. To disable the loading of a
program, remove the appropriate list in /usr/share/gopreload/enabled or
move it to /usr/share/gopreload/disabled.

Preload

A more automated approach is used by Preload. All you have to do is
enable it with this command:

     # systemctl enable preload

It will monitor the most used files on your system, and with time build
its own list of files to preload at boot.

Readahead

Readahead is a tool that can cache files before they are needed and help
accelerate program loading.

Boot time
---------

You can find tutorials with good tips in the article Improve Boot
Performance.

> Suspend to RAM

The best way to reduce boot time is not booting at all. Consider
suspending your system to RAM instead.

Application-specific tips
-------------------------

> Firefox

The Firefox Tweaks article offers good tips; notably turning off
anti-phishing and cleaning the SQlite database. See also: Firefox in
Ramdisk.

Firefox in the official repositories is built with the profile guided
optimization flag enabled. You may want to use it in your custom build.
To do this append

    ac_add_options --enable-profile-guided-optimization

to your mozconfig.

> Gcc/Makepkg

See Ccache.

> LibreOffice

See Speed up LibreOffice.

> Pacman

See Improve Pacman Performance.

> SSH

See Speed up SSH.

Laptops
-------

See Laptop.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Maximizing_Performance&oldid=255000"

Categories:

-   Hardware
-   System administration
