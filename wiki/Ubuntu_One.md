Ubuntu One
==========

Summary

This article discusses how to install, configure and use Ubuntu One on
your system.

Related

Dropbox

Ubuntu One is a service to store and sync files online and between
computers, and share files and folders with others using file
synchronization. Brief description here.

If you know what Dropbox is then you could say that Ubuntu One is an
alternative to Dropbox.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 GUI                                                          |
|     -   2.2 Command line                                                 |
|                                                                          |
| -   3 Usage                                                              |
|     -   3.1 Nautilus                                                     |
|     -   3.2 Déjà Dup                                                     |
+--------------------------------------------------------------------------+

Installation
------------

Install ubuntuone-client, available in the official repositories. It
contains the synchronization daemon and a command line utility for
configuration.

Additional packages are recommended for better desktop integration:

-   ubuntuone-control-panel is the configuration GUI for Ubuntu One: you
    could register or log in, and manage shared folders and devices.
-   ubuntuone-client-gnome is the GNOME integration pack: it contains a
    Nautilus extension and provides notifications if your Ubuntu One
    account runs out of space.

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

> Nautilus

If ubuntuone-client-gnome installed, Nautilus file manager allows the
option of sharing files or directories by right-clicking the
file/directory and selecting the appropriate option.

> Déjà Dup

You can use Déjà Dup (deja-dup) to make (incremental) backups to your
Ubuntu One storage.

Use Déjà Dup (Applications -> Backup) to configure the backup by:
selecting "Storage" -> "Backup location" -> "Ubuntu One" and enter a
"Folder" (default: deja-dup/hostname).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ubuntu_One&oldid=254406"

Category:

-   Internet Applications
