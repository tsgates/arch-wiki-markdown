Gamin
=====

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  
 Gamin is a file and directory monitoring system defined to be a subset
of the FAM (File Alteration Monitor) system. It is a service provided by
a library which allows for the detection of modification to a file or
directory.

Gamin re-implements the FAM specification with inotify. It is newer and
more actively maintained than FAM, maintains compatibility with FAM and
can replace it in almost every case. It is a GNOME project, but does not
have GNOME dependencies.

Installation
------------

If it is installed, first disable and remove the fam package, ignoring
dependencies:

    # systemctl disable fam.service
    # pacman -Rd fam

Install the gamin package.

External links
--------------

-   FAM, Gamin and inotify

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gamin&oldid=255887"

Category:

-   File systems
