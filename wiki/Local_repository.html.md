Local repository
================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with pacman      
                           Tips#Custom local        
                           repository.              
                           Notes: This article is   
                           older than the linked    
                           section, Custom local    
                           repository with ABS and  
                           gensync (former          
                           prerequisite to this     
                           page) redirects to it.   
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

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
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This document outlines one way to share Arch Linux packages across a
LAN. A better way to do this would be to create a Custom local
repository with ABS and gensync and make the repository available across
the LAN using NFS or FTP. This document should be edited to describe
this process in detail. For the time being, the original HOWTO is left
intact below:

Contents
--------

-   1 Introduction
-   2 On the Server Side
-   3 On all clients
-   4 To sync your local repository against archlinux.org

Introduction
------------

Sharing all of your downloaded packages to your LAN can save bandwidth,
diskspace, and time.

    pacman -Syu

Will sync against our local repository;

    pacman -S pkgname 

Will try to download and install a package from localserver. If the
package does not exist it will download it from the next server in the
list /etc/pacman.conf and save the package on localserver;

    alsync

Will update localserver database against ftp.archlinux.org.

In example: for my network

    serverip=192.168.14.3
    network=192.168.14.0/255.255.255.0

Adjust to your needs.

On the Server Side
------------------

Create an NFS share on the server hosting the packages.

For detailed help on setting up an NFS server please see NFS

-   Add this line to /etc/exports:

    /var/cache/pacman/pkg 192.168.14.0/24(rw,no_subtree_check,nohide)

-   If you modify /etc/exports while the server is running, you must
    re-export them for changes to take effect:

    # exportfs -ra

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

To sync your local repository against archlinux.org
---------------------------------------------------

-   "alsync" connects, logs in, and updates your packages database on
    the local nfs server

     pacman -S openssl
     pacman -S wget

  

-   create a file called /bin/alsync and add these lines

     cd /var/cache/pacman/pkg
     wget -N ftp://ftp.archlinux.org/current/.db.
     wget -N ftp://ftp.archlinux.org/extra/.db.

-   chmod 755 /bin/alsync

copy this file to your clients

-   Attempt to run as root on the first client

     alsync
     pacman -Syu
     pacman -S new-pkgname

-   Then move to the next client and run

     pacman -Syu
     pacman -S new-pkgname

Retrieved from
"https://wiki.archlinux.org/index.php?title=Local_repository&oldid=299398"

Category:

-   Package management

-   This page was last modified on 21 February 2014, at 13:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
