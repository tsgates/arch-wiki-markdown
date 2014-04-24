Sybase
======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Sybase is a multi-threaded, multi-user SQL database. For more
information about features, see the official homepage.

Contents
--------

-   1 Install Sybase Client
-   2 Install command line client tool
-   3 Install Sybase Server
-   4 Configuration
    -   4.1 Enable remote access
-   5 Upgrading
-   6 Troubleshooting
    -   6.1 Install Sybase python binding

Install Sybase Client
---------------------

For those user do not want to install sybase server, it could install
the freetds package:

    # pacman -S freetds

After installing freetds you should edit the config file as root:

    # vi /etc/freetds/freetds.conf

Install command line client tool
--------------------------------

sqsh is in the AUR.

Install Sybase Server
---------------------

Configuration
-------------

> Enable remote access

Upgrading
---------

Troubleshooting
---------------

> Install Sybase python binding

[Download driver here http://python-sybase.sourceforge.net/] (v0.39 is
workable)

for sybase ocs installed

    python setup.py install

for use freetds

    root# SYBASE=/usr SYBASE_OCS= CFLAGS="-DHAVE_FREETDS" python setup.py install

Sample Code

    con=Sybase.connect('DSN','USER','PASS','DB',locking=0)
    c=con.cursor()
    c.execute('select count(*) from TABLE')
    c.fetchone()

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sybase&oldid=277286"

Category:

-   Database management systems

-   This page was last modified on 1 October 2013, at 21:14.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
