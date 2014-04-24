Mod perl
========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Enabling Perl + Apache
    -   1.1 Allow perl to execute scripts for certain directories
        -   1.1.1 Alternative 1: Using virtual hosts
        -   1.1.2 Alternative 2: Just enable for a certain subdirectory
    -   1.2 Turn on perl for directory listings
    -   1.3 Try it out

Enabling Perl + Apache
----------------------

Install mod_perl from the official repositories.

Add this to httpd.conf:

    LoadModule perl_module modules/mod_perl.so

> Allow perl to execute scripts for certain directories

There are two possible methods: creating a virtual host, or enabling
perl for a subdirectory.

Alternative 1: Using virtual hosts

Add a virtual host with various settings in extra/httpd-vhosts.conf:

    <VirtualHost perlwebtest:80>
    	Servername perlwebtest
    	DocumentRoot /srv/http/perlwebtest
    	ErrorLog /var/log/httpd/perlwebtest-error.log
    	CustomLog /var/log/httpd/perlwebtest-access.log combined
    	<Directory /srv/http/perlwebtest>
    		AddHandler perl-script .pl
    		PerlResponseHandler ModPerl::Registry
    		Options +ExecCGI
    		PerlOptions +ParseHeaders
    		AllowOverride All
    		Order allow,deny
    		Allow from all
    	</Directory>
    </VirtualHost>

Ensure /etc/httpd/conf/httpd.conf includes the line

    Include conf/extra/httpd-vhosts.conf

  
 Make sure you do not have "Options Indexes FollowSymLinks"!

Add "perlwebtest" as localhost in /etc/hosts:

    127.0.0.1	localhost YOURHOSTNAME perlwebtest

Use your hostname instead of YOURHOSTNAME.

Alternative 2: Just enable for a certain subdirectory

Add the following to /etc/httpd/conf/httpd.conf:

    Alias /perlwebtest/ /srv/http/perlwebtest/
    <Location /perlwebtest/>
          AddHandler perl-script .pl
          AddHandler perl-script .cgi
          PerlResponseHandler ModPerl::Registry
          PerlOptions +ParseHeaders
          Options +ExecCGI
          Order allow,deny
          Allow from all
    </Location>

> Turn on perl for directory listings

Create /etc/httpd/conf/extra/perl_module.conf as well:

    # Required modules: dir_module, perl_module

    <IfModule dir_module>
            <IfModule perl_module>
                    DirectoryIndex index.pl index.html
            </IfModule>
    </IfModule>

Then include it in /etc/httpd/conf/httpd.conf:

    # Perl
    Include conf/extra/perl_module.conf

> Try it out

Create index.pl in /srv/http/perlwebtest:

    #!/usr/bin/perl
    print "Content-type: text/plain\n\n";
    print "mod_perl now works\n";

Restart apache:

    # rc.d restart httpd

Usually you can just reload:

    # rc.d reload httpd

Then visit http://perlwebtest (if you created a virtual host) or
http://localhost/perlwebtest (if you only enabled one directory).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mod_perl&oldid=305774"

Category:

-   Web Server

-   This page was last modified on 20 March 2014, at 02:12.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
