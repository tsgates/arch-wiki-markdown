Readahead-fedora
================

Readahead-fedora is originally developed by Fedora, and contrary to
ureadahead, it does not require patching the kernel. It creates a list
of files to put in the page cache before they are needed, thus reducing
boot time.

Contents
--------

-   1 Advantages
-   2 Installation
-   3 Configuration
-   4 Usage
    -   4.1 Automated profiling
    -   4.2 Manually reprofile the system
-   5 Trimming down boot-times
-   6 Notes
-   7 Links

Advantages
----------

-   It does not require patching the kernel.
-   It can take multiple lists of files to be preloaded, and sort them
    according to their position on the disk.
-   It preloads the inode tables on ext2-based file systems.
-   It opens the files without making the system update their access
    time, therefore avoiding extra disk writes. (Though, this shouldn't
    matter when using relatime or noatime I think)
-   It uses a lightweight monitoring daemon.

(List shamelessly stolen from the debian package description, original
here)

Installation
------------

Ying has created a PKGBUILD for this project; it is named
readahead-fedora in the AUR.

Note:libprelude currently doesn't build with libtool-2.4. Either
downgrade to 2.2.10-3 or wait for a workaround.

Configuration
-------------

All configuration is done through /etc/readahead.conf. Some interesting
variables might be:

    TIMEOUT_SWITCH_TO_LATER="8"

This determines the timeout for the collector while X and such is
starting.

    RAC_MAXTIME="100"

A value in seconds that determine how long the collector should run.

    RAC_INITPATH="/sbin/init"

A path to your init program. Change this if you use anything other than
sysvinit.

    RAC_EXECIGN="/sbin/readahead /usr/sbin/preload"

If you want the collector to ignore syscalls from certain programs, this
is where you set their paths.

    RAC_EXCLUDE="/proc /sys /dev /var/log /var/run /var/lock /home /tmp /var/tmp /media /selinux /mnt"

Directories to ignore while collecting. Anything that is not needed
during boot should probably be here to keep the list slimmed down.

Usage
-----

The package installs the file /etc/rc.d/functions.d/readahead. This file
will automatically start readahead at the appropriate times, control the
collector and all that.

If you have dbus installed, readahead will automatically start it before
X starts to avoid any issues.

The file /.readahead should automatically be created when installing the
package. This is to let readahead-collector profile your system next
boot.

> Automated profiling

This is actually really easy, just add a cron job that creates the file
/.readahead every month or so.

> Manually reprofile the system

There are two ways to do this, either just run

    $ touch /.readahead

as root, or you can temporarily add

    init=/sbin/readahead-collector

to the kernel line in your bootloader. You should also disable auditd,
because auditd deletes all audit rules during boot, which is
contraproductive for the collector. Now, you just need to reboot and let
the collector profile your system.

Trimming down boot-times
------------------------

The package edits your inittab to take advantage of the early - later
split in readahead-fedora. What it basically does is move these lines
around:

    ...
    rc::sysinit:/etc/rc.sysinit
    rs:S1:wait:/etc/rc.single
    #rm:2345:wait:/etc/rc.multi
    #rh:06:wait:/etc/rc.shutdown
    #su:S:wait:/sbin/sulogin -p

    ...
    # Example lines for starting a login manager
    #x:5:respawn:/usr/bin/xdm -nodaemon
    #x:5:respawn:/usr/sbin/gdm -nodaemon
    #x:5:respawn:/usr/bin/kdm -nodaemon
    #x:5:respawn:/usr/bin/slim >& /dev/null

    rm:2345:wait:/etc/rc.multi > /dev/null
    rh:06:wait:/etc/rc.shutdown
    su:S:wait:/sbin/sulogin -p

    # End of file

Note:The old inittab is backed up as /etc/inittab.backup.

The idea of doing it this way is that readahead will put the needed
X-stuff in the early cache. Thus, while X is starting it will have time
to read the later cache for starting the daemons.

Note:Since we cannot have multi starting early, we cannot use :once:
instead of :wait: to make boot asynchronous.

Notes
-----

You might wonder what this file does while profiling:

    ...
    readahead-later() {
      if [ -e /.readahead ]; then
          sleep 8
          touch /.switch-collector-to-later
          rm /.readahead
      else
    ...

Readahead-fedora uses two steps to read and create the cache, called
"early" and "later". Why it does it this way is to have a small, neat
cache that it initially reads. This basically contains the basic files
needed to boot together with X. After it has read those files and
started X, it reads the "later" cache for starting the various daemons
and services. This way, it tries to be a bit smarter and dynamic in
hiding load times.

Links
-----

-   README from fedorahosted.org
-   Package info from the Debian package tree.
-   quick-boot in the AUR.
-   Article by ying in German.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Readahead-fedora&oldid=238062"

Category:

-   Boot process

-   This page was last modified on 3 December 2012, at 18:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
