Insync
======

Related articles

-   Dropbox
-   Ubuntu One

insync is an alternative Google Drive client which is available for
Windows, Mac OS X and Linux which allows you to sync a local folder or
symlinked folders with your Google Drive. Whilst previous Beta versions
used to be for free, the final release features a trial period after
which a one-time payment per Google account is required.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Running as a systemd service
    -   2.2 Cinnamon
-   3 Usage
-   4 Troubleshooting
    -   4.1 Slow sync process

Installation
------------

Install insync, available in the AUR. It contains the synchronization
daemon, a systemd service file and a command line utility for
configuration. It can be used and integrates nicely with different
desktop environments such as KDE, Gnome or Cinnamon.

Configuration
-------------

When you start insync for the first time it is recommended to run it
from the command line to set the path to your local folder which you
would like to sync with your Google Drive.

    $ insync --set-files-path=/your/local/folder

After having done that once you can start insync normally. A shortcut
should be available in the start menu of your desktop environment.

> Running as a systemd service

You can run insync automatically from boot using the systemd service.

     # systemctl enable insync@<user>

> Cinnamon

When you start insync from the start menu it may not appear in the task
bar. For that you need to add the task bar applet by right-click on your
panel.

Usage
-----

The usage is self-explanatory. Copy files and folders from and to your
local folder to sync it with your Google Drive. In future release it is
planned to support selective sync of files and folders.

Troubleshooting
---------------

> Slow sync process

The default systemd service file provided in insync uses the
--synchronous-full flag to make sqlite transactions safer and prevent
database corruption. However, for some users this might considerably
slow down the sync process. If you do not need full synchronisation,
create /etc/systemd/system/insync@.service to override the provided
service file and modify the ExecStart variable:

    /etc/systemd/system/insync@.service

    .include /usr/lib/systemd/system/insync@.service
    [Service]
    ExecStart=/usr/bin/insync start

Retrieved from
"https://wiki.archlinux.org/index.php?title=Insync&oldid=302641"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
