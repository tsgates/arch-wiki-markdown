SOHO Postfix
============

This tutorial will configure Postfix using MySQL as backend,
Courier-IMAP or Dovecot for IMAP-SSL, Postfix Admin for virtual
domains/users management, Spamassassin for spam filtering, and
SquirrelMail for webmail. Mailing list and anti-virus are in the works.

What this tutorial doesn't do is a thorough explanation of how
everything works with each other. If you are the curious mind, check out
the project's documentations. I also expect you already have a good
working Apache and MySQL servers.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Required packages                                                  |
| -   2 Downloads                                                          |
| -   3 What is Postfix?                                                   |
| -   4 Installation                                                       |
|     -   4.1 Software installation                                        |
|     -   4.2 General configuration                                        |
|         -   4.2.1 Setup folder to store domain e-mails                   |
|         -   4.2.2 SSL certs                                              |
|             -   4.2.2.1 Courier-IMAP                                     |
|                                                                          |
|         -   4.2.3 Webmail                                                |
|             -   4.2.3.1 SquirrelMail                                     |
|             -   4.2.3.2 RoundCube                                        |
|                                                                          |
|         -   4.2.4 Spamassassin                                           |
|         -   4.2.5 Postfix Admin                                          |
|         -   4.2.6 Courier-IMAP and Courier-authlib                       |
|         -   4.2.7 Dovecot                                                |
|         -   4.2.8 PHP                                                    |
|         -   4.2.9 Postfix                                                |
|         -   4.2.10 SMTP-AUTH                                             |
|                                                                          |
| -   5 Put into production!                                               |
|     -   5.1 Firing up services!                                          |
|     -   5.2 Verify working                                               |
|     -   5.3 Post-installation                                            |
|                                                                          |
| -   6 Notes                                                              |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Required packages
-----------------

-   postfix
-   mysql (phpmyadmin is optional but recommended!)
-   courier-imap
-   dovecot
-   courier-authlib
-   apache
-   php
-   squirrelmail
-   spamassassin

Downloads
---------

-   Postfix Admin

The latest stable release as of this writing is v2.1.0.

What is Postfix?
----------------

From Postfix.org...

    What is Postfix? It is Wietse Venema's mailer that started life at IBM research as an
    alternative to the widely-used Sendmail program.

    Postfix attempts to be fast, easy to administer, and secure. The outside has a definite
    Sendmail-ish flavor, but the inside is completely different.

If you want to know how exactly Postfix works, check out Anatomy of
Postfix!

Installation
------------

> Software installation

Installs Arch packages with following.

    pacman -S php mysql apache postfix dovecot courier-imap courier-authlib squirrelmail spamassassin

Note: postfixadmin can be found in AUR

Download Postfix Admin, extract into /home/httpd/html/ and make a
symlink.

    ln -s /home/httpd/html/postfixadmin-2.1.0 /home/httpd/html/postfixadmin

(there's a new folder structure for apache in Arch: the default httpd
folder for html documents is /srv/http)--mvinnicius 08:38, 31 January
2011 (EST)

(If you install from AUR postfixadmin can be found in
/usr/share/webapps/postfixAdmin/) -- Foppe (talk)

> General configuration

Setup folder to store domain e-mails

All your domains emails will go under /home/vmail/.

    groupadd -g 5000 vmail
    useradd -u 5000 -g vmail -s /sbin/nologin -d /home/vmail -m vmail
    chmod 750 /home/vmail

SSL certs

Certificates generated here can be used by httpd, ftp or any other
services supports SSL.

    cd /etc/ssl/certs
    openssl req -new -x509 -newkey rsa:1024 -days 365 -keyout server.key -out server.crt

When asked about "Common Name", use your FQDN. i.e.
http://linuxmonkey.net

    openssl rsa -in server.key -out server.key

Above removes passphrase.

    chown nobody:nobody server.key
    chmod 600 server.key
    mv server.key /etc/ssl/private/

Above are extra securities in case you actually wants to use SSL the
real way.

* * * * *

Courier-IMAP

Courier-IMAP's SSL cert is a little different.

    vi /etc/courier-imap/imapd.cnf

Make it to suit your environment.

    /usr/sbin/mkimapdcert

Will generate /usr/share/imapd.pem

    mv /usr/share/imapd.pem /etc/courier-imap/

Move the newly generated Courier-IMAP SSL cert.

Webmail

SquirrelMail

Make the folder.

    mkdir /var/lib/squirrelmail
    chown nobody:nobody /var/lib/squirrelmail

Configure SquirrelMail on CLI.

    cd /home/httpd/html/squirrelmail/config - (is now /srv/http/squirrelmail/config), 04.12.2011 
    perl conf.pl

RoundCube

Yes, it works! Check it out here!

    RoundCube Webmail is a browser-based multilingual IMAP client with an application-like user interface.
    It provides full functionality you expect from an e-mail client, including MIME support, address book,
    folder manipulation, message searching and spell checking. RoundCube Webmail is written in PHP and
    requires a MySQL or Postgres database. The user interface is fully skinnable using XHTML and CSS 2.

As for the configuration of RoundCube, note that I'm using PostfixAdmin
2.2.1.1, which can make the query quite different. For the
configuration, you should look in the main.inc.php, and consider several
options:

    $rcmail_config['auto_create_user'] = TRUE;
    $rcmail_config['default_host'] = 'your.fdm';
    $rcmail_config['virtuser_query'] = 'SELECT username FROM postfix.mailbox WHERE username = "%u" or name = "%u"';
    $rcmail_config['smtp_server'] = 'mail.your.fdm';
    $rcmail_config['smtp_user'] = '%u';
    $rcmail_config['smtp_pass'] = '%p';
    $rcmail_config['smtp_helo_host'] = 'your.fdm';
    $rcmail_config['imap_root'] = 'INBOX'; // Important: Otherwise, folders like "Sent" and "Trash" will not be created
    $rcmail_config['create_default_folders'] = TRUE;
    $rcmail_config['enable_spellcheck'] = FALSE; // Communicates with Google - do we want this?

Spamassassin

Go over /etc/mail/spamassassin/local.cf and configure it to your needs.

Create Spamassassin user/group and folder.

    groupadd -g 5001 spamd
    useradd -u 5001 -g spamd -s /sbin/nologin -d /var/lib/spamassassin -m spamd
    chown spamd:spamd /var/lib/spamassassin

Make sure /etc/conf.d/spamd look like following.

    SAHOME="/var/lib/spamassassin/"
    SPAMD_OPTS="--create-prefs --max-children 5 --username spamd --helper-home-dir ${SAHOME} -s ${SAHOME}spamd.log --pidfile /var/run/spamd.pid"

To leave the service ready to run, let's update the spamassassin
matching patterns.

    /usr/bin/vendor_perl/sa-update

Postfix Admin

* * * * *

Obs1: There's a package in AUR

Obs2: The user/group in the recent apache pkg are http:http)

Obs3: Check the instructions for the use of setup.php in the
postfixadmin folder --mvinnicius 08:47, 31 January 2011 (EST)

* * * * *

Sets up correct permissions.

    chown -R nobody:nobody /home/httpd/html/postfixadmin-2.1.0/
    cd /home/httpd/html/postfixadmin/
    chmod 640 *.php
    cd /home/httpd/html/postfixadmin/admin/
    chmod 640 *.php
    cd /home/httpd/html/postfixadmin/images/
    chmod 640 *.png
    cd /home/httpd/html/postfixadmin/languages/
    chmod 640 *.lang
    cd /home/httpd/html/postfixadmin/templates/
    chmod 640 *.php
    cd /home/httpd/html/postfixadmin/users/
    chmod 640 *.php

Look at /home/httpd/html/postfixadmin/DATABASE_MYSQL.TXT and modify the
lines with password of your like. (edited by silvernode NOTE:
DATABASE_MYSQL.txt does not seem to exist in postfixadmin-2.3.2)

    INSERT INTO user (Host, User, Password) VALUES ('localhost','postfix',password('YOUR_NEW_PASSWD'));
    (Line 28?)

    INSERT INTO user (Host, User, Password) VALUES ('localhost','postfixadmin',password('YOUR_NEW_PASSWD'));
    (Line 31?)

Load Postfix Admin MySQL database structure.

    /etc/rc.d/mysqld start
    mysql -u root -p < /home/httpd/html/postfixadmin/DATABASE_MYSQL.TXT
    /etc/rc.d/mysqld stop

(Remember to remove YOUR_NEW_PASSWD from
/home/httpd/html/postfixadmin/DATABASE_MYSQL.TXT!)

Make Postfix Admin configuration file.

    cp /home/httpd/html/postfixadmin/config.inc.php.sample /home/httpd/html/postfixadmin/config.inc.php
    chmod 640 /home/httpd/html/postfixadmin/config.inc.php

You may want to go over /home/httpd/html/postfixadmin/config.inc.php and
configure it to suit you, but the following line needs to match what
password you set above.

    $CONF['database_password'] = 'YOUR_NEW_PASSWD';
    (Line 32?)

Make sure it uses newer MySQL protocol

    $CONF['database_type'] = 'mysqli';
    (Line 29?)

Courier-IMAP and Courier-authlib

Courier-IMAP is a bit harder to configure and noticeably slower compared
to Dovecot. However, if you prefer something tried-and-true,
Courier-IMAP won't disappoint you.

Make sure following files have following contents.

-   /etc/conf.d/courier-imap

    CI_DAEMONS="imapd-ssl"

-   /etc/authlib/authdaemonrc

    authmodulelist="authmysql"

-   /etc/authlib/authmysqlrc

    MYSQL_SERVER            localhost
    MYSQL_USERNAME          postfix
    MYSQL_PASSWORD          YOUR_NEW_PASSWD
    MYSQL_SOCKET            /tmp/mysql.sock
    MYSQL_PORT              3306
    MYSQL_OPT               0
    MYSQL_DATABASE          postfix
    MYSQL_USER_TABLE        mailbox
    MYSQL_CRYPT_PWFIELD     password
    MYSQL_UID_FIELD         5000
    MYSQL_GID_FIELD         5000
    MYSQL_LOGIN_FIELD       username
    MYSQL_HOME_FIELD        "/home/vmail"
    MYSQL_MAILDIR_FIELD     maildir
    MYSQL_QUOTA_FIELD       quota

-   /etc/courier-imap/imapd-ssl

    IMAPDSSLSTART=YES
    TLS_PROTOCOL=SSL23
    TLS_CERTFILE=/etc/courier-imap/imapd.pem

Dovecot

    Dovecot is an open source IMAP and POP3 server for Linux/UNIX-like systems, written with security
    primarily in mind. Dovecot is an excellent choice for both small and large installations. It's fast,
    simple to set up, requires no special administration and it uses very little memory.

At this time Dovecot is recommended as it is faster and newer than
courier-imap, it is also much easier to setup

Make sure the following files with following contents.

I strongly recommend go over all settings within this file, but I've
listed what's required.

-   /etc/dovecot/dovecot.conf

Obs: In the recent package, besides the dovecot.conf file, the
configurations below are splitted in other files at
/etc/dovecot/conf.d--mvinnicius 09:02, 31 January 2011 (EST)

    protocols = imap # since new version of dovecot, 'imaps' is not necessary 
    ssl = yes # or can be ssl = required
    ssl_cert = </etc/ssl/certs/server.crt
    ssl_key = </etc/ssl/private/server.key
    first_valid_uid = 5000
    first_valid_gid = 5000
    auth_username_chars = abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890.-_@
    namespace {
     inbox = yes
     location = maildir:/home/vmail/%u/ #The %u is needed since this setting overrides all others, probably this isn't even needed if you have the mysql setup
     #see http://wiki.dovecot.org/MailLocation
     prefix = 
     separator = /
     type = private
    }
    protocol imap {
      imap_client_workarounds = delay-newmail tb-extra-mailbox-sep
    }
    protocol lda {
     postmaster_address = admin@YOUR_DOMAIN.TLD
     hostname = YOUR_SERVER_NAME
     sendmail_path = /usr/sbin/sendmail
    }
    service auth {
     unix_listener /var/spool/postfix/private/auth {
       group = postfix
       mode = 0666
       user = postfix
     }
     unix_listener auth-userdb {
       group = vmail
       mode = 0600
       user = vmail
     }
    }
    userdb {
     args = /etc/dovecot/dovecot-sql.conf
     driver = sql
    }
    passdb {
      driver = sql
      args = /etc/dovecot/dovecot-sql.conf
    }

  

-   /etc/dovecot/dovecot-sql.conf

    driver = mysql #if you are using mysql, check the dovecot wiki for other options
    connect = host=localhost dbname=postfix user=postfix password=YOUR_NEW_PASSWD
    default_pass_scheme = CRYPT
    password_query = SELECT password FROM mailbox WHERE username = '%u' AND active = '1'
    user_query = SELECT maildir AS mail, 5000 AS uid, 5000 AS gid, "/home/vmail" AS home FROM mailbox WHERE username = '%u' AND active = '1'

PHP

Edit /etc/php/php.ini and make the following changes.

    magic_quotes_gpc = On
    (Required for Postfix Admin)

    open_basedir = /home/:/tmp/:/usr/share/pear/:/var/lib/squirrelmail/
    (Required for SquirrelMail)

Postfix

I strongly recommend you go through all the lines in
/etc/postfix/main.cf and configure it to your needs. Only followings are
required for this setup!

    mydestination = localhost

    mynetworks_style = host

    relay_domains = $mydestination

Add the following to end of /etc/postfix/main.cf.

    # Postfix with MySQL maps (Configure domain emails with Postfix Admin)
    #
    # Virtual Mailbox Domain Settings
    virtual_alias_maps = mysql:/etc/postfix/mysql_virtual_alias_maps.cf
    virtual_mailbox_domains = mysql:/etc/postfix/mysql_virtual_domains_maps.cf
    virtual_mailbox_maps = mysql:/etc/postfix/mysql_virtual_mailbox_maps.cf
    virtual_mailbox_limit = 51200000
    virtual_minimum_uid = 5000
    virtual_uid_maps = static:5000
    virtual_gid_maps = static:5000
    virtual_mailbox_base = /home/vmail
    virtual_transport = virtual
    # Additional for quota support
    virtual_create_maildirsize = yes
    virtual_mailbox_extended = yes
    virtual_mailbox_limit_maps = mysql:/etc/postfix/mysql_virtual_mailbox_limit_maps.cf
    virtual_mailbox_limit_override = yes
    virtual_maildir_limit_message = Sorry, your maildir has overdrawn your diskspace quota, please free up some space and try again.
    virtual_overquota_bounce = yes

(Above addition scrapped from Ubuntu Wiki (Postfix Complete Virtual Mail
System) <=== NOT COMPLETE!)

Create the following Postfix maps with contents provided but change out
the password.

    In Postfix, lookup tables are called maps. Postfix uses maps not only to find out
    where to send mail, but also to impose restrictions on clients, senders, and recipients,
    and to check certain patterns in email content.

-   /etc/postfix/mysql_virtual_alias_maps.cf

    user = postfix
    password = YOUR_NEW_PASSWD
    hosts = localhost
    dbname = postfix
    table = alias
    select_field = goto
    where_field = address

-   /etc/postfix/mysql_virtual_domains_maps.cf

    user = postfix
    password = YOUR_NEW_PASSWD
    hosts = localhost
    dbname = postfix
    table = domain
    select_field = domain
    where_field = domain
    #additional_conditions = and backupmx = '0' and active = '1'

-   /etc/postfix/mysql_virtual_mailbox_maps.cf

    user = postfix
    password = YOUR_NEW_PASSWD
    hosts = localhost
    dbname = postfix
    table = mailbox
    select_field = maildir
    where_field = username
    #additional_conditions = and active = '1'

-   /etc/postfix/mysql_virtual_mailbox_limit_maps.cf

    user = postfix
    password = YOUR_NEW_PASSWD
    hosts = localhost
    dbname = postfix
    table = mailbox
    select_field = quota
    where_field = username
    #additional_conditions = and active = '1'

Set the proper permissions on those map files.

    chgrp postfix /etc/postfix/mysql_*.cf
    chmod 640 /etc/postfix/mysql_*.cf

Make Postfix pipe mails through Spamassassin first.

-   /etc/postfix/master.cf

    smtp      inet  n       -       n       -       -       smtpd -o content_filter=spamassassin
    spamassassin    unix    -       n       n       -       -       pipe user=nobody argv=/usr/bin/vendor_perl/spamc -f -e /usr/sbin/sendmail -oi -f ${sender} ${recipient}

SMTP-AUTH

This is *OPTIONAL*! I do recommend you use your ISP's SMTP service to
send your e-mails.

Basic setup is using SMTPS (SSL; port 465) using SASL+PAM to
authenticate with MySQL backend.

Install some packages first.

    pacman -S cyrus-sasl cyrus-sasl-plugins pam_mysql

Make the following modifications to specified files.

-   /etc/postfix/main.cf

    relay_domains = *

    smtpd_sasl_auth_enable = yes
    smtpd_relay_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination
    smtpd_sasl_security_options = noanonymous
    smtpd_sasl_tls_security_options = $smtpd_sasl_security_options
    smtpd_tls_auth_only = yes
    smtpd_tls_cert_file = /etc/ssl/certs/server.crt
    smtpd_tls_key_file = /etc/ssl/private/server.key
    smtpd_sasl_local_domain = $mydomain
    broken_sasl_auth_clients = yes
    smtpd_tls_loglevel = 1

-   /etc/postfix/master.cf

    smtps inet n - n - - smtpd -o smtpd_tls_wrappermode=yes -o smtpd_sasl_auth_enable=yes

Note: as it turns out, smtps was never actually a valid entry in
/etc/services (except briefly, for a few months in 1996... see
https://bugs.archlinux.org/task/20436). Since recent versions of
/etc/services are now "fixed", postfix will not be able to translate the
string "smtps" into port 465 any more. As a workaround, you can do this:

    465 inet n - n - - smtpd -o smtpd_tls_wrappermode=yes -o smtpd_sasl_auth_enable=yes

(You can also change /etc/services so that 465/tcp is smtps again, but
this will break mysteriously unless you also tell pacman not to ever
touch that file, which, if you ever migrate your server or help a friend
set up his, is something you're definitely going to forget you did...
and then it will break mysteriously again and you'll spend a few hours
Googling until you land here.)

-   /etc/pam.d/smtp

    auth required /usr/lib/security/pam_mysql.so user=postfix passwd=YOUR_NEW_PASSWD host=localhost db=postfix table=mailbox usercolumn=username passwdcolumn=password crypt=1
    account sufficient /usr/lib/security/pam_mysql.so user=postfix passwd=YOUR_NEW_PASSWD host=localhost db=postfix table=mailbox usercolumn=username passwdcolumn=password crypt=1

pam_mysql.so may also be located in /lib/security/ instead of
/usr/lib/security/. I find Arch64 uses /usr/lib/security/pam_mysql.so
and Arch32 uses /lib/security/pam_mysql.so.

-   /etc/conf.d/saslauthd

    SASLAUTHD_OPTS="-m /var/run/saslauthd -r -a pam"

-   /usr/lib/sasl2/smtpd.conf

    pwcheck_method: saslauthd
    mech_list: plain login
    saslauthd_path: /var/run/saslauthd/mux
    log_level: 7

Put into production!
--------------------

> Firing up services!

Run following command to start all services!

    for v in spamd mysqld httpd postfix dovecot;do /etc/rc.d/$v start ;done
    (saslauthd if you plan to use SMTP-AUTH)

If you plan to use Courier-IMAP, run following instead!

    for v in saslauthd spamd mysqld httpd postfix authdaemond courier-imap;do /etc/rc.d/$v start ;done
    (saslauthd if you plan to use SMTP-AUTH)

Go to following site to configure more stuff!

-   Postfix Admin

    http://YOUR_DOMAIN.TLD/postfixadmin/admin/
    (Default is USER: admin PASS: admin)

I would look into Apache's documentation on .htaccess/.htpasswd and
change out Postfix Admin's default admin page password.

> Verify working

-   Postfix

Let's test see if Postfix is up and accepting connections.

    [root@monkey1 /etc/rc.d]# telnet localhost 25
    Trying 127.0.0.1...
    Connected to localhost.
    Escape character is '^]'.
    220 mail.YOUR_DOMAIN.TLD ESMTP Postfix (Arch Linux)
    ehlo YOUR_DOMAIN.TLD
    250-mail.YOUR_DOMAIN.TLD
    250-PIPELINING
    250-SIZE 10240000
    250-VRFY
    250-ETRN
    250-ENHANCEDSTATUSCODES
    250-8BITMIME
    250 DSN
    mail from: root@localhost
    250 2.1.0 Ok
    rcpt to: test@YOUR_DOMAIN.TLD
    250 2.1.5 Ok
    data
    354 End data with <CR><LF>.<CR><LF>
    This is a test sending from root@localhost!
    .
    250 2.0.0 Ok: queued as 883E910C47B
    quit
    221 2.0.0 Bye
    Connection closed by foreign host.

^^^^^^^^^^

S-W-E-E-T! :)

-   Dovecot or Courier-IMAP

Fire up your favorite mail client, that supports IMAP-SSL, and connect
to your domain see if it works!

-   Spamassassin

If you see something similar in your e-mail headers, Spamassassin is
working!

    X-Spam-Checker-Version: SpamAssassin 3.2.3 (2007-08-08) on	YOUR_DOMAIN.TLD
    X-Spam-Status: No, score=-0.2 required=3.0 tests=ALL_TRUSTED,MISSING_SUBJECT	autolearn=no version=3.2.3

-   Postfix Admin

Play around see everything works like it should.

    http://YOUR_DOMAIN.TLD/postfixadmin/

-   SquirrelMail

    http://YOUR_DOMAIN.TLD/squirrelmail/

> Post-installation

If you firewalled your server, make sure the ports 25 80 443 993 (and
465 for SMTP-AUTH) are open!

Don't forget to add services to your /etc/rc.conf!

Any configuration files with YOUR_NEW_PASSWD in it you should chmod 640
it!

Notes
-----

Comments? Questions? Rants? Please let me know at terii [-AT-]
linuxmonkey [-DOT-] net.

You can also catch me on Freenode IRC under #archlinux; quad3d,
quad3datwork, limlappy, gangsterlicious, or portofu.

Thanks to slicehost.com for hosting my VPS! This guide is not possible
without my VPS. Find this guide useful? Thinking about having your own
VPS at slicehost.com? Ask me for my reference e-mail so I can get some
credit! :)

See also
--------

-   Simple Virtual User Mail System
-   Courier MTA
-   Postfix

Retrieved from
"https://wiki.archlinux.org/index.php?title=SOHO_Postfix&oldid=247297"

Category:

-   Mail Server
