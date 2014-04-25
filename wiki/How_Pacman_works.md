How Pacman works
================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: This page's goal  
                           is to describe how       
                           pacman works. It is a    
                           work in progress, and    
                           until reviewed, not to   
                           be considered correct or 
                           accurate. (Discuss)      
  ------------------------ ------------------------ ------------------------

Overview
--------

Arch linux uses binary packages. This means that the code is already
compiled when you download it, and accounts for the speed by which
packages are installed. Packages live in repositories. The repositories
are named in: /etc/pacman.conf. For example the core repository can be
specified as follows:

    [core]
    SigLevel = Never
    Include = /etc/pacman.d/mirrorlist

This means the actual location of the core repository is specified by
the URL's in /etc/pacman.d/mirrorlist

The actual packages are downloaded to the cache, which is normally
located at: /var/cache/pacman/pkg. You might find several versions of a
given package here:

    % cd /var/cache/pacman/pkg
    pkg % ls which*
    which-2.20-5-x86_64.pkg.tar.xz  
    which-2.20-6-x86_64.pkg.tar.xz

The second important data structure is the pacman database. This is
normally located at: /var/lib/pacman/sync. For each repository you
specify in /etc/pacman.conf, there will be a corresponding database file
located here. These files are tar gzipped. When you extract them, you
will get one directory for each package.

    % tree which-2.20-6 
    which-2.20-6
    |-- depends
    `-- desc

depends lists the packages this package depends on. In the case above we
are looking at the package called: which. We can see the version that is
installed is: 2.20-6. The desc file, has a description of the file, such
as the file size, MD5 hash, etc.

When you run: pacman -Syu, pacman will try to sync the packages on your
computer to the latest ones in the external repositories. It will
compare the hashes on your local computer versus the ones on the
external repos, if they are different then they download the newer one,
install it, and update the corresponding database.

Questions
---------

How is the master list of which packages are installed generated/stored?
For example are the pacman databases built from somewhere else? Does the
system get corrupted if they are deleted?

Retrieved from
"https://wiki.archlinux.org/index.php?title=How_Pacman_works&oldid=266704"

Category:

-   Package management

-   This page was last modified on 17 July 2013, at 08:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
