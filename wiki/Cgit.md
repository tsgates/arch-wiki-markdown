Cgit
====

Cgit is an attempt to create a fast web interface for the git scm, using
a builtin cache to decrease server io-pressure.

Contents
--------

-   1 Installation
-   2 Configuration of Web Server
    -   2.1 Apache
    -   2.2 Lighttpd
        -   2.2.1 Lighttpd sub-domain
    -   2.3 Nginx
-   3 Configuration of Cgit
    -   3.1 Basic Configuration
    -   3.2 Adding repositories
    -   3.3 Syntax highlighting
-   4 Integration
    -   4.1 Gitosis
    -   4.2 Gitolite
-   5 Troubleshooting
    -   5.1 snapshots does not show properly
-   6 References

Installation
------------

Installing cgit is rather simple as it's available in the Community
repository:

    # pacman -S cgit

In order to actually use cgit you will of course also need to have some
webserver installed on your system, like for example Apache.

Configuration of Web Server
---------------------------

> Apache

You may add the following either to the end of your
/etc/httpd/conf/httpd.conf file or place it in a separate file inside
the /etc/httpd/conf/extra/ directory.

    #
    # cgit configuration for apache
    #

    ScriptAlias /cgit/ "/usr/lib/cgit/cgit.cgi/"
    Alias /cgit-css "/usr/share/webapps/cgit/"
    <Directory "/usr/share/webapps/cgit/">
       AllowOverride None
       Options None
       Order allow,deny
       Allow from all
    </Directory>
    <Directory "/usr/lib/cgit/">
       AllowOverride None
       Options ExecCGI FollowSymlinks
       Order allow,deny
       Allow from all
    </Directory>

> Lighttpd

The following configuration will let you access cgit through
http://your.server.com/cgit with http://your.server.com/git redirecting
to it. It's not perfect (for example you'll see "cgit.cgi" in all repos'
url) but works.

Create the file /etc/lighttpd/conf.d/cgit.conf:

    server.modules += ("mod_redirect",
                      "mod_alias",
                      "mod_cgi",
                      "mod_fastcgi",
                      "mod_rewrite" )

    var.webapps  = "/usr/share/webapps/"
    $HTTP["url"] =~ "^/cgit" {
        server.document-root = webapps
        server.indexfiles = ("cgit.cgi")
        cgi.assign = ("cgit.cgi" => "")
        mimetype.assign = ( ".css" => "text/css" )
    }
    url.redirect = (
        "^/git/(.*)$" => "/cgit/cgit.cgi/$1",
    )

Just include this file in /etc/lighttpd/lighttpd.conf:

    include "conf.d/cgit.conf"

and restart lighttpd.

Lighttpd sub-domain

This alternative lighttpd configuration will serve Cgit on a sub-domain
like git.example.com with optional SSL support, and rewrites creating
nice permalinks:

       # GIT repository browser
       #$SERVER["socket"] == "127.0.0.1:443" {
       $SERVER["socket"] == "127.0.0.1:80" {
         #ssl.engine                    = "enable"
         #ssl.pemfile                   = "/etc/lighttpd/ssl/git.example.com.pem"
         
         server.name          = "git.example.com"
         server.document-root = "/usr/share/webapps/cgit"
         
         index-file.names     = ( "cgit.cgi" )
         cgi.assign           = ( "cgit.cgi" => "/usr/share/webapps/cgit/cgit.cgi" )
         url.rewrite-once     = (
           "^/([^?/]+/[^?]*)?(?:\?(.*))?$"   => "/cgit.cgi?url=$1&$2",
         )
       }

> Nginx

The following configuration uses fcgiwrap and will serve Cgit on a
subdomain like git.example.com.

Install and setup fcgiwrap:

    # pacman -S fcgiwrap
    # systemctl daemon-reload
    # systemctl enable fcgiwrap.socket
    # systemctl start fcgiwrap.socket

Configure Nginx:

    /etc/nginx/nginx.conf

    worker_processes          1;
     
    events {
      worker_connections      1024;
    }
     
    http {
      include                 mime.types;
      default_type            application/octet-stream;
      sendfile                on;
      keepalive_timeout       65;
      gzip                    on;
     
      # Cgit
      server {
        listen                80;
        server_name           git.example.com;
        root                  /usr/share/webapps/cgit;
        try_files             $uri @cgit;

        location @cgit {
          include             fastcgi_params;
          fastcgi_param       SCRIPT_FILENAME $document_root/cgit.cgi;
          fastcgi_param       PATH_INFO       $uri;
          fastcgi_param       QUERY_STRING    $args;
          fastcgi_pass        unix:/run/fcgiwrap.sock;
        }
      }
    }

Configuration of Cgit
---------------------

> Basic Configuration

Before you can start adding repositories you will first have to create
the basic cgit configuration file at /etc/cgitrc.

    #
    # cgit config
    #

    css=/cgit.css
    logo=/cgit.png
    # Following lines work with the above Apache config
    #css=/cgit-css/cgit.css
    #logo=/cgit-css/cgit.png

    # if you don't want that webcrawler (like google) index your site
    robots=noindex, nofollow

> Adding repositories

Now you can add your repos:

    #
    # List of repositories.
    # This list could be kept in a different file (e.g. '/etc/cgitrepos')
    # and included like this:
    #   include=/etc/cgitrepos
    #

    repo.url=MyRepo
    repo.path=/srv/git/MyRepo.git
    repo.desc=This is my git repository

    repo.url=MyOtherRepo
    repo.path=/srv/git/MyOtherRepo.git
    repo.desc=That's my other git repository

If you prefer not having to manually specify each repository it's also
possible to configure cgit to search for them:

    scan-path=/srv/git/

If you are coming from gitweb and want to keep the descriptions and
owner information, then use:

    enable-git-config=1

For detailed documentation about the available settings in this
configuration file, please see the manage (`man cgitrc`).

> Syntax highlighting

Cgit supports syntax highlighting when viewing blobs. To enable syntax
highlighting, you have to install the highlight package.

    # pacman -S highlight

Edit /usr/lib/cgit/filters/syntax-highlighting.sh. Comment out version 2
and comment in version 3. You may want to add --inline-css to the
options of highlight for a more colorfull output without editing cgit's
css file.

     # This is for version 2
     #exec highlight --force -f -I -X -S "$EXTENSION" 2>/dev/null
     
     # This is for version 3
     exec highlight --force --inline-css -f -I -O xhtml -S "$EXTENSION" 2>/dev/null

Enable the filter in /etc/cgitrc

    source-filter=/usr/lib/cgit/filters/syntax-highlighting.sh

Integration
-----------

> Gitosis

If you want to integrate with gitosis you will have to run two commands
to give apache permission to look though the folder.

    # chgrp http /srv/gitosis
    # chmod a+rx /srv/gitosis

> Gitolite

If you added repositories managed by gitolite you have to change the
permissions, so the web server can access the files.

-   Change permission for future repositories:
    -   Edit ~/.gitolite.rc of your gitolite user. Change the UMASK to
        0022
    -   See also: http://gitolite.com/gitolite/external.html#umask
-   Change permission for existing repositories:
    -   Run the following two commands (as root or gitolite-user):
        -   # find /path/to/the/repository/ -type d -exec chmod og+rx {} \;
        -   # find /path/to/the/repository/ -type f -exec chmod og+r {} \;

Troubleshooting
---------------

> snapshots does not show properly

If you have enabled scan-path as long as snapshots, the order in cgitrc
matters. According to cgit mailing list, snapshots should be specified
before scan-path

    snapshots=tar.gz tar.bz2 zip
    scan-path=/path/to/your/repositories

References
----------

-   http://git.zx2c4.com/cgit/
-   http://git.zx2c4.com/cgit/about/
-   http://git.zx2c4.com/cgit/tree/README
-   http://git.zx2c4.com/cgit/tree/cgitrc.5.txt

Retrieved from
"https://wiki.archlinux.org/index.php?title=Cgit&oldid=303299"

Category:

-   Version Control System

-   This page was last modified on 6 March 2014, at 09:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
