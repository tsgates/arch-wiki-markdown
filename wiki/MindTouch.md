MindTouch
=========

MindTouch is an enterprise wiki and collaborative portal. For more
information, see the Wikipedia article, and the SourceForge project.

Installation
------------

Feel free to follow along on the MindTouch Installation Guide. However,
these installation instructions assume you'll be using Nginx instead of
Apache.

-   Install MySQL.
-   Install Nginx and php-fpm.
-   Compile the mindtouch Arch User Repository package and install the
    resulting mindtouch and mindtouch-setup packages.
-   If you would like to use Prince to allow PDF export, install the
    princexml package from the Arch User Repository.

Note:Although Prince is not free for commercial use, there is an
explicit exception made for MindTouch, which allows it to be used for
free, even if your MindTouch installation will be used for commercial
purposes. (A note is added to the first page of every generated PDF.)
Prince can also be installed at a later date if necessary.

-   The mindtouch package added a file that can be used to simplify the
    nginx configuration, but you'll need to create a link to it in your
    nginx configuration directory. As root:

    # cd /etc/nginx/conf
    # ln -s /usr/share/mindtouch/nginx-rewrites mindtouch-rewrites

-   Add the following configuration to nginx, modifying to suit your
    needs:

    server {
      listen       80;
      server_name  mindtouch;

      location / {
        root /usr/share/webapps/mindtouch;
        index index.php;
        include mindtouch-rewrites;
      }

      location ~ \.php$ {
        root          /usr/share/webapps/mindtouch;
        fastcgi_pass  unix:/var/run/php-fpm/php-fpm.sock;
        fastcgi_buffers 256 4k;
        fastcgi_buffer_size 128k;
        include       fastcgi.conf;
      }

      location /@api/ {
        proxy_pass http://localhost:8081/;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Host $host:$server_port;
      }
    }

Note:The fastcgi buffer configuration is necessary, or certain MindTouch
pages will cause a Bad Gateway error because the returned HTTP headers
are too large for the default buffer size.

-   Edit the /etc/php/php.ini file, and ensure that the paths assigned
    to open_basedir contain the following:
    -   /usr/share/webapps/
    -   /etc/webapps/
    -   /usr/bin

For instance:

    open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps:/etc/webapps:/usr/bin

Note:/usr/bin is required because MindTouch needs to run certain
external tools, such as /usr/bin/identify (from ImageMagick). This is
not a serious security risk, as the http user is still not able to write
to /usr/bin.

-   Restart Nginx and php-fpm if necessary, and open the relevant URL in
    your favourite web browser (e.g. http://mindtouch).

-   Select "MindTouch Core", and proceed through the installation steps.
    Pay special attention to specifying localhost as the database host
    (instead of 127.0.0.1). This will ensure that the unix socket is
    used for communication with the database. By default, MySQL does not
    enable network access.

Note:If you have a remote MySQL installation, enter those details here,
but be aware that further configuration will be required shortly, and
this has not yet been tested with this package.

-   After clicking "Install MindTouch", you should be taken to a
    confirmation page indicating that your MindTouch licence was
    successfully generated.

-   Please ignore the instructions provided in the "You're not done
    yet!" section. Instead, perform the following commands, which
    achieve the same goal:

    # mindtouch-install-config
    # pacman -R mindtouch-setup

-   If you have a remote MySQL server, you'll need to follow these
    additional steps:
    -   Edit the /etc/webapps/mindtouch/mindtouch.deki.startup.xml file.
    -   Search for the db-options configuration.
    -   Remove the server=/var... key.
    -   Replace Protocol=unix with Protocol=socket.

-   Start the MindTouch API:

    # /etc/rc.d/mindtouch start

-   Click "Continue to MindTouch".

Installing or Removing Prince
-----------------------------

MindTouch can be configured to start using Prince if it's installed
after the MindTouch installation. It's also possible to remove Prince,
in which case the PDF export option becomes unavailable in MindTouch.

-   Install (or remove) the princexml package from the Arch User
    Repository.
-   Edit the /etc/webapps/mindtouch/mindtouch.deki.startup.xml file.
-   Find the princexml-path configuration tag.
-   Set the content of the tag to be /usr/bin/prince, or remove it if
    you want to remove Prince.
-   Restart the MindTouch API.

More Resources
--------------

-   MindTouch Community Portal

Retrieved from
"https://wiki.archlinux.org/index.php?title=MindTouch&oldid=207227"

Category:

-   Web Server
