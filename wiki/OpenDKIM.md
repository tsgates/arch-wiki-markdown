OpenDKIM
========

DomainKeys Identified Mail is a digital email signing/verification
technology, which is already supported by some common mail providers.
(For example yahoo, google, etc).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 The idea                                                           |
| -   2 Installation                                                       |
| -   3 Basic configuration                                                |
| -   4 Postfix integration                                                |
| -   5 Notes                                                              |
+--------------------------------------------------------------------------+

The idea
--------

Basically DKIM means digitally signing all messages on the server to
verify the message actually was sent from the domain in question and is
not spam or pishing (and has not been modified).

-   The sender's mail server signs outgoing email with the private key.

-   When the message arrives, the receiver (or his server) requests the
    public key from the domain's DNS and verifies the signature.

This ensures the message was sent from a server who's private key
matches the domain's public key.

For more info see RFC 6376

Installation
------------

Install the package opendkim from the Official repositories.

You may add an user for opendkim or use existing one (for example:
postfix)

Basic configuration
-------------------

-   Generate key (server1 is the selector that is specified in the conf
    file below):

    opendkim-genkey -r -s server1 -d example.com

-   Create /etc/opendkim/opendkim.conf (see example in the same
    directory)

Minimal config:

    /etc/opendkim/opendkim.conf

    Domain                  example.com
    KeyFile                 /path/to/keys/server1.private
    Selector                server1
    Socket                  inet:8891@localhost
    UserID                  opendkim

-   Add a DNS TXT record with your selector and public key. The correct
    record is generated with the private key and can be found in
    server1.txt in the same location as the private key.

-   Enable and start the opendkim.service. Read Daemons for more
    information.

Postfix integration
-------------------

Just add

     non_smtpd_milters=inet:127.0.0.1:8891

and/or

     smtpd_milters=inet:127.0.0.1:8891

into main.cf or smtpd options in master.cf

master.cf example:

    smtp      inet  n       -       n       -       -       smtpd
      -o smtpd_client_connection_count_limit=10
      -o smtpd_milters=inet:127.0.0.1:8891

    submission inet n       -       n       -       -       smtpd
      -o smtpd_enforce_tls=no
      -o smtpd_sasl_auth_enable=yes
      -o smtpd_client_restrictions=permit_sasl_authenticated,reject
      -o smtpd_sasl_path=smtpd
      -o cyrus_sasl_config_path=/etc/sasl2
      -o smtpd_milters=inet:127.0.0.1:8891

Notes
-----

While you're about to fight spam and increase people's trust in your
server, you might want to take a look at Sender Policy Framework, which
basically means adding a DNS Record stating which servers are authorized
to send email for your domain.

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenDKIM&oldid=254737"

Category:

-   Mail Server
