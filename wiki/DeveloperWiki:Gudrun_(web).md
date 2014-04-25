DeveloperWiki:Gudrun (web)
==========================

Contents
--------

-   1 General configuration guideline
-   2 Users
-   3 Services
-   4 Vhost setup
-   5 Maintainer
    -   5.1 www.archlinux.org
    -   5.2 mailman.archlinux.org
    -   5.3 bugs.archlinux.org
    -   5.4 projects.archlinux.org
    -   5.5 planet.archlinux.org
    -   5.6 repos.archlinux.org
-   6 Emergency evacuation plan

General configuration guideline
-------------------------------

-   Document non-trivial changes within the config files
-   Keep the others informed about changes you made (e.g. send a summary
    to arch-dev, prefix with [gudrun])
-   Use a local git repo for complex configuration files. The following
    are currently being tracked in git:
    -   /etc/httpd/conf
    -   /etc/php
-   Don't forget to commit your changes ;-)

Users
-----

  UID    User         Primary Purpose                                           Cronjobs   Owned/Primary Directories
  ------ ------------ --------------------------------------------------------- ---------- --------------------------------
  33     http         Apache process owner                                      no         /srv/http
  130    svnserve     process owner for svnserve, spawned by xinetd             no         
  131    git-daemon   process owner for git-daemon, spawned by xinetd           no         
  5000   bbs          PHP/FastCGI process owner for the BBS                     no         /srv/http/bbs
  5001   wiki         PHP/FastCGI process owner for the Wiki                    no         /srv/http/wiki
  5002   archweb      Python/FastCGI process owner for the main site            no         /srv/http/archweb_pub
  5003   archwebdev   Python/FastCGI process owner for the dev site             no         /srv/http/archweb_dev
  5004   viewvc       CGI user for ViewVC (repos.archlinux.org)                 no         /srv/http/viewvc
  5005   projects     CGI user for gitweb                                       no         /srv/http/projects
  5006   planet       endpoint user for rsyncing planet contents from gerolde   no         /home/planet, /srv/http/planet
  5007   bugs         PHP/FastCGI process owner for Flyspray                    no         /srv/http/flyspray

Services
--------

-   Apache
-   MySQL
-   memcached
-   mailman
-   svnserve
-   git-daemon
-   (please add more)

Vhost setup
-----------

-   For each vhost the DocumentRoot points to
    /srv/http/vhosts/<vhost.archlinux.org>/
-   Every vhost dir should be tracked by a git repo
-   If this is a public repo (prefered) make sure there are no config
    files with passwords; use .gitignore)
-   Put the public git repo on Gerolde under
    /srv/projects/git/<vhost.archlinux.org>.git
-   You'll push to and pull from that bare repo
-   The repo can be accessed via /srv/git/<vhost.archlinux.org>.git from
    gudrun

Maintainer
----------

-   System (sudo): Aaron, Jan, Dan, Pierre, Thomas

> www.archlinux.org

-   Maintainer: Dan

> mailman.archlinux.org

-   Maintainer: ?

> bugs.archlinux.org

-   Maintainer: Roman
-   Upstream: http://flyspray.org/
-   Dependencies: php, mysql
-   Public git repo:
    https://projects.archlinux.org/vhosts/bugs.archlinux.org.git/

> projects.archlinux.org

-   Maintainer: Ronald

> planet.archlinux.org

-   Maintainer: Andrea

> repos.archlinux.org

-   Maintainer: Ronald ?
-   Public git repo:
    https://projects.archlinux.org/vhosts/repos.archlinux.org.git/

Emergency evacuation plan
-------------------------

1.  Don't Panic!
2.  Look for some cute cat at lolcats and place it on a maintenance page
3.  Blame Allan

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Gudrun_(web)&oldid=238799"

Category:

-   DeveloperWiki:Server Configuration

-   This page was last modified on 6 December 2012, at 00:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
