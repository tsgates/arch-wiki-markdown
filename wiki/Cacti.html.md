Cacti
=====

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: some rc.d        
                           scripts are still        
                           mentioned (Discuss)      
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: excessive usage  
                           of bullet points;        
                           instructions do not      
                           comply with Help:Style   
                           (specifically:           
                           Help:Style#Package_manag 
                           ement_instructions       
                           and                      
                           Help:Style#Daemon_operat 
                           ions)                    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This article describes how to set up Cacti on an Arch Linux system.
Cacti is a web-based system monitoring and graphing solution.

Contents
--------

-   1 Server Setup
-   2 Cacti Setup
-   3 Web Configuration
-   4 See Also
-   5 External Links

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

    # systemctl start mysqld
    # systemctl start snmpd

-   Ensure mysqld and snmpd will run at boot:

    # systemctl enable mysqld
    # systemctl enable snmpd

-   Apache HTTPD setup:

-   Create a new httpd config file, /etc/httpd/conf/extra/cacti.conf
    with the following contents:

    /etc/httpd/conf/extra/cacti.conf

    Alias /cacti /usr/share/webapps/cacti

    <Directory /usr/share/webapps/cacti>
            Options +FollowSymLinks
            AllowOverride All
            order allow,deny
            allow from all

            AddType application/x-httpd-php .php

            <IfModule mod_php5.c>
                    php_flag magic_quotes_gpc Off
                    php_flag short_open_tag On
                    php_flag register_globals Off
                    php_flag register_argc_argv On
                    php_flag track_vars On
                    # this setting is necessary for some locales
                    php_value mbstring.func_overload 0
                    php_value include_path .
            </IfModule>

            DirectoryIndex index.php
    </Directory>

-   Edit /etc/httpd/conf/httpd.conf. At the end of the file, include
    cacti.conf:

    # Include conf/extra/cacti.conf

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
"https://wiki.archlinux.org/index.php?title=Cacti&oldid=289670"

Category:

-   Status monitoring and notification

-   This page was last modified on 20 December 2013, at 21:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
