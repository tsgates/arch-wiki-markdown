WebDAV
======

WebDAV(Web Distributed Authoring and Versioning) is an extension of HTTP
1.1 and therefore can be considered to be a procotol. It contains a set
of concepts and accompanying extension methods to allow read and write
across the HTTP 1.1 protocol. Instead of using NFS or SMB, WebDAV offers
file transfers via HTTP.

The goal of this how to is to setup a simple WebDAV configuration using
Apache.

See also File Sharing with Webdav and DNSSD.

Contents
--------

-   1 Server (Apache)
    -   1.1 Create directories
-   2 Client (Cadaver)
    -   2.1 Test it
-   3 Authentication

Server (Apache)
---------------

Install Apache as explained in the LAMP article.

Now enable WebDAV. Add the following line to /etc/httpd/conf/httpd.conf.

    DAVLockDB /home/httpd/DAV/DAVLock

Make sure you add it outside of any other directives, for instance right
under the DocumentRoot definition.

Next, add the following (also outside of any directives):

    Alias /dav "/home/httpd/html/dav"

    <Directory "/home/httpd/html/dav">
      DAV On
      AllowOverride None
      Options Indexes FollowSymLinks
      Require all granted
    </Directory>

> Create directories

    # mkdir -p /home/httpd/DAV

Check the permissions of DavLockDB's directory and insure it is writable
by the apache user (http):

    # chown -R http:http /home/httpd/DAV # Otherwise you wouldn't be able to upload files

    # mkdir -p /home/httpd/html/dav
    # chown -R nobody.nobody /home/httpd/html/dav

Client (Cadaver)
----------------

Cadaver is a command line WebDAV client. It can be installed with the
package cadaver, available in the official repositories.

> Test it

    # cadaver http://localhost/dav
    dav:/dav/> mkcol test
    Creating `test': succeeded.
    dav:/dav/> ls
    Listing collection `/dav/': succeeded.
    Coll: test
    dav:/dav/> exit

If the above worked as shown, then you are good to go.

Authentication
--------------

Make sure you add permissions for viewing and dav access to the
directory, and maybe even make that directory ssl access only.

There are numerous different protocols you can use:

-   plain
-   digest
-   others

Two examples follow, in which foo is the username:

Using digest:

    # basic form: htdigest -c /path/to/file AuthName username
    htdigest -c /etc/httpd/conf/passwd WebDAV foo

Note:Make sure digest authentication is enabled in httpd.conf by the
presence of this entry:
LoadModule auth_digest_module modules/mod_auth_digest.so

Using plain:

    # basic form: htpasswd -c /path/to/file username
    htpasswd -c /etc/httpd/conf/passwd foo

Next, httpd.conf must be edited to enable authentication. One method
would be to require the user foo for everything:

    <Directory "/home/httpd/html/dav">
      DAV On
      AllowOverride None
      Options Indexes FollowSymLinks
      AuthType Digest # substitute "Basic" for "Digest" if you used htpasswd above
      AuthName "WebDAV"
      AuthUserFile /etc/httpd/conf/passwd
      Require user foo
    </Directory>

Note:AuthName must match the name passed when using the htdigest command
for digest authentication. For basic/plain authentication, this line may
be removed. Also, make sure that the AuthUserFile path matches that used
with the htdigest or htpasswd commands above

If you want to permit everybody to read, you could use this in your
httpd.conf

    <Directory "/home/httpd/html/dav">
      DAV On
      AllowOverride None
      Options Indexes FollowSymLinks
      AuthType Digest # substitute "Basic" for "Digest" if you used htpasswd above
      AuthName "WebDAV"
      AuthUserFile /etc/httpd/conf/passwd
      Require all granted
      <LimitExcept GET HEAD OPTIONS PROPFIND>
        Require user foo
      </LimitExcept>
    </Directory>

Don't forget to restart apache after making changes!

    # systemctl restart httpd

Retrieved from
"https://wiki.archlinux.org/index.php?title=WebDAV&oldid=304693"

Category:

-   Networking

-   This page was last modified on 16 March 2014, at 03:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
