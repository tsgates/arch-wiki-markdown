The Perfect Small Business Server(+Failover)
============================================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Small       
                           Business Server.         
                           Notes: after merging,    
                           redirect this page to    
                           Small Business Server.   
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

In this guide, we will be building ourselves a 'redundant/Highly
Available' Home/Small Business server(Cluster). We will be using two
physical nodes(computers)running the same exact services in an
'active/passive'(master/slave/Failover) HeartBeat "cluster". We will
refer to these two computers as "node1" & "node2". As I am writing this
guide the latest Arch Linux install image is Arch_2010_05(I am using the
32bit/i686 image) though I imagine we are soon due for a new image.
Again, this article was written on: 08/14/2011, August 14th, 2011. I
will personally speak for the accuracy of this article, I developed this
guide step-by-step on my own personal servers and I have since re-built
both machines following this guide to the letter, they are 100%
functional, fairly secure, and my "Highly Available" services have not
had a single moment of downtime since being initially powered on.

Contents
--------

-   1 PREFACE:
-   2 Install & Configure SSH:
-   3 Install Apache, PHP & MySQL:
    -   3.1 Configure Apache:
    -   3.2 Configure MySQL:

PREFACE:
========

On each node we will be installing & setting up the following
services/daemons:

-   DNS: Bind in a Chroot, with ProBIND PHP Web GUI To edit DNS Zones.
-   Web: Apache, With SSL.
-   PHP: PHP5.
-   Database: MySQL(i), With PHPMyAdmin Web GUI To create/edit/delete
    Databases & Users.
-   IMAP/POP3/(S): Dovecot for Incoming Mail/accounts (w/ Secure
    IMAP/POP3(?S).
-   SMTP/(S): Postfix for Outgoing Mail (+Dovecot-SSL w/ PostfixAdmin
    Web GUI).
-   RoundCubeMail: Simple, Sleek WebMail/Web GUI with sieve/spam filters
    & identities.
-   Horde: OpenSource GroupWare & Mail Web GUI Similiar to M$ Exchange
    in Features/Functionality.
-   Firewall: IPTables with the UFW: Uncomplicated Firewall FrontEnd,
    (optionally: with UFW'S GTK GUI: GUFW).

  
Following are the IP Adresses, Hostnames, & Domain Name we'll use to
refer to our machines, change these to suit your own needs, for this
guide we will have TWO "virtual/shared Highly Available/Failover IP
Addresses & Hostnames/Domains, we do this because some DNS registrars
require a MINIMUM of TWO unique NameServers, if yours does NOT, you may
use a single HA Address as such: 'ha.example.com==>192.168.1.200', for
this guide our addresses will be:

-   node1.example.dom ==> 192.168.1.101 (Hostname / IP of our 1st
    Machine)
-   node2.example.dom ==> 192.168.1.102 (Hostname / IP of our 2nd
    Machine)
-   ha1.example.dom ====> 192.168.1.201 (Hostname / IP of our 1st
    "Virtual/H.A" Address)
-   ha2.example.dom ====> 192.168.1.202 (Hostname / IP of our 2nd
    "Virtual/H.A" Address)

  
  

Install & Configure SSH:
========================

We will now install SSH/OpenSSH so that we may connect to our nodes from
a 3rd machine & manage the rest of our installation/configuration from
one(single) keyboard/mouse/monitor, you may continue to work in your
current environment if you like however, but you should still install &
configure ssh:

INPUT: the following command to install SSH/OpenSSH:

    # [root@node(1/2) ~] pacman -S openssh

EDIT: the file: /etc/ssh/sshd_config and make sure it reflects that the
following lines are UNCOMMENTED/MADE ACTIVE:

    /etc/rc.conf

    Port 22
    AddressFamily any
    ListenAddress 192.168.1.0/24
    PermitRootLogin yes
    ChallengeResponseAuthentication no
    UsePAM yes

    # override default of no subsystems
    Subsystem	sftp	/usr/lib/ssh/sftp-server

INPUT: the following command to test & make sure ssh/sshd is working:

    # [root@node(1/2) ~] /etc/rc.d/sshd start

Note: if you have any problems configuring SSH/SSHD/sshd_config file
see: https://wiki.archlinux.org/index.php/SSH

EDIT: the file: /etc/rc.conf and add sshd to the END of your daemons
array so that our SSH Server starts at boot-time:

    /etc/rc.conf

    DAEMONS=(hwclock syslog-ng logd dbus network netfs crond sshd)

You should now have your SSH server/daemon up and running, continue on
to the next step!

Install Apache, PHP & MySQL:
============================

We will now install & configure Apache with PHP & MySQL, We will do this
in two sections, first will we install & configure the basic apache
settings, then we will install PHP & create a number of "vhost.conf"
style files apache needs for a PROPER setup of: RoundCubeMail,
PHPMyAdmin, PHP, ProBIND, mysql, etc...Because we will be telling apache
to use things like PHP, PHPMyAdmin, RoundCubeMail, ProBIND, MySQL,
PostfixAdmin, Horde, etc, it (may not) start UNTIL all of the previously
mentioned packages are downloaded, unpackaged, and installed in the
proper places. IF YOU DECIDE NOT TO USE A SPECIFIC WEBAPP/PACKAGE
DESCRIBED IN THIS GUIDE, SIMPLY DO NOT PUT AN "Include packagename" LINE
for it IN: /etc/httpd/conf/httpd.conf here we go!:

INPUT: the following command to install apache, php & MySQL:

    # [root@node(1/2) ~] pacman -S apache php-apache php mysql

Configure Apache:
-----------------

CHECK: that the user & group http exists / http:http with:

    # [root@node(1/2) ~] grep http /etc/passwd

INPUT: the following to create user & group http (if it doesn't already
exist):

    # [root@node(1/2) ~] useradd -d /srv/http -r -s /bin/false -U http

EDIT: the file: /etc/httpd/conf/httpd.conf and uncomment the following,
we will UNCOMMENT/MAKE ACTIVE the ENTIRE LoadModule LIST, we will also
add a LoadModule line for PHP5 at the end of the load module list:

    # [root@node(1/2) ~] nano /etc/httpd/conf/httpd.conf 

    /etc/httpd/conf/httpd.conf

    ServerRoot "/etc/httpd"
    Listen 80
    LoadModule authn_file_module modules/mod_authn_file.so
    LoadModule authn_dbm_module modules/mod_authn_dbm.so
    LoadModule authn_anon_module modules/mod_authn_anon.so
    LoadModule authn_dbd_module modules/mod_authn_dbd.so
    LoadModule authn_default_module modules/mod_authn_default.so
    LoadModule authz_host_module modules/mod_authz_host.so
    LoadModule authz_groupfile_module modules/mod_authz_groupfile.so
    LoadModule authz_user_module modules/mod_authz_user.so
    LoadModule authz_dbm_module modules/mod_authz_dbm.so
    LoadModule authz_owner_module modules/mod_authz_owner.so
    LoadModule authnz_ldap_module modules/mod_authnz_ldap.so
    LoadModule authz_default_module modules/mod_authz_default.so
    LoadModule auth_basic_module modules/mod_auth_basic.so
    LoadModule auth_digest_module modules/mod_auth_digest.so
    LoadModule file_cache_module modules/mod_file_cache.so
    LoadModule cache_module modules/mod_cache.so
    LoadModule disk_cache_module modules/mod_disk_cache.so
    LoadModule mem_cache_module modules/mod_mem_cache.so
    LoadModule dbd_module modules/mod_dbd.so
    LoadModule dumpio_module modules/mod_dumpio.so
    LoadModule reqtimeout_module modules/mod_reqtimeout.so
    LoadModule ext_filter_module modules/mod_ext_filter.so
    LoadModule include_module modules/mod_include.so
    LoadModule filter_module modules/mod_filter.so
    LoadModule substitute_module modules/mod_substitute.so
    LoadModule deflate_module modules/mod_deflate.so
    LoadModule ldap_module modules/mod_ldap.so
    LoadModule log_config_module modules/mod_log_config.so
    LoadModule log_forensic_module modules/mod_log_forensic.so
    LoadModule logio_module modules/mod_logio.so
    LoadModule env_module modules/mod_env.so
    LoadModule mime_magic_module modules/mod_mime_magic.so
    LoadModule cern_meta_module modules/mod_cern_meta.so
    LoadModule expires_module modules/mod_expires.so
    LoadModule headers_module modules/mod_headers.so
    LoadModule ident_module modules/mod_ident.so
    LoadModule usertrack_module modules/mod_usertrack.so
    LoadModule unique_id_module modules/mod_unique_id.so
    LoadModule setenvif_module modules/mod_setenvif.so
    LoadModule version_module modules/mod_version.so
    LoadModule proxy_module modules/mod_proxy.so
    LoadModule proxy_connect_module modules/mod_proxy_connect.so
    LoadModule proxy_ftp_module modules/mod_proxy_ftp.so
    LoadModule proxy_http_module modules/mod_proxy_http.so
    LoadModule proxy_scgi_module modules/mod_proxy_scgi.so
    LoadModule proxy_ajp_module modules/mod_proxy_ajp.so
    LoadModule proxy_balancer_module modules/mod_proxy_balancer.so
    LoadModule ssl_module modules/mod_ssl.so
    LoadModule mime_module modules/mod_mime.so
    LoadModule dav_module modules/mod_dav.so
    LoadModule status_module modules/mod_status.so
    LoadModule autoindex_module modules/mod_autoindex.so
    LoadModule asis_module modules/mod_asis.so
    LoadModule info_module modules/mod_info.so
    LoadModule suexec_module modules/mod_suexec.so
    LoadModule cgi_module modules/mod_cgi.so
    LoadModule cgid_module modules/mod_cgid.so
    LoadModule dav_fs_module modules/mod_dav_fs.so
    LoadModule vhost_alias_module modules/mod_vhost_alias.so
    LoadModule negotiation_module modules/mod_negotiation.so
    LoadModulHostnameLookups One dir_module modules/mod_dir.so
    LoadModule imagemap_module modules/mod_imagemap.so
    LoadModule actions_module modules/mod_actions.so
    LoadModule speling_module modules/mod_speling.so
    LoadModule userdir_module modules/mod_userdir.so
    LoadModule alias_module modules/mod_alias.so
    LoadModule rewrite_module modules/mod_rewrite.so
    LoadModule php5_module modules/libphp5.so
    User http
    Group http
    ServerAdmin root@example.dom
    ServerName 192.168.1.101
    DocumentRoot "/srv/http"
    TypesConfig conf/mime.types
    MIMEMagicFile conf/magic

Note: make sure you put the IP address for node1 in the ServerName line
in httpd.conf on Node1, and the ip for Node2 in ServerName line for
Node2!

EDIT: the file: /etc/httpd/conf/httpd.conf: We will now ADD Include
LINES to include 'supplementary configurations' in
/etc/httpd/conf/extra/httpd-*packagename*.conf files, for all of the Web
Apps we will install(E.G RoundCubeMail), and uncomment some already
existing Include Lines, in the Include list, The lines in bold have been
ADDED, so it should look like this:

    # [root@node(1/2) ~] nano /etc/httpd/conf/httpd.conf 

    /etc/httpd/conf/httpd.conf

    # Supplemental configuration
    #
    # The configuration files in the conf/extra/ directory can be 
    # included to add extra features or to modify the default configuration of 
    # the server, or you may simply copy their contents here and change as 
    # necessary.

    # Server-pool management (MPM specific)
    #Include conf/extra/httpd-mpm.conf

    # Multi-language error messages
    Include conf/extra/httpd-multilang-errordoc.conf

    # Fancy directory listings
    Include conf/extra/httpd-autoindex.conf

    # Language settings
    Include conf/extra/httpd-languages.conf

    # User home directories
    Include conf/extra/httpd-userdir.conf

    # Real-time info on requests and configuration
    #Include conf/extra/httpd-info.conf

    # Virtual hosts
    Include conf/extra/httpd-vhosts.conf

    # Local access to the Apache HTTP Server Manual
    #Include conf/extra/httpd-manual.conf

    # Distributed authoring and versioning (WebDAV)
    #Include conf/extra/httpd-dav.conf

    # Various default settings
    Include conf/extra/httpd-default.conf

    # Secure (SSL/TLS) connections
    Include conf/extra/httpd-ssl.conf

    # Php 5 vhost-configuration
    Include conf/extra/php5_module.conf

    #phpMyAdmin vhost-configuration
    Include conf/extra/httpd-phpmyadmin.conf

    #postfixAdmin vhost-configuration
    Include conf/extra/httpd-postfixadmin.conf

    #roundcubemail vhost-configuration
    Include conf/extra/httpd-roundcubemail.conf

    #ProBIND vhost-configuration
    Include conf/extra/httpd-probind.conf

    #HORDE vhost-configuration
    Include conf/extra/httpd-horde.conf

    #
    # Note: The following must must be present to support
    #       starting without SSL on platforms with no /dev/random equivalent
    #       but a statically compiled-in mod_ssl.
    #

Note: these files do not exist yet, we will create them.

EDIT: the file: /etc/httpd/conf/mime.types: We must now ADD a "Mime
Type" FOR: PHP / PHP5 in the mime.types file, this file is in
ALPHABETICAL ORDER, Add the php mime.type line as I have, in the proper
alphabetical location shown:

    # [root@node(1/2) ~] nano /etc/httpd/conf/mime.types 

    /etc/httpd/conf/mime.types

    application/pdf                                 pdf
    application/pgp-encrypted                       pgp
    # application/pgp-keys
    application/pgp-signature                       asc sig
    application/x-httpd-php                         php
    application/pics-rules                          prf
    # application/pidf+xml
    # application/pidf-diff+xml
    application/pkcs10                              p10
    application/pkcs7-mime                          p7m p7c

EDIT: the file: /etc/httpd/conf/extra/httpd-default.conf & fix it so
that given lines read as follows:

    # [root@node(1/2) ~] nano /etc/httpd/conf/extra/httpd-default.conf

    /etc/httpd/conf/extra/httpd-default.conf

    UseCanonicalName Off
    ServerTokens Prod
    ServerSignature Off
    HostnameLookups On

We must now CREATE all of the 'vhost style files' we have defined in
httpd.conf with Include conf/extra/* lines, inside the directory:
/etc/httpd/conf/extra/, here we go:

    # [root@node(1/2) ~] nano /etc/httpd/conf/extra/httpd-phpmyadmin.conf

    /etc/httpd/conf/extra/httpd-phpmyadmin.conf

    Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"
    	<Directory "/usr/share/webapps/phpMyAdmin">
    		AllowOverride All
    		Options FollowSymlinks
    		Order allow,deny
    		Allow from all
    		php_admin_value open_basedir "/srv/:/tmp/:/usr/share/webapps/:/etc/webapps:/usr/share/pear/"
    	</Directory>

    # [root@node(1/2) ~] nano /etc/httpd/conf/extra/httpd-postfixadmin.conf

    /etc/httpd/conf/extra/httpd-postfixadmin.conf

    Alias /postfixadmin "/usr/share/webapps/PostfixAdmin"
    	<Directory "/usr/share/webapps/PostfixAdmin">
    		AllowOverride All
    		Options FollowSymlinks
    		Order allow,deny
    		Allow from all
    		php_admin_value open_basedir "/srv/:/tmp/:/usr/share/webapps/:/etc/webapps:/usr/share/pear/"
    	</Directory>

    # [root@node(1/2) ~] nano /etc/httpd/conf/extra/httpd-roundcubemail.conf

    /etc/httpd/conf/extra/httpd-roundcubemail.conf

    Alias /roundcubemail "/usr/share/webapps/RoundCubeMail"
    	<Directory "/usr/share/webapps/RoundCubeMail">
    		AllowOverride All
    		Options FollowSymlinks
    		Order allow,deny
    		Allow from all
    		php_admin_value open_basedir "/srv/:/tmp/:/usr/share/webapps/:/etc/webapps:/usr/share/pear/"
    	</Directory>

    # [root@node(1/2) ~] nano /etc/httpd/conf/extra/httpd-probind.conf

    /etc/httpd/conf/extra/httpd-probind.conf

    Alias /probind "/usr/share/webapps/ProBIND"
    	<Directory "/usr/share/webapps/ProBIND">
    		AllowOverride All
    		Options FollowSymlinks
    		Order allow,deny
    		Allow from all
    		php_admin_value open_basedir "/srv/:/tmp/:/usr/share/webapps/:/etc/webapps:/usr/share/pear/"
    	</Directory>

    # [root@node(1/2) ~] nano /etc/httpd/conf/extra/httpd-horde.conf

    /etc/httpd/conf/extra/httpd-horde.conf

    Alias /hordge "/usr/share/webapps/horde"
    	<Directory "/usr/share/webapps/Horde">
    		AllowOverride All
    		Options FollowSymlinks
    		Order allow,deny
    		Allow from all
    		php_admin_value open_basedir "/srv/:/tmp/:/usr/share/webapps/:/etc/webapps:/usr/share/pear/"
    	</Directory>

EDIT: /etc/httpd/conf/extra/httpd-vhosts.conf to reflect the following
'Virtual Hosts':

    # [root@node(1/2) ~] nano /etc/httpd/conf/extra/httpd-vhosts.conf

    /etc/httpd/conf/extra/httpd-vhosts.conf

    NameVirtualHost *:80

    <VirtualHost *:80>
        DocumentRoot "/srv/http"
        ServerAdmin root@localhost
        ErrorLog "/var/log/httpd/192.168.1.100-error_log"
        CustomLog "/var/log/httpd/192.168.1.100-access_log" common
        <Directory /srv/http/>
    		    DirectoryIndex index.htm index.html
    		    AddHandler cgi-script .cgi .pl
    		    Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
    		    AllowOverride None
    		    Order allow,deny
    		    allow from all
    	</Directory>
    </VirtualHost>
    <VirtualHost *:80>
        ServerAdmin root@example.dom
        DocumentRoot "/srv/http/"
        ServerName example.dom
        ServerAlias www.example.dom
        <Directory /serv/http/>
    		    DirectoryIndex index.htm index.html
    		    AddHandler cgi-script .cgi .pl
    		    Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
    		    AllowOverride None
    		    Order allow,deny
    		    allow from all
    	</Directory>
    </VirtualHost>

CREATE: Self Signed SSL Certificates for apache:

    # [root@node(1/2) ~] cd /etc/httpd/conf
    # [root@node(1/2) ~] openssl genrsa -des3 -out server.key 1024
    # [root@node(1/2) ~] openssl req -new -key server.key -out server.csr
    # [root@node(1/2) ~] cp server.key server.key.org
    # [root@node(1/2) ~] openssl rsa -in server.key.org -out server.key
    # [root@node(1/2) ~] openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

Note: Apache should now be set-up correctly, we will serve files for
'www.example.dom' out of /srv/http/*.html, AND for:
"www.example.dom/~username" out of /home/*username/public_html/*.html;
We have also told apache to look in /usr/share/webapps/ for the
following directories(packages/webapps): ..webapps/RoundCubeMail/,
../webapps/PostfixAdmin/, ../webapps/PHPMyAdmin/, etc, etc, using the
'Include conf/extra/httpd-*package.conf files.

Configure MySQL:
----------------

Retrieved from
"https://wiki.archlinux.org/index.php?title=The_Perfect_Small_Business_Server(%2BFailover)&oldid=203248"

Category:

-   Web Server

-   This page was last modified on 30 May 2012, at 13:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
