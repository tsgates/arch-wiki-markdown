PostGIS
=======

PostGIS adds support for geographic objects in the PostgreSQL database.
This document describes the process for installing PostGIS and creating
a template PostGIS database. It is assumed that PostgreSQL has been
installed. If it hasn't, please refer to the PostgreSQL page.

Contents
--------

-   1 Installing PostGIS
-   2 Installing PostGIS Extension
-   3 Creating a Template PostGIS Database
-   4 Creating a PostGIS Database From the Template
-   5 More Resources
-   6 PostGIS failing with json_tokener_error

Installing PostGIS
------------------

-   Install PostGIS.

    $ su
    # pacman -S postgis

Installing PostGIS Extension
----------------------------

Since [[PostgreSQL 9.1][1]], the preferred approach is to install
PostGIS and enable postgis extension for each spatial database.

    $ psql

    -- verify available extensions
    SELECT name, default_version,installed_version 
    FROM pg_available_extensions WHERE name LIKE 'postgis%' ;

    -- install extension for spatial database mygisdb
    \c mygisdb
    CREATE EXTENSION postgis;
    CREATE EXTENSION postgis_topology;
    CREATE EXTENSION fuzzystrmatch;
    CREATE EXTENSION postgis_tiger_geocoder;

You don't need to do the below "Creating a Template PostGIS Database"
step if you use PostGIS extension.

-   upgrade postgis extension

    $ psql

    ALTER EXTENSION postgis UPDATE TO "2.1.0";

-   migrate spatial database created with postgis_template

Dump and drop the spatial database, re-create a spatial database with
extension, and restore the dumped database. Follow
http://www.postgis.org/docs/postgis_installation.html#hard_upgrade for
specific commands.

Creating a Template PostGIS Database
------------------------------------

-   Become the postgres user.

    $ su
    # su - postgres

-   If you haven't created a superuser for accessing PostgreSQL, you may
    want do that now. You will be prompted for granting permissions to
    that user.

    $ createuser [username]

-   Create a new database called "template_postgis".

    $ createdb -O [username] template_postgis -E UTF-8

-   PostGIS requires the pl/pgSQL language to be installed on a
    database.

    $ createlang plpgsql template_postgis

-   Load the PostGIS spatial types for PostgreSQL and spatial reference
    systems. "postgis.sql" and "spatial_ref_sys.sql" are part of the
    installation of PostGIS, and may reside somewhere else besides
    "/usr/sharepostgresql/contrib/postgis-1.5/" depending on the
    installation. (Below is for default postgis 1.5 installation)

    $ psql -d template_postgis -f /usr/share/postgresql/contrib/postgis-2.0/postgis.sql
    $ psql -d template_postgis -f /usr/share/postgresql/contrib/postgis-2.0/spatial_ref_sys.sql

-   Make it a real template.

    $ psql

    UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis';

Creating a PostGIS Database From the Template
---------------------------------------------

-   It's common practice to reserve a bare template for creating new
    PostGIS databases. As a PostgreSQL superuser, the following command
    will create a new database:

    $ createdb -T template_postgis [new_postgis_db]

More Resources
--------------

For additional resources concerning PostGIS, check out the PostGIS
Documentation.

PostGIS failing with json_tokener_error
---------------------------------------

This happends when adding postgis as an extension. The libjson-c package
has changed, and PostGIS hasn't put out a stable release with this yet.
Its in 2.1.0rc1, though. The bug-report is
http://trac.osgeo.org/postgis/ticket/2213

The fix is to download the postgis PKGBUILD and then change the version
to '2.1.0rc1'. Don't forget to change the sha256sum.

Retrieved from
"https://wiki.archlinux.org/index.php?title=PostGIS&oldid=296398"

Category:

-   Database management systems

-   This page was last modified on 6 February 2014, at 17:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
