PostFix Howto With SASL
=======================

  
 The postfix package in [extra] is compiled with SASL support:

    pacman -S postfix cyrus-sasl

To enable SASL for accepting mail from other users, open the "Message
submission" port (TCP 587) in /etc/postfix/master.cf, by uncommenting
these lines (which are there by default, just commented):

    submission inet n       -       n       -       -       smtpd
      -o syslog_name=postfix/submission
      -o smtpd_tls_security_level=encrypt
      -o smtpd_sasl_auth_enable=yes
      -o smtpd_reject_unlisted_recipient=no
    #  -o smtpd_client_restrictions=$mua_client_restrictions
    #  -o smtpd_helo_restrictions=$mua_helo_restrictions
    #  -o smtpd_sender_restrictions=$mua_sender_restrictions
      -o smtpd_recipient_restrictions=permit_sasl_authenticated,reject
      -o milter_macro_daemon_name=ORIGINATING

Note that this also enables SSL, so if you do not have a SSL
certificate, keep the "smtpd_tls_security_level" option commented out.

The three restriction options (client, helo, sender) can also be left
commented out, since smtpd_recipient_restrictions already handles SASL
users.

Setup Postfix as you normally would and start it. If you want to start
it at boot time see Daemons#Starting_on_boot.

SASL can use different authentication methods. The default one is PAM
(as configured in /etc/conf.d/saslauthd), but to set it up properly you
have to create /usr/lib/sasl2/smtpd.conf:

    pwcheck_method: saslauthd
    mech_list: plain
    log_level: 7

To read about other authentication methods please refer to
http://www.postfix.org/SASL_README.html

To start all the daemons:

    systemctl start postfix saslauthd

Hopefully you should be able to telnet to your Postfix server with:

telnet localhost 587

You should then type:

EHLO test.com

This is roughly what you should see:

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
    250 8BITMIME

Retrieved from
"https://wiki.archlinux.org/index.php?title=PostFix_Howto_With_SASL&oldid=259290"

Category:

-   Mail Server

-   This page was last modified on 28 May 2013, at 12:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
