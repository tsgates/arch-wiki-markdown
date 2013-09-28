MySQL
=====

MySQL is a widely spread, multi-threaded, multi-user SQL database. For
more information about features, see the official homepage.

Note:MariaDB is now officially our default implementation of MySQL.It is
recommended for all users to upgrade to MariaDB. MySQL will be dropped
from the repositories to the AUR before 2013/4/26. See the announcement.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Upgrade to MariaDB                                                 |
| -   2 Installation                                                       |
| -   3 Configuration                                                      |
|     -   3.1 Disable remote access                                        |
|     -   3.2 Enable auto-completion                                       |
|                                                                          |
| -   4 Upgrading                                                          |
| -   5 Backup                                                             |
| -   6 Troubleshooting                                                    |
|     -   6.1 MySQL daemon cannot start                                    |
|     -   6.2 Unable to run mysql_upgrade because MySQL cannot start       |
|     -   6.3 Reset the root password                                      |
|                                                                          |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Upgrade to MariaDB
------------------

Users who want to switch will need to install mariadb, libmariadbclient
or mariadb-clients and execute mysql_upgrade in order to migrate their
systems.

    # systemctl stop mysqld
    # pacman -S mariadb libmariadbclient mariadb-clients
    # systemctl start mysqld
    # mysql_upgrade -p

Installation
------------

Install the mysql package from the official repositories.

After installing MySQL, start the mysqld daemon.

Run the setup script and restart the daemon afterwards:

    # mysql_secure_installation
    # systemctl restart mysqld

Configuration
-------------

Once you have started the MySQL server, you probably want to add a root
account in order to maintain your MySQL users and databases. This can be
done manually or automatically, as mentioned by the output of the above
script. Either run the commands to set a password for the root account,
or run the secure installation script.

You now should be able to do further configuration using your favorite
interface. For example you can use MySQL's command line tool to log in
as root into your MySQL server:

    $ mysql -p -u root

> Disable remote access

The MySQL server is accessible from the network by default. If mysql is
only needed for the localhost, you can improve security by not listening
on TCP port 3306. To refuse remote connections, uncomment the following
line in /etc/mysql/my.cnf:

    skip-networking

You will still be able to log in from the localhost.

> Enable auto-completion

The MySQL client completion feature is disabled by default. To enable it
system-wide edit /etc/mysql/my.cnf, and replace no-auto-rehash by
auto-rehash. Completion will be enabled next time you run the MySQL
client. Please note that enabling this feature can make the client
initialization longer.

Upgrading
---------

You might consider running this command after you have upgraded MySQL
and started it:

    # mysql_upgrade -u root -p

Backup
------

The database can be dumped to a file for easy backup. The following
shell script will do this for you, creating a db_backup.gz file in the
same directory as the script, containing your database dump:

    #!/bin/bash

    THISDIR=`dirname $(readlink -f "$0")`

    mysqldump --single-transaction --flush-logs --master-data=2 --all-databases \
      | gzip > $THISDIR/db_backup.gz
    echo 'purge master logs before date_sub(now(), interval 7 day);' | mysql

See also the official mysqldump page in the MySQL manual.

Troubleshooting
---------------

> MySQL daemon cannot start

If you see something like this:

     :: Starting MySQL  [FAIL]

and there is no entry in the log files, you might want to check the
permissions of files in the directories /var/lib/mysql and
/var/lib/mysql/mysql. If the owner of files in these directories is not
mysql:mysql, you should do the following:

     # chown mysql:mysql /var/lib/mysql -R

If you run into permission problems despite having followed the above,
ensure that your my.cnf is copied to /etc/:

     # cp /etc/mysql/my.cnf /etc/my.cnf

Now try and start the daemon.

If you get these messages in your /var/lib/mysql/hostname.err

     [ERROR] Can't start server : Bind on unix socket: Permission denied
     [ERROR] Do you already have another mysqld server running on socket: /var/run/mysqld/mysqld.sock ?
     [ERROR] Aborting

The permissions of /var/run/mysqld could be the culprit.

     # chown mysql:mysql /var/run/mysqld -R

If you run mysqld and the following error appears:

     Fatal error: Can’t open and lock privilege tables: Table ‘mysql.host’ doesn’t exist

Run the following command from the /usr directory to install the default
tables:

     # cd /usr
     # mysql_install_db --user=mysql --ldata=/var/lib/mysql/

> Unable to run mysql_upgrade because MySQL cannot start

Try run MySQL in safemode:

    # mysqld_safe --datadir=/var/lib/mysql/

And then run:

    # mysql_upgrade -u root -p

> Reset the root password

Stop the mysqld daemon.

    # mysqld_safe --skip-grant-tables &

Connect to the mysql server

    # mysql -u root mysql

Change root password:

     mysql> UPDATE mysql.user SET Password=PASSWORD('MyNewPass') WHERE User='root';
     mysql> FLUSH PRIVILEGES;
     mysql> exit

Start the mysqld daemon.

See also
--------

-   LAMP - Arch wiki article covering the setup of a LAMP server (Linux
    Apache MySQL PHP)
-   http://www.mysql.com/
-   Front-ends: mysql-gui-tools mysql-workbench

Retrieved from
"https://wiki.archlinux.org/index.php?title=MySQL&oldid=251957"

Category:

-   Database management systems
