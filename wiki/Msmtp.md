msmtp
=====

> Summary

msmtp configuration and usage hints.

Required software

msmtp

> Related

mutt

OfflineIMAP

msmtp is a very simple and easy to use smtp client with excellent
sendmail compatibility.

An alternative lightweight MTA that also handles local mail is dma,
available in the AUR.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 Quick start                                                        |
| -   3 Using the mail command                                             |
| -   4 Test msmtp                                                         |
| -   5 Configuring cron for msmtp                                         |
| -   6 Miscellaneous                                                      |
|     -   6.1 Practical password management                                |
|     -   6.2 Using msmtp offline                                          |
|     -   6.3 Vim syntax highlighting                                      |
|     -   6.4 Send mail with PHP using msmtp                               |
|                                                                          |
| -   7 Troubleshooting                                                    |
|     -   7.1 Issues with TLS                                              |
+--------------------------------------------------------------------------+

Installing
----------

msmtp can be installed with package msmtp, available in the official
repositories. Optionally, installing msmtp-mta creates a sendmail alias
to msmtp.

Quick start
-----------

The following is an example of a msmtp configuration file for several
accounts. If msmtp throws errors when using this file, search for double
byte '\xc2\xa0' characters that may have been erroneously inserted.

    ~/.msmtprc

    # Accounts will inherit settings from this section
    defaults
    auth             on
    tls              on
    tls_trust_file   /usr/share/ca-certificates/mozilla/Thawte_Premium_Server_CA.crt

    # A first gmail address
    account        gmail
    host           smtp.gmail.com
    port           587
    from           username@gmail.com
    user           username@gmail.com
    password       password
    tls_trust_file /etc/ssl/certs/ca-certificates.crt

    # A second gmail address
    account    gmail2 : gmail
    from       username2@gmail.com
    user       username2@gmail.com
    password   password2

    # A freemail service
    account    freemail
    host       smtp.freemail.example
    from       joe_smith@freemail.example
    user       joe.smith
    password   secret

    # A provider's service
    account   provider
    host      smtp.provider.example

    # Set a default account
    account default : gmail

msmtp will refuse to start if user configuration file is readable and
writeable to anyone else but the owner:

    $ chmod 600 ~/.msmtprc

This does not apply to system configuration file (in Arch, this is
/etc/msmtprc; copy the example over from /usr/share/doc/msmtp/ ).

Using the mail command
----------------------

To send mails using the 'mail' command you have to install
heirloom-mailx (some applications require it, e.g. smartd):

    $ pacman -S heirloom-mailx

Either install msmtp-mta or edit /etc/mail.rc to set sendmail

    /etc/mail.rc

    set sendmail=/usr/bin/msmtp

You need to have a .msmtprc file in the home of every users who want to
send mail (for example if you want to send mails as root), or
alternatively you can use a system wide /etc/msmtprc

msmtp also understands aliases. Add the following line to the defaults
section of msmtprc or your local configuration file:

    /etc/msmtprc

    aliases               /etc/aliases

and create an aliases file in /etc

    /etc/aliases

    # Example aliases file
         
    # Send root to Joe and Jane
    root: joe_smith@example.com, jane_chang@example.com
         
    # Send cron to Mark
    cron: mark_jones@example.com
       
    # Send everything else to admin
    default: admin@domain.example

Test msmtp
----------

The -a flag specifies the account to use as sender;
<username>@domain.com is the recipient.

Save (with the addresses you want to use)

    To: <username>@domain.com
    From: username@gmail.com
    Subject: A test

    Yadda, yadda, yadda.

as, say, "test.mail".

Then execute

    $ cat test.mail | msmtp -a default <username>@domain.com

Do not merely use "echo 'Yadda, yadda, yadda.'" instead of "cat
test.mail". This causes at least Gmail and Yahoo to deliver the mail
incorrectly.

Configuring cron for msmtp
--------------------------

Assuming you're using the default cron daemon, cronie, you'll want to
make sure it knows to use msmtp rather than sendmail.

You can do this by either installing msmtp-mta or by adding the proper
crond option in /etc/conf.d/crond:

    CRONDARGS=-m/usr/bin/msmtp

Miscellaneous
-------------

> Practical password management

The password directive may be omitted. In that case, if the account in
question has auth set to a legitimate value other than off, invoking
msmtp from an interactive shell will ask for the password before sending
mail. msmtp will not prompt if it has been called by another type of
application, such as Mutt. There is a solution for such cases: the
--passwordeval parameter. You can call msmtp to use an external keyring
tool like gpg:

    msmtp --passwordeval 'gpg -d mypwfile.gpg'

If gpg prompt for the passphrase cannot be issued (e.g. when called from
Mutt) then start the gpg-agent before.

If you cannot use a keyring tool for any reason, you may want to use the
password directly. There is a patched version msmtp-pwpatched in the AUR
that provides the --password parameter. Note that it is a huge security
flaw, since any user connected to you machine can see the parameter of
any command (in the /proc filesystem for example).

If this is not desired, an alternative is to place passwords in
~/.netrc, a file that can act as a common pool for msmtp, OfflineIMAP,
and associated tools.

> Using msmtp offline

Although msmtp is great, it requires that you be online to use it. This
isn't ideal for people on laptops with intermittent connections to the
Internet or dialup users. Several scripts have been written to remedy
this fact, collectively called msmtpqueue.

The scripts are installed under /usr/share/doc/msmtp/msmtpqueue. You
might want to copy the scripts to a convenient location on your
computer, (/usr/local/bin is a good choice).

Finally, change your MUA to use msmtp-enqueue.sh instead of msmtp when
sending e-mail. By default, queued messages will be stored in
~/.msmtpqueue. To change this location, change the
QUEUEDIR=$HOME/.msmtpqueue line in the scripts (or delete the line, and
export the QUEUEDIR variable in .bash_profile like so:
export QUEUEDIR="$XDG_DATA_HOME/msmtpqueue").

When you want to send any mail that you've created and queued up run:

    $ /usr/local/bin/msmtp-runqueue.sh

Adding /usr/local/bin to your PATH can save you some keystrokes if
you're doing it manually. The README file that comes with the scripts
has some handy information, reading it is recommended.

> Vim syntax highlighting

The msmtp source distribution includes a msmtprc highlighting script for
Vim. Install it from ./scripts/vim/msmtp.vim.

> Send mail with PHP using msmtp

Look for sendmail_path option in your php.ini and edit like this:

    sendmail_path = "/usr/bin/msmtp -C /path/to/your/config -t"

Note that you can not use a user configuration file (ie: one under ~/)
if you plan on using msmtp as a sendmail replacement with php or
something similar. In that case just create /etc/msmtprc, and remove
your user configuration (or not if you plan on using it for something
else). Also make sure it's readable by whatever you're using it with
(php, django, etc...)

From the msmtp manual: Accounts defined in the user configuration file
override accounts from the system configuration file. The user
configuration file must have no more permissions than user read/write

So it's impossible to have a conf file under ~/ and have it still be
readable by the php user.

To test it place this file in your php enabled server or using php-cli.

    <?php
    mail("your@email.com", "Test email from PHP", "msmtp as sendmail for PHP");
    ?>

Troubleshooting
---------------

> Issues with TLS

If you see the following message:

     msmtp: TLS certificate verification failed: the certificate hasn't got a known issuer

it probably means your tls_trust_file is not right.

Just follow the fine manual. It explains you how to find out the server
certificate issuer of a given smtp server. Then you can explore the
/usr/share/ca-certificates/ directory to find out if by any chance, the
certificate you need is there. If not, you will have to get the
certificate on your own.

If you are trying to send mail through GMail and are receiving this
error, have a look at this thread or just use the second GMail example
above.

If you are completely desperate, but are 100% sure you are communicating
with the right server, you can always temporarily disable the cert
check:

    $ msmtp --tls-certcheck off

Retrieved from
"https://wiki.archlinux.org/index.php?title=Msmtp&oldid=247141"

Categories:

-   Email Client
-   Mail Server
