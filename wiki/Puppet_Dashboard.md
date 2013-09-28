Puppet Dashboard
================

Note:This wiki entry is a work-in-progress.

From Puppet Dashboard web site:

The Puppet Dashboard is a web interface and reporting tool for your
Puppet installation. Dashboard facilitates management and configuration
tasks, provides a quick visual snapshot of important system information,
and delivers valuable reports.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Setting up a database for Puppet Dashboard                         |
|     -   1.1 Create a MySQL database                                      |
|     -   1.2 Create a MySQL user and grant privileges                     |
|     -   1.3 Create a database.yml file that matches your database        |
+--------------------------------------------------------------------------+

Setting up a database for Puppet Dashboard
------------------------------------------

Setting up a database for Puppet Dashboard is the same as most other
Ruby on Rails projects:

1.  Create a MySQL database.
2.  Create a MySQL user and grant privileges.
3.  Create a database.yml file that matches your database.
4.  Run db:migrate from within the Rails root.

You will need to decide on a database name and a Puppet Dashboard MySQL
user and password. The user (and password) will never be used for
authentication to the end-user. This guide assumes the database name
puppet_dashboard with a username of puppet_dashboard and a random
password, as described below.

> Create a MySQL database

First, make sure that a MySQL server is installed and running. Log into
MySQL as the root user, like so:

    $ mysql -u root

Or, if you have set a root password:

    $ mysql -u root -p

When logged in, create a database for Puppet Dashboard:

    mysql> create database `puppet_dashboard` default charset utf8;

> Create a MySQL user and grant privileges

As mentioned, the MySQL user for Puppet Dashboard will never be
available to the end-user, so it is a good idea to make a robust
password. This is easily done by using pwgen (available in the mirrors
as a part of the pwgen package). To get a randomly-generated,
50-character password, run it like this:

    $ pwgen -N 1 -s 50
    s5ODn3iaX97mv5Ky6VmW2Z4rBitX1JxWgFNAFQbdtTrcytM8vL

This will be the password used for the MySQL user. While at a MySQL
prompt, run the following:

    mysql> grant all on `puppet_dashboard`.* to 'puppet_dashboard'@'localhost' identified by 's5ODn3iaX97mv5Ky6VmW2Z4rBitX1JxWgFNAFQbdtTrcytM8vL';

Your database is now configured.

> Create a database.yml file that matches your database

Retrieved from
"https://wiki.archlinux.org/index.php?title=Puppet_Dashboard&oldid=221042"

Category:

-   System administration
