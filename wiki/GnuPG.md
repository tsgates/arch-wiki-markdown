GnuPG
=====

GnuPG can be used to sign and encrypt files or mails.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Basic keys management                                              |
|     -   2.1 Create key                                                   |
|     -   2.2 Import key                                                   |
|     -   2.3 List keys                                                    |
|                                                                          |
| -   3 Basic usage                                                        |
|     -   3.1 Symmetric Encryption                                         |
|                                                                          |
| -   4 gpg-agent                                                          |
|     -   4.1 Pinentry                                                     |
|                                                                          |
| -   5 Smartcards                                                         |
|     -   5.1 GnuPG only setups                                            |
|     -   5.2 GnuPG together with OpenSC                                   |
|                                                                          |
| -   6 Troubleshooting                                                    |
|     -   6.1 Su                                                           |
|     -   6.2 Agent complains end of file                                  |
+--------------------------------------------------------------------------+

Installation
------------

Install gnupg, available in the official repositories.

Basic keys management
---------------------

> Create key

-   Generate a private key by typing in a terminal:

    # gpg --gen-key

You’ll have to answer a bunch of questions but generally, you can accept
the defaults.

-   Generate an ASCII version of your public key (e.g. to distribute it
    by e-mail):

    # gpg --armor --output public.key --export 'Your Name'

-   Register your key with a public PGP key server, so that others can
    retrieve your key without having to contact you directly.:

    # gpg  --keyserver hkp://subkeys.pgp.net --send-keys Key Id

> Import key

-   Import a public key to your public key ring:

    # gpg --import public.key

-   Import a private key to your secret key ring:

    # gpg --import private.key

> List keys

-   Keys in your public key ring:

    # gpg --list-keys

-   Keys in your secret key ring:

    # gpg --list-secret-keys

Basic usage
-----------

You can use gnupg to encrypt your sensitive documents, but only
individual files at a time.

For example, to decrypt a file data, use:

    # gpg -d secret.tar.gpg

You'll be prompted to enter your passphrase.

If you want to encrypt directories or a whole file-system you should
consider use Truecrypt, though you can always tarball various files and
then encrypt them.

> Symmetric Encryption

gpg-agent
---------

gpg-agent is mostly used as daemon to request and cache the password for
the keychain. This is useful if GnuPG is used from an external program
like a mail client. It can be activated by adding following line in
~/.gnupg/gpg.conf:

    use-agent

This tells GnuPG to use the agent whenever it needs the password.
However, the agent needs to run already. To autostart it, create the
following file and make it executable:

    /etc/profile.d/gpg-agent.sh

    #!/bin/sh

    envfile="${HOME}/.gnupg/gpg-agent.env"
    if test -f "$envfile" && kill -0 $(grep GPG_AGENT_INFO "$envfile" | cut -d: -f 2) 2>/dev/null; then
        eval "$(cat "$envfile")"
    else
        eval "$(gpg-agent --daemon --write-env-file "$envfile")"
    fi
    export GPG_AGENT_INFO  # the env file does not contain the export statement

Add an entry in your .xinitrc

    eval $(gpg-agent --daemon) &

Log out your Xsession and login. Check gpg-agent is actived

    #ps aux | grep agent

If you would like to use gpg-agent to manage your SSH keys see SSH
Keys#GnuPG Agent.

Pinentry

Finally, the agent needs to know how to ask the user for the password.
This can be set in ~/.gnupg/gpg-agent.conf

The default uses a gtk dialog. To change it to ncurses or qt, set the
following in the above file

    pinentry-program /usr/bin/pinentry-curses

or

    pinentry-program /usr/bin/pinentry-qt4

For more options see man gpg-agent and info pinentry.

Smartcards
----------

GnuPG uses scdaemon as an interface to your smartcard reader, please
refer to scdaemon man page for details.

> GnuPG only setups

If you do not plan to use other cards but those based on GnuPG, you
should check the reader-port parameter in ~/.gnupg/scdaemon.conf. The
value '0' refers to the first available serial port reader and a value
of '32768' (default) refers to the first USB reader.

> GnuPG together with OpenSC

If you are using any smartcard with an opensc driver (e.g.: ID cards
from some countries) you should pay some attention to GnuPG
configuration. Out of the box you might receive a message like this when
using gpg --card-status

    gpg: selecting openpgp failed: ec=6.108

By default, scdaemon will try to connect directly to the device. This
connection will fail if the reader is being used by another process. For
example: the pcscd daemon used by OpenSC. To cope with this situation we
should use the same underlying driver as opensc so they can work well
together. In order to point scdaemon to use pcscd you should remove
reader-port from ~/gnupg/scdaemon.conf, specify the location to
libpcsclite.so library and disable ccid so we make sure that we use
pcscd.

    ~/scdaemon.conf

    pcsc-driver /usr/lib/libpcsclite.so 
    card-timeout 5
    disable-ccid

Please check man scdaemon if you do not use OpenSC.

Troubleshooting
---------------

> Su

When using pinentry, you must have the proper permisions of the terminal
device (e.g. /dev/tty1) in use. However, with su (or sudo), the
ownership stays with the original user, not the new one. This means that
pinentry will fail, even as root. The fix is to change the permissions
of the device at some point before the use of pinentry (i.e. using gpg
with an agent). If doing gpg as root, simply change the ownership to
root right before using gpg

    chown root /dev/ttyN  # where N is the current tty

and then change it back after using gpg the first time. The equivalent
is likely to be true with /dev/pts/.

Note:being part of the group tty does not seem to alleviate the issue,
at least as root. (Please confirm with non-superusers)

> Agent complains end of file

The default pinetry program is pinetry-gtk-2, which needs a DBus session
bus to run properly. Check $DBUS_SESSION_BUS_ADDRESS, if that's missing
you can run

     eval $(dbus-launch --sh-syntax --exit-with-session)

to provide the bus. dbus-launch as available in dbus.

Alternatively you can use the qt pinetry.

    # ln -sf /usr/bin/pinetry-qt4 /usr/bin/pinetry

Retrieved from
"https://wiki.archlinux.org/index.php?title=GnuPG&oldid=253469"

Category:

-   Security
