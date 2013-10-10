NFS
===

> Summary

Article covers configuration of NFSv4 which is an open standard network
file sharing protocol.

> Related

NFS Troubleshooting - Dedicated article for common problems and
solutions.

NFSv3 - Deprecated v3 format.

From Wikipedia:

Network File System (NFS) is a distributed file system protocol
originally developed by Sun Microsystems in 1984, allowing a user on a
client computer to access files over a network in a manner similar to
how local storage is accessed.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 Configuration                                                      |
|     -   2.1 Server                                                       |
|         -   2.1.1 ID mapping                                             |
|         -   2.1.2 File system                                            |
|         -   2.1.3 Exports                                                |
|         -   2.1.4 Starting the server                                    |
|                                                                          |
|     -   2.2 Client                                                       |
|         -   2.2.1 Mounting from Linux                                    |
|             -   2.2.1.1 /etc/fstab Settings                              |
|             -   2.2.1.2 Using autofs                                     |
|                                                                          |
|         -   2.2.2 Mounting from Windows                                  |
|         -   2.2.3 Mounting from OS X                                     |
|                                                                          |
| -   3 Troubleshooting                                                    |
+--------------------------------------------------------------------------+

Installing
----------

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

    # exportfs -ra

Starting the server

Start/enable rpc-idmapd.service and rpc-mountd.service. Note that these
units require other services, which are launched automatically by
systemd.

> Client

Clients need nfs-utils to connect, but no special setup is required when
connecting to NFS 4 servers.

Mounting from Linux

Show the server's exported filesystems:

    $ showmount -e servername

Then mount omitting the server's NFS export root:

    # mount -t nfs4 servername:/music /mountpoint/on/client

/etc/fstab Settings

Using fstab is useful for a server which is always on, and the NFS
shares are available whenever the client boots up. Edit /etc/fstab file,
and add an appropriate line reflecting the setup. Again, the server's
NFS export root is omitted.

    /etc/fstab

    servername:/music   /mountpoint/on/client   nfs4   rsize=8192,wsize=8192,timeo=14,intr,_netdev	0 0

Note:Additional mount options can be specified here. Consult the NFS man
page for further information.

Some additional mount options to consider are include:

-   rsize=8192 and wsize=8192
-   timeo=14
-   intr
-   _netdev

The rsize value is the number of bytes used when reading from the
server. The wsize value is the number of bytes used when writing to the
server. The default for both is 1024, but using higher values such as
8192 can improve throughput. This is not universal. It is recommended to
test after making this change.

The timeo value is the amount of time, in tenths of a second, to wait
before resending a transmission after an RPC timeout. After the first
timeout, the timeout value is doubled for each retry for a maximum of 60
seconds or until a major timeout occurs. If connecting to a slow server
or over a busy network, better performance can be achieved by increasing
this timeout value.

The intr option allows signals to interrupt the file operation if a
major timeout occurs for a hard-mounted share.

The _netdev option tells the system to wait until the network is up
before trying to mount the share. systemd assumes this for NFS, but
anyway it's good practice to use it for all types of networked
filesystems

Using autofs

Using autofs is useful when multiple machines want to connect via NFS;
they could both be clients as well as servers. The reason this method is
preferable over the earlier one is that if the server is switched off,
the client will not throw errors about being unable to find NFS shares.
See autofs#NFS Network mounts for details.

Mounting from Windows

Note:Only the Ultimate and Enterprise editions of Windows 7 and the
Enterprise edition of Windows 8 include "Client for NFS".

NFS shares can be mounted from Windows if the "Client for NFS" service
is activated (which it is not by default). To install the service go to
"Programs and features" in the Control Panel and click on "Turn Windows
features on or off". Locate "Services for NFS" and activate it as well
as both subservices ("Administrative tools" and "Client for NFS").

Some global options can be set by opening the "Services for Network File
System" (locate it with the search box) and right click on
client->properties.

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

    # sudo mount -t nfs -o resvport servername:/srv/nfs4 /Volumes/servername

Troubleshooting
---------------

There is a dedicated article NFS Troubleshooting.

Retrieved from
"https://wiki.archlinux.org/index.php?title=NFS&oldid=255551"

Category:

-   Networking
