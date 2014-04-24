Etherpad-lite
=============

Summary help replacing me

This article explains how to install and configure Etherpad-Lite.

> Related

Ethersheet

Gobby

CoVim

Etherpad-Lite or just Etherpad, is a collaborative, multi-user
web-editor based on NodeJS with the ability to import/export various
office file formats.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Starting
-   4 See also

Installation
------------

Install etherpad-lite from the AUR.

Configuration
-------------

For testing purpose, the default database backend for Etherpad is the
file-based DirtyDB. With that, you can run and test Etherpad-Lite
without any further configuration. If you want to use MySQL, PostgreSQL
or SQLite, you can adjust those settings in the settings.json file.
Further, you can set a password for the administrator interface on
http://localhost:9001/admin, change port and listening address, etc. At
least, don't forget to set a sessionkey, e.g. generate with pwgen and
pwgen -y 10 1 and write it down to:

    /usr/share/webapps/etherpad-lite/settings.json

    "sessionKey" : "",

Your Etherpad installation can be extended with plugins listed at the
administrator interface.

Starting
--------

To enable the and start server process, run:

    systemctl enable etherpad-lite
    systemctl start etherpad-lite

Finally you can access Etherpad-Lite on http://127.0.0.1:9001 or
directly access a pad with http://127.0.0.1:9001/p/padname

See also
--------

-   Official Etherpad website
-   Developement page on GitHub

Retrieved from
"https://wiki.archlinux.org/index.php?title=Etherpad-lite&oldid=306109"

Category:

-   Internet applications

-   This page was last modified on 20 March 2014, at 17:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
