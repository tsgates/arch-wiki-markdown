Simple Virtual User Mail System
===============================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Postfix.    
                           Notes: both articles     
                           cover the exact same     
                           setup (Discuss)          
  ------------------------ ------------------------ ------------------------

This article describes how to set up a complete virtual user mail system
on an Arch Linux system in the simplest manner possible. However, since
a mail system consists of many complex components, quite a bit of
configuration will still be necessary. Roughly, the components used in
this article are Postfix, Dovecot, PostfixAdmin and Roundcube.

In the end, the provided solution will allow you to use the best
currently available security mechanisms, you will be able to send mails
using SMTP and SMTPS and receive mails using POP3, POP3S, IMAP and
IMAPS. Additionally, configuration will be easy thanks to PostfixAdmin
and users will be able to login using Roundcube. What a deal!

This article assumes that you have a working LAMP setup as we will need
a working Apache2 as well as MYSQL database. Of course, with a few
changes to these instructions you could easily use another httpd and
database. For the purposes of this tutorial, however, the choice made
above will be used. Additionally, the article assumes all-default
settings for every package installed below. No changes except for those
mentioned will be required.

Should any unforeseen problems occur, feel free to use the discussion
page to voice your problems and I will try to answer.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 User
    -   2.2 Database
    -   2.3 Postfix
    -   2.4 Dovecot
    -   2.5 PostfixAdmin
    -   2.6 Roundcube
    -   2.7 systemd
-   3 Fire it up
-   4 Optional Items
    -   4.1 SpamAssassin
        -   4.1.1 SpamAssassin combined with Dovecot LDA / Sieve
            (Mailfiltering)
-   5 Troubleshooting
-   6 Tips and Tricks
    -   6.1 When sending email with Postfix, how can I hide the sender’s
        IP and username in the Received header
-   7 See also

Installation
------------

    # pacman -S dovecot postfix

Configuration
-------------

> User

For security reasons, a new user should be created to store the mails:

    groupadd -g 5000 vmail
    useradd -u 5000 -g vmail -s /sbin/nologin -d /home/vmail -m vmail

A gid and uid of 5000 is used in both cases so that we do not run into
conflicts with regular users. All your mail will then be stored in
/home/vmail. You could change the home dir to something like
/var/mail/vmail but careful to change this in any configuration below as
well.

> Database

You will need to create an empty database and corresponding user. We
will be using PostfixAdmin's tables to fill the database later on. In
this article, postfix_user will have read/write access to postfix_db
using hunter2 for a password. You are expected to create your database
and user yourself as shown in the following code. Make sure to assign
proper permissions.

    $> mysql -u root -p

    password:

    CREATE SCHEMA `postfix_db` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
    CREATE USER 'postfix_user'@'localhost' IDENTIFIED BY 'hunter2';
    GRANT ALL ON `postfix_db`.* TO `postfix_user`@`localhost`;

> Postfix

There are basically 2 ways of doing SMTPS.

One is using the wrapper mode which enables even old/odd clients like
Outlook to use TLS. The wrapper mode uses the system service "smtps"
which is a non-standard service and runs on port 465.

The other, more proper method is to use a port that simply enforces TLS
without any wrapping. The system service for this is "submission" which
is standard and uses port 587.

For the improper variant uncomment this in /etc/postfix/master.cf:

    smtps     inet  n       -       n       -       -       smtpd
      -o smtpd_tls_wrappermode=yes
      -o smtpd_sasl_auth_enable=yes

And verify that these lines are in /etc/services:

    smtps 465/tcp # Secure SMTP
    smtps 465/udp # Secure SMTP

otherwise posfix won't start :

postfix/master[5309]: fatal: 0.0.0.0:smtps: Servname not supported for
ai_socktype

For the proper variant uncomment this in /etc/postfix/master.cf:

    smtp     inet  n       -       n       -       -       smtpd
    submission     inet  n       -       n       -       -       smtpd
      -o smtpd_tls_security_level=encrypt
      -o smtpd_sasl_auth_enable=yes

To /etc/postfix/main.cf append:

    relay_domains = *
    virtual_alias_maps = proxy:mysql:/etc/postfix/virtual_alias_maps.cf
    virtual_mailbox_domains = proxy:mysql:/etc/postfix/virtual_domains_maps.cf
    virtual_mailbox_maps = proxy:mysql:/etc/postfix/virtual_mailbox_maps.cf
    virtual_mailbox_base = /home/vmail
    virtual_mailbox_limit = 512000000
    virtual_minimum_uid = 5000
    virtual_transport = virtual
    virtual_uid_maps = static:5000
    virtual_gid_maps = static:5000
    local_transport = virtual
    local_recipient_maps = $virtual_mailbox_maps
    transport_maps = hash:/etc/postfix/transport

    smtpd_sasl_auth_enable = yes
    smtpd_sasl_type = dovecot
    smtpd_sasl_path = /var/run/dovecot/auth-client
    smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination
    smtpd_relay_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination
    smtpd_sasl_security_options = noanonymous
    smtpd_sasl_tls_security_options = $smtpd_sasl_security_options
    smtpd_tls_auth_only = yes
    smtpd_tls_cert_file = /etc/ssl/private/server.crt
    smtpd_tls_key_file = /etc/ssl/private/server.key
    smtpd_sasl_local_domain = $mydomain
    broken_sasl_auth_clients = yes
    smtpd_tls_loglevel = 1

Warning:relay_domains = * might be a bad idea (see
http://www.postfix.org/BASIC_CONFIGURATION_README.html#relay_to). You
usually do not want postfix to forward mail from strangers.

This references a lot of files that do not even exist yet. Let's create
them.

Edit /etc/postfix/virtual_alias_maps.cf as new and add:

    user = postfix_user
    password = hunter2
    hosts = localhost
    dbname = postfix_db
    query = SELECT goto FROM alias WHERE address='%s' AND active = true

Edit /etc/postfix/virtual_domains_maps.cf as new and add:

    user = postfix_user
    password = hunter2
    hosts = localhost
    dbname = postfix_db
    query = SELECT domain FROM domain WHERE domain='%s' AND backupmx = false AND active = true

Edit /etc/postfix/virtual_mailbox_limits.cf as new and add:

    user = postfix_user
    password = hunter2
    hosts = localhost
    dbname = postfix_db
    query = SELECT quota FROM mailbox WHERE username='%s'

Edit /etc/postfix/virtual_mailbox_maps.cf as new and add:

    user = postfix_user
    password = hunter2
    hosts = localhost
    dbname = postfix_db
    query = SELECT maildir FROM mailbox WHERE username='%s' AND active = true

Run postmap on transport to generate its db:

    postmap /etc/postfix/transport

We still need the SSL cert and private key:

    cd /etc/ssl/certs
    openssl req -new -x509 -newkey rsa:1024 -days 365 -keyout server.key -out server.crt
    openssl rsa -in server.key -out server.key
    chown nobody:nobody server.key server.crt
    chmod 400 server.key
    chmod 444 server.crt
    mv server.key /etc/ssl/private/
    mv server.crt /etc/ssl/private/

> Dovecot

Start by getting a fresh config file from the pre-existing sample
config:

    cp /etc/dovecot/dovecot.conf.sample /etc/dovecot/dovecot.conf

In /etc/dovecot/dovecot.conf we'll need to do quite some configuration:

    protocols = imap pop3
    auth_mechanisms = plain
    passdb {
        driver = sql
        args = /etc/dovecot/dovecot-sql.conf
    }
    userdb {
        driver = sql
        args = /etc/dovecot/dovecot-sql.conf
    }

    service auth {
        unix_listener auth-client {
            group = postfix
            mode = 0660
            user = postfix
        }
        user = root
    }

    mail_home = /home/vmail/%d/%u
    mail_location = maildir:~

    ssl_cert = </etc/ssl/private/server.crt
    ssl_key = </etc/ssl/private/server.key

Note: you may want to replace the whole content of the file with this
one since the default configuration file imports the content of
conf.d/*.conf. Those files call other files that aren't present in our
configuration. You can alternatively remove conf.d/.

See http://wiki2.dovecot.org/Variables for the docevot variables %d
and %u.

Now obviously we also need the /etc/dovecot/dovecot-sql.conf we just
referenced in the config above. Go ahead and create a
/etc/dovecot/dovecot-sql.conf with these contents:

    driver = mysql
    connect = host=localhost dbname=postfix_db user=postfix_user password=hunter2
    # The new name for MD5 is MD5-CRYPT so you might need to change this depending on version
    default_pass_scheme = MD5-CRYPT
    # Get the mailbox
    user_query = SELECT '/home/vmail/%d/%u' as home, 'maildir:/home/vmail/%d/%u' as mail, 5000 AS uid, 5000 AS gid, concat('dirsize:storage=',  quota) AS quota FROM mailbox WHERE username = '%u' AND active = '1'
    # Get the password
    password_query = SELECT username as user, password, '/home/vmail/%d/%u' as userdb_home, 'maildir:/home/vmail/%d/%u' as userdb_mail, 5000 as  userdb_uid, 5000 as userdb_gid FROM mailbox WHERE username = '%u' AND active = '1'
    # If using client certificates for authentication, comment the above and uncomment the following
    #password_query = SELECT null AS password, ‘%u’ AS user

> PostfixAdmin

To install PostfixAdmin, we can use the postfixadmin package from the
official repositories.

Next, PostfixAdmin needs to be configured. First edit the
/etc/webapps/postfixadmin/config.inc.php file:

    $CONF['configured'] = true;
    // correspond to dovecot maildir path /home/vmail/%d/%u 
    $CONF['domain_path'] = 'YES';
    $CONF['domain_in_mailbox'] = 'YES';
    $CONF['database_type'] = 'mysql';
    $CONF['database_host'] = 'localhost';
    $CONF['database_user'] = 'postfix_user';
    $CONF['database_password'] = 'hunter2';
    $CONF['database_name'] = 'postfix_db';

Then assuming localhost is the hostname of the machine you are
installing this on, navigate to http://localhost/postfixAdmin/setup.php.
The setup will guide you through the remaining steps to set up
PostfixAdmin.

Note:For a detailed section on setting up domains and mailboxes in
PostfixAdmin see the related [Gentoo wiki article]

> Roundcube

Roundcube is available in the community repo.

    pacman -S roundcubemail

The post install process is similar to any other webapps like PhpMyAdmin
or PostFixAdmin. Copy the example configuration file to your webserver
configuration directory. If you are using Apache do:

    cp /etc/webapps/roundcubemail/apache.conf /etc/httpd/conf/extra/httpd-roundcubemail.conf

Add the include line in /etc/httpd/conf/httpd.conf

    Include conf/extra/httpd-roundcubemail.conf

Make some directories writable by the webserver in
/usr/share/webapps/roundcubemail/:

    chown -R http:http temp logs

Roundcube now requires the pdo_mysql.so extension, make sure this
extension is un-commented in your php.ini file. Also check .htaccess for
access restrictions. Assuming that localhost is your current host,
navigate a browser to http://localhost/roundcubemail/installer/ and
follow the instructions. You could use the same database for Roundcube
that you already used for PostfixAdmin though you shouldn't. For a
proper setup, create a second database "roundcube_db" and a
"roundcube_user" for use with Roundcube. Update this info in db.inc.php.

While running the installer, make sure to address the IMAP host with
ssl://localhost/ or tls://localhost/ instead of just localhost. Use port
993. Likewise with SMTP, make sure to provide ssl://localhost/ on port
465 if you used the wrapper mode and tls://localhost/ on port 587 if you
used the proper TLS mode. See here for an explanation on that.

> systemd

Make sure your daemons start on boot:

    systemctl enable dovecot postfix

Fire it up
----------

Since now hopefully everything is set up correctly, all necessary
daemons should be started for a test run:

    systemctl start postfix dovecot

Now for testing purposes, create a domain and mail account in
PostfixAdmin. Try to login to this account using Roundcube. Now send
yourself a mail.

Optional Items
--------------

Although these items are not required, they definitely add more
completeness to your setup

> SpamAssassin

Is available in the extra repo. Following steps borrowed from
SOHO_Postfix#Spamassassin

    pacman -S spamassassin

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

Note: If you want to combine Spamassassin and Dovecot Mail Filtering you
have to ignore the next two lines and continue further down instead.

Edit /etc/postfix/master.cf and add the content filter under smtp.

    smtp       inet  n       -       n       -       -       smtpd
           -o content_filter=spamassassin

Also add the following service entry for spamassassin

    spamassassin   unix   -     n       n      -       -       pipe
           user=spamd argv=/usr/bin/vendor_perl/spamc -f -e /usr/sbin/sendmail -oi -f ${sender} ${recipient}

SpamAssassin combined with Dovecot LDA / Sieve (Mailfiltering)

-   Set up LDA and the Sieve-Plugin which is descriped in Dovecot#Sieve.
    But ignore the last line mailbox_command... 
-   Instead add a pipe in /etc/postfix/master.cf

     dovecot   unix  -       n       n       -       -       pipe
           flags=DRhu user=vmail:vmail argv=/usr/bin/vendor_perl/spamc -f -u spamd -e /usr/lib/dovecot/dovecot-lda -f ${sender} -d ${recipient}

-   And activate it in Postfix main.cf

     virtual_transport = dovecot

Enable and start the service with systemctl

    systemctl enable spamassassin
    systemctl start spamassassin

Troubleshooting
---------------

If you get errors like your imap/pop3 client failing to receive mails,
take a look into your /var/log/mail.log file. It turned out that the
maildir /home/vmail/mail@domain.tld is just being created if there is at
least one email waiting. Otherwise there wouldn't be any need for the
directory.

Tips and Tricks
---------------

> When sending email with Postfix, how can I hide the sender’s IP and username in the Received header

This is a privacy concern mostly, if you use Thunderbird and send an
email. The received header will contain your LAN and WAN IP and info
about the email client you used. (Original source: AskUbuntu) What we
want to do is remove the Received header from outgoing emails. This can
be done by applying header_checks exclusively to the submission port.
What we need to do is pass the cleanup_service_name option to the
submission service so that we can set up a new cleanup service,
“subcleanup.” The relevant section of /etc/postfix/master.cf might look
like this:

    submission inet n       -       -       -       -       smtpd
     -o smtpd_tls_security_level=encrypt
     -o smtpd_sasl_auth_enable=yes
     -o smtpd_client_restrictions=permit_sasl_authenticated,reject
     -o milter_macro_daemon_name=ORIGINATING
     -o cleanup_service_name=subcleanup

Now we can pass the header_checks option to the new cleanup service.
That part of /etc/postfix/master.cf might look like this:

    cleanup   unix  n       -       -       -       0       cleanup
    subcleanup unix n       -       -       -       0       cleanup
     -o header_checks=regexp:/etc/postfix/submission_header_checks

Finally, we need to create the file
/etc/postfix/submission_header_checks, which will contain the regex that
filters offending Received header lines:

    /^Received:/ IGNORE
    /^User-Agent:/ IGNORE

See also
--------

-   Courier MTA
-   Postfix
-   SOHO Postfix
-   OpenDKIM

Retrieved from
"https://wiki.archlinux.org/index.php?title=Simple_Virtual_User_Mail_System&oldid=304155"

Category:

-   Mail Server

-   This page was last modified on 12 March 2014, at 13:54.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
