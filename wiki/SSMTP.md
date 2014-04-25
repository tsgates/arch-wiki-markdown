SSMTP
=====

SSMTP is a program to deliver an email from a local computer to a
configured mailhost (mailhub). It is not a mail server (like
feature-rich mail server sendmail) and does not receive mail, expand
aliases or manage a queue. One of its primary uses is for forwarding
automated email (like system alerts) off your machine and to an external
email address.

Contents
--------

-   1 Installation
-   2 Forward to a Gmail Mail Server
    -   2.1 Attachments
-   3 References

Installation
------------

Install the package ssmtp from the official repositories.

Forward to a Gmail Mail Server
------------------------------

To configure SSMTP, you will have to edit its configuration file
(/etc/ssmtp/ssmtp.conf) and enter your account settings:

    # The user that gets all the mails (UID < 1000, usually the admin)
    root=username@gmail.com

    # The mail server (where the mail is sent to), both port 465 or 587 should be acceptable
    # See also http://mail.google.com/support/bin/answer.py?answer=78799
    mailhub=smtp.gmail.com:587

    # The address where the mail appears to come from for user authentication.
    rewriteDomain=gmail.com

    # The full hostname
    hostname=localhost

    # Use SSL/TLS before starting negotiation 
    UseTLS=Yes
    UseSTARTTLS=Yes

    # Username/Password
    AuthUser=username
    AuthPass=password

    # Email 'From header's can override the default domain?
    FromLineOverride=yes

Change the file permissions of /etc/ssmtp/ssmtp.conf because the
password is printed in plain text (so that other users on your system
cannot see your Gmail password).

    chmod 640 /etc/ssmtp/ssmtp.conf

Change the config file group to mail to avoid "/etc/ssmtp/ssmtp.conf not
found" error.

    chown root:mail /etc/ssmtp/ssmtp.conf

Users who can send mail need to belong to "mail" group (must log out and
log back in for changes to be used).

    gpasswd -a mainuser mail

Create aliases for local usernames

    /etc/ssmtp/revaliases

    root:username@gmail.com:smtp.gmail.com:587
    mainuser:username@gmail.com:smtp.gmail.com:587

To test whether the Gmail server will properly forward your email:

    echo test | mail -v -s "testing ssmtp setup" username@somedomain.com

If you receive the error

    send-mail: Cannot open mailhub:25

be sure the user is a member of the "mail" group.

Change the 'From' text by editing /etc/passwd to receive mail from 'root
at myhost' instead of just 'root'.

    chfn -f 'root at myhost' root
    chfn -f 'mainuser at myhost' mainuser

Which changes /etc/passwd to:

    grep myhostname /etc/passwd

    root:x:0:0:root@myhostname,,,:/root:/bin/bash
    mainuser:x:1000:1000:mainuser@myhostname,,,:/home/mainuser:/bin/bash

An alternate method for sending emails is to create a text file and send
it with 'ssmtp' or 'mail'

    test-mail.txt

    To:username@somedomain.com
    From:youraccount@gmail.com
    Subject: Test

    This is a test mail.

Send the test-mail.txt file

    mail username@somedomain.com < test-mail.txt

> Attachments

This method does not work with attachments. If you need to be able to
add attachments, install and configure Mutt and Msmtp and then go see
the tip at nixcraft.

References
----------

-   SSMTP and Gmail on the Arch forums
-   Sending Email From Your System with sSMTP
-   The Qnd Guide to ssmtp
-   GMail Support - Configuring other mail clients

Retrieved from
"https://wiki.archlinux.org/index.php?title=SSMTP&oldid=303515"

Category:

-   Mail Server

-   This page was last modified on 7 March 2014, at 19:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
