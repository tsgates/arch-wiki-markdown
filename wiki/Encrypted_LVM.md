Encrypted LVM
=============

This is a page about creating an LUKS+LVM install, and also to clear up
a lot of the confusion based around old and out of date wiki articles.

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: This is a very    
                           specific article - If    
                           you think something      
                           should be included here  
                           please add to it!        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Keep in mind that this is DESTRUCTIVE and encrypting a drive will make
any previous data unreadable! The following must be done on a fresh
drive, or one where you do not mind losing the data (because backups!).

The following section will refer to your target hard drive as /dev/sdx.
Be sure to change "sdx" to a proper target like /dev/sda. I will also
assume this is a NEW Arch installation (complete with GPT and GRUB2).

I highly recommend reading through the LVM Wiki if you have not already,
and perhaps even playing inside a Virtual Machine before you start
playing with your real data.

A DISCLAIMER: Please read through this whole document before you start
running luksFormat, and have some SOLID backups - no one but you is
responsible for your disks!

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Single-Disk                                                        |
|     -   1.1 LVM on LUKS                                                  |
|     -   1.2 LUKS on LVM                                                  |
|                                                                          |
| -   2 Spanned/Multiple Disks                                             |
|     -   2.1 Why So Serious?                                              |
|     -   2.2 Add A New Drive                                              |
|     -   2.3 Extend The Logical Volume                                    |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 Help It's Not Booting!                                       |
+--------------------------------------------------------------------------+

Single-Disk
-----------

Encrypted LVM can be set up in 2 ways: LVM on LUKS, or LUKS on LVM. In a
single-disk system, either is acceptable. However, IF YOU WISH to span
your LVM across multiple drives in the future, you must use LUKS on LVM.
(Explanation is below in the "Spanned" section).

In all cases, we must first clean the target drive and fill it with
random data. This is to make our new encrypted partition blend in with
the 'noise', and make it impossible to tell where the random data ends
and where the LUKS container begins. The small frandom module is very
quick at spitting out randomized data; much faster than /dev/urandom,
which is helpful when we are dealing with 1TB+ size disks! We will also
use dcfldd, a small program that works exactly like dd, but is more
verbose. Both these packages are from the AUR.

    # yaourt -S frandom 
    # yaourt -S dcfldd

You can also use /dev/urandom if you would rather not install frandom.

    # dcfldd if=/dev/frandom of=/dev/sdx

Wait for this to finish -- it might take a while depending on how large
your disk is.

> LVM on LUKS

        _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
       |Logical volume1 15GB  |Logical volume2 35GB      |Logical volume3 200GB               |
       |/dev/MyStorage/rootvol|/dev/MyStorage/homevol    |/dev/MyStorage/mediavol             |
       |_ _ _ _ _ _ _ _ _ _ _ |_ _ _ _ _ _ _ _ _ _ _ _ _ |_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ |
       |                                                                                      |
       |                                (LUKS Encrypted Disk  /dev/sdxx)                      | 
       |                                                                                      |
       |--------------------------------------------------------------------------------------|

In this first case a LUKS encrypted blob is created directly at the
partition level, and then an LVM system is placed inside of the blob.
This config hides all information about the underlying partitions --
while the LUKS container is encrypted, the disk simply looks full of
random data. Only when the container is decrypted can you see that there
is in fact an LVM system inside. To set up this config:

Start with partitioning your newly randomized drive:

    # gdisk /dev/sdx

Make the following:

-   sdx1 - Size 2MB, Partition Type EF02 (This is so GRUB plays nice
    with GPT)
-   sdx2 - Size 200mb, Partition Type 8300 (This is your /boot
    partition)
-   sdx3 - Remaining space, Partition Type 8E00 (LVM)

Create the LUKS encrypted container (sdx3. We do not encrypt /boot or
the BIOS partition)

    # cryptsetup luksFormat /dev/sdx3

NOTE: cryptsetup has a TON of options (which you can find in its man
page). The defaults now are quite secure (aes-xts-plain64 with 256bit
keysize results in a 128 bit AES encryption for the data), but you may
change whatever settings you like here. Enter your password twice.

    # cryptsetup luksOpen /dev/sdx3 lvm

Now we open our container. Your decrypted disk is now available at
/dev/mapper/lvm

From here, create your LVM system....

    # pvcreate /dev/mapper/lvm
    # vgcreate MyStorage /dev/mapper/lvm
    # lvcreate -L 15G MyStorage -n rootvol
    # lvcreate -L 35G MyStorage -n homevol
    # lvcreate -L 200G MyStorage -n mediavol

    # mkfs.ext4 /dev/mapper/MyStorage-rootvol
    # mkfs.ext4 /dev/mapper/MyStorage-homevvol
    # mkfs.ext4 /dev/mapper/MyStorage-mediavol

.....And then mount the proper folders to their locations. IE:

    # mount /dev/MyStorage/rootvol /mnt
    # mount /dev/MyStorage/homevol /mnt/home

etc. Now continue through the Arch setup. (Pacstrap, arch-chroot /mnt,
and so on. This HOWTO will assume you are also installing grub-bios to
GPT as per the install guide.)

IT IS CRITICAL, before exiting the install, that you modify GRUB2 and
initcpio so that it will unlock your LUKS container on boot!

Edit /etc/mkinitcpio.conf, and change HOOKS=" " to include (order is
important here):

    # ....... keymap encrypt lvm2 filesystems..."

Next, edit /etc/default/grub and change the following line to say:

    # GRUB_CMDLINE_LINUX="cryptdevice=/dev/sdx3:MyStorage"

Rebuild:

    # mkinitcpio -p linux
    # grub-mkconfig -o /boot/grub/grub.cfg

Done! Exit the chroot, unmount all your partitions and reboot. After
GRUB2 loads, you will be prompted to enter your volume password -- do so
and Arch will continue to boot.

> LUKS on LVM

        _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
       |Encrypted Volume1     |Encrypted volume2         |Encrypted volume3 200GB             |
       |/dev/MyStorage/rootvol|/dev/MyStorage/homevol    |/dev/MyStorage/mediavol             |
       |_ _ _ _ _ _ _ _ _ _ _ |_ _ _ _ _ _ _ _ _ _ _ _ _ |_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ |

This is the opposite of above: your disk is partitioned openly, and each
LVM section is visible. However, the contents of the LVMs are safely
encrypted until unlocked. THIS IS THE REQUIRED CONFIGURATION IF YOU WISH
TO ADD/SPAN MORE PHYSICAL DRIVES IN THE FUTURE.

Start with partitioning your newly randomized drive:

    # gdisk /dev/sdx

Make the following:

-   sdx1 - Size 2MB, Partition Type EF02 (This is so GRUB plays nice
    with GPT)
-   sdx2 - Size 200mb, Partition Type 8300 (This is your /boot
    partition)
-   sdx3 - Remaining space, Partition Type 8E00 (LVM)

Create your LVM partition from sdx3:

    # pvcreate /dev/sdx3
    # vgcreate MyStorage /dev/sdx3
    # lvcreate -L 15G MyStorage -n rootvol
    # lvcreate -L 35G MyStorage -n homevol
    # lvcreate -L 200G MyStorage -n mediavol

Now, encrypt each LVM partition seperately:

    # cryptsetup luksFormat /dev/MyStorage/rootvol
    # cryptsetup luksFormat /dev/MyStorage/homevol
    # cryptsetup luksFormat /dev/MyStorage/mediavol

Again -- as above, cryptsetup has many options, and you can use
whichever cipher or keysize you like, or simply accept the defaults.

Unlock each LUKS container:

    # cryptsetup luksOpen /dev/MyStorage/rootvol root
    # cryptsetup luksOpen /dev/MyStorage/homevol home
    # cryptsetup luksOpen /dev/MyStorage/mediavol media 

And format as ext4 for all partitions including boot:

    # mkfs.ext4 /dev/mapper/root
    # mkfs.ext4 /dev/mapper/home
    # mkfs.ext4 /dev/mapper/media
    # mkfs.ext4 /dev/sdx2 

Now continue through the Arch setup. (Pacstrap, arch-chroot /mnt, and so
on. This HOWTO will assume you are also installing grub-bios to GPT as
per the install guide.) Be precise with the following edits! IT IS
CRITICAL, before exiting the install, that you modify GRUB2 and initcpio
so that it will unlock your LUKS container on boot!

Edit /etc/mkinitcpio.conf, and change HOOKS=" " to include (order is
important here):

    # ....... keymap lvm2 encrypt filesystems..."

Next, edit /etc/default/grub and change the following line to say:

    # GRUB_CMDLINE_LINUX="cryptdevice=/dev/mapper/MyStorage-rootvol:root root=/dev/mapper/root ro"

Rebuild:

    # mkinitcpio -p linux
    # grub-mkconfig -o /boot/grub/grub.conf

A note about LUKS encryption keys: below we will be editing
/etc/crypttab. This is necessary to unlock each non-root LUKS container
(like /home, /media, etc) -- these logical volumes are just as important
as /root, and if they are not visible the entire system will fail to
boot! LVM must have all volumes present and accounted for. Now, in order
to avoid typing in multiple passwords (1 per container) every boot, we
may generate some strong encryption keys and save them in /etc. These
keys are perfectly safe: they are being saved inside the root LVM
container, which must be unlocked by you at boot with a password. As
well, having different passwords for each disk makes breaking the
encryption even more difficult -- even if one password is compromised,
the LVM WILL NOT activate without the other partitions.

    # dd if=/dev/frandom of=/etc/home.key bs=512 count=4
    # dd if=/dev/frandom of=/etc/media.key bs=512 count=4

    # cryptsetup luksAddKey /dev/mapper/MyStorage-homevol /etc/home.key
    # cryptsetup luksAddKey /dev/mapper/MyStorage-mediavol /etc/media.key

Finally, we must add the non-root LVMs to /etc/crypttab

    # home          /dev/mapper/MyStorage-homevol	          /etc/home.key
    # media         /dev/mapper/MyStorage-mediavol           /etc/media.key

IF YOU DO NOT WANT TO USE KEYS HERE, simply delete the columns above
containing "/etc/<keyname>" and you will be asked for each unlock
password on boot.

Now exit the chroot, unmount all your partitions and reboot. After GRUB2
loads, you will be prompted to enter your volume password -- do so and
Arch will continue to boot.

Spanned/Multiple Disks
----------------------

> Why So Serious?

This section is a continuation of the Encrypted_LVM#LUKS_on_LVM config,
above. It is required you have setup your initial LVM drive in this way.
If you have not, go back and start over. Why, you ask?

Because initrd only allows for a SINGLE cryptdevice= entry! For example,
take "LVM on LUKS". The entire LVM exists inside a LUKS container. This
is perfectly fine for a single-drive system: there is only one container
to decrypt. BUT, what happens when you want to increase the size of your
LVM? This is in fact the whole POINT of LVM: you can add and remove
entire drives without having to change the underlying partition.

So you add another hard drive in order to expand /home (Which is a
logical volume of its own.) You encrypt the second drive, add it to the
volume group, expand the Home LV. But now, how do you tell initrd to
unlock BOTH drives at the same time? You cannot! And as stated in the
section above... if only a part of an LVM is available, it WILL NOT
BOOT. So, adding a second drive that requires decryption before it can
be read is out of the picture.

Luckily, we can get around this by making the LVM's visible to the
system even before they are encrypted. This is why LUKS on LVM is, in
general, a much better option.

> Add A New Drive

Assuming you now have a working single-drive LUKS-on-LVM configuration,
it's now time to expand one of your logical volumes.

Connect your drive (if it's new, or completely randomize it as you did
with your root drive). Open gdisk and create a single partiion:

-   /dev/sdy1: Use ALL space, Partition type 8E00 (Linux LVM)

Now, attach this new disk to your existing LVM:

    # pvcreate /dev/sdy1
    # vgextend MyStorage /dev/sdy1

> Extend The Logical Volume

You will have to unmount whatever partition you want to grow, meaning
you may need to boot via an install cd. Details for this will follow
below. In this example, we will extend the "HOME" logical volume by 100%
of the free space of our new drive (ie, put the WHOLE thing into /home!)

From a root console:

    # umount /home
    # fsck /dev/mapper/home
    # cryptsetup luksClose /dev/mapper/home
    # lvextend -l +100%FREE MyStorage/homevol

Now the LV is extended. Let us make LUKS aware of the change:

    # cryptsetup luksOpen /dev/mapper/MyStorage-homevol home
    # umount /home      ((JUST IN CASE IT WAS AUTO RE-MOUNTED AGAIN))
    # cryptsetup --verbose resize home

And finally resize the ext4 partition itself:

    # e2fsck -f /dev/mapper/home
    # resize2fs /dev/mapper/home

Done!

    # mount /dev/mapper/home /home

Note how /home now includes the span of the new drive, and you DO not
have to change or add any more encryption keys -- the key for your Home
LVM will continue to work and fill into the newly added space.

  

-   A note on extending your root partition:

The procedure works exactly the same for your root LVM, with the
exception that it must be done from an Arch INSTALL CD. (you can't
unmount your root partition while it's in use).

Troubleshooting
---------------

> Help It's Not Booting!

First, DONT PANIC! You can always boot a rescue CD and get into your LVM
manually!

Start up via the Arch installer. When you reach the root shell, for each
encrypted LVM:

    # cryptsetup luksOpen /dev/mapper/MyStorage-rootvol

Simply unlock each logical partition -- they will appear in
/dev/mapper/<lv> and you can mount each from there.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Encrypted_LVM&oldid=255842"

Category:

-   File systems
