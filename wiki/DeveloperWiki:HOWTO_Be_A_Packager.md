DeveloperWiki:HOWTO Be A Packager
=================================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Follow Package Guidelines                                          |
| -   2 How To Use SVN                                                     |
|     -   2.1 Non-recursive checkout                                       |
|     -   2.2 Checkout a package                                           |
|     -   2.3 Updating all packages                                        |
|     -   2.4 Adding a package                                             |
|     -   2.5 Removing a package                                           |
|     -   2.6 Moving a package between repos                               |
|     -   2.7 "Tagging" releases                                           |
|     -   2.8 Cleaning up your checkout                                    |
|                                                                          |
| -   3 The Process                                                        |
|     -   3.1 Checkout/update your local repository                        |
|     -   3.2 Update the needed package                                    |
|     -   3.3 Traverse to the package's trunk directory                    |
|     -   3.4 Change and build                                             |
|     -   3.5 Run namcap on both PKGBUILD and package                      |
|     -   3.6 Use devtools to upload and commit                            |
|     -   3.7 Update the repository                                        |
|                                                                          |
| -   4 Staging Directories                                                |
| -   5 Miscellaneous Stuff                                                |
|     -   5.1 SVN $Id$ tags                                                |
|     -   5.2 Package checking tools                                       |
|         -   5.2.1 namcap                                                 |
|         -   5.2.2 checkpkg                                               |
|                                                                          |
|     -   5.3 Commit messages                                              |
|     -   5.4 Avoid having to enter your password all the time             |
+--------------------------------------------------------------------------+

Follow Package Guidelines
-------------------------

Package guidelines can be found in the Arch Linux documentation. Please
follow them closely.

Arch Packaging Standards

How To Use SVN
--------------

> Non-recursive checkout

For core, extra, testing and staging repos:

      svn checkout -N svn+ssh://svn-packages@nymeria.archlinux.org/srv/repos/svn-packages/svn svn-packages

For community, community-testing, community-staging, multilib,
multilib-testing, multilib-staging:

      svn checkout -N svn+ssh://svn-community@nymeria.archlinux.org/srv/repos/svn-community/svn svn-community

  
 This creates two directories named "svn-packages" and "svn-community"
which contains nothing. It does, however, know that it is an svn
checkout.

> Checkout a package

You can use `archco` to fetch a dir in the svn-packages repository or
`communityco` to fetch a dir from the svn-community repo. You don't need
to be in an svn checkout to do that.

Otherwise you have to cd the svn checkout and exec:

      svn update package-name

This will pull the package you requested into your checkout. From now
on, any time you `svn update` at the top level, this will be updated as
well.

> Updating all packages

      cd svn-packages
      svn update

> Adding a package

      cd svn-packages
      mkdir -p new-package/{repos,trunk}
      $EDITOR new-package/trunk/PKGBUILD
      svn add new-package
      svn propset svn:keywords "Id" new-package/trunk/PKGBUILD
      svn commit

> Removing a package

      ssh nymeria.archlinux.org
      /packages/db-remove repo-name arch packagename
      i.e. /packages/db-remove core i686 openssh 

And if you want to really kill the package, you will need to

    svn rm

the entire package directory after the above steps and commit the
deletion.

> Moving a package between repos

      ssh nymeria.archlinux.org
      /packages/db-move fromrepo torepo packagename
      i.e. /packages/db-move testing core openssh

Alternatively, the move from testing is so common we have helper
scripts:

      /packages/testing2x openssh bzip2 coreutils
      /packages/testing2x64 openssh bzip2 coreutils

These scripts only work if the packages on the commandline are either in
core or extra. If a package is only in testing, you have to use
testing2core, testing2core64, testing2extra or testing2extra64.

> "Tagging" releases

Fetch the package dir using `archco` or `communityco` or from an svn
checkout. Then

      cd package-name/trunk
      archrelease extra-i686

This makes an svn copy of the trunk entries in a directory named
"extra-i686" indicating that this package is in the extra repository for
the i686 architecture. This will be done automatically when using tools
such as extrapkg (see below)

> Cleaning up your checkout

Since you are now maintaining a non-recursive checkout, you may want to
get rid of packages that you are no longer tracking:

      svn update package1 package2 --set-depth exclude

Or if you want an empty toplevel again:

      svn update --set-depth empty

The Process
-----------

> Checkout/update your local repository

      cd svn-packages
      svn update

> Update the needed package

      svn update some-package

> Traverse to the package's trunk directory

      cd some-package/trunk/

> Change and build

      $EDITOR PKGBUILD
      makepkg

It is highly recommended to build your package using a clean chroot

> Run namcap on both PKGBUILD and package

      namcap PKGBUILD
      namcap some-package-1.0-1-i686.pkg.tar.gz

> Use devtools to upload and commit

This is repo dependent. For 'extra', you use 'extrapkg'. 'testingpkg'
for 'testing', etc

      extrapkg "A commit message"

> Update the repository

Use 'db-update'. It will find new packages for any repository and it
manages both i686 and x86_64 architectures at once, if present. For
example:

      ssh nymeria.archlinux.org
      /packages/db-update

Staging Directories
-------------------

Staging directories are needed on nymeria.archlinux.org for uploading of
packages. The following structure is NOT automatically created. You must
do it yourself:

       ~/staging/
        |-- core/
        |-- extra/
        `-- testing/

These directories are searched by the db scripts to find new packages
and those slated for removal.

Miscellaneous Stuff
-------------------

> SVN $Id$ tags

$Id$ tags are a nice helper for PKGBUILDs and should be added to the top
of all PKGBUILDs in a comment. However, svn needs an additional push to
know that it should modify this line on checkout.

      svn propset svn:keywords "Id" my-package/trunk/PKGBUILD

> Package checking tools

namcap

Run on both your PKGBUILD and package to check for common packaging
problems.

checkpkg

Run (as root) in the directory with your freshly built package to get a
file list diff compared with the package version currently in the repos.

> Commit messages

Please try to write concise commit messages. If the package is simply an
upstream change, that is fine, but if anything more complex changes,
please inform us by writing an appropriate commit message.

> Avoid having to enter your password all the time

When working with extrapkg and the other devtools, quite a few ssh
connections are established, even when using ssh keys and the ssh agent.
You can work around that.

Add this to your $HOME/.ssh/config:

    ControlPath /home/<your username>/.ssh/master-%h-%p-%r

    Host nymeria.archlinux.org

Now, before you start working, open a ssh session with

    ssh -M nymeria.archlinux.org

Enter your password and leave that session open until you are finished.
All ssh sessions (including scp and svn+ssh) will now be tunneled
through this connection.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:HOWTO_Be_A_Packager&oldid=244984"

Category:

-   DeveloperWiki
