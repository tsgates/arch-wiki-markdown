Smokeping
=========

Contents
--------

-   1 Introduction
-   2 Installation
    -   2.1 Prerequisites
        -   2.1.1 Optional Prerequisites
    -   2.2 Installing Packages
    -   2.3 Downloading Smokeping
-   3 Configuration
    -   3.1 Editing Scripts
    -   3.2 Editing the config file
-   4 Setup
-   5 Testing
-   6 Deployment
    -   6.1 Proxied
        -   6.1.1 nginx
    -   6.2 FastCGI
-   7 Advanced Configuration
    -   7.1 Idiosyncracies
-   8 Bugs
    -   8.1 Tr.cgi
    -   8.2 Cropper
    -   8.3 CPU Crunch

Introduction
------------

Smokeping allows you to probe a list of servers, store that data using
RRDtool, and generate statistical charts based on RRDtool's output.
Smokeping consists of two parts. A daemon runs in the background pinging
and collecting data at set intervals. A web interface displays that data
in the form of graphs.

Smokeping Website
    http://oss.oetiker.ch/smokeping/index.en.html

This guide only sets up the smokeping daemon and CGI script. We do not
set up advanced features like the AJAX traceroute or the JavaScript
graph cropper. Why? Because these did not work properly for me and I do
not need these features enough to figure out why.

Installation
------------

The smokeping CGI script runs under SpeedyCGI. SpeedyCGI is a modified
version of perl that allows scripts to be run persistently. Without
persistence, the smokeping CGI script must load all modules and data on
every webpage view. This would be too slow.

SpeedyCGI has not been updated since 2003 (as of Nov 1, 2010) and no
longer compiles with perl, which has since gone through API changes.
Instead of using SpeedyCGI for persistence, we will convert the
smokeping.cgi script into a PSGI webapp which can then be made
persistent a variety of ways. More on that later.

We will just be installing the smokeping chart interface as a webapp.
The traceroute feature will not be included.

> Prerequisites

perl
    The smokeping daemon and cgi script are perl scripts. We will use
    the system-wide perl for this example. You might also consider a
    perl for only the smokeping app. You may also compile an old version
    of perl (try 5.8.x) if you choose to use SpeedyCGI.
fping
    Smokeping has many many different ways to probe a host. The simplest
    and default method is a simple ping probe which requires the fping
    program.
rrdtool
    RRDTool is created by the same author as smokeping. RRDTool collects
    and displays statistical information in a disk-efficient manner.
perl-plack
    Plack is perl's version of Ruby's rack. Plack is the implementation
    of the PSGI specification. PSGI is like Python's WSGI. By using
    Plack/PSGI we can run the smokeping.cgi as a webapp on any number of
    backends (proxied, FreeCGI, mod_perl, CGI, etc).
perl-cgi-emulate-psgi
    The CGI::Emulate::PSGI fools the smokeping.cgi script into thinking
    it is running in a CGI environment, when instead it is executing
    inside a PSGI app.
ttf-dejavu
    Without this font the graphs are unreadable and the letters are
    replaced with blocks.

Optional Prerequisites

If you want to use other probes such as the DNS or http probe you will
need other packages shown below. We will only be setting up the basic
ping probe in this example.

  Probe           Package Needed
  --------------- --------------------------------
  Curl            curl
  DNS             dnsutils (for the dig utility)
  EchoPing        echoping (AUR)
  SSH             openssh
  TelnetIOSPing   perl-net-telnet
  AnotherDNS      perl-net-dns
  LDAP            perl-ldap
  LDAP (tls)      perl-io-socket-ssl
  Authen          perl-authen-radius

In our example we use a simple Plack-based webserver. You may wish to
install a full-fledged webserver. If you wish to use the master/slave
functionality of Smokeping you will need the perl-libwww package. If you
want to probe IPv6 servers you will need the perl-socket6 package from
the AUR. I will not be covering any of these features and will stick to
the bare minimum.

> Installing Packages

First install the packages that are available from the official
repositories:

    sudo pacman -S rrdtool fping perl ttf-dejavu

The perl-cgi-emulate-psgi and perl-plack prerequisites can be installed
from the AUR.

> Downloading Smokeping

We are going to download Smokeping and extract it in our home directory
so we can edit it.

    cd
    curl -O http://oss.oetiker.ch/smokeping/pub/smokeping-2.4.2.tar.gz
    tar zxf smokeping-2.4.2.tar.gz

Configuration
-------------

Smokeping requires you to edit a few files. The unedited files end with
the .dist extension. Rename the .dist files to names without the suffix.
The find command does this and prints out each file that is being
renamed and needs editing:

    cd smokeping-2.4.2
    find . -name '*.dist' -print -execdir sh -c 'mv {} $(basename {} .dist)' \;

> Editing Scripts

The files inside the bin/ directory I call scripts. The script files
contain use lib statements. These add a path to search for when loading
perl modules (similar to $PATH). We do not need these. We will add to
the module search path at runtime.

You must set the proper config file path. The config file is by default
set to etc/config.dist. We will remove the .dist suffix. I prefer
relative directories so that I can move the smokeping directory to
anywhere I please without re-editing these files. The downside to using
relative paths is you must be sure to start the daemon and webapp in the
proper directory.

Run this sed command to edit these scripts:

    sed -i -e '/^use lib/d' -e 's/config.dist/config/' bin/*

> Editing the config file

Next edit the etc/config file. The first section of the etc/config file
is the easiest to edit. Personalize the top of the config file to match
your information. Replace the absolute paths to relative paths. The
General section should look similar to my example below. The comments
describe each field.

    config

    *** General ***

    owner     = Your Name Here       # your name
    contact   = your.email@host.bla  # your email
    mailhost  = your.smtp.server.bla # your mail server
    sendmail  = /usr/sbin/sendmail   # where the sendmail program is
    imgcache  = public/images # filesystem directory where we store files
    imgurl    = images        # URL directory to find them
    datadir   = var/pingdata  # where we share data between the daemon and webapp
    piddir    = var           # filesystem directory to store PID file
    cgiurl    = http://yourdomain/smokeping # exterior URL
    smokemail = etc/smokemail # new relative dir, remove .dist
    tmail     = etc/tmail     # ditto
    syslogfacility = local0
    # each probe is now run in its own process
    # disable this to revert to the old behaviour
    # concurrentprobes = no

Note:If you do not have the sendmail program installed (ie from postfix
or sendmail) then use something else instead like /bin/false. The file
you specify must exist or smokeping will error out.

We are setting up the bare minimum and are not using alerts, so comment
out the *** Alerts *** section. Scroll down to the *** Presentation ***
section and replace the template path with a relative path:

    config

    *** Presentation ***

    template = etc/basepage.html

The *** Probes *** section specify which probes are active. By default
only the FPing probe is set. Leave this for now. Comment out or delete
the *** Slaves *** section, you do not have any slaves... right? Scroll
down to the *** Targets *** section. This is where you specify which
hosts to ping. Replace it with a host you would like to collect
statistics on, like so:

    config

    *** Targets ***

    probe = FPing

    menu = Top
    title = Network Latency Grapher
    remark = Hello World!

    + ArchLinux
    menu  = ArchLinux
    title = ArchLinux Hosts
    host  = /ArchLinux/ArchLinux_News /ArchLinux/ArchLinux_BBS /ArchLinux/ArchLinux_Wiki

    ++ ArchLinux_News
    menu  = News
    title = ArchLinux Main Site
    host  = archlinux.org

    ++ ArchLinux_BBS
    menu  = BBS
    title = ArchLinux BBS
    host  = bbs.archlinux.org

    ++ ArchLinux_Wiki
    menu = Wiki
    title = ArchLinux Wiki
    host  = wiki.archlinux.org 

Each + character defines a section in our hierarchy. Spaces are not
allowed in the section names. You can define host as either a real host
name or the path to another section to generate a multiple host chart.
These hosts are all on the same machine so the statistics are not very
interesting.

You can learn more about the Smokeping config file with the examples at
http://oss.oetiker.ch/smokeping/doc/smokeping_examples.en.html

For now let us just try to get things started.

Setup
-----

Create the directories we specified or else smokeping will error out.

     mkdir -p var/pingdata public/images

Now we create the PSGI app that will wrap the CGI script. If you open
the htdocs/smokeping.cgi file you will see it is really simple and just
calls the Smokeping module's cgi subroutine. We are going to fool the
CGI code into thinking that it is using the CGI environment. Here is
where Plack comes into play.

Inside the smokeping dir, create a new file called app.psgi. Copy/paste
the following into the file:

    app.psgi

    # -*- cperl -*-

    use Plack::App::Directory;
    use Plack::Builder;
    use CGI::Emulate::PSGI;

    use CGI qw();

    use warnings;
    use strict;

    use Smokeping 2.004002;

    my $smokeping = sub {
        CGI::initialize_globals();
        
        Smokeping::cgi("etc/config");
    };

    my $fileapp = Plack::App::Directory->new
        ({ 'root' => 'public' })->to_app;

    $smokeping  = CGI::Emulate::PSGI->handler( $smokeping );

    builder {
        mount "/"           => $smokeping;
        mount "/smokeping/" => $fileapp;
    };

This file does the same thing as smokeping.cgi. We are in effect fooling
smokeping to think it is still run with CGI. The difference is we wrap
the CGI app into a PSGI app. This allows it to run persistently among
other things. The concept of SpeedyCGI is similar. We also add file
serving for the static files like images. The default, empty, or root
path is set to the smokeping app itself and anything under the
smokeping/ URL component serves a file from the public/ directory. The
only files we serve are the graph images files.

Testing
-------

Now we are going to test our webapp. Type the following commands to
start the smokeping daemon and a webserver:

    perl -Ilib bin/smokeping
    plackup -Ilib

Here the -I switch adds the lib directory to perl's module search path.
This does the same thing as use lib;

Our commands start the smokeping daemon and a simple server for the
webapp which listens on port 5000 by default. Go to the webpage
(yourdomain.com:5000) and look at the pretty graph. Keep in mind the
default setup pings every 5 minutes so you may have to wait for some
data to appear. If something goes wrong, fix it before continuing.

If it works and that is all you wanted feel free to stop here. You can
run your webapp with a better server by installing perl-starman from the
AUR. Starman is a fast production quality pre-forking server. I usually
set it to a very low number of worker processes though because I do not
receive a lot of traffic.

You should set the plack environment to deployment if you do not
want/need debugging information like stack traces printed. By default
Plack runs in the development environment. For example:

    starman -Ilib -p 80 -E deployment --workers 2 &

The -I switch does the same thing as PERL5LIB. -p listens on port 80,
the default http port. -E sets the plack environment to deployment which
disables bug checking.

Deployment
----------

Note:This section is incomplete and needs a walkthrough written for it

Now you should probably setup a user for smokeping and create a
/etc/rc.d/ daemon startup script to start the smokeping daemon as well
as the FastCGI webapp daemon. You could also create a directory under
/srv/http for smokeping. When you copy the files, you only need the
following files and directories and you can leave the rest.

-   app.psgi
-   lib/
-   etc/
-   var/
-   public/

Copy those files and directories into the destination. The rest is junk!
Make sure to cd into the destination before starting the smokeping
daemon and FastCGI webapp.

You should also setup the webserver to serve the files and remove file
serving code from from app.psgi so it looks like this:

    app.psgi

    # -*- cperl -*-                                                                  
        
    use CGI::Emulate::PSGI;
    use CGI qw();
    use warnings;
    use strict;

    use Smokeping 2.004002;

    my $smokeping = sub {
        CGI::initialize_globals();
        Smokeping::cgi("etc/config");
    };

    CGI::Emulate::PSGI->handler( $smokeping );

Much simpler!

> Proxied

You can continue to use a plack web server. If you do please upgrade
from plackup which is designed for testing purposes. The main web server
will act as a proxy and forward requests to the plack server.

nginx

I use nginx so here is a quick walkthrough. I like this method because
it is quick and easy. Make sure that the port that the Plack server is
running on is blocked from outside by a proxy (like iptables). Edit your
nginx configuration file similar to this:

    nginx.conf

            location /smokeping {
                error_log    /srv/http/smokeping/var/error.log  info;
                access_log   /srv/http/smokeping/var/access.log combined;
                
                proxy_buffers     8 16k;
                proxy_buffer_size 32k;
                proxy_pass        http://localhost:9003/;
            }

            location /smokeping/ {
                error_log    /srv/http/smokeping/var/error.log  info;
                access_log   /srv/http/smokeping/var/access.log combined;
                
                alias /srv/http/smokeping/public/;
            }

Nginx will serve our image files for us and will pass any request for
/smokeping to the proxied webapp server. When you start the proxied
server, make sure it has the port set:

    cd /srv/http/smokeping
    starman -Ilib -p 9003 -E deployment --workers 2 &

Feel free to use any port you like instead of 9003.

> FastCGI

You can easily set up the webapp to use FastCGI. Just use plackup to
start the FastCGI server process:

    plackup -s FCGI --listen /var/run/smokeping.sock --daemonize --nproc 4

(You will need the perl FCGI module installed via the 'perl-fcgi'
package)

Now just setup your web server (i.e. apache, lighttpd, nginx) to route
traffic to your FastCGI "server" by pointing to the
/var/run/smokeping.sock socket.

Advanced Configuration
----------------------

Note:This section is incomplete.

There are many idiosyncracies to the smokeping configuration file. There
is also alot of power. You can setup many different types of probes. You
can setup slave smokeping servers that can send their statistics and
show you probes from other servers. You can also create your custom
probes in perl. I have not gotten that far along and the example
configuration file above should be a good start.

> Idiosyncracies

I have found some things to avoid in config files through trial and
error. Make sure you do not use spaces or periods in section names. You
should probably avoid forward slashes too. Sections are defined with +s.

This is probably because the RRD files are stored under the data
directory with the same exact names as the sections.

Bugs
----

There are a few bugs I have noticed.

> Tr.cgi

The traceroute CGI script simply does not work. This could be a mistake
on my part or a bug in the code. I do not need it or like it so I simply
do not use it.

> Cropper

I had noticed that if I try to use the javascript cropper it does not
work very well. Click on a graph long enough and it will pop up. If I
try to crop a graph to zoom in, the server crashes. Hard.

I decided to remove the cropper until I could track down the bug. To do
this remove the <script> tags inside the etc/basepage.html file. You may
have noticed that I created a new file serving dir called public/. This
avoids all the old files I do not use that are needed for the cropper
and the traceroute script. This is not the most ideal fix and the server
is likely still vulnerable to crashes but at least they will not happen
on accident.

> CPU Crunch

Every once and awhile I noticed that the CPU usage goes crazy for the
web interface. When I use Twiggy the CPU usage goes up to 100% and stays
there, locking up the server. I have decided instead to use the Starman
server. That way if one process goes to crap Starman will spawn another
one. This could be caused by a race condition in the Smokeping module. I
have not really tried to track it down.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Smokeping&oldid=304887"

Category:

-   Networking

-   This page was last modified on 16 March 2014, at 08:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
