Netconsole
==========

netconsole is a kernel module that sends all kernel log messages (i.e.
dmesg) over the network to another computer, without involving user
space (e.g. syslogd). Name "netconsole" is a misnomer because it's not
really a "console", more like a remote logging service.

It can be used either built-in or as a module. Built-in netconsole
initializes immediately after NIC cards and will bring up the specified
interface as soon as possible. The module is mainly used for capturing
kernel panic output from a headless machine, or in other situations
where the user space is no more functional.

Documentation is available in the Linux kernel tree under
Documentation/networking/netconsole.txt

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Build-in Configuration                                             |
| -   3 Dynamic configuration                                              |
| -   4 Receiver                                                           |
| -   5 Starting at Boot                                                   |
+--------------------------------------------------------------------------+

Installation
------------

Install gnu-netcat from the official repositories.

Build-in Configuration
----------------------

Netconsole and other modules' Kernel parameters can be passed from a
bootloader to kernel at its startup via kernel command line by modifying
the bootloader environment, which is type and version specific. Example
for Uboot, where 1st address is Plug Computer ArchLinux device's
netconsole Out Port & IP, and 2nd address is your PC's netconsole In
Port & IP & adapter MAC:

    fw_setenv usb_custom_params 'loglevel=7 netconsole=6666@192.168.1.28/eth0,6666@192.168.1.19/00:13:32:20:r9:a5'

Logging is done by your ArchLinux set logger like syslog-ng, so
available loglevels (output details) are defined in that logger docs,
and may differ for each log type. One can also pass netconsole string
parameters at kernel runtime (no config file required), then start two
netconsole instances on the monitoring PC (one to read output, another
for input), and restart it on the PC or device you are logging as shown
in Dynamic Configuration:

    # set log level for kernel messages
    dmesg -n 8

    netconsole=6666@192.168.1.28/eth0,6666@192.168.1.19/00:13:32:20:r9:a5

    nc -l -u -p 6666 &
    nc -u 192.168.1.28 6666

One may need to switch off PC and router firewall, and setup proper
router port forwarding to monitor and input data in Netconsole.

Dynamic configuration
---------------------

Netconsole can be loaded as one of kernel modules manually after boot or
auto during boot depending on this module config. See kernel modules for
configuring it to load at boot. For loading manually any time after
boot:

    # set log level for kernel messages
    dmesg -n 8

    modprobe configfs
    modprobe netconsole
    mount none -t configfs /sys/kernel/config

    # 'netconsole' dir is auto created if the module is loaded 
    mkdir /sys/kernel/config/netconsole/target1
    cd /sys/kernel/config/netconsole/target1

    # set local IP address
    echo 192.168.0.111 > local_ip
    # set destination IP address
    echo 192.168.0.17 > remote_ip
    # find destination MAC address
    arping `cat remote_ip` -f |grep -o ..:..:..:..:..:.. > remote_mac

    echo 1 > enabled

netconsole should now be configured. To verify, run 'dmesg |tail' and
you should see "netconsole: network logging started". Check available
log levels by running 'dmesg -h'.

Receiver
--------

    nc -u -l 6666

or

    nc -u -l -p 6666

Starting at Boot
----------------

Just add the netconsole to the kernel cmd line. It takes a string
configuration parameter "netconsole" in the following format:

      netconsole=[src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr]
            src-port      source for UDP packets (defaults to 6665)
            src-ip        source IP to use (interface address)
            dev           network interface (eth0)
            tgt-port      port for logging agent (6666)
            tgt-ip        IP address for logging agent
            tgt-macaddr   ethernet MAC address for logging agent (broadcast)

Examples:

    linux /vmlinuz-linux root=UUID=a322511e-b028-4f11-87b6-e48b5d99bbd8 ro netconsole=514@10.0.0.1/eth1,514@10.0.0.2/12:34:56:78:9a:bc
    linux /vmlinuz-linux root=/dev/disk/by-label/ROOT ro netconsole=514@10.0.0.2/12:34:56:78:9a:bc

From: Net Console for Boot Debugging.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Netconsole&oldid=249877"

Categories:

-   Kernel
-   Networking
