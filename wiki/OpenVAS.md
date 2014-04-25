OpenVAS
=======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Overview
-   2 Installation
-   3 Managing users
-   4 Updating
-   5 Running OpenVAS
-   6 See Also

Overview
--------

OpenVAS stands for Open Vulnerability Assessment System and is a network
security scanner with associated tools like a graphical user front-end.
The core component is a server with a set of network vulnerability tests
(NVTs) to detect security problems in remote systems and applications.

Installation
------------

Currently, OpenVAS is available through the AUR.

Installing it will also provide you with OpenVAS client and libraries.

Managing users
--------------

To be able to use OpenVAS you first need to make an OpenVAS user. There
are two types of user authentication methods used in OpenVAS - passwords
and ssl certificates.

To add a new user run the following with root privileges:

    # openvas-adduser

This will prompt you to choose one of the two mentioned methods as a
mean of authentification.

You can also remove a user using (also with root privileges):

    # openvas-rmuser

You can make a new user certificate using (with root privileges):

    # openvas-mkcert

Updating
--------

Before running OpenVAS you should fetch new plugins and the newest
security checks:

    # openvas-nvt-sync

There is a problem with openvas-nvt-sync updating (this affects the
currently available version - 3.0.2-1). To fix it - edit
/usr/sbin/openvas-nvt-sync and find the line containing SYNC_TMP_DIR and
change it to look like:

    SYNC_TMP_DIR=`mktemp -d openvas-nvt-sync.XXXXXXXXXX -t`

Running OpenVAS
---------------

To use OpenVAS, you first need to start the OpenVAS server:

    # openvassd

To start the OpenVAS client run:

    # OpenVAS-Client &

From OpenVAS-Client you will have to connect to the OpenVAS server using
the user you previously created.

See Also
--------

-   OpenVAS Official OpenVAS website.
-   OpenVAS Compendium A Publication of the OpenVAS Project.

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenVAS&oldid=243533"

Categories:

-   Networking
-   Security

-   This page was last modified on 11 January 2013, at 20:25.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
