Streaming using twitch.tv
=========================

Twitch.tv is one of the more popular RTMP based streaming services
offered. As Steam has a Linux client available, some people may be in
search of solutions to stream their games or Linux desktop. As there are
no well known Linux broadcasting programs just yet, most solutions at
this point are CLI based. The info included here should serve as a list
of such solutions.

Twitch streaming Guidelines
---------------------------

From Twitch.tv support:

Video Requirements

-   Codec: H.264 (x264)
-   Mode: Strict CBR
-   Keyframe Interval: 2 seconds

Audio Requirements

-   Codec: AAC-LC or MP3, Stereo or Mono
-   Maximum bit rate: 160 kbps (AAC), 128 kbps (MP3)
-   Sampling frequency: any (AAC), 44.1 KHz (MP3)

Other Requirements

Not listed on their page is a requirement of the Y'UV420p pixel format,
as Y'UV444 is not widely supported just yet.

  

Ffmpeg solutions
----------------

These solutions revolve around making use of the FFmpeg package:

> .bashrc script method

One method of streaming to twitch using FFMPEG makes use of a simple
script that is placed in a user's ~/.bashrc file. this script supports
streaming of both desktop and OpenGL elements.

-   Depending on your internet upload speed, you may need to modify the
    Ffmpeg parameters. use the breakdown list for reference.

  
 The script can be used by typing

    streaming streamkeyhere

into a terminal. sound sources can be manipulated by using pavucontrol.
The .bashrc script is as follows:

  

    streaming() {
    INRES="1440x900" # input resolution
    FPS="15" # target FPS
    QUAL="fast"  # one of the many FFMPEG preset
    STREAM_KEY="$1" # use the terminal command Streaming streamkeyhere to stream your video to twitch or justin
    URL="rtmp://live.justin.tv/app/$STREAM_KEY" #flashver=FMLE/3.0\20(compatible;\20FMSc/1.0)"   

    ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0 \
       -f alsa -ac 2 -i pulse -vcodec libx264 -crf 30 -preset "$QUAL" -s "1280x720" \
       -acodec libmp3lame -ab 96k -ar 44100 -threads 0 -pix_fmt yuv420p \
       -f flv "$URL"
    }

  Parameter            Description
  -------------------- -----------------------------------------------------------------------------------------------------
  ffmpeg               The converter
  -f x11grab           -f forces input to be from x11grab
  -s "$INRES"          -s sets a specific image size, relying on the variable $INRES
  -r "$FPS"            -r sets framerate to be the value equal to $FPS
  -i :0.0              -i gets input, in this case its pulling in screen :0.0 from x11
  -ab 96k              -ab sets audio bitrate to 96k. -b:a is the alternate form of this command
  -f alsa              forces input(?) to be from alsa
  -ac 2                sets audio channels to 2
  -i pulse             gets input from pulse
  -vcodec libx264      sets video codec to libx264
  -crf 23              sets the ffmpeg constant rate factor to 23
  -preset "$QUAL"      sets the preset compression quality and speed
  -s "1280x720"        specifies size of image to be 720p
  -acodec libmp3lame   sets audio codec to use libmp3lame
  -ar 44100            sets audio rate to 44100 hz
  -threads 0           sets cpu threads to start, 0 autostarts threads based on cpu cores
  -pix_fmt yuv420p     sets pixel format to Y'UV420p. Otherwise by default Y'UV444 is used and is incompatible with twitch
  -f flv "$URL"        forces format to flv, and outputs to the twitch RTMP url

  :  Ffmpeg Parameter breakdown

Retrieved from
"https://wiki.archlinux.org/index.php?title=Streaming_using_twitch.tv&oldid=304980"

Category:

-   Streaming

-   This page was last modified on 16 March 2014, at 10:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
