Znc
===

ZNC is an advanced IRC bouncer that is left connected so an IRC client
can disconnect/reconnect without losing the chat session.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Webadmin Module
    -   2.2 Control Panel Module
-   3 See also

Installation
------------

1. Install znc from the Official repositories. The installation script
will create a group and user znc. The default home directory for this
user is /var/lib/znc.

Note: A bug in znc.install (znc 1.0-2) sets the znc user's home
directory as /var/empty. /var/lib/znc is still created and owned by the
correct user/group. You should change znc's home directory to
/var/lib/znc

2. Generate ZNC config as user znc.

    # su - znc
    $ znc --makeconf

Go through the wizard and setup your preferences.

Warning:Do not edit configuration files manually in a text editor while
ZNC is running. There is a very good chance you will lose your
configuration. Use the webadmin or controlpanel modules to change
settings on-the-fly. They are both included in the package.

3. To make ZNC start on boot:

    # systemctl enable znc

Start and stop the ZNC daemon as usual by running:

    # systemctl {start|stop|restart} znc

Configuration
-------------

Though you can choose to modify your configuration files manually, this
requires shutting down the server first. Do not edit configuration files
while ZNC is running.

> Webadmin Module

If you enabled the web admin module, you can access it at
http://yourhostname:znc port, the znc port number is the same as you
defined for connecting to the bouncer.

> Control Panel Module

If you enabled the control panel module, /msg *controlpanel help for a
list of settings while you are connected to the server.

See also
--------

-   ZNC's website

Retrieved from
"https://wiki.archlinux.org/index.php?title=Znc&oldid=301618"

Category:

-   Internet Relay Chat

-   This page was last modified on 24 February 2014, at 11:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
