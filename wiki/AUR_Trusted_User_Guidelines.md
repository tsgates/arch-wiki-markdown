AUR Trusted User Guidelines
===========================

> Summary

Explains guidelines for the Arch User Repository's Trusted Users.

> Related

Arch User Repository

The Trusted User (TU) is a member of the community charged with keeping
the AUR in working order. He/she maintains popular packages
(communicating with and sending patches upstream as needed), and votes
in administrative matters. A TU is elected from active community members
by current TUs in a democratic process. TUs are the only members who
have a final say in the direction of the AUR.

The TUs are governed using the TU bylaws

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 TODO list for new Trusted Users                                    |
| -   2 The TU and [unsupported]                                           |
| -   3 The TU and [community], Guidelines for Package Maintenance         |
|     -   3.1 Rules for Packages Entering the [community] Repo             |
|     -   3.2 Accessing and Updating the Repository                        |
|     -   3.3 Disowning packages                                           |
|     -   3.4 Moving packages from unsupported to [community]              |
|     -   3.5 Moving packages from [community] to unsupported              |
|     -   3.6 Moving packages from [community-testing] to [community]      |
|     -   3.7 Deleting packages from unsupported                           |
|     -   3.8 See also                                                     |
+--------------------------------------------------------------------------+

TODO list for new Trusted Users
-------------------------------

1.  Read this entire wiki article.
2.  Read the TU Bylaws.
3.  Make sure your account details on the AUR are up-to-date and that
    your sponsor has given you TU status.
4.  Add yourself to the Trusted Users page.
5.  Remind Allan/Andrea to change your account on forums.
6.  Ask some TU for the #archlinux-tu@freenode key and hang out with us
    in the channel. You do not have to do this, but it would be neat
    since this is where most dark secrets are spilled and where many new
    ideas are conceived.
7.  If you are not upgraded to a Trusted User group on bug tracker in
    two days, report this as a bug to Andrea Scarpino
    (andrea@archlinux.org).
8.  Send Ionuț Bîru (ibiru@archlinux.org) all the information based on
    this template to have access on dev interface.
9.  Install the devtools package.
10. Send an email to Florian Pritz with one SSH public key attached. If
    you do not have one, use ssh-keygen to generate one. Check the Using
    SSH Keys wiki page for more information about SSH keys.
11. Create a PGP key for package signing.
12. Send a signed email to all Master Keys owners including your PGP key
    and the relative full key fingerprint. Your key needs to be signed
    at least by three of five master key holders.
13. Make the directories ~/staging/community and
    ~/staging/community-testing (and ~/staging/multilib if you are
    interested in maintaining multilib packages) on
    nymeria.archlinux.org. This step is important as the devtools
    scripts use this directory to process incoming packages.
14. Subscribe to the arch-dev-public ML and ask Florian to whitelist
    you.
15. Start contributing!

The TU and [unsupported]
------------------------

The TUs should also make an effort to check package submissions in
UNSUPPORTED for malicious code and good PKGBUILDing standards. In around
80% of cases the PKGBUILDs in the UNSUPPORTED are very simple and can be
quickly checked for sanity and malicious code by the TU team.

TUs should also check PKGBUILDs for minor mistakes, suggest corrections
and improvements. The TU should endeavor to confirm that all pkgs follow
the Arch Packaging Guidelines/Standards and in doing so share their
skills with other package builders in an effort to raise the standard of
package building across the distro.

TUs are also in an excellent position to document recommended practices.

The TU and [community], Guidelines for Package Maintenance
----------------------------------------------------------

> Rules for Packages Entering the [community] Repo

-   Only "popular" packages may enter the repo, as defined by 1% usage
    from pkgstats or 10 votes on the AUR.

-   Automatic exceptions to this rule are:
    -   i18n packages
    -   accessibility packages
    -   drivers
    -   dependencies of packages who satisfy the definition of popular,
        including makedeps and optdeps
    -   packages that are part of a collection and are intended to be
        distributed together, provided a part of this collection
        satisfies the definition of popular

-   Any additions not covered by the above criteria must first be
    proposed on the aur-general mailing list, explaining the reason for
    the exemption (e.g. renamed package, new package). The agreement of
    three other TUs is required for the package to be accepted into
    [community]. Proposed additions from TUs with large numbers of
    "non-popular" packages are more likely to be rejected.

-   TUs are strongly encouraged to move packages they currently maintain
    from [community] if they have low usage. No enforcement will be
    made, although resigning TUs packages may be filtered before
    adoption can occur.

> Accessing and Updating the Repository

The [community] repository now uses devtools which is the same system
used for uploading packages to [core] and [extra], except that it uses
another server nymeria.archlinux.org instead of gerolde.archlinux.org.
Thus most of the instructions in Packager Guide work without any change.
Information which is specific for the [community] repository (like
changed URLs) have been put here. The devtools require packagers to set
the PACKAGER variable. This is done in
/usr/share/devtools/makepkg-{i686,x86_64}.conf since the regular
configuration file does not get placed in a clean chroot.

Initially you should do a non-recursive checkout of the [community]
repository:

    svn checkout -N svn+ssh://svn-community@nymeria.archlinux.org/srv/repos/svn-community/svn

This creates a directory named "svn" which contains nothing. It does,
however, know that it is an svn checkout.

For checking out, updating all packages or adding a package see the
Packager Guide.

To remove a package:

    ssh nymeria.archlinux.org /community/db-remove community arch pkgname

Here and in the following text, arch can be one of i686 or x86_64 which
are the two architectures supported by Arch Linux. (What about "any"?)

When you are done with editing the PKGBUILD, etc, you should commit the
changes (svn commit).

When you want to release a package, first copy the package to the
staging/community directory on nymeria.archlinux.org using scp and then
tag the package by going to the pkgname/trunk directory and issuing
archrelease community-arch. This makes an svn copy of the trunk entries
in a directory named community-i686 or community-x86_64 indicating that
this package is in the community repository for that architecture.

Note: In some cases, especially for community packages, an x86_64 TU
might bump the pkgrel by .1 (and not +1). This indicates that the change
to the PKGBUILD is x86_64 specific and i686 maintainers should not
rebuild the package for i686. When the TU decides to bump the pkgrel, it
should be done with the usual increment of +1. However, a previous
pkgrel=2.1 must not become pkgrel=3.1 when bumped by the TU and must
instead be pkgrel=3. In a nutshell, leave dot (.) releases exclusive to
the x86_64 TU's to avoid confusion.

Thus the process of updating a package can be summarised as:

-   Update the package directory (svn update some-package)
-   Change to the package trunk directory (cd some-package/trunk)
-   Edit the PKGBUILD, make necessary changes and makepkg. It is
    recommended to build in a clean chroot.
-   Namcap the PKGBUILD and the binary pkg.tar.gz.
-   Commit, Copy and Tag the package using
    communitypkg "commit message". This automates the following:
    -   Commit the changes to trunk (svn commit)
    -   Copy the package to nymeria.archlinux.org
        (scp pkgname-ver-rel-arch.pkg.tar.xz* nymeria.archlinux.org:staging/community/)
    -   Tag the package (archrelease community-{i686,x86_64})

-   Update the repository
    (ssh nymeria.archlinux.org /community/db-update)

Also see the Miscellaneous section in the Packager Guide. For the
section Avoid having to enter your password all the time use
nymeria.archlinux.org instead of gerolde.archlinux.org.

> Disowning packages

If a TU cannot or does not want to maintain a package any longer, a
notice should be posted to the AUR Mailing List, so another TU can
maintain it. A package can still be disowned even if no other TU wants
to maintain it, but the TUs should try not to drop many packages (they
should not take on more than they have time for). If a package has
become obsolete or is not used any longer, it can be removed completely
as well.

If a package has been removed completely, it can be uploaded once again
(fresh) to UNSUPPORTED, where a regular user can maintain the package
instead of the TU.

> Moving packages from unsupported to [community]

Follow the normal procedures for adding a package community, but
remember to delete the corresponding package from unsupported!

> Moving packages from [community] to unsupported

Remove the package using the instructions above and upload your source
tarball to the AUR.

> Moving packages from [community-testing] to [community]

    ssh nymeria.archlinux.org /srv/repos/svn-community/dbscripts/db-move community-testing community package

> Deleting packages from unsupported

There is no point in removing dummy packages, because they will be
re-created in an attempt to track dependencies. If someone uploads a
real package then all dependents will point to the correct place.

> See also

-   DeveloperWiki#Packaging_Guidelines

Retrieved from
"https://wiki.archlinux.org/index.php?title=AUR_Trusted_User_Guidelines&oldid=247293"

Category:

-   Package development
