Tomcat and Apache
=================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Tomcat.     
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This document describes the steps needed to install Apache Tomcat. It
also optionally describes how to integrate Tomcat with the Apache Web
Server, and how to configure MySQL to work with Tomcat Servlets and
JSPs.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuring Tomcat                                                 |
|     -   2.1 THE FOLLOWING SHOULD NO LONGER BE NEEDED                     |
|                                                                          |
| -   3 Test Tomcat                                                        |
| -   4 Configure Apache                                                   |
|     -   4.1 Without mod_jk                                               |
|     -   4.2 Using mod_jk                                                 |
|                                                                          |
| -   5 Configure MySQL                                                    |
+--------------------------------------------------------------------------+

Installation
------------

Install and configure Apache as in the Apache, PHP, and MySQL tutorial.
You may install PHP and MySQL at this time if you want them.

Then install Tomcat:

    # pacman -S tomcat

Configuring Tomcat
------------------

Edit /etc/conf.d/tomcat. Replace the line

    TOMCAT_JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk \

with this one (assuming that /opt/java is your JAVA_HOME):

    TOMCAT_JAVA_HOME=/opt/java \

THE FOLLOWING SHOULD NO LONGER BE NEEDED

Edit /etc/conf.d/tomcat. Change CATALINA_USER to some user that suites
your system (like "nobody")

    modprobe capability

Now add capabilities to modules in /etc/rc.conf.

Also you may have to edit /etc/rc.d/tomcat to change the java home for
jsvc. In the "start" section you have change this line:

    -home /usr/lib/jvm/java-1.6.0-openjdk \

with this one (assuming that /opt/java is your JAVA_HOME):

    -home /opt/java \

Test Tomcat
-----------

Run in terminal (as root):

    # /etc/rc.d/tomcat start

Notice that you can check the logs in /opt/tomcat/logs/catalina.log.

Tomcat should be running. Test by visiting http://localhost:8080/ in a
web browser. You can browse the JSP and servlet examples if you like.

This is all that is needed to run Tomcat as a stand-alone server. You
can add new webapp directories to the /opt/tomcat/webapps directory.
Optionally, if you want to place webapps in a different directory, you
can make /opt/tomcat/webapps/ a symbolic link to another directory. For
example, if you wanted to place your web applications in
/home/httpd/tomcat run these commands (as root):

    # cd /opt/tomcat
    # mv webapps /home/httpd/tomcat
    # ln -s /home/httpd/tomcat/webapps webapps

You can also place symbolic links within the webapps directory.

If you wish tomcat to start on bootup:   
 Edit /opt/tomcat/bin/catalina.sh and add this line at the top:

    JAVA_HOME=/opt/java

This is needed because JAVA_HOME is not set when the daemons are started
  
 Edit /etc/rc.conf:

    DAEMONS=(some daemons now add tomcat)

Or add this line to rc.local:

    /etc/rc.d/tomcat start

Configure Apache
----------------

> Without mod_jk

If you have mod_proxy installed (default since Apache 2.0) you only need
to include two directives in your httpd.conf file for each web
application that you wish to forward to Tomcat 5. For example, to
forward an application at context path /myapp:

    ProxyPass         /myapp  http://localhost:8080/myapp
    ProxyPassReverse  /myapp  http://localhost:8080/myapp

Note: starting from Apache 2.2 included mod_proxy supports the AJP
protocol and so it's a viable alternative to mod_jk (this package). It's
far easier to configure in httpd.conf or inside a <VirtualHost>:

    ProxyPass / ajp://127.0.0.1:8009/APPNAME
    ProxyPassReverse / ajp://127.0.0.1:8009/APPNAME

Instead of / you can map APPNAME to an arbitrary web path. mod_jk
(described below) should be used only if its advanced features are
needed.

> Using mod_jk

There are two ways to install mod_jk: from AUR or from upstream. In the
latter case you should copy it to the directory /usr/lib/httpd/modules/.
Then rename the file to mod_jk.so and set it executable with

    # chmod a+x mod_jk.so

Edit /etc/httpd/conf/httpd.conf  
 Add this line to the end of the LoadModule section:

    LoadModule jk_module               modules/mod_jk.so

Add these lines below the LoadModule section:

    <IfModule jk_module>
        JkWorkersFile   /etc/httpd/conf/workers.properties
        JkShmFile       /var/run/shm.file
        JkShmSize       1048576
    </IfModule>

Create the file /etc/httpd/conf/workers.properties. It should contain
the following:

    # Define some properties
    workers.apache_log=/var/log/httpd/
    workers.tomcat_home=/opt/tomcat
    workers.java_home=/opt/java
    ps=/
    worker.list=worker2
    # Define worker's properties
    worker.worker2.type=ajp13
    worker.worker2.host=localhost
    worker.worker2.port=8009
    worker.worker2.mount=/jsp-examples /jsp-examples/*

Start Apache. Run in terminal (as root):

    # /etc/rc.d/httpd start

Only run httpd after tomcat is started (EDIT: I'm not sure if this is
true, I can restart & start tomcat and apache separately from each
other, I will just get a 'Service unavailable' in Apache if I request a
.jsp while tomcat is restarting..)

Visit http://localhost/jsp-examples The Tomcat JSP examples should be
visible.

If you want to have URLs other than examples map to tomcat, modify the
.mount attribute like

    worker.worker2.mount=/jsp-examples /jsp-examples/* /someapp /someapp/* 

to your workers.properties file. The someapp will map
http://localhost/someapp/ to /opt/tomcat/webapps/someapp/ as interpreted
by tomcat. There are more complex workers.properties configurations;
search the website for more info.
http://tomcat.apache.org/connectors-doc/reference/workers.html

Configure MySQL
---------------

Do this section only if you want to connect to MySQL from within Tomcat
or the Java environment in general.

Review the MySQL documentation and download the driver. 3.0 is a good
choice: http://www.mysql.com/products/connector-j/

Untar the driver and copy =mysql-connector-java-3.0.11-stable-bin.jar
into /opt/java/jre/lib/ext

    tar xfvz mysql-connector-java-3.0.11-stable.tar.gz
    cp mysql-connector-java-3.0.11-stable/mysql-connector-java-3.0.11-stable-bin.jar /opt/java/jre/lib/ext

Start MySQL if it isn't already running (as root):

    # /etc/rc.d/mysqld start

Test that the driver can be loaded:   
 Save this as ~TestMysql.java

        public class TestMysql {
            public static void main(String[] args) {
                try {
                    Class.forName("com.mysql.jdbc.Driver").newInstance();
                } catch (Exception e) {
                    System.out.println("The driver couldn't be loaded");
                    return;
                }
                System.out.println("The driver was loaded");
            }
        }

Compile the file:

    $ javac TestMysql.java

Run the file

    $ java -classpath :/opt/java/jre/lib/ext TestMysql

It will output "The driver was loaded" if the driver is available,
otherwise "The driver couldn't be loaded"

You should be able to use the driver using DriverManager.getConnection()
in Java programs now. It should also automatically be available to
Tomcat servlets and JSPs. See The Mysql Connector/J documentation for
more information.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tomcat_and_Apache&oldid=204941"

Category:

-   Web Server
