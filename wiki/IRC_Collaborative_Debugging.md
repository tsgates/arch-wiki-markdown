IRC Collaborative Debugging
===========================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with IRC         
                           Channel.                 
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

For requesting help from an IRC help channel (like #archlinux), you can
use collaborative debugging services (like pastebin) to give IRC users
details about problems you are seeing or configuration files you need
referenced.

Contents
--------

-   1 IRC Usage
-   2 Output Errors/Messages to File
-   3 Programs to Upload to Pastebin Services
    -   3.1 pastebinit
-   4 Console Installer Questions

IRC Usage
---------

When you tell the people in the chat-room what your problem is,
sometimes they will need to know additional information. This could be
the output (for example) of a command or the contents of a configuration
file. It is a general rule for IRC channels to never paste text greater
than three lines. When you need to do more, paste services (e.g.
pastebin) allow temporary use of storing text information. To prevent
from having to write the information down physically and then type it
manually into an IRC channel this is where it becomes useful to use
collaborative debugging program that can send the information to a paste
service. There are several tools that can be used that can send
information to a pastebin service.

Note:If you are in console and using and IRC program you can do
Ctrl+Alt+F2 (F3, F4…) to enter another console to enter a command.

Output Errors/Messages to File
------------------------------

Many of these programs will need to have a file to upload. If you are
using a program that you need to share it's output you can put it in a
text file by doing:

    program > program-output.txt 2>&1 

For example:

    fdisk -l > partitions.txt 2>&1

It will redirect all output to a text file (both standard output and
error output) and can be uploaded to a pastebin service.

Programs to Upload to Pastebin Services
---------------------------------------

A number of programs exist to upload to pastebin services.

> pastebinit

To add pastebinit:

    pacman -S pastebinit

And to upload a file:

    pastebinit ~/.bashrc

Or pipe the output of a command to pastebinit:

    dmesg | pastebinit

pastebinit will then return a URL of the uploaded file.

Console Installer Questions
---------------------------

Occasionally you might need to actually show a picture of what your
question is about (e.g. if you have a question about a console-based
installer). For this you can use fbshot. fbshot is a framebuffer
screenshot program. To take a screenshot of the first console
(Ctrl+Alt+F1):

    fbshot -c 1 console1.png

Then you can use links and a image-hosting website to upload the image.

Retrieved from
"https://wiki.archlinux.org/index.php?title=IRC_Collaborative_Debugging&oldid=277600"

Category:

-   Internet Relay Chat

-   This page was last modified on 5 October 2013, at 11:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
