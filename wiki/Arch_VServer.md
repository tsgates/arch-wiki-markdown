Arch VServer
============

This article aims to provide all necessary information regarding the
creation of a vserver host as well as vserver guests running Arch Linux.
This will enable you to setup virtual servers that provide different
services as if they were on different machines, with a very little
overhead. You can get more information about virtual servers here.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preparing the Host                                                 |
| -   2 Paths of Interest                                                  |
| -   3 Preparing the Guests                                               |
|     -   3.1 Preparing the guest installation media                       |
|         -   3.1.1 Optional: Base variables to follow along with the      |
|             steps                                                        |
|         -   3.1.2 Optional: Preparing the guest disk                     |
|         -   3.1.3 Optional: Link the host and guest pacman cache         |
|         -   3.1.4 Prepare Vserver                                        |
|         -   3.1.5 Prepare the guest's filesystem                         |
|         -   3.1.6 Install the base system                                |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 Viewing output from vserver $GuestName start / stop          |
|     -   4.2 SSH will not start                                           |
|     -   4.3 SSH immediately terminates the connection                    |
|                                                                          |
| -   5 Tips & Trick                                                       |
|     -   5.1 Network via dummy adapters                                   |
|                                                                          |
| -   6 More Resources                                                     |
+--------------------------------------------------------------------------+

Preparing the Host
==================

To prepare the vserver host environment, you will need to install both a
vserver patched kernel, the vserver utilities and their dependencies
which are located in the AUR. The required packages are dietlibc,
beecrypt, kernel26-vserver (not found or linux-vserver orphan), and
util-vserver

Paths of Interest
=================

/etc/vservers : configuration root ( reference )

/etc/vservers/.defaults : configuration skeleton used when building new
guests

/etc/vservers/.defaults/vdirbase : symlink to the folder containing
vserver guests. This defaults to /vservers.

/etc/vservers/<guest name> : guest specific configurations

Preparing the Guests
====================

Vserver will launch guests from subfolders of
/etc/vservers/.defaults/vdirbase. As such, creating a new guest system
is as simple as installing the required packages in a folder of the
host. Furthermore, there's nothing stopping you ( and quite a few things
encouraging you ) to mount filesystems to the subfolders of vdirbase and
installing your guest in there.

If you plan on doing this often, I highly recommend that you write
yourself a little batch script since most of these steps can be
automated quite easily.

Preparing the guest installation media
--------------------------------------

NOTE : This is all heavily inspired from Install From Existing Linux and
will therefore be quite brief when not mentioning Vserver specific
steps.

> Optional: Base variables to follow along with the steps

    GuestName= # Name of the guest
    GuestRoot=/etc/vservers/.defaults/vdirbase/$GuestName
    GuestPackages= # Listing of packages to install via pacman
    GuestDisk= # Installation target device
    GuestNetDevice= # ex.: eth0, dummy0, etc...
    GuestIP= # I think you get it
    GuestContext= # Unique identifier for the guest, I go with the last part of the IP

> Optional: Preparing the guest disk

1.  Create a LVM Physical Volume, a Volume Group and a Logical Volume (
    wiki:LVM )
2.  Create a filesystem on the lvm volume
3.  mkdir $GuestRoot
4.  mount /dev/$GuestDisk $GuestRoot

> Optional: Link the host and guest pacman cache

1.  mkdir $GuestRoot/var/cache/pacman/pkg
2.  mount -o bind /var/cache/pacman/pkg $GuestRoot/var/cache/pacman/pkg

> Prepare Vserver

1.  vserver $GuestName -m skeleton --context $GuestContext --interface
    $GuestNetDevice:$GuestIP --flags
    lock,virt_mem,virt_uptime,virt_cpu,virt_load,sched_hard,hide_netif
    --initstyle plain
2.  (optional) cd /etc/vservers/$GuestName/interfaces
3.  (optional) cp -r 0 1
4.  (optional) echo 'lo' > dev
5.  (optional) echo '127.0.0.$GuestContext' > ip

> Prepare the guest's filesystem

1.  Prepare guest filesystem for the pacman db
    1.  mkdir -p /newarch/var/lib/pacman

> Install the base system

NOTE : To save some time, it's probably a good idea to create a text
file containing all the packages to install and call it via "pacman -S
`cat $GuestPackages` -r $GuestRoot" instead of the following :

1.  pacman -S base -r $GuestRoot
2.  Optional: If you want to chroot into the newly created guest so as
    to install new packages, it might be a good idea to mount a few
    filesystems required by some packages.
    1.  Bind /dev, /proc, /sys to the corresponding directories in
        $GuestRoot

3.  Modify guest configuration files to enable a smoother boot process
    1.  Modify /etc/rc.shutdown by removing anything
        hardware/clock/mount related. This includes most everything
        under Saving Random Seed'.
    2.  Modify /etc/rc.sysinit by anything hardware/clock/mount related.
    3.  Modify /etc/syslog-ng.conf by removing file("/proc/kmsg")

Troubleshooting
===============

Viewing output from vserver $GuestName start / stop
---------------------------------------------------

NOTE : For me, this only worked in the actual consoles, not in X.

1.  Make sure that the device /dev/console exists in the guest
    1.  If it does not, cp -a /dev/console $GuestRoot/dev/

SSH will not start
------------------

I noticed that /dev/null did not always get created properly in my first
experimentations. Therefore I did a quick :

1.  cp -a /dev/null $GuestRoot/dev
2.  cp -a /dev/zero $GuestRoot/dev

Furthermore, if you're not using the dummy network driver and are
attaching to the host's network interface, you'll want to configure the
ListenAddress statement of /etc/ssh/sshd_config so that it binds only to
the guest's IP address as opposed to 127.0.0.1.

SSH immediately terminates the connection
-----------------------------------------

On my machine, SSH used to authenticate me correctly and log me in, but
then immediately drop the connection without an explanation. Consulting
/var/log/auth.log revealed the following:

    sshd[17899]: pam_limits(sshd:session): Could not set limit for 'nice': Operation not permitted

This is easily fixed by commenting all nice related lines in
/etc/security/limits.conf.

Tips & Trick
============

Network via dummy adapters
--------------------------

Here, you're either using the dummy module to create virtual network
adapters or created interface aliases via /usr/sbin/ip. I went for the
former and configured the host as such :

1.  /etc/sysctl.conf : net.ipv4.ip_forward=1  

Modify or add that statement to enable routing on the host

1.  /etc/rc.local  

    modprobe dummy numdummies=$NumberOfGuests
    ip link set dev dummy$GuestContext name $GuestName

This provides me with dummy interfaces that I can route / firewall that
are all named the same as my guests... yay.

More Resources
==============

Problematic Programs  
 Make BSD style init SYSV compatible  
 Vserver tutorial  
 linux-vserver.org's Installation on ArchLinux  
 linux-verserver.org's networking tutorial  

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_VServer&oldid=253579"

Category:

-   Virtualization
