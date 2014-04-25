Dovecot
=======

Summary help replacing me

This article explains how to install and configure Dovecot.

> Related

Postfix

Courier MTA

OpenSMTPD

Fail2ban

This article describes how to set up a mail server suitable for personal
or small office use.

Dovecot is an open source IMAP and POP3 server for Linux/UNIX-like
systems, written primarily with security in mind. Developed by Timo
Sirainen, Dovecot was first released in July 2002. Dovecot primarily
aims to be a lightweight, fast and easy to set up open source
mailserver. For more detailed information, please see the official
Dovecot Wiki.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Assumptions
    -   2.2 Create the SSL certificate
    -   2.3 PAM Authentication
    -   2.4 Dovecot configuration
    -   2.5 Sieve
-   3 Starting the server
-   4 Tricks

Installation
------------

Install the packages dovecot and pam from the official repositories.

Configuration
-------------

> Assumptions

-   Each mail account served by Dovecot, has a local user account
    defined on the server.
-   The server uses PAM to authenticate the user against the local user
    database (/etc/passwd).
-   SSL is used to encrypt the authentication password.
-   The common Maildir format is used to store the mail in the user's
    home directory.
-   A MDA has already been set up to deliver mail to the local users.

> Create the SSL certificate

The dovecot package contains a script to generate the server SSL
certificate.

-   Copy the configuration file from the sample file:
    # cp /etc/ssl/dovecot-openssl.cnf{.sample,} .
-   Edit /etc/ssl/dovecot-openssl.cnf to configure the certificate.

-   Execute # /usr/lib/dovecot/mkcert.sh to generate the certificate.

The certificate/key pair is created as /etc/ssl/certs/dovecot.pem and
/etc/ssl/private/dovecot.pem.

> PAM Authentication

-   To configure PAM for dovecot, create /etc/pam.d/dovecot with the
    following content:

    /etc/pam.d/dovecot

    auth    required        pam_unix.so nullok
    account required        pam_unix.so 

> Dovecot configuration

-   Copy the dovecot.conf and conf.d/* configuration files from
    /usr/share/doc/dovecot/example-config to /etc/dovecot:

    # cp /usr/share/doc/dovecot/example-config/dovecot.conf /etc/dovecot
    # cp -r /usr/share/doc/dovecot/example-config/conf.d /etc/dovecot

The default configuration is ok for most systems, but make sure to read
through the configuration files to see what options are available. See
the quick configuration guide and dovecot configuration for more
instructions.

By default dovecot will try to detect what mail storage system is in use
on the system. To use the Maildir format edit
/etc/dovecot/conf.d/10-mail.conf to set
mail_location = maildir:~/Maildir.

> Sieve

Sieve is a programming language that can be used to create filters for
email on mail server.

-   Install pigeonhole
-   Add "sieve" to "protocols" in dovecot.conf (and the lines from the
    next points)

    protocols = imap pop3 sieve

-   Add minimal 80-sieve.conf

    service managesieve-login {
      inet_listener sieve {
        port = 4190
      }
    }

    service managesieve {
    }

    protocol sieve {
    }

-   Add "sieve" to "mail_plugins" in "protocol lda" section

    protocol lda {
      mail_plugins = sieve
    }

-   Specify sieve storage location in "plugin" section:

    plugin {
      sieve=/var/mail/%u/dovecot.sieve
      sieve_dir=/var/mail/%u/sieve
    }

Note: Nowadays it is recommended to use LMTP instead of LDA.
Nevertheless can the Dovecot LDA still be used for small mailservers.
More information can be found in the Dovecot Wiki

-   Ensure that your MTA uses dovecot for delivery. For example:
    postfix's main.cf and dovecot-lda:

     mailbox_command = /usr/lib/dovecot/dovecot-lda -f "$SENDER" -a "$RECIPIENT"

Starting the server
-------------------

Use the standard systemd syntax to control the dovecot.service daemon.

    # systemctl start dovecot.service

To have it start on boot

    # systemctl enable dovecot.service

Tricks
------

Generate hashes with non-default hash functions.

    doveadm pw -s SHA512-CRYPT -p "superpassword"

Remember to make sure that the column in the database is large
enough(you might not get a warning..)

Remember to set the password scheme in your dovecot-sql.conf file

    default_pass_scheme = SHA512-CRYPT

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dovecot&oldid=305746"

Category:

-   Mail Server

-   This page was last modified on 20 March 2014, at 01:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
