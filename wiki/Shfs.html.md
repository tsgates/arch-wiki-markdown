Shfs
====

Shfs is a simple and easy to use Linux kernel module which allows you to
mount remote filesystems using a plain shell (ssh) connection. When
using shfs, you can access all remote files just like the local ones,
only the access is governed through the transport security of ssh.

Note that the FUSE-based Sshfs is much more widely used, as shfs has not
been updated since 2004.

Contents
--------

-   1 Why SHFS?
-   2 Howto SHFS
    -   2.1 Installation
    -   2.2 Configuration
    -   2.3 /etc/fstab
-   3 See Also
-   4 External Links

Why SHFS?
---------

Shfs supports some nice features:

-   file cache for access speedup
-   perl and shell code for the remote (server) side
-   could preserve uid/gid (root connection)
-   number of remote host platforms (Linux, Solaris, Cygwin, ...)
-   Linux kernel 2.4.10+ and 2.6
-   arbitrary command used for connection (instead of ssh)
-   persistent connection (reconnect after ssh dies)

If these features cannot convince you, I probably cannot either. Yet,
consider: the only thing you need on the server is a sshd running - and
you can mount your filesystem from anywhere in a secure way.

Howto SHFS
----------

In order to use shfs it needs to be installed and configured on the
client side, NOT on the server side! Server only needs to have working
sshd running.

> Installation

If you have standard Arch-kernel installed and community repo enabled in
pacman, the installation is very simple:

    # pacman -S shfs-utils

In other cases (e.g. if you run a self-baked kernel), you need to
compile shfs first for yourself. There is a PKGBUILD and other needed
files in AUR, just download them manually or even simpler, if you have
ABS configured to use build files from community repo, just update your
local abs tree:

    # abs community/shfs-utils

Then change to the directory where the files are downloaded and run
makepkg (do not need to be root):

    $ cd /var/abs/community/shfs-utils
    $ makepkg

This should make a working package, which can be easily installed (under
root):

    # pacman -A ./shfs-utils*.pkg.tar.gz

> Configuration

If you want to use shfsmount as mortal user, you will have to
chmod +s /usr/bin/shfsmount and chmod + /usr/bin/shfsumount. However it
is much more comfortable to put your mount options into /etc/fstab -
this is what mine looks like:

    remoteuser@Server:/data   /mnt/data   shfs    rw,noauto,uid=localuser,persistent   0       0
    remoteuser@Server:/crap   /mnt/crap   shfs    rw,noauto,uid=localuser,persistent   0       0
    remoteuser@Server:/backup /mnt/backup shfs    rw,noauto,uid=localuser,persistent   0       0
    remoteuser@Server:/home   /mnt/home   shfs    rw,noauto,uid=localuser,persistent   0       0

Soon you will get tired typing passwords and once you do, you might
consider Using SSH Keys.

Btw, if you are a paranoid bastard, like I am, and do not run ssh on
port 22 on your server, you will need to complete your option list with
port=<portnumber>.

> /etc/fstab

To add an entry for an shfs volume in your fstab, add a line of the
format:

    userid@remoteMachine:/remoteDirectory /home/userid/remoteDirectory shfs rw,user,noauto 0 0

(Came from Ubuntu Forums).

See Also
--------

-   Sshfs - A more up-to-date, FUSE-based implementation of an SSH-based
    filesystem.

External Links
--------------

-   http://shfs.sourceforge.net/ for a supposed to be complete
    reference.  
-   http://www.openssh.com/ for a really complete reference ;)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Shfs&oldid=252879"

Categories:

-   File systems
-   Secure Shell

-   This page was last modified on 4 April 2013, at 15:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
