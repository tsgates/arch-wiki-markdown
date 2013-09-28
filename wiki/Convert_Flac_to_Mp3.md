Convert Flac to Mp3
===================

Tip:You can use flac2mp3-bash script from aur to convert Flac to Mp3
easily.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
|     -   1.1 Installation                                                 |
|         -   1.1.1 Usage                                                  |
|         -   1.1.2 Addendum                                               |
|             -   1.1.2.1 Nautilus-scripts                                 |
|                                                                          |
| -   2 More generic solution                                              |
+--------------------------------------------------------------------------+

Introduction
------------

Here is a script that will convert FLAC to MP3 via the commandline.

Essentially, the .flac files within a directory will be decompressed to
.wav and then the resulting .wav files will be encoded to .mp3 using the
latest LAME switches for encodings (-V 0 --vbr-new). The ID3 tags of the
original .flac files will be passed to the resulting .mp3 files.

The original .flac files will not be harmed and the resulting .mp3s will
be in the same directory. All other files in the directory (.nfo,
images, .sfv, etc) will be ignored and unharmed.

For more information on LAME switches/settings such as V0, visit
Hydrogenaudio LAME Wiki. V0 is roughly equivalent to --preset extreme
which results in a variable bitrate usually between 220-260. The audio
of a V0 is transparent, meaning one cannot tell the difference between
the lossy file and the original source (compact disc/lossless), but yet
the file size is a quite reasonable.

More information on flac: FLAC

> Installation

First you need to install the following packages: flac, lame, and id3

    pacman -S flac lame id3

Once those are installed, copy the following script into your preferred
editor:

    #! /bin/sh

    for a in *.flac; do
        OUTF=${a%.flac}.mp3

        ARTIST=$(metaflac "$a" --show-tag=ARTIST | sed s/.*=//g)
        TITLE=$(metaflac "$a" --show-tag=TITLE | sed s/.*=//g)
        ALBUM=$(metaflac "$a" --show-tag=ALBUM | sed s/.*=//g)
        GENRE=$(metaflac "$a" --show-tag=GENRE | sed s/.*=//g)
        TRACKNUMBER=$(metaflac "$a" --show-tag=TRACKNUMBER | sed s/.*=//g)
        DATE=$(metaflac "$a" --show-tag=DATE | sed s/.*=//g)

        flac -c -d "$a" | lame -m j -q 0 --vbr-new -V 0 -s 44.1 - "$OUTF"
        id3 -t "$TITLE" -T "${TRACKNUMBER:-0}" -a "$ARTIST" -A "$ALBUM" -y "$DATE" -g "${GENRE:-12}" "$OUTF"
    done

Below is a modified version of the above script which:

-   adds an optional parameter (-d), which, if passed on the command
    line, causes each source FLAC file to be deleted after successful
    conversion;
-   changes the LAME encoding options as follows:
    -   drops --vbr-new, as it is the default VBR behaviour as of LAME
        3.98, and thus is automatically used when "-V 0" is used;
    -   drops "-m j", as LAME defaults to the specified value (joint
        stereo) when using --vbr-new (see above);
    -   drops "-q 0", as LAME defaults to this behaviour when using VBR;
    -   drops "-s 44.1", as LAME detects the proper sample rate to use;
    -   adds "--noreplaygain" (personal preference);

-   and uses LAME to write tags instead of the id3 package, which has
    the dual advantage of removing the need for an additional package in
    the tool chain and allowing the script to write both id3v1 and id3v2
    tags (the id3 package does not support id3v2 tags).

Now for the script:

    #! /bin/sh

    for a in *.flac; do
        OUTF=${a%.flac}.mp3

        ARTIST=`metaflac "$a" --show-tag=ARTIST | sed s/.*=//g`
        TITLE=`metaflac "$a" --show-tag=TITLE | sed s/.*=//g`
        ALBUM=`metaflac "$a" --show-tag=ALBUM | sed s/.*=//g`
        GENRE=`metaflac "$a" --show-tag=GENRE | sed s/.*=//g`
        TRACKNUMBER=`metaflac "$a" --show-tag=TRACKNUMBER | sed s/.*=//g`
        DATE=`metaflac "$a" --show-tag=DATE | sed s/.*=//g`

        flac -c -d "$a" | lame --noreplaygain -V0 \
            --add-id3v2 --pad-id3v2 --ignore-tag-errors --tt "$TITLE" --tn "${TRACKNUMBER:-0}" \
            --ta "$ARTIST" --tl "$ALBUM" --ty "$DATE" --tg "${GENRE:-12}" \
            - "$OUTF"
        RESULT=$?
        if [ "$1" ] && [ "$1" = "-d" ] && [ $RESULT -eq 0 ]; then
            rm "$a"
        fi
    done

Alternatively, below is a script that will search for all FLAC audio
files beyond where the script resides on your filesystem and convert
them to MP3; including those pesky filenames with spaces.

    #! /bin/bash

    find . -type f -name "*.flac" -print0 | while read -d $'\0' a

    do
        OUTF=${a%.flac}.mp3

        ARTIST=`metaflac "$a" --show-tag=ARTIST | sed s/.*=//g`
        TITLE=`metaflac "$a" --show-tag=TITLE | sed s/.*=//g`
        ALBUM=`metaflac "$a" --show-tag=ALBUM | sed s/.*=//g`
        GENRE=`metaflac "$a" --show-tag=GENRE | sed s/.*=//g`
        TRACKNUMBER=`metaflac "$a" --show-tag=TRACKNUMBER | sed s/.*=//g`
        DATE=`metaflac "$a" --show-tag=DATE | sed s/.*=//g`

        flac -c -d "$a" | lame -m j -q 0 --vbr-new -V 0 -s 44.1 - "$OUTF"
        id3 -t "$TITLE" -T "${TRACKNUMBER:-0}" -a "$ARTIST" -A "$ALBUM" -y "$DATE" -g "${GENRE:-12}" "$OUTF"
    done

Save the script as flac2mp3 and make the script executable:

    chmod a+x flac2mp3

As root, copy the script to /usr/local/bin (or anywhere else that is in
your $PATH).

    cp flac2mp3 /usr/local/bin

To make /usr/local/bin in your $PATH, do (as normal user):

    PATH=$PATH:/usr/local/bin/

and then (as normal user):

    nano .bashrc

and add export PATH=$PATH:/usr/local/bin/

Usage

Open up a terminal and cd to the directory of .flac files that you wish
to convert and enter flac2mp3

You'll see the verbose decoding/encoding process in the terminal which
may take a few moments.

Done.

Addendum

With a small modification the command file can be used to transcode the
files into a new directory structure:

    #! /bin/bash
    find "$1" -name *.flac -print0 | while read -d $'\0' IF
    do
      OF=$(echo "$IF" | sed -e 's/\.flac$/.mp3/g' -e "s,$1,$2,g")
      echo "$IF -> $OF"
      mkdir -p "${OF%/*}"

      ARTIST=`metaflac "$IF" --show-tag=ARTIST | sed s/.*=//g`
      TITLE=`metaflac "$IF" --show-tag=TITLE | sed s/.*=//g`
      ALBUM=`metaflac "$IF" --show-tag=ALBUM | sed s/.*=//g`
      GENRE=`metaflac "$IF" --show-tag=GENRE | sed s/.*=//g`
      TRACKNUMBER=`metaflac "$IF" --show-tag=TRACKNUMBER | sed s/.*=//g`
      DATE=`metaflac "$IF" --show-tag=DATE | sed s/.*=//g`

      flac -c -d "$IF" 2> /dev/null | lame -m j -q 0 --vbr-new -V 0 -s 44.1 - "$OF" 2> /dev/null
      id3 -t "$TITLE" -T "${TRACKNUMBER:-0}" -a "$ARTIST" -A "$ALBUM" -y "$DATE" -g "${GENRE:-12}" "$OF"
    done

if saved in flac2mp3 this can be used as follows

    ./flac2mp3 /srv/media/music /srv/media/music-lofi

which will take the directory structure under /srv/media/music and
transcode its content into /srv/media/music-lofi.

Nautilus-scripts

Here's a well-written version of "flac2mp3" script which will run either
from command line or, if you copy it into ~/.gnome2/nautilus-scripts, it
will appear in the right-click menu in Nautilus:

    #!/bin/bash
    #
    # Copyright 2008 Octavio Ruiz
    # Distributed under the terms of the GNU General Public License v3
    # $Header: $
    #
    # Yet Another FLAC to MP3 script
    #
    # Author:
    # Octavio Ruiz (Ta^3) <tacvbo@tacvbo.net>
    # Thanks:
    # Those comments at:
    # http://www.linuxtutorialblog.com/post/solution-converting-flac-to-mp3
    # WebPage:
    # https://github.com/tacvbo/yaflac2mp3/tree
    #
    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
    # WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
    # OTHER KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
    # See the GNU General Public License for more details.
    #
    # Modified by woohoo
    #
    # you need zenity package for notifications.
    # please note that you can put this script in ~/.gnome2/nautilus-scripts
    # and it will show up in right-click menu in any folder in gnome.
    #
    # modify the lame options to your preference example change -b 320 to -b 128 or -b 192 or -b 256
    # LAME_OPTS="--vbr-new -V 0 -b 256"
    # LAME_OPTS="-V 0 --vbr-new"

    LAME_OPTS="-b 320 -h --cbr"

    old_IFS=${IFS}
    IFS='
    '

    # when running from nautilus-scripts, it useful to find the current folder
    base="`echo $NAUTILUS_SCRIPT_CURRENT_URI | cut -d'/' -f3- | sed 's/%20/ /g'`"
    if [ -z "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]; then
      dir="$base"
    else
      while [ ! -z "$1" -a ! -d "$base/$1" ]; do shift; done
      dir="$base/$1"
    fi

    if [ "$dir" != "" ]; then
      cd "$dir"
    fi

    id3v2=$(which id3v2)

    files=`find . -type f -regex '^.+\.flac$' | sort`

    declare -i nn=0
    for file in ${files}
    do
      fn=$(readlink -f "$file")
      vars=( `metaflac --no-utf8-convert --export-tags-to=- "${fn}"` )

      for N_vars in ${!vars[@]}
      do
        export "$(echo "${vars[${N_vars}]%=*}" | tr [:upper:] [:lower:])=${vars[${N_vars}]#*=}"
      done

      dest=`echo "$fn"|sed -e 's/\.flac$/\.mp3/'`

      flac -dc "$fn" |\
        lame --ignore-tag-errors --add-id3v2 ${LAME_OPTS} \
            ${artist:+--ta} ${artist} \
            ${tracknumber:+--tn} ${tracknumber} \
            ${title:+--tt} ${title} \
            ${album:+--tl} ${album} \
            ${date:+--ty} ${date} \
            ${genre:+--tg} ${genre} \
            ${comment:+--tc} ${comment} \
            - $dest
     
        [[ -x ${id3v2} ]] && ${id3v2} \
            ${artist:+--artist} ${artist} \
            ${tracknumber:+--track} ${tracknumber} \
            ${title:+--song} ${title} \
            ${album:+--album} ${album} \
            ${date:+--year} ${date} \
            ${genre:+--genre} ${genre} \
            ${comment:+--comment} ${comment} \
            $dest

      let nn=nn+1
    done

    zenity --notification --text "Finished converting flac to mp3.${IFS}Processed ${nn} files."
    #zenity --info --text "Done!"
    IFS=${old_IFS}

More such conversion scripts on pastebin.com here.

More generic solution
---------------------

See Convert_Any_To_Mp3 for a more generic solution if you want to
transform to mp3 all kind of audio formats supported by both mplayer and
mutagen.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Convert_Flac_to_Mp3&oldid=205934"

Categories:

-   Audio/Video
-   Scripts
