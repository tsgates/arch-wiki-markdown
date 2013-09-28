sysctl
======

sysctl is a tool (in [core] package procps-ng) for examining and
changing kernel parameters at runtime. sysctl is implemented in procfs,
the virtual process file system at /proc/.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Configuration                                                      |
| -   2 systemd                                                            |
| -   3 Security                                                           |
|     -   3.1 Preventing link TOCTOU vulnerabilities                       |
|     -   3.2 Hide kernel symbol addresses                                 |
|                                                                          |
| -   4 Networking                                                         |
|     -   4.1 Improving Performance                                        |
|     -   4.2 TCP/IP stack hardening                                       |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 Small periodic system freezes                                |
|                                                                          |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Configuration
-------------

The sysctl preload/configuration file is located at /etc/sysctl.conf.

    /etc/sysctl.conf

    # /etc/sysctl.conf - Configuration file for setting system variables
    # See sysctl.conf (5) for information.

    # you can have the CD-ROM close when you use it, and open
    # when you are done.
    #dev.cdrom.autoeject = 1
    #dev.cdrom.autoclose = 1

    # protection from the SYN flood attack
    net.ipv4.tcp_syncookies = 1

    # see the evil packets in your log files
    #net.ipv4.conf.all.log_martians = 1

    # if not functioning as a router, there is no need to accept redirects or source routes
    #net.ipv4.conf.all.accept_redirects = 0
    #net.ipv4.conf.all.accept_source_route = 0
    #net.ipv6.conf.all.accept_redirects = 0
    #net.ipv6.conf.all.accept_source_route = 0

    # Disable packet forwarding
    net.ipv4.ip_forward = 0
    net.ipv6.conf.all.forwarding = 0

    # Enable IPv6 Privacy Extensions
    net.ipv6.conf.default.use_tempaddr = 2
    net.ipv6.conf.all.use_tempaddr = 2

    # sets the port range used for outgoing connections
    #net.ipv4.ip_local_port_range = 32768    61000

    # Swapping too much or not enough? Disks spinning up when you'd
    # rather they didn't? Tweak these.
    #vm.vfs_cache_pressure = 100
    #vm.laptop_mode = 0
    #vm.swappiness = 60

    #kernel.printk_ratelimit_burst = 10
    #kernel.printk_ratelimit = 5
    #kernel.panic_on_oops = 0

    # Reboot 600 seconds after a panic
    #kernel.panic = 600

    # Disable SysRq key (note: console security issues)
    kernel.sysrq = 0

The parameters available are those listed under /proc/sys/. For example,
the kernel.sysrq parameter refers to the file /proc/sys/kernel/sysrq on
the file system. The sysctl -a command can be used to display all values
currently available.

Note:If you have the kernel documentation installed (linux-docs), you
can find detailed information about sysctl settings in
/usr/src/linux-$(uname -r)/Documentation/sysctl/. It is highly
recommended reading before changing sysctl settings.

Settings can be changed through file manipulation or using the sysctl
utility. For example, to temporarily enable the magic sysrq key:

    # sysctl kernel.sysrq=1

or:

    # echo "1" > /proc/sys/kernel/sysrq

To preserve changes between reboots, add or modify the appropriate lines
in /etc/sysctl.conf.

Tip:After changing settings in /etc/sysctl.conf, you can load them with

    # sysctl -p

systemd
-------

If you have systemd installed, you will find /etc/sysctl.d/ which is "a
drop-in directory for kernel sysctl parameters, extending what you can
already do with /etc/sysctl.conf." See The New Configuration Files and
more specifically systemd's sysctl.d man page for more information.

Security
--------

> Preventing link TOCTOU vulnerabilities

See the commit message for when this feature was added for the
rationale.

    fs.protected_hardlinks = 1
    fs.protected_symlinks = 1

> Hide kernel symbol addresses

Enabling kernel.kptr_restrict will hide kernel symbol addresses in
/proc/kallsyms from regular users, making it more difficult for kernel
exploits to resolve addresses/symbols dynamically. This will not help
that much on a precompiled Arch Linux kernel, since a determined
attacker could just download the kernel package and get the symbols
manually from there, but if you're compiling your own kernel, this can
help mitigating local root exploits. This will break some perf commands
when used by non-root users (but main perf features require root access
anyway). See this bug for more information.

    kernel.kptr_restrict = 1

Networking
----------

> Improving Performance

Warning:This may cause dropped frames with load-balancing and NATs, only
use this for a server that communicates only over your local network.

    # reuse/recycle time-wait sockets
    net.ipv4.tcp_tw_reuse = 1
    net.ipv4.tcp_tw_recycle = 1

> TCP/IP stack hardening

    #### ipv4 networking ####

    ## TCP SYN cookie protection
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

    ## disable ALL packet forwarding (not a router, disable it)
    net.ipv4.ip_forward = 0

    ## log martian packets
    net.ipv4.conf.all.log_martians = 1

    ## ignore echo broadcast requests to prevent being part of smurf attacks
    net.ipv4.icmp_echo_ignore_broadcasts = 1

    ## optionally, ignore all echo requests
    ## this is NOT recommended, as it ignores echo requests on localhost as well
    #net.ipv4.icmp_echo_ignore_all = 1

    ## ignore bogus icmp errors
    net.ipv4.icmp_ignore_bogus_error_responses = 1

    ## IP source routing (insecure, disable it)
    net.ipv4.conf.all.accept_source_route = 0

    ## send redirects (not a router, disable it)
    net.ipv4.conf.all.send_redirects = 0

    ## ICMP routing redirects (only secure)
    net.ipv4.conf.all.accept_redirects = 0
    net.ipv4.conf.all.secure_redirects = 1

Troubleshooting
---------------

> Small periodic system freezes

Set dirty bytes to small enough value (for example 4M)

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
-   SysCtl Config Tutorial

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sysctl&oldid=255559"

Category:

-   Kernel
