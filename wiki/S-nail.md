S-nail
======

S-nail is a mail processing system with a command syntax reminiscent of
ed, with lines replaced by messages. It is based on Heirloom mailx,
which in turn is based upon Berkeley Mail 8.1. It is intended to provide
the functionality of the POSIX mailx command and offers (mostly
optional) extensions for IDNA, MIME, S/MIME, SMTP, POP3 and IMAP. It is
usable as a mail batch language.

Contents
--------

-   1 Sending mail with an external SMTP server
    -   1.1 Testing and sending emails
-   2 Interactive use with an IMAP mailbox
    -   2.1 Viewing messages
    -   2.2 Message composition

Sending mail with an external SMTP server
-----------------------------------------

Configuration files are $HOME/.mailrc and the systemwide /etc/mail.rc.
Add the following text to the appropriate file, changing bold strings:

    set smtp=smtp(s)://server:port
    set smtp-use-starttls
    set smtp-auth-user=mailuser
    set smtp-auth-password=password
    set from="Your Name <youremail@domain>" # optional

> Testing and sending emails

To test the configuration:

    $ echo "message" | mailx -v -s "subject" receiver@mail.com

Interactive use with an IMAP mailbox
------------------------------------

While only folder is strictly required, the following are some suggested
settings for interactive usage.

    set folder=imap(s)://mylogin@server:port
    set password-mylogin@server=password

    retain subject from to cc # only print these headers by default
    set editalong             # invoke $EDITOR when composing mail interactively
    set record=+Sent          # + means relative to folder
    set imap-keepalive=240    # or many servers will expire the session
    set imap-cache=~/.imap_cache

    # You may want to define shortcuts to folders, for example:
    shortcut junk "+INBOX/Junk Mail"

When storing passwords in $HOME/.mailrc, you should set appropriate
permissions with chmod 0600. Additional accounts can be configured using
the account command; see the man pages for details.

> Viewing messages

When started in interactive mode, S-nail will print a listing of
messages in your mailbox.

A message may be printed by typing its number, or the next message may
be printed by simply hitting Enter. The following listing instructs
basic usage, but once comfortable, a skimming of the manual is strongly
encouraged.

-   inc (incorporate) prints listing of new messages
-   he (headers) reprints the message list
-   z-, z+, Z pages the message list
-   folders shows listing of mailboxes
-   folder or fi changes the mailbox file
-   r replies to all
-   R replies to the sender
-   move or mv moves a message
-   (un)flag marks a message as (un)flagged
-   new marks a message unread
-   seen marks it read
-   P prints all of a message's headers.

Most commands take a message-list as a parameter, which defaults to the
current message.

> Message composition

Composition is started by typing mail user@host or by replying to a
message. When you return from $EDITOR you will be placed into the native
editor, where many operations can be performed using tilde escapes
(listed by ~?). Of particular interest is ~@, which allows the
attachment list to be edited.

To send the mail, signal EOT with Ctrl+d or type "." on its own line.

Retrieved from
"https://wiki.archlinux.org/index.php?title=S-nail&oldid=290294"

Category:

-   Email Client

-   This page was last modified on 24 December 2013, at 19:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
