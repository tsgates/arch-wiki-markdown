DeveloperWiki:Managing the Master Key
=====================================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prepare your Smartcard                                             |
| -   2 Creating the master key                                            |
| -   3 Signing the master key                                             |
| -   4 Signing your own packager key                                      |
| -   5 Revoking a master key                                              |
| -   6 Signing developer keys                                             |
| -   7 Revoking developer keys                                            |
| -   8 Open questions                                                     |
| -   9 External documentation                                             |
+--------------------------------------------------------------------------+

Prepare your Smartcard
----------------------

Install the ccid package and start the pcscd daemon. Insert your
smartcard reader and check the output of gpg --card-status

Creating the master key
-----------------------

Run gpg --card-edit. Type in admin to enabled administration functions.
All available commands can now be listed by issuing the help command.
Use the name and sex commands to set some unimportant meta data.

To create a new key pair just type in generate. Create a 3072 Bits key
that does not expire and enter your data according to this example:

    Real name: Pierre Schmitz
    Email address: pierre@master-key.archlinux.org
    Comment: Arch Linux Master Key

Confirm that your USER-ID looks like
"Pierre Schmitz (Arch Linux Master Key) <pierre@master-key.archlinux.org>".
Generating the key will take some time. Note that the encryption key
will be reduced to 1024 Bits.

If you created a backup of your key during creation you should secure it
on an offline device and remove the key from your hard drive. E.g. use
shred:

    shred -u /home/pierre/.gnupg/sk_8DFDBF1F86872C2F.gpg

Now create a revoke key:

    gpg -o master-key-revoke.asc --gen-revoke 6AC6A4C2

Choose no reason (0) if you are asked for one. Make sure to save this
key on a secure and offline device (e.g. print it or use a thumb drive).

Signing the master key
----------------------

Sign the master key using your packager key. For example using the
master key id:

    gpg --sign-key 6AC6A4C2

Double check you are using the right keys here!

Upload your master key now using:

    gpg --send-keys 6AC6A4C2

You may also want to create a copy of your public key to publish
elsewhere:

    gpg --export --armor 6AC6A4C2 > pierre@master-key.archlinux.org.asc

Signing your own packager key
-----------------------------

As you should trust yourself the most, just go ahead and sign your own
packager key:

    gpg --sign-key -u 6AC6A4C2 9741E8AC

Note that in this example your master key id is first and your packager
key id last.

Upload your public key using:

    gpg --send-keys 9741E8AC

Revoking a master key
---------------------

Signing developer keys
----------------------

Revoking developer keys
-----------------------

Open questions
--------------

-   Using the smartcard generates following errors without any apparent
    effect:

    libusb couldn't open USB device /dev/bus/usb/001/006: Permission denied.
    libusb requires write access to USB device nodes.

Cause: gnupg has an internal ccid driver. This driver accesses the USB
device node directly, without going through pcscd. However, gnupg's
internal driver does not support the Gemalto USB reader anyway, so this
message can be ignored.

-   udev/packaging issue:

    udevd[273]: specified group 'pcscd' unknown

This is unproblematic: the pcscd daemon runs as root.

-   Should we advice to create a backup during key creation or rather
    not?
-   Is the passphrase only used for the backup key?

Yes.

-   Is the public key also stored on the card?

It probably is, but there is no apparent way to obtain it. Export it to
some keyserver quickly.

-   How should the url configuration be set?

A string pointing to a URL that stores your pubkey.

-   What is the impact of setting forcesig?

If you enable forcesig, you must enter the PIN for each single
signature. This is recommended.

External documentation
----------------------

http://wiki.debian.org/Smartcards/OpenPGP

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Managing_the_Master_Key&oldid=170722"

Category:

-   DeveloperWiki
