Owncloud
========

From Wikipedia:

ownCloud is a software suite that provides a location-independent
storage area for data (cloud storage).

The ownCloud installation and configuration mainly depends on what web
server and database you decide to run. Currently the wiki discusses the
Apache and Nginx configurations.

Contents
--------

-   1 First steps
    -   1.1 Database support
    -   1.2 Exif support
-   2 Apache configuration
    -   2.1 Installation
        -   2.1.1 Disable Webdav
    -   2.2 Custom configurations
        -   2.2.1 Filesize limitations
        -   2.2.2 Running ownCloud in a subdirectory
    -   2.3 Filling ownCloud with data
        -   2.3.1 Small files
            -   2.3.1.1 WebDav
            -   2.3.1.2 SABnzbd
        -   2.3.2 Big files
    -   2.4 Important notes
-   3 Nginx + uwsgi_php configuration
-   4 Sync Clients
-   5 Troubleshooting
    -   5.1 Self-signed certificate not accepted
    -   5.2 Can't create data directory (/path/to/dir)
    -   5.3 CSync faild to find a specific file.
    -   5.4 Seeing white page after login
    -   5.5 GUI sync client fails to connect
    -   5.6 "Can't write into apps directory"
-   6 See also

First steps
-----------

Install owncloud from the official repositories. Alternatively see the
packages available in the Arch User Repository: [1]. Uncomment
extensions in /etc/php/php.ini:

     gd.so
     intl.so
     openssl.so
     xmlrpc.so
     zip.so
     iconv.so

Database support

Depending on which database backend you are going to use uncomment
either one of the following extensions in /etc/php/php.ini:

+--------------------------+--------------------------+--------------------------+
| SQLite                   | MySQL                    | PostgreSQL               |
+==========================+==========================+==========================+
|      sqlite.so           |      mysql.so            |      pgsql.so            |
|      sqlite3.so          |      mysqli.so           |      pdo_pgsql.so        |
|      pdo_sqlite.so       |      pdo_mysql.so        |                          |
+--------------------------+--------------------------+--------------------------+

Don't forget to install the appropriate php-module for the database. In
the PostgreSQL case thats php-pgsql or for SQLite php-sqlite.

Exif support

Additionally install exif support with

     # pacman -S exiv2

and uncomment the exif.so extension in php.ini

Apache configuration
--------------------

> Installation

Set up the LAMP stack.

You will probably need to install the MDB2 pear package as well. Install
php-pear, then:

     # pear install MDB2

1.  Copy /etc/webapps/owncloud/apache.example.conf to
    /etc/httpd/conf/extra/owncloud.conf (version 6+)
2.  Add the following lines into /etc/httpd/conf/httpd.conf (the php5
    line should have already been added during the LAMP stack setup):

     Include /etc/httpd/conf/extra/owncloud.conf
     LoadModule php5_module modules/libphp5.so
     Include conf/extra/php5_module.conf

Since apache 2.4 you might need to adjust owncloud.conf and replace

       Order allow,deny
       Allow from all

with

       Require all granted

Disable Webdav

Owncloud comes with its own Webdav enabled which conflict. Owncloud
recommends to disable mod_dav and mod_dav_fs. This should be done in
/etc/httpd/conf/httpd.conf

Now restart httpd (Apache)

     # systemctl restart httpd

Open http://localhost in your browser. You should now be able to create
a user account and follow the installation wizard.

> Custom configurations

Filesize limitations

With the default configuration ownCloud only allows the upload of
filesizes less than 2MB. This can be changed by changing the following
line in /etc/php/php.ini to your liking.

Warning:As of version 4.0 this is no longer necessary! The maximum
upload size is now set via the ownCloud gui

     upload_max_filesize = 2M

As of version 4.5, upload limits are set in
/usr/share/webapps/owncloud/.htaccess. This won't work if PHP is set up
to run as CGI, so you need to change the limits in /etc/php/php.ini. You
also need to change open_basedir.

    upload_max_filesize = 512M
    post_max_size = 512M
    memory_limit = 512M
    open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/

Running ownCloud in a subdirectory

By including the default owncloud.conf in httpd.conf, owncloud will take
control of port 80 and your localhost domain. If you would like to have
owncloud run in a subdirectory, then skip the 'Include
/etc/httpd/conf/extra/owncloud.conf' line altogether and just use a
symbolic link like so:

    # ln -s /usr/share/webapps/owncloud/ /srv/http/

In that case, you'll also have to ensure /usr/share/webapps is in the
open_basedir line of php.ini, and that per-directory .htaccess files are
read by apache.

Alternatively, you could follow the standard procedure, but comment out
the VirtualHost part of the include file, and skip the
symlink/basedir/htaccess part.

> Filling ownCloud with data

Small files

WebDav

Always use WebDAV or the web interface to add new files to your
ownCloud. Otherwise they will not show up correctly, as they do not get
indexed right. No further configuration is necessary to enable WebDAV
uploads in ownCloud.

Consider installing and enabling php-apc to speed up WebDAV.

SABnzbd

When using SABnzbd, you might want to set

    folder_rename 0

in your sabnzbd.ini file, because ownCloud will scan the files as soon
as they get uploaded, preventing SABnzbd from removing UNPACKING
prefixes etc.

Big files

WebDAV isn't suitable for big files, because it fills up all the RAM and
CPU.

With the current version, it looks like, there is no good way of copying
huge amounts of data to your ownCloud.

Here's a Workaround:

Copy the files directly to your ownCloud and do a full re-scan of your
database (you could use the Re-scan filesystem add-on for example).

But beware that this will not work as easily in the future, when
end-to-end encryption gets added to ownCloud (this is a planned
feature).

> Important notes

-   When using a subdomain (like cloud.example.net), make sure it is
    covered by your certificate. Otherwise, connection via the owncloud
    client or webdav might fail.

-   If you are planning on using OwnCloud's sync-clients, make sure to
    have NTP installed and running on your OwnCloud server, otherwise
    the sync-clients will fail.

-   Add some SSL encryption to your connection!

(If adding SSL encryption as above, be sure to edit
/etc/httpd/conf/extra/httpd-ssl.conf and change DocumentRoot "/srv/http"
to DocumentRoot "/usr/share/webapps/owncloud" )

-   More Apps for ownCloud can be found here

-   To install an new application, download the zip from the apps store,
    extract it into /srv/http/owncloud/apps/.

Afterwards restart httpd:

    systemctl restart httpd

log into your server go to the app sections you should see the new apps
in there,

-   If you are protecting access to your owncloud location with HTTP
    basic auth, the file "status.php" must be excluded from auth and be
    publicly accessible. [2]

Nginx + uwsgi_php configuration
-------------------------------

You can avoid the use of Apache, and run owncloud in it's own process by
using the uwsgi-plugin-php application server. uWSGI itself has a wealth
of features to limit the resource use, and to harden the security of the
application, and by being a separate process it can run under its own
user.

-   First of all you should set up your Nginx server. See the Nginx page
    for further information.
-   Set a server with the following lines in the http section of your
    /etc/nginx/nginx.conf file:

    #this is to avoid Request Entity Too Large error
    client_max_body_size 1000M;
    # deny access to some special files
    location ~ ^/(data|config|\.ht|db_structure\.xml|README) {
        deny all;
    }
    # pass all .php or .php/path urls to uWSGI
    location ~ ^(.+\.php)(.*)$ {
        include uwsgi_params;
        uwsgi_modifier1 14;
        uwsgi_pass 127.0.0.1:3001;
    }
    # everything else goes to the filesystem,
    # but / will be mapped to index.php and run through uwsgi
    location / {
        root /usr/share/webapps/owncloud;
        index index.php;
        rewrite ^/.well-known/carddav /remote.php/carddav/ redirect;
        rewrite ^/.well-known/caldav /remote.php/caldav/ redirect;
    }

-   Then create a uWSGI config file. /etc/uwsgi/owncloud.ini could be a
    good choice:

    [uwsgi]
    socket = 127.0.0.1:3001
    master = true
    chdir = /srv/http/owncloud # This path might be changed
    php-docroot = /usr/share/webapps/owncloud
    php-index = index.php

    # only allow these php files, I don't want to inadvertently run something else
    php-allowed-ext = /index.php
    php-allowed-ext = /public.php
    php-allowed-ext = /remote.php
    php-allowed-ext = /cron.php
    #php-allowed-ext = /status.php
    php-allowed-ext = /settings/apps.php
    php-allowed-ext = /core/ajax/update.php
    php-allowed-ext = /core/ajax/share.php
    php-allowed-ext = /core/ajax/requesttoken.php
    php-allowed-ext = /core/ajax/translations.php
    php-allowed-ext = /search/ajax/search.php
    php-allowed-ext = /search/templates/part.results.php
    php-allowed-ext = /settings/admin.php
    php-allowed-ext = /settings/users.php
    php-allowed-ext = /settings/personal.php
    php-allowed-ext = /settings/help.php
    php-allowed-ext = /settings/ajax/getlog.php
    php-allowed-ext = /settings/ajax/setlanguage.php
    php-allowed-ext = /settings/ajax/setquota.php
    php-allowed-ext = /settings/ajax/userlist.php
    php-allowed-ext = /settings/ajax/createuser.php
    php-allowed-ext = /settings/ajax/removeuser.php
    php-allowed-ext = /settings/ajax/enableapp.php
    php-allowed-ext = /core/ajax/appconfig.php

    php-set = date.timezone=Etc/UTC
    php-set = open_basedir=/srv/http/owncloud:/tmp/:/usr/share/pear/:/usr/share/webapps/owncloud

    processes = 10
    cheaper = 2
    cron = -3 -1 -1 -1 -1 /usr/bin/php -f /usr/share/webapps/owncloud/cron.php 1>/dev/null

-   You can run it with:

    # uwsgi_php --ini /etc/uwsgi/owncloud.ini

-   Otherwise, a simple systemd unit file to start the uwsgi instance
    can be (this is without using the emperor):

    [Unit]
    Description=OwnCloud service via uWSGI-PHP

    [Service]
    User=http
    ExecStart=/usr/bin/uwsgi_php --ini /etc/uwsgi/owncloud.ini
    ExecReload=/bin/kill -HUP $MAINPID
    KillSignal=SIGQUIT
    Restart=always

    [Install]
    WantedBy=multi-user.target

Sync Clients
------------

The official clients can be found in this page : Sync Clients Also take
notice that while the official ownCloud android app is a paid app on the
play store, it is not a paid app on F-Droid.

Troubleshooting
---------------

> Self-signed certificate not accepted

OwnCloud uses Wikipedia:cURL and Wikipedia:SabreDAV to check if WebDAV
is enabled. If you use a SSL/TLS with a self-signed certificate, e.g. as
shown in LAMP and access ownClouds admin panel, you will see the
following error message:

    Your web server is not yet properly setup to allow files synchronization because the WebDAV interface seems to be broken.

Assuming that you followed the LAMP-tutorial, execute the following
steps:

Create local directory for non-distribution certificates and copy LAMPs
certificate there. This will prevent ca-certificates-updates to
overwrite it.

    $ cp /etc/httpd/conf/server.crt /usr/share/ca-certificates/WWW.EXAMPLE.COM.crt

Add WWW.EXAMPLE.COM.crt to /etc/ca-certificates.conf:

    WWW.EXAMPLE.COM.crt

Now, regenerate your certificate store:

    $ update-ca-certificates

Restart the httpd service to activate your certificate.

  
 Should this not work consider disabling mod_curl in /etc/php/php.ini.

> Can't create data directory (/path/to/dir)

Check your httpd conf file (like owncloud.conf). Add your data dir to

    php_admin_value open_basedir "/srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/:/path/to/dir/"

You should also modify php.ini in the same way. Restart the httpd
service to activate the change.

> CSync faild to find a specific file.

Most probably a certificate issue, recreate it, and don't leave the
common name empty or you will see the error again.

    openssl genrsa -out server.key 2048
    openssl req -new -key server.key -x509 -days 365 -out server.crt

> Seeing white page after login

The cause is probably a new app that you installed, to fix that you can
either use phpMyAdmin by editing the oc_appconfig table(in the case you
got lucky and the table has edit option) or do it by hand with mysql:

    mysql -u root -p owncloud
    MariaDB [owncloud]> delete from oc_appconfig where appid='<nameOfExtension>' and configkey='enabled' and configvalue='yes'
    MariaDB [owncloud]> insert into oc_appconfig (appid,configkey,configvalue) values ('<nameOfExtension>','enabled','no');

This should delete the relevant configuration from the table and add it
again.

> GUI sync client fails to connect

If using HTTP basic auth, make sure to exclude "status.php", which must
be publicly accessible [3]

> "Can't write into apps directory"

As mentioned in the official admin manual either you need an apps
directory that is writable by the http user, or you need to set
"appstoreenabled" to false.

Also, not mentioned there, the directory needs to be in the open_basedir
line in /etc/php/php.ini

One clean method is to have the package-installed directory at
/usr/share/webapps/owncloud/apps stay owned by root, and have the
user-installed apps go into e.g. /var/www/owncloud/apps which is owned
by http. Then you can set "appstoreenabled" to true and package upgrades
of apps should work fine as well. Relevant lines from
/etc/webapps/owncloud/config/config.php:

      'apps_paths' => 
      array (
        0 => 
        array (
          'path' => '/usr/share/webapps/owncloud/apps',
          'url' => '/apps',
          'writable' => false,
        ),
        1 => 
        array (
          'path' => '/var/www/owncloud/apps',
          'url' => '/wapps',
          'writable' => true,
        ),
      ),

Example open_basedir line from /etc/php/php.ini (you might have other
dirs in there as well):

    open_basedir = /srv/http/:/usr/share/webapps/:/var/www/owncloud/apps/

Directory permissions:

    $ ls -ld /usr/share/webapps/owncloud/apps /var/www/owncloud/apps/
    drwxr-xr-x 26 root root 4096 des.  14 20:48 /usr/share/webapps/owncloud/apps
    drwxr-xr-x  2 http http   48 jan.  20 20:01 /var/www/owncloud/apps/

See also
--------

-   ownCloud official website
-   ownCloud 6.0 Admin Documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=Owncloud&oldid=305003"

Category:

-   Web Server

-   This page was last modified on 16 March 2014, at 10:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
