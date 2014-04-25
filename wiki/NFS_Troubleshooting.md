NFS Troubleshooting
===================

Summary help replacing me

Dedicated article for common problems and solutions.

> Related

NFS - Main NFS article.

Contents
--------

-   1 Server-side issues
    -   1.1 exportfs: /etc/exports:2: syntax error: bad option list
    -   1.2 Group/GID permissions issues
    -   1.3 "Permission denied" when trying to write files
-   2 Client-side issues
    -   2.1 mount.nfs4: No such device
    -   2.2 mount.nfs4: access denied by server while mounting
    -   2.3 Unable to connect from OS X clients
    -   2.4 Unreliable connection from OS X clients
    -   2.5 Lock problems
    -   2.6 mount.nfs: Operation not permitted
-   3 Performance issues
    -   3.1 Diagnose the problem
    -   3.2 Server threads
    -   3.3 Close-to-open/flush-on-close
        -   3.3.1 The nocto mount option
        -   3.3.2 The async export option
    -   3.4 Buffer cache size and MTU
-   4 Other issues
    -   4.1 Permissions issues

Server-side issues
------------------

> exportfs: /etc/exports:2: syntax error: bad option list

Delete all space from the option list in /etc/exports

> Group/GID permissions issues

If NFS shares mount fine, and are fully accessible to the owner, but not
to group members; check the number of groups that user belongs to. NFS
has a limit of 16 on the number of groups a user can belong to. If you
have users with more than this, you need to enable the --manage-gids
start-up flag for rpc.mountd on the NFS server.

    /etc/conf.d/nfs-server.conf

    # Options for rpc.mountd.
    # If you have a port-based firewall, you might want to set up
    # a fixed port here using the --port option.
    # See rpc.mountd(8) for more details.

    MOUNTD_OPTS="--manage-gids"

> "Permission denied" when trying to write files

-   If you need to mount shares as root, and have full r/w access from
    the client, add the no_root_squash option to the export in
    /etc/exports:

    /var/cache/pacman/pkg 192.168.1.0/24(rw,no_subtree_check,no_root_squash)

Client-side issues
------------------

> mount.nfs4: No such device

Check that you have loaded the nfs module

    lsmod | grep nfs

and if previous returns empty or only nfsd-stuff, do

    # modprobe nfs

> mount.nfs4: access denied by server while mounting

NFS shares have to reside in /srv - check your /etc/exports file and if
necessary create the proper folder structure as described in the
NFS#File_system page.

Check that the permissions on your client's folder are correct. Try
using 755.

or try "exportfs -rav" reload /etc/exports file.

> Unable to connect from OS X clients

When trying to connect from a OS X client, you will see that everything
is ok at logs, but MacOS X refuses to mount your NFS share. You have to
add insecure option to your share and re-run exportfs -r.

> Unreliable connection from OS X clients

OS X's NFS client is optimized for OS X Servers and might present some
issues with Linux servers. If you are experiencing slow performance,
frequent disconnects and problems with international characters edit the
default mount options by adding the line
nfs.client.mount.options = intr,locallocks,nfc to /etc/nfs.conf on your
Mac client. More information about the mount options can be found here.

> Lock problems

If you got error such as this:

    mount.nfs: rpc.statd is not running but is required for remote locking.
    mount.nfs: Either use '-o nolock' to keep locks local, or start statd.
    mount.nfs: an incorrect mount option was specified

To fix this, you need to change the "NEED_STATD" value in
/etc/conf.d/nfs-common.conf to YES.

Remember to start all the required services (see NFS), not just the nfs
service.

> mount.nfs: Operation not permitted

After updating to nfs-utils 1.2.1-2 or higher, mounting NFS shares
stopped working. Henceforth, nfs-utils uses NFSv4 per default instead of
NFSv3. The problem can be solved by using either mount option 'vers=3'
or 'nfsvers=3' on the command line:

    # mount.nfs remote target directory -o ...,vers=3,...
    # mount.nfs remote target directory -o ...,nfsvers=3,...

or in /etc/fstab:

    remote target directory nfs ...,vers=3,... 0 0
    remote target directory nfs ...,nfsvers=3,... 0 0

Performance issues
------------------

This NFS Howto page has some useful information regarding performance.
Here are some further tips:

> Diagnose the problem

-   Htop should be your first port of call. The most obvious symptom
    will be a maxed-out CPU.
-   Press F2, and under "Display options", enable "Detailed CPU time".
    Press F1 for an explanation of the colours used in the CPU bars. In
    particular, is the CPU spending most of its time responding to IRQs,
    or in Wait-IO (wio)?

> Server threads

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

> Close-to-open/flush-on-close

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

The nocto mount option

Note:The linux kernel does not seem to honour this option properly.
Files are still flushed when they're closed.

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

The async export option

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
/etc/exports file for those specific exports. See the exports manual
page for details. In this case, it does not make sense to use the nocto
mount option on the client.

> Buffer cache size and MTU

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

See also the nfs manual page for more about rsize and wsize.

Other issues
------------

> Permissions issues

If you find that you cannot set the permissions on files properly, make
sure the user/group you are chowning are on both the client and server.

If all your files are owned by nobody, and you are using NFSv4, on both
the client and server, you should:

-   For systemd, ensure that the rpc-idmapd service has been started.
-   For initscripts, ensure that NEED_IDMAPD is set to YES in
    /etc/conf.d/nfs-common.conf.

Retrieved from
"https://wiki.archlinux.org/index.php?title=NFS_Troubleshooting&oldid=305826"

Category:

-   Networking

-   This page was last modified on 20 March 2014, at 10:46.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
