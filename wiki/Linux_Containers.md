Linux Containers
================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Some parts of     
                           this are dated, ideally  
                           this page would be a     
                           summary of container     
                           tools and discuss LXC,   
                           chroot, systemd-nspawn,  
                           and docker + the basics  
                           required to get each     
                           going, with a more       
                           detailed subpage on      
                           each. (Discuss)          
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Introduction
    -   1.1 Synopsis
    -   1.2 About this HowTo
    -   1.3 Less verbose tutorial
    -   1.4 Testing capabilities
-   2 Host configuration
    -   2.1 Control group filesystem
    -   2.2 Userspace tools
    -   2.3 Bridge device setup
    -   2.4 NAT device setup
    -   2.5 Starting a container on boot with Systemd
-   3 Container setup
    -   3.1 Creating the filesystem
        -   3.1.1 Bootstrap
        -   3.1.2 Download existing
        -   3.1.3 Using the lxc tools
    -   3.2 Creating the device nodes
-   4 Container configuration
    -   4.1 Configuration file
        -   4.1.1 Basic settings
            -   4.1.1.1 Basic settings explained
        -   4.1.2 Terminal settings
            -   4.1.2.1 Host Virtual Consoles
            -   4.1.2.2 Local Virtual Consoles
            -   4.1.2.3 /dev/tty Device Files
            -   4.1.2.4 Configuring Log-In Ability
            -   4.1.2.5 Troubleshooting virtual consoles
            -   4.1.2.6 Pseudo Terminals
        -   4.1.3 Host device access settings
            -   4.1.3.1 Host device access settings explained
    -   4.2 Configuration file notes
        -   4.2.1 At runtime /dev/ttyX devices are recreated
        -   4.2.2 Containers have access to host's TTY nodes
            -   4.2.2.1 To access the container from a host TTY
            -   4.2.2.2 To prevent access to the host TTY
            -   4.2.2.3 To test this access
        -   4.2.3 Configuration troubleshooting
            -   4.2.3.1 console access denied: Permission denied
            -   4.2.3.2 lxc-console does not provide a login prompt
    -   4.3 Configuring fstab
-   5 Container Creation and Destruction
    -   5.1 Creation
    -   5.2 Destruction
-   6 Readying the host for virtualization
    -   6.1 /etc/inittab
    -   6.2 /etc/rc.sysinit replacement
    -   6.3 /etc/rc.conf cleanup
    -   6.4 TBC
-   7 Known Problems
    -   7.1 Using systemd inside a docker container results in a
        segfault
    -   7.2 Container cannot be shutdown if using systemd
-   8 See Also

Introduction
------------

> Synopsis

Linux Containers (LXC) are an operating system-level virtualization
method for running multiple isolated server installs (containers) on a
single control host. LXC does not provide a virtual machine, but rather
provides a virtual environment that has its own process and network
space. It is similar to a chroot, but offers much more isolation.

> About this HowTo

This document is intended as an overview on setting up and deploying
containers, and is not an in depth detailed instruction by instruction
guide. A certain amount of prerequisite knowledge and skills are assumed
(running commands as root, kernel configuration, mounting filesystems,
shell scripting, chroot type environments, networking setup, etc).

Much of this was taken verbatim from Dwight Schauer, Tuxce and Ulhume.
It has been copied here both to enable to community to share their
collective wisdom and to expand on a few points.

> Less verbose tutorial

Delerious010 21:43, 1 December 2009 (EST) I have come to realize I have
added a lot of text to this HowTo. If you would like something more
streamlined, please head on over to http://lxc.teegra.net/ for Dwight's
excellent guide.

> Testing capabilities

Once the lxc package is installed, running lxc-checkconfig will print
out a list of your system's capabilities

Host configuration
------------------

> Control group filesystem

LXC depends on the control group filesystem being mounted. The standard
location for it is /sys/fs/cgroup. If you use systemd, the cgroup
filesystem will be mounted automatically, including the default
controllers, but with other initsystems you might have to do it
yourself:

    mount -t tmpfs none /sys/fs/cgroup

> Userspace tools

Install lxc from [community]. For networking, you will probably need
bridge-utils and netctl or openvpn.

> Bridge device setup

The preferred way to setup a Bridge in Arch is with netctl, and is
explained in detail in the article: Bridge_with_netctl. In the config
for your container, just specify the host interface as whatever you name
your bridge (usually br0). You can find a skeleton implementation in
/etc/netctl/examples/bridge.

Alternatively, you can use an OpenVPN Bridge, which is useful if you are
already familiar with or running it.

> NAT device setup

If you don't have a device you can easily bridge (such as a wlan) you
can instead NAT using netctl by using the same
/etc/netctl/examples/bridge with the following changes:

    BindsToInterfaces=()
    IP=static
    Address=192.168.100.1/24
    FwdDelay=0

Remember to copy the example to /etc/netctl and name it whatever you
want. You can use any address range and subnet mask you want for the
interface (make sure is one you are not already using). Once this
interface is up with netctl start <profile> you need to have iptables
put your external interface in masquerade and you need to enable ip
forwarding with sysctl:

    iptables -t nat -A POSTROUTING -o <external interface such as eth0 or wlan0> -j MASQUERADE
    sysctl net.ipv4.ip_forward=1

To have the nat prepared at boot, and to save the iptables and sysctl
states:

    netctl enable <profile>
    iptables-save > /etc/iptables/iptables.rules
    echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.d/40-ip-forward.conf

In your container config file, you will need to assign an IP address:

    lxc.network.ipv4 = 192.168.100.2/24

When you enter your container, you must set the default gateway to the
netctl address, which in this example was 192.168.100.1. In any
container including ip the following command will work:

    ip route add default via 192.168.100.1

Or on distros such as Ubuntu that use /etc/network:

    /etc/network/if-up.d/routes

    #! /bin/sh
    route add default gw 192.168.100.1
    exit 0

> Starting a container on boot with Systemd

If you completed a container, starting it when the host boots is
possible with the following command:

    systemctl enable lxc@CONTAINER_NAME.service

Container setup
---------------

Note Configuring a container that runs systemd requires specific
configuration that is discussed here.

There are various different means to do this

> Creating the filesystem

Bootstrap

Bootstrap an install ( mkarchroot, debootstrap, rinse, Install From
Existing Linux ). You can also just copy/use an existing installation’s
complete root filesystem.

For example, install a small debian to /home/lxc/debianfs

    yaourt -S debootstrap # install debootstrap from AUR

    # method 1:
    sudo debootstrap wheezy /home/lxc/debianfst http://ftp.us.debian.org/debian  # use us mirror site install wheezy version
    # or, method 2:  use faster tar ball method
    sudo debootstrap --make-tarball wheezy.packages.tgz sid http://debian.osuosl.org/debian/
    sudo debootstrap --unpack-tarball wheezy.packages.tgz wheezy debianfs

Download existing

You can download a base install tar ball. OpenVZ templates work just
fine.

Using the lxc tools

    /usr/bin/lxc-debian {create|destroy|purge|help}
    /usr/bin/lxc-fedora {create|destroy|purge|help}

Nowadays you can create small and simple archlinux container

    # lxc-create -n containername -t archlinux -- -P vim,dhclient

with the template specific options -P you can add a list of packages to
the installation.

> Creating the device nodes

Since udev does not work within the container, you will want to make
sure that a certain minimum amount of devices is created for it. This
may be done with the following script:

    #!/bin/bash
    ROOT=$(pwd)
    DEV=${ROOT}/dev
    mv ${DEV} ${DEV}.old
    mkdir -p ${DEV}
    mknod -m 666 ${DEV}/null c 1 3
    mknod -m 666 ${DEV}/zero c 1 5
    mknod -m 666 ${DEV}/random c 1 8
    mknod -m 666 ${DEV}/urandom c 1 9
    mkdir -m 755 ${DEV}/pts
    mkdir -m 1777 ${DEV}/shm
    mknod -m 666 ${DEV}/tty c 5 0
    mknod -m 600 ${DEV}/console c 5 1
    mknod -m 666 ${DEV}/tty0 c 4 0
    mknod -m 666 ${DEV}/full c 1 7
    mknod -m 600 ${DEV}/initctl p
    mknod -m 666 ${DEV}/ptmx c 5 2

Container configuration
-----------------------

> Configuration file

The main configuration files are used to describe how to originally
create a container. Though these files may be located anywhere, /etc/lxc
is probably a good place.

23/Aug/2010: Be aware that the kernel may not handle additional
whitespace in the configuration file. This has been experienced on
"lxc.cgroup.devices.allow" settings but may also be true on other
settings. If in doubt use only one space wherever whitespace is
required.

Basic settings

    lxc.utsname = $CONTAINER_NAME
    lxc.mount = $CONTAINER_FSTAB
    lxc.rootfs = $CONTAINER_ROOTFS
    lxc.network.type = veth
    lxc.network.flags = up
    lxc.network.link = br0
    lxc.network.hwaddr = $CONTAINER_MACADDR 
    lxc.network.ipv4 = $CONTAINER_IPADDR
    lxc.network.name = $CONTAINER_DEVICENAME

Basic settings explained

lxc.utsname : This will be the name of the cgroup for the container.
Once the container is started, you should be able to see a new folder
named /cgroup/$CONTAINER_NAME.

Furthermore, this will also be the value returned by hostname from
within the container. Assuming you have not removed access, the
container may overwrite this with it's init script.

lxc.mount : This points to an fstab formatted file that is a listing of
the mount points used when lxc-start is called. This file is further
explained further

Terminal settings

The following configuration is optional. You may add them to your main
configuration file if you wish to login via lxc-console, or through a
terminal ( e.g.: Ctrl+Alt+F1 ).

The container can be configured with virtual consoles (tty devices).
These may be devices from the host that the container is given
permission to use (by its configuration file) or they may be devices
created locally within the container.

The host's virtual consoles are accessed using the key sequence Alt+Fn
(or Ctrl+Alt+Fn from within an X11 session). The left Alt key reaches
consoles 1 through 12 and the right Alt key reaches consoles 13 through
24. Further virtual consoles may be reached by the Alt+→ key sequence
which steps to the next virtual console.

The container's local virtual consoles may be accessed using the
"lxc-console" command.

Host Virtual Consoles

The container may access the host's virtual consoles if the host is not
using them and the container's configuration allows it. Typical
container configuration would deny access to all devices and then allow
access to specific devices like this:

     lxc.cgroup.devices.deny = a          # Deny all access to devices
     lxc.cgroup.devices.allow = c 4:0 rwm # /dev/tty0
     lxc.cgroup.devices.allow = c 4:1 rwm # /dev/tty1
     lxc.cgroup.devices.allow = c 4:2 rwm # /dev/tty2

For a container to be able to use a host's virtual console it must not
be in use by the host. This will most likely require the host's
/etc/inittab to be modified to ensure no getty or other process runs on
any virtual console that is to be used by the container.

After editing the host's /etc/inittab file, issung a killall -HUP init
will terminate any getty processes that are no longer configured and
this will free up the virtual conosole for use by the container.

Note that local virtual consoles take precedence over host virtual
consoles. This is described in the next section.

Local Virtual Consoles

The number of local virtual consoles that the container has is defined
in the container's configuration file (normally on the host in
/etc/lxc). It is defined thus:

     lxc.tty = n

where n is the number of local virtual consoles required.

The local virtual consoles are numbered starting at tty1 and take
precedence over any of the host's virtual consoles that the container
might be entitled to use. This means that, for example, if n = 2 then
the container will not be able to use the host's tty1 and tty2 devices
even entitled to do so by its configuration file. Setting n to 0 will
prevent local virtual consoles from being created thus allowing full
access to any of host's virtual consoles that the container might be
entitled to use.

/dev/tty Device Files

The container must have a tty device file (e.g. /dev/tty1) for each
virtual console (host or local). These can be created thus:

    # mknod -m 666 /dev/tty1 c 4 1
    # mknod -m 666 /dev/tty2 c 4 2

and so on...

In the above, c means character device, 4 is the major device number
(tty devices) and 1, 2, 3, etc., is the minor device number (specific
tty device). Note that /dev/tty0 is special and always refers to the
current virtual console.

For further info on tty devices, read this:
http://www.kernel.org/pub/linux/docs/device-list/devices.txt

If a virtual console's device file does not exist in the container, then
the container cannot use the virtual console.

Configuring Log-In Ability

The container's virtual consoles may be used for login sessions if the
container runs "getty" services on their tty devices. This is normally
done by the container's "init" process and is configured in the
container's /etc/inittab file using lines like this:

     c1:2345:respawn:/sbin/agetty -8 38400 tty1 linux

There is one line per device. The first part c1 is just a unique label,
the second part defines applicable run levels, the third part tells init
to start a new getty when the current one terminates and the last part
gives the command line for the getty. For further information refer to
man init.

If there is no getty process on a virtual console it will not be
possible to log in via that virtual console. A getty is not required on
a virtual console unless it is to be used to log in.

If a virtual console is to allow root logins it also needs to be listed
in the container's /etc/securetty file.

Troubleshooting virtual consoles

If lxc.tty is set to a number, n, then no host devices numbered n or
below will be accessible even if the above configuration is present
because they will be replaced with local virtual consoles instead.

A tty device file's major number will change from 4 to 136 if it is a
local virtual console. This change is visible within the container but
not when viewing the container's devices from the host's filesystem.
This information is useful when troubleshooting.

This can be checked from within a container thus:

     # ls -Al /dev/tty*
     crw------- 1 root root 136, 10 Aug 21 21:28 /dev/tty1
     crw------- 1 root root   4, 2  Aug 21 21:28 /dev/tty2

Pseudo Terminals

     lxc.pseudo = 1024

Maximum amount of pseudo terminals that may be created in /dev/pts.
Currently, assuming the kernel was compiled with
CONFIG_DEVPTS_MULTIPLE_INSTANCES, this tells lxc-start to mount the
devpts filesystem with the newinstance flag.

Host device access settings

    lxc.cgroup.devices.deny = a # Deny all access to devices
    lxc.cgroup.devices.allow = c 1:3 rwm # dev/null
    lxc.cgroup.devices.allow = c 1:5 rwm # dev/zero
    lxc.cgroup.devices.allow = c 5:1 rwm # dev/console
    lxc.cgroup.devices.allow = c 5:0 rwm # dev/tty
    lxc.cgroup.devices.allow = c 4:0 rwm # dev/tty0
    lxc.cgroup.devices.allow = c 1:9 rwm # dev/urandom
    lxc.cgroup.devices.allow = c 1:8 rwm # dev/random
    lxc.cgroup.devices.allow = c 136:* rwm # dev/pts/*
    lxc.cgroup.devices.allow = c 5:2 rwm # dev/pts/ptmx
    # No idea what this is .. dev/bsg/0:0:0:0 ???
    lxc.cgroup.devices.allow = c 254:0 rwm

Host device access settings explained

lxc.cgroup.devices.deny : By settings this to a, we are stating that the
container has access to no devices unless explicitely defined within the
configuration file.

> Configuration file notes

At runtime /dev/ttyX devices are recreated

If you have enabled multiple DevPTS instances in your kernel, lxc-start
will recreate lxc.tty amount of /dev/ttyX devices when it is executed.

This means that you will have lxc.tty amount of pseudo ttys. If you are
planning on accessing the container via a "real" terminal (Ctrl+Alt+FX),
make sure that it is a number that is inferior to lxc.tty.

To tell whether it has been re-created, just log in to the container via
either lxc-console or SSH and perform a ls -Al command on the tty.
Devices with a major number of 4 are "real" tty devices whereas a major
number of 136 indicates a pts.

Be aware that this is only visible from within the container itself and
not from the host.

Containers have access to host's TTY nodes

If you do not properly restrict the container's access to the /dev/tty
nodes, the container may have access to the host's.

Taking into consideration that, as previously mentioned, lxc-start
recreates lxc.tty amount of /dev/tty devices, any tty nodes present in
the container that are of a greater minor number than lxc.tty will be
linked to the host's.

To access the container from a host TTY

1.  On the host, verify no getty is started for that tty by checking
    /etc/inittab.
2.  In the container, start a getty for that tty.

To prevent access to the host TTY

Please have a look at the configuration statements found in host device
access settings.

Via the lxc.cgroup.devices.deny = a we are preventing access to all host
level devices. And then, throuh lxc.cgroup.devices.allow = c 4:1 rwm we
are allowing access to the host's /dev/tty1. In the above example,
simply removing all allow statements for major number 4 and minor > 1
should be sufficient.

To test this access

I may be off here, but looking at the output of the ls command below
should show you both the major and minor device numbers. These are
located after the user and group and represented as : 4, 2

1.  Set lxc.tty to 1
2.  Make there that the container has dev/tty1 and /dev/tty2
3.  lxc-start the container
4.  lxc-console into the container
5.  ls -Al /dev/tty  
    crw------- 1 root root 4, 2 Dec 2 00:20 /dev/tty2
6.  echo "test output" > /dev/tty2
7.  Ctrl+Alt+F2 to view the host's second terminal
8.  You should see "test output" printed on the screen

Configuration troubleshooting

console access denied: Permission denied

If, when executing lxc-console, you receive the error lxc-console:
console access denied: Permission denied you have most likely either
omitted lxc.tty or set it to 0.

lxc-console does not provide a login prompt

Though you are reaching a tty on the container, it most likely is not
running a getty. You will want to double check that you have a getty
defined in the container's /etc/inittab for the specific tty.

If using systemd chances are that a problem with the getty@.service
script will bite you. The script only starts a getty if /dev/tty0
exists. And since this condition is not met in the container, you get no
getty. Use this patch, to let lxc-console finally work.

    --- /usr/lib/systemd/system/getty@.service.orig 2013-05-30 12:55:28.000000000 +0000
    +++ /usr/lib/systemd/system/getty@.service      2013-06-16 23:05:49.827146901 +0000
    @@ -20,7 +20,8 @@
     # On systems without virtual consoles, don't start any getty. (Note
     # that serial gettys are covered by serial-getty@.service, not this
     # unit
    -ConditionPathExists=/dev/tty0
    +ConditionVirtualization=|lxc
    +ConditionPathExists=|/dev/tty0
     
     [Service]
     # the VT is cleared by TTYVTDisallocate

For more than one getty you have to explicitly enable the needed service
(and decrease lxc.tty in the container configuration). In the real
system a configurable number of getty-services is automatically created
from the systemd-logind.service

> Configuring fstab

    none $CONTAINER_ROOTFS/dev/pts devpts defaults 0 0
    none $CONTAINER_ROOTFS/proc    proc   defaults 0 0
    none $CONTAINER_ROOTFS/sys     sysfs  defaults 0 0
    none $CONTAINER_ROOTFS/dev/shm tmpfs  defaults 0 0

This fstab is used by lxc-start when mounting the container. As such,
you can define any mount that would be possible on the host such as bind
mounting to the host's own filesystem. However, please be aware of any
and all security implications that this may have.

Warning : You certainly do not want to bind mount the host's /dev to the
container as this would allow it to, amongst other things, reboot the
host.

Container Creation and Destruction
----------------------------------

> Creation

    lxc-create -f $CONTAINER_CONFIGPATH -n $CONTAINER_NAME

lxc-create will create
/var/lib/lxc/CONTAINER_NAME with a new copy of the container configuration file found in CONTAINER_CONFIGPATH.

As such, if you need to make modifications to the container's
configuration file, it's advisable to modify only the original file and
then perform lxc-destroy and lxc-create operations afterwards. No data
will be lost by doing this.

Note : When copying the file over, lxc-create will strip all comments
from the file.

Note : As of lxc-git from atleast 2009-12-01, performing lxc-create no
longer splits the config file into multiple files and folders.
Therefore, we only have the configuration file to worry about.

> Destruction

    lxc-destroy -n $CONTAINER_NAME

This will delete /var/lib/lxc/$CONTAINER_NAME which only contains
configuration files. No data will be lost.

Readying the host for virtualization
------------------------------------

> /etc/inittab

1.  Comment out any getty that are not required

> /etc/rc.sysinit replacement

Since we are running in a virtual environment, a number of steps
undertaken by rc.sysinit are superfluous and may even flat out fail or
stall. As such, until the initscripts are made virtualization aware,
this will take some hack and slash.

For now, simply replace the file :

    #!/bin/bash
    # Whatever is needed to clean out old daemon/service pids from your container
    rm -f $(find /var/run -name '*pid')
    rm -f /var/lock/subsys/*
    # Configure network settings
    ## You can either use dhcp here, manually configure your
    ## interfaces or try to get the rc.d/network script working.
    ## There have been reports that network failed in this
    ## environment.
    ip route add default via 192.168.10.1
    echo > /etc/resolv.conf search your-domain
    echo >> /etc/resolv.conf nameserver 192.168.10.1
    # Initally we do not have any container originated mounts
    rm -f /etc/mtab
    touch /etc/mtab

> /etc/rc.conf cleanup

You may want to remove any and all hardware related daemons from the
DAEMONS line. Furthermore, depending on your situation, you may also
want to remove the network daemon.

> TBC

Known Problems
--------------

> Using systemd inside a docker container results in a segfault

See docker github issue, launching /usr/lib/systemd/systemd --system
results in a segfault, last tested with systemd 208-10.

> Container cannot be shutdown if using systemd

lxc-shutdown should be used for clean shutdown or reboot of the
container, but only the reboot is working out of the box when using
systemd.

Shutdown will be signalled to the container with SIGPWR but current
systemd doesn't have any services in place to handle the sigpwr.target.
But for the container we can simply reuse the poweroff.target and get
exactly what we want.

    # ln -s /usr/lib/systemd/system/poweroff.target ${CONTAINER_RFS}/etc/systemd/system/sigpwr.target

See Also
--------

-   Arch systemd container
-   LXC@developerWorks
-   Docker Installation on ArchLinux

Retrieved from
"https://wiki.archlinux.org/index.php?title=Linux_Containers&oldid=305444"

Categories:

-   Security
-   Virtualization

-   This page was last modified on 18 March 2014, at 13:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
