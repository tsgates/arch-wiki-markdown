phpMyAdmin
==========

phpMyAdmin is a web-based tool to help manage MySQL databases using an
Apache/PHP frontend. It requires a working LAMP setup.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Apache
    -   2.2 PHP
    -   2.3 phpMyAdmin configuration
    -   2.4 Add blowfish_secret passphrase
    -   2.5 Enabling Configuration Storage (optional)
        -   2.5.1 creating phpMyAdmin database
        -   2.5.2 creating phpMyAdmin database user
-   3 Accessing your phpMyAdmin installation
-   4 Lighttpd Configuration
-   5 Nginx Configuration

Installation
------------

Install the phpmyadmin and php-mcrypt packages from the official
repositories.

Configuration
-------------

> Apache

Note:The following works (at least no obvious problems) with Apache 2.4
and php-apache/mod_mpm_prefork or php-fpm/mod_proxy_handler

Set up Apache to use php as outlined in the LAMP article.

Create the Apache configuration file:

    # /etc/httpd/conf/extra/httpd-phpmyadmin.conf

    Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"
    <Directory "/usr/share/webapps/phpMyAdmin">
        DirectoryIndex index.html index.php
        AllowOverride All
        Options FollowSymlinks
        Require all granted
    </Directory>

And include it in /etc/httpd/conf/httpd.conf:

    # phpMyAdmin configuration
    Include conf/extra/httpd-phpmyadmin.conf

By default, everyone can see the phpMyAdmin page, to change this, edit
/etc/httpd/conf/extra/httpd-phpmyadmin.conf to your liking. For example,
if you only want to be able to access it from the same machine, replace
Require all granted by Require local.

> PHP

You need to enable the mysqli and mcrypt (if you want phpMyAdmin
internal authentication) extensions in PHP by editing /etc/php/php.ini
and uncommenting the following lines:

    extension=mysqli.so
    extension=mcrypt.so

You need to make sure that PHP can access /etc/webapps. Add it to
open_basedir in /etc/php/php.ini if necessary:

    open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/:/etc/webapps

> phpMyAdmin configuration

phpMyAdmin's configuration file is located at
/etc/webapps/phpmyadmin/config.inc.php. If you have a local MySQL
server, it should be usable without making any modifications.

If your MySQL server is not on the localhost, uncomment and edit the
following line:

    $cfg['Servers'][$i]['host'] = 'localhost';

If you would like to use phpMyAdmin setup script by calling
http://localhost/phpmyadmin/setup you will need to create a config
directory that's writeable by the httpd user in
/usr/share/webapps/phpMyAdmin as follows:

    # cd /usr/share/webapps/phpMyAdmin
    # mkdir config
    # chgrp http config
    # chmod g+w config

> Add blowfish_secret passphrase

If you see the following error message at the bottom of the page when
you first log in to /phpmyadmin (using a previously setup MySQL username
and password) :

    ERROR: The configuration file now needs a secret passphrase (blowfish_secret)

You need to add a blowfish password to the phpMyAdmin's config file.
Edit /etc/webapps/phpmyadmin/config.inc.php and insert a random blowfish
"password" in the line

    $cfg['blowfish_secret'] = ; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */

Go here to get a nicely generated blowfish_secret and paste it between
the marks. It should now look something like this:

    $cfg['blowfish_secret'] = 'qtdRoGmbc9{8IZr323xYcSN]0s)r$9b_JUnb{~Xz'; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */

The error should go away if you refresh the phpmyadmin page.

> Enabling Configuration Storage (optional)

Now that the basic database server has been setup, it is functional,
however by default, extra options such as table linking, change
tracking, PDF creation, and bookmarking queries are disabled. You will
see a message at the bottom of the main phpMyAdmin page, "The phpMyAdmin
configuration storage is not completely configured, some extended
features have been deactivated. To find out why...", This section
addresses how to to enable these extra features.

Note:This example assumes you want to use the username pma as the
controluser, and pmapass as the controlpass. These should be changed
(the very least, you should change the password!) to something more
secure.

In /etc/webapps/phpmyadmin/config.inc.php, uncomment (remove the leading
"//"s on) these two lines, and change them to your desired credentials:

    // $cfg['Servers'][$i]['controluser'] = 'pma';
    // $cfg['Servers'][$i]['controlpass'] = 'pmapass';

You will need this information later, so keep it in mind.

Beneath the controluser setup section, uncomment these lines:

    /* Storage database and tables */
    // $cfg['Servers'][$i]['pmadb'] = 'phpmyadmin';
    // $cfg['Servers'][$i]['bookmarktable'] = 'pma__bookmark';
    // $cfg['Servers'][$i]['relation'] = 'pma__relation';
    // $cfg['Servers'][$i]['table_info'] = 'pma__table_info';
    // $cfg['Servers'][$i]['table_coords'] = 'pma__table_coords';
    // $cfg['Servers'][$i]['pdf_pages'] = 'pma__pdf_pages';
    // $cfg['Servers'][$i]['column_info'] = 'pma__column_info';
    // $cfg['Servers'][$i]['history'] = 'pma__history';
    // $cfg['Servers'][$i]['table_uiprefs'] = 'pma__table_uiprefs';
    // $cfg['Servers'][$i]['tracking'] = 'pma__tracking';
    // $cfg['Servers'][$i]['designer_coords'] = 'pma__designer_coords';
    // $cfg['Servers'][$i]['userconfig'] = 'pma__userconfig';
    // $cfg['Servers'][$i]['recent'] = 'pma__recent';
    // $cfg['Servers'][$i]['users'] = 'pma__users';
    // $cfg['Servers'][$i]['usergroups'] = 'pma__usergroups';
    // $cfg['Servers'][$i]['navigationhiding'] = 'pma__navigationhiding';

Next, create the user with the above details. Don't set any permissions
for it just yet.

Note:If you can't login to phpmyadmin, make sure that your mysql server
is started.

creating phpMyAdmin database

Using the phpMyAdmin web interface: Import
/usr/share/webapps/phpMyAdmin/examples/create_tables.sql from phpMyAdmin
-> Import. or Using command line:
mysql -u root -p < /usr/share/webapps/phpMyAdmin/examples/create_tables.sql.

creating phpMyAdmin database user

Now to apply the permissions to your controluser, in the SQL tab, make
sure to replace all instances of 'pma' and 'pmapass' to the values set
in config.inc.php. If you are setting this up for a remote database,
then you must also change 'localhost' to the proper host:

    GRANT USAGE ON mysql.* TO 'pma'@'localhost' IDENTIFIED BY 'pmapass';
    GRANT SELECT (
        Host, User, Select_priv, Insert_priv, Update_priv, Delete_priv,
        Create_priv, Drop_priv, Reload_priv, Shutdown_priv, Process_priv,
        File_priv, Grant_priv, References_priv, Index_priv, Alter_priv,
        Show_db_priv, Super_priv, Create_tmp_table_priv, Lock_tables_priv,
        Execute_priv, Repl_slave_priv, Repl_client_priv
        ) ON mysql.user TO 'pma'@'localhost';
    GRANT SELECT ON mysql.db TO 'pma'@'localhost';
    GRANT SELECT ON mysql.host TO 'pma'@'localhost';
    GRANT SELECT (Host, Db, User, Table_name, Table_priv, Column_priv)
        ON mysql.tables_priv TO 'pma'@'localhost';

In order to take advantage of the bookmark and relation features, you
will also need to give pma some additional permissions:

Note:as long as you did not change the value of
cfg['Servers'][i]['pmadb'] in /etc/webapps/phpmyadmin/config.inc.php,
then <pma_db> should be phpmyadmin

    GRANT SELECT, INSERT, UPDATE, DELETE ON <pma_db>.* TO 'pma'@'localhost';

Log out, and back in to ensure the new features are activated. The
message at the bottom of the main screen should now be gone.

Accessing your phpMyAdmin installation
--------------------------------------

Your phpMyAdmin installation is now complete. Before you start using it
you need to restart Apache.

You can access your phpMyAdmin installation by going to
http://localhost/phpmyadmin/

Lighttpd Configuration
----------------------

Configurating Lighttpd is similar to Apache. Make sure Lighttpd is setup
to serve PHP files (see Lighttpd).

Make an alias for phpmyadmin in your Lighttpd config.

     alias.url = ( "/phpmyadmin" => "/usr/share/webapps/phpMyAdmin/")

Then enable mod_alias, mod_fastcgi and mod_cgi in your config (
server.modules section )

Update open_basedir in /etc/php/php.ini and add "/usr/share/webapps/".

     open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/:/etc/webapps/

Restart Lighttpd and go to [1].

Nginx Configuration
-------------------

Configurating Nginx is similar to Apache (and Lighttpd, for that
matter). Make sure Nginx is setup to serve PHP files (see Nginx).

You can setup a sub domain (or domain) with a server block like so (if
using php-fpm):

     server {
             server_name     phpmyadmin.<domain.tld>;
     
             root    /usr/share/webapps/phpMyAdmin;
             index   index.php;
     
             location ~ \.php$ {
                     try_files      $uri =404;
                     fastcgi_pass   unix:/var/run/php-fpm/php-fpm.sock;
                     fastcgi_index  index.php;
                     include        fastcgi.conf;
             }
     }

To access this url on your localhost, you can simply add an entry in
/etc/hosts:

     127.0.0.1	phpmyadmin.<domain.tld>

You need to update PHP's open_basedir option to add the appropriate
directories. Either in /etc/php/php.ini:

     open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/:/etc/webapps/

Or if running php-fpm with a separate entry for phpmyadmin, you can
overwrite this value in your pool definition (in /etc/php/fpm.d/<pool
file>):

     php_admin_value[open_basedir] = /tmp/:/usr/share/webapps/:/etc/webapps/

If the above doesn't fix it try adding the following to your NGINX
Configuration below the other fastcgi_param (I think its something to do
with the Suhosin-Patch)

     fastcgi_param  PHP_ADMIN_VALUE  open_basedir="/srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/:/etc/webapps/";

While you can enter anything for the blowfish password, you may want to
choose a randomly generated string of characters (most likely for
security reasons). Here's a handy tool that will do that for you on the
web[2].

When using SSL, you might run into the problem that the links on the
pages generated by phpMyAdmin incorrectly start with "http" instead of
"https" which may cause errors. To fix this, you can add the following
fcgi_param to your SSL-enabled server section (in addition to your usual
fastcgi params):

     fastcgi_param HTTPS on;

Retrieved from
"https://wiki.archlinux.org/index.php?title=PhpMyAdmin&oldid=303728"

Category:

-   Web Server

-   This page was last modified on 9 March 2014, at 09:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
