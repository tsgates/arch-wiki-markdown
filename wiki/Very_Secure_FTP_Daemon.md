Very Secure FTP Daemon
======================

vsftpd (Very Secure FTP Daemon) is a lightweight, stable and secure FTP
server for UNIX-like systems.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Enabling uploading                                           |
|     -   2.2 Local user login                                             |
|     -   2.3 Anonymous login                                              |
|     -   2.4 Chroot jail                                                  |
|     -   2.5 Limiting user login                                          |
|     -   2.6 Limiting connections                                         |
|     -   2.7 Using xinetd                                                 |
|     -   2.8 Using SSL to Secure FTP                                      |
|     -   2.9 Dynamic DNS                                                  |
|                                                                          |
| -   3 Tips and tricks                                                    |
|     -   3.1 PAM with virtual users                                       |
|         -   3.1.1 Adding private folders for the virtual users           |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 vsftpd: refusing to run with writable root inside chroot()   |
|     -   4.2 FileZilla Client: GnuTLS error -8 when connecting via SSL    |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Simply install vsftpd from the Official Repositories.

To start the server:

    # systemctl start vsftpd.service

If you want it to be started automatically at boot:

    # systemctl enable vsftpd.service

See the xinetd section below for procedures to use vsftpd with xinetd.

Configuration
-------------

Most of the settings in vsftpd are done by editing the file
/etc/vsftpd.conf. The file itself is well-documented, so this section
only highlights some important changes you may want to modify. For all
available options and documentation, one can man vsftpd.conf (5). Files
are served by default from /srv/ftp.

> Enabling uploading

The WRITE_ENABLE flag must be set to YES in /etc/vsftpd.conf in order to
allow changes to the filesystem, such as uploading:

    write_enable=YES

> Local user login

One must set the line to /etc/vsftpd.conf to allow users in /etc/passwd
to login:

    local_enable=YES

> Anonymous login

The line in /etc/vsftpd.conf controls whether anonymous users can login:

    anonymous_enable=YES          # Allow anonymous login
    no_anon_password=YES          # No password is required for an anonymous login
    anon_max_rate=30000           # Maximum transfer rate for an anonymous client in Bytes/second
    anon_root=/example/directory/ # Directory to be used for an anonymous login

> Chroot jail

One can set up a chroot environment which prevents the user from leaving
its home directory. To enable this, add the following lines to
/etc/vsftpd.conf:

    chroot_list_enable=YES
    chroot_list_file=/etc/vsftpd.chroot_list

The chroot_list_file variable specifies the file which contains users
that are jailed.

For a more restricted environment, one can specify the line:

    chroot_local_user=YES

This will make local users jailed by default. In this case, the file
specified by chroot_list_file lists users that are not in a chroot jail.

> Limiting user login

It's possible to prevent users from logging into the FTP server by
adding two lines to /etc/vsftpd.conf:

    userlist_enable=YES
    userlist_file=/etc/vsftpd.user_list

userlist_file now specifies the file which lists users that are not able
to login.

If you only want to allow certain users to login, add the line:

    userlist_deny=NO

The file specified by userlist_file will now contain users that are able
to login.

> Limiting connections

One can limit the data transfer rate, number of clients and connections
per IP for local users by adding the information in /etc/vsftpd.conf:

    local_max_rate=1000000 # Maximum data transfer rate in bytes per second
    max_clients=50         # Maximum number of clients that may be connected
    max_per_ip=2           # Maximum connections per IP

> Using xinetd

If you want to use vsftpd with xinetd, add the following lines to
/etc/xinetd.d/vsftpd:

    service ftp
    {
            socket_type             = stream
            wait                    = no
            user                    = root
            server                  = /usr/sbin/vsftpd
            log_on_success  += HOST DURATION
            log_on_failure  += HOST
            disable                 = no
    }

The option below should be set in /etc/vsftpd.conf:

    pam_service_name=ftp

Finally, add xinetd to your daemons line in /etc/rc.conf. You do not
need to add vsftpd, as it will be called by xinetd whenever necessary.

If you get errors like this while connecting to the server:

    500 OOPS: cap_set_proc

You need to add capability in MODULES= line in /etc/rc.conf.

While upgrading to version 2.1.0 you might get an error like this when
connecting to the server from a client:

    500 OOPS: could not bind listening IPv4 socket

In earlier versions it has been enough to leave the following lines
commented:

    # Use this to use vsftpd in standalone mode, otherwise it runs through (x)inetd
    # listen=YES

In this newer version, and maybe future releases, it is necessary
however to explicitly configure it to not run in a standalone mode, like
this:

    # Use this to use vsftpd in standalone mode, otherwise it runs through (x)inetd
    listen=NO

> Using SSL to Secure FTP

Generate an SSL Cert, e.g. like that:

    # cd /etc/ssl/certs
    # openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/ssl/certs/vsftpd.pem -out /etc/ssl/certs/vsftpd.pem
    # chmod 600 /etc/ssl/certs/vsftpd.pem

You will be asked a lot of Questions about your Company etc., as your
Certificate is not a trusted one it doesn't really matter what you fill
in. You will use this for encryption! If you plan to use this in a
matter of trust get one from a CA like thawte, verisign etc.

edit your configuration /etc/vsftpd.conf

    #this is important
    ssl_enable=YES

    #choose what you like, if you accept anon-connections
    # you may want to enable this
    # allow_anon_ssl=NO

    #choose what you like,
    # it's a matter of performance i guess
    # force_local_data_ssl=NO

    #choose what you like
    force_local_logins_ssl=YES

    #you should at least enable this if you enable ssl...
    ssl_tlsv1=YES
    #choose what you like
    ssl_sslv2=YES
    #choose what you like
    ssl_sslv3=YES
    #give the correct path to your currently generated *.pem file
    rsa_cert_file=/etc/ssl/certs/vsftpd.pem
    #the *.pem file contains both the key and cert
    rsa_private_key_file=/etc/ssl/certs/vsftpd.pem

> Dynamic DNS

Make sure you put the following two lines in /etc/vsftpd.conf:

    pasv_addr_resolve=YES
    pasv_address=yourdomain.noip.info

It is not necessary to use a script that updates pasv_address
periodically and restarts the server, as it can be found elsewhere!

Note:You won't be able to connect in passive mode via LAN anymore. Try
the active mode on your LAN PC's FTP client.

Tips and tricks
---------------

> PAM with virtual users

Using virtual users has the advantage of not requiring a real login
account on the system. Keeping the environment in a container is of
course a more secure option.

A virtual users database has to be created by first making a simple text
file like this:

    user1
    password1
    user2
    password2

Include as many virtual users as you wish according to the structure in
the example. Save it as logins.txt; the file name does not have any
significance. Next step depends on Berkeley database system, which is
included in the core system of Arch. As root create the actual database
with the help of the logins.txt file, or what you chose to call it:

    # db_load -T -t hash -f logins.txt /etc/vsftpd_login.db

It is recommended to restrict permissions for the now created
vsftpd_login.db file:

    # chmod 600 /etc/vsftpd_login.db

Warning:Be aware that stocking passwords in plain text is not safe.
Don't forget to remove your temporary file with rm logins.txt.

PAM should now be set to make use of vsftpd_login.db. To make PAM check
for user authentication create a file named ftp in the /etc/pam.d/
directory with the following information:

    auth required pam_userdb.so db=/etc/vsftpd_login crypt=hash 
    account required pam_userdb.so db=/etc/vsftpd_login crypt=hash

Note:We use /etc/vsftpd_login without .db extension in PAM-config!

Now it is time to create a home for the virtual users. In the example
/srv/ftp is decided to host data for virtual users, which also reflects
the default directory structure of Arch. First create the general user
virtual and make /srv/ftp its home:

    # useradd -d /srv/ftp virtual

Make virtual the owner:

    # chown virtual:virtual /srv/ftp

Configure vsftpd to use the created environment by editing
/etc/vsftpd.conf. These are the necessary settings to make vsftpd
restrict access to virtual users, by user-name and password, and
restrict their access to the specified area /srv/ftp:

    anonymous_enable=NO
    local_enable=YES
    chroot_local_user=YES
    guest_enable=YES
    guest_username=virtual
    virtual_use_local_privs=YES

If the xinetd method is used start the service. You should now only be
allowed to login by user-name and password according to the made
database.

Adding private folders for the virtual users

First create directories for users:

    # mkdir /srv/ftp/user1
    # mkdir /srv/ftp/user2
    # chown virtual:virtual /srv/ftp/user?/

Then, add the following lines to /etc/vsftpd.conf:

    local_root=/srv/ftp/$USER
    user_sub_token=$USER

Troubleshooting
---------------

> vsftpd: refusing to run with writable root inside chroot()

As of vsftpd 2.3.5, the chroot directory that users are locked to must
not be writable. This is in order to prevent a security vulnerabilty. To
do this:

    # chmod a-w /home/user

Workaround: You can put this into your /etc/vsftpd.conf to workaround
this security enhancement (since vsftpd 3.0.0; from Fixing 500 OOPS:
vsftpd: refusing to run with writable root inside chroot ()):

    allow_writeable_chroot=YES

or alternative:

Install vsftpd-ext from AUR and set in the conf file
allow_writable_root=YES

> FileZilla Client: GnuTLS error -8 when connecting via SSL

vsftpd tries to display plain-text error messages in the SSL session. In
order to debug this, temporarily disable encryption and you will see the
correct error message.[1]

See also
--------

-   vsftpd official homepage
-   vsftpd.conf man page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Very_Secure_FTP_Daemon&oldid=248142"

Category:

-   File Transfer Protocol
