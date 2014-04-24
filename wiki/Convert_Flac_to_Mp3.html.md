Convert Flac to Mp3
===================

Related articles

-   Convert Any To Mp3
-   Convert any Movie to DVD Video

Here are a few scripts and tools that facilitate converting FLAC to MP3.

For more information on LAME switches/settings such as V0, visit the
Hydrogenaudio LAME Wiki. V0 is roughly equivalent to --preset extreme
which results in a variable bitrate usually between 220-260. The audio
of a V0 is transparent, meaning one cannot tell the difference between
the lossy file and the original source (compact disc/lossless), but yet
the file size is a quite reasonable.

Contents
--------

-   1 Scripts
    -   1.1 With FFmpeg
        -   1.1.1 Parallel version
    -   1.2 Without FFmpeg
    -   1.3 Usage
-   2 Packages
-   3 See also

Scripts
-------

In these two examples, the FLAC files in a directory are read,
decompressed to WAV, and streamed into the MP3 encoder, LAME. Both
scripts pass the ID3 tags from the FLAC files to the resulting MP3
files, and encode to MP3 V0.

The original .flac files are not modified and the resulting .mp3s will
be in the same directory. All files with extensions not matching *.flac
in the working directory (.nfo, images, .sfv, etc.) are ignored.

> With FFmpeg

Chances are, your system already has ffmpeg installed, which brings in
the flac and lame packages. FFmpeg has all the encoding and decoding
facilities built in to do the job.

    #!/bin/bash

    for a in *.flac; do
      < /dev/null ffmpeg -i "$a" -qscale:a 0 "${a[@]/%flac/mp3}"
    done

Parallel version

Convertion can be accelerated if you have multicore CPU/several CPUs:

    parallel -j 4 'a={}; ffmpeg -i "$a" -qscale:a 0 "${a[@]/%flac/mp3}"' ::: *.flac

> Without FFmpeg

If for some reason you have something against FFmpeg, you still need to
have flac and lame installed. Here, the tagging process is more
explicit, using the metadata utility that comes with flac, and passing
the information to lame

    #!/bin/bash

    for a in *.flac; do
      # give output correct extension
      OUTF="${a[@]/%flac/mp3}"

      # get the tags
      ARTIST=$(metaflac "$a" --show-tag=ARTIST | sed s/.*=//g)
      TITLE=$(metaflac "$a" --show-tag=TITLE | sed s/.*=//g)
      ALBUM=$(metaflac "$a" --show-tag=ALBUM | sed s/.*=//g)
      GENRE=$(metaflac "$a" --show-tag=GENRE | sed s/.*=//g)
      TRACKNUMBER=$(metaflac "$a" --show-tag=TRACKNUMBER | sed s/.*=//g)
      DATE=$(metaflac "$a" --show-tag=DATE | sed s/.*=//g)

      # stream flac into the lame encoder
      flac -c -d "$a" | lame -V0 --add-id3v2 --pad-id3v2 --ignore-tag-errors \
        --ta "$ARTIST" --tt "$TITLE" --tl "$ALBUM"  --tg "${GENRE:-12}" \
        --tn "${TRACKNUMBER:-0}" --ty "$DATE" - "$OUTF"
    done

> Usage

For ease of use, add the script to your PATH. Open up a terminal, cd to
the directory of FLAC files that you wish to convert, and invoke
flac2mp3 (or whatever you named the script). You'll see the verbose
decoding/encoding process in the terminal which may take a few moments.
Done! At this point, it's trivial to mv *.mp3 all your new MP3s wherever
you wish.

A useful extension of the above scripts is to let it recurse into all
subdirectories of the working directory. Replace the first line
(for .... do) with

    $ find -type f -name "*.flac" -print0 | while read -d $'\0' a; do

Packages
--------

-   whatmp3 - A small Python script that accepts a list of directories
    containing FLAC files as arguments and converts them to MP3 with the
    specified options.
-   flac2all - Audio converter of FLAC to either Ogg Vorbis or MP3
    retaining all tags and metadata.
-   flac2mp3-bash - Bash script to convert Flac to Mp3 easily.

See also
--------

-   https://www.xiph.org/flac/
-   https://en.wikipedia.org/wiki/FLAC
-   http://lame.sourceforge.net/
-   http://wiki.hydrogenaudio.org/index.php?title=Flac - More
    information on FLAC.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Convert_Flac_to_Mp3&oldid=295129"

Categories:

-   Audio/Video
-   Scripts

-   This page was last modified on 31 January 2014, at 09:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
