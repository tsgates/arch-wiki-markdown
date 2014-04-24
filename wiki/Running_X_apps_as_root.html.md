Running X apps as root
======================

By default, and for security reasons, root will be unable to connect to
a non-root user's X server. There are multiple ways of allowing root to
do so, if it is necessary.

The most secure methods
-----------------------

The most secure methods are simple. They include:

-   kdesu (included with KDE)

    $ kdesu name-of-app

-   gksu (included with GNOME)

    $ gksu name-of-app

-   bashrun (in community)

    $ bashrun --su name-of-app

-   sudo (must be installed and properly configured with visudo)

    $ sudo name-of-app

-   sux (wrapper around su which will transfer your X credentials)

    $ sux root name-of-app

These are the preferred methods, because they automatically exit when
the application exits, negating any security risks quite completely.

Alternate methods
-----------------

These methods will allow root to connect to a non-root user's X server,
but present varying levels of security risks, especially if you run ssh.
If you are behind a firewall, you may consider them to be safe enough
for your requirements.

-   Temporarily allow root access

-   xhost

    $ xhost +

will temporarily allow root, or anyone to connect your X server.
Likewise,

    $ xhost -

will disallow this function afterward.

Some users also use:

    $ xhost + localhost

(Your X server must be configured to listen to TCP connections for
xhost + localhost to work).

-   Permanently allow root access

Method 1: Add the line

session         optional        pam_xauth.so

to  /etc/pam.d/su  and /etc/pam.d/su-l. Then switch to your root user
using 'su' or 'su -'.

Method 2: Globally in /etc/profile

Add the following to /etc/profile

    export XAUTHORITY=/home/non-root-usersname/.Xauthority

This will permanently allow root to connect to a non-root user's X
server.

Or, merely specify a particular app:

    export XAUTHORITY=/home/usersname/.Xauthority kwrite

(to allow root to access kwrite, for instance.)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Running_X_apps_as_root&oldid=295296"

Category:

-   X Server

-   This page was last modified on 1 February 2014, at 09:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
