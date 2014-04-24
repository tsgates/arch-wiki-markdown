Sshfs
=====

You can use sshfs to mount a remote system - accessible via SSH - to a
local folder, so you will be able to do any operation on the mounted
files with any tool (copy, rename, edit with vim, etc.). Using sshfs
instead of shfs is generally preferred as a new version of shfs hasn't
been released since 2004.

Contents
--------

-   1 Installation
-   2 Usage
    -   2.1 Mounting
    -   2.2 Unmounting
-   3 Chrooting
-   4 Helpers
-   5 Automounting
    -   5.1 On demand
    -   5.2 On boot
    -   5.3 Secure user access
-   6 Options
-   7 Troubleshooting
    -   7.1 Connection reset by peer
    -   7.2 Remote host has disconnected
    -   7.3 Thunar has issues with FAM and remote file access
    -   7.4 Shutdown hangs when sshfs is mounted
-   8 See also

Installation
------------

Install sshfs from official repositories. This should install fuse and
sshfs, and maybe other packages.

Usage
-----

First a kernel module should be loaded, so as root, do:

    # modprobe fuse

Note:This will be done automatically when you run the sshfs command, so
there's no need to add a modprobe conf file to make it load at boot. If
you get an error message about needing to load the module when you run
sshfs, you probably didn't reboot after a kernel update.

Check if fuse is active:

    systemctl list-units --all|grep fuse

     sys-module-fuse.device    loaded active   plugged       /sys/module/fuse

Note:You may have to execute the sshfs command first, before systemctl
will show that fuse is active. Systemd will activate the fuse device
once a program is run that requires it.

> Mounting

You will use the command sshfs. To mount a remote directory:

    $ sshfs USERNAME@HOSTNAME_OR_IP:/PATH LOCAL_MOUNT_POINT SSH_OPTIONS

For example:

    $ sshfs sessy@mycomputer:/home/sessy /mnt/sessy -C -p 9876

Where 9876 is the port number.

Also, make certain that before connecting, you set the file permissions
for any local client folders you will attempt to mount a remote
directory to. I.e., do not have everything owned by root! You could also
run the mount command as a regular user, it should work as well.

SSH will ask for the password, if needed. If you do not want to type in
your password 49 times a day, then read this: How to Use RSA Key
Authentication with SSH or Using SSH Keys.

Tip:To quickly mount a remote dir, do some file-management and unmount
it, put this in a script:

    sshfs USERNAME@HOSTNAME_OR_IP:/PATH LOCAL_MOUNT_POINT SSH_OPTIONS
    mc ~ LOCAL_MOUNT_POINT
    fusermount -u LOCAL_MOUNT_POINT

This will mount the remote directory, launch MC, and unmount it when you
exit.

> Unmounting

To unmount the remote system:

    $ fusermount -u LOCAL_MOUNT_POINT

Example:

    $ fusermount -u /mnt/sessy

Chrooting
---------

You may want to jail a (specific) user to a directory.To do this, edit
/etc/ssh/sshd_config:

    /etc/ssh/sshd_config

    .....
    Match User someuser 
           ChrootDirectory /chroot/%u
           ForceCommand internal-sftp #to restrict the user to sftp only
           AllowTcpForwarding no
           X11Forwarding no
    .....

Note:The chroot directory must be owned by root, otherwise you will not
be able to connect. For more info check the manpages for
Match, ChrootDirectory and ForceCommand.

Helpers
-------

If you often need to mount sshfs filesystems you may be interested in
using an sshfs helper, such as sftpman.

It provides a command-line and a GTK frontend, to make mounting and
unmounting a simple one click/command process.

Automounting
------------

Automounting can happen on boot, or on demand (when accessing the
directory). For both, the setup happens in /etc/fstab.

> On demand

With systemd on-demand mounting is possible using /etc/fstab entries.

Example:

    user@host:/remote/folder /mount/point  fuse.sshfs noauto,x-systemd.automount,_netdev,users,idmap=user,IdentityFile=/home/user/.ssh/id_rsa,allow_other,reconnect 0 0

The important mount options here are noauto,x-systemd.automount,_netdev.

-   noauto tells it not to mount at boot
-   x-systemd.automount does the on-demand magic
-   _netdev tells it that it's a network device, not a block device
    (without it "No such device" errors might happen)

> On boot

An example on how to use sshfs to mount a remote filesystem through
/etc/fstab

    USERNAME@HOSTNAME_OR_IP:/REMOTE/DIRECTORY  /LOCAL/MOUNTPOINT  fuse.sshfs  defaults,_netdev  0  0

Take for example the fstab line

    llib@192.168.1.200:/home/llib/FAH  /media/FAH2  fuse.sshfs  defaults,_netdev  0  0

The above will work automatically if you are using an SSH key for the
user. See Using SSH Keys.

If you want to use sshfs with multiple users:

    user@domain.org:/home/user  /media/user   fuse.sshfs    defaults,allow_other,_netdev    0  0

Again, it's important to set the _netdev mount option to make sure the
network is available before trying to mount.

> Secure user access

When automounting via /etc/fstab, the filesystem will generally be
mounted by root. By default, this produces undesireable results if you
wish access as an ordinary user and limit access to other users.

An example mountpoint configuration:

    USERNAME@HOSTNAME_OR_IP:/REMOTE/DIRECTORY  /LOCAL/MOUNTPOINT  fuse.sshfs noauto,x-systemd.automount,_netdev,user,idmap=user,transform_symlinks,identityfile=/home/USERNAME/.ssh/id_rsa,allow_other,default_permissions,uid=USER_ID_N,gid=USER_GID_N 0 0

Summary of the relevant options:

-   allow_other - Allow other users than the mounter (i.e. root) to
    access the share.
-   default_permissions - Allow kernel to check permissions, i.e. use
    the actual permissions on the remote filesystem. This allows
    prohibiting access to everybody otherwise granted by allow_other.
-   uid, gid - set reported ownership of files to given values; uid is
    the numeric user ID of your user, gid is the numeric group ID of
    your user.

Options
-------

sshfs can automatically convert your local and remote user IDs.

Add the idmap option with user value to translate UID of connecting
user:

    # sshfs -o idmap=user sessy@mycomputer:/home/sessy /mnt/sessy -C -p 9876

If you have a different login on the remote system, it can still work if
you provide the ssh standard option User:

    # sshfs -o idmap=user,User=sessy2 sessy@mycomputer:/home/sessy /mnt/sessy -C -p 9876

(I've used first form, second is based on docs, so YMMV, but it should
at least be close)

Troubleshooting
---------------

> Connection reset by peer

-   If you are trying to access the remote system with a hostname, try
    using its IP address, as it can be a domain name solving issue. Make
    sure you edit /etc/hosts with the server details.
-   If you are using non-default key names and are passing it as
    -i .ssh/my_key, this won't work. You have to use
    -o IdentityFile=/home/user/.ssh/my_key, with the full path to the
    key.
-   Adding the option 'sshfs_debug' (as in
    'sshfs -o sshfs_debug user@server ...') can help in resolving the
    issue.
-   If you're trying to sshfs into a router running DD-WRT or the like,
    there is a solution here. (note that the
    -osftp_server=/opt/libexec/sftp-server option can be used to the
    sshfs command in stead of patching dropbear)
-   Forum thread: sshfs: Connection reset by peer

Note: When providing more than one option for sshfs, they must be comma
separated. Like so:
'sshfs -o sshfs_debug,IdentityFile=</path/to/key> user@server ...')

> Remote host has disconnected

-   If you recieve this message directly after attempting to use sshfs,
    try checking the path of your Subsystem listed in
    /etc/ssh/sshd_config on the remote machine to see if it is valid.

Note:The default value for Subsystem should be
Subsystem sftp /usr/lib/ssh/sftp-server

-   You can check this by typing find /  grep XXXX where XXXX is the
    path of the subsystem

> Thunar has issues with FAM and remote file access

If you experience remote folders not displaying, getting kicked back to
the home directory, or other remote file access issues through Thunar,
replace fam with gamin. Gamin is derived from fam.

> Shutdown hangs when sshfs is mounted

Systemd may hang on shutdown if an sshfs mount was mounted manually and
not unmounted before shutdown. To solve this problem, create this file
(as root):

    /etc/systemd/system/killsshfs.service

    [Unit]
    After=network.target

    [Service]
    RemainAfterExit=yes
    ExecStart=-/bin/true
    ExecStop=-/usr/bin/pkill sshfs

    [Install]
    WantedBy=multi-user.target

Then enable the service: systemctl enable killsshfs.service

See also
--------

-   sftpman - sshfs helper tool
-   SSH
-   How to mount chrooted SSH filesystem, with special care with owners
    and permissions questions.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sshfs&oldid=285205"

Category:

-   Secure Shell

-   This page was last modified on 29 November 2013, at 14:33.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
