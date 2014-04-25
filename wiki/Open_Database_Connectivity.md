Open Database Connectivity
==========================

An ODBC engine needs drivers to be able to interact with databases.

Contents
--------

-   1 ODBC engines
    -   1.1 unixODBC
        -   1.1.1 Installation
        -   1.1.2 Configuration
    -   1.2 iODBC
-   2 Drivers
    -   2.1 FreeTDS
        -   2.1.1 Installation
        -   2.1.2 Configuration
-   3 Databases
    -   3.1 Microsoft SQL Server 2000

ODBC engines
------------

You have two options to chose from. Apparently unixODBC is more widely
supported.

> unixODBC

Installation

    # pacman -S unixodbc

Configuration

At /etc/odbcinst.ini is where drivers are declared, and /etc/odbc.ini
where connections. More instruction at each driver section.

> iODBC

...

Drivers
-------

> FreeTDS

FreeTDS is a set of libraries for Unix and Linux that allows your
programs to natively talk to Microsoft SQL Server and Sybase databases.
Technically speaking, FreeTDS is an open source implementation of the
TDS (Tabular Data Stream) protocol used by these databases for their own
clients.

Installation

    pacman -S freetds

Configuration

/etc/odbcinst.ini

    [FreeTDS]
    Driver          = /usr/lib/libtdsodbc.so 
    UsageCount      = 1 

Databases
---------

> Microsoft SQL Server 2000

/etc/odbc.ini

    [server_name]
    Driver      = FreeTDS
    #Trace       = Yes
    #TraceFile   = /tmp/odbc
    Servername  = server_name
    Database    = database_name

/etc/freetds/freetds.conf

    [server_name]
    host = 192.168.0.2 # Host name or IP address.
    port = 1433 # Default port.
    tds version = 7.1
    client charset = UTF-8

Retrieved from
"https://wiki.archlinux.org/index.php?title=Open_Database_Connectivity&oldid=246888"

Category:

-   Database management systems

-   This page was last modified on 9 February 2013, at 09:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
