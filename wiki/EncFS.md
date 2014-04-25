EncFS
=====

Related articles

-   Disk Encryption

EncFS is a userspace stackable cryptographic file-system similar to
eCryptfs, and aims to secure data with the minimum hassle. It uses FUSE
to mount an encrypted directory onto another directory specified by the
user. It does not use a loopback system like some other comparable
systems such as TrueCrypt and dm-crypt.

EncFS is definitely the simplest software if you want to try disk
encryption on Linux.

This has a number of advantages and disadvantages compared to these
systems. Firstly, it does not require any root privileges to implement;
any user can create a repository of encrypted files. Secondly, one does
not need to create a single file and create a file-system within that;
it works on existing file-system without modifications.

This does create a few disadvantages, though; because the encrypted
files are not stored in their own file, someone who obtains access to
the system can still see the underlying directory structure, the number
of files, their sizes and when they were modified. They cannot see the
contents, however.

This particular method of securing data is obviously not perfect, but
there are situations in which it is useful.

For more details on how EncFS compares to other disk encryption
solution, see Disk Encryption#Comparison table.

Contents
--------

-   1 Comparison to eCryptFS
-   2 Installation
-   3 Usage
-   4 User friendly mounting
    -   4.1 Mount using Gnome Encfs Manager
    -   4.2 Mount using gnome-encfs
    -   4.3 Mount using CryptKeeper trayicon
    -   4.4 Mount at login using pam_encfs
        -   4.4.1 Single password
        -   4.4.2 /etc/pam.d/
            -   4.4.2.1 login
            -   4.4.2.2 gdm
            -   4.4.2.3 Configuration
    -   4.5 Mount when USB drive with EncFS folders is inserted using
        fsniper
        -   4.5.1 How to
-   5 See Also

Comparison to eCryptFS
----------------------

eCryptFS is implemented in kernelspace and therefore little bit harder
to configure. You have to remember various encryption options (used
cyphers, key type, etc...), in EncFS this is not the case, because EncFS
is storing that information in its signature so you do not have to
remember anything (except the passphrase). The authors of eCryptFS claim
it is faster because there is no overhead caused by context switching
(between kernel and userspace).

Installation
------------

Install the encfs package.

Usage
-----

To create a secured repository, type:

    $ encfs ~/.name ~/name

Note that absolute paths must be used. This will be followed by a prompt
about whether you want to go with the default (paranoid options) or
expert configuration. The latter allows specifying algorithms and other
options. The former is a fairly secure default setup. After entering a
key for the encryption, the encoded file-system will be created and
mounted. The encoded files are stored, in this example, at ~/.name, and
their unencrypted versions in ~/name.

To unmount the file-system, type:

    $ fusermount -u ~/name

To remount the file-system, issue the first command, and enter the key
used to encode it. Once this has been entered, the file-system will be
mounted again.

User friendly mounting
----------------------

> Mount using Gnome Encfs Manager

The Gnome Encfs Manager is an easy to use manager and mounter for encfs
stashes featuring per-stash configuration, Gnome Keyring support, a tray
menu inspired by Cryptkeeper but using the AppIndicator API and lots of
unique features.

The author has created a repo which is more up to date than the AUR
package. Add it to /etc/pacman.conf

     [home_moritzmolch_gencfsm_Arch_Extra]
     SigLevel = Never
     Server = http://download.opensuse.org/repositories/home:/moritzmolch:/gencfsm/Arch_Extra/$arch

     sudo pacman -Sy gnome-encfs-manager

> Mount using gnome-encfs

gnome-encfs integrates EncFS folders into the GNOME desktop by storing
their passwords in the keyring and optionally mounting them at login
using GNOME's autostart mechanism. See
https://bitbucket.org/obensonne/gnome-encfs/. This method has the
advantage that mounting and can automated and the password does not have
to be the same as your user password.

> Mount using CryptKeeper trayicon

Quite simple app, just install cryptkeeper from AUR and add it to your X
session.

> Mount at login using pam_encfs

Install pam_encfs. See also:

-   http://pam-encfs.googlecode.com/svn/trunk/README
-   http://pam-encfs.googlecode.com/svn/trunk/pam_encfs.conf
-   https://wiki.edubuntu.org/EncryptedHomeFolder
-   http://code.google.com/p/pam-encfs/

Single password

Warning:Note that if you will use same password (eg.: using
try_first_pass or use_first_pass) for login and encfs (so encfs will
mount during your login) then you should use SHA password hashes
(Preferably SHA512 with some huge numer of rounds) and (which is most
important) secure password, because hash of your password is probably
stored in unencrypted form in /etc/shadow and it can be cracked in order
to get your encfs password (because it's same as your regular unix login
password).

/etc/pam.d/

Note that when you are using try_first_pass parameter to pam_unix.so
then you will have to set EncFS to use same password as you are using to
login (or vice-versa) and you will be entering just single password.
Without this parameter you will need to enter two passwords.

login

This section tells how to make encfs automount when you're logging in by
virtual terminal.

Note:If you only want to use it through GDM, you may pass this and go
right to the GDM section below.

    #%PAM-1.0

    auth		required	pam_securetty.so
    auth		requisite	pam_nologin.so
    auth		sufficient	pam_encfs.so
    auth		required	pam_unix.so nullok try_first_pass
    #auth		required	pam_unix.so nullok
    auth		required	pam_tally.so onerr=succeed file=/var/log/faillog
    # use this to lockout accounts for 10 minutes after 3 failed attempts
    #auth		required	pam_tally.so deny=2 unlock_time=600 onerr=succeed file=/var/log/faillog
    account		required	pam_access.so
    account		required	pam_time.so
    account		required	pam_unix.so
    #password	required	pam_cracklib.so difok=2 minlen=8 dcredit=2 ocredit=2 retry=3
    #password	required	pam_unix.so md5 shadow use_authtok
    session		required	pam_unix.so
    session		required	pam_env.so
    session		required	pam_motd.so
    session		required	pam_limits.so
    session		optional	pam_mail.so dir=/var/spool/mail standard
    session		optional	pam_lastlog.so
    session		optional	pam_loginuid.so
    -session	optional	pam_ck_connector.so nox11
    #Automatic unmount (optional):
    #session	required	pam_encfs.so

Warning:Note that automatic unmout will process even when there is
another session. eg.: logout on VC can unmout encfs mounted by GDM
session that is still active.

gdm

This section explains how to make encfs automount when you're logging in
by GDM.

Note:For debug purposes you may try automount on virtual console login
first. This article has a section about automount on virtual console
login.

Edit the file /etc/pam.d/gdm-password.

Insert (do not overwrite) the following into the bottom of gdm-password:

    #%PAM-1.0
    auth            requisite       pam_nologin.so
    auth            required        pam_env.so
    auth            sufficient      pam_encfs.so
    auth            required        pam_unix.so try_first_pass
    auth            optional        pam_gnome_keyring.so
    account         required        pam_unix.so
    session         required        pam_limits.so
    session         required        pam_unix.so
    session         optional        pam_gnome_keyring.so auto_start
    password        required        pam_unix.so
    session         required        pam_encfs.so

Save and exit.

Configuration

Edit /etc/security/pam_encfs.conf :

Recommended: comment out the line

    encfs_default --idle=1

This flag will unmount your encrypted folder after 1 minute of
inactivity. If you are automounting this on login, you probably would
like to keep this mounted for as long as you are logged in.

At the bottom, comment any existing demo entries and add:

    #USERNAME       SOURCE                                  TARGET PATH                 ENCFS Options           FUSE Options
    foo             /home/foo/EncryptedFolder             /home/foo/DecryptedFolder       -v                    allow_other

Next, edit /etc/fuse.conf: Uncomment:

    user_allow_other

To test your config, open a new virtual terminal (e.g. Ctrl+Alt+F4) and
login. You should see pam successfuly mount your EncFS folder.

> Mount when USB drive with EncFS folders is inserted using fsniper

Simple method to automount (asking for password) encfs when USB drive
with EncFS one or more folders in root is inserted. We will use fsniper
(filesystem watching daemon using inotify) and git (for askpass binary).

See more at
https://github.com/Harvie/Programs/tree/master/bash/encfs/automount
(latest version of files used in the How to).

How to

1. You need USB automount working for this - like thunar or nautilus
does.  
 2. Make encrypted folder on your drive, eg.:
encfs /media/USB/somename /media/USB/somename.plain (and then unmount
everything).  
 3. Create a ~/.config/fsniper/config file:

    watch {
    	/etc/ {
    		mtab {
    			# %% is replaced with the filename of the new file
    			handler = encfs-automount.sh %%;
    		}
    	}
    }

4. install helper script:

    #!/bin/sh
    #	~/.config/fsniper/scripts/encfs-automount.sh
    # Quick & dirty script for automounting EncFS USB drives
    # TODO:
    #  - Unmounting!!!
    #
    ASKPASS="/usr/lib/git-core/git-gui--askpass"

    lock=/tmp/fsniper_encfs.lock
    lpid=$(cat "$lock" 2>/dev/null) &&
    ps "$lpid" | grep "$lpid" >/dev/null && {
    	echo "Another instance of fsniper_encfs is running"
    	exit;
    }
    echo $BASHPID > "$lock";
    sleep 2;

    echo
    echo ==== EncFS automount script for fsniper ====

    list_mounts() {
    	cat /proc/mounts | cut -d ' ' -f 2
    }

    list_mounts | while read mount; do
    	config="$mount"'/*/.encfs*';
    	echo Looking for "$config"
    	config="$(echo $config)"
    	[ -r "$config" ] && {
    		cyphertext="$(dirname "$config")";
    		plaintext="$cyphertext".plain
    		echo Found config: "$config";
    		echo Trying to mount: "$cyphertext to $plaintext";
    		list_mounts | grep "$plaintext" >/dev/null && {
    			echo Already mounted: "$plaintext"
    		} || {
    			echo Will mount "$cyphertext to $plaintext"
    			"$ASKPASS" "EncFS $cyphertext to $plaintext" | encfs --stdinpass "$cyphertext" "$plaintext"
    		}
    	}
    done
    echo

    rm "$lock" 2>/dev/null

5. Make sure that /usr/lib/git-core/git-gui--askpass is working for you
(that's why you need git package - but you can adjust the helper
script).  
 6. Try fsniper --log-to-stdout in terminal (askpass should appear when
USB drive is inserted).  
 7. Add fsniper --daemon to your session.  
 8. Do not forget to unmount encfs before removing drive.

See Also
--------

-   Security audit of EncFS by Taylor Hornby (January 14, 2014).

Retrieved from
"https://wiki.archlinux.org/index.php?title=EncFS&oldid=301066"

Categories:

-   Security
-   File systems

-   This page was last modified on 24 February 2014, at 06:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
