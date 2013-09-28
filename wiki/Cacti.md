Cacti
=====

This article describes how to set up Cacti on an Arch Linux system.
Cacti is a web-based system monitoring and graphing solution.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Server Setup                                                       |
| -   2 Cacti Setup                                                        |
| -   3 Web Configuration                                                  |
| -   4 See Also                                                           |
| -   5 External Links                                                     |
+--------------------------------------------------------------------------+

Server Setup
------------

This article assumes that you already have a working LAMP (Linux,
Apache, MySQL, PHP) server. If you do not have a web-server set up
already, you can follow these instructions to do so.

Cacti Setup
-----------

The following should all be performed as root.

-   Install the necessary programs

    # pacman -S cacti php-snmp

-   Edit /etc/php/php.ini

-   Uncomment the following lines:

    ;extension=mysql.so
    ;extension=sockets.so
    ;extension=snmp.so

-   Comment the following line:

    open_basedir=...

-   Uncomment and set the following:

    ;date.timezone =

-   Start mysqld and snmpd if they're not already running:

    # /etc/rc.d/mysqld start
    # /etc/rc.d/snmpd start

-   Add mysqld and snmdp to the DAEMONS array in /etc/rc.conf to ensure
    that they're running at bootup

-   Edit /etc/httpd/conf/httpd.conf

-   Inside the <Directory "/srv/http"> block, ensure that you have the
    following line:

    AllowOverride All

-   MySQL setup

-   Create the cacti database, load the tables, and set the user. You
    will be asked for the MySQL root password for each of these
    commands.

    # mysqladmin -u root -p create cacti
    # mysql -u root -p cacti < /usr/share/webapps/cacti/cacti.sql
    # mysql -u root -p
      mysql> GRANT ALL ON cacti.* TO cacti@localhost IDENTIFIED BY 'some_password';
      mysql> FLUSH PRIVILEGES;
      mysql> exit

Note: As of march 2011 (mysql 5.5.9-1, cacti 0.8.7g-1) mysql fails to
import the SQL due to an outdated syntax. You can update the file using
this command:

    cd /usr/share/webapps/cacti && mv cacti.sql cacti.sql.org && sed s/TYPE=/ENGINE=/g cacti.sql.org > cacti.sql

-   Edit /usr/share/webapps/cacti/include/config.php. The password was
    specified in the previous step.

    $database_username = "cacti";
    $database_password = "some_password";

-   Clean up cacti directory

    # chown -R http:http /usr/share/webapps/cacti/{rra,log}
    # rm /usr/share/webapps/cacti/.htaccess
    # chmod +x /usr/share/webapps/cacti/{cmd,poller}.php /usr/share/webapps/cacti/lib/ping.php

-   Optionally, install cacti-spine, a faster poller for cacti, from the
    AUR. Use the same password as in previous steps.

-   Edit /etc/spine.conf

    DB_User cacti
    DB_Pass some_password

-   Set up cron job to run poller every 5 minutes

    # crontab -e

-   Add the following to the end of the list

    */5 * * * * /usr/bin/sudo -u http /usr/bin/php /usr/share/webapps/cacti/poller.php &> /dev/null

-   Restart cron and apache

    # /etc/rc.d/crond restart
    # /etc/rc.d/httpd restart

Web Configuration
-----------------

Open up a browser and go to http://your_ip/cacti. You should be welcomed
with the cacti installer.

-   Click Next
-   Select New Install and click Next
-   Ensure that all paths are ok. You need to specify versions of
    RRDTool and NET-SNMP. Get RRDTool Utility Version using 'rrdtool
    -v', and'net-snmp-config --version' for NET-SNMP. Click Finish.
    -   If any paths are invalid, you'll need to figure out why. Check
        the apache error logs for hints.

-   Login with username "admin" and password "admin".
-   Change the password as requested, click Save.
-   (Optional) If you chose to install spine, follow these instructions
    to set it up.
    -   Click on Settings, on the left panel of the Console tab.
    -   Select the Poller tab.
    -   Change Poller Type to spine.
    -   Adjust any other settings on the page as desired, then click
        Save.
    -   Select the Paths tab.
    -   Set Spine Poller File Path to /usr/bin/spine and click Save.

See Also
--------

-   LAMP - Set up a LAMP server

External Links
--------------

-   http://cacti.net

Retrieved from
"https://wiki.archlinux.org/index.php?title=Cacti&oldid=240559"

Category:

-   Status monitoring and notification
