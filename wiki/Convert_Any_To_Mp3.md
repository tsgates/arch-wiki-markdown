Convert Any To Mp3
==================

Below is a script that will convert a lot of audio formats to MP3 via
the commandline. It has MPlayer, mutagen and lame as dependencies, so it
should accept every format that both mutagen and player accept.

Basically, mp3ify <input_dir> [<output_dir>] transforms structure
<input_dir>/X/Y/.../Z into structure <output_dir>/X/Y/.../Z according to
the following rules:

-   flac, ogg, m4a, ape, aac, mpc files will be encoded to mp3
    preserving tags.

-   Everything else will be copied without modification.

Default output_dir is /tmp/mp3ify.

lame settings fine-tunning is done editing the configuration variables
at the top of the script.

If you prefer to install a package here is one at the AUR.


    #!/bin/bash

    DEFAULT_OUTPUT_DIR=/tmp/mp3ify
    QUALITY=2
    VBR_QUALITY=4
    MIN_BITRATE=64
    MAX_BITRATE=256
    SAMPLE_FREQ=44.1


    function any_to_mp3 {

      PIPE=`mktemp -u -t mp3ify.pipe.XXXXXX`
      mkfifo "$PIPE"

      mplayer -ao pcm -ao pcm:file="$PIPE" "$INPUT_FILE" -noconsolecontrols > /dev/null 2>&1 &

      lame -m j -q $QUALITY -v -V $VBR_QUALITY -b $MIN_BITRATE \
           -B $MAX_BITRATE -s $SAMPLE_FREQ "$PIPE" "$OUTPUT_FILE" > /dev/null 2>&1

      rm "$PIPE"

      python2 -c "
    import mutagen
    input = mutagen.File(\"$INPUT_FILE\", easy = True)
    output = mutagen.File(\"$OUTPUT_FILE\", easy = True)
    for tag in [ 'artist', 'album', 'tracknumber', 'date', 'genre', 'title', 'comment' ]:
      value = input.get(tag)
      if value: output[tag] = value[0]
    output.save(v1=2)"
    }


    function usage {

      echo "mp3ify <input_dir> [<output_dir>]

      Transforms structure <input_dir>/X/Y/.../Z into structure <output_dir>/X/Y/.../Z
      according to the following rules:

        flac, ogg, m4a, ape, aac, mpc files will be encoded to mp3 preserving tags.

        Everything else will be copied without modification.

      Requires: mplayer, lame, mutagen.
    "
      exit 1
    }


    INPUT_DIR="$1"
    [ -d "$INPUT_DIR" ] || usage
    OUTPUT_DIR="${2:-$DEFAULT_OUTPUT_DIR}"

    find "$INPUT_DIR" -name '*.*' | while read INPUT_FILE
    do
      INPUT_EXTENSION="${INPUT_FILE##*.}"
      OUTPUT_FILE="$OUTPUT_DIR/${INPUT_FILE#$INPUT_DIR}"
      mkdir -p "`dirname "$OUTPUT_FILE"`"

      case $INPUT_EXTENSION in
      flac|m4a|ogg|ape|aac|mpc)
        OUTPUT_FILE="${OUTPUT_FILE%.$INPUT_EXTENSION}.mp3"
        echo -n "Converting ${INPUT_FILE##*/}... "
        any_to_mp3
        ;;
      *)
        echo -n "Copying ${INPUT_FILE##*/}... "
        cp "$INPUT_FILE" "$OUTPUT_FILE"
        ;;
      esac

      echo "done."
    done

Retrieved from
"https://wiki.archlinux.org/index.php?title=Convert_Any_To_Mp3&oldid=239107"

Categories:

-   Audio/Video
-   Scripts
