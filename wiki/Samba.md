Samba
=====

> Summary

Installing, configuring and troubleshooting Samba

> Related

NFS

Samba Domain Controller

Samba is a re-implementation of the SMB/CIFS networking protocol, it
facilitates file and printer sharing among Linux and Windows systems as
an alternative to NFS. Some users say that Samba is easily configured
and that operation is very straight-forward. However, many new users run
into problems with its complexity and non-intuitive mechanism. It is
strongly suggested that the user stick close to the following
directions.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Required packages                                                  |
|     -   1.1 Server                                                       |
|     -   1.2 Client                                                       |
|                                                                          |
| -   2 Server configuration                                               |
|     -   2.1 Creating a share                                             |
|     -   2.2 Creating user share path                                     |
|     -   2.3 Adding a user                                                |
|     -   2.4 Web-based configuration (SWAT)                               |
|     -   2.5 Starting the service                                         |
|                                                                          |
| -   3 Client configuration                                               |
|     -   3.1 Manual mounting                                              |
|         -   3.1.1 Add Share to /etc/fstab                                |
|         -   3.1.2 User mounting                                          |
|                                                                          |
|     -   3.2 Automatic Mounting                                           |
|         -   3.2.1 smbnetfs                                               |
|             -   3.2.1.1 Daemon                                           |
|                                                                          |
|         -   3.2.2 fusesmb                                                |
|         -   3.2.3 autofs                                                 |
|                                                                          |
|     -   3.3 File Manager Configuration                                   |
|         -   3.3.1 Nautilus                                               |
|         -   3.3.2 Thunar and pcmanfm                                     |
|         -   3.3.3 KDE                                                    |
|         -   3.3.4 Other Graphical Environments                           |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Required packages
-----------------

> Server

To share files with Samba, install samba, from the Official
Repositories.

> Client

Only smbclient is required to access files from a Samba/SMB/CIFS server.
It is also available from the Official Repositories.

Server configuration
--------------------

The /etc/samba/smb.conf file must be created before starting the
service. Once that is set up, users may opt for using an advanced
configuration interface like SWAT.

As root, copy the default Samba configuration file to
/etc/samba/smb.conf:

    # cp /etc/samba/smb.conf.default /etc/samba/smb.conf

> Creating a share

Edit /etc/samba/smb.conf, scroll down to the Share Definitions section.
The default configuration automatically creates a share for each user's
home directory. It also creates a share for printers by default.

There are a number of commented sample configurations included. More
information about available options for shared resources can be found in
man smb.conf. Here is the on-line version.

> Creating user share path

This marks the named objects for automatic export to the environment of
subsequently executed commands:

    # export USERSHARES_DIR="/var/lib/samba/usershares"
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

    # chmod 01770 ${USERSHARES_DIR}

Set the following variable in smb.conf configuration file:

    /etc/samba/smb.conf

    ...
     [global]
       usershare path = /var/lib/samba/usershares
       usershare max shares = 100
       usershare allow guests = yes
       usershare owner only = False
     ...

Save the file and then add your user to the group sambashares replacing
"your_username" with the name of your user:

    # usermod -a -G ${USERSHARES_GROUP} your_username

Restart Samba

Log out and log back in. You should now be able to configure your samba
share using GUI. For example, in Thunar you can right click on any
directory and share it on the network. When the error
You are not the owner of the folder appears, simply try to reboot the
system.

> Adding a user

To log into a Samba share, a samba user is needed. The user must already
have a Linux user account with the same name on the server, otherwise
running the next command will fail:

    # pdbedit -a -u <user>

Note:As of version 3.4.0, smbpasswd is no longer used by default.
Existing smbpasswd databases can be converted to the new format

> Web-based configuration (SWAT)

SWAT (Samba Web Administration Tool) is a facility that is part of the
Samba suite. Whether or not to use this tool remains a matter of
personal preference. It does allow for quick configuration and has
context-sensitive help for each smb.conf parameter. SWAT also provides
an interface for monitoring of current state of connection(s), and
allows network-wide MS Windows network password management.

Warning:Before using SWAT, be warned that SWAT will completely replace
/etc/samba/smb.conf with a fully optimized file that has been stripped
of all comments, and only non-default settings will be written to the
file.

To use SWAT, first install xinetd, available in the Official
Repositories.

Edit /etc/xinetd.d/swat. To enable SWAT, change the disable = yes line
to disable = no.

    /etc/xinetd.d/swat

    service swat
    {
            type                    = UNLISTED
            protocol                = tcp
            port                    = 901
            socket_type             = stream
            wait                    = no
            user                    = root
            server                  = /usr/sbin/swat
            log_on_success          += HOST DURATION
            log_on_failure          += HOST
            disable                 = no
    }

Alternatively, add an entry for swat to /etc/services and omit the first
3 lines of the configuration.

Then start the "xinetd" daemon.

The web interface can be accessed on port 901 by default:
http://localhost:901/

Note:An all-encompasing Webmin tool is also available, and the SWAT
module can be loaded there.

> Starting the service

Start/enable Samba via the smbd and nmbd daemons.

Client configuration
--------------------

Shared resources from other computers on the LAN may be accessed and
mounted locally by GUI or CLI methods. The graphical manner is limited
since most lightweight Desktop Environments do not have a native way to
facilitate accessing these shared resources.

There are two parts to share access. First is the underlying file system
mechanism, and second is the interface which allows the user to select
to mount shared resources. Some environments have the first part built
into them.

> Manual mounting

Install smbclient from the Official Repositories.

To list public shares on a server:

    $ smbclient -L <hostname> -U%

Create a mount point for the share:

    # mkdir /mnt/MOUNTPOINT

Mount the share using the mount.cifs type. Not all the options listed
below are needed or desirable (ie. password).

    # mount -t cifs //SERVER/SHARENAME /mnt/MOUNTPOINT -o user=USERNAME,password=PASSWORD,workgroup=WORKGROUP,ip=SERVERIP

SERVER

The Windows system name.

SHARENAME

The shared directory.

MOUNTPOINT

The local directory where the share will be mounted.

-o [options]

See man mount.cifs for more information:

Note:Abstain from using a trailing /. //SERVER/SHARENAME/ will not work.

Add Share to /etc/fstab

The simplest way to add an fstab entry is something like this:

    /etc/fstab

    //SERVER/SHARENAME /mnt/MOUNTPOINT cifs noauto,username=USER,password=PASSWORD,workgroup=WORKGROUP,ip=SERVERIP 0 0

However, storing passwords in a world readable file is not recommended!
A safer method would be to use a credentials file. As an example, create
a file and chmod 600 <filename> so only the owning user can read and
write to it. It should contain the following information:

    /path/to/credentials/sambacreds

    username=USERNAME
    password=PASSWORD

and the line in your fstab should look something like this:

    /etc/fstab

    //SERVER/SHARENAME /mnt/MOUNTPOINT cifs noauto,username=USER,credentials=/path/to/credentials/sambacreds,workgroup=WORKGROUP,ip=SERVERIP 0 0

If using systemd (modern installations), one can utilize the
comment=systemd.automount option, which speeds up service boot by a few
seconds. Also, one can map current user and group to make life a bit
easier, utilizing uid and gid options (warning: using the uid and gid
options may cause input ouput errors in programs that try to fetch data
from network drives):

    /etc/fstab

    //SERVER/SHARENAME /mnt/MOUNTPOINT cifs noauto,credentials=/path/to/smbcredentials,comment=systemd.automount,uid=USERNAME,gid=USERGROUP 0 0

User mounting

    /etc/fstab

    //SERVER/SHARENAME /mnt/MOUNTPOINT cifs users,noauto,credentials=/path/to/smbcredentials,workgroup=WORKGROUP,ip=SERVERIP 0 0

Note:Note: The option is users (plural). For other filesystem types
handled by mount, this option is usually user; sans the "s".

This will allow users to mount it as long as the mount point resides in
a directory controllable by the user; i.e. the user's home. For users to
be allowed to mount and unmount the Samba shares with mount points that
they do not own, use smbnetfs, or grant privileges using sudo.

> Automatic Mounting

There are several ways to easily browse shared resources:

smbnetfs

Install smbnetfs, from the Official Repositories.

Add the following line to /etc/fuse.conf:

    user_allow_other

and load the fuse kernel module:

    # modprobe fuse

If a username and a password are required to access some of the shared
folders, edit /etc/smbnetfs/.smb/smbnetfs.conf and uncomment the line
starting with "auth":

    /etc/smbnetfs/.smb/smbnetfs.conf

    auth			"hostname" "username" "password"

Make sure to chmod 600 /etc/smbnetfs/.smb/smbnetfs.conf, and any include
files for smbnetfs to work correctly.

Daemon

Start and enable the smbnetfs daemon.

fusesmb

Note:Because smbclient 3.2.X is malfunctioning with fusesmb, revert to
using older versions if necessary. See the relevant forum topic for
details.

1.  Install fusesmb, available in the Arch User Repository.
2.  Create a mount point: # mkdir /mnt/fusesmb
3.  Load fuse kernel module.
4.  Mount the shares:

        # fusesmb -o allow_other /mnt/fusesmb

autofs

See Autofs for information on the kernel-based automounter for Linux.

> File Manager Configuration

Nautilus

In order to access samba shares through Nautilus, install the gvfs-smb
package, available in the Official Repositories.

Press Ctrl+L and enter smb://servername/share in the location bar to
access your share.

The mounted share is likely to be present at /run/user/<your UID>/gvfs
in the filesystem.

Thunar and pcmanfm

For access using Thunar or pcmanfm, install gvfs-smb, available in the
Official Repositories.

Go to smb://servername/share, to access your share.

KDE

KDE, has the ability to browse Samba shares built in. Therefore do not
need any additional packages. However, for a GUI in the KDE System
Settings, install the kdenetwork-filesharing package from the Official
Repositories

Other Graphical Environments

There are a number of useful programs, but they may need to have
packages created for them. This can be done with the Arch package build
system. The good thing about these others is that they do not require a
particular environment to be installed to support them, and so they
bring along less baggage.

-   pyneighborhood is available in the Official Repositories.
-   LinNeighborhood, RUmba, xffm-samba plugin for Xffm are not available
    in the official repositories or the AUR. As they are not officially
    (or even unofficially supported), they may be obsolete and may not
    work at all.

See also
--------

-   Tips and tricks - A dedicated page for alternate configurations and
    suggestions.
-   Troubleshooting - A dedicated page for solving common (or not so
    common) issues.
-   Samba: An Introduction
-   Official Samba site

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samba&oldid=254430"

Category:

-   Networking
