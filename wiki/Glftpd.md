Glftpd
======

Summary

This article discusses the installation and configuration of the
GreyLine FTP daemon on Arch Linux systems. An extensive administrative
example is provided at the end.

Related

vsftpd

Proftpd

This article describes the installation of the GreyLine FTP daemon on
Arch Linux.

GLFTPD is a secure FTP service for Unix-like operating systems which
does not require system accounts.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Historic                                                           |
| -   2 Installation                                                       |
|     -   2.1 Preperation                                                  |
|     -   2.2 installgl.sh                                                 |
|         -   2.2.1 TCDP Setup                                             |
|         -   2.2.2 JAIL Setup                                             |
|         -   2.2.3 GLFTPD BASE Setup                                      |
|         -   2.2.4 SERVICE SETUP & MULTI-INSTALL                          |
|         -   2.2.5 COMPILING SOURCES & COPYING LIBS                       |
|         -   2.2.6 PORT AND SYSTEM SETUP                                  |
|         -   2.2.7 SSL/TLS SETUP                                          |
|         -   2.2.8 STARTING GLFTPD                                        |
|         -   2.2.9 FINISH                                                 |
|                                                                          |
| -   3 Allowing access                                                    |
|     -   3.1 xinetd                                                       |
|     -   3.2 hosts.allow                                                  |
|     -   3.3 local testing                                                |
|                                                                          |
| -   4 Server Configuration                                               |
|     -   4.1 glftpd.conf                                                  |
|         -   4.1.1 Basics                                                 |
|         -   4.1.2 Folder rights                                          |
|         -   4.1.3 Encrypted file transfers                               |
|         -   4.1.4 Dupecheck                                              |
|         -   4.1.5 Behind a router?                                       |
|                                                                          |
|     -   4.2 Adding and configuring users and groups                      |
|         -   4.2.1 General tips                                           |
|         -   4.2.2 Example                                                |
|         -   4.2.3 Transfer credits                                       |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 System update killed glftpd                                  |
|                                                                          |
| -   6 External Links                                                     |
+--------------------------------------------------------------------------+

Historic
--------

glFTPd stands for GreyLine File Transfer Protocol Daemon and was named
after the initial developer GreyLine. The first public release of glFTPd
dates back to the beginning 1998. glFTPd is well known for its detailed
user permissions, extensive scripting features, extensive
configurabillity and for securely and efficiently transferring files
between other sites using FXP. glFTPd has often been used on topsites
for distribution of warez.

While development was stopped and the latest stable version of glFTPd
dates from 2005-12-25, glFTPd is still widely respected and used for its
secure nature. The official website has been closed but pzs-ng
programmers have continued mirroring glftpd on their glFTPd.dk website.

Installation
------------

glFTPd comes with a well thought through installation script that will
automatically create the required system groups, configure the most
basic options and set-up /jail if you want to.

Preperation

Install the requirements from the Official Repositories:

    $ pacman -S xinetd zip unzip openssl inetutils

  
 Install tcp_wrappers, available in the Arch User Repository:

-   tcp_wrappers

  

Note:x86_64 users sould also install lib32-glibc from the Multilib
Repository Official_Repositories#.5Bmultilib.5D

    $ sudo pacman -S lib32-glibc

  
 Start the xinetd daemon

    $ sudo /etc/rc.d/xinetd start

Note:Systemd users may start xinetd as follows:
$ sudo systemctl start xinetd.service

  
 Finally, prepare the installation files. Find a dir to work from, /tmp
is generally ok:

    $ cd /tmp

Download the latest version of the glftpd source

    $ wget http://www.glftpd.dk/files/glftpd-LNX_2.01.tgz

Unpack the source archive and enter the directory:

    $ tar -zxvf glftpd-LNX_2.01.tgz
    $ cd glftpd-LNX_2.01

installgl.sh

installgl.sh is the glFTPd installation script which will automate the
installation procedure for you.

run the installation script with root privilidges

    $ sudo ./installgl.sh

You will now be prompted with several questions, below is an example of
a jailed set-up, answers are listed in bold.

         ###  #     ##### ##### ####  ####        ###
       #   # #     #       #   #   # #   #      #   #
      #     #     ###     #   #   # #   #         #
     #  ## #     #       #   ####  #   #        # 
    #   # #     #       #   #     #   #       # 
    ###  ##### #       #   #     ####       ##### 
    --== WE MAKE FILES TRANSFER ==--
    -----------------------------------------------------------
    GLFTPD INSTALLER v2.0.1 (linux)
    Originally done by jehsom and dn.
    Made ready for the new era by turranius and psxc.  
    -----------------------------------------------------------
    Before we begin: If this installer fails on your system, please
    let the devs know. You find us on irc (efnet) in #glftpd. Thank you.
    Also, any bugs found in glftpd itself should be reported either to
    the board @ http://www.glftpd.com, in the irc channel, or both.

    Press <enter> to continue.

TCDP Setup

    TCPD SETUP
    Do you wish to use tcpd? If you are not sure then you should not
    use it. If you decided to change this at a later time, please
    search for tcpd in glftpd.docs for the required changes.
    Use tcpd? [Y]es [N]o: Y

JAIL Setup

A jailed setup will prevent normal system users from accessing the
glftpd installation while at the same time prevent users with access to
the glftpd server from accessing the rest of the system. This security
feature is highly recommended, more detailed information on jailing is
available on wikipedia.

We setup a private group for glftpd and add specific system users to
this group, only these system users will have access to glftpd's
configuration. If you choose to skip the creation of a private group
root will be the only user with access to glftpd's configuration.

    JAIL SETUP:
    Do you want to run glftpd in a "Jailed" environment?  In this
    environment a private directory will be created and glftpd will
    be installed inside.  Regular shell users will not be able to get
    inside this private directory.  The glftpd.conf is also moved
    inside for added security and a new group will be created so
    you and other users you specify can access glftpd through the shell.
    Use a jailed environment? [Y]es [N]o: Y

    Creating the jailed environment.

    Please enter the private directory to install glftpd inside [/jail]: /jail

    Do you want to create a private group?  If you say no then only root will
    be able to access glftpd.  Otherwise you can add other shell users to the
    group so they can access glftpd from the shell.
    Use a private group? [Y]es [No]: Y

    What would you like your private group to be called? [glftpd]: glftpd
    Creating private group . . . Done.

    Who should have access to glftpd? (separate with ,): username
    Setting permissions on /jail . . . Done.

GLFTPD BASE Setup

Configure the directory inside the jail to be used to install glftpd.

    GLFTPD BASE SETUP:
    Please enter the directory inside /jail to install glftpd to [/glftpd]: /glftpd

    Copying glftpd files to /jail/glftpd . . . 
    Copying required binaries to /jail/glftpd/bin . . .
    All binaries successfully copied.
    Making glftpd's /dev/null , /dev/zero & /dev/urandom . . . 

SERVICE SETUP & MULTI-INSTALL

This section of the installation will allow you to setup multiple
instances of glftpd on the same system, the default answer allows for a
single instance of glftpd.

    SERVICE SETUP & MULTI-INSTALL:
    Enter a service name for glftpd. This name will be used as the
    service name mapped to the port in /etc/services, the name
    used in your (x)inetd settings, and the name of your config-file.
    NOTE: If you (wish to) have multiple instances of glftpd on the
    same box, you *must* to change this.
    Press <enter> for the default (glftpd)> glftpd

COMPILING SOURCES & COPYING LIBS

    COMPILING SOURCES & COPYING LIBS:
    modifying source (bin/sources/glconf.h) ... OK.
    Compiling source files in /jail/glftpd/bin/sources to /jail/glftpd/bin:
       ansi2gl .. OK.
       dirlogclean .. OK.
       dirloglist .. OK.
       dirlogscanner .. OK.
       dirlogsearch .. OK.
       dupeadd .. OK.
       dupecheck .. OK.
       dupediradd .. OK.
       dupelist .. OK.
       dupescan .. OK.
       flysfv .. OK.
       ftpwho .. OK.
       glupdate .. OK.
       killghost .. OK.
       nukelogclean .. OK.
       nukelogscanner .. OK.
       olddirclean2 .. OK.
       undupe .. OK.
       userstat .. OK.
       weektop .. OK.
    All source files successfully compiled.

    Copying required shared library files:
       ld-linux.so.2: OK
       libacl.so.1: OK
       libattr.so.1: OK
       libbz2.so.1.0: OK
       libcap.so.2: OK
       libcrypt.so.1: OK
       libc.so.6: OK
       libdl.so.2: OK
       libm.so.6: OK
       libncursesw.so.5: OK
       libpcre.so.0: OK
       libpthread.so.0: OK
       libreadline.so.6: OK
       librt.so.1: OK
       libz.so.1: OK

    Copying your system's run-time library linker(s):
    (NOTE: Searches can take a couple of minutes, please be patient.)
       ld-linux.so.2: OK

    Configuring the shared library cache . . . Done.

PORT AND SYSTEM SETUP

The base port the FTP service will run on, make sure to pick a port not
already in use by another service on your system. To create a list of
ports currently in use on your system, use lsof:

    # lsof -i

    PORT AND SYSTEM SETUP:
    Enter the port you would like glftpd to listen on [1337]: 1337
    Setting userfile permissions . . .
    Adding glftpd service to /etc/services (as glftpd) . . 
    Copying glftpd.conf to /jail/glftpd.conf . . .

    Do you wish to use European weeks? European weeks starts with a Monday.
    This is for glftpd's reset binary (see docs for more info) [Y/N]: Y

SSL/TLS SETUP

SSL or TLS encryption is available to encrypt the FTP login and data
connections, this step will create a certificate inside the jail and set
glftpd up to use this certificate. It is possible to use different
certificates, this can be configured in glftpd.conf after installation
has finished

    SSL/TLS SETUP:
    We will now create a certificate for SSL/TLS support. This step is
    required.

    Please specify a generic name for this certificate.
    This can be any name but should say something about the ftp server
    like the name for it perhaps (press enter for glftpd): glftpd

    Please wait while creating certificate... (will take time!)

    1024 semi-random bytes loaded
    Generating DSA parameters, 1024 bit long prime
    This could take some time
    ....... [snip] ++++++*
    1024 semi-random bytes loaded
    Generating DH parameters, 1024 bit long safe prime, generator 2
    This is going to take a long time
    ..... [snip] ++*
    Generating DSA key, 1024 bits
    Moving ftpd-dsa.pem to /jail/glftpd//etc . . . Done

    -> IMPORTANT !!!!
    -> If you get TLS errors of any kind, read instructions in README.TLS
    -> included in this package!

STARTING GLFTPD

The script has now completed the configuration of your server and will
now write the configuration to glftpd.conf and set the service up to be
started.

    STARTING GLFTPD:

    Copying /etc/resolv.conf to /jail/glftpd/etc/resolv.conf . . . Done.
    Configuring xinetd for glftpd . . . Done.
    Restarting xinetd . . . Succes.

    Adding crontab entry to tabulate site stats nightly . . . Done.

    chmod'ing the site/ dir . . . Done.

FINISH

    FINISH:
    Congratulations, glFtpD has been installed. Scroll up and note any errors
    that needs fixing. ./installgl.debug contains a log of the installation process.
    To get your site running, you must edit \033[1m/jail/glftpd.conf\033[0m according to
    the instructions in /jail/glftpd/docs/glftpd.docs.
    For help, visit #glftpd on EFnet after you've read (not skimmed) the docs/faq.

    After configuring glftpd, visit the following websites for additional
    scripts to give your site some style!:
    Turranius - http://www.grandis.nu/glftpd
    Jehsoms - http://runslinux.net/
    http://www.chimera-coding.com
    D-ViBEs collection - http://www.glftpd.at

    The official glftpd homepage is located at http://www.glftpd.com

    Thanks for your support!
    the glFtpD team

Allowing access
---------------

> xinetd

To start xinetd at boot, please add "xinetd" to the DAEMONS section of
rc.conf:

    /etc/rc.conf

    DAEMONS=(syslog-ng network ... ... xinetd)

> hosts.allow

By default, tcp_wrappers will deny any connection to the system from the
outside. To allow people people to access the FTP server, please add the
following to hosts.allow:

    /etc/hosts.allow

    glftpd: ALL

> local testing

First, make sure you have xinetd running and have allowed access to
glftpd in /etc/hosts.allow.

During installation through install.sh, a single administrative FTP user
was created. This user has full access to glftpd's features and can only
log in to the ftp service from the system itself (localhost).

    ftp username: glfptd
    ftp password: glftpd

To log on to the ftp service, use the ftp command. <port> is the
portnumber you chose during installation (1337 in the example):

    ftp 127.0.0.1 <port>

Example:

    # ftp 127.0.0.1 1337
    Connected to 127.0.0.1.
    220 MY SITE NAME (glFTPd 2.00 Linux+TLS) ready.
    Name (127.0.0.1:root): glftpd
    331 Password required for glftpd.
    Password:
    230-                                _____
    230- ______________________________|__   |____ ________________________________
    230- \     _      /   _     /  _     /   |    |    _     /  _     /    _      /
    230-  \    \     /    /    /   /____/.   |    |    /    /   /____/.    /_____/
    230-   \________/____/    /______    |___|____|___/    /______    |____|
    230- .-=----------- /____/ ---- |____| --------- /____/ ---- |____| -------=-.
    230- `-=-------------------------------------------------------------------=-'
    230-       `-----( Type 'site onel MESSAGE' to enter your message )-----'
    230 User glftpd logged in.
    Remote system type is UNIX.
    Using binary mode to transfer files.
    ftp>

Success! to log off, type bye:

    ftp> bye
    221- Goodbye
    221

Server Configuration
--------------------

Glftpd's configuration is divided in 2 systems that each handle a
different aspect of the configuration:

-   glftpd.conf configures server properties, encryption settings,
    directory rights, and connection settings.
-   site commands are mainly for user and group related configuration.

> glftpd.conf

glftpd.conf is the main configuration file for glFTPd. The default
configuration works well in a local testing set-up, but needs some
attention before the server can be considered operational.

Note: glftpd.conf is available in /jail/glftpd.conf if you followed the
example installation

Basics

Configures if your FTP is up, down or open to admin only: (0=up, 1=admin
only, !*=down, default (commented with #) is up)

    # shutdown 1

The FTP long name:

    sitename_long MY[:space:]SITE[:space:]NAME

The FTP short name:

    sitename_short MSN 

Admin E-Mail adress:

    email root@127.0.0.1 

The ammount of users that can be online at the same time, the first
number specifies the maximum amount of users allowed to connect to the
site. The second number specifies how many exempt users can connect, if
the site is already full. They must have exempt flag for this to work.
Exempt users take up a slot, just like everyone else, so if you have
max_users 5 5, and you have 5 exempt users logged in, non-exempt users
won't be able to login.

    max_users 15 5

The maximum ammount of accounts that can be registered with the server:

    total_users 300

Folder rights

Folder rights configure which user(s) or group(s) are allowed to perform
operations (read, write, create, delete) on folders. This is usefull as
it will allow you to prevent users or groups deleting files or adding
files when you don't want them too.

To configure this, edit /jail/glftpd.conf and look for this section:

    /jail/glftpd.conf

     ##############################################################################
     ##################     THE RIGHTS SECTION BEGINS HERE     ####################
     ##############################################################################
     # (you can use a ! in front of any group/user/flag to negate it)             #
     # The default is no, you don't need to add "!*" at the end                   #
     #                                                                            #
     # Function       Path                   =GROUP or -username or X (flag)      #
     ##############################################################################
     
     upload          *                               *
     resume          *                               *
     makedir         *                               *
     download        *                               *
     dirlog          *                               *
     rename          *                               1 =STAFF
     filemove        *                               1 =STAFF
     renameown       *                               *
     nuke            *                               *
     delete          *                               1
     deleteown       *                               *
     
     ##############################################################################
     ###################     THE RIGHTS SECTION ENDS HERE     #####################
     ##############################################################################

Now, let's say we add a user called upload. We want this user to be
capable of:

-   Creating new folders
-   Uploading new files and resuming uploads
-   Deleting his own files

We also want our siteops, or site operators, (everybody with the 1 flag,
look below for explenation) to be allpowerfull everywhere. Lastly, we
want our group ftpusers to be able to download from everywhere.

    /jail/glftpd.conf

     ##############################################################################
     ##################     THE RIGHTS SECTION BEGINS HERE     ####################
     ##############################################################################
     # (you can use a ! in front of any group/user/flag to negate it)             #
     # The default is no, you don't need to add "!*" at the end                   #
     #                                                                            #
     # Function       Path                   =GROUP or -username or X (flag)      #
     ##############################################################################
     
     upload          *                               1 -upload
     resume          *                               1 =ftpusers -upload
     makedir         *                               1 -upload
     download        *                               1 =ftpusers
     dirlog          *                               1
     rename          *                               1
     filemove        *                               1
     renameown       *                               1
     nuke            *                               1
     delete          *                               1 -upload
     deleteown       *                               1 -upload
     
     ##############################################################################
     ###################     THE RIGHTS SECTION ENDS HERE     #####################
     ##############################################################################

It should be noted that a * in the Path collum superseeds any other
configuration. Example:

    /jail/glftpd.conf

    upload          *                               -upload

This allows the user upload to upload anywhere it is allowed to go
(you're able to configure the home directory any user is limited to
through site commands)

    /jail/glftpd.conf

    upload          *                               1
    upload          /site/uploads                   -upload

Here, the first line states that only people with flag 1 are allowed to
upload anywhere. Now since /site/uploads is within "anywhere", the
second line has no effect.

    /jail/glftpd.conf

    upload          /site/dir1                       1
    upload          /site/dir2                       1
    upload          /site/dir3                       1
    upload          /site/uploads                   -upload

In this third example, any user with flag 1 is allowed to upload to
dir1, dir2 and dir3. Nobody else will be allowed to upload to those
locations. user upload is allowed to upload to uploads, nobody else.

By this I hope I have made it clear that any user on the ftp has to be
allowed to do anything, the default is no acess to do anything at all.

Encrypted file transfers

glFTPd allows you to require your users to log on and transfer data with
encryption enabled. The installation script has created a certificate
you can use, we just need to set-up who will be required to use
encryption to access the server.

The certificate that was created during installation is available in
/jail/glftpd/etc/ftpd-dsa.pem

Open /jail/glftpd.conf with your favorite editor and look for the
following (near the top of the file):

    /jail/glftpd.conf

    #if you have dsa cert file
    DSA_CERT_FILE /jail/glftpd//etc/ftpd-dsa.pem

Now, look for the following:

    /jail/glftpd.conf

    # TLS enforcements.
    userrejectsecure        !*
    userrejectinsecure      !*
    denydiruncrypted        !*
    denydatauncrypted       !*

! means not, * means everybody. This means that, currently, nobody is
being rejected or denied based on secure or insecure log on. Now, let's
make it so that:

-   Everybody connecting without encryption will be denied
-   The account useraccountname will be exempt from this rule and will
    be allowed to log on without encryption, but will not be denied if
    he logs on with encryption.
-   The group groupname will be rejected if it tries to log on with
    encryption.

    /jail/glftpd.conf

    # TLS enforcements.
    userrejectsecure        =groupname !*
    userrejectinsecure      !-useraccountname *
    denydiruncrypted        !-useraccountname *
    denydatauncrypted       !-useraccountname *

Dupecheck

By default, glFTPd checks for double files in the FTP's directory. Based
on filenames, glFTPd may reject files and deny them during upload.
Disabeling this feature can be usefull. Look for the following line in
/jail/glftpd.conf:

    /jail/glftpd.conf

    # dupecheck     how many days?  ignore file case like Windows?
     dupe_check      7               no

And change the default value of "7" to "0":

    /jail/glftpd.conf

    # dupecheck     how many days?  ignore file case like Windows?
     dupe_check      0               no

Behind a router?

If you're running the FTP daemon from behind a router, you will need to
configure glftpd.conf accordingly. You will want to operate the FTP in
passive mode and define a port range for passive connections.
Additionally, you will need to tell glFTPd what your WAN IP is.

Configures the PASV mode (used behind routers) portrange:

    /jail/glftpd.conf

    pasv_ports <X>-<Y>

Configures the PASV mode IP, this is your WAN IP (click here to
determine your WAN IP)

Note: This port range needs to be outside the main ftp port you chose
during set-up.

Note: the trailing 1 is required if you're behind a router!

    /jail/glftpd.conf

    pasv_addr xxx.xxx.xxx.xxx 1

The default glftpd.conf file does not include these options, you can
just add them to the end of the file.

Note: When behind a router, you will need to apply a technique called
"port forwarding" (sometimes called "virtual server") to allow traffic
to reach your server correctly. Please refer to portforward.com for more
information.

> Adding and configuring users and groups

glFTPd's users, groups and their respective settings (such as download
speed, max. connections etc.) have to be configured by use of site
commands. site commands are used when already logged on to the ftp
server and are interpreted by glftpd.

General tips

glFTPd's help feature and documentation is extensive and provides
extremely helpful examples. For example, users can acess a list of all
basic configuration commands with:

    ftp> site help

if you're unsure about a command syntax, or want to know options, you
can simply do:

    ftp> site <command>

example:

    ftp> site addip
    200-  .------------------------------------------------.
    200- | USAGE: SITE ADDIP <username> <ident@ip>          |
    200- |                                                  |
    200- |  <username> The username to add.                 |
    200- |  <ident@ip> The IP address to add.               |
    200- |                                                  |
    200- | You can use [,],?, and * in the IPs.             |
    200- | Note that a user may have a maximum of 10 IP's.  |
    200- |                                                  |
    200- | Examples: SITE ADDIP user frank@*.netcom.com     |
    200- |           SITE ADDIP user blah@128.23.222.15     |
    200- |           SITE ADDIP user a@24.1.5.[345][789]    |
    200- |           SITE ADDIP user *@205.241.224.*        |
    200-  `------------------------------------------------'
    200 Command Successful.

  
 As a final tip, any command you apply to a user can be applied to a
group. This is good when wanting to apply speedlimits, connectionlimits
or other options to all users in that group. In this example, we will
apply a download speed limit to all users in our ftpusers group.

    ftp> site change =ftpusers max_dlspeed 250
    200 Change command applied to 2 users.

Specific commands to be applied to groups only (i.e. max ammount of
logins per group) are discussed in the example, or can be found in
glFTPd's help feature.

Example

The following example will show you how to:

-   Create an admin account to remotely administrate the server.
-   Create a new group, called ftpusers (note that this group is only
    available on glFTPd and has no link to linux usergroups).
-   Create a new user, called archie (note that this user is only
    available on glFTPd and has no link to linux usergroups).
-   Add this user to the ftpusers group.

  

-   Configure several settings for our new user archie.
-   Configure several options for our group ftpusers.

  
 Log on to the server:

    ftp 127.0.0.1 <port>

Create the new user admin, along with the password for this account:

    ftp> site adduser admin adminpassword
    200 User (admin) succesfully added.

Now, let's add an IP with which the admin user is allowed to log on. *@*
allows admin to log on from any ip.

    ftp> site addip admin *@*
    200- IP '*@*' successfully added to admin.

Flags represent special rights on the server such as group admin or user
kick rights. The meaning of these flags is available in the
documentation. To list the flags your new admin user has, do:

    ftp> site flags admin
    200- FLAGS for user admin ...
    200-
    200-    [ ]SITEOP    -1-
    200-    [ ]GADMIN    -2-
    200-    [*]GLOCK     -3-
    200-    [ ]EXEMPT    -4-
    200-    [ ]COLOR     -5-
    200-    [ ]DELETED   -6-
    200-    [ ]USEREDIT  -7-
    200-    [ ]ANONYMOUS -8-
    200-    [ ]NUKE      -A-
    200-    [ ]UNNUKE    -B-
    200-    [ ]UNDUPE    -C-
    200-    [ ]KICK      -D-
    200-    [ ]KILL      -E-
    200-    [ ]TAKE      -F-
    200-    [ ]GIVE      -G-
    200-    [ ]USERS     -H-
    200-    [ ]IDLER     -I-
    200-    [ ]CUST1     -J-
    200-    [ ]CUST2     -K-
    200-    [ ]CUST3     -L-
    200-    [ ]CUST4     -M-
    200-    [ ]CUST5     -N-

We want our user admin to have: SITEOP (1), USEREDIT (7), KICK (D), KILL
(E) and USERS (H).

    ftp> site change admin flags +17DEH
    200- Command Successfull.

Create the new usergroup, ftpusers with:

    ftp> site grpadd ftpusers
    200- Group (ftpusers) successfully added.

Add the user admin to the ftpusers group:

    ftp> site chgrp admin ftpusers
    200- 'admin' has been successfully added to 'ftpusers'

Now, make admin group admin for the ftpusers group:

    ftp> site chgadmin admin ftpusers
    200- 'admin' has been successfully added as gadmin for 'ftpusers'

Add the user archie, along with the password for this account:

    ftp> site adduser archie archrocks
    200 User (archie) succesfully added.

Adding IP to archie:

    ftp> site addip archie *@*
    200- IP '*@*' successfully added to archie.

Add the user archie to the ftpusers group:

    ftp> site chgrp archie ftpusers
    200- 'archie' has been successfully added to 'ftpusers'

  
 We now have:

-   Our admin account, able to remotely configure the server, configure
    users and is groupadmin of the main ftpusers group.
-   Our archie account.
-   Our main ftpusers group.

  
 Now that our user archie can log on, we need to set some options to
prevent him doing things we don't want. Let's set the following options
for our user archie:

-   Max 1 login at the same time
-   Max 1 connections from the same IP
-   Max 1 simultaneous download (trivial in this case, since we already
    have max 1 connection. This serves as informative option for you)
-   Max downloadspeed of 250 kbyte / second.
-   User can log on between 10:00 and 21:00

  
 Max 1 login at the same time, 1 connection from the same IP:

    ftp> site change archie num_logins 1 1
    200 Command Successful.

Max 1 simultaneous download:

    ftp> site change archie max_sim_down 1
    200- Changed max simultaneous downloads for archie to 1.
    200 Command Successful.

Max downloadspeed of 250 kbyte / second:

    ftp> site change archie max_dlspeed 250
    200- Changed max download speed for archie to 250 KB/s
    200 Command Successful.

User can log on between 10:00 and 21:00:

    ftp> site change archie timeframe 10 21
    200 Command Successful.

  
 Finally, let's change some group options:

-   Max 1 user in this group may be online at the same time
-   Max 10 users may exist in this group

  
 Max 1 user in this group may be online at the same time:

    ftp> site grpchange ftpusers max_logins 1
    200 Command Successful.

Max 10 users may exist in this group:

    ftp> site grpchange ftpusers slots 10
    200 Command Successful.

Transfer credits

glFTPd uses a credit system which is on by default. The credit system is
simple: Uploads give you credits (at a certain ratio), Downloads cost
you credits. This feature can be usefull, but isn't in most day to day
ftp applications. The simpelest way to disable this system is to set the
ratio to 0 for all users, or give them a high ammount of credits.

    site change username ratio 0

This will set the Upload/Download ratio for that user to 0, this will
effectively disable the credit system for that user. This situation
referred to as "leech" in the community. Many options to configure the
credit system are available, please refer to the docs for options.

Troubleshooting
---------------

> System update killed glftpd

A system update may remove the glftpd line from /etc/services, to
restore functionallity simply add

    /etc/services

    glftpd         portnumber/tcp

External Links
--------------

-   glFTPd.dk (semi-official website, updated and supported by pzs-ng
    staff members)
-   glFTPd Docs - Official documentation on installation and
    configuration of glFTPd.
-   Ubuntu glFTPd Guide - Source for parts of this guide.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Glftpd&oldid=223243"

Category:

-   File Transfer Protocol
