Hamachi
=======

Hamachi is a proprietary (closed source) commercial VPN software. With
Hamachi you can organize two or more computers with an Internet
connection into their own virtual network for direct secure
communication.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Hamachi 2 (beta)
        -   2.1.1 Using the hamachi command line tool as a regular user
        -   2.1.2 Automatically setting a custom nickname
-   3 Running Hamachi
    -   3.1 Systemd
-   4 GUI
-   5 See also

Installation
------------

Install the logmein-hamachi package from the AUR.

Configuration
-------------

> Hamachi 2 (beta)

Hamachi 2 is configured in
/var/lib/logmein-hamachi/h2-engine-override.cfg (create that file if it
doesn't exist). Unfortunately, it isn't easy to find a comprehensive
list of possible configuration options, so here are a few that you can
use.

Using the hamachi command line tool as a regular user

In order to use the hamachi command line tool as a regular user, add the
following line to the configuration file:

    Ipc.User YourUserNameHere

Automatically setting a custom nickname

Normally, Hamachi uses your system's hostname as the nickname that other
Hamachi users will see. If you want to automatically set a custom
nickname every time Hamachi starts, add the following line to the
configuration file:

    Setup.AutoNick YourNicknameHere

You can also manually set a nickname using the hamachi command line
tool:

    # hamachi set-nick YourNicknameHere

However, this needs to be done every time Hamachi is (re-)started, so if
you always want to use the same nickname, setting it automatically (as
explained above) is probably easier.

Running Hamachi
---------------

    # systemctl start logmein-hamachi

Now you have a whole bunch of commands at your disposal. These are in no
particular order and are fairly self explanatory.

    $hamachi set-nick bob
    $hamachi login
    $hamachi create my-net secretpassword
    $hamachi go-online my-net
    $hamachi list
    $hamachi go-offline my-net

To get a list of all the commands, run:

    $hamachi ?

Note:Make sure you change the status of the channel(s) you are in to
"online" if you want to perform any network actions on computers in
there.

> Systemd

The logmein-hamachi AUR package also includes a nice little Systemd
daemon.

If you feel like it, you can set Hamachi to start at every boot with
Systemd:

    # systemctl enable logmein-hamachi

To start the Hamachi Daemon immediately, use this command:

    # systemctl start logmein-hamachi

GUI
---

The following GUI frontends for Hamachi are available in the AUR:

-   quamachi (Qt4, Python)
-   haguichi (Gtk2, Mono)

See also
--------

-   Project home page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hamachi&oldid=302716"

Category:

-   Virtual Private Network

-   This page was last modified on 1 March 2014, at 11:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
