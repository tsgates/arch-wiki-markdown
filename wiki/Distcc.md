Distcc
======

> Summary

distcc is a program that distributes source code among a number of
distcc-servers allowing many machines to compile one program and thus
speed up the compilation process. The cool part is you can use it
together with pacman/srcpac.

> Related

TORQUE

Distcc is a program to distribute builds of C, C++, Objective C or
Objective C++ code across several machines on a network. distcc should
always generate the same results as a local build, is simple to install
and use, and is usually much faster than a local compile.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Terms                                                              |
| -   2 Getting started                                                    |
| -   3 Configuration                                                      |
|     -   3.1 Both Daemon and Server(s)                                    |
|     -   3.2 Daemon Only                                                  |
|                                                                          |
| -   4 Compile                                                            |
| -   5 Monitoring Progress                                                |
| -   6 "Cross Compiling" with Distcc                                      |
|     -   6.1 Chroot Method (Preferred)                                    |
|         -   6.1.1 Add port numbers to DISTCC_HOSTS on the i686 chroot    |
|         -   6.1.2 Invoke makepkg from the Native Environment             |
|                                                                          |
|     -   6.2 Multilib GCC Method (Not Recommended)                        |
|                                                                          |
| -   7 Tips/Tricks                                                        |
|     -   7.1 Limit HDD/SSD usage                                          |
|         -   7.1.1 Relocate $HOME/.distcc                                 |
|         -   7.1.2 Adjust log level                                       |
|                                                                          |
| -   8 Failure work with CMake or other tools                             |
+--------------------------------------------------------------------------+

Terms
-----

Note: The terminology used by the software can be a bit counterintuitive
in that "the daemon" is the master and "the server(s)" are the slave
PC(s) in a distcc cluster.

 distcc daemon
    The PC or server that's running distcc to distribute the source
    code. The daemon itself will compile parts of the source code but
    will also send other parts to the hosts defined in DISTCC_HOSTS.

 distcc server
    The PC or server compiling the source code it gets from the daemon.
    When it's done compiling, it sends back the object code (i.e.
    compiled source code) to the daemon, which in turn sends back some
    more source code (if there's any left to compile).

Getting started
---------------

Install the distcc package from official repositories on all PCs in the
cluster:

For other distros, or even OSes including Windows through using Cygwin,
refer to the distcc docs.

Configuration
-------------

> Both Daemon and Server(s)

Edit /etc/conf.d/distccd and modify the only uncommented line with the
correct IP address or range of your daemon or of your entire subnet:

    DISTCC_ARGS="--user nobody --allow 192.168.0.0/24"

> Daemon Only

Edit /etc/makepkg.conf in the following three sections:

1.  BUILDENV has distcc unbanged i.e. without exclamation point.
2.  Uncomment the DISTCC_HOSTS line and add the IP addresses of the
    servers (slaves) then a slash and the number of threads they are to
    use. The subsequent IP address/threads should be separated by a
    white space. This list is ordered from most powerful to least
    powerful (processing power).
3.  Adjust the MAKEFLAGS variable to correspond to the number of sum of
    the number of individual values specified for the max threads per
    server. In the example below, this is 5+3+3=11. If users specify
    more than this sum, the extra theoretical thread(s) will be blocked
    by distcc and appear as such in monitoring utils such as
    distccmon-text described below.

Note:It is common practice to define the number of threads as the number
of physical core+hyperhtreaded cores (if they exist) plus 1. Do this on
a per-server basis, NOT in the MAKEFLAGS!

Example using relevant lines:

    BUILDENV=(distcc fakeroot color !ccache !check)
    MAKEFLAGS="-j11"
    DISTCC_HOSTS="192.168.0.2/5 192.168.0.3/3 192.168.0.4/3"

If users wish to use distcc through SSH, add an "@" symbol in front of
the IP address in this section. If key-based auth is not setup on the
systems, set the DISTCC_SSH variable to ignore checking for
authenticated hosts, i.e. DISTCC_SSH="ssh -i"

Compile
-------

Start the distcc daemon on every participating machine:

    # systemctl start distccd

To have distccd start at boot-up, run this on every participating
machine:

    # systemctl enable distccd

Compile via makepkg as normal.

Monitoring Progress
-------------------

Progress can be monitored via several methods.

1.  distccmon-text
2.  tailing log file

Invoke distccmon-text to check on compilation status:

    $ distccmon-text
    29291 Preprocess  probe_64.c                                 192.168.0.2[0]
    30954 Compile     apic_noop.c                                192.168.0.2[0]
    30932 Preprocess  kfifo.c                                    192.168.0.2[0]
    30919 Compile     blk-core.c                                 192.168.0.2[1]
    30969 Compile     i915_gem_debug.c                           192.168.0.2[3]
    30444 Compile     block_dev.c                                192.168.0.3[1]
    30904 Compile     compat.c                                   192.168.0.3[2]
    30891 Compile     hugetlb.c                                  192.168.0.3[3]
    30458 Compile     catalog.c                                  192.168.0.4[0]
    30496 Compile     ulpqueue.c                                 192.168.0.4[2]
    30506 Compile     alloc.c                                    192.168.0.4[0]

One can have this program run continuously by using watch or by
appending a space followed by integer to the command which corresponds
to the number of sec to wait for a repeat query:

    $ watch distccmon-text

or

    $ distccmon-text 2

One can also simply tail /var/log/messages.log on daemon:

    # tail -f /var/log/messages.log

"Cross Compiling" with Distcc
-----------------------------

There are currently two method from which to select to have the ability
of distcc distribution of tasks over a cluster building i686 packages
from a native x86_64 environment. Neither is ideal, but to date, there
are the only two methods documented on the wiki.

An ideal setup is one that uses the unmodified ARCH packages for distccd
running only once one each node regardless of building from the native
environment or from within a chroot AND one that works with makepkg.
Again, this Utopian setup is not currently known.

A discussion thread has been started on the topic; feel free to
contribute.

> Chroot Method (Preferred)

Note:This method works, but is not very elegant requiring duplication of
distccd on all nodes AND need to have a 32-bit chroots on all nodes.

Assuming the user has a 32-bit chroot setup and configured on each node
of the distcc cluster, the strategy is to have two separate instances of
distccd running on different ports on each node -- one runs in the
native x86_64 environment and the other in the x86 chroot on a modified
port. Start makepkg via a schroot command invoking makepkg.

Add port numbers to DISTCC_HOSTS on the i686 chroot

Append the port number defined eariler (3692) to each of the hosts in
/opt/arch32/etc/makepkg.conf as follows:

    DISTCC_HOSTS="192.168.1.101/5:3692 192.168.1.102/5:3692 192.168.1.103/3:3692"

Note:This only needs to be setup on the "master" i686 chroot. Where
"master" is defined as the one from which the compilation will take
place.

Invoke makepkg from the Native Environment

Setup schroot on the native x86_64 environment. Invoke makepkg to build
an i686 package from the native x86_64 environment, simply by:

    $ schroot -p -- makepkg -src

> Multilib GCC Method (Not Recommended)

Warning:Errors have been reported when using this method to build the
i686 linux package from a native x86_64 system! The chroot method is
preferred and has been verified to work building the kernel packages.

Edit /etc/pacman.conf and uncomment the [multilib] repository:

    [multilib]
    Include = /etc/pacman.d/mirrorlist

Install gcc-multilib from the official repositories.

Compile packages on x86_64 for i686 is as easy as adding the following
lines to $HOME/.makepkg.conf

    CARCH="i686"
    CHOST="i686-pc-linux-gnu"
    CFLAGS="-march=i686 -O2 -pipe -m32"
    CXXFLAGS="${CFLAGS}"

and invoking makepkg via the following

    $ linux32 makepkg -src

Remember to remove or modify $HOME/.makepkg.conf when finished compiling
i686 packages!

Tips/Tricks
-----------

> Limit HDD/SSD usage

Relocate $HOME/.distcc

By default, distcc creates $HOME/.distcc which stores transient relevant
info as it serves up work for nodes to compile. Create a directory named
.distcc in RAM such as /tmp and soft link to it in $HOME. This will
avoid needless HDD read/writes and is particularly important for SSDs.

    $ mv $HOME/.distcc /tmp
    $ ln -s $HOME/.distcc /tmp/.distcc

Use systemd to re-create this directory on a reboot (the soft link will
remain until it is manually removed like any other file):

Create the following tmpfile where "X" is the letter for the SSD device.

     /etc/tmpfiles.d/tmpfs-create.conf 

    d /tmp/.distccd 0755 facade users -

Adjust log level

By default, distcc will log to /var/log/messages.log as it goes along.
One trick (actually recommended in the distccd manpage) is to log to an
alternative file directly. Again, one can locate this in RAM via /tmp.
Another trick is to lower to log level of minimum severity of error that
will be included in the log file. Useful if only wanting to see error
messages rather than an entry for each connection. LEVEL can be any of
the standard syslog levels, and in particular critical, error, warning,
notice, info, or debug.

Both of these lines are to be appended to DISTCC_ARGS in
/etc/conf.d/distccd

    DISTCC_ARGS="--user nobody --allow 192.168.0.0/24 --log-level error --log-file /tmp/distccd.log"

Failure work with CMake or other tools
--------------------------------------

CMake sometimes pass "response file" to gcc, but the distcc cannot deal
with it. There is a patch file, but it has not been applied to upstream
code. If you encounter this problem, you can path this file or use the
distcc-rsp package in the AUR.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Distcc&oldid=240641"

Categories:

-   Package development
-   Networking
