PostFix Howto With SASL
=======================

The postfix package in [extra] is compiled with sasl support:

    pacman -S postfix cyrus-sasl

An example line for the /etc/postfix/main.cf file to enable the SASL is
below.

    mydestination = $myhostname, localhost.$mydomain, $mydomain
    myorigin = $mydomain
    smtpd_sasl_auth_enable = yes
    smtpd_sasl_security_options = noanonymous
    smtpd_sasl_tls_security_options = $smtpd_sasl_security_options
    smtpd_tls_auth_only = no
    smtpd_sasl_local_domain = $mydomain
    smtpd_recipient_restrictions = permit_mynetworks,permit_sasl_authenticated,reject_unauth_destination,permit
    broken_sasl_auth_clients = yes
    relay_domains = *

You might want to change various options to suit your needs though.
Setup Postfix as you normally would and start it. If you want to start
it at boot time see Daemons#Starting_on_boot.

SASL can use different authentication methods. The default one is PAM
(as configured in /etc/conf.d/saslauthd), but to set it up properly you
have to create /usr/lib/sasl2/smtpd.conf:

    pwcheck_method: saslauthd
    saslauthd_path: /var/run/saslauthd/mux
    mech_list: plain login
    log_level: 7

To read about other authentication methods please refer to
http://www.postfix.org/SASL_README.html

To start all the daemons:

    systemctl start postfix
    systemctl start saslauthd

Hopefully you should be able to telnet to your Postfix server with :

telnet localhost 25

You should then type :

EHLO test.com

This is roughly what you should see :

    Trying 127.0.0.1...

    Connected to localhost.localdomain
    Escape character is '^]'

    220 justin ESMTP Postfix
    EHLO test.com
    250-justin
    250-PIPELINING
    250-SIZE 10240000
    250-VRFY
    250-ETRN
    250-AUTH PLAIN OTP DIGEST-MD5 CRAM-MD5
    250-AUTH=PLAIN OTP DIGEST-MD5 CRAM-MD5
    250 8BITMIME

Retrieved from
"https://wiki.archlinux.org/index.php?title=PostFix_Howto_With_SASL&oldid=242961"

Category:

-   Mail Server
