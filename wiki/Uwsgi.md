Uwsgi
=====

Contents
--------

-   1 Installation
-   2 Starting service
-   3 Configuring
    -   3.1 Application configuration
    -   3.2 Nginx configuration
-   4 See Also

Installation
------------

Install package uwsgi in the official repositories. Note, the package
does not come with plugins as it is just a compact package. External
plugins have to be installed separately. It is a very efficient software
due to the reason it is written in C. There are alternatives written in
Python like gunicorn, but they are slower inherently.

Starting service
----------------

To enable the uwsgi service by default at start-up, run:

    # systemctl enable uwsgi@helloworld

This will enable the service for the application configured in
/etc/uwsgi/helloworld.ini. Otherwise, you can also enable it through the
socket interface with the following command:

    # systemctl enable uwsgi@helloworld.socket

Alternatively, you can run the Emperor mode service. This mode enables a
single uwsgi instance to run a bunch of different apps (called vassals)
using a single main supervisor (called emperor). To enable it, type:

    # systemctl enable emperor.uwsgi

You can also use the socket:

    # systemctl enable emperor.uwsgi.socket

The configuration for this sits in /etc/uwsgi/emperor.ini.

Configuring
-----------

You can create a configuration by editing and putting that in
/etc/uwsgi/. There is a build file shipped with the package located at
/etc/uwsgi/archlinux.ini.

More details can be found in the uwsgi documentation.

Application configuration

The following is a simple example to get python support. You may need to
install the uwsgi-plugin-python or uwsgi-plugin-python2 plugin from the
community repository by pacman.

    [uwsgi]
    chdir = /srv/http/helloworld
    module = helloworld
    plugins = python

It is also possible to run uwsgi separately with the following syntax
for instance:

    uwsgi --socket 127.0.0.1:3031 --plugin python2 --wsgi-file ~/foo.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191 --uid --gid

Note, you should avoid running this command as root.

Nginx configuration

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        include uwsgi_params;
        # uwsgi_pass unix:/var/run/uwsgi/helloworld.sock;
        uwsgi_pass 127.0.0.1:3031;
    }

See Also
--------

-   Official Documentation
-   UWsgi Github
-   Fluffy White Stuff Benchmark
-   Flask uwsgi deploying
-   Django and uWSGI
-   Flask with uwsgi and nginx video
-   Apache and uwsgi

Retrieved from
"https://wiki.archlinux.org/index.php?title=Uwsgi&oldid=305789"

Category:

-   Web Server

-   This page was last modified on 20 March 2014, at 03:17.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
