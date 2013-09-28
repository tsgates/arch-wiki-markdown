Redmine
=======

Summary

This page gives guidelines for the installation and configuration of
Redmine on Archlinux.

Related

Ruby on Rails

RVM

MariaDB

Redmine is a free and open source, web-based project management and
bug-tracking tool. It includes a calendar and Gantt charts to aid visual
representation of projects and their deadlines. It handles multiple
projects. Redmine provides integrated project management features, issue
tracking, and support for various version control systems.

Redmine is written using the Ruby on Rails framework. It is
cross-platform and cross-database.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prerequisites                                                      |
|     -   1.1 Ruby                                                         |
|     -   1.2 Database                                                     |
|         -   1.2.1 MariaDB 5.0 or higher (recommended)                    |
|         -   1.2.2 MySQL 5.0 or higher                                    |
|         -   1.2.3 PostgreSQL 8.2 or higher                               |
|         -   1.2.4 Microsoft SQL Server                                   |
|         -   1.2.5 SQLite 3                                               |
|                                                                          |
|     -   1.3 Web Server                                                   |
|         -   1.3.1 Phusion Passenger (recommended)                        |
|         -   1.3.2 Apache                                                 |
|         -   1.3.3 Mongrel                                                |
|         -   1.3.4 Unicorn                                                |
|         -   1.3.5 nginx                                                  |
|         -   1.3.6 Apache Tomcat                                          |
|                                                                          |
| -   2 Optional Prerequisites                                             |
|     -   2.1 SCM (Source Code Management)                                 |
|     -   2.2 ImageMagick                                                  |
|     -   2.3 Ruby OpenID Library                                          |
|                                                                          |
| -   3 Installation                                                       |
|     -   3.1 Build and Installation                                       |
|     -   3.2 Database Configuration                                       |
|         -   3.2.1 Database Creation                                      |
|         -   3.2.2 Database Access Configuration                          |
|                                                                          |
|     -   3.3 Ruby gems                                                    |
|         -   3.3.1 Adding Additional Gems (Optional)                      |
|         -   3.3.2 Check previously installed gems                        |
|         -   3.3.3 Gems Installation                                      |
|                                                                          |
|     -   3.4 Session Store Secret Generation                              |
|     -   3.5 Database Structure Creation                                  |
|     -   3.6 Database Population with Default Data                        |
|     -   3.7 File System Permissions                                      |
|     -   3.8 Test the installation                                        |
|                                                                          |
| -   4 Updating (ToDo)                                                    |
|     -   4.1 Checkout SVN Source                                          |
|     -   4.2 User accounts                                                |
|                                                                          |
| -   5 Test server                                                        |
|     -   5.1 Unicorn server                                               |
|                                                                          |
| -   6 Start redmine on boot                                              |
| -   7 See Also                                                           |
+--------------------------------------------------------------------------+

Prerequisites
-------------

This document will guide you through the installation process of the
Redmine and all of its prerequisites, including the optional ones. If
desired, however, you may install Redmine and it's prerequisites
separately, simply refering to the relevant sections below.

Although this guide will go through all the installation process, this
isn't a one way path. So Redmine can use different versions of the other
softwares (mariaDB, mySQL, postgreSQL, etc, as your database).

Note:At this time is important to note that this guide is an default
suggestion, feel free to use other of the prerequisites mentioned on
this wiki.

> Ruby

Redmine version

Supported Ruby versions

Rails version used

Supported RubyGems versions

2.3.0

ruby 1.8.7, 1.9.2, 1.9.3, 2.0.0

Rails 3.2.13

RubyGems <= 1.8

jruby 1.6.7, 1.7.2

  
 There are two simple ways to install Ruby: installing the ruby package
as described in ruby or installing RVM as described in RVM
(recommended).

Note:If you use RVM, pay attention to the single and multiple user
differences! If you are not creating a hosting service, the multiple
user (available for all users on the machine) should be the choice for
simpler debuging.

> Database

Redmine Officially support many databases.

MariaDB 5.0 or higher (recommended)

MariaDB is a drop-in replacement for MySQL, in fact it was a fork of it
and maintain binarie compatibility.

To install mariadb simply refer to MariaDB.

MySQL 5.0 or higher

To install mysql simply refer to MySQL.

PostgreSQL 8.2 or higher

To install postgresql simply refer to Postgresql.

Make sure your database datestyle is set to ISO (Postgresql default
setting). You can set it using:

    ALTER DATABASE "redmine_db" SET datestyle="ISO,MDY";

Note:Some bugs in PostgreSQL 8.4.0 and 8.4.1 affect Redmine behavior
([#4259], [#4314]), they are fixed in PostgreSQL 8.4.2

Microsoft SQL Server

Warning:Support is temporarily broken (with ruby 2.0.0 under Windows
because of database adapter gems incompatibilities).

SQLite 3

Not supported for multi-user production use. So, it will not be detailed
how to install and configure it for use with Redmine. See upstream
document for more info.

Warning:Support is temporarily broken (with ruby 2.0.0 under Windows
because of database adapter gems incompatibilities).

> Web Server

Phusion Passenger (recommended)

TODO

Apache

TODO

Mongrel

TODO

Unicorn

Configure and start Unicorn using script provided in Ruby on
Rails#Unicorn.

nginx

See Nginx to install it.

Apache Tomcat

See Ruby on Rails#Application_servers

Optional Prerequisites
----------------------

> SCM (Source Code Management)

TODO: list all scm supported and how to install them...

> ImageMagick

TODO: to enable Gantt export to png image. link:
http://www.imagemagick.org/

> Ruby OpenID Library

TODO: to enable OpenID support (version 2 or greater is required). link:
http://openidenabled.com/ruby-openid/

Installation
------------

> Build and Installation

Download the package redmine from the AUR.

Note:Detailed build instructions at Arch User Repository#Build the
package. It's HIGHLY recommended to read all the AUR page to understand
what are you doing.

> Database Configuration

Now, we will need to create the database that the Redmine will use to
store your data. For now on, the database and its user will be named
redmine. But this names can be changed to anything else.

Note:The configuration for MariaDB and MySQL will be the same since both
are binary compatible.

Database Creation

To create the database, the user and set privileges (MariaDB and MySQL
>= 5.0.2):

    # mysql -u root -p

    CREATE DATABASE redmine CHARACTER SET UTF8;
    CREATE USER 'redmine'@'localhost' IDENTIFIED BY 'my_password';
    GRANT ALL PRIVILEGES ON redmine.* TO 'redmine'@'localhost';

For versions of MariaDB and MySQL prior to 5.0.2:

    # mysql -u root -p

    CREATE DATABASE redmine CHARACTER SET UTF8;
    GRANT ALL PRIVILEGES ON redmine.* TO'redmine'@'localhost' IDENTIFIED BY 'my_password';

For PostgreSQL:

    CREATE ROLE redmine LOGIN ENCRYPTED PASSWORD 'my_password' NOINHERIT VALID UNTIL 'infinity';
    CREATE DATABASE redmine WITH ENCODING='UTF8' OWNER=redmine;

For SQLServer:

Although the database, login and user can be created within SQL Server
Management Studio with a few clicks, you can always use the command line
with SQLCMD:

    USE [master]
    GO
    -- Very basic DB creation
    CREATE DATABASE [REDMINE]
    GO
    -- Creation of a login with SQL Server login/password authentication and no password expiration policy
    CREATE LOGIN [REDMINE] WITH PASSWORD=N'redminepassword', DEFAULT_DATABASE=[REDMINE], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
    GO
    -- User creation using previously created login authentication
    USE [REDMINE]
    GO
    CREATE USER [REDMINE] FOR LOGIN [REDMINE]
    GO
    -- User permissions set via roles
    EXEC sp_addrolemember N'db_datareader', N'REDMINE'
    GO
    EXEC sp_addrolemember N'db_datawriter', N'REDMINE'
    GO

Note:If you want to use additional environments, you must create
separate databases for each one (for example: development and test).

Database Access Configuration

Now you need to configure Redmine to access the database we just
created. To do that you have to copy
/usr/share/webapps/redmine/config/database.yml.example to database.yml:

    # cd /usr/share/webapps/redmine/config
    # cp database.yml.example database.yml

And then edit this file in order to configure your database settings for
"production" environment (you can configure for the "development" and
"test" environments too, just change the appropriate sections).

Example for MariaDB and MySQL database:

    nano database.yml

    production:
      adapter: mysql2
      database: redmine
      host: localhost
      port: 3307   #If your server is not running on the standard port (3306), set it here, otherwise this line is unnecessary.
      username: redmine
      password: my_password

Note:For ruby1.9 the "adapter" value must be set to mysql2, and for
ruby1.8 or jruby, it must be set to mysql.

Example for PostgreSQL database:

    nano database.yml

    production:
      adapter: postgresql
      database: redmine
      host: localhost
      username: redmine
      password: my_password
      encoding: utf8
      schema_search_path: <database_schema> (default - public)

Example for a SQL Server database:

    nano database.yml

    production:
      adapter: sqlserver
      database: redmine
      host: localhost #Set not default host (localhost) here, otherwise this line is unnecessary.
      port: 1433 #Set not standard port (1433) here, otherwise this line is unnecessary.
      username: redmine
      password: my_password

> Ruby gems

Redmine requires some RubyGems to be installed and there are multiple
ways of installing them (as listed on the referenced page).

-   prototype-rails
-   unicorn (an application-server)
-   mysql2 (high-performance Ruby bindings for MySQL)
-   coderay
-   erubis
-   fastercsv
-   rdoc
-   net-ldap
-   rack-openid

Obviously, if you choose a different database-server, or want to use a
different application-server you should replace mysql2 and unicorn to
your liking.

Adding Additional Gems (Optional)

If you need to load gems that are not required by Redmine core (eg.
Puma, fcgi), create a file named Gemfile.local at the root of your
redmine directory. It will be loaded automatically when running
bundle install:

    # nano Gemfile.local

    gem 'puma'

Check previously installed gems

The Redmine devs included Bundler in Redmine, which can manage Gems just
like pacman manages packages. Run the following command to assure
Redmine all dependencies are met:

    # bundle install --without development test rmagick postgresql sqlite

This should output a list of gems Redmine needs.

Gems Installation

Note:If you prefer, you can install all the gems as pacman packages. You
have only to search for the gem package and install them as usual. As of
using Ruby gem is much simpler to manage and maintain up to date gems,
this will be preferable and used as default bellow.

Redmine uses Bundler to manage gems dependencies. So, you need to
install Bundler first:

    # gem install bundler

Then you can install all the gems required by Redmine using the
following command:

    # cd /usr/share/webapps/redmine
    # bundle install

To install without the ruby development and test environments use this
instead of the last command:

    # bundle install --without development test

Note:You can include/exclude environments using the above syntax.

Although it is highly recommend to enjoy all the features of Redmine, if
you really does not want to use ImageMagick, you should skip the
installation of the rmagick gem using:

    # bundle install --without rmagick

Note:Only the gems that are needed by the adapters you've specified in
your database configuration file are actually installed (eg. if your
config/database.yml uses the mysql2 adapter, then only the mysql2 gem
will be installed). Don't forget to re-run bundle install when you
change or add adapters in this file.

> Session Store Secret Generation

Now you must generate a random key that will be used by Rails to encode
cookies that stores session data thus preventing their tampering:

    # rake generate_secret_token

Note:For Redmine prior to 2.x this step is done by executing
# rake generate_session_store.

Warning:Generating a new secret token invalidates all existing sessions
after restart.

> Database Structure Creation

With the database created and the access configured for Redmine, now
it's time to create the database structure. This is done by running the
following command under the application root directory:

    # cd /usr/share/webapps/redmine
    # RAILS_ENV=production rake db:migrate

These command will create tables by running all migrations one by one
then create the set of the permissions and the application administrator
account, named admin.

> Database Population with Default Data

Now you may want to insert the default configuration data in database,
like basic types of task, task states, groups, etc. To do so execute the
following:

    # RAILS_ENV=production rake redmine:load_default_data

Redmine will prompt for the data set language that should be loaded; you
can also define the REDMINE_LANG environment variable before running the
command to a value which will be automatically and silently picked up by
the task:

    # RAILS_ENV=production REDMINE_LANG=pt-BR rake redmine:load_default_data

Note:This step is not mandatory, but it certainly will save you a lot of
work to start using Redmine. And for a first time it can be very
instructive.

> File System Permissions

The user account running the application must have write permission on
the following subdirectories:

    files: storage of attachments.
    log: application log file production.log.
    tmp and tmp/pdf: used to generate PDF documents among other things (create these ones if not present).

Assuming you run the application with a the default Apache user http
account:

    # mkdir tmp tmp/pdf public/plugin_assets
    # chown -R http:http files log tmp public/plugin_assets
    # chmod -R 755 files log tmp tmp/pdf public/plugin_assets

> Test the installation

To test your new installation using WEBrick web server run the following
in the Redmine folder:

    # ruby script/rails server webrick -e production

Once WEBrick has started, point your browser to http://localhost:3000/.
You should now see the application welcome page. Use default
administrator account to log in: admin/admin. You can go to
Administration menu and choose Settings to modify most of the
application settings.

Warning:Webrick is not suitable for production use, please only use
webrick for testing that the installation up to this point is
functional. Use one of the many other guides in this wiki to setup
redmine to use either Passenger (aka mod_rails), FCGI or a Rack server
(Unicorn, Thin, Puma or hellip) to serve up your redmine.

Updating (ToDo)
---------------

Backup the files used in Redmine:

    # cd /usr/share/webapps/redmine/files
    # tar -czvf redmine_files.tar.gz *
    # mv redmine_files.tar.gz /path/to/your/secure/location

Backup the plugins installed in Redmine:

    # cd /usr/share/webapps/redmine/plugins
    # tar -czvf redmine_plugins.tar.gz *
    # mv redmine_plugins.tar.gz /path/to/your/secure/location

Backup the database:

    # mysqldump -u root -p<password> <redmine_database> | gzip > /path/to/backup/db/redmine_`date +%y_%m_%d`.gz

Update the package as normal (through AUR):

    # wget https://aur.archlinux.org/packages/re/redmine/redmine.tar.gz
    # tar -zxpvf redmine.tar.gz
    # cd redmine

Inspect the downloaded files, mainly the PKGBUILD, and then build:

    # makepkg -s
    # pacman -U redmine-2.3.0-2-any.pkg.tar.gz

Note:To simplify all this AUR install and update process, you can always
use the AUR Helpers, although this isn't a supported way.

Update the gems requirements:

    #  bundle update

For a clean gems environment, you may want to remove all the gems and
reinstall them. To go through this, do:

    # for x in `gem list --no-versions`; do gem uninstall $x -a -x -I; done

Warning:The command above will delete ALL the gems in your system or
user, depending of what type of Ruby installation you did in the
prerequisites step. You must take care or you can stop working another
applications that rely on Ruby gems.

If you did the last step and removed all the gems, now you will need to
reinstall them all:

    # gem install bundler
    # bundle install --without development test

Copy the saved files:

    # cd /path/to/your/secure/location
    # mv redmine_files.tar.gz /usr/share/webapps/redmine/files
    # cd /usr/share/webapps/redmine/files
    # tar -zxpvf redmine_files.tar.gz

Copy the installed plugins

    # cd /path/to/your/secure/location
    # mv redmine_plugins.tar.gz /usr/share/webapps/redmine/plugins
    # cd /usr/share/webapps/redmine/plugins
    # tar -zxpvf redmine_plugins.tar.gz

Regenerate the secret token:

    # cd /usr/share/webapps/redmine
    # rake generate_secret_token

Check for any themes that you may have installed in the public/themes
directory. You can copy them over but checking for updated version is
ideal.

Warning:Do NOT overwrite config/settings.yml with the old one.

Update the database. This step is the one that could change the contents
of your database. Go to your new redmine directory, then migrate your
database:

    # RAILS_ENV=production REDMINE_LANG=pt-BR rake db:migrate

If you have installed any plugins, you should also run their database
migrations:

    # RAILS_ENV=production REDMINE_LANG=pt-BR rake redmine:plugins:migrate

Now, it's time to clean the cache and the existing sessions:

    # rake tmp:cache:clear
    # rake tmp:sessions:clear

Restart the application server (e.g. puma, thin, passenger, etc). And
finally go to "Admin -> Roles & permissions" to check/set permissions
for the new features, if any.

> Checkout SVN Source

Get the Redmine source (Download instructions). Here is method of
installing Redmine directly from subversion in /srv/http/redmine/

    # useradd -d /srv/http/redmine -s /bin/false redmine
    # mkdir -p /srv/http/redmine
    # svn checkout http://svn.redmine.org/redmine/branches/2.1-stable /srv/http/redmine
    # chown -R redmine: /srv/http/redmine

> User accounts

Add redmine user and append redmine2 to git group.

    # useradd --user-group --shell /bin/bash --comment 'redmine2 system' --create-home --groups git redmine2

Test server
-----------

> Unicorn server

    # sudo -u redmine2 unicorn -D -E production -c config/unicorn.rb

Start redmine on boot
---------------------

    #systemctl enable redmine

See Also
--------

-   Official install guide from Redmine Wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Redmine&oldid=255980"

Category:

-   Version Control System
