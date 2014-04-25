sysctl
======

sysctl is a tool for examining and changing kernel parameters at runtime
(package procps-ng in official repositories). sysctl is implemented in
procfs, the virtual process file system at /proc/.

Contents
--------

-   1 Configuration
-   2 Security
    -   2.1 Preventing link TOCTOU vulnerabilities
    -   2.2 Hide kernel symbol addresses
-   3 Networking
    -   3.1 Improving performance
    -   3.2 TCP/IP stack hardening
-   4 Troubleshooting
    -   4.1 Small periodic system freezes
-   5 See also

Configuration
-------------

Note:From version 207, systemd only applies settings from
/etc/sysctl.d/* and /usr/lib/sysctl.d/*. If you had customized
/etc/sysctl.conf, you need to rename it as /etc/sysctl.d/99-sysctl.conf.

The sysctl preload/configuration file can be created at
/etc/sysctl.d/99-sysctl.conf. For systemd, /etc/sysctl.d/ and
/usr/lib/sysctl.d/ are drop-in directories for kernel sysctl parameters.
The naming and source directory decide the order of processing, which is
important since the last parameter processed may override earlier ones.
For example, parameters in a /usr/lib/sysctl.d/50-default.conf will be
overriden by equal parameters in /etc/sysctl.d/50-default.conf and any
configuration file processed later from both directories.

To load all configuration files manually, execute

    # sysctl --system 

which will also output the applied hierarchy. A single parameter file
can also be loaded explicitly with

    # sysctl -p filename.conf

See the new configuration files and more specifically systemd's sysctl.d
man page for more information.

The parameters available are those listed under /proc/sys/. For example,
the kernel.sysrq parameter refers to the file /proc/sys/kernel/sysrq on
the file system. The sysctl -a command can be used to display all
currently available values.

Note:If you have the kernel documentation installed (linux-docs), you
can find detailed information about sysctl settings in
/usr/lib/modules/$(uname -r)/build/Documentation/sysctl/. It is highly
recommended reading these before changing sysctl settings.

Settings can be changed through file manipulation or using the sysctl
utility. For example, to temporarily enable the magic SysRq key:

    # sysctl kernel.sysrq=1

or:

    # echo "1" > /proc/sys/kernel/sysrq

To preserve changes between reboots, add or modify the appropriate lines
in /etc/sysctl.d/99-sysctl.conf or another applicable parameter file in
/etc/sysctl.d/.

Tip:Some parameters that can be applied may depend on kernel modules
which in turn might not be loaded. For example parameters in
/proc/sys/net/bridge/* depend on the bridge module. If it is not loaded
at runtime (or after a reboot), those will silently not be applied. See
Kernel_modules#Loading

Security
--------

> Preventing link TOCTOU vulnerabilities

See the commit message for when this feature was added for the
rationale.

    fs.protected_hardlinks = 1
    fs.protected_symlinks = 1

Note:Already enabled by default nowadays. Only left here as information.

> Hide kernel symbol addresses

Enabling kernel.kptr_restrict will hide kernel symbol addresses in
/proc/kallsyms from regular users, making it more difficult for kernel
exploits to resolve addresses/symbols dynamically. This will not help
that much on a precompiled Arch Linux kernel, since a determined
attacker could just download the kernel package and get the symbols
manually from there, but if you're compiling your own kernel, this can
help mitigating local root exploits. This will break some perf commands
when used by non-root users (but main perf features require root access
anyway). See FS#34323 for more information.

    kernel.kptr_restrict = 1

Networking
----------

> Improving performance

Warning:This may cause dropped frames with load-balancing and NATs, only
use this for a server that communicates only over your local network.

    # reuse/recycle time-wait sockets
    net.ipv4.tcp_tw_reuse = 1
    net.ipv4.tcp_tw_recycle = 1

> TCP/IP stack hardening

    #### ipv4 networking ####

    ## TCP SYN cookie protection (default)
    ## helps protect against SYN flood attacks
    ## only kicks in when net.ipv4.tcp_max_syn_backlog is reached
    net.ipv4.tcp_syncookies = 1

    ## protect against tcp time-wait assassination hazards
    ## drop RST packets for sockets in the time-wait state
    ## (not widely supported outside of linux, but conforms to RFC)
    net.ipv4.tcp_rfc1337 = 1

    ## tcp timestamps
    ## + protect against wrapping sequence numbers (at gigabit speeds)
    ## + round trip time calculation implemented in TCP
    ## - causes extra overhead and allows uptime detection by scanners like nmap
    ## enable @ gigabit speeds
    net.ipv4.tcp_timestamps = 0
    #net.ipv4.tcp_timestamps = 1

    ## source address verification (sanity checking)
    ## helps protect against spoofing attacks
    net.ipv4.conf.all.rp_filter = 1

    ## disable ALL packet forwarding (not a router, disable it) (default)
    net.ipv4.ip_forward = 0

    ## log martian packets
    net.ipv4.conf.all.log_martians = 1

    ## ignore echo broadcast requests to prevent being part of smurf attacks (default)
    net.ipv4.icmp_echo_ignore_broadcasts = 1

    ## optionally, ignore all echo requests
    ## this is NOT recommended, as it ignores echo requests on localhost as well
    #net.ipv4.icmp_echo_ignore_all = 1

    ## ignore bogus icmp errors (default)
    net.ipv4.icmp_ignore_bogus_error_responses = 1

    ## IP source routing (insecure, disable it) (default)
    net.ipv4.conf.all.accept_source_route = 0

    ## send redirects (not a router, disable it)
    net.ipv4.conf.all.send_redirects = 0

    ## ICMP routing redirects (only secure)
    net.ipv4.conf.all.accept_redirects = 0
    #net.ipv4.conf.all.secure_redirects = 1 (default)

Troubleshooting
---------------

> Small periodic system freezes

Set dirty bytes to small enough value (for example 4M):

    vm.dirty_background_bytes = 4194304
    vm.dirty_bytes = 4194304

Try to change kernel.io_delay_type (x86 only):

-   0 - IO_DELAY_TYPE_0X80
-   1 - IO_DELAY_TYPE_0XED
-   2 - IO_DELAY_TYPE_UDELAY
-   3 - IO_DELAY_TYPE_NONE

See also
--------

-   The sysctl(8) and sysctl.conf(5) man pages
-   Linux kernel documentation
    (<kernel source dir>/Documentation/sysctl/)
-   Kernel Documentation: IP Sysctl
-   SysCtl.conf Tweaked for Security and Cable Speed [1]

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sysctl&oldid=305452"

Category:

-   Kernel

-   This page was last modified on 18 March 2014, at 14:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
