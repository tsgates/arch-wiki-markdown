FFmpeg
======

  Summary
  --------------------------------------------------------------------------------------------------
  This article attempts to walk users through the installation, usage and configuration of FFmpeg.

FFmpeg is command-line driven collection of tools which enables the
decoding, encoding, conversion and playback of most audio and video
streams.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Package installation                                               |
| -   2 Encoding examples                                                  |
|     -   2.1 Screen cast to .webm                                         |
|     -   2.2 VOB to any container                                         |
|     -   2.3 x264 Lossless                                                |
|     -   2.4 Single-pass MPEG-2 (near lossless)                           |
|     -   2.5 x264: Constant Rate Factor                                   |
|     -   2.6 YouTube                                                      |
|     -   2.7 Two-pass x264 (very high-quality)                            |
|     -   2.8 Two-pass MPEG-4 (very high-quality)                          |
|         -   2.8.1 Determining bitrates with fixed output file sizes      |
|                                                                          |
|     -   2.9 Softsubs to hardsubs                                         |
|                                                                          |
| -   3 Preset files                                                       |
|     -   3.1 Creating presets                                             |
|     -   3.2 Using preset files                                           |
|         -   3.2.1 libavcodec-vhq.ffpreset                                |
|             -   3.2.1.1 Two-pass MPEG-4 (very high quality)              |
|                                                                          |
| -   4 Volume gain                                                        |
| -   5 Extracting audio                                                   |
|     -   5.1 Stripping audio                                              |
|                                                                          |
| -   6 Adding subtitles                                                   |
| -   7 Recording webcam                                                   |
| -   8 Package removal                                                    |
| -   9 Additional resources                                               |
+--------------------------------------------------------------------------+

Package installation
--------------------

FFmpeg is part of the official Arch Linux [extra] repository.

    # pacman -S ffmpeg

Encoding examples
-----------------

> Screen cast to .webm

Using x11grab to video grab your display and using ALSA for sound. First
we create lossless raw file `test.mkv`.

    $ ffmpeg -f x11grab -r 30 -i :0.0 -f alsa -i hw:0,0 -acodec flac -vcodec ffvhuff test.mkv

Then we process this `test.mkv` file into a smaller `test.webm` end
product. Complex switches like `c:a` & `c:v` convert the stream into
what's needed for WebM.

    $ ffmpeg -y -i test.mkv -c:a libvorbis -q:a 3 -c:v libvpx -b:v 2000k test.webm

See https://github.com/kaihendry/recordmydesktop2.0/blob/master/r2d2.sh
for a more fleshed out example.

> VOB to any container

Concatenate the desired VOB files into a single VOB file:

    $ cat VTS_01_1.VOB VTS_01_2.VOB VTS_01_3.VOB VTS_01_4.VOB > Transformers.3.Dark.of.the.Moon.VOB

Or concatenate and then pipe the output VOB to FFmpeg:

    $ cat VTS_01_1.VOB VTS_01_2.VOB VTS_01_3.VOB VTS_01_4.VOB > Transformers.3.Dark.of.the.Moon.VOB | ffmpeg -i ...

> x264 Lossless

The ultrafast preset will provide the fastest encoding and is useful for
quick capturing (such as screencasting):

    ffmpeg -i input -vcodec libx264 -preset ultrafast -qp 0 -acodec copy output.mkv

On the opposite end of the preset spectrum is veryslow and will encode
slower than ultrafast but provide a smaller output file size:

    ffmpeg -i input -vcodec libx264 -preset veryslow -qp 0 -acodec copy output.mkv

Both examples will provide the same quality output.

> Single-pass MPEG-2 (near lossless)

Allow FFmpeg to automatically set DVD standardized parameters. Encode to
DVD MPEG-2 at a frame rate of 30 frames/second:

    ffmpeg -i 13.Assassins.VOB -target ntsc-dvd -sameq 13.Assassins.mpg

Encode to DVD MPEG-2 at a frame rate of 24 frames/second:

    ffmpeg -i 13.Assassins.VOB -target film-dvd -sameq 13.Assassins.mpg

> x264: Constant Rate Factor

Used when you want a specific quality output. General usage is to use
the highest -crf value that still provides an acceptable quality. A sane
range is 18-28 and 23 is default. 18 is considered to be visually
lossless. Use the slowest -preset you have patience for. See the x264
Encoding Guide for more information.

    ffmpeg -i input -vcodec libx264 -preset slow -crf 22 -acodec libmp3lame -aq 4 output.mkv

-tune option can be used to match the type and content of the of media
being encoded.

> YouTube

FFmpeg is very useful to encode videos and strip their size before you
upload them on YouTube. The following single line of code takes an input
file and outputs a .mkv container.

    ffmpeg -i INPUT -c:v libx264 -crf 18 -preset slow -pix_fmt yuv420p -c:a copy OUTPUT.mkv

For more information see the forums. You can also create a custom alias
ytconvert which takes the name of the input file as first argument and
the name of the .mkv container as second argument. To do so add the
following to your ~/.bashrc:

    # Convert videos for YouTube
    # See also https://bbs.archlinux.org/viewtopic.php?pid=1200542#p1200542
    youtubeConvert()
    {
    ffmpeg -i $1 -c:v libx264 -crf 18 -preset slow -pix_fmt yuv420p -c:a copy $2.mkv
    }
    alias ytconvert=youtubeConvert

> Two-pass x264 (very high-quality)

Audio deactivated as only video statistics are recorded during the first
of multiple pass runs:

    ffmpeg -i Transformers.3.Dark.of.the.Moon.VOB -an -vcodec libx264 -pass 1 -preset veryslow -threads 0 -b 3000k -x264opts frameref=15:fast_pskip=0 -f rawvideo -y /dev/null

Container format is automatically detected and muxed into from the
output file extenstion (.mkv):

    ffmpeg -i Transformers.3.Dark.of.the.Moon.VOB -acodec libvo-aacenc -ab 256k -ar 96000 -vcodec libx264 -pass 2 -preset veryslow -threads 0 -b 3000k -x264opts frameref=15:fast_pskip=0 Transformers.3.Dark.of.the.Moon.mkv

Tips

If you receive Unknown encoder 'libvo-aacenc' error (given the fact that
your ffmpeg is compiled with libvo-aacenc enabled), you may want to try
...-acodec libvo_aacenc..., an underscore instead of hyphen.

> Two-pass MPEG-4 (very high-quality)

Audio deactivated as only video statistics are logged during the first
of multiple pass runs:

    ffmpeg -i Transformers.3.Dark.of.the.Moon.VOB -an -vcodec mpeg4 -pass 1 -mbd 2 -trellis 2 -flags +cbp+mv0 -pre_dia_size 4 -dia_size 4 -precmp 4 -cmp 4 -subcmp 4 -preme 2 -qns 2 -b 3000k -f rawvideo -y /dev/null

Container format is automatically detected and muxed into from the
output file extenstion (.avi):

    ffmpeg -i Transformers.3.Dark.of.the.Moon.VOB -acodec copy -vcodec mpeg4 -vtag DX50 -pass 2 -mbd 2 -trellis 2 -flags +cbp+mv0 -pre_dia_size 4 -dia_size 4 -precmp 4 -cmp 4 -subcmp 4 -preme 2 -qns 2 -b 3000k Transformers.3.Dark.of.the.Moon.avi

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

> Softsubs to hardsubs

If have a softsubbed video (eg. ASS/SSA subs in a mkv container like
most anime) you can 'burn' these subs into a new file to be played on a
device which does not support subs or is to weak to display complex
subs.

-   Install mkvtoolnix-cli to pull out *.ass files from *.mkv files.

-   Recompile ffmpeg with --enable-libass if it is not already enabled
    in your ffmpeg build. See ABS for easy recompiling.

-   Pull out subs from your file. This command assumes that track #2 is
    the ASS/SSA track. Use mkvinfo if it is not.

    mkvextract tracks YourFile.mkv 2:YourFile.ass

-   Recode file with ffmpeg. See sections above for suitable options. It
    is very important to disable sub-recording -sn and enable
    sub-rendering -vf ass=YourFile.ass

Output is set as *.mp4 since the default Android 4.2 player dislikes
*.mkv. (But VLC on Android works with mkv). Example:

    ffmpeg -i YourFile.mkv -sn -vcodec libx264 -crf 18 -preset slow -vf ass=YourFile.ass -acodec copy Output.mp4

Preset files
------------

> Creating presets

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

    ffmpeg -i 13.Assassins.2010.mpg -an -vcodec mpeg4 -pass 1 -vpre vhq -f rawvideo -y /dev/null

Ratecontrol based on the video statistics logged from the first pass:

    ffmpeg -i 13.Assassins.2010.mpg -acodec libvorbis -aq 8 -ar 48000 -vcodec mpeg4 -pass 2 -vpre vhq -b 3000k 13.Assassins.2010.mp4

-   libvorbis quality settings (VBR)

-   -aq 4 = 128 kb/s
-   -aq 5 = 160 kb/s
-   -aq 6 = 192 kb/s
-   -aq 7 = 224 kb/s
-   -aq 8 = 256 kb/s

-   aoTuV is generally preferred over libvorbis provided by Xiph.Org and
    is provided by libvorbis-aotuv in the AUR.

Volume gain
-----------

Change the audio volume in multiples of 256 where 256 = 100% (normal)
volume. Additional values such as 400 are also valid options.

    -vol 256  = 100%
    -vol 512  = 200%
    -vol 768  = 300%
    -vol 1024 = 400%
    -vol 2048 = 800%

To double the volume (512 = 200%) of an MP3 file:

    ffmpeg -i example.mp3 -vol 512 loud-example.mp3

To quadruple the volume (1024 = 400%) of an Ogg file:

    ffmpeg -i example.ogg -vol 1024 loud-example.ogg

Note that gain metadata is only written to the output file. Unlike
mp3gain or ogggain, the source sound file is untouched.

Extracting audio
----------------

    $ ffmpeg -i The.Kings.Speech.mpg
    Input #0, avi, from 'The.Kings.Speech.2010.mpg':  Duration: 01:58:28.96, start: 0.000000, bitrate: 3000 kb/s    Stream #0.0: Video: mpeg4, yuv420p, 720x480 [PAR 1:1 DAR 16:9], 29.97 tbr, 29.97 tbn, 29.97 tbc    Stream #0.1: Audio: ac3, 48000 Hz, stereo, s16, 384 kb/s    Stream #0.2: Audio: ac3, 48000 Hz, 5.1, s16, 448 kb/s    Stream #0.3: Audio: dts, 48000 Hz, 5.1 768 kb/s

Extract the first (-map 0:1) AC-3 encoded audio stream exactly as it was
multiplexed into the file:

    ffmpeg -i The.Kings.Speech.mpg -map 0:1 -acodec copy -vn The.Kings.Speech.ac3

Convert the third (-map 0:3) DTS audio stream to an AAC file with a
bitrate of 192 kb/s and a sampling rate of 96000 Hz:

    ffmpeg -i The.Kings.Speech.mpg -map 0:3 -acodec libvo-aacenc -ab 192k -ar 96000 -vn The.Kings.Speech.aac

-vn disables the processing of the video stream.

Extract audio stream with certain time interval:

    ffmpeg -ss 00:01:25 -t 00:00:05 -i The.Kings.Speech.mpg -map 0:1 -acodec copy -vn The.Kings.Speech.ac3

-ss specifies the start point, and -t specifies the duration.

> Stripping audio

1.  Copy the first video stream (-map 0:0) along with the second AC-3
    audio stream (-map 0:2).
2.  Convert the AC-3 audio stream to two-channel MP3 with a bitrate of
    128 kb/s and a sampling rate of 48000 Hz.

    ffmpeg -i The.Kings.Speech.mpg -map 0:0 -map 0:2 -vcodec copy -acodec libmp3lame -ab 128k -ar 48000 -ac 2 The.Kings.Speech.mkv

    $ ffmpeg -i The.Kings.Speech.mkv
    Input #0, avi, from 'The.Kings.Speech.2010.mpg':  Duration: 01:58:28.96, start: 0.000000, bitrate: 3000 kb/s    Stream #0.0: Video: mpeg4, yuv420p, 720x480 [PAR 1:1 DAR 16:9], 29.97 tbr, 29.97 tbn, 29.97 tbc    Stream #0.1: Audio: mp3, 48000 Hz, stereo, s16, 128 kb/s

Note:Removing undesired audio streams allows for additional bits to be
allocated towards improving video quality.

Adding subtitles
----------------

FFmpeg does not currently support muxing subtitle files into existing
streams. See MEncoder for subtitle muxing support.

Recording webcam
----------------

FFmpeg supports grabbing input from Video4Linux2 devices. The following
command will record a video from the webcam, assuming that the webcam is
correctly recognized under /dev/video0:

    $ ffmpeg -f v4l2 -s 640x480 -i /dev/video0 out.mpg

The above produces a silent video. It is also possible to include audio
sources from a microphone. The following command will include a stream
from the default ALSA recording device into the video:

    $ ffmpeg -f alsa -i default -f v4l2 -s 640x480 -i /dev/video0 out.mpg

To use PulseAudio with an ALSA backend:

    $ ffmpeg -f alsa -i pulse -f v4l2 -s 640x480 -i /dev/video0 out.mpg

For a higher quality capture, try encoding the output using higher
quality codecs:

    $ ffmpeg -f alsa -i default -f v4l2 -s 640x480 -i /dev/video0 -acodec flac -vcodec libx264 out.mkv

Package removal
---------------

pacman will not remove configuration files outside of the defaults that
were created during package installation. This includes user-created
preset files.

Additional resources
--------------------

-   x264 Settings - MeWiki Documentation
-   FFmpeg Documentation - Official Documentation
-   Encoding with the x264 Codec - MEncoder Documentation
-   H.264 eEcoding Guide - Avidemux Wiki
-   Using FFmpeg - Linux How To Pages

Retrieved from
"https://wiki.archlinux.org/index.php?title=FFmpeg&oldid=243137"

Category:

-   Audio/Video
