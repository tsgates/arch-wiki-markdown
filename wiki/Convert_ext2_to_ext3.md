Convert ext2 to ext3
====================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

If you have installed Arch to an ext2 filesystem, it is a good idea to
enable the journal and turn it into an ext3 filesystem. Journaling
provides a range of benefits.

1. Identify the partition(s) for conversion by inspecting /etc/fstab and
the output of the mount command

2. Add a journal to the partition(s):

    sudo tune2fs -j PARTITION

Where PARTITION is /dev/hda1, /dev/sda1, /dev/discs/disc0/part1, etc.

2. Edit /etc/fstab and change ext2 to ext3 for the partition.

For example:

    /dev/sda3 / ext2 defaults 0 1

becomes

    /dev/sda3 / ext3 defaults 0 1

3. Add the ext3 module to /etc/mkinitcpio.conf

    MODULES="ext3"

4. Rebuild the initrd image (for a standard kernel):

    sudo mkinitcpio -p linux

See also: Migrating from ext3 to ext4

Retrieved from
"https://wiki.archlinux.org/index.php?title=Convert_ext2_to_ext3&oldid=216995"

Category:

-   File systems
