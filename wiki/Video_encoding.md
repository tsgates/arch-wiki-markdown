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

Contents
--------

-   1 Video Encoding
    -   1.1 GUI And Scripted Conversions
    -   1.2 GUI Conversions
    -   1.3 Scripted Conversions
    -   1.4 Specific Commands
        -   1.4.1 Encoding AVI Videos in Windows and Mac Readable
            Formats
    -   1.5 Common Misconceptions
        -   1.5.1 Codecs v.s. Containers
        -   1.5.2 encoder v.s. codec
    -   1.6 I want to learn some basics
        -   1.6.1 Containers
        -   1.6.2 Codecs
        -   1.6.3 Choosing the right stuff

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

A common source of confusion when it comes to video encoding is the
difference between codecs / encoding formats, and containers. The
difference between them can be illustrated with a few examples, MKV,
AVI, WEBM are all container formats, while XviD, H.264, VP8 are video
encoding formats, AAC, Vorbis and MP3 are audio encoding formats.

While the encoding format describes how the audio or video data is
compressed and encoded, the container format describes how this encoded
data is laid out inside a file. A video file will typically contain
audio in addition to video and often might contain additional data such
as subtitles and chapter marks. In addition, these tracks of data need
to be synchronised, so that the audio, video and subtitles play at the
appropriate time. How the audio, video, subtitle and additional data is
put together and kept in sync is described by the container format.

A very old yet common container format is AVI (Audio Video Interleave),
it only works for simple situations where all you need is a single audio
and single video track. Newer, modern formats such as MKV allow for much
greater flexibility; MKV for instance supports multiple audio tracks
(e.g. multiple languages), video tracks (e.g. multiple angles), multiple
subtitle tracks, chapter marks with support for nested chapters, it can
also support cover art, arbitrary attachments (for example a PDF booklet
for a song), and even support for DVD-like menus. Google's open source
WebM format is based on MKV, however it utilises VP8 for video encoding
and Vorbis for audio encoding.

MP4 often refers to both the video compression format, and the format of
the container, however they are both distinct entities. The MPEG-4 Part
14 specification describes the format of the MP4 video container, while
other parts have to do with the audio and video encoding. MPEG-4 Part 2
for instance deals with video encoding, and is possibly more popular
DivX and Xvid, it is superseded by the MPEG-4 Part 1 format, which is
more popular as H.264, or AVC. MPEG-4 Part 3 deals with audio, and is
used wherever you see MP4 audio (m4a files) and is also known as AAC.

With a modern container format such as MKV or MP4, it is possible to
encode video and audio in any desired format and to put them together in
a single file for simultaneous playback. One could for instance pick
H.264 / AVC video, and use it together with Vorbis audio and put the
resultant in and MP4 container. The resultant file should have no
trouble playing on a computer with the requisite software installed,
however it could cause problems for mobile phones, smart TVs, set top
boxes that have less flexible decoding software.

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
"https://wiki.archlinux.org/index.php?title=Video_encoding&oldid=304077"

Category:

-   Audio/Video

-   This page was last modified on 11 March 2014, at 22:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
