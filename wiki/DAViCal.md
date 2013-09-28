DAViCal
=======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

DAViCal is a server implementing the CalDAV and CardDAV protocol. It's
solely a server, with minimal direct user interaction, instead relying
on using CalDav clients, such as Apple's iCal.app, iOS (iPhone, iPad,
iPod), Thunderbird with Sunbird, or Evolution.

Installation
------------

> Installing pre-requisites

DAViCal is written in PHP and uses the PostgreSQL database as it's
backend to store the calendar information. Currently it only supports
PostgreSQL, but there is work to support other databases as well.

It is available in the AUR: davical.

Install PHP and PostgreSQL, along with the PHP bindings for PostgreSQL,
with pacman:

    # pacman -S postgresql php php-pgsql

DAViCal is a web application, and therefore you need a web server set up
as well. For this page, Nginx will be assumed, but DAViCal can run on
nearly any web server. (Some may stop processing requests when they see
the CalDAV HTTP headers, and therefore DAViCal will not be able to see
them.)

> Preparing PostgreSQL

First of all, you should set up PostgreSQL so it can start up by
following this guide.

DAViCal requires two independent accounts to be set up, one for
accessing the database from the web application, which will be limited
in power, and another that will be used for administrating the DAViCal
related tables.

In order to do so, you will need to edit
/var/lib/postgres/data/pg_hba.conf

Add the following lines:

       local   davical         davical_app                             trust
       local   davical         davical_dba                             trust

Make sure that you have a 'root' role in your database. If you don't,
create it by becoming the postgres user as described on PostgreSQL page
and execute the following:

    $ createuser -s -U postgres --interactive
    $ Enter name of role to add: root

Prepare database by running create-database.sh script as root:

    # /srv/http/davical/dba/create-database.sh

Then run createdb as root:

    # createdb

Retrieved from
"https://wiki.archlinux.org/index.php?title=DAViCal&oldid=251385"

Category:

-   Networking
