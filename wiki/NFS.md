NFS
===

Related articles

-   NFS Troubleshooting

From Wikipedia:

Network File System (NFS) is a distributed file system protocol
originally developed by Sun Microsystems in 1984, allowing a user on a
client computer to access files over a network in a manner similar to
how local storage is accessed.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Server
        -   2.1.1 ID mapping
        -   2.1.2 File system
        -   2.1.3 Exports
        -   2.1.4 Starting the server
        -   2.1.5 Firewall configuration
    -   2.2 Client
        -   2.2.1 Mounting from Linux
            -   2.2.1.1 using /etc/fstab
            -   2.2.1.2 Using autofs
        -   2.2.2 Mounting from Windows
        -   2.2.3 Mounting from OS X
-   3 Tips and tricks
    -   3.1 Performance tuning
    -   3.2 Automatic mount handling
        -   3.2.1 NetworkManager dispatcher
    -   3.3 Configure NFS fixed ports
-   4 Troubleshooting
-   5 See also

Installation
------------

Both client and server only require the installation of the nfs-utils
package.

Note:It is HIGHLY recommended to use a time sync daemon on ALL nodes of
your network to keep client/server clocks in sync. Without accurate
clocks on all nodes, NFS can introduce unwanted delays! The NTP system
is recommended to sync both the server and the clients to the highly
accurate NTP servers available on the Internet.

Configuration
-------------

> Server

ID mapping

Edit /etc/idmapd.conf and set the Domain field to your domain name.

    /etc/idmapd.conf

    [General]
     
    Verbosity = 1
    Pipefs-Directory = /var/lib/nfs/rpc_pipefs
    Domain = atomic

    [Mapping]

    Nobody-User = nobody
    Nobody-Group = nobody

File system

Note:For security reasons, it is recommended to use an NFS export root
which will keep users limited to that mount point only. The following
example illustrates this concept.

Define any NFS shares in /etc/exports which are relative to the NFS
root. In this example, the NFS root will be /srv/nfs4 and we will be
sharing /mnt/music.

    # mkdir -p /srv/nfs4/music

Read/Write permissions must be set on the music directory so clients may
write to it.

Now mount the actual target share, /mnt/music to the NFS share via the
mount command:

    # mount --bind /mnt/music /srv/nfs4/music

To make it stick across server reboots, add the bind mount to fstab:

    /etc/fstab

    /mnt/music /srv/nfs4/music  none   bind   0   0

Exports

Add directories to be shared and an ip address or hostname(s) of client
machines that will be allowed to mount them in exports:

    /etc/exports

    /srv/nfs4/ 192.168.0.1/24(rw,fsid=root,no_subtree_check)
    /srv/nfs4/music 192.168.0.1/24(rw,no_subtree_check,nohide) # note the nohide option which is applied to mounted directories on the file system.

Users need-not open the share to the entire subnet; one can specify a
single IP address or hostname as well.

For more information about all available options see man 5 exports.

If you modify /etc/exports while the server is running, you must
re-export them for changes to take effect:

    # exportfs -rav

Starting the server

Start rpc-idmapd.service and rpc-mountd.service using systemd. If you
want them running at boot time, enable them. Note that these units
require other services, which are launched automatically by systemd.

Firewall configuration

To enable access through a firewall, tcp and udp ports 111, 2049, and
20048 need to be opened. To configure this for iptables, edit
/etc/iptables/iptables.rules to include the following lines:

    /etc/iptables/iptables.rules

    -A INPUT -p tcp -m tcp --dport 111 -j ACCEPT
    -A INPUT -p tcp -m tcp --dport 2049 -j ACCEPT
    -A INPUT -p tcp -m tcp --dport 20048 -j ACCEPT
    -A INPUT -p udp -m udp --dport 111 -j ACCEPT
    -A INPUT -p udp -m udp --dport 2049 -j ACCEPT
    -A INPUT -p udp -m udp --dport 20048 -j ACCEPT

To apply changes, restart iptables service.

> Client

Clients with a kernel version prior to 3.12.7-2 need to start
rpc-gssd.service to avoid an approx 15 seconds delay with an
accompanying error in dmesg that reads, "RPC: AUTH_GSS upcall timed out"
due to a kernel bug.

Note:The server does not need to run this service.

Warning:Starting this service without having it configured properly will
result in error messages like:

    rpc.gssd[30473]: ERROR: Key table file '/etc/krb5.keytab' not found while beginning keytab scan for keytab 'FILE:/etc/krb5.keytab'
    rpc.gssd[30473]: ERROR: gssd_refresh_krb5_machine_credential: no usable keytab entry found in keytab /etc/krb5.keytab for connection with host server.domain
    rpc.gssd[30473]: ERROR: No credentials found for connection to server server.domain

and might lock up any NFS mount on the system when mounting and
unmounting some mounts very often.

An alternative is to blacklist the module rpcsec_gss_krb5 and rebooting
afterwards:

    # echo "blacklist rpcsec_gss_krb5" > /etc/modprobe.d/rpcsec_gss_krb5-blacklist.conf
    # reboot

as described on Red Hat's Bugzilla.

Mounting from Linux

Show the server's exported file systems:

    $ showmount -e servername

Then mount omitting the server's NFS export root:

    # mount -t nfs4 servername:/music /mountpoint/on/client

Note:Server name needs to be a valid hostname (not just IP address).
Otherwise mounting of remote share will hang.

using /etc/fstab

Using fstab is useful for a server which is always on, and the NFS
shares are available whenever the client boots up. Edit /etc/fstab file,
and add an appropriate line reflecting the setup. Again, the server's
NFS export root is omitted.

    /etc/fstab

    servername:/music   /mountpoint/on/client   nfs4   rsize=8192,wsize=8192,timeo=14,intr,_netdev	0 0

Note:Consult the NFS and mount man pages for more mount options.

Some additional mount options to consider are include:

 rsize and wsize
    The rsize value is the number of bytes used when reading from the
    server. The wsize value is the number of bytes used when writing to
    the server. The default for both is 1024, but using higher values
    such as 8192 can improve throughput. This is not universal. It is
    recommended to test after making this change, see #Performance
    tuning.

 timeo
    The timeo value is the amount of time, in tenths of a second, to
    wait before resending a transmission after an RPC timeout. After the
    first timeout, the timeout value is doubled for each retry for a
    maximum of 60 seconds or until a major timeout occurs. If connecting
    to a slow server or over a busy network, better performance can be
    achieved by increasing this timeout value.

 intr
    The intr option allows signals to interrupt the file operation if a
    major timeout occurs for a hard-mounted share.

 _netdev
    The _netdev option tells the system to wait until the network is up
    before trying to mount the share. systemd assumes this for NFS, but
    anyway it is good practice to use it for all types of networked file
    systems

Note:Setting the sixth field (fs_passno) to a nonzero value may lead to
unexpected behaviour, e.g. hangs when the systemd automount waits for a
check which will never happen.

Using autofs

Using autofs is useful when multiple machines want to connect via NFS;
they could both be clients as well as servers. The reason this method is
preferable over the earlier one is that if the server is switched off,
the client will not throw errors about being unable to find NFS shares.
See autofs#NFS network mounts for details.

Mounting from Windows

Note:Only the Ultimate and Enterprise editions of Windows 7 and the
Enterprise edition of Windows 8 include "Client for NFS".

NFS shares can be mounted from Windows if the "Client for NFS" service
is activated (which it is not by default). To install the service go to
"Programs and features" in the Control Panel and click on "Turn Windows
features on or off". Locate "Services for NFS" and activate it as well
as both subservices ("Administrative tools" and "Client for NFS").

Some global options can be set by opening the "Services for Network File
System" (locate it with the search box) and right click on client >
properties.

Warning:Serious performance issues may occur (it randomly takes 30-60
seconds to display a folder, 2 MB/s file copy speed on gigabit LAN, ...)
to which Microsoft does not have a solution yet.[1]

To mount a share using Explorer:

Computer > Map network drive > servername:/srv/nfs4/music

Mounting from OS X

Note:OS X by default uses an insecure (>1024) port to mount a share.

Either export the share with the insecure flag, and mount using Finder:

Go > Connect to Server > nfs://servername/

Or, mount the share using a secure port using the terminal:

    # mount -t nfs -o resvport servername:/srv/nfs4 /Volumes/servername

Tips and tricks
---------------

> Performance tuning

In order to get the most out of NFS, it is necessary to tune the rsize
and wsize mount options to meet the requirements of the network
configuration.

> Automatic mount handling

This trick is useful for laptops that require nfs shares from a local
wireless network. If the nfs host becomes unreachable, the nfs share
will be unmounted to hopefully prevent system hangs when using the hard
mount option. See
https://bbs.archlinux.org/viewtopic.php?pid=1260240#p1260240

Make sure that the NFS mount points are correctly indicated in
/etc/fstab:

    $ cat /etc/fstab

    lithium:/mnt/data           /mnt/data	        nfs noauto,noatime,rsize=32768,wsize=32768,intr,hard 0 0
    lithium:/var/cache/pacman   /var/cache/pacman	nfs noauto,noatime,rsize=32768,wsize=32768,intr,hard 0 0

The noauto mount option tells systemd not to automatically mount the
shares at boot. systemd would otherwise attempt to mount the nfs shares
that may or may not exist on the network causing the boot process to
appear to stall on a blank screen.

In order to mount NFS share by non-root user user may be required to be
added to fstab entry. Also enable rpc-statd.service.

Create the auto_share script that will be used by cron to check if the
NFS host is reachable,

    /root/bin/auto_share

    #!/bin/bash

    SERVER="YOUR_NFS_HOST"

    MOUNT_POINTS=$(sed -e '/^.*#/d' -e '/^.*:/!d' -e 's/\t/ /g' /etc/fstab | tr -s " " | cut -f2 -d" ")

    ping -c 1 "${SERVER}" &>/dev/null

    if [ $? -ne 0 ]; then
        # The server could not be reached, unmount the shares
        for umntpnt in ${MOUNT_POINTS}; do
            umount -l -f $umntpnt &>/dev/null
        done
    else
        # The server is up, make sure the shares are mounted
        for mntpnt in ${MOUNT_POINTS}; do
            mountpoint -q $mntpnt || mount $mntpnt
        done
    fi

    # chmod +x /root/bin/auto_share

Create the root cron entry to run auto_share every minute:

    # crontab -e

    * * * * * /root/bin/auto_share

A systemd unit file can also be used to mount the NFS shares at startup.
The unit file is not necessary if NetworkManager is installed and
configured on the client system. See #NetworkManager dispatcher.

    /etc/systemd/system/auto_share.service

    [Unit]
    Description=NFS automount

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/root/bin/auto_share

    [Install]
    WantedBy=multi-user.target

Now enable auto_share.

NetworkManager dispatcher

In addition to the method described previously, NetworkManager can also
be configured to run a script on network status change.

Enable and start the NetworkManager-dispatcher service.

The easiest method for mount shares on network status change is to just
symlink to the auto_share script:

    # ln -s /root/bin/auto_share /etc/NetworkManager/dispatcher.d/30_nfs.sh

Or use the following mounting script that checks for network
availability:

    /etc/NetworkManager/dispatcher.d/30_nfs.sh

    #!/bin/bash

    SSID="CHANGE_ME"

    MOUNT_POINTS=$(sed -e '/^.*#/d' -e '/^.*:/!d' -e 's/\t/ /g' /etc/fstab | tr -s " " | cut -f2 -d" ")

    ISNETUP=$(nmcli dev wifi | \grep $SSID | tr -s ' ' | cut -f 10 -d ' ') 2>/dev/null

    # echo "$ISNETUP" >> /tmp/nm_dispatch_log

    if [[ "$ISNETUP" == "yes" ]]; then
        for mntpnt in ${MOUNT_POINTS}; do
            mountpoint -q $mntpnt || mount $mntpnt
        done
    else
        for srvexp in ${MOUNT_POINTS}; do
            umount -l -f $srvexp &>/dev/null
        done
    fi

Now when the wireless SSID "CHANGE_ME" goes up or down, the nfs.sh
script will be called to mount or unmount the shares as soon as
possible.

> Configure NFS fixed ports

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: This section was 
                           originally refered to    
                           NFS version 3. (Discuss) 
  ------------------------ ------------------------ ------------------------

If you have a port-based firewall, you might want to set up a fixed
ports. For rpc.statd and rpc.mountd you should set following settings in
/etc/conf.d/nfs-common and /etc/conf.d/nfs-server (ports can be
different):

    /etc/conf.d/nfs-common

    STATD_OPTS="-p 4000 -o 4003"

    /etc/conf.d/nfs-server

    MOUNTD_OPTS="--no-nfs-version 2 -p 4002"

    /etc/modprobe.d/lockd.conf

    # Static ports for NFS lockd
    options lockd nlm_udpport=4001 nlm_tcpport=4001

After restart nfs-common nfs-server daemons and reload lockd modules you
can check used ports with following command:

    $ rpcinfo -p

       program vers proto   port  service
        100000    4   tcp    111  portmapper
        100000    3   tcp    111  portmapper
        100000    2   tcp    111  portmapper
        100000    4   udp    111  portmapper
        100000    3   udp    111  portmapper
        100000    2   udp    111  portmapper
        100024    1   udp   4000  status
        100024    1   tcp   4000  status
        100021    1   udp   4001  nlockmgr
        100021    3   udp   4001  nlockmgr
        100021    4   udp   4001  nlockmgr
        100021    1   tcp   4001  nlockmgr
        100021    3   tcp   4001  nlockmgr
        100021    4   tcp   4001  nlockmgr
        100003    2   tcp   2049  nfs
        100003    3   tcp   2049  nfs
        100003    4   tcp   2049  nfs
        100003    2   udp   2049  nfs
        100003    3   udp   2049  nfs
        100003    4   udp   2049  nfs
        100005    3   udp   4002  mountd
        100005    3   tcp   4002  mountd

Then, you need to open the ports 111-2049-4000-4001-4002-4003 TCP and
UDP.

Troubleshooting
---------------

There is a dedicated article NFS Troubleshooting.

See also
--------

-   See also Avahi, a Zeroconf implementation which allows automatic
    discovery of NFS shares.
-   HOWTO: Diskless network boot NFS root
-   NFS Performance Management
-   If you are setting up the Arch Linux NFS server for use by Windows
    clients through Microsoft's SFU, you will save a lot of time and
    hair-scratching by looking at this forum post first !
-   Microsoft Services for Unix NFS Client info
-   Unix interoperability and Windows Vista Prerequisites to connect to
    NFS with Vista

Retrieved from
"https://wiki.archlinux.org/index.php?title=NFS&oldid=304090"

Categories:

-   File systems
-   Networking

-   This page was last modified on 12 March 2014, at 03:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
