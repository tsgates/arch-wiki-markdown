quvi
====

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with List of     
                           Applications.            
                           Notes: Doesn't add more  
                           information than an      
                           entry in the list; usage 
                           instructions are         
                           documented in the man    
                           page and other upstream  
                           sources. (Discuss)       
  ------------------------ ------------------------ ------------------------

quvi parses media stream URLs for Internet applications that would
otherwise have to use adobe flash multimedia platform to access the
media streams. The typical examples of this are the different media
hosts, such as YouTube, for videos that use this "multimedia platform"
to deliver their content.

Source: project home

Installation
------------

Install quvi from community.

Usage
-----

The simplest way to play a video from a URL is to issue

     $ quvi "<url>" --exec "mplayer %u"

This can be configured as a default behavior by creating

    ~/.quvirc

    exec = "mplayer %u"

Related links
-------------

-   Quvi homepage

  

Retrieved from
"https://wiki.archlinux.org/index.php?title=Quvi&oldid=271520"

Category:

-   Player

-   This page was last modified on 18 August 2013, at 04:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
