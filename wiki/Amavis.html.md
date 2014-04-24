Amavis
======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Amavis gives you an interface between mail servers (MTAs such as Postfix
or DoveCot) and mail filters (ClamAV, SpamAssassin). In many cases it is
more efficient than running separate daemons like spamd.

Contents
--------

-   1 Install & Setup
-   2 Postfix
-   3 SpamAssassin
-   4 ClamAV

Install & Setup
---------------

Install amavisd-new from the AUR. You'd be wise to also install
optdepends such as p7zip and unrar so your filters can actually see
inside compressed files.

If your hostname is not a FQDN, you must set $myhostname in
/etc/amavisd/amavisd.conf. You probably want to set $mydomain too.

After that, you can start the amavisd service with systemctl and
possibly enable it.

Some ways to check for errors:

    systemctl status amavisd
    journalctl -xbo short -u amavisd

Postfix
-------

Digest of the excellent upstream README.

SpamAssassin
------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: todo (Discuss)   
  ------------------------ ------------------------ ------------------------

ClamAV
------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: todo (Discuss)   
  ------------------------ ------------------------ ------------------------

Retrieved from
"https://wiki.archlinux.org/index.php?title=Amavis&oldid=288011"

Category:

-   Mail Server

-   This page was last modified on 15 December 2013, at 03:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
