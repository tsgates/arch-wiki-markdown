Convert any Movie to DVD Video
==============================

> Summary

Video DVD encoding tools provided by MPlayer.

> Related

DVD Ripping

Dvd2Avi

MPlayer

Video2dvdiso

MEncoder is part of the mplayer package. See MPlayer for details.
mplayer2 does not include MEncoder.

Why another article about this process? There is a plethora of articles,
man pages, and blog entries about how to convert any movie to a standard
DVD Video viewable on any hardware DVD player. However, most of those
pages focus on one aspect of this process. The point of this article is
to summarize most of the available knowledge in only one place.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 The parts of a DVD                                                 |
| -   2 The Audio                                                          |
| -   3 The Video                                                          |
|     -   3.1 Removing the black borders                                   |
|     -   3.2 Obtaining the correct aspect ratio                           |
|     -   3.3 Reaching a valid resolution                                  |
|     -   3.4 Encoding the video                                           |
|                                                                          |
| -   4 Putting Audio and Video together                                   |
| -   5 The Subtitles                                                      |
|     -   5.1 Textual subtitles                                            |
|     -   5.2 Subtitles from another DVD video                             |
|         -   5.2.1 Fix subtitle images                                    |
|                                                                          |
|     -   5.3 VobSub files                                                 |
|                                                                          |
| -   6 Authoring the DVD                                                  |
|     -   6.1 One file, One movie                                          |
|     -   6.2 Many files, One movie                                        |
|     -   6.3 One file, Many movies                                        |
|     -   6.4 Many files, Many movies                                      |
|     -   6.5 dvdauthor Command line                                       |
|                                                                          |
| -   7 Burning the DVD video                                              |
| -   8 Appendix A: about changing frame-rate                              |
| -   9 Appendix B: about menu                                             |
| -   10 External links                                                    |
+--------------------------------------------------------------------------+

The parts of a DVD
------------------

For our purposes in this example, every movie on the DVD has one video
track, at least one audio track, and possibly includes subtitles. We
will begin by creating a simple DVD that autostarts when put in the DVD
player, without any menu. If the disk includes more than one movie, you
can select one using the chapter function of the DVD player.

The Audio
---------

The audio tracks are encoded using the Dolby Surround AC-3 Digital codec
with a sample rate of 48000Hz. A DVD video can have up to 1536 kbps of
audio information, but for each audio track the limit is 448 kbps. You
can have mono, stereo or 5.1 audio tracks.

The audio and video total bitrate cannot be greater than 9800 kbps; so
every audio track reduces the bitrate for the video, but it should not
be a problem since a maximum of 8264 kbps (9800 - 1536) of video bitrate
is enough.

While the heavy constraints of the video makes it almost impossible to
find a video track without need of encoding, it is fairly common to find
files with an ac3 track.

In order to know your input file audio codec, you can use mplayer (of
the package with the same name), here is an example of a file with a
fine audio track:

    $ mplayer movie.mov
    ...
    AUDIO: 48000 Hz, 6 ch, s16le, 448.0 kbit/9.72% (ratio: 56000->576000)
    Selected audio codec: [a52] afm: liba52 (AC3-liba52)
    ...

If your input file already has an ac3 encoded audio track (with an
acceptable bitrate, sample rate and frame rate) you should not encode it
again.

You need only to extract it:

    mencoder movie.mov -alang en -ovc frameno -of rawaudio -oac copy \
    -o english_audio.ac3

If the audio track it is not an acceptable ac3 file then you have to
encode it. Usually ac3 uses 64 or 96 kbps per audio channel.

For 6 channels the encoding command is:

    mencoder movie.mov -alang en -ovc frameno -of rawaudio -srate 48000 -channels 6 \
    -oac lavc -lavcopts acodec=ac3:abitrate=384 -o english_audio.ac3

or for stereo audio:

    mencoder movie.mov -alang it -ovc frameno -of rawaudio -srate 48000 -channels 2 \
    -oac lavc -lavcopts acodec=ac3:abitrate=128 -o italian_audio.ac3

Using both commands, we will have two files, one per audio track.

If you are changing the sampling rate and you think the audio quality is
poor you can try to add the argument -af resample=48000::2: doing so
mplayer will use its most precise algorithm.

The Video
---------

Standard compliant DVD videos have a well-defined and precise video
requirement. The aspect ratio can be '16/9' or '4/3', the available
resolutions change if you are making a Pal or a Ntsc DVD. The two
standards also have different frame ratios. The codec is Mpeg-2.

DVDs do not use square pixels, the pixels are rectangular: while the
movie has a certain resolution the player has to display it as if it
were deforming the pixels. This table shows the real resolution and how
the player displays it.

    NTSC DVD, framerate: 30000/1001 (29.97) or 24000/1001 (23.97)
     Resolution    Displayed as
     720x480       720x540 (4/3) or 854x480 (16/9)
     704x480       720x528 (4/3) 
     352x480       640x480 (4/3) 
     352x240       352x264 (4/3) 

    PAL DVD, framerate: 25
     Resolution    Displayed as
     720x576       768x576 (4/3) or 1024x576 (16/9)
     704x576       768x576 (4/3)
     352x576       768x576 (4/3)
     352x288       384x288 (4/3)

As you can see, the 4/3 aspect ratio has 4 resolutions; the 16/9 only
one. The Ntsc standard gives you two kinds of frame rate while Pal
provides only one.

Depending of the country you live in, you have to decide between Ntsc or
Pal. In order to decide ratio and resolution you must know the
resolution of your input movie.

Play you input movie with mplayer, ensure that mplayer plays exactly
what you want to put in the DVD. You might consider options like -ss.
-endpos or -chapter.

mplayer show lines like:

    Movie-Aspect is 1.39:1 - prescaling to correct movie aspect.
    VO: [xv] 512x368 => 512x368 Planar YV12 

Which gives you the aspect ratio and the resolution. In this example the
ratio is 1.39:1 - that is quite similar to 4/3 (as is 1.333:1). While
the resolution is 512x368 it is not possible to encode it in a 704x576
Pal DVD or 704x480 Ntsc DVD.

This is fine and good if the input does not have black borders or if the
input file has exactly the aspect ratio of 4/3 or 16/9. Otherwise there
is an intermediate step required.

Removing the black borders

If the input file has black borders and its aspect ratio is not 4/3 or
16/9 you have to remove the black border and consider the 'real'
resolution and the 'real' aspect ratio. mplayer has a feature to detect
the black borders in order to remove them with ease: the cropdetect
video filter. Play the movie with -vf cropdetect, seek in the movie a
bright scene where the black borders are easily visible. mplayer will
give you an output with the correct crop values. Example:

    ...
    Movie-Aspect is 1.50:1 - prescaling to correct movie aspect.
    VO: [xv] 720x480 => 720x480 Planar YV12 
    ...
    [CROP] Crop area: X: 0..719  Y: 38..440  (-vf crop=720:400:0:40).% 0 0 
    [CROP] Crop area: X: 0..719  Y: 38..440  (-vf crop=720:400:0:40).% 0 0 
    [CROP] Crop area: X: 0..719  Y: 38..440  (-vf crop=720:400:0:40).% 0 0 
    ...

This movie have 40 pixels of black border and its aspect ratio is 1.50.
So we found a bright scene and mplayer said us the correct values for
the crop video filter: in this case 720:400:0:40.

Replaying the movie with -vf crop=720:400:0:40 we see the real
resolution, unfortunately mplayer will show the old aspect ratio so we
have to calculate the real one by hand:

    Movie-Aspect is 1.50:1 - prescaling to correct movie aspect.
    VO: [xv] 720x400 => 720x400 Planar YV12 

The aspect ratio is actually 720/400 = 1.8; a ratio of 1.8 means we have
to use 16/9 (as it is 1.777)

Obtaining the correct aspect ratio

We now have movie without black borders but with the wrong aspect ratio
- as DVDs accept only 16/9 or 4/3. Luckily mplayer has another video
filter that puts the correct black borders to obtain the correct aspect
ratio. The filter is expand. Lets continue the previous example:

    mplayer movie.mov -vf crop=720:400:0:40,expand=:::::16/9

mplayer will display the movie with a small black border (we passed from
to 1.8 to 1.777 after all). All the heading colons are necessary because
the filter would accept many other parameters we leave to default.

Reaching a valid resolution

Now we have to decide the resolution we will use. Of course if we
selected the 16/9 aspect ratio we will have only one choice (720x576 for
Pal or 720x480 for Ntsc), but if we selected the 4/3 aspect ratio we
have to decide. Usually the best selection is the smallest resolution
that contains the original movie after removing the black borders or the
maximum resolution if the input file is larger. For example a 4/3 movie
of 640x480 should be put in 704x480 Ntsc or 704x576 Pal. To continue the
previous example we will use 720x576 Pal.

The video filter chain becomes: -vf
crop=720:400:0:40,expand=:::::16/9,scale=720:576,dsize=1024:576 where we
scaled to the correct resolution in scale and set the display resolution
in dsize following the table.

If mplayer shows something like VO: [xv] 720x576 => 1024x576 Planar YV12
where the first pair is the resolution, the second pair is the displayed
resolution and the movie is displayed correctly (no oval heads for
example) we are done.

> Encoding the video

With mplayer correctly displaying the video with an aspect ratio of 4/3
or 16/9 in one of the DVD compliant resolutions, it is time to encode
the video in a file suitable for DVD video. We will use mencoder (of
mplayer package), mplayer and mencoder share the video filers, so the
-vf line we calculated until now will be used to have a fine mpeg2 file.

There is one last thing to decide, the average bitrate of movie. A
compliant mpeg for DVD can have a maximum bitrate of 9800 bits per
second with both audio and video, a safe choice is using 8264 kbps as
maximum for the mpeg-2 video, it leaves all the free space for the
audio. Moreover, the video on average usually needs only 4000-5000 kbps.
mencoder takes the meaning of average very seriously, so much you can
assume that:

    (average bitrate) * (movie length in seconds) = (total of bits)

And knowing how many bits you have in the DVD you can calculate your
bitrate with great precision.

    Kind of DVD   # of bits
    DVD-R SL      37658558464
    DVD+R SL      37602983936
    DVD-R DL      68349329408
    DVD+R DL      68383932416

For example if you have a 2 hours movie (7200 seconds), a single 448
kbits per seconds audio track (usual value for 6 channels audio) and a
DVD-R SL you might calculate:

    37658558464 / 7200 - 448000 = 4782355

There is probably some space wastage in the DVD structure, but we can
use 4500 kbits and be fairly safe.

The encoding is made in two passes, the first is about getting
information about the movie structure in order to know where the encoder
should use more bits (high action scenes) and where it should use less
bits (calm or slow paced scenes) in order to use exactly the bits you
asked for at the best quality.

The commands, as you can understand from the || exit, are meant to be
written in a file:

     rm divx2pass.log

     nice -19 mencoder -alang en -oac lavc -ovc lavc -of rawvideo -vf-clr -vf \
     crop=720:400:0:40,expand=:::::16/9,scale=720:576,dsize=1024:576,harddup \
     -ofps 25 -lavcopts vcodec=mpeg2video:turbo:vpass=1:vrc_buf_size=1835\
    :vrc_maxrate=8264:vbitrate=4500:keyint=15:vstrict=0:aspect=16/9 \
     -o /dev/null movie.mov || exit

     nice -19 mencoder -alang en -oac lavc -ovc lavc -of rawvideo -vf-clr -vf \
     crop=720:400:0:40,expand=:::::16/9,scale=720:576,dsize=1024:576,harddup \
     -ofps 25 -lavcopts vcodec=mpeg2video:vpass=2:vrc_buf_size=1835\
    :vrc_maxrate=8264:vbitrate=4500:keyint=15:trell:mbd=2:precmp=2:subcmp=2\
    :cmp=2:dia=2:predia=2:cbp:mv0:lmin=1:dc=10:vstrict=0:aspect=16/9 \
     movie.mov -o movie_video_track.m2v  || exit

Things to note:

-   there is the video filters chain we calculated until now with the
    adding of harddup. A necessary filter to obtain standard compliant
    DVD videos;
-   the bitrate we decided (4500) is the value that appears in vbitrate
    value;
-   the aspect ratio appears in the aspect value;
-   the -ofps 25 option is there because we wanted a Pal DVD, if you
    wanted a Ntsc DVD you had to use -ofps 30000/1001;
-   the first pass discards the video output; the pass is there only to
    make the information file divx2pass.log;
-   the input file movie.mov can be replaced with everything mplayer can
    read, it is of course only a place-holder;
-   the output is a raw video stream;
-   the maximum bitrate is 8264 kbps: it leaves all the space for audio.
    It usually unneeded, but if you know how much bitrate you used for
    the audio you can increase: e.g., if you have two audio tracks with
    bitrate of 192 kbps you can put 9146 kbps as 9800-192*2;
-   In order to ensure the proper A/V sync we also encode the audio with
    lavc, but no settings are needed as the audio is discarded;
-   if you copy and paste ensure there are no leading spaces in the
    lines starting with a colon.

All the other values are more or less fixed for a high quality DVD
compliant conversion, you can (and should) read about in the mencoder
man page.

Note: the filter chain shown here is complete in the sense we had to
make every pass. If you had an input file already of 16/9 ratio for
example you would have only -vf scale=720:576,dsize=1024:576,harddup; if
you had a input file of the wrong ratio but without black borders you
would have only something like -vf
expand=:::::4/3,scale=720:576,dsize=768:576,harddup; the bare minimum is
-vf harddup if you had a movie of a correct resolution and ratio.

Save these commands in a text file and in the shell execute sh filename,
the execution of those two commands might take some time. But once
finished you will have a video stream at the correct resolution for DVD
video.

If you have more than one video file (like first part of the movie in a
file and the second part in another file) you have to encode both
following these instructions, we will put both in the DVD when we author
the DVD.

Putting Audio and Video together
--------------------------------

In order to have only one file with both audio and video we will use
mplex (of mjpegtools package); the command is straightforward:

    mplex -f 8 -o movie.mpg movie_video_track.m2v english_audio.ac3 italian_audio.ac3

The output file (movie.mpg) will contain both audio tracks and the
related video track. The order on the command line matters: the order of
the audio tracks will be the same on the DVD. You should note it down as
in the final DVD we will include the audio tracks' language tag.

mplex is necessary if there is more than one audio track, but if you
have only one you can create the mpeg file directly. You have to replace
the second command of video encoding. For example, making movie.mpg with
only the English track in one pass:

     nice -19 mencoder -oac lavc -ovc lavc -of mpeg -mpegopts format=dvd:tsaf -vf-clr -vf \
     crop=720:400:0:40,expand=:::::16/9,scale=720:576,dsize=1024:576,harddup \
     -srate 48000 -ofps 25 -lavcopts vcodec=mpeg2video:vpass=2:vrc_buf_size=1835\
    :vrc_maxrate=8264:vbitrate=4500:keyint=15:trell:mbd=2:precmp=2:subcmp=2\
    :cmp=2:dia=2:predia=2:cbp:mv0:lmin=1:dc=10:acodec=ac3:abitrate=384:vstrict=0\
    :aspect=16/9 -channels 6 movie.mov -o movie.mpg  || exit

Things to note:

-   the -of option now states mpeg, not raw video;
-   there is a new option: -mpegopts with the settings that mplex hides
    behind -f 8;
-   there are options for both video and audio in the -lavcopts.

There are two main causes of failure of mplex: the first is that the
audio does not have the correct bitrate of 48000kbps; the second is that
the total bitrate is greater than 9800kbps in some points of the movie.

The first problem manifests with hundred of Warning messages, and you
have to re-encode the audio.

The second manifests with frames dropped and after a while with global
failure: you have to re-encode the video with the correct maximum
bitrate (put 8264 if you want to be sure).

The Subtitles
-------------

The subtitles are merged in the mpeg file and depend uipon the setting
displayed if the user selects (normal subtitles) or always (forced
subtitles). Forced subtitles are usually used to translate to the main
language those parts of the movie in foreign languages, for example the
Elves speak in The Lord of the Ring.

In DVD video you have 3360 kbps of space for subtitles. Subtitles are
actually pictures of at most 4 colors (one being transparency): this is
the reason why the subtitles often look crude.

In mpeg file there is no relation between the subtitles and languages,
only a sid number. While you add subtitles write down the language the
subtitle is for every sid. (example: sid 0: english; sid 1: italian; sid
2: french,...)

> Textual subtitles

A textual subtitle is easily recognizable, it is a file that opened with
a text editor shows the lines of the movie with relative timings. We
will use spumux (of the dvdauthor package) to render the text in the
movie as subtitle.

The first problem is the font. The font must be easily readable when
rendered within the constraints of resolution and colors. I found the
Xerox Sans Serif Wide Bold that is freely available quite good.

spumux looks for the .ttf file of the font in the directory ~/.spumux,
so make that directory and copy the font to it. For the example we will
assume the font file name is then ~/.spumux/xerox.ttf.

In the example, the file containing the subtitles is called italian.srt.

spumux uses a .xml file for the settings. Here is how ours would look:

    <subpictures>
       <stream>
          <textsub filename="italian.srt"
             fontsize="22.0" font="xerox.ttf" horizontal-alignment="center"
             vertical-alignment="bottom" left-margin="60" right-margin="60"
             top-margin="20" bottom-margin="30" subtitle-fps="25"
             movie-fps="25" movie-width="720" movie-height="576"
             force="no"
          />
       </stream>
    </subpictures>

Once we have made the sub_ita.xml file we have to mix it with the mpeg
file, using spumux:

    spumux -s0 sub_ita.xml <movie.mpg >movie_ita_sub.mpg

You should experiment with the position values to obtain a result you
like. Use force="yes" if you wanted forced subtitles. The -s sets the
subtitle stream id, if you include more subtitles the value has to be
increased accordingly.

For example you might add other subtitles after modifying the subtitles
file name in the .xml file using:

    spumux -s1 sub_fre.xml <movie_ita_sub.mpg >movie_ita_sub__fre_sub.mpg

> Subtitles from another DVD video

If you want to extract the subtitles from another DVD you have to use
tccat and tcextract (of transcode package) to get the subtitle raw
stream. After you convert the raw stream with subtitle2pgm (also of
transcode package) to pictures and a control file. The control file is
understood by spumux.

Assuming the dvd device is /dev/sr0 and the video track is the first we
detect the subtitles available with mplayer:

    $ mplayer -dvd-device /dev/sr0 dvd://1 -frames 0 2>&1 | grep sid
    subtitle ( sid ): 0 language: en
    subtitle ( sid ): 1 language: pt

Extract the raw subtitle stream:

    tccat -i /dev/sr0 -T 1,-1 | tcextract -x ps1 -t vob -a  $((0x20 + 0)) > subs-en

The value of -a is the sid number of the subtitle + 0x20. In this case
we extracted the first subtitle stream, eventually change the second
zero to the wanted sid number.

Extracting the pictures from the subtitles creates lots of files, so we
make a directory and work in it. subtitle2pgm extracts in black and
white and the grey levels must be decided the user. So to begin, try:

    $ mkdir subs-en-wd
    $ cd subs-en-wd
    $ subtitle2pgm -i ../subs-en -c 0,85,170,255 -g 4 -t 1

The directory will be filled with the subtitles. Using an image viewer
check the colors: you will have white (the 255), light grey (the 170),
dark grey (the 85) and black (the 0). Select a unique color for the
background and select colors for the other parts: usually letters white
and border around letters dark gray. Once you find suitable color scheme
delete the folder and execute again subtitle2pgm with the new color
scheme.

    $ cd ..
    $ rm -rf subs-en-wd && mkdir subs-en-wd
    $ cd subs-en-wd
    $ subtitle2pgm -i ../subs-en -c 224,224,32,0 -g 4 -t 1

subtitle2pgm created the images, but also an .xml file usable by spumux.
So if the images are fine, just use spumux to mix them with the mpeg
file.

    spumux -s0 movie_subtitle.dvdxml <../movie.mpg >../movie_subs.mpg

Fix subtitle images

The images might be the wrong resolution (for example, if extracted from
a Ntsc DVD and put in a Pal one) and so appear misplaced. To fix the
problem there are two approaches: one is converting every image to the
correct resolution; the other is just move the image.

Lets start with the former. For example you have subtitles as images of
resolution 720x480 extracted from a Ntsc DVD 16/9. You are making a Pal
DVD, so the resolution is 720x576: just including the subtitles without
alterations makes them appear in the centre of the movie.

The subtitles will appear a little deformed (as the 720 pixels are shown
as 1024 in Pal, while in the Ntsc they are shown as 854), but we just
tell spumux to put the images at the bottom of the screen.

spumux accepts some options about how to render the subtitle images.
Reading the man page we see we need to use the yoffset option. To alter
every line of the .xml file we use sed. The pictures were fine for 480
pixels, since we now have 576 we have to move the images down the screen
by 96 pixels, so:

    sed -i movie_subtitle.dvdxml -e 's.<spu .<spu yoffset="96" .'

Using sed to alter the .xml file is easy and quick. If you need to add
some other options (for example you want forced subtitles) just use the
sed expression s.<spu .<spu X where X is the new option you want.

If just moving the subtitle image is not enough you might want to
convert the pictures to the correct resolution. To do that we will use
convert (of imagemagick package) and a little bash script.

For example to convert the pictures from the Ntsc resolution to the Pal
one, we write a text file with:

    for d in *.png ;do
      convert "$d" -resize '720x575!' +dither -map "$d" tmp.png || break
      mv tmp.png "$d"
      echo "$d"
    done

That does convert every image without altering the palette (thanks to
-map) and making a clean resize (thanks to +dither). The resulting
images replaced the old ones, so now you can just use the .xml file.

> VobSub files

VobSub subtitles are formed by a pair of files: an .idx and a .sub file.
Sometime both are compressed as a single .rar file. If that is the case,
simply use unrar to decompress and obtain the two files.

The .sub file is an mpeg sequence with only the subtitles. You have to
extract the raw stream with tcextract

    tcextract -i s.sub -x ps1 -a $((0x20 + 0)) > subs-en

It is the same idea as extracting from a DVD; the second 0 is the sid
number of the subtitle track you want to extract: you can read the .idx
file with any text editor to see the subtitles language tags.

You now have a raw subtitle stream, you can follow the same instructions
of the above section.

Authoring the DVD
-----------------

At this point we should have only .mpeg files with the video track, the
audio tracks and the subtitles. We have just to include the header
structure of a DVD video. We use dvdauthor (of the package of the same
name).

dvdauthor uses an .xml file to determine the shape of the DVD
filesystem. Here is the bare minimum:

    <dvdauthor>
        <vmgm />
        <titleset>
            <titles>
                <pgc>
                    <vob file="video.mpg" />
                </pgc>
            </titles>
        </titleset>
    </dvdauthor>

But usually you want to tag the audio and the subtitle tracks, in this
second example the video.mpg has two audio tracks and two subtitle
tracks. We give a linguistic tag, order matters the first tag goes to
the first language and so go on.

    <dvdauthor>
        <vmgm />
        <titleset>
            <titles>
                <subpicture lang="en" />
                <subpicture lang="pt" />
                <audio lang="en" />
                <audio lang="pt" />
                <pgc>
                    <vob file="video.mpg" />
                </pgc>
            </titles>
        </titleset>
    </dvdauthor>

The idea of audio tracks and subtitles tagging applies to all the
titles. Now you can have one of the following situations:

-   one file, one movie;
-   many files, one movie;
-   one file, many movies;
-   many files, many movies.

> One file, One movie

In this case you can just use one of the bare minimum .xml files.

> Many files, One movie

If you have many files for one movie, dvdauthor uses them as chapters
just adding vob file tags:

    <dvdauthor>
        <titleset>
            <titles>
                <pgc>
                    <vob file="video_cd1.mpg" />
                    <vob file="video_cd2.mpg" />
                </pgc>
            </titles>
        </titleset>
    </dvdauthor>

> One file, Many movies

You should make separate files from the beginning using -ss. -endpos or
-chapter mencoder options. But if you have already encoded you might try
using now -ss and -endpos with mencoder doing only a streamcopy:

    mencoder -oac copy -ovc copy -endpos 01:10:00 movie.mpg -o first_part.mpg
    mencoder -oac copy -ovc copy -ss 01:10:00 movie.mpg -o second_part.mpg

Doing so you move to the fourth case.

> Many files, Many movies

In this case you have to make different titles just adding titles tags.

    <dvdauthor>
        <titleset>
            <titles>
                <pgc>
                    <vob file="video1_cd1.mpg" />
                    <vob file="video1_cd2.mpg" />
                </pgc>
            </titles>
        </titleset>
        <titleset>
            <titles>
                <pgc>
                    <vob file="video2_cd1.mpg" />
                    <vob file="video2_cd2.mpg" />
                </pgc>
            </titles>
        </titleset>
    </dvdauthor>

> dvdauthor Command line

Once you have written the .xml file, you are ready to use dvdauthor. The
command is:

    export VIDEO_FORMAT=PAL     # or NTSC
    dvdauthor -o dvd -x dvd.xml

where dvd.xml is the xml filename, and dvd is the name of the output
directory. It must not already exist. Once dvdauthor completes its job,
in the dvd directory you will have standard compliant DVD video.

It is a good idea to test it before burning:

    mplayer -dvd-device dvd/ dvd://1

Burning the DVD video
---------------------

We burn the DVD or create the iso using wodim and mkisofs (both of
cdrkit package). To create the iso the command is:

    mkisofs -dvd-video -udf -o dvd.iso dvd/

And you can burn it with:

    wodim -v dev=/dev/sr0 dvd.iso

If you do not want to create the iso, you can use pipes to accomplish
both steps in one command:

    export TSIZE=`mkisofs -dvd-video -udf -print-size dvd/ 2>/dev/null`
    mkisofs -dvd-video -udf -o - dvd/ | wodim -sao -eject -v dev=/dev/sr0 tsize="$TSIZE"s -

If you want to create the iso AND burn at the same time:

    export TSIZE=`mkisofs -dvd-video -udf -print-size dvd/ 2>/dev/null`
    mkisofs -dvd-video -udf -o - dvd/ | tee dvd.iso | wodim -sao -eject -v dev=/dev/sr0 tsize="$TSIZE"s -

If you just want a single command:

    mkisofs -dvd-video -udf -o - dvd/ | wodim -sao -eject -v dev=/dev/sr0 \
    tsize=`mkisofs -dvd-video -udf -print-size dvd/ 2>/dev/null`s -

And there it is. You have a standard compliant DVD video that is
viewable with any hardware DVD player.

Appendix A: about changing frame-rate
-------------------------------------

If the difference between the input frame-rate and the output frame-rate
is small you might consider to speed up or slow down the movie instead
of transforming its frame-rate by dropping or duplicating frames. The
mplayer command-line argument for doing so is -speed.

The most classical situation is converting from a 23.976 NTSC fps to a
25 PAL fps: this is the PAL speed-up.

    25/(24000/1001) = 1.042708333333...

So a Ntsc movie shown in Pal country most often is about 4% faster than
its original. mplayer is not very keen about changing frame-rates, so it
is often noticeable in the final output. On the other hand a speed up or
a slow down of less than 5% is probably unnoticeable.

In order to change the frame-rate this way you have to:

-   calculate the speed value: (output framerate)/(input framerate);
-   use -speed in every mplayer command, including converting audio;
-   always set explicitly the output frame-rate.

Here is an example of making a Pal Dvd from an Ntsc input, the
1.042733... is from the division above:

     rm divx2pass.log

     nice -19 mencoder -oac lavc -ovc lavc -of rawvideo -vf-clr -vf \
     expand=:::::16/9,scale=720:576,dsize=1024:576,harddup \
     -speed 1.04270833333333333333 -srate 48000 \
     -ofps 25 -lavcopts vcodec=mpeg2video:turbo:vpass=1:vrc_buf_size=1835\
    :vrc_maxrate=8264:vbitrate=4500:keyint=15:vstrict=0:aspect=16/9 \
     -o /dev/null movie.mov || exit

     nice -19 mencoder -oac lavc -ovc lavc -of rawvideo -vf-clr -vf \
     expand=:::::16/9,scale=720:576,dsize=1024:576,harddup \
     -speed 1.04270833333333333333 -srate 48000 \
     -ofps 25 -lavcopts vcodec=mpeg2video:vpass=2:vrc_buf_size=1835\
    :vrc_maxrate=8264:vbitrate=4500:keyint=15:trell:mbd=2:precmp=2:subcmp=2\
    :cmp=2:dia=2:predia=2:cbp:mv0:lmin=1:dc=10:vstrict=0:aspect=16/9 \
     -o movie_video_track.m2v movie.mov || exit

     nice -19 mencoder movie.mov -ovc frameno -of rawaudio -srate 48000 -channels 6 \
     -speed 1.04270833333333333333 -ofps 25 \
     -oac lavc -lavcopts acodec=ac3:abitrate=448 -o english_audio_6ch.ac3 || exit

     nice -19 mplex -o movie.mpg -f 8 movie_video_track.m2v english_audio_6ch.ac3

Appendix B: about menu
----------------------

Now you know how-to make the .mpg files; if you want making a menu for
your DVD you can follow this external tutorial from Myth TV[1].

  

External links
--------------

-   http://www.gentoo-wiki.info/FFmpeg/DivX_to_DVD gives an example of
    using ffmpeg to quickly create the mpg from e.g. an avi. This might
    be useful if mencoder doesn't seem to handle some input files (has
    happened).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Convert_any_Movie_to_DVD_Video&oldid=197856"

Category:

-   Audio/Video
