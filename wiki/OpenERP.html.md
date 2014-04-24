OpenERP
=======

OpenERP is Enterprise Resource Planning software. It provides a
complete, integrated ERP solution for small and medium sized businesses
and organizations. OpenERP includes financial and analytic accounting,
warehouse and inventory management, sales and purchase management,
customer and supplier relations management, association management,
tasks automation, human resource management, marketing campaign,
document management, help desk, e-commerce integration, and point of
sale functionality.

OpenERP features an application server which uses PostgreSQL as database
back-end, with a web-based client. It is written in the Python
programming language, with a highly modular design which allows for the
rapid development of new modules through Open Object RAD. OpenERP
developers have a strong commitment to free software.

A thriving support and development community has grown up around
OpenERP, providing free technical support, bug-fixing, new development,
and support services. OpenERP provides extensive documentation in
various electronic formats, as well as hardcopy. The company responsible
for development of OpenERP earns profits through partnership services
with OpenERP consultants, and by providing support, training, hosting
services, software development, and software quality testing and
verification.

Contents
--------

-   1 Before Installing
    -   1.1 Installing PostgreSQL
    -   1.2 Configuring PostgreSQL for remote use over a network
    -   1.3 Setting up PostgreSQL to run with OpenERP
-   2 Installation and configuration
    -   2.1 Installation
    -   2.2 Configuration
    -   2.3 Starting the server
    -   2.4 Logging in
-   3 Additional OpenERP Documentation
-   4 OpenERP Community
-   5 Open Object RAD

Before Installing
-----------------

> Installing PostgreSQL

OpenERP uses the PostgreSQL database, which should be installed and
configured before installing OpenERP. Follow PostgreSQL#Installing
PostgreSQL. Complete these installation instructions, but do not perform
any other configuration from that page. Return to this page for
additional configuration steps.

> Configuring PostgreSQL for remote use over a network

The by default, PostgreSQL only accepts connections from the local
machine. If you plan to run PostgreSQL and OpenERP on different
machines, you will need to follow PostgreSQL#Configure PostgreSQL to be
accessible from remote hosts.

> Setting up PostgreSQL to run with OpenERP

Next, it is necessary to create a new PostgreSQL user for OpenERP.

First, log in as the default PostgreSQL superuser, 'postgres', by
executing the following command from the CLI:

-   If you have sudo set up:

    $ sudo -i -u postgres

-   Otherwise:

    $ su
    # su - postgres

Once logged in as postgres, begin the process of creating the openerp
database user, with the following command:

    [postgres]$ createuser openerp --interactive -P

You will first be asked for a password. For highly secure yet easy to
remember passwords, consider using a Diceware Passphrase. Re-enter the
password as requested. The next three questions should be answered in
sequence with n, y, and n. Shall the new role be a superuser? n Shall
the new role be allowed to create database? y Shall the new role be
allowed to create more new roles? n

You may also use options as below to skip the interactive questions to
set the attributes:

    [postgres]$ createuser openerp --createdb --login --no-superuser --no-createrole -P

Once you are finished answering these questions, type exit to log out
from postgres and return to your regular user.

This completes the installation and setup of PostgreSQL for use with
OpenERP under Arch Linux. Additional detailed information about
PostgreSQL configuration may be found in the PostgreSQL article, and the
PostgreSQL Manuals webpage. Also, there is a powerful GUI PostgreSQL
Admin tool, pgAdmin, which is available in the Arch repositories.

Installation and configuration
------------------------------

OpenERP requires the installation of the OpenERP Server, OpenERP comes
with a webserver so you can use your web browser to use it. Currently,
OpenERP is not available in the official repositories, but it is
available through the Arch User Repository.

> Installation

Install openerp from the AUR.

> Configuration

The configuration file of OpenERP server is at
/etc/openerp/openerp-server.conf. Edit db_user and db_password. If the
PostgreSQL server is on a different machine, also edit db_host.

     [options]
     ; This is the password that allows database operations:
     ; admin_passwd = admin
     db_host = localhost
     db_port = 5432
     db_user = openerp
     db_password = password

If you want OpenERP to run in multiple process, add the following line
to openerp-server.conf.

    workers = n # change n to a number you like.

> Starting the server

Use the command below to enable autostart openerp server at boot:

    # systemctl enable openerp.service

Use the command below to start openerp:

    # systemctl start openerp.service

> Logging in

Go to http://localhost:8069 in your web browser and you will be greeted
by the OpenERP login page.

Additional OpenERP Documentation
--------------------------------

There are various sources of OpenERP documentation. The best place to
start is the OpenERP Documentation webpage. This page links to different
online documents, including detailed installation instructions.
Additionally, there is an online copy of the book, "OpenERP for Retail
and Industrial Management",and can be purchased from Amazon.com. While
OpenERP documentation, such as "OpenERP for Retail and Industrial
Management" is freely downloadable, it does not come with a free
documentation license.

OpenERP Community
-----------------

The OpenERP Community is centered upon the Open Object website. Free
technical support for OpenERP may be found in the webforums[dead link
2013-08-26], a mailing list[dead link 2011-09-06] which is linked to the
webforums, an IRC channel on freenode.net, an OpenERP wiki, and the
Official ERP Documentation webpage. The latest news may be found on
OpenERP Planet, while various OpenERP screencasts are provided on
OpenERP TV. Fee-based support services are provided by OpenERP
Partners[dead link 2011-09-06].

Open Object RAD
---------------

Open Object is the Python-based Rapid Application Development framework
for developing OpenERP modules. It allows developers and businesses to
customize OpenERP for specific needs. Open Object RAD development work
is centered upon the Open Object Launchpad page. Developer news and
blogs are published on Open Object Planet. There are pages for software
downloads, OpenERP module downloads[dead link 2011-09-06], and
development source code downloads.

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenERP&oldid=292635"

Category:

-   Office

-   This page was last modified on 12 January 2014, at 23:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
