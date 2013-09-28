Odbc
====

  ------------------------ ------------------------ ------------------------
  [Tango-go-next.png]      This article or section  [Tango-go-next.png]
                           is a candidate for       
                           moving to Open Database  
                           Connectivity.            
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Open Database Connectivity, commonly ODBC, is an open specification for
providing application developers with a predictable API with which to
access Data Sources

This document shows how to set up unixODBC in Arch, first to access your
database on your localhost and then extends the steps to configure MySQL
to allow remote access through ODBC.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 MySQL, ODBC with OpenOffice Setup on LocalHost                     |
|     -   1.1 Packages To Install                                          |
|     -   1.2 Configure the ini Files                                      |
|     -   1.3 Create A Symbolic Link                                       |
|     -   1.4 Create A Test Database                                       |
|     -   1.5 Testing the ODBC                                             |
|     -   1.6 A Couple Useful Websites                                     |
|                                                                          |
| -   2 MySQL, ODBC with OpenOffice Setup on the Remote Server             |
|     -   2.1 Edit odbc.ini                                                |
|     -   2.2 Edit my.cnf                                                  |
|     -   2.3 Verify Port 3306 is Listening                                |
|     -   2.4 Permissions on MySQL for Remote Connection                   |
|     -   2.5 Testing the ODBC                                             |
|     -   2.6 Miscellaneous                                                |
+--------------------------------------------------------------------------+

MySQL, ODBC with OpenOffice Setup on LocalHost
----------------------------------------------

> Packages To Install

Start by installing the unixodbc and myodbc

    # pacman -S unixodbc myodbc

> Configure the ini Files

Configure the "odbc.ini" and "odbcinst.ini" file. Starting with
odbcinst.ini, which lists all installed drivers. Su to root and set up
your /etc/odbcinst.ini file as follows

    [MySQL]
    Description     = ODBC Driver for MySQL
    Driver          = /usr/lib/libmyodbc.so
    Setup           = /usr/lib/libodbcmyS.so
    FileUsage       = 1

Next set up your data sources in "/etc/odbc.ini" (system wide) or
"~/.odbc" (current user). If a data source is defined in both of these
files, the one in your home directory take precedence.

    [MySQL-test]
    Description     = MySQL database test
    Driver          = MySQL
    Server          = localhost
    Database        = test
    Port            = 3306
    Socket          = /var/run/mysqld/mysqld.sock
    Option          =
    Stmt            =

> Create A Symbolic Link

Next we need to create a symlink for libmyodbc.so. To do this we need to
go to "/usr/lib/" and set up a symlink to libmyodbc.so

     cd /usr/lib/
     ln -s ./libmyodbc5w.so ./libmyodbc.so

> Create A Test Database

Create a new database "test". You can use one of the MySQL front-ends
mysql-gui-tools mysql-workbench or the commandline.

    mysqladmin -h localhost -u root -p create test

> Testing the ODBC

To test the ODBC connection

    isql MySQL-test

If the connection is established, you will see

    +---------------------------------------+
    | Connected!                            |
    |                                       |
    | sql-statement                         |
    | help [tablename]                      |
    | quit                                  |
    |                                       |
    +---------------------------------------+
    SQL>

If you have a problem connecting then check the error message by running

    isql MySQL-test -v

> A Couple Useful Websites

http://www.unixodbc.org/doc/OOoMySQL.pdf

This website got me going on ODBC with MySQL but left out some things
that were necessary for me to get isql up and running. However this
might be a good reference for the OpenOffice part.

http://mail.easysoft.com/pipermail/unixodbc-support/2004-August/000111.html

To work around error messages this URL proved helpful so here it is as
well.

MySQL, ODBC with OpenOffice Setup on the Remote Server
------------------------------------------------------

> Edit odbc.ini

From the Client side it is necessary to edit the odbc.ini and the
.odbc.ini files slightly. Here is the odbc.ini that I used to login.

    [MySQL-test]
    Description     = MySQL database test
    Driver          = MySQL
    Server          = 192.168.0.102
    Trace           = Off
    TraceFile       = stderr
    Database        = test
    Port            = 3306
    USER            = username
    Password        = secretpassword
    Socket          = /var/run/mysqld/mysqld.sock
    Option          =
    Stmt            =

> Edit my.cnf

Edit /etc/mysql/my.cnf so that port 3306 will be running to do this
comment out skip-networking. You can add bind-address = IP with you
incoming network card's IP.

    #skip-networking
    bind-address = 192.168.1.100

> Verify Port 3306 is Listening

restart the MySQL server

    # systemctl restart mysqld

Then check that port 3306 is listening on the server

    $ ss -ant

If port 3306 is open, you'll see the following:

    State       Recv-Q Send-Q                                     Local Address:Port                                       Peer Address:Port
    LISTEN      0            50                                                     *:3306                                                  *:*

> Permissions on MySQL for Remote Connection

Next it is necessary to give permissions on the server so that MySQL
will allow a remote connection. Type

    mysql -h localhost -u username -p

and log into your MySQL database.

    mysql> CREATE DATABASE test;
    mysql> GRANT ALL ON test.* TO username@'192.168.1.100' IDENTIFIED BY 'PASSWORD';

An extensive tutorial on this subject can be found here.

> Testing the ODBC

run the

    isql MySQL-test

command and you should be able to log into your server.

> Miscellaneous

From the client you can run the following command to verify that port
3306 is open

    telnet 192.168.0.100 3306

Good luck and happy computing now that you can get OpenOffice to connect
to you databases.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Odbc&oldid=248897"

Categories:

-   Networking
-   Database management systems
