CoovaChilli
===========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Work in           
                           progress :) (Discuss)    
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Introduction
-   2 Installation
-   3 Example configuration
    -   3.1 FreeRadius
        -   3.1.1 Mysql database setup
    -   3.2 CoovaChilli
    -   3.3 daloRADIUS
-   4 Start and enable applications
-   5 Also read

Introduction
============

http://coova.org/CoovaChilli

Installation
============

Several other applications are required for an example setup of
CoovaChilli:

    $ pacman -S freeradius nginx mariadb php

From the AUR install the following two packages: daloradius and
coova-chilli.

Example configuration
=====================

Example configuration for a full and working CoovaChilli setup. Consider
eth0 is the interface for our incoming internet connection and eth1 is
the gateway interface for our unknown wifi clients and is coonnected to
various hot-spots.

FreeRadius
----------

    /etc/raddb/clients.conf

    client 127.0.0.1 {
     secret     = mysecret
    }

Adjust the following settings:

    /etc/raddb/sql.conf

            server = "localhost"
            login = "root"
            password = "xxxx"

Uncomment the following settings:

    /etc/freeradius/sites-available/default

    authorize {
              sql
    }

    accounting {
             sql
    }

Uncomment the following settings:

    /etc/freeradius/radiusd.conf

           $INCLUDE sql.conf

> Mysql database setup

Setup MariaDB and choose a password for the mysql root user.

    $ mysql -u root -p
    mysql> CREATE DATABASE radius;
    mysql> exit
    $ mysql -u root -p radius < /usr/share/nginx/html/daloradius/contrib/db/fr2-mysql-daloradius-and-freeradius.sql

CoovaChilli
-----------

    /etc/chilli/defaults

    HS_NETWORK=192.168.10.0
    HS_UAMLISTEN=192.168.10.1

    HS_RADSECRET=mysecret
    HS_UAMSECRET=uamsecret
    HS_UAMFORMAT=https://\$HS_UAMLISTEN/hotspotlogin/hotspotlogin.php
    HS_UAMHOMEPAGE=https://\$HS_UAMLISTEN

daloRADIUS
----------

    $ rm /usr/share/nginx/html/index.html
    $ cp -r /usr/share/webapps/daloradius/contrib/chilli/portal2/* /usr/share/nginx/html/

Adjust the following config values:

    /usr/share/nginx/html/daloradius/library/daloradius.conf.php

    $configValues['CONFIG_DB_PASS'] = 'xxxx';
    $configValues['CONFIG_MAINT_TEST_USER_RADIUSSECRET'] = 'mysecret';
    $configValues['CONFIG_DB_TBL_RADUSERGROUP'] = 'radusergroup';

Also in these several files:

    /usr/share/nginx/html/signup-*/library/daloradius.conf.php

    $configValues['CONFIG_DB_PASS'] = 'xxxx';
    $configValues['CONFIG_DB_NAME'] = 'radius';
    $configValues['CONFIG_DB_TBL_RADUSERGROUP'] = 'radusergroup';
    $configValues['CONFIG_SIGNUP_SUCCESS_MSG_LOGIN_LINK'] = "<br />Click <b>here</b>".
                                            " to return to the Login page and start your surfing<br /><br />";

Start and enable applications
=============================

Create a systemd service file for coova-chilli.

    $ systemctl enable nginx freeradius mysqld coova-chilli
    $ systemctl start nginx freeradius mysqld coova-chilli

Also read
=========

-   Original tutorial:
    http://linux.xvx.cz/2010/03/debian-wi-fi-hotspot-using-coovachilli-freeradius-mysql-and-daloradius/
-   List of Open Source capative portal software and network access
    control:
    https://mohammadthalif.wordpress.com/2010/12/14/list-of-open-source-captive-portal-software-and-network-access-control-nac/#comment-428

Retrieved from
"https://wiki.archlinux.org/index.php?title=CoovaChilli&oldid=306088"

Category:

-   Networking

-   This page was last modified on 20 March 2014, at 17:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
