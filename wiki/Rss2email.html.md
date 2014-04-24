Rss2email
=========

  Summary help replacing me
  -----------------------------------------------------------------------------------------------
  An overview of the RSS feed reader program that lets users read RSS feeds from their inboxes.

rss2email is a free tool for retrieving content from RSS feeds and
mailing it. It is useful for those who do not want yet another program
with which to keep up and for people who have a system for e-mail
management that they would like to apply to their RSS feeds as well.
People with lots of e-mail often have highly customized systems that let
them process their mail efficiently; rss2email allows them to easily
apply this system to their feeds as well.

Contents
--------

-   1 Installation
-   2 Adding feeds
-   3 Getting RSS feeds
-   4 Managing rss2email
-   5 Advanced configuration
-   6 See also

Installation
------------

Install rss2email from the AUR.

Adding feeds
------------

First, tell rss2email where it should send feeds by running the command:

    $ r2e new user@example.com

Next, subscribe to an RSS feed. For example, to subscribe to the Arch
Linux package updates feed, run:

    $ r2e add https://www.archlinux.org/feeds/packages/ e-mail address

Note that an e-mail address only has to be given if the feed is to be
delivered to an address other than the default one; otherwise, leaving
off the e-mail address is acceptable.

After a new feed is added, rss2email will e-mail every post it hasn't
previously e-mailed. The first time it is run, therefore, it will e-mail
every post. To avoid this behavior, after adding a new feed, run:

    $ r2e run --no-send

Getting RSS feeds
-----------------

To get new stories, execute the command:

    $ r2e run

To automate this process and have rss2email check for new feeds every 30
minutes, users should add the following to their crontab by running the
command crontab -e and appending to the file:

    */30 * * * * /usr/bin/r2e run

Managing rss2email
------------------

To view feeds previously added to rss2email, run:

    r2e list

This will output a numbered list of feeds. To delete a feed, run:

    r2e delete number

where number is the number of the feed to be deleted.

To change the default e-mail address, run:

    r2e email new_address@example.net

Advanced configuration
----------------------

The following configuration changes should be made in config.py, which
should be located at ~/.rss2email/config.py.

To have RSS entries sent as HTML e-mails instead of as plain text, set:

    HTML_MAIL = 1

To receive new e-mails when RSS posts are updated, set:

    TRUST_GUID = 0

To set the date header of e-mails to when the RSS post was written,
rather than when the e-mail is actually sent, set:

    DATE_HEADER = 1

To fix the error message "sender domain must exist" or to change the
address from which e-mails are sent, set:

    DEFAULT_FROM = user@example.com

To force all feeds to use this address, even if they have their own
address set, use:

    FORCE_FROM = 1

To have rss2email automatically wrap long lines, set:

    BODY_WIDTH = 72

Where 72 is the number of characters after which rss2email should start
a new line.

To send mail using an SMTP server rather than the local machine, use:

    SMTP_SEND = 1
    SMTP_SERVER = smtp.example.com:25

If the SMTP server requires authentication, set:

    AUTHREQUIRED = 1
    SMTP_USER = user@example.com
    SMTP_PASS = password

See also
--------

-   http://www.allthingsrss.com/rss2email/?page_id=31#unix - Official
    getting started page
-   http://www.linux.com/archive/feed/50469 - linux.com article.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Rss2email&oldid=273430"

Category:

-   Email Client

-   This page was last modified on 1 September 2013, at 08:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
