Nginx
=====

Nginx (pronounced "engine X") written by Igor Sysoev (Russia) in 2005,
is a free, open-source, high-performance HTTP server and reverse proxy,
as well as an IMAP/POP3 proxy server. According to Netcraft's March 2013
Web Server Survey, Nginx now hosts 13.53% of all domains worldwide,
while Apache hosts about 54.68%. Nginx is now well known for its
stability, rich feature set, simple configuration, and low resource
consumption.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Installation in a chroot                                           |
|     -   2.1 Create Necessary Devices                                     |
|     -   2.2 Create Necessary Folders                                     |
|     -   2.3 Populate the chroot                                          |
|     -   2.4 Modify nginx.service to start chroot                         |
|                                                                          |
| -   3 Starting Service                                                   |
| -   4 Configuring                                                        |
|     -   4.1 FastCGI                                                      |
|         -   4.1.1 PHP implementation                                     |
|             -   4.1.1.1 Step 1: PHP configuration                        |
|             -   4.1.1.2 Step 2: php-fpm                                  |
|             -   4.1.1.3 Step 3: Nginx configuration                      |
|                                                                          |
|         -   4.1.2 CGI implementation                                     |
|             -   4.1.2.1 Step 1: fcgiwrap                                 |
|                 -   4.1.2.1.1 Multiple worker threads                    |
|                                                                          |
|             -   4.1.2.2 Step 2: Nginx configuration                      |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 Accessing local IP redirects to localhost                    |
|     -   5.2 Error: 403 (Permission error)                                |
|     -   5.3 Error: 404 (Pathinfo error)                                  |
|     -   5.4 Error: The page you are looking for is temporarily           |
|         unavailable. Please try again later.                             |
|     -   5.5 Error: No input file specified                               |
|     -   5.6 Error: chroot: '/usr/sbin/nginx' No such file or directory   |
|                                                                          |
| -   6 See Also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install package nginx in the official repositories.

For a Ruby on Rails oriented installation, see The Perfect Rails Setup.

Installation in a chroot
------------------------

Installing Nginx in a chroot adds an additional layer of security. For
maximum security the chroot should include only the files needed to run
the Nginx server and all files should have the most restrictive
permissions possible, e.g., as much as possible should be owned by root,
directories such as /usr/bin should be unreadable and unwriteable, etc.

Arch comes with an http user and group by default which will run the
server. The chroot will be in /srv/http.

A perl script to create this jail is available at jail.pl gist. It
expects to be run as root. You will need to uncomment a line before it
makes any changes.

> Create Necessary Devices

Nginx needs /dev/null, /dev/random, and /dev/urandom. To install these
in the chroot we create the /dev/ folder and add the devices with mknod.
We avoid mounting all of /dev/ to ensure that, even if the chroot is
compromised, an attacker must break out of the chroot to access
important devices like /dev/sda1.

Tip:See man mknod and ls -l /dev/{null,random,urandom} to better
understand the argument to mknod.

    # export JAIL=/srv/http
    # mkdir $JAIL/dev
    # mknod -m 0666 $JAIL/dev/null c 1 3
    # mknod -m 0666 $JAIL/dev/random c 1 8
    # mknod -m 0444 $JAIL/dev/urandom c 1 9

> Create Necessary Folders

Nginx requires a bunch of files to run properly. Before copying them
over, create the folders to store them. This assumes your Nginx document
root will be /srv/http/www.

    # mkdir -p $JAIL/etc/nginx/logs
    # mkdir -p $JAIL/usr/{lib,sbin}
    # mkdir -p $JAIL/usr/share/nginx
    # mkdir -p $JAIL/var/{log,lib}/nginx
    # mkdir -p $JAIL/www/cgi-bin
    # mkdir -p $JAIL/{run,tmp}
    # cd $JAIL; ln -s usr/lib lib 

Note: If using a 64 bit kernel you will need to create symbolic links
lib64 and usr/lib64 to usr/lib: cd $JAIL; ln -s usr/lib lib64 ; ln -s
usr/lib usr/lib64.

Then mount $JAIL/tmp and $JAIL/run as tmpfs's. The size should be
limited to ensure an attacker cannot eat all the RAM.

    # mount -t tmpfs none $JAIL/run -o 'noexec,size=1M'
    # mount -t tmpfs none $JAIL/tmp -o 'noexec,size=100M'

In order to preserve the mounts across reboots, the following entries
should be added to /etc/fstab:

    /etc/fstab

     tmpfs   /srv/http/run   tmpfs   rw,noexec,relatime,size=1024k   0       0
     tmpfs   /srv/http/tmp   tmpfs   rw,noexec,relatime,size=102400k 0       0

  

> Populate the chroot

First copy over the easy files.

    # cp -r /usr/share/nginx/* $JAIL/usr/share/nginx
    # cp -r /usr/share/nginx/html/* $JAIL/www
    # cp /usr/sbin/nginx $JAIL/usr/sbin/
    # cp -r /var/lib/nginx $JAIL/var/lib/nginx

Now copy over required libraries. Use ldd to list them and then copy
them all to the correct location. Copying is preferred over hardlinks to
ensure that even if an attacker gains write access to the files they
cannot destroy or alter the true system files.

    $ ldd /usr/sbin/nginx

       linux-vdso.so.1 (0x00007fff5adff000)
       libpthread.so.0 => /usr/lib/libpthread.so.0 (0x00007fdb1a8d3000)
       libcrypt.so.1 => /usr/lib/libcrypt.so.1 (0x00007fdb1a69c000)
       libstdc++.so.6 => /usr/lib/libstdc++.so.6 (0x00007fdb1a399000)
       libm.so.6 => /usr/lib/libm.so.6 (0x00007fdb1a09f000)
       libpcre.so.1 => /usr/lib/libpcre.so.1 (0x00007fdb19e3c000)
       libssl.so.1.0.0 => /usr/lib/libssl.so.1.0.0 (0x00007fdb19bd2000)
       libcrypto.so.1.0.0 => /usr/lib/libcrypto.so.1.0.0 (0x00007fdb197c9000)
       libdl.so.2 => /usr/lib/libdl.so.2 (0x00007fdb195c5000)
       libz.so.1 => /usr/lib/libz.so.1 (0x00007fdb193af000)
       libGeoIP.so.1 => /usr/lib/libGeoIP.so.1 (0x00007fdb1917c000)
       libgcc_s.so.1 => /usr/lib/libgcc_s.so.1 (0x00007fdb18f67000)
       libc.so.6 => /usr/lib/libc.so.6 (0x00007fdb18bc0000)
       /lib/ld-linux-x86-64.so.2 (0x00007fdb1aaef000)

    # cp /lib/ld-linux-x86-64.so.2 $JAIL/lib

For files residing in /usr/lib you may try the following one-liner:

    # cp $(ldd /usr/sbin/nginx | grep /usr/lib | sed -sre 's/(.+)(\/usr\/lib\/\S+).+/\2/g') $JAIL/usr/lib

Note:Do not try to copy linux-vdso.so – it is not a real library and
does not exist in /usr/lib. Also ld-linux-x86-64.so will likely be
listed in /lib64 for a 64 bit system.

Copy over some misc. but necessary libraries and system files.

    # cp /usr/lib/libnss_* $JAIL/usr/lib
    # cp -rfvL /etc/{services,localtime,nsswitch.conf,nscd.conf,protocols,hosts,ld.so.cache,ld.so.conf,resolv.conf,host.conf,nginx} $JAIL/etc

Create restricted user/group files for the chroot. This way only the
users needed for the chroot to function exist as far as the chroot
knows, and none of the system users/groups are leaked to attackers
should they gain access to the chroot.

    $JAIL/etc/group

    http:x:33:
    nobody:x:99:

    $JAIL/etc/passwd

    http:x:33:33:http:/:/bin/false
    nobody:x:99:99:nobody:/:/bin/false

    $JAIL/etc/shadow

    http:x:14871::::::
    nobody:x:14871::::::

    $JAIL/etc/gshadow

    http:::
    nobody:::

    # touch $JAIL/etc/shells
    # touch $JAIL/run/nginx.pid

Finally make set very restrictive permissions. As much as possible
should be owned by root and set unwritable.

    # chown -R root:root $JAIL/
     
    # chown -R http:http $JAIL/www
    # chown -R http:http $JAIL/etc/nginx
    # chown -R http:http $JAIL/var/{log,lib}/nginx
    # chown http:http $JAIL/run/nginx.pid
     
    # find $JAIL/ -gid 0 -uid 0 -type d -print | xargs chmod -rw
    # find $JAIL/ -gid 0 -uid 0 -type d -print | xargs chmod +x
    # find $JAIL/etc -gid 0 -uid 0 -type f -print | xargs chmod -x
    # find $JAIL/usr/sbin -type f -print | xargs chmod ug+rx
    # find $JAIL/ -group http -user http -print | xargs chmod o-rwx
    # chmod +rw $JAIL/tmp
    # chmod +rw $JAIL/run

If your server will bind port 80 (or any port 0-1024), give the chrooted
executable permission to bind these ports without root.

    # setcap 'cap_net_bind_service=+ep' $JAIL/usr/sbin/nginx

> Modify nginx.service to start chroot

Before modifying the nginx.service unit file, it may be a good idea to
copy it to /etc/systemd/system/ since the unit files there take priority
over those in /usr/lib/systemd/system/. This means upgrading nginx would
not modify your custom .service file.

    # cp /usr/lib/systemd/system/nginx.service /etc/systemd/system/nginx.service

The systemd unit must be changed to start up Nginx in the chroot, as the
http user, and store the pid file in the chroot

Note:I'm not sure if the pid file needs to be stored in the chroot jail.

    /etc/systemd/system/nginx.service

     [Unit]
     Description=A high performance web server and a reverse proxy server
     After=syslog.target network.target
     
     [Service]
     Type=forking
     PIDFile=/srv/http/run/nginx.pid
     ExecStartPre=/usr/bin/chroot --userspec=http:http /srv/http /usr/sbin/nginx -t -q -g 'pid /run/nginx.pid; daemon on; master_process on;'
     ExecStart=/usr/bin/chroot --userspec=http:http /srv/http /usr/sbin/nginx -g 'pid /run/nginx.pid; daemon on; master_process on;'
     ExecReload=/usr/bin/chroot --userspec=http:http /srv/http /usr/sbin/nginx -g 'pid /run/nginx.pid; daemon on; master_process on;' -s reload
     ExecStop=/usr/bin/chroot --userspec=http:http /srv/http /usr/sbin/nginx -g 'pid /run/nginx.pid;' -s quit
     
     [Install]
     WantedBy=multi-user.target

Note:Upgrading nginx with pacman will not upgrade the chrooted nginx
installation. You have to take care of the updates manually by repeating
some of the steps above. Do not forget to also update the libraries it
links against.

You can now safely get rid of the non-chrooted nginx installation.

    # pacman -Rsc nginx

If you do not remove the non-chrooted nginx installation, you may want
to make sure that the running nginx process is in fact the chrooted one.
You can do so by checking where /proc/{PID}/root symmlinks to. If should
link to /srv/http instead of /.

    # ps -C nginx | awk '{print $1}' | sed 1d | while read -r PID; do ls -l /proc/$PID/root; done

Starting Service
----------------

To enable the Nginx service by default at start-up, run:

    # systemctl enable nginx

To start the Nginx service, run:

    # systemctl start nginx

The default served page at http://127.0.0.1 is:

    /usr/share/nginx/html/index.html

Configuring
-----------

You can modify the configuration by editing the files in /etc/nginx/.
The main configuration file is located at /etc/nginx/nginx.conf.

More details can be found here: Nginx Configuration Examples.

> FastCGI

FastCGI, also FCGI, is a protocol for interfacing interactive programs
with a web server. FastCGI is a variation on the earlier Common Gateway
Interface (CGI); FastCGI's main aim is to reduce the overhead associated
with interfacing the web server and CGI programs, allowing a server to
handle more web page requests at once.

FastCGI technology is introduced into Nginx to work with many external
tools, i.e.: Perl, PHP and Python. So, you cannot use these unless a
FastCGI server has been started.

PHP implementation

There are different ways to run a FastCGI server for PHP. We cover
php-fpm, a recommended solution.

Step 1: PHP configuration

The open_basedir in /etc/php/php.ini has to list base directories which
contain PHP files, like /srv/http/ and /usr/share/webapps/:

    open_basedir = /usr/share/webapps/:/srv/http/:/home/:/tmp/:/usr/share/pear/

Step 2: php-fpm

-   http://php-fpm.org

Install php-fpm. The configuration file is /etc/php/php-fpm.conf. Enable
and start the systemd php-fpm.service.

Step 3: Nginx configuration

Inside each server block serving a PHP web application should appear a
location block similar to:

     location ~ \.php$ {
          fastcgi_pass   unix:/run/php-fpm/php-fpm.sock;
          fastcgi_index  index.php;
          include        fastcgi.conf;
     }

You could create /etc/nginx/php.conf and save this configuration there,
then when needed just include this file into the server block.

     server = {
         ...
         include  php.conf;
         ...
     }

If you are going to process .html and .htm files with PHP, you should
have something like this:

     location ~ \.(php|html|htm)$ {
          fastcgi_pass   unix:/var/run/php-fpm/php-fpm.sock;
          fastcgi_index  index.php;
          include        fastcgi.conf;
     }

Non .php files processing in php-fpm should be explicitly enabled in
/etc/php/php-fpm.conf:

     security.limit_extensions = .php .html .htm

You need to restart the php-fpm daemon if you changed the configuration.

    # systemctl restart php-fpm

Pay attention to the fastcgi_pass argument, as it must be the TCP or
Unix socket defined by the chosen FastCGI server in its config file. The
default (Unix) socket for php-fpm is

    fastcgi_pass unix:/run/php-fpm/php-fpm.sock;

You might use the common TCP socket, not default,

    fastcgi_pass 127.0.0.1:9000;

Unix domain sockets are however faster.

fastcgi.conf or fastcgi_params are usually included because they hold
FastCGI settings for Nginx; the use of the latter is deprecated, though.
They come within the Nginx installation.

Finally, if Nginx has been working, run:

    # systemctl restart nginx

If you would like to test the FastCGI implementation, create
/usr/share/nginx/html/index.php with content

    <?php
      phpinfo();
    ?> 

and visit the URL http://127.0.0.1/index.php with your browser.

CGI implementation

This implementation is needed for CGI applications.

Step 1: fcgiwrap

Install fcgiwrap. The configuration file is
/usr/lib/systemd/system/fcgiwrap.socket. Enable and start the systemd
fcgiwrap.socket.

The systemd unit file is currently being discussed on this ArchLinux
task page. You may want to examine the unit file yourself to ensure it
will work the way you want.

Multiple worker threads

If you want to spawn multiple worker threads, it's recommended that you
use multiwatch, which will take care of restarting crashed children. You
will need to use spawn-fcgi to create the unix socket, as multiwatch
seems unable to handle the systemd-created socket, even though fcgiwrap
itself does not have any trouble if invoked directly in the unit file.

Copy the unit file from /usr/lib/systemd/system/fcgiwrap.service to
/etc/systemd/system/fcgiwrap.service (and the fcgiwrap.socket unit, if
present), and modify the ExecStart line to suit your needs. Here is a
unit file that uses multiwatch. Make sure fcgiwrap.socket is not started
or enabled, because it will conflict with this unit:

    /etc/systemd/system/fcgiwrap.service

    [Unit]
    Description=Simple CGI Server
    After=nss-user-lookup.target

    [Service]
    ExecStart=/usr/bin/spawn-fcgi -u http -g http -s /run/fcgiwrap.sock -n -- /usr/bin/multiwatch -f 10 -- /usr/sbin/fcgiwrap
    ExecStartPost=/usr/bin/chmod 660 /run/fcgiwrap.sock
    PrivateTmp=true
    Restart=on-failure

    [Install]
    WantedBy=multi-user.target

Tweak -f 10 to change the number of children that are spawned.

Warning:The ExecStartPost line is required because of strange behaviour
I'm seeing when I use the -M 660 option for spawn-fcgi. The wrong mode
is set. This may be a bug?

Step 2: Nginx configuration

Inside each server block serving a CGI web application should appear a
location block similar to:

     location ~ \.cgi$ {
          fastcgi_pass   unix:/run/fcgiwrap.sock;
          include        fastcgi.conf;
     }

The default (Unix) socket for fcgiwrap is /run/fcgiwrap.sock.

Troubleshooting
---------------

> Accessing local IP redirects to localhost

Solution from the Arch Linux forum.

Edit /etc/nginx/nginx.conf and locate the "server_name localhost" line
without a # infront of it, and add below:

    server_name_in_redirect off;

Default behavior is that nginx redirects any requests to the value given
as server_name in the config.

> Error: 403 (Permission error)

This is most likely a permission error. Are you sure whatever user
configured in the Nginx configuration is able to read the correct files?

If the files are located within a home directory, (e.g.
/home/arch/public/webapp) and you are sure the user running Nginx has
the right permissions (you can temporarily chmod all the files to 777 in
order to determine this), /home/arch might be chmod 750, simply chmod it
to 751, and it should work.

If you have changed your document root

If you are sure that permissions are as they should be, make sure that
your document root directory is not empty. Try creating index.html in
there.

> Error: 404 (Pathinfo error)

In some framework (like thinkphp, cakephp) or CMS, they need the
pathinfo function.

1. Edit the file /etc/php/php.ini, make sure

    cgi.fix_pathinfo=1

2. Edit /etc/nginx/conf/nginx.conf, comment

    location ~ \.php$ {
    ...
    }

to

    #location ~ \.php$ {
    #...
    #}

Then add the follows,

    location ~ ^(.+\.php)(.*)$ {
      root   /srv/http/nginx;
      fastcgi_pass   unix:/var/run/php-fpm/php-fpm.sock; 	
      #fastcgi_pass   127.0.0.1:9000; #Un-comment this and comment "fastcgi_pass   unix:/var/run/php-fpm/php-fpm.sock;" if you are not using php-fpm.
      fastcgi_index  index.php;
      set $document_root2 $document_root;
      if ($document_root2 ~ "^(.*\\\\).*?[\\\\|\/]\.\.\/(.*)$") { set $document_root2 $1$2; }
      if ($document_root2 ~ "^(.*\\\\).*?[\\\\|\/]\.\.\/(.*)$") {	set $document_root2 $1$2; }
      if ($document_root2 ~ "^(.*\\\\).*?[\\\\|\/]\.\.\/(.*)$") {	set $document_root2 $1$2; }
      if ($document_root2 ~ "^(.*\\\\).*?[\\\\|\/]\.\.\/(.*)$") {	set $document_root2 $1$2; }
      if ($document_root2 ~ "^(.*\\\\).*?[\\\\|\/]\.\.\/(.*)$") {	set $document_root2 $1$2; }
      fastcgi_split_path_info ^(.+\.php)(.*)$;
      fastcgi_param	SCRIPT_FILENAME	$document_root2$fastcgi_script_name;
      fastcgi_param	PATH_INFO	$fastcgi_path_info;
      fastcgi_param	PATH_TRANSLATED	$document_root2$fastcgi_path_info;
      include	fastcgi_params;
      fastcgi_param  DOCUMENT_ROOT      $document_root2;
    }

> Error: The page you are looking for is temporarily unavailable. Please try again later.

This is because the FastCGI server has not been started, or the socket
used has wrong permissions.

> Error: No input file specified

Most Likely you do not have the SCRIPT_FILENAME containing the full path
to your scripts. If the configuration of nginx (fastcgi_param
SCRIPT_FILENAME) is correct, this kind of error means php failed to load
the requested script. Usually it is simply a permissions issue, you can
just run php-cgi as root

    # spawn-fcgi -a 127.0.0.1 -p 9000 -f /usr/bin/php-cgi

or you should create a group and user to start the php-cgi. For example:

    # groupadd www
    # useradd -g www www
    # chmod +w /srv/www/nginx/html
    # chown -R www:www /srv/www/nginx/html
    # spawn-fcgi -a 127.0.0.1 -p 9000 -u www -g www -f /usr/bin/php-cgi

Another occasion is that, wrong "root" argument in the "location ~
\.php$" section in nginx.conf, make sure the "root" points to the same
directory as it in "location /" in the same server. Or you may just set
root as global, do not define it in any location section.

Also keep in mind that your php script path was defined as /srv/http by
default using the variable "open_basedir" in /etc/php/php.ini; you can
change them if you need.

Also notice that not only php script should have read permission, but
also the entire directory structure should have execute permission so
that PHP user can traverse the path.

> Error: chroot: '/usr/sbin/nginx' No such file or directory

If you encounter this error when running the daemon of nginx using
chroot, this is likely due to missing 64 bit libraries in the jailed
environment.

If you are running chroot in /srv/http you need to add the required 64
bit libraries.

First, set up the directories (these commands will need to be run as
root)

    # mkdir /srv/http/usr/lib64 
    # cd /srv/http; ln -s usr/lib64 lib64

Then copy the required 64 bit libraries found using ldd /usr/sbin/nginx
to /srv/http/usr/lib64

if run as root, permissions for the libraries should be read and
executable for all users, so no modification is required.

See Also
--------

-   Init script for Nginx
-   Nginx Official Site
-   Nginx HowTo
-   Easy Config Files

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nginx&oldid=253330"

Category:

-   Web Server
