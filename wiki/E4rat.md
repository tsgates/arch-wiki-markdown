E4rat
=====

> Summary

How to drastically reduce boot and log-into-X time for ext4 file systems
using the e4rat range of tools.

> Related

Improve Boot Performance

Preload

Readahead

Ureadahead

Ext4

Forum threads

Main discussion

Improved e4rat-preload

e4rat stands for e4 'reduced access time' (ext4 file system only) and is
a project by Andreas Rid and Gundolf Kiefer. The e4rat range of tools
are comprised of e4rat-collect, e4rat-realloc and e4rat-preload.

Current version is 0.2.1

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Process                                                            |
|     -   1.1 Who benefits, who does not                                   |
|                                                                          |
| -   2 Installation                                                       |
| -   3 Getting it to work                                                 |
|     -   3.1 e4rat-collect                                                |
|     -   3.2 e4rat-realloc                                                |
|     -   3.3 e4rat-preload                                                |
|     -   3.4 Alternative: e4rat-preload-lite                              |
|                                                                          |
| -   4 e4rat with different init system, e.g. systemd                     |
| -   5 Bootchart                                                          |
|     -   5.1 bootchart 0.9-9                                              |
|     -   5.2 bootchart2                                                   |
|                                                                          |
| -   6 Troubleshooting                                                    |
|     -   6.1 startup.log is not created                                   |
|     -   6.2 e4rat erroneously reports an ext2 files system               |
|     -   6.3 /var/lib/e4rat/startup.log is not accessible                 |
|     -   6.4 Remove annoying message that mess up boot message            |
+--------------------------------------------------------------------------+

Process
-------

If you look at a classical bootchart you will notice that neither disk
nor CPU are utilized fully during the boot process. e4rat changes this
to make full use of both disk and CPU during boot process and thus
reduce boot time drastically. It consists of three stages:

-   e4rat-collect - collect files for a specified time (default 120
    seconds but this can be adjusted)
-   e4rat-realloc - reallocate files
-   e4rat-preload - preload them

> Who benefits, who does not

e4rat has proven to be extremely effective for typical single user
set-ups which boot straight into X, perhaps even with a number of
programs open. If you have a server set-up and boot only into the CLI
your boot time decrease may not be as drastic. Users of SSD drives do
not benefit because there are no moving parts and thus (almost) no disk
latency - Ureadahead might be worth looking at.

Note:(to ureadahead users) The official e4rat manual states that
ureadahead conflicts with e4rat. This may be true for Ubuntu but using
e4rat in conjunction with ureadahead does work on Arch Linux, although
it does not speed up the boot process any further.

It is always better to be safe than sorry. Just make backup if you
cannot afford to lose data on your partition.

Installation
------------

Install e4rat from the Official Repositories.

Getting it to work
------------------

Now for the nitty-gritty:

> e4rat-collect

To have e4rat collect a list of files you will need to append
init=/sbin/e4rat-collect to your kernel parameters.For example:

    kernel /vmlinuz0linux root=/dev/disk/by-label/ARCH init=/sbin/e4rat-collect ro 5

This will only have to be done once so you may prefer to append this
command on the grub command line itself.

Upon booting e4rat-collect will watch your system for a default of 120
seconds. So if you boot, log into X, open your favourite browser and
email client all within 2 minutes, every one of those activities is
logged. To change the default of 120 seconds edit /etc/e4rat.conf. To
manually stop e4rat-collect type:

    e4rat-collect -k

or

    pkill e4rat-collect

Upon successful boot and after having waited the allotted time you
should see the following file: /var/lib/e4rat/startup.log

Do not forget to remove the e4rat-collect command from your boot loader
configuration file (not necessary if you inserted it on the grub command
line).

> e4rat-realloc

For the reallocation process change to init 1

    sudo init 1

Note:Users who have switched to a pure systemd setup do not have to
change runlevels. Simply login as root once e4rat-collect has finished
to run the e4rat-realloc utility however, switching to rescue mode in
systemd with systemctl rescue may allow for more inodes/blocks to be
reallocated as some may not be free while in multiuser.target

Log in as root and run:

    e4rat-realloc  /var/lib/e4rat/startup.log

This can take a while depending on how many files you have in your
startup.log file.

Note:It may be worthwhile to repeat the reallocation step multiple times
before exiting or rebooting in order to further reduce the fragmentation
count. Simply re-run the command a few times to see if this is possible
on the your setup. If so you'll see the count number reduced after a few
runs. This is perfectly safe and shouldn't cause any issues with
booting.

> e4rat-preload

Append init=/sbin/e4rat-preload permanently to your kernel parameters.

> Alternative: e4rat-preload-lite

An alternative preload binary has been developed by jlindgren, it saves
a few extra seconds from your boot time.

The savings come from

-   using pure C with no external library dependencies, which drops the
    number of linked .so files from 22 to 3

Note:Current [0.2.3] version of e4rat-preload is linked against 5 .so
libraries, including libc, libm, libpthread ! So there is not much of a
difference here.

-   preloading only the first 100 files (both inodes and file contents)
    before starting /sbin/init, then continuing to load the remaining
    files in parallel with the normal boot sequence.

You can install e4rat-preload-lite from the AUR.

Append (or replace) init=/usr/sbin/e4rat-preload-lite permanently to
your kernel parameters. Reboot and enjoy.

e4rat with different init system, e.g. systemd
----------------------------------------------

e4rat-collect defaults to replacing itself with /sbin/init upon
completion. If you need to specify another process with PID 1, such as
/bin/systemd, you can change this in /etc/e4rat.conf by setting the
"init" parameter:

    init /bin/systemd 

This allows to launch both e4rat-preload and bootchart in the same boot
sequence.

Bootchart
---------

Note: this has not worked for and is still in development - any
suggestions welcome

You will see a noticeable improvement but nothing can beat a nice
Bootchart. Have it run before and after e4rat installation and gawk at
the difference.

> bootchart 0.9-9

This version of bootchart automatically stops logging as soon as Display
Manager comes up. Supposedly the following overrides that and continues
logging but it does not work for me:

To continue logging adjust your /etc/bootchartd.conf as follows:

    AUTO_STOP_LOGGER="no"

To stop it manually type:

    ~# bootchartd stop

To run both e4rat-preload and bootchart append the following to your
grub kernel line:

    init=/sbin/bootchartd bootchart_init=/sbin/e4rat-preload

> bootchart2

To get bootchart2 working together with e4rat edit /sbin/bootchartd and
replace the line where it says

    init="/sbin/init"

with

    init="/sbin/e4rat-preload"

This will allow you to measure your boot time with the fine informations
that Bootchart2 provides.

It's easy to set up when to stop bootchart2 (on opposite to bootchat) by
editing its configuration file /etc/bootchartd.conf. Simply adjust the
line

    EXIT_PROC="kdm_greet xterm konsole gnome-terminal metacity mutter compiz ldm icewm-session enlightenment"

with any program you want Bootchart2 stop logging when it launches, or
rather left it empty for logging to be stopped manually.

Troubleshooting
---------------

If things do not work you may want to try the following.

> startup.log is not created

-   comment out auditd from your rc.conf
-   check the following for any hints

    dmesg | grep e4rat

-   try to increase verbosity and loglevel to 31 in your e4rat.conf

> e4rat erroneously reports an ext2 files system

Add rootfstype=ext4 to kernel parameters from your bootloader.

> /var/lib/e4rat/startup.log is not accessible

-   this suggests that you have /var on a separate partition which is
    not yet mounted during boot. You need move your startup.log to an
    accessible partition (/etc/e4rat/ is just fine) and adjust your
    /etc/e4rat.conf to reflect this change:

    startup_log_file /etc/e4rat/startup.log

> Remove annoying message that mess up boot message

If you are annoyed by the e4rat-preload message during boot, decrease
loglevel to 1 in /etc/e4rat.conf

Retrieved from
"https://wiki.archlinux.org/index.php?title=E4rat&oldid=243534"

Category:

-   Boot process
