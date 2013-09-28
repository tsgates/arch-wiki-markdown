Lighttpd
========

  
 Lighttpd is "a secure, fast, compliant, and very flexible web-server
that has been optimized for high-performance environments. It has a very
low memory footprint compared to other webservers and takes care of
cpu-load. Its advanced feature-set (FastCGI, CGI, Auth,
Output-Compression, URL-Rewriting and many more) make lighttpd the
perfect webserver-software for every server that suffers load problems."

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Basic Setup                                                  |
|     -   2.2 FastCGI                                                      |
|         -   2.2.1 PHP                                                    |
|             -   2.2.1.1 Using php-fpm                                    |
|             -   2.2.1.2 eAccelerator                                     |
|             -   2.2.1.3 Try a php page                                   |
|                                                                          |
|         -   2.2.2 Ruby on Rails                                          |
|         -   2.2.3 Python FastCGI                                         |
|                                                                          |
|     -   2.3 SSL                                                          |
|         -   2.3.1 Server Name Indication                                 |
|         -   2.3.2 Redirect HTTP requests to HTTPS                        |
|                                                                          |
|     -   2.4 Output Compression                                           |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 Lighttpd downloads .php files                                |
|     -   3.2 Styles (CSS) not working properly                            |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install the lighttpd package from the official repositories.

Configuration
-------------

> Basic Setup

The lighttpd configuration file is: /etc/lighttpd/lighttpd.conf. By
default it should produce a working test page.

To check your lighttpd.conf for bugs you can use this command - helps
finding misconfigurations very fast:

    $ lighttpd -t -f /etc/lighttpd/lighttpd.conf

The default configuration file specifies /srv/http/ as the document
directory served.

It may be necessary to add a user and group for http if you do not
already have one. That user needs to have write permissions to
/var/log/lighttpd as well, so we will make it the owner of the folder:

    # groupadd http
    # useradd http
    # chown -R http /var/log/lighttpd

To test the install:

    # echo 'TestMe!' >> /srv/http/index.html
    # chmod 755 /srv/http/index.html

To start the server:

    # systemctl start lighttpd

Then point your browser to localhost, and you should see the test page.

To start the server on every boot:

    # systemctl enable lighttpd

Example configuration files are available in /usr/share/doc/lighttpd/.

> FastCGI

Install fcgi. Now you have lighttpd with fcgi support. If it was that
what you wanted you are all set. People that want Ruby on Rails, PHP or
Python should continue.

Note: New default user and group: Instead of group "nobody" lighttpd now
runs as user/group "http" by default.

First copy the example config file form
/usr/share/doc/lighttpd/config/conf.d/fastcgi.conf to
/etc/lighttpd/conf.d

The following needs adding to the config file,
/etc/lighttpd/conf.d/fastcgi.conf

    server.modules += ( "mod_fastcgi" )

    #server.indexfiles += ( "dispatch.fcgi" ) #this is deprecated
    index-file.names += ( "dispatch.fcgi" ) #dispatch.fcgi if rails specified

    server.error-handler-404   = "/dispatch.fcgi" #too
    fastcgi.server = (
        ".fcgi" => (
          "localhost" => ( 
            "socket" => "/run/lighttpd/rails-fastcgi.sock",
            "bin-path" => "/path/to/rails/application/public/dispatch.fcgi"
          )
        )
    )

Then in /etc/lighttpd/lighttpd.conf:

    include "conf.d/fastcgi.conf"

For PHP or Ruby on Rails see the next sections.

PHP

Install php and php-cgi (see also PHP and LAMP).

Check that php-cgi is working php-cgi --version

    PHP 5.4.3 (cgi-fcgi) (built: May  8 2012 17:10:17)
    Copyright (c) 1997-2012 The PHP Group
    Zend Engine v2.4.0, Copyright (c) 1998-2012 Zend Technologies

If you get a similar output then php is installed correctly.

Note:Please keep in mind if you receive errors like No input file found
after attempting to access your php files then make sure
/etc/php/php.ini has the directives enabled, see here for more
information lighttpd FAQ entry:

    cgi.fix_pathinfo=1
    open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/another/path:/second/path

And that the files are world readable,

    # chmod -R 755

In /etc/lighttpd/conf.d/fastcgi.conf add:

    server.modules += ( "mod_fastcgi" )

    #server.indexfiles += ( "index.php" ) #this is deprecated
    index-file.names += ( "index.php" )

    fastcgi.server = (
        ".php" => (
          "localhost" => ( 
            "bin-path" => "/usr/bin/php-cgi",
            "socket" => "/run/lighttpd/php-fastcgi.sock",
            "max-procs" => 4, # default value
            "bin-environment" => (
              "PHP_FCGI_CHILDREN" => "1", # default value
            ),
            "broken-scriptfilename" => "enable"
          ))
    )

Then in /etc/lighttpd/lighttpd.conf:

    include "conf.d/fastcgi.conf"

Finally reload the configuration

    # systemctl reload lighttpd

Using php-fpm

There is no adaptive spawning anymore in recent lighttpd releases. For
dynamic management of PHP processes, you can use php-fpm.

    # pacman -S php-fpm
    # rc.d start php-fpm

Note:You can configure the number of servers in the pool and tweak other
configuration options by editing the file /etc/php/php-fpm.conf. More
details on php-fpm can be found on the php-fpm website. You should also
note that when you make changes to /etc/php/php.ini you will need to
restart php-fpm

In /etc/lighttpd/conf.d/fastcgi.conf add:

    server.modules += ( "mod_fastcgi" )

    index-file.names += ( "index.php" ) 

    fastcgi.server = (
        ".php" => (
          "localhost" => ( 
            "socket" => "/run/php-fpm/php-fpm.sock",
            "broken-scriptfilename" => "enable"
          ))
    )

eAccelerator

Install eaccelerator from the AUR.

Add own config file for eaccelerator:

    /etc/php/conf.d/eaccelerator-own.ini

    zlib.output_compression = On
    cgi.fix_pathinfo=1
    eaccelerator.cache_dir="/home/phpuser/eaccelerator/cache"

Tip:I additionally set safe_mod to On in my setup, but this is not
required.

Try a php page

Create the following php page, name it index.php, and place a copy in
both /srv/http/ and /srv/http-ssl/html/

    <?php
    phpinfo();
    ?>

Try navigating with a web browser to both the http and https address of
your server. You should see the phpinfo page.

Check eaccelerator caching:

    # ls -l /home/phpuser/eaccelerator/cache

If the above command outputs the following:

    -rw-------  1 phpuser phpuser 456 2005-05-05 14:53 eaccelerator-277.58081
    -rw-------  1 phpuser phpuser 452 2005-05-05 14:53 eaccelerator-277.88081

Then eaccelerator is happily caching your php scripts to help speed
things up.

Ruby on Rails

Install and configure FastCGI (see #FastCGI above).

Install ruby from [extra] and ruby-fcgi from AUR.

Follow instructions on RubyOnRails.

Python FastCGI

Install and configure FastCGI (see #FastCGI above).

Install flup:

    # pacman -S python2-flup

Configure:

    fastcgi.server = (
        ".py" =>
        (
            "python-fcgi" =>
            (
            "socket" => "/run/lighttpd/fastcgi.python.socket",
             "bin-path" => "test.py",
             "check-local" => "disable",
             "max-procs" => 1,
            )
        )
    )

Put the test.py in the root of your server (don't forget to chmod +x it)

    #!/usr/bin/env python2

    def myapp(environ, start_response):
        print 'got request: %s' % environ
        start_response('200 OK', [('Content-Type', 'text/plain')])
        return ['Hello World!']

    if __name__ == '__main__':
        from flup.server.fcgi import WSGIServer
        WSGIServer(myapp).run()

Thanks to firecat53 for his explanation

> SSL

Generate an SSL Cert, e.g. like that:

    # mkdir /etc/lighttpd/certs
    # openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/lighttpd/certs/www.example.com.pem -out /etc/lighttpd/certs/www.example.com.pem
    # chmod 600 /etc/lighttpd/certs/www.example.com.pem

Edit /etc/lighttpd/lighttpd.conf. To make lighttpd SSL-only (you
probably need to set the server port to 443 as well)

    ssl.engine = "enable" 
    ssl.pemfile = "/etc/lighttpd/certs/www.example.com.pem"

To enable SSL in addition to normal HTTP

    $SERVER["socket"] == ":443" {
        ssl.engine                  = "enable" 
        ssl.pemfile                 = "/etc/lighttpd/certs/www.example.com.pem" 
     }

If you want to serve different sites, you can change the document root
inside the socket conditional:

    $SERVER["socket"] == ":443" {
        server.document-root = "/srv/ssl" # use your ssl directory here
        ssl.engine                 = "enable"
        ssl.pemfile                = "/etc/lighttpd/certs/www.example.com.pem"  # use the path where you created your pem file
     }

or as alternative you can use the scheme conditional to distinguish
between secure and normal requests.

    $HTTP["scheme"] == "https" {
        server.document-root = "/srv/ssl" # use your ssl directory here
        ssl.engine                 = "enable"
        ssl.pemfile                = "/etc/lighttpd/certs/www.example.com.pem"  # use the path where you created your pem file
     }

Note that you cannot use the scheme conditional around ssl.engine above,
since lighttpd needs to know on what port to enable SSL.

Server Name Indication

To use SNI with lighttpd, simply put additional ssl.pemfile
configuration directives inside host conditionals. A default ssl.pemfile
is still required.

    $HTTP["host"] == "www.example.org" {
        ssl.pemfile = "/etc/lighttpd/certs/www.example.org.pem" 
    }

    $HTTP["host"] == "mail.example.org" {
        ssl.pemfile = "/etc/lighttpd/certs/mail.example.org.pem" 
    }

Redirect HTTP requests to HTTPS

You should add "mod_redirect" in server.modules array in
/etc/lighttpd/lighttpd.conf:

    server.modules += ( "mod_redirect" )

    $SERVER["socket"] == ":80" {
      $HTTP["host"] =~ "example.org" {
        url.redirect = ( "^/(.*)" => "https://example.org/$1" )
        server.name                 = "example.org" 
      }
    }

    $SERVER["socket"] == ":443" {
      ssl.engine = "enable" 
      ssl.pemfile = "/etc/lighttpd/ssl/server.pem" 
      server.document-root = "..." 
    }

To redirect all hosts to their secure equivalents use the following in
place of the socket 80 configuration above:

    $SERVER["socket"] == ":80" {
      $HTTP["host"] =~ "(.*)" {
        url.redirect = ( "^/(.*)" => "https://%1/$1" )
      }
    }

To redirect all hosts for part of the site (e.g. secure or phpmyadmin):

    $SERVER["socket"] == ":80" {
      $HTTP["url"] =~ "^/secure" {
        url.redirect = ( "^/(.*)" => "https://example.com/$1" )
      }
    }

> Output Compression

In /etc/lighttpd/lighttpd.conf add

    var.cache_dir           = "/var/cache/lighttpd"

Then create directory for a compressed files:

    # mkdir /var/cache/lighttpd/compress
    # chown http:http /var/cache/lighttpd/compress

Copy example configuration file:

    # mkdir /etc/lighttpd/conf.d
    # cp /usr/share/doc/lighttpd/config/conf.d/compress.conf /etc/lighttpd/conf.d/

Add following in /etc/lighttpd/lighttpd.conf:

    include "conf.d/compress.conf"

Note: You can not do this (copy compress.conf) and add a needed content
in /etc/lighttpd/lighttpd.conf instead.

Troubleshooting
---------------

> Lighttpd downloads .php files

If lighttpd downloads .php files instead of "initializing" them you
probably missed to add these lines to your /etc/lighttpd/lighttpd.conf.

    server.modules = (
                       "mod_fastcgi",
                     )

    fastcgi.server = ( ".php" => ((
                         "bin-path" => "/usr/bin/php-cgi", #depends where your php-cgi has been installed. Default here.
                         "socket" => "/tmp/php.socket",
                         "max-procs" => 2,
                         "bin-environment" => (
                           "PHP_FCGI_CHILDREN" => "16",
                           "PHP_FCGI_MAX_REQUESTS" => "10000"
                         ),
                         "bin-copy-environment" => (
                           "PATH", "SHELL", "USER"
                         ),
                         "broken-scriptfilename" => "enable"
                     )))

> Styles (CSS) not working properly

The default lighttpd config does not include a mimetype definition for
CSS so when standards compliant browsers get text/html instead of
text/css they get confused and nothing displays properly. To fix this
add an entry for CSS.

    mimetype.assign	= (
      ".html" => "text/html",
      ".txt" => "text/plain",
      ".jpg" => "image/jpeg",
      ".png" => "image/png",
      ".css" => "text/css",
      "" => "application/octet-stream"
    )

New lines are not needed and are only used here for readability.

Note: The "application/octet-stream" declaration must be at the end. It
is a catch-all, and any declarations after it will be ignored.

See also
--------

-   Lighttpd wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lighttpd&oldid=251879"

Category:

-   Web Server
