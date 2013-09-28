Access Control Lists
====================

  
 Access Control List (ACL) provides an additional, more flexible
permission mechanism for file systems. It is designed to assist with
UNIX file permissions. ACL allows you to give permissions for any user
or group to any disc resource.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Enabling ACL                                                 |
|     -   2.2 Set ACL                                                      |
|                                                                          |
| -   3 Examples                                                           |
|     -   3.1 Output of ls command                                         |
|                                                                          |
| -   4 Increase security of your web server                               |
| -   5 Additional Resources                                               |
+--------------------------------------------------------------------------+

Installation
------------

Install the acl package which is available from the official
repositories by pacman:

    # pacman -S acl

Configuration
-------------

> Enabling ACL

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: It seems to work 
                           out of the box using     
                           systemd (Discuss)        
  ------------------------ ------------------------ ------------------------

To enable ACL - edit /etc/fstab and add the acl attribute in options on
the partition which you want to use ACL:

    /etc/fstab

    # 
    # /etc/fstab: static file system information
    #
    # <file system>        <dir>         <type>    <options>          <dump> <pass>
    none                   /dev/pts      devpts    defaults            0      0
    none                   /dev/shm      tmpfs     defaults            0      0

    /dev/cdrom /media/cdrom   auto    ro,user,noauto,unhide   0      0
    /dev/dvd /media/dvd   auto    ro,user,noauto,unhide   0      0
    UUID=5de01fca-7c63-49b0-9b2b-8b1790f8428e swap swap defaults 0 0
    UUID=822dd720-e35f-424c-b012-2c84b4aa265a /data reiserfs defaults 0 1
    UUID=8e5259dd-26fc-411a-88e2-f38d4dc36724 /home reiserfs defaults,acl 0 1
    UUID=c18f753e-0039-49bd-930f-587d48b7e083 / reiserfs defaults 0 1
    UUID=f64bfc77-7958-49c5-a244-1fa2517d676f /tmp reiserfs defaults 0 1

Save the file and remount the partition:

    # mount -o remount /home

> Set ACL

To modify ACL use setfacl command. To add permissions use setfacl -m.

Add permissions to some user:

    # setfacl -m "u:username:permissions"

or

    # setfacl -m "u:uid:permissions"

Add permissions to some group:

    # setfacl -m "g:groupname:permissions"

or

    # setfacl -m "g:gid:permissions"

Remove all permissions:

    # setfacl -b

Remove each entry:

    # setfacl -x "entry"

To check permissions use:

    # getfacl filename

Examples
--------

Set all permissions for user johny to file named "abc":

    # setfacl -m "u:johny:rwx" abc

Check permissions

    # getfacl abc

    # file: abc
    # owner: someone
    # group: someone
    user::rw-
    user:johny:rwx
    group::r--
    mask::rwx
    other::r--

Change permissions for user johny:

    # setfacl -m "u:johny:r-x" abc

Check permissions

    # getfacl abc

    # file: abc
    # owner: someone
    # group: someone
    user::rw-
    user:johny:r-x
    group::r--
    mask::r-x
    other::r--

Remove all extended ACL entries:

    # setfacl -b abc

Check permissions

    # getfacl abc

    # file: abc
    # owner: someone
    # group: someone
    user::rw-
    group::r--
    other::r--

> Output of ls command

You will notice that there is an ACL for a given file because it will
exhibit a + (plus sign) after its Unix permissions in the output of
ls -l.

    $ ls -l /dev/audio

    crw-rw----+ 1 root audio 14, 4 nov.   9 12:49 /dev/audio

    $ getfacl /dev/audio

    getfacl: Removing leading '/' from absolute path names
    # file: dev/audio
    # owner: root
    # group: audio
    user::rw-
    user:solstice:rw-
    group::rw-
    mask::rw-
    other::---

Increase security of your web server
------------------------------------

You can now add permissions to our home directory and/or site directory
only to nobody user any anyone else - without "whole world" to increase
your security.

Add permissions +x for nobody user on your home directory via ACL:

    # setfacl -m "u:nobody:--x" /home/homeusername/

Now you can remove whole world rx permissions:

    # chmod o-rx /home/homeusername/

Check our changes:

    # file: username/
    # owner: username
    # group: users
    user::rwx
    user:nobody:--x
    group::r-x
    mask::r-x
    other::---

As we can see others do not have any permissions but user nobody have
"x" permission so they can "look" into users directory and give access
to users pages from their home directories to www server. Of course if
www server work as nobody user. But - whole world except nobody - do not
have any permissions.

Additional Resources
--------------------

-   Man Page - man getfacl
-   Man Page - man setfacl

Retrieved from
"https://wiki.archlinux.org/index.php?title=Access_Control_Lists&oldid=255730"

Category:

-   Security
