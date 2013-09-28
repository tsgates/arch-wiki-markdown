Samba/Advanced file sharing with KDE4
=====================================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: KDE share panel  
                           no longer has            
                           configuration settings   
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Work plan:

1.  install packages
2.  configure samba
3.  configure sudo and kdesu
4.  configure KDE side of things
5.  share a folder

Packages we will need:

-   kdebase-dolphin this is the interface we will use to share folders
-   samba for the server that will share files
-   kdenetwork-filesharing for System Settings File Sharing part
-   kdebase-runtime basic KDE workspace (but if you're reading this,
    chances are you already have it installed)
-   sudo

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing requisites                                              |
| -   2 Configuring samba                                                  |
| -   3 Configure sudo                                                     |
| -   4 Configure KDE                                                      |
| -   5 Share a folder                                                     |
+--------------------------------------------------------------------------+

> Installing requisites

Install all packages and their dependencies:

pacman -S kdebase-dolphin samba kdenetwork-filesharing kdebase-runtime sudo

Log out and log in again (kdelibs3 are in non standard place and so the
PATH must be updated)

> Configuring samba

A basic config file works OK, though you'll need to create Samba users
(with pdbedit -a -u <user name> as root):

    smb.conf

    [global]
    workgroup=HOME
    server string = Samba Server
    log file = /var/log/samba/&m.log
    max log size = 50
    load printers = No
    dns proxy = No

    [homes]
    comment = Home Directories
    read only = No
    browsable = No
    browseable = No

Alternatively you can configure samba with security = share and add
guest account = <your user name> to get an anonymous Samba server

Remember to add samba to DAEMONS in /etc/rc.conf if you want it to start
at boot time.

> Configure sudo

as root run visudo (it uses editor defined in $EDITOR or $VISUAL
variables) and add line:

    /etc/sudoers

    ...
    <your user name> ALL=(ALL) ALL

this will allow you to run all programs with sudo using your own
password.

Run this command to change default super user command:
kwriteconfig --file kdesurc --group super-user-command --key super-user-command sudo

> Configure KDE

Right click any folder in your home directory and select Properties. Go
to Share tab and click 'Configure File Sharing...', you'll be asked for
your sudo password. (alternatively run kcmshell4 fileshare as root)

In the dialog you need to select checkbox near "Enable Local Network
File Sharing". Check radiobutton besides 'Advanced sharing', unselect
NFS sharing.

Click 'Allowed Users' and select the second option -- 'Only users of a
certain group are allowed to share folders'. Click 'Choose group...'.
Create new group, call it samba-share, do not check any checkboxes in
the dialog, click OK. In the new window add yourself, root to the group
and all the other users you may want. Click OK.

Click OK in the main dialog.

Log out, log back in.

> Share a folder

When the file sharing is configured you will see a new checkbox in the
Share tab: 'Share this folder in the local network'. Select checkbox
beside 'Share with Samba', give the share some meaningful name and
decide whatever it should be writable or not.

'More Samba Options' button lists all possible Samba options that can be
applied to a share, so it's quite comprehensive.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samba/Advanced_file_sharing_with_KDE4&oldid=245112"

Category:

-   Networking
