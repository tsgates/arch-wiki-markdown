NBSMTP
======

Introduction
------------

From nbSMTP manpage: nbSMTP is a lightweight SMTP client. It simply
takes a message from STDIN and sends it to a relayhost. A relayhost is
meant to be a full SMTP server and it will really send the message.

Installation
------------

To install nbSMTP:

    pacman -S nbsmtp

Forward to a Gmail Mail Server
------------------------------

To configure nbSMTP, you will have to edit its configuration file
(~/.nbsmtprc) and enter your account settings:

    relayhost=smtp.gmail.com
    port=587
    use_starttls=True
    fromaddr=myusername@gmail.com
    auth_user=myusername@gmail.com
    auth_pass=myultrasecretpassword

Be careful with permissions on this file, it is recommendable to run
this:

    chmod 600 ~/.nbsmtprc

To test the configuration, create a file (testemail):

    To: myusername@gmail.com
    From: myusername@gmail.com
    Subject: nbsmtp test
    hello email world

and then run:

/usr/bin/nbsmtp < testemail

Enjoy

Retrieved from
"https://wiki.archlinux.org/index.php?title=NBSMTP&oldid=228397"

Categories:

-   Email Client
-   Mail Server

-   This page was last modified on 13 October 2012, at 10:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
