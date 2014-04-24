Scissy
======

Scissy is a standalone and minimal git hosting service.

Contents
--------

-   1 Installation
    -   1.1 Create certificate
    -   1.2 Set git home
    -   1.3 Initialize git account
    -   1.4 Start scissy
    -   1.5 Login to scissy
    -   1.6 Become admin

Installation
------------

Warning:Scissy is still in early and active developpment.

You can install scissy from AUR.

> Create certificate

You have to provide SSL certificate to run scissy, so you have to create
them first:

    cd /etc/scissy
    openssl genrsa -out server.key 2048
    openssl req -new -key server.key -out server.csr
    openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
    chmod 600 server.key server.csr server.crt
    chown git:git server.key server.csr server.crt

> Set git home

    usermod -d /var/lib/scissy git

> Initialize git account

    su git - scissy-init

> Start scissy

To start scissy at boot:

    systemctl enable scissy

To start scissy now:

    systemctl start scissy

> Login to scissy

Now to try your setup, you can register and login into
https://localhost:19042

> Become admin

You can get admin by doing:

    su git - scissy-set-admin my-user-name

Retrieved from
"https://wiki.archlinux.org/index.php?title=Scissy&oldid=292679"

Category:

-   Version Control System

-   This page was last modified on 13 January 2014, at 10:02.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
