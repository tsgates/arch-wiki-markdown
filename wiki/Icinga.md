Icinga
======

  Summary
  ----------------------------------------------------------------------------------------------------
  A short installation and configuration guide for the service and network monitoring program Icinga

Icinga is an open source host, service and network monitoring program.
It monitors specified hosts and services, alerting you to any developing
issues, errors or improvements. This article describes the installation
and configuration of Icinga.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Icinga Configuration                                               |
| -   3 Webserver Configuration                                            |
|     -   3.1 Additional Nginx Configuration                               |
|                                                                          |
| -   4 Icinga-web                                                         |
|     -   4.1 Configure IDOUtils                                           |
|     -   4.2 Configure WebServer                                          |
|         -   4.2.1 Configure PHP                                          |
|         -   4.2.2 Confiure Database                                      |
|             -   4.2.2.1 Mysql                                            |
|                                                                          |
|     -   4.3 Finally                                                      |
|                                                                          |
| -   5 Upgrade database                                                   |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Follow Install Web Application Package

Before you install the package create the user icinga:icinga with these
commands:

    # groupadd -g 667 icinga
    # useradd -u 667 -g icinga -G http -d /dev/null -s /bin/false icinga

Install icinga from the AUR.

Users may also want to install nagios-plugins.

Icinga Configuration
--------------------

Copy the sample config files as root:

     # cd /etc/icinga
     # cp cgi.cfg.sample cgi.cfg
     # cp resource.cfg.sample resource.cfg
     # cp icinga.cfg.sample icinga.cfg
     # cp objects/commands.cfg.sample objects/commands.cfg
     # cp objects/contacts.cfg.sample objects/contacts.cfg
     # cp objects/localhost.cfg.sample objects/localhost.cfg
     # cp objects/templates.cfg.sample objects/templates.cfg
     # cp objects/timeperiods.cfg.sample objects/timeperiods.cfg

Edit /etc/icinga/resource.cfg

     $USER1$=/usr/share/nagios/libexec

Webserver Configuration
-----------------------

Create htpasswd.users file with a username and password.

     # htpasswd -c /etc/icinga/htpasswd.users icingaadmin

If you define another user foo, you need grant access permission to that
user. Edit /etc/icinga/cgi.cfg

     authorized_for_system_information=icingaadmin,foo
     authorized_...
     ...

> Additional Nginx Configuration

Configure Authentication

     location /icinga/ {
       auth_basic              "Restricted";
       auth_basic_user_file    /etc/icinga/htpasswd.users;
     }

Configure CGI

       location ~ \.cgi$ {
         fastcgi_pass    unix:/var/run/fcgiwrap.sock;
         include        fastcgi.conf;
         fastcgi_param  AUTH_USER          $remote_user;
         fastcgi_param  REMOTE_USER        $remote_user;
       }

Icinga-web
----------

> Follow Install Web Application Package

Install icinga-web from the AUR.

> Configure IDOUtils

     # cd /etc/icinga
     # mv idomod.cfg-sample idomod.cfg
     # mv ido2db.cfg-sample ido2db.cfg
     
     ! Database Setup
     
     (Mysql)
     $ mysql -u root -p
     > CREATE USER 'icinga' IDENTIFIED BY 'icinga';
     > CREATE DATABASE icinga;
     > GRANT USAGE ON icinga.* TO 'icinga'@'localhost' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0;
     > GRANT SELECT , INSERT , UPDATE , DELETE, DROP, CREATE VIEW, INDEX
      ON icinga.* TO 'icinga'@'localhost';
     > FLUSH PRIVILEGES;
     > quit
     
     $ mysql -u root -p icinga < /usr/share/icinga/idoutils/db/mysql/mysql.sql

> Configure WebServer

Example config files are located at

     /etc/icinga-web/apache.example.conf
     /etc/icinga-web/nginx.example.conf

Configure PHP

Edit /etc/php.ini

     open_basedir = ...:/usr/share/icinga-web:/var/cache/icinga-web:/var/log/icinga
     extension=pdo_mysql.so
     extension=xsl.so
     extension=sockets.so

Confiure Database

Mysql

     ! Create database and grants.
     # mysql -u root -p
     > CREATE USER 'icinga_web' IDENTIFIED BY 'icinga_web';
     > CREATE DATABASE icinga_web;
     > GRANT USAGE ON icinga_web.* TO 'icinga_web'@'localhost' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0;
     > GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX ON icinga_web.* TO 'icinga_web'@'localhost';
     > quit
      
     ! Import the schema.
     # mysql -u root -p icinga_web < /usr/share/icinga-web/etc/schema/mysql.sql

> Finally

     ! Start IDOUtils
     # systemctl start ido2db
       
     ! Start Icinga
     # systemctl start icinga
       
     ! Start Mysql
     # systemctl start mysqld
       
     ! Start Web Server
     # systemctl start httpd or nginx
       
     ! goto http://localhost/icinga-web
     > login with 'root' and 'password'

Upgrade database
----------------

A new version usually requires an upgrade of the database. You find the
sql upgrade scripts in

     /usr/share/icinga/idoutils/db/mysql/upgrade
     /usr/share/icinga-web/etc/schema/updates/mysql

Commands to upgrade with these scripts are

     # mysql -u root -p icinga < ./mysql-upgrade-1.8.0.sql 
     # mysql -u root -p icinga_web < ./mysql_v1-7-2_to_v1-8-0.sql
     # systemctl --system daemon-reload
     # systemctl restart icinga

See also
--------

-   icinga.org Official website
-   Nagios Plugins the home of the official plugins
-   wikipedia.org Wikipedia article
-   NagiosExchange overview of plugins, addons, mailing lists for Icinga

Retrieved from
"https://wiki.archlinux.org/index.php?title=Icinga&oldid=252887"

Categories:

-   Status monitoring and notification
-   Networking
