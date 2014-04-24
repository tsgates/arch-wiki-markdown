Virtual Private Server
======================

Related articles

-   Comprehensive Server Guide

From Wikipedia:Virtual private server:

Virtual private server (VPS) is a term used by Internet hosting services
to refer to a virtual machine. The term is used for emphasizing that the
virtual machine, although running in software on the same physical
computer as other customers' virtual machines, is in many respects
functionally equivalent to a separate physical computer, is dedicated to
the individual customer's needs, has the privacy of a separate physical
computer, and can be configured to run server software.

This article discusses the use of Arch Linux on Virtual Private Servers,
and includes some fixes and installation instructions specific to VPSes.

Warning:It appears that systemd does not support Linux 2.6.32 since
systemd-205. Since many container-based virtualization environments rely
on older kernels (the latest OpenVZ runs on a modified RHEL6-2.6.32 for
example), it may be impossible to keep an Arch Linux install up to date.
Most of the instructions regarding OpenVZ on this page were written for
systemd-204 and earlier.

Contents
--------

-   1 Providers that offer Arch Linux
-   2 Installation
    -   2.1 KVM
    -   2.2 OpenVZ
        -   2.2.1 Updating a 2010.05 installation image
        -   2.2.2 Moving your VPS from network configuration in rc.conf
            to netcfg (tested with OpenVZ)
        -   2.2.3 Moving your VPS from initscripts to systemd
    -   2.3 Xen
    -   2.4 Converting OpenStack and Xen components to systemd
-   3 Troubleshooting
    -   3.1 OpenVZ: kernel too old for glibc
    -   3.2 SSH fails: PTY allocation request failed on channel 0

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

A MilesWeb VPS

2013.10.14

OpenVZ

Europe, India, US

Latest Arch Linux available on OpenVZ platform. Quick setup, 24/7
support via Live Chat, Email and Phone. VPS starts from $20 / mo

123 Systems

2010.05.xx

OpenVZ

Dallas, US-TX

Arch available as a selection upon reinstall. Very old (2.6.18-308)
kernel - See OpenVZ troubleshooting. Limited information available
before purchase. Cannot verify Arch Linux version without purchase.

AUSWEB

Latest Only (clarify?)

VMware ESXi

Sydney, AU

Latest ISO (clarify?) of Arch Available. Enterprise Service.

affinity.net.nz

2013.08.01

KVM

Auckland, New Zealand (NZ)

IRC channel is #affinity on ircs.kiwicon.org

Afterburst

2012.12.01

OpenVZ

Miami, US-FL; Nuremberg, DE

Formerly FanaticalVPS, kernel version depends on what node your VPS is
on, the ones in Miami are fine (2.6.32-042stab072.10) but some of the
ones in Germany require a custom glibc.

BuyVM

2013.07.01

KVM

LA, Buffalo NY

Must chose a different OS at sign up. Once accessible, choose to mount
the latest Arch ISO and reboot to install manually.

DigitalOcean

2013.05.xx

KVM

New York, US-NY; San Francisco, US-CA; Amsterdam, AN

Uses a custom kernel. You can run your own kernel with a kexec hack.
Every server uses SSDs by default.

Edis

2013.03.01

vServer, KVM, OpenVZ

Multiple international locations.

Also offer dedicated server options as well as an "off-shore" location
at the Isle of Man (IM).

DirectVPS

2014.01.xx

OpenVZ

Amsterdam, AN; Rotterdam, AN

Dutch language site. Version verifyable by clicking through
https://www.directvps.nl/try-1.plp?p=31

Gandi

2013.10.27

Xen

Paris, FR; Baltimore, MD, US; Bissen, LU

Very granular scaling of system resources (e.g. RAM, disk space);
IPv6-only option available; you can supply your own install image,
version based on keyring package version

GigaTux

2013.06.01

Xen

Chicago, US-IL; Frankfurt, DE; London, GB; San Jose, US-CA

Host Virtual

2011.08.19

KVM

Multiple International Locations

Appears to use KVM virtualization. Site lists "Xen based virtualization"
and features lists ability to install from ISO.

Hostigation

2010.05 i686

OpenVZ, KVM

Charlotte, US-NC; Los Angeles, US-CA

You can migrate to x86_64.

IntoVPS

2012.09.xx

OpenVZ

Amsterdam, NA; Bucharest, RO; Dallas, US-TX; Fremont, US-CA; London, GB

Blog has not been updated since September, 2012 which included the Arch
Linux update.

Leapswitch Networks

[2013.10.xx]

OpenVZ/KVM

USA, India, Portugal, Spain, Ukraine, Germany

ArchLinux currently available in Control Panel for reinstall, not on
order form.

Linode.com

2013.06.xx

OpenVZ

Tokyo, JP; Multiple US; London, GB

To run a custom kernel, install linux-linode. (linux will break on a
32-bit Linode.)

Lylix

2013.xx.xx

Unlisted

Unlisted

Core2Duo and Woodcrest based processors.

Node Deploy

xxxx.xx.xx

OpenVZ, KVM

Germany (DE); Los Angeles, US-CA; Atlanta, US-GA; Phoenix, US-AZ

"At NodeDeploy we support virtually every linux distribution." Arch
Linux is listed under their Operating Systems. No version information.

Netcup

2012.11.xx

KVM

Germany (DE)

German language site.

OnePoundWebHosting

2013.05.xx

Xen PV, Xen HVM

United Kingdom (UK)

They are a registrar too. Unable to verify server locations.

proPlay.de

2012.12.xx

OpenVZ, KVM

Germany (DE)

German language site.

QuickVZ

2013.10

OpenVZ, Xen

Amsterdam, Netherlands (NL); Stockholm, Sweden (SE)

Provide hardened Arch Linux images along with Enterprise services (e,g.
VPN, Virtual Private LAN Service (VPLS) and Virtual Routers.

Rackspace Cloud

2013.6

Xen

Multiple international locations

Billed per hour. Use their "next gen" VPSes (using the
mycloud.rackspace.com panel); the Arch image on the first gen Rackspace
VPSes is out of date.

RamHost.us

2013.05.01

OpenVZ, KVM

Los Angeles, US-CA; Great Britain (GB); Atlanta, US-GA; Germany (DE)

You can request a newer ISO on RamHost's IRC network.

RamNode

2013.07.01

SSD and SSD Cached: OpenVZ, KVM

Seattle, WA USA, Atlanta, GA USA

You can request Host/CPU passthrough with KVM service. Customer service
has been prompt and professional. Regular discount codes can be found
(15-35% off). Modern hardware. Competitive pricing (before discounts).

Tilaa

2013.06.01

KVM

Amsterdam, NL

English or Dutch language site.

TransIP

2013.05.01

KVM

Amsterdam, NL

English language site. Registrar.

XenVZ

2009.12.07

OpenVZ, Xen

United Kingdom (UK), United States (US)

Hardware

Virpus

2013.05.xx

OpenVZ, Xen

Kansas City, US-KS; Los Angeles, US-CA

Vmline

2013.09.01

KVM, OpenVZ

Kraków, PL

S-Net reseller. Full virtualization. Polish language site.

VPSBG.eu

2013.10

OpenVZ

Sofia, Bulgaria

Offshore VPS in Bulgaria - anonymous registrations and Bitcoin are
accepted.

VPS6.NET

2013.01.xx 

OpenVZ, Xen, HVM-ISO

Multiple US; Frankfurt, DE; Bucharest, RO; Istanbul, TR

Registrar.

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

See QEMU#Preparing an (Arch) Linux guest.

> OpenVZ

Updating a 2010.05 installation image

These instructions assume you have a 2010.05 image from your VPS
provider and you would like to get it updated. The biggest work involves
preparing /lib for the symlink upgrade (glibc 2.16, and later filesystem
2013.01).

Warning:If you are on a older kernel than 2.6.32, please refer further
down the page to get the glibc-vps repository working (just add the
repository and you can follow these steps).

To start, grab the latest BusyBox from
http://busybox.net/downloads/binaries/latest/. This allows you to force
glibc (losing /lib temporarily) without losing your OS (BusyBox comes
with its own GNU tools which are statically linked).

    # wget http://busybox.net/downloads/binaries/latest/busybox-i686
    # chmod +x busybox-i686

First, you can get a list of packages that own files in /lib with the
following command:

    $ pacman -Qo /lib/* | cut -d' ' -f 5 | egrep -v 'glibc' | uniq | xargs

For the current 2010.05 that comes from ibiru's page, these are the
packages that were required to be removed for me:

    pacman -S acl attr util-linux-ng bzip2 libcap e2fsprogs libgcrypt libgpg-error udev readline ncurses pam pcre popt procps readline shadow e2fsprogs sysfsutils udev util-linux-ng sysvinit coreutils

You may have to remove /lib/udev/devices/loop0 (a simple rm works).

After the upgrade finishes, you must remove any extra empty directories
in /lib (/lib/modules is the common offender):

    # rm -rf /lib/modules

Install tzdata to fix some dependencies, and remove
/etc/profile.d/locale.sh:

    # pacman -S tzdata
    # rm /etc/profile.d/locale.sh

Remove /var/run (you should have nothing running that matters):

    # rm -rf /var/run

Force glibc, which will pull in the latest filesystem package, but will
BREAK everything (other than BusyBox):

    # pacman -S --force glibc

Now, you will have a broken system, so symlink /usr/lib to /lib with
BusyBox's ln program:

    # ./busybox-i686 ln -s /usr/lib /lib

And you should have a fully functional system where you can now update
pacman.

    # pacman -S pacman
    # pacman-key --init
    # pacman-key --populate archlinux
    # pacman-db-upgrade
    # pacman -Syy

Now, update initscripts to get the iproute2 package:

    # pacman -S initscripts

Install the makedev package:

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

    # pacman -Syu

You may run into some issues with krb5 and heimdal, as krb5 no longer
provides+conflicts+replaces heimdal
(https://projects.archlinux.org/svntogit/packages.git/commit/trunk/PKGBUILD?h=packages/krb5&id=f5e6d77fd14ced15ebf5b6a78a7c76e0db0625f7).
The old openssh depends on heimdal (and the new openssh depends on
krb5), so force install krb5, then upgrade openssh, then remove heimdal
and reinstall krb5.

    # pacman -S --force krb5
    # pacman -S openssh openssl
    # pacman -R heimdal
    # pacman -S krb5

Fix syslog-ng. Set the src to unix-dgram("/dev/log") and add --no-caps
to both check and run args in /etc/conf.d/syslog-ng.

Make sure your /etc/rc.conf is not messed up with broken network
definitions, or else be sure serial access works on your VPS before you
reboot.

Moving your VPS from network configuration in rc.conf to netcfg (tested with OpenVZ)

1) Install netcfg

    pacman -S netcfg

2) Create a netcfg configuration file /etc/network.d/venet

    CONNECTION='ethernet'
    DESCRIPTION='VPS venet connection'
    INTERFACE='venet0'
    IP='static'
    IPCFG=(
    #default
    'addr add 127.0.0.1/32 broadcast 0.0.0.0 dev venet0'
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

> Converting OpenStack and Xen components to systemd

There are three components that need to be enabled in systemd when using
a VPS based on OpenStack/Xen, such as Rackspace NextGen Cloud. The
current version of xe-guest-utilities contains two of these:
xe-linux-distribution and xe-daemon.

You will need to create a custom service file for the OpenStack
nova-agent, as the current version 0.0.1.37 only comes with a sysvinit
start-up script.

    /etc/systemd/system/nova-agent.service

    [Unit]
    Description=nova-agent service
    After=xe-daemon.service

    [Service]
    Environment=LD_LIBRARY_PATH=/usr/share/nova-agent/0.0.1.37/lib
    ExecStart=usr/bin/nova-agent -n -l info /usr/share/nova-agent/nova-agent.py

    [Install]
    WantedBy=multi-user.target

Once these steps are done, you can continue with converting the server
from sysvinit to systemd.

Make sure to enable the following services:

    # systemctl enable xe-linux-distribution
    # systemctl enable xe-daemon
    # systemctl enable nova-agent

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

Note:For installs that have not been updated to glibc-2.16, it will save
you lots of time and prevent major breakage to do:

    pacman -U https://dev.archlinux.org/~ibiru/openvz/glibc-vps/i686/glibc-2.16.0-101-i686.pkg.tar.xz

or

    pacman -U https://dev.archlinux.org/~ibiru/openvz/glibc-vps/x86_64/glibc-2.16.0-101-x86_64.pkg.tar.xz

Add a single -d if needed. The instructions below assume that this has
been done.

Following similar instructions from DeveloperWiki:usrlib.

Try doing the following to fix it:

1) Edit /etc/pacman.conf and add the following repository ABOVE [core]:

For 32-bit:

    [glibc-vps]
    Server = https://dev.archlinux.org/~ibiru/openvz/glibc-vps/i686

For 64-bit:

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

    # mv /etc/pacman.conf.pacnew /etc/pacman.conf

6) Upgrade your whole system with new packages again pacman -Syu

If you get the following error or a similar error:

    initscripts: /etc/profile.d/locale.sh exists in filesystem

Simply delete that file (e.g., rm -f /etc/profile.d/locale.sh), then run
pacman -Syu again.

If you get the following error or a similar error:

    filesystem: /etc/mtab exists in filesystem

Run pacman -S filesystem --force

If you get the following error or a similar error:

    libusb-compat: /usr/bin/libusb-config exists in filesystem

Run pacman -S libusb and then pacman -S libusb-compat

7) Before rebooting, you need to install the makedev package from the
official repositories by running pacman -S makedev.

8) Add MAKEDEV to /etc/rc.local:

    /usr/sbin/MAKEDEV tty
    /usr/sbin/MAKEDEV pty

9) Edit /etc/inittab, comment out the following lines; otherwise, you
will see errors in /var/log/errors.log):

    #c1:2345:respawn:/sbin/agetty -8 -s 38400 tty1 linux
    #c2:2345:respawn:/sbin/agetty -8 -s 38400 tty2 linux
    #c3:2345:respawn:/sbin/agetty -8 -s 38400 tty3 linux
    #c4:2345:respawn:/sbin/agetty -8 -s 38400 tty4 linux
    #c5:2345:respawn:/sbin/agetty -8 -s 38400 tty5 linux
    #c6:2345:respawn:/sbin/agetty -8 -s 38400 tty6 linux

10) To enable use of the hostname command, install the package inetutils
from the official repositories.

11) Remove disabling of the SysRq key and setup of core dump pattern
because this is blocked by OpenVZ and causes errors.

Because sysctl does not use /etc/sysctl.conf any more[1], you must
transfer all settings to /etc/sysctl.d/99-sysctl.conf (or any other file
in /etc/sysctl.d/; however, do not transfer the following line:

    kernel.sysrq = 0

Edit /usr/lib/sysctl.d/coredump.conf and comment out the following line:

    #kernel.core_pattern=|/usr/lib/systemd/systemd-coredump %p %u %g %s %t %e

12) Save and reboot.

Enjoy & thank ioni if you happen to be in #archlinux

> SSH fails: PTY allocation request failed on channel 0

Some VPSes have an outdated /etc/rc.sysinit. You may be able to log in
via serial console or with the following command:

    $ ssh root@broken.server '/bin/bash -i'

Then run the following:

    # mv /etc/rc.sysinit.pacnew /etc/rc.sysinit
    # reboot

Once it is working, you should be able to comment out the udevd_modprobe
line in /etc/rc.sysinit to save a bit of RAM the next time you reboot.

If the above does not work, take a look at this guide.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Virtual_Private_Server&oldid=305760"

Categories:

-   Getting and installing Arch
-   Virtualization

-   This page was last modified on 20 March 2014, at 02:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
