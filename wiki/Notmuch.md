Notmuch
=======

> Summary

This article explains how to install and configure notmuch.

> Related

mutt

Notmuch is a mail indexer. Essentially, is a very thin front end on top
of xapian. Much like Sup, it focuses on one thing: indexing your email
messages. Notmuch can be used as an email reader, or simply as an
indexer and search tool for other MUAs, like mutt.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Overview                                                           |
| -   2 First time Usage                                                   |
| -   3 Frontends                                                          |
|     -   3.1 Emacs                                                        |
|     -   3.2 Vim                                                          |
|     -   3.3 alot                                                         |
|     -   3.4 bower                                                        |
|     -   3.5 ner                                                          |
|                                                                          |
| -   4 Integrating with mutt                                              |
+--------------------------------------------------------------------------+

Overview
--------

Notmuch is written in C and an order of magnitude faster than sup-mail.
Notmuch can be terminated during the indexing process, on the next run
it will continue where it left off. Also like sup-mail, it does not
provide a way to permanently delete unwanted email messages. It doesn't
fetch or send mails, nor does it store your email addresses, you'll need
to use programs like offlineimap, msmtp and abook for those tasks.

Notmuch is available in the Official Repositories: notmuch or
notmuch-git from the AUR

It provides python, vim, and emacs bindings.

First time Usage
----------------

After installation, you enter an interactive setup by running:

     notmuch setup

The program prompts you for the location of your maildir and your
primary and secondary email addresses. You can also edit the config file
directly which is created by default at $HOME/.notmuch-config.

Subsequent re-indexing of the mail directories is done with:

     notmuch new

Frontends
---------

There are a range of ways to use notmuch, including cli, or with one of
the Unix $EDITORS:

> Emacs

The default frontend for notmuch is Emacs. It is developed by the same
people that develop notmuch.

> Vim

There's a vim interface available and included in notmuch. To start it,
type:

    vim -c NotMuch

> alot

alot is a standalone CLI interface for notmuch, written in python. It is
available from AUR:

alot [1]

alot-git [2]

Alot uses mailcap for handling different kinds of files. This currently
includes html mails, which means that you need to configure a ~/.mailcap
file in order to view html mails. As minimum, put this line into your
~/.mailcap:

    text/html; w3m -dump %s; nametemplate=%s.html; copiousoutput

More file handlers can be configured of course.

> bower

bower[3] is another CLI interface, this one is written in Mercury[4].

> ner

ner - notmuch email reader [5] is yet another CLI interface, apparently
written in C++.

Integrating with mutt
---------------------

If you use mutt as your MUA, then notmuch is an excellent complementary
tool to index and search your mail. The notmuch-mutt package provides a
script to integrate notmuch with mutt.

Refer to the notmuch-mutt man page for configuration information. This
blogpost steps through how to setup notmuch with mutt, but the
information is a little outdated.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Notmuch&oldid=251917"

Category:

-   Email Client
