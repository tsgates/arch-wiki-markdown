PostGIS
=======

PostGIS adds support for geographic objects in the PostgreSQL database.
This document describes the process for installing PostGIS and creating
a template PostGIS database. It is assumed that PostgreSQL has been
installed. If it hasn't, please refer to the PostgreSQL page.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing PostGIS                                                 |
| -   2 Creating a Template PostGIS Database                               |
| -   3 Creating a PostGIS Database From the Template                      |
| -   4 More Resources                                                     |
+--------------------------------------------------------------------------+

Installing PostGIS
------------------

-   Install PostGIS.

    $ su
    $ pacman -S postgis

Creating a Template PostGIS Database
------------------------------------

-   Become the postgres user.

    $ su
    $ su - postgres

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

Retrieved from
"https://wiki.archlinux.org/index.php?title=PostGIS&oldid=224941"

Category:

-   Database management systems
