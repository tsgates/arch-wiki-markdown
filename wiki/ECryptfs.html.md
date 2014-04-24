eCryptfs
========

Related articles

-   Disk Encryption

This article describes basic usage of eCryptfs. It guides you through
the process of creating a private and secure encrypted directory within
your $HOME directory, where you can store all your sensitive files and
private data.

In implementation eCryptfs differs from dm-crypt, which provides a block
device encryption layer, while eCryptfs is an actual file-system – a
stacked cryptographic file system to be exact. For comparison of the two
you can refer to this table.

The summary is that it doesn't require special on-disk storage
allocation effort, such as separate partitions, you can mount eCryptfs
on top of any single directory to protect it. That includes e.g. your
entire $HOME and network file systems (i.e. having encrypted NFS
shares). All cryptographic metadata is stored in the headers of files,
so encrypted data can be easily moved, stored for backup and recovered.
There are other advantages, but there are also drawbacks, for instance
eCryptfs is not suitable for encrypting complete partitions which also
means you can't protect your swap space with it (instead you can combine
it with dm-crypt).

For more details on how eCryptfs compares to other disk encryption
solutions, see Disk Encryption#Comparison table.

Note:The article is currently in the process of being re-structured. If
you can help with the task, that would be great - have a look at the
plan. If you need to find information that might not be in its place
again, the revision before the restructuring is here.

Contents
--------

-   1 Basics
-   2 Preparation
    -   2.1 Deficiencies
    -   2.2 Login password
-   3 Setup & Mounting
    -   3.1 Using the Ubuntu tools
        -   3.1.1 Encrypting a data directory
            -   3.1.1.1 Undo encryption
        -   3.1.2 Encrypting a home directory
        -   3.1.3 Mounting
        -   3.1.4 Auto-mounting
    -   3.2 Using ecryptfs-simple
    -   3.3 Manual setup
        -   3.3.1 With ecryptfs-utils
        -   3.3.2 Without ecryptfs-utils
            -   3.3.2.1 Mounting
            -   3.3.2.2 Auto-mounting
                -   3.3.2.2.1 Optional step
-   4 Usage
    -   4.1 Removal
    -   4.2 Backup
-   5 See Also

Basics
------

See Disk_Encryption#Available_methods for a general introduction to
stacked filesystem encryption, and how it compares to block device
encryption.

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason:                  
                            - Explain the basic     
                           mechanisms & terminology 
                           at the heart of eCryptfs 
                           ("mounting", "FEKEK",    
                           "wrapped passphrase",    
                           etc.) in simple terms    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Preparation
-----------

Before starting to set up disk encryption, there are a few things to
consider and to prepare in advance: Disk_Encryption#Preparation

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason:                  
                            - discuss the 2         
                           real-life set-ups for    
                           which eCryptfs is        
                           especially well suited:  
                           encrypted data directory 
                           and encrypted home       
                           directory                
                            - discuss swap, and     
                           point to                 
                           dm-crypt/Swap_Encryption 
                           for instructions [and    
                           make sure that article   
                           is written in a          
                           self-contained way that  
                           does not assume readers  
                           arrived from other       
                           dm-crypt articles!]      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

> Deficiencies

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: check if the     
                           warning about sparse     
                           files is still           
                           applicable (Discuss)     
  ------------------------ ------------------------ ------------------------

eCryptfs does not handle sparse files well; this should be considered
before encrypting large portions of the directory structure ($HOME, for
example). For most intents and purposes this deficiency does not pose a
problem. Using eCryptfs to encrypt sparse files, however, currently
encrypts the entire allocated space of the sparse file, which, in the
case of big files, can starve the system of resources. (This bug may be
tracked on Launchpad). One popular and inadvisable application of
eCryptfs is to encrypt a BitTorrent download location; this often
requires eCryptfs to handle sparse files of 10 GB or more and may lead
to intense disk starvation. A simple workaround is to place sparse files
in an unencrypted .Public directory (as opposed to the standard eCryptfs
.Private directory, explained below).

> Login password

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Already covered  
                           in                       
                           Disk_Encryption#Preparat 
                           ion,                     
                           which is linked to       
                           above. (Discuss)         
  ------------------------ ------------------------ ------------------------

Note:With shadow 4.1.4.3-3 sha512 is the default for new passwords (see
bug 13591 and corresponding commit).

If you are encrypting your whole home, with auto-mounting you should use
a strong password and consider changing the hash algorithm for
/etc/shadow from md5 to stronger ones like sha512/bcrypt that helps to
protect your password against rainbow-table attacks. See
https://wiki.archlinux.org/index.php/SHA_password_hashes for more
information.

Setup & Mounting
----------------

eCryptfs is a part of Linux since version 2.6.19. But to work with it
you will need the userspace tools provided by the package ecryptfs-utils
available in the Official repositories.

Once you have installed that package you can load the ecryptfs module
and continue with the setup:

    # modprobe ecryptfs

Before we say anything else it's advised that you check the eCryptfs
documentation. It is distributed with a very good and complete set of
manual pages.

> Using the Ubuntu tools

Most of the user-friendly convenience tools installed by the
ecryptfs-utils package assume a very specific eCryptfs setup, namely the
one that is officially used by Ubuntu (where it can be selected as an
option during distro installation). Unfortunately, these choices are not
just default options but are actually hard-coded in the tools, so if
this set-up does not suit your needs then you can't use the convenience
tools and will have to follow the steps at #Manual_setup instead.

The set-up used by these tools is as follows:

+--------------------------------------------------------------------------+
| -   each user can have only one encrypted directory that is managed by   |
|     these tools:                                                         |
|     -   either full $HOME dir encryption...                              |
|     -   or a single encrypted data directory (by default ~/Private/, but |
|         this can be customized).                                         |
| -   the lower directory for each user is always ~/.Private/              |
|     (in the case of full home dir encryption, this will be a symlink to  |
|     the actual location at /home/.ecryptfs/$USER/.Private/)              |
| -   the encryption options used are:                                     |
|     -   cipher: AES                                                      |
|     -   key length: 16 bytes (128 bits)                                  |
|     -   key management scheme: passphrase                                |
|     -   plaintext passthrough: enabled                                   |
| -   the configuration / control info for the encrypted directory is      |
|     stored in a bunch of files at ~/.ecryptfs/:                          |
|     (in the case of full home dir encryption, this will be a symlink to  |
|     the actual location at /home/.ecryptfs/$USER/.ecryptfs/)             |
|     -   Private.mnt [plain text file] - contains the path where the      |
|         upper directory should be mounted (e.g. /home/lucy or            |
|         /home/lucy/Private)                                              |
|     -   Private.sig [plain text file] - contains the signature used to   |
|         identify the mount passphrase in the kernel keyring              |
|     -   wrapped-passphrase [binary file] - the mount passphrase,         |
|         encrypted with the login passphrase                              |
|     -   auto-mount, auto-umount [empty files] - if they exist, the       |
|         pam_ecryptfs.so module will (assuming it is loaded)              |
|         automatically mount/unmount this encrypted directory when the    |
|         user logs in/out                                                 |
+--------------------------------------------------------------------------+

Encrypting a data directory

For a full $HOME directory encryption see #Encrypting a home directory

To encrypt a single data directory as a user, run

    $ ecryptfs-setup-private

and follow the instructions. It will automatically create the
~/.Private/ and ~/.ecryptfs/ directory structures as described in the
box above. It will also ask for two passphrases:

login passphrase
    This is the password you will have to enter each time you want to
    mount the encrypted directory. If you want auto-mounting on login to
    work, it has to be the same password you use to login to your user
    account; otherwise you can choose a different one.

mount passphrase
    This is used to derive the actual file encryption master key. Thus
    you should not enter a custom one unless you know what you are doing
    - instead press Enter to let it auto-generate a random one, which
    will be much more secure. It will be encrypted using the login
    passphrase and stored in this encrypted form in
    ~/.ecryptfs/wrapped-passphrase, and automatically decrypted
    ("unwrapped") again in RAM when needed, so you never have to enter
    it manually. Make sure this file does not get lost, otherwise you
    can never access your encrypted folder again! You may want to run
    ecryptfs-unwrap-passphrase to see the mount passphrase in
    unencrypted form, write it down on a piece of paper, and keep it in
    a safe (or similar), so you can use it to recover your encrypted
    data in case the wrapped-passphrase file is accidentally
    lost/corrupted or in case you forget the login passphrase.

The mount point ("upper directory") for the encrypted folder will be at
~/Private by default, however you can manually change this right after
the setup command has finished running, by doing:

    $ mv ~/Private /path/to/new/folder
    $ echo /path/to/new/folder > ~/.ecryptfs/Private.mnt

To actually use your encrypted folder, you will have to mount it... See
#Mounting below.

Undo encryption

To undo the single directory encryption run

    $ ecryptfs-setup-private --undo

and follow the instructions

Encrypting a home directory

This will set up an encrypted $HOME directory for a user, and take care
of migrating any existing files they have in their not yet encrypted
home directory. Ensure that the user in question owns no processes and
is logged out. You also need to ensure that you have rsync installed.
Once the prerequisites have been met run as root:

    # ecryptfs-migrate-home -u username

and follow the instructions. It is imperative that the user logs in
before the next reboot, to complete the process.

Mounting

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason:                  
                           - explain how to mount   
                           on-demand, using         
                           ecryptfs-mount-private   
                           and                      
                           ecryptfs-umount-private  
                                                    
                            - explain how to mount  
                           from a live-CD, using    
                           ecryptfs-recover-private 
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Auto-mounting

A better way is to use PAM directly, see 'PAM MODULE' in:

    /usr/share/doc/ecryptfs-utils/README

1. Check if ~/.ecryptfs/auto-mount and ~/.ecryptfs/wrapped-passphrase
(these are automatically created by ecryptfs-setup-private) exist.

2. Add ecryptfs to the pam-stack exactly as following to allow
transparent unwrapping of the passphrase on login.

Open /etc/pam.d/system-auth and add this after the line containing auth
required pam_unix.so [...]:

    auth	required	pam_ecryptfs.so unwrap

, then add this above the line containing password required pam_unix.so
[...]:

    password	optional	pam_ecryptfs.so

, and this after the line session required pam_unix.so:

    session	optional	pam_ecryptfs.so

3. Relogin (you need to type the user's password for obvious reason ;)
and check output of mount which should now contain a mountpoint, e.g.:

    /home/$USER/.Private on /home/$USER/Private type ecryptfs (...)

Your user's encrypted directory should be perfectly readable, e.g.
$HOME/Private/

Note that the latter will be automatically unmounted and made
unavailable when the user log off.

* * * * *

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Does the         
                           following provide any    
                           useful information that  
                           isn't already contained  
                           in the top part of this  
                           section? Do we really    
                           need a full copy of all  
                           those PAM files here?    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

To use the eCryptfs PAM module it self for mounting you should know it
depends on some hard-coded Ubuntu defaults. Like using AES cipher with a
16 byte key. As described in this BBS post [1] you have to do the
following steps:

1) For your understanding and preparation, read the guide mentioned
above. [2]

2) Install keyutils and ecryptfs-utils from the official Repos.

[Do the following steps as root!]

3) Make a "ecryptfs" Group:

    groupadd ecryptfs

4) Add the user to it:

    usermod -aG ecryptfs user

5) Load the ecryptfs module

    modprobe ecryptfs

6) Change your /etc/pam.d/system-auth to look something like this (lines
to add are bold):

    #%PAM-1.0

    auth      required  pam_env.so
    auth      required  pam_unix.so     try_first_pass nullok
    auth      required  pam_ecryptfs.so unwrap
    auth      optional  pam_permit.so

    account   required  pam_unix.so
    account   optional  pam_permit.so
    account   required  pam_time.so

    password  required  pam_ecryptfs.so
    password  required  pam_unix.so     try_first_pass nullok sha512 shadow
    password  optional  pam_permit.so

    session   required  pam_ecryptfs.so unwrap
    session   required  pam_limits.so
    session   required  pam_env.so
    session   required  pam_unix.so
    session   optional  pam_permit.so

  
 6a) When using GDM < 3.2 to log in, edit /etc/pam.d/gdm like this:

    #%PAM-1.0
    auth            requisite       pam_nologin.so
    auth            required        pam_env.so
    auth            required        pam_unix.so
    auth            optional        pam_ecryptfs.so unwrap
    auth            optional        pam_gnome_keyring.so
    account         required        pam_unix.so
    session         required        pam_limits.so
    session         required        pam_unix.so
    session         optional        pam_ecryptfs.so unwrap
    session         optional        pam_gnome_keyring.so auto_start
    password        required        pam_unix.so
    password        optional        pam_ecryptfs.so

6b) For GDM >= 3.2, make the following changes to
/etc/pam.d/gdm-password (thanks to grawity for this):

    #%PAM-1.0
    auth            requisite       pam_nologin.so
    auth            required        pam_env.so
    auth            requisite       pam_unix.so nullok
    auth            optional        pam_ecryptfs.so unwrap
    auth            optional        pam_gnome_keyring.so
    auth            sufficient      pam_succeed_if.so uid >= 1000 quiet
    auth            required        pam_deny.so
    account         required        pam_unix.so
    password        required        pam_unix.so
    password        optional        pam_ecryptfs.so
    session         required        pam_loginuid.so
    -session        optional        pam_systemd.so
    session         optional        pam_keyinit.so force revoke
    session         required        pam_limits.so
    session         required        pam_unix.so
    session         optional        pam_ecryptfs.so unwrap
    session         optional        pam_gnome_keyring.so auto_start

6c) For KDM, make the following changes to /etc/pam.d/kde:

    #%PAM-1.0
    auth            required        pam_unix.so
    auth            optional        pam_ecryptfs.so unwrap
    auth            required        pam_nologin.so
    account         required        pam_unix.so
    password        optional        pam_ecryptfs.so
    password        required        pam_unix.so
    session         required        pam_unix.so
    session         optional        pam_ecryptfs.so unwrap
    session         required        pam_limits.so

6d) For LXDM, make the following changes to /etc/pam.d/lxdm:

    #%PAM-1.0
    auth            requisite       pam_nologin.so
    auth            required        pam_env.so
    auth            required        pam_unix.so
    auth            optional        pam_ecryptfs.so unwrap
    account         required        pam_unix.so
    session         required        pam_limits.so
    session         required        pam_unix.so
    session         optional        pam_ecryptfs.so unwrap
    password        required        pam_unix.so
    password        optional        pam_ecryptfs.so

6e) For LightDM, make the following changes to /etc/pam.d/lightdm

    #%PAM-1.0
    auth      required pam_nologin.so
    auth      required pam_env.so
    auth      required pam_unix.so
    auth      optional pam_ecryptfs.so unwrap
    account   required pam_unix.so
    password  optional pam_ecryptfs.so
    password  required pam_unix.so
    session   required pam_unix.so
    session   optional pam_ecryptfs.so unwrap

7) To be able to automatically mount your encrypted home directory on
login using SSH, edit /etc/pam.d/sshd:

    #%PAM-1.0
    #auth           required        pam_securetty.so        #Disable remote root
    auth            required        pam_unix.so
    auth            optional        pam_ecryptfs.so unwrap
    auth            required        pam_env.so
    account         required        pam_nologin.so
    account         required        pam_unix.so
    account         required        pam_time.so
    password        required        pam_unix.so
    password        optional        pam_ecryptfs.so
    session         optional        pam_ecryptfs.so unwrap
    session         required        pam_unix_session.so
    session         required        pam_limits.so
    session         optional        pam_ck_connector.so nox11

9) Log in and check if everything worked correctly.

This is a working solution and ecryptfs is exactly used as in Ubuntu
(10.04/10.10) - and is easy to set up. Besides this, it has the
advantage of auto-unmount at log-out, which shell profile files (i.e.
~/.bash_logout) could have trouble doing, because there could still be
open file-descriptors by the shell at the time of umount. To encrypt
swap, see: Dm-crypt/Swap_Encryption (some of the tools provided by
ecryptfs, such as ecryptfs-setup-swap, only work in ubuntu).

> Using ecryptfs-simple

Use ecryptfs-simple if you just want to use eCryptfs to mount arbitrary
directories the way you can with EncFS. ecryptfs-simple does not require
root privileges or entries in fstab, nor is it limited to hard-coded
directories such as ~/.Private. The package is available in the AUR and
in Xyne's repos.

As the name implies, usage is simple:

    # simple mounting
    ecryptfs-simple /path/to/foo /path/to/bar

    # automatic mounting: prompts for options on the first mount of a directory then reloads them next time
    ecryptfs-simple -a /path/to/foo /path/to/bar

    # unmounting by source directory
    ecryptfs-simple -u /path/to/foo

    # unmounting by mountpoint
    ecryptfs-simple -u /path/to/bar

> Manual setup

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason:                  
                            - fully explain how to  
                           set up an encrypted data 
                           directory or home        
                           directory using          
                           mount.ecryptfs and       
                           ecryptfs-wrap-passphrase 
                                                    
                            - this section should   
                           be more generic &        
                           comprehensive than it is 
                           now, and possibly be     
                           split into additional    
                           subsections (Discuss)    
  ------------------------ ------------------------ ------------------------

With ecryptfs-utils

Alternatively to using the scripts ecryptfs-setup-private and
ecryptfs-mount-private to setup and mount eCryptfs, the same can be done
directly with the binaries (which those scripts use)
ecryptfs-add-passphrase and mount.ecryptfs_private from the package
ecryptfs-utils. Those binaries require no root privileges to work, by
default.

First choose an ALIAS as you like. Through this section, ALIAS will be
secret. Create the required directories/files:

    $ mkdir ~/.secret ~/secret ~/.ecryptfs
    $ touch ~/.ecryptfs/secret.conf ~/.ecryptfs/secret.sig

The ~/.secret directory will hold the encrypted data. The ~/secret
directory is the mount point where ~/.secret will be mounted as an
ecryptfs filesystem.

In the next command, replace USER with the name of the current user's
home directory. Note that you should write full paths to
~/.ecryptfs/secret.conf. Its format looks like the one of /etc/fstab
without the mount options:

    $ echo "/home/USER/.secret /home/USER/secret ecryptfs" > ~/.ecryptfs/secret.conf

A mount passphrase must be added to the keyring:

    $ ecryptfs-add-passphrase
    Passphrase: 
    Inserted auth tok with sig [78c6f0645fe62da0] into the user session keyring

Write the output signature (ecryptfs_sig) from the previous command to
~/.ecryptfs/secret.sig:

    $ echo 78c6f0645fe62da0 > ~/.ecryptfs/secret.sig

A second passphrase for filename encryption may be used. If you choose
so, add it to the keyring:

    $ ecryptfs-add-passphrase
    Passphrase: 
    Inserted auth tok with sig [326a6d3e2a5d444a] into the user session keyring

If you run the command above, append its output signature
(ecryptfs_fnek_sig) to ~/.ecryptfs/secret.sig:

     $ echo 326a6d3e2a5d444a >> ~/.ecryptfs/secret.sig

Finally, to mount ~/.secret on ~/secret:

    $ mount.ecryptfs_private secret

An ecryptfs filesystem will be mounted with the following options:

    rw,nosuid,nodev,relatime,ecryptfs_fnek_sig=326a6d3e2a5d444a,ecryptfs_sig=78c6f0645fe62da0,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_unlink_sigs

Except for ecryptfs_sig and ecryptfs_fnek_sig, the options are
hard-coded. ecryptfs_fnek_sig will exist only if you choose filename
encryption.

To unmount ~/.secret:

    $ umount.ecryptfs_private secret

Without ecryptfs-utils

The ecryptfs-utils package is distributed with a few helper scripts
which will help you with key management and similar tasks. Some were
written to automate this whole process of setting up encrypted
directories (ecryptfs-setup-private) or help you combine eCryptfs with
dm-crypt to protect swap space (ecryptfs-setup-swap). Despite those
scripts we will go trough the process manually so you get a better
understanding of what is really being done.

First create your private directories, in this example we will call them
exactly that: Private

    $ su -
    # mkdir -m 700 /home/username/.Private
    # mkdir -m 500 /home/username/Private
    # chown username:username /home/username/{.Private,Private}

Let's summarize

-   Actual encrypted data will be stored in ~/.Private directory
    (so-called lower directory)
-   While mounted, decrypted data will be available in ~/Private
    directory (so-called upper directory)
    -   While not mounted nothing can be written to this directory
    -   While mounted it has the same permissions as the lower directory

eCryptfs can now be mounted on top of ~/Private.

    # mount -t ecryptfs /home/username/.Private /home/username/Private

You will need to answer a few questions and provide a passphrase which
should be used to mount this directory in the future. However you can
also have different keys encrypting different data (more about this
below). For convenience we will limit this guide to only one key and
passphrase. Let's see an example:

    Key type: passphrase
    Passphrase: ThisIsAVeryWeakPassphrase
    Cipher: aes
    Key byte: 16
    Plaintext passtrough: no
    Filename encryption: no
    Add signature to cache: yes 

Let's summarize

-   The passphrase is your mount passphrase which will be salted, hashed
    and loaded into the kernel keyring.
    -   In eCryptfs terms, this salted, hashed passphrase is your "file
        encryption key, encryption key", or fekek.
-   eCryptfs supports a few different ciphers (AES, blowfish,
    twofish...). You can read about them on Wikipedia.
-   Plaintext passtrough enables you to store and work with un-encrypted
    files stored in the lower directory.
-   Filename encryption is available since Linux 2.6.29
    -   In eCryptfs terms the key used to protect filenames is known as
        "filename encryption key", or fnek.
-   The signature of the key(s) will be stored in
    /root/.ecryptfs/sig-cache.txt.

Since our later goal is to be able to mount without root privileges, we
will now move the eCryptfs configuration directory to your own home and
transfer the ownership to you:

    # mv /root/.ecryptfs /home/username
    # chown username:username /home/username/.ecryptfs

Your setup is now complete and directory is mounted. You can place any
file in the ~/Private directory and it will get encrypted in ~/.Private.

Now copy a few files to your new private directory, and then un-mount
it. If you inspect the files you will see that they are unreadable –
encrypted. That was cool you say, but how do I get them back... and that
brings us to:

* * * * *

Above is detailed the simplest way to setup the mount point, but
ecryptfs-setup-private runs through some extra steps.

-   The above mount passphrase is derived from the passphrase you type
    in. This is not considered very secure, so the setup script grabs
    some characters from /dev/random for safety:

    od -x -N $bytes --width=$bytes /dev/urandom | head -n 1 | sed "s/^0000000//" | sed "s/\s*//g"

-   ecryptfs-setup-private also takes the resulting mount passphrase and
    wraps it with your login passphrase (pasword) and stores this in
    ~/.ecryptfs/wrapped-passphrase. You can replicate this with:

    $ ecryptfs-wrap-passphrase ~/.ecryptfs/wrapped-passphrase 
      Passphrase to wrap: 
      Wrapping passphrase:

Mounting

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason:                  
                            - fully explain how to  
                           mount on-demand, using   
                           ecryptfs-add-passphrase  
                           and mount.ecryptfs       
                            - this section should   
                           be more generic &        
                           comprehensive than it is 
                           now (Discuss)            
  ------------------------ ------------------------ ------------------------

Whenever you need your files available you can repeat the above mount
procedure, using the same passphrase and options if you want to access
your previously encrypted files or using a different passphrase (and
possibly options) if for some reason you want to have different keys
protecting different data (imagine having a publicly shared directory
where different data is encrypted by different users, and their keys).

In any case going trough those questions every time could be a bit
tedious.

One solution would be to create an entry in the /etc/fstab file for this
mount point:

    /home/user/.Private /home/user/Private ecryptfs [... user ... ecryptfs_sig=XY,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_unlink_sigs 0 0

-   You will notice that we defined the user option, it enables you to
    mount the directory as a user (if it does not works as a normal
    user, you may need to setuid mount.ecryptfs by running as root:
    chmod +s /sbin/mount.ecryptfs)
-   Notice the ecryptfs_sig option, replace XY with your own key
    signature (as seen in the mtab line earlier and in sig-cache.txt)
-   If you enabled filename encryption then pass an additional mount
    option: ecryptfs_fnek_sig=XY, where XY is the same signature you
    provide with the ecryptfs_sig option.
-   Last option ecrypfs_unlink_sigs ensures that your keyring is cleared
    every time the directory is un-mounted

Since your key was deleted from the kernel keyring when you un-mounted,
in order to mount you need to insert it into the keyring again. You can
use the ecryptfs-add-passphrase utility or the ecryptfs-manager to do
it:

When the key is inserted you can mount the directory:

    $ ecryptfs-add-passphrase
      Passphrase: ThisIsAVeryWeakPassphrase

    $ mount -i /home/username/Private

You will notice that we used the -i option this time. It disables
invoking the mount helper. Speaking of which, using -i by default mounts
with: nosuid, noexec and nodev. If you want to have at least executable
files in your private directory you can add the exec option to the fstab
line.

This would be a good place to mention the keyctl utility from the
(earlier installed) keyutils package. It can be used for any advanced
key management tasks. Following examples show how to list your keyring
contents and how to clear them:

    $ keyctl list @u
    $ keyctl clear @u

Note:However, one should remember that /etc/fstab is for system-wide
partitions only and should not be used for user-specific mounts

Auto-mounting

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason:                  
                           - this section should be 
                           more generic &           
                           comprehensive than it is 
                           now                      
                            - make sure it properly 
                           fits in with the article 
                           structure (Discuss)      
  ------------------------ ------------------------ ------------------------

The above "eCryptfs and $HOME" article uses a shell init file to mount
the home directory. The same can be done using pam_mount with the added
benefit that home is un-mounted when all sessions are logged out. Add
the following lines to /etc/security/pam_mount.conf.xml:

    <luserconf name=".pam_mount.conf.xml" />
    <mntoptions require="" /> 
    <lclmount>mount -i %(VOLUME) "%(before=\"-o\" OPTIONS)"</lclmount> 

Please prefer writing manually these lines instead of simply
copy/pasting them (especially the lclmount line), otherwise you might
get some corrupted characters. Explanation:

-   the first line indicates where the user-based configuration file is
    located (here ~/.pam_mount.conf.xml) ;
-   the second line overwrites the default required mount options which
    are unnecessary ("nosuid,nodev") ;
-   the last line indicates which mount command to run (eCryptfs needs
    the -i switch).

Then set the volume definition, preferably to ~/.pam_mount.conf.xml:

    <pam_mount>
        <volume noroot="1" fstype="ecryptfs" path="/home/.ecryptfs/user/.Private/" mountpoint="/home/user/"/>
    </pam_mount>

"noroot" is needed because the encryption key will be added to the
user's keyring

Finally, edit /etc/pam.d/login as described in pam_mount's article.

Optional step

To avoid wasting time needlessly unwrapping the passphrase you can
create a script that will check pmvarrun to see the number of open
sessions:

    #!/bin/sh
    #
    #    /usr/local/bin/doecryptfs

    exit $(/usr/sbin/pmvarrun -u$PAM_USER -o0)

With the following line added before the eCryptfs unwrap module in your
PAM stack:

    auth    [success=ignore default=1]    pam_exec.so     quiet /usr/local/bin/doecryptfs
    auth    required                      pam_ecryptfs.so unwrap

The article suggests adding these to /etc/pam.d/login, but the changes
will need to be added to all other places you login, such as
/etc/pam.d/kde.

Usage
-----

+--------------------------+--------------------------+--------------------------+
| [Tango-view-fullscreen.p | This article or section  | [Tango-view-fullscreen.p |
| ng]                      | needs expansion.         | ng]                      |
|                          | Reason:                  |                          |
|                          |  - point to the above    |                          |
|                          | "Setup & Mounting"       |                          |
|                          | section for how to mount |                          |
|                          | and unmount [this        |                          |
|                          | section here will cover  |                          |
|                          | all other (i.e.          |                          |
|                          | setup-independent) usage |                          |
|                          | info]                    |                          |
|                          | - explain how to         |                          |
|                          | interact with encrypted  |                          |
|                          | files using              |                          |
|                          | ecryptfs-stat,           |                          |
|                          | ecryptfs-find,           |                          |
|                          | ecryptfs-rewrite-file    |                          |
|                          |  - discuss symlinking    |                          |
|                          | into the encrypted       |                          |
|                          | container                |                          |
|                          |  - discuss placing       |                          |
|                          | non-encrypted files or   |                          |
|                          | folders in the encrypted |                          |
|                          | container                |                          |
|                          | ("pass-through")         |                          |
|                          |  - discuss backup        |                          |
|                          | strategies               |                          |
|                          |                          |                          |
|                          | (Discuss)                |                          |
+--------------------------+--------------------------+--------------------------+

Besides using your private directory as storage for sensitive files, and
private data, you can also use it to protect application data. Take
Firefox for an example, not only does it have an internal password
manager but the browsing history and cache can also be sensitive.
Protecting it is easy:

     $ mv ~/.mozilla ~/Private/mozilla
     $ ln -s ~/Private/mozilla ~/.mozilla

> Removal

If you want to move a file out of the private directory just move it to
it's new destination while ~/Private is mounted. Also note that there
are no special steps involved if you want to remove your private
directory. Make sure it is un-mounted and delete ~/.Private, along with
all the files.

> Backup

Setup explained here separates the directory with encrypted data from
the mount point, so the encrypted data is available for backup at any
time. With an overlay mount (i.e. ~/Secret mounted over ~/Secret) the
lower, encrypted, data is harder to get to. Today when cronjobs and
other automation software do automatic backups the risk of leaking your
sensitive data is higher.

We explained earlier that all cryptographic metadata is stored in the
headers of files. You can easily do backups, or incremental backups, of
your ~/.Private directory, treating it like any other directory.

See Also
--------

-   Security audit of eCryptfs by Taylor Hornby (January 22, 2014).

  

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Regardless of    
                           what some blog author    
                           thinks, this wiki should 
                           strive to treat the      
                           topic of disk encryption 
                           with eCryptfs            
                           comprehensively (within  
                           reasonable limits of     
                           course). If there are    
                           multiple good options at 
                           any particular step,     
                           then multiple options    
                           should be listed. Once   
                           this wiki page will have 
                           achieved that goal, the  
                           following should be      
                           deleted (or replaced by  
                           a plain "See Also" link  
                           list.) (Discuss)         
  ------------------------ ------------------------ ------------------------

This wiki article covers only the basic setup of a private encrypted
directory. There is however another article about eCryptfs on Arch
Linux, which covers encryption of your entire $HOME and encrypting swap
space without breaking hibernation (suspend to disk).

That article includes many more steps (i.e. using PAM modules and
automatic mounting) and the author was opposed to replicating it here,
because there is just no single "right" way to do it. The author
proposes some solutions and discusses the security implications, but
they are his solutions and as such might not be the best nor are they
endorsed by the eCryptfs project in any way.

    Article: eCryptfs and $HOME by Adrian C. (anrxc).

Consider that Chromium OS, as released by Google, is using eCryptfs to
protect devices that are, and will be, powered by it. Some
implementation details are available and they make excellent reading.
You can read them here, they could help a lot as you're coming up with
your own strategy.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ECryptfs&oldid=304941"

Categories:

-   Security
-   File systems

-   This page was last modified on 16 March 2014, at 09:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
