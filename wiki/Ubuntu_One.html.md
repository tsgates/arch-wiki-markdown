Ubuntu One
==========

Related articles

-   Dropbox

Ubuntu One is a service to store and sync files online and between
computers, and share files and folders with others using file
synchronization. Brief description here.

If you know what Dropbox is then you could say that Ubuntu One is an
alternative to Dropbox.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 GUI
    -   2.2 Command line
-   3 Usage
    -   3.1 Status icon
    -   3.2 Déjà Dup

Installation
------------

Install ubuntuone-control-panel, available in the official repositories.
It's a GUI application to configure and monitor Ubuntu One. It pulls in
the ubuntuone-client package, which contains the synchronization daemon
and a command line utility for configuration.

Configuration
-------------

> GUI

Simply launch Ubuntu One application (or run
ubuntuone-control-panel-qt), log in with your account (or register a new
one) and enjoy! On first login, an "Ubuntu One" folder will be
automatically created in your home directory. After that Ubuntu One's
daemon will autostart when you log in to your desktop, and sync files
continuously.

> Command line

Alternatively, you could use the command-line tool called u1sdtool to
configure Ubuntu One. Even though it's a command line tool, it requires
a running X.Org, otherwise it fails to run.

To connect the syncdaemon, run:

    $ u1sdtool -c

On the first login, you have to enter your account details or create a
new account.

For other command line options, check:

    $ u1sdtool -h

Usage
-----

There should be a directory named "Ubuntu One" in your home directory,
everything you put there should be synced with Ubuntu One's cloud.

> Status icon

You can launch the control panel in status icon mode with the following
command:

    $ ubuntuone-control-panel-qt --minimized

> Déjà Dup

You can use Déjà Dup (deja-dup) to make (incremental) backups to your
Ubuntu One storage.

Use Déjà Dup (Applications -> Backup) to configure the backup by:
selecting "Storage" -> "Backup location" -> "Ubuntu One" and enter a
"Folder" (default: deja-dup/hostname).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ubuntu_One&oldid=302671"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
