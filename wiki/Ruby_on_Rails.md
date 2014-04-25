Ruby on Rails
=============

Ruby on Rails, often shortened to Rails or RoR, is an open source web
application framework for the Ruby programming language. It is intended
to be used with an Agile development methodology that is used by web
developers for rapid development.

This document describes how to set up the Ruby on Rails Framework on an
Arch Linux system.

Contents
--------

-   1 Installation
    -   1.1 Option A: via RubyGems
    -   1.2 Option B: via pacgem
    -   1.3 Option C: from the AUR
-   2 Configuration
-   3 Application servers
    -   3.1 Mongrel
    -   3.2 Unicorn
        -   3.2.1 Systemd service
        -   3.2.2 Nginx Configuration
    -   3.3 Apache/Nginx (using Phusion Passenger)
-   4 Databases
    -   4.1 SQLite
    -   4.2 PostgreSQL
    -   4.3 MySQL
-   5 The Perfect Rails Setup
    -   5.1 Step 0: SQLite
    -   5.2 Step 1: RVM
    -   5.3 Step 2: Rubies
    -   5.4 Step 3: Nginx with Passenger support
    -   5.5 Step 4: Gemsets and Apps
    -   5.6 Passenger for Nginx and Passenger Standalone
    -   5.7 Step 5: .rvmrc files and ownerships
    -   5.8 Step 6: Reverse proxies
        -   5.8.1 Launch Passenger Standalone daemons at system start-up
    -   5.9 Step 7: Deployment
        -   5.9.1 With subdomains
        -   5.9.2 Without subdomains
    -   5.10 References
-   6 See also
-   7 References

Installation
------------

Ruby on Rails requires Ruby to be installed, so read that article first
for installation instructions. The nodejs package is also required.

Ruby on Rails itself can be installed multiple ways:

> Option A: via RubyGems

Note:You can also install Rails system-wide using Gems. To do this, run
the following commands as root and append them with --no-user-install.
Please read Ruby#Installing gems per-user or system-wide for possible
dangers of using RubyGem in this way.

The following command will install Rails for the current user:

    $ gem install rails

Building the documentation takes a while. If you want to skip it, append
--no-document to the install command.

    $ gem install rails --no-document

gem is a package manager for Ruby modules, somewhat like pacman is to
Arch Linux. To update your gems, simply run:

    $ gem update

> Option B: via pacgem

You can install Rails using pacgem from the AUR. Pacgem automatically
creates PKGBUILDs and Arch packages for each of the gems. These packages
will then be installed using pacman.

    # pacgem rails

The gem packages can be updated with

    # pacgem -u

> Option C: from the AUR

Warning:This is not recommended, as this might not include the latest
Rails version, and additional dependencies may be introduced that may
require you to run gem install anyway.

There is a rails package available in the AUR.

Configuration
-------------

Rails is bundled with a basic HTTP server called WeBrick. You can create
a test application to test it. First, create an application with the
rails command:

    $ rails new testapp_name

Note:If you get an error like
Errno::ENOENT: No such file or directory (...) An error occurred while installing x, and Bundler cannot continue.,
you might have to configure Bundler so that it installs gems per-user
and not system-wide. Alternatively, run # rails new testapp_name once as
root. If it has completed successfully, delete testapp_name/ and run
$ rails new testapp_name again as a regular user.

Note:If you get an error message like this:

    ... FetchError: SSL_connect returned=1 errno= 0 state=SSLv2/v3 read server hello A: sslv3 alert handshake
    failure (https://s3.amazonaws.com/ production.s3.rubygems.org/gems/rake-10.0.3.gem) 

install nodejs and try again.

This creates a new folder inside your current working directory.

    $ cd testapp_name

Next start the web server. It listens on port 3000 by default:

    $ rails server

Now visit the testapp_name website on your local machine by opening
http://localhost:3000 in your browser

Note:If Ruby complains about not being able to find a JavaScript
runtime, install nodejs.

A test-page should shown greeting you "Welcome aboard".

Application servers
-------------------

While the default Ruby On Rails HTTP server (WeBrick) is convenient for
basic development it is not recommended for production use. Generally,
you should choose between installing the Phusion Passenger module for
your webserver (Apache or Nginx), or use a dedicated application-server
(such as Mongrel or Unicorn) combined with a separate web-server acting
as a reverse proxy.

> Mongrel

Mongrel is a drop-in replacement for WeBrick, that can be run in
precisely the same way, but offers better performance.

First install the Mongrel gem:

    # gem install mongrel

Then start it using:

    # mongrel_rails start

Alternatively, you can just run "ruby script/server" again, as it
replaces WeBrick by default.

> Unicorn

Unicorn is loosely based on Mongrel, and is used by Github. It uses a
different architecture that tries harder to find the best child for
handling a request. Explanation of differences between Unicorn and
Mongrel.

Install the Unicorn gem:

    # gem install unicorn

Then create a configuration file for your application in /etc/unicorn/.
For example; here is a configuration example (Based on [1]) for Redmine:

    /etc/unicorn/redmine.ru

    working_directory "/srv/http/redmine"
    pid "/tmp/redmine.pid"

    preload_app true
    timeout 60
    worker_processes 4
    listen 4000
    stderr_path('/var/log/unicorn.log')

    GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

    after_fork do |server, worker|
    	#start the worker on port 4000, 4001, 4002 etc...
    	addr = "0.0.0.0:#{4000 + worker.nr}"
    	# infinite tries to start the worker
    	server.listen(addr, :tries => -1, :delay => -1, :backlog => 128)

    	#Drop privileges if running as root
    	worker.user('nobody', 'nobody') if Process.euid == 0
    end

Start it using:

    # usr/bin/unicorn -D -E production -c /etc/unicorn/redmine.ru

Systemd service

Put the following contents in /etc/systemd/system/unicorn.service:

    /etc/systemd/system/unicorn.service

    [Unit]
    Description=Unicorn application server
    After=network.target

    [Service]
    Type=forking
    User=redmine
    ExecStart=/usr/bin/unicorn -D -E production -c /etc/unicorn/redmine.ru

    [Install]
    WantedBy=multi-user.target

You can now easily start and stop unicorn using systemctl

Nginx Configuration

After setting up Nginx, configure unicorn as an upstream server using
something like this (Warning: this is a stripped example. It probably
doesn't work without additional configuration):

    http {
    	upstream unicorn {
    		server 127.0.0.1:4000 fail_timeout=0;
    		server 127.0.0.1:4001 fail_timeout=0;
    		server 127.0.0.1:4002 fail_timeout=0;
    		server 127.0.0.1:4003 fail_timeout=0;
    	}

    	server {
    		listen		80 default;
    		server_name	YOURHOSTNAMEHERE;

    		location / {
    			root			/srv/http/redmine/public;
    			proxy_set_header	X-Forwarded-For $proxy_add_x_forwarded_for;
    			proxy_set_header Host   $http_host;
    			proxy_redirect		off;
    			proxy_pass		http://unicorn;
    		}
    	}
    }

> Apache/Nginx (using Phusion Passenger)

Passenger also known as mod_rails is a module available for Nginx and
Apache, that greatly simplifies setting up a Rails server environment.
Nginx does not support modules as Apache and has to be compiled with
mod_rails in order to support Passenger; let Passenger compile it for
you. As for Apache, let Passenger set up the module for you.

Note:The current Nginx package in the official repositories actually is
compiled with the Passenger module, so you can install it via pacman.
The configuration files are stored in /etc/nginx/conf/.

Note:As of 2013-10-07 this doesn't seem to be the casy any longer and
you will have to follow the remaining steps here

Start by installing the 'passenger' gem:

    # gem install passenger

If you are aiming to use Apache, run:

    # passenger-install-apache2-module

In case a rails application is deployed with a sub-URI, like
http://example.com/yourapplication, some additional configuration is
required, see the modrails documentation

For Nginx:

    # passenger-install-nginx-module

The installer will provide you with any additional information regarding
the installation (such as installing additional libraries).

To serve an application with Nginx, configure it as follows:

    server {
        server_name app.example.org;
        root path_to_app/public; # Be sure to point to 'public' folder!
        passenger_enabled on;
        rails_env development; # Rails environment.
    }

Databases
---------

Most web applications will need to interact with some sort of database.
ActiveRecord (the ORM used by Rails to provide database abstraction)
supports several database vendors, the most popular of which are MySQL,
SQLite, and PostgreSQL.

> SQLite

SQLite is the default lightweight database for Ruby on Rails. To enable
SQLite, simply install sqlite3.

> PostgreSQL

Install postgresql.

> MySQL

First, install and configure a MySQL server. Please refer to MySQL on
how to do this.

A gem with some native extensions is required, probably best installed
as root:

    # gem install mysql

You can generate a rails application configured for MySQL by using the
-d parameter:

    $ rails new testapp_name -d mysql

You then need to edit config/database.yml. Rails uses different
databases for development, testing, production and other environments.
Here is an example development configuration for MySQL running on
localhost:

     development:
       adapter: mysql
       database: my_application_database
       username: development
       password: my_secret_password

Note that you do not have to actually create the database using MySQL,
as this can be done via Rails with:

    # rake db:create

If no errors are shown, then your database has been created and Rails
can talk to your MySQL database.

The Perfect Rails Setup
-----------------------

Phusion Passenger running multiple Ruby versions.

-   Arch Linux: A simple, lightweight distribution. ;)
-   Nginx: A fast and lightweight web server with a strong focus on high
    concurrency, performance and low memory usage.
-   Passenger (a.k.a. mod_rails or mod_rack): Supports both Apache and
    Nginx web servers. It makes deployment of Ruby web applications,
    such as those built on Ruby on Rails web framework, a breeze.
-   Ruby Version Manager (RVM): A command-line tool which allows you to
    easily install, manage, and work with multiple Ruby environments
    from interpreters to sets of gems. RVM lets you deploy each project
    with its own completely self-contained and dedicated environment
    —from the specific version of ruby, all the way down to the precise
    set of required gems to run your application—.
-   SQLite: The default lightweight database for Ruby on Rails.

> Step 0: SQLite

Install sqlite.

Note:Of course SQLite is not critical in this setup, you can use MySQL
and PostgreSQL as well.

> Step 1: RVM

Make a multi-user RVM installation as specified here.

In the 'adding users to the rvm group' step, do

    # usermod -a -G rvm http
    # usermod -a -G rvm nobody

http and nobody are the users related to Nginx and Passenger,
respectively.

Note:Maybe adding the 'nobody' user to the 'rvm' group is not necessary.

> Step 2: Rubies

Once you have a working RVM installation in your hands, it is time to
install the latest Ruby interpreter

Note:During the installation of Ruby patches will be applied. Consider
installing the base-devel group beforehand.

    $ rvm install 2.0.0

Note: It may be useful to delete the 'global' gemsets of the
environments that have web applications. Their gems might somehow
interfere with Passenger. In that case, a
rvm 2.0.0 do gemset delete global is sufficient.

> Step 3: Nginx with Passenger support

Run the following to allow passenger install nginx:

    $ rvm use 2.0.0 
    $ gem install passenger
    $ rvmsudo passenger-install-nginx-module

The passenger gem will be put into the default gemset.

This will download the sources of Nginx, compile and install it for you.
It will guide you through all the process. Note that the default
location for Nginx will be /opt/nginx.

Note:If you encounter a compilation error regarding Boost threads, see
this article.

After completion, add the following two lines into the 'http block' at
/opt/nginx/conf/nginx.conf that look like:

    http { 
      ...
      passenger_root /usr/local/rvm/gems/ruby-2.0.0-p353/gems/passenger-3.0.9;
      passenger_ruby /usr/local/rvm/wrappers/ruby-2.0.0-p353/ruby;
      ...
    }

> Step 4: Gemsets and Apps

For each Rails application you should have a gemset. Suppose that you
want to try RefineryCMS against BrowserCMS, two open-source Content
Management Systems based on Rails.

Install RefineryCMS first:

    $ rvm use 2.0.0@refinery --create
    $ gem install rails -v 4.0.1
    $ gem install passenger
    $ gem install refinerycms refinerycms-i18n sqlite3

Deploy a RefineryCMS instance called refineria:

    $ cd /srv/http/
    $ rvmsudo refinerycms refineria

Install BrowserCMS in a different gemset:

    $ rvm use 2.0.0@browser --create
    $ gem install rails -v 4.0.1
    $ gem install passenger
    $ gem install browsercms sqlite3

Deploy a BrowserCMS instance called navegador:

    $ cd /srv/http/
    $ rvmsudo browsercms demo navegador
    $ cd /srv/http/navegador
    $ rvmsudo rake db:install

> Passenger for Nginx and Passenger Standalone

Observe that the passenger gem was installed three times and with
different intentions; in the environments

-   2.0.0 => for Nginx,
-   2.0.0@refinery => Standalone
-   2.0.0@browser => Standalone

The strategy is to combine Passenger for Nginx with Passenger
Standalone. One must first identify the Ruby environment (interpreter
plus gemset) that one uses the most; in this setup the Ruby interpreter
and the default gemset were selected. One then proceeds with setting up
Passenger for Nginx to use that environment (step 3).

-   Applications within the chosen environment can be served as in
    Apache/Nginx (using Phusion Passenger), page up in this article.
-   All applications that are to use a different Ruby version and/or
    gemset can be served separately through Passenger Standalone and
    hook into the main web server via a reverse proxy configuration
    (step 6).

> Step 5: .rvmrc files and ownerships

This step is crucial for the correct behaviour of the setup. RVM seeks
for .rvmrc files when changing folders; if it finds one, it reads it. In
these files normally one stores a line like

    rvm <ruby_version>@<gemset_name>

so the specified environment is set at the entrance of applications'
root folder.

Create /srv/http/refineria/.rvmrc doing

    # echo "rvm ree@refinery" > /srv/http/refineria/.rvmrc

, and /srv/http/navegador/.rvmrc with

    # echo "rvm 2.0.0@browser" > /srv/http/navegador/.rvmrc

You have to enter to both application root folders now, because every
first time that RVM finds a .rvmrc it asks you if you trust the given
file, consequently you must validate the two files you have just
created.

These files aid the programs involved to find the correct gems.

Apart, if applications' files and folders are not owned by the right
user you will face database write-access problems. The use of rvmsudo
produces root-owned archives when generated by Rails; in the other hand,
nobody is the user for Passenger —if you have not changed it—: who will
use and should posses them. Fix this doing

    # chown -R nobody.nobody /srv/http/refineria /srv/http/navegador

> Step 6: Reverse proxies

You have to start the Passenger Standalone web servers for your
applications. So, do

    $ cd /srv/http/refineria
    $ rvmsudo passenger start --socket tmp/sockets/passenger.socket -d

and

    $ cd /srv/http/navegador
    $ rvmsudo passenger start --socket tmp/sockets/passenger.socket -d

. The first time that you run a Passenger Standalone it will perform a
minor installation.

Note that you are using unix domain sockets instead of the commonly-used
TCP sockets; it turns out that unix domain are significantly faster than
TCP sockets.

Note:If you are experimenting trouble with unix sockets, changing to TCP
should work:

    rvmsudo passenger start -a 127.0.0.1 -p 3000 -d

Launch Passenger Standalone daemons at system start-up

Do you have a script? Please post it here.

The systemd script below was made for a Typo blog I host at
/srv/http/typo. It's located at
/etc/systemd/system/passenger_typo.service. I set the Environment= tags
(see "man systemd.exec") from the output of "rvm env". The only
exception was PATH=, which I had to combine from my regular PATH and the
output of rvm env.

Note: If you don't set the "WorkingDirectory=" variable to your
application folder, passenger will fail to find your app and will
subsequently shut itself down.

    [Unit]
    Description=Passenger Standalone Script for Typo
    After=network.target

    [Service]
    Type=forking
    WorkingDirectory=/srv/http/typo
    PIDFile=/srv/http/typo/tmp/pids/passenger.pid

    Environment=PATH=/usr/local/rvm/gems/ruby-2.0.0-p0@typo/bin:/usr/local/rvm/gems/ruby-2.0.0-p0@global/bin:/usr/local/rvm/rubies/ruby-2.0.0-p0/bin:/usr/local/rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin/core_perl
    Environment=rvm_env_string=ruby-2.0.0-p0@typo
    Environment=rvm_path=/usr/local/rvm
    Environment=rvm_ruby_string=ruby-2.0.0-p0
    Environment=rvm_gemset_name=typo
    Environment=RUBY_VERSION=ruby-2.0.0-p0
    Environment=GEM_HOME=/usr/local/rvm/gems/ruby-2.0.0-p0@typo
    Environment=GEM_PATH=/usr/local/rvm/gems/ruby-2.0.0-p0@typo:/usr/local/rvm/gems/ruby-2.0.0-p0@global
    Environment=MY_RUBY_HOME=/usr/local/rvm/rubies/ruby-2.0.0-p0
    Environment=IRBRC=/usr/local/rvm/rubies/ruby-2.0.0-p0/.irbrc

    ExecStart=/bin/bash -c "rvmsudo passenger start --socket /srv/http/typo/tmp/sockets/passenger.socket -d"

    [Install]
    WantedBy=multi-user.target

> Step 7: Deployment

With subdomains

Once again edit /opt/nginx/conf/nginx.conf to include some vital
instructions:

    ## RefineryCMS ##

    server {
        server_name refinery.domain.com;
        root /srv/http/refineria/public;
        location / {
            proxy_pass http://unix:/srv/http/refineria/tmp/sockets/passenger.socket;
            proxy_set_header Host $host;
        }
    }

    ## BrowserCMS ##

    server {
        server_name browser.domain.com;
        root /srv/http/navegador/public;
        location / {
            proxy_pass http://unix:/srv/http/navegador/tmp/sockets/passenger.socket;
            proxy_set_header Host $host;
        }
    }

Note:Or if using TCP sockets, configure the proxy_pass directive like

    proxy_pass http://127.0.0.1:3000;

Without subdomains

If you for some reason don't want to host each application on it's own
subdomain but rather in a url like: site.com/railsapp then you could do
something like this in your config:

    server {
        server_name site.com;
        #Base for the html files etc
        root /srv/http/;

        #First application you want hosted under domain site.com/railsapp
        location /railsapp {
            root /srv/http/railsapp/public;
            #you may need to change passenger_base_uri to be the uri you want to point at, ie:
            #passenger_base_uri /railsapp;
            #but probably only if you're using the other solution with passenger phusion
            proxy_pass http://unix:/srv/http/railsapp/tmp/sockets/passenger.socket;
            proxy_set_header Host $host;
        }

        #Second applicatino you want hosted under domain site.com/anotherapp
        location /anotherapp {
            root /srv/http/anotherapp/public;
            #same thing about the passenger_base_uri here, but with value /anotherapp instead
            proxy_pass http://unix:/srv/http/anotherapp/tmp/sockets/passenger.socket;
            proxy_set_header Host $host;
        }
    }

At this point you are in conditions to run Nginx with:

    # systemctl start nginx

and to access both CMSs through refinery.domain.com and
browser.domain.com.

> References

-   http://beginrescueend.com/integration/passenger
-   http://blog.phusion.nl/2010/09/21/phusion-passenger-running-multiple-ruby-versions

See also
--------

-   Ruby
-   Nginx
-   LAMP
-   MySQL

References
----------

-   Ruby on Rails http://rubyonrails.org/download.
-   Mongrel http://mongrel.rubyforge.org.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ruby_on_Rails&oldid=302015"

Category:

-   Web Server

-   This page was last modified on 25 February 2014, at 12:07.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
