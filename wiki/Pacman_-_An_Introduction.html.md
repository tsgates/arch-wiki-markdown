Pacman - An Introduction
========================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Beginners'  
                           guide#Package            
                           management.              
                           Notes: ...or just link   
                           it from there? (Discuss) 
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Overview
-   2 Installing packages
-   3 Removing packages
-   4 Notes

Overview
--------

Packages in arch repositories are constantly upgraded. When a package is
upgraded, its old version is removed from the repository. There are no
major arch releases. Each package is upgraded as new versions become
available from upstream sources. The repository is always coherent. (The
packages in the repository always have compatible versions.) This type
of repository is called a rolling archive. Before packages are upgraded
in the core, extra and community repositories, they are tested in the
testing repository, to ensure that the distribution is stable.

Pacman saves to disk a list of packages available in a repository. This
list is not automatically updated (refreshed) and is called a repository
database. Updating the list is referred to as synchronizing the
database. The list can be refreshed using pacman -Sy. pacman -Syy
refreshes the list even if it appears to be up to date. (Running
pacman -Syy is a good idea after the repository mirror used by pacman is
changed by the user. Mirrors can be out of sync and the package list
from the old mirror may not correspond to the package list of the new
mirror, even though the dates of the lists may suggest that they do. See
Installing packages for an unlikely but possible problem which could
arise from the use of this command.)

Installing packages
-------------------

pacman -S mypackage installs mypackage and all its dependencies. If
mypackage has been upgraded by the user since the last refresh of the
package list, then the required version of mypackage will not be found
in the repository and pacman -S mypackage fails with a message.
mypackage's dependencies are listed in the Depends On entry of
mypackage's metainformation. (mypackage's metainformation can be listed
with pacman -Si mypackage for packages in the package list and with
pacman -Qi mypackage for installed packages). If mypackage or its
dependencies are already installed, they are upgraded to the version in
the package list. If pacman -S mypackage finds any conflicts (installed
packages which are listed in the Conflicts With entry of the mypackage's
metainformation) then it fails with a message.

Warning:However, pacman -S mypackage does not check for broken
dependencies which may appear from the possible upgrade of mypackage or
one of its dependencies. It is possible that an already installed
package which depends on an upgraded package is unable to function with
the new version of the upgraded package. This can happen if the package
list has been refreshed by the user but all installed packges have not
been upgraded and it could result in a non functional system after
reboot.

The solution is to never run pacman -Sy, which could be followed by
pacman -S mypackage, but to always run pacman -Syu, which upgrades all
packages after the refresh of the package list. This ensures that when
pacman -S mypackage is run all packages installed on the system have
compatible versions.

After pacman -Syu is run there is a small chance that corrections on the
system will be needed in order to have it running as desired. Important
corrections are advertised here: Arch Home. They are very rare (six in
2012). However, it is advisable to run pacman -Syu only when time to
perform corrections is available to the user and not when the system is
relied upon. It is advisable to run pacman -Syu often in order to
minimize the difficulty of adjustment, whenever it arises.

See also Installing packages.

Warning:Read this post and this post about unlikely but possible
problems which could be caused by this command.

Removing packages
-----------------

pacman -R mypackage removes mypackage. If other packages depend on
mypackage, then it fails with a message. To remove them too,
pacman -Rc mypackage should be run.

Warning:The list of packages to be removed should be carefully checked
before they are removed. Otherwise, packages required by the system to
function may be inadvertently removed.

pacman -R mypackage does not remove mypackage's dependencies which have
been installed as dependencies (not explicitly, Install Reason in
mypackage's metainformation) and are not required by other packages. For
that to happen, pacman -Rs mypackage must be run. The complete command
would be pacman -Rcs mypackage.

See also Removing Packages.

Notes
-----

pacman always lists packages to be installed or removed and asks for
permission before it takes action. To inhibit any action, -p should be
used.

pacman operates at a lower level compared to yum and apt. This requires
more attention from the user, but it also empowers him or her with
better control over his or her system.

For those who have used other Linux distributions before, there is a
helpful Pacman Rosetta.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pacman_-_An_Introduction&oldid=302014"

Categories:

-   Classroom
-   Package management

-   This page was last modified on 25 February 2014, at 11:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
