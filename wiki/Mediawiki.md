Mediawiki
=========

Note: If you are using xampp, instead of LAMP, there are different steps
you need to take after installing. More info here

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Web server                                                   |
|         -   2.1.1 Apache                                                 |
|         -   2.1.2 Nginx                                                  |
|         -   2.1.3 Lighttpd                                               |
|                                                                          |
|     -   2.2 LocalSettings.php                                            |
|                                                                          |
| -   3 Tips and tricks                                                    |
|     -   3.1 Mathematics (texvc)                                          |
|     -   3.2 Unicode                                                      |
+--------------------------------------------------------------------------+

Installation
------------

You need to have a web server installed, configured to be able to use
php. You can follow the LAMP guide for that purpose.

Install the php-gd, php-intl, php-xcache and mediawiki, all available
from the official repositories.

Instead of mysql you can use sqlite (which requires php-sqlite and
sqlite) or postgresql.

Note:Since PHP 5.1.0, SQLite depends on PDO. You should uncomment the
following line in your php.ini if you wish to use SQLite with Mediawiki:
extension1=pdo_sqlite.so

Configuration
-------------

First, adjust the open_basedir in /etc/php/php.ini to include the
webapps directory (allows update.php to be run from the command line):

    /etc/php/php.ini

    open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/

Then, still on /etc/php/php.ini, look for the Dynamic Extensions section
and uncomment ;extension=gd.so, uncomment ;extension=intl.so and add
extension=xcache.so.

Now do the steps corresponding to your web server.

> Web server

Apache

Create /etc/webapps/mediawiki/httpd-mediawiki.conf from the provided
example apache.example.conf in the same directory. Edit it to remove the
php_admin_value open_basedir line, which is already in php.ini.

-   Add the following lines to /etc/httpd/conf/httpd.conf

    LoadModule php5_module modules/libphp5.so
    Include conf/extra/php5_module.conf
    Include /etc/webapps/mediawiki/httpd-mediawiki.conf

-   Adjust permissions in /usr/share/webapps/mediawiki/.htaccess, e.g.
    to

    allow from all

Restart the httpd.service daemon.

Nginx

To get MediaWiki working with Nginx, create the following file:

    /etc/nginx/mediawiki.conf


    location / {
       index index.php;
       try_files $uri $uri/ @mediawiki;
    }
    location @mediawiki {
       rewrite ^/(.*)$ /index.php?title=$1&$args;
    }
    location ~ \.php5?$ {
       include fastcgi.conf;
       fastcgi_pass php;
    }
    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
       try_files $uri /index.php;
       expires max;
       log_not_found off;
    }
    # Restrictions based on the .htaccess files
    location ^~ ^/(cache|includes|maintenance|languages|serialized|tests|images/deleted)/ {
       deny all;
    }
    location ^~ ^/(bin|docs|extensions|includes|maintenance|mw-config|resources|serialized|tests)/ {
       internal;
    }
    location ^~ /images/ {
       try_files $uri /index.php;
    }
    location ~ /\. {
       access_log off;
       log_not_found off; 
       deny all;
    }

Ensure that php-fpm is installed, and in your /etc/nginx/nginx.conf
file, ensure that you have an upstream directive named php, similar to
this one:

    /etc/nginx/nginx.conf

    upstream php {
       server unix:/var/run/php-fpm/php-fpm.sock;
    }

Include a server directive, similar to this

    /etc/nginx/nginx.conf

    server {
      listen 80;
      server_name mediawiki;
      root /usr/share/webapps/mediawiki;
      index index.php;
      charset utf-8;
    # For correct file uploads
      client_max_body_size    100m; # Equal or more than upload_max_filesize in /etc/php/php.ini
      client_body_timeout     60;
      include mediawiki.conf;

    }

Lighttpd

You should have Lighttpd installed and configured. "mod_alias" and
"mod_rewrite" in server.modules array of lighttpd is required. Append to
the lighttpd configuration file the following lines

    /etc/lighttpd/lighttpd.conf

    alias.url += ("/mediawiki" => "/usr/share/webapps/mediawiki/")
    url.rewrite-once += (
                    "^/mediawiki/wiki/upload/(.+)" => "/mediawiki/wiki/upload/$1",
                    "^/mediawiki/wiki/$" => "/mediawiki/index.php",
                    "^/mediawiki/wiki/([^?]*)(?:\?(.*))?" => "/mediawiki/index.php?title=$1&$2"
    )

Restart the lighttpd.service daemon.

> LocalSettings.php

Open the wiki url (is http://your_server/mediawiki/) in a browser and do
the initial setup to create LocalSettings.php. Then save it to
/usr/share/webapps/mediawiki/LocalSettings.php.

Tips and tricks
---------------

> Mathematics (texvc)

Usually installing texvc package and enabling it in config are enough:

    $wgUseTeX = true;

If you get problems, try to increase limits for shell commands:

     $wgMaxShellMemory = 8000000;
     $wgMaxShellFileSize = 1000000;
     $wgMaxShellTime = 300;

> Unicode

Check that php, apache and mysql uses UTF-8. Otherwise you may face
strange bugs because of encoding mismatch.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mediawiki&oldid=254751"

Category:

-   Web Server
