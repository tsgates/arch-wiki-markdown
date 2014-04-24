Postfix
=======

Related articles

-   PostFix Howto With SASL
-   Simple Virtual User Mail System
-   Courier MTA
-   SOHO Postfix

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with SOHO        
                           Postfix.                 
                           Notes: both articles     
                           cover the exact same     
                           setup (Discuss)          
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Simple      
                           Virtual User Mail        
                           System.                  
                           Notes: both articles     
                           cover the exact same     
                           setup (Discuss)          
  ------------------------ ------------------------ ------------------------

From Postfix's site:

"Postfix attempts to be fast, easy to administer, and secure, while at
the same time being sendmail compatible enough to not upset existing
users. Thus, the outside has a sendmail-ish flavor, but the inside is
completely different."

The goal of this article is to setup Postfix for virtual mailbox
delivery only. There will be no delivery to user accounts on the system
(/etc/passwd). Further, access will only be available via a web mail
frontend (Squirrelmail), no direct POP3 or IMAP access will be granted.
It should be fairly easy to allow those additional features given the
information below, but it is not within the scope of this document.

Contents
--------

-   1 Required packages
-   2 Pre-installtion
    -   2.1 newuser
    -   2.2 setup MX record
-   3 Postfix configuration
    -   3.1 /etc/postfix/master.cf
    -   3.2 /etc/postfix/main.cf
        -   3.2.1 For virtual mail
            -   3.2.1.1 myhostname
            -   3.2.1.2 mydomain
            -   3.2.1.3 myorigin
            -   3.2.1.4 mydestination
            -   3.2.1.5 mynetworks and mynetwork_style
            -   3.2.1.6 relaydomains
            -   3.2.1.7 home_mailbox
            -   3.2.1.8 virtual_mail
            -   3.2.1.9 Default message and mailbox size limits
        -   3.2.2 Local mail
    -   3.3 /etc/postfix/aliases
    -   3.4 /etc/postfix/virtual_alias
    -   3.5 mysql_virtual_domains.cf
    -   3.6 mysql_virtual_mailboxes.cf
    -   3.7 mysql_virtual_forwards.cf
    -   3.8 Postfix check
    -   3.9 Start Postfix
-   4 MySQL configuration
    -   4.1 create a MySQL database
    -   4.2 setup table structure
    -   4.3 create a MySQL user
    -   4.4 add a domain
    -   4.5 add a user
-   5 Test Postfix
    -   5.1 Error response
    -   5.2 See that you have received a email
-   6 Configure Courier IMAP
    -   6.1 /etc/courier-imap/imapd
    -   6.2 /etc/authlib/authdaemonrc
    -   6.3 /etc/authlib/authmysqlrc
    -   6.4 Fam and rpcbind
    -   6.5 Start Courier
    -   6.6 Test
-   7 Configure Squirrelmail
    -   7.1 Create secure http site (https)
        -   7.1.1 Edit /etc/httpd/conf/extra/httpd-ssl.conf
        -   7.1.2 Include httpd-ssl.conf in httpd.conf
        -   7.1.3 Create the directory structure
        -   7.1.4 Generate a certificate
        -   7.1.5 restart Apache and test
    -   7.2 put Squirrelmail in the directory you created
    -   7.3 run Squirrelmail config utility
    -   7.4 test the Squirrelmail setup
    -   7.5 test Squirrelmail
        -   7.5.1 Troubleshooting
-   8 See also

Required packages
-----------------

-   apache
-   courier-imap from AUR (dovecot is an officially supported
    alternative, not yet included in this article)
-   mariadb
-   openssl
-   postfix
-   squirrelmail from AUR (roundcubemail is an officially supported
    alternative, not yet included in this article)

Pre-installtion
---------------

> newuser

We need to create the user for storing the virtual mail. Create a
vmailuser as follows:

    # groupadd -g 5003 vmail
    # useradd -g vmail -u 5003 -d /home/vmailer -s /bin/false vmailer
    # mkdir /home/vmailer
    # chown vmailer:vmail /home/vmailer
    # chmod -R 750 /home/vmailer
    # passwd vmailer

5003 UID/GID are the ones specified in the Postfix main.cf file.

> setup MX record

An MX record should point to the mail host. Usually this is done from
configuration interface of your domain provider.

A mail exchanger record (MX record) is a type of resource record in the
Domain Name System that specifies a mail server responsible for
accepting email messages on behalf of a recipient's domain.

When an e-mail message is sent through the Internet, the sending mail
transfer agent queries the Domain Name System for MX records of each
recipient's domain name. This query returns a list of host names of mail
exchange servers accepting incoming mail for that domain and their
preferences. The sending agent then attempts to establish an SMTP
connection to one of these servers, starting with the one with the
smallest preference number, delivering the message to the first server
with which a connection can be made.

Note:Some mail servers will not deliver mail to you if your MX record
points to a CNAME. For best results, always point an MX record to an A
record definition. For more information, see e.g. Wikipedia's List of
DNS Record Types.

Postfix configuration
---------------------

> /etc/postfix/master.cf

This is the Pipeline configuration file, in which you can put your new
pipes e.g. to check for Spam!

> /etc/postfix/main.cf

For virtual mail

myhostname

set myhostname if your mail server has multiple domains, and you do not
want the primary domain to be the mail host. The default is to use the
result of a gethostname() call if nothing is specified. For our purposes
we will just set it as follows:

    myhostname = mail.nospam.net

This is assuming that a DNS A record, and an MX record both point to
mail.nospam.net

mydomain

this is usually the value of myhostname, minus the first part. If your
domain is wonky, then just set it manually:

    mydomain = nospam.net

myorigin

this is where the email will be seen as being sent from. I usually set
this to the value of mydomain. For simple servers, this works fine. This
is for mail originating from a local account. Since we are not doing
local delivery (except sending), then this is not really as important as
it normally would be.

    myorigin = $mydomain

mydestination

This is the lookup for local users. Since we are not going to deliver
internet mail for any local users, set this to localhost only.

    mydestination = localhost

mynetworks and mynetwork_style

Both of these control relaying, and whom is allowed to. We do not want
any relaying. For our sakes, we will simply set mynetwork_style to host,
as we are trying to make a standalone postfix host, that people with use
webmail on. No relaying, no other MTA's. Just webmail.

    mynetworks_style = host

relaydomains

This controls the destinations that Postfix will relay TO. The default
value is $mydestination. This should be fine for now.

    relay_domains = $mydestination

home_mailbox

This setting controls how mail is stored for the users. Set this to
"Maildir/", as courier IMAP requires Maildir style mail storage. This is
a good thing. Maildir format mailboxes remove the possible race
conditions that can occur with old style mbox formats. No more need to
deal with file locking. The '/' at the end is REQUIRED.

    home_mailbox = Maildir/

virtual_mail

Virtual mail is mail that does not map to a user account (/etc/passwd).
This is where all the email for the system will be kept. We are not
doing local delivery, remember, so if you want a user that has the same
name as a local user, just make a virtual account with the same name.
First thing we need to do is add the following:

    virtual_mailbox_domains = virtualdomain.tld
    virtual_alias_maps = hash:/etc/postfix/virtual_alias, mysql:/etc/postfix/mysql_virtual_forwards.cf
    virtual_mailbox_domains = mysql:/etc/postfix/mysql_virtual_domains.cf
    virtual_mailbox_maps = mysql:/etc/postfix/mysql_virtual_mailboxes.cf
    virtual_mailbox_base = /home/vmailer
    virtual_uid_maps = static:5003
    virtual_gid_maps = static:5003
    virtual_minimum_uid = 5003
    virtual_mailbox_limit = 51200000

virtual_mailbox_domains is a list of the domains that you want to
receive mail for. This CANNOT be the same thing that is listed in
mydestination. That is why we left mydestination to be localhost only.
virtual_mailbox_maps will contain the info about the virtual users and
their mailbox locations. We are using a hash file to store the more
permanent maps, and these will override the forwards in the MySQL
database.

virtual_mailbox_base is the base dir where the virtual mailboxes will be
stored. The gid and uid maps are the real system user account that the
virtual mail will be owned by. This is for storage purposes. Since we
will be using a web interface, and do not want people accessing this by
any other means, we will be creating this account later with no login
access. Virtual_mailbox_limit controls the size of the mailbox. I do not
know how well this works yet. I have set the size above to about 50MB.

Default message and mailbox size limits

Postfix imposes both message and mailbox size limits by default. The
message_size_limit controls the maximum size in bytes of a message,
including envelope information. (default 10240000) The
mailbox_size_limit controls the maximum size of any local individual
mailbox or maildir file. This limits the size of any file that is
written to upon local delivery, including files written by external
commands (i.e. procmail) that are executed by the local delivery agent.
(default is 51200000, set to 0 for no limit) If bounced message
notifications are generated, check the size of the local mailbox under
/var/spool/mail and use postconf to check these size limits:

    supersff:~> postconf -d mailbox_size_limit
    mailbox_size_limit = 51200000
    supersff:~> postconf -d message_size_limit
    message_size_limit = 10240000

Local mail

The only things you need to change in /etc/postfix/main.cf are as
follows. Uncomment them and modify them to the specifics listed below.
Everything else can be left as installed.

    inet_interfaces = loopback-only
    mynetworks_style = host
    append_dot_mydomain = no
    default_transport = error: Local delivery only!

If you want to control where the mail gets delivered and which mailbox
format is to be used, you can do this by setting:

    home_mailbox = /some/path 

or:

    mail_spool_directory some/path

mail_spool_directory is an absolute path where all mail goes, while
home_mailbox specifies a mailbox relative to the user's home directory.
If the path ends with a slash ('/'), messages are stored in Maildir
format (directory tree, one message per file); if it doesn't, the mbox
format is used (all mail in one file).

Examples:

    mail_spool_directory = /var/mail  (1)
    home_mailbox = Maildir/           (2)

1) All mail will be stored in /var/mail, mbox format.

2) Mail will be saved in ~/Maildir, Maildir format.

> /etc/postfix/aliases

We need to map some aliases to real accounts. The default setup by arch
looks pretty good here.

Uncomment the following line, and change it to a real account. I put the
user account on the box that I use. Best not to just send mail to root,
because you do not want to be logging in as root or checking email as
root. Not good. Sudo is your friend, and so is forwarding root mail.
Since this is for local delivery only (syslogs and stuff), it is still
within the realm of mydestination.

    root: USER

Once you have finished editing /etc/postfix/aliases you must run the
postalias command:

    postalias /etc/postfix/aliases

> /etc/postfix/virtual_alias

Create /etc/postfix/virtual_alias with the following contents:

    MAILER-DAEMON:  postmaster
    postmaster:     root

    # General redirections for pseudo accounts
    bin:            root
    daemon:         root
    named:          root
    nobody:         root
    uucp:           root
    www:            root
    ftp-bugs:       root
    postfix:        root

    # Put your local aliases here.

    # Well-known aliases
    manager:        root
    dumper:         root
    operator:       root
    abuse:          postmaster

    # trap decode to catch security attacks
    decode:         root

    # Person who should get root's mail. Don't receive mail as root!
    root:           cactus@virtualdomain.tld

Then run the postalias command on it:

    postalias /etc/postfix/virtual_alias

Alternatively you can create the file .forward in /root. specify the
user to whom root mail should be forwarded, e.g. user@localhost.

    /root/.forward

    user@localhost

> mysql_virtual_domains.cf

Create the /etc/postfix/mysql_virtual_domains.cf file with the following
(or similar) contents:

    user = postfixuser
    password = XXXXXXXXXX
    hosts = localhost
    dbname = postfix
    table = domains
    select_field = 'virtual'
    where_field = domain

> mysql_virtual_mailboxes.cf

Create the /etc/postfix/mysql_virtual_mailboxes.cf file with the
following (or similar) contents:

    user = postfixuser
    password = XXXXXXXXXX
    hosts = localhost
    dbname = postfix
    table = users
    select_field = concat(domain,'/',email,'/')
    where_field = email

Instead of having a directory structure something like
/home/vmail/example.com/user@example.com you can have cleaner
subdirectories (without the additional domain name) by replacing
select_field and where_field with:

    query = SELECT CONCAT(SUBSTRING_INDEX(email,'@',-1),'/',SUBSTRING_INDEX(email,'@',1),'/') FROM users WHERE email='%s'

> mysql_virtual_forwards.cf

Create the /etc/postfix/mysql_virtual_forwards.cf file with the
following (or similar) contents:

    user = postfixuser
    password = XXXXXXXXXX
    hosts = localhost
    dbname = postfix
    table = forwardings
    select_field = destination
    where_field = source

> Postfix check

Run the postfix check command. It should output anything that you might
have done wrong in a config file.

To see all of your configs, type postconf. To see how you differ from
the defaults, try postconf -n.

> Start Postfix

Start/enable postfix.service using systemd.

MySQL configuration
-------------------

> create a MySQL database

Create MySQL database called 'postfix', or something similar.

    CREATE DATABASE postfix;
    USE postfix;

> setup table structure

Import the following table structure.

    CREATE TABLE `domains` (
      `domain` varchar(50) NOT NULL default "",
      PRIMARY KEY  (`domain`),
      UNIQUE KEY `domain` (`domain`)
    );


    CREATE TABLE `forwardings` (
      `source` varchar(80) NOT NULL default "",
      `destination` text NOT NULL,
      PRIMARY KEY  (`source`)
    );

    CREATE TABLE `users` (
      `email` varchar(80) NOT NULL default "",
      `password` varchar(20) NOT NULL default "",
      `quota` varchar(20) NOT NULL default '20971520',
      `domain` varchar(255) NOT NULL default "",
      UNIQUE KEY `email` (`email`)
    );

> create a MySQL user

Add a user for Postfix to use. Something like "postfixuser". Give
permissions for Postfix user to the table. This user should be listed in
the /etc/postfix/mysql_virtual_domains.cf file.

The official reference manual has a detailed guide on user management
and server administration in general.

The following is just an example for creation of 'postfixuser' with
password 'XXXXXXXXXX'. Note that the GRANT statements need to be
executed after creating the tables in the next step.

    CREATE USER 'postfixuser' IDENTIFIED BY 'XXXXXXXXXX';
    GRANT SELECT, INSERT, UPDATE, DELETE ON domains TO postfixuser;
    GRANT SELECT, INSERT, UPDATE, DELETE ON forwardings TO postfixuser;
    GRANT SELECT, INSERT, UPDATE, DELETE ON users TO postfixuser;

> add a domain

    INSERT INTO `domains` VALUES ('virtualdomain.tld');

> add a user

    INSERT INTO `users` VALUES ('cactus@virtualdomain.tld', 'secret', 
    '20971520', 'virtualdomain.tld');

The above creates the user and sets a password as secret.

This will allow you to use encrypted passwords

    INSERT INTO `users` VALUES ('cactus@virtualdomain.tld', ENCRYPT('secret'), 
    '20971520', 'virtualdomain.tld');

Test Postfix
------------

Start Postfix service. Now lets see if Postfix is going to deliver mail
for our test user.

    telnet servername 25
    ehlo testmail.org
    mail from:<test@testmail.org>
    rcpt to:<cactus@virtualdomain.tld>
    data
    This is a test email.

    .
    quit

> Error response

    451 4.3.0 <lisi@test.com>:Temporary lookup failure

Maybe you have entered the wrong user/password for MySQL or the MySQL
socket is not in the right place.

    550 5.1.1 <email@spam.me>: Recipient address rejected: User unknown in virtual mailbox table.

Double check content of mysql_virtual_mailboxes.cf and check the main.cf
for mydestination

> See that you have received a email

Now type $ find /home/vmailer.

You should see something like the following:

    /home/vmailer/virtualdomain.tld/cactus@virtualdomain.tld
    /home/vmailer/virtualdomain.tld/cactus@virtualdomain.tld/tmp
    /home/vmailer/virtualdomain.tld/cactus@virtualdomain.tld/cur
    /home/vmailer/virtualdomain.tld/cactus@virtualdomain.tld/new
    /home/vmailer/virtualdomain.tld/cactus@virtualdomain.tld/new/1102974226.2704_0.bonk.testmail.org

The key is the last entry. This is an actual email, if you see that, it
is working.

Configure Courier IMAP
----------------------

> /etc/courier-imap/imapd

    ADDRESS=127.0.0.1

We set the listen address to LOCAL ONLY. No outside connections.

> /etc/authlib/authdaemonrc

Remove all the modules from the authmodulelist line except for authmysql
like so:

    authmodulelist="authmysql"

> /etc/authlib/authmysqlrc

Replace the entire file with the following:

    MYSQL_SERVER            localhost
    MYSQL_USERNAME          postfixuser
    MYSQL_PASSWORD          secret
    MYSQL_SOCKET            /run/mysqld/mysqld.sock
    MYSQL_DATABASE          postfix
    # MYSQL_NAME_FIELD      name
    MYSQL_USER_TABLE        users
    MYSQL_CLEAR_PWFIELD     password
    MYSQL_UID_FIELD         '5003'
    ##note, this is the uid that we set in /etc/postfix/main.cf
    MYSQL_GID_FIELD         '5003'
    ##note, this is the gid that we set in /etc/postfix/main.cf
    MYSQL_LOGIN_FIELD       email
    MYSQL_HOME_FIELD        "/home/vmailer"
    MYSQL_MAILDIR_FIELD     concat(domain,'/',email,'/')
    MYSQL_QUOTA_FIELD       quota

Where secret is the MySQL password for the user postfixuser. If you are
using encrypted passwords by using MySQL's encrypt function. Use
"MYSQL_CRYPT_PWFIELD columnname" instead of "MYSQL_CLEAR_PWFIELD
columnname".

For an alternative directory structure, you could also use this setting
for MAILDIR_FIELD:

    MYSQL_MAILDIR_FIELD     CONCAT(SUBSTRING_INDEX(email,'@',-1),'/',SUBSTRING_INDEX(email,'@',1),'/')

In this case, courier will use a directory like
/home/vmail/exampledomain.com/exampleuser.

> Fam and rpcbind

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: FAM should not   
                           be required anymore.     
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Courier-imap for arch comes compiled with FAM. This means portmap is
also required. What used to be portmap is nowadays called rpcbind.

Install rpcbind and edit /etc/fam/fam.conf

    local_only = true
    idle_timeout = 0

Make sure the two above values are set. Then start and enable the daemon
rpcbind.

> Start Courier

Start/enable courier-imapd.service using systemd.

> Test

Lets see if courier is working:

    telnet localhost imap
    Trying 127.0.0.1...
    Connected to localhost.localdomain.
    Escape character is '^]'.
    * OK [[CAPABILITY IMAP4rev1 ... ]] Courier-IMAP ready.

    A LOGIN "cactus@virtualdomain.tld" "password"
    A OK LOGIN Ok.

    B SELECT "Inbox"
    * FLAGS (\Draft \Answered ... \Recent)
    * OK [[PERMANENTFLAGS (\Draft \Answered ... \Seen)]] Limited
    * 8 EXISTS
    * 5 RECENT
    * OK [[UIDVALIDITY 1026858715]] Ok
    B OK [[READ-WRITE]] Ok

    Z LOGOUT
    * BYE Courier-IMAP server shutting down
    Z OK LOGOUT completed
    Connection closed by foreign host.

Configure Squirrelmail
----------------------

> Create secure http site (https)

We are going to create a secure http site. This is so that people can
login with plain text passwords, and not have to worry about the
passwords getting sniffed (or worry less).

Edit /etc/httpd/conf/extra/httpd-ssl.conf

Add appropriate information. Here is an example section:

    <VirtualHost _default_:443>
    #  General setup for the virtual host
    DocumentRoot "/home/httpd/site.virtual/virtualdomain.tld/html"
    ServerName virtualdomain.tld:443
    ServerAdmin noemailonthisbox@localhost
    <Directory "/home/httpd/site.virtual/virtualdomain.tld/html">
        Options -Indexes +FollowSymLinks
        AllowOverride Options Indexes AuthConfig
        Order allow,deny
        Allow from all
    </Directory>

Include httpd-ssl.conf in httpd.conf

Simply uncomment this line in your httpd.conf:

    #Include conf/extra/httpd-ssl.conf

Create the directory structure

Now, create the directory you specified in the ssl.conf file.

    $ mkdir -p /home/httpd/site.virtual/virtualdomain.tld/html

Generate a certificate

Follow the instructions here: LAMP#SSL

restart Apache and test

Make sure that https is now working, and that you can get to the secure
site.

> put Squirrelmail in the directory you created

Either extract squirrelmail, or move it from where the arch package puts
it, into the directory you created for the secure http site.

> run Squirrelmail config utility

    cd squirrelmaildir/config
    perl conf.pl

Make sure you select 'D', then type in courier and hit enter. Make sure
your other options are correct as well. Note: If you use php with safe
mode on, make sure that the data dir is owned by the same owner as all
the files in the squirrelmail directory. With safe mode off, simply
follow the squirrelmail setup directions.

> test the Squirrelmail setup

Point your browser to squirrelmail/src/configtest.php. Should you get an
error on directory location, make sure php.ini has been set to allow
access to them (open_basedir directive).

> test Squirrelmail

Log in with the test account. You will need to login with the form of:
username: cactus@virtualdomain.tld password: secret

Try sending email to non-existent local accounts. You should get an
immediate bounce back. Try sending email to external good email
accounts, as well as non-existent ones. Just general testing stuff. If
everything works fine, then you can add other accounts to the MySQL
database, and away you go!

Troubleshooting

If you received an error similar to:

    Warning: file_exists() [function.file-exists]: open_basedir restriction in effect. File(/var/lib/squirrelmail/data) is not within the allowed path(s): \
    (/srv/http/:/home/:/tmp/:/usr/share/pear/) in /home/httpd/site.virtual/virtualdomain.tld/html/squirrelmail/src/configtest.php on line 303

Then edit /etc/httpd/httpd.conf, and in the section:

    <Directory "/home/httpd/site.virtual/virtualdomain.tld/html">

add:

    php_admin_value open_basedir /home/httpd/site.virtual/virtualdomain.tld/html:/var/lib/squirrelmail/

If you get an error similar to:

    Unknown user or password incorrect.

You may have to create your user directories within vmailer like so:

    $ mkdir -p /home/vmailer/mydomain.com/username
    $ mkdir /home/vmailer/mydomain.com/username/cur
    $ mkdir /home/vmailer/mydomain.com/username/new
    $ mkdir /home/vmailer/mydomain.com/username/tmp
    $ chmod -R 750 /home/vmailer
    $ chown -R vmailer.vmail /home/vmailer

where mydomain.com/username is the domain/username given within MySQL.

See also
--------

-   Out of Office for Squirrelmail
-   Postfix Ubuntu documentation
-   A simple mailserver on Arch Linux
-   Use Gmail as an SMTP relay

Retrieved from
"https://wiki.archlinux.org/index.php?title=Postfix&oldid=292835"

Category:

-   Mail Server

-   This page was last modified on 14 January 2014, at 11:46.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
