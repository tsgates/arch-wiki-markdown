PostgreSQL
==========

Related articles

-   PhpPgAdmin

PostgreSQL is an open source, community driven, standard compliant
object-relational database system.

This document describes how to set up PostgreSQL. It also describes how
to configure PostgreSQL to be accessible from a remote client. If you
need help setting up the rest of a web stack, see the LAMP page and
follow all of the sections except the one related to MySQL.

Contents
--------

-   1 Before you start
-   2 Installing PostgreSQL
-   3 Create your first database/user
-   4 Familiarize with PostgreSQL
    -   4.1 Access the database shell
-   5 Optional configuration
    -   5.1 Configure PostgreSQL to be accessible from remote hosts
    -   5.2 Change default data directory
    -   5.3 Change default encoding of new databases to UTF-8
-   6 Administration tools
-   7 Upgrading PostgreSQL
    -   7.1 Quick guide
    -   7.2 Detailed instructions
        -   7.2.1 Manual dump and reload
-   8 Troubleshooting
    -   8.1 Improve performance of small transactions
    -   8.2 Prevent disk writes when idle

Before you start
----------------

Several sections have instructions stating "become the postgres user".
Commands that should be run as the postgres user are prefixed by
[postgres]$ in this article.

Execute the following as root to get a shell as the postgres user:

    # su - postgres

If you use sudo, you can use the following:

    $ sudo -i -u postgres

The postgres user will automatically be created by installing
PostgreSQL.

Installing PostgreSQL
---------------------

Install postgresql from the official repositories.

Before PostgreSQL can function correctly the database cluster must be
initialized by the postgres user. Become the postgres user and run the
following commmand:

    [postgres]$ initdb --locale en_US.UTF-8 -E UTF8 -D '/var/lib/postgres/data'

Start PostgreSQL and, optionally, add it to the list of daemons that
start on system startup:

    # systemctl start postgresql
    # systemctl enable postgresql

Warning:If the database resides on a Btrfs file system, you should
consider disabling Copy-on-Write for the directory before creating any
database.

Create your first database/user
-------------------------------

Tip:If you create a PostgreSQL user with the same name as your Linux
username, it allows you to access the PostgreSQL database shell without
having to specify a user to login (which makes it quite convenient).

Become the postgres user. Add a new database user using the createuser
command:

    [postgres]$ createuser --interactive

Create a new database over which the above user has read/write
privileges using the createdb command (execute this command from your
login shell if the database user has the same name as your Linux user,
otherwise add -U database-username to the following command):

    $ createdb myDatabaseName

Familiarize with PostgreSQL
---------------------------

> Access the database shell

Become the postgres user. Start the primary db shell, psql, where you
can do all your creation of databases/tables, deletion, set permissions,
and run raw SQL commands. Use the "-d" option to connect to the database
you created (without specifying a database, psql will try to access a
database that matches your username)

    [postgres]$ psql -d myDatabaseName

Some helpful commands:

Get help

    => \help

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

Optional configuration
----------------------

> Configure PostgreSQL to be accessible from remote hosts

The PostgreSQL database server configuration file is postgresql.conf.
This file is located in the data directory of the server, typically
/var/lib/postgres/data. This folder also houses the other main config
files, including the pg_hba.conf.

Note:By default this folder will not even be browseable (or searchable)
by a regular user, if you are wondering why find or locate is not
finding the conf files, this is the reason.

Edit the file /var/lib/postgres/data/postgresql.conf. In the connections
and authentications section add the listen_addresses line to your needs:

    listen_addresses = 'localhost,my_remote_ip_address'

Take a careful look at the other lines.

Host-based authentication is configured in
/var/lib/postgres/data/pg_hba.conf. This file controls which hosts are
allowed to connect. Note that the defaults allow any local user to
connect as any database user including the database superuser. Add a
line like the following:

    # IPv4 local connections:
    host   all   all   my_remote_ip_address/32   md5

where your_desired_ip_address is the IP address of the client.

See the documentation for pg_hba.conf.

After this you should restart the daemon process for the changes to take
effect with:

    # systemctl restart postgresql

Note:Postgresql uses port 5432 by default for remote connections. So
make sure this port is open and able to receive incoming connections.

For troubleshooting take a look in the server log file

    $ journalctl -u postgresql

> Change default data directory

The default directory where all your newly created databases will be
stored is /var/lib/postgres/data. To change this, follow these steps:

Create the new directory and make the postgres user its owner:

    # mkdir -p /pathto/pgroot/data
    # chown -R postgres:postgres /pathto/pgroot

Become the postgres user, and initialize the new cluster:

    [postgres]$ initdb -D /pathto/pgroot/data

If enabled, disable postgres.service. Copy
/usr/lib/systemd/system/postgresql.service to
/etc/systemd/system/postgresql.service and edit it to change the default
PGROOT and PIDFile paths.

    Environment=PGROOT=/pathto/pgroot/
    ...
    PIDFile=/pathto/pgroot/data/postmaster.pid

> Change default encoding of new databases to UTF-8

Note:If you ran initdb with -E UTF8 these steps are not required

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

Note:this last step can create problems when upgrading via pg_upgrade.

Now you can create a new database:

    [postgres]$ createdb blog

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

Administration tools
--------------------

-   phpPgAdmin — Web-based administration tool for PostgreSQL.

http://phppgadmin.sourceforge.net || phppgadmin

-   pgAdmin — GUI-based administration tool for PostgreSQL.

http://www.pgadmin.org/ || pgadmin3

Upgrading PostgreSQL
--------------------

> Quick guide

This is for upgrading from 9.2 to 9.3.

     pacman -S --needed postgresql-old-upgrade
     su -
     su - postgres -c 'mv /var/lib/postgres/data /var/lib/postgres/data-9.2'
     su - postgres -c 'mkdir /var/lib/postgres/data'
     su - postgres -c 'initdb --locale en_US.UTF-8 -E UTF8 -D /var/lib/postgres/data'

If you had custom settings in configuration files like pg_hba.conf and
postgresql.conf, merge them into the new ones. Then:

     su - postgres -c 'pg_upgrade -b /opt/pgsql-9.2/bin/ -B /usr/bin/ -d /var/lib/postgres/data-9.2 -D /var/lib/postgres/data'

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

     > sudo -u postgres ls -l /var/lib/postgres/data-9.2
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
     
     > sudo -u postgres mv /var/lib/postgres/data-9.2/postmaster.pid /tmp

-   ERROR: could not access file "$libdir/postgis-2.0": No such file or
    directory   
     Retrieve postgis-2.0.so from postgis package for version postgresql
    9.2 () and copy it to /opt/pgsql-9.2/lib (make sure the privileges
    are right)

> Detailed instructions

Note:Official PostgreSQL upgrade documentation should be followed.

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
database must be initialized, as described near the top of this page.

    # systemctl stop postgresql
    # su - postgres -c 'mv /var/lib/postgres/data /var/lib/postgres/olddata'
    # su - postgres -c 'initdb --locale en_US.UTF-8 -E UTF8 -D /var/lib/postgres/data'

Reference the upstream pg_upgrade documentation for details.

The upgrade invocation will likely look something like the following
(run as the postgres user). Do not run this command blindly without
understanding what it does!

    # su - postgres -c 'pg_upgrade -d /var/lib/postgres/olddata/ -D /var/lib/postgres/data/ -b /opt/pgsql-8.4/bin/ -B /usr/bin/'

Manual dump and reload

You could also do something like this (after the upgrade and install of
postgresql-old-upgrade) (NB: below is command for postgres8.4 update,
you can find similar command in /opt/ for postgres 9.2 update. )

    # systemctl stop postgresql
    # /opt/pgsql-8.4/bin/pg_ctl -D /var/lib/postgres/olddata/ start
    # /opt/pgsql-8.4/bin/pg_dumpall >> old_backup.sql
    # /opt/pgsql-8.4/bin/pg_ctl -D /var/lib/postgres/olddata/ stop
    # systemctl start postgresql
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

Retrieved from
"https://wiki.archlinux.org/index.php?title=PostgreSQL&oldid=305122"

Categories:

-   Database management systems
-   Web Server

-   This page was last modified on 16 March 2014, at 15:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
