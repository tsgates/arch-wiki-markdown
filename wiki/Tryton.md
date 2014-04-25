Tryton
======

  

  Summary help replacing me
  ------------------------------------------------------------------------------------------------------------------------------------------------------
  Covers installation and configuration of Tryton – an application platform for businesses that allow you to setup a central server for invoices, etc.

Tryton is a three-tiers high-level general purpose application platform
under the license GPL-3 written in Python and using PostgreSQL (or
sqlite) as database engine.

Installation
------------

Install the server application, trytond, from the AUR.

Once trydond is installed, install the client application, tryton, from
the AUR.

Configuring
-----------

As root or using sudo, edit the file /etc/trytond.conf

Here you will find options which you can uncomment and fill out as
necessary.

Next, as root, create the directory /var/lib/trytond, and chown it so
that the trytond user can access it.

Now you can launch trytond and the tryton client.

Run /etc/rc.d/trytond start as root, and then launch tryton as a regular
user.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tryton&oldid=206865"

Category:

-   Web Server

-   This page was last modified on 13 June 2012, at 14:37.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
