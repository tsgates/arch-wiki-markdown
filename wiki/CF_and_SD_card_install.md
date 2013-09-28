CF and SD card install
======================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: (Discuss)        
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

For the last few years I've had laptops running on CF cards and SD
cards. It is a fantastic idea, especially for older IDE based laptops.
(Try finding a new 2.5" IDE drive for less than $50. CF adapter + card =
$30.) Here's a quick rundown of installing and running.

Have a cdrom drive? Make two partitions. The first about should be
100-200 Mb, the emergency partition. More on that later. The second
takes up the rest of the drive. Do not make a swap.

No cd drive? dd the usb .img file to the card. Open the drive in a
partition editor. You'll see one 180Mb partition. Boot this to install
Arch. (Later it can be used for rescue purposes.) Add a second partition
taking up the rest of the space. Same thing, no swap partition.

Format the primary partition as ext2.

Don't worry about no swap. You know how a normal computer slows WAY down
when it starts hitting the swap? You'll feel the same effect even
without swap. When memory gets low, shared libraries are automatically
unloaded to free up more space. But your apps still need to use these
libs, so they get read from disk (slow!). You'll feel the slowdown long
before hitting an OOM error.

> Fstab

Follow the Beginners' Guide to install. When it comes time to edit
/etc/fstab, you should use the following. Add one line to move /tmp into
ram, use UUID to use persistent naming and change your primary
mountpoint to "noatime,nodiratime" to reduce wear:

     tmpfs            /tmp    tmpfs    nosuid,nodev    0 0
     UUID=...         /     ext2     defaults,noatime,nodiratime     0 1

See: Fstab and Persistent block device naming

> Mkinitcpio.conf

You may also need to add usb to /etc/mkinitcpio.conf in order to boot
correctly from a card on an usb card reader. If you need input from usb
devices (i.E. password for dm-crypt) you need usbinput as well:

    HOOKS="base udev autodetect pata scsi sata usb filesystems usbinput"

And rebuild the image:

    # mkinitcpio -p linux

Note:This example is for the linux package, it works the same for the
other kernel packages.

See: Mkinitcpio#Configuring the HOOKS

Try not to run any file indexers. I set up a CF card laptop for a
friend, running gnome. Trackerd literally ate the drive, even after I
excluded /. Uninstalling tracker worked fine, nothing seemed to depend
on it.

What about that emergency partition I was taking about? In short, things
will go wrong if you are using cheap flash cards. You'll accidentally
eject the card, while it's on. You'll shut down and something will get
corrupted. And the card is formatted ext2, not the most advanced FS.
I've even had cards catch on fire the moment they were powered on. The
emergency partition holds a small OS for when things inevitably go belly
up, to pull files off or run fsck. My personal favorites are Rescue Is
Possible Linux, Puppy Linux, TinyCore Linux, Parted Magic or the Arch
Linux installer. Look at them all, find one you like. If installing
live-CDs to a drive is too tricky, install one using unetbootin.

And back stuff up! The flash cards are relatively small compared to hard
drives, so this is a snap. I usually replace/upgrade my cards every year
to be safe, but one did die after just three months.

Offline

Retrieved from
"https://wiki.archlinux.org/index.php?title=CF_and_SD_card_install&oldid=239602"

Category:

-   Getting and installing Arch
