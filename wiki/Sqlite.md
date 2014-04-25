Sqlite
======

  
 From the project home page:

SQLite is a software library that implements a self-contained,
serverless, zero-configuration, transactional SQL database engine.
SQLite is the most widely deployed SQL database engine in the world. The
source code for SQLite is in the public domain.

Contents
--------

-   1 Features
-   2 Installation
-   3 Using sqlite3 command line shell
    -   3.1 Create a database
    -   3.2 Create table
    -   3.3 Insert data
    -   3.4 Search database
-   4 Using sqlite in shell script
-   5 See also

Features
--------

From: SQLite Features

-   Transactions are atomic, consistent, isolated, and durable even
    after system crashes and power failures.
-   Zero-configuration - no setup or administration needed.
-   Implements most of SQL92.
-   A complete database is stored in a single cross-platform disk file.
-   Supports terabyte-sized databases and gigabyte-sized strings and
    blobs.
-   Small code footprint: less than 325KiB fully configured or less than
    190KiB with optional features omitted.
-   Faster than popular client/server database engines for most common
    operations.
-   Simple, easy to use API.
-   Written in ANSI-C. TCL bindings included. Bindings for dozens of
    other languages available separately.
-   Well-commented source code with 100% branch test coverage.
-   Available as a single ANSI-C source-code file that you can easily
    drop into another project.
-   Self-contained: no external dependencies.
-   Cross-platform: Unix (Linux and Mac OS X), OS/2, and Windows (Win32
    and WinCE) are supported out of the box. Easy to port to other
    systems.
-   Sources are in the public domain. Use for any purpose.
-   Comes with a standalone command-line interface (CLI) client that can
    be used to administer SQLite databases.

Installation
------------

Install sqlite from the official repositories.

Related packages are:

-   sqlite-doc - most of the static HTML files that comprise this
    website, including all of the SQL Syntax and the C/C++ interface
    specs and other miscellaneous documentation
-   php-sqlite - sqlite3 module for PHP (don't forget to enable it in
    /etc/php/php.ini)
-   gambas2-gb-db-sqlite3 - Gambas2 Sqlite3 database access component
-   sqliteman - The best developer's and/or admin's GUI tool for Sqlite3
    in the world

Using sqlite3 command line shell
--------------------------------

The SQLite library includes a simple command-line utility named sqlite3
that allows the user to manually enter and execute SQL commands against
an SQLite database.

Create a database

    sqlite3 databasename

Create table

    sqlite> create table tblone(one varchar(10), two smallint);

Insert data

    sqlite> insert into tblone values('helloworld',20);
    sqlite> insert into tblone values('archlinux', 30);

Search database

    sqlite> select * from tblone;
    helloworld|20
    rchlinux|30

See the sqlite docs.

Using sqlite in shell script
----------------------------

See forum post.

See also
--------

-   SQLite homepage
-   SQLite Hammer
-   Using SQLite - Oreilly Book
-   SQLite - Apress Book

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sqlite&oldid=304048"

Category:

-   Database management systems

-   This page was last modified on 11 March 2014, at 17:18.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
