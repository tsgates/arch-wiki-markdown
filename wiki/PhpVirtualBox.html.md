PhpVirtualBox
=============

  
 phpVirtualBox is an open source, AJAX implementation of the VirtualBox
user interface written in PHP. As a modern web interface, it allows you
to access and control remote VirtualBox instances. Much of its verbage
and some of its code is based on the (inactive) vboxweb project.
phpVirtualBox was designed to allow users to administer VirtualBox in a
headless environment - mirroring the VirtualBox GUI through its web
interface.

Contents
--------

-   1 Installation
    -   1.1 VirtualBox web service
    -   1.2 VirtualBox web interface (phpvirtualbox)
-   2 Configuration
    -   2.1 Web service
    -   2.2 Web interface
-   3 Running
-   4 Debugging
-   5 External Resources

Installation
------------

To remotely control virtual machine you need two components: VirtualBox
web service, running in the same OS with virtual machine, and web
interface, written in PHP and therefore dependent on PHP-capable web
server. Communication between them, based on SOAP protocol is currently
unencrypted, so it is recommended to install both on the same machine if
you do not want your username and password to be send via network as
clear text.

> VirtualBox web service

To use the web console, you must install virtualbox-ext-oracle package
from AUR.

> VirtualBox web interface (phpvirtualbox)

Install phpvirtualbox from Official repositories on a php-capable web
server of your choice (Apache is suitable choice).

Configuration
-------------

From here on out, it is assumed that you have a web server (with root at
/srv/http) and php functioning properly.

> Web service

In virtual machine settings, enable the remote desktop access and
specify a port different with other virtual machines.

Every time you need to make machine remotely available execute something
like this:

    vboxwebsrv -b --logfile path to log file --pidfile /run/vbox/vboxwebsrv.pid --host 127.0.0.1

As user whom account you want service to be running from (--host option
is not necessary if you enabled association with localhost in the
/etc/host.conf).

Note:This user must be in group vboxusers!

virtualbox is available in community and it's contains the
vboxweb.service for systemd.

For start vboxweb from non-root user you must:

1. Create or add a user in the group vboxusers (for example, vbox)

2. Create your custom vboxweb_mod.service file by copy
/usr/lib/systemd/system/vboxweb.service to
/etc/systemd/system/vboxweb_mod.service

3. Modify /etc/systemd/system/vboxweb_mod.service like this:

     [Unit]
     Description=VirtualBox Web Service
     After=network.target

     [Service]
     Type=forking
     PIDFile=/run/vboxweb/vboxweb.pid
     ExecStart=/usr/bin/vboxwebsrv --pidfile /run/vboxweb/vboxweb.pid  --background
     User=vbox
     Group=vboxusers

     [Install]
     WantedBy=multi-user.target

4. Create tmpfile rule for your vboxweb_mod.service

    # echo "d /run/vboxweb 0755 vbox vboxusers" > /etc/tmpfiles.d/vboxweb_mod.conf

5. Create manually /run/vboxweb directory for first start
vboxweb_mod.service

    # mkdir /run/vboxweb
    # chown vbox:vboxusers /run/vboxweb
    # chmod 755 /run/vboxweb

or just reboot your system for automatically create.

6. Start vboxweb_mod.service

    # systemctl start vboxweb_mod

and enable it if nessesary

    # systemctl enable vboxweb_mod

> Web interface

Edit /etc/php/php.ini, make sure the following lines are uncommented.

    extension=json.so  ; this module is built into php as of version 5.4 and so will not exist or need to be uncommented
    extension=soap.so

Edit the example configuration file
/usr/share/webapps/phpvirtualbox/config.php-example appropriately (it is
well-commented and does not need explanations). Copy that file into
/etc/webapps/phpvirtualbox/config.php and symlink to
/usr/share/webapps/phpvirtualbox/config.php.

If you are running Apache as webserver, you can copy
/etc/webapps/phpvirtualbox/apache.example.conf into
/etc/httpd/conf/extra/phpvirtualbox.conf, and then add following line
into /etc/httpd/conf/httpd.conf:

    Include conf/extra/phpvirtualbox.conf

Edit /etc/webapps/phpvirtualbox/.htaccess and remove the following line.

    deny from all

Don't forget to restart the webserver like this (example for Apache):

systemctl restart httpd

Running
-------

If everything works fine, visit
http://YourVboxWebInterfaceHost/phpvirtualbox and it should show a login
box. The initial username and password are both "admin", after login
change them from the web interface (File -> change password). If you set
$noAuth=true in the web interface config.php, you should immediately see
the phpvirtualbox web interface.

Debugging
---------

If you encounter a login problem, and you have upgraded virtualbox from
3.2.x to 4.0.x, you should run the following command to update you
websrvauthlibrary in you virtualbox configuration file which has been
changed from VRDPAuth.so to VBOXAuth.so.

    VBoxManage setproperty vrdeauthlibrary default
    VBoxManage setproperty websrvauthlibrary default 

If you are still unable to login into the interface, you can try to
disable webauth by

    VBoxManage setproperty websrvauthlibrary null

on virtualization server and set username and password to empty strings
and set $noAuth=true in /etc/webapps/phpvirtualbox/config.php on web
server. By doing this, you should immediatelly access the web interface
without login process. And then, maybe you can try some apache access
control.

External Resources
------------------

-   PHPVirtualBox Home Page
-   Manage your VirtualBox VMs via the web with phpVirtualBox
-   systemd vboxweb.service mod when needing to start as non-root user

Retrieved from
"https://wiki.archlinux.org/index.php?title=PhpVirtualBox&oldid=301582"

Category:

-   Virtualization

-   This page was last modified on 24 February 2014, at 11:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
