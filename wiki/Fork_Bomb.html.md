Fork Bomb
=========

A fork bomb is a simple, malicious script designed to consume as much of
a system's resources as possible in a very short time frame. It is
common for trolls and malicious forum users to try to trick new users
into executing fork bombs, which will usually crash a improperly
configured computer.

Scripts
-------

The most common form of a bash fork bomb looks like this:

    $ :(){ :|: & };:

This script will define a function which calls an instance of itself,
and then pipes the output of that instance into another instance of
itself, then disowns the child processes so the bomb cannot be stopped
by killing the parent, then calls the function.

Prevention
----------

On systems with many, or untrusted users, it is important to limit the
number of processes each can run at once, therefore preventing fork
bombs and other denial of service attacks. /etc/security/limits.conf
determines how many processes each user, or group can have open, and is
empty (except for useful comments) by default. adding the following
lines to this file will limit all users to 100 active processes, unless
they use the ulimit command to explicitly raise their maximum to 200 for
one session. These values can be changed according to the appropriate
number of processes a user should have running, or the hardware of the
box you are administrating.

    * soft nproc 100
    * hard nproc 200

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fork_Bomb&oldid=298920"

Category:

-   Scripts

-   This page was last modified on 19 February 2014, at 11:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
