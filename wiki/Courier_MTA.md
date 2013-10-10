Courier MTA
===========

> Summary

This article focuses on the big Courier-MTA mail-server suite, which
integrates an MTA and the POP3/IMAP mail fetching methods.

> Related

Simple Virtual User Mail System

Postfix

SOHO Postfix

Courier MTA is an SMTP and POP3/IMAP4 Server with courier.

The advantages of Courier-MTA are:

-   Authentication for MTA and POP3/IMAP happens against one data source
-   This datasource can be a MySQL, PgSQL or LDAP, but also can be
    simpler like PAM or a compiled plaintextfile (BerkeleyDB)
-   Easy support of virtual users
-   SMTP-auth out of the box
-   Comes with webmail
-   Web based administration possible
-   Also has a separate mail delivery agent (MDA), if it is needed

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preamble                                                           |
| -   2 Installing                                                         |
| -   3 Authuserdb authentication                                          |
| -   4 Creating the vmail user                                            |
| -   5 Creating the email accounts                                        |
| -   6 Setting up Maildirs                                                |
| -   7 Creating the user database                                         |
| -   8 Configuring courier                                                |
|     -   8.1 Setting localdomain and hosteddomains                        |
|                                                                          |
| -   9 Testing your setup                                                 |
| -   10 Configuring IMAP and POP3                                         |
| -   11 Remarks                                                           |
| -   12 See also                                                          |
+--------------------------------------------------------------------------+

Preamble
--------

This is a "little" text which will help you to configure the courier
mail server. It doesn't explicitly cover the configuration of the
popular and widely used Courier-IMAP server. Instead it focuses on the
big Courier-MTA mail-server suite, which integrates an MTA and the
POP3/IMAP mail fetching methods.

While there are many methods how authorization of users for MTA and POP
can be integrated in one database, there is really no such integrated
solution which comes out of the box. There are a couple of mail-servers
on Windows which support that, but we're working with Unix/Linux here,
right? Also, some admins might argue that the integration of
authentication via external databases or LDAP repositories are
absolutely sufficient and even desirable since the POP3 server and the
MTA are hosted on separated machines anyway. Well, how about the
enthusiastic user who rents one dedicated server or the home user who
just wants to serve his or her home network? Mostly the enterprise
solutions are copied and narrowed down to personal needs.

Note:This creates potential security risks since it is tricky to
coordinate all these different pieces of software appropriately.

Courier-MTA is not really simple, but it might be easier than the
constructs mentioned above.

The following text describes a setup for two local domains on one
physical machine, which is not so uncommon for single users or small
companies. We authenticate against a BerkeleyDB-based ".dat" file which
is created from a text or multiple textfiles automatically by tools that
come with courier. This method is described in the Courier documentation
as authuserdb, so do not get confused about names. The authentication
against other providers happens in an adequate way and is covered in
courier-authlibs documentation. There are differences in the handling of
SASL methods (such as PLAIN or CRAM-MD5) depending on which
authentication backend (authuserd, authpam, authmysql ...) you like to
use. Just do not expect that this setup can be painlessly converted from
the described authuserdb to authmysql.

Note:If you would like to test on your local box but have no DNS-server
running, the setup fails on some edges because Courier-MTA needs at
least an MX entry to work. To work around that you can recompile
courier-mta from "abs". Add --without-tcpddns to the configure
attributes and go make some coffee, since this will take a while. Then
make sure, that you add our dummy domains "domain1" and "domain2" to
your /etc/hosts.

Installing
----------

Install courier-mta from the Arch User Repository.

Any other mail transfer agents (like cyrus) or smtp servers (sendmail,
postfix, etc) must be uninstalled for this, so answer 'yes' when
prompted to do so.

Authuserdb authentication
-------------------------

Let courier know that we want to authenticate against authuserdb.

In the file /etc/authlib/authdaemonrc find authmodulelist=... then
remove all listed modules except for authuserdb:

    authmodulelist="authuserdb"

    # For test it is useful to set DEBUG_LOGIN from 0 to 2
    DEBUG_LOGIN=2

Creating the vmail user
-----------------------

We want to deliver our mail primarily to virtual users, so we can easily
create e-mail accounts without creating real users. Granny may want to
read her e-mail but she doesn't need ssh access to that box, does she?
To make that possible we need one "physical" user, that owns all of our
mails physically on the drive. Note, that this is not the courier user
which is primarily there to make sure that the actual server process
doesn't run as root. Many people save this stuff in /var since it's
primarily thought for these things. You can create the users "home" just
anywhere you want! The decision will be influenced by the partition
layout of your drive(s).

Add a user "vmail", who is the lord of all of the mail files:

    # useradd -u 7200 -m -s /bin/bash vmail
    # passwd vmail

Creating the email accounts
---------------------------

There is a place where the virtual users and their attributes will be
stored. This can be either a plain textfile or a directory where several
textfiles are contained. See courier-authlib's documentation for
details. The directory-based approach makes maintenance a bit easier
since we can separate the users of domains and subdomains, so we'll go
with this approach. The name of the directory is not negotiable.

    # mkdir /etc/authlib/userdb

The attributes of the "vmail"-system user need to be stored here, too,
since we allowed only authuserdb in /etc/authlib/authdaemonrc .
Fortunately, courier comes with a handy script that converts all local
users into a file in courier-syntax. This file can be named freely, we
call it "system". Later we also create a file for "domain1" and
"domain2". Got the idea?

    # pw2userdb > /etc/authlib/userdb/system

Keep only the "vmail" user (this means that no local user can receive
emails!):

    # sed -n -i "/vmail/p" /etc/authlib/userdb/system

Now we create the virtual users in the authentication database. The
actual Maildir folders have to be created manually later. This creates a
user "user1@domain1" and a "user2@domain2". For details about these
commands check the man pages for the command itself and the man pages
that are linked to.

-   user1:

    # userdb -f /etc/authlib/userdb/domain1 user1@domain1 \
      set home=/home/vmail/domain1/user1 uid=7200 gid=7200

Let's set a password for the user (used for PLAIN and LOGIN and APOP):

    # userdbpw -md5 | userdb -f /etc/authlib/userdb/domain1 user1@domain1 set systempw

The following is used for CRAM-MD5 and friends (SASL-methods). Also note
that this construct pipes the the password directly into the command and
thus can be read as cleartext, but can be handy for shell scripts that
create new users:

    # echo 'pwuser1' | userdbpw -hmac-md5 | \
      userdb -f /etc/authlib/userdb/domain1 user1@domain1 set hmac-md5pw

-   user2 (repeat for user2@domain2):

    # userdb -f /etc/authlib/userdb/domain2 user2@domain2 \
      set home=/home/vmail/domain2/user2 uid=7200 gid=7200

    # userdbpw | userdb -f /etc/authlib/userdb/domain2 user2@domain2 set systempw

    # echo 'pwuser2' | userdbpw -hmac-md5 | \
      userdb -f /etc/authlib/userdb/domain2 user2@domain2 set hmac-md5pw

Setting up Maildirs
-------------------

We need to create the virtual users "Maildir" as a physical place on the
hard-drive in the "vmail"-system user home directory. Note that the
"vmail" user needs write rights and also will own the files. It's
easiest to create that stuff as the "vmail" user:

Become "vmail":

    # su vmail
    $ mkdir -p /home/vmail/domain1/user1 && maildirmake /home/vmail/domain1/user1/Maildir
    $ mkdir -p /home/vmail/domain2/user2 && maildirmake /home/vmail/domain2/user2/Maildir

Leave "vmail" account and become root:

    $ exit

Make sure you become root again by leaving the "vmail" account by typing
exit as shown above.

Creating the user database
--------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: initscripts has  
                           been depreciated. Use    
                           systemd instead.         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Now it's time to create the BerkeleyDB from the plain textfiles. It is
important that the files in /etc/authlib/userdb are visible for root
only. If they have any world or group rights, courier will not allow the
creation of the db-files from the information.

    # chmod 700 /etc/authlib/userdb && chmod 600 /etc/authlib/userdb/*
    # makeuserdb

Now we can check if the authentication works. Courier comes with a
little tool that checks if users can be authenticated. Before using this
tool, we must make sure the authentication daemon is running:

    # /etc/rc.d/authdaemond start
    # authtest user1@domain1
    # authtest user2@domain2

If you encounter any errors while testing the authentication, please
consult these instructions, which detail how to use debugging features
to pinpoint the problem.

Configuring courier
-------------------

Now we are now done with authentication stuff. It gave us a flexible
layout which can be easily extended. Time to move on to courier's
configuration itself. First, we will try to give some aliases for the
server. The aliases follow the userdb's scheme very closely. Unlike in
other servers, there is no need to handle with all aliases in just one
file. Again, you can create several plain textfiles in one folder, where
you can handle the aliases by domains or even finer structured if you
like. The folder's location is again not negotiable, you must use
/etc/courier/aliases. There is already a "system" file which deals with
root, postmaster and the usual suspects. Just add a "user1@domain1"
behind the existing "postmaster: " to have all system relevant mails
delivered to "user1@domain1". We just assume that this user is your
primary account.

    # cat > /etc/courier/aliases/domain1 << EOALIASES
    user1@domain1:        user1@domain1
    user.user1@domain1:   user1@domain1
    u.user1@domain1:      user1@domain1
    userer1@domain1:      user1@domain1
    looser1@domain1:      user1@domain1
    EOALIASES

Repeat that for every domain and user, in our testcase for
user2@domain2. It might help to create another scheme here like naming
your files domain1.user1 which makes administration easier and more
transparent. This will also help on automated, script-based
administration.

Finally, these aliases must be exported to the BerkeleyDB. Again,
Courier comes with a little utility for that task, it's called
makealiases:

    # makealiases

Just check if everything is fine:

    # makealiases -chk

> Setting localdomain and hosteddomains

Now we need to tell courier the who is who on this box -- who we serve
e-mail for and who we do not. Courier separates this into these levels:

-   locals: This is localhost for sure and on dedicated servers you are
    mostly part of a domain like server234.serverfarm.tld
-   hosteddomains: For your hosted domains and subdomains like
    my-cool-domain.ca, project1.my-cool-domain.ca

For example, lets say you have a server at blahfarm.com. Usually they
make your server a host on their domain. This is likely something like
server234.blahfarm.com . Now, you want your server available from the
web by a more meaningful and even cooler name, so you buy (or rent) a
domain name like my-cool-domain.ca . In this case the setup looks like
this:

locals:

localhost

server237.blahfarm.com

hosteddomains:

my-cool-domain.ca

project1.my-cool-domain.ca

smtp.my-cool-domain.ca

Note:Any subdomain like project1.my-cool-domain.ca or
smtp.my-cool-domain.ca also must also be in /etc/courier/hosteddomains
if you want to have email addresses like info@project1.my-cool-domain.ca

To learn the difference between these specifications, read the manpage
for makehosteddomains. You will figure that the following suits our
approach:

    # echo localhost > /etc/courier/locals
    # echo server237.blahfarm.com >> /etc/courier/locals

    # mkdir /etc/courier/hosteddomains
    # cat > /etc/courier/hosteddomains/domain1 << EODOMAIN1HOSTED
    domain1
    mail.domain1[TAB]domain1
    EODOMAIN1HOSTED

    # cat > /etc/courier/hosteddomains/domain2 << EODOMAIN2HOSTED
    domain2
    mail.domain2[TAB]domain2
    EODOMAIN2HOSTED

Note:[TAB] can be inserted by typing 'Ctrl' + V then 'Tab'

Again, these values must be converted into a BerkeleyDB - use the
courier command:

    # makehosteddomains

Before we go on, one more thing needs to be written -- the domain(s) we
accept mail for. In the directory /etc/courier/esmtpacceptmailfor.dir/
we'll create a file named domain1 and type domain1 into it:

    # echo domain1 > /etc/courier/esmtpacceptmailfor.dir/domain1

Repeat for domain2:

    # echo domain2 > /etc/courier/esmtpacceptmailfor.dir/domain2

Finally, convert into a BerkeleyDB:

    # makeacceptmailfor

...and you are done here.

Testing your setup
------------------

Now the server is read to rock. Let's run several tests on the SMTP
server and see if it's working nicely at least for sending and receiving
mails.

    ###############################################################################
    # this is  a testcase suggested on couriers very own webpage, we just convert it
    # from a local to a virtual user

    # prepare as vmail
    su vmail
    cd ~/domain1/user1

    maildirmake bounces && maildirmake test
    echo "./test" > .courier-test-default
    echo "./bounces" > .courier

    # back to root, start the server and finally run the script
    exit
    /usr/sbin/courier start
    /usr/lib/courier/perftest1 1000 "user1@domain1 user2@domain2"
    ###############################################################################

Let's test some more stuff, which can be useful.

Send an ordinary mail (as root or ordinary user):

    $ echo "To: user2@domain2
    From: user1@domain1" | /usr/bin/sendmail

Send a mail to an alias:

    $ echo "To: userer2@domain2
    From: user1@domain1" | /usr/bin/sendmail

Send a mail to an external email address:

    $ echo "To: me_freak@gmail.com
    From: user1@domain1" | /usr/bin/sendmail

Configuring IMAP and POP3
-------------------------

So far, our operations have been focused on the box which runs the
server itself. Now we need to setup some interaction related
configuration. Since security is important we will setup some nice
authentication modes, which doesn't send cleartext passwords. Courier
supports CRAM-MD5 among others. You will have to make sure that your
clients support that too. So far I tested sylpheed-claws > 1.0.4, esmtp
and thunderbird with these settings.

Now it comes in, that we will have to configure the several server
daemons. Courier is already running (from the perftest above) but it
doesn't provide services to the network. So we have to configure esmtpd,
pop3d and imapd with their respective configuration files in
/etc/courier/<servicename> .

Since we like to use SMTPAuth instead if a IP/Domain based SMTP
authentication we need to activate the AUTHREQUIRED option in esmtpd.
Also we activate the CRAM-MD5 challenge method for authorization. NOTE:
this setup definitely keeps Outlook losers out. For these buggy and old
fashioned clients you will need to use way less restrictive settings!

In /etc/courier/esmtpd:

    AUTH_REQUIRED=1
    ESMTPAUTH="CRAM-MD5"

In /etc/courier/pop3d:

    POP3AUTH="CRAM-MD5"

The imapd setting is a bit different. In /etc/courier/imapd there is a
long line starting with IMAP_CAPABILITY. Just add a "AUTH=CRAM-MD5" at
the end of the arguments and you should be done:

    IMAP_CAPABILITY="... AUTH=CRAM-MD5"

Remarks
-------

Because of our very small testcase with just 2 boxes and no
domaincontrol we have to take a look at couriers intrinsics and work
around a little issue. Courier is nitpicking about RFC compliance, which
does mean you have to make sure that you understand how to configure
your e-mail clients for testing. This will fail in our testing:

    +------------+            +---------------+                +-------------------+
    |local laptop|  ------->  |local box(with |  ------------> |  MTA somewhere on |
    +------------+            |  courier-mta) |                |  web              |
                              +---------------+                +-------------------+

Why? Because you send from a non-valid domain name. I assume here, that
we use our "domain1" and "domain2" testpark. Now, when you create an
account in Sylpheed which looks like this: Name: user numberone Address:
user1@domain1 Sylpheed consequently sends the mail as "user numberone
<user1@domain1>". This is wrong, since it violates the RFC. You get a
Error: 517 - Syntax Error. For the testing you can simply fool
Courier-MTA by setting the domain in sylpheed's dialog to: Address:
user1@domain1.xx

Something similar (you just get Error 513 - Syntax Error) happens in
this case:

    +--------------------------+            +------------------------+
    |local laptop              |  ------->  |local MTA (courier-mta) |
    | sylpheed account         |            | MTA delivers to        |
    | user1@domain1.xx sends   |            | user2@domain2          |
    | to user2@domain2         |            +------------------------+
    +--------------------------+

because domain2 is not valid. You can send to mail.domain2 which will
work around that. For boxes at the internet and properly configured
domains this is absolutely no problem, since you are always part of a
domain and thus have one dot (.) behind the @.

See also
--------

-   Simple Virtual User Mail System
-   Postfix
-   SOHO Postfix

Retrieved from
"https://wiki.archlinux.org/index.php?title=Courier_MTA&oldid=240896"

Category:

-   Mail Server
