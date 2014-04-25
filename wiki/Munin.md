Munin
=====

Munin the monitoring tool surveys all your computers and remembers what
it saw. It presents all the information in graphs through a web
interface. Its emphasis is on plug and play capabilities. After
completing a installation a high number of monitoring plugins will be
playing with no more effort.

Using Munin you can easily monitor the performance of your computers,
networks, SANs, applications, weather measurements and whatever comes to
mind. It makes it easy to determine "what's different today" when a
performance problem crops up. It makes it easy to see how you're doing
capacity-wise on any resources.

Munin uses the excellent RRDTool (written by Tobi Oetiker) and the
framework is written in Perl, while plugins may be written in any
language. Munin has a master/node architecture in which the master
connects to all the nodes at regular intervals and asks them for data.
It then stores the data in RRD files, and (if needed) updates the
graphs. One of the main goals has been ease of creating new plugins
(graphs). [1]

Simply put, Munin allows you to make graphs about system statistics. You
can check out University of Oslo's Munin install to see some examples of
what it can do.

Contents
--------

-   1 Installation
    -   1.1 munin and munin-node
    -   1.2 Optional web server
    -   1.3 IPv6
-   2 Configuration
    -   2.1 Daemon
    -   2.2 Plugins
    -   2.3 Directories
    -   2.4 Customization
    -   2.5 Cron
    -   2.6 Permissions
-   3 Testing
-   4 Plugins
    -   4.1 Adding
    -   4.2 Removing
    -   4.3 Debugging

Installation
------------

Munin relies on a client-server model. The client is munin-node, and the
server is munin (referred as to "munin-master" in the documentation).

You will only need to install munin-master on a single machine, but
munin-node will need to be installed on all machines you wish to
monitor. This article will focus on a single-machine installation.
Further documentation may be found on the Munin documentation wiki.

> munin and munin-node

There is currently a munin (munin-master) and a munin-node package in
extra.

    # pacman -S munin munin-node

> Optional web server

The following guide sets up Munin to generate static HTML and graph
images and write them in a directory of your choosing. You can view
these generated files locally with any web browser. If you want to view
the generated files from a remote machine, then you want to install and
configure one of the following web servers:

-   Apache
-   Lighttpd
-   NginX

Or one of the other servers found in the web server category.

> IPv6

For IPv6 support on munin-node (using host :::1 in
/etc/munin/munin-node.conf) you need to install the following packages:

-   perl-socket6
-   perl-io-socket-inet6

  

Configuration
-------------

> Daemon

Start the daemon with

    systemctl start munin-node

Enable the daemon with

    systemctl enable munin-node

See Daemons for more information.

> Plugins

Run munin-node-configure with the --suggest option to have Munin suggest
plugins that it thinks will work on your installation:

    # munin-node-configure --suggest

If there is a suggestion for a plugin you want to use, follow that
suggestion and run the command again. When you are satisfied with the
plugins suggested by munin-node-configure, run it with the --shell
option to have the plugins configured:

    # munin-node-configure --shell | sh

> Directories

Create a directory where the munin-master will write the generated HTML
and graph images. The munin user must have write permission to this
directory.

/srv/http/munin is used below, so the generated output can be viewed at
http://localhost/munin/ provided that a web server is installed and
running.

    # mkdir /srv/http/munin
    # chown munin:munin /srv/http/munin

Uncomment the htmldir entry in /etc/munin/munin.conf and change it to
the directory created in the previous step:

    htmldir /srv/http/munin

> Customization

Before running munin, you might want to setup the hostname of your
system. In /etc/munin/munin.conf, the default hostname is "myhostname".
This can be altered to any preferred host name. The hostname will be
used to group and name the .rrd files in /var/lib/munin and further,
used to group the html files and graphs in your selected munin-master
directory.

> Cron

Run the following to have munin collect data and update the generated
HTML and graph images every 5 minutes:

    # crontab /etc/munin/munin-cron-entry -u munin

  
 Configure your email server so that you can receive mails to "munin"
user. If you use postfix, add this line in /etc/postfix/aliases

     munin:    root

And run the command

     newaliases

> Permissions

Because many plugins read log files, it is useful to add "munin" user
into "log" group:

    # usermod -aG log munin

Testing
-------

Munin should be able to run now. To make sure everything works, start
munin-node:

    # systemctl start munin-node

Then run munin-cron manually to generate the HTML and graph images:

    # su - munin --shell=/bin/bash
    $ munin-cron

And finally test the interface by pointing your browser to the output
directory or http://localhost/munin/.

Note:It might take a while for the graphs to have data, so be patient.
Wait for about 30 minutes to an hour.

Plugins
-------

There are many Munin plugins out there just waiting to be installed. The
MuninExchange is an excellent place to start looking, and if you cannot
find a plugin that does what you want it is easy to write your own. Have
a look at HowToWritePlugins at the Munin documentation wiki to learn
how.

> Adding

Basically all plugins are added in the following manner (although there
are exceptions, review each plugin!):

Download a plugin, then copy or move it to /usr/lib/munin/plugins

    # cp <plugin> /usr/lib/munin/plugins/

Then link the plugin to /etc/munin/plugins:

    # ln -s /usr/lib/munin/plugins/<plugin> /etc/munin/plugins/<plugin>

Note:Some plugins - known as wildcard plugins - can be used with
multiple devices at once by linking them with different names. These
plugins end with an underscore and are linked as <plugin>_<device> to be
used on <device>. See the if_ plugin for an example.

Now test your plugin. You do not need to use the full path to the
plugin, munin-run should be able to figure it out:

    # munin-run <plugin>

And restart munin-node:

    # systemctl restart munin-node

Finally, refresh the web page.

> Removing

If you want to remove a plugin, simply delete the linked file in
/etc/munin/plugins - there is no need to remove the plugin from
/usr/lib/munin/plugins.

    # rm /etc/munin/plugins/<plugin>

> Debugging

If you come across a plugin that is not working as expected (for example
giving you no output at all) it might be interesting to run it directly.
Fortunately there is a way to do this. Following the instructions until
here, you will for exmpale notice, that the plugin "apache_accesses"
gives no output at all, when enabled. In order to run the plugin
directly just run

    # munin-run apache_accesses

The error "LWP::UserAgent not found at
/etc/munin/plugins/apache_accesses line 86." indicates that a perl
function could not be found. To resolve the problem simply install the
missing library in this case "perl-libwww".

Retrieved from
"https://wiki.archlinux.org/index.php?title=Munin&oldid=271776"

Category:

-   Status monitoring and notification

-   This page was last modified on 20 August 2013, at 00:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
