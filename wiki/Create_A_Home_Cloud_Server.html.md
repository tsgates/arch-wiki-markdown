Create A Home Cloud Server
==========================

With Arch Linux, you can easily make a home cloud server, to replace
web-based data storage. This lets you store your data on your own
computer, and have it be accessible across platforms.

Contents
--------

-   1 Basic home cloud server components
-   2 Prerequisites
-   3 Installation
-   4 Extras

Basic home cloud server components
----------------------------------

-   A SMB server for file sharing
-   Zeroconf for service discovery
-   WebDAV for remote iPhone/web based file sharing
-   SSH / SFTP for remote access and file sharing
-   CardDAV/ConDAV for calendar, reminder, and contact sharing
-   A DLNA server for sharing music and photos with TVs and video game
    consoles

Prerequisites
-------------

-   An IP address. For example a static IP address/ domain name, or
    something like No-Ip
-   You'll need to know how to set up your firewall for port forwarding.

Installation
------------

-   Follow the Installation guide
-   Set up a LAMP stack (Apache + Mysql + PHP)
-   Set up Postgresql (for davical)
-   Install Avahi (for zeroconf)
-   Samba
-   Davical / Webical - Make sure to check the user comments at AUR and
    the davical website, for help.
-   SSH
-   MiniDLNA

Extras
------

Once you've got the base setup down, there's lots of other cool,
optional stuff you can do, such as:

-   Set up BIND so you can have a nameserver and DNS cache for your
    local network
-   Set up a web cache, for example with Squid
-   Locally host your email and notes, for example via a Simple Virtual
    User Mail System

Retrieved from
"https://wiki.archlinux.org/index.php?title=Create_A_Home_Cloud_Server&oldid=298263"

Category:

-   Web Server

-   This page was last modified on 16 February 2014, at 07:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
