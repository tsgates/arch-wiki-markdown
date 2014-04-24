Xtrabackup
==========

Percona XtraBackup is an high performance, low-profile and non-blocking
open-source backup utility for InnoDB and XtraDB databases.

Currently is the only open-source tool that performs backups on
'MySQL-based' servers (MySQL, MariaDB, Percona Server) that doesn't lock
your database during it. Backups are online, and queries and
transactions continue to run without interruption ('hot backups').

It can back up data from InnoDB, XtraDB, and MyISAM tables on MySQL 5.0
and 5.1 servers, and it has many advanced features like partial, remote,
compressed and incremental backups, multi-threaded file copying for
performance and Point-in-time recovery.

Note: MyISAM tables are read-only while they are being backed up.

Contents
--------

-   1 Installation
-   2 Usage Examples
    -   2.1 xtrabackup
    -   2.2 innobackupex
    -   2.3 tar4ibd
-   3 Tips
    -   3.1 Setting up a slave with Xtrabackup
-   4 More Resources

Installation
------------

Install the xtrabackup from the AUR.

Usage Examples
--------------

XtraBackup is really a set of three tools:

 xtrabackup
    A compiled C binary, which copies only InnoDB and XtraDB data
 innobackupex
    A wrapper script that provides functionality to backup a whole MySQL
    database instance with MyISAM, InnoDB, and XtraDB tables.
 tar4ibd
    A patched version of tar for handling InnoDB data safely.

In all of the below examples, the following is assumed:

-   You are backing up a server whose data is stored in /var/lib/mysql/,
    which is the standard location for Archlinux
-   You are storing the backups in /data/backups/mysql
-   You have a my.cnf file in a standard location, such as /etc/my.cnf,
    with at least the following contents:

    [mysqld]
    datadir=/var/lib/mysql/
    [xtrabackup]
    target_dir=/data/backups/mysql/

> xtrabackup

Making the backup copies the InnoDB data and log files to the
destination and preparing the backup makes the data files consistent and
ready to use.

-   Make a backup:

    # xtrabackup --backup

Prepare the backup:

    # xtrabackup --prepare

Prepare again, to create fresh InnoDB log files:

    # xtrabackup --prepare

The exit status of a successful xtrabackup is 0. In the second --prepare
step, you should see InnoDB print messages similar to “Log file
./ib_logfile0 did not exist: new to be created”, followed by a line
indicating the log file was created.

You might want to set the --use-memory option to something similar to
the size of your buffer pool, if you are on a dedicated server that has
enough free memory. The complete documentation of the tool is here.

> innobackupex

-   Copying all your MySQL data from the specified directory in your
    my.cnf.

It will put the backup in a timestamped subdirectory of /data/backups/
by default (in this example, /data/backups/2010-03-13_02-42-44).

    # innobackupex /data/backups

Note: There is a lot of output, but you need to make sure you see this
at the end of the backup. If you do not see this output, then your
backup failed:

    # 100313 02:43:07  innobackupex: completed OK!

-   If you take the backup from a replica (“slave”), then you might need
    to see the position relative to the primary (“master”) at the point
    of the backup:

    # innobackupex --slave-info /data/backups

See the full documentation of this tool here.

> tar4ibd

The tar4ibd binary is a specially patched version of tar that
understands how to handle InnoDB/XtraDB data files correctly.

The syntax is the same as tar. The only consideration you must have is
including the -i option if you are extracting a file with GNU tar. If
not, only a part of your data will be extracted.

Tips
----

> Setting up a slave with Xtrabackup

Xtrabackup is also can be used to clone one slave to another, or just
setup new slave from the master. And it is done in a non-blocking way
(almost for MyISAM setups) for the cloned server.

Assuming the previous scenario, first execute

    # innobackupex --stream=tar /tmp/ --slave-info | ssh user@DESTSERVER "tar xfi - -C /var/lib/mysql"

When it finishes, on your destination server run

    # innobackupex --apply-log --use-memory=2G  /var/lib/mysql

and you will have ready the database directory.

Copy my.cnf from the original server and start mysqld on the new slave.

Look at the content of the file xtrabackup_slave_info that will be
created on the slave:

    # cat /var/lib/mysql/xtrabackup_slave_info
    CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000834', MASTER_LOG_POS=50743116

and execute that statement on a mysql console and start the slave:

    mysql> CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000834', MASTER_LOG_POS=50743116;
    mysql> START SLAVE;

You should check that everything went OK with:

    mysql> SHOW SLAVE STATUS \G
    ...
    Slave_IO_Running: Yes
    Slave_SQL_Running: Yes
    ...
    Seconds_Behind_Master: 1643
    ...

Note: You can use this procedure to add new slaves to a master. Use the
same commands to clone an instance already configured as a slave. Just
before setting the master for the slave ('CHANGE MASTER TO') run:

    mysql> STOP SLAVE;

More Resources
--------------

-   Percona's documentation of Xtrabackup
-   XtraBackup in Launchpad
-   Xtrabackup's Home page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xtrabackup&oldid=198735"

Categories:

-   Database management systems
-   System recovery

-   This page was last modified on 23 April 2012, at 18:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
