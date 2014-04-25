Samba
=====

Related articles

-   Samba/Tips and tricks
-   Samba/Troubleshooting
-   Samba/Advanced file sharing with KDE4
-   Samba Domain Controller
-   Active Directory Integration
-   Samba 4 Active Directory Domain Controller
-   OpenChange Server
-   NFS

Samba is a re-implementation of the SMB/CIFS networking protocol, it
facilitates file and printer sharing among Linux and Windows systems as
an alternative to NFS. Some users say that Samba is easily configured
and that operation is very straight-forward. However, many new users run
into problems with its complexity and non-intuitive mechanism. It is
strongly suggested that the user stick close to the following
directions.

Contents
--------

-   1 Server configuration
    -   1.1 Creating a share
    -   1.2 Starting services
    -   1.3 Creating user share path
    -   1.4 Adding a user
    -   1.5 Changing a password
-   2 Client configuration
    -   2.1 Manual mounting
        -   2.1.1 Add Share to /etc/fstab
        -   2.1.2 User mounting
    -   2.2 WINS host names
    -   2.3 Automatic mounting
        -   2.3.1 smbnetfs
            -   2.3.1.1 Daemon
        -   2.3.2 fusesmb
        -   2.3.3 autofs
    -   2.4 File manager configuration
        -   2.4.1 Nautilus and Nemo
        -   2.4.2 Thunar and PCManFM
        -   2.4.3 KDE
        -   2.4.4 Other graphical environments
-   3 See also

Server configuration
--------------------

To share files with Samba, install samba, from the official
repositories.

The Samba server is configured in /etc/samba/smb.conf. Copy the default
Samba configuration file to /etc/samba/smb.conf:

    # cp /etc/samba/smb.conf.default /etc/samba/smb.conf

> Creating a share

Edit /etc/samba/smb.conf, scroll down to the Share Definitions section.
The default configuration automatically creates a share for each user's
home directory. It also creates a share for printers by default.

There are a number of commented sample configurations included. More
information about available options for shared resources can be found in
man smb.conf. Here is the on-line version.

On Windows side, be sure to change smb.conf to the Windows Workgroup.
(Windows default: WORKGROUP)

Be sure that your machine is not named Localhost, since it will resolve
on Windows to 127.0.0.1.

> Starting services

Start smbd and nmbd to provide basic file sharing through SMB:

    # systemctl start smbd
    # systemctl start nmbd

If you want to start Samba at boot, enable smbd and nmbd.

Note:Or you can enable Samba socket so the daemon is started on the
first incoming connection:

    systemctl disable smbd.service
    systemctl enable smbd.socket

> Creating user share path

This marks the named objects for automatic export to the environment of
subsequently executed commands:

    # export USERSHARES_DIR="/var/lib/samba/usershare"
    # export USERSHARES_GROUP="sambashare"

This creates the usershares directory in var/lib/samba:

    # mkdir -p ${USERSHARES_DIR}

This makes the group sambashare:

    # groupadd ${USERSHARES_GROUP}

This changes the owner of the directory and group you just created to
root:

    # chown root:${USERSHARES_GROUP} ${USERSHARES_DIR}

This changes the permissions of the usershares directory so that users
in the group sambashare can read, write and execute files:

    # chmod 1770 ${USERSHARES_DIR}

Set the following variables in smb.conf configuration file:

    /etc/samba/smb.conf

    ...
    [global]
      usershare path = /var/lib/samba/usershare
      usershare max shares = 100
      usershare allow guests = yes
      usershare owner only = False
      ...

Save the file and then add your user to the group sambashares replacing
your_username with the name of your user:

    # usermod -a -G ${USERSHARES_GROUP} your_username

Restart smbd and nmbd.

Log out and log back in. You should now be able to configure your samba
share using GUI. For example, in Thunar you can right click on any
directory and share it on the network. When the error
You are not the owner of the folder appears, simply try to reboot the
system.

> Adding a user

To log into a Samba share, a samba user is needed. The user must already
have a Linux user account with the same name on the server, otherwise
running the next command will fail:

    # pdbedit -a -u user

Note:As of version 3.4.0, smbpasswd is no longer used by default.
Existing smbpasswd databases can be converted to the new format

> Changing a password

To change a user's password, use smbpasswd:

    # smbpasswd username

Client configuration
--------------------

Only smbclient is required to access files from a Samba/SMB/CIFS server.
It is also available from the official repositories.

Shared resources from other computers on the LAN may be accessed and
mounted locally by GUI or CLI methods. The graphical manner is limited
since most lightweight Desktop Environments do not have a native way to
facilitate accessing these shared resources.

There are two parts to share access. First is the underlying file system
mechanism, and second is the interface which allows the user to select
to mount shared resources. Some environments have the first part built
into them.

> Manual mounting

Install smbclient from the official repositories. If you want a lighter
approach and do not need the ability to list public shares, you need
only install cifs-utils to provide /usr/bin/mount.cifs.

To list public shares on a server:

    $ smbclient -L hostname -U%

Create a mount point for the share:

    # mkdir /mnt/mountpoint

Mount the share using the mount.cifs type. Not all the options listed
below are needed or desirable (ie. password).

    # mount -t cifs //SERVER/sharename /mnt/mountpoint -o user=username,password=password,workgroup=workgroup,ip=serverip

SERVER

The Windows system name.

sharename

The shared directory.

mountpoint

The local directory where the share will be mounted.

-o [options]

See man mount.cifs for more information.

> Note:

-   Abstain from using a trailing /. //SERVER/sharename/ will not work.
-   If your mount does not work stable, stutters or freezes, try to
    enable different SMB protocol version with vers= option. For
    example, vers=2.0 for Windows Vista mount.

Add Share to /etc/fstab

The simplest way to add an fstab entry is something like this:

    /etc/fstab

    //SERVER/sharename /mnt/mountpoint cifs username=username,password=password 0 0

However, storing passwords in a world readable file is not recommended!
A safer method would be to use a credentials file. As an example, create
a file and chmod 600 filename so only the owning user can read and write
to it. It should contain the following information:

    /path/to/credentials/sambacreds

    username=username
    password=password

and the line in your fstab should look something like this:

    /etc/fstab

    //SERVER/SHARENAME /mnt/mountpoint cifs credentials=/path/to/credentials/sambacreds 0 0

If using systemd (modern installations), one can utilize the
comment=systemd.automount option, which speeds up service boot by a few
seconds. Also, one can map current user and group to make life a bit
easier, utilizing uid and gid options.

Warning:Using the uid and gid options may cause input ouput errors in
programs that try to fetch data from network drives.

    /etc/fstab

    //SERVER/SHARENAME /mnt/mountpoint cifs credentials=/path/to/smbcredentials,comment=systemd.automount,uid=username,gid=usergroup 0 0

Note:Space in sharename should be replaced by \040 (ASCII code for space
in octal). For example, //SERVER/share name on the command line should
be //SERVER/share\040name in /etc/fstab.

User mounting

    /etc/fstab

    //SERVER/SHARENAME /mnt/mountpoint cifs users,credentials=/path/to/smbcredentials,workgroup=workgroup,ip=serverip 0 0

Note:The option is users (plural). For other filesystem types handled by
mount, this option is usually user; sans the "s".

This will allow users to mount it as long as the mount point resides in
a directory controllable by the user; i.e. the user's home. For users to
be allowed to mount and unmount the Samba shares with mount points that
they do not own, use smbnetfs, or grant privileges using sudo.

> WINS host names

The smbclient package provides a driver to resolve host names using
WINS. To enable it, add “wins” to the “hosts” line in
/etc/nsswitch.conf.

> Automatic mounting

There are several ways to easily browse shared resources:

smbnetfs

Note:smbnetfs needs an intact Samba server setup. See above on how to do
that.

First, check if you can see all the shares you are interested in
mounting:

    $ smbtree -U remote_user

If that does not work, find and modify the following line in
/etc/samba/smb.conf accordingly:

    domain master = auto

Now restart smbd nmbd as seen above.

If everything works as expected, install smbnetfs from the official
repositories.

Then, add the following line to /etc/fuse.conf:

    user_allow_other

and load the fuse kernel module:

    # modprobe fuse

Now copy the directory /etc/smbnetfs/.smb to your home directory.

    $ cp -a /etc/smbnetfs/.smb ~

Then create a link to the smb.conf file:

    $ ln -s /etc/samba/smb.conf ~/.smb/smb.conf

If a username and a password are required to access some of the shared
folders, edit ~/.smb/smbnetfs.auth to include one or more entries like
this:

    ~/.smb/smbnetfs.auth

    auth			"hostname" "username" "password"

It is also possible to add entries for specific hosts to be mounted by
smbnetfs, if necessary. More details can be found in
~/.smb/smbnetfs.conf.

When you are done with the configuration, you need to run

    $ chmod 600 ~/.smb/smbnetfs.*

Otherwise, smbnetfs complains about 'insecure config file permissions'.

Finally, to mount your Samba network neighbourhood to a directory of
your choice, call

    $ smbnetfs mount_point

Daemon

The Arch Linux package also maintains an additional system-wide
operation mode for smbnetfs. To enable it, you need to make the said
modifications in the directoy /etc/smbnetfs/.smb.

Then, you can start and/or enable the smbnetfs daemon as usual. The
system-wide mount point is at /mnt/smbnet/.

fusesmb

Note:Because smbclient 3.2.X is malfunctioning with fusesmb, revert to
using older versions if necessary. See the relevant forum topic for
details.

1.  Install fusesmb, available in the AUR.
2.  Create a mount point: mkdir /mnt/fusesmb
3.  Load fuse kernel module.
4.  Mount the shares:

        fusesmb -o allow_other /mnt/fusesmb

autofs

See Autofs for information on the kernel-based automounter for Linux.

> File manager configuration

Nautilus and Nemo

In order to access samba shares through Nautilus or Nemo, install the
gvfs-smb package, available in the official repositories.

Press Ctrl+l and enter smb://servername/share in the location bar to
access your share.

The mounted share is likely to be present at /run/user/your_UID/gvfs in
the filesystem.

Thunar and PCManFM

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with #Nautilus   
                           and Nemo.                
                           Notes: Identical, aren't 
                           they? (Discuss)          
  ------------------------ ------------------------ ------------------------

For access using Thunar or PCManFM, install gvfs-smb, available in the
official repositories.

Go to smb://servername/share, to access your share.

KDE

KDE, has the ability to browse Samba shares built in. Therefore do not
need any additional packages. However, for a GUI in the KDE System
Settings, install the kdenetwork-filesharing package from the official
repositories.

If when navigating with Dolphin you get a "Time Out" Error, you should
uncomment and edit this line in smb.conf:

    name resolve order = lmhosts bcast host wins

as shown in this page.

Other graphical environments

There are a number of useful programs, but they may need to have
packages created for them. This can be done with the Arch package build
system. The good thing about these others is that they do not require a
particular environment to be installed to support them, and so they
bring along less baggage.

-   pyneighborhood is available in the official repositories.
-   LinNeighborhood, RUmba, xffm-samba plugin for Xffm are not available
    in the official repositories or the AUR. As they are not officially
    (or even unofficially supported), they may be obsolete and may not
    work at all.

See also
--------

-   Samba: An Introduction
-   Official Samba site

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samba&oldid=304102"

Categories:

-   File systems
-   Networking

-   This page was last modified on 12 March 2014, at 07:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
