Seafile
=======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Work in progress  
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Seafile is a next-generation open source cloud storage system, with
advanced support for file syncing, privacy protection and teamwork.

Collections of files are called libraries, and each library can be
synced separately. A library can be encrypted with a user chosen
password. This password is not stored on the server, so even the server
admin can't view your file contents.

Seafile lets you create groups with file syncing, wiki, and discussion
-- enabling easy collaboration around documents within a team.

Contents
--------

-   1 Server
    -   1.1 Installation
    -   1.2 Deploy with Nginx
-   2 Sources

Server
------

> Installation

Install seafile-server from the Arch User Repository

As root, add a new user to run the seafile server under:

    # useradd -m -d /srv/seafile -s /bin/false seafile

Change to that new user, e.g. using sudo (following commands are to be
executed as that user unless otherwise stated):

    $ sudo -u seafile -s /bin/sh

As that user, create the directory layout for the domain and change
directory to it (replace example.org with the domain of your new
server):

    $ mkdir -p $HOME/example.org/seafile-server
    $ cd $HOME/example.org

Check the seahub repository for the latest git tag with the format
"vx.y.z-server" and set the SEAFILE_SERVER_VERSION variable to x.y.z,
e.g. 2.1.3:

    $ SEAFILE_SERVER_VERSION=2.1.3

Download seahub and extract it:

    $ wget -P seafile-server https://github.com/haiwen/seahub/archive/v$SEAFILE_SERVER_VERSION-server.tar.gz
    $ tar -xz -C seafile-server -f seafile-server/v$SEAFILE_SERVER_VERSION-server.tar.gz

Rename the extracted directory:

    $ mv seafile-server/seahub-$SEAFILE_SERVER_VERSION-server seafile-server/seahub

To create the configuration for the seafile server, run

    $ seafile-admin setup

and follow the instructions now showing on your screen. See the seafile
wiki for a detailed explanation of the seafile-admin script.

To manually start your new seafile server, run as root:

    # systemctl start seafile-server@example.org

To automatically start your new seafile server at system startup, run as
root:

    # systemctl enable seafile-server@example.org

> Deploy with Nginx

In order to deploy Seafile's webinterface "seahub" with Nginx, you can
use an Nginx configuration similar to this:

    server {
        listen 80;
        server_name www.foo.tld foo.tld;
        rewrite ^/(.*) https://$server_name/$1 permanent;   # force redirect http to https
    }

    server {
        listen 443;
        ssl on;
        ssl_certificate /etc/ssl/certs/foo.tld.crt;
        ssl_certificate_key /etc/ssl/private/server.key;
        server_name www.foo.tld foo.tld;

        location / {
            fastcgi_pass    127.0.0.1:8000;
            fastcgi_param   SCRIPT_FILENAME     $document_root$fastcgi_script_name;
            fastcgi_param   PATH_INFO           $fastcgi_script_name;

            fastcgi_param   SERVER_PROTOCOL     $server_protocol;
            fastcgi_param   QUERY_STRING        $query_string;
            fastcgi_param   REQUEST_METHOD      $request_method;
            fastcgi_param   CONTENT_TYPE        $content_type;
            fastcgi_param   CONTENT_LENGTH      $content_length;
            fastcgi_param   SERVER_ADDR         $server_addr;
            fastcgi_param   SERVER_PORT         $server_port;
            fastcgi_param   SERVER_NAME         $server_name;

            fastcgi_param   HTTPS on;
            fastcgi_param   HTTP_SCHEME https;
        }

        location /seafhttp {
            rewrite ^/seafhttp(.*)$ $1 break;
            proxy_pass http://127.0.0.1:8082;
            client_max_body_size 0;
        }

        location /media {
            root {ABSOLUTE_PATH}/foo.tld/seafile-server/seahub;
        }
    }

Sources
-------

-   https://github.com/haiwen/seafile/wiki/Build-and-deploy-seafile-server-from-source
-   https://github.com/haiwen/seafile/wiki/Deploy-Seafile-with-nginx

Retrieved from
"https://wiki.archlinux.org/index.php?title=Seafile&oldid=294723"

Category:

-   Web Server

-   This page was last modified on 28 January 2014, at 04:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
