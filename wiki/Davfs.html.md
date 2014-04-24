Davfs
=====

DAVfs is a Linux file system driver that allows you to mount a WebDAV
server as a disk drive. WebDAV is an extension to HTTP/1.1 that allows
remote collaborative authoring of Web resources, defined in RFC 4918.

Installing DAVfs
----------------

Install davfs2 from official repositories.

Mounting the partition
----------------------

Examples:

    # mount.davfs http://localhost:8080/ /mnt/dav
    # mount -t davfs http://localhost:8080/ /mnt/dav

Mounting as regular user
------------------------

Add yourself to network group:

    # usermod -a -G network username

Add webdav entry to /etc/fstab:

    https://webdav.example.com /home/username/webdav davfs user,noauto,uid=username,file_mode=600,dir_mode=700 0 1

Create secrets file in your home:

    $ mkdir ~/.davfs2/
    $ echo "https://webdav.example.com webdavuser webdavpassword" >> ~/.davfs2/secrets 
    $ chmod 0600 ~/.davfs2/secrets

If you want to mount several disks from same server, you need specify
mount points of this disks instead of server address in file
~/.davfs2/secrets

    /home/username/disk1 webdavuser1 webdavpassword1
    /home/username/disk2 webdavuser1 webdavpassword2
    .........
    /home/username/diskN webdavuserN webdavpasswordN 

Now you should be able to mount and unmount ~/webdav:

    # mount ~/webdav
    # fusermount -u ~/webdav

Retrieved from
"https://wiki.archlinux.org/index.php?title=Davfs&oldid=263490"

Category:

-   File systems

-   This page was last modified on 19 June 2013, at 19:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
