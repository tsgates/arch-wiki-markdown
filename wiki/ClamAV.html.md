ClamAV
======

Clam AntiVirus is an open source (GPL) anti-virus toolkit for UNIX. It
provides a number of utilities including a flexible and scalable
multi-threaded daemon, a command line scanner and advanced tool for
automatic database updates. Because ClamAV's main use is on file/mail
servers for Windows desktops it primarily detects Windows viruses and
malware.

Contents
--------

-   1 Installation
-   2 Starting the daemon
-   3 Updating database
-   4 Scan for viruses
-   5 Troubleshooting
    -   5.1 Error: Clamd was NOT notified
    -   5.2 Error: No supported database files found
    -   5.3 Error: Can't create temporary directory

Installation
------------

ClamAV can be installed with package clamav, available in the official
repositories.

  

Starting the daemon
-------------------

The service is called clamd.service. Read Daemons for more information
about starting it and enabling it to start at boot.

Updating database
-----------------

Update the virus definitions with:

    # freshclam

The database files are saved in:

    /var/lib/clamav/daily.cvd
    /var/lib/clamav/main.cvd

Scan for viruses
----------------

clamscan can be used to scan certain files, home directory, or an entire
system:

    $ clamscan myfile
    $ clamscan -r -i /home
    $ clamscan -r -i --exclude-dir='^/sys|^/proc|^/dev|^/lib|^/bin|^/sbin' /

If you would like clamscan to remove the infected file use the --remove
option in the command.

Using the -l path/to/file option will print the clamscan logs to a text
file for locating reported infections.

Troubleshooting
---------------

> Error: Clamd was NOT notified

If you get the following messages after running freshclam:

    WARNING: Clamd was NOT notified: Cannot connect to clamd through 
    /var/lib/clamav/clamd.sock connect(): No such file or directory

Add a sock file for ClamAV:

    # touch /var/lib/clamav/clamd.sock
    # chown clamav:clamav /var/lib/clamav/clamd.sock

Then, edit /etc/clamav/clamd.conf - uncomment this line:

    LocalSocket /var/lib/clamav/clamd.sock

Save the file and restart the daemon

> Error: No supported database files found

If you get the next error when starting the daemon:

    LibClamAV Error: cli_loaddb(): No supported database files found
    in /var/lib/clamav ERROR: Not supported data format

Generate the database as root:

    # freshclam -v

> Error: Can't create temporary directory

If you get the following error, along with a 'HINT' containing a UID and
a GID number:

    # can't create temporary directory

Correct permissions:

    # chown UID:GID /var/lib/clamav & chmod 755 /var/lib/clamav

Retrieved from
"https://wiki.archlinux.org/index.php?title=ClamAV&oldid=304307"

Category:

-   Security

-   This page was last modified on 13 March 2014, at 14:11.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
