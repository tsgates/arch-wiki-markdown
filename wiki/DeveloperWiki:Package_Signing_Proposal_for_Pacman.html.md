DeveloperWiki:Package Signing Proposal for Pacman
=================================================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This is a proposal for the package signing feature for Pacman. Here
we'll gather ideas and commitments, so the implementation will be guided
by this document.

See also: Pacman package signing

Contents
--------

-   1 Introduction
-   2 Web of Trust - Simple introduction
-   3 Pacman's keyring
-   4 Arch Key Signing keys
    -   4.1 Use case: Arch Key Signing Keys creation
    -   4.2 Use case: Signing of developer's keys
-   5 Package signing by developers
    -   5.1 Use case
-   6 Installation of KSK by the users
    -   6.1 Use case
-   7 Package verification
    -   7.1 Use case
-   8 Affected tools
    -   8.1 Makepkg
    -   8.2 devtools
    -   8.3 pacman
    -   8.4 pacman-key
-   9 Final comments

Introduction
------------

Package signing is a long asked feature for Pacman. The goal of this
implementation is to guarantee that a package was created by the person
that claims to have made it.

For that to work, we'll use GnuPG as the tool to sign, verify and manage
the group of keys that are trusted.

Web of Trust - Simple introduction
----------------------------------

A web of trust is the concept used by OpenPGP (and GnuPG) for the
management of trust policies in its public key system. As there's no
concept of a central authoritative entity, there is the need of some
kind of verification of the public keys that we accept in our keyring.
Keys can be signed by other users, indicating that they trust in the
veracity of the key. But the verification can become cumbersome, as the
number of keys exchanged increases. To solve this, the concept of Web of
Trust was introduced. If I trust enough in a friend, I can sign his key
in my keyring and tell to gpg that I also trust in the keys that he
signs. So, if I verify a file that was signed by a person that my friend
trusts, gpg will accept the signature as valid. When I import the third
person's public key, gpg will mark it as a valid key.

In GnuPG, there are four levels of trust in a public key:

 unknown
    I did not say anything about this key yet
 none
    I do not trust this public key to sign other keys (this just affects
    the signature keys, not the signatures of files)
 marginal
    I have a little trust in this public key to sign other keys
 fully
    I trust completely in this public key, as if it was my own
 ultimately
    the same level of trust as your own key

So, GnuPG can be configured to accept a key as valid if it has 3
marginally trusted key signatures or 1 fully trusted key signature (this
is the default). Or it can be any other combination, if properly
configured.

The following is a suggestion for the use of GnuPG to sign and manage
the pacman's keyring, together with the creation of a web of trust for
the Arch Developers. It is very similar to what Debian and Fedora do,
although there are some differences, because of our way of doing things.

Pacman's keyring
----------------

Pacman will have a separated keyring, so the root's keyring will not be
affected by keys that are intended for use with package signing. This is
already implemented in Allan's pacman git branch for gpg support. The
directory will be /etc/pacman.d/gnupg/. There will be the public key
database, the trust database and a fake private key database, because
GnuPG doesn't work very well without one (according to Debian's apt-key
script).

The keyring will be populated based on the keys from the pacman-keyring
package. In this package, there will be a file for the valid keys and
one for the removed keys, so that the post-install script can revoke
keys that may not be trusted anymore (be it for security reasons or
because some developer has left the project). There'll be signature
files for the two sets of keys, so the updatedb script can check to see
if they are valid before updating.

Arch Key Signing keys
---------------------

There will be 3 keys for the sole purpose of signing other developers'
keys (hereafter named KSK, Key Signing Keys). They will be created by 3
developers (hereafter named Key Signers) that will be responsible for
the role of signing the other developers' keys (and their own too). This
procedure is very important and must be done with the certainty that the
keys being signed are from the person they plead to be. The confirmation
of the fingerprints must be done via a secure channel (skype, phone
call, secure email or personally). For example, Debian only trust in
keys confirmed personally. We can be a little lenient because the group
of developers is reduced.

The Key Signers must keep his KSK secured and must choose a strong
passphrase, so that even in the event of the secret keys being stolen,
the risk of a real misuse will be little. In such case, there will be
some time for the generation of a new set of KSK and the re-signing of
the others developers' keys. The Key Signers must also generate a
revocation key for each of the KSK and must keep the revocation keys
secured (preferably only in printed form or in a thumbdrive stored in
some kind of safe box). This is needed because anyone that owns the
revocation key can revoke the corresponding key.

To sign the developer's keys, the Key Signers must receive a copy of the
public key (through email or from a public key server). After importing
the key into his own keyring, the Key Signer must sign the public key
with the KSK. After that, he needs to export the signed public key and
update the pacman-keyring package (there'll be a script for that task).
Only one Key Signer should update the pacman-keyring package at a time
to avoid having some key being lost because of overwriting files. There
must be some form of coordination between the Key Signers on who will do
the task.

With the KSK and the signed developers' keys, the pacman-keyring package
will be created and signed with one of the KSK.

> Use case: Arch Key Signing Keys creation

1.  3 developers will be selected to be the Key Signers
2.  Each Key Signer creates a public/private key pair in his local
    keyring with gpg --gen-key
    1.  We need to decide if there'll be an expiration date

3.  Each Key Signer creates a revocation key, which will be used for
    revocation of the KSK, in case of compromising of the private key.
    gpg --gen-revoke <key id>
    1.  GnuPG can generate a revocation key for other person to trigger
        there the revocation. So, for each KSK, there should be
        designated revocation keys for the other two Key Signers. They
        could revoke their KSK and the others too, in case of
        inavailability of the owner of a KSK.
    2.  The revocation key MUST be kept secure, even more than the
        private key. This is because any person can revoke a key. The
        advise from GnuPG is that the revocation key be kept in a thumb
        drive in a safe or printed, so that there would be no way to
        access the digital file of the rev. key.

4.  Each Key Signer sends his public KSK to a predefined key server. gpg
    --send-keys <key id> --keyserver <url for key server>
5.  Each Key Signer fetches the other KSKs from the key server and signs
    them with his own KSK (not his personal key)
6.  Each Key Signer sends the other KSKs to the server again, to update
    the signatures.
7.  Each fetches again the KSKs from the key server, so they get the
    KSKs with all signatures from the others signers.

> Use case: Signing of developer's keys

1.  If a developer doesn't have a key yet, he generates one with: gpg
    --gen-key
2.  If he generated the key in the previous step, he needs to generate a
    revocation key too. gpg --gen-revoke <key id>
    1.  The same remarks for the revocation key above apply here.

3.  The developer exports his public key to a file or sends it to a
    public key server. gpg --export <key id> > key.gpg or gpg --send-key
    <key id> --keyserver <url for key server>
4.  The developer contacts one of the Key Signers and sends him his
    public key file or instructs him to fetch it from the key server. Is
    important to negotiate a secure channel for the exchange of
    fingerprint. It should not be through email. Maybe IM, Skype or
    through ssh session with some Arch server as temporary storage.
5.  The Key Signer signs the developer's public key with his owned KSK.
6.  There'll be a script to help the management of the files used to
    populate pacman's key ring, so the new key will be added to the set
    of valid keys.
7.  The pacman-keyring package will be rebuilt and signed with a KSK
    (not with a common developer's key). The procedure is described in
    the use case for package signing.

Package signing by developers
-----------------------------

When a developer builds a new package, makepkg will have the options to
sign the package too, with the developer's own key (not the KSK, if the
developer owns one). The signature will be detached, so we can keep this
process optional for people that do not care for it.

> Use case

1.  A package is rebuilt and signed with makepkg --signwithkey <key id>
    [other options]
2.  Developer uses tool to upload the package and signature to his
    staging area
3.  Developer repeats this until there are no more packages to build
4.  Developer uses tool to copy his packages from staging area to the
    final repository and sign the repo.db. The script will do the
    following:
    1.  check if the repo.db is locked. Just proceed if unlocked.
    2.  lock the repo.db
    3.  call repo-add to add all the new packages
    4.  copy the repo.db to the local machine of the developer
    5.  sign the local repo.db with the developer's personal key. The
        signature will be detached
    6.  scp the signature back (and the repo.db?) to the server
    7.  unlock the repo.db

Installation of KSK by the users
--------------------------------

This is a very sensitive part and must be done with caution, at the risk
of driving all the work moot. The KSK should be manually verified by the
user before pacman can accept the pacman-keyring package. I believe that
the following would be the workflow:

-   the KSK and the corresponding fingerprints would be available in
    several channels of Arch: Home page, git repository, forums, public
    key servers, etc.

-   the user downloads the KSK and import them (with a new tool, called
    pacman-key, named after apt-key)

-   pacman-key shows the fingerprint of each KSK and asks for the
    approval of the user

-   if the user confirms, pacman imports the keys to its keyring,
    setting them as fully trusted

After this, the pacman-keyring can be installed and the public keys of
the developers can be added by the post-install script. The trustdb will
be updated automatically.

> Use case

1.  The user must download the pacman-key tool (or it could be provided
    in a version of pacman without signing capabilities).
2.  User fetches the KSKs from a key server. The id's can be discovered
    on a new item or forum or mail list post. pacman-key receive
    <keyserver> <KSK1 id> <KSK2 id> <KSK3 id>
3.  If the user downloaded the KSKs, they must be imported to pacman's
    keyring. Otherwise, they are already there. pacman-key add <file
    with KSKs>
4.  User must trust explicitly each KSK with pacman-key trust <KSK id>
    1.  The KSK fingerprint will be shown to the user. He must guarantee
        that he consults more than one secure source for comparison,
        such as Arch news item, Forum post, Mail list archive post,
        maybe we should have a file in git too.
    2.  The user must type 'trust' in the prompt. GnuPG will ask the
        level of trust that the user assigns to the key. He should
        answer 5 (ultimately) for the KSKs. Any value other than 5 will
        not make the KSK effective to assign trust to other keys signed
        by it. This must be further investigated. "Ultimately" should be
        used only for personal keys and "Fully" or "Marginal" should be
        effective. Maybe it is a configuration problem.
    3.  The user types 'save' to end the edit session of GnuPG

5.  When a version of pacman able to verify signatures is available,
    pacman will update itself and install pacman-keyring first, as a
    dependency. The pacman-key tool will be used by --post-install
    script from pacman-keyring and will update the real pacman keyring
    with the keys in this package. The web of trust will be updated
    accordingly.

Package verification
--------------------

When pacman downloads a package, the signature will be downloaded with
it, if applicable. Pacman will inform the user if the package's
signature is not valid and stop. There will be no possibility to install
a signed package with an invalid signature.

> Use case

1.  Pacman downloads the repo.db and its corresponding signature. The
    following should happen:
    1.  pacman verifies if the signature date is older than n days (we
        must decide this). If older, stop the procedure and ask the user
        to change mirrors or report the bug (the lack of new versions of
        the repo.db will be a bug)
    2.  pacman verifies the signature to see if it is valid.

2.  pacman downloads the packages (the signatures are already downloaded
    in the repository database)
3.  Before the installation (or update), each package is verified to see
    if the signature is correct and is signed by a trusted key. If the
    package has a signature and it is not valid, it should not be
    installed.

Affected tools
--------------

> Makepkg

There should be options to choose the key to sign a package. The key
will always be from the keyring of the user building the package.

> devtools

This is a subject that is being discussed and this text will be updated
soon.

> pacman

Allan's branch is already verifying signatures, but there are some easy
changes needed to point to the right keyring.

> pacman-key

Pacman-key is a new tool, responsible for the management of Pacman's
keyring. It is a shell script and is needed because gpgme is not able to
handle some operations on keyrings, so we can not change pacman to
handle them too. The operations available will be, amongst others:

-   approval of KSK
-   importing/exporting of keys
-   fetching keys from a key server
-   changing level of trust for keys
-   removal of keys
-   update of trustdb

Final comments
--------------

We believe that these suggestions are feasible and will bring a new
level of quality to Arch Linux. Allan's gpg branch of pacman git
repository is in a good position in relation of what I suggested above.

The discussions will take place on pacman-dev mailing list and this
document will be updated as the decisions are made.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Package_Signing_Proposal_for_Pacman&oldid=196151"

Categories:

-   Package development
-   Pacman development

-   This page was last modified on 23 April 2012, at 11:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
