WebDAV authentication
=====================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with WebDAV.     
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Goals                                                              |
|     -   1.1 Required packages                                            |
|                                                                          |
| -   2 WebDav Configuration                                               |
|     -   2.1 Step 1: Edit /etc/httpd/conf/httpd.conf                      |
|     -   2.2 Step 2: Create needed directories and assign permissions     |
|     -   2.3 Step 3: Authentication                                       |
|     -   2.4 Step 4: Restart apache                                       |
+--------------------------------------------------------------------------+

Goals
-----

The goal of this how to use simple authentication with WebDAV. Please
refer to Cactus' superb write up on setting up WebDAV.

> Required packages

-   apache
-   cadaver (for testing)

  

WebDav Configuration
--------------------

> Step 1: Edit /etc/httpd/conf/httpd.conf

    DAVLockDB /var/log/httpd/DavLock/DavLockDB
    <Location /dav>
    DAV On
    AuthType Digest
    AuthName "WebDAV"
    AuthUserFile /etc/httpd/conf/passwd
    Require user foo
    </Location>

> Step 2: Create needed directories and assign permissions

    # mkdir -p /var/log/httpd/DavLock
    # touch /var/log/httpd/DavLock/DavLockDB
    # chown -R nobody.nobody /var/log/httpd/DavLock
    # mkdir -p /home/httpd/html/dav
    # chown -R nobody.nobody /home/httpd/html/dav

  

> Step 3: Authentication

There are numerous different protocols you can use:

-   plain
-   digest
-   others

This is an example for using digest (make sure it is enabled in
httpd.conf)

    htdigest -c /etc/httpd/conf/passwd WebDAV foo

Please make sure that the path is identical to the one you entered in
your httpd.conf. Also when using digest you have to enter the AuthName
from httpd.conf. For plain authentication you would not need this.

With the above setup the user *foo* is required for everything.

If you want to permit everybody to read, you could use this in your
httpd.conf

    <Location /dav>
    DAV On
    AuthType Digest
    AuthName "WebDAV"
    AuthUserFile /etc/httpd/conf/passwd
    <LimitExcept GET HEAD OPTIONS PROPFIND>
    require user foo
    </LimitExcept>
    </Location>

> Step 4: Restart apache

    # /etc/rc.d/httpd restart

Retrieved from
"https://wiki.archlinux.org/index.php?title=WebDAV_authentication&oldid=253942"

Category:

-   Networking
