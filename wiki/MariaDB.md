MariaDB
=======

MariaDB is a reliable, high performance and full-featured database
server which aims to be an 'always Free, backward compatible, drop-in'
replacement of the MySQL Server. It is distributed under the GPLv2
license.

Started as a fork of MySQL by Widenius (creator of both servers),
MariaDB is a project developed by the open source community under the
technocracy model. Monty Program Ab employs most of the original core
MySQL developers, and is currently the main steward for the project.

MariaDB is kept up to date with the latest MySQL release from the same
branch. A merge from the main MySQL branch is done for every new MySQL
release or when there is some critical bugfix applied to the main
branch.

The intent also being to maintain high fidelity with MySQL, ensuring a
"drop-in" replacement capability with library binary equivalency and
exacting matching with MySQL APIs and commands.

Installation
------------

Install the mariadb package from the community repository.

If MySQL is already installed on the system, pacman has to remove mysql,
mysql-clients and libmysqlclient before installing mariadb.

After installing, the mysql system tables should be installed for you
automatically. If not, this should reinstall them:

    # /usr/bin/mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

Note: If you experience errors or you want more information about it,
read the official [documentation]

To start the mariadb daemon:

    # systemctl start mysqld.service

To enable it on every boot:

    # systemctl enable mysqld.service

Configuration
-------------

It is highly recommended to secure the installation after starting the
daemon, using the provided tool:

    # mysql_secure_installation

If you are new to MySQL, please read the MySQL page on this wiki for
additional information.

Retrieved from
"https://wiki.archlinux.org/index.php?title=MariaDB&oldid=252781"

Category:

-   Database management systems
