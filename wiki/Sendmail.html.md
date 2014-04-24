Sendmail
========

Sendmail is the classical SMTP server from the unix world. It was
originally coded long time ago, when the internet was a safer place, and
back then, security didn't matter as much as does today. Therefore it
used to have several security bugs and it got some bad reputation for
that. But those bugs are long fixed and a recent sendmail version is as
safe as any other SMTP server. However, if your top priority is
security, you should probably use netqmail.

The goal of this article is to setup Sendmail for local users accounts,
without using mysql or other database, and allowing also the creation of
mail-only accounts.

This article only explains the required steps configuring Sendmail;
after that, you probably want to add IMAP and POP3 access, so you could
follow the Dovecot article.

Contents
--------

-   1 Installation
-   2 DNS Records
-   3 Adding users
-   4 Configuration
    -   4.1 Create SSL certs
    -   4.2 sendmail.cf
    -   4.3 local-host-names
    -   4.4 access.db
    -   4.5 aliases.db
    -   4.6 virtusertable.db
    -   4.7 Start on boot
    -   4.8 SASL authentication
-   5 Tips and tricks
    -   5.1 Forward all the mail of one domain to certain user

Installation
------------

Install the package sendmail from the AUR, and the packages procmail and
m4 from the official repositories.

DNS Records
-----------

You should have a domain, and edit your MX records to point your server.
Remember some servers have problems with MX records pointing to CNAMEs,
so your MX should point to an A record instead.

Adding users
------------

-   By default, all the local users can have an email address like
    username@your-domain.com. But if you want to add mail-only accounts,
    that is, users who can get email, but can't have shell access or
    login on X, you can add them like this:

    useradd -m -s /sbin/nologin joenobody

-   Assign a password:

    passwd joenobody

Configuration
-------------

> Create SSL certs

-   Generate a key and sign it. Read OpenSSL for more information.

> sendmail.cf

-   Create the file /etc/mail/sendmail.mc.

You can read all the options for configuring sendmail on the file
/usr/share/sendmail-cf/README.

Warning:If you create your own sendmail.mc file, remember that plaintext
auth over non-TLS is very risky. Using the following example forces TLS
and is therefore more safe unless you know what are you doing

Here is an example using auth over TLS. The example has comments
explaing how it works. The comments start with dnl .

    /etc/mail/sendmail.mc

    include(`/usr/share/sendmail-cf/m4/cf.m4')
    define(`confDOMAIN_NAME', `your-domain.com')dnl
    FEATURE(use_cw_file)
    dnl  The following allows relaying if the user authenticates,
    dnl  and disallows plaintext authentication (PLAIN/LOGIN) on
    dnl  non-TLS links:
    define(`confAUTH_OPTIONS', `A p y')dnl
    dnl
    dnl  Accept PLAIN and LOGIN authentications:
    TRUST_AUTH_MECH(`LOGIN PLAIN')dnl
    define(`confAUTH_MECHANISMS', `LOGIN PLAIN')dnl
    dnl
    dnl Make sure this paths correctly point to your SSL cert files:
    define(`confCACERT_PATH',`/etc/ssl/certs')
    define(`confCACERT',`/etc/ssl/certs/ca.pem')
    define(`confSERVER_CERT',`/etc/ssl/certs/server.crt')
    define(`confSERVER_KEY',`/etc/ssl/private/server.key')
    dnl
    FEATURE(`virtusertable', `hash /etc/mail/virtusertable.db')dnl
    OSTYPE(linux)dnl
    MAILER(local)dnl
    MAILER(smtp)dnl

-   Then process it with

    # m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf

> local-host-names

-   Put your domains on the local-host-names file:

    /etc/mail/local-host-names

    localhost
    your-domain.com
    mail.your-domain.com
    localhost.localdomain

-   Make sure the domains are also resolved by your /etc/hosts file.

> access.db

-   Create the file /etc/mail/access and put there the base addresses
    where you want to be able to relay mail. Lets suppose you have a vpn
    on 10.5.0.0/24, and you want to relay mails from any ip in that
    range:

    /etc/mail/access

    10.5.0 RELAY
    127.0.0 RELAY

-   Then process it with

    # makemap hash /etc/mail/access.db < /etc/mail/access

> aliases.db

-   Edit the file /etc/mail/aliases and uncomment the line
    #root:         human being here and change it to be like this:

    root:         your-username

-   You can add aliases for your usernames there, like:

    coolguy:      your-username
    somedude:     your-username

-   Then process it with

    # newaliases

> virtusertable.db

-   Create your virtusertable file and put there aliases that includes
    domains (useful if your server is hosting several domains)

    /etc/mail/virtusertable

    your-username@your-domain.com         your-username
    joe@my-other.tk                       joenobody

-   Then process it with

    # makemap hash /etc/mail/virtusertable.db < /etc/mail/virtusertable

> Start on boot

Enable and start the following services. Read Daemons for more datails.

-   saslauthd.service
-   sendmail.service
-   sm-client.service

> SASL authentication

-   Add a user to the SASL database for SMTP authentication.

    # saslpasswd2 -c your-username

Tips and tricks
---------------

> Forward all the mail of one domain to certain user

To forward all mail addressed to any user in the my-other.tk domain to
your-username@your-domain.com, add to the /etc/mail/virtusertable file:

    @my-other.tk        your-username@your-domain.com

Do not forget to process it again with

    # makemap hash /etc/mail/virtusertable.db < /etc/mail/virtusertable

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sendmail&oldid=305782"

Category:

-   Mail Server

-   This page was last modified on 20 March 2014, at 02:17.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
