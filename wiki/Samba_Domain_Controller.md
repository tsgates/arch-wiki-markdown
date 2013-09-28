Samba Domain Controller
=======================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: This article was 
                           not tested with Samba 4, 
                           proceed with caution!    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This article explains how to setup a simple Windows Domain Controller
with user authentication and shares on a small network using samba. Note
this Howto is currently only a rough guide and may not work properly

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 PreConfiguration                                             |
|     -   1.2 Samba Config File                                            |
|     -   1.3 Other Configuration                                          |
|     -   1.4 Adding users                                                 |
|                                                                          |
| -   2 Finished                                                           |
+--------------------------------------------------------------------------+

Installation
============

Install samba.

PreConfiguration
----------------

run the following commands to create files and change permissions

    mkdir /home/samba
    mkdir /home/samba/netlogon
    mkdir /home/samba/profiles
    chmod 777 /var/spool/samba/
    chown -R root:users /home/samba/
    chmod -R 771 /home/samba/
    mkdir -p /home/shares/allusers
    chown -R root:users /home/shares/allusers/
    chmod -R ug+rwx,o+rx-w /home/shares/allusers/

Samba Config File
-----------------

Create the samba config file

    vi /etc/samba/smb.conf

Enter the following text

    [global]
      workgroup = MIDEARTH
      netbios name = archer
      server string = Samba Domain Controller

      
      passdb backend = tdbsam
      security = user
      username map = /etc/samba/smbusers
      name resolve order = wins bcast hosts
      domain logons = yes
      preferred master = yes
      wins support = yes

      
      # Default logon
      logon drive = H:
      logon script = scripts/logon.bat
      logon path = \\archer\profile\%U


      # Useradd scripts
      add user script = /usr/sbin/adduser --quiet --disabled-password --gecos "" %u
      delete user script = /usr/sbin/userdel -r %u
      add group script = /usr/sbin/groupadd %g
      delete group script = /usr/sbin/groupdel %g
      add user to group script = /usr/sbin/usermod -G %g %u
      add machine script = /usr/sbin/useradd -s /bin/false/ -d /var/lib/nobody %u
      idmap uid = 15000-20000
      idmap gid = 15000-20000
      template shell = /bin/bash


      # sync smb passwords with linux passwords
      passwd program = /usr/bin/passwd %u
      passwd chat = *Enter\snew\sUNIX\spassword:* %n\n *Retype\snew\sUNIX\spassword:* %n\n *password\supdated\ssuccessfully* .
      passwd chat debug = yes
      unix password sync = yes
      
      # set the loglevel
      log level = 3

    [public]
      browseable = yes
      public = yes


    [homes]
      comment = Home
      valid users = %S
      read only = no
      browsable = no


    [netlogon]
      comment = Network Logon Service
      path = /home/samba/netlogon
      admin users = administrator
      valid users = %U
      read only = no
      guest ok = yes
      writable = no
      share modes = no


    [profile]
      comment = User profiles
      path = /home/samba/profiles
      valid users = %U
      create mode = 0600
      directory mode = 0700
      writable = yes
      browsable = no
      guest ok = no


    [allusers]
     comment = All Users
     path = /home/shares/allusers
     valid users = @users
     force group = users 
     create mask = 0660
     directory mask = 0771
     writable = yes

Other Configuration
-------------------

Next restart samba

    systemctl restart samba

Edit the following file

    vi /etc/nsswitch.conf

And change the line

    hosts: files dns

to say

    hosts: files wins dns

Add the root user to the samba password database

    smbpasswd -a root

This next command tells the server that the user administrator will be
our domain admin

    echo "root = administrator" > /etc/samba/smbusers

Add the default domain groups (SUPER IMPORTANT!)

    net groupmap add ntgroup="Domain Admins" unixgroup=wheel rid=512 type=d
    net groupmap add ntgroup="Domain Users" unixgroup=users rid=513 type=d
    net groupmap add ntgroup="Domain Guests" unixgroup=nobody rid=514 type=d

Launching the NetBIOS name server may be required for other machines to
"see" the server

    nmbd -H /etc/samba/lmhosts -D

Adding users
------------

First add the user

    useradd username -m -G users

then add it to the samba database

    smbpasswd -a username

Restart the samba server just to be sure

    systemctl restart samba

Finished
========

Your samba domain controller may or may not work now that you have
completed this untested how to.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samba_Domain_Controller&oldid=253951"

Category:

-   Networking
