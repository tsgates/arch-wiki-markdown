GnuPG
=====

GnuPG can be used to sign and encrypt files or mails.

Contents
--------

-   1 Installation
-   2 Environment Variables
-   3 Configuration file
-   4 Basic keys management
    -   4.1 Create key
    -   4.2 Manage your key
    -   4.3 Rotating subkeys
    -   4.4 Import key
    -   4.5 List keys
-   5 Basic usage
-   6 gpg-agent
    -   6.1 Pinentry
-   7 Keysigning Parties
    -   7.1 Caff
-   8 Smartcards
    -   8.1 GnuPG only setups
    -   8.2 GnuPG together with OpenSC
-   9 Troubleshooting
    -   9.1 Su
    -   9.2 Agent complains end of file
    -   9.3 KGpg configuration permissions
-   10 See also

Installation
------------

Install gnupg, available in the official repositories.

Environment Variables
---------------------

-   $GNUPGHOME is used by GnuPGP to point to the directory where all
    configuration files are stored. By default $GNUPGHOME isn't set and
    your $HOME is used instead, thus you will find a ~/.gnupg directory
    right after the install. You may change this default setting by
    putting this line in one of your regular startup files

    export GNUPGHOME="/path/to/gnupg/directory"

Note: By default, the gnupg directory has its Permissions set to 700 and
the files it contains have their permissions set to 600. Only the owner
of the directory has permission to read, write and execute (r,w,x). This
is for security purposes and should not be changed. In case this
directory or any file inside it does not follow this security measure,
you will get warnings about unsafe file and home directory permissions.

-   GPG_AGENT_INFO used to locate the pgp-agent. Consists of 3 colon
    delimited fields:
    -   1. path to Unix Domain Socket
    -   2. PID of gpg-agent
    -   3. protocol version set to 1

E.g : GPG_AGENT_INFO=/tmp/gpg-eFqmSC/S.gpg-agent:7795:1. When starting
the gpg-agent, this variable is set to the correct value.

Configuration file
------------------

Default is ~/.gnupg/gpg.conf. If you want to change the default
location, either run gpg this way $ gpg --homedir path/to/file or use
$GNUPGHOME variable.

Append in this file any long options you want. Do not write the two
dashes, but simply the name of the option and required arguments. You
will find a skeleton file usr/share/gnupg/gpg-conf.skel. Following is a
basic configuration file:

    ~/.gnupg/gpg.conf

    default-key name            # useful in case you manage several keys and want to set a default one
    keyring file                # will add file to the current list of keyrings
    trustdb-name file           # use file instead of the default trustdb
    homedir dir                 # set the name of the gnupg home dir to dir instead of ~/.gnupg
    display-charset utf-8       # bypass all translation and assume that the OS uses native UTF-8 encoding
    keyserver name              # use name as your keyserver
    no-greeting                 # suppress the initial copyright message
    armor                       # create ASCII armored output. Default is binary OpenPGP format

If you want to set up default options for a multi-user system, the
configuration file of defaults is expected in /etc/skel/.gnupg/. With
that in place the new user configuration can be created with

    # addgnupghome user1 user2 

which will add the respective /home/userX/.gnupg/ and copy the files
from the skeleton directory to it.

Basic keys management
---------------------

Note:Whenever a <user-id> is required in a command, it can be specified
with your key ID, fingerprint, a part of your name or email address,
etc. GnuPG is flexible on this.

> Create key

-   Set stronger algorithms to be used first:

    ~/.gnupg/gpg.conf

    personal-digest-preferences SHA512
    cert-digest-algo SHA512
    default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed

-   Generate a private key by typing in a terminal:

    $ gpg --gen-key

You will be asked several questions. In general, most users will want
both a RSA (sign only) and a RSA (encrypt only) key. It is advised to
use a keysize of 4096 bits (default is 2048).

While having an expiration date for subkeys isn't technically necessary,
it is considered good practice. A period of a year is generally good
enough for the average user. This way even if you lose access to your
keyring, it will allow others to know that it is no longer valid.

> Manage your key

-   Running the gpg --edit-key <user-id> command will present a menu
    which enables you to do most of your key management related tasks.
    Following is an example to set your expiration date:

    $ gpg --edit-key <user-id>
    > key number
    > expire yyyy-mm-dd
    > save
    > quit

Some useful commands:

    > passwd       # change the passphrase
    > clean        # compact any user ID that is no longer usable (e.g revoked or expired)
    > revkey       # revoke a key
    > addkey       # add a subkey to this key

-   Generate an ASCII version of your public key (e.g. to distribute it
    by e-mail):

    $ gpg --armor --output public.key --export <user-id>

-   Register your key with a public PGP key server, so that others can
    retrieve your key without having to contact you directly:

    $ gpg  --keyserver pgp.mit.edu --send-keys <user-id>

-   Sign and encrypt for user Bob

    $ gpg se -r Bob file

-   make a clear text signature

    $ gpg --clearsign file

> Rotating subkeys

Warning:Never delete your expired or revoked subkeys unless you have a
good reason. Doing so will cause you to lose the ability to decrypt
files encrypted with the old subkey. Please only delete expired or
revoked keys from other users to clean your keyring.

If you have set your subkeys to expire after a set time, you will have
to create new ones. Do this a few weeks in advanced to allow others to
update their keyring.

-   Create new subkey (repeat for both signing and encrypting key)

    $ gpg --edit-key <user-id>
    > addkey

And answer the following questions it asks (see previous section for
suggested settings).

-   Save changes

    > save

-   Update it to a keyserver.

    $ gpg  --keyserver pgp.mit.edu --send-keys <user-id>

Note:Revoking expired subkeys is unnecessary and arguably bad form. If
you are constantly revoking keys, it may cause others to lack confidence
in you.

> Import key

-   Import a public key to your public key ring:

    $ gpg --import public.key

-   Import a private key to your secret key ring:

    $ gpg --import private.key

> List keys

-   Keys in your public key ring:

    $ gpg --list-keys

-   Keys in your secret key ring:

    $ gpg --list-secret-keys

Basic usage
-----------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Currently, only  
                           file encryption is       
                           covered. (Discuss)       
  ------------------------ ------------------------ ------------------------

You can use gnupg to encrypt your sensitive documents, but only
individual files at a time.

For example, to decrypt a file, use:

    $ gpg -d secret.tar.gpg

You'll be prompted to enter your passphrase.

If you want to encrypt directories or a whole file-system you should
consider using TrueCrypt, though you can always tarball various files
and then encrypt them.

gpg-agent
---------

Gpg-agent is mostly used as daemon to request and cache the password for
the keychain. This is useful if GnuPG is used from an external program
like a mail client. It can be activated by adding following line in
~/.gnupg/gpg.conf:

    use-agent

This tells GnuPG to use the agent whenever it needs the password.
However, the agent needs to run already. To autostart it, create the
following file and make it executable, and remember to change the
envfile path if you changed your $GNUPGHOME:

    /etc/profile.d/gpg-agent.sh

    if [ $EUID -ne 0 ] ; then
        envfile="$HOME/.gnupg/gpg-agent.env"
        if [[ -e "$envfile" ]] && kill -0 $(grep GPG_AGENT_INFO "$envfile" | cut -d: -f 2) 2>/dev/null; then
            eval "$(cat "$envfile")"
        else
            eval "$(gpg-agent --daemon --enable-ssh-support --write-env-file "$envfile")"
        fi
        export GPG_AGENT_INFO  # the env file does not contain the export statement
        export SSH_AUTH_SOCK   # enable gpg-agent for ssh
    fi

If you don't want gpg-agent to autostart for all users or just want to
keep user daemons in the users own configuration files you can add the
following entry to your .xinitrc:

    eval $(gpg-agent --daemon) &

Log out of your Xsession and log back in. Check if gpg-agent is
activated

    $ pgrep agent

Pinentry

Finally, the agent needs to know how to ask the user for the password.
This can be set in ~/.gnupg/gpg-agent.conf

The default uses a gtk dialog. To change it to ncurses or qt, set the
following in the above file

    pinentry-program /usr/bin/pinentry-curses

or

    pinentry-program /usr/bin/pinentry-qt4

For more options see man gpg-agent and info pinentry.

Keysigning Parties
------------------

To allow users to validate keys on the keyservers and in their keyrings
(i.e. make sure they are from whom they claim to be), PGP/GPG uses a
so-called "Web of Trust". To build this Web of Trust, many hacker events
include keysigning parties.

The Zimmermann-Sassaman key-signing protocol is a way of making these
very effective. Here you'll find a How-To-article.

> Caff

For an easier process of signing keys and sending signatures to the
owners after a keysigning party, you can use the tool 'caff'. It can be
installed from the AUR with the package caff-svn or bundled together
with other useful tools in the package signing-party-svn. Either way,
there will be a lot of dependencies installing from the AUR.
Alternatively you can install them with

    cpanm Any:Moose
    cpanm GnuPG::Interface 

To send the signatures to their owners you need a working MTA. If you
don't have already one, install msmtp.

Smartcards
----------

Note that pcsclite has to be installed and the contained systemd service
has to be running.

    # systemctl start pcscd.service

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

The default pinentry program is pinentry-gtk-2, which needs a DBus
session bus to run properly. See General Troubleshooting#Session
permissions for details.

Alternatively, you can use pinentry-qt. See GnuPG#Pinentry.

> KGpg configuration permissions

There have been issues with kdeutils-kgpg being able to access the
~/.gnupg/ options. One issue might be a result of a deprecated options
file, see the bug report.

Another user reported that KGpg failed to start until the ~/.gnupg
folder is set to drwxr-xr-x permissions. If you require this
work-around, ensure that the directory contents retain -rw-------
permissions! Further, report it as a bug to the developers.

See also
--------

-   The GNU Privacy Handbook
-   A more comprehensive gpg Tutorial

Retrieved from
"https://wiki.archlinux.org/index.php?title=GnuPG&oldid=305213"

Category:

-   Security

-   This page was last modified on 16 March 2014, at 20:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
