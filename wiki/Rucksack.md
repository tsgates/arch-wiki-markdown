Rucksack
========

Rucksack is a simple script and daemon designed for Arch Linux. Rucksack
allows the system administrator to set up a unified package cache on
individual workstations, exploiting unionfs to combine a remote package
cache and a local package cache. By avoiding repeated downloads of core
packages rucksack helps to reduce bandwidth consumption and network
traffic. The remote cache can reside on any machine within the network,
utilizing a variety of shared file systems, including NFS.

Because rucksack mounts the remote cache as read-only there are no
security or storage concerns: you can administrate the volume of
packages stored from the host machine. However, rucksack also mounts a
local cache so that any files that pacman cannot find in the remote
cache are downloaded and stored as normal. All this takes place within a
seamless single cache. This means that client machine can still keep up
to date with an array of packages not used on the remote host machine.

Rucksack is NOT a repository mirroring tool and is focused on avoiding
repeated downloads of core packages. It is therefore superior in many
ways to the rsync method described in the Local Mirror howto.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Setup                                                              |
|     -   1.1 Sharing the remote cache                                     |
|     -   1.2 Setting up the clients                                       |
|         -   1.2.1 Creating the caches and mount points                   |
|         -   1.2.2 Configure rucksack                                     |
|         -   1.2.3 Configuring fstab                                      |
|         -   1.2.4 Starting rucksack                                      |
|                                                                          |
|     -   1.3 Is that it?                                                  |
|                                                                          |
| -   2 FAQs                                                               |
+--------------------------------------------------------------------------+

Setup
-----

The rucksack script is not currently available as an Arch Linux package
but the source can be found here Rucksack is purely a client side
application – it doesn’t need to be installed on the remote cache host.
Rucksack relies on unionfs so ensure you install the unionfs module for
your kernel. Unionfs is available in the repositories for both the stock
and beyond kernels

> Sharing the remote cache

It is important to select the right machine as your remote cache host.
We all know that every system should be kept as up to date as possible
but the machine storing your cache should be that which is most
frequently updated.

The remote cache host doesn’t require any special configuration as such;
you merely need to share the pacman cache residing in
/var/cache/pacman/pkg using your preferred shared filesystem. NFS is the
easiest to set up but any shared filesystem that can be mounted from
fstab is suitable.

This NFS howto provides all the information you need to set up a secure
and reliable NFS share.

(Please add links to further howtos for other shared FSs)

> Setting up the clients

Each client now needs to be configured to access the shared resource
created above. You can refer to the howtos above for this step. Once you
can successfully mount the shared resource on the client machine you can
move to the next step.

Creating the caches and mount points

Pacman normally uses one package cache, stored in /var/cache/pacman/pkg.
The easiest way to set up your caches for rucksack is to move your
existing cache to /var/cache/pacman/local and create a remote cache
mount point and a new pacman cache directory. The pacman cache directory
/var/cache/pacman/pkg is used as the unionfs mount point.

    # mv /var/cache/pacman/pkg /var/cache/pacman/local
    # mkdir /var/cache/pacman/{pkg,remote}

That’s it!

Configure rucksack

Rucksack config options are found in /etc/conf.d/rucksack. Currently the
only information you need to add is the local cache directory and the
mount points for the remote cache and the target pacman cache (almost
certainly /var/cache/pacman/pkg).

Configuring fstab

This is the heart of rucksack. You need to add a line to fstab to mount
the shared remote cache on the remote cache mount point created above.
This can either be set to mount at boot or can be set noauto and
rucksack will mount it as necessary.

Starting rucksack

Rucksack should be started at boot by adding rucksack to the DAEMONS
array in rc.conf. It can also be started and stopped manually using the
following commands:

    # rucksack -start
    # rucksack -stop

Warning: If rucksack is not manually stopped correctly before shutdown
then there is a strong chance that one of your mount points will hang
and data maybe lost. Therefore I would strongly recommend that you use
the daemon to avoid such problems.

> Is that it?

Well, yes! Rucksack is an extremely simple and robust way of utilizing
shared file systems and unionfs. You could simply do all of this by hand
but I hope rucksack can save you the trouble.

FAQs
----

Q. All my clients use KDE but my host doesn’t. How can rucksack help me?

A. Simple. All you need to do is frequently run pacman -Syw kde on the
remote cache host to keep the KDE packages cache for use by your client
machines.

Q. My pacman cache is stored on a separate local partition, can rucksack
deal with that?

A. Yes. As long as you have configured your machine to correctly mount
that partition from within fstab rucksack will try and mount it as
necessary. Bear in mind though that the mount point will need to be
changed from /var/cache/pacman/pkg.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Rucksack&oldid=239532"

Category:

-   Package management
