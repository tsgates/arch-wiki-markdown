Wordpress
=========

> Summary

Wordpress is an easy to setup and administer FLOSS content management
system featuring a strong and vibrant community with thousands of
plugins and themes.

> Related

LAMP

PHP

MySQL

phpMyAdmin

Wordpress is the goto Free Libre Open Source Software (FLOSS) content
management system (CMS) created by Matt Mullenweg and first released in
2003. Wordpress has a vast and vibrant community that provides tens of
thousands of free plugins and themes to allow the user to easily
customize the appearance and function of their Wordpress CMS. Wordpress
is licensed under the GPLv2.

The biggest feature of Wordpress is its ease in configuration and
administration. Setting up a Wordpress site takes five minutes. The
Wordpress administration panel allows users to easily configure almost
every aspect of their website including fetching and installing plugins
and themes. Wordpress provides effortless automatic updates.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Installation using pacman                                    |
|     -   1.2 Manual install                                               |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Host config                                                  |
|     -   2.2 Configure apache                                             |
|     -   2.3 Configure MySQL                                              |
|         -   2.3.1 Using phpMyAdmin                                       |
|                                                                          |
| -   3 Wordpress Installation                                             |
| -   4 Usage                                                              |
|     -   4.1 Installing a theme                                           |
|         -   4.1.1 Using the admin panel                                  |
|                                                                          |
|     -   4.2 Installing a plugin                                          |
|     -   4.3 Updating                                                     |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 Appearance is broken (no styling)                            |
|                                                                          |
| -   6 Tips and tricks                                                    |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Wordpress also requires PHP and MySQL to be installed and configured.
See the LAMP wiki article for more information.

Note:As of August 2012, this article does not support using Wordpress
with PostrgreSQL. Wordpress was designed to be used with mysql only. It
is possible to use Wordpress with other databases such as PostgreSQL,
through the use of a plugin and a bit of work.

> Installation using pacman

Install wordpress from the official repositories.

Warning:While it is easier to let pacman manage updating your Wordpress
install, this is not necessary. Wordpress has functinality built-in for
managing updates, themes, and plugins. If you decide to install the
official community package, you will not be able to install plugins and
themes using the Wordpress admin panel without a needlessly complex
permissions setup, or logging into FTP as root. pacman does not delete
the Wordpress install directory when uninstalling it from your system
regardless of whether or not you have added data to the directory
manually or otherwise.

> Manual install

Go to wordpress.org and download the latest version of Wordpress and
extract it to your webserver directory. Give the directory enough
permissions to allow your FTP user to write to the directory (used by
Wordpress).

    cd /srv/http/whatever
    wget https://wordpress.org/latest.tar.gz
    tar xvzf latest.tar.gz

Configuration
-------------

The configuration method used here assumes you are using Wordpress on a
local network.

> Host config

Make sure your /etc/hosts file is setup correctly. This will be
important when accessing your Wordpress CMS from a local network. Your
/etc/hosts file should look something like the following,

    #<ip-address>   <hostname.domain.org>   <hostname>
    127.0.0.1       lithium.kaboodle.net    localhost lithium
    ::1             lithium.kaboodle.net    localhost lithium

Note:You will need to use a proxy server to access your Wordpress
installation from mobile devices if you plan on using hostnames to
install Wordpress, otherwise your website will appear broken #Appearance
is broken (no styling).

> Configure apache

You will need to create a config file for apache to find your Wordpress
install. Create the following file and edit it your favorite text
editor:

    # /etc/httpd/conf/extra/httpd-wordpress.conf

    Alias /wordpress "/usr/share/webapps/wordpress"
    <Directory "/usr/share/webapps/wordpress">
    	AllowOverride All
    	Options FollowSymlinks
    	Order allow,deny
    	Allow from all
    	php_admin_value open_basedir "/srv/:/tmp/:/usr/share/webapps/:/etc/webapps:$"
    </Directory>

Change /wordpress in the first line to whatever you want. For example,
/myblog would require that you navigate to http://hostname/myblog to see
your Wordpress website.

Also change the paths to your Wordpress install folder in case you did a
manual install. Don't forget to append the parent directory to the
php_admin_value variable as well as shown below.

    # /etc/httpd/conf/extra/httpd-wordpress.conf

    Alias /myblog "/mnt/data/srv/wordpress"
    <Directory "/mnt/data/srv/wordpress">
    	AllowOverride All
    	Options FollowSymlinks
    	Order allow,deny
    	Allow from all
    	php_admin_value open_basedir "/srv/:/tmp/:/usr/share/webapps/:/etc/webapps:/mnt/data/srv:$"
    </Directory>

Next edit the apache config file and add the following:

    # /etc/httpd/conf/httpd.conf

    ...
    Include conf/extra/httpd-wordpress.conf
    ...

Now restart httpd (Apache).

> Configure MySQL

MySQL can be configured using a plethora of tools, but the most common
are the command line or phpMyAdmin.

Using phpMyAdmin

See phpMyAdmin to install and configure phpMyAdmin.

In your web browser, navigate to your phpMyAdmin host and perform the
following steps:

1.  Login to phpMyAdmin.
2.  Click "user" and then click "Add user".
3.  Give the pop up window a name and a password.
4.  Select "Create database with same name and grant all privileges".
5.  Click the "Add user" button to create the user.

Wordpress Installation
----------------------

Once you have spent a couple of hours setting up your http server, php,
and mysql, it is finally time to let Wordpress have its five minutes and
install itself. So let us begin.

The Wordpress installation procedure will use the URL in the address
field of your web browser as the default website URL. If you have
navigated to http://localhost/wordpress, your website will be accessible
from your local network, but it will be broken in appearance and
function.

1.  Navigate to http://hostname/wordpress.
2.  Click the "Create a Configuration File" button.
3.  Click the "Let's go!" button.
4.  Fill in you database information created in the previous section
5.  Click "Submit".

If you installed Wordpress from the Official repository, then this setup
procedure will not have the correct permissions to create the
wp-config.php file used by Wordpress. You will have to do this step
yourself as root using information Wordpress will provide.

A page will appear saying Wordpress can not write the wp-config.php
file. Copy the text in the edit box and open
/usr/share/webapps/wordpress/wp-config.php as root in your text editor.
Paste the copied text into the editor and save the file.

Finally, Click "Run the install" and Wordpress will populate the
database with your information. Once complete, you will be shown
"Success!" page. Click the login button to finish your installation.

Now would be a good time to access your website from all your devices to
be sure your Wordpress installation is setup correctly.

Usage
-----

> Installing a theme

There are tens of thousands of themes available for Wordpress. Searching
on google for a good theme can be like wading through a river filled
with trash. Good places for looking for themes include Smashing Magazine
and the official Wordpress theme website. There is also pay for theme
sites like Woo Themes and The Theme Factory.

Using the admin panel

Before installing a theme using the admin panel, you will need to setup
an FTP server on your Wordpress host.

Once the FTP server is setup, login to your Wordpress installation and
click "Appearance->Install Themes->Upload". From there select your zip
file that contains your theme and click "Install Now". You will be
presented with a box asking for FTP information, enter it and click
"Proceed". If you have been following along closely, you should now have
an installed theme. Activate it if you wish.

> Installing a plugin

The steps for installing a plugin are the same as they are for
installing a theme. Just click the "Plugins" link in the left navigation
bar and follow the steps. Wordpress is very easy to use.

> Updating

Every now and then when you log into wordpress there will be a
notification informing you of updates. If you have correctly installed
and configured an FTP client, and have the correct filesystem
permissions to write in the Wordpress install path then you should be
able to perform updates at the click of a button. Just follow the steps.

Troubleshooting
---------------

> Appearance is broken (no styling)

Your Wordpress website will appear to have no styling to it when viewing
it in a web browser (desktop or mobile) that does not have its hostnames
mapped to ip addresses correctly.

This occurs because you used a url with the hostname of your server,
instead of an ip address, when doing the initial setup and Wordpress has
used this as the default website URL.

To fix this, you will either need to edit your /etc/hosts file or setup
a proxy server. For an easy to setup proxy server, see Polipo, or if you
want something with a little more configuration, see Squid.

Another option is changing a value in the database table of your
Wordpress, specifically the wp_options table. The fix is to change the
siteurl option to point directly to the domain name and not "localhost".

Tips and tricks
---------------

See also
--------

-   Wordpress
-   Content management system

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wordpress&oldid=255623"

Category:

-   Web Server
