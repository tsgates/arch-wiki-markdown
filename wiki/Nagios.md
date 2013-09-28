Nagios
======

  Summary
  ----------------------------------------------------------------------------------------------------
  A short installation and configuration guide for the service and network monitoring program Nagios

Nagios is an open source host, service and network monitoring program.
It monitors specified hosts and services, alerting you to any developing
issues, errors or improvements. This article describes the installation
and configuration of Nagios.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Features                                                           |
| -   2 Webserver                                                          |
| -   3 Installation                                                       |
| -   4 Nagios Configuration                                               |
| -   5 Apache Configuration                                               |
| -   6 PHP Configuration                                                  |
| -   7 Final Steps                                                        |
| -   8 Plugin check_rdiff                                                 |
|     -   8.1 Download and Install                                         |
|     -   8.2 Enable sudo for user nagios                                  |
|     -   8.3 Integrate check_rdiff plugin into nagios                     |
|                                                                          |
| -   9 Forks                                                              |
| -   10 See also                                                          |
+--------------------------------------------------------------------------+

Features
--------

Some of Nagios' features include:

-   Monitoring of network services (SMTP, POP3, HTTP, NNTP, PING, etc.)
-   Monitoring of host resources (processor load, disk usage, etc.)
-   Simple plugin design that allows users to easily develop their own
    service checks
-   Parallelized service checks
-   Ability to define network host hierarchy using "parent" hosts,
    allowing detection of and distinction between hosts that are down
    and those that are unreachable
-   Contact notifications when service or host problems occur and get
    resolved (via email, pager, or user-defined method)
-   Ability to define event handlers to be run during service or host
    events for proactive problem resolution
-   Automatic log file rotation
-   Support for implementing redundant monitoring hosts
-   Optional web interface for viewing current network status,
    notification and problem history, log file, etc.

The following installation and configuration were tested using nagios
3.2.0-1, Apache web server 2.2.14-2, and PHP5 5.3.1-3 by awayand.

Webserver
---------

According to the official documentation a webserver is not required, but
if you wish to use any of the CGI features then a webserver (apache
preferred), PHP (php-apache) for it and the gd library are required.
This is assumed for this installation

Installation
------------

Install nagios from the AUR.

Users may also want to install nagios-plugins.

Nagios Configuration
--------------------

Copy the sample config files as root:

     cp /etc/nagios/cgi.cfg.sample /etc/nagios/cgi.cfg
     cp /etc/nagios/resource.cfg.sample /etc/nagios/resource.cfg
     cp /etc/nagios/nagios.cfg.sample /etc/nagios/nagios.cfg
     cp /etc/nagios/objects/commands.cfg.sample /etc/nagios/objects/commands.cfg
     cp /etc/nagios/objects/contacts.cfg.sample /etc/nagios/objects/contacts.cfg
     cp /etc/nagios/objects/localhost.cfg.sample /etc/nagios/objects/localhost.cfg
     cp /etc/nagios/objects/templates.cfg.sample /etc/nagios/objects/templates.cfg
     cp /etc/nagios/objects/timeperiods.cfg.sample /etc/nagios/objects/timeperiods.cfg

Make owner/group for all the files you just copied and belong to root
equal to nagios/nagios:

    # chown -R nagios:nagios /etc/nagios

Create htpasswd.users file with a username and password, eg. nagiosadmin
and secretpass

    # htpasswd -c /etc/nagios/htpasswd.users nagiosadmin

If the owner/group of the nagios-plugins you installed are root:root,
the following needs to be done:

    # chown -R nagios:nagios /usr/share/nagios

Once Nagios is configured, it is time to configure the webserver.

Apache Configuration
--------------------

Edit /etc/httpd/conf/httpd.conf, add the following to the end of the
file:

    # Nagios
    Include "conf/extra/nagios.conf"

    # PHP
    Include "conf/extra/php5_module.conf"

Note: As of 3.4.1-4 the example conf is in
etc/webapps/nagios/apache.example.conf

To fix this run:

     cp /etc/webapps/nagios/apache.example.conf /etc/httpd/conf/extra/nagios.conf

Add the apache user http to the group nagios, otherwise you will get the
following error when using nagios:

    Could not open command file '/var/nagios/rw/nagios.cmd' for update!: 

    # usermod -G nagios -a http

PHP Configuration
-----------------

Edit /etc/php/php.ini to include /usr/share/nagios in the open_basedir
directive.

Example configuration:

    open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps:/etc/webapps:/usr/share/nagios

Final Steps
-----------

Start/Restart nagios:

    /etc/rc.d/nagios restart

Start/Restart apache:

    /etc/rc.d/httpd restart

Now you should be able to access nagios through your webbrowser using
the username and password you have created above using htpasswd:

    http://localhost/nagios

Plugin check_rdiff
------------------

A small guide on monitoring rdiff-backups using a plugin called
check_rdiff.

> Download and Install

You will need perl installed.

    cd
    wget http://www.monitoringexchange.org/attachment/download/Check-Plugins/Software/Backup/check_rdiff/check_rdiff
    cp check_rdiff /usr/share/nagios/libexec
    chown nagios:nagios /usr/share/nagios/libexec/check_rdiff
    chmod 755 /usr/share/nagios/libexec/check_rdiff

> Enable sudo for user nagios

Since the perl script check_rdiff needs to run as root, you will have to
enable sudo for the nagios user:

    sudoedit /etc/sudoers

This will open the /etc/sudoers file, then paste the following at the
end of the file (you should know how to use the vi editor, if that is
the one being used by sudoedit):

    nagios  ALL=(root)NOPASSWD:/usr/share/nagios/libexec/check_rdiff

> Integrate check_rdiff plugin into nagios

Edit /etc/nagios/objects/commands.cfg to include the following command
definition:

    # check rdiff-backup
    define command{
    	command_name	check_rdiff
            command_line    sudo $USER1$/check_rdiff -r $ARG1$ -w $ARG2$ -c $ARG3$ -l $ARG4$ -p $ARG5$ 
    	}

Edit /etc/nagios/objects/localhost.cfg to include checking of
rdiff-backup on localhost, for example:

    define service{
            use                             local-service         ; Name of service template to use
            host_name                       localhost
            service_description             rdiff-backup
    	check_command			check_rdiff!/home/x/rdiffbackup!8!10!500!24
            }

Quote from the check_rdiff script content:

The above command checks the repository (-r) which is defined as the
destination of the backup, or more specifically, the directory above the
rdiff-backup-data directory. It will return warning if the backup hasn't
finished by 8am and critical by 10am. It will also return warning if the
TotalDestinationSizeChange is greater than 500Mb. It also get the period
set to 24hrs (-p). This is important as the plugin will throw a critical
if the backup doesn't start in time.

Finally, restart nagios:

    /etc/rc.d/nagios restart

You can now see the rdiff-backup status by clicking on Services on the
left side of the nagios web interface control panel.

Forks
-----

-   Icinga is a Nagios fork. More details about the fork can be found at
    Icinga FAQ: Why a fork?

See also
--------

-   nagios.org Official website
-   Nagios Plugins the home of the official plugins
-   wikipedia.org Wikipedia article
-   NagiosExchange overview of plugins, addons, mailing lists for Nagios
-   NagiosForge a repository for ad

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nagios&oldid=243168"

Category:

-   Networking
