Tar
===

From GNU's Tar Page:

"The Tar program provides the ability to create tar archives, as well as
various other kinds of manipulation. For example, you can use Tar on
previously created archives to extract files, to store additional files,
or to update or list files which were already stored."

As an early Unix compression format, tar files (known as tarballs) are
widely used for packaging in Unix-like operating systems. Both pacman
and AUR packages are tarballs, and Arch uses GNU's Tar program by
default.

Usage
-----

For tar archives, Tar by default will extract the file according to its
extension:

    $ tar xvf file.EXTENSION

Forcing a given format:

  ------------------------------------------------
  File Type      Extraction Command
  -------------- ---------------------------------
  file.tar       tar xvf file.tar

  file.tgz       tar xvzf file.tgz

  file.tar.gz    tar xvzf file.tar.gz

  file.tar.bz    bzip -cd file.bz | tar xvf -

  file.tar.bz2   tar xvjf file.tar.bz2  
                  bzip2 -cd file.bz2 | tar xvf -

  file.tar.xz    tar xvJf file.tar.xz  
                   xz -cd file.xz | tar xvf -
  ------------------------------------------------

The construction of some of these Tar arguments may be considered
legacy, but they are still useful when performing specific operations.
The Compatibility section of Tar's man page shows how they work in
detail.

> As a cp alternative

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Copying a directory tree and its contents to another filesystem using

    $ cp -pR directory /target

is not always sufficient.

Using Tar instead will preserve ownership, permissions, and timestamps.

This neat trick allows using Tar to perform a recursive copy without
creating an intermediate tar file and overcoming all cp shortcomings.

To copy all of the files and subdirectories in the current working
directory to the directory /target, use:

    $ tar cf - * | ( cd /target; tar xfp -)

The first part of the command before the pipe instructs Tar to create an
archive of everything in the current directory and write it to standard
output (the - in place of a filename frequently indicates stdout). The
commands within parentheses cause the shell to change directory to the
target directory and untar data from standard input. Since the cd and
Tar commands are contained within parentheses, their actions are
performed together.

The -p option in the tar extraction command directs Tar to preserve
permission and ownership information, if possible given the user
executing the command. If you are running the command as root, this
option is turned on by default and can be omitted.

Note that the * will not copy any of the files prefixed with a . in the
root directory. It is tricky to wildcard these files because one does
not want to include the . and .. directories, so usually one adds .??*
to pick up everything else except for one- and two-character filenames
prefixed with the . (e.g. .a, .bc). To copy these as well, you will want
to list them by doing:

    $ ls -a

in the root directory first and typing those explicitly.

In summary, I would recommend this instead:

    $ tar cf - * .??* | ( cd /target; tar xfp -)

but first do:

    $ ls -a

and if you see anything starting with a . (besides ..) that is not
followed by more then two characters, add those as well; e.g.:

    $ tar cf - * .??* .a .z .bc | ( cd /target; tar xfp -)

See Also
--------

-   GNU tar manual (Also available via info tar)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tar&oldid=304909"

Category:

-   Data compression and archiving

-   This page was last modified on 16 March 2014, at 09:14.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
