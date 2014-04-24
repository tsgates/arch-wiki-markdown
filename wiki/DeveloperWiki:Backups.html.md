DeveloperWiki:Backups
=====================

This page provides an overview of the Arch Linux services that require
backed up.

Contents
--------

-   1 BBS
-   2 Wiki
-   3 Flyspray
-   4 Mailman
-   5 ArchWeb
-   6 Git
-   7 SVN
    -   7.1 Core/Extra Repos
    -   7.2 Community Repos
-   8 System files
    -   8.1 Gerolde
    -   8.2 Gudrun
    -   8.3 Sigurd
-   9 AUR

BBS
---

-   Server: gudrun
-   Backup commands:

    mysqldump -uXXX -pXXX fluxbb \
    	--no-data \
    	| gzip -c > bbs-schema.sql.gz

    mysqldump -uXXX -pXXX --hex-blob fluxbb \
    	--no-create-info \
    	--single-transaction --quick \
    	--ignore-table=fluxbb.online --ignore-table=fluxbb.search_cache \
    	--ignore-table=fluxbb.search_matches --ignore-table=fluxbb.search_words \
    	| gzip -c > bbs-data.sql.gz

    tar -czf bbs-htdocs.tar.gz /srv/http/vhosts/bbs.archlinux.org/

-   Space needed: 200MB

Wiki
----

-   Server: gudrun
-   Backup commands:

    mysqldump -uXXX -pXXX archwiki \
    	--no-data \
    	| gzip -c > archwiki-schema.sql.gz

    mysqldump -uXXX -pXXX --hex-blob archwiki \
    	--no-create-info \
    	--single-transaction --quick \
    	--ignore-table=archwiki.hitcounter --ignore-table=archwiki.searchindex \
    	--ignore-table=archwiki.l10n_cache --ignore-table=archwiki.objectcache \
    	--ignore-table=archwiki.querycache --ignore-table=archwiki.querycachetwo \
    	--ignore-table=archwiki.querycache_info --ignore-table=archwiki.transcache \
    	| gzip -c > archwiki-data.sql.gz

    tar -czf wiki-htdocs.tar.gz /srv/http/vhosts/wiki.archlinux.org

-   Space needed: 570MB

Flyspray
--------

-   Server: gudrun
-   Backup commands:

    mysqldump -uflyspray -pxxx flyspray \
           --no-data \
           | gzip -c > bugs-schema.sql.gz

    mysqldump -uflyspray -pxxx --hex-blob flyspray \
           --no-create-info \
           --single-transaction --quick \
           --ignore-table=flyspray.flyspray_cache \
           | gzip -c > bugs-data.sql.gz

    tar czf bugs-htdocs.tar.gz /srv/http/vhosts/bugs.archlinux.org/

-   Space needed: 160MB

Mailman
-------

-   Server: gudrun
-   Backup commands:

    tar czf mailman.tar.gz /srv/mailman

-   Space needed: 400MB

ArchWeb
-------

-   Server: gudrun
-   Backup commands:

    mysqldump -uxxx -pxxx archweb \
          --no-data \
          | gzip -c > archweb-schema.sql.gz

    mysqldump -uxxx -pxxx --hex-blob archweb \
          --no-create-info \
          --single-transaction --quick \
          | gzip -c > archweb-data.sql.gz

    tar czf archweb-htdocs.tar.gz /srv/http/archweb/

-   Space needed: 32MB

Git
---

-   Server: gerolde
-   Backup commands:

    repos=(archiso
          netcfg
          pacman
          vhosts/repos.archlinux.org
          vhosts/bbs.archlinux.org
          vhosts/bugs.archlinux.org
          vhosts/wiki.archlinux.org
          mkinitcpio
          dbscripts
          devtools
          abs
          initscripts
          archboot
          archweb
          aur
          server-misc
          mkinitcpio-nfs-utils
          srcpac
          namcap
          kde-build
          aif
          linux-2.6-ARCH
          wpa_actiond)

    for r in ${repos[@]}; do
           git clone -q --mirror /srv/projects/git/${r}.git ${r}.git
           tar czf ${r}.git.tar.gz ${r}.git
           rm -rf ${r}.git
    done

-   Space needed: 120MB

SVN
---

Note: should probably do a full backup monthly followed by incremental
backups daily.

> Core/Extra Repos

-   Server: gerolde
-   Backup commands:

    svnadmin hotcopy /srv/svn-packages/ svn-packages --clean-logs
    svnadmin verify --quiet svn-packages
    tar -czf svn-packages.tar.gz svn-packages
    rm -rf svn-packages

-   Size needed: 4GB (estimated)

> Community Repos

-   Server: sigurd (could be done using rsync copy on gerolde)
-   Backup commands:

    svnadmin hotcopy /srv/svn-packages/ svn-community --clean-logs
    svnadmin verify --quiet svn-community 
    tar -czf svn-packages.tar.gz svn-community
    rm -rf svn-community

-   Size needed: 1.1GB

System files
------------

> Gerolde

-   Server: gerolde
-   Backup commands:

    tar czf system-gerolde.tar.gz /etc /var/log /var/lib/pacman/local

-   Size needed: 170MB

> Gudrun

-   Server: gudrun
-   Backup commands:

    tar -cz --exclude=/var/log/httpd/*access* -f system-gudrun.tar.gz /etc /var/log /var/lib/pacman/local

-   Size needed: 20MB

> Sigurd

-   Server: sigurd
-   Backup commands:

    tar -cz --exclude=/var/log/lighttpd/aur-access* -f system-sigurd.tar.gz /etc /var/log /var/lib/pacman/local

-   Size needed: 11M

AUR
---

For now:

-   Server: sigurd
-   Backup commands:

    time=`date +%Y%m%d-%H%M`
    mysqldump -uaur -pxxx aur | gzip -c > aur-$time.sql.gz
    /srv/http/aur.archlinux.org/aur/scripts/cleanup /srv/http/aur.archlinux.org/aur/web
    tar czf aur-files-$time.tar.gz /srv/http/aur.archlinux.org

I'd like to make a script for dumping the DB which will grab the
DB/username/passwd from the AUR config file, so we do not have those
things spread all over the place.

-   Space needed: 250M (as of 06 Dec 2010)

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Backups&oldid=196010"

Category:

-   Arch development

-   This page was last modified on 23 April 2012, at 10:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
