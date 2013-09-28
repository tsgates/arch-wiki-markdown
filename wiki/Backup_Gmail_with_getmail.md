Backup Gmail with getmail
=========================

We can use getmail to fully backup email messages from a Gmail account.

Emails will be backed-up in Maildir format, meaning that each email will
be a separate text file, readable with any email client, or even with a
text editor.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing getmail                                                 |
| -   2 Creating required files and folders                                |
| -   3 Configuring getmail                                                |
| -   4 Running getmail and adding a cron job                              |
| -   5 Migrating emails, importing old emails                             |
+--------------------------------------------------------------------------+

Installing getmail
------------------

    # pacman -S getmail

Creating required files and folders
-----------------------------------

Getmail reads its configuration from ~/.getmail/getmailrc by default.
Unfortunately this directory and file do not exist by default, so we
need to create them.

    $ mkdir ~/.getmail
    $ touch ~/.getmail/getmailrc
    $ chmod 700 ~/.getmail

We also need to create the folder where the emails will be backed-up:

    $ mkdir ~/bak/mail
    $ cd ~/bak/mail
    $ mkdir cur new tmp

For this example ~/bak/mail was chosen , but it could just as well be
~/mail. The cur, new and tmp folders are required by the Maildir format
and by getmail.

Configuring getmail
-------------------

Open the ~/.getmail/getmailrc file and add the entries below. The
complete file can also be found here
http://archlinux.pastebin.com/0GH5vtSn

    # More configuration options here:
    # http://pyropus.ca/software/getmail/configuration.html
    [retriever]
    type = SimpleIMAPSSLRetriever
    server = imap.gmail.com
    mailboxes = ("[Gmail]/All Mail",)
    username = USER
    password = PASS

The retriever section tells getmail where to connect. It uses IMAP to
connect to the server. For POP3 we can use the type
SimplePOP3SSLRetriever, but we'll also have to modify the server field.
The mailbox which we backup will be All Mail.

The username and password fields need to be changed to your own.

    [destination]
    type = Maildir
    path = ~/bak/mail/

The path field is the destination folder (which we created earlier)
where the emails will be backed-up. All emails will be placed in 'new',
and the cur and tmp folders will be left empty. This is normal, do not
delete cur and tmp.

The options section is a bit longer:

    [options]
    verbose = 2
    message_log = ~/.getmail/log

This tells getmail to be very verbose and tell us the status of each
message (whether it was backed-up successfully, total number of
messages, etc). Also, everything will be logged to ~/.getmail/log.

    # retrieve only new messages
    # if set to true it will re-download ALL messages every time!
    read_all = false

    # do not alter messages
    delivered_to = false
    received = false

Setting delivered_to and received fields to false will prevent emails
from being altered by getmail.

Running getmail and adding a cron job
-------------------------------------

Now if we run getmail it will backup all Gmail emails to ~/bak/mail,
outputting its status along the way.

We want to periodically run getmail to backup our Gmail account, so
we'll add a cron job:

    * * * * *   ID=getmail FREQ=1d getmail -q

The -q parameter will run getmail in quiet mode and only report errors.

Migrating emails, importing old emails
--------------------------------------

Backing-up emails will suffice for most people, but if we want to
migrate our emails to another account it gets a bit tricky. The
appendmail script from http://bitbucket.org/wooptoo/appendmail can help
us import emails to another account, be it Gmail or not. It can also be
used to import old emails in our existing Gmail account.

Basically it reads every email file from its 'import' folder and puts it
on Gmail or another account.

A direct link to download is
http://bitbucket.org/wooptoo/appendmail/get/tip.zip It needs PHP to run,
and you need to modify the username and password to yours.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Backup_Gmail_with_getmail&oldid=206894"

Category:

-   Email Client
