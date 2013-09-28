Mount FTP
=========

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

There are several packages available from the community repository or
AUR that allow to mount FTP shares and interact with them just as if
they were local file systems. It's advisable to use a ssl encrypted ftp
connection at least for the control channel.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Packages                                                           |
| -   2 Using curlftpfs to mount a FTP folder                              |
|     -   2.1 Mount as root                                                |
|     -   2.2 Mount as normal user                                         |
+--------------------------------------------------------------------------+

Packages
--------

These are the packages that provide a way to mount FTP shares:

-   curlftpfs [recommended]
-   fuseftp
-   lufs [outdated]

All three packages are based on FUSE library.

Using curlftpfs to mount a FTP folder
-------------------------------------

Install curlftpfs from the official repositories

If needed, make sure that fuse has been started.

    # modprobe fuse

> Mount as root

Create the mount point and then mount the FTP folder.

    # mkdir /mnt/ftp
    # curlftpfs ftp.yourserver.com /mnt/ftp/ -o user=username:password

If you want to give other (regular) users access right, use the
allow_other option:

    # curlftpfs ftp.yourserver.com /mnt/ftp/ -o user=username:password,allow_other

Do not add space after the comma or the allow_other argument won't be
recognized.

To use FTP in active mode add the option 'ftp_port=-':

    # curlftpfs ftp.yourserver.com /mnt/ftp/ -o user=username:password,allow_other,ftp_port=-

You can add this line to /etc/fstab to mount automatically.

    curlftpfs#USER:PASSWORD@ftp.domain.org /mnt/mydomainorg fuse auto,user,uid=1000,allow_other,_netdev 0 0

To prevent the password to be shown in the process list, create a .netrc
file in the home directory of the user running curlftpfs and chmod 600
with the following content:

    machine ftp.yourserver.com
    login username
    password mypassword

> Mount as normal user

You can also mount as normal user (always use the .netrc file for the
credentials and ssl encryption!):

    $ mkdir ~/my-server
    $ curlftpfs -o ssl,utf8 ftp://my-server.tld/ ~/my-server

if the answer is

    Error connecting to ftp: QUOT command failed with 500

then the server does not support the utf8 option. Leave it out and all
will be fine.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mount_FTP&oldid=243109"

Category:

-   File systems
