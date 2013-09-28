Apache and FastCGI
==================

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 mod_fastcgi                                                        |
|     -   2.1 Step 1: Installation                                         |
|     -   2.2 Step 2: Configuration                                        |
|                                                                          |
| -   3 mod_fcgid                                                          |
|     -   3.1 Step 1: Installation                                         |
|     -   3.2 Step 2: Configuration                                        |
|                                                                          |
| -   4 Troubleshooting                                                    |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Introduction
------------

There are two FastCGI modules for Apache:

-   mod_fastcgi (seems to be faster; see [1])
-   mod_fcgid

They both have permissive licenses (custom for mod_fastcgi and GPL for
mod_fcgid) and they are both available in Extra repository.

Apache 2.4 (available as AUR package) now provides an official module,
mod_proxy_fcgi. See configuration example for php-fpm.

mod_fastcgi
-----------

> Step 1: Installation

    pacman -S mod_fastcgi

> Step 2: Configuration

First you need to load the fastcgi module. Make sure that the following
is present and uncommented in your httpd.conf:

    LoadModule fastcgi_module modules/mod_fastcgi.so

Then you need to tell Apache when to use FastCGI.

For example you can ask Apache to treat all .fcgi files as fastcgi
applications:

    <IfModule fastcgi_module>
      AddHandler fastcgi-script .fcgi # you can put whatever extension you want
    </IfModule>

Remember that standard CGI restrictions apply, files must be in an
ExecCGI enabled directory to execute.

mod_fcgid
---------

> Step 1: Installation

    pacman -S mod_fcgid

> Step 2: Configuration

First you need to load the fastcgi module. Make sure that the following
is present and uncommented in your httpd.conf:

    LoadModule fcgid_module modules/mod_fcgid.so

Then you need to tell Apache when to use FastCGI.

For example you can ask Apache to treat all .fcgi files as fastcgi
applications:

    <IfModule fcgid_module>
      AddHandler fcgid-script .fcgi # you can put whatever extension you want
    </IfModule>

Remember that standard CGI restrictions apply, files must be in an
ExecCGI enabled directory to execute.

Troubleshooting
---------------

It doesn't work? Apache error log (/var/log/httpd/error_log) should help
you find the problem.

See also
--------

-   lighttpd#FastCGI

Retrieved from
"https://wiki.archlinux.org/index.php?title=Apache_and_FastCGI&oldid=237840"

Category:

-   Web Server
