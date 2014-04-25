Codecs
======

Related articles

-   DVD Playing
-   GStreamer
-   MPlayer
-   VLC media player

From Wikipedia:

A codec is a device or computer program capable of encoding and/or
decoding a digital data stream or signal.

In general, codecs are utilized by multimedia applications to encode or
decode audio or video streams. In order to play encoded streams, users
must ensure an appropriate codec is installed.

This article deals only with codecs and application backends; see List
of Applications for a list of media players (MPlayer, mpv and VLC are
popular choices).

Contents
--------

-   1 Requirements
-   2 List of codecs
-   3 Backends
    -   3.1 GStreamer
    -   3.2 xine
    -   3.3 libavcodec
-   4 Tips and tricks
    -   4.1 Install MPlayer binary codecs
    -   4.2 No H264, mpg4 or Musepack (.mpc) in Totem Player

Requirements
------------

Playing multimedia content requires two components:

-   A capable media player
-   The appropriate codec

It is not always necessary to explicitly install codecs if you have
installed a media player. For example, MPlayer pulls in a large number
of codecs as dependencies, and also has codecs built in.

List of codecs
--------------

-   ALAC — Data compression method which reduces the size of audio files
    with no loss of information.

https://alac.macosforge.org/ || alac-svn

-   CELT — Compression algorithm for audio. Like MP3, Vorbis, and AAC it
    is suitable for transmitting music with high quality. Unlike these
    formats CELT imposes very little delay on the signal, even less than
    is typical for speech centric formats like Speex, GSM, or G.729.

http://www.celt-codec.org/ || celt

-   Daala — New video compression technology. The effort is a
    collaboration between Mozilla Foundation, Xiph.Org Foundation and
    other contributors. The goal of the project is to provide a free to
    implement, use and distribute digital media format and reference
    implementation with technical performance superior to h.265.

https://www.xiph.org/daala/ || libdaala-git

-   FAAC — Proprietary AAC audio encoder.

http://www.audiocoding.com/faac.html || faac

-   FAAD2 — ISO AAC audio decoder.

http://www.audiocoding.com/faad2.html || faad2

-   FLAC — Free Lossless Audio Codec.

https://xiph.org/flac/ || flac

-   Fraunhofer FDK AAC — Complete, high-quality audio solution to
    Android (and Linux) users.

http://www.iis.fraunhofer.de/en/bf/amm/implementierungen/fdkaaccodec.html
|| libfdk-aac-git

-   Musepack — Audio compression format with a strong emphasis on high
    quality. It's not lossless, but it is designed for transparency, so
    that you won't be able to hear differences between the original wave
    file and the much smaller MPC file. It is based on the MPEG-1
    Layer-2 / MP2 algorithms, but since 1997 it has rapidly developed
    and vastly improved and is now at an advanced stage in which it
    contains heavily optimized and patentless code.

http://musepack.net/ || libmpcdec

-   JasPer — Software-based implementation of the codec specified in the
    emerging JPEG-2000 Part-1 standard.

http://www.ece.uvic.ca/~frodo/jasper/ || jasper

-   LAME — MP3 encoder and graphical frame analyzer.

http://lame.sourceforge.net/ || lame

-   liba52 — Free library for decoding ATSC A/52 streams.

http://liba52.sourceforge.net/ || a52dec

-   libdca — Free library for decoding DTS Coherent Acoustics streams.

https://www.videolan.org/developers/libdca.html || libdca

-   libde265 — Open source implementation of the h.265 video codec.

https://github.com/strukturag/libde265 || libde265 libde265-git

-   libdv — The Quasar DV codec (libdv) is a software codec for DV
    video.

http://libdv.sourceforge.net/ || libdv

-   libmpeg2 — Library for decoding MPEG-1 and MPEG-2 video streams.

http://libmpeg2.sourceforge.net/ || libmpeg2

-   MAD — High-quality MPEG audio decoder.

http://www.underbit.com/products/mad/ || libmad

-   Nero AAC — AAC audio codec (decode/encode/tag) all-in-one.

http://www.nero.com/eng/company/about-nero/nero-aac-codec.php || neroaac

-   opencore-amr — Open source implementation of the Adaptive Multi Rate
    (AMR) speech codec.

http://sourceforge.net/projects/opencore-amr/ || opencore-amr

-   Speex — Patent-free audio compression format designed for speech.

http://www.speex.org/ || speex

-   Theora — Open video codec developed by the Xiph.org.

http://www.theora.org/ || libtheora

-   Vorbis — Completely open, patent-free, professional audio encoding
    and streaming technology.

http://www.vorbis.com/ || libvorbis

-   libvpx — High-quality, open video format for the web that's freely
    available to everyone.

http://www.webmproject.org || libvpx libvpx-git

-   Opus — Totally open, royalty-free, highly versatile audio codec.
    Opus is unmatched for interactive speech and music transmission over
    the Internet, but is also intended for storage and streaming
    applications. It is standardized by the Internet Engineering Task
    Force (IETF) as RFC 6716 which incorporated technology from Skype's
    SILK codec and Xiph.Org's CELT codec.

http://www.opus-codec.org/ || opus opus-git

-   Schrödinger — Advanced royalty-free video compression format
    designed for a wide range of uses, from delivering low-resolution
    web content to broadcasting HD and beyond, to near-lossless studio
    editing.

http://www.audiocoding.com/faac.html || schroedinger

-   WavPack — Audio compression format with lossless, lossy, and hybrid
    compression modes.

http://www.wavpack.com/ || wavpack

-   x264 — Free library for encoding H264/AVC video streams.

https://www.videolan.org/developers/x264.html || x264 x264-git

-   x265 — Open-source project and free application library for encoding
    video streams into the H.265/High Efficiency Video Coding (HEVC)
    format.

http://x265.org/ || x265 x265-hg

-   XviD — Open source MPEG-4 video codec.

http://www.xvid.org/ || xvidcore

Backends
--------

> GStreamer

From http://www.gstreamer.net/:

GStreamer is a library for constructing graphs of media-handling
components. The applications supports range from simple Ogg/Vorbis
playback, audio/video streaming to complex audio (mixing) and video
(non-linear editing) processing.

Simply, GStreamer is a backend or framework utilized by many media
applications. See GStreamer article.

> xine

From http://www.xine-project.org/about:

xine is a free (gpl-licensed) high-performance, portable and reusable
multimedia playback engine. xine itself is a shared library with an easy
to use, yet powerful API which is used by many applications for smooth
video playback and video processing purposes.

As an alternative to GStreamer, many media players can be configured to
utilize the xine backend provided by xine-lib.

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
player, just install the Gstreamer libav library to fix it install
gst-libav.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Codecs&oldid=290650"

Category:

-   Audio/Video

-   This page was last modified on 28 December 2013, at 13:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
