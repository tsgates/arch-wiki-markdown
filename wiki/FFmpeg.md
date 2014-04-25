FFmpeg
======

From the project home page:

FFmpeg is a complete, cross-platform solution to record, convert and
stream audio and video. It includes libavcodec - the leading audio/video
codec library.

Contents
--------

-   1 Package installation
-   2 Encoding examples
    -   2.1 Screen cast
    -   2.2 Recording webcam
    -   2.3 VOB to any container
    -   2.4 x264 lossless
    -   2.5 Single-pass MPEG-2 (near lossless)
    -   2.6 x264: constant rate factor
    -   2.7 YouTube
    -   2.8 Two-pass x264 (very high-quality)
    -   2.9 Two-pass MPEG-4 (very high-quality)
        -   2.9.1 Determining bitrates with fixed output file sizes
    -   2.10 Subtitles
        -   2.10.1 Extracting
        -   2.10.2 Hardsubbing
    -   2.11 Volume gain
    -   2.12 Extracting audio
    -   2.13 Stripping audio
-   3 Preset files
    -   3.1 Using preset files
        -   3.1.1 libavcodec-vhq.ffpreset
            -   3.1.1.1 Two-pass MPEG-4 (very high quality)
-   4 Package removal
-   5 See also

Package installation
--------------------

Various flavors and related projects can be installed from the official
repositories and the AUR:

-   ffmpeg – official package

Notable variants:

-   ffmpeg-git – development version
-   ffmpeg-full – built with as much optional features enabled as
    possible

Forks:

-   ffmbc – targeted for broadcasting usage
-   libav-git – the binary it provides is called avconv instead of
    ffmpeg

Encoding examples
-----------------

> Screen cast

FFmpeg includes the x11grab and ALSA virtual devices that enable
capturing the entire user display and audio input.

First create test.mkv with lossless encoding:

    $ ffmpeg -f x11grab -video_size 1920x1080 -i $DISPLAY -f alsa -i default -c:v ffvhuff -c:a flac test.mkv

where -video_size specifies the size of the area to capture. Check the
FFmpeg manual for examples of how to change the screen or position of
the capture area. Then you may process the MKV into a smaller WebM file:

    $ ffmpeg -i test.mkv  -c:v libvpx -c:a libvorbis  -b:v 2000k -q:a 3 test.webm

> Recording webcam

FFmpeg supports grabbing input from Video4Linux2 devices. The following
command will record a video from the webcam, assuming that the webcam is
correctly recognized under /dev/video0:

    $ ffmpeg -f v4l2 -s 640x480 -i /dev/video0 output.mpg

The above produces a silent video. It is also possible to include audio
sources from a microphone. The following command will include a stream
from the default ALSA recording device into the video:

    $ ffmpeg -f alsa -i default -f v4l2 -s 640x480 -i /dev/video0 output.mpg

To use PulseAudio with an ALSA backend:

    $ ffmpeg -f alsa -i pulse -f v4l2 -s 640x480 -i /dev/video0 output.mpg

For a higher quality capture, try encoding the output using higher
quality codecs:

    $ ffmpeg -f alsa -i default -f v4l2 -s 640x480 -i /dev/video0 -acodec flac \
    -vcodec libx264 output.mkv

> VOB to any container

Concatenate the desired VOB files into a single stream and mux them to
MPEG-2:

    $ cat f0.VOB f1.VOB f2.VOB | ffmpeg -i - out.mp2

> x264 lossless

The ultrafast preset will provide the fastest encoding and is useful for
quick capturing (such as screencasting):

    $ ffmpeg -i input -vcodec libx264 -preset ultrafast -qp 0 -acodec copy output.mkv

On the opposite end of the preset spectrum is veryslow and will encode
slower than ultrafast but provide a smaller output file size:

    $ ffmpeg -i input -vcodec libx264 -preset veryslow -qp 0 -acodec copy output.mkv

Both examples will provide the same quality output.

> Single-pass MPEG-2 (near lossless)

Allow FFmpeg to automatically set DVD standardized parameters. Encode to
DVD MPEG-2 at ~30 FPS:

    $ ffmpeg -i video.VOB -target ntsc-dvd -q:a 0 -q:v 0 output.mpg

Encode to DVD MPEG-2 at ~24 FPS:

    $ ffmpeg -i video.VOB -target film-dvd -q:a 0 -q:v 0 output.mpg

> x264: constant rate factor

Used when you want a specific quality output. General usage is to use
the highest -crf value that still provides an acceptable quality. Lower
values are higher quality; 0 is lossless, 18 is visually lossless, and
23 is the default value. A sane range is between 18 and 28. Use the
slowest -preset you have patience for. See the x264 Encoding Guide for
more information.

    $ ffmpeg -i video -vcodec libx264 -preset slow -crf 22 -acodec libmp3lame -aq 4 output.mkv

-tune option can be used to match the type and content of the of media
being encoded.

> YouTube

FFmpeg is very useful to encode videos and strip their size before you
upload them on YouTube. The following single line of code takes an input
file and outputs a mkv container.

    $ ffmpeg -i video -c:v libx264 -crf 18 -preset slow -pix_fmt yuv420p -c:a copy output.mkv

For more information see the forums. You can also create a custom alias
ytconvert which takes the name of the input file as first argument and
the name of the .mkv container as second argument. To do so add the
following to your ~/.bashrc:

    youtubeConvert(){
            ffmpeg -i $1 -c:v libx264 -crf 18 -preset slow -pix_fmt yuv420p -c:a copy $2.mkv
    }
    alias ytconvert=youtubeConvert

See also Arch Linux forum thread.

> Two-pass x264 (very high-quality)

Audio deactivated as only video statistics are recorded during the first
of multiple pass runs:

    $ ffmpeg -i video.VOB -an -vcodec libx264 -pass 1  -preset veryslow \
    -threads 0 -b 3000k -x264opts frameref=15:fast_pskip=0 -f rawvideo -y /dev/null

Container format is automatically detected and muxed into from the
output file extenstion (.mkv):

    $ ffmpeg -i video.VOB -acodec libvo-aacenc -ab 256k -ar 96000 -vcodec libx264 \
    -pass 2 -preset veryslow -threads 0 -b 3000k -x264opts frameref=15:fast_pskip=0 video.mkv

Tip:If you receive Unknown encoder 'libvo-aacenc' error (given the fact
that your ffmpeg is compiled with libvo-aacenc enabled), you may want to
try -acodec libvo_aacenc, an underscore instead of hyphen.

> Two-pass MPEG-4 (very high-quality)

Audio deactivated as only video statistics are logged during the first
of multiple pass runs:

    $ ffmpeg -i video.VOB -an -vcodec mpeg4 -pass 1 -mbd 2 -trellis 2 -flags +cbp+mv0 \
    -pre_dia_size 4 -dia_size 4 -precmp 4 -cmp 4 -subcmp 4 -preme 2 -qns 2 -b 3000k \
    -f rawvideo -y /dev/null

Container format is automatically detected and muxed into from the
output file extenstion (.avi):

    $ ffmpeg -i video.VOB -acodec copy -vcodec mpeg4 -vtag DX50 -pass 2 -mbd 2 -trellis 2 \
    -flags +cbp+mv0 -pre_dia_size 4 -dia_size 4 -precmp 4 -cmp 4 -subcmp 4 -preme 2 -qns 2 \
    -b 3000k video.avi

-   Introducing threads=n>1 for -vcodec mpeg4 may skew the effects of
    motion estimation and lead to reduced video quality and compression
    efficiency.
-   The two-pass MPEG-4 example above also supports output to the MP4
    container (replace .avi with .mp4).

Determining bitrates with fixed output file sizes

-   (Desired File Size in MB - Audio File Size in MB) x 8192 kb/MB /
    Length of Media in Seconds (s) = Bitrate in kb/s

-   (3900 MB - 275 MB) = 3625 MB x 8192 kb/MB / 8830 s = 3363 kb/s
    required to achieve an approximate total output file size of 3900 MB

> Subtitles

Extracting

Subtitles embedded in container files, such as MPEG-2 and Matroska, can
be extracted and converted into SRT, SSA, among other subtitle formats.

-   Inspect a file to determine if it contains a subtitle stream:

    $ ffprobe foo.mkv

    ...
    Stream #0:0(und): Video: h264 (High), yuv420p, 1920x800 [SAR 1:1 DAR 12:5], 23.98 fps, 23.98 tbr, 1k tbn, 47.95 tbc (default)
      Metadata:
      CREATION_TIME   : 2012-06-05 05:04:15
      LANGUAGE        : und
    Stream #0:1(und): Audio: aac, 44100 Hz, stereo, fltp (default)
     Metadata:
     CREATION_TIME   : 2012-06-05 05:10:34
     LANGUAGE        : und
     HANDLER_NAME    : GPAC ISO Audio Handler
    Stream #0:2: Subtitle: ssa (default)

-   foo.mkv has an embedded SSA subtitle which can be extracted into an
    independent file:

    $ ffmpeg -i foo.mkv foo.ssa

Hardsubbing

(instructions based on an FFmpeg wiki article)

Hardsubbing entails merging subtitles with the video. Hardsubs can't be
disabled, nor language switched.

-   Overlay foo.mpg with the subtitles in foo.ssa:

    $ ffmpeg -i foo.mpg -c copy -vf subtitles=foo.ssa out.mpg

> Volume gain

Change the audio volume in multiples of 256 where 256 = 100% (normal)
volume. Additional values such as 400 are also valid options.

    -vol 256  = 100%
    -vol 512  = 200%
    -vol 768  = 300%
    -vol 1024 = 400%
    -vol 2048 = 800%

To double the volume (512 = 200%) of an MP3 file:

    $ ffmpeg -i file.mp3 -vol 512 louder file.mp3

To quadruple the volume (1024 = 400%) of an Ogg file:

    $ ffmpeg -i file.ogg -vol 1024 louder file.ogg

Note that gain metadata is only written to the output file. Unlike
mp3gain or ogggain, the source sound file is untouched.

> Extracting audio

    $ ffmpeg -i video.mpg

    ...
    Input #0, avi, from 'video.mpg':
      Duration: 01:58:28.96, start: 0.000000, bitrate: 3000 kb/s
        Stream #0.0: Video: mpeg4, yuv420p, 720x480 [PAR 1:1 DAR 16:9], 29.97 tbr, 29.97 tbn, 29.97 tbc
        Stream #0.1: Audio: ac3, 48000 Hz, stereo, s16, 384 kb/s
        Stream #0.2: Audio: ac3, 48000 Hz, 5.1, s16, 448 kb/s
        Stream #0.3: Audio: dts, 48000 Hz, 5.1 768 kb/s
    ...

Extract the first (-map 0:1) AC-3 encoded audio stream exactly as it was
multiplexed into the file:

    $ ffmpeg -i video.mpg -map 0:1 -acodec copy -vn video.ac3

Convert the third (-map 0:3) DTS audio stream to an AAC file with a
bitrate of 192 kb/s and a sampling rate of 96000 Hz:

    $ ffmpeg -i video.mpg -map 0:3 -acodec libvo-aacenc -ab 192k -ar 96000 -vn output.aac

-vn disables the processing of the video stream.

Extract audio stream with certain time interval:

    $ ffmpeg -ss 00:01:25 -t 00:00:05 -i video.mpg -map 0:1 -acodec copy -vn output.ac3

-ss specifies the start point, and -t specifies the duration.

> Stripping audio

1.  Copy the first video stream (-map 0:0) along with the second AC-3
    audio stream (-map 0:2).
2.  Convert the AC-3 audio stream to two-channel MP3 with a bitrate of
    128 kb/s and a sampling rate of 48000 Hz.

    $ ffmpeg -i video.mpg -map 0:0 -map 0:2 -vcodec copy -acodec libmp3lame \
    -ab 128k -ar 48000 -ac 2 video.mkv

    $ ffmpeg -i video.mkv

    ...
    Input #0, avi, from 'video.mpg':
      Duration: 01:58:28.96, start: 0.000000, bitrate: 3000 kb/s
        Stream #0.0: Video: mpeg4, yuv420p, 720x480 [PAR 1:1 DAR 16:9], 29.97 tbr, 29.97 tbn, 29.97 tbc
        Stream #0.1: Audio: mp3, 48000 Hz, stereo, s16, 128 kb/s

Note:Removing undesired audio streams allows for additional bits to be
allocated towards improving video quality.

Preset files
------------

Populate ~/.ffmpeg with the default preset files:

    $ cp -iR /usr/share/ffmpeg ~/.ffmpeg

Create new and/or modify the default preset files:

    ~/.ffmpeg/libavcodec-vhq.ffpreset

    vtag=DX50
    mbd=2
    trellis=2
    flags=+cbp+mv0
    pre_dia_size=4
    dia_size=4
    precmp=4
    cmp=4
    subcmp=4
    preme=2
    qns=2

> Using preset files

Enable the -vpre option after declaring the desired -vcodec

libavcodec-vhq.ffpreset

-   libavcodec = Name of the vcodec/acodec
-   vhq = Name of specific preset to be called out
-   ffpreset = FFmpeg preset filetype suffix

Two-pass MPEG-4 (very high quality)

First pass of a multipass (bitrate) ratecontrol transcode:

    $ ffmpeg -i video.mpg -an -vcodec mpeg4 -pass 1 -vpre vhq -f rawvideo -y /dev/null

Ratecontrol based on the video statistics logged from the first pass:

    $ ffmpeg -i video.mpg -acodec libvorbis -aq 8 -ar 48000 -vcodec mpeg4 \
    -pass 2 -vpre vhq -b 3000k output.mp4

-   libvorbis quality settings (VBR)

-   -aq 4 = 128 kb/s
-   -aq 5 = 160 kb/s
-   -aq 6 = 192 kb/s
-   -aq 7 = 224 kb/s
-   -aq 8 = 256 kb/s

-   aoTuV is generally preferred over libvorbis provided by Xiph.Org and
    is provided by libvorbis-aotuv in the AUR.

Package removal
---------------

pacman will not remove configuration files outside of the defaults that
were created during package installation. This includes user-created
preset files.

See also
--------

-   x264 Settings - MeWiki documentation
-   FFmpeg documentation - official documentation
-   Encoding with the x264 codec - MEncoder documentation
-   H.264 encoding guide - Avidemux wiki
-   Using FFmpeg - Linux how to pages
-   List of supported audio and video streams

Retrieved from
"https://wiki.archlinux.org/index.php?title=FFmpeg&oldid=305455"

Category:

-   Audio/Video

-   This page was last modified on 18 March 2014, at 15:07.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
