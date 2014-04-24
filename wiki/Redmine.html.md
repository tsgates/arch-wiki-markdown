Redmine
=======

Related articles

-   Ruby on Rails
-   RVM
-   MariaDB
-   Apache
-   Nginx

Redmine is a free and open source, web-based project management and
bug-tracking tool. It includes a calendar and Gantt charts to aid visual
representation of projects and their deadlines. It handles multiple
projects. Redmine provides integrated project management features, issue
tracking, and support for various version control systems.

Redmine is written using the Ruby on Rails framework. It is
cross-platform and cross-database.

Contents
--------

-   1 Prerequisites
    -   1.1 Ruby
    -   1.2 Database
        -   1.2.1 MariaDB 5.0 or higher (recommended)
        -   1.2.2 MySQL 5.0 or higher
        -   1.2.3 PostgreSQL 8.2 or higher
        -   1.2.4 Microsoft SQL Server
        -   1.2.5 SQLite 3
    -   1.3 Web Server
        -   1.3.1 Apache
        -   1.3.2 Mongrel
        -   1.3.3 Unicorn
        -   1.3.4 Nginx
        -   1.3.5 Apache Tomcat
-   2 Optional Prerequisites
    -   2.1 SCM (Source Code Management)
    -   2.2 ImageMagick
    -   2.3 Ruby OpenID Library
-   3 Installation
    -   3.1 Build and Installation
    -   3.2 Database Configuration
        -   3.2.1 Database Creation
        -   3.2.2 Database Access Configuration
    -   3.3 Ruby gems
        -   3.3.1 Adding Additional Gems (Optional)
        -   3.3.2 Check previously installed gems
        -   3.3.3 Gems Installation
    -   3.4 Session Store Secret Generation
    -   3.5 Database Structure Creation
    -   3.6 Database Population with Default Data
    -   3.7 File System Permissions
    -   3.8 Test the installation
    -   3.9 Configure the production server
-   4 Updating
-   5 Troubleshooting
    -   5.1 RMagick gem without support for High Dynamic Range in
        ImageMagick
    -   5.2 Runtime error complaining that RMagick was configured with
        older version
    -   5.3 Error when installing gems: Cannot load such file --
        mysql2/mysql2
    -   5.4 Apache 2.4 Updating
    -   5.5 Checkout SVN Source
    -   5.6 Automating The Update Process
    -   5.7 Creating a Systemd Unit
-   6 See Also

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

2.5.0

ruby 1.8.7, 1.9.2, 1.9.3, 2.0.0

Rails 3.2

RubyGems <= 1.8

jruby 1.7.6

There are two simple ways to install Ruby: installing the ruby package
as described in ruby or installing RVM as described in RVM
(recommended).

Note:Ruby MRI 1.8.7 support has reached its EOL and its use is
discouraged. See Important: Ruby 1.8.7 out of support and #14371 for
additional information.

Note:MRI 1.9.3p327 contains a bug breaking plugin loading under Windows
which 1.9.3p194 or 1.9.3p392 haven't.

Note:Ruby 2.1 on Rails 3.2 has a bug. See upstream bug track #16194.

Warning:If you use RVM, pay attention to the single and multiple user
differences! If you are not creating a hosting service, the multiple
user (available for all users on the machine) should be the choice for
simpler debuging.

> Database

Redmine supports many different databases.

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
because of database adapter gem incompatibility).

SQLite 3

Not supported for multi-user production use. So, it will not be detailed
how to install and configure it for use with Redmine. See upstream
document for more info.

Warning:Support is temporarily broken (with ruby 2.0.0 under Windows
because of database adapter gems incompatibilities).

> Web Server

Apache

To install apache simply refer to Apache.

Mongrel

To install Mongrel server (ruby gem) simply refer to
Ruby_on_Rails#Mongrel.

Unicorn

To install Unicorn server (ruby gem) simply refer to
Ruby_on_Rails#Unicorn.

Nginx

To install nginx simply refer to Nginx.

Apache Tomcat

To install tomcat6 or tomcat7 simply refer to Tomcat.

Optional Prerequisites
----------------------

> SCM (Source Code Management)

+--------------------------+--------------------------+--------------------------+
| SCM                      | Supported versions       | Comments                 |
+==========================+==========================+==========================+
| Git                      | >=1.5.4.2                |                          |
+--------------------------+--------------------------+--------------------------+
| Subversion               | 1.3, 1.4, 1.5, 1.6 & 1.7 | 1.3 or higher            |
|                          |                          | required.                |
|                          |                          | Doesn't support Ruby     |
|                          |                          | Bindings for             |
|                          |                          | Subversion.              |
|                          |                          |                          |
|                          |                          | Subversion 1.7.0 and     |
|                          |                          | 1.7.1 contains bugs      |
|                          |                          | #9541                    |
+--------------------------+--------------------------+--------------------------+
| Mercurial                | >=1.6                    | Support bellow version   |
|                          |                          | 1.6 is droped as seen in |
|                          |                          | #9465.                   |
+--------------------------+--------------------------+--------------------------+
| Bazaar                   | >= 2.0.4                 |                          |
+--------------------------+--------------------------+--------------------------+
| Darcs                    | >=1.0.7                  |                          |
+--------------------------+--------------------------+--------------------------+
| CVS                      | 1.12.12                  | 1.12 required.           |
|                          |                          |  Won't work with CVSNT.  |
+--------------------------+--------------------------+--------------------------+

  
 More information can be read at Redmine Repositories Wiki.

> ImageMagick

ImageMagick is necessary to enable Gantt export to png image.

To install imagemagick simply:

    # pacman -S imagemagick

> Ruby OpenID Library

To enable OpenID support, is required a version >= 2 of the library.

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
like pacman manages packages. Run the following command to assure that
all Redmine dependencies are met:

    # bundle install --without development test

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

> Configure the production server

For Apache and Nginx, it is recommended to use Phusion Passenger.
Passenger, also known as mod_rails, is a module available for Nginx and
Apache.

Start by installing the 'passenger' gem:

    # gem install passenger

Now you have to look at your passenger gem installation directory to
continue. If you don't known where it is, type:

    # gem env

And look at the GEM PATHS to find where the gems are installed. If you
followed this guide and installed RVM, you can have more than one path,
look at the one you are using.

For this guide so far, the gem path is
/usr/local/rvm/gems/ruby-2.0.0-p247@global.

    # cd /usr/local/rvm/gems/ruby-2.0.0-p247@global/gems/passenger-4.0.23

If you are aiming to use Apache, run:

    # passenger-install-apache2-module

In case a rails application is deployed with a sub-URI, like
http://example.com/yourapplication, some additional configuration is
required, see the modrails documentation

For Nginx:

    # passenger-install-nginx-module

And finally, the installer will provide you with further information
regarding the installation (such as installing additional libraries).
So, to setup your server, simply follow the output from the passenger
installer.

Updating
--------

Backup the files used in Redmine:

    # tar czvf ~/redmine_files.tar.gz -C /usr/share/webapps/redmine/ files

Backup the plugins installed in Redmine:

    # tar czvf ~/redmine_plugins.tar.gz -C /usr/share/webapps/redmine/ plugins

Backup the database:

    # mysqldump -u root -p <redmine_database> | gzip > ~/redmine_db.sql.gz

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

Note:If you removed ALL the gems as above, and used a server that uses a
gem, remember to reinstall the server gem: passenger (for Apache and
Nginx), Mongrel or Unicorn. To do this, just follow the steps in the
installation tutorial above.

Copy the saved files:

    # tar xzvf ~/redmine_files.tar.gz -C /usr/share/webapps/redmine/

Copy the installed plugins

    # tar xzvf ~/redmine_plugins.tar.gz -C /usr/share/webapps/redmine/

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

Troubleshooting
---------------

> RMagick gem without support for High Dynamic Range in ImageMagick

As of ImageMagick 6.8.6.8-1, it is built with HDRI (High Dynamic Range
Image) support, and this breaks the RMagick gem as seen in Arch bug
#36518.

The github rmagick is already patched, but the mantainer did not packed
it for rubygems yet.

To install this patched version download the git repository:

    # git clone https://github.com/rmagick/rmagick.git

Then, you need to build the gem:

    # cd rmagick
    # gem build rmagick.gemspec

And finally install it:

    # gem install rmagick-2.13.2.gem

Note:It will show some complains like
unable to convert "\xE0" from ASCII-8BIT to UTF-8 for ext/RMagick/RMagick2.so, skipping,
but you can safelly ignore it.

> Runtime error complaining that RMagick was configured with older version

If you get the following runtime error after upgrading ImageMagick
This installation of RMagick was configured with ImageMagick 6.8.7 but ImageMagick 6.8.8-1 is in use.
then you only need to reinstall (or rebuild as shown above if is the
case).

Note:This is due to that when you install the RMagick gem it compiles
some native extensions and they may need to be rebuilt after some
ImageMagick upgrades.

> Error when installing gems: Cannot load such file -- mysql2/mysql2

If you see an error like  cannot load such file -- mysql2/mysql2, you
are having a problem with the installation of the database gem. Probably
a misconfiguration in the Database Access Configuration step. In this
case you should verify the database.yml file.

If no success, you can manually install the database gem by:

    # gem install mysql2

In last case, as suggested by Bobdog, you can try to comment the line of
the database gem and add a new one as bellow:

    <path-to-mysql2-gem-directory>/lib/mysql2/mysql2.rb


     # require 'mysql2/mysql2'
     require '<path-to-mysql2-gem-directory>/lib/mysql2/mysql2.so'

> Apache 2.4 Updating

When updating to Apache 2.4 will be necessary to remove and install all
your gems to make sure all of them that need to build native extensions
will be rebuilt against the new Apache server.

So, for a clean gems environment, remove all the gems:

    # for x in `gem list --no-versions`; do gem uninstall $x -a -x -I; done

To reinstall the gems:

    # cd /usr/share/webapps/redmine
    # gem install bundler
    # bundle install --without development test

Remember to reinstall the RMagick gem as describe above in RMagick gem
without support for High Dynamic Range in ImageMagick.

And if you are using Passenger to serve your apps through Apache you
will need to reinstall it as described above in Configure the production
server.

> Checkout SVN Source

Get the Redmine source (Download instructions). Here is method of
installing Redmine directly from subversion in /srv/http/redmine/

    # useradd -d /srv/http/redmine -s /bin/false redmine
    # mkdir -p /srv/http/redmine
    # svn checkout http://svn.redmine.org/redmine/branches/2.1-stable /srv/http/redmine
    # chown -R redmine: /srv/http/redmine

> Automating The Update Process

Example of an after-update script:

    #!/usr/bin/bash
    export RAILS_ENV=production
    grep -E "^gem 'thin'" Gemfile || echo "gem 'thin'" >> Gemfile
    bundle update && bundle exec rake generate_secret_token db:migrate redmine:plugins:migrate tmp:cache:clear tmp:sessions:clear

Note: Note that this script uses Thin as application server, so you must
change it to your needs.

> Creating a Systemd Unit

If you want to automatic run you application server when system starts,
you need to create a systemd unit file.

Note: This is not needed if you use apache or nginx with Passenger gem.
Those servers already have their own unit file, so you have only to
enable it.

Example of systemd unit file that starts redmine using Thin with redmine
user and group:

    # nano redmine.unit

    [Unit]
    Description=redmine
    After=syslog.target network.target
    [Service]
    Type=oneshot
    RemainAfterExit=yes
    EnvironmentFile=/usr/share/webapps/redmine/.env
    User=redmine
    Group=redmine
    WorkingDirectory=/usr/share/webapps/redmine
    ExecStartPre=/usr/bin/mkdir -p -m 0770 /run/redmine
    ExecStartPre=/usr/bin/chown redmine.http /run/redmine
    ExecStart=/etc/init.d/redmine start
    ExecReload=/etc/init.d/redmine restart
    ExecStop=/etc/init.d/redmine stop
    [Install]
    WantedBy=multi-user.target

Together with that, you need to create a init file as:

    # nano /etc/init.d/redmine

    #!/bin/sh
    . ~/.env
    bundle exec thin -s 2 -S /run/redmine/redmine.socket $1

And finally, you need to set the necessary environment variables to the
redmine user. If they are not already setted.

    # nano ~/.env

    PATH=$HOME/.gem/ruby/2.1.0/bin:/usr/bin
    RAILS_ENV==production

Note: This example shows a specific case, using Thin as application
server, so you must change these files to your needs.

See Also
--------

-   Official install guide from Redmine Wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Redmine&oldid=305585"

Category:

-   Version Control System

-   This page was last modified on 19 March 2014, at 12:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
