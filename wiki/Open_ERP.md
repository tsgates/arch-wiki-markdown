Open ERP
========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: This page needs  
                           some major updating to   
                           be compatible with Open  
                           ERP version 7, which is  
                           what is now available    
                           from AUR. (Discuss)      
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Before Installing Open ERP                                         |
|     -   2.1 Installing PostgreSQL                                        |
|     -   2.2 Configuring PostgreSQL for local use on your own machine     |
|     -   2.3 Configuring PostgreSQL for remote use over a network         |
|     -   2.4 Setting up PostgreSQL to run with Open ERP                   |
|                                                                          |
| -   3 Installing Open ERP from AUR                                       |
|     -   3.1 install Open ERP                                             |
|     -   3.2 configure Open ERP                                           |
|     -   3.3 start Open ERP server                                        |
|     -   3.4 login to Open ERP                                            |
|     -   3.5 Open ERP GTK-Client                                          |
|                                                                          |
| -   4 Additional Open ERP Documentation                                  |
| -   5 Open ERP Community                                                 |
| -   6 Open Object RAD                                                    |
+--------------------------------------------------------------------------+

Introduction
============

This introduction briefly describes Open ERP, its basic design, and its
community. The rest of this wikipage details installing and configuring
Open ERP on Arch Linux. It also provides additional information about
Open ERP documentation, community, and development.

Open ERP is Enterprise Resource Planning software. It provides a
complete, integrated ERP solution for small and medium sized businesses
and organizations. Open ERP includes financial and analytic accounting,
warehouse and inventory management, sales and purchase management,
customer and supplier relations management, association management,
tasks automation, human resource management, marketing campaign,
document management, help desk, e-commerce integration, and point of
sale functionality.

Open ERP features an application server which uses PostgreSQL for its
database, along with a standalone GTK-based client, as well as a
web-based client. It is written in the Python programming language, with
a highly modular design which allows for the rapid development of new
modules through Open Object RAD. Open ERP developers have a strong
committment to free software.

A thriving support and development community has grown up around Open
ERP, providing free technical support, bugfixing, new development, and
support services. Open ERP provides extensive documentation in various
electronic formats, as well as hardcopy. The company responsible for
development of Open ERP earns profits through partnership services with
Open ERP consultants, and by providing support, training, hosting
services, software development, and software quality testing and
verification.

Before Installing Open ERP
==========================

The following instructions assume that you have installed the 'sudo'
command on your Arch Linux system. If you have not already done so, go
to the sudo Arch Wikipage for more information.

> Installing PostgreSQL

Open ERP uses the PostgreSQL database, which should be installed and
configured before installing Open ERP. Follow the instructions in the
"Installing PostgreSQL" section of the Arch PostgreSQL Wikipage.
Complete these installation instructions, but do not perform any other
configuration from that page. Return to this page for additional
configuration steps.

> Configuring PostgreSQL for local use on your own machine

If you plan to use PostgreSQL and Open ERP on the same machine, you will
need to configure PostgreSQL to listen on the localhost's 5432 TCP port.
As root, open the following configuration file with a text editor:

    /var/lib/postgres/data/postgresql.conf

Search for the following section within the postgresql.conf file:

    #------------------------------------------------------------------------------
    # CONNECTIONS AND AUTHENTICATION
    #------------------------------------------------------------------------------

    # - Connection Settings -

    #listen_addresses = 'localhost'         # what IP address(es) to listen on;
                                            # comma-separated list of addresses;
                                            # defaults to 'localhost', '*' = all
                                            # (change requires restart)
    #port = 5432                            # (change requires restart)

Uncomment the #listen_addresses line, and replace the text 'localhost'
with '127.0.0.1'. Also, uncomment the #port line. Save the file. When
complete, the file should appear as follows:

    #------------------------------------------------------------------------------
    # CONNECTIONS AND AUTHENTICATION
    #------------------------------------------------------------------------------

    # - Connection Settings -

    listen_addresses = '127.0.0.1'          # what IP address(es) to listen on;
                                            # comma-separated list of addresses;
                                            # defaults to 'localhost', '*' = all
                                            # (change requires restart)
    port = 5432                             # (change requires restart)

Restart PostgreSQL so that it uses the newly changed conf file, by
executing the following command:

    sudo /etc/rc.d/postgresql restart

Verify that PostgreSQL is listening on the localhost port 5432 by
executing the following command:

    # ss -anpt

Within the output from this command, you should find the following line
of text, except for the PID number which will very likely be different:

    tcp        0      0 127.0.0.1:5432          0.0.0.0:*               LISTEN      13420/postgres

> Configuring PostgreSQL for remote use over a network

If you need remote access to PostgreSQL over a network, read the
following section from the PostgreSQL Arch Wikipage.

> Setting up PostgreSQL to run with Open ERP

Next, it is necessary to create a new PostgreSQL user for Open ERP. In
this example, the user is 'yourusername', but you should replace this
with your Arch system login username. First, log in as the default
PostgreSQL superuser, 'postgres', by executing the following command
from the CLI:

    sudo su - postgres

Once logged in as postgres, begin the process of creating the
'yourusername' user, with the folowing command:

    createuser yourusername -P

You will first be asked for a password. For highly secure yet easy to
remember passwords, consider using a Diceware Passphrase. Re-enter the
password as requested. The next three questions should be answered in
sequence with n, y, and n. Shall the new role be a superuser? n Shall
the new role be allowed to create database? y Shall the new role be
allowed to create more new roles? n

You may also use options as below to skip the interactive questions to
set the attributes:

    createuser yourusername --createdb --login --no-superuser --no-createrole -P

Once you are finished answering these questions, type the word 'exit' to
log out from PostgreSQL as the postgres superuser.

You may want to edit your /etc/rc.conf file by adding postgresql to the
Daemons list, so that PostgreSQL will automatically start up when you
boot up your computer.

This completes the installation and setup of PostgreSQL for use with
Open ERP under Arch Linux. Additional detailed information about
PostgreSQL configuration may be found on the Arch Wikipage for
PostgreSQL, and the PostgreSQL Manuals webpage. Also, there is a
powerful GUI PostgreSQL Admin tool, pgAdmin, which is available in the
Arch repositories.

Installing Open ERP from AUR
============================

Open ERP requires the installation of the Open ERP Server, Open ERP
comes with a webserver so you can use your web browser to use it, or you
can use a Open ERP GTK-Client installed from AUR. Currently, Open ERP is
not available in the main repositories of Arch Linux, but it is
available through the Arch User Repository. Open ERP requires Python
2.7, various libraries compiled with Python 2.7, and a few other
dependencies not found in the Arch repositories. All of these packages
are provided through AUR. The best tool for downloading, compiling, and
installing AUR packages is yaourt. The following instructions assume
that yaourt has been installed and configured on the user's system.

> install Open ERP

     yaourt -S openerp

> configure Open ERP

the configure file of Open ERP server is at
/etc/openerp/openerp-server.conf. make it look like this:

     [options]
     ; This is the password that allows database operations:
     ; admin_passwd = admin
     db_host = localhost
     db_port = 5432
     db_user = yourusername  ##this is username you created in postegres.
     db_password =

> start Open ERP server

use the command below to enable autostart openerp server when system
boot:

    systemctl enable openerp-server.service

use the command below to start openerp:

    systemctl start openerp-server.service

> login to Open ERP

use your favorite web browser and go to link below:

    127.0.0.1:8069

shows openerp login page.

> Open ERP GTK-Client

Note:The current version of Open ERP in AUR is 7.0, which DOES NOT have
a GTK client. If you install openerp-client (version 6.1), it will
probably break your Open ERP database.

To install the Open ERP standalone GTK-based client, from the CLI,
execute the following command:

    yaourt -S openerp-client

Additional Open ERP Documentation
=================================

There are various sources of Open ERP documentation. The best place to
start is the Open ERP Documentation webpage. This page links to
different online documents, including detailed installation
instructions. Additionally, there is an online copy of the book, "Open
ERP for Retail and Industrial Management". This copy is also available
as a PDF file[dead link 2011-09-06], and can be purchased in hardcopy
form from Open ERP[dead link 2011-09-06] or from Amazon.com. While Open
ERP documentation, such as "Open ERP for Retail and Industrial
Management" is freely downloadable, it does not come with a free
documentation license. Further details about this issue are found on the
Open ERP website[dead link 2011-09-06]. Finally, Open ERP TV provides
screencasts, some of which document various features and procedures of
the software.

Open ERP Community
==================

The Open ERP Community is centered upon the Open Object website. Free
technical support for Open ERP may be found in the webforums, a mailing
list[dead link 2011-09-06] which is linked to the webforums, an IRC
channel on freenode.net, an Open ERP wiki, and the Official ERP
Documentation webpage. The latest news may be found on Open ERP Planet,
while various Open ERP screencasts are provided on Open ERP TV.
Fee-based support services are provided by Open ERP Partners[dead link
2011-09-06].

Open Object RAD
===============

Open Object is the Python-based Rapid Application Development framework
for developing Open ERP modules. It allows developers and businesses to
customize Open ERP for specific needs. Open Object RAD development work
is centered upon the Open Object Launchpad page. Developer news and
blogs are published on Open Object Planet. There are pages for software
downloads, Open ERP module downloads[dead link 2011-09-06], and
development source code downloads.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Open_ERP&oldid=255046"

Category:

-   Office
