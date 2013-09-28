fdm
===

Summary

A guide on using fdm for the purpose of local mail delivery.

Related

Alpine

msmtp

Mutt

Postfix

SSMTP

fdm, or fetch and deliver mail, is a simple program for delivering and
filtering mail. Comparing it to other same-purposed applications shows
that it has similarities with Mutt's very focused design principles.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 Configuring                                                        |
|     -   2.1 mbox                                                         |
|     -   2.2 maildir                                                      |
|     -   2.3 Final setup                                                  |
|                                                                          |
| -   3 Testing                                                            |
| -   4 Extended usage                                                     |
|     -   4.1 Additional Filtering                                         |
|     -   4.2 Automation with cron                                         |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Installing
----------

Install fdm from the Official Repositories.

Configuring
-----------

fdm supports the tried and tested mbox format along with the newer
maildir specification.

> mbox

Alpine uses the mbox format, so we need to set up some files that we
will be editing.

    $ cd
    $ mkdir mail
    $ touch mail/INBOX .fdm.conf 
    $ chmod 600 .fdm.conf mail/INBOX

> maildir

Mutt prefers a capitized mail directory, and is able to use the maildir
format. If you plan on using Mutt do the following setup.

    $ cd
    $ touch .fdm.conf; chmod 600 .fdm.conf
    $ mkdir -p Mail/INBOX/{new,cur,tmp}

> Final setup

Edit .fdm.conf, and add your email accounts and basic filter rules. Use
mbox or maildir, but not both.

    ## .fdm.conf
    ## Accounts and rules for:
    #> foo@example.com
    #> bar@gmail.com
    ## Last edit 21-Dec-09

    # Catch-all action (mbox):
    action "inbox" mbox "%h/mail/INBOX"
    # Catch-all action (maildir):
    # action "inbox" maildir "%h/Mail/INBOX"

    account "foo" imaps server "imap.example.com"
    	user "foo@example.com" pass "supersecret"

    account "bar" imaps server "imap.gmail.com"
            user "bar@gmail.com" pass "evenmoresecret"

    # Match all mail and deliver using the 'inbox' action.
    match all action "inbox"

This will collect the mail from the listed accounts and deliver it to
the INBOX folder that we made. Refer to the fdm(1) man page for
specifics on how to connect to other types of mail servers (POP3 for
example).

Tip:You can also specify your login name and/or password in the .netrc
file.

Testing
-------

Once you have this setup to your satisfaction, attempt to collect your
mail by manually running fdm.

    $ fdm -kv fetch

This will keep your mail untouched on the server incase there are
errors. Look over the output to make sure everything worked as planned.
Open your favorite mail reader (MUA) and make sure that you can read the
mail that was just delivered.

Extended usage
--------------

Non-essential features that add to fdm's usability

> Additional Filtering

If you want to have mail from a certain account go to a specific
mailbox, you could add the following lines to your fdm.conf file. From
the config file above, if you wanted to filter the mail from
bar@gmail.com into it's own folder bar-mail, you would add this below
the existing "action" line:

    action "bar-deliver" mbox "%h/mail/bar-mail"

Change the mbox to maildir if needed, also make sure the path is
correct.

To activate the new action, add this before the existing "match" line:

    match account "bar" action "bar-deliver"

Then all mail to bar@gmail.com will be put into the bar-mail mail
folder.

> Automation with cron

If all went well, set up a cron job to check your mail regularly.

    $ crontab -e
    */15 * * * * fdm fetch >> $HOME/[Mm]ail/fdm.log

See also
--------

-   fdm's official site
-   fdm's SourceForge project page
-   fdm-users mailing list

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fdm&oldid=249686"

Category:

-   Email Client
