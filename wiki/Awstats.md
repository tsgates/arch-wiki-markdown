Awstats
=======

  

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Article still    
                           refers to the old AUR    
                           package, even though the 
                           package has been moved   
                           to [community] (Discuss) 
  ------------------------ ------------------------ ------------------------

From AWStats - Free log file analyzer for advanced statistics:

AWStats is a free powerful and featureful tool that generates advanced
web, streaming, ftp or mail server statistics, graphically. This log
analyzer works as a CGI or from command line and shows you all possible
information your log contains, in few graphical web pages. It uses a
partial information file to be able to process large log files, often
and quickly. It can analyze log files from all major server tools like
Apache log files (NCSA combined/XLF/ELF log format or common/CLF log
format), WebStar, IIS (W3C log format) and a lot of other web, proxy,
wap, streaming servers, mail servers and some ftp servers.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 mod_perl                                                     |
|     -   1.2 Awstats                                                      |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Enable mod_perl for Apache                                   |
|     -   2.2 Configure Apache to log for AWStats                          |
|     -   2.3 Including AWStats configuration in Apache's configuration    |
|     -   2.4 AWStats Configuration                                        |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

> mod_perl

mod_perl is required to run AWStats with Apache. The mod_perl package is
available in the [extra] repository; install it using pacman.

> Awstats

The awstats package is available in the [community] repository.

    # pacman -S awstats

Configuration
-------------

> Enable mod_perl for Apache

To enable mod_perl in Apache, you should add following line to Apache
configuration (/etc/httpd/conf/httpd.conf).

     LoadModule perl_module modules/mod_perl.so

> Configure Apache to log for AWStats

By default AWStats requires Apache to record access logs as 'combined'.
Unless you want a different behavior, you should set your access log
format as 'combined'. To do so, your Apache configuration should look
like this:

     <VirtualHost *:80>
         ServerAdmin zxc@returnfalse.net
         DocumentRoot "/srv/http/xxx"
         ServerName www.returnfalse.net
         ErrorLog "/var/log/httpd/returnfalse-error_log"
         CustomLog "/var/log/httpd/returnfalse-access_log" combined
     </VirtualHost>

The important line here is:

     CustomLog "/var/log/httpd/returnfalse-access_log" combined

Warning:At this point, if apache has started to log access with
different format, AWStats will complain about this because it cannot
read. So if you are changing Apache's log format now, you probably
should delete old log files not to confuse AWStats.

> Including AWStats configuration in Apache's configuration

If you set the log format, then next step is including AWStats config
file in Apache. The package in the AUR has a default one, and it's
working without any problem. But in case you want to create your own
configuration, default one is this:

     Alias /awstatsclasses "/srv/http/awstats/classes/"
     Alias /awstatscss "/srv/http/awstats/css/"
     Alias /awstatsicons "/srv/http/awstats/icon/"
     ScriptAlias /awstats/ "/srv/http/awstats/cgi-bin/"
     
     <Directory "/srv/http/awstats">
         Options None
         AllowOverride None
         Order allow,deny
         Allow from all
     </Directory>

Include this file (in AUR case, the path is
/etc/httpd/conf/extra/httpd-awstats.conf) to Apache's main
configuration:

     Include conf/extra/httpd-awstats.conf

Now if you have done all steps correctly, you should be able to see
AWStats running on http://localhost/awstats/awstats.pl of course after
restarting Apache.

     # /etc/rc.d/httpd restart

One last thing, which is the actual aim, make AWStats read logs and
convert them to stats.

> AWStats Configuration

The AUR package comes with an hourly cron script to update stats shown
on AWStats. This cron script reads AWStats configuration files in
/etc/awstats and updates the stats for the sites that are defined in
these configuration files. Instead of creating these configuration
files, you can use AWStats' configuration tool. Run:

     perl /usr/share/awstats/tools/awstats_configure.pl

and follow the instructions. If you successfully created config file
there is one thing that you should modify manually. Open the
configuration file created by awstats_configure.pl with your favorite
text editor. Then find the line on which LogFile variable is defined,
and set it as the path that Apache logs accesses (which you set to be
logged as 'combined' format before):

     LogFile=/var/log/httpd/returnfalse-access_log

You are done, now you can run hourly cron script to test the results.

Warning:With these settings anyone will be able to reach AWStats.
Setting a authentication would help keeping these stats private.

See also
--------

-   mod_perl Apache + Perl

Retrieved from
"https://wiki.archlinux.org/index.php?title=Awstats&oldid=222261"

Category:

-   Web Server
