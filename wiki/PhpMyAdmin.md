phpMyAdmin
==========

phpMyAdmin is a web-based tool to help manage MySQL databases using an
Apache/PHP frontend. It requires a working LAMP setup.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Adjust access rights                                         |
|     -   2.2 Review apache phpmyadmin configuration                       |
|     -   2.3 Add blowfish_secret passphrase                               |
|     -   2.4 Enabling Configuration Storage (optional)                    |
|         -   2.4.1 creating phpMyAdmin database                           |
|         -   2.4.2 creating phpMyAdmin database user                      |
|                                                                          |
| -   3 Accessing your phpMyAdmin installation                             |
| -   4 Lighttpd Configuration                                             |
| -   5 Nginx Configuration                                                |
| -   6 Other (Older) information                                          |
+--------------------------------------------------------------------------+

Installation
------------

Install the phpmyadmin and php-mcrypt packages:

    # pacman -S phpmyadmin php-mcrypt

Configuration
-------------

Ensure you do not have an older copy of phpMyAdmin.

    # rm -r /srv/http/phpMyAdmin

Copy the example configuration file to your httpd configuration
directory.

    # cp /etc/webapps/phpmyadmin/apache.example.conf /etc/httpd/conf/extra/httpd-phpmyadmin.conf

Add the following lines to /etc/httpd/conf/httpd.conf:

    # phpMyAdmin configuration
    Include conf/extra/httpd-phpmyadmin.conf

> Adjust access rights

To allow access from any host, edit /etc/webapps/phpmyadmin/.htaccess
and change deny from all into

    allow from all

Alternatively, you can restrict access to localhost and your local
network only. Replace 192.168.1.0/24 with your network's IP block.

    deny from all
    allow from localhost
    allow from 127.0.0.1
    allow from ::1
    allow from 192.168.1.0/24

Note:The ::1 is required when using IPv6. Otherwise you might get an
error similar to "Error 403 - Access forbidden!" when you attempt to
access your phpMyAdmin installation.

> Review apache phpmyadmin configuration

Your /etc/httpd/conf/extra/httpd-phpmyadmin.conf should have the
following information:

            Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"
            <Directory "/usr/share/webapps/phpMyAdmin">
                    AllowOverride All
                    Options FollowSymlinks
                    Order allow,deny
                    Allow from all
                    php_admin_value open_basedir "/srv/:/tmp/:/usr/share/webapps/:/etc/webapps:/usr/share/pear/"
            </Directory>

You need the mysqli and mcrypt (if you want phpMyAdmin internal
authentication) modules, so uncomment the following in /etc/php/php.ini:

    extension=mysqli.so
    extension=mcrypt.so

Restart httpd.

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
    // $cfg['Servers'][$i]['bookmarktable'] = 'pma_bookmark';
    // $cfg['Servers'][$i]['relation'] = 'pma_relation';
    // $cfg['Servers'][$i]['table_info'] = 'pma_table_info';
    // $cfg['Servers'][$i]['table_coords'] = 'pma_table_coords';
    // $cfg['Servers'][$i]['pdf_pages'] = 'pma_pdf_pages';
    // $cfg['Servers'][$i]['column_info'] = 'pma_column_info';
    // $cfg['Servers'][$i]['history'] = 'pma_history';
    // $cfg['Servers'][$i]['tracking'] = 'pma_tracking';
    // $cfg['Servers'][$i]['designer_coords'] = 'pma_designer_coords';
    // $cfg['Servers'][$i]['userconfig'] = 'pma_userconfig';
    // $cfg['Servers'][$i]['recent'] = 'pma_recent';

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
$cfg['Servers'][$i]['pmadb'] in /etc/webapps/phpmyadmin/config.inc.php,
then <pma_db> should be phpmyadmin

    GRANT SELECT, INSERT, UPDATE, DELETE ON <pma_db>.* TO 'pma'@'localhost';

Log out, and back in to ensure the new features are activated. The
message at the bottom of the main screen should now be gone.

Accessing your phpMyAdmin installation
--------------------------------------

Finally your phpmyadmin installation is complete. Before you start using
it you need to restart httpd (Apache)

You can access your phpmyadmin installation using the following url:

    http://localhost/phpmyadmin/

If you want to access it using http://localhost/phpmyadmin, open
'/etc/httpd/conf/extra/httpd-phpmyadmin.conf' and change:

    Alias /phpmyadmin/ "/usr/share/webapps/phpMyAdmin/"

to

    Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"

You should also read this thread.

If you get the error "#2002 - The server is not responding (or the local
MySQL server's socket is not correctly configured)" then you might want
to change "localhost" in /etc/webapps/phpmyadmin/config.inc.php to your
hostname:

    $cfg['Servers'][$i]['host'] = 'localhost';

If you would like to use phpmyadmin setup script by calling
http://localhost/phpmyadmin/setup you will need to create a config
directory that's writeable by the httpd in the
/usr/share/webapps/phpmyadmin as follows:

    cd /usr/share/webapps/phpMyAdmin
    mkdir config
    chgrp http config
    chmod g+w config

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

Create a symbolic link to the /usr/share/webapps/phpmyadmin directory
from whichever directory your vhost is serving files from, e.g.
/srv/http/<domain>/public_html/

     sudo ln -s /usr/share/webapps/phpMyAdmin /srv/http/<domain>/public_html/phpmyadmin

You can also setup a sub domain with a server block like so (if using
php-fpm):

     server {
             server_name     phpmyadmin.<domain.tld>;
             access_log      /srv/http/<domain>/logs/phpmyadmin.access.log;
             error_log       /srv/http/<domain.tld>/logs/phpmyadmin.error.log;
     
             location / {
                     root    /srv/http/<domain.tld>/public_html/phpmyadmin;
                     index   index.html index.htm index.php;
             }
     
             location ~ \.php$ {
                     root            /srv/http/<domain.tld>/public_html/phpmyadmin;
                     fastcgi_pass    unix:/var/run/php-fpm/php-fpm.sock;
                     fastcgi_index   index.php;
                     fastcgi_param   SCRIPT_FILENAME  /srv/http/<domain.tld>/public_html/phpmyadmin/$fastcgi_script_name;
                     include         fastcgi_params;
             }
     }

Update open_basedir in /etc/php/php.ini and add "/usr/share/webapps/".

     open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/:/etc/webapps/

You may run into some issues with phpmyadmin telling you "The
Configuration File Now Needs A Secret Passphrase" and no matter what you
enter, the error is still displayed. Try changing the ownership of the
files to the NGINX specified user/group, e.g. nginx...

     sudo chown -R http:http /usr/share/webapps/phpMyAdmin

If the above doesn't fix it try adding the following to your NGINX
Configuration below the other fastcgi_param (I think its something to do
with the Suhosin-Patch)

     fastcgi_param  PHP_ADMIN_VALUE  open_basedir="/srv/:/tmp/:/usr/share/webapps/:/etc/webapps:/usr/share/pear/";

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

Other (Older) information
-------------------------

This page holds a sample 'config.inc.php' file that you can place in the
main phpMyAdmin directory so that it immediately starts working

Things you should do first

Create a 'controluser', so that phpmyadmin can read from the main mysql
database.

    mysql -u root -p YOURROOTPASSWORD
    mysql> grant usage on mysql.* to controluser@localhost identified by 'CONTROLPASS';

Where is phpmyadmin

in phpmyadmin 3.2.2-3 the file is missing /srv/http/ create this symlik

    ln -s /usr/share/webapps/phpMyAdmin/ /srv/http/phpmyadmin

Things you should change

controluser is set to controluser   
 controlpass is set to password   
 verbose is set to name_of_server

Sample 'config.inc.php' file

    <?php
    /*
     * Generated configuration file
     * Generated by: phpMyAdmin 2.11.8.1 setup script by Michal Čihař <michal@cihar.com>
     * Version: $Id: setup.php 11423 2008-07-24 17:26:05Z lem9 $
     * Date: Mon, 01 Sep 2008 20:34:02 GMT
     */

    /* Servers configuration */
    $i = 0;

    /* Server ravi-test-mysql (http) [1] */
    $i++;
    $cfg['Servers'][$i]['host'] = 'localhost';
    $cfg['Servers'][$i]['extension'] = 'mysql';
    $cfg['Servers'][$i]['port'] = '3306';
    $cfg['Servers'][$i]['connect_type'] = 'tcp';
    $cfg['Servers'][$i]['compress'] = false;
    $cfg['Servers'][$i]['controluser'] = 'controluser';
    $cfg['Servers'][$i]['controlpass'] = 'password';
    $cfg['Servers'][$i]['auth_type'] = 'http';
    $cfg['Servers'][$i]['verbose'] = 'name_of_server';

    /* End of servers configuration */

    $cfg['LeftFrameLight'] = true;
    $cfg['LeftFrameDBTree'] = true;
    $cfg['LeftFrameDBSeparator'] = '_';
    $cfg['LeftFrameTableSeparator'] = '__';
    $cfg['LeftFrameTableLevel'] = 1;
    $cfg['LeftDisplayLogo'] = true;
    $cfg['LeftDisplayServers'] = false;
    $cfg['DisplayServersList'] = false;
    $cfg['DisplayDatabasesList'] = 'auto';
    $cfg['LeftPointerEnable'] = true;
    $cfg['DefaultTabServer'] = 'main.php';
    $cfg['DefaultTabDatabase'] = 'db_structure.php';
    $cfg['DefaultTabTable'] = 'tbl_structure.php';
    $cfg['LightTabs'] = false;
    $cfg['ErrorIconic'] = true;
    $cfg['MainPageIconic'] = true;
    $cfg['ReplaceHelpImg'] = true;
    $cfg['NavigationBarIconic'] = 'both';
    $cfg['PropertiesIconic'] = 'both';
    $cfg['BrowsePointerEnable'] = true;
    $cfg['BrowseMarkerEnable'] = true;
    $cfg['ModifyDeleteAtRight'] = false;
    $cfg['ModifyDeleteAtLeft'] = true;
    $cfg['RepeatCells'] = 100;
    $cfg['DefaultDisplay'] = 'horizontal';
    $cfg['TextareaCols'] = 40;
    $cfg['TextareaRows'] = 7;
    $cfg['LongtextDoubleTextarea'] = true;
    $cfg['TextareaAutoSelect'] = false;
    $cfg['CharEditing'] = 'input';
    $cfg['CharTextareaCols'] = 40;
    $cfg['CharTextareaRows'] = 2;
    $cfg['CtrlArrowsMoving'] = true;
    $cfg['DefaultPropDisplay'] = 'horizontal';
    $cfg['InsertRows'] = 2;
    $cfg['EditInWindow'] = true;
    $cfg['QueryWindowHeight'] = 310;
    $cfg['QueryWindowWidth'] = 550;
    $cfg['QueryWindowDefTab'] = 'sql';
    $cfg['ForceSSL'] = false;
    $cfg['ShowPhpInfo'] = false;
    $cfg['ShowChgPassword'] = false;
    $cfg['AllowArbitraryServer'] = false;
    $cfg['LoginCookieRecall'] = 'something';
    $cfg['LoginCookieValidity'] = 1800;
    ?>

Retrieved from
"https://wiki.archlinux.org/index.php?title=PhpMyAdmin&oldid=248071"

Category:

-   Web Server
