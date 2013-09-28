Installing Sugarcrm Community Edition
=====================================

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

SugarCRM is a web based CRM solution written in PHP. SugarCRM is
available in different flavors. There are “Community” (free),
“Professional”, and “Enterprise” editions. For a detailed overview of
the different editions, see the SugarCRM website. This page is a guide
on the installation of the free Community Edition.

-   You can find the latest edition of this how-to at:

    http://cihan.me/installing-sugarcrm-community-edition-on-arch-linux/

1. Install unzip and mysql:

    # pacman -S unzip mysql mysql-clients

2. Start the mysqld:

    /etc/rc.d/mysqld start

3. Add mysqld to your /etc/rc.conf, in the DAEMONS array. For more
information read: Daemons. Here is an example:

    # DAEMONS=(!syslog-ng network lighttpd sshd vsftpd mysqld)

  
 4. Stop the mysqld daemon:

    # /etc/rc.d/mysqld stop

5. Connect to mysql server:

    # mysql -u root mysql

6. Define a root password:

    mysql> UPDATE user SET password=PASSWORD(”Your_Password_Here”) WHERE User=’root’;

    mysql> FLUSH PRIVILEGES;

    mysql> exit

Then restart the mysqld daemon:

    # /etc/rc.d/mysqld restart

7. Create a user and database for Sugarcrm, with necessary privileges:

    $ mysql -u root -p
    Enter password:

After logging in, create a database:

    mysql> create database sugarcrm;
    Query OK, 1 row affected (0.00 sec)

Allow user sugarcrm to connect to the server from localhost using a
password :

    mysql> grant usage on *.* to sugarcrm@localhost identified by ‘yourpassword’;
    Query OK, 0 rows affected (0.00 sec)

Grant all privileges on the sugarcrm database to user
sugarcrm@localhost:

    mysql> grant all privileges on sugarcrm.* to sugarcrm@localhost ;
    Query OK, 0 rows affected (0.00 sec)

8. Install apache and php unless already installed:

    # pacman -S apache php php-apache

9. Next configure Apache and Php. First create the user http unless
already present:

    # useradd http

10. Add this line to /etc/hosts (If the hosts file doesn’t exist, create
it.):

    127.0.0.1  localhost.localdomain   localhost

Note: If you want a different hostname, append it to the end:

    127.0.0.1  localhost.localdomain   localhost myhostname

11.Edit /etc/rc.conf:

If you set a hostname, the HOSTNAME variable should be the same;
otherwise, use “localhost”:

    #
    # Networking
    #
    HOSTNAME=”localhost”

12. Make sure the hostname appears in /etc/hosts or apache will fail to
start. Alternatively, you can edit /etc/httpd/conf/httpd.conf as root
and comment the following module:

    LoadModule unique_id_module        modules/mod_unique_id.so

It should now appear as:

    #LoadModule unique_id_module        modules/mod_unique_id.so

13. Run the following in a terminal as root to start the HTTP server:

    # /etc/rc.d/httpd start

14. Apache should now be running. Test by visiting http://localhost/ in
a web browser. It should display a simple Apache test page.

15. To start Apache automatically at boot, edit /etc/rc.conf as root and
add the httpd daemon:

    DAEMONS=(… httpd …)

Or add this line to /etc/rc.local:

    /etc/rc.d/httpd start

16. Add these line in /etc/httpd/conf/httpd.conf:

    LoadModule php5_module modules/libphp5.so
    Include conf/extra/php5_module.conf

Note: The “Include” can not be directly after the “LoadModule” line in
the configuration file, it need to be down with the other “Includes”. [
edit: it works with includes following loadmodule ]

17. If your DocumentRoot is outside of /home/, add it to open_basedir in
/etc/php/php.ini as such:

    open_basedir = /home/:/tmp/:/usr/share/pear/:/path/to/documentroot

Suggestion - Add your document root as follows: this is the default

    open_basedir = /srv/http:/home/:/tmp/:/usr/share/pear/

18. Restart the Apache service to make changes take effect (as root):

    # /etc/rc.d/httpd restart

19. If you have any problems, edit your /etc/httpd/conf/httpd.conf file
with the following information:

    # nano /etc/httpd/conf/httpd.conf

20. Within <IfModule mime_module>

    AddType application/x-httpd-php .php
    AddType application/x-httpd-php-source .phps

21. Restart Apache

    # /etc/rc.d/httpd restart

22. Set the memory_limit is at least 64M and set the upload_max_filesize
to 20M on php.ini:

    #vim /etc/php/php.ini

    [...]
    memory_limit = 128M      ; Maximum amount of memory a script may consume (128MB)
    [...]
    ; Maximum allowed size for uploaded files.
    upload_max_filesize = 20M
    [...]

23. /etc/rc.d/httpd restart

24. Add a file handler for .phtml if you need it in
/etc/httpd/conf/extra/php5_module.conf:

    DirectoryIndex index.php index.phtml index.html

25. To enable the libGD module, uncomment in /etc/php/php.ini:

    ;extension=gd.so

to

    extension=gd.so

26. To enable the mcrypt module, uncomment in /etc/php/php.ini:

    ;extension=mcrypt.so

to

    extension=mcrypt.so

27. Make sure you have libmcrypt installed:

    # pacman -S libmcrypt

28. There have been issues with getting mcrypt to work with php if you
don’t have libtool installed, so install it:

    # pacman -S libtool

29. Edit /etc/php/php.ini (this is in /usr/etc on older systems) to
uncomment the following line (By removing ;):

    ;extension=mysql.so

30. Install basic tables and secure at mysql:

    # sudo /usr/bin/mysql_install_db

    # sudo /usr/bin/mysql_secure_installation

31. Start the mysql daemon (as root):

    # /etc/rc.d/mysqld start

32. Make a directory named sugarcrm under /srv/http/sugarcrm, download
the installation file of sugarcrm, unzip it, move to the directory
/srv/http/sugarcrm and then change the ownership:

    # mkdir /srv/http/sugarcrm
    # cd /tmp
    # wget -c http://www.sugarforge.org/frs/download.php/5446/SugarCE-5.2.0e.zip
    # unzip SugarCE-5.2.0e.zip
    # cd SugarCE-Full-5.2.0e/
    # mv * /srv/http/sugarcrm/
    # chown -R http:http /srv/http/sugarcrm/

33. Start the webbased SugarCRM installer by opening the URL

    http://localhost/sugarcrm/install.php

34. The SugarCRM setup wizard comes up:

35. Scroll down and click on the Next button:

36. Accept the license (GPL) and click on Next:

37. Select Typical Install and click on Next:

38. Select the database type (MySQL):

39. On the Database Configuration page, fill in a name for the SugarCRM
database (sugarcrm). The Host Name is localhost. Then fill in the
username of the MySQL administrator (root) and his MySQL password
(yourrootsqlpassword). Then scroll down…

40. Select Define user to create from the drop-down menu to create a
MySQL user for SugarCRM (this user will be created by the setup wizard).
Fill in a name for that user (sugarcrm) and the password. If you want to
have some demo data to play with, select Yes from the Populate Database
with Demo Data. Click on Next.

41. Next fill in a password for the SugarCRM admin user (username is
admin):

42. Select your locale and currency settings:

43. You should now see a summary of your selected options. If
everything’s ok, click on Install:

44. Now you should now see the SugarCRM login screen. Fill in admin as
the username and the password you specified in the setup wizard. That’s
all. Enjoy it.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_Sugarcrm_Community_Edition&oldid=198564"

Category:

-   Office
