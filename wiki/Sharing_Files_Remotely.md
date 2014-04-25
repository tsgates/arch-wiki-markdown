Sharing Files Remotely
======================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 NFS
-   2 FISH
-   3 SHFS
-   4 See also

NFS
---

Using NFS in Arch only requires installing portmap and nfs-utils; most
of the NFS functionality has already been compiled into the kernel. As
FUBAR suspected, the uid's for user robert were different on the two
machines: uid=1000 in Arch and uid=1001 in Xandros. In NFS, I got around
that by putting 'no_root_squash' in the export directives in
/etc/exports, i.e.

    /        hostname_DT(rw,no_root_squash,subtree_check)
    /home    hostname_DT(rw,no_root_squash,subtree_check)
    /mnt/sda5    hostname_DT(rw,no_root_squash,subtree_check)
    /mnt/sda7    hostname_DT(rw,no_root_squash,subtree_check)

Also, to use NFS in Arch one has to add the services portmap, nfslock,
nfsd to the DAEMONS line in /etc/rc.conf, e.g. right after network.
Finally, I have to stop the firewalls on both machines when I want to
use NFS. After doing all of that, I can use Konqueror as user robert to
access all filesystems on the respective server (DT or LT) from the
other machine as a client except for /home/robert and
/mnt/sda7/home/robert (that's a Slackware install) on LT; for these I
have to use Konqueror as root on DT.

FISH
----

FISH is a KDE's Konqueror feature, do not confuse it with fish.

Using FISH is very simple. Remote filesystems do not have to be mounted,
and the only thing that's required is that the sshd service is running
on the file server. I.e. in Arch one has to install openssh and put the
service sshd in the DAEMONS line in /etc/rc.conf. Firewalls must be
stopped to set up the connection but once the connection is established
it looks as though one can restart the firewalls.

Once this is done, all that's needed to access the root filesystem of
the server is to enter 'fish://root@hostname/' in the URL field of
Konqueror as an ordinary user, followed by the root password.

The drawback of FISH is that one is frequently asked for the password
but I suppose one can avoid that by using SSH keys.

SHFS
----

SHFS needs to be installed and configured on the client side, not on the
server side. The server only needs to have a working sshd running. If
you run Arch as a client, install shfs in it (see SHFS) and make sure
sshd is running on the server and firewall rules allow a ssh connection.

Next, create a mount point for the remote filesystem, e.g.

    # mkdir -p /mnt/shfs

Set the suid bit on /usr/bin/shfsmount and /usr/bin/shfsumount if you
wish to enable all users to mount (umount) remote dirs using shfs. You
can do this in Konqueror or by running

    # chmod u+s /usr/bin/shfsmount
    # chmod u+s /usr/bin/shfsumount

so that the permissions are: -rwsr-xr-x root root.

Then mount the remote shell filesystem:

    # shfsmount root@remote_hostname:/ /mnt/shfs -o uid=robert

(or you can use # mount -t shfs root@remote_hostname:/ /mnt/shfs -o
uid=robert)

Using the option -o uid=robert got me around the mismatch of uid's for
robert on the two systems.

At the 'root@remote_hostname's password:' prompt enter root's password.
You're ready then to access the remote filesystem as user robert at
/mnt/shfs, even after the remote firewall is restarted.

See also
--------

-   This article was forked from thread
    https://bbs.archlinux.org/viewtopic.php?id=26926.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sharing_Files_Remotely&oldid=237998"

Category:

-   Networking

-   This page was last modified on 3 December 2012, at 14:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
