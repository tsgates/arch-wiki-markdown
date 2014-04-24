DeveloperWiki:Package signing
=============================

This page covers usage of package signing with pacman, as well as being
a brain dump and collaborative design document. To set up package
signing in pacman, see pacman-key.

See also: DeveloperWiki:Package Signing Proposal for Pacman

Pacman 4 uses GnuPG to implement package signing.

Contents
--------

-   1 Usage
    -   1.1 Arch implementation
    -   1.2 Signature checking
-   2 Course of action for development
    -   2.1 Documentation
    -   2.2 Additional Features
        -   2.2.1 Package validation without root privileges
        -   2.2.2 Timeline for increasing security
-   3 How signing is implemented in other distributions
    -   3.1 Frugalware
    -   3.2 Gnuffy
    -   3.3 Debian
        -   3.3.1 Binary packages (.deb)
        -   3.3.2 Source packages
    -   3.4 Gentoo
    -   3.5 Red Hat/Fedora/CentOS
        -   3.5.1 Pros
        -   3.5.2 Cons
    -   3.6 SUSE
    -   3.7 Slackware
    -   3.8 Ubuntu
        -   3.8.1 Cons
-   4 Links
    -   4.1 Bug reports
    -   4.2 Blogs
    -   4.3 Mailing list discussions and patches
    -   4.4 Forum discussions

Usage
-----

> Arch implementation

-   Packages are signed using makepkg --sign. This creates a detached
    binary signature (.sig).
-   The signed package is added to the repository database, and a
    detached signature of the repository database will be generated,
    using repo-add --verify --sign. The command line options indicate
    that the signature of the old database will be verified, and that
    the new database will be signed. Independently of these options,
    repo-add will detect the detached signature, convert it via base64
    to ASCII, and add it to the repository database.
-   pacman will download both the databases and the database signatures
    and verify the databases upon database sync and each time the
    database is opened. When a package is loaded, its signature will be
    checked whether that comes from a repo database or a standalone .sig
    file.
-   pacman-key exists for the sake of managing keys, but there is
    missing functionality

> Signature checking

To prepare for checking signed packages, run the pacman-key command
shown below, with root permissions. It generates a random key and a
“keyring” in /etc/pacman.d/gnupg/. You may need to move the mouse around
to generate entropy for the key.

    # pacman-key --init

If this command is never run, pacman will abort saying “failed to commit
transaction (invalid or corrupted package [PGP signature])” when it
encounters packages signed with an unknown key.

By default, pacman automatically accepts unsigned packages, but signed
ones are rejected with an error unless pacman considers the key to be
“trusted”. This corresponds to SigLevel = Optional in pacman.conf; see
Package and database signature checking in the pacman.conf man page for
further information.

Pacman usually prompts to add new keys of signed packages to its
keyring. Keys can be manually compared against the lists of Arch
developers and trusted users on the Arch Linux web site. If the SigLevel
configuration specifies “TrustAll”, pacman considers keys to be trusted
once they are imported to the keyring, so it will then continue
installing each package. If pacman does not prompt to add new keys
(cannot find on configured key server perhaps?), they could still be
added manually by using the pacman-key tool.

If SigLevel specifies TrustedOnly (the default), pacman also considers
the “trust level” for each key. A key is considered trusted if it is
locally signed, or it has a sufficient level in the pacman web of trust.
Locally signing a key (with pacman-key --lsign) only really works after
the key has already been imported.

If there is a long time and failure right after checking packages
integrity, edit /etc/pacman.d/gnupg/gpg.conf to use a different key
server, for example keyserver hkp://pgp.mit.edu instead of
keys.gnupg.net.

Course of action for development
--------------------------------

> Documentation

Documentation for the new features must be reviewed and finalized.

> Additional Features

These are important but non-essential features that should be added soon
after package signing is implemented. Work on these issues can start
now, but priority should be given to the "requirements" above.

Package validation without root privileges

Currently, pacman's GnuPG home directory (aka gpgdir, typically
/etc/pacman.d/gnupg/) must be locked in order to check a package's
signature. Only root can perform this locking, so either locking must be
disabled for read-only accesses, or the directory must be copied/linked
to a writable location when a user is performing package verification.

Timeline for increasing security

A timeline for transitioning between some unsigned packages and a
fully-signed set of packages must be made. This is the responsibility of
the developers.

How signing is implemented in other distributions
-------------------------------------------------

> Frugalware

Frugalware uses a fork of pacman which implements package signing
(verify)

> Gnuffy

Arch based distro gnuffy uses signed packages with their custom package
manager Spaceman modeled on pacman.

> Debian

Binary packages (.deb)

To sum up, the GPG signature is included in the .deb.

Details:

Regular non signed binary packages are "ar" archives of at least 3
files:

-   data.tar.gz (files to be installed)
-   control.tar.gz (package metadata)
-   debian-binary (contains the version of the deb format)

Signed packages also have a _gpgorigin file at the root of the .deb that
is a "gpg -abs" of the concatenation of the 3 laters (as explained
here):

    cat debian-binary control.tar.gz data.tar.gz > /tmp/combined-contents
    gpg -abs -o _gpgorigin /tmp/combined-contents (-a "Create ASCII armored output" ; -b "detach signature" ; -s "sign")

Source packages

Original files are provided on the repo like this
acpid_2.0.4.orig.tar.gz with diff if necessary (acpid_2.0.4-1.diff.gz).
A description file containing MD5sums of the orig.tar.gz and diff.gz is
written and signed using GPG and uploaded along these.

> Gentoo

According to the Gentoo wiki, individual ebuilds are not signed.

> Red Hat/Fedora/CentOS

-   Signature type: GPG
-   Stored: in the RPM

A RPM package is a tarball of installed files to which is added a header
made up of metadata (name of package, version, ...). This metadata can
contain a GPG signature of the tarball. See the file format
specification for details.

NB: packages built for the Red Hat Network are signed with the Red Hat
official key(s) but technically a RPM can be signed using any other key
(one can even add another signature to the RPM)

To check a package correction, one must first import the signer's key
first: Example for Red Hat:

    rpm --import /usr/share/doc/rpm-4.1/RPM-GPG-KEY

And can then check signature manually:

    $ rpm -K openldap-clients-2.3.43-4.x86_64.rpm 
      openldap-clients-2.3.43-4.x86_64.rpm: sha1 md5 OK

And even fully check the package (MD5):

    $ rpm -Kv openldap-clients-2.3.43-4.x86_64.rpm 
      openldap-clients-2.3.43-4.x86_64.rpm:
         SHA1 header hash: OK (65999383ad859be0ce337aee4c1f6bd049ebe4a0)
         MD5 sum: OK (4be23a341d23b794d08fbee35c459c83)

Option --nogpg prevents rpm from checking GPG signatures

Pros

-   Enable Official Distribution package signature but also enables
    personal and multiple signatures

Cons

-   Implies complicated package format with header containing signature
    of an inner tarball (not very KISS)
-   Space greedy on repos

> SUSE

> Slackware

> Ubuntu

For each package, a small description file containing the SHA sum of the
package is created. That file is then signed using gpg (.dsc) and
uploaded within the same folder as the package:

    gpg --clearsign description_of_package

See result for acpid in Ubuntu

Cons

-   Space greedy (2 files for 1 package)

Links
-----

> Bug reports

1.  Bugreport Signed packages

> Blogs

1.  Geoffrey carriers blog
2.  Attack on package managers
3.  Attack faq

> Mailing list discussions and patches

1.  Add Keyring option in alpm/pacman
2.  Package signing again
3.  PATCH (newgpg) Let pacman specify GnuPG's home directory.
4.  Dan's pacman tree build&test
5.  GPG work
6.  GPG signature option in makepkg patch
7.  GPG signature support for makepkg
8.  GPG signature option in makepkg, adapted to Dan McGee's suggestions
    patch
9.  GPG verification patch
10. GPGSIG in repo-add patch
11. Signing by default
12. Package Database signing
13. Pointless to use non-md5 for makepkg INTEGRITY_CHECK
14. Can we trust our mirrors
15. Multiple/Shared Architectures

> Forum discussions

1.  Pacman vulnerable to MITM attacks?
2.  Arch approach to security
3.  Pacman Veanurability
4.  Package signing
5.  pacman vulnerabilities

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Package_signing&oldid=266917"

Categories:

-   Package development
-   Pacman development
-   Security

-   This page was last modified on 18 July 2013, at 06:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
