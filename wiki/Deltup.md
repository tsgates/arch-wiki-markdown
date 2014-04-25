Deltup
======

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Using delta mean to save time and size in downloading and updating the
system. The package that will be downloaded will be a sort of "diff" of
the new package, that will be used to "build" the new package at the end
of the download. This option can be used on Arch Linux i686 and x86-64
versions.

Contents
--------

-   1 Install
-   2 Configuration
-   3 Comparisons
-   4 Disadvantage

Install
-------

Install xdelta3 from the official repositories.

Configuration
-------------

Edit /etc/pacman.d/mirrorlist and add the proper repository:

    /etc/pacman.d/mirrorlist

    ##
    ## Arch Linux repository mirrorlist
    ## Generated on 2011-03-24
    ##

    ## Delta Archlinux.fr
    Server = http://delta.archlinux.fr/$repo/os/$arch
    .....

Then edit /etc/pacman.conf uncommenting (removing #) the option
UseDelta:

    /etc/pacman.conf

    .....
    # Misc options (all disabled by default)
    #UseSyslog
    ShowSize
    UseDelta
    TotalDownload
    .....

Comparisons
-----------

Check before activating the UseDelta option how much we need to download
to full update the system.

    #  pacman -Syu


     ...

     Total Download Size:   416,89 MB
     Total Installed Size:   1933,56 MB

     Proceed with installation? [Y/n]

Choose n and not confirm the update. As shown the package to be
downloaded now are 416,89 MB.

After enabling delta, check again for the updates available(now the
option UseDelta is enabled):

    # pacman -Syu


     ...

     Total Download Size:   343,15 MB
     Total Installed Size:   1933,56 MB

     Proceed with installation? [Y/n]

In this way we do not need to download 416,89 MB of packages but only
343,15 MB, so we obtain a shorter time in the update process.

Disadvantage
------------

This method isn't fully supported in Arch Linux as opposed to OpenSuSE
or Gentoo which use this as standard for their update system. In fact
the available delta repository are just a few. The results can be much
better if delta have more deltup packages between previous versions in
the repositories. For example, in the repository the author uses, there
is only -1 version of each package.

    kdeartwork-kscreensaver-4.6.2-1_to_4.6.3-1-x86_64.delta	2011-May-06 22:35:41	301.8K	 application/octet-stream 
    kdeartwork-kscreensaver-4.6.3-1-x86_64.pkg.tar.xz	2011-May-06 08:57:57	589.2K	 application/octet-stream

Retrieved from
"https://wiki.archlinux.org/index.php?title=Deltup&oldid=274759"

Category:

-   Package management

-   This page was last modified on 8 September 2013, at 14:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
