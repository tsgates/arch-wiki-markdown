MEncoder
========

> Summary

An overview of the video encoding/decoding tool provided by MPlayer.

> Related

DVD Ripping

Dvd2Avi

MPlayer

Video2dvdiso

MEncoder is part of the mencoder package.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Basics                                                             |
| -   2 Example                                                            |
|     -   2.1 Ripping and encoding the video                               |
|     -   2.2 Ripping and encoding the audio                               |
|     -   2.3 Making the final .mkv file                                   |
|     -   2.4 Encoding video mp4 for Nokia 5800 XM and Nokia N97           |
|     -   2.5 Encoding a multi audio / multi language MKV video to an MP4  |
|         with different audio streams                                     |
|     -   2.6 Adding SubRip subtitles to a file                            |
|         -   2.6.1 Two-pass x264 (very high-quality)                      |
|         -   2.6.2 Single-pass x264 (very high-quality)                   |
|         -   2.6.3 Two-pass xvid (very high-quality)                      |
|         -   2.6.4 Three-pass lavc (very high-quality mpeg4)              |
|         -   2.6.5 Single-pass lavc (very high-quality mpeg-2)            |
|                                                                          |
|     -   2.7 Adding VOBsub subtitles to a file                            |
|         -   2.7.1 Two-pass x264 (very high-quality)                      |
|         -   2.7.2 Testing subtitle muxing results                        |
|             -   2.7.2.1 Single-pass x264 (low quality)                   |
|                                                                          |
|     -   2.8 mp2 vs. mp3lame vs. aac                                      |
|                                                                          |
| -   3 GUI frontends                                                      |
+--------------------------------------------------------------------------+

Basics
------

The basic syntax for a conversion is

    mencoder original_video.mpg -o new_video.avi -ovc output_video_codec -oac output_audio_codec

So to convert movie.mpg to movie.avi with MPEG-4 Part 2 video and MP2
audio, the command is

    mencoder movie.mpg -o movie.avi -ovc lavc -oac lavc

The default output formats without any options are MPEG-4 for video and
MP2 for audio.

This is basically how one converts a video. However, there are MANY more
options available.

For input formats, MEncoder can use any format that MPlayer can play, so
to verify whether it will work with your video, just try playing it in
MPlayer.

To list output video codecs, run

    $ mencoder -ovc help

Similarly, to list output audio codecs, run

    $ mencoder -oac help

This information can also be found here where it better explained,
although non-specific.

There are many more options available (e.g. you can define bit rates and
expected sizes).

See the Gentoo Linux Wiki article on this subject for more information:
Mencoder

Example
-------

This approach allows one to make a .mkv file with an H.264-encoded video
and any number of Vorbis-encoded audio tracks.

We will use mencoder (part of mplayer package) for ripping and encoding
and mkvmerge (part of mkvtoolnix package) for making the .mkv file
itself.

> Ripping and encoding the video

The H.264 encoder is usually used in two passes: the first reads
informations about the movie, the second uses that information to
encode. We will not extract any audio for now.

Commands follow; remember to replace the variables with the proper
values:

    # First pass: we are just collecting information, so the normal output is thrown away.
    mencoder -dvd-device "$ISO" dvd://"$TITLE" -chapter "$CHAPTER" -o /dev/null -nosound -ovc x264 \
    -x264encopts direct=auto:pass=1:turbo:bitrate=900:bframes=1:\
    me=umh:partitions=all:trellis=1:qp_step=4:qcomp=0.7:direct_pred=auto:keyint=300 \
    -vf scale=-1:-10,harddup

    # Second pass: here we compress the video track using the information from the first step.
    mencoder -dvd-device "$ISO" dvd://"$TITLE" -chapter "$CHAPTER" -nosound -ovc x264 \
    -x264encopts direct=auto:pass=2:bitrate=900:frameref=5:bframes=1:\
    me=umh:partitions=all:trellis=1:qp_step=4:qcomp=0.7:direct_pred=auto:keyint=300 \
    -vf scale=-1:-10,harddup -o video.avi

This will create a video.avi file containing the video. You can play
with the -x264encopts options and the -vf filters to improve the quality
or reduce the file size. For example, a movie with a black border should
be cropped with -vf crop=$X:$Y,scale=-1:-10,harddup with the proper
values instead of $X and $Y (see cropdetect in the MEncoder manual). You
may want to scale down the movie with -vf scale=$WIDTH:-10,harddup the
width of the movie will become $WIDTH (keep $WIDTH a multiple of 16:
640, 480, or 320 are usually fine), the height will be correctly
calculated in order to keep the aspect ratio.

You can also use any other of the filters MEncoder has to offer, like
pullup,softskip or you can change the frame rate using -ofps. (If you do
so, remember to use the same frame rate everywhere including in the
commands to rip audio.)

It is important that you use harddup as the last filter: it will force
MEncoder to write every frame (even duplicate ones) in the output. Also,
it is necessary to use scale=$WIDTH,-10 with $WIDTH as -1 to keep the
original width or a new, usually smaller, width: it is necessary since
the H.264 codec uses square pixels and DVDs instead use rectangular
pixels.

> Ripping and encoding the audio

You can extract audio tracks as needed. Here we compress with the Vorbis
algorithm, but you may want to check the MEncoder manual in order to see
alternatives.

The command follows (replace the variables with desired values):

    # Here we rip and compress the audio.
    mencoder -dvd-device "$ISO" dvd://"$TITLE" -alang "$AUDIOLANG" -chapter "$CHAPTER" -ovc frameno \
    -oac lavc -lavcopts acodec=vorbis:abitrate=224 -channels 2 -srate 48000 -o "$AUDIOLANG".avi

You should repeat the command for every audio track you want, so we will
have .avi files with the audio track.

You may also want to use -channels 6 to exact all the channels of a 5.1
DVD or changing the bit rate. As with the video, you can use audio
filters via -af but it is not necessary.

> Making the final .mkv file

Putting it all together in a single file is simple. Add other audio
tracks if needed:

    mkvmerge -D audio.avi -A video.avi -o mymovie.mkv

The .mkv file will contain everything, so you can store your movie
keeping all the audio track you want. Even if you are not interested in
keeping multiple sound tracks, the H.264/Vorbis format pair should
ensure great quality.

Of course to make the work easier, you should write every command in a
single file and execute it.

See Dvd2Avi for a sample script.

> Encoding video mp4 for Nokia 5800 XM and Nokia N97

In 2 passes with small bitrates (640kbps video vbitrate and 96kbps audio
abitrate) yields pretty watchable video mp4 for nokia 5800 xm and Nokia
N97 phones' default video player. Let's assume that we have a video.avi
file (replace video.avi with your video file)

mkv to mp4 (nokia 97, 5800 compatible)

    # step 1: convert the mkv to mpg ; many mkv files do not directly get converted to mp4
    mencoder "$1" -ovc lavc -lavcopts vcodec=mpeg1video -aid 0 -oac pcm -o delete_me.mpg
    # step 2: convert the mpg file to mp4
    mencoder -of lavf -lavfopts format=mp4 -oac lavc -ovc lavc -lavcopts \
    aglobal=1:vglobal=1:acodec=libfaac:vcodec=mpeg4:abitrate=128:vbitrate=640:keyint=250:mbd=1:vqmax=10:lmax=10:turbo  -af lavcresample=44100 \
    -vf harddup,scale=640:-3 "delete_me.mpg" -o "$1.mp4"
    # step 3: delete the temporary huge sized mpg file 
    rm "delete_me.mpg"

replace "$1" with the .mkv video filename. e.g., sample.mkv; here -aid 0
= first audio track in mkv;

Converting an avi to mp4 (nokia 97, 5800 compatible) using multipass (2
passes)

    # First pass:
    mencoder -of lavf -lavfopts format=mp4 -oac lavc -ovc lavc -lavcopts \
    aglobal=1:vglobal=1:acodec=libfaac:vcodec=mpeg4:abitrate=96:vbitrate=640:keyint=250:mbd=1:vqmax=10:lmax=10:vpass=1:turbo  -af lavcresample=44100 \
    -vf harddup,scale=640:-3 "video.avi" -o "video.mp4"

    # Second pass:
    mencoder -of lavf -lavfopts format=mp4 -oac lavc -ovc lavc -lavcopts \
    aglobal=1:vglobal=1:acodec=libfaac:vcodec=mpeg4:abitrate=96:vbitrate=640:keyint=250:mbd=1:vqmax=10:lmax=10:vpass=2 -af lavcresample=44100 \
    -vf harddup,scale=640:-3 "video.avi" -o "video.mp4"

After the 2nd pass is done, copy the video.mp4 to nokia 5800 xm or n97's
memory card and open the file using file manager of nokia after removing
the device from the computer.

we need to run the above two commands in the folder where video.avi is
present. play around with abitrate, vbitrate, and scale values to get
video quality and size of your liking. alternate formatfactory is a
mencoder gpl application for windows which runs in wine, can also
convert all-to-mp4.

scale=640:-3 will try to keep the video width to 640 and resize the
video height accordingly. Do use the "original" aspect in nokia's mp4
player "option->aspect" for 16:9 and 4:3 aspect ratio videos.

> Encoding a multi audio / multi language MKV video to an MP4 with different audio streams

to encode multi-audio file to mp4 we need to use the "-aid <audio stream
number>" like -map 0:1 in ffmpeg)

1. To extract video+audio stream1 (usually english) of mkv file:

    mencoder -oac copy -ovc copy -aid 0 sample.mkv -o sample.mp4 

2. To extract video+audio stream2 (usually non-english, like Hindi,
French, etc.) of mkv file:

    mencoder -oac copy -ovc copy -aid 1 sample.mkv -o sample.mp4

> Adding SubRip subtitles to a file

The following output video codec (-ovc) options are suggested as very
high-quality settings and should suffice for most transcodings,
including the additon of subtitles to a stream.

Two-pass x264 (very high-quality)

    mencoder original_video.avi -oac copy -ovc x264 -x264encopts pass=1:preset=veryslow:fast_pskip=0:tune=film:frameref=15:bitrate=3000:threads=auto -sub original_video.srt -subfont-text-scale 3 -o /dev/null
    mencoder original_video.avi -oac copy -ovc x264 -x264encopts pass=2:preset=veryslow:fast_pskip=0:tune=film:frameref=15:bitrate=3000:threads=auto -sub original_video.srt -subfont-text-scale 3 -o output_video.avi

-   fast_pskip=0 is a maximum quality placebo preset option.
-   frameref is the only other major option undefined by preset
    settings.
-   bitrate values can be modified to suit desired file size and quality
    needs.
-   tune should be set to match the type and content of the of media
    being encoded.

Single-pass x264 (very high-quality)

    mencoder original_video.avi -oac copy -ovc x264 -x264encopts preset=veryslow:tune=film:crf=15:frameref=15:fast_pskip=0:threads=auto -sub original_video.srt -subfont-text-scale 3 -o output_video.avi

-   The following example uses the option -of lavf to mux the output
    into a Matroska container which is autodetected from the output file
    extension .mkv

    mencoder original_video.avi -oac copy -of lavf -ovc x264 -x264encopts preset=veryslow:tune=film:crf=15:frameref=15:fast_pskip=0:global_header:threads=auto -sub original_video.srt -subfont-text-scale 3 -o output_video.mkv

-   global_header writes global video headers to extradata, or in front
    of keyframes and is typically required for .mp4 and .mkv containers.

Two-pass xvid (very high-quality)

    mencoder original_video.avi -oac copy -ovc xvid -xvidencopts pass=1:chroma_opt:vhq=4:max_bframes=1:quant_type=mpeg:threads=6 -sub original_video.srt -subfont-text-scale 3 -o /dev/null
    mencoder original_video.avi -oac copy -ovc xvid -xvidencopts pass=2:chroma_opt:vhq=4:max_bframes=1:quant_type=mpeg:bitrate=3000:threads=6 -sub original_video.srt -subfont-text-scale 3 -o output_video.avi

-   threads=n where n = physical, or CPU cores.
-   Recent versions of mencoder enable bvhq=1 as a default setting.
-   Xvid does not accept bitrate settings on the first of multiple-pass
    encodings.
-   subfont-text-scale 2-3 helps with proper sizing with 16:9 format
    screens.
-   max_bframes=0 can be set so long as the bitrate is high enough.

Three-pass lavc (very high-quality mpeg4)

    mencoder original_video.avi -oac copy -ffourcc DX50 -ovc lavc -lavcopts vpass=1:mbd=2:mv0:trell:v4mv:cbp:predia=6:dia=6:precmp=6:cmp=6:subcmp=6:preme=2:qns=2:vbitrate=3000 -sub original_video.srt -subfont-text-scale 3 -o output_video.avi
    mencoder original_video.avi -oac copy -ffourcc DX50 -ovc lavc -lavcopts vpass=3:mbd=2:mv0:trell:v4mv:cbp:predia=6:dia=6:precmp=6:cmp=6:subcmp=6:preme=2:qns=2:vbitrate=3000 -sub original_video.srt -subfont-text-scale 3 -o output_video.avi
    mencoder original_video.avi -oac copy -ffourcc DX50 -ovc lavc -lavcopts vpass=3:mbd=2:mv0:trell:v4mv:cbp:predia=6:dia=6:precmp=6:cmp=6:subcmp=6:preme=2:qns=2:vbitrate=3000 -sub original_video.srt -subfont-text-scale 3 -o output_video.avi

-   Introducing threads=n>1 for -vcodec mpeg4 may skew the effects of
    motion estimation and lead to reduced video quality and compression
    efficiency.
-   predia=6:dia=6:precmp=6:cmp=6:subcmp=6 to
    predia=3:dia=3:precmp=3:cmp=3:subcmp=3 can reduce encoding times
    without incurring much loss in quality.
-   vmax_b_frames not included as referenced in the official mencoder
    documentation as the current default setting is to not to use
    B-frames at all.
-   vb_strategy not included as referenced in the official mencoder
    documentation for the same reason as above. Else vb_strategy=2.

Single-pass lavc (very high-quality mpeg-2)

    mencoder -mc 0 -noskip -oac lavc -ovc lavc -of mpeg -mpegopts format=dvd:tsaf  -vf scale=720:576,harddup -srate 48000 -af lavcresample=48000   -lavcopts vcodec=mpeg2video:vrc_buf_size=1835:vrc_maxrate=9800:vbitrate=5000:keyint=15:vstrict=0:acodec=mp2:abitrate=192:aspect=16/9  -sub-bg-alpha 100 -subpos 95 -subfont-text-scale 2.5 -subcp cp1250 -sub subFile.srt  -o outFile.mpg inFile.mkv

-   -mc 0 -noskip to ensure A/V sync
-   aspect - setting video aspect manually
-   subtitle background, subtitle encoding and subtitle scaling

There are as always many options that can be set, this combination
ensures that picture looks almost the same as original with slightly
smaller file size

(great for converting FULL HD videos so that they are playable on older
devices)

> Adding VOBsub subtitles to a file

Two-pass x264 (very high-quality)

-   Direct -vobsub to the subtitle_file using the full pathname of the
    file without extensions (.idx/.sub).
-   Select the second subtitle ID language (-vobsubid 2) contained
    within the VOBsub files (.idx/.sub).

    mencoder original_video.avi -oac copy -ovc x264 -x264encopts pass=1:preset=veryslow:fast_pskip=0:tune=film:frameref=15:bitrate=3000:threads=auto -vobsub subtitle_file -vobsubid 2 -o /dev/null
    mencoder original_video.avi -oac copy -ovc x264 -x264encopts pass=2:preset=veryslow:fast_pskip=0:tune=film:frameref=15:bitrate=3000:threads=auto -vobsub subtitle_file -vobsubid 2 -o output_video.avi

Testing subtitle muxing results

Avoid passing resource intensive encoding options in order to verify
desired results sooner rather than later.

Single-pass x264 (low quality)

    mencoder original_video.avi -oac copy -ovc x264 -x264encopts preset=ultrafast:threads=auto -sub original_video.srt -subfont-text-scale 3 -o output_video.avi

    mencoder original_video.avi -oac copy -ovc x264 -x264encopts pass=2:preset=ultrafast:threads=auto -vobsub subtitle_file -vobsubid 2 -o output_video.avi

> mp2 vs. mp3lame vs. aac

-   toolame is recommended over FFmpeg lavc (libavcodec) for mp2
    encoding.
-   mp3lame is recommended over FAAC (not fully developed) encoding at
    all bitrates.

GUI frontends
-------------

-   ogmrip
    OGMRip is an application and a set of libraries for ripping and
    encoding DVD into AVI, OGM, MP4, or Matroska files using a wide
    variety of codecs. It relies on mplayer, mencoder, ogmtools,
    mkvtoolnix, mp4box, oggenc, lame, and faac to perform its tasks.
-   hybrid-encoder
    Hybrid is a multi platform (Linux/Mac OS X/Windows) Qt based
    frontend for a bunch of other tools which can convert nearly every
    input to x264/Xvid/VP8 + ac3/ogg/mp3/aac/flac inside an
    avi/mp4/m2ts/mkv/webm container, a BluRay or an AVCHD structure.
-   hypervc-qt4
    Hyper Video Converter is a frontend for various cli videoencoder
    tools I have made because I wanted something, that let's me quickly
    convert videos from konqueror without typing 3-line-commands in the
    console.
-   iriverter
    iriverter is a cross-platform frontend to mencoder designed to
    facilitate the conversion of almost any video format to one that is
    playable on various multimedia players.
-   kmenc15
    Kmenc15 is an advanced Qt/KDE MEncoder frontend, generally designed
    to be a VirtualDub replacement for Linux. It is most useful for
    editing and encoding large high quality AVIs capped from TV. It
    allows cutting and merging at exact frames, applying any
    MPlayer/MEncoder filter, with preview.
-   kvideoencoder
    KVideoEncoder is a GUI for the mencoder and transcode.
-   qvideoconverter
    QVideoConverter is an GUI for mencoder and provides an simple way to
    convert files/dvds to DivX videos.
-   jmencode
    This program is a simple java front-end for the free and very useful
    MPlayer software, for the purpose of encoding video. Initially the
    focus is on converting DVD into MPEG-4.

Retrieved from
"https://wiki.archlinux.org/index.php?title=MEncoder&oldid=211217"

Category:

-   Audio/Video
