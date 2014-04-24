Procmail
========

Procmail is a program for filtering, sorting and storing email. It can
be used both on mail clients and mail servers. It can be used to filter
out spam, checking for viruses, to send automatic replies, etc.

The goal of this article is to teach the configuration of procmail. This
article assumes you already have either a email client (mutt, nmh, etc)
or a mail server (sendmail, postfix, etc) working, that can use (or
requires) procmail. It also assumes you have at least basic knowledge on
regular expressions. This article will give only a minimal explanation,
for a complete manual, check the man procmailrc

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Assignments
    -   2.2 Recipes
        -   2.2.1 Flags and lockfile
        -   2.2.2 Conditions
        -   2.2.3 Action
-   3 Tips and tricks
    -   3.1 Spamassassin
    -   3.2 ClamAV
    -   3.3 Filtering mail to a different mailbox
-   4 See also

Installation
------------

Install the package procmail from the official repositories.

Configuration
-------------

The configuration is going to be saved on ~/.procmailrc if this is the
configuration for an email client, or on /etc/procmailrc if is going to
be used by an email server.

The configuration is composed of two sections; assignments and recipes.

> Assignments

The assignments section provides variables for procmail

    PATH=/bin:/usr/bin
    MAILDIR=$HOME/Mail
    DEFAULT=$HOME/Mail/inbox
    LOGFILE=/dev/null
    SHELL=/bin/sh

> Recipes

Recipes are the main section, they are the actual filters that do the
actions. Recipes have the following format:

    :0 [flags] [ : [locallockfile] ]
    <zero or more conditions (one per line)>
    <exactly one action line>

The conditions are extended regular expressions, with some few extra
options. Conditions always start with an asterisk.

The action can be only a mailbox name, or an external program.

Flags and lockfile

For basic recipes, you don't need any flags. But they can be necessary
if your script calls an external command. Here is a list of some of the
most used flags:

-   f Consider the pipe as a filter.
-   w Wait for the filter or program to finish and check its exitcode
    (normally ignored); if the filter is unsuccessful, then the text
    will not have been filtered.

Using a : after the :0 is to use a lockfile. A lockfile is necessary to
prevent problems if 2 or more instances of procmail are working at the
same time (that may happen if 2 or more email arrive almost at the same
moment).

You can set the name of the lockfile after the :

Conditions

A condition starts with an asterisk, following an extended regexp, like
this one:

    * ^From.* someperson@\w+.com

Action

An action can be something as simple as

    work

in that case, the mail that complies with the condition will be saved on
the work inbox.

It could also start with a pipe, which means the message is going to be
passed to the standard input of the command following the pipe. A line
like that could be something like this:

    | /usr/bin/vendor_perl/spamc

By default, once a recipe's action is used, the processing is over.

If the f flag was used, the command can alter the message and keep
reading recipes. In this example, the spamassassin command will add
headers to the mail, with its spam status level, which later can be used
by another recipe to block it, or store it on a different mailbox.

Tips and tricks
---------------

> Spamassassin

Here is an example using spamassassin to block spam. You should already
have spamassassin installed and working.

    # By using the f and w flags and no condition, spamassassin is going add the X-Spam headers to every single mail, and then process other recipes.
    # No lockfile is used.
    :0fw
    | /usr/bin/vendor_perl/spamc

    # Messages with a 5 stars or higher spam level are going to be deleted right away
    # And since we never touch any inbox, no lockfile is needed.
    :0
    * ^X-Spam-Level: \*\*\*\*\*
    /dev/null

    # If a mail with spam-status:yes wasn't deleted by previous line, it could be a false positive. So its going to be sent to an spam mailbox instead.
    # Since we don't want the possibility of one procmail instance messing with another procmail instance, we use a lockfile
    :0:
    * ^X-Spam-Status: Yes
    $HOME/mail/Spam

> ClamAV

An example using the ClamAV antivirus.

    # We make sure its going to use the sh shell. Mostly needed for mail-only account that have /sbin/nologin as shell
    SHELL=/bin/sh

    # We'll scan the mail with clam using the standard input, and saving the result on the AV_REPORT variable
    AV_REPORT=`clamdscan --stdout --no-summary - |sed 's/^stream: //'`

    # We check if the word FOUND was in the result and save "Yes" or "No" according to that
    VIRUS=`echo $AV_REPORT|sed '/FOUND/ { s/.*/Yes/; q  };  /FOUND/  !s/.*/No/'`

    # formail is a filter that can alter a mail message, while keeping the correct format. We use it here to add/alter a header called 
    # X-Virus with either value Yes or No
    :0fw
    | formail -i "X-Virus: $VIRUS"

    # And if we just added "X-Virus: Yes", we will also add another header with the scan result, and alter the subject, again, with the scan result.
    # Since we are using the f flag, the mail is going to be delivered anyway.
    :0fw
    * ^X-Virus: Yes
    | formail -i "X-Virus-Report: $AV_REPORT" -i "Subject: [Virus] $AV_REPORT"

> Filtering mail to a different mailbox

If a coworker keeps using forward to send you jokes and other non
serious stuff, but at the same time, writes you work related mails, you
could save the forwarded mails (most likely not-work-related mails) on a
different mailbox.

    :0:
    * ^From.*coworker@domain.com
    * ^Subject.*FW:
    $HOME/mail/jokes

See also
--------

-   Procmail Homepage

Retrieved from
"https://wiki.archlinux.org/index.php?title=Procmail&oldid=305764"

Category:

-   Email Client

-   This page was last modified on 20 March 2014, at 02:06.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
