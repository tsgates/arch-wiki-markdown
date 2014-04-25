GpsDrive
========

GpsDrive is a car (bike, ship, plane) navigation system. GpsDrive
displays your position provided from your GPS receiver on a zoomable
map. The maps are autoselected for best resolution depending of your
position and can be downloaded from the Internet. Speech output is
supported via the "speech dispatcher" software. All GPS receivers
supported by gpsd should be usable.

GpsDrive is written in C with use of the GTK+ toolkit under the GPL
license, and runs with Linux, Mac OSX, and FreeBSD.

GpsDrive 2.11 features OpenStreetMap/Mapnik vector/offline rendering
support, which is time-consuming to setup. This article describes
step-by-step how to setup PostgreSQL with PostGIS support, import an
OpenStreetMap database, and configure the GpsDrive<->Mapnik<->PostgreSQL
connection.

Contents
--------

-   1 Installing Packages
-   2 Installing PostgreSQL
    -   2.1 Starting from Scratch
-   3 Hardening PostgreSQL
-   4 Creating the PostgreSQL GIS user
-   5 Creating a PostGIS template database
-   6 Wrapping Up the PostgreSQL setup
-   7 Importing an OSM File into the PostgreSQL database
-   8 Testing the PostgreSQL connection with QuantumGIS
-   9 World Boundaries
-   10 Creating a customized osm.xml
-   11 Using GpsdDrive
-   12 Displaying OpenStreetMap POIs
-   13 Troubleshooting
    -   13.1 GpsDrive cannot find world boundaries
    -   13.2 Paths
-   14 Other Information
    -   14.1 Managing windows in XMonad
    -   14.2 Kismet Integration
    -   14.3 Optimizing PostgreSQL for OSM data
    -   14.4 Merging SQLite databases of waypoints schema
    -   14.5 Scripts packaged with GpsDrive
-   15 Links/References

Installing Packages
-------------------

Install the following packages and dependencies:

       sudo pacman -S gpsdrive mapnik openstreetmap-map-icons-svn

From AUR:

       osm2pgsql-svn osm2poidb-svn

The PostgreSQL installation/setup is described below.

Installing PostgreSQL
---------------------

First postgresql needs to be installed:

       sudo pacman -S postgresql

Upon startup, the /etc/rc.d/postgresql script will check for and create
the postgres user and group, and call the postgresql initdb process if
the "/var/lib/postgres/" directory does not exist. The initdb process,
among other things, checks the permissions on "/var/lib/postgres/",
initializes the template database encoding according to the current
user's locale, and sets a default authentication method.

Note: If the default database encoding was not set to UTF8 or needs to
be in a specific unicode encoding, see: PostgreSQL#Change Default
Encoding of New Databases To UTF-8 (Optional)

       sudo /etc/rc.d/postgresql start

To verify that the postgres user and group have been created and linked,
run:

       egrep -i postgres /etc/{passwd,group}
       groups postgres

(Optional) Add postgresql to the list of startup daemons in
/etc/rc.conf. Just keep in mind that postgresql locks a fixed amount of
memory.

> Starting from Scratch

If you want to remove the current database and start from scratch, stop
postgresql and archive "/var/lib/postgres/", perhaps as
"/var/lib/postgres-archive/". Calling "/etc/rc.d/postgresql start" will
create a pristine database. When you are confident that the new database
is up to par, "/var/lib/postgres-archive" can be deleted.

Hardening PostgreSQL
--------------------

For ease of installation postgresql uses the trust authentication
method, which will allow any user to connect without a password. Before
changing the default however, the postgres user (initial superuser) must
set a password to avoid becoming locked out.

       psql -U postgres
       ALTER USER postgres WITH ENCRYPTED PASSWORD '...';

This should create an md5-hashed password, prefixed with 'md5...'. To
verify:

       select * from pg_shadow;

Now the host-based authentication methods can be modified from
"/var/lib/postgres/data/pg_hba.conf". I recommend changing all the
"trust" entries to "md5". Alternatively the ident authentication method
can be used for local access. While the ident authentication method over
TCP/IP is only as trustworth as the local ident server (also, making a
local ident server publicly available is a security risk), using ident
with unix-domain sockets incurs no additional security risk, and
obviates the need to provide passwords. If using ident, change the
method of local access to "ident" and provide a unixuser -> postgres
user mapping in "/var/lib/postgres/data/pg_ident.conf". The only
drawback is lack of syntax to map a specific linux user to all postgres
databases.

After modifying any of the configuration files, postgresql needs to be
reloaded or restarted, either of:

       sudo su - postgres -c 'pg_ctl reload -D "/var/lib/postgres/data"'
       sudo /etc/rc.d/postgresql restart

When an object is created, it is assigned an owner; normally the role
(user) that created the object. Since by default only the owner (or a
superuser) can modify an object, there should be no need to modify
database roles and privileges in this article.

Creating the PostgreSQL GIS user
--------------------------------

It is now time to create the postgresql user that will access all the
GIS databases. A good default is:

       -S  The new user will not be a superuser
       -d  The new user will be allowed to create databases
           You'll most likely want to create other GIS databases
           This option is also necessary for the next several steps
       -R  The new user will not be allowed to create new roles
       -P  issue a prompt for the password of the new user

The password will be encrypted corresponding to
"/var/lib/postgres/data/pg_hba.conf". So (in the following example the
username is "gis"):

       createuser -S -d -R -P -U postgres gis

Creating a PostGIS template database
------------------------------------

GpsDrive and OpenStreetMap/Mapnik require postGIS-enabled postgres
database. Creating a PostGIS template avoids the need to PostGIS-enable
each and every OpenStreetMap database, and some ownership issues.

       createdb -E UTF8 template_postgis -U gis
       createlang -d template_postgis -U gis plpgsql
       psql -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';" -U postgres
       psql -d template_postgis -f "/usr/share/postgresql/contrib/postgis-2.0/postgis.sql" -U postgres
       psql -d template_postgis -f "/usr/share/postgresql/contrib/postgis-2.0/spatial_ref_sys.sql" -U postgres
       psql -d template_postgis -c "ALTER TABLE spatial_ref_sys OWNER TO gis;" -U postgres
       psql -d template_postgis -c "ALTER TABLE geometry_columns OWNER TO gis;" -U postgres
       psql -d template_postgis -c "ALTER VIEW geography_columns OWNER TO gis;" -U postgres
       psql -d template_postgis -c "VACUUM FREEZE" -U postgres

Wrapping Up the PostgreSQL setup
--------------------------------

Next instantiate the GIS database. Since GpsDrive and
OpenStreetMap/Mapnik can access different databases, it makes sense to
name the database after the region to be imported. For example,
"New_Mexico" or "Vienna" "Great_Britain"

       createdb -E UTF8 -T template_postgis -U gis "location"

Importing an OSM File into the PostgreSQL database
--------------------------------------------------

To download a snapshot of the entire OpenStreetMap database
(planet.osm), visit OpenStreetMap Planet.osm. The webpage also offers
extracts of the database mainly from Europe. For greater variety,
CloudMade Maps offers extracts from regions all around the globe. Once
the *.osm file has been downloaded, it needs to be imported into
PostgreSQL in order to be queried by Mapnik. The tool osm2pgsql
(currently from AUR) accomplishes this. First though, the working
directory needs to be setup:

       mkdir -p ~/gis/osm/
       cd ~/gis/osm
       wget ...
       osm2pgsql --database "location" --username "gis" --password --multi-geometry "file.osm"

Two important notes. First, osm2pgsql has two operating modes, full and
slim. Full uses RAM for intermediate storage, and therefore operates
relatively fast. Slim-mode, on the other hand, uses the PostgreSQL
database for storage of intermediate information. While this is slower,
often the *.osm databases contain too many nodes to be cached in RAM. If
this happens, osm2pgsql will abort with an error. 32-bit systems do not
address enough ram for a planet.osm import, much less a full Europe
import, and while 64-bit systems theoretically could have enough RAM, as
of 2010 32GB is not enough for Europe.osm. In any case, since slim-mode
offers additional features including incremental updates and proper
evaluation of mutipolygons, the osm2pgsql wiki recommends always
operating in slim-mode, even with small files.

Secondly, the information that osm2pgsql imports into the PostgreSQL
database is selected by the default.style file, usually located at
"/usr/share/osm2pgsql/default.style". Mapnik uses the osm.xml file to
extract information from the same database. If either of the two files
are out of sync, it is possible that mapnik will fail to fetch some
columns from the database, and thus fail to draw some layers. Since
osm2pgsql from AUR is currently packaged from SVN, and the following
steps build a customized osm.xml file also from SVN, this should not be
a problem. On the upside, to add more geographical features to the
database, simple edit the default.style file. For a full overview see
the OpenStreetMap osm2pgsql Wiki.

Testing the PostgreSQL connection with QuantumGIS
-------------------------------------------------

-   Fire up "/usr/bin/qgis".
-   Menu -> Layer -> Add PostGIS Layer...
    -   Create a LocalHost connection:
        -   Host: 127.0.0.1
        -   Database: "location"
        -   Port: 5432
        -   Username: gis
    -   Connect
    -   Select all four layers and add:
        -   planet_osm_line
        -   planet_osm_point
        -   planet_osm_polygon
        -   planet_osm_roads

Depending on the size of the database, the map could take a while to
draw. If the map has been satisfactorily drawn, then most likely the
osm2pgsql import was successful.

World Boundaries
----------------

The world boundaries from OpenStreetMap are not currently (2010) in the
database, but provided as external shapefiles. As of 2010 these files
consume ~1.2GB of disk-space post-extraction. After setting up the
working directory, these files need to be acquired:

       mkdir -p ~/"gis/osm/world_boundaries [$(date '+%Y-%m-%d')]"
       cd ~/"gis/osm/world_boundaries [$(date '+%Y-%m-%d')]"
       mkdir "world_boundaries"
       wget http://tile.openstreetmap.org/world_boundaries-spherical.tgz
       wget http://tile.openstreetmap.org/processed_p.tar.bz2
       wget http://tile.openstreetmap.org/shoreline_300.tar.bz2
       wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m-populated-places.zip
       wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m-admin-0-boundary-lines.zip
       tar xvzf world_boundaries-spherical.tgz
       tar xvjf processed_p.tar.bz2 -C world_boundaries
       tar xvjf shoreline_300.tar.bz2 -C world_boundaries
       unzip ne_10m-populated-places.zip -d world_boundaries
       unzip ne_110m-admin-0-boundary-lines.zip -d world_boundaries
       cd world_boundaries
       ln -s ne_110m_admin_0_boundary_lines_land.shp 110m_admin_0_boundary_lines_land.shp
       ln -s ne_110m_admin_0_boundary_lines_land.dbf 110m_admin_0_boundary_lines_land.dbf

Note:See
http://wiki.openstreetmap.org/wiki/Mapnik#Download_required_data for
more information

Creating a customized osm.xml
-----------------------------

The final step is to create the osm.xml file GpsDrive/Mapnik needs to
extract information from the PostgreSQL database. The latest Mapnik XML
scripts can be exported from SVN.

       cd ~/gis/osm/
       svn checkout http://svn.openstreetmap.org/applications/rendering/mapnik
       cd mapnik
       #./generate_xml.py -h
       # in the following, replace "$(date '+%Y-%m-%d')" with the correct date
       # also replace "location" in location_osm.xml with the correct location
       python2 generate_xml.py osm.xml location_osm.xml --symbols ./symbols/ --world_boundaries ~/"gis/osm/world_boundaries [$(date '+%Y-%m-%d')]/world_boundaries/" --host localhost --user "gis" --dbname "location" --port 5432 --password "..."

The generate_xml.py script combines the xml templates from "./inc/" and
"./osm.xml" with the symbols (images) from "./symbols/" to create a
customized non-template xml file. To update the template files and
scripts, simply run:

       cd ~/gis/osm/mapnik/
       svn update

The customized location_osm.xml file will not be modified during the
update process.

Using GpsdDrive
---------------

Gpsdrive requires an osm.xml file in ~/.gpsdrive/ in order to correctly
initialize mapnik. Simple copy over the location_osm.xml file generated
in the previous step:

       cp ~/gis/osm/mapnik/location_osm.xml ~/.gpsdrive/osm.xml

Afterwards start GpsDrive. Assuming everything went correctly, there
should be a "Mapnik Mode" checkbox in the "_Map Control" options box
(vertical menu, left hand side). Checking it enables OpenStreetMap
support with the Mapnik renderer. To speed up the display, GpsDrive
caches the the rendered Mapnik PNG images in
"~/.gpsdrive/map/mapnik_cache/".

To switch PostgreSQL PostGIS/OSM databases, simply generate new osm.xml
files and swap them out with "~/.gpsdrive/osm.xml".

Displaying OpenStreetMap POIs
-----------------------------

GpsDrive does not read POI (Point of Interest) information from the
PostGIS Mapnik database. Instead it uses a custom SQLite database
derived by cross-referencing the geoinfo.db file from the OSM map-icons
set with an OSM xml map file. By default GpsDrive expects to find this
SQLite database at /usr/share/gpsdrive/osm.db, but this can be easily
changed in ~/.gpsdrive/gpsdriverc. Edit away:

       osmdbfile = /full/path/to/~/.gpsdrive/osm.db

To create ~/.gpsdrive/osm.db from an *.osm xml map file, use osm2poidb.
One limitation is that osm2poidb is unable to update existing SQLite
databases for additional *.osm xml map files:

       cd ~/.gpsdrive/
       osm2poidb --db-file /usr/share/icons/map-icons/geoinfo.db --osm-file location_osm.db ~/gis/osm/location.osm
       ln -s location_osm.db osm.db

GpsDrive should now report
"DB: Using waypoints from OpenStreetMap database." and display an extra
"OSM DB" checkbox under the "Points" information box (vertical menu,
left hand side). The "Find" capability of GpsDrive should also now be
operational.

Troubleshooting
---------------

> GpsDrive cannot find world boundaries

       Missing '/usr/share/mapnik/world_boundaries' please install mapnik world boundaries, if error occurs!

For some strange reason, GpsDrive does not send mapnik the
world_boundaries directory specified in ~/.gpsdrive/osm.xml, but a
standardized directory of "/usr/share/mapnik/world_boundaries/". Until
this is fixed, a quick workaround using symlinks:

       # in the following, replace "$(date '+%Y-%m-%d')" with the correct date
       sudo ln -s ~/"gis/osm/world_boundaries [$(date '+%Y-%m-%d')]/world_boundaries/" /usr/lib/mapnik/world_boundaries
       sudo ln -s /usr/lib/mapnik/ /usr/share/mapnik

> Paths

You may want to add

     geoinfofile = /usr/share/icons/map-icons/geoinfo.db
     mapnik_font_path = /usr/share/fonts/TTF

into ~/.gpsdrive/gpsdriverc

Other Information
-----------------

> Managing windows in XMonad

The following ManageHook setup requires the XMonad.Hooks.ManageHelpers
module in addition to XMonad.ManageHook

       , className =? "Gpsdrive"       <&&>
           fmap (not . isInfixOf "GpsDrive") title             -?> doFloat

> Kismet Integration

src/gpskismet.c was just ported (July 2010) to the newcore kismet
protocol, see the GpsDrive mailing list, subject "Kismet Integration".

> Optimizing PostgreSQL for OSM data

> Merging SQLite databases of waypoints schema

> Scripts packaged with GpsDrive

  Script                               Details                                                                                              Status
  ------------------------------------ ---------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------
  geoinfo.pl                           Retrieves POI data from different sources and imports them into a mySQL database.                    (Deprecated) GpsDrive now uses an SQLite database located at ~/.gpsdrive/waypoints.db instead of MySQL to manage user points.
  gpsdrive-update-mapnik-poitypes.pl   Stores GpsDrive-compatible POI information inside the 'poi' column of the PostGIS/Mapnik database.   (Deprecated) GpsDrive now uses an SQLite database located at /usr/share/gpsdrive/osm.db to store OpenStreetMap POI data.

Links/References
----------------

  -------------------------------------------------------------------------- ---------------------------------
  http://sourceforge.net/apps/mediawiki/gpsdrive/index.php                   GpsDrive Wiki
  http://downloads.cloudmade.com                                             OSM Extraction Service
  http://wiki.openstreetmap.org/wiki/Planet.osm                              Planet.osm
  http://wiki.openstreetmap.org/wiki/Mapnik                                  OSM Mapnik Directions
  http://wiki.openstreetmap.org/wiki/Mapnik/PostGIS                          OSM Mapnik/PostGIS Directions
  http://wiki.openstreetmap.org/wiki/Map_Icons                               OSM Map Icon Information
  http://wiki.openstreetmap.org/wiki/Osm2pgsql                               OSM osm2pgsql Page
  https://wiki.archlinux.org/index.php/PostgreSQL                            Archwiki PostgreSQL Page
  http://www.postgresql.org/docs/current/static/auth-methods.html            PostgreSQL Auth Methods
  http://www.davidpashley.com/articles/postgresql-user-administration.html   PostgreSQL User Administration
  file:///usr/share/doc/postgresql/html/xplang-install.html                  PostgreSQL Installing Languages
  -------------------------------------------------------------------------- ---------------------------------

Retrieved from
"https://wiki.archlinux.org/index.php?title=GpsDrive&oldid=304849"

Category:

-   Other hardware

-   This page was last modified on 16 March 2014, at 08:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
