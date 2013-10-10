Virtual Private Server
======================

> Summary

This article discusses the use of Arch Linux on Virtual Private Servers,
and includes some fixes and installation instructions specific to VPSes.

> Related

Comprehensive Server Guide

From Wikipedia:Virtual private server:

Virtual private server (VPS) is a term used by Internet hosting services
to refer to a virtual machine. The term is used for emphasizing that the
virtual machine, although running in software on the same physical
computer as other customers' virtual machines, is in many respects
functionally equivalent to a separate physical computer, is dedicated to
the individual customer's needs, has the privacy of a separate physical
computer, and can be configured to run server software.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Providers that offer Arch Linux                                    |
| -   2 Installation                                                       |
|     -   2.1 KVM                                                          |
|     -   2.2 OpenVZ                                                       |
|         -   2.2.1 Getting a 2010.05 Image Up To Date                     |
|         -   2.2.2 Moving your VPS from network configuration in rc.conf  |
|             to netcfg (tested with OpenVZ)                               |
|         -   2.2.3 Moving your VPS from initscripts to systemd            |
|                                                                          |
|     -   2.3 Xen                                                          |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 OpenVZ: kernel too old for glibc                             |
|     -   3.2 SSH fails: PTY allocation request failed on channel 0        |
+--------------------------------------------------------------------------+

Providers that offer Arch Linux
-------------------------------

Warning:We cannot vouch for the honesty or quality of any provider.
Please conduct due diligence before ordering.

Note:This list is for providers with a convenient Arch Linux image.
Using Arch on other providers is probably possible, but would require
loading custom ISOs or disk images or installing under chroot.

Provider

Arch Release

Virtualization

Locations

Notes

123 Systems

2010.05 i686/x86_64

OpenVZ

Dallas, TX

Arch available as a selection upon reinstall. Very old (2.6.18-308)
kernel - See OpenVZ troubleshooting.

Afterburst

2012.12.01 i686/x86_64

OpenVZ

Miami (USA), Falkenstein (Germany)

Formerly FanaticalVPS, kernel version depends on what node your VPS is
on, the ones in Miami are fine (2.6.32-042stab072.10) but some of the
ones in Germany require a custom glibc.

AlienVPS

2010.05

Xen, KVM

Los Angeles, New York

Clodo.ru

2011.??

Xen

Moscow

Can pay per hour. Lists an invalid release version of the installer.

Edis

2011.08 i686/x86_64

vServer, KVM

Austria, Chile, Germany, France, Hong Kong, Italy, Iceland, Poland,
Sweden, Switzerland, Spain, UK, USA

EOReality

(?) i686/x86_64

OpenVZ

Chicago

Need to use special glibc-vps repo for this provider . See OpenVZ
troubleshooting for instructions. You will also need to remove heimdal.

DirectVPS

2012.09 x86_64

Xen

Amsterdam, Rotterdam

Generation-Host

2012.07

Xen

Chicago IL, Clifton NJ and Toronto ON Canada

GigaTux

2011.08 x86_64

Xen

Chicago, Frankfurt, Israel, London, San Jose

Host Virtual

2011.08

Xen

Amsterdam, Chennai (Madras), Chicago, Dallas, Hong Kong, London, Los
Angeles, New York, Paris, Reston, San Jose

Hostigation

2010.05 i686

OpenVZ, KVM

Charlotte, Los Angeles

You can migrate to x86_64.

IntoVPS

2012.05 i686/x86_64

OpenVZ

Amsterdam, Bucharest, Dallas, Fremont, London

Linode.com

2012.07

Xen

Atlanta, Dallas, Fremont, London, Newark, Tokyo

Uses a custom kernel; do not install the linux package.

Lylix

2007.08

 ?

 ?

Node Deploy

 ?

OpenVZ, KVM

LA, Germany

unmanaged, solusvm server manager

Netcup

2011.10 x86_64/2012.11 x86_64

vServer, KVM

Germany

OnePoundWebHosting

2012.09 x86_64

Xen

UK

OpenVZ.ca

2010.05 i686/x86_64

OpenVZ

Canada

proPlay.de

2011.10 i686/x86_64

OpenVZ, KVM

Germany

Rackspace Cloud

2012.08

Xen

Chicago, Dallas, London

Billed per hour.

RamHost.us

2012.12

OpenVZ, KVM

Atlanta, England, Germany, Los Angeles

You can request a newer iso on IRC.

Tilaa

2012.12 i686/x86_64

KVM

Amsterdam

TransIP

2013.01.04

KVM

Amsterdam

XenVZ

2009.12 x86_64

OpenVZ, Xen

UK?

Virpus

2010.05 x86_64

OpenVZ, Xen

Kansas City

Vmline

2012.08.04-dual.iso

Xen-HVM

Poland - Kraków

S-Net reseller. It's probably imposible to install i686 due to lack of
xen_netfront and xen_blkfront modules

VPS6.NET

2010.05 i686/x86_64 OpenVZ, 2012.01 x86_64 Xen

OpenVZ, Xen

Germany, Romania, Turkey, USA

UK2.net

2010.05 i686/x86_64

Xen

United Kingdom

Appears to use a custom kernel; do not install the linux package.

Installation
------------

> KVM

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Are there        
                           instructions specific to 
                           VPSes? (Discuss)         
  ------------------------ ------------------------ ------------------------

See KVM#Preparing an (Arch) Linux guest.

> OpenVZ

Getting a 2010.05 Image Up To Date

These instructions you have a 2010.05 image from your VPS provider and
you'd like to get it up to scratch. The biggest work involves preparing
/lib for the symlink upgrade (glibc 2.16, and later filesystem 2013.01).

Warning:If you are on a older kernel than 2.6.32, please refer further
down the page to get the glibc-vps repo working (just add the repo and
you can follow these steps).

To start, grab the latest busybox from
http://busybox.net/downloads/binaries/latest/. This allows you to force
glibc (losing /lib temporarily) without losing your OS (busybox comes
with its own GNU tools which are statically linked).

    wget http://busybox.net/downloads/binaries/latest/busybox-i686
    chmod +x busybox-i686

First off you can get a list of packages that own files in /lib with the
following command:

    pacman -Qo /lib/* | cut -d' ' -f 5 | egrep -v 'glibc' | uniq | xargs

For the current 2010.05 that comes straight off of ibiru's page, these
are the packages that were required to be removed for me:

    pacman -S acl attr util-linux-ng bzip2 libcap e2fsprogs libgcrypt libgpg-error udev readline ncurses pam pcre popt procps readline shadow e2fsprogs sysfsutils udev util-linux-ng sysvinit coreutils

You may have to remove /lib/udev/devices/loop0 (a simple rm works).

After the upgrade finishes, you must remove any extra empty directories
in /lib (/lib/modules is the common offender):

    rm -rf /lib/modules

Install tzdata to fix some dependencies and remove
/etc/profile.d/locale.sh:

    pacman -S tzdata
    rm /etc/profile.d/locale.sh

Remove /var/run (you should have nothing running that matters):

    rm -rf /var/run

Force glibc (this will pull in the latest filesystem, but BREAK
everything (other than busybox)):

    pacman -S --force glibc

Now you will have a broken system, so first thing symlink /usr/lib to
/lib with busybox's ln:

    ./busybox-i686 ln -s /usr/lib /lib

And you should have a fully functional system where you can now update
pacman.

    pacman -S pacman; pacman-key --init; pacman-key --populate archlinux; pacman-db-upgrade; pacman -Syy

Now, update initscripts to get iproute2:

    pacman -S iniscripts

Install makedev:

    pacman -S makedev

Add the following to your /etc/rc.local:

    /usr/sbin/MAKEDEV tty
    /usr/sbin/MAKEDEV pty

Comment the following lines in /etc/inittab:

    #c1:2345:respawn:/sbin/agetty -8 -s 38400 tty1 linux
    #c2:2345:respawn:/sbin/agetty -8 -s 38400 tty2 linux
    #c3:2345:respawn:/sbin/agetty -8 -s 38400 tty3 linux
    #c4:2345:respawn:/sbin/agetty -8 -s 38400 tty4 linux
    #c5:2345:respawn:/sbin/agetty -8 -s 38400 tty5 linux
    #c6:2345:respawn:/sbin/agetty -8 -s 38400 tty6 linux

Finally, you should be able to upgrade the whole system:

    pacman -Su

You may run into some issues with krb5 and heimdal, as krb5 no longer
provides+conflicts+replaces heimdal
(https://projects.archlinux.org/svntogit/packages.git/commit/trunk/PKGBUILD?h=packages/krb5&id=f5e6d77fd14ced15ebf5b6a78a7c76e0db0625f7).
The old openssh depends on heimdal (and the new openssh depends on
krb5), so force install krb5, then upgrade openssh, then remove heimdal
and reinstall krb5.

    pacman -S --force krb5
    pacman -S openssh openssl
    pacman -R heimdal
    pacman -S krb5

Fix syslog-ng (set the src to unix-dgram("/dev/log") and add --no-caps
to both check and run args in /etc/conf.d/syslog-ng).

Make sure your rc.conf isn't messed up with broken network definitions,
or else be sure serial access works on your VPS before you reboot.

  

Moving your VPS from network configuration in rc.conf to netcfg (tested with OpenVZ)

1) Install netcfg

    pacman -S netcfg

2) Create a netcfg configuration file /etc/network.d/venet

    CONNECTION='ethernet'
    DESCRIPTION='VPS venet connection'
    INTERFACE='venet0'
    IP='static'
    IPCFG=(
    #IPv4 address
    'addr add xxx.xxx.xxx.xxx/32 broadcast 0.0.0.0 dev venet0'
    #IPv4 route
    'route add default dev venet0'
    #IPv6 address
    'addr add xxxx:xx:xx::x/128 dev venet0'
    #IPv6 route
    '-6 route add default dev venet0'
    )
    DNS=('xxx.xxx.xxx.xxx' 'xxx.xxx.xxx.xxx')

3) Edit your netcfg main conf file /etc/conf.d/netcfg

    NETWORKS=(venet)
    WIRED_INTERFACE="venet0"

4) Try your new setup

    rc.d stop network && ip addr flush venet0 && netcfg venet

Your VPS should still be connected and have its IP addresses set
correctly. (Check with ip a)

DO NOT proceed to next step if this isn't the case.

5) Make your new setup survive reboots

In the DAEMONS array in /etc/rc.conf, replace network with net-profiles.

Remove all networking information that is in /etc/rc.conf.

    reboot

Moving your VPS from initscripts to systemd

Warning:This has been known to work with OpenVZ on the 2.6.32 kernel,
but systemd may not work on older kernels.

This is very similar to a regular arch system, except you probably don't
have access to your kernel line.

1) Move from network in rc.conf to netcfg (see above).

2) Install systemd

    pacman -S systemd

2 bonus for OpenVZ) Remove kernel core dump pattern since this is
blocked by OpenVZ and causes errors

Edit /usr/lib/sysctl.d/coredump.conf, comment out the following line:

    #kernel.core_pattern=|/usr/lib/systemd/systemd-coredump %p %u %g %s %t %e

3) Move all configuration from /etc/rc.conf (except the DAEMONS array)
to its appropriate location.

See Native configuration and rc.conf for details.

Now your /etc/rc.conf should only contain the DAEMONS array.

4) Install systemd-sysvcompat

    pacman -S systemd-sysvcompat

It will ask to replace sysvinit, say yes.

    reboot

5) Move daemons from the DAEMONS array in /etc/rc.conf to systemd

See the guide and the daemons list.

If your DAEMONS array is now empty, skip next step.

6) Moving rc.d daemons with no systemd support, example: vzquota

Create a custom systemd service file for vzquota:
/etc/systemd/system/newvzquota.service:

    [Unit]
    Description=Setup vzquota on VPS
    ConditionFileIsExecutable=/etc/rc.d/vzquota

    [Service]
    Type=oneshot
    ExecStart=/etc/rc.d/vzquota start
    ExecStop=/etc/rc.d/vzquota stop
    TimeoutSec=0
    StandardInput=tty
    RemainAfterExit=yes

    [Install]
    WantedBy=multi-user.target

Note:It is recommended to choose a .service file name that is different
from the name of the daemon, because systemd might try to call the
LEGACY scripts with the old name.

Enable this service:

    systemctl enable newvzquota.service

Remove vzquota from the DAEMONS array in /etc/rc.conf

Repeat this step to remove all daemons from /etc/rc.conf.

7) Removing /etc/rc.local and /etc/rc.local.shutdown

Write custom .service files to replace functionality in /etc/rc.local
and /etc/rc.local.shutdown. You can take a look at
/usr/lib/systemd/system/rc-local.service and
/usr/lib/systemd/system/rc-local-shutdown.service for inspiration.

8) Removing initscripts

Your /etc/rc.conf file must look like this:

    DAEMONS=()

and /etc/rc.local and /etc/rc.local.shutdown must now be empty.

Uninstall initscripts

    pacman -R initscripts

    reboot

> Xen

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Are there        
                           instructions specific to 
                           VPSes? (Discuss)         
  ------------------------ ------------------------ ------------------------

See Xen#Arch as Xen guest (PVHVM mode) and/or Xen#Arch as Xen guest (PV
mode).

Troubleshooting
---------------

> OpenVZ: kernel too old for glibc

Are you on a virtual private server (VPS) with an old kernel & broke
your system? Are you using OpenVZ?

Check your kernel version with:

    uname -r

If your kernel is older than 2.6.32, you will need a custom version of
glibc (because of dependencies in glibc).

Arch Template Used:
https://dev.archlinux.org/~ibiru/openvz/2010.05/arch-2010.05-i686-minimal.tar.gz

Note:for installs that have not been updated to glibc-2.16, it will save
you lots of time and prevent major breakage to do:

    pacman -U https://dev.archlinux.org/~ibiru/openvz/glibc-vps/i686/glibc-2.16.0-101-i686.pkg.tar.xz

or

    pacman -U https://dev.archlinux.org/~ibiru/openvz/glibc-vps/x86_64/glibc-2.16.0-101-x86_64.pkg.tar.xz

Add a single "-d" if needed. The instructions below assume that this has
been done.

  
 Following similar instructions from DeveloperWiki:usrlib.

Try doing the following to fix it:

1) Edit /etc/pacman.conf and add the following repository ABOVE [core]:

for 32-bit:

    [glibc-vps]
    Server = https://dev.archlinux.org/~ibiru/openvz/glibc-vps/i686

for 64-bit:

    [glibc-vps]
    Server = https://dev.archlinux.org/~ibiru/openvz/glibc-vps/x86_64

2) Then run pacman -Syy followed by pacman -Syu. You will be notified to
upgrade pacman first.

3) Upgrade the pacman database by running pacman-db-upgrade as root.

4) Edit /etc/pacman.conf.pacnew (new pacman config file) and add the
following repository ABOVE [core]:

    [glibc-vps]
    Server = https://dev.archlinux.org/~ibiru/openvz/glibc-vps/$arch

5) Replace /etc/pacman.conf with /etc/pacman.conf.pacnew (run as root):

    mv /etc/pacman.conf.pacnew /etc/pacman.conf

6) Upgrade your whole system with new packages again pacman -Syu

If you get the following or similar error:

    initscripts: /etc/profile.d/locale.sh exists in filesystem

Simply delete that file (e.g., rm -f /etc/profile.d/locale.sh), then run
pacman -Syu again.

  
 If you get the following or similar error:

    filesystem: /etc/mtab exists in filesystem

Run pacman -S filesystem --force

  
 If you get the following or similar error:

    libusb-compat: /usr/bin/libusb-config exists in filesystem

Run pacman -S libusb and then pacman -S libusb-compat

7) Before rebooting, you need to install the makedev package by running
pacman -S makedev.

8) Add MAKEDEV to /etc/rc.local:

    /usr/sbin/MAKEDEV tty
    /usr/sbin/MAKEDEV pty

9) Edit /etc/inittab, comment out the following lines (otherwise you
will see errors in /var/log/errors.log):

    #c1:2345:respawn:/sbin/agetty -8 -s 38400 tty1 linux
    #c2:2345:respawn:/sbin/agetty -8 -s 38400 tty2 linux
    #c3:2345:respawn:/sbin/agetty -8 -s 38400 tty3 linux
    #c4:2345:respawn:/sbin/agetty -8 -s 38400 tty4 linux
    #c5:2345:respawn:/sbin/agetty -8 -s 38400 tty5 linux
    #c6:2345:respawn:/sbin/agetty -8 -s 38400 tty6 linux

10) To enable the use of the hostname command, install the package
inetutils from the official repositories.

11) Remove disabling of SysRq key and setup of core dump pattern since
this is blocked by OpenVZ and causes errors

Edit /etc/sysctl.conf, comment out the following line:

    #kernel.sysrq = 0

Edit /usr/lib/sysctl.d/coredump.conf, comment out the following line:

    #kernel.core_pattern=|/usr/lib/systemd/systemd-coredump %p %u %g %s %t %e

12) Save and reboot.

Enjoy & thank ioni if you happen to be in #archlinux

> SSH fails: PTY allocation request failed on channel 0

Some VPSes have an outdated rc.sysinit. You may be able to login via
serial console or with

    > ssh root@broken.server '/bin/bash -i'

Then run the following:

    # mv /etc/rc.sysinit.pacnew /etc/rc.sysinit
    # reboot

Once it’s working, you should be able to comment out the udevd_modprobe
line in rc.sysinit to save a bit of RAM the next time you reboot.

If the above doesn’t work, take a look at
http://fsk141.com/fix-pty-allocation-request-failed-on-channel-0.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Virtual_Private_Server&oldid=252913"

Categories:

-   Getting and installing Arch
-   Virtualization
