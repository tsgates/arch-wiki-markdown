UnrealIRCd
==========

UnrealIRCd (Unreal IRC daemon) is an Open Source IRC Server. Development
of UnrealIRCd began in May of 1999. Unreal was created from the
Dreamforge IRCd that was formerly used by the DALnet IRC Network. Over
the years, many new and exciting features have been added to Unreal. It
is hard to even see a resemblance between the current Unreal and
Dreamforge.

Installing UnrealIRCd
---------------------

Install from the community repo:

    pacman -S unrealircd

Configuring (mandatory)
-----------------------

Many of the settings you'll want to set are very dependent on how you
will use your IRC server. There is a default configuration but it
doesn't work out of the box.

The files in /etc/unrealircd/ are not viewable by users, only root can
see/read/edit the files in this directory.

The first thing you'll want to do when setting up UnrealIRCd is to open
/etc/unrealircd/unrealircd.conf and find the lines where it says FOR
*NIX, uncomment the following 2lines and uncomment them. You'll also
need to remove the src/ from the start of the path, as they are in the
modules directory under /etc/unrealircd/

From there you'll want to follow the UnrealIRCd Configuration Docs
making sure to configure all of the required fields such as me, admin,
class etc etc.

As far as I could tell, you do not get even snake oil certs with the
UnrealIRCd package. I am sure there are other (easier) ways to generate
the certs, but my solution was to use ABS to build the package, then
went into src/ and ran:

    make pem

Which will ask you a series of questions, if you are running a public
facing server you should answer them honestly, if you are not, then the
answers do not really matter.

Starting/Stopping the daemon
----------------------------

You can start and stop the UnrealIRCd daemon as usual by running:

    systemctl {start|stop|restart} unrealircd

If you run into problems where the daemon won't start, I recommend
running:

    sudo unrealircd

It will spew out the errors and what line they occur on. Often it is due
to problems in your configuration.

Retrieved from
"https://wiki.archlinux.org/index.php?title=UnrealIRCd&oldid=241920"

Category:

-   Internet Relay Chat

-   This page was last modified on 28 December 2012, at 06:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
