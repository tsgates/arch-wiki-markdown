DeveloperWiki:releng roadmap
============================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Arch dropped AIF 
                           for now; not sure if     
                           there's a releng team at 
                           all anymore (Discuss)    
  ------------------------ ------------------------ ------------------------

important todo's
----------------

-   aif filesystem/blockdevice code is a bit complex (mostly due to
    limitations of bash)

     details: https://bugs.archlinux.org/task/15640

-   support btrfs: include tools, integrate in AIF, add mkinitcpio hook
-   support for filesystem optimized for ssd's? nilfs?
-   support softraid
-   streamline automatic installations: ability to autostart aif on
    [pxe] boot with a specific profile, understand/convert kickstart
    files, ..
-   include a tool (preferrably something with simple
    libui-sh/dialog/ncurses interface) which can help you set up
    wireless networks, and use it in aif

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:releng_roadmap&oldid=238709"

Category:

-   DeveloperWiki

-   This page was last modified on 5 December 2012, at 23:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
