Mod wsgi
========

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installation                                                       |
|     -   2.1 Apache Module : mod_wsgi for Python 2.6                      |
|         -   2.1.1 Install Package                                        |
|         -   2.1.2 Configure Apache                                       |
|         -   2.1.3 Test mod_wsgi                                          |
|                                                                          |
|     -   2.2 Customization                                                |
|         -   2.2.1 Use mod_wsgi and Python 3.1                            |
|         -   2.2.2 Compilation using ABS                                  |
|                                                                          |
| -   3 See Also                                                           |
+--------------------------------------------------------------------------+

Introduction
------------

According to the project's site :

The aim of mod_wsgi is to implement a simple to use Apache module which
can host any Python application which supports the Python WSGI
interface. The module would be suitable for use in hosting high
performance production web sites, as well as your average self managed
personal sites running on web hosting services.

mod_wsgi is an Apache module that embeds a Python application within the
server and allow them to communicate through the Python WSGI interface
as defined in the Python PEP 333. WSGI is one of the Python ways to
produce high quality and high performance web applications.

WSGI provide a standard way to interface different web-apps without
hassle. Several well-know python applications or frameworks provide wsgi
for easy deployment and embedding. It means that you can embed your
Django-powered blog and your project's Trac into a single Pylons
application that wraps around them to deals with, say, authentication
without modifying the formers.

Example:

-   Pylons
-   Django
-   Turbo-gear
-   Trac
-   Moin-moin
-   Zope

mod_wsgi 3.x supports those Python versions: 2.3, 2.4, 2.5, 2.6, 3.1
(3.0 is NOT supported as Python's developers have dropped support for
Python 3.0).

Installation
------------

> Apache Module : mod_wsgi for Python 2.6

This document describes how to set up and test the Apache module
mod_wsgi compiled against Python 2.6 on an Arch Linux system.

Install Package

The mod_wsgi package lives in extra, install it with pacman (or whatever
you want) :

       # pacman -S mod_wsgi2

Configure Apache

-   As requested by the installer, add the following line to
    /etc/httpd/conf/httpd.conf:

    LoadModule wsgi_module modules/mod_wsgi.so

-   Restart Apache

       # /etc/rc.d/httpd restart

-   Check to make sure that Apache loaded correctly

Test mod_wsgi

-   Add this block to /etc/httpd/conf/httpd.conf if you are not using
    the latest apache 2.4:

    WSGIScriptAlias /wsgi_app /home/www/wsgi-scripts/wsgi_app.py

    <Directory /home/www/wsgi-scripts>
        Order allow,deny
        Allow from all
    </Directory>

-   If you use apache 2.4.x, add this block to
    /etc/httpd/conf/httpd.conf

    WSGIScriptAlias /wsgi_app /home/www/wsgi-scripts/wsgi_app.py

    <Directory /home/www/wsgi-scripts>
        Order allow,deny
        Require all granted
    </Directory>

-   Create a file in /home/www/wsgi-scripts called wsgi_app.py with this
    code :

    #-*- coding: utf-8 -*-
    import pprint
    def wsgi_app(environ, start_response):
        """ Display the contents of the environ dictionary."""
        # produce some content
        output =  pprint.pformat(environ)

        # send first header and status
        status = '200 OK'
        headers = [('Content-type', 'text/plain'),
    		('Content-Length', str(len(output)))]
        start_response(status, headers)

        # wsgi apps should return and iterable, the following is acceptable too :
        # return [output]
        yield output

    # mod_wsgi need the *application* variable to serve our small app
    application = wsgi_app

-   Restart Apache

       # /etc/rc.d/httpd  restart

-   Check to make sure that Apache loaded correctly

-   Navigate to http://localhost/wsgi_app and discover the ugly environ
    dictionary..

Note:While mod_python will execute any Python script that ends with .py,
mod_wsgi only executes python applications.

> Customization

Use mod_wsgi and Python 3.1

This document explain how run mod_wsgi along Python 3.1 t instead of
Python 2.6 that the Arch Linux binary package from repository offer. It
will be assumed you have already installed the necessary packages (as
described in ABS plus Python 3.1 : pacman -S python3).

Compilation using ABS

-   Update your ABS to ensure you have the very last PKGBUILD version.

-   Prepare the mod_wsgi folder into your home:

       $ mkdir -p ~/abs
       $ cp -r /var/abs/extra/mod_wsgi ~/abs

-   Edit the PKGBUILD: replace the --with-python flag with the correct
    Python's version:

        --with-python=/usr/bin/python || return 1

by

    --with-python=/usr/bin/python3.1 || return 1

-   Build the package (run this command inside the PKGBULD folder):

       $ makepkg -s

-   Install it (as a root):

       # pacman -U mod_wsgi-3.0-1-$ARCH.pkg.tar.gz

-   Restart Apache :

      # /etc/rc.d/httpd restart

-   Test your set-up with this small app :

    #-*- coding: utf-8 -*-
    def wsgi_app(environ, start_response):
        import sys
        output = str(sys.version)
        status = '200 OK'
        headers = [('Content-type', 'text/plain'),
                   ('Content-Length', str(len(output)))]
        start_response(status, headers)
        yield output

    application = wsgi_app

When browsing to the url you bound your app on you should see :

       3.1.1 (r311:74480, Aug 27 2009, 04:56:37) 
       [GCC 4.4.1]

If you read :

       2.6.4 (r264:75706, Oct 27 2009, 06:25:13) 
       [GCC 4.4.1]

You have failed to compile and install mod_wsgi against Python3.1. Retry
and double check all the previous steps.

See Also
--------

-   mod_wsgi project's site
-   Quick Configuration Guide
-   Upgrading to 2.4 from 2.2

This article is partially adapted from mod_python. Many thanks to the
authors.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mod_wsgi&oldid=236327"

Category:

-   Web Server
