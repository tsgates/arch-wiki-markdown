dm-crypt/Device Encryption
==========================

Back to Dm-crypt.

This section covers how to manually utilize dm-crypt from the command
line to encrypt a system.

Contents
--------

-   1 Preparation
-   2 Cryptsetup usage
    -   2.1 Cryptsetup passphrases and keys
-   3 Encryption options with dm-crypt
    -   3.1 Encryption options for LUKS mode
    -   3.2 Encryption options for plain mode
-   4 Encrypting devices with cryptsetup
    -   4.1 Encrypting devices with LUKS mode
        -   4.1.1 Using LUKS to Format Partitions with a Keyfile
    -   4.2 Encrypting devices with plain mode
-   5 Opening and closing an encrypted partition with cryptsetup
-   6 Cryptsetup actions specific for LUKS
    -   6.1 Key management
        -   6.1.1 Adding LUKS keys
        -   6.1.2 Removing LUKS keys
    -   6.2 Backup and restore
        -   6.2.1 Backup using cryptsetup
        -   6.2.2 Restore using cryptsetup
        -   6.2.3 Manual backup and restore
-   7 Cryptsetup and keyfiles
    -   7.1 Storing the Key File
        -   7.1.1 External Storage on a USB Drive
            -   7.1.1.1 Preparation for Persistent block device naming
            -   7.1.1.2 Persistent symlinks
            -   7.1.1.3 Persistent udev rule
        -   7.1.2 Generating the keyfile
        -   7.1.3 Storing the keyfile
        -   7.1.4 Configuration of initcpio
        -   7.1.5 Storing the key as a plain (visible) file

Preparation
-----------

Before using cryptsetup, always make sure the dm-crypt kernel module is
loaded.

Cryptsetup usage
----------------

Cryptsetup is the command line tool to interface with dm-crypt for
creating, accessing and managing encrypted devices. The tool was later
expanded to support different encryption types that rely on the Linux
kernel device-mapper and the cryptographic modules. The most notable
expansion was for the Linux Unified Key Setup (LUKS) extension, which
stores all of the needed setup information for dm-crypt on the disk
itself and abstracts partition and key management in an attempt to
improve ease of use. Devices accessed via the device-mapper are called
blockdevices. See Disk_encryption#Block_device_encryption for further
information.

The tool is used as follows:

    # cryptsetup <OPTIONS> <action> <action-specific> <device> <dmname>

It has compiled-in defaults for the options and the encryption mode,
which will be used if no others are specified on the command line. Have
a look at

    $ cryptsetup --help 

which lists options, actions and the default parameters for the
encryption modes in that order. A full list of options cryptsetup
accepts can be found in the manpage. Since different parameters are
required or optional, depending on encryption mode and action, the
following sections point out differences further. Blockdevice encryption
is fast, but speed matters a lot too. Since changing an encryption
cipher of a blockdevice after setup is delicate, it is important to
check dm-crypt performance for the individual system before setup:

    $ cryptsetup benchmark 

can give guidance on deciding for an algorithm and key-size prior to
installation. If certain AES ciphers excel with a considerable (e.g.
tenfold) higher throughput, these are probably the ones with hardware
support in the CPU.

Tip:You may want to practise encrypting a virtual hard drive in a
virtual machine when learning.

> Cryptsetup passphrases and keys

An encrypted blockdevice is protected by a key. A key is either a:

-   Passphrase, see Disk_encryption#Choosing_a_strong_passphrase
-   Keyfile, see #Cryptsetup and keyfiles

Both key types have default maximum sizes: A passphrase can be up to 512
characters and a keyfile can have 8192kB.

An important distinction of LUKS to note at this point is that the key
is used to unlock the master-key of a LUKS-encrypted device and can be
changed with root access. Other encryption modes do not support changing
the key after setup, because they do not employ a master-key for the
encryption. See Disk_encryption#Block_device_encryption for details.

Encryption options with dm-crypt
--------------------------------

Cryptsetup supports different encryption operating modes to use with
dm-crypt. The most common (and default) is

-   --type LUKS

The other ones are

-   --type plain for using dm-crypt plain mode,
-   --type loopaes for a loopaes legacy mode, and
-   --type tcrypt for a Truecrypt compatibility mode.

The basic cryptographic options for encryption cipher and hashes
available can be used for all modes and rely on the kernel cryptographic
backend features. All that are loaded at runtime can be viewed with

    $ less /proc/crypto 

and are available to use as options. If the list is short, execute
cryptsetup benchmark which will trigger loading available modules.

The following introduces encryption options for the first two modes.
Note that the tables list options used in the respective examples in
this article and not all available ones.

> Encryption options for LUKS mode

The cryptsetup action to set up a new dm-crypt device in LUKS encryption
mode is luksFormat. Unlike the name implies, it does not format the
device, but sets up the LUKS device header and encrypts the master-key
with the desired cryptographic options.

As LUKS is the default encryption mode:

    # cryptsetup -v luksFormat <device>

is all needed to perform it with default parameters (-v optional). For
comparison, we can specify the default options manually too:

    # cryptsetup -v --cipher aes-xts-plain64 --key-size 256 --hash sha1 --iter-time 1000 --use-urandom --verify-passphrase luksFormat <device> 

These options used are compared below in the left column, with another
set in the right column:

Options

Cryptsetup (1.6.2) defaults

Example

Comment

--cipher, -c

aes-xts-plain64

aes-xts-plain64

The example uses the same cipher as the default: the AES-cipher with
XTS.

--key-size, -s

256

512

The default uses a 256 bit key-size. XTS splits the supplied key into
fraternal twins. For an effective AES-256 the XTS key-size must be 512.

--hash, -h

sha1

sha512

Hash algorithm used for PBKDF2. Due to this processing, SHA1 is
considered adequate as of January 2014.

--iter-time, -i

1000

5000

Number of milliseconds to spend with PBKDF2 passphrase processing. Using
a hash stronger than sha1 results in less iterations if iter-time is not
increased.

--use-random

--use-urandom

--use-random

/dev/urandom is used as randomness source for the (long-term) volume
master key. Avoid generating an insecure master key if low on entropy.
The last three options only affect the encryption of the master key and
not the disk operations.

--verify-passphrase, -y

Yes

-

Default only for luksFormat and luksAddKey. No need to type for Arch
Linux with LUKS mode at the moment.

The options used in the example column result in the following:

    # cryptsetup -v --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 5000 --use-random luksFormat <device>

Please note that with release 1.6.0, the defaults have changed to an AES
cipher in XTS mode. It is advised against using the previous default
--cipher aes-cbc-essiv, because of its known issues and practical
attacks against them.

> Encryption options for plain mode

In dm-crypt plain mode, there is no master-key on the device, hence,
there is no need to set it up. Instead the encryption options to be
employed are used directly to create the mapping between an encrypted
disk and a named device. The mapping can be created against a partition
or a full device. In the latter case not even a partition table is
needed.

To create a plain mode mapping with cryptsetup's default parameters:

    # cryptsetup <options> open --type plain <device> <dmname>

Executing it will prompt for a password, which should have very high
entropy. Below a comparison of default parameters with the example in
Dm-crypt/Encrypting_an_entire_system#Plain dm-crypt

Option

Cryptsetup defaults (1.6.2)

Example

Comment

--hash

ripemd160

sha512

The hash is used to create the key from the passphrase or keyfile

--cipher

aes-cbc-essiv:sha256

twofish-xts-plain64

The cipher consists of three parts: cipher-chainmode-IV generator.
Please see Disk_Encryption#Ciphers_and_modes_of_operation for an
explanation of these settings, and the DMCrypt documentation for some of
the options available.

--key-size

256bits

512

The key size (in bits). The size will depend on the cipher being used
and also the chainmode in use. Xts mode requires twice the key size of
cbc.

--offset

0

0

The offset from the beginning of the target disk from which to start the
mapping

--key-file

default uses a passphrase

/dev/sdZ (or e.g. /boot/keyfile.enc)

The device or file to be used as a key. See here for further details.

--keyfile-offset

0

0

Offset from the beginning of the file where the key starts (in bytes).

--keyfile-size

8192kB

- (default applies)

Limits the bytes read from the key file.

Using the device /dev/sdX, the above right column example results in:

    # cryptsetup --hash=sha512 --cipher=twofish-xts-plain64 --offset=0 --key-file=/dev/sdZ --key-size=512 open --type=plain /dev/sdX enc

Unlike encrypting with LUKS, the above command must be executed in full
whenever the mapping needs to be re-established, so it is important to
remember the cipher, hash and key file details. We can now check that
the mapping has been made:

    # fdisk -l

An entry should now exist for /dev/mapper/enc.

Encrypting devices with cryptsetup
----------------------------------

This section shows how to employ the options for creating new encrypted
blockdevices and accessing them manually.

> Encrypting devices with LUKS mode

Formatting LUKS Partitions

In order to setup a partition as an encrypted LUKS partition execute:

    # cryptsetup -c <cipher> -y -s <key size> luksFormat /dev/<partition name>

    Enter passphrase: <password>
    Verify passphrase: <password>

first to setup the encrypted master-key. Checking results can be done
with:

    # cryptsetup luksDump /dev/<drive>

This should be repeated for all partitions to be encrypted (except for
/boot). You will note that the dump not only shows the cipher header
information, but also the key-slots in use for the LUKS partition.

The following example will create an encrypted root partition using the
AES cipher in XTS mode with an effective 256-bit encryption

    # cryptsetup -c aes-xts-plain -y -s 512 luksFormat /dev/sda3

Unlocking/Mapping LUKS Partitions with the Device Mapper

Once the LUKS partitions have been created it is time to unlock them.

The unlocking process will map the partitions to a new device name using
the device mapper. This alerts the kernel that /dev/<partition name> is
actually an encrypted device and should be addressed through LUKS using
the /dev/mapper/<name> so as not to overwrite the encrypted data. To
guard against accidental overwriting, read about the possibilities to
backup the cryptheader after finishing setup.

In order to open an encrypted LUKS partition execute:

    # cryptsetup open --type luks /dev/<partition name> <device-mapper name>

    Enter any LUKS passphrase: <password>
    key slot 0 unlocked.
    Command successful.

Usually the device mapped name is descriptive of the function of the
partition that is mapped, example:

    # cryptsetup open --type luks /dev/sda3 root 

Once opened, the root partition device address would be /dev/mapper/root
instead of the partition (e.g. /dev/sda3).

    # cryptsetup open --type luks /dev/sda3 lvmpool 

For setting up LVM ontop the encryption layer the device file for the
decrypted volume group would be anything like /dev/mapper/lvmpool
instead of /dev/sda3. LVM will then give additional names to all logical
volumes created, e.g. /dev/mapper/lvmpool-root and
/dev/mapper/lvmpool-swap.

In order to write encrypted data into the partition it must be accessed
through the device mapped name. The first step of access will typically
be to create a filesystem

    # mkfs -t ext4 /dev/mapper/root

and mount it

    # mount -t ext4 /dev/mapper/root /mnt

The mounted blockdevice can then be used like any other partition. Once
done, closing the device locks it again

    # umount /mnt
    # cryptsetup close root

Using LUKS to Format Partitions with a Keyfile

When creating a new LUKS encrypted partition, a keyfile may be
associated with the partition on its creation using:

    # cryptsetup -c <desired cipher> -s <key size> luksFormat /dev/<volume to encrypt> /path/to/mykeyfile

This is accomplished by appending the bold area to the standard
cryptsetup command which defines where the keyfile is located.

See #Cryptsetup and keyfiles for instructions on how to generate and
manage keyfiles.

> Encrypting devices with plain mode

The creation and subsequent access of a dm-crypt plain mode encryption
both require not more than using the cryptsetup open action with correct
parameters. The following shows that with two examples of non-root
devices, but adds a quirk by stacking both (i.e. the second is created
inside the first). Obviously, stacking the encryption doubles overhead.
The usecase here is simply to illustrate another example of the cipher
option usage.

A first mapper is created with cryptsetup's plain-mode defaults, as
described in the table's left column above

    # cryptsetup --type plain -v open /dev/sdaX plain1 
    Enter passphrase: 
    Command successful.
    # 

Now we add the second blockdevice inside it, using different encryption
parameters and with an (optional) offset, create a filesystem and mount
it

    # cryptsetup --type plain --cipher=serpent-xts-plain64 --hash=sha256 --key-size=256 --offset=10  open /dev/mapper/plain1 plain2
    Enter passphrase: 
    # lsblk -p   
    NAME                                                     
    /dev/sda                                     
    ├─/dev/sdaX          
    │ └─/dev/mapper/plain1     
    │   └─/dev/mapper/plain2              
    ...
    # mkfs -t ext2 /dev/mapper/plain2
    # mount -t ext2 /dev/mapper/plain2 /mnt
    # echo "This is stacked. one passphrase per foot to shoot." > /mnt/stacked.txt

We close the stack to check access works

    # cryptsetup close plain2
    # cryptsetup close plain1

First, let's try to open the filesystem directly:

    # cryptsetup --type plain --cipher=serpent-xts-plain64 --hash=sha256 --key-size=256 --offset=10 open /dev/sdaX plain2
    # mount -t ext2 /dev/mapper/plain2 /mnt
    mount: wrong fs type, bad option, bad superblock on /dev/mapper/plain2,
          missing codepage or helper program, or other error

Why that did not work? Because the "plain2" starting block (10) is still
encrypted with the cipher from "plain1". It can only be accessed via the
stacked mapper. The error is arbitrary though, trying a wrong passphrase
or wrong options will yield the same. For dm-crypt plain mode, the open
action will not error out itself.

Trying again in correct order:

    # cryptsetup close plain2    # dysfunctional mapper from previous try
    # cryptsetup --type plain open /dev/sdaX plain1
    Enter passphrase: 
    # cryptsetup --type plain --cipher=serpent-xts-plain64 --hash=sha256 --key-size=256 --offset=10 open /dev/mapper/plain1 plain2 
    Enter passphrase: 
    # mount /dev/mapper/plain2 /mnt && cat /mnt/stacked.txt
    This is stacked. one passphrase per foot to shoot.
    # exit

dm-crypt will handle stacked encryption with some mixed modes too. For
example LUKS mode could be stacked on the "plain1" mapper. Its header
would then be encrypted inside "plain1" when that is closed.

Available for plain mode only is the option --shared. With it a single
device can be segmented into different non-overlapping mappers. We do
that in the next example, using a loopaes compatible cipher mode for
"plain2" this time:

    # cryptsetup --type plain --offset 0 --size 1000 open /dev/sdaX plain1 
    Enter passphrase: 
    # cryptsetup --type plain --offset 1000 --size 1000 --shared --cipher=aes-cbc-lmk --hash=sha256 open /dev/sdaX plain2
    Enter passphrase: 
    # lsblk -p
    NAME                    
    dev/sdaX                    
    ├─/dev/sdaX               
    │ ├─/dev/mapper/plain1     
    │ └─/dev/mapper/plain2     
    ...

As the devicetree shows both reside on the same level, i.e. are not
stacked and "plain2" can be opened individually.

Opening and closing an encrypted partition with cryptsetup
----------------------------------------------------------

Cryptsetup actions specific for LUKS
------------------------------------

> Key management

It is possible to define up to 8 different keys per LUKS partition. This
enables the user to create access keys for save backup storage. Also a
different key-slot could be used to grant access to a partition to a
user by issuing a second key and later revoking it again. Passphrases or
key-files to a key may be changed.

Once an encrypted partition has been created, the initial keyslot 0 is
created (if no other was specified manually). Additional keyslots are
numbered from 1 to 7. Which keyslots are used can be seen by issuing

    # cryptsetup luksDump /dev/<device> |grep BLED

    Key Slot 0: ENABLED
    Key Slot 1: ENABLED
    Key Slot 2: ENABLED
    Key Slot 3: DISABLED
    Key Slot 4: DISABLED
    Key Slot 5: DISABLED
    Key Slot 6: DISABLED
    Key Slot 7: DISABLED

Where <device> is the volume containing the LUKS header. This and all
the following commands in this section work on header backup files as
well.

Adding LUKS keys

Adding new keyslots is accomplished using cryptsetup with the luksAddKey
action. For safety it will always, i.e. also for already unlocked
devices, ask for a valid existing key ("any passphrase") before a new
one may be entered:

    # cryptsetup luksAddKey /dev/<device> (/path/to/<additionalkeyfile>) 
    Enter any passphrase:
    Enter new passphrase for key slot:
    Verify passphrase: 

If /path/to/<additionalkeyfile> is given, cryptsetup will add a new
keyslot for <additionalkeyfile>. Otherwise a new passphrase will be
prompted for twice. For using an existing keyfile to authorize the
action, the --key-file or -d option followed by the "old" <keyfile> will
try to unlock all available keyfile keyslots:

    # cryptsetup luksAddKey /dev/<device> (/path/to/<additionalkeyfile>) -d /path/to/<keyfile>

If it is intended to use multiple keys and change or revoke them, the
--key-slot or -S option may be used to specify the slot:

    # cryptsetup luksAddKey /dev/<device> -S 6 
    Enter any passphrase: 
    Enter new passphrase for key slot: 
    Verify passphrase:
    # cryptsetup luksDump /dev/sda8 |grep 'Slot 6'
    Key Slot 6: ENABLED

To show an associated action in this example, we decide to change the
key right away:

    # cryptsetup luksChangeKey /dev/<device> -S 6 
    Enter LUKS passphrase to be changed: 
    Enter new LUKS passphrase: 

before continuing to remove it.

Removing LUKS keys

There are two different actions to remove keys from the header:

-   luksRemoveKey is used to remove a key by specifying its
    passphrase/key-file and
-   luksKillSlot may be used to remove a key from a specific key slot
    (using another key). Obviously, this is extremely useful if you have
    forgotten a passphrase, lost a key-file, or have no access to it.

Warning:Both above actions can be used to irrevocably delete the last
active key for an encrypted device!

For above warning it is good to know the key we want to keep is valid.
An easy check is to unlock the device with the -v option, which will
specify which slot it occupies:

    # cryptsetup -v open /dev/<device> testcrypt
    Enter passphrase for /dev/<device>: 
    Key slot 1 unlocked.
    Command successful.

Now we can remove the key added in the previous subsection using its
passphrase:

    # cryptsetup luksRemoveKey /dev/<device>
    Enter LUKS passphrase to be deleted: 

If we had used the same passphrase for two keyslots, the first slot
would be wiped now. Only executing it again would remove the second one.

Alternatively, we can specify the key slot:

    # cryptsetup luksKillSlot /dev/<device> 6
    Enter any remaining LUKS passphrase:

Note that in both cases, no confirmation was required.

    # cryptsetup luksDump /dev/sda8 |grep 'Slot 6'
    Key Slot 6: DISABLED

To re-iterate the warning above: If the same passphrase had been used
for key slots 1 and 6, both would be gone now.

> Backup and restore

If the header of a LUKS encrypted partition gets destroyed, you will not
be able to decrypt your data. It is just as much as a dilemma as
forgetting the passphrase or damaging a key-file used to unlock the
partition. A damage may occur by your own fault while re-partitioning
the disk later or by third-party programs misinterpreting the partition
table.

Therefore, having a backup of the header and storing it on another disk
might be a good idea.

Attention: Many people recommend NOT backing up the cryptheader, but
even so it's a single point of failure! In short, the problem is that
LUKS is not aware of the duplicated cryptheader, which contains the
master key used to encrypt all files on the partition. Of course this
master key is encrypted with your passphrases or keyfiles. But if one of
those gets compromised and you want to revoke it you have to do this on
all copies of the cryptheader! I.e. if someone obtains a copy of the
cryptheader and one of your keys he can decrypt the master key and
access all your data. Of course the same is true for all backups you
create of partitions. So you decide if you are one of those paranoids
brave enough to go without a backup for the sake of security or not. See
also the LUKS FAQ for further details on this.

Backup using cryptsetup

Cryptsetup's luksHeaderBackup action stores a binary backup of the LUKS
header and keyslot area:

    # cryptsetup luksHeaderBackup /dev/<device> --header-backup-file /mnt/<backup>/<file>.img

where <device> is the partition containing the LUKS volume.

Tip:You can also back up the plaintext header into ramfs and encrypt it
in example with gpg before writing to persistent backup storage by
executing the following commands.

    # mkdir /root/<tmp>/
    # mount ramfs /root/<tmp>/ -t ramfs
    # cryptsetup luksHeaderBackup /dev/<device> --header-backup-file /root/<tmp>/<file>.img
    # gpg2 --recipient <User ID> --encrypt /root/<tmp>/<file>.img 
    # cp /root/<tmp>/<file>.img.gpg /mnt/<backup>/
    # umount /root/<tmp>

Warning:Tmpfs can swap to harddisk if low on memory so it is not
recommended here.

Restore using cryptsetup

Warning:Restoring the wrong header or restoring to an unencrypted
partition will cause data loss! The action can not perform a check
whether the header is actually the correct one for that particular
device.

In order to evade restoring a wrong header, you can ensure it does work
by using it as a remote --header first:

    # cryptsetup -v --header /mnt/<backup>/<file>.img open /dev/<device> test 
    Key slot 0 unlocked.
    Command successful.
    # mount /dev/mapper/test /mnt/test && ls /mnt/test 
    # umount /mnt/test 
    # cryptsetup close test 

Now that the check succeeded, the restore may be performed:

    # cryptsetup luksHeaderRestore /dev/<device> --header-backup-file ./mnt/<backup>/<file>.img

Now that all the keyslot areas are overwritten; only active keyslots
from the backup file are available after issuing the command.

Manual backup and restore

The header always resides at the beginning of the device and a backup
can be performed without access to cryptsetup as well. First you have to
find out the payload offset of the crypted partition:

    # cryptsetup luksDump /dev/<device> | grep "Payload offset"

     Payload offset:	4040

Second check the sector size of the drive

    # fdisk -l /dev/<device> |grep "Sector size"

    Sector size (logical/physical): 512 bytes / 512 bytes

Now that you know the values, you can backup the header with a simple dd
command:

    # dd if=/dev/<device> of=/path/to/<file>.img bs=512 count=4040

and store it safely.

A restore can then be performed using the same values as when backing
up:

    # dd if=./<file>.img of=/dev/<device> bs=512 count=4040

Cryptsetup and keyfiles
-----------------------

Note:This section describes using a plaintext keyfile. If you want to
encrypt your keyfile giving you two factor authentication see Using GPG
or OpenSSL Encrypted Keyfiles for details, but please still read this
section.

What is a Keyfile?

A keyfile is any file in which the data contained within it is used as
the passphrase to unlock an encrypted volume. Therefore if these files
are lost or changed, decrypting the volume will no longer be possible.

Tip:Define a passphrase in addition to the keyfile for backup access to
encrypted volumes in the event the defined keyfile is lost or changed.

Why use a Keyfile?

There are many kinds of keyfile. Each type of keyfile used has benefits
and disadvantages summarized below:

keyfile.passphrase:

this is my passphrase I would have typed during boot but I have placed
it in a file instead

This is a keyfile containing a simple passphrase. The benefit of this
type of keyfile is that if the file is lost the data it contained is
known and hopefully easily remembered by the owner of the encrypted
volume. However the disadvantage is that this does not add any security
over entering a passphrase during the initial system start.

keyfile.randomtext:

fjqweifj830149-57 819y4my1- 38t1934yt8-91m 34co3;t8y;9p3y-

This is a keyfile containing a block of random characters. The benefit
of this type of keyfile is that it is much more resistant to dictionary
attacks than a simple passphrase. An additional strength of keyfiles can
be utilized in this situation which is the length of data used. Since
this is not a string meant to be memorized by a person for entry, it is
trivial to create files containing thousands of random characters as the
key. The disadvantage is that if this file is lost or changed, it will
most likely not be possible to access the encrypted volume without a
backup passphrase.

keyfile.binary:

where any binary file, images, text, video could be chosen as the
keyfile

This is a binary file that has been defined as a keyfile. When
identifying files as candidates for a keyfile, it is recommended to
choose files that are relatively static such as photos, music, video
clips. The benefit of these files is that they serve a dual function
which can make them harder to identify as keyfiles. Instead of having a
text file with a large amount of random text, the keyfile would look
like a regular image file or music clip to the casual observer. The
disadvantage is that if this file is lost or changed, it will most
likely not be possible to access the encrypted volume without a backup
passphrase. Additionally, there is a theoretical loss of randomness when
compared to a randomly generated text file. This is due to the fact that
images, videos and music have some intrinsic relationship between
neighboring bits of data that does not exist for a text file. However
this is controversial and has never been exploited publicly.

Creating a Keyfile with Random Characters

Here dd is used to generate a keyfile of 2048 random bytes.

    # dd if=/dev/urandom of=mykeyfile bs=512 count=4

The usage of dd is similar to initially wiping the volume with random
data prior to encryption.

> Storing the Key File

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: The default      
                           method to store a        
                           keyfile and reference it 
                           via crypttab should be   
                           added. (Discuss)         
  ------------------------ ------------------------ ------------------------

External Storage on a USB Drive

Preparation for Persistent block device naming

For reading the file from an external storage device it is very
convenient to access it through udev's Persistent block device naming
features and not by ordinary device nodes like /dev/sdb1 whose naming
depends on the order in which devices are plugged in. So in order to
assure that the encrypt HOOK in the initcpio finds your keyfile, you
must use a permanent device name.

Persistent symlinks

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Persistent  
                           block device naming.     
                           Notes: Anything not      
                           specific to storing LUKS 
                           keyfiles should get      
                           merged there. (Discuss)  
  ------------------------ ------------------------ ------------------------

A quick method (as opposed to setting up a udev rule) for doing so
involves referencing the right partition by its UUID, id (based on
hardware info and serial number) or filesystem label.

Plug the device in and print every file name under /dev/disk:

    #ls -lR /dev/disk/

    /dev/disk/:
    total 0
    drwxr-xr-x 2 root root 180 Feb 12 10:11 by-id
    drwxr-xr-x 2 root root  60 Feb 12 10:11 by-label
    drwxr-xr-x 2 root root 100 Feb 12 10:11 by-path
    drwxr-xr-x 2 root root 180 Feb 12 10:11 by-uuid

    /dev/disk/by-id:
    total 0
    lrwxrwxrwx 1 root root  9 Feb 12 10:11 usb-Generic_STORAGE_DEVICE_000000014583-0:0 -> ../../sdb
    lrwxrwxrwx 1 root root 10 Feb 12 10:11 usb-Generic_STORAGE_DEVICE_000000014583-0:0-part1 -> ../../sdb1

    /dev/disk/by-label:
    total 0
    lrwxrwxrwx 1 root root 10 Feb 12 10:11 Keys -> ../../sdb1

    /dev/disk/by-path:
    total 0
    lrwxrwxrwx 1 root root  9 Feb 12 10:11 pci-0000:00:1d.7-usb-0:1:1.0-scsi-0:0:0:0 -> ../../sdb
    lrwxrwxrwx 1 root root 10 Feb 12 10:11 pci-0000:00:1d.7-usb-0:1:1.0-scsi-0:0:0:0-part1 -> ../../sdb1

    /dev/disk/by-uuid:
    total 0
    lrwxrwxrwx 1 root root 10 Feb 12 10:11 baa07781-2a10-43a7-b876-c1715aba9d54 -> ../../sdb1

> UUID

Using the filesystem UUID for persistent block device naming is
considered very reliable. Filesystem UUIDs are stored in the filesystem
itself, meaning that the UUID will be the same if you plug it into any
other computer, and that a dd backup of it will always have the same
UUID since dd does a bitwise copy.

The right device node for what is now /dev/sdb1 will always get
symlinked by /dev/disk/by-uuid/baa07781-2a10-43a7-b876-c1715aba9d54.
Symlinks can be used in a bootloader "cryptkey" kernel option or
anywhere else.

For legacy filesystems like FAT the UUID will be much shorter but
collision is still unlikely to happen if not mounting many different FAT
filesystems at once.

> Label

In the following example a FAT partition is labeled as "Keys" and will
always get symlinked by /dev/disk/by-label/Keys:

    #mkdosfs -n >volume-name< /dev/sdb1

    #blkid -o list

    device     fs_type label    mount point    UUID
    -------------------------------------------------------
    /dev/sdb1  vfat    Keys     (not mounted)  221E-09C0

Persistent udev rule

Optionally you may choose to set up your flash drive with a udev rule.
There is some documentation in the Arch wiki about that already; if you
want more in-depth, structural info, read this guide. Here is quickly
how it goes.

Get the serial number from your USB flash drive:

    lsusb -v | grep -A 5 Vendor

Create a udev rule for it by adding the following to a file in
/etc/udev/rules.d/, such as 8-usbstick.rules:

    KERNEL=="sd*", ATTRS{serial}=="$SERIAL", SYMLINK+="$SYMLINK%n"

Replace $SYMLINK and $SERIAL with their respective values. %n will
expand to the partition (just like sda is subdivided into sda1, sda2,
...). You do not need to go with the 'serial' attribute. If you have a
custom rule of your own, you can put it in as well (e.g. using the
vendor name).

Rescan your sysfs:

    udevadm trigger

Now check the contents of /dev:

    ls /dev

It should show your device with your desired name.

Generating the keyfile

Optionally you can mount a tmpfs for storing the temporary keyfile.

    # mkdir ./mytmpfs
    # mount tmpfs ./mytmpfs -t tmpfs -o size=32m
    # cd ./mytmpfs

The advantage is that it resides in RAM and not on a physical disk, so
after unmounting your keyfile is securly gone. So copy your keyfile to
some place you consider as secure before unmounting. If you are planning
to store the keyfile as a plain file on your USB device, you can also
simply execute the following command in the corresponding directory,
e.g. /media/sdb1

The keyfile can be of arbitrary content and size. We will generate a
random temporary keyfile of 2048 bytes:

    # dd if=/dev/urandom of=secretkey bs=512 count=4

If you stored your temporary keyfile on a physical storage device,
remember to not just (re)move the keyfile later on, but use something
like

    cp secretkey /destination/path
    shred --remove --zero secretkey

to securely overwrite it. For overaged filesystems like FAT or ext2 this
will suffice while in the case of journaling filesystems, flash memory
hardware and other cases it is highly recommended to wipe the entire
device or at least the keyfiles partition.

Add a keyslot for the temporary keyfile to the LUKS header:

    # cryptsetup luksAddKey /dev/sda2 secretkey

    Enter any LUKS passphrase:
    key slot 0 unlocked.
    Command successful.

Storing the keyfile

The following uses an USB-stick to store the key file and modifies the
initramfs to load and use it on boot to unlock the root partition.

Configuration of initcpio

You have to add two extra modules in your /etc/mkinitcpio.conf, one for
the drive's file system and one for the codepage. Further if you created
a udev rule, you should tell mkinitcpio about it:

    MODULES="ata_generic ata_piix nls_cp437 vfat"
    FILES="/etc/udev/rules.d/8-usbstick.rules"

In this example it is assumed that you use a FAT formatted USB drive.
Replace those module names if you use another file system on your USB
stick (e.g. ext2) or another codepage. Users running the stock Arch
kernel should stick to the codepage mentioned here.

If you have a non-US keyboard, it might prove useful to load your
keyboard layout before you are prompted to enter the password to unlock
the root partition at boot. For this, you will need the keymap hook
before encrypt.

Generate a new image (maybe you should backup a copy of your old
/boot/initramfs-linux.img first):

    # mkinitcpio -p linux

Storing the key as a plain (visible) file

Be sure to choose a plain name for your key – a bit of 'security through
obscurity' is always nice ;-). Avoid using dotfiles (hidden files) – the
encrypt hook will fail to find the keyfile during the boot process.

You have to add
cryptdevice=/dev/sda3:root cryptkey=/dev/usbstick:vfat:/secretkey to
your kernel parameters. This assumes /dev/usbstick is the FAT partition
of your choice. Replace it with /dev/disk/by-... or whatever your device
is.

That is all, reboot and have fun!

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dm-crypt/Device_Encryption&oldid=305682"

Categories:

-   Security
-   File systems

-   This page was last modified on 19 March 2014, at 21:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
