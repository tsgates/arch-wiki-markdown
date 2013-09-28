Couchdb
=======

"Apache CouchDB is a document-oriented database that can be queried and
indexed in a MapReduce fashion using JavaScript." - CouchDB homepage

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Running                                                            |
| -   3 Using Futon                                                        |
| -   4 Configuring                                                        |
| -   5 More Resources                                                     |
+--------------------------------------------------------------------------+

Installation
------------

Install the couchdb package:

    # pacman -S couchdb

Running
-------

Start Couch

    # systemctl start couchdb

To launch on startup, enable it:

    # systemctl enable couchdb

Using Futon
-----------

You can now access the Futon admin interface by going to
http://localhost:5984/_utils

Configuring
-----------

Change the default port, bind address, log-level and other useful
nuggets in /etc/couchdb/local.ini.

If you want to run CouchDB on port 80 you will have to run the daemon as
root or use an iptables rule such as:

      iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 5984

Note: Do not modify /etc/couchdb/default.ini as it gets overwritten
whenever couchdb is updated, copy any values you would like to change
and put them in your local.ini. Also be sure to restart couchdb after
changes to this file.

If you would like to use ssl with a self-signed certificate you can
create one like this:

     # cd /etc/couchdb
     # openssl genrsa -des3 -out server.key 1024
     # openssl req -new -key server.key -out server.csr
     # cp server.key server.key.org
     # openssl rsa -in server.key.org -out server.key
     # openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

Then uncomment httpsd and update the path in the [ssl] section

     [daemons]
     httpsd = {couch_httpd, start_link, [https]}

     [ssl]
     cert_file = /etc/couchdb/server.crt
     key_file = /etc/couchdb/server.key

Futon can be accessed over ssl on port 6984 via
https://localhost:6984/_utils/

Admin users can be created in your local.ini file. Add the username and
password in plaintext, next time couch is restarted it will hash the
password. See create a read-only database for locking down databases and
further security.

     [admins]
     admin = magicalunicorns

More Resources
--------------

-   Official CouchDB page
-   CouchDB Wiki
-   CouchDB - The Definitive Guide
-   create a read-only database

Retrieved from
"https://wiki.archlinux.org/index.php?title=Couchdb&oldid=233072"

Category:

-   Database management systems
