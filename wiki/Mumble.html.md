Mumble
======

From Wikipedia, the free encyclopedia:

Mumble is a voice over IP (VoIP) application primarily designed for use
by gamers, similar to programs such as TeamSpeak and Ventrilo.

This page goes over installation and configuration of both the client
portion of the software (Mumble) and the server portion (Murmur).

Contents
--------

-   1 Client
    -   1.1 Installation
    -   1.2 Configuration
-   2 Server
    -   2.1 Installation
    -   2.2 Configuration
        -   2.2.1 Network
        -   2.2.2 Config File
        -   2.2.3 Startup

Client
------

> Installation

Install mumble from the official repositories.

> Configuration

When you first launch the client, a configuration wizard will take you
through the setup process. Settings can be changed later through the
menu.

For a discussion of advanced settings, see the official documentation.
The Mumbleguide is a good starting point.

Server
------

The Mumble project maintains a good guide for setting up the server
here: Murmurguide. What follows is a quick-and-dirty, abridged version
of that guide.

> Installation

Install murmur from the official repositories.

The postinstall script will tell you to reload dbus and set the
supervisor password. The default configuration doesn't use dbus, so you
can ignore that if you want. Setting the supervisor password is
recommended, however.

> Configuration

Network

If you use a firewall, you will need to open TCP and UDP ports 64738.
Depending on your network, you may also need to set a static IP, port
forwarding, etc.

Config File

The default Murmur config file is at /etc/murmur.ini and is heavily
commented. Reading through all the comments is highly recommended.

Startup

Enable and then start Murmur with systemctl enable murmur and
systemctl start murmur. If all went smoothly, you should have a
functioning Murmur server.

  

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mumble&oldid=293779"

Category:

-   Sound

-   This page was last modified on 20 January 2014, at 20:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
