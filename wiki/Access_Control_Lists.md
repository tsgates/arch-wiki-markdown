Access Control Lists
====================

Access Control List (ACL) provides an additional, more flexible
permission mechanism for file systems. It is designed to assist with
UNIX file permissions. ACL allows you to give permissions for any user
or group to any disc resource.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Enabling ACL
    -   2.2 Set ACL
-   3 Examples
    -   3.1 Output of ls command
-   4 Increase security of your web server
-   5 See also

Installation
------------

The required package acl is a dependency of systemd, it should already
be installed.

Configuration
-------------

> Enabling ACL

To enable ACL, the filesystem must be mounted with the acl option. You
can use fstab to make it permanent on your system.

There is a big chance that the acl option is already active as default
mount option of your filesystem. Use the following command to check it
for ext* formatted partitions:

    # tune2fs -l /dev/sdXY | grep "Default mount options:"

    Default mount options:    user_xattr acl

Also check that the default mount option is not overridden, in such case
you will see noacl in /proc/mounts in the relevant line.

You can set the default mount options of a filesystem using the
tune2fs -o option partition command, for example:

    # tune2fs -o acl /dev/sdXY

Using the default mount options instead of an entry in /etc/fstab is
very useful for external drives, such partition will be mounted with acl
option also on other Linux machines. There is no need to edit /etc/fstab
on every machine.

> Note:

-   acl is specified as default mount option when creating an ext2/3/4
    filesystem. This is configured in /etc/mke2fs.conf.
-   The default mount options are not listed in /proc/mounts.

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

See also
--------

-   Man Page - man getfacl
-   Man Page - man setfacl

Retrieved from
"https://wiki.archlinux.org/index.php?title=Access_Control_Lists&oldid=282039"

Category:

-   Security

-   This page was last modified on 9 November 2013, at 01:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
