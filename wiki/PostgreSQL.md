PostgreSQL
==========

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: excessive use of 
                           lists, please use them   
                           only when there are      
                           items to list. (Discuss) 
  ------------------------ ------------------------ ------------------------

PostgreSQL is an open source, community driven, standard compliant
object-relational database system.

This document describes how to set up PostgreSQL. It also describes how
to configure PostgreSQL to be accessible from a remote client. If you
need help setting up the rest of a web stack, see the LAMP page and
follow all of the sections except the one related to MySQL.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Before you start                                                   |
| -   2 Installing PostgreSQL                                              |
| -   3 Creating Your First Database/User                                  |
| -   4 Familiarizing Yourself with PostgreSQL                             |
|     -   4.1 Access the database shell                                    |
|                                                                          |
| -   5 Configure PostgreSQL to be accessible from remote hosts            |
| -   6 Configure PostgreSQL to Work With PHP                              |
| -   7 Change Default Data Dir (Optional)                                 |
| -   8 Change Default Encoding of New Databases To UTF-8 (Optional)       |
| -   9 Installing phpPgAdmin (optional)                                   |
| -   10 Installing pgAdmin (optional)                                     |
| -   11 Upgrading PostgreSQL                                              |
|     -   11.1 Quick Guide                                                 |
|     -   11.2 Detailed Instructions                                       |
|                                                                          |
| -   12 Troubleshooting                                                   |
|     -   12.1 Improve performance of small transactions                   |
|     -   12.2 Prevent disk writes when idle                               |
|                                                                          |
| -   13 See also                                                          |
+--------------------------------------------------------------------------+

Before you start
----------------

Several sections have instructions stating "become the postgres user".
If sudo is installed, execute the following to get a shell as the
postgres user:

    sudo -i -u postgres

Otherwise su can be used:

    su root
    su - postgres

Installing PostgreSQL
---------------------

Install postgresql

Create the file tmpfiles.d for /run/postgresql:

    # systemd-tmpfiles --create postgresql.conf

Create the data directory (acordingly with the PGROOT variable set
before in the config file)

    # mkdir /var/lib/postgres/data

Set /var/lib/postgres ownership to user 'postgres'

    # chown -c -R postgres:postgres /var/lib/postgres

As user 'postgres' start the database (see first paragraph of this
document for instructions on how to become a postgres user):

    $ su - postgres
    $ initdb -D '/var/lib/postgres/data'

Start PostgreSQL

    # systemctl start postgresql

(Optional) Add PostgreSQL to the list of daemons that start on system
startup

    # systemctl enable postgresql

Creating Your First Database/User
---------------------------------

Become the postgres user. Add a new database-user using the createuser
command.

If you create a user as per your login user ($USER) it allows you to
access the postgresql database shell without having to specify a user to
login (which makes it quite convenient).

e.g. to create a superuser

    $ createuser -s -U postgres --interactive

    Enter name of role to add: myUsualArchLoginName

Create a new database over which the above user has read/write
privileges using the createdb command.

From your login shell (not the postrgres user's)

    $ createdb myDatabaseName

Familiarizing Yourself with PostgreSQL
--------------------------------------

> Access the database shell

Become the postgres user. Start the primary db shell, psql, where you
can do all your creation of databases/tables, deletion, set permissions,
and run raw SQL commands. Use the "-d" option to connect to the database
you created (without specifying a database, psql will try to access a
database that matches your username)

    $ psql -d myDatabaseName

Some helpful commands:

Connect to a particular database

    => \c <database>

List all users and their permission levels

    => \du

Shows summary information about all tables in the current database

    => \dt

exit/quit the psql shell

    => \q or CTRL+d

There are of course many more meta-commands, but these should help you
get started.

Configure PostgreSQL to be accessible from remote hosts
-------------------------------------------------------

The PostgreSQL database server configuration file is postgresql.conf.
This file is located in the data directory of the server, typically
/var/lib/postgres/data. This folder also houses the other main config
files, including the pg_hba.conf.

Note: By default this folder will not even be browseable (or searchable)
by a regular user, if you are wondering why `find` or `locate` is not
finding the conf files, this is the reason (threw me for a loop the
first time I installed).

As root user edit the file  

    # vim /var/lib/postgres/data/postgresql.conf

In the connections and authentications section uncomment or edit the
listen_addresses line to your needs  

    listen_addresses = '*'

and take a careful look at the other lines.

Hereafter insert the following line in the host-based authentication
file /var/lib/postgres/data/pg_hba.conf. This file controls which hosts
are allowed to connect, so be careful.

    # IPv4 local connections:
    host   all   all   your_desired_ip_address/32   trust

where your_desired_ip_address is the IP address of the client.

After this you should restart the daemon process for the changes to take
effect with  

    # systemctl restart postgresql

Note: Postgresql uses port 5432 by default for remote connections. So
make sure this port is open and able to receive incoming connections

For troubleshooting take a look in the server log file

    tail /var/log/postgresql.log

Configure PostgreSQL to Work With PHP
-------------------------------------

Install the PHP-PostgreSQL modules

    # pacman -S php-pgsql 

Open the file /etc/php/php.ini with your editor of choice, e.g.,

    # vim /etc/php/php.ini

Find the line that starts with, ";extension=pgsql.so" and change it to,
"extension=pgsql.so". (Just remove the preceding ";"). If you need PDO,
do the same thing with ";extension=pdo.so" and
";extension=pdo_pgsql.so". If these lines are not present, add them.
These lines may be in the "Dynamic Extensions" section of the file, or
toward the very end of the file.

Restart the Apache web server

    # systemctl restart httpd

Change Default Data Dir (Optional)
----------------------------------

The default directory where all your newly created databases will be
stored is /var/lib/postgres/data. To change this, follow these steps:

Create the new directory and assign it to user postgres (you eventually
have to become root):

    mkdir -p /pathto/pgroot/data
    chown -R postgres:postgres /pathto/pgroot

Become the postgres user(change to root, then postgres user), and
initialize the new cluster:

    initdb -D /pathto/pgroot/data

Edit /etc/conf.d/postgresql and change the PGROOT variable(optionally
PGLOG) to point to your new pgroot directory.

    #PGROOT="/var/lib/postgres/"
    PGROOT="/pathto/pgroot/"

If using systemd, copy /usr/lib/systemd/system/postgresql.service to
/etc/systemd/system/postgresql.service and change the default PGROOT
path.

    #Environment=PGROOT=/var/lib/postgres/
    Environment=PGROOT=/pathto/pgroot/

You will also need to change the default PIDFile path.

    PIDFile=/pathto/pgroot/data/postmaster.pid

Change Default Encoding of New Databases To UTF-8 (Optional)
------------------------------------------------------------

When creating a new database (e.g. with createdb blog) PostgreSQL
actually copies a template database. There are two predefined templates:
template0 is vanilla, while template1 is meant as an on-site template
changeable by the administrator and is used by default. In order to
change the encoding of new database, one of the options is to change
on-site template1. To do this, log into PostgresSQL shell (psql) and
execute the following:

First, we need to drop template1. Templates cannot be dropped, so we
first modify it so it is an ordinary database:

    UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';

Now we can drop it:

    DROP DATABASE template1;

The next step is to create a new database from template0, with a new
default encoding:

    CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE';

Now modify template1 so it is actually a template:

    UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';

(OPTIONAL) If you do not want anyone connecting to this template, set
datallowconn to FALSE:

    UPDATE pg_database SET datallowconn = FALSE WHERE datname = 'template1';

(this last step can create problems when upgrading via pg_upgrade)

Now you can create a new database by running from regular shell:

    su -
    su - postgres
    createdb blog;

If you log in back to psql and check the databases, you should see the
proper encoding of your new database:

    \l

returns

                                  List of databases
      Name    |  Owner   | Encoding  | Collation | Ctype |   Access privileges
    -----------+----------+-----------+-----------+-------+----------------------
    blog      | postgres | UTF8      | C         | C     |
    postgres  | postgres | SQL_ASCII | C         | C     |
    template0 | postgres | SQL_ASCII | C         | C     | =c/postgres
                                                         : postgres=CTc/postgres
    template1 | postgres | UTF8      | C         | C     |

Installing phpPgAdmin (optional)
--------------------------------

Phppgadmin (website) is a web-based administration tool for PostgreSQL.

1.  Make sure that the [community] repo is enabled.
2.  Install the package via Pacman

        # pacman -S phppgadmin

Installing pgAdmin (optional)
-----------------------------

pgAdmin is a GUI-based administration tool for PostgreSQL.

1.  Install the package via Pacman

        # pacman -S pgadmin3

Upgrading PostgreSQL
--------------------

> Quick Guide

This is for upgrading from 9.1 to 9.2.

     pacman -S --needed postgresql-old-upgrade
     su - postgres -c 'mv /var/lib/postgres/data /var/lib/postgres/data-9.1'
     su - postgres -c 'mkdir /var/lib/postgres/data'
     su - postgres -c 'initdb -D /var/lib/postgres/data'

If you had custom settings in configuration files like pg_hba.conf and
postgresql.conf, merge them into the new ones. Then:

     su - postgres -c 'pg_upgrade -b /opt/pgsql-9.1/bin/ -B /usr/bin/ -d /var/lib/postgres/data-9.1 -D /var/lib/postgres/data'

If the "pg_upgrade" step fails with:

-   cannot write to log file pg_upgrade_internal.log  
     Failure, exiting   
    Make sure you're in a directory that the "postgres" user has enough
    rights to write the log file to (/tmp for example). Or use "su -
    postgres" instead of "sudo -u postgres".
-   LC_COLLATE error that says that old and new values are different  
    Figure out what the old locale was, C or en_US.UTF-8 for example,
    and force it when calling initdb.

     sudo -u postgres LC_ALL=C initdb -D /var/lib/postgres/data

-   There seems to be a postmaster servicing the old cluster.  
    Please shutdown that postmaster and try again.  
    Make sure postgres isn't running. If you still get the error then
    chances are these an old PID file you need to clear out.

     > sudo -u postgres ls -l /var/lib/postgres/data-9.1
       total 88
       -rw------- 1 postgres postgres     4 Mar 25  2012 PG_VERSION
       drwx------ 8 postgres postgres  4096 Jul 17 00:36 base
       drwx------ 2 postgres postgres  4096 Jul 17 00:38 global
       drwx------ 2 postgres postgres  4096 Mar 25  2012 pg_clog
       -rw------- 1 postgres postgres  4476 Mar 25  2012 pg_hba.conf
       -rw------- 1 postgres postgres  1636 Mar 25  2012 pg_ident.conf
       drwx------ 4 postgres postgres  4096 Mar 25  2012 pg_multixact
       drwx------ 2 postgres postgres  4096 Jul 17 00:05 pg_notify
       drwx------ 2 postgres postgres  4096 Mar 25  2012 pg_serial
       drwx------ 2 postgres postgres  4096 Jul 17 00:53 pg_stat_tmp
       drwx------ 2 postgres postgres  4096 Mar 25  2012 pg_subtrans
       drwx------ 2 postgres postgres  4096 Mar 25  2012 pg_tblspc
       drwx------ 2 postgres postgres  4096 Mar 25  2012 pg_twophase
       drwx------ 3 postgres postgres  4096 Mar 25  2012 pg_xlog
       -rw------- 1 postgres postgres 19169 Mar 25  2012 postgresql.conf
       -rw------- 1 postgres postgres    48 Jul 17 00:05 postmaster.opts
       -rw------- 1 postgres postgres    80 Jul 17 00:05 postmaster.pid   # <-- This is the problem
     
     > sudo -u postgres mv /var/lib/postgres/data-9.1/postmaster.pid /tmp

-   ERROR: could not access file "$libdir/postgis-2.0": No such file or
    directory   
     Retrieve postgis-2.0.so from postgis package for version postgresql
    9.1 () and copy it to /opt/pgsql-9.1/lib (make sure the privileges
    are right)

> Detailed Instructions

Warning:Official PostgreSQL upgrade documentation should be followed.

Note that these instructions could cause data loss. Use at your own
risk.

It is recommended to add the following to your /etc/pacman.conf file:

    IgnorePkg = postgresql postgresql-libs

This will ensure you do not accidentally upgrade the database to an
incompatible version. When an upgrade is available, pacman will notify
you that it is skipping the upgrade because of the entry in pacman.conf.
Minor version upgrades (e.g., 9.0.3 to 9.0.4) are safe to perform.
However, if you do an accidental upgrade to a different major version
(e.g., 9.0.X to 9.1.X), you might not be able to access any of your
data. Always check the PostgreSQL home page (http://www.postgresql.org/)
to be sure of what steps are required for each upgrade. For a bit about
why this is the case see the versioning policy.

There are two main ways to upgrade your PostgreSQL database. Read the
official documentation for details.

For those wishing to use pg_upgrade, a postgresql-old-upgrade package is
available in the repositories that will always run one major version
behind the real PostgreSQL package. This can be installed side by side
with the new version of PostgreSQL. When you are ready to perform the
upgrade, you can do

    pacman -Syu postgresql postgresql-libs postgresql-old-upgrade

Note also that the data directory does not change from version to
version, so before running pg_upgrade it is necessary to rename your
existing data directory and migrate into a new directory. The new
database must be initialized by starting the server, as described near
the top of this page. The server then needs to be stopped before running
pg_upgrade.

    # rc.d stop postgresql
    # su - postgres -c 'mv /var/lib/postgres/data /var/lib/postgres/olddata'
    # rc.d start postgresql
    # rc.d stop postgresql

Reference the upstream pg_upgrade documentation for details.

The upgrade invocation will likely look something like the following
(run as the postgres user). Do not run this command blindly without
understanding what it does!

    # su - postgres -c 'pg_upgrade -d /var/lib/postgres/olddata/ -D /var/lib/postgres/data/ -b /opt/pgsql-8.4/bin/ -B /usr/bin/'

You could also do something like this (after the upgrade and install of
postgresql-old-upgrade)

    # rc.d stop postgresql
    # /opt/pgsql-8.4/bin/pg_ctl -D /var/lib/postgres/olddata/ start
    # pg_dumpall >> old_backup.sql
    # /opt/pgsql-8.4/bin/pg_ctl -D /var/lib/postgres/olddata/ stop
    # rc.d start postgresql
    # psql -f old_backup.sql postgres

Troubleshooting
---------------

> Improve performance of small transactions

If you are using PostgresSQL on a local machine for development and it
seems slow, you could try turning synchronous_commit off in the
configuration (/var/lib/postgres/data/postgresql.conf). Beware of the
caveats, however.

    synchronous_commit = off

> Prevent disk writes when idle

PostgreSQL periodically updates its internal "statistics" file. By
default, this file is stored on disk, which prevents disks spinning down
on laptops and causes hard drive seek noise. It's simple and safe to
relocate this file to a memory-only file system with the following
configuration option:

    stats_temp_directory = '/run/postgresql'

See also
--------

-   Official PostgreSQL Homepage

Retrieved from
"https://wiki.archlinux.org/index.php?title=PostgreSQL&oldid=253590"

Categories:

-   Database management systems
-   Web Server
