Local repository
================

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with pacman      
                           Tips.                    
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This document outlines one way to share Arch Linux packages across a
LAN. A better way to do this would be to create a Custom local
repository with ABS and gensync and make the repository available across
the LAN using NFS or FTP. This document should be edited to describe
this process in detail. For the time being, the original HOWTO is left
intact below:

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 On the Server Side                                                 |
| -   3 On all clients                                                     |
| -   4 To sync your local repository v.s. archlinux.org                   |
+--------------------------------------------------------------------------+

Introduction
------------

To share all your downloaded packages in your lan Pros save bandwidth,
diskspace and time.

    pacman -Sy

Will sync against our local repository;

    pacman -S pkgname 

Try to download and install pkg from localserver if pkg not exist it
download from the next server in the list /etc/pacman.conf and save pkg
on localserver;

    alsync

Will update localserver db against ftp.archlinux.org.

Ex. for my network

    serverip=192.168.14.3
    network=192.168.14.0/255.255.255.0

Adjust to yours.

  

On the Server Side
------------------

Create an NFS share on the server to host the packages.

-   Install NFS:

     pacman -S nfs-utils

-   Add this line to /etc/exports:

    /var/cache/pacman/pkg 192.168.14.0/255.255.255.0(rw,no_root_squash)

-   Add rpcbind, nfs-common and nfs-server to DAEMONS in /etc/rc.conf.

-   Start the NFS daemons:

     # rc.d start rpcbind nfs-common nfs-server

On all clients
--------------

-   Rename /var/cache/pacman/pkg to /var/cache/pacman/pkgorg.
-   Create a new /var/cache/pacman/pkg and mount the nfs share there.
-   Run:

    mount -o rw,nolock 192.168.14.3:/var/cache/pacman/pkg /var/cache/pacman/pkg

-   If the mount from command line does not work add this option:

    nfsvers=3

-   Or, if you want it automount after the reboot, add this line in
    /etc/fstab:

     192.168.14.3:/var/cache/pacman/pkg /var/cache/pacman/pkg    nfs    rw,nolock

-   Again, if the mount does not work, try to add mount option nfsvers=3
    to the fstab entry.
-   Run:

    mount -a

-   Run:

    df

To check mount.

-   Move all your already fetched pkg from your clients:

     /var/cache/pacman/pkgorg to /var/cache/pacman/pkg

-   Edit /etc/pacman.conf and add this lines directly after the line:

     {current}
     Server = file:///var/cache/pacman/pkg

and after

     {extra}
     Server = file:///var/cache/pacman/pkg

I have skipped the step 3 because for me it works as i want already. I
sync from each PC and all share the pacman cache.

To sync your local repository v.s. archlinux.org
------------------------------------------------

-   "alsync" connects, login, and update your packages database on the
    local nfsserver

     pacman -S openssl
     pacman -S wget

  

-   create a file called /bin/alsync and put in this lines

     cd /var/cache/pacman/pkg
     wget -N ftp://ftp.archlinux.org/current/.db.
     wget -N ftp://ftp.archlinux.org/extra/.db.

-   chmod 777 /bin/alsync

copy this file to your clients

-   to try run as root on first client

     alsync
     pacman -Sy
     pacman -S new-pkgname

-   move to next client and run

     pacman -Sy
     pacman -S new-pkgname

Retrieved from
"https://wiki.archlinux.org/index.php?title=Local_repository&oldid=210878"

Category:

-   Package management
