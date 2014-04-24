Slrn
====

Slrn is a text-based news client. It runs through a textual user
interface and is highly customizable. It uses the S-Lang library.

Contents
--------

-   1 Configuration
    -   1.1 User account
    -   1.2 Signature
    -   1.3 Encoding
    -   1.4 Displaying all posts
-   2 Managing usergroups
-   3 See also

Configuration
-------------

To run slrn, you will have to set up an environment variable with the
newsgroups server you wish to use (it is a good idea to put it into your
.bashrc so you do not have to export it again for each session):

    NNTPSERVER='my.news.server' && export NNTPSERVER

Two important slrn configuration files are .slrnrc for basic
configuration and .jnewsrc that contains the list of newsgroups.

To create .slrnrc from a sample startup file for slrn:

    # cp /usr/share/doc/slrn/slrn.rc /home/your_username/.slrnrc

After creating .slrnrc you should configure the user account and then
create .jnewsrc:

    # slrn -f /home/your_username/.jnewsrc --create

User account

To set up your newsgroup account, you have to set up the following
parameters in .slrnrc

    set username "desired_username"
    set hostname "desired_hostname"
    set replyto "some_name <email@example.com>"

Signature

To set up a signature uncomment the following line in .slrnrc:

    set signature ".signature"

Also, you have to create .signature file in your home folder and put
your signature in it.

Encoding

To set up encoding (i.e. utf8) uncomment the following lines in .slrnrc:

    charset display utf8
    charset outgoing utf8

Displaying all posts

By default slrn will only shows unread posts. If you are used to having
all posts listed in a certain newsgroup, this will be a big change for
you. To have all posts listed add the following to your .slrnrc:

    setkey group "set_prefix_argument(4); () = select_group();" " "

Managing usergroups
-------------------

You can manage usergroups directly through slrn or by editing .jnewsrc
file. If you decide to manage them using .jnewsrc file, you can do it by
changing the ! and : at the end of each newsgroup.

Unsubscribed group example:

    misc.test! 1-210917

Subscribed group example:

    misc.test: 1-210917

See also
--------

-   slrn Official slrn website.
-   slrn FAQ slrn frequently asked questions

Retrieved from
"https://wiki.archlinux.org/index.php?title=Slrn&oldid=302721"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 11:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
