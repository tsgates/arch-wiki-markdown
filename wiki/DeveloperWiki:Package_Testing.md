DeveloperWiki:Package Testing
=============================

Testing Overview
================

The intended purpose of the testing repo is to provide a staging area
for packages to be placed prior to acceptance into the main
repositories. Package maintainers (and general users) can then access
these testing packages to make sure that there are no problems
integrating the new package. Once a package has been tested and no
errors are found, the package can then be moved to the primary
repositories.

Not all packages need to go through this testing process, however all
packages destined for [core] MUST go to testing first.

Packages that can affect many packages (such as perl or python) should
be tested as well. Testing can also be used for large collections of
packages such as GNOME and KDE.

WARNING: Developers must build their packages in a clean chroot to avoid
providing packages that have linking/run-time dependencies on packages
from the [testing] repository.

For detailed instructions on moving a package between testing and the
main repositories, see DeveloperWiki:HOWTO Be A Packager

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Package_Testing&oldid=100662"

Category:

-   DeveloperWiki
