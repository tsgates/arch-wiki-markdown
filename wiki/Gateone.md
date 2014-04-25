Gateone
=======

From Gate One ✈ Web Terminal Emulator and SSH Client:

Gate One™ is a web-based Terminal Emulator and SSH client that brings
the power of the command line to the web. It requires no browser plugins
and is built on top of a powerful plugin system that allows every aspect
of its appearance and functionality to be customized.

Gate One enables users to access SSH servers over the web. alternatives
exist, such as Guacamole. One of Gate One's distinguishing features is
the ability to resume sessions from other browsers or to replay
sessions.

This guide covers Gate One setup behind nginx as reverse proxy.

Contents
--------

-   1 Installation
    -   1.1 Optional dependencies
-   2 Configuration
    -   2.1 Main settings
    -   2.2 Authentication settings
        -   2.2.1 None
        -   2.2.2 PAM
        -   2.2.3 Google
    -   2.3 Terminal settings
    -   2.4 Reverse proxy
        -   2.4.1 Nginx
-   3 Systemd integration
-   4 Problems

Installation
------------

Gate One is available in the AUR via gateone-git.

> Optional dependencies

If you want to be able to upgrade (restart) Gate One without losing
user's connected sessions you have to have dtach installed. This option
is enabled by default in the configuration.

dtach
    emulates the detach feature of screen

Configuration
-------------

Warning:By default gateone allows anonymous users to access the service.
Please make sure to change the settings.

Following installation run gateone once to generate a default
configuration with self generated ssl certificates.

    # gateone

Let’s edit the configuration to suite your needs. There are three
configuration files by default. located under /etc/gateone/conf.d/

All options are described at:
http://liftoff.github.io/GateOne/About/index.html#configuration

Keep in mind that these options are split up in three configuration
files: this article will deal with only some of them.

> Main settings

The main server settings are found in /etc/gateone/conf.d/10server.conf.

    /etc/gateone/conf.d/10server.conf

    {
        // "gateone" server-wide settings fall under "*"
        "*": {
            "gateone": { // These settings apply to all of Gate One
                "address": "",
                "ca_certs": null,
                "cache_dir": "/tmp/gateone_cache",
                "certificate": "/etc/gateone/ssl/certificate.pem",
                "combine_css": "",
                "combine_css_container": "gateone",
                "combine_js": "",
                "cookie_secret": "ZTRiOGUzNjM5ZmNjNDJjODllNDRmODk3Y2RjZTVlNTc4M",
                "debug": false,
                "disable_ssl": false,
                "embedded": false,
                "enable_unix_socket": false,
                "gid": "0",
                "https_redirect": false,
                "js_init": "",
                "keyfile": "/etc/gateone/ssl/keyfile.pem",
                "locale": "en_US",
                "log_file_max_size": 100000000,
                "log_file_num_backups": 10,
                "log_file_prefix": "/var/log/gateone/gateone.log",
                "log_to_stderr": null,
                "logging": "info",
                "origins": ["localhost", "127.0.0.1", "10.1.1.100"],
                "pid_file": "/var/run/gateone.pid",
                "port": 443,
                "session_dir": "/tmp/gateone",
                "session_timeout": "5d",
                "syslog_facility": "daemon",
                "syslog_host": null,
                "uid": "0",
                "unix_socket_path": "/tmp/gateone.sock",
                "url_prefix": "/",
                "user_dir": "/var/lib/gateone/users",
                "user_logs_max_age": "30d"
            }
        }
    }

"address": "" This tells Gate One to listen on all addresses.
"address": "localhost;::1;10.1.1.100" Gate One will listen on localhost
(IPv4 and IPv6) and on 10.1.1.100.

"disable_ssl": false or true, if you are handling SSL offloading
somewhere else.

"origins": ["localhost", "127.0.0.1", "serverhostname", "10.1.1.100", "full.domain.name",
Add all URL's that will be used when connecting to Gate One. Failed
attempts will be logged, look for "unknown origins" with systemctl
status gateone

"port": 443 What TCP port Gate One will listen on.

"url_prefix": "/" Specifies the URL path, if set to "/gateone/" the
address will be https://10.1.1.100/gateone/

> Authentication settings

The authentication settings are found in
/etc/gateone/conf.d/20authentication.conf.

    /etc/gateone/conf.d/20authentication.conf

    // This is Gate One's authentication settings file.
    {
        // "gateone" server-wide settings fall under "*"
        "*": {
            "gateone": { // These settings apply to all of Gate One
                "api_timestamp_window": "30s",
                "auth": "none",
                "pam_realm": "hostname",
                "pam_service": "login",
                "ssl_auth": "none",
                "sso_keytab": null,
                "sso_realm": null,
                "sso_service": "HTTP"
            }
        }
    }

"auth": "none" Can be "none", "pam", google", "kerberos" or "api".

None

None is no authentication and allows anonymous access. Sessions will be
tied to browser cookie.

PAM

PAM authentication can be used to authenticate with local users, but PAM
can do much more. For example, you can authenticate against htpasswd
files. Requires pam_pwdfile.

    /etc/gateone/conf.d/20authentication.conf

     "auth": "pam"
     "pam_service": "gateonepwd"

Gate One uses Crypt encryption so use switch -d.

    # htpasswd -c -d /etc/gateone/users.passwd user1

Create the PAM service file

    /etc/pam.d/gateonepwd

     #%PAM-1.0
     # Login using a htpasswd file
     @include common-sessionauth    
     required pam_pwdfile.so          pwdfile /etc/gateone/users.passwd
     required pam_permit.so

Google

Google Authentication uses Google to authenticate (Gmail or Google+).

All authenticated modes enable you to resume your sessions on a
different browser.

> Terminal settings

Here you can add terminals and options for them. For example using it to
control what are accessible to Google authenticated users. For more
information look here:
https://github.com/liftoff/GateOne/blob/master/gateone/applications/terminal/docs/configuration.rst

Example to only allow example@gmail.com and test@gmail.com to access the
SSH application:

    /etc/gateone/conf.d/20authentication.conf

     // This is Gate One's Terminal application settings file.
    {
        // "*" means "apply to all users" or "default"
        "*": {
           "terminal": { // These settings apply to the "terminal" application
                "commands": {
                    "SSH": {"command": "/usr/lib/python2.7/site-packages/gateone/applications/terminal/plugins/ssh/scripts/ssh_connect.py -S '%SESSION_DIR%/%SESSION%/%SHORT_SOCKET%' --sshfp -a '-oUserKnownHostsFile=\\\"%USERDIR%/%USER%/
    .ssh/known_hosts\\\"'", "description": "Connect to hosts via SSH."}
                },
                "default_command": "SSH",
                "dtach": true,
                "environment_vars": {"TERM": "xterm-256color"},
                "session_logging": true,
                "syslog_session_logging": false,
                "allow": false
            }
        },
        // "*" means "apply to all users" or "default"
        "user.upn=(example@gmail.com|test@gmail.com)": {
           "terminal": { // These settings apply to the "terminal" application
                "commands": {
                    "SSH": {"command": "/usr/lib/python2.7/site-packages/gateone/applications/terminal/plugins/ssh/scripts/ssh_connect.py -S '%SESSION_DIR%/%SESSION%/%SHORT_SOCKET%' --sshfp -a '-oUserKnownHostsFile=\\\"%USERDIR%/%USER%/
    .ssh/known_hosts\\\"'", "description": "Connect to hosts via SSH."}
                },
                "default_command": "SSH",
                "dtach": true,
                "environment_vars": {"TERM": "xterm-256color"},
                "session_logging": true,
                "syslog_session_logging": false,
                "allow": true
            }
        }
     }

> Reverse proxy

Using a reverse proxy to handle SSL and more than just Gate One on the
same IP-address:443 listener is possible, but please note that Gate One
uses WebSocket and that the reverse proxy must be able to handle
WebSockets.

Nginx

Make sure that the port that the Gate One server is running on is
blocked from outside by a firewall (like iptables) or if you are running
Gate One and nginx on the same server make sure it only listens on
localhost. Please see Nginx for more information about installing.

Edit your nginx configuration file similar to this:

Note:Listed below are only the server part of the nginx configuration

    /etc/nginx/nginx.conf

    # HTTPS server
    server {
    	listen       [::]:443;
    	listen       443;
    	server_name  mysslhost;

    	ssl                  on;
    	ssl_certificate      server.crt;
    	ssl_certificate_key  server.key;
    	ssl_session_timeout  5m;
    	ssl_protocols  SSLv2 SSLv3 TLSv1;
    	ssl_ciphers  HIGH:!aNULL:!MD5;
    	ssl_prefer_server_ciphers   on;

        location /gateone/ {
    		#auth_basic "Restricted";					#One extra layer of authentication
    		#auth_basic_user_file /etc/nginx/.htpasswd;
    		proxy_pass_header Server;
    		proxy_set_header Host $http_host;
    		proxy_redirect off;
    		proxy_set_header X-Real-IP $remote_addr;
    		proxy_set_header X-Scheme $scheme;
    		proxy_pass http://localhost:8888;
    		proxy_http_version 1.1;
    		proxy_set_header Upgrade $http_upgrade;
    		proxy_set_header Connection "upgrade";
    	}
    	location /other {
    		rewrite /other/(.*) /$1 break;
    		include /etc/nginx/proxy.conf;
    		proxy_pass http://10.1.1.200:80;
    		break;
    	}
    }

Note:The above configuration requires the following Gate One
configuration

    /etc/gateone/conf.d/10server.conf

    	"disable_ssl": true,
    	"https_redirect": false,
    	"port": 8888,
    	"url_prefix": "/gateone/"

Gate One now lives under the URL: https://your-nginx-server:443/gateone/

Systemd integration
-------------------

Gate One package comes with a systemd service file: gateone.service.

Problems
--------

It has been reported that Gate One fails to open the terminal. This is
because Gate One tries to execute python. If the executeable python
isn't available it could fail, in that case please refer to
Python#Python_2

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gateone&oldid=301928"

Categories:

-   Networking
-   Secure Shell

-   This page was last modified on 24 February 2014, at 20:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
