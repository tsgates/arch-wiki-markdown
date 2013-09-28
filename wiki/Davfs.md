Davfs
=====

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installing DAVfs                                                   |
| -   3 Mounting the partition                                             |
| -   4 Mounting as regular user                                           |
+--------------------------------------------------------------------------+

Introduction
------------

DAVfs is a Linux file system driver that allows you to mount a WebDAV
server as a disk drive. WebDAV is an extension to HTTP/1.1 that allows
remote collaborative authoring of Web resources, defined in RFC 4918.

Installing DAVfs
----------------

Make sure the [extra] repo is enabled, then run:

    # pacman -S davfs2

Mounting the partition
----------------------

Examples:

    # mount.davfs http://localhost:8080/ /mnt/dav
    # mount -t davfs http://localhost:8080/ /mnt/dav

Mounting as regular user
------------------------

Add yourself to network group:

    # sudo usermod -a -G network username

Add webdav entry to /etc/fstab:

    https://webdav.example.com /home/username/webdav davfs user,noauto,uid=username,file_mode=600,dir_mode=700 0 1

Create secrets file in your home:

    # mkdir ~/.davfs2/
    # echo "https://webdav.example.com webdavuser webdavpassword" >> ~/.davfs2/secrets 
    # chmod 0600 ~/.davfs2/secrets

Now you should be able to mount and unmount ~/webdav:

    # mount ~/webdav
    # fusermount -u ~/webdav

Retrieved from
"https://wiki.archlinux.org/index.php?title=Davfs&oldid=212695"

Category:

-   File systems
