Zabbix
======

Summary help replacing me

This article explains how to install and configure Zabbix.

> Related

Munin

Graphite

Nagios

Cacti

Monit

Icinga

Zenoss

Zabbix is a full-featured monitoring solution for larger networks. It
can discover all kind of networking devices using different methods,
check machine states and applications, sending pre-defined alarm
messages and visualize complex data correlations.

Contents
--------

-   1 Server setup
    -   1.1 Installation
    -   1.2 Configuration
    -   1.3 Starting
-   2 Agent (Client) setup
    -   2.1 Installation
    -   2.2 Configuration
    -   2.3 Starting
-   3 See also

Server setup
------------

> Installation

If you want to use the Zabbix server with MariaDB, install
zabbix-server-mysql from the AUR. For PostgreSQL as database backend,
you should use zabbix-server. You also have to choose a web server with
PHP support, e.g.:

-   Apache
-   Lighttpd
-   NginX

Or one of the other servers found in the web server category. You may
edit the PKGBUILDs if you plan to use Nginx as web-server, since by
default they have apache and php-apache as dependency.

> Configuration

Symlink the Zabbix web application directory to your http document root,
e.g.:

    ln -s /usr/share/webapps/zabbix /var/www

Make sure to adjust following variables to these minimal values in your
php.ini:

    /etc/php/php.ini

    extension=bcmath.so
    extension=gd.so
    extension=sockets.so
    post_max_size = 16M
    max_execution_time = 300
    max_input_time = 300
    date.timezone = "UTC"

In this example, we create on localhost a MariaDB database called zabbix
for the user zabbix identified by the password test and then import the
database templates. This connection will be later used by the Zabbix
server and web application:

    mysql -u root -p -e "create database zabbix"
    mysql -u root -p -e "grant all on zabbix.* to zabbix@localhost identified by 'test'"
    mysql -u zabbix -p zabbix < /etc/zabbix/database/schema.sql
    mysql -u zabbix -p zabbix < /etc/zabbix/database/images.sql
    mysql -u zabbix -p zabbix < /etc/zabbix/database/data.sql

Adjust database settings in zabbix_server.conf:

    /etc/zabbix/zabbix_server.conf

    DBHost=mysql.local
    DBName=zabbix
    DBUser=zabbix
    DBPassword=test

> Starting

To enable the and start server process, run:

    systemctl enable zabbix-server
    systemctl start zabbix-server

Finally you can access Zabbix via your local web server, e.g.:
http://127.0.0.1/zabbix , finish the installation wizard and access the
frontend the first time. The default username is Admin and password
zabbix.

See appendix for a link to the official documentation, which explains
all further steps in using it.

Agent (Client) setup
--------------------

> Installation

Currently, the server package already includes zabbix-agent, so you
don't have to install this package on your monitoring server. However,
for monitoring targets, the client part is more minimal, standalone and
easy to deploy, just install zabbix-agent.

> Configuration

Simply edit the zabbix_agentd.conf and replace the server variable with
the IP of your monitoring server. Only servers from this/these IP will
be allowed to access the agent.

    /etc/zabbix/zabbix_agentd.conf

    Server=127.0.0.1
    ServerActive=

Further make sure the port 10050 on your device being monitored isn't
blocked and is properly forwarded.

> Starting

To enable and start the agent, run:

    systemctl enable zabbix-agentd
    systemctl start zabbix-agentd

See also
--------

-   Official manual for version 2.0

Retrieved from
"https://wiki.archlinux.org/index.php?title=Zabbix&oldid=306103"

Category:

-   Status monitoring and notification

-   This page was last modified on 20 March 2014, at 17:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
