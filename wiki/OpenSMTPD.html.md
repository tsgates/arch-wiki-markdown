OpenSMTPD
=========

Summary help replacing me

This article explains how to install and configure a simple OpenSMTPD
server.

> Related

Dovecot

Contents
--------

-   1 Required packages
-   2 Installation
-   3 Simple OpenSMTPD/mbox configuration
    -   3.1 Create user accounts
    -   3.2 Craft a simple smtpd.conf setup
    -   3.3 Create virtual domain and user tables
-   4 Starting the server
-   5 Watch the spice flow!
-   6 See also

Required packages
-----------------

-   opensmtpd

Installation
------------

    # pacman -S opensmptd

Simple OpenSMTPD/mbox configuration
-----------------------------------

> Create user accounts

-   Create a user account on the mail server for each desired mailbox.

    # useradd -m -s /bin/bash roger
    # useradd -m -s /bin/bash shirley

-   OpenSMTPD will deliver messages to the user account's mbox file at
    /var/spool/mail/<username>
-   Multiple SMTP email addresses can be delivered into one mailbox if
    desired.

> Craft a simple smtpd.conf setup

-   A working configuration can be had in as little as five lines! In
    this example 10.1.1.0/24 is the LAN IP subnet.

    /etc/smtpd/smtpd.conf

    listen on eth0 hostname myemaildomain.com
    table vdoms             "/etc/smtpd/vdoms"
    table vusers            "/etc/smtpd/vusers"
    accept from any for domain <vdoms> virtual <vusers> deliver to mbox
    accept from source { localhost 10.1.1.0/24 } for any relay

> Create virtual domain and user tables

-   For the domain table file; simply put one domain per line

    /etc/smtpd/vdoms

    personaldomain.org
    businessname.com

-   For the user table file; list one inbound SMTP email addresses per
    line and then map it to an mbox user account name, SMTP email
    address, or any combination of the two on the right, separated by
    commas.

    /etc/smtpd/vusers

    roger@personaldomain.org          roger
    newsletters@personaldomain.org    roger,roger.rulz@gmail.com

    roger@businessname.com            roger
    shirley@businessname.com          shirley
    info@businessname.com             roger,shirley
    contact@businessname.com          info@businessname.com

Starting the server
-------------------

Use the standard systemd syntax to control the smtpd.service daemon.

    # systemctl start smtpd.service

To have it start on boot

    # systemctl enable smtpd.service

Watch the spice flow!
---------------------

    # journalctl -f _SYSTEMD_UNIT=smtpd.service

See also
--------

-   OpenSMTPD pairs well with Dovecot. Combine the two for a nice
    minimalist mailserver
-   OpenSMTPD project page
-   Simple SMTP server with OpenSMTPD

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenSMTPD&oldid=305267"

Category:

-   Mail Server

-   This page was last modified on 17 March 2014, at 02:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
