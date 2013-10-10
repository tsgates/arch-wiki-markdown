NFS Troubleshooting
===================

> Summary

Dedicated article for common problems and solutions.

> Related

NFS - Main NFS article.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Server-side Issues                                                 |
|     -   1.1 exportfs: /etc/exports:2: syntax error: bad option list      |
|     -   1.2 Group/gid permissions issues                                 |
|     -   1.3 "Permission denied" when trying to write files               |
|                                                                          |
| -   2 Client-side Issues                                                 |
|     -   2.1 mount.nfs4: No such device                                   |
|     -   2.2 mount.nfs4: access denied by server while mounting           |
|     -   2.3 Unable to connect from OS X clients                          |
|     -   2.4 Unreliable connection from OS X clients                      |
|     -   2.5 Lock problems                                                |
|                                                                          |
| -   3 Performance Issues                                                 |
|     -   3.1 Diagnose the problem                                         |
|     -   3.2 Server Threads                                               |
|     -   3.3 Close-to-Open / Flush-on-Close                               |
|         -   3.3.1 The nocto mount option                                 |
|         -   3.3.2 The async export option                                |
|                                                                          |
|     -   3.4 Buffer Cache Size and MTU                                    |
|                                                                          |
| -   4 Other Issues                                                       |
|     -   4.1 Permissions Issues                                           |
+--------------------------------------------------------------------------+

Server-side Issues
==================

exportfs: /etc/exports:2: syntax error: bad option list
-------------------------------------------------------

Delete all space from the option list in /etc/exports

Group/gid permissions issues
----------------------------

If NFS shares mount fine, and are fully accessible to the owner, but not
to group members; check the number of groups that user belongs to. NFS
has a limit of 16 on the number of groups a user can belong to. If you
have users with more then this, you need to enable the --manage-gids
start-up flag for rpc.mountd on the NFS server.

    /etc/conf.d/nfs-server.conf

    # Options for rpc.mountd.
    # If you have a port-based firewall, you might want to set up
    # a fixed port here using the --port option.
    # See rpc.mountd(8) for more details.

    MOUNTD_OPTS="--manage-gids"

"Permission denied" when trying to write files
----------------------------------------------

-   If you need to mount shares as root, and have full r/w access from
    the client, add the no_root_squash option to the export in
    /etc/exports:

        /var/cache/pacman/pkg 192.168.1.0/24(rw,no_subtree_check,no_root_squash)

Client-side Issues
==================

mount.nfs4: No such device
--------------------------

Check that you have loaded the nfs module

    lsmod | grep nfs

and if previous returns empty or only nfsd-stuff, do

    modprobe nfs

mount.nfs4: access denied by server while mounting
--------------------------------------------------

Check that the permissions on your client's folder are correct. Try
using 755.

Unable to connect from OS X clients
-----------------------------------

When trying to connect from a OS X client, you will see that everything
is ok at logs, but MacOS X refuses to mount your NFS share. You have to
add insecure option to your share and re-run exportfs -r.

Unreliable connection from OS X clients
---------------------------------------

OS X's NFS client is optimized for OS X Servers and might present some
issues with Linux servers. If you are experiencing slow performance,
frequent disconnects and problems with international characters edit the
default mount options by adding the line
nfs.client.mount.options = intr,locallocks,nfc to /etc/nfs.conf on your
Mac client. More information about the mount options can be found here.

Lock problems
-------------

If you got error such as this:

    mount.nfs: rpc.statd is not running but is required for remote locking.
    mount.nfs: Either use '-o nolock' to keep locks local, or start statd.
    mount.nfs: an incorrect mount option was specified

To fix this, you need to change the "NEED_STATD" value in
/etc/conf.d/nfs-common.conf to YES.

Remember to start all the required services (see NFS or NFSv3), not just
the nfs service.

Performance Issues
==================

This NFS Howto page has some useful information regarding performance.
Here are some further tips:

Diagnose the problem
--------------------

-   Htop should be your first port of call. The most obvious symptom
    will be a maxed-out CPU.
-   Press F2, and under "Display options", enable "Detailed CPU time".
    Press F1 for an explanation of the colours used in the CPU bars. In
    particular, is the CPU spending most of its time responding to IRQs,
    or in Wait-IO (wio)?

Server Threads
--------------

Symptoms: Nothing seems to be very heavily loaded, but some operations
on the client take a long time to complete for no apparent reason.

If your workload involves lots of small reads and writes (or if there
are a lot of clients), there may not be enough threads running on the
server to handle the quantity of queries. To check if this is the case,
run the following command on one or more of the clients:

    # nfsstat -rc
    Client rpc stats:
    calls      retrans    authrefrsh
    113482     0          113484

If the retrans column contains a number larger than 0, the server is
failing to respond to some NFS requests, and the number of threads
should be increased.

To increase the number of threads on the server, edit the file
/etc/conf.d/nfs-server.conf and change the value of the NFSD_COUNT
variable. The default number of threads is 8. Try doubling this number
until retrans remains consistently at zero. Don't be afraid of
increasing the number quite substantially. 256 threads may be quite
reasonable, depending on the workload. You will need to restart the NFS
server daemon each time you modify the configuration file. Bear in mind
that the client statistics will only be reset to zero when the client is
rebooted.

Use htop (disable the hiding of kernel threads) to keep an eye on how
much work each nfsd thread is doing. If you reach a point where the
retrans values are non-zero, but you can see nfsd threads on the server
doing no work, something different is now causing your bottleneck, and
you'll need to re-diagnose this new problem.

Close-to-Open / Flush-on-Close
------------------------------

Symptoms: Your clients are writing many small files. The server CPU is
not maxed out, but there is very high wait-IO, and the server disk seems
to be churning more than you might expect.

In order to ensure data consistency across clients, the NFS protocol
requires that the client's cache is flushed (all data is pushed to the
server) whenever a file is closed after writing. Because the server is
not allowed to buffer disk writes (if it crashes, the client won't
realise the data wasn't written properly), the data is written to disk
immediately before the client's request is completed. When you're
writing lots of small files from the client, this means that the server
spends most of its time waiting for small files to be written to its
disk, which can cause a significant reduction in throughput.

See this excellent article or the nfs manpage for more details on the
close-to-open policy. There are several approaches to solving this
problem:

> The nocto mount option

Note:The linux kernel doesn't seem to honour this option properly. Files
are still flushed when they're closed.

Does your situation match these conditions?

-   The export you have mounted on the client is only going to be used
    by the one client.
-   It doesn't matter too much if a file written on one client doesn't
    immediately appear on other clients.
-   It doesn't matter if after a client has written a file, and the
    client thinks the file has been saved, and then the client crashes,
    the file may be lost.

If you're happy with the above conditions, you can use the nocto mount
option, which will disable the close-to-open behaviour. See the nfs
manpage for details.

> The async export option

Does your situation match these conditions?

-   It's important that when a file is closed after writing on one
    client, it is:
    -   Immediately visible on all the other clients.
    -   Safely stored on the server, even if the client crashes
        immediately after closing the file.

-   It's not important to you that if the server crashes:
    -   You may loose the files that were most recently written by
        clients.
    -   When the server is restarted, the clients will believe their
        recent files exist, even though they were actually lost.

In this situation, you can use async instead of sync in the server's
/etc/exports file for those specific exports. See the exports manpage
for details. In this case, it does not make sense to use the nocto mount
option on the client.

Buffer Cache Size and MTU
-------------------------

Symptoms: High kernel or IRQ CPU usage, a very high packet count through
the network card.

This is a trickier optimisation. Make sure this is definitely the
problem before spending too much time on this. The default values are
usually fine for most situations.

See this excellent article for information about I/O buffering in NFS.
Essentially, data is accumulated into buffers before being sent. The
size of the buffer will affect the way data is transmitted over the
network. The Maximum Transmission Unit (MTU) of the network equipment
will also affect throughput, as the buffers need to be split into
MTU-sized chunks before they're sent over the network. If your buffer
size is too big, the kernel or hardware may spend too much time
splitting it into MTU-sized chunks. If the buffer size is too small,
there will be overhead involved in sending a very large number of small
packets. You can use the rsize and wsize mount options on the client to
alter the buffer cache size. To achieve the best throughput, you need to
experiment and discover the best values for your setup.

It is possible to change the MTU of many network cards. If your clients
are on a separate subnet (e.g. for a Beowulf cluster), it may be safe to
configure all of the network cards to use a high MTU. This should be
done in very-high-bandwidth environments.

See also the nfs manpage for more about rsize and wsize.

Other Issues
============

Permissions Issues
------------------

If you find that you cannot set the permissions on files properly, make
sure the user/group you are chowning are on both the client and server.

If all your files are owned by nobody, and you are using NFSv4, on both
the client and server, you should:

-   For initscripts, ensure that NEED_IDMAPD is set to YES in
    /etc/conf.d/nfs-common.conf.
-   For systemd, ensure that the rpc-idmapd service has been started.

Retrieved from
"https://wiki.archlinux.org/index.php?title=NFS_Troubleshooting&oldid=247992"

Category:

-   Networking
