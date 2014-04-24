Kolab
=====

Related articles

-   EGroupware

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Need style clean  
                           up based on Help:Style.  
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Kolab is an unified communication and collaboration system, composed of
a server-side daemon which offers storage and synchronization
capabilities for contact, calendar, mail and file data. Clients can use
several well defined formats like vCard, iCal, XML, IMAP and LDAP to
communicate with the Kolab server.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 OpenLDAP
    -   2.2 Dovecot IMAPD
-   3 Frontends
    -   3.1 Roundcubemail Plugin
-   4 Test and start the server
-   5 See also

Installation
------------

Kolab server is available in the AUR via the pykolab package.

Configuration
-------------

At first, Kolab requires you to use a FQDN (fully qualified domain
name), therefore adjust and append:

    /etc/hosts

    192.168.1.101	kolab.example.org

Write the same domain name into /etc/hostname.

> OpenLDAP

    sudo setup-kolab ldap

389-ds-base

> Dovecot IMAPD

Frontends
---------

> Roundcubemail Plugin

Besides the basic Roundcubemail installation and configuration, this
roundcube-kolab plugin package is needed for advanced groupware
functionality.

Test and start the server
-------------------------

    systemctl enable kolabd
    systemctl start kolabd

See also
--------

-   Official homepage
-   Kolab manuals
-   http://hosted.kolabsys.com/~vanmeeuwen/build/html/howtos/build-kolab-from-source.html
-   http://mirror.kolabsys.com/pub/releases/
-   https://obs.kolabsys.com/project/show?project=Kolab%3A3.1

Retrieved from
"https://wiki.archlinux.org/index.php?title=Kolab&oldid=302720"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 11:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
