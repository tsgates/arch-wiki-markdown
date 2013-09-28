Codecs
======

Summary

An overview of codec packages available for Arch Linux.

Related

DVD Playing

GStreamer

MPlayer

VLC media player

From wikipedia:

A codec is a device or computer program capable of encoding and/or
decoding a digital data stream or signal.

In general, codecs are utilized by multimedia applications to encode or
decode audio or video streams. In order to play encoded streams, users
must ensure an appropriate codec is installed.

This article deals only with codecs and application backends; see Common
Applications for a list of media players (MPlayer and VLC are popular
choices).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Requirements                                                       |
| -   2 Common codecs                                                      |
| -   3 Backends                                                           |
|     -   3.1 GStreamer                                                    |
|     -   3.2 xine                                                         |
|     -   3.3 libavcodec                                                   |
|                                                                          |
| -   4 Tips and tricks                                                    |
|     -   4.1 Install MPlayer binary codecs                                |
|     -   4.2 No H264, mpg4 or Musepack (.mpc) in Totem Player             |
+--------------------------------------------------------------------------+

Requirements
------------

Playing multimedia content requires two components:

-   A capable media player
-   The appropriate codec

It is not always necessary to explicitly install codecs if you have
installed a media player. For example, MPlayer pulls in a large number
of codecs as dependencies, and also has codecs built in.

Common codecs
-------------

-   a52dec: liba52 is a free library for decoding ATSC A/52 streams
-   faac: FAAC is an AAC audio encoder
-   faad2: ISO AAC audio decoder
-   flac: Free Lossless Audio Codec
-   jasper: A software-based implementation of the codec specified in
    the emerging JPEG-2000 Part-1 standard
-   lame: An MP3 encoder and graphical frame analyzer
-   libdca: Free library for decoding DTS Coherent Acoustics streams
-   libdv: The Quasar DV codec (libdv) is a software codec for DV video
-   libmad: A high-quality MPEG audio decoder
-   libmpeg2: libmpeg2 is a library for decoding MPEG-1 and MPEG-2 video
    streams
-   libtheora: An open video codec developed by the Xiph.org
-   libvorbis: Vorbis codec library
-   libxv: X11 Video extension library
-   opus: An open audio codec developed by the Xiph.org
-   wavpack: Audio compression format with lossless, lossy, and hybrid
    compression modes
-   x264: Free library for encoding H264/AVC video streams
-   xvidcore: XviD is an open source MPEG-4 video codec

Backends
--------

> GStreamer

From http://www.gstreamer.net/:

GStreamer is a library for constructing graphs of media-handling
components. The applications it supports range from simple Ogg/Vorbis
playback, audio/video streaming to complex audio (mixing) and video
(non-linear editing) processing.

Simply, GStreamer is a backend or framework utilized by many media
players.

GStreamer uses a plugin architecture which makes the most of GStreamer's
functionality implemented as shared libraries. Since version 0.10 the
plugins come grouped into three sets (named after the film The Good, the
Bad and the Ugly).[1]

-   gstreamer0.10-base-plugins
-   gstreamer0.10-good-plugins
-   gstreamer0.10-bad-plugins
-   gstreamer0.10-ugly-plugins
-   gstreamer0.10-ffmpeg

For the most complete solution:

    # pacman -S gstreamer0.10-plugins

> xine

From http://www.xine-project.org/about:

xine is a free (gpl-licensed) high-performance, portable and reusable
multimedia playback engine. xine itself is a shared library with an easy
to use, yet powerful API which is used by many applications for smooth
video playback and video processing purposes.

As an alternative to GStreamer, many media players can be configured to
utilize the xine backend:

    # pacman -S xine-lib

Note that the xine project itself provides a capable video player,
xine-ui.

> libavcodec

libavcodec is part of the FFmpeg project. It includes a large number of
video and audio codecs. The libavcodec codecs are included with media
players such as MPlayer and VLC, so you may not need to install the
ffmpeg package itself.

Tips and tricks
---------------

> Install MPlayer binary codecs

As an ultimate solution, you can try to install MPlayer binary codecs.

If you are not able to play some files go to
http://www.mplayerhq.hu/design7/dload.html, read the instructions and
install the codec you need to play your files.

They can also be found in AUR with the name codecs and codecs64.

> No H264, mpg4 or Musepack (.mpc) in Totem Player

If you see the "The H264 plugin is missing" warning with Totem media
player, just install the Gstreamer AV library to fix it

    pacman -S gst-libav

Retrieved from
"https://wiki.archlinux.org/index.php?title=Codecs&oldid=255774"

Category:

-   Audio/Video
