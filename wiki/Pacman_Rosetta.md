Pacman Rosetta
==============

This page pulls heavily from openSUSE's Software Management Command Line
Comparison. It has been simplified and has added Arch to the comparison,
as well as modified the order in which each distribution exists for the
benefit of Arch users.

Users from other Linux distributions can benefit from pacman by using a
simple wrapper: pacapt. The script could also be intended for Arch users
having to temporarily deal with another distribution.

pacapt is a pacman shell script implementation for other linux
distribution.

Note:Some of the tools described here are specific to a certain version
of pacman. The -Qk option is new in pacman 4.1

Note:The command pkgfile can be found in the pkgfile package.

Action

Arch

Red Hat/Fedora

Debian/Ubuntu

(Old) SUSE

openSUSE

Gentoo

Install a package(s) by name

pacman -S

yum install

apt-get install

rug install

zypper install zypper in

emerge [-a]

Remove a package(s) by name

pacman -Rc

yum remove/erase

apt-get remove

rug remove/erase

zypper remove zypper rm

emerge -C

Search for package(s) by searching the expression in name, description,
short description. What exact fields are being searched by default
varies in each tool. Mostly options bring tools on par.

pacman -Ss

yum search

apt-cache search

rug search

zypper search zypper se [-s]

emerge -S

Upgrade Packages - Install packages which have an older version already
installed

pacman -Syu

yum update

apt-get upgrade

rug update

zypper update zypper up

emerge -u world

Upgrade Packages - Another form of the update command, which can perform
more complex updates -- like distribution upgrades. When the usual
update command will omit package updates, which include changes in
dependencies, this command can perform those updates.

pacman -Syu

yum distro-sync

apt-get dist-upgrade

zypper dup

emerge -uDN world

Reinstall given Package - Will reinstall the given package without
dependency hassle.

pacman -S

yum reinstall

apt-get install --reinstall

zypper install --force

emerge [-a]

Installs local package file, e.g. app.rpm and uses the installation
sources to resolve dependencies

pacman -U

yum localinstall

dpkg -i && apt-get install -f

zypper in /path/to/local.rpm

emerge

Updates package(s) with local packages and uses the installation sources
to resolve dependencies

pacman -U

yum localupdate

n/a

emerge

Use some magic to fix broken dependencies in a system

pacman dep level - testdb, shared lib level - findbrokenpkgs or lddd

package-cleanup --problems

apt-get --fix-broken

rug* solvedeps

zypper verify

revdep-rebuild

Only downloads the given package(s) without unpacking or installing them

pacman -Sw

yumdownloader (found in yum-utils package)

apt-get --download-only

zypper --download-only

emerge --fetchonly

Remove dependencies that are no longer needed, because e.g. the package
which needed the dependencies was removed.

pacman -Qdtq | pacman -Rs -

package-cleanup --leaves

apt-get autoremove

n/a

emerge --depclean

Downloads the corresponding source package(s) to the given package
name(s)

Use ABS && makepkg -o

yumdownloader --source

apt-get source

zypper source-install

emerge --fetchonly

Remove packages no longer included in any repositories.

package-cleanup --orphans

Install/Remove packages to satisfy build-dependencies. Uses information
in the source package.

automatic

yum-builddep

apt-get build-dep

zypper si -d

emerge -o

Add a package lock rule to keep its current state from being changed

${EDITOR} /etc/pacman.conf  
modify IgnorePkg array

yum.conf <--”exclude” option (add/amend)

echo "$PKGNAME hold" | dpkg --set-selections

rug* lock-add

Put package name in /etc/zypp/locks

/etc/portage/package.mask

Delete a package lock rule

remove package from IgnorePkg line in /etc/pacman.conf

yum.conf <--”exclude” option (remove/amend)

echo "$PKGNAME install" | dpkg --set-selections

rug* lock-delete

Remove package name from /etc/zypp/locks

/etc/portage/package.mask (or package.unmask)

Show a listing of all lock rules

cat /etc/pacman.conf

yum.conf (research needed)

/etc/apt/preferences

rug* lock-list

View /etc/zypp/locks

cat /etc/portage/package.mask

Add a checkpoint to the package system for later rollback

(unnecessary, done on every transaction)

rug* checkpoint-add

n/a

Remove a checkpoint from the system

N/A

N/A

rug* checkpoint-remove

n/a

Provide a list of all system checkpoints

N/A

yum history list

rug* checkpoints

n/a

Rolls entire packages back to a certain date or checkpoint.

N/A

yum history rollback

rug* rollback

n/a

Undo a single specified transaction.

N/A

yum history undo

n/a

Package information management

Get a dump of the whole system information - Prints, Saves or similar
the current state of the package management system. Preferred output is
text or XML. One version of rug dumps information as a sqlite database.
(Note: Why either-or here? No tool offers the option to choose the
output format.)

(see /var/lib/pacman/local)

(see /var/lib/rpm/Packages)

apt-cache stats

rug dump

n/a

emerge --info

Show all or most information about a package. The tools' verbosity for
the default command vary. But with options, the tools are on par with
each other.

pacman -[S|Q]i

yum list or info

apt-cache showpkg apt-cache show

rug info

zypper info zypper if

emerge -S; emerge -pv; eix

Search for package(s) by searching the expression in name, description,
short description. What exact fields are being searched by default
varies in each tool. Mostly options bring tools on par.

pacman -Ss

yum search

apt-cache search

rug search

zypper search zypper se [-s]

emerge -S

Lists packages which have an update available. Note: Some provide
special commands to limit the output to certain installation sources,
others use options.

pacman -Qu

yum list updates yum check-update

apt-get upgrade -> n

rug list-updates rug summary

zypper list-updates zypper patch-check (just for patches)

emerge -uDNp world

Display a list of all packages in all installation sources that are
handled by the packages management. Some tools provide options or
additional commands to limit the output to a specific installation
source.

pacman -Sl

yum list available

apt-cache dumpavail apt-cache dump (Cache only) apt-cache pkgnames

rug packages

zypper packages

emerge -ep world

Displays packages which provide the given exp. aka reverse provides.
Mainly a shortcut to search a specific field. Other tools might offer
this functionality through the search command.

pkgfile <filename>

yum whatprovides yum provides

apt-file search <filename>

rug what-provides

zypper what-provides    zypper wp

equery belongs (only installed packages); pfl

Display packages which require X to be installed, aka show reverse/
dependencies. rug's what-requires can operate on more than just package
names.

pacman -Sii

yum resolvedep

apt-cache rdepends

rug what-requires

IN PROGRESS

equery depends

Display packages which conflict with given expression (often package).
Search can be used as well to mimic this function. rug's what-conflicts
function operates on more than just package names

(none)

repoquery --whatconflicts

rug info-conflicts rug what-conflicts

IN PROGRESS

List all packages which are required for the given package, aka show
dependencies.

pacman -[S|Q]i

yum deplist

apt-cache depends

rug info-requirements

IN PROGRESS

emerge -ep

List what the current package provides

yum provides

rug info-provides

IN PROGRESS

equery files

List the files that the package holds. Again, this functionality can be
mimicked by other more complex commands.

pacman -Ql $pkgname   
pkgfile -l

yum provides

apt-file list

rug* file-list

IN PROGRESS

equery files

List all packages that require a particular package

repoquery --whatrequires [--recursive]

equery depends -a

Search all packages to find the one which holds the specified file.
auto-apt is using this functionality.

pkgfile -s

yum provides yum whatprovides

apt-file search

rug* package-file rug what-provides

IN PROGRESS

equery belongs

Display all packages that the specified packages obsoletes.

yum list obsoletes

apt-cache / grep

rug info-obsoletes

IN PROGRESS

Verify dependencies of the complete system. Used if installation process
was forcefully killed.

testdb

yum deplist

apt-get check ? apt-cache unmet

rug verify rug* dangling-requires

n/a

emerge -uDN world

Generates a list of installed packages

pacman -Q

yum list installed

dpkg --get-selections

zypper

emerge -ep world

List packages that are installed but are not available in any
installation source (anymore).

pacman -Qm

yum list extras

deborphan

zypper se -si | grep 'System Packages'

eix-test-obsolete

List packages that were recently added to one of the installation
sources, i.e. which are new to it. Note: Synaptic has this
functionality, however apt doesn't seem to be the provider.

(none)

yum list recent

n/a

eix-diff

Show a log of actions taken by the software management.

cat /var/log/pacman.log

yum history cat /var/log/yum.log

cat /var/log/dpkg.log

rug history

cat /var/log/zypp/history

located in /var/log/portage

Clean up all local caches. Options might limit what is actually cleaned.
Autoclean removes only unneeded, obsolete information.

pacman -Sc  
pacman -Scc

yum clean

apt-get clean apt-get autoclean

zypper clean

eclean distfiles

Add a local package to the local package cache mostly for debugging
purposes.

cp $pkgname /var/cache/pacman/pkg/

apt-cache add

n/a

cp $srcfile /usr/portage/distfiles

Display the source package to the given package name(s)

repoquery -s

apt-cache showsrc

n/a

Generates an output suitable for processing with dotty for the given
package(s).

apt-cache dotty

n/a

Set the priority of the given package to avoid upgrade, force downgrade
or to overwrite any default behavior. Can also be used to prefer a
package version from a certain installation source.

${EDITOR} /etc/pacman.conf  
Modify HoldPkg and/or IgnorePkg arrays

yum-plugin-priorities and yum-plugin-protect-packages

/etc/apt/preferences smart priority –set

zypper mr -p

${EDITOR} /etc/portage/package.keywords  
Add a line with =category/package-version

Remove a previously set priority

/etc/apt/preferences smart priority --remove

zypper mr -p

${EDITOR} /etc/portage/package.keywords  
remove offending line

Show a list of set priorities.

apt-cache policy /etc/apt/preferences smart priority --show

n/a

cat /etc/portage/package.keywords

Ignores problems that priorities may trigger.

n/a

Installation sources management

${EDITOR} /etc/pacman.conf

${EDITOR} /etc/yum.repos.d/${REPO}.repo

${EDITOR} /etc/apt/sources.list

layman

Add an installation source to the system. Some tools provide additional
commands for certain sources, others allow all types of source URI for
the add command. Again others, like apt and yum force editing a sources
list. apt-cdrom is a special command, which offers special options
design for CDs/DVDs as source.

${EDITOR} /etc/pacman.conf

${EDITOR} /etc/yum.repos.d/${REPO}.repo

apt-cdrom add

rug service-add rug mount /local/dir

zypper service-add

layman, overlays

Refresh the information about the specified installation source(s) or
all installation sources.

pacman -Sy

yum clean expire-cache && yum check-update

apt-get update

rug refresh

zypper refresh zypper ref

layman -f

Prints a list of all installation sources including important
information like URI, alias etc.

cat /etc/pacman.d/mirrorlist

cat /etc/yum.repos.d/*

rug service-list

zypper service-list

layman -l

Disable an installation source for an operation

yum --disablerepo=${REPO}

emerge package::repo-to-use

Download packages from a different version of the distribution than the
one installed.

yum --releasever=${VERSION}

echo "category/package ~amd64" >> /etc/portage/package.keywords &&
emerge package

Other commands

Start a shell to enter multiple commands in one session

yum shell

apt-config shell

zypper shell

Package Verification

Single package

pacman -Qk[k] <package>

rpm -V <package>

debsums

rpm -V <package>

rpm -V <package>

equery check

All packages

pacman -Qk[k]

rpm -Va

debsums

rpm -Va

rpm -Va

equery check

Package Querying

List installed local packages along with version

pacman -Q

rpm -qa

dpkg-query -l

emerge -e world

Display local package information: Name, version, description, etc.

pacman -Qi

rpm -qi

dpkg-query -p

emerge -pv and emerge -S

Display remote package information: Name, version, description, etc.

pacman -Si

yum info

apt-cache show

emerge -pv and emerge -S

Display files provided by local package

pacman -Ql

rpm -ql

dpkg-query -L

equery files

Display files provided by a remote package

pkgfile -l

repoquery -l

pfl

Query the package which provides FILE

pacman -Qo

rpm -qf (installed only) or yum whatprovides (everything)

dpkg-query -S

equery belongs

Query a package supplied on the command line rather than an entry in the
package management database

pacman -Qp

rpm -qp

dpkg-deb -I

Show the changelog of a package

pacman -Qc

rpm -q --changelog

equery changes -f

Search locally installed package for names or descriptions

pacman -Qs

eix -S -I

Building Packages

Build a package

makepkg -s

rpmbuild -ba (normal) mock (in chroot)

dpkg-buildpkg

rpmbuild -ba

rpmbuild -ba

ebuild; quickpkg

Check for possible packaging issues

rpmlint

lintian

repoman

List the contents of a package file

pacman -Qpl <file>

rpmls rpm -qpl

rpm -qpl

rpm -qpl

Extract a package

tar -Jxvf

rpm2cpio | cpio -vid

ar vx | tar -zxvf data.tar.gz

rpm2cpio | cpio -vid

rpm2cpio | cpio -vid

tar -jxvf

Query a package supplied on the command line rather than an entry in the
package management database

pacman -Qp

rpm -qp

dpkg-deb -I

Action

Arch

Red Hat/Fedora

Debian/Ubuntu

(Old) SUSE

openSUSE

Gentoo

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pacman_Rosetta&oldid=252921"

Category:

-   Package management
