DomainKeys
==========

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Note:This is obsoleted by OpenDKIM.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 What is it?                                                        |
|     -   1.1 How it works?                                                |
|                                                                          |
| -   2 Installation                                                       |
| -   3 Generic configuration                                              |
| -   4 Postfix integration                                                |
|     -   4.1 Inbound filter                                               |
|     -   4.2 Outbound filter                                              |
+--------------------------------------------------------------------------+

What is it?
===========

It is digital email signing/verification technology, which included into
RFCs and already supported by many mail servers. (For example yahoo,
google, etc).

How it works?
-------------

Sender signs email with private key.

Receiver gets signed email, request public key from DNS and verify it.

So you can check who actualy sent this email.

For more info see RFC 4870

Installation
============

Install dkfilter: pacman -S dkfilter

By default, you should add dkfilter user and group. If you do not want
to do this, edit /etc/conf.d/dkfilter and change DKFILTER_USER and
DKFILTER_GROUP.

Generic configuration
=====================

-   Generate key:

    openssl genrsa -out private.key 1024
    openssl rsa -in private.key -pubout -out public.key

-   Adjust /etc/conf.d/dkfilter
-   Add DNS record with your selector (see DKFILTER_SELECTOR in
    /etc/conf.d/dkfilter, you may choose random name) and key:

    server1._domainkey IN TXT "k=rsa; p=MHwwDQYJK ... OprwIDAQAB; t=y"

-   Run it with /etc/rc.d/dkfilter start or add it to DAEMONS in
    /etc/rc.conf

Postfix integration
===================

Inbound filter
--------------

Inbound filter gets connection from port 10025 and output filtered data
to port 10026. (Inbound filter does not remove any data, it just adds
verification result into mail)

Add following into /etc/postfix/master.cf:

    #
    # Before-filter SMTP server. Receive mail from the network and
    # pass it to the content filter on localhost port 10025.
    #
    smtp      inet  n       -       n       -       -       smtpd
        -o smtpd_proxy_filter=127.0.0.1:10025
        -o smtpd_client_connection_count_limit=10
    #
    # After-filter SMTP server. Receive mail from the content filter on
    # localhost port 10026.
    #
    127.0.0.1:10026 inet n  -       n       -        -      smtpd
        -o smtpd_authorized_xforward_hosts=127.0.0.0/8
        -o smtpd_client_restrictions=
        -o smtpd_helo_restrictions=
        -o smtpd_sender_restrictions=
        -o smtpd_recipient_restrictions=permit_mynetworks,reject
        -o smtpd_data_restrictions=
        -o mynetworks=127.0.0.0/8
        -o receive_override_options=no_unknown_recipient_checks

Outbound filter
---------------

Outbound filter gets connection from port 10027 and output signed data
to port 10028.

Add following into /etc/postfix/master.cf:

    #
    # modify the default submission service to specify a content filter
    # and restrict it to local clients and SASL authenticated clients only
    #
    submission  inet  n     -       n       -       -       smtpd
        -o smtpd_etrn_restrictions=reject
        -o smtpd_sasl_auth_enable=yes
        -o content_filter=dksign:[127.0.0.1]:10027
        -o receive_override_options=no_address_mappings
        -o smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject

    #
    # specify the location of the DomainKeys signing filter
    #
    dksign    unix  -       -       n       -       10      smtp
        -o smtp_send_xforward_command=yes
        -o smtp_discard_ehlo_keywords=8bitmime

    #
    # service for accepting messages FROM the DomainKeys signing filter
    #
    127.0.0.1:10028 inet  n  -      n       -       10      smtpd
        -o content_filter=
        -o receive_override_options=no_unknown_recipient_checks,no_header_body_checks
        -o smtpd_helo_restrictions=
        -o smtpd_client_restrictions=
        -o smtpd_sender_restrictions=
        -o smtpd_recipient_restrictions=permit_mynetworks,reject
        -o mynetworks=127.0.0.0/8
        -o smtpd_authorized_xforward_hosts=127.0.0.0/8

Retrieved from
"https://wiki.archlinux.org/index.php?title=DomainKeys&oldid=197422"

Category:

-   Internet Applications
