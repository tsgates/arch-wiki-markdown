AgenDAV
=======

From [1]: "AgenDAV is an open source multilanguage CalDAV web client
which features a rich AJAX interface with shared calendars support".

Installation
------------

Install the AgenDAV package agendav (AUR).

> Database

You must provide a SQL database to AgenDAV. Here is a PostgreSQL
example.

Install PostgreSQL according to the article. Create a agendav user and
database:

    # createuser agendav
    # createdb -O agendav agendav

> Configuration

When the database is setup, you must manually populate it:

    # psql -U agendav agendav < /usr/share/webapps/agendav/sql/pgsql.schema.sql
    # bash /usr/share/webapps/agendav/bin/agendavcli dbupdate

Make sure you enable the pgsql.so (or whatever database you used) and
iconv.so extension in php.ini.

Edit the configuration files
/etc/webapps/agendav/{config,caldav,database}.php to your liking.

Serve the app via apache /etc/webapps/agendav/apache.example.conf,
nginx/php-fpm /etc/webapps/agendav/nginx.example.conf or some other
webserver.

Retrieved from
"https://wiki.archlinux.org/index.php?title=AgenDAV&oldid=302621"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
