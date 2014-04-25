pacman-key
==========

The pacman-key tool is used to set up and manage package signing in Arch
Linux.

Contents
--------

-   1 Introduction
-   2 Setup
    -   2.1 Configuring pacman
    -   2.2 Initializing the keyring
-   3 Managing the keyring
    -   3.1 Verifying the five master keys
    -   3.2 Adding developer keys
    -   3.3 Adding unofficial keys
    -   3.4 Using gpg
-   4 Troubleshooting
    -   4.1 Cannot import keys
    -   4.2 Disabling signature checking
    -   4.3 Resetting all the keys
    -   4.4 Removing stale packages
-   5 See also

Introduction
------------

Pacman uses GnuPG keys in a web of trust model to determine if packages
are authentic. There are currently five Master Signing Keys. At least
three of these Master Signing Keys are used to sign each of the
Developer's and Trusted User's own keys which then in turn are used to
sign their packages. The user also has a unique PGP key which is
generated when you set up pacman-key. So the web of trust links the
user's key to the five Master Keys.

Examples of webs of trust:

-   Custom packages: You made the package yourself and signed it with
    your own key.
-   Unofficial packages: A developer made the package and signed it. You
    used your key to sign that developer's key.
-   Official packages: A developer made the package and signed it. The
    developer's key was signed by the Arch Linux master keys. You used
    your key to sign the master keys, and you trust them to vouch for
    developers.

Note:The HKP protocol uses 11371/tcp for communication. In order to get
the signed keys from the servers (using pacman-key), this port is
required for communication.

Setup
-----

> Configuring pacman

The SigLevel option in /etc/pacman.conf determines how much trust is
required to install a package. For a detailed explanation of SigLevel
see the pacman.conf man page and the comments in the file itself.
Signature checking may be set globally or per repository. If SigLevel is
set globally in the [options] section to require all packages to be
signed, then packages you build will also need to be signed using
makepkg.

Note:Although all official packages are now signed, as of June 2012
signing of the databases is a work in progress. If Required is set then
DatabaseOptional should also be set.

A default configuration of

    /etc/pacman.conf

    SigLevel = Required DatabaseOptional

can be used to only install packages that are signed by trusted keys.
This is because TrustOnly is a default compiled-in pacman parameter. So
above leads to the same result as a global option of

    SigLevel = Required DatabaseOptional TrustedOnly

The above can be achieved too on a repository level further below in the
configuration, e.g.:

    [core]
    SigLevel = PackageRequired # ’Optional’ here would turn off a global ’Required’ for this repository
    Include = /etc/pacman.d/mirrorlist

explicitly adds signature checking for the packages of the repository,
but does not require the database to be signed.

Warning:The SigLevel TrustAll option exists for debugging purposes and
makes it very easy to trust keys that have not been verified. You should
use TrustedOnly for all official repositories.

> Initializing the keyring

To set up the pacman keyring use:

    # pacman-key --init

For this initialization, entropy is required. Moving your mouse around,
pressing random characters at the keyboard or running some disk-based
activity (for example in another console running ls -R / or
find / -name foo or dd if=/dev/sda8 of=/dev/tty7) should generate
entropy. If your system does not already have sufficient entropy, this
step may take hours; if you actively generate entropy, it will complete
much more quickly.

The randomness created is used to set up a keyring (/etc/pacman.d/gnupg)
and the GPG signing key of your system.

Note:If you need to run pacman-key --init over SSH, install the haveged
package on the target machine. Connect via SSH and run the following:

    # haveged -w 1024
    # pacman-key --init

After pacman-key successfully ran, simply stop haveged and remove the
package.

    # pkill haveged
    # pacman -Rs haveged

The haveged solution is not just for use over SSH: it's a great way to
get some entropy quickly. If you're having problems with
pacman-key --init taking ages then you should try this solution.

Managing the keyring
--------------------

> Verifying the five master keys

The initial setup of keys is achieved using:

    # pacman-key --populate archlinux

Take time to verify the Master Signing Keys when prompted as these are
used to co-sign (and therefore trust) all other packager's keys.

PGP keys are too large (2048 bits or more) for humans to work with, so
they are usually hashed to create a 40-hex-digit fingerprint which can
be used to check by hand that two keys are the same. The last eight
digits of the fingerprint serve as a name for the key known as the 'key
ID'.

> Adding developer keys

The official developer and TU keys are signed by the master keys, so you
do not need to use pacman-key to sign them yourself. Whenever pacman
encounters a key it does not recognize, it will promt to download it
from a keyserver configured in /etc/pacman.d/gnupg/gpg.conf (or by using
the --keyserver option on the command line). Wikipedia maintains a list
of keyservers.

Once you have downloaded a developer key, you will not have to download
it again, and it can be used to verify any other packages signed by that
developer.

Note:The archlinux-keyring package (a dependancy of pacman) contains the
latest keys. However keys can also be updated using:

    # pacman-key --refresh-keys

While doing --refresh-keys, your local key will also be looked up on the
remote keyserver, and you will receive a message about it being not
found. This is nothing to be concerned about.

> Adding unofficial keys

First get the key ID (keyid) from the owner of the key. Then you need to
add the key to the keyring:

-   If the key is found on a keyserver, import it with:

        # pacman-key -r keyid

-   If otherwise a link to a keyfile is provided, download it and then
    run:

        # pacman-key --add /path/to/downloaded/keyfile

Always be sure to verify the fingerprint, as you would with a master
key, or any other key which you are going to sign. Finally, you need to
locally sign the imported key:

    # pacman-key --lsign-key keyid

You now trust this key to sign packages.

> Using gpg

If pacman-key is not enough, you can manage pacman's keyring by gpg like
this:

    # gpg --homedir /etc/pacman.d/gnupg $OPTIONS

or

    # env GNUPGHOME=/etc/pacman.d/gnupg gpg $OPTIONS

Troubleshooting
---------------

Warning:Pacman-key depends on time. If your system clock is wrong,
you'll get:

    error: PackageName: signature from "User <email@archlinux.org>" is invalid
    error: failed to commit transaction (invalid or corrupted package (PGP signature))
    Errors occured, no packages were upgraded.

> Cannot import keys

Some ISPs block the port used to import PGP keys. One solution is to use
the MIT keyserver, which provides an alternate port. To do this, edit
/etc/pacman.d/gnupg/gpg.conf and change the keyserver line to:

    keyserver hkp://pgp.mit.edu:11371

If this does not help either, change the keyserver to the kjsl
keyserver, which provides this service through port 80 (the HTML port),
which should always remian unblocked.

    keyserver hkp://keyserver.kjsl.com:80

If you happen to forget to run pacman-key --populate archlinux you might
get some errors while importing keys.

> Disabling signature checking

Warning:Use with caution. Disabling package signing will allow pacman to
install untrusted packages automatically.

If you are not concerned about package signing, you can disable PGP
signature checking completely. Edit /etc/pacman.conf and uncomment the
following line under [options]:

    SigLevel = Never

You need to comment out any repository-specific SigLevel settings too
because they override the global settings. This will result in no
signature checking, which was the behavior before pacman 4. If you
decide to do this, you do not need to set up a keyring with pacman-key.
You can change this option later if you decide to enable package
verification.

> Resetting all the keys

If you want to remove or reset all the keys installed in your system,
you can remove /etc/pacman.d/gnupg folder as root and rerun
pacman-key --init and following that add the keys as preferred.

> Removing stale packages

If the same packages keep failing and you are sure you did all the
pacman-key stuff right, try removing them like so
rm /var/cache/pacman/pkg/badpackage* so that they are freshly
downloaded.

This might actually be the solution if you get a message like
error: linux: signature from "Some Person <Some.Person@example.com>" is invalid
or similar when upgrading (i.e. you might not be the victim of a MITM
attack after all, your downloaded file was simply corrupt).

See also
--------

-   DeveloperWiki:Package Signing Proposal for Pacman
-   Pacman Package Signing – 1: Makepkg and Repo-add
-   Pacman Package Signing – 2: Pacman-key
-   Pacman Package Signing – 3: Pacman
-   Pacman Package Signing – 4: Arch Linux

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pacman-key&oldid=303420"

Category:

-   Package management

-   This page was last modified on 6 March 2014, at 22:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
