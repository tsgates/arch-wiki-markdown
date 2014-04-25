Xhost
=====

Contents
--------

-   1 Summary
-   2 Installation
-   3 Usage
-   4 The 'cannot connect to X server :0.0' output

Summary
-------

From Xhost man page:

The xhost program is used to add and delete host names or user names to
the list allowed to make connections to the X server. In the case of
hosts, this provides a rudimentary form of privacy control and security.
It is only sufficient for a workstation (single user) environment,
although it does limit the worst abuses. Environments which require more
sophisticated measures should implement the user-based mechanism or use
the hooks in the protocol for passing other authentication data to the
server.

See man xhost for the full info.

Installation
------------

Install xorg-xhost from the Official repositories.

Usage
-----

To provide access to an application running as sudo or su to the
graphical server (aka your X session aka your computer screen), open a
terminal and type as your normal user (don't su -):

    xhost +

To get things back to normal, with controlled access to the X screen:

    xhost -

The 'cannot connect to X server :0.0' output
--------------------------------------------

The above command xhost + will get you rid of that output, albeit
momentarily; one way of getting permanently rid of this issue, among
many, is to add

    xhost + >/dev/null

into your ~/.bashrc file. This way, each time you fire up the terminal,
the command gets executed. If you do not yet have a .bashrc file in your
home directory, it's OK to create one with just this line in it. If you
do not add >/dev/null then each time you fire a terminal, you will see a
non-disruptive message saying: access control disabled, clients can
connect from any host, which is your confirmation that you can now sudo
<your soft> without issue.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xhost&oldid=301577"

Category:

-   Networking

-   This page was last modified on 24 February 2014, at 11:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
