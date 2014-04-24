RealPlayer
==========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This article describes how to play .rmvb video files.

Installation
------------

The most simple way is to install VLC, which plays .rmvb now, as well as
many other video format.

    # pacman -S vlc

Or you can install realplayer from the AUR.

Next, start it with:

    $ realplay &

On the first run, a configuration wizard will set up the necessary
options.

  

.ram files
----------

To play .ram files, this script is intended to replace the use of
realplayer by using vlc instead :
http://www.sputnick-area.net/scripts/realplay.bash

See comments inside.

Conversion of RealMedia Files
-----------------------------

As RealMedia files are not widely (nor well) supported, it may be useful
to convert them to another format. FFmpeg can be used for this.

    # pacman -S ffmpeg

For example, to convert the video foo.rm to an mp4 file:

    ffmpeg -i foo.rm -vcodec mpeg4 -sameq -acodec libfaac -ab 94208 foo.mp4

Retrieved from
"https://wiki.archlinux.org/index.php?title=RealPlayer&oldid=256777"

Category:

-   Player

-   This page was last modified on 12 May 2013, at 09:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
