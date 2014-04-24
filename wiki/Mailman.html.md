Mailman
=======

Mailman is an application for managing electronic mailing lists.
Normally you will use it along a mail server and also a web server too;
for the first you may pick one between Postfix, Exim, Sendmail and Qmail
—if you are unsure about which one to use, Postfix is a very good
choice—; as for the latter, any web server is useful, common options are
Apache, Lighttpd and Nginx. (These three pieces not necessarily shall
run on the same computer.)

Only the Mailman installation will be covered in this article. You can
refer to the correspondent wiki pages to learn how to install the mail
and web servers.

For this guide we are going to suppose that you are using a machine
called "arch" and you want to setup mailing lists for the organizations
"a", "b" and "c", with example domains "a.org", "b.org" and "c.org" that
point to "arch". For each domain,

-   Mailman's web interface will be accessible from
    lists.[organization_name].org and
-   the lists' archives under lists.[organization_name].org/archives.
-   Lists addresses will look like [list_name]@[organization_name].org.

A caveat: you can use a Mailman installation to manage lists for several
domains, but two lists cannot have the same name even though its domains
are different!

Contents
--------

-   1 Mailman installation
-   2 Mailman configuration
    -   2.1 Web Server integration
    -   2.2 MTA integration
    -   2.3 Postfix integration
    -   2.4 Exim integration
-   3 Mail Server Configuration
    -   3.1 Postfix
    -   3.2 Exim
-   4 Web Server Configuration
    -   4.1 Nginx
    -   4.2 Lighttpd
    -   4.3 Apache
-   5 Post configuration
    -   5.1 Site-wide mailing list
    -   5.2 Set up cron
    -   5.3 Start Mailman
    -   5.4 Create a password
-   6 Using Mailman
-   7 Troubleshooting
    -   7.1 Postfix
    -   7.2 UTF-8
-   8 See also

Mailman installation
--------------------

Install mailman from the official repositories.

Mailman configuration
---------------------

The full set of configuration defaults lives in the
/usr/lib/mailman/Mailman/Defaults.py file. However you should never
modify this file! Instead, change the mm_cfg.py file,
/etc/mailman/mm_cfg.py. You only need to add values to mm_cfg.py that
are different than the defaults in Defaults.py. Future Mailman upgrades
are guaranteed never to touch your mm_cfg.py file.

> Web Server integration

    DEFAULT_URL_HOST = 'lists.a.org'

    VIRTUAL_HOSTS.clear()
    add_virtualhost(DEFAULT_URL_HOST, DEFAULT_EMAIL_HOST)
    add_virtualhost('lists.b.org', 'b.org')
    add_virtualhost('lists.c.org', 'c.org')

    POSTFIX_STYLE_VIRTUAL_DOMAINS = ['a.org', 'b.org', 'c.org']

    DEFAULT_URL_PATTERN = 'http://%s/'
    PUBLIC_ARCHIVE_URL = 'http://%(hostname)s/archives/%(listname)s'

For Apache make this change from the above:

    DEFAULT_URL_PATTERN = 'http://%s/lists/'

> MTA integration

The content of /etc/mailman/mm_cfg.py varies depending on the chosen
mail server.

> Postfix integration

    DEFAULT_EMAIL_HOST = 'a.org'
    MTA = 'Postfix'

Once you have edited mm_cfg.py, run

    # /usr/lib/mailman/bin/genaliases

to generate an aliases file that Postfix needs.

> Exim integration

    DEFAULT_EMAIL_HOST = 'a.org'
    MTA = None

Mail Server Configuration
-------------------------

Note: Ensure your domain name server (DNS) setup. For mail delivery on
the internet, your DNS must be correct. An MX record should point to the
mail host. More info about DNS is beyond the scope of this document.

> Postfix

For installing and configuring this mail server, see Postfix. (If you
will be using Postfix just for Mailman, its setup is much simpler:
ignore all the mailbox and database stuff.)

/etc/postfix/main.cf should have the following fields and values:

    myhostname = arch.a.org
    mydomain = a.org
    myorigin = $mydomain
    mydestination = localhost, a.org, b.org, c.org
    mynetworks_style = host

    alias_maps = hash:/etc/postfix/aliases, hash:/var/lib/mailman/data/aliases
    alias_database = $alias_maps
    virtual_alias_maps = hash:/etc/postfix/virtual, hash:/var/lib/mailman/data/virtual-mailman

    recipient_delimiter = +

> Exim

Please dump your configuration here.

Web Server Configuration
------------------------

> Nginx

For installing and configuring this web server, see Nginx. Mailman web
interface relies on CGI processing; this setup uses Nginx along
fcgiwrap, see Nginx#fcgiwrap.

/etc/nginx/conf/nginx.conf should include the following configuration
per domain (example for a.org):

    server {
      server_name lists.a.org;
      root /usr/lib/mailman/cgi-bin;

      location = / {
        rewrite ^ /listinfo permanent;
      }

      location / {
        fastcgi_split_path_info ^(/[^/]*)(.*)$;
        fastcgi_pass unix:/run/fcgiwrap.sock;
        include fastcgi.conf;
        fastcgi_param PATH_INFO         $fastcgi_path_info;
        fastcgi_param PATH_TRANSLATED   $document_root$fastcgi_path_info;
      }

      location /icons {
        alias /usr/lib/mailman/icons;
      }

      location /archives {
        alias /var/lib/mailman/archives/public;
        autoindex on;
      }

    }

Note:Nginx must run with user http and group http or Mailman will
complain. Be sure to define the user directive in
/etc/nginx/conf/nginx.conf as follows (outside the html block):

    user http http;

> Lighttpd

    server.modules = ("mod_rewrite",
                      "mod_cgi")

    url.rewrite = ( "^/$" => "/usr/lib/mailman/cgi-bin/listinfo",
                    "^/usr/lib/mailman/cgi-bin/$" => "/usr/lib/mailman/cgi-bin/listinfo" )

    cgi.assign = (
            "/usr/lib/mailman/cgi-bin/admin" => "",
            "/usr/lib/mailman/cgi-bin/admin/" => "",
            "/usr/lib/mailman/cgi-bin/admindb" => "",
            "/usr/lib/mailman/cgi-bin/admindb/" => "",
            "/usr/lib/mailman/cgi-bin/confirm" => "",
            "/usr/lib/mailman/cgi-bin/confirm/" => "",
            "/usr/lib/mailman/cgi-bin/create" => "",
            "/usr/lib/mailman/cgi-bin/create/" => "",
            "/usr/lib/mailman/cgi-bin/edithtml" => "",
            "/usr/lib/mailman/cgi-bin/edithtml/" => "",
            "/usr/lib/mailman/cgi-bin/listinfo" => "",
            "/usr/lib/mailman/cgi-bin/listinfo/" => "",
            "/usr/lib/mailman/cgi-bin/options" => "",
            "/usr/lib/mailman/cgi-bin/options/" => "",
            "/usr/lib/mailman/cgi-bin/private" => "",
            "/usr/lib/mailman/cgi-bin/private/" => "",
            "/usr/lib/mailman/cgi-bin/rmlist" => "",
            "/usr/lib/mailman/cgi-bin/rmlist/" => "",
            "/usr/lib/mailman/cgi-bin/roster" => "",
            "/usr/lib/mailman/cgi-bin/roster/" => "",
            "/usr/lib/mailman/cgi-bin/subscribe" => "",
            "/usr/lib/mailman/cgi-bin/subscribe/" => ""
            )

    $HTTP["host"] =~ "(^|\.)lists.a.org$" {
            server.document-root            = "/usr/lib/mailman/cgi-bin/"
            server.errorlog                 = "/var/log/lighttpd/lists.a.org_error.log"
            accesslog.filename              = "/var/log/lighttpd/lists.a.org_access.log"
    }

> Apache

Add following line to your /etc/mailman/mm_cfg.py:

IMAGE_LOGOS = '/mailman-icons/'

The example use of of creating lists.a.org implies creating a vhost.
Consider moving the following config into a vhost definition instead of
modifying your global httpd.conf.

Modify your /etc/httpd/conf/httpd.conf with the following snippets
added.

    <IfModule alias_module>
        Alias /mailman-icons/ "/usr/lib/mailman/icons/"
        Alias /archives/ "/var/lib/mailman/archives/public/"
        ScriptAlias /lists/ "/usr/lib/mailman/cgi-bin/"
        ScriptAlias / "/usr/lib/mailman/cgi-bin/listinfo"
    </IfModule>

    <Directory "/usr/lib/mailman/cgi-bin/">
        AllowOverride None
        Options Indexes FollowSymlinks ExecCGI
        Require all granted
    </Directory>

    <Directory "/usr/lib/mailman/icons/">
        Require all granted
    </Directory>

    <Directory "/var/lib/mailman/archives/public/">
        Require all granted
    </Directory>

Restart httpd systemd service.

Post configuration
------------------

> Site-wide mailing list

To create this specific list requested by Mailman for its proper
operation (between other things, it is used for password reminders),
run:

    # /usr/lib/mailman/bin/newlist mailman

This will create a list called "mailman" under the default domain
(mailman@a.org in the example). You do not have to do it for the other
domains (i.e. b.org and c.org).

Later you should also subscribe yourself to the site list.

> Set up cron

Several Mailman features occur on a regular schedule, so you must set up
cron to run the right programs at the right time.

    # cd /usr/lib/mailman/cron/
    # crontab -u mailman crontab.in

> Start Mailman

The Mailman service can be managed with the mailman daemon.

If you run into problems, run it more verbose so it can help you
troubleshoot:

    # /usr/lib/mailman/bin/mailmanctl start

> Create a password

There are two type of passwords that you can create from the command
line. The first is the "general password" which can be used anywhere a
password is required in the system. The site password will get you into
the administration page for any list, and it can be used to log in as
any user.

The second password is a site-wide "list creator" password. You can use
this to delegate the ability to create new mailing lists without
providing all the privileges of the site password. Of course, the owner
of the site password can also create new mailing lists, but the list
creator password is limited to just that special role.

To set the general password, use this command:

    # /usr/lib/mailman/bin/mmsitepass <general-password>

To set the list creator password, this:

    # /usr/lib/mailman/bin/mmsitepass -c <list-creator-password>

It is okay not to set a list creator password, but you probably do want
a general password.

Using Mailman
-------------

To administrate your lists (create and configure lists, manage users,
etcetera) use the web interface; remember that each domain has its own.
For example, the URL of organization "a" would be http://lists.a.org.

Mailman can be also managed by command-line. Example for list creation:

    # newlist --urlhost=lists.b.org --emailhost=b.org list_name

Troubleshooting
---------------

You should check that your installation has all the correct permissions
and group ownerships by running the check_perms script:

    # /usr/lib/mailman/bin/check_perms

. If it reports problems, then you can either fix them manually or use
the same program to fix them (probably the easiest solution):

    # /usr/lib/mailman/bin/check_perms -f

. Repeat previous steps until no more errors are reported!

> Postfix

Make sure that the files in /var/lib/mailman/data/:

-   aliases.db,
-   aliases,
-   virtual-mailman,
-   virtual-mailman.db,

are user and group owned by mailman and that are group writable.

> UTF-8

http://www.divideandconquer.se/2009/08/17/convert-mailman-translation-to-utf-8.

See also
--------

-   GNU Mailman installation manual

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mailman&oldid=303742"

Category:

-   Internet applications

-   This page was last modified on 9 March 2014, at 10:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
