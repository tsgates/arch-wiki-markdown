Drupal
======

  
 "Drupal is a free and open source content management system (CMS) and
Content Management framework (CMF) written in PHP and distributed under
the GNU General Public License." - Wikipedia

This article describes how to setup Drupal and configure Apache, MySQL
or PostgreSQL, PHP, and Postfix to work with it. It is assumed that you
have some sort of LAMP (Apache, MySQL, PHP) or LAPP (Apache, PostgreSQL,
PHP) server already setup.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Installing Drupal                                            |
|         -   1.1.1 from Arch repositories                                 |
|         -   1.1.2 manual install                                         |
|                                                                          |
|     -   1.2 Installing GD                                                |
|     -   1.3 Installing Postfix                                           |
|                                                                          |
| -   2 Tips and Tricks                                                    |
|     -   2.1 Scheduling with Cron                                         |
|     -   2.2 Xampp Compatibility                                          |
|     -   2.3 Upload progress Not enabled                                  |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 Browser shows the actual PHP code when visiting localhost    |
|     -   3.2 Drupal's setup page is not the initial page when accessing   |
|         localhost                                                        |
|     -   3.3 Drupal's setup page does not start and shows HTTP ERROR 500  |
|                                                                          |
| -   4 More Resources                                                     |
+--------------------------------------------------------------------------+

Installation
------------

> Installing Drupal

from Arch repositories

1.  Install the drupal package from community using pacman.
2.  Edit /etc/php/php.ini:
    -   If PHP version is less than 5.2.0, Find the line with
        ";extension=json.so" and uncomment it by removing the ";" from
        the beginning of the line if necessary. If no such line is
        found, add it to the [PHP] section of the file.
    -   For Drupal 7, enable a PDO extension for your database. For
        MySQL, the line extension=pdo_mysql.so should be uncommented.
    -   Find the line beginning "open_basedir =". Add the Drupal install
        directories, /usr/share/webapps/drupal/ and /var/lib/drupal/.
        /srv/http/ can be removed if you do not intend to use it.

3.  Edit /etc/httpd/conf/httpd.conf:
    -   If your webserver is dedicated to drupal,
        -   Find the line DocumentRoot "/srv/http" and change it to the
            Drupal install directory, i.e.
            DocumentRoot "/usr/share/webapps/drupal".
        -   Find the section that starts with "<Directory "/srv/http">"
            and change /srv/http to the Drupal install directory,
            /usr/share/webapps/drupal. In the same section, make sure it
            includes a line "AllowOverride All" to enable the clean
            URL's.

    -   If you are using Apache Virtual Hosts, see Apache#Virtual_Hosts.

4.  Comment out the 'deny from all' line of the
    /usr/share/webapps/drupal/.htaccess file to enable httpd access.
5.  Restart Apache (httpd).

manual install

1.  Download the latest package from http://drupal.org and extract it.
2.  Move the folders to apache's htdocs folder.
3.  Open a web browser, and navigate to "localhost"
4.  Follow the on-screen instructions.

> Installing GD

You may need the GD library for your Drupal installation.

1.  Install the php-gd package using pacman.
2.  Edit /etc/php/php.ini. Find the line with ;extension=gd.so and
    uncomment it by removing the ";". If no such line is found, add it
    to the [PHP] section of the file.
3.  Restart Apache (httpd).

> Installing Postfix

In order to send e-mails with Drupal, you will need to install postfix.
Drupal uses e-mails for account verification, password recovery, etc.

1.  Install Postfix

        # pacman -S postfix 

2.  Configure Postfix as needed

        # nano /etc/postfix/main.cf 

    All that you should have to do is change the hostnames under
    "Internet Host and Domain Names"

         myhostname = hostname1 

      
    And then start the Postfix service:

        # rc.d start postfix

3.  Send a test e-mail to yourself

         mail myusername@localhost 

    (Enter a subject, some words in the body, then press ctrl+d to exit
    and send the letter) Wait 10 seconds, and then type mail to check
    your mail. If you've gotten it, excellent.

4.  Make sure Port 25 is fowarded if you have a router so that mails can
    be sent to the Internet at large
5.  Open the file /etc/php/php.ini with your editor of choice, e.g.

        # nano /etc/php/php.ini

    Find the line that starts with, ;sendmail_path="" and change it to
    sendmail_path="/usr/sbin/sendmail -t -i"

6.  Restart the Apache web server

        rc.d restart httpd

Tips and Tricks
---------------

> Scheduling with Cron

Drupal recommends running cron jobs hourly. Cron can be executed from
the browser by visiting localhost/cron It is also possible to run cron
via script by copying the appropriate file from the "scripts" folder
into /etc/cron.hourly and making it executable.

> Xampp Compatibility

The 5.x and 6.x series of Drupal do not support PHP 5.3, and as a result
are incompatible with the latest release of Xampp. Currently, the last
Drupal-compatible version of Xampp is 1.7.1.

Note: Xampp's PHP memory limit currently defaults to 8MB. Also, Xampp
ignores php.ini files in the Drupal directory. To fix this:

1.  edit Xampp's php.ini file using your favorite editor.

        nano /opt/lampp/etc/php.ini

2.  Search for the "memory_limit" line, and replace it with an
    appropriate value. (Most Drupal installations are happy with 32M,
    but sites with a lot of modules may need 100M or more.)
3.  Restart Xampp.

        /opt/lampp/lampp restart

> Upload progress Not enabled

Upon successful installation you may see the following message in the
Status Report:

Your server is capable of displaying file upload progress, but does not
have the required libraries. It is recommended to install the PECL
uploadprogress library (preferred) or to install APC.

  
 First, install the php-pear package:

    # pacman -S php-pear

Next, use the pecl command to automatically download, compile and
install the library:

    # pecl install uploadprogress

Finally, add to /etc/php/php.ini

    extension=uploadprogress.so

Restart apache.

Troubleshooting
---------------

> Browser shows the actual PHP code when visiting localhost

You do not have php-apache installed.

    # pacman -S php-apache

Then, enable the PHP module in /etc/httpd/conf/httpd.conf by adding the
following lines in the appropriate sections:

    LoadModule php5_module modules/libphp5.so
    Include conf/extra/php5_module.conf

If, when starting httpd, you get the following error:

    httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1 for ServerName

You should edit httpd.conf

    # nano /etc/httpd/conf/httpd.conf

In that file find the line that looks similar to

    #ServerName www.example.com:80

Uncomment it (remove # from the front) and adjust the address as needed.
Restart httpd by

    # /etc/rc.d/httpd restart

or

    # rc.d restart httpd

and you are ready to go!

> Drupal's setup page is not the initial page when accessing localhost

In this situation, you should navigate in your /srv directory and look
for the drupal folder (most probably it will be in the http directory).
Then edit httpd.conf by

    # nano /etc/httpd/conf/httpd.conf

and look for a line starting with DocumentRoot and change the path with
that folder's path (for me it looks like DocumentRoot
"/srv/http/drupal") and also find another line starting with

    <Directory

and set the same path there as well. Restart httpd by

    # rc.d restart httpd

and you will be done.

> Drupal's setup page does not start and shows HTTP ERROR 500

This may be because Drupal needs the json.so extension to be activated
in your /etc/php/php.ini. just uncomment the line ;extension=json.so
from /etc/php/php.ini by deleting the initial ';' and restart httpd
service by typing rc.d restart httpd. (See this link for info.)

More Resources
--------------

-   Official Drupal Documentation
-   Simple Guide to Install Drupal on Xampp
-   LAMP (How to setup an apache server)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Drupal&oldid=239497"

Category:

-   Web Server
