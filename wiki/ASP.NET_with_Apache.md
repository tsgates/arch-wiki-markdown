ASP.NET with Apache
===================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Apache.     
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Describes how to show ASP.NET-sites under Apache by using Mod_Mono.

From Mod_Mono's site:

"Mod_Mono is an Apache 2.0/2.2 module that provides ASP.NET support for
the web's favorite server, Apache (http://httpd.apache.org/)."

Contents
--------

-   1 Installing
-   2 Configuring
    -   2.1 AutoHosting
-   3 Testing

Installing
----------

The setup requires mono and mono_mod for Apache compliance. Package xsp
is a simple webserver for ASP.NET, optionally installed for testing the
configuration.

     pacman -S mono mod_mono xsp

Configuring
-----------

Edit /etc/httpd/conf/httpd.conf and add the following line:

     Include /etc/httpd/conf/mod_mono.conf

Finally, restart apache with:

     systemctl restart httpd.service

Now, Apache should be able to show ASP.NET-pages.

> AutoHosting

Further details: http://www.mono-project.com/AutoHosting

With this setting, configuring apache for each deployment is no longer
needed; just place the application in any directory within html-root and
it will be promptly auto-configured. Add the following lines to
/etc/httpd/conf/httpd.conf to enable the option:

     # Choose ASP2.0 support instead of the default 1.0
     MonoServerPath "/usr/bin/mod-mono-server2"
     MonoAutoApplication enabled

Testing
-------

If xsp is installed and html-path is /httpd/html, then open a browser
and access http://server/xsp/ to see an overview over the
ASP.NET-testfiles.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASP.NET_with_Apache&oldid=290389"

Category:

-   Web Server

-   This page was last modified on 26 December 2013, at 02:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
