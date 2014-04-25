Subversion Setup
================

"Apache Subversion is a full-featured version control system originally
designed to be a better CVS. Subversion has since expanded beyond its
original goal of replacing CVS, but its basic model, design, and
interface remain heavily influenced by that goal."

This article deals with setting up an svn-server on your machine. There
are two popular svn-servers, the built in svnserve and the more advanced
option, Apache with svn plugins.

Contents
--------

-   1 Apache Subversion Setup
    -   1.1 Goals
    -   1.2 Apache Installation
    -   1.3 Subversion Installation
    -   1.4 Subversion Configuration
        -   1.4.1 Edit /etc/httpd/conf/httpd.conf
        -   1.4.2 To SSL or not to SSL?
        -   1.4.3 Create /home/svn/.svn-policy-file
        -   1.4.4 Create /home/svn/.svn-auth-file
        -   1.4.5 Create a Repository
        -   1.4.6 Set Permissions
    -   1.5 Create a Project
        -   1.5.1 Directory structure for project
        -   1.5.2 Populate Directory
        -   1.5.3 Import the Project
        -   1.5.4 Test SVN Checkout
-   2 Svnserve setup
    -   2.1 Install the package
    -   2.2 Create a repository
    -   2.3 Set access policies
    -   2.4 Start the server daemon
    -   2.5 svn+ssh
-   3 Subversion backup and restore
-   4 Subversion clients
-   5 See Also

Apache Subversion Setup
-----------------------

> Goals

The goal of this how to is to setup Subversion, with Apache. Why use
Apache for Subversion? Well, quite simply, it provides features that the
standalone svnserve does not have...

-   You get the ability to use https protocol. This is more secure than
    the md5 authentication used by svnserve.
-   You get fine-grained access controls. You can use Apache auth to
    limit permissions by directory. This means you can grant read access
    to everything, but commit access only to trunk for instance, while
    have another group with commit access to tags or branches.
-   You get a free repository viewer. While not very exciting, it does
    work.
-   The Subversion team is working on seamless webdav integration. At
    some point you should be able to use any webdav interface to update
    files in the repository.

> Apache Installation

This howto does not cover installation and initial setup of the Apache
web server. This is covered here.

> Subversion Installation

Besides apache you will only need to install subversion, available from
the official repositories.

> Subversion Configuration

Create a directory for your repositories:

    # mkdir -p /home/svn/repositories

Edit /etc/httpd/conf/httpd.conf

Ensure the following are listed...if not, add them (you will typically
have to add just the last two), they must be in this order:

    LoadModule dav_module           modules/mod_dav.so
    LoadModule dav_fs_module        modules/mod_dav_fs.so
    LoadModule dav_svn_module       modules/mod_dav_svn.so
    LoadModule authz_svn_module     modules/mod_authz_svn.so

To SSL or not to SSL?

SSL for SVN access has a few benefits, for instance it allows you to use
Apache's AuthType Basic, with little fear of someone sniffing passwords.

Generate the certificate by:

    # cd /etc/httpd/conf/
    # openssl req -new -x509 -keyout server.key -out server.crt -days 365 -nodes

Add the following to /etc/httpd/conf/extra/httpd-ssl.conf (or to
/etc/httpd/conf/extra/httpd-vhosts.conf if you are not using ssl).
Include the following inside of a virtual host directive:

    <Location /svn>
       DAV svn
       SVNParentPath /home/svn/repositories
       AuthzSVNAccessFile /home/svn/.svn-policy-file
       AuthName "SVN Repositories"
       AuthType Basic
       AuthUserFile /home/svn/.svn-auth-file
       Require valid-user
    </Location>

To make sure the SSL settings get loaded, uncomment the SSL
configuration line in /etc/httpd/conf/httpd.conf so it looks like this:

    Include /etc/httpd/conf/extra/httpd-ssl.conf

Create /home/svn/.svn-policy-file

    [/]
    * = r

    [REPO_NAME:/]
    USER_NAME = rw

The * in the / section is matched to anonymous users. Any access above
and beyond read only will be prompted for a user/pass by apache AuthType
Basic. The REPO_NAME:/ section inherits permissions from those above, so
anon users have read only permission to it. The last bit grants
read/write permission of the REPO_NAME repository to the user USER_NAME.

Create /home/svn/.svn-auth-file

This is either an htpasswd, or htdigest file. I used htpasswd. Again,
because of SSL, I do not worry as much about password sniffing. htdigest
would provide even more security vs. sniffing, but at this point, I do
not have a need for it. Run the following command

    # htpasswd -cs /home/svn/.svn-auth-file USER_NAME

The above creates the file (-c) and uses SHA-1 for storing the password
(-s). The user USER_NAME is created.

To add additional users, leave off the (-c) flag.

    # htpasswd -s /home/svn/.svn-auth-file OTHER_USER_NAME

Create a Repository

    # svnadmin create /home/svn/repositories/REPO_NAME

Set Permissions

The Apache user needs permissions over the new repository.

    # chown -R http:http /home/svn/repositories/REPO_NAME

> Create a Project

Directory structure for project

Create a temporary directory with the branches tags trunk directory
structure on your development machine.

    $ mkdir -p ~/svn-import/{branches,tags,trunk}

Populate Directory

Copy or move your project source files into the created trunk directory.

    $ cp -R /my/existing/project/* ~/svn-import/trunk

Import the Project

    $ svn import -m "Initial import" ~/svn-import https://yourdomain.net/svn/REPO_NAME/

Test SVN Checkout

    $ svn checkout https://yourdomain.net/svn/REPO_NAME/ /my/svn/working/copy

If everything worked out, you should now have a working, checked out
copy of your freshly created SVN repo.

Enjoy!

Svnserve setup
--------------

> Install the package

Install subversion from the official repositories.

> Create a repository

Create your repository

    mkdir /path/to/repos/
    svnadmin create /path/to/repos/repo1

Your initial repository is empty, if you want to import files into it,
use the following command.

    svn import ~/code/project1 file:///path/to/repos/repo1 --message 'Initial repository layout'

> Set access policies

Edit the file /path/to/repos/repo1/conf/svnserve.conf and uncomment or
add the line under [general]

    password-db = passwd

You might also want to change the default option for anonymous users.

    anon-access = read

Replace "read" with "write" for a repository that anyone can commit to,
or set it to "none" to disable all anonymous access.

Now edit the file /path/to/repos/repo1/conf/passwd

    [users]
    harry = foopassword
    sally = barpassword

The above defines users harry and sally, with passwords foopassword and
barpassword, change it as you like

> Start the server daemon

Before you start the server, edit the config file:

    /etc/conf.d/svnserve

    SVNSERVE_ARGS="--root=/path/to/repos"

The --root=/path/to/repos option set the root of repository tree. If you
have multiple repositories use --root=/path-to/reposparent. Then access
independent repositories by passing in repository name in the URL:
svn://host/repo1. make sure that the user has read/write access to the
repository files)

Optionally add a --listen-port if you want a different port, or other
options.

By default, the service runs as root. If you want to change that, add a
drop-in:

    /etc/systemd/system/svnserve.service.d/50-custom.conf

    [Service]
    User=svn

Now start the svnserve.service daemon.

> svn+ssh

To use svn+ssh://, we have to have a wrapper written for svnserve.

check where the svnserve binary is located:

     # which svnserve
    /usr/local/bin/svnserve

Our wrapper is going to have to fall in PATH prior to this location...

create wrapper:

    # touch /usr/bin/svnserve
    # chmod 755 /usr/bin/svnserve 

now edit it to look like so:

    /usr/bin/svnserve 
    #!/bin/sh
    # wrapper script for svnserve
    umask 007
    /usr/local/bin/svnserve -r /path/to "$@"

-r /path/to is what makes use of the svn co
svn+ssh://server.domain.com:/reponame instead of :/path/to/reponame.

Start svnserve with new wrapper script like so:

    # /usr/bin/svnserve -d  ( start daemon mode )

we can also check the perms for remote users like this:

    $ svn ls svn+ssh://server.domain.com:/reponame
    ++server.domain.com++
    dev/
    qa/
    release/

Subversion backup and restore
-----------------------------

To back up your subversion repositories,do this for each repository you
have.

    $ svnadmin dump /path/to/reponame > /tmp/reponame.dump
    $ scp -rp /tmp/reponame.dump user@server.domain.com:/tmp/

To restore the backup, create the corresponding repositories first:

    svnadmin create /path/to/reponame

Then load svn dump into new repo:

    svnadmin load /path/to/reponame < /tmp/repo1.dump

Setting Permissions:

    chown -R svn:svnusers /path/to/reponame ; 
    chmod -R g+w /path/to/reponame/db/

Ok these repos should be all setup.

Subversion clients
------------------

For a list of subversion clients, see the Wikipedia article.

See Also
--------

-   http://svnbook.red-bean.com/en/1.1/svn-book.html#svn-ch-9-sect-2.2-re-load
-   http://subversion.tigris.org/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Subversion_Setup&oldid=304225"

Categories:

-   Version Control System
-   Web Server

-   This page was last modified on 12 March 2014, at 22:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
