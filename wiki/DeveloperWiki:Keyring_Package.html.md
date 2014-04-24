DeveloperWiki:Keyring Package
=============================

Summary
=======

We will provide a package that contains a GPG keyring of the developers
keys for import into the pacman keyring.

Overview of Keyring
===================

The GPG keyring for pacman is managed by pacman-key and stored in
/etc/pacman.d/gnupg. This keyring is created using "pacman-key --init",
which also creates an ultimately trusted "Pacman Keychain Master Key".
For a key to be accepted by pacman as trusted after being imported to
the pacman keyring (pacman-key --add/--recv-keys), it must either be
locally signed by the Pacman Keychain Master Key (pacman-key --lsign
<key>), given ultimate trust (via pacman-key --edit-key <key>), or
reachable from an ultimately trusted key through the PGP Web of Trust.

The Arch Linux keyring will contain all packager GPG keys along with a
number (~3) of "master" keys. A user will be required to manually
verify, import and locally sign the master keys into their pacman
keyring. The master keys will be well published on the Arch Linux site
and across various developers websites allowing users to readily verify
their authenticity. Every developer key will be signed by the master
keys and so will be trusted through the web of trust.

A package will be provided that contains the Arch developers GPG keys
ready for import with "pacman-key --populate". This package (and the
files in this package) will be signed (detached) by an Arch master key
(or all of them). The package contains the following files:

-   /usr/share/pacman/keyrings/arch.gpg - the GPG keyring containing the
    developer keys (and probably the master keys)
-   /usr/share/pacman/keyrings/arch-revoked.gpg - [OPTIONAL] a list of
    revoked keys
-   /usr/share/pacman/keyrings/arch-trusted - [OPTIONAL] information
    about which keys need trusted to the form web of trust

For more details of the files and their format, see the PROVIDING A
KEYRING FOR IMPORT section of "man pacman-key".

Areas Needing Finalized for Package Signing Keyring
===================================================

-   How many Arch master keys will there be?
    -   Note: need at least three to establish the web of trust (by
        default)
    -   Note: should be at least one "backup" key to replace a revoked
        key immediately (and thus maintain web of trust)
    -   Query: is the backup key published before it is needed
-   Who holds the master keys?
-   Who holds the revoke certificates for the master keys?
-   How are the master key holders going to verify the dev keys before
    signing them?
-   Will there be separate keyrings for Developers and Trusted Users?
-   Policy for handling developer keys on resignation (where revoking is
    probably not immediately required)

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Keyring_Package&oldid=196102"

Category:

-   Package development

-   This page was last modified on 23 April 2012, at 11:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
