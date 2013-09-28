Noip
====

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Need to fix style 
                           according to Help:Style  
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

noip is a dynamic DNS client updater for no-ip.com services.

Installation
------------

    # pacman -S noip

Configuration
-------------

To configure de No-IP DUC you have to execute the noip2 executable with
-C option (create the configuration file step by step), or if you want
to select all hosts in your account to be updated add the -Y option.

    # noip2 -C

To see more options off the No-IP DUC use:

    # noip2 -h

To start the service
--------------------

Start the service with

    # systemctl start noip2

To start automatically at boot simply do:

    # systemctl enable noip2

Retrieved from
"https://wiki.archlinux.org/index.php?title=Noip&oldid=255110"

Category:

-   Domain Name System
