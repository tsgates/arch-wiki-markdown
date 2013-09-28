Video encoding
==============

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Video Encoding                                                     |
|     -   1.1 GUI And Scripted Conversions                                 |
|     -   1.2 GUI Conversions                                              |
|     -   1.3 Scripted Conversions                                         |
|     -   1.4 Specific Commands                                            |
|         -   1.4.1 Encoding AVI Videos in Windows and Mac Readable        |
|             Formats                                                      |
|                                                                          |
|     -   1.5 Common Misconceptions                                        |
|         -   1.5.1 Codecs v.s. Containers                                 |
|         -   1.5.2 encoder v.s. codec                                     |
|                                                                          |
|     -   1.6 I want to learn some basics                                  |
|         -   1.6.1 Containers                                             |
|         -   1.6.2 Codecs                                                 |
|         -   1.6.3 Choosing the right stuff                               |
+--------------------------------------------------------------------------+

Video Encoding
==============

Videos can be encoded through the command line, as single commands, or
using scripts, or using GUI interface to command line options. This
article covers some of the possibile methods.

  

GUI And Scripted Conversions
----------------------------

GUI Conversions
---------------

Several graphical user interfaces exist to assist with the conversion of
video to new formats.

-   winff
-   ogmrip
-   dvdrip
-   handbrake
-   avidemux

Scripted Conversions
--------------------

xvidenc is a script available in the AUR. It uses mencoder and might be
a good fit, if want to convert some videos but lack most of the
knowledge: While there are (probably?) even easier scripts out there,
this one still gives you a lot of choices (most of which you can ignore
by pressing enter to use a decent default settings).

h264enc is an advanced shell script for encoding DVDs or video files to
the H.264 format using the encoding utility MEncoder from MPlayer.

Specific Commands
-----------------

> Encoding AVI Videos in Windows and Mac Readable Formats

Use these commands:

    opt="vbitrate=2160000:mbd=2:keyint=132:vqblur=1.0:cmp=2:subcmp=2:dia=2:mv0:last_pred=3"

    mencoder -ovc lavc -lavcopts vcodec=msmpeg4v2:vpass=1:$opt -oac mp3lame -o /dev/null input.avi
    mencoder -ovc lavc -lavcopts vcodec=msmpeg4v2:vpass=2:$opt -oac mp3lame -o output.avi input.avi

"input.avi" is the AVI you made using Linux utilities, and "output.avi"
is the AVI you want to make which will be readable by Windows and Mac
users.

Common Misconceptions
---------------------

(Easy one-liners? I'll think I'll do this Section first, as I did & do
have a LOT of misconceptions and I'm sure a lot of people who mostly
used windows to convert videos in the past have, too;))

> Codecs v.s. Containers

> encoder v.s. codec

I want to learn some basics
---------------------------

look (I'm not sure where: links some starting points to look depending
on what one needs?)

> Containers

avi, mkv etc... (max one line description + one link for the most used
ones?)

> Codecs

xvid, stuff (..same...?)

> Choosing the right stuff

no idea

Retrieved from
"https://wiki.archlinux.org/index.php?title=Video_encoding&oldid=206427"

Category:

-   Audio/Video
