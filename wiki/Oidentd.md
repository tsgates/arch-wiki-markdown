Oidentd
=======

oidentd is an ident (rfc1413 compliant) daemon that runs on Linux,
Darwin, FreeBSD, OpenBSD, NetBSD and Solaris. oidentd can handle IP
masqueraded/NAT connections on Linux, Darwin, FreeBSD (ipf only),
OpenBSD and NetBSD. oidentd has a flexible mechanism for specifying
ident responses. Users can be granted permission to specify their own
ident responses. Responses can be specified according to host and port
pairs.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Global configuration                                         |
|     -   2.2 User configuration                                           |
|                                                                          |
| -   3 Starting oidentd                                                   |
+--------------------------------------------------------------------------+

Installation
------------

Install oidentd, available in the Official Repositories。

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

-   /etc/rc.d/oidentd start

If you want to have oidentd start up automatically every time you start
your computer, then you need to add oidentd to your DAEMONS=() array in
/etc/rc.conf. For example:

    DAEMONS=(pcmcia syslogd klogd !fam esd mono network autofs cupsd oidentd crond gdm)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Oidentd&oldid=240526"

Category:

-   Networking
