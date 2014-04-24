Autodl-irssi
============

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

installation
------------

install "autodl-irssi-svn" package from AUR.

     mkdir -p ~/.irssi/scripts/autorun
     ln -s /usr/share/autodl-irssi/AutodlIrssi ~/.irssi/scripts
     ln -s /usr/share/autodl-irssi/autodl-irssi.pl ~/.irssi/scripts/autorun

install autodl-irssi rutorrent plugin
-------------------------------------

install rutorrent-autodl-irssi-svn package from AUR.

edit
/etc/webapps/rutorrent/conf/users/<user>/plugins/autodl-irssi/conf.php

     <?php
     
     $autodlPort = 12345;
     $autodlPassword = "password";
     
     ?>

Edit ~/.autodl/autodl.cfg

     [options]
     gui-server-port = 12345
     gui-server-password = password

See also
--------

-   https://code.google.com/p/rutorrent/wiki/PluginAutodlirssi

Retrieved from
"https://wiki.archlinux.org/index.php?title=Autodl-irssi&oldid=302625"

Categories:

-   Internet applications
-   Internet Relay Chat

-   This page was last modified on 1 March 2014, at 04:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
