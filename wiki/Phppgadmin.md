Phppgadmin
==========

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Accessing your phpPgAdmin installation                             |
| -   4 Lighttpd Configuration                                             |
| -   5 NGINX Configuration                                                |
| -   6 Troubleshooting Access Denied (403)                                |
+--------------------------------------------------------------------------+

Installation
------------

To install phpPgAdmin, install the phppgadmin packages in Official
Repositories.

Configuration
-------------

Ensure you do not have an older copy of phppgadmin.

    rm -r /srv/http/phppgAdmin

Copy the example configuration file to your httpd configuration
directory.

    cp /etc/webapps/phppgadmin/apache.example.conf /etc/httpd/conf/extra/httpd-phppgadmin.conf

Add the following lines to /etc/httpd/conf/httpd.conf:

    # phpPgAdmin configuration
    Include conf/extra/httpd-phppgadmin.conf

Add the following lines to /etc/httpd/conf/httpd.conf:

    # Use for PHP 5.x:
    LoadModule php5_module        modules/libphp5.so
    AddHandler php5-script php

Add index.php after "DirectoryIndex index.html"

    # DirectoryIndex: sets the file that Apache will serve if a directory
    # is requested.
    #
    <IfModule dir_module>
        DirectoryIndex index.html index.php
    </IfModule>

In /usr/share/webapps/phppgadmin/.htaccess, comment out deny from all.
The line should look like this:

    #deny from all

Otherwise you'll get an error similar to "Error 403 - Access forbidden!"
when you attempt to access your phppgadmin installation.

Your /etc/httpd/conf/extra/httpd-phppgadmin.conf should have the
following information:

    Alias /phppgadmin "/usr/share/webapps/phppgadmin"
            <Directory "/usr/share/webapps/phppgadmin">
                    AllowOverride All
                    Options FollowSymlinks
                    Order allow,deny
                    Allow from all
            </Directory>

Open your /etc/php/php.ini and go to the line containing open_basedir
and add the path(s) to your phppgAdmin installation so it has the
following:

    :/usr/share/webapps/phppgadmin:/etc/webapps/

For example, mine contains the following:

    open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/phppgadmin:/etc/webapps

You need the pgsql module, so uncomment in /etc/php/php.ini:

     ;extension=pgsql.so

to

     extension=pgsql.so

Accessing your phpPgAdmin installation
--------------------------------------

Finally your phppgadmin installation is complete. Before start using it
you need to restart your apache server by following command:

    # systemctl restart httpd.service

You can access your phppgadmin installation using the following url:

    http://localhost/phppgadmin/

or

    http://localhost/phppgadmin/index.php

Note: 'localhost' is your hostname.

If you want to access it using:

    http://localhost/phppgadmin

in '/etc/httpd/conf/extra/httpd-phppgadmin.conf' change:

    Alias /phppgadmin/ "/usr/share/webapps/phppgadmin/"

to

    Alias /phppgadmin "/usr/share/webapps/phppgadmin"

Lighttpd Configuration
----------------------

The php setup for lighttpd is exactly the same as for apache. Make an
alias for phppgadmin in your lighttpd config.

     alias.url = ( "/phppgadmin" => "/usr/share/webapps/phppgadmin/")

Then enable mod_alias, mod_fastcgi and mod_cgi in your config (
server.modules section )

Update open_basedir in /etc/php/php.ini and add "/usr/share/webapps/".

     open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/

Make sure lighttpd is setup to serve php files, Lighttpd#FastCGI

Restart lighttpd and browse to http://localhost/phppgadmin/index.php

NGINX Configuration
-------------------

Also similar to apache configuration (and Lighttpd, for that matter).

Create a symbolic link to the /usr/share/webapps/phppgadmin directory
from whichever directory your vhost is serving files from, e.g.
/srv/http/<domain>/public_html/

     sudo ln -s /usr/share/webapps/phppgadmin /srv/http/<domain>/public_html/phppgadmin

You can also setup a sub domain with a server block like so (if using
php-fpm):

     server {
             server_name     phppgadmin.<domain.tld>;
             access_log      /srv/http/<domain>/logs/phppgadmin.access.log;
             error_log       /srv/http/<domain.tld>/logs/phppgadmin.error.log;
     
             location / {
                     root    /srv/http/<domain.tld>/public_html/phppgadmin;
                     index   index.html index.htm index.php;
             }
     
             location ~ \.php$ {
                     root            /srv/http/<domain.tld>/public_html/phppgadmin;
                     fastcgi_pass    unix:/var/run/php-fpm/php-fpm.sock;
                     fastcgi_index   index.php;
                     fastcgi_param   SCRIPT_FILENAME  /srv/http/<domain.tld>/public_html/phppgadmin/$fastcgi_script_name;
                     include         fastcgi_params;
             }
     }

  

Troubleshooting Access Denied (403)
-----------------------------------

You will need to edit the .htaccess file located at

      /etc/webapps/phppgsql/.htaccess

to

      Allow from <ip>

where <ip> is your current ip (or use 127.0.0.1 if you are on the same
box) and then

    # systemctl restart httpd

in order to access phppgadmin.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Phppgadmin&oldid=254958"

Category:

-   Web Server
