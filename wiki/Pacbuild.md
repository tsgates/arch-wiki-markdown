Pacbuild
========

Pacbuild is a distributed building daemon that can be used to
automatically build or search problems in packages. Submitters send
PKGBUILDs to the main server, which in turn issues instructions to each
build system.

This article covers installing and using Pacbuild.

Warning:The pacbuild scripts are out of date regarding the Arch Linux
build architecture. Strawberry configuration file for instance still
refers to the ancient "current" repository. These scripts must not be
confused with the ones provided by the devtools package which are the
official tools used by developers for building packages in Arch Linux.

Contents
--------

-   1 Installation
-   2 Overview
    -   2.1 apple
    -   2.2 peach
    -   2.3 strawberry
    -   2.4 queuepackage.sh
-   3 Running a build system
    -   3.1 Get an apple 'builder' account
    -   3.2 Configure strawberry
-   4 Submitting builds
    -   4.1 Get an apple 'submitter' account
    -   4.2 Configure queuepackage.sh
    -   4.3 Submit a build
    -   4.4 Checking build status
-   5 Running an apple instance
    -   5.1 Configuring apple
    -   5.2 Adding data
        -   5.2.1 Add an architecture
        -   5.2.2 Add a configuration
    -   5.3 Adding users
-   6 Running peach web interface
-   7 Development to-do
-   8 See also

Installation
------------

Install pacbuild, available in the Official repositories.

Overview
--------

Pacbuild consists of a series of applications named after powerups from
the pacman video game.

> apple

apple is the main server. PKGBUILDs are submitted here, and apple
contacts build systems to hand out orders.

> peach

peach is a simple python cgi script that serves as a web frontend to an
apple instance

> strawberry

strawberry is the build daemon. Machines running strawberry are issued
PKGBUILDs by a remote apple daemon.

> queuepackage.sh

queuepackage.sh is a simple interface to the send build instructions to
a remote apple daemon.

Running a build system
----------------------

If you are interested in offering a system to build on (any architecture
is welcome, but i686 is the most prevalent), contact Jason Chu and he
will supply a username and password.

> Get an apple 'builder' account

A username/password on a given apple instance is needed in order to
accept builds. The password should be sent to the apple maintainer in
md5 encrypted format. For example:

    $ echo -n "<password>" | md5sum

Indicate which architecture the build system is currently running
packages for--this should be i686, x86_64, ppc, etc.

In addition, it is important to note that this account is a builder
account.

> Configure strawberry

Strawberry's config exists in /etc/strawberryConfig.py.

The only settings you should have to change are as follows:

    username='USERNAME'
    password='PASSWORD'
    [...]
    url='http://url.to.appledaemon.com:8888'

Assuming the apple maintainer has setup the requested account, start
strawberry with:

    # /etc/rc.d/strawberry start

The system will now be given build tasks as determined by the remote
apple instance, and it will then proceed to build.

Add strawberry to the DAEMONS variable in /etc/rc.conf to run it
automatically on boot.

Warning: sometimes when strawberry crashes, it does not remove its pid
file. So if you cannot 'restart' strawberry, chances are you need to
remove the pid file manually before restarting strawberry :

    # rm /var/run/strawberry.pid

Submitting builds
-----------------

These are the steps a developer takes to submit builds to the apple
instance. Normal users will not be granted build accounts on official
apple instances, but anyone can run an apple instance.

> Get an apple 'submitter' account

A username/password on a given apple instance is needed in order to
submit builds. The password should be sent to the apple maintainer in
md5 encrypted format. For example:

    $ echo -n "<my password>" | md5sum

Indicate which architecture the build system is submitting packages
for--this should be i686, x86_64, ppc, etc.

In addition, it is important to note that this account is a submitter
account.

> Configure queuepackage.sh

The first time queuepackage.sh is ran, it will generate a configuration
file. Fill out all the data in this file. An example is below:

    ~/.queuepackage.conf

    username="USERNAME"
    password="PASSWORD"
    url="http://url.to.appledaemon.com:8888"
    defaultpriority=1
    defaultconfig="current"
    defaultarch="i686"

The apple URL should be provided by maintainer.

Warning:as this file contains a plain text password, it is worthwhile to
make sure permissions are set as minimal as possible. chmod 600 is
recommended.

> Submit a build

Now go to a directory that contains a PKGBUILD (a directory one would
normally run makepkg in) and run queuepackage.sh. This will submit the
package to apple.

> Checking build status

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The maintainer of the apple instance should have given you the URL to
peach. This is the front end for checking build statuses. It should be
self explanatory, if a bit plain.

Note:to-do: explain a bit more using screenshots.

Running an apple instance
-------------------------

There are many reasons for running an apple server; for porting
purposes, massive rebuilds, custom repos, or even just to rebuild
personal packages across a local network.

> Configuring apple

Apple's main configuration file sits at /etc/appleConfig.py. Chances are
that it does not need to be altered, unless interested in adjusting the
stalePackageTimeout setting. This seems to be used for when a package
stays in the "building" state for too long.

You need to create the apple package directory. If you have not modified
appleConfig.py then:

    $ mkdir /var/lib/pacbuild/apple

If you have changed it then mkdir the directory you specified as
Packagedir.

> Adding data

This part is more difficult. For the moment, initializing apple's DB
requires manual sql entry. To make this easier, here are some basic
steps. Each of these commands is to be issued at the sqlite prompt
produced from:

    # /etc/rc.d/apple start
    # sqlite3 /var/lib/pacbuild/apple.db

Add an architecture

To signify that this apple instance accepts i686 builds:

    insert into arch (name) values ('i686');

For x86_64:

    insert into arch (name) values ('x86_64');

Add a configuration

Configurations are named pacman.conf excerpts containing the
repositories to use when building. This is important when one is
building packages against things in testing. Official apple instances
will use something like the following, for named instances "current" and
"testing".

Current configuration:

    insert into pacman_conf (name, data, arch_id) values ('current',
    '[current]
    Server = ftp://ftp.archlinux.org/current/os/i686

    [extra]
    Server = ftp://ftp.archlinux.org/extra/os/i686', 1);

Testing configuration:

    insert into pacman_conf (name, data, arch_id) values ('testing',
    '[testing]
    Server = ftp://ftp.archlinux.org/testing/os/i686

    [current]
    Server = ftp://ftp.archlinux.org/current/os/i686

    [extra]
    Server = ftp://ftp.archlinux.org/extra/os/i686', 1);

> Adding users

The steps to add a user to an apple instance are straightforward as
well. Take care to note the account type (builder or submitter, see
above).

Enter a package submitter, named testuser:

    insert into user (name, password, email, type)
    values ('testuser', '0cc175b9c0f1b6a831c399e269772661', 'testuser@domain.com', 'submitter');

It is not needed to add a testuser builder because a submitter can also
build. To restrict an account to only being able to build packages:

    insert into user (name, password, email, type)
    values ('testuser', '0cc175b9c0f1b6a831c399e269772661', 'testuser@domain.com', 'builder');

Running peach web interface
---------------------------

We need a HTTP server. Install lighttpd from the official repositories
and libcgi from the AUR.

Configure lighttpd :

    # vim /etc/lighttpd/lighttpd.conf

Make sure these lines are uncommented:

    server.modules = (
    	...
    	"mod_cgi",
    	...
    )
    ...
    # These 2 should exist...
    cgi.assign = ( ".pl"  => "/usr/bin/perl",
    		".cgi" => "/usr/bin/perl",
    # ... but you need to add this one
    		".py"  => "/usr/bin/python")

Then put peach.py in the http directory and start lighthttpd:

    # cp /usr/share/pacbuild/peach.py /srv/http/
    # /etc/rc.d/lighttpd start

We should be good: http://localhost/peach.py

Development to-do
-----------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Left to do before 0.4:

-   unionfs support for image building [Simo]
-   strawberry knows what arch it is building for [Jason]
-   builders are not tied to an arch [Jason]
-   submitters can submit for any arch [Jason]
-   build profiles are arch specific [Jason]
-   paging for peach.py (Could be better, but it is good enough for now)
-   separate builds by architecture (or have them all in one) in
    peach.py

See also
--------

-   http://xentac.net/~jchu/blog/static/pacbuild (does not resolve as of
    11/9/09)
-   http://web.archive.org/web/20071026092245/http://xentac.net/~jchu/blog/static/pacbuild
    (mirror of above blog post)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pacbuild&oldid=301405"

Categories:

-   Arch development
-   Package development

-   This page was last modified on 24 February 2014, at 11:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
