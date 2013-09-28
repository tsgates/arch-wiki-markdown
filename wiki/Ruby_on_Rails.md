Ruby on Rails
=============

Ruby on Rails, often shortened to Rails or RoR, is an open source web
application framework for the Ruby programming language. It is intended
to be used with an Agile development methodology that is used by web
developers for rapid development.

This document describes how to set up the Ruby on Rails Framework on an
Arch Linux system.

Ruby on Rails requires Ruby to be installed, so read that article first
for installation instructions.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Option A: Installation via RubyGems (Recommended)                  |
|     -   1.1 Updating Gems                                                |
|                                                                          |
| -   2 Option B: Installing via the AUR                                   |
| -   3 Configuration                                                      |
| -   4 Application servers                                                |
|     -   4.1 Mongrel                                                      |
|     -   4.2 Unicorn                                                      |
|         -   4.2.1 Systemd service                                        |
|         -   4.2.2 Nginx Configuration                                    |
|                                                                          |
|     -   4.3 Apache/Nginx (using Phusion Passenger)                       |
|                                                                          |
| -   5 Databases                                                          |
|     -   5.1 SQLite                                                       |
|     -   5.2 PostgreSQL                                                   |
|     -   5.3 MySQL                                                        |
|                                                                          |
| -   6 Option C: The Perfect Rails Setup                                  |
|     -   6.1 Step 0: SQLite                                               |
|     -   6.2 Step 1: RVM                                                  |
|     -   6.3 Step 2: Rubies                                               |
|         -   6.3.1 Advice                                                 |
|                                                                          |
|     -   6.4 Step 3: Nginx with Passenger support                         |
|     -   6.5 Step 4: Gemsets and Apps                                     |
|     -   6.6 Passenger for Nginx and Passenger Standalone                 |
|     -   6.7 Step 5: .rvmrc files and ownerships                          |
|     -   6.8 Step 6: Reverse proxies                                      |
|         -   6.8.1 Launch Passenger Standalone daemons at system start-up |
|                                                                          |
|     -   6.9 Step 7: Deployment                                           |
|                                                                          |
| -   7 With subdomains                                                    |
| -   8 Without subdomains                                                 |
|     -   8.1 References                                                   |
|                                                                          |
| -   9 See also                                                           |
| -   10 References                                                        |
+--------------------------------------------------------------------------+

Option A: Installation via RubyGems (Recommended)
-------------------------------------------------

Note: If this command is run without being root (using sudo or
otherwise), the gem will be installed into the home directory of the
user.

    # gem install rails

Building the documentation takes a while. If you want to skip it, append
the parameters --no-ri --no-rdoc to the install command.

    # gem install rails --no-ri --no-rdoc

> Updating Gems

gem is a package manager for Ruby modules, somewhat like pacman is to
Arch Linux. To update your gems, simply run:

    # gem update

Option B: Installing via the AUR
--------------------------------

Warning:This is not recommended, as this might not include the latest
Rails version, and additional dependencies may be introduced that may
require you to run gem install anyway.

There is a rails package available in the AUR. Note that this is not in
an official repository, so you will need to build it manually.

Configuration
-------------

Rails is bundled with a basic HTTP server called WeBrick. You can create
a test application to test it. First, create an application with the
rails command:

    $ rails new testapp_name

Note:If you get an Error message like this:

    ... FetchError: SSL_connect returned=1 errno= 0 state=SSLv2/v3 read server hello A: sslv3 alert handshake
    failure (https://s3.amazonaws.com/ production.s3.rubygems.org/gems/rake-10.0.3.gem) 

try

    $ pacman -Suy
    $ pacman -S nodejs

then try again.

This creates a new folder inside your current working directory.

    $ cd testapp_name

Next start the web server. It listens on port 3000 by default:

    $ rails server

Now visit the testapp_name website on your local machine by opening
http://localhost:3000 in your browser

Note: If ruby complains about not being able to find a JavaScript
runtime, do # pacman -S nodejs.

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

Start by installing the 'passenger' gem:

    # gem install passenger

If you are aiming to use Apache, run:

    # passenger-install-apache2-module

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

(Stub.)

Install postgresql.

> MySQL

Note:You must first install MySQL with the appropriate headers in
/usr/include (just installing mysql is fine) before attempting to
install the Ruby MySQL extensions.

Please refer to MySQL on how to install MySQL Server.

A gem with some native extensions is required, probably best installed
as root:

    # sudo gem install mysql

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

Option C: The Perfect Rails Setup
---------------------------------

Phusion Passenger running multiple Ruby versions.

-   Archlinux: A simple, lightweight distribution. ;)
-   Nginx: A fast and lightweight web server with a strong focus on high
    concurrency, performance and low memory usage.
-   Passenger (a.k.a. mod_rails or mod_rack): Supports both Apache and
    Nginx web servers. It makes deployment of Ruby web applications,
    such as those built on Ruby on Rails web framework, a breeze.
-   Ruby Enterprise Edition (REE): Passenger allows Ruby on Rails
    applications to use about 33% less memory, when used in combination
    with REE.
-   Ruby Version Manager (RVM): A command-line tool which allows you to
    easily install, manage, and work with multiple Ruby environments
    from interpreters to sets of gems. RVM lets you deploy each project
    with its own completely self-contained and dedicated environment
    —from the specific version of ruby, all the way down to the precise
    set of required gems to run your application—.
-   SQLite: The default lightweight database for Ruby on Rails.

> Step 0: SQLite

Easy as:

    $ sudo pacman -S sqlite

Note:Of course SQLite is not critical in this setup, you can use MySQL
and PostgreSQL as well.

> Step 1: RVM

Make a multi-user RVM installation as specified here.

In the 'adding users to the rvm group' step, do

    $ sudo usermod -a -G rvm http
    $ sudo usermod -a -G rvm nobody

. http and nobody are the users related to Nginx and Passenger,
respectively.

Note:Maybe adding the 'nobody' user to the 'rvm' group is not necessary.

> Step 2: Rubies

Once you have a working RVM installation in your hands, it is time to
install the Ruby Enterprise Edition interpreter

Note:During the installation of Ruby Enterprise Edition patches will be
applied. Consider installing base-devel beforehand.

    $ rvm install ree

. Also take the chance to include other interpreters you want to use,
like the last Ruby version

    $ rvm install 2.0.0

Advice

There is a documented bug with older versions of Ruby (ie. the 1.8.7
version that REE uses) and the GCC versions 4.6 and up. If you get
segmentation fault errors when trying to install gems such as Passenger,
remove your install of REE and reinstall with the following:

    $ rvm remove ree
    $ CFLAGS="-O2 -fno-tree-dce -fno-optimize-sibling-calls" rvm install ree

It is also possible to make it work with older versions of GCC, but that
requires considerably more time.

I have found useful to delete the 'global' gemsets of the environments
that have web applications. Their gems were somehow interfering with
Passenger. Do not do

    $ rvm ree do gemset delete global
    $ rvm 2.0.0 do gemset delete global

now, but consider this later if you encounter complications.

> Step 3: Nginx with Passenger support

Do not install Nginx via pacman. This web server does not support
modules as Apache, so it must be compiled from source with the
functionality of mod_rails (Passenger). Fortunately this is
straightforward thanks to the passenger gem. Get it:

    $ rvm use ree
    $ gem install passenger

. The gem will be put into the 'default' gemset. Now execute the
following script:

Note:The current nginx package in the official repos actually was
compiled with the passenger module. So you can install it via pacman and
skip this step. The config files are stored in /etc/nginx/conf/.

    $ rvmsudo passenger-install-nginx-module

. It will download the sources of Nginx, compile and install it for you.
It will guide you through all the process. (The default location for
Nginx is /opt/nginx.)

Note:If you encounter a compilation error regarding Boost threads, see
this article.

After completion, the script will require you to add two lines into the
'http block' at /opt/nginx/conf/nginx.conf that look like:

    http { 
      ...
      passenger_root /usr/local/rvm/gems/ree-1.8.7-2011.03/gems/passenger-3.0.9;
      passenger_ruby /usr/local/rvm/wrappers/ree-1.8.7-2011.03/ruby;
      ...
    }

If you installed Nginx from pacman the passenger_root needs to be
changed to:

    passenger_root /usr/lib/passenger/;

Warning:Do not set it to /usr/lib/passenger/bin/passenger since this
will result in Nginx segfaulting when checking the config

For everything that is not Ruby, use Nginx as usual to serve static
pages, PHP and Python. Check the wiki page for more information.

To enable the Nnginx service by default at start-up just add nginx to
the DAEMONS array in /etc/rc.conf:

    DAEMONS=(ntpd syslog-ng ... nginx)

If you are using systemd instead of initscripts, you must run the
following command to have your system run nginx on startup

    # systemctl enable nginx.service

Note:It is possible that your Nginx installation has not come with an
init script; check your /etc/rc.d/ directory for a file called nginx, if
that is your case manually create it. Help yourself with
Nginx/Init_script. If you installed nginx to another location, such as
/opt/nginx, you will need to edit the init script accordingly.

> Step 4: Gemsets and Apps

For each Rails application you should have a gemset. Suppose that you
want to try RefineryCMS against BrowserCMS, two open-source Content
Management Systems based on Rails. Then you should do:

    $ rvm use ree@refinery --create
    $ gem install rails -v 3.0.11
    $ gem install passenger
    $ gem install refinerycms refinerycms-i18n sqlite3

Deploy a RefineryCMS instance called refineria:

    $ cd /srv/http/
    $ rvmsudo refinerycms refineria

Again:

    $ rvm use 2.0.0@browser --create
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

-   ree => for Nginx,
-   ree@refinery => Standalone, and
-   2.0.0@browser => Standalone.

The strategy is to combine Passenger for Nginx with Passenger
Standalone. One must first identify the Ruby environment (interpreter
plus gemset) that one uses the most; in this setup the REE interpreter
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

    sudo sh -c 'echo "rvm ree@refinery" > /srv/http/refineria/.rvmrc'

, and /srv/http/navegador/.rvmrc with

    sudo sh -c 'echo "rvm 2.0.0@browser" > /srv/http/navegador/.rvmrc'

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

    $ sudo chown -R nobody.nobody /srv/http/refineria /srv/http/navegador

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
---------------

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
------------------

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

    $ sudo rc.d start nginx

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
"https://wiki.archlinux.org/index.php?title=Ruby_on_Rails&oldid=255931"

Category:

-   Web Server
