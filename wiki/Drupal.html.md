Drupal
======

"Drupal is a free and open source content management system (CMS) and
Content Management framework (CMF) written in PHP and distributed under
the GNU General Public License." - Wikipedia

This article describes how to setup Drupal and configure Apache, MySQL
or PostgreSQL, PHP, and Postfix to work with it. It is assumed that you
have some sort of LAMP (Apache, MySQL, PHP) or LAPP (Apache, PostgreSQL,
PHP) server already setup.

Contents
--------

-   1 Installation
    -   1.1 Arch repositories
    -   1.2 Manual install
    -   1.3 Installing GD
    -   1.4 Installing Postfix
-   2 Tips and tricks
    -   2.1 Scheduling with Cron
    -   2.2 Xampp Compatibility
    -   2.3 Upload progress not enabled
-   3 Troubleshooting
    -   3.1 Browser shows the actual PHP code when visiting localhost
    -   3.2 Setup page is not the initial page when accessing localhost
    -   3.3 Setup page does not start and shows HTTP ERROR 500
-   4 See also

Installation
------------

> Arch repositories

Install the drupal package from the official repositories.

Edit /etc/php/php.ini:

-   If PHP version is less than 5.2.0, Find the line with
    ;extension=json.so and uncomment it by removing the ";" from the
    beginning of the line if necessary. If no such line is found, add it
    to the [PHP] section of the file.
-   For Drupal 7, enable a PDO extension for your database. For MySQL,
    the line extension=pdo_mysql.so should be uncommented.
-   Find the line beginning with open_basedir =. Add the Drupal install
    directories, /usr/share/webapps/drupal/ and /var/lib/drupal/.
    /srv/http/ can be removed if you do not intend to use it.

Edit /etc/httpd/conf/httpd.conf:

-   If your webserver is dedicated to Drupal, find the line
    DocumentRoot "/srv/http" and change it to the Drupal install
    directory, i.e. DocumentRoot "/usr/share/webapps/drupal", then find
    the section that starts with "<Directory "/srv/http">" and change
    /srv/http to the Drupal install directory,
    /usr/share/webapps/drupal. In the same section, make sure it
    includes a line "AllowOverride All" to enable the clean URL's.
-   If you are using Apache Virtual Hosts, see Apache#Virtual_Hosts.

  
 Finally comment out the deny from all line of the
/usr/share/webapps/drupal/.htaccess file to enable httpd access and
restart Apache (httpd).

> Manual install

Download the latest package from http://drupal.org and extract it. Move
the folders to Apache's htdocs folder. Open a web browser, and navigate
to [localhost localhost]. Follow the on-screen instructions.

> Installing GD

You may need the GD library for your Drupal installation. First install
the php-gd package. Edit /etc/php/php.ini. Find the line with
;extension=gd.so and uncomment it by removing the ";". If no such line
is found, add it to the [PHP] section of the file. Restart Apache
(httpd).

> Installing Postfix

In order to send e-mails with Drupal, you will need to install Postfix.
Drupal uses e-mails for account verification, password recovery, etc.
First install postfix.

1.  Edit Postfix configuration file /etc/postfix/main.cf as needed. All
    that you should have to do is change the hostnames under "Internet
    Host and Domain Names" myhostname = hostname1
2.  Start the Postfix service: # systemctl start postfix.
3.  Send a test e-mail to yourself: mail myusername@localhost. Enter a
    subject, some words in the body, then press Ctrl+d to exit and send
    the letter. Wait 10 seconds, and then type mail to check your mail.
    If you've gotten it, excellent.
4.  Make sure port 25 is fowarded if you have a router so that mails can
    be sent to the Internet at large
5.  Edit the file /etc/php/php.ini. Find the line that starts with,
    ;sendmail_path="" and change it to
    sendmail_path="/usr/sbin/sendmail -t -i"
6.  Restart the Apache web server.

Tips and tricks
---------------

> Scheduling with Cron

Drupal recommends running cron jobs hourly. Cron can be executed from
the browser by visiting [localhost/cron localhost/cron]. It is also
possible to run cron via script by copying the appropriate file from the
"scripts" folder into /etc/cron.hourly and making it executable.

> Xampp Compatibility

The 5.x and 6.x series of Drupal do not support PHP 5.3, and as a result
are incompatible with the latest release of Xampp. Currently, the last
Drupal-compatible version of Xampp is 1.7.1.

Note: Xampp's PHP memory limit currently defaults to 8MB. Also, Xampp
ignores php.ini files in the Drupal directory. To fix this:

1.  Edit Xampp's configuration file /opt/lampp/etc/php.ini using your
    favorite editor.
2.  Search for the "memory_limit" line, and replace it with an
    appropriate value. Most Drupal installations just need 32MB, but
    sites with a lot of modules may need 100MB or more.
3.  Restart Xampp: /opt/lampp/lampp restart

> Upload progress not enabled

Upon successful installation you may see the following message in the
Status Report:

    Your server is capable of displaying file upload progress, but does not have the required libraries. It is recommended to install the PECL uploadprogress library (preferred) or to install APC.

First, install the php-pear package. Next, use the pecl command to
automatically download, compile and install the library:

    # pecl install uploadprogress

Finally, add to /etc/php/php.ini

    extension=uploadprogress.so

Restart Apache.

Troubleshooting
---------------

> Browser shows the actual PHP code when visiting localhost

You do not have php-apache installed.

Then, enable the PHP module in /etc/httpd/conf/httpd.conf by adding the
following lines in the appropriate sections:

    LoadModule php5_module modules/libphp5.so
    Include conf/extra/php5_module.conf

If, when starting httpd, you get the following error:

    httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1 for ServerName

You should edit /etc/httpd/conf/httpd.conf. In that file find the line
that looks similar to

    #ServerName www.example.com:80

Uncomment it (remove # from the front) and adjust the address as needed.
Restart httpd:

    # systemctl restart httpd

> Setup page is not the initial page when accessing localhost

In this situation, you should navigate in your /srv directory and look
for the drupal folder (most probably it will be in the http directory).
Then edit /etc/httpd/conf/httpd.conf. and look for a line starting with
DocumentRoot and change the path with that folder's path (for example
DocumentRoot "/srv/http/drupal") and also find another line starting
with <Directory and set the same path there as well. Restart httpd.

> Setup page does not start and shows HTTP ERROR 500

This may be because Drupal needs the json.so extension to be activated
in your /etc/php/php.ini. Just uncomment in /etc/php/php.ini the line:

    ;extension=json.so

Restart httpd service.

See this link for info.

See also
--------

-   Official Drupal documentation
-   Simple guide to install Drupal on Xampp
-   LAMP (How to setup an Apache server)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Drupal&oldid=289025"

Category:

-   Web Server

-   This page was last modified on 17 December 2013, at 20:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
