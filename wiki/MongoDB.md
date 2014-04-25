MongoDB
=======

MongoDB (from humongous) is an open source document-oriented database
system developed and supported by MongoDB Inc. (formerly 10gen). It is
part of the NoSQL family of database systems. Instead of storing data in
tables as is done in a "classical" relational database, MongoDB stores
structured data as JSON-like documents with dynamic schemas (MongoDB
calls the format BSON), making the integration of data in certain types
of applications easier and faster.

Contents
--------

-   1 Installing MongoDB
-   2 Access the database shell
-   3 Troubleshooting
    -   3.1 MongoDB won't start

Installing MongoDB
------------------

Install mongodb

    # pacman -S mongodb

Start MongoDB

    # systemctl start mongodb

(Optional) Add MongoDB to the list of daemons that start on system
startup

    # systemctl enable mongodb

Access the database shell
-------------------------

To access the Database shell you have type in your terminal

    $ mongo

Troubleshooting
---------------

> MongoDB won't start

Check that there is at least 3GB space available for its journal files,
otherwise mongodb can fail to start (without issuing a message to the
user).

    $ df -h /var/lib/mongodb/

Check if the lock file exists

    # ls  -lisa /var/lib/mongodb

If it does, stop the mongodb service, and delete the file. Then start
the service again.

    # rm /var/lib/mongodb/mongod.lock

If it still won't start, run a repair on the database, specifying the
dbpath (/var/lib/mongodb/ is the default --dbpath in Arch Linux)

    # mongod --dbpath /var/lib/mongodb/ --repair

After running the repair as root, the files got chowned to root, whilst
Arch Linux runs it under a different user. You then need to chown back
the files. Further reference

    # cd /var/log/mongodb
    # sudo chown -R mongodb:mongodb .
    # cd /var/lib/mongodb
    # sudo chown -R mongodb:mongodb .

Check that the boost-libs package is up to date. MongoDB requires a
specific version, however, the package does not restrict the version of
this dependency.

Retrieved from
"https://wiki.archlinux.org/index.php?title=MongoDB&oldid=298782"

Category:

-   Database management systems

-   This page was last modified on 18 February 2014, at 16:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
