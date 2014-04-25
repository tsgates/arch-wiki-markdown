Gitlab
======

Summary help replacing me

This page gives guidelines for the installation and configuration of
Gitlab on Archlinux.

> Related

Gitolite

Ruby on Rails

Gitlab is a free git repository management application based on Ruby on
Rails. It is distributed under the MIT License and its source code can
be found on Github. It is a very active project with a monthly release
cycle and ideal for businesses that want to keep their code private.
Consider it as a self hosted Github but open source. You can try a demo
here.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Notes Before Configuring
    -   2.2 Basic configuration
    -   2.3 Database backend
        -   2.3.1 MariaDB
        -   2.3.2 PostgreSQL
        -   2.3.3 Initialize Gitlab database
-   3 Start and test GitLab
-   4 Advanced Configuration
    -   4.1 HTTPS/SSL
        -   4.1.1 Change GitLab configs
        -   4.1.2 Configure HTTPS server of choice
            -   4.1.2.1 Apache
            -   4.1.2.2 Node.js
    -   4.2 Web server configuration
        -   4.2.1 Nginx and unicorn
        -   4.2.2 Apache and unicorn
            -   4.2.2.1 Configure Unicorn
            -   4.2.2.2 Create a virtual host for Gitlab
            -   4.2.2.3 Enable host and start unicorn
-   5 Useful Tips
    -   5.1 Fix Rake Warning
    -   5.2 Hook into /var
    -   5.3 Hidden options
    -   5.4 Backup and restore
    -   5.5 Migrate from sqlite to mysql
    -   5.6 Running GitLab with rvm
-   6 Troubleshooting
    -   6.1 HTTPS is not green (gravatar not using https)
-   7 See also

Installation
------------

Note:If you want to use rvm be sure to check out Gitlab#Running GitLab
with rvm before starting with the installation

Note:This guide covers installing and configuring GitLab without
HTTPS/SSL at first, just to get GitLab up and running. After getting
GitLab up and running, see #Advanced Configuration to set up SSL.

Installing gitlab from the AUR instead of manually has the added benefit
that lots of steps have been taken care of for you (e.g. permissions and
ownership for files, etc).

Make sure you perform a system upgrade (pacman -Syu) before installing
gitlab from AUR and that you have installed the base-devel group, or you
may face problems installing gitlab because base-devel packages are not
required to be listed as dependencies in PKGBUILD files.

Also before installing the gitlab package from the AUR, you need to
choose a database backend if you're planning to host GitLab it on the
same machine as the database:

-   Use Pacman to install mariadb and libmariadbclient from the official
    repositories and start the daemon
-   or install postgresql and libpqxx. Read
    PostgreSQL#Installing_PostgreSQL to set it up and start the daemon.

In order to receive mail notifications, make sure to install a mail
server. By default, Archlinux does not ship with one. The recommended
mail server is postfix, but you can use others such as SSMTP, msmtp,
sendmail, etc.

Configuration
-------------

> Notes Before Configuring

The gitlab package from AUR organizes GitLab's files in a manner that
more closely follows standard linux conventions rather than installing
everything in /home/git as you are told to do by GitLab's official
install guide.

  
 After you've installed gitlab from AUR, the config file
/etc/webapps/gitlab/shell.yml corresponds to the file
/home/git/gitlab-shell/config.yml that is mentioned in GitLab's official
install guide when installing gitlab-shell. The config file
/etc/webapps/gitlab/gitlab.yml corresponds to the file
/home/git/gitlab/config/gitlab.yml that is mentioned in GitLab's
official install guide when configuring GitLab.

  
 Another key difference between gitlab from AUR and the GitLab install
guide is that GitLab from AUR uses the gitlab user with /var/lib/gitlab
as the home folder instead of the git user with /home/git as the home
folder. This keeps the /home area clean so it contains only real user
homes.

Tip:If you are familiar with the Arch Build System you can edit the
PKGBUILD and relevant files to change gitlab's home directory to a place
of your liking.

> Basic configuration

Open up /etc/webapps/gitlab/shell.yml and set gitlab_url: to the url
where you intend to host GitLab (note the 'http://' and trailing slash).
For example, if you will host GitLab at 'yourdomain.com', then it'd look
like this:

    Snippet from /etc/webapps/gitlab/shell.yml

    # GitLab user. git by default
    user: gitlab

    # Url to gitlab instance. Used for api calls. Should end with a slash.
    gitlab_url: "http://yourdomain.com/" # <<-- right here

    http_settings:
    #  user: someone
    #  password: somepass
    ...

  
 Open up /etc/webapps/gitlab/gitlab.yml and edit where needed. In the
gitlab: section set host: (replacing localhost) to 'yourdomain.com',
your fully qualified domin name (no 'http://' or trailing slash). port:
can be confusing. This is not the port that the gitlab server (unicorn)
runs on; it's the port that users will initially access through in their
browser. Basically, if you intend for users to visit 'yourdomain.com' in
their browser, without appending a port number to the domain name, leave
port: as 80. If you intend your users to type something like
'yourdomain.com:3425' into their browsers, then you'd set port: to 3425
(you'll also have to configure your server (apache, nginx, etc) to
listen on that port). Those are the minimal changes needed for a working
GitLab install. The adventurous may read on in the comment and customize
as needed. For example:

    Snippet from /etc/webapps/gitlab/gitlab.yml

    ...
      ## GitLab settings
      gitlab:
        ## Web server settings
        host: yourdomain.com
        port: 80
        https: false
    ...

> Database backend

A Database backend will be required before Gitlab can be run. Currently
GitLab supports MariaDB and PostgreSQL. By default, GitLab assumes you
will use MySQL. Extra work is needed if you plan to use PostgreSQL.

Note:Don't forget to replace your_username_here and your_password_here
with your chosen values in the following examples.

MariaDB

To set up MySQL (MariaDB) you need to create a database called
gitlabhq_production along with a user who has full priviledges to the
database. You might do it via command line as in the following example.

    mysql -u root -p

    mysql> CREATE DATABASE IF NOT EXISTS `gitlabhq_production`;
    mysql> CREATE USER 'your_username_here'@'localhost' IDENTIFIED BY 'your_password_here';
    mysql> GRANT SELECT, LOCK TABLES, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON `gitlabhq_production`.* TO 'your_username_here'@'localhost';
    mysql> \q

Now try connecting to the new database with the new user to verify you
did it correctly:

    mysql -u your_username_here -p -D gitlabhq_production

Next you'll need to open up /etc/webapps/gitlab/database.yml and set
username: and password: for the gitlabhq_production database to
your_username_here and your_password_here, respectively. You need not
worry about the info for the gitlabhq_development and gitlan_test
databases, as those are not required for our purposes (unless you're
feeling adventurous at your own risk). For example:

    Snippet from /etc/webapps/gitlab/database.yml

    #
    # PRODUCTION
    #
    production:
      adapter: mysql2
      encoding: utf8
      reconnect: false
      database: gitlabhq_production
      pool: 10
      username: your_username_here
      password: "your_password_here"
      # host: localhost
      # socket: /tmp/mysql.sock
    ...

That's all for MySQL configuration.

For more info and other ways to create/manage MySQL databases, see the
MariaDB documentation, the GitLab official (generic) install guide, and
phpMyAdmin.

PostgreSQL

Login to PostgreSQL and create the gitlabhq_production database with
along with it's user. Remember to change your_username_here and
your_password_here to the real values:

    psql -d template1

    template1=# CREATE USER your_username_here WITH PASSWORD 'your_password_here';
    template1=# CREATE DATABASE gitlabhq_production OWNER your_username_here;
    template1=# \q

Try connecting to the new database with the new user to verify it works:

    psql -d gitlabhq_production

Copy the PostgreSQL template file before configuring it (overwriting the
default MySQL configuration file):

    cp /usr/share/doc/gitlab/database.yml.postgresql /etc/webapps/gitlab/database.yml

Open up the new /etc/webapps/gitlab/database.yml and set the values for
username: and password:. For example:

    Snippet from the new /etc/webapps/gitlab/database.yml

    #
    # PRODUCTION
    #
    production:
      adapter: postgresql
      encoding: unicode
      database: gitlabhq_production
      pool: 10
      username: your_username_here
      password: "your_password_here"
      # host: localhost
      # port: 5432 
      # socket: /tmp/postgresql.sock
    ...

For our purposes (unless you know what you're doing), you don't need to
worry about configuring the other databases listed in
/etc/webapps/gitlab/database.yml. We only need to set up the production
database to get GitLab working.

Finally, open up /usr/lib/systemd/system/gitlab.target change all
instances of mysql.service to postgresql.service. For example:

    Snippet from /usr/lib/systemd/system/gitlab.target

    ...
    [Unit]
    Description=GitLab - Self Hosted Git Management
    Requires=redis.service postgresql.service
    After=redis.service postgresql.service syslog.target network.target

    [Install]
    WantedBy=multi-user.target

Initialize Gitlab database

Finally, initialize the database and activate advanced features:

    $ cd /usr/share/webapps/gitlab
    $ sudo -u gitlab bundle exec rake gitlab:setup RAILS_ENV=production

Start and test GitLab
---------------------

With the following commands we check if the steps we followed so far are
configured properly.

    $ cd /usr/share/webapps/gitlab
    $ sudo -u gitlab bundle exec rake gitlab:env:info RAILS_ENV=production
    $ sudo -u gitlab bundle exec rake gitlab:check RAILS_ENV=production

Note:These gitlab:env:info and gitlab:check commands will show a fatal
error related to git. This is OK.

    Example output of sudo -u gitlab bundle exec rake gitlab:env:info RAILS_ENV=production

    fatal: Not a git repository (or any of the parent directories): .git

    System information
    System:		Arch Linux
    Current User:	git
    Using RVM:	yes
    RVM Version:	1.20.3
    Ruby Version:	2.0.0p0
    Gem Version:	2.0.0
    Bundler Version:1.3.5
    Rake Version:	10.0.4

    GitLab information
    Version:	5.2.0.pre
    Revision:	
    Directory:	/home/git/gitlab
    DB Adapter:	mysql2
    URL:		http://gitlab.arch
    HTTP Clone URL:	http://gitlab.arch/some-project.git
    SSH Clone URL:	git@gitlab.arch:some-project.git
    Using LDAP:	no
    Using Omniauth:	no

    GitLab Shell
    Version:	1.4.0
    Repositories:	/home/git/repositories/
    Hooks:		/home/git/gitlab-shell/hooks/
    Git:		/usr/bin/git

Note: gitlab:check will complain about missing initscripts. Don't worry,
we will use ArchLinux's systemd to manage server start during boot
(which GitLab does not recognize).

    Example output of sudo -u gitlab bundle exec rake gitlab:check RAILS_ENV=production

    fatal: Not a git repository (or any of the parent directories): .git
    Checking Environment ...

    Git configured for gitlab user? ... yes
    Has python2? ... yes
    python2 is supported version? ... yes

    Checking Environment ... Finished

    Checking GitLab Shell ...

    GitLab Shell version >= 1.7.9 ? ... OK (1.8.0)
    Repo base directory exists? ... yes
    Repo base directory is a symlink? ... no
    Repo base owned by gitlab:gitlab? ... yes
    Repo base access is drwxrws---? ... yes
    update hook up-to-date? ... yes
    update hooks in repos are links: ... can't check, you have no projects
    Running /srv/gitlab/gitlab-shell/bin/check
    Check GitLab API access: OK
    Check directories and files:
            /srv/gitlab/repositories: OK
            /srv/gitlab/.ssh/authorized_keys: OK
    Test redis-cli executable: redis-cli 2.8.4
    Send ping to redis server: PONG
    gitlab-shell self-check successful

    Checking GitLab Shell ... Finished

    Checking Sidekiq ...

    Running? ... yes
    Number of Sidekiq processes ... 1

    Checking Sidekiq ... Finished

    Checking LDAP ...

    LDAP is disabled in config/gitlab.yml

    Checking LDAP ... Finished

    Checking GitLab ...

    Database config exists? ... yes
    Database is SQLite ... no
    All migrations up? ... fatal: Not a git repository (or any of the parent directories): .git
    yes
    GitLab config exists? ... yes
    GitLab config outdated? ... no
    Log directory writable? ... yes
    Tmp directory writable? ... yes
    Init script exists? ... no
      Try fixing it:
      Install the init script
      For more information see:
      doc/install/installation.md in section "Install Init Script"
      Please fix the error above and rerun the checks.
    Init script up-to-date? ... can't check because of previous errors
    projects have namespace: ... can't check, you have no projects
    Projects have satellites? ... can't check, you have no projects
    Redis version >= 2.0.0? ... yes
    Your git bin path is "/usr/bin/git"
    Git version >= 1.7.10 ? ... yes (1.8.5)

    Checking GitLab ... Finished

Make systemd see your new daemon unit files:

    $ systemctl daemon-reload

After starting the database backend (in this case MySQL), we can start
Gitlab with its webserver (Unicorn):

    $ systemctl start redis mysqld gitlab-sidekiq gitlab-unicorn

Replace mysqld with postgresql in the above command if you're using
PostgreSQL.

To automatically launch GitLab at startup, run:

    $ systemctl enable gitlab.target gitlab-sidekiq gitlab-unicorn

Now test your Gitlab instance by visiting http://localhost:8080 or
http://yourdomain.com and login with the default credentials:

    username: admin@local.host
    password: 5iveL!fe

That's it. GitLab should now be up and running.

Advanced Configuration
----------------------

> HTTPS/SSL

Change GitLab configs

Modify /etc/webapps/gitlab/shell.yml so the url to your GitLab site
starts with https://. Modify /etc/webapps/gitlab/gitlab.yml so that
https: setting is set to true.

Configure HTTPS server of choice

Apache

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: info needed       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Node.js

You can easily set up an http proxy on port 443 to proxy traffic to the
GitLab application on port 8080 using http-master for Node.js. After
you've creates your domain's OpenSSL keys and have gotten you CA
certificate (or self signed it), then go to
https://github.com/CodeCharmLtd/http-master to learn how easy it is to
proxy requests to GitLab using HTTPS. http-master is built on top of
node-http-proxy.

> Web server configuration

If you want to integrate Gitlab into a running web server instead of
using its build-in http server Unicorn, then follow these instructions.

Nginx and unicorn

Install nginx from the official repositories.

Run these commands to setup nginx:

    ln -s /etc/nginx/sites-available/gitlab /etc/nginx/sites-enabled/gitlab

Edit /etc/nginx/sites-enabled/gitlab and change YOUR_SERVER_IP and
YOUR_SERVER_FQDN to the IP address and fully-qualified domain name of
the host serving Gitlab.

Restart gitlab.target, resque.service and nginx.

Apache and unicorn

Install apache from the official repositories.

Configure Unicorn

Note:If the default path is not /home/git for your installation, change
the below path accordingly

As the official installation guide instructs, copy the unicorn
configuration file:

    # sudo -u git -H cp /home/git/gitlab/config/unicorn.rb.example /home/git/gitlab/config/unicorn.rb

Now edit config/unicorn.rb and add a listening port by uncommenting the
following line:

    listen "127.0.0.1:8080"

Tip: You can set a custom port if you want. Just remember to also
include it in Apache's virtual host. See below.

Create a virtual host for Gitlab

Create a configuration file for Gitlab’s virtual host and insert the
lines below adjusted accordingly. For the ssl section see LAMP#SSL. If
you do not need it, remove it. Notice that the SSL virtual host needs a
specific IP instead of generic. Also if you set a custom port for
Unicorn, do not forget to set it at the BalanceMember line.

Enable host and start unicorn

Enable your Gitlab virtual host and reload Apache:

    /etc/httpd/conf/httpd.conf

     Include /etc/httpd/conf/extra/gitlab.conf

Finally start unicorn:

    systemctl start gitlab-unicorn

Useful Tips
-----------

> Fix Rake Warning

When running rake tasks for the gitlab project, this error will occur:
fatal: Not a git repository (or any of the parent directories): .git.
This is a bug in bundler, and it can be safely ignored. However, if you
want to git rid of the error, the following method can be used:

     cd /usr/share/webapps/gitlab
     sudo -u gitlab git init
     sudo -u gitlab git commit -m "initial commit" --allow-empty

> Hook into /var

     sudo mkdir -m700 /var/log/gitlab /var/tmp/gitlab
     sudo chown gitlab:gitlab /var/log/gitlab /var/tmp/gitlab
     sudo -u gitlab -i
     cd ~/gitlab
     d=log; mv $d/* /var/$d/gitlab; rm -f $d/.gitkeep; rm -r $d && ln -s /var/$d/gitlab $d
     d=tmp; mv $d/* /var/$d/gitlab; rm -f $d/.gitkeep; rm -r $d && ln -s /var/$d/gitlab $d

> Hidden options

Go to Gitlab's home directory

    # cd /usr/share/webapps/gitlab

and run

    # rake -T | grep gitlab

These are the options so far:

    rake gitlab:app:backup_create      # GITLAB | Create a backup of the gitlab system
    rake gitlab:app:backup_restore     # GITLAB | Restore a previously created backup
    rake gitlab:app:enable_automerge   # GITLAB | Enable auto merge
    rake gitlab:app:setup              # GITLAB | Setup production application
    rake gitlab:app:status             # GITLAB | Check gitlab installation status
    rake gitlab:gitolite:update_hooks  # GITLAB | Rewrite hooks for repos
    rake gitlab:gitolite:update_keys   # GITLAB | Rebuild each key at gitolite config
    rake gitlab:gitolite:update_repos  # GITLAB | Rebuild each project at gitolite config
    rake gitlab:test                   # GITLAB | Run both cucumber & rspec

> Backup and restore

Create a backup of the gitlab system:

    # sudo -u gitlab -H rake RAILS_ENV=production gitlab:backup:create

Restore the previously created backup file
/home/gitlab/gitlab/tmp/backups/20130125_11h35_1359131740_gitlab_backup.tar:

    # sudo -u gitlab -H rake RAILS_ENV=production gitlab:backup:restore BACKUP=/home/gitlab/gitlab/tmp/backups/20130125_11h35_1359131740

Note: Backup folder is set in config/gitlab.yml. GitLab backup and
restore is documented here.

> Migrate from sqlite to mysql

Get latest code as described in #Update_Gitlab. Save data.

    # cd /home/gitlab/gitlab
    # sudo -u gitlab bundle exec rake db:data:dump RAILS_ENV=production

Follow #Mysql instructions and then setup the database.

    # sudo -u gitlab bundle exec rake db:setup RAILS_ENV=production

Finally restore old data.

    # sudo -u gitlab bundle exec rake db:data:load RAILS_ENV=production

> Running GitLab with rvm

To run gitlab with rvm first you have to set up an rvm:

     curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3

Note:Version 1.9.3 is currently recommended to avoid some compatibility
issues.

For the complete installation you will want to be the final user (e.g.
git) so make sure to switch to this user and activate your rvm:

     su - git
     source "$HOME/.rvm/scripts/rvm"

Then continue with the installation instructions from above. However,
the systemd scripts will not work this way, because the environment for
the rvm is not activated. The recommendation here is to create to
separate shell scripts for puma and sidekiq to activate the environment
and then start the service:

    gitlab.sh

    #!/bin/sh
    source `/home/git/.rvm/bin/rvm 1.9.3 do rvm env --path`
    RAILS_ENV=production bundle exec puma -C "/home/git/gitlab/config/puma.rb"

    sidekiq.sh

    #!/bin/sh
    source `/home/git/.rvm/bin/rvm 1.9.3 do rvm env --path`
    case $1 in
        start)
            bundle exec rake sidekiq:start RAILS_ENV=production
            ;;
        stop)
            bundle exec rake sidekiq:stop RAILS_ENV=production
            ;;
        *)
            echo "Usage $0 {start|stop}"
    esac

Then modify the above systemd files so they use these scripts. Modify
the given lines:

    gitlab.service

    ExecStart=/home/git/bin/gitlab.sh

    sidekiq.service

    ExecStart=/home/git/bin/sidekiq.sh start
    ExecStop=/home/git/bin/sidekiq.sh stop

Troubleshooting
---------------

Sometimes things may not work as expected. Be sure to visit the Trouble
Shooting Guide.

> HTTPS is not green (gravatar not using https)

Redis caches gravatar images, so if you've visited your GitLab with
http, then enabled https, gravatar will load up the non-secure images.
You can clear the cache by doing

    cd /usr/share/webapps/gitlab; bundle exec rake cache:clear

as the gitlab user.

See also
--------

-   Official Documentation
-   Gitlab recipes with further documentation on running it with several
    webservers

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gitlab&oldid=306053"

Category:

-   Version Control System

-   This page was last modified on 20 March 2014, at 17:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
