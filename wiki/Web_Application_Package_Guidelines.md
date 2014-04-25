Web Application Package Guidelines
==================================

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Symlinking part  
                           of webapps causes major  
                           issues. Furthermore the  
                           file system layout is    
                           insufficient for more    
                           than one instance of a   
                           webapp. (Discuss)        
  ------------------------ ------------------------ ------------------------

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

This page describes how to package web application which tends to
install into /srv/http (for example packages written in php, such as
phpmyadmin and phpvirtualbox).

Contents
--------

-   1 Directory structure
-   2 Install web application package
    -   2.1 Install with Apache
    -   2.2 Install with Nginx

Directory structure
-------------------

Layout example:

-   /etc/webapps/$pkgname
-   /usr/share/webapps/$pkgname
-   /var/... (according to generic FHS conventions)

/usr/share/webapps/$pkgname files and/or directories should be symlinked
into /var and /etc/.

/etc/webapps/$pkgname should contain some examples which helps to setup
web-server to run this web application:

-   /etc/webapps/$pkgname/apache.example.conf
-   /etc/webapps/$pkgname/nginx.example.conf
-   /etc/webapps/$pkgname/other-web-server.example.conf

Install web application package
-------------------------------

> Install with Apache

Install package

       # install 'foo' packaage
       # cp /etc/webapps/foo/apache.example.conf /etc/httpd/conf/extra/foo.conf
       # edit /etc/httpd/conf/httpd.conf
          Include conf/extra/foo.conf

Start server

       # systemctl start httpd

> Install with Nginx

Install package

       # install 'foo' pacakge
       # ln -s /usr/share/webapps/foo /srv/http
       # cp /etc/webapps/foo/nginx.example.conf /etc/nginx/extra/foo.conf # conf file may be not present.

You may need configure FastCGI-PHP, FastCGI-CGI

Start server

       # systemctl start <fastcgi>
       # systemctl start nginx

Retrieved from
"https://wiki.archlinux.org/index.php?title=Web_Application_Package_Guidelines&oldid=270134"

Category:

-   Package development

-   This page was last modified on 6 August 2013, at 18:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
