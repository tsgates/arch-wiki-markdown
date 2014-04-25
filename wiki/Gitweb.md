Gitweb
======

Gitweb is the default web interface provided with git itself and is the
basis for other git scripts like cgit, gitosis and others.

gitweb actually supports fcgi natively, so you don't need to wrap it as
a cgi script
http://repo.or.cz/w/alt-git.git?a=blob_plain;f=gitweb/INSTALL
https://sixohthree.com/1402/running-gitweb-in-fastcgi-mode

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Apache
        -   2.1.1 Apache 2.4
    -   2.2 Lighttpd
    -   2.3 Nginx
    -   2.4 Gitweb config
    -   2.5 Syntax highlighting
-   3 Adding repositories
-   4 See also

Installation
------------

To install gitweb you first have to install git and a webserver. For
this example we use apache but you can also use nginx, lighttpd or
others.

Next you need to link the current gitweb default to your webserver
location. In this example I use the default folder locations:

    # ln -s /usr/share/gitweb /srv/http/gitweb

Note:You may want to double check the server directory to make sure the
symbolic links were made.

Configuration
-------------

> Apache

Add the following to the end of your /etc/httpd/conf/httpd.conf

    <Directory "/srv/http/gitweb">
       DirectoryIndex gitweb.cgi
       Allow from all
       AllowOverride all
       Order allow,deny
       Options ExecCGI
       <Files gitweb.cgi>
       SetHandler cgi-script
       </Files>
       SetEnv  GITWEB_CONFIG  /etc/conf.d/gitweb.conf
    </Directory>

If using a virtualhosts configuration, add this to
/etc/httpd/conf/extra/httpd-vhosts.conf

    <VirtualHost *:80>
        ServerName gitserver
        DocumentRoot /var/www/gitweb
        <Directory /var/www/gitweb>
           Options ExecCGI +FollowSymLinks +SymLinksIfOwnerMatch
           AllowOverride All
           order allow,deny
           Allow from all
           AddHandler cgi-script cgi
           DirectoryIndex gitweb.cgi
       </Directory>
    </VirtualHost>

You could also put the configuration in it's own config file in
/etc/httpd/conf/extra/ but that's up to you to decide.

Apache 2.4

For Apache 2.4 you need to install mod_perl along with git and apache.

Create /etc/httpd/conf/extra/httpd-gitweb.conf

    <IfModule mod_perl.c>
        Alias /gitweb "/usr/share/gitweb"
        <Directory "/usr/share/gitweb">
            DirectoryIndex gitweb.cgi
            Require all granted
            Options ExecCGI
            AddHandler perl-script .cgi
            PerlResponseHandler ModPerl::Registry
            PerlOptions +ParseHeaders
            SetEnv  GITWEB_CONFIG  /etc/conf.d/gitweb
        </Directory>
    </IfModule>

Add the following line to the modules section of
/etc/httpd/conf/httpd.conf

    LoadModule perl_module modules/mod_perl.so

Add the following line to the end of /etc/httpd/conf/httpd.conf

    # gitweb configuration
    Include conf/extra/httpd-gitweb.conf

> Lighttpd

Add the following to /etc/lighttpd/lighttpd.conf:

    server.modules += ( "mod_alias", "mod_cgi", "mod_redirect", "mod_setenv" )
    setenv.add-environment = ( "GITWEB_CONFIG" => "/etc/conf.d/gitweb.conf" )
    url.redirect += ( "^/gitweb$" => "/gitweb/" )
    alias.url += ( "/gitweb/" => "/usr/share/gitweb/" )
    $HTTP["url"] =~ "^/gitweb/" {
           cgi.assign = ( ".cgi" => "" )
           server.indexfiles = ( "gitweb.cgi" )
    }

You may also need to add ".css" => "text/css" to the mimetype.assign
line for GitWeb to display properly.

> Nginx

Consider you've symlinked ln -s /usr/share/gitweb /var/www, append this
location to your nginx configuration:

    /etc/nginx/nginx.conf

    location /gitweb/ {
            index gitweb.cgi;
            include fastcgi_params;
            gzip off;
            fastcgi_param   GITWEB_CONFIG  /etc/conf.d/gitweb.conf;
            if ($uri ~ "/gitweb/gitweb.cgi") {
                    fastcgi_pass    unix:/var/run/fcgiwrap.sock;
            }
    }

Additionally, we have to install fcgiwrap and spawn-fcgi and modify the
fcgiwrap service file:

    /usr/lib/systemd/system/fcgiwrap.service

    [Unit]
    Description=Simple server for running CGI applications over FastCGI
    After=syslog.target network.target

    [Service]
    Type=forking
    Restart=on-abort
    PIDFile=/var/run/fcgiwrap.pid
    ExecStart=/usr/bin/spawn-fcgi -s /var/run/fcgiwrap.sock -P /var/run/fcgiwrap.pid -u http -g http -- /usr/sbin/fcgiwrap
    ExecStop=/usr/bin/kill -15 $MAINPID

    [Install]
    WantedBy=multi-user.target

In the end, enable and restart the services:

    systemctl enable nginx fcgiwrap
    systemctl start nginx fcgiwrap

> Gitweb config

Next we need to make a gitweb config file. Open (or create if it does
not exist) the file /etc/conf.d/gitweb.conf and place this in it:

    /etc/conf.d/gitweb.conf

    $git_temp = "/tmp";

    # The directories where your projects are. Must not end with a slash.
    $projectroot = "/path/to/your/repositories"; 

    # Base URLs for links displayed in the web interface.
    our @git_base_url_list = qw(git://<your_server> http://git@<your_server>); 

To enable "blame" view (showing the author of each line in a source
file), add the following line:

    $feature{'blame'}{'default'} = [1];

Now the the configuration is done, please restart your webserver. For
apache:

    systemctl restart httpd 

Or for lighttpd:

    systemctl restart lighttpd

> Syntax highlighting

To enable syntax highlighting with Gitweb, you have to first install the
highlight package:

When highlight has been installed, simply add this line to your
gitweb.conf:

    $feature{'highlight'}{'default'} = [1];

Save the file and highlighting should now be enabled.

Adding repositories
-------------------

To add a repository go to your repository folder, make your repository
like so:

    mkdir my_repository.git
    git init --bare my_repository.git/
    cd my_repository.git/
    touch git-daemon-export-ok
    echo "Short project's description" > .git/description

Next open the .git/config file and add this:

    [gitweb]
            owner = Your Name

This will fill in the "Owner" field in gitweb. It's not required.

I assumed that you want to have this repository as "central" repository
storage where you push your commits to so the git-daemon-export-ok and
--bare are here to have minimal overhead and to allow the git daemon to
be used on it.

That is all for making a repository. You can now see it on your
http://localhost/gitweb (assuming everything went fine). You do not need
to restart apache for new repositories since the gitweb cgi script
simply reads your repository folder.

See also
--------

This howto was mainly based on the awesome howto from howtoforge:
http://www.howtoforge.com/how-to-install-a-public-git-repository-on-a-debian-server.
I only picked the parts that are needed to get it working and left the
additional things out.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gitweb&oldid=304613"

Category:

-   Version Control System

-   This page was last modified on 15 March 2014, at 15:06.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
