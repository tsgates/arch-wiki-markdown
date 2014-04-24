Snoopy
======

Snoopy is a program similar to Warcraft III Banlist, aimed at improving
the experience of Warcraft III players on Battle.net. Though focused on
hosting, snoopy can be useful for any users as it allows for pinging,
location checks, friends list following, and more. Snoopy is a native
program built to use with WarCraft III on Wine.

Contents
--------

-   1 Installation
-   2 Getting started
    -   2.1 Snoopy programs
    -   2.2 Executing snoopy
        -   2.2.1 Snoopy alias
        -   2.2.2 Snoopy script
    -   2.3 Allowing sudo for snoopy
-   3 See also

Installation
------------

Snoopy can be found in the AUR as package snoopy.

Getting started
---------------

> Snoopy programs

Snoopy installs three programs in the /usr/bin directory:

-   snoopy-sh is a not so useful on arch script intended to run
    snoopy-nox for the current user. Ignore this.
-   snoopy-ping is a frontend to the ping command that snoopy uses to
    ping. Feel free to ignore this too.
-   snoopy-nox is the primary program that snoopy runs. This is all
    we're really going to worry about.

> Executing snoopy

Snoopy can be executed in either of the following ways. The alias
approach is a single-user solution, as opposed to the script which will
work for all users.

Snoopy alias

A simple way to get snoopy working is to use an alias.

-   First edit your .bashrc file, add the following line as a new line
    with your interface (for example "enp1s0"):

    ~/.bashrc

    alias snoopy-sh-local='sudo snoopy-nox enp1s0 $(id -u) $(id -g)'

-   For this time you have to run:

     $ source ~/.bashrc

This command re-reads your .bashrc and is afterwards not necessary
because your .bashrc is read on every login.

Snoopy script

You can make your own script to run snoopy-nox. It takes three
parameters: your network device, your uid, and your gid. These are
necessary because snoopy must be run as root. We'll make a launch
script.

First, if you do not know your network interface run:

    # ip a

to determine what it is. A typical default ethernet interface name is
enp1s0.

How you make your script is ultimately up to you. In my example I get
the user's uid and gid using id -u and id -g respectively. I set the
interface explicitly, enp1s0. sudo is used because snoopy must be run as
root. Here is an example script:

    /usr/bin/snoopy-sh-local

    #!/bin/bash
    sudo snoopy-nox enp1s0 $(id -u) $(id -g)

When you've finished your simple script make sure it is executable:

    # chmod 755 /usr/bin/snoopy-sh-local

Now snoopy should now work properly. It is up to you how you want to run
it with regards to Warcraft 3. It shouldn't matter whether you start
snoopy before or after Warcraft 3. Perhaps you'll want to change your
script to run Warcraft 3 as well after snoopy starts.

> Allowing sudo for snoopy

You might want to allow nopassword sudo for snoopy. First, edit the sudo
config file:

    # visudo

Add a line like the following. %wheel can be replaced with specific
usernames if desired, otherwise it'll work for any users in the wheel
group.

    %wheel ALL=NOPASSWD:/usr/bin/snoopy-nox

See also
--------

-   Snoopy website

Retrieved from
"https://wiki.archlinux.org/index.php?title=Snoopy&oldid=276466"

Category:

-   Gaming

-   This page was last modified on 23 September 2013, at 20:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
