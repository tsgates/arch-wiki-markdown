Oidentd
=======

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

oidentd is an ident (rfc1413 compliant) daemon that runs on Linux,
Darwin, FreeBSD, OpenBSD, NetBSD and Solaris. oidentd can handle IP
masqueraded/NAT connections on Linux, Darwin, FreeBSD (ipf only),
OpenBSD and NetBSD. oidentd has a flexible mechanism for specifying
ident responses. Users can be granted permission to specify their own
ident responses. Responses can be specified according to host and port
pairs.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Global configuration
    -   2.2 User configuration
-   3 Starting oidentd

Installation
------------

Install oidentd, available in the Official repositories。

Configuration
-------------

With no global nor user configuration file(s), the users' ident replies
will be that of their login name. This makes configuration files
optional. See the oidentd.conf manual for more detail.

> Global configuration

You may create the global configuration file /etc/oidentd.conf.

According to the manual, the following is suitable for a global
configuration.

    default {
         default {
              deny spoof
              deny spoof_all
              deny spoof_privport
              allow random
              allow random_numeric
              allow numeric
              allow hide
         }
    }
    user root {
         default {
              force reply "UNKNOWN"
         }
    }

Which says, "Grant all users the ability to generate random numeric
ident replies, the ability to generate numeric ident replies, and the
ability to hide their identities on all ident queries. Explicitly deny
the ability to spoof ident responses. And reply with `UNKNOWN' for all
successful ident queries for root."

> User configuration

Additionally and/or alternatively, each user may create his own local
configuration file, $HOME/.oidentd.conf.

A possible example follows.

    global { reply "unknown" }
    to irc.example.org { reply "example" }

Which says, "Reply with `unknown' to all successful ident lookups, but
reply with `example' to ident lookups for connections to
irc.example.org."

The global configuration file will dictate what works in the user's
local configuration file.

Starting oidentd
================

With oidentd installed and configured, you are now ready to start the
daemon.

    systemctl start oidentd.socket

If you want to have oidentd start up automatically every time you start
your computer, then you need to enable oidentd.socket with systemd. For
example:

    systemctl enable oidentd.socket

Retrieved from
"https://wiki.archlinux.org/index.php?title=Oidentd&oldid=301530"

Category:

-   Networking

-   This page was last modified on 24 February 2014, at 11:50.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
