Insync
======

Summary

This article discusses how to install, configure and use insync on your
system.

Related

Dropbox

Ubuntu One

insync is an alternative Google Drive client which is available for
Windows, Mac OS X and Linux. It is free and allows you to sync a local
folder with your Google Drive.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Running as a systemd service                                 |
|     -   2.2 Cinnamon                                                     |
|                                                                          |
| -   3 Usage                                                              |
+--------------------------------------------------------------------------+

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

You can run insync automatically from boot using the systenmd service.

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

Retrieved from
"https://wiki.archlinux.org/index.php?title=Insync&oldid=251916"

Category:

-   Internet Applications
