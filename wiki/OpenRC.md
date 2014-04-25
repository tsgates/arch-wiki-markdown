OpenRC
======

Note:Arch uses systemd by default. If you use OpenRC, please mention so
while asking for help.

OpenRC is an init system maintained by the Gentoo developers. OpenRC is
a dependency based init system that works with the system provided init
program, normally sysvinit. It is not a replacement for sysvinit.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Network
    -   2.2 Logging
        -   2.2.1 syslog-ng
        -   2.2.2 Boot logging
    -   2.3 Hostname
    -   2.4 Module autoloading
    -   2.5 Locale
-   3 Troubleshooting
    -   3.1 Error while unmounting /tmp
    -   3.2 Disabling IPv6 doesn't work
    -   3.3 During shutdown remounting root as read-only fails
-   4 External Links

Installation
------------

OpenRC is available in the AUR. You can choose to install either openrc
or openrc-git package. You will also need to install
openrc-arch-services-git (provides service files for use with openrc on
arch) and openrc-sysvinit (a slightly patched version of traditional
sysvinit). For the sake of compatibility with initscripts,
openrc-sysvinit installs the sysvinit init binary as /sbin/init-openrc.

The packages will be installed under /etc/openrc instead of the default
location of /etc, so that users can switch to initscripts or systemd
when desired.

Configuration
-------------

For booting with OpenRC add init=/sbin/init-openrc to the kernel line in
your bootloader configuration. If you want to switch back to systemd,
change it to init=/usr/lib/systemd/systemd.

For detailed instructions on configuring OpenRC, read the man pages,
visit the gentoo guide and the gentoo wiki.

It is worth noting that the udev service is not enabled by default. In
order to enable it, do:

    # rc-update add udev sysinit

> Network

There are multiple ways to get a network up and running. One way is by
configuring the /etc/openrc/conf.d/network file. Both the ip (iproute2)
and the ifconfig (net-tools) commands are supported.

Below is an example configuration using ip.

    ip_eth0="192.168.1.2/24"
    defaultiproute="via 192.168.1.1"
    ifup_eth0="ip link set \$int mtu 1500"

The network service is added to the boot runlevel by default, so no
further action is required.

You can also use NetworkManager, dhcpcd or netcfg by enabling the
respective services.

Take a look at Network configuration for a detailed look at networking
in general.

> Logging

syslog-ng

If you use syslog-ng, comment out the following line in
/etc/syslog-ng/syslog-ng.conf:

    unix-dgram("/run/systemd/journal/syslog")

and add this line instead:

    unix-dgram("/dev/log");

Note:Without making this change syslog-ng will fail to run and as a
result nothing will be logged!

Boot logging

OpenRC's boot logging is disabled by default. To enable it, uncomment
the following line in /etc/openrc/rc.conf:

    #rc_logger="YES"

> Hostname

OpenRC sets the hostname from /etc/openrc/conf.d/hostname.

Here is an example file:

    /etc/openrc/conf.d/hostname

    hostname="myhostname"

> Module autoloading

OpenRC doesn't use /etc/modules-load.d/ folder, instead it uses
/etc/openrc/conf.d/modules.

add a line like this to that file :

    modules=acpi_cpufreq

> Locale

There is no built-in support for configuring locales in OpenRC. Though,
you can configure the settings through the /etc/locale.conf file, which
is sourced via /etc/profile.d/locale.sh.

For details on configuring the locale, take a look here.

Troubleshooting
---------------

> Error while unmounting /tmp

When shutting the system down, you might get an error message such as

    * Unmounting /tmp ... 
    * in use but fuser finds nothing [ !! ]

This can be fixed by adding

    no_umounts="/tmp"

to /etc/openrc/conf.d/localmount

Note:This problem occurs only if your tmp is mounted as a tmpfs.

> Disabling IPv6 doesn't work

If you have OpenRC installed under the /etc/openrc sysconf directory.

One fix for this is to put

    # Disable ipv6
    net.ipv6.conf.all.disable_ipv6 = 1

in a file (with a .conf extension) under /etc/openrc/sysctl.d

> During shutdown remounting root as read-only fails

If the above happens, edit the /etc/openrc/init.d/mount-ro file and put:

    telinit u

after the following line:

    # Flush all pending disk writes now
    sync; sync

External Links
--------------

-   Wikipedia:OpenRC
-   Forum thread about OpenRC in Arch

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenRC&oldid=298607"

Category:

-   Boot process

-   This page was last modified on 17 February 2014, at 21:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
