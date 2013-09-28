DeveloperWiki:Signing Packages
==============================

  

Choose a UID
------------

-   Use a valid e-mail address: no obfuscation.
-   The e-mail address should be reliable (do not use one you got from
    your ISP or a random free service).
-   When in doubt, you should prefer using your @archlinux.org address.
-   The UID also has to be the same as the PACKAGER variable you use to
    build packages.
-   A correct UID looks like this: Pierre Schmitz <pierre@archlinux.de>
-   We strongly advise you use your real name. It has to be exactly that
    found on official documents (passport, driver's license, etc.); see
    CAcert's practice on names.

Create a key pair
-----------------

1.  Install gnupg.
2.  Run: gpg --gen-key
    1.  You may use the default: a never expiring 2048-bit RSA key for
        encryption and signing.

3.  Create a revocation certificate, for use when/if your private key
    ever gets compromised:
    1.  Run:
        gpg -o ~/.gnupg/pierre@archlinux.de-revoke.asc --gen-revoke pierre@archlinux.de
    2.  Make sure to store this file in a secure location (and/or
        encrypt it with a passphrase); then delete the plaintext
        version.

4.  Backup your private key:
    gpg --export-secret-keys pierre@archlinux.de > pierre@archlinux.de-private.asc

Recommended: Get your key signed by CAcert
------------------------------------------

1.  Create an account on CAcert.
2.  Meet CAcert assurers and have them verify your official
    identification documents; see CAcert's assurance policy.
3.  You will then be able to access a new part of the CAcert website and
    get your key signed:
    1.  Export your public key:
        gpg --export --armor pierre@archlinux.de > pierre@archlinux.de.asc
    2.  Paste the content of that file into the form on the CAcert
        website.
    3.  Save the signed key from the CAcert website and import it:
        gpg --import <filename>

Recommended: Get your key signed by other devs
----------------------------------------------

1.  When ever you meet with another dev, sign each others' keys.
2.  Take this seriously: never sign a key when you cannot verify the
    other person's identity.
3.  See CAcert's assurance policy for good guidelines.

Publish your public key
-----------------------

1.  Send your public key to a keyserver:
    1.  Check your key id with: gpg -k
    2.  Run: gpg --send-keys KEY-ID

2.  Add your key fingerprint to your profile at
    https://www.archlinux.org/devel/profile/

Be safe!
--------

1.  Create a backup of your keys and be sure not to forget the
    passphrase!

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Signing_Packages&oldid=184856"

Category:

-   DeveloperWiki
