ClamAV
======

Clam AntiVirus is an open source (GPL) anti-virus toolkit for UNIX. It
provides a number of utilities including a flexible and scalable
multi-threaded daemon, a command line scanner and advanced tool for
automatic database updates. Because ClamAV's main use is on file/mail
servers for Windows desktops it primarily detects Windows viruses and
malware.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Starting the daemon                                                |
| -   4 Updating database                                                  |
| -   5 Scan for Viruses                                                   |
| -   6 Troubleshooting                                                    |
|     -   6.1 Error: Clamd was NOT notified                                |
|     -   6.2 Error: No supported database files found                     |
|     -   6.3 Error: Can't create temporary directory                      |
+--------------------------------------------------------------------------+

Installation
------------

ClamAV can be installed with package clamav, available in the Official
Repositories.

Configuration
-------------

Whether you are going to use clamav as a daemon or use it as a simple
file checker you need to comment out the line that contains the word
Example, usually it is found at the beginning of
/etc/clamav/freshclam.conf and /etc/clamav/clamd.conf files.

Starting the daemon
-------------------

The service is called clamd.service. Read Daemons for more information
about starting it and enabling it to start at boot.

Also change the start options from "no" to "yes":

    /etc/conf.d/clamav

    # change these to "yes" to start
    START_FRESHCLAM="yes"
    START_CLAMD="yes"

Updating database
-----------------

Edit the below file and comment out the line saying "Example"

    /etc/clamav/freshclam.conf

    # Comment or remove the line below.
    # Example

Update the virus definitions with:

    # freshclam

The database files are saved in:

    /var/lib/clamav/daily.cvd
    /var/lib/clamav/main.cvd

Scan for Viruses
----------------

clamscan can be used to scan certain files, home directory, or an entire
system:

    $ clamscan myfile
    $ clamscan -r -i /home
    $ clamscan -r -i --exclude-dir=^/sys\|^/proc\|^/dev /

If you would like clamscan to remove the infected file use the --remove
option in the command.

Using the -l <path to file> option will print the clamscan logs to a
text file for locating reported infections.

Troubleshooting
---------------

> Error: Clamd was NOT notified

If you get the following messages after running freshclam:

    WARNING: Clamd was NOT notified: Cannot connect to clamd through 
    /var/lib/clamav/clamd.sock connect(): No such file or directory

Add a sock file for clamav:

    # touch /var/lib/clamav/clamd.sock
    # chown clamav:clamav /var/lib/clamav/clamd.sock

Then, edit /etc/clamav/clamd.conf – uncomment this line:

    LocalSocket /var/lib/clamav/clamd.sock

Save the file and restart the daemon

> Error: No supported database files found

If you get the next error when starting the daemon:

    LibClamAV Error: cli_loaddb(): No supported database files found
    in /var/lib/clamav ERROR: Not supported data format

Run freshclam as root:

    # freshclam -v

> Error: Can't create temporary directory

If you get the following error, along with a 'HINT' containing a UID and
a GID number:

    # can't create temporary directory

Do the following:

    # chown UID:GID /var/lib/clamav & chmod 755 /var/lib/clamav

Retrieved from
"https://wiki.archlinux.org/index.php?title=ClamAV&oldid=249980"

Category:

-   Security
