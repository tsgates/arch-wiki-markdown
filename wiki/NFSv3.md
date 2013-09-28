NFSv3
=====

Note:this article covers NFSv3, for the current version 4 see NFS

The goal of this article is to assist in setting up an nfs-server for
sharing files over a network.

-   nfs-utils has been upgraded since 2009-06-23, and NFS4 support is
    now implemented. Refer to the news bulletin.
-   portmap has been replaced by rpcbind.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Required packages                                                  |
| -   2 Setting up the server                                              |
|     -   2.1 Files                                                        |
|         -   2.1.1 /etc/exports                                           |
|         -   2.1.2 /etc/conf.d/nfs-common.conf                            |
|                                                                          |
|     -   2.2 Daemons                                                      |
|     -   2.3 systemd services                                             |
|                                                                          |
| -   3 Setting up the client                                              |
|     -   3.1 Files                                                        |
|         -   3.1.1 /etc/conf.d/nfs-common.conf                            |
|         -   3.1.2 /etc/request-key.conf                                  |
|                                                                          |
|     -   3.2 Daemons                                                      |
|     -   3.3 systemd services                                             |
|     -   3.4 Mounting                                                     |
|     -   3.5 Auto-mount on boot                                           |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 mount.nfs: Operation not permitted                           |
|                                                                          |
| -   5 Tips and tricks                                                    |
|     -   5.1 Configure NFS fixed ports                                    |
|                                                                          |
| -   6 Links and references                                               |
+--------------------------------------------------------------------------+

Required packages
-----------------

Required packages for both the server and the client are minimal. You
will only need to install the nfs-utils package from the official
repositories. Optionally, install the keyutils package to use the
keyring based idmapper on the NFS client.

Setting up the server
---------------------

You can now edit your configuration and then start the daemons.

Note:It is HIGHLY recommended to use a time sync daemon on ALL nodes of
your network to keep client/server clocks in sync. Without accurate
clocks on all nodes, NFS can introduce unwanted delays! Seemingly random
"Device or Resource busy" messages when operating on shares might be
caused by clocks that are out of sync.

  

> Files

/etc/exports

This file defines the various shares on the nfs server and their
permissions. A few examples:

    /files *(ro,sync) # Read-only access to anyone
    /files 192.168.0.100(rw,sync) # Read-write access to a client on 192.168.0.100
    /files 192.168.1.1/24(rw,sync) #  Read-write access to all clients from 192.168.1.1 to 192.168.1.255
    /bsd   *(ro,sync,insecure) #  BSD clients require insecure as otherwise connections will be rejected by the client

If you make changes to /etc/exports after starting the daemons, you can
make them effective by issuing the following command:

    # exportfs -r

If you decide to make your NFS share public and writable, you can use
the all_squash option in combination with anonuid and the anongid
option. For example, to set the privileges for the user nobody in the
group nobody, you can do the following:

    ; Read-write access to a client on 192.168.0.100, with rw access for the user 99 with gid 99
    /files 192.168.0.100(rw,sync,all_squash,anonuid=99,anongid=99))

This also means, that if you want write access to this directory,
nobody.nobody must be the owner of the share directory:

    # chown -R nobody.nobody /files

Full details on the exports file are provided by the exports man page.

/etc/conf.d/nfs-common.conf

Note:This used to be in /etc/conf.d/nfs which is replaced by
"/etc/conf.d/nfs-common.conf" and "/etc/conf.d/nfs-server.conf".

Edit this file to pass appropriate run-time options to nfsd, mountd,
statd, and sm-notify. The default Arch NFS init scripts require the
--no-notify option for statd, as follows:

    STATD_OPTS="--no-notify"

Others may be left at the provided defaults, or changed according to
your requirements. Please refer to the relevant man pages for full
details.

> Daemons

You can now start the server with the following commands:

    # rc.d start rpcbind (or: rc.d start portmap)
    # rc.d start nfs-common (or: rc.d start nfslock)
    # rc.d start nfs-server (or: rc.d start nfsd)

Please note that they must be started in that order. To start the server
at boot time, add these daemons to the DAEMONS array in /etc/rc.conf. It
may be necessary to start the daemons as root / using sudo when you
start them from the terminal.

Note:One or more of the daemons may not start if they are backgrounded
in your /etc/rc.conf.

> systemd services

    # systemctl enable rpc-mountd.service rpc-statd.service

If you have trouble getting NFS working, you may want to consider
forcing the NFS daemon module to load:

    # echo nfsd > /etc/modules-load.d/nfsd.conf

Setting up the client
---------------------

> Files

/etc/conf.d/nfs-common.conf

Edit this file to pass appropriate run-time options to statd - the
remaining options are for server use only. Do not use the --no-notify
option on the client side, unless you are fully aware of the
consequences of doing so.

Please refer to the statd man page for full details.

/etc/request-key.conf

Kernels after 2.6.37 support using request-key to find and cache
idmapper entries. Using request-key allows multiple idmap requests to be
placed at a single time, making it significantly more scalable than the
legacy code.

Please refer to the nfsidmap page for full details.

> Daemons

Start the rpcbind and nfs-common daemons:

    rc.d start rpcbind (or: rc.d start portmap)
    rc.d start nfs-common (or: rc.d start nfslock)

Please note that they must be started in that order.

To start the daemons at boot time, add them to the DAEMONS array in
/etc/rc.conf.

> systemd services

    # systemctl enable rpc-statd.service

> Mounting

Show the server's exported filesystems:

    showmount -e server

Then just mount as normal:

    mount server:/files /files

Unlike CIFS shares or rsync, NFS exports must be called by the full path
on the server; example, if /home/fred/music is defined in /etc/exports
on server ELROND, you must call:

    mount ELROND:/home/fred/music /mnt/point

instead of just using:

    mount ELROND:music /mnt/point

or you will get mount.nfs: access denied by server while mounting

Note:If you see the following message then you probably did not start
the daemons from the previous section or something went wrong while
starting them.

    mount: wrong fs type, bad option, bad superblock on 192.168.1.99:/media/raid5-4tb,
           missing codepage or helper program, or other error
           (for several filesystems (e.g. nfs, cifs) you might
           need a /sbin/mount.<type> helper program)
           In some cases useful info is found in syslog - try
           dmesg | tail  or so

> Auto-mount on boot

If you want to mount on boot, make sure network, rpcbind (portmap),
nfs-common (nfslock) and netfs are in the DAEMONS array in /etc/rc.conf.
Make sure the order is this one. It is better not to put any '@' in
front of them (although you could safely use @netfs); for instance:

    DAEMONS=(... network rpcbind nfs-common @netfs ...)

or

    DAEMONS=(... network portmap nfslock @netfs ...)

Add an appropriate line in /etc/fstab, for example:

    server:/files /files nfs defaults 0 0

If you wish to specify a packet size for read and write packets, specify
them in your fstab entry. The values listed below are the defaults if
none are specified:

    server:/files /files nfs rsize=32768,wsize=32768 0 0

Read the nfs man page for further information, including all available
mount options.

Troubleshooting
---------------

Note:See dedicated article: NFS Troubleshooting.

> mount.nfs: Operation not permitted

After updating to nfs-utils 1.2.1-2, mounting NFS shares stopped
working. Henceforth, nfs-utils uses NFSv4 per default instead of NFSv3.
The problem can be solved by using either mount option 'vers=3' or
'nfsvers=3' on the command line:

    # mount.nfs <remote target> <directory> -o ...,vers=3,...
    # mount.nfs <remote target> <directory> -o ...,nfsvers=3,...

or in /etc/fstab:

    <remote target> <directory> nfs ...,vers=3,... 0 0
    <remote target> <directory> nfs ...,nfsvers=3,... 0 0

Tips and tricks
---------------

> Configure NFS fixed ports

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

Then you need restart nfs daemons and reload lockd module:

    # modprobe -r lockd 
    # modprobe lockd 
    # rc.d restart nfs-common nfs-server

After restart nfs daemons and reload modules you can check used ports
with following command:

    $ rpcinfo -p

    rpcinfo -p
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

Then, you need to open the ports 111-2049-4000-4001-4002-4003 tcp and
udp.

Links and references
--------------------

-   See also Avahi, a Zeroconf implementation which allows automatic
    discovery of NFS shares.
-   HOWTO: Diskless network boot NFS root
-   Very helpful
-   If you are setting up the Archlinux NFS server for use by Windows
    clients through Microsoft's SFU, you will save a lot of time and
    hair-scratching by looking at this forum post first !
-   Microsoft Services for Unix NFS Client info
-   Unix interoperability and Windows Vista Prerequisites to connect to
    NFS with Vista

Retrieved from
"https://wiki.archlinux.org/index.php?title=NFSv3&oldid=239749"

Categories:

-   File systems
-   Networking
