Talkd and the talk command
==========================

The "talk" command allows you to talk to other users on the same system,
which is useful if you're both SSH'd in from somewhere. Using it is very
simple; to talk to someone the command is just

    $ talk <username> <tty>

Of course, you can talk to users on another system as well:

    $ talk <username>@<hostname> <tty>

In either case, the tty is optional. It is used if you wish to talk to a
local user who is logged in more than once to indicate the appropriate
terminal name. "tty" is of the form 'ttyXX', or 'pts/X'.

Setup
-----

> Using xinetd

1.  First, install the inetutils package, which contains talk and talkd.
    These also rely on xinetd, so install that as well. You might also
    need the screen command; it's in the screen package.

        # pacman -S inetutils xinetd screen

2.  Configure the xinetd service entry by editing /etc/xinetd.d/talk and
    setting "disable = no".
3.  If you are using tcp_wrappers or something similar, add an entry to
    /etc/hosts.allow:

        talkd: 127.0.0.1

4.  Now start xinetd:

        # systemctl start xinetd.service

5.  If you're on the local system, you might need to start a screen
    session to make yourself show up on the "w" and "who" commands --
    you need to show up there or talk won't work.
6.  Allow write access in your terminal if needed:

        $ mesg y

Talk should work now.

> Using systemd directly

Starting from inetutils 1.9.1.341-2, talk.service and talk.socket files
are provided. Just upgrade and then activate the talk daemon:

    # systemctl start talk

Now, the Lennart is strong in you!

Retrieved from
"https://wiki.archlinux.org/index.php?title=Talkd_and_the_talk_command&oldid=288968"

Category:

-   System administration

-   This page was last modified on 17 December 2013, at 03:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
