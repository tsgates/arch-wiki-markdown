Ganglia
=======

Ganglia is a scalable distributed system monitor tool for
high-performance computing systems such as clusters and grids. It allows
the user to remotely view live or historical statistics (such as CPU
load averages or network utilization) for all machines that are being
monitored.

Ganglia is available as the ganglia package on the AUR, along with the
web frontend ganglia-web. There is also a reduced-dependency version
named ganglia-minimal, which would be appropriate on boxes where you
don't require gmetad and want to avoid pulling in rrdtool as a
dependency, which would in turn pull in Cairo and Mesa.

The Ganglia Wiki contains all the information you need to get started
with Ganglia.

Contents
--------

-   1 Ganglia Web Interface
    -   1.1 Nginx with php-fpm
-   2 Troubleshooting
    -   2.1 Issues with IP-address binding or undesirable hostnames
-   3 References

Ganglia Web Interface
---------------------

The ganglia web frontend is available as the ganglia-web package on the
AUR.

You will also need a web server with a working PHP setup. The following
sections include some example setups.

Make sure that the open_basedir setting in your /etc/php/php.ini
includes /usr/share/webapps and /var/lib/ganglia.

> Nginx with php-fpm

Firstly, install the required packages:

    pacman -S nginx php-fpm

This is a minimal configuration for nginx:

    /etc/nginx/nginx.conf

    events {
      worker_connections  1024;
    }

    http {
      include mime.types;
      default_type application/octet-stream;

      upstream php {
        server unix:/run/php-fpm/php-fpm.sock;
      }

      server {
        listen 80 default_server;

        root /usr/share/webapps;
        index index.php;

        location ~ \.php$ {
          fastcgi_pass php;
          include fastcgi.conf;
        }
      }
    }

Then start all required services:

    systemctl start gmetad gmond php-fpm nginx

Go to http://localhost/ganglia and check that your setup is working.

Troubleshooting
---------------

> Issues with IP-address binding or undesirable hostnames

If bind_hostname = yes in the udp_send_channel section of gmond.conf,
the gmond daemon will determine which IP to bind to (and report in the
XML data) by determining the IP address of the default hostname. You
should be able to replicate this behaviour with one of these commands:

    $ hostname -i
    $ host $(hostname)

The hostname to report is determined by asking the system to look up a
hostname for the chosen IP address, in order to ensure the hostname is
that by which other machines on the network identify the monitored
machine:

    $ host <ip-address>

The hostname listed at the top of the list is the one that will be
reported by gmond, and will appear in the web UI. You can influence the
returned hostname by modifying your /etc/hosts or /etc/nsswitch.conf
files. In particular, watch out for placing myhostname before dns on the
hosts line in /etc/nsswitch.conf. This will cause gmond to attempt to
bind to a UDP port on 127.0.0.1, and it will fail to load.

If you're not able to achieve the desired behaviour, the hostname can be
overridden in the gmond.conf file by adding the following lines to the
globals section:

    globals {
      ...
      override_hostname = myhostname.mydomain
      override_ip = 127.0.0.2
    }

References
----------

-   E-mail exchange explaining IP and Hostname lookup:
    http://www.mail-archive.com/ganglia-general@lists.sourceforge.net/msg01885.html

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ganglia&oldid=291046"

Category:

-   Status monitoring and notification

-   This page was last modified on 31 December 2013, at 11:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
