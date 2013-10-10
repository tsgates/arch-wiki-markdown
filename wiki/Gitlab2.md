Gitlab2
=======

> Summary

This page gives guidelines for the installation and configuration of
Gitlab on Archlinux.

> Related

Gitolite

Ruby on Rails

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Gitlab.     
                           Notes: Most of the text  
                           are the same. (Discuss)  
  ------------------------ ------------------------ ------------------------

Gitlab is a free git repository management application based on Ruby on
Rails and Gitolite. It is distributed under the MIT License and its
source code can be found on Github. It is a very active project with a
monthly release cycle and ideal for businesses that want to keep their
code private. Consider it as a self hosted Github but open source. You
can try a demo page here.

Note:Throughout the article, sudo is heavily used, assuming that the
user that is running the commands is root or someone with equal
privileges. There is no need to edit the sudoers file whatsoever. It is
only used to change to the appropriate user. For more info read
man sudo.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Required packages                                                  |
| -   2 Create user accounts                                               |
| -   3 Gitolite                                                           |
| -   4 Gitlab                                                             |
|     -   4.1 Installation                                                 |
|     -   4.2 Basic configuration                                          |
|         -   4.2.1 Web application specific settings                      |
|         -   4.2.2 Email used for notification                            |
|         -   4.2.3 Application specific settings                          |
|         -   4.2.4 Git Hosting configuration                              |
|         -   4.2.5 Git settings                                           |
|                                                                          |
|     -   4.3 Database selection                                           |
|         -   4.3.1 SQLite                                                 |
|         -   4.3.2 MySQL                                                  |
|                                                                          |
|     -   4.4 Install gems                                                 |
|     -   4.5 Start redis server                                           |
|     -   4.6 Populate the database                                        |
|     -   4.7 Setup gitlab hooks                                           |
|     -   4.8 Check status                                                 |
|     -   4.9 Server testing and resque process                            |
|                                                                          |
| -   5 Web server configuration                                           |
|     -   5.1 Unicorn only                                                 |
|     -   5.2 Nginx and unicorn                                            |
|     -   5.3 Apache and unicorn                                           |
|         -   5.3.1 Configure Unicorn                                      |
|         -   5.3.2 Create a virtual host for Gitlab                       |
|         -   5.3.3 Enable host and start unicorn                          |
|                                                                          |
| -   6 Useful Tips                                                        |
|     -   6.1 Hidden options                                               |
|     -   6.2 Backup and restore                                           |
|     -   6.3 Update Gitlab                                                |
|     -   6.4 Migrate to mysql from sqlite                                 |
|     -   6.5 Add existing gitolite repositories                           |
|                                                                          |
| -   7 Troubleshooting                                                    |
| -   8 See also                                                           |
+--------------------------------------------------------------------------+

Required packages
-----------------

Merged with Gitlab page

Create user accounts
--------------------

Add gitlab-git and gitlab user. gitlab-git is a system user that will be
used for gitolite. gitlab user will be used for Gitlab and is part of
group gitlab-git.

    # useradd --user-group --shell /bin/sh --comment 'git version control' --create-home --system gitlab-git
    # useradd --user-group --shell /bin/bash --comment 'gitlab system' --create-home --groups gitlab-git gitlab

Gitolite
--------

Clone the gitolite repository from Gitlab's fork. That way we are sure
it will work.

    # cd /home/git
    # sudo -H -u gitlab-git git clone -b gl-v304 https://github.com/gitlabhq/gitolite.git /home/gitlab-git/gitolite

Generate Gitlab's ssh key to be used with gitolite:

 # sudo -H -u gitlab ssh-keygen -q -N '' -t rsa -f /home/gitlab/.ssh/id_rsa

Add the following path to git's .bash_profile:

    # sudo -u gitlab-git sh -c 'echo "export PATH=/home/gitlab-git/bin:$PATH" >> /home/gitlab-git/.profile'
    # sudo -u gitlab-git sh -c 'gitolite/install -ln /home/gitlab-git/bin'

Copy Gitlab's public key to gitolite's home and change permissions:

    # cp /home/gitlab/.ssh/id_rsa.pub /home/gitlab-git/gitlab.pub
    # chmod 0444 /home/gitlab-git/gitlab.pub
    # sudo -u gitlab-git -H sh -c "PATH=/home/gitlab-git/bin:$PATH; gitolite setup -pk /home/gitlab-git/gitlab.pub"
    # sudo -u gitlab-git -H sed -i 's/0077/0007/g' /home/gitlab-git/.gitolite.rc
    # sudo -u gitlab-git -H sed -i "s/\(GIT_CONFIG_KEYS\s*=>*\s*\).\{2\}/\1'\.\*'/g" /home/gitlab-git/.gitolite.rc

Change permissions:

    # chmod -R g+rwX /home/gitlab-git/repositories/
    # chmod g+x /home/gitlab-git
    # chown -R gitlab-git:gitlab-git /home/gitlab-git/repositories/

Note: The next step is important to succeed. If not, do not try to
proceed any further.

Add Gitlab's ssh key to known hosts:

    # sudo -u gitlab -H git clone gitlab-git@localhost:gitolite-admin.git /tmp/gitolite-admin

Answer yes. At this point you should be able to clone the gitolite-admin
repository.

    Example output

    Cloning into '/tmp/gitolite-admin'...
    The authenticity of host 'localhost (::1)' can't be established.
    ECDSA key fingerprint is 5a:50:69:47:1f:1c:61:79:08:a8:2c:fa:a1:fb:48:bf.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added 'localhost' (ECDSA) to the list of known hosts.
    remote: Counting objects: 6, done.
    remote: Compressing objects: 100% (4/4), done.
    Receiving objects: 100% (6/6), 712 bytes, done.
    remote: Total 6 (delta 0), reused 0 (delta 0)

If the repository is cloned successfully, it is safe to remove it:

    # rm -rf /tmp/gitolite-admin

Gitlab
------

> Installation

Tip: If you do not want to download any documentation, add
gem: --no-rdoc --no-ri to /home/gitlab/.gemrc. Be sure to add it as the
gitlab user in order to acquire the appropriate permissions.

Add ruby to Gitlab's PATH:

    # sudo -u gitlab -H sh -c 'echo "export PATH=$(ruby -rubygems -e "puts Gem.user_dir")/bin:$PATH" >> /home/gitlab/.bash_profile'

Install bundler and charlock_holmes:

    # sudo -u gitlab -H gem install charlock_holmes --version '0.6.8'
    # sudo -u gitlab -H gem install bundler

Note:When installing charlock_holmes don't mind any errors that might
occur, that's normal.

Clone Gitlab's stable repository:

    # cd /home/gitlab
    # sudo -H -u gitlab git clone -b stable git://github.com/gitlabhq/gitlabhq.git gitlab
    # cd gitlab
    # sudo -u gitlab mkdir -pv tmp

> Basic configuration

First we need to rename the example file.

    # sudo -u gitlab cp config/gitlab.yml.example config/gitlab.yml

The options are pretty straightforward. You can skip this part as it is
quite detailed. Open /home/gitlab/gitlab/config/gitlab.yml with your
favorite editor and check the settings below.

Web application specific settings

    /home/gitlab/gitlab/config/gitlab.yml

    host: myhost.example.com
    port: 80
    https: false

-   host: Enter your Fully Qualified Domain Name.

Email used for notification

    /home/gitlab/gitlab/config/gitlab.yml

    from: notify@example.com

This is how the mail address will be shown for mail notifications.
Gitlab needs the sendmail command in order to send emails (for things
like lost password recovery, new user addition etc). This command is
provided by packages such as msmtp, postfix, sendmail etc, but you can
only have one of them installed. First, check whether you already have
the sendmail command:

    # ls /usr/sbin/sendmail

If you get a ‘cannot access /usr/bin/sendmail’ then install one of the
above packages.

Application specific settings

    /home/gitlab/gitlab/config/gitlab.yml

    default_projects_limit: 10
    # backup_path: "/vol/backups"   # default: Rails.root + backups/
    # backup_keep_time: 604800      # default: 0 (forever) (in seconds)

-   default_projects_limit: As the name suggests, this integer defines
    the default number of projects new users have. The number can change
    from within Gitlab by an administrator.
-   backup_path: The path where backups are stored. Default location is
    /home/gitlab/gitlab/backups. The backups folder is created
    automatically after first backup.
-   backup_keep_time: Time to preserve backups. The default option is to
    never be deleted.

Also check Backup and restore.

Git Hosting configuration

    /home/gitlab/gitlab/config/gitlab.yml

    admin_uri: gitlab-git@localhost:gitolite-admin
    base_path: /home/gitlab-git/repositories/
    hooks_path: /home/gitlab-git/share/gitolite/hooks/
    # host: localhost
    git_user: gitlab-git
    upload_pack: true
    receive_pack: true
    # port: 22

-   admin_uri: Do not change it. Leave as is.
-   base_path: The path where gitolite's repositories reside. If the
    repositories directory is different than the default one, change it
    here.
-   hooks_path: change default setting to
    /home/gitlab-git/share/gitolite/hooks/
-   host: Should point to your FQDN.
-   git_user: Name of the git user we created.
-   upload_pack:
-   receive_pack:

-   port: ssh port which git should use. Default one is 22. If you want
    to change it for safety reasons, do not forget to also add the port
    number to .ssh/config.

    /home/gitlab/gitlab/.ssh/config

    Host localhost
    Port 5000

Git settings

    /home/gitlab/gitlab/config/gitlab.yml

    path: /usr/bin/git
    git_max_size: 5242880 # 5.megabytes
    git_timeout: 10

-   git_max_size: Max size of git objects like commits, in bytes,.This
    value can be increased if you have very large commits.
-   git_timeout: git timeout to read commit, in seconds.

> Database selection

You have two options, either use sqlite or mysql. In case you want to
change from sqlite to mysql see #Migrate_to_mysql_from_sqlite.

SQLite

You don't have to create an sqlite database, Gitlab will create it for
you.

    # sudo -u gitlab cp config/database.yml.sqlite config/database.yml

MySQL

Install mysql from the official repositories and start the daemon. Both
sysvinit and systemd are supported. If you are using initscripts you
might want to add mysqld to your DAEMONS array in rc.conf. Create the
database and do not forget to replace password with a real one.

    # mysql -u root -p

    mysql> create database gitlabhq_production;
    mysql> create user 'gitlab'@'localhost' identified by 'password';
    mysql> grant all privileges on gitlabhq_production.* to 'gitlab'@'localhost' with grant option;
    mysql> exit;

Copy the example configuration file and make sure to update
username/password in config/database.yml at production section:

    # sudo -u gitlab cp config/database.yml.example config/database.yml

> Install gems

This could take a while as it installs all required libraries.

    # cd /home/gitlab/gitlab
    # source /home/gitlab/.bash_profile
    # sudo -u gitlab -H bundle install --deployment

Note:Using "--without development test" in bundle command line will
ignore required packages for database backup and restore

  
 Fix for pygments.rb to work with our python2 (thanks to billyburly).

    # sed -i "s/opts = {})/opts = {:python_exe => 'python'})/g" /home/gitlab/gitlab/vendor/bundle/ruby/1.9.1/bundler/gems/pygments.rb-2cada028da50/lib/pygments/ffi.rb
    # ln -s /usr/bin/python2 /usr/bin/python

> Start redis server

Start the daemon. If you are using initscripts you might want to add
redis to your DAEMONS array in rc.conf.

Note:redis might already be running, causing a FAIL message to appear.
Check if it is already running with rc.d list redis.

If you have switched to systemd, there is a service file included in the
official package. See daemon how to enable it.

> Populate the database

    # sudo -u gitlab bundle exec rake gitlab:app:setup RAILS_ENV=production

> Setup gitlab hooks

    # cp ./lib/hooks/post-receive /home/gitlab-git/share/gitolite/hooks/common/post-receive
    # chown gitlab-git:gitlab-git /home/gitlab-git/share/gitolite/hooks/common/post-receive

> Check status

With the following command we check if the steps we followed so far are
conigured properly.

    # sudo -u gitlab bundle exec rake gitlab:app:status RAILS_ENV=production

    Example output

    Starting diagnostic
    config/database.yml............exists
    config/gitlab.yml............exists
    /home/gitlab-git/repositories/............exists
    /home/gitlab-git/repositories/ is writable?............YES
    remote: Counting objects: 6, done.
    remote: Compressing objects: 100% (4/4), done.
    Receiving objects: 100% (6/6), 712 bytes, done.
    remote: Total 6 (delta 0), reused 0 (delta 0)
    Can clone gitolite-admin?............YES
    UMASK for .gitolite.rc is 0007? ............YES
    /home/gitlab-git/share/gitolite/hooks/common/post-receive exists? ............YES

    Finished

> Server testing and resque process

Resque is a Redis-backed library for creating background jobs, placing
those jobs on multiple queues, and processing them later. For the
backstory, philosophy, and history of Resque's beginnings, please see
this blog post.

Run resque process for processing queue:

    # sudo -u gitlab bundle exec rake environment resque:work QUEUE=* RAILS_ENV=production BACKGROUND=yes

or use Gitlab's start script:

    # sudo -u gitlab ./resque.sh

Note:If you run this as root,
/home/gitlab/gitlab/tmp/pids/resque_worker.pid will be owned by root
causing the resque worker not to start via init script on next
boot/service restart

Gitlab application can be started with the next command:

    # sudo -u gitlab bundle exec rails s -e production

Open localhost:3000 with your favorite browser and you should see
Gitlab's sign in page. In case you missed it, the default login/password
are:

    login.........admin@local.host
    password......5iveL!fe

Since this is a thin web server, it is only for test purposes. You may
close it with Ctrl+c. Follow instructions below to make Gitlab run with
a real web server.

Web server configuration
------------------------

> Unicorn only

Edit /home/gitlab/gitlab/config/unicorn.rb uncomment:

    listen 8080 # listen to port 8080 on all TCP interfaces

Create /etc/rc.d/unicorn-gitlab

    #!/bin/bash

    . /etc/rc.conf
    . /etc/rc.d/functions


    PID=`pidof -o %PPID /usr/bin/ruby`
    case "$1" in
      start)
        stat_busy "Starting unicorn"
        [ -z "$PID" ] && sudo -u gitlab bash  -c  "source /home/gitlab/.bash_profile && cd /home/gitlab/gitlab/ && bundle exec unicorn_rails -c config/unicorn.rb -E production -D"
        if [ $? -gt 0 ]; then
          stat_fail
        else
          add_daemon unicorn
          stat_done
        fi
        ;;
      stop)
        stat_busy "Stopping unicorn"
        [ ! -z "$PID" ]  && kill $PID &> /dev/null
        if [ $? -gt 0 ]; then
          stat_fail
        else
          rm_daemon unicorn
          stat_done
        fi
        ;;
      restart)
        $0 stop
        sleep 1
        $0 start
        ;;
      *)
        echo "usage: $0 {start|stop|restart}"
    esac
    exit 0

Start unicorn:

    # /etc/rc.d/unicorn-gitlab start

Test it http://localhost:8080

Add it to DAEMONS array in /etc/rc.conf

Redirect http port to unicorn server

    # iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080

And test again, now http://localhost

  

> Nginx and unicorn

Install nginx from the official repositories.

Edit /etc/nginx/nginx.conf. In the http section add:

    upstream gitlab {
        server unix:/home/gitlab/gitlab/tmp/sockets/gitlab.socket;
    }

    server {
       listen YOUR_SERVER_IP:80;         # e.g., listen 192.168.1.1:80;
       server_name YOUR_SERVER_FQDN;     # e.g., server_name source.example.com;
       root /home/gitlab/gitlab/public;

       # individual nginx logs for this gitlab vhost
       access_log  /var/log/nginx/gitlab_access.log;
       error_log   /var/log/nginx/gitlab_error.log;

       location / {
           # serve static files from defined root folder;.
           # @gitlab is a named location for the upstream fallback, see below
           try_files $uri $uri/index.html $uri.html @gitlab;
       }

       # if a file, which is not found in the root folder is requested, 
       # then the proxy pass the request to the upsteam (gitlab unicorn)
       location @gitlab {
         proxy_redirect     off;

         # you need to change this to "https", if you set "ssl" directive to "on"
         proxy_set_header   X-FORWARDED_PROTO http;
         proxy_set_header   Host              $http_host;
         proxy_set_header   X-Real-IP         $remote_addr;

         proxy_pass http://gitlab;
       }
    }

Change YOUR_SERVER_IP and YOUR_SERVER_FQDN to the IP address and
fully-qualified domain name of the host serving Gitlab and restart
nginx.

Unicorn is an HTTP server for Rack applications designed to only serve
fast clients on low-latency, high-bandwidth connections and take
advantage of features in Unix/Unix-like kernels. First we rename the
example file and then we start unicorn:

    # cd /home/gitlab/gitlab
    # sudo -u gitlab cp config/unicorn.rb.orig config/unicorn.rb
    # sudo -u gitlab bundle exec unicorn_rails -c config/unicorn.rb -E production -D

> Apache and unicorn

Install apache from the official repositories.

Configure Unicorn

As the official installation guide instructs, copy the unicorn
configuration file:

    # sudo -u gitlab -H cp /home/gitlab/gitlab/config/unicorn.rb.example /home/gitlab/gitlab/config/unicorn.rb

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

    # mkdir -pv /etc/httpd/conf/vhosts/

    /etc/httpd/conf/vhosts/gitlab

    <VirtualHost *:80>
      ServerName gitlab.myserver.com
      ServerAlias www.gitlab.myserver.com
      DocumentRoot /home/gitlab/gitlab/public
      ErrorLog /var/log/httpd/gitlab_error_log
      CustomLog /var/log/httpd/gitlab_access_log combined

      <Proxy balancer://unicornservers>
          BalancerMember http://127.0.0.1:8080
      </Proxy>

      <Directory /home/gitlab/gitlab/public>
        AllowOverride All
        Options -MultiViews
      </Directory>

      RewriteEngine on
      RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f
      RewriteRule ^/(.*)$ balancer://unicornservers%{REQUEST_URI} [P,QSA,L]

      ProxyPass /uploads !
      ProxyPass / balancer://unicornservers/
      ProxyPassReverse / balancer://unicornservers/
      ProxyPreserveHost on

       <Proxy *>
          Order deny,allow
          Allow from all
       </Proxy>
    </VirtualHost>

    <VirtualHost MY_IP:443>
      ServerName gitlab.myserver.com
      ServerAlias www.gitlab.myserver.com
      DocumentRoot /home/gitlab/gitlab/public
      ErrorLog /var/log/httpd/gitlab_error_log
      CustomLog /var/log/httpd/gitlab_access_log combined

      <Proxy balancer://unicornservers>
          BalancerMember http://127.0.0.1:8080
      </Proxy>

      <Directory /home/gitlab/gitlab/public>
        AllowOverride All
        Options -MultiViews
      </Directory>

      RewriteEngine on
      RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f
      RewriteRule ^/(.*)$ balancer://unicornservers%{REQUEST_URI} [P,QSA,L]

      ProxyPass /uploads !
      ProxyPass / balancer://unicornservers/
      ProxyPassReverse / balancer://unicornservers/
      ProxyPreserveHost on

       <Proxy *>
          Order deny,allow
          Allow from all
       </Proxy>

      SSLEngine on
      SSLCertificateFile /home/gitlab/gitlab/ssl.cert
      SSLCertificateKeyFile /home/gitlab/gitlab/ssl.key
    </VirtualHost>

Enable host and start unicorn

Enable your Gitlab virtual host and reload Apache:

    /etc/httpd/conf/httpd.conf

    Include conf/vhosts/gitlab

Finally start unicorn:

    # cd /home/gitlab/gitlab
    # sudo -u gitlab bundle exec unicorn_rails -c config/unicorn.rb -E production -D

Useful Tips
-----------

> Hidden options

Go to Gitlab's home directory

    # cd /home/gitlab/gitlab

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

Create a backup of the gitlab system.

    # cd /home/gitlab/gitlab
    # sudo -u gitlab rake gitlab:app:backup_create

Restore a previously created backup.

    # cd /home/gitlab/gitlab
    # sudo -u gitlab rake gitlab:app:backup_restore

Note: Backup folder is set in conig.yml. Check
#Application_specific_settings.

> Update Gitlab

When a new version is out follow the instructions at Github wiki. A new
release is out every 22nd of a month.

  

> Migrate to mysql from sqlite

Get latest code as described in #Update_Gitlab. Save data.

    # cd /home/gitlab/gitlab
    # sudo -u gitlab bundle exec rake db:data:dump RAILS_ENV=production

Follow #Mysql instructions and then setup the database.

    # sudo -u gitlab bundle exec rake db:setup RAILS_ENV=production

Finally restore old data.

    # sudo -u gitlab bundle exec rake db:data:load RAILS_ENV=production

> Add existing gitolite repositories

Troubleshooting
---------------

Sometimes things may not work as expected. Be sure to visit the Trouble
Shooting Guide.

See also
--------

-   Official Documentation
-   GitLab on an Ubuntu 10.04 server with Apache
-   Setting up gitlab on Debian 6
-   Installing Gitlab on CentOS 6
-   Gist: Install Gitlab on Debian Squeeze
-   Gist: Install Gitlab on Archlinux

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gitlab2&oldid=240302"

Category:

-   Version Control System
