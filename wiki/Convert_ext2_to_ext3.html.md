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

Note:If you have installed Arch to an ext2 filesystem, it is a good idea
to enable the journal and turn it into an ext3 filesystem. Journaling
provides a range of benefits.

1. Identify the partition(s) for conversion by inspecting /etc/fstab and
the output of the mount command

2. Add a journal to the partition(s):

    # tune2fs -j partition

Where partition is /dev/sda1, /dev/hda1, /dev/discs/disc0/part1, etc.

3. Edit /etc/fstab and change ext2 to ext3 for the partition.

For example:

    /dev/sda3 / ext2 defaults 0 1

becomes:

    /dev/sda3 / ext3 defaults 0 1

4. Add the ext3 module to /etc/mkinitcpio.conf:

    MODULES="ext3"

5. Rebuild the initrd image (for a standard kernel):

    # mkinitcpio -p linux

See also
--------

Migrating from ext3 to ext4

Retrieved from
"https://wiki.archlinux.org/index.php?title=Convert_ext2_to_ext3&oldid=300513"

Category:

-   File systems

-   This page was last modified on 23 February 2014, at 15:25.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
