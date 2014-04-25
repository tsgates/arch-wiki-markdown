SFTP
====

SFTP refers to various forms of (more or less) secure file transfer
protocols. This article lists two examples and how to set them up.

Contents
--------

-   1 SSH file transfer protocol
    -   1.1 Setting up SSH file transfer protocol with OpenSSH
-   2 FTP over SSH
    -   2.1 Setting up FTP with pure-ftpd
    -   2.2 Set up Certificates
    -   2.3 Enable TLS
-   3 See also

SSH file transfer protocol
--------------------------

SSH file transfer protocol is a FTP-like protocol that allows secure
file transfer and manipulation, encrypting both passwords and
transferred data.

> Setting up SSH file transfer protocol with OpenSSH

To set up SFTP you only need to install and configure OpenSSH. Once you
have this running, SFTP is running too because the default configuration
file enables it. Follow the instructions below for older configs.

1. Open /etc/ssh/sshd_config with your favorite editor and add this line
if it does not already exist:

    Subsystem sftp /usr/lib/ssh/sftp-server

2. Restart the SSH-daemon with:

    # systemctl restart sshd.service

And it should work. You can access your files with the sftp program or
sshfs. Many standard FTP programs should work as well.

FTP over SSH
------------

FTP over SSH encrypts passwords unlike plain FTP. FTP over SSH is not
really a true protocol, it is just SSH + FTP or TLS/SSL + FTP . Note
that there are many ways to set this up. This is one of them.

This setup in particular (using pure-ftpd + TLS) encrypts usernames,
passwords, commands and server replies, but does NOT encrypt the data
channel. This also means that there is reduced performance cost on data
transfer.

> Setting up FTP with pure-ftpd

Install pure-ftpd as directed in this wiki article.

Then you can go ahead and edit the configuration file:

    # vi /etc/pure-ftpd.conf

You can start and stop the pure-ftpd daemon by

    # systemctl start pure-ftpd
    # systemctl stop pure-ftpd
    # systemctl restart pure-ftpd

and you can set it to automatically start with

    # systemctl enable pure-ftpd

> Set up Certificates

Refer to the documentation for more information. The short version is
this:

1. Create a Self-Signed Certificate:

    # mkdir -p /etc/ssl/private
    # openssl req -x509 -nodes -newkey rsa:1024 -keyout \
     /etc/ssl/private/pure-ftpd.pem \
     -out /etc/ssl/private/pure-ftpd.pem

2. Make it private:

    # chmod 600 /etc/ssl/private/*.pem

3. Be aware that using 1024 bits in some countries is against the law.
Choose 512 or less if unsure.

> Enable TLS

Towards the bottom of /etc/pure-ftpd.conf you should find a section for
TLS. Uncomment and change the TLS setting to 1 (which enables both FTP
and SFTP):

    TLS             1

Now restart the pure-ftpd daemon and you should be able to log in with
SFTP-enabled clients (e.g. FileZilla, SmartFTP). (Do not forget to use
port 22.)

See also
--------

-   SFTP-chroot

Retrieved from
"https://wiki.archlinux.org/index.php?title=SFTP&oldid=274487"

Category:

-   Secure Shell

-   This page was last modified on 6 September 2013, at 01:33.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
