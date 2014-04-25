Flumotion
=========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Flumotion is a streaming media server created with the backing of
Fluendo. It features intuitive graphical administration tools, making
the task of setting up and manipulating audio and video streams easy for
even novice system administrators.

Contents
--------

-   1 Installing Flumotion
-   2 Changing the Default User and Pass
-   3 Starting the manager
-   4 Starting the worker
-   5 Starting Config App

Installing Flumotion
--------------------

First enable the [community] repo then do:

    # pacman -S flumotion

Changing the Default User and Pass
----------------------------------

Run:

    htpasswd -nb user password

Replace user:PSfNpHTkpTx1M with the output of htpasswd in
/etc/flumotion/managers/default/planet.xml

Next, place your user and password in the proper places in
/etc/flumotion/workers/default.xml

Starting the manager
--------------------

    flumotion-manager -d 3 /etc/flumotion/managers/default/planet.xml

Note:You can specify a different PEM certificate file by passing the
--certificate parameter to the manager.

Starting the worker
-------------------

    flumotion-worker -d 3 -u user -p password

Starting Config App
-------------------

-   GUI: flumotion-admin
-   ncurses: flumotion-admin-text

Retrieved from
"https://wiki.archlinux.org/index.php?title=Flumotion&oldid=270482"

Category:

-   Streaming

-   This page was last modified on 9 August 2013, at 09:16.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
