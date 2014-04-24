Very Secure FTP Daemon
======================

vsftpd (Very Secure FTP Daemon) is a lightweight, stable and secure FTP
server for UNIX-like systems.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Enabling uploading
    -   2.2 Local user login
    -   2.3 Anonymous login
    -   2.4 Chroot jail
    -   2.5 Limiting user login
    -   2.6 Limiting connections
    -   2.7 Using xinetd
    -   2.8 Using SSL to Secure FTP
    -   2.9 Dynamic DNS
    -   2.10 Port configurations
    -   2.11 Configuring iptables
-   3 Tips and tricks
    -   3.1 PAM with virtual users (updated)
        -   3.1.1 Adding private folders for the virtual users
-   4 Troubleshooting
    -   4.1 vsftpd: no connection (Error 500) with recent kernels (3.5
        and newer) and .service
    -   4.2 vsftpd: refusing to run with writable root inside chroot()
    -   4.3 FileZilla Client: GnuTLS error -8 when connecting via SSL
    -   4.4 vsftpd.service fails to run on boot
-   5 See also

Installation
------------

Simply install vsftpd from the Official repositories.

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
available options and documentation, one can man vsftpd.conf (5) (or
visit vsftpd.conf online manpage). Files are served by default from
/srv/ftp.

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

    # Allow anonymous login
    anonymous_enable=YES
    # No password is required for an anonymous login          
    no_anon_password=YES
    # Maximum transfer rate for an anonymous client in Bytes/second          
    anon_max_rate=30000 
    # Directory to be used for an anonymous login           
    anon_root=/example/directory/

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

Xinetd provides enhanced capabilities for monitoring and controlling
connections. It is not necessary though for a basic good working
vsftpd-server.

Installation of vsftpd will add a necessary service file,
/etc/xinetd.d/vsftpd. By default services are disabled. Enable the ftp
service:

    service ftp
    {
            socket_type             = stream
            wait                    = no
            user                    = root
            server                  = /usr/bin/vsftpd
            log_on_success  += HOST DURATION
            log_on_failure  += HOST
            disable                 = no
    }

If you have set the vsftpd daemon to run in standalone mode make the
following change in /etc/vsftpd.conf:

    listen=NO

Otherwise connection will fail:

    500 OOPS: could not bind listening IPv4 socket

Instead of starting the vsftpd daemon start xinetd:

    # systemctl start xinetd

To start xinetd automatically at boot:

    # systemctl enable xinetd

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

  

> Port configurations

Especially for private FTP servers that are exposed to the web it's
recommended to change the listening port to something other than the
standard port 21. This can be done using the following lines in
/etc/vsftpd.conf:

    listen_port=2211

Furthermore a custom passive port range can be given by:

    pasv_min_port=49152
    pasv_max_port=65534

> Configuring iptables

Often the server running the FTP daemon is protected by an iptables
firewall. To allow access to the FTP server the corresponding port needs
to be opened using something like

    # iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 2211 -j ACCEPT

This article won't provide any instruction on how to set up iptables but
here is an example: Simple stateful firewall.

There are some kernel modules needed for proper FTP connection handling
by iptables that should be referenced here. Among those especially
ip_conntrack_ftp. It is needed as FTP uses the given listen_port (21 by
default) for commands only; all the data transfer is done over different
ports. These ports are chosen by the FTP daemon at random and for each
session (also depending on whether active or passive mode is used). To
tell iptables that packets on ports should be accepted, ip_conntrack_ftp
is required. To load it automatically on boot create a new file in
/etc/modules-load.d e.g.:

    # echo ip_conntrack_ftp > /etc/modules-load.d/ip_conntrack_ftp.conf

If you changed the listen_port you also need to configure the conntrack
module accordingly:

    /etc/modprobe.d/ip_conntrack_ftp.conf

    options nf_conntrack_ftp ports=2211
    options ip_conntrack_ftp ports=2211

Tips and tricks
---------------

> PAM with virtual users (updated)

Since PAM no longer provides pam_userdb.so another easy method is to use
pam_pwdfile. For environments with many users another option could be
pam_mysql. This section is however limited to explain how to configure a
chroot environment and authentication by pam_pwdfile.so.

In this example we create the directory vsftpd:

    # mkdir /etc/vsftpd

One option to create and store user names and passwords is to use the
Apache generator htpasswd:

    # htpasswd -c /etc/vsftpd/.passwd

A problem with the above command is that vsftpd might not be able to
read the generated MD5 hashed password. If running the same command with
the -d switch, crypt() encryption, password become readable by vsftpd,
but the downside of this is less security and a password limited to 8
characters. Openssl could be used to produce a MD5 based BSD password
with algorithm 1:

    # openssl passwd -1

Whatever solution the produced /etc/vsftpd/.passwd should look like
this:

    username1:hashed_password1
    username2:hashed_password2
    ...

Next you need to create a PAM service using pam_pwdfile.so and the
generated /etc/vsftpd/.passwd file. In this example we create a file in
the /etc/pam.d directory named vsftpd with the following content:

    auth required pam_pwdfile.so pwdfile /etc/vsftpd/.passwd
    account required pam_permit.so

Now it is time to create a home for the virtual users. In the example
/srv/ftp is decided to host data for virtual users, which also reflects
the default directory structure of Arch. First create the general user
virtual and make /srv/ftp its home:

    # useradd -d /srv/ftp virtual

Make virtual the owner:

    # chown virtual:virtual /srv/ftp

A basic /etc/vsftpd.conf with no private folders configured, which will
default to the home folder of the virtual user:

    # pointing to the correct PAM service file
    pam_service_name=vsftpd
    write_enable=YES
    hide_ids=YES
    listen=YES
    connect_from_port_20=YES
    anonymous_enable=NO
    local_enable=YES
    write_enable=YES
    dirmessage_enable=YES
    xferlog_enable=YES
    chroot_local_user=YES
    guest_enable=YES
    guest_username=virtual
    virtual_use_local_privs=YES

Some parameters might not be necessary for your own setup. If you want
the chroot environment to be writable you will need to add the following
to the configuration file:

    allow_writeable_chroot=YES

Otherwise vsftpd because of default security settings will complain if
it detects that chroot is writable.

Start the vsftpd daemon:

    # systemctl start vsftpd

You should now be able to login from a ftp-client with any of the users
and passwords stored in /etc/vsftpd/.passwd.

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

> vsftpd: no connection (Error 500) with recent kernels (3.5 and newer) and .service

add this to your /etc/vsftpd.conf

    seccomp_sandbox=NO

> vsftpd: refusing to run with writable root inside chroot()

As of vsftpd 2.3.5, the chroot directory that users are locked to must
not be writable. This is in order to prevent a security vulnerabilty.

The safe way to allow upload is to keep chroot enabled, and configure
your FTP directories.

    local_root=/srv/ftp/user

    # mkdir -p /srv/ftp/user/upload
    #
    # chmod 550 /srv/ftp/user
    # chmod 750 /srv/ftp/user/upload

  
 If you must:

You can put this into your /etc/vsftpd.conf to workaround this security
enhancement (since vsftpd 3.0.0; from Fixing 500 OOPS: vsftpd: refusing
to run with writable root inside chroot ()):

    allow_writeable_chroot=YES

or alternative:

Install vsftpd-ext from AUR and set in the conf file
allow_writable_root=YES

> FileZilla Client: GnuTLS error -8 when connecting via SSL

vsftpd tries to display plain-text error messages in the SSL session. In
order to debug this, temporarily disable encryption and you will see the
correct error message.[1]

> vsftpd.service fails to run on boot

If you have enabled the vsftpd service and it fails to run on boot, make
sure it is set to load after network.target in the service file:

    /usr/lib/systemd/system/vsftpd.service

    [Unit]
    Description=vsftpd daemon
    After=network.target

See also
--------

-   vsftpd official homepage
-   vsftpd.conf man page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Very_Secure_FTP_Daemon&oldid=302535"

Category:

-   File Transfer Protocol

-   This page was last modified on 28 February 2014, at 22:02.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
