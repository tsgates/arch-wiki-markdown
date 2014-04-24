Sparse file
===========

This article contains information regarding sparse files, their
creation, maintenance, and expansion.

Contents
--------

-   1 Sparse Files
    -   1.1 What is a sparse file?
    -   1.2 Advantages
    -   1.3 Disadvantages
-   2 Creating sparse files
    -   2.1 Formatting the file with a filesystem
    -   2.2 Mounting the file at boot
-   3 Copying the sparse file
    -   3.1 Copying with `cp'
    -   3.2 Archiving with `tar'
-   4 Resizing the sparse file
    -   4.1 Growing the file
-   5 Sources

Sparse Files
------------

> What is a sparse file?

According to Wikipedia, in computer science, a sparse file is a type of
computer file that attempts to use file system space more efficiently
when blocks allocated to the file are mostly empty. This is achieved by
writing brief information (metadata) representing the empty blocks to
disk instead of the actual "empty" space which makes up the block, using
less disk space (i.e. sparse files contain blocks of zeros whose
existance is recorded, but have no space allocated on disk). The full
block size is written to disk as the actual size only when the block
contains "real" (non-empty) data.

When reading sparse files, the file system transparently converts
metadata representing empty blocks into "real" blocks filled with zero
bytes at runtime. The application is unaware of this conversion.

Most modern file systems support sparse files, including most Unix
variants and NTFS, but notably not Apple's HFS+. Sparse files are
commonly used for disk images, database snapshots, log files and in
scientific applications.

> Advantages

The advantage of sparse files is that storage is only allocated when
actually needed: disk space is saved, and large files can be created
even if there is insufficient free space on the file system.

> Disadvantages

Disadvantages are that sparse files may become fragmented; file system
free space reports may be misleading; filling up file systems containing
sparse files can have unexpected effects; and copying a sparse file with
a program that does not explicitly support them may copy the entire,
uncompressed size of the file, including the sparse, mostly zero
sections which are not on disk -- losing the benefits of the sparse
property in the file.

Creating sparse files
---------------------

The truncate utility can create sparse files. This command creates a
512 MiB sparse file:

    $ truncate -s 512M file.img

The dd utility can also be used, for example:

    $ dd if=/dev/zero of=file.img bs=1 count=0 seek=512M
    0+0 records in
    0+0 records out
    0 bytes (0 B) copied, 2.4934e-05 s, 0.0 kB/s

Sparse files have different apparent file sizes (the maximum size to
which they may expand) and actual file sizes (how much space is
allocated for data on disk). To check the file's apparent size, just
run:

    $ du -h --apparent-size file.img
    512M    file.img

and, to check the actual size of the file on disk:

    $ du -h file.img
    0       file.img

As you can see, although the apparent size of the file is 512 MiB, its
"actual" size is really zero—that's because due to the nature and beauty
of sparse files, it will "expand" arbitrarily to minimize the space
required to store its contents.

> Formatting the file with a filesystem

Now that we've created the sparse file, it's time to format it with a
filesystem; for this example, I will use ReiserFS:

    # mkfs.reiserfs -f -q file.img
    mkfs.reiserfs 3.6.21 (2009 www.namesys.com)

We can now check its size to see how the filesystem has affected it:

    # du -h --apparent-size file.img
    512M    file.img

    # du -h file.img
    33M     file.img

As you may have expected, formatting it with the filesystem has
increased its actual size, but left its apparent size the same. Now we
can create a directory which we will use to mount our file:

    # mkdir folder

    # mount -o loop file.img folder

Tada! We now have both a file and a folder into which we may store
almost 512 MiB worth of information!

> Mounting the file at boot

Having created a sparse file, you may wish to mount it automatically at
boot; the best way I can suggest to do this is to add a simple entry to
your `/etc/fstab', as follows:

    /path/to/file.img  /path/to/folder  reiserfs  loop,defaults  0  0

Warning:Be sure to include the `loop' option -- otherwise, it will not
mount!!!

Copying the sparse file
-----------------------

> Copying with `cp'

Normally, `cp' is good at detecting whether a file is sparse, so it
suffices to run:

    cp file.img new_file.img

...and new_file.img will be sparse. However, cp does have a
--sparse=WHEN option. This is especially useful if a sparse-file has
somehow become non-sparse (i.e. the empty blocks have been written out
to disk in full). Disk space can be recovered by doing:

    cp --sparse=always new_file.img recovered_file.img

> Archiving with `tar'

One day, you may decide to back up your well-loved sparse file, and
choose the `tar' utility for that very purpose; however, you soon
realize you have a problem:

    # du -h file.img
    33M     file.img

    # tar -cf file.tar file.img

    # du -h file.tar
    513M    file.tar

Apparently, even though the current size of the sparse file is only 33
MB, compressing it with tar created an archive of the ENTIRE SIZE OF THE
FILE! Luckily for you, though, tar has a `--sparse' (`-S') flag, that
when used in conjunction with the `--create' (`-c') operation, tests all
files for sparseness while archiving. If tar finds a file to be sparse,
it uses a sparse representation of the file in the archive. This is
useful when archiving files, such as dbm files, likely to contain many
nulls, and dramatically decreases the amount of space needed to store
such an archive.

    # tar -Scf file.tar file.img

    # du -h file.tar
    12K     file.tar

Problem solved.

Resizing the sparse file
------------------------

Before we resize the file, let's populate it with a couple small files
for testing purposes:

    # for f in {1..5}; do touch folder/file${f}; done

    # ls folder/
    file1  file2  file3  file4  file5

Now, let's add some content to one of the files:

    # echo "This is a test to see if it works..." >> folder/file1

    # cat folder/file1
    This is a test to see if it works...

> Growing the file

Should you ever need to grow the file, you may do the following:

    # umount folder

    # dd if=/dev/zero of=file.img bs=1 count=0 seek=1G
    0+0 records in
    0+0 records out
    0 bytes (0 B) copied, 2.2978e-05 s, 0.0 kB/s

This will increase its size to 1 Gb, and leave its information intact.
Next, we need to increase the size of its filesystem:

    # resize_reiserfs file.img
    resize_reiserfs 3.6.21 (2009 www.namesys.com)

    ReiserFS report:
    blocksize             4096
    block count           262144 (131072)
    free blocks           253925 (122857)
    bitmap block count    8 (4)

    Syncing..done


    resize_reiserfs: Resizing finished successfully.

...and, remount it:

    # mount -o loop file.img folder

Checking its size gives us:

    # du -h --apparent-size file.img
    1.0G    file.img

    # du -h file.img
    33M     file.img

...and to check for consistency:

    # df -h folder
    Filesystem            Size  Used Avail Use% Mounted on
    /tmp/file.img         1.0G   33M  992M   4% /tmp/folder

    # ls folder
    file1  file2  file3  file4  file5

    # cat folder/file1
    This is a test to see if it works...

Seeing its contents are still intact, we are good to go! It's amazing!

Sources
-------

- http://en.wikipedia.org/wiki/Sparse_file

- http://www.apl.jhu.edu/Misc/Unix-info/tar/tar_85.html

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sparse_file&oldid=293674"

Category:

-   File systems

-   This page was last modified on 20 January 2014, at 06:46.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
