Foswiki
=======

Foswiki is a free enterprise collaboration platform written in Perl;
developed, supported and maintained by its users and the open-source
community.

More information:

-   Wikipedia article
-   The Foswiki website

You may also be interested in XWiki, which caters to similar needs, but
is Java-based.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Apache                                                             |
| -   3 Nginx                                                              |
| -   4 After Installation                                                 |
| -   5 Upgrade                                                            |
| -   6 Troubleshooting                                                    |
|     -   6.1 Argument "5.8.1" isn't numeric in numeric lt (<) ... when    |
|         accessing configure                                              |
+--------------------------------------------------------------------------+

Installation
------------

Note:I abandoned the idea of adopting and maintaining the foswiki
package on the AUR for the following reasons:

-   Foswiki currently requires some user intervention on every upgrade.
-   Foswiki has a convenient mechanism for installing, updating, and
    removing plugins that does not function unless the installation
    directory is writeable.

These instructions assume you will be using the directory
/srv/http/foswiki to store your Foswiki installation.

The Foswiki Installation Guide is very thorough (although maybe a bit
overwhelming), and makes an excellent reference. Follow along using the
official guide, but you will find these notes to be more concise, and
more specific to ArchLinux.

-   You will need to install the following packages in order for Foswiki
    to work:
    -   rcs
    -   perl-crypt-passwdmd5 (AUR Package)
    -   perl-cgi-session
    -   perl-html-tree
    -   perl-libwww

-   From the Foswiki website, determine the URL of the latest Foswiki
    release.
-   Download and unpack the archive as the http user at
    /srv/http/foswiki. For instance (as root):

    # su -s /bin/bash - http
    $ mkdir /tmp/foswiki
    $ cd /tmp/foswiki
    $ wget <archive-url>
    $ tar xzf Fos*
    $ rm *.tgz
    $ exit
    # mv /tmp/foswiki/* /srv/http/foswiki
    # rmdir /tmp/foswiki
    # cd /srv/http/foswiki

-   Depending on how keen you are on locking down access to the Foswiki
    installation, you could restrict access to the installation
    directory:

    # chmod o-rx .

-   At this point, you want to ensure that all the files have the
    correct permissions. (See the Foswiki guide on Setting File Access
    Permissions for details.)

If you would like to determine whether the files already have the
correct permissions, you can make use of find to test permissions
against the example commands listed in the above Foswiki guide. For
instance, this will find any directories that do not have their access
mode set to 755:

    # find . -type d \! -perm 755

As of version 1.1.5, I found that only one file was incorrectly set to
be owner-writable; all other files appeared to have the correct
permissions fresh out of the archive. The following command can be used
to set the correct permissions (either as root or http), and will also
catch any similar files that may display the same issue in future:

    $ find pub data -name '*,v' -type f -exec chmod 444 \{\} \;

-   Copy bin/LocalLib.cfg.txt to bin/LocalLib.cfg, ensuring that
    ownership and access rights are identical to the original file.
-   Edit your newly copied file so that the $foswikiLibPath line reads
    as follows:

    $foswikiLibPath = '/srv/http/foswiki/lib';

Apache
------

See the Configure the Webserver section of the Foswiki Installation
Guide for guidance on getting set up with Apache.

Nginx
-----

Setting up Nginx to work correctly with Foswiki is tricky, but almost
everything you need is provided here. The configuration is heavily
commented, to make it as easy as possible to modify it to suit your
needs.

Foswiki is written in Perl and is generally intended to be run as a
series of CGI scripts. Check out the FastCGIEngineContrib if you're
interested in running Foswiki as a FastCGI application, but be aware
that some plugins do not work well with this setup.

-   Install fcgiwrap (See the Nginx#fcgiwrap page). The rest of this
    configuration assumes you've set up fcgiwrap using a socket.

-   Create a file with the following contents at
    /etc/nginx/foswiki.conf:

    location /bin/configure {
      # It is important to protect this location with a password.
      auth_basic "Restricted";
      auth_basic_user_file htpasswd/foswiki-configure;
      # (Temporarily?) allow an IP address below for configuration access
      #allow 127.0.0.1;
      deny all;
      fastcgi_pass fcgiwrap;
      include      fastcgi.conf;
      fastcgi_split_path_info ^(/bin/configure)(.*);
      fastcgi_param PATH_INFO $fastcgi_path_info;
    }
    location /bin/ {
      fastcgi_pass fcgiwrap;
      include      fastcgi.conf;
      fastcgi_split_path_info ^(/bin/\w+)(.*);
      fastcgi_param PATH_INFO $fastcgi_path_info;
      # Setting the NO_FOSWIKI_SESSION environment variable prevents a
      # session being created. If a bot is spawning too many sessions, add its
      # user agent string to this regexp.
      set $no_foswiki_session "";
      if ($http_user_agent ~* "^gsa-crawler") {
        set $no_foswiki_session true;
      }
      fastcgi_param NO_FOSWIKI_SESSION $no_foswiki_session;
      # This prevents the %INCLUDE% macro from including our own topics as URLs
      # and also prevents other Foswikis from doing the same. This is important to
      # prevent the most obvious Denial of Service attacks.
      if ($http_user_agent = "") { return 403; }
    }
    # Contains public-facing files.
    # The rewrite rule is necessary for enforcing access policies. Otherwise,
    # access would be free to this directory. Comment it out if you don't like
    # the performance hit (but see /pub/... locations below).
    location /pub/ {
      rewrite ^/pub/(.*)$ /bin/viewfile/$1 last;
    }
    # Prevent HTML attachments from rendering directly in the browser; it could
    # potentially be a security risk.
    location ~* /pub/.*\.html?$ {
      types {}
      default_type application/octet-stream;
    }
    # These locations contain CSS, JS, and other assets that are trusted and really
    # need to be cached, and that we don't want going through CGI for reasons of
    # performance. The ^~ prefix prevents the above HTML security fix from applying
    # to these locations (e.g. WYSIWYG uses some HTML from /pub/System).
    location ^~ /pub/System/ {  # General system support files
    }
    location ^~ /pub/Main/SitePreferences/ {  # Attachments for site logos etc...
    }
    # Anything in the Trash should not be visible.
    # This is not necessary if access policies are being enforced for the /pub
    # directory through the rewrite rule above.
    #location /pub/Trash {
    #  deny all;
    #}
    location /robots.txt {
    }
    # Pretty URLs: /Main/Foo, /edit/Main/Foo, etc...
    location / {
      rewrite ^/(?:[A-Z].*)?$ /bin/view$uri last;
      rewrite ^/([a-z]+/[A-Z].*) /bin/$1 last;
      # The above should catch most day-to-day things. This is for some more unusual
      # situations (e.g. when Main requires authentication, when resubmitting a
      # form, maybe some other situations):
      rewrite ^ /bin$uri last;
    }

Warning:When working on a production installation, take care of the
allow directive near the top of the file. Keep it commented out when you
don't need access to the configure script. This script is a potential
security weak point for Foswiki, and is best kept locked down when it's
not needed.

-   Uncomment the allow directive near the top of the file, and replace
    127.0.0.1 with the IP address of your local machine.
-   Now, add a new server section to your main nginx configuration file
    at /etc/nginx/nginx.conf; for instance:

    server {
      listen 80;
      server_name foswiki;
      root /srv/http/foswiki;

      include foswiki.conf;
    }

-   If you haven't done so already, add an upstream block before the
    server blocks in nginx.conf, as the foswiki.conf file references
    this:

    upstream fcgiwrap {
      server unix:/var/run/fcgiwrap.sock;
    }

-   Follow the instructions from the Nginx Wiki to create an htpasswd
    file at the required location. The above configuration expects such
    a file at /etc/nginx/htpasswd/foswiki-configure. Don't forget to set
    sensible file permissions for this file. For instance, as root:

    # mkdir -p /etc/nginx/htpasswd
    # cd /etc/nginx/htpasswd
    # printf "admin:$(openssl passwd -crypt <YOURPASSWORD>)\n" >> foswiki-configure
    # chgrp http foswiki-configure
    # chmod 640 foswiki-configure

-   Navigate your browser to the /configure URL, e.g.:
    http://foswiki/configure.
-   In the General Path Settings section, remove the contents of the
    {ScriptUrlPaths}{view} setting. It should be completely blank. (This
    will make Foswiki use the pretty URLs we've set up in the Nginx
    configuration.)
-   All other settings should be fine, so press "Save Changes", and
    choose a password to protect your configuration. (You may as well
    use the same password you set for your HTTP Basic Authentication.)
-   Review the Foswiki configuration as desired, and save once more.
-   Comment out the allow directive near the top of
    /etc/nginx/foswiki.conf to protect the configure script.
-   Your Foswiki installation should now be complete.

After Installation
------------------

Once your wiki is set up, you way also want to set up cron rules for:

-   E-mail notifications
-   Web statistics

Upgrade
-------

The Foswiki Upgrade Guide is the official reference for the upgrade
process, and is generally sufficient to help you with the upgrade. The
most painful part of the upgrade process is the copying of topics from
the old installation to the new. A script is available that almost
completely automates this process, leaving you only with the task of
merging a few core topics that were modified in the old installation.

You can find the script here:
https://github.com/giddie/bits-n-pieces/blob/master/Foswiki/foswiki-copy.

-   Use diff (or your favourite derivative) to compare lib/LocalSite.cfg
    and any topics that need merging manually.
-   It may be best to edit certain topics via the Web interface if you
    want Foswiki to save a revision with the original contents.
-   Don't forget to copy:
    -   The <topic>.txt,v file containing the revision data if you're
        simply clobbering the new topic with the old one.
    -   The pub folder of any topic you're merging manually, if it
        exists.
    -   The data/.htpasswd file, which contains the users' password
        hashes.

Troubleshooting
---------------

> Argument "5.8.1" isn't numeric in numeric lt (<) ... when accessing configure

This is caused by a bug in Foswiki. A workaround is to downgrade to RCS
5.8. The configure script can't handle the third digit in the version
number.

Since this is really just a lazy programming mistake (basically "5.8" is
a number while "5.8.1" is not), you can safely comment out line 505-513
of {Foswiki_root}/lib/Foswiki/Configure/Checker.pm.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Foswiki&oldid=217400"

Category:

-   Web Server
