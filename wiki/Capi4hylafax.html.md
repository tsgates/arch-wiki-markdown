Capi4hylafax
============

  

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

> Installation

    pacman -S capi4hylafax

> Setup:

-   Please run 'faxsetup' as root user to adjust hylafax to your needs.
-   Don't even try to run faxaddmodem for capi20 devices!!!
-   c2faxaddmodem' is a nice tool for configuring your isdn card.
-   var/spool/hylafax/etc/config/config.faxCAPI to your needs, if you
    need more.
-   Please add 'hylafax' and 'capi4hylafax' to your daemons list in
    /etc/rc.conf.
-   Please be sure that your device has the right permissions 'uucp',
    udev users please
-   restart udev after installation.

-   Add the following two lines to /var/spool/hylafax/etc/config:

       SendFaxCmd: /usr/bin/c2faxsend

> Notes:

-   to save your config, please do not forget to add to /etc/pacman.conf

     NoUpgrade   = var/spool/hylafax/etc/config/config.faxCAPI

-   If you need more than one isdn controller please read the manual of
    capi4hylafax.

For comments about the package please use this thread:
https://bbs.archlinux.org/viewtopic.php?t=11089

For Hints and Tips please have a look at Hylafax wiki.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Capi4hylafax&oldid=238505"

Category:

-   Modems

-   This page was last modified on 5 December 2012, at 07:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
