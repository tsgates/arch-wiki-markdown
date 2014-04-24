Plex
====

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with List of     
                           Applications.            
                           Notes: This article      
                           doesn't offer more       
                           information than an      
                           entry in List of         
                           Applications, although I 
                           think we'd need to       
                           create a new section for 
                           this kind of             
                           applications.            
                            This could be merged    
                           along with Streaming     
                           media. (Discuss)         
  ------------------------ ------------------------ ------------------------

Landing page for http://plexapp.com/ Please contribute and update.

Contents
--------

-   1 Packages available in AUR
-   2 Plex Media Server (PMS)
    -   2.1 Installation
    -   2.2 Operation
-   3 Plex Home Theater
    -   3.1 Installation

Packages available in AUR
-------------------------

-   plexmediaserver
-   plexmediaserver-plexpass
-   plex-home-theater
-   plex-home-theater-git
-   plex-ffmpeg-git

Plex Media Server (PMS)
-----------------------

> Installation

Install the package from AUR: plexmediaserver.

> Operation

To start plex, run sudo systemctl start plexmediaserver. Use sudo
systemctl enable plexmediaserver to have it start on startup. Then go to
(http://localhost:32400/manage) to set up plex. If you want to add media
folders in your home directory you may get a permissions issue. chmod
775 ~/ and usermod -a -G users plex to allow plex to access your files.

Plex Home Theater
-----------------

> Installation

You can build either plex package from source, or use the unofficial
alucryd repository providing both regular plex-home-theater and
nightlies of plex-home-theater-git.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Plex&oldid=297659"

Category:

-   Streaming

-   This page was last modified on 15 February 2014, at 08:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
