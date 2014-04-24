Rip Audio CDs
=============

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Optical     
                           Disc Drive.              
                           Notes: There's already   
                           Optical Disc Drive#DVD   
                           ripping. (Discuss)       
  ------------------------ ------------------------ ------------------------

CD rippers are designed to extract ("rip") the raw digital audio (in a
format commonly called CDDA) from a compact disc to a file or other
output. Most CD rippers also support burning audio to a CD and
transcoding it on-the-fly.

Contents
--------

-   1 Introduction
-   2 Ripping
    -   2.1 Using a CD ripper
    -   2.2 Using a simple shell script
-   3 Post-processing
    -   3.1 Tag editors
    -   3.2 Converting to other formats
-   4 See also

Introduction
------------

Music is usually stored on audio CDs in an uncompressed format (requires
a lot of space, e.g. 700MB for only 80 minutes of audio). Extracting the
audio from the CD usually involves compressing it so that it requires
less space using:

 Lossless compression
    same quality, less space.
 Lossy compression
    lower quality, much less space.

Most common formats to convert to are: APE and FLAC for lossless and MP3
and OGG for lossy.

Ripping
-------

> Using a CD ripper

For some examples of CD rippers see: List of Applications#CD Ripping.

> Using a simple shell script

If you want to rip an audio CD gapless and using CD-Text you can use the
following shell script. You need to install the mp3splt, cdrtools and
vorbis-tools packages, all available in the official repositories.

    rip_gapless.sh

    #!/bin/bash
    # This script needs mp3splt, cdrtools, vorbis-tools

    CREATE_OGG="true";
    CREATE_FLAC="false";
    CREATE_MKA="false";

    WORKING_DIRECTORY=$(pwd)

    function usage() 
    { 
      echo "Usage: $0 [OUTPUT_DIRECTORY] device";
      echo "eg.: $0 my_audio_cd /dev/sr0";
      exit;
    }

    function no_cdtext()
    {
      echo "CD doesn't contain cd-text information";
      echo "Please specify output directory";
      echo "$0 OUTPUT_DIRECTORY device";
      exit;
    }

    function remove_quotes() {
      local OUTPUT_STRING
      # remove quotes
      OUTPUT_STRING=$(echo "$1" | sed "s/^\([\"']\)\(.*\)\1\$/\2/g")
      # remove selected special characters
      echo "$OUTPUT_STRING" | sed "s/\(.*\)[\\]\(.*\)/\1\2/g"
    }

    # store command line parameters
    if  [[ "$#" = "2" ]] ; then
      CDROM=$2;
      OUTPUT_DIRECTORY=$1;
    elif [[ "$#" = "1" ]] ; then
      CDROM=$1;
    else 
      usage;
    fi

    # retrieve CD information
    echo "Retrieve CD information"
    CD_INFO=$(cdda2wav -J -g /dev/sr0 2>&1)

    # test if CD-Text is available
    if [[ "detected" == $(echo "${CD_INFO}" | awk '/^CD-Text.*/ {print $2}') ]]; then
      echo "CD-Text detected"
      CD_TEXT_DETECTED=true
      ALBUM_INFORMATION=$(echo "${CD_INFO}" | grep ^"Album title")
      # remove characters from beginning of string
      ALBUM_INFORMATION=$(echo "${ALBUM_INFORMATION#*Album title: }")
      ALBUM_TITLE=$(echo "${ALBUM_INFORMATION% from *}")
      ALBUM_TITLE=$(remove_quotes "${ALBUM_TITLE}")
      ALBUM_ARTIST=$(echo "${ALBUM_INFORMATION#* from }")
      ALBUM_ARTIST=$(remove_quotes "${ALBUM_ARTIST}")
    fi

    # check if cd has cdtext
    if [[ true == ${CD_TEXT_DETECTED} ]]; then
      if [[ "2" = "$#" ]]; then
        echo "CD-text found"
        echo "Overriding given output directory name"
      fi
      mkdir -p "./${ALBUM_ARTIST}/${ALBUM_TITLE}"
      cd "./${ALBUM_ARTIST}/${ALBUM_TITLE}"
      OUTPUT_DIRECTORY="${ALBUM_ARTIST}/${ALBUM_TITLE}"
      OUTPUT_FILENAME="${ALBUM_TITLE}"
    else
      if [[ "$#" != "2" ]]; then
        no_cdtext
      else
        mkdir "${OUTPUT_DIRECTORY}"
        cd "${OUTPUT_DIRECTORY}"
        OUTPUT_FILENAME="${OUTPUT_DIRECTORY}"
      fi
    fi

    cdda2wav -cuefile -paranoia -t all dev=${CDROM} "${OUTPUT_FILENAME}.wav" &> "${OUTPUT_FILENAME}.log"

    if [[ "true" = ${CREATE_OGG} ]]; then
      mkdir ogg
      pushd ogg
      oggenc -o "${OUTPUT_FILENAME}.ogg" -q 6 "../${OUTPUT_FILENAME}.wav"
      oggsplt -c "../${OUTPUT_FILENAME}.cue" -o "@N - @t" "${OUTPUT_FILENAME}.ogg"
      popd
    fi

    if [[ "true" = ${CREATE_FLAC} ]]; then
      mkdir flac
      pushd flac
      cd flac  # -5 -V -T "ARTIST=%a" -T "ALBUM=%g" -T "DATE=%y" -T "GENRE=%m" --tag-from-file=CUESHEET="%a - %g.cue" --cuesheet="%a - %g.cue" %s
      flac --cuesheet="../${OUTPUT_FILENAME}.cue" --tag-from-file=CUESHEET="../${OUTPUT_FILENAME}.cue" --output-name="./${OUTPUT_FILENAME}.flac" --best "../${OUTPUT_FILENAME}.wav"
      popd
    fi

    if [[ "true" = ${CREATE_MKA} ]]; then
      mkdir mka
      pushd mka
      # -5 -V -T "ARTIST=%a" -T "ALBUM=%g" -T "DATE=%y" -T "GENRE=%m" --tag-from-file=CUESHEET="%a - %g.cue" --cuesheet="%a - %g.cue" %s
      flac --output-name="./${OUTPUT_FILENAME}.flac" --best "../${OUTPUT_FILENAME}.wav"
      mkvmerge -q -o "${OUTPUT_FILENAME}.flac.mka" "${OUTPUT_FILENAME}.flac" --attachment-mime-type text/plain --attachment-description "cdda2wav Log" --attach-file "../${OUTPUT_FILENAME}.log" --attachment-mime-type text/plain --attachment-description "Original CUE Sheet" --attach-file "../${OUTPUT_FILENAME}.cue" --title "${ALBUM_TITLE}" --chapters "../${OUTPUT_FILENAME}.cue"
      rm "./${OUTPUT_FILENAME}.flac"
      popd
    fi

    # rm "${WORKING_DIRECTORY}/${OUTPUT_DIRECTORY}/${OUTPUT_FILENAME}.{cddb,cdindex,cdtext,wav}"

Post-processing
---------------

> Tag editors

For some examples of audio tag editors see: List of Applications#Audio
tag editors.

> Converting to other formats

If the CD ripper you used does not support the format you wanted to
convert to you can use other encoders/decoders such as FFmpeg or
MEncoder. Some simple scripts to convert from flac or other formats to
MP3 can also be found on the wiki.

See also
--------

-   RIAA and actual laws allow backup of physically obtained media under
    these conditions RIAA - The Law.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Rip_Audio_CDs&oldid=275558"

Category:

-   Optical

-   This page was last modified on 15 September 2013, at 03:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
