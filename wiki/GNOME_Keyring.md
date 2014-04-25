GNOME Keyring
=============

From GnomeKeyring:

GNOME Keyring is a collection of components in GNOME that store secrets,
passwords, keys, certificates and make them available to applications.

Note:Gnome Keyring does not support ECDSA keys. See Bug 641082.

Contents
--------

-   1 Installation
-   2 Manage using GUI
-   3 Use Without GNOME, but with a display manager
-   4 Use Without GNOME and a display manager
-   5 SSH Keys
-   6 Integration with applications
-   7 Gnome Keyring dialog and SSH
-   8 Flushing passphrases
-   9 Gnome Keyring and Git
-   10 Unlock at Startup
-   11 Useful Tools
    -   11.1 gnome-keyring-query

Installation
------------

If you're using GNOME, gnome-keyring got installed automatically as a
part of it. If you're using a different setup, install gnome-keyring
from the official repositories.

Manage using GUI
----------------

    # pacman -S seahorse

It is possible to leave the GNOME keyring password blank or change it.
In seahorse, in the "View" dropdown, select "By Keyring". On the
Passwords tab, right click on "Passwords: login" and pick "Change
password." Enter the old password and leave empty the new password. You
will be warned about using unencrypted storage; continue by pushing "Use
Unsafe Storage."

Use Without GNOME, but with a display manager
---------------------------------------------

Both Slim and LightDM ship with /etc/pam.d/slim or /etc/pam.d/lightdm
preconfigured to unlock keyring upon login. Users no longer need to
modify the file. So the keyring will work out of the box for most cases.
If you are using the keyring to unlock your ssh keys though, make sure
to have ~/.zshenv

     if [ -n "$DESKTOP_SESSION" ];then
       if [ -n "$GNOME_KEYRING_PID" ]; then
         eval $(gnome-keyring-daemon --start --components=ssh)
         export SSH_AUTH_SOCK
       fi
     fi

Use Without GNOME and a display manager
---------------------------------------

It is possible to use GNOME Keyring without the rest of the GNOME
desktop and a display manager. To do this, add the following to your
~/.xinitrc file:

    # Start a D-Bus session
    # Source the below file only if you do not already use the default xinitrc skeleton. 
    # Otherwise you will end up with multiple dbus sessions.
    source /etc/X11/xinit/xinitrc.d/30-dbus
    # Start GNOME Keyring
    eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
    # You probably need to do this too:
    export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

See FS#13986 for more info.

If you experience problems retrieving information from the keyring, make
sure that the variables "DBUS_SESSION_BUS_ADDRESS" and
"DBUS_SESSION_BUS_PID" are exported in the target environment.

Instructions on how to use GNOME Keyring in Xfce are in the SSH Agents
section on that page.

SSH Keys
--------

To add your SSH key:

    $ ssh-add ~/.ssh/id_dsa
    Enter passphrase for /home/mith/.ssh/id_dsa:

To list automatically loaded keys:

    $ ssh-add -L

To disable all keys;

    $ ssh-add -D

Now when you connect to a server, the key will be found and a dialog
will popup asking you for the passphrase. It has an option to
automatically unlock the key when you login. If you check this you will
not need to enter your passphrase again!

Integration with applications
-----------------------------

-   Firefox#GNOME_Keyring_integration

Gnome Keyring dialog and SSH
----------------------------

Run in a terminal, the following:

    $ gnome-keyring-daemon -s

Output will get a few lines, but in reality we are interested,
SSH_AUTH_SOCK, example:

    GNOME_KEYRING_C.................
    SSH_AUTH_SOCK=/run/user/1000/keyring-XXXXXX/ssh
    GPG_AGENT_INF...................

Now you should add to your ~/.bashrc, according to the output of the
previous command, for example:

    SSH_AUTH_SOCK=`ss -xl | grep -o '/run/user/1000/keyring-.*/ssh'`
    [ -z "$SSH_AUTH_SOCK" ] || export SSH_AUTH_SOCK

If you run on your terminal the following:

    $ echo $SSH_AUTH_SOCK

will return something like the following:

    /run/user/1000/keyring--XXXXXX/ssh

Now when you connect with ssh, gnome-keyring dialog will launch the
"entry of the passphrase"

Flushing passphrases
--------------------

       gnome-keyring-daemon -r -d

will start gnome-keyring-daemon and shut down previously running
daemons. Note: if there is no previously running daemons, it'll still
start up.

What's a good way of checking whether it's already running?

Gnome Keyring and Git
---------------------

The Gnome keyring is useful in use with Git when you are pushing over
https. First compile the helper

    $ cd /usr/share/git/credential/gnome-keyring
    # make

Set Git up to use the helper

    $ git config --global credential.helper /usr/share/git/credential/gnome-keyring/git-credential-gnome-keyring

Next time you do a git push, you'll be asked to unlock your keyring

Unlock at Startup
-----------------

GNOME's login manager (gdm) will automatically unlock the keyring once
you log in; for others it is not so easy.

For SLiM, see SLiM#SLiM_and_Gnome_Keyring; For KDM see
KDM#KDM_and_Gnome-keyring

If you are using automatic login, then you can disable the keyring
manager by setting a blank password on the login keyring. Note: your
passwords will be stored unencrypted if you do this.

If you use console based login, automatic unlocking of the keyring can
be achieved by the following changes in /etc/pam.d/login: Add
auth       optional     pam_gnome_keyring.so at the end of the auth
section and
session    optional     pam_gnome_keyring.so        auto_start at the
end of the session section. The result should look similar to this:

    #%PAM-1.0

    auth       required     pam_securetty.so
    auth       requisite    pam_nologin.so
    auth       include      system-local-login
    auth       optional     pam_gnome_keyring.so
    account    include      system-local-login
    session    include      system-local-login
    session    optional     pam_gnome_keyring.so        auto_start

Next, add password	optional	pam_gnome_keyring.so to the end of
/etc/pam.d/passwd. The file should look somewhat like this:

    #%PAM-1.0
    #password	required	pam_cracklib.so difok=2 minlen=8 dcredit=2 ocredit=2 retry=3
    #password	required	pam_unix.so sha512 shadow use_authtok
    password	required	pam_unix.so sha512 shadow nullok
    password	optional	pam_gnome_keyring.so

Note:To use automatic unlocking, the same password for the user account
and the keyring have to be set.

Useful Tools
------------

> gnome-keyring-query

gnome-keyring-query from the AUR provides a simple command-line tool for
querying passwords from the password store of the GNOME Keyring.

Retrieved from
"https://wiki.archlinux.org/index.php?title=GNOME_Keyring&oldid=305472"

Category:

-   GNOME

-   This page was last modified on 18 March 2014, at 16:26.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
