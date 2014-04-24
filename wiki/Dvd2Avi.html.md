Dvd2Avi
=======

A simple Bash script for ripping DVDs; missing some of the more advanced
features such as cropping, but aspect ratio is kept intact.

    #!/bin/sh

    # Dvd2Avi 0.2
    # Only does one title at a time, but "avimerge" from Transcode
    # can sort it from there.

    # by yyz

    echo -n "Enter the name of output file (without extension):"
    read FILE

    echo -n "Enter the title you wish to rip:"
    read TITLE

    echo -n "Select a quality level (h/n/l)[[n]]:"
    read Q

    if [[ -z $Q ]];then 
        # If no quality passed, default to normal
        Q=n
    fi

    if [[ $Q = h ]]; then 
    # If h passed, use high quality
    mencoder dvd://$TITLE -alang en -oac mp3lame -lameopts br=320:cbr -ovc lavc -lavcopts vcodec=mpeg4:vhq -vf scale -zoom -xy 800 -o $FILE.avi
    exit $?
    fi

    if [[ $Q = n ]]; then 
    # If n passed, use normal quality (recommended)
    mencoder dvd://$TITLE -alang en -oac mp3lame -lameopts br=160:cbr -ovc lavc -lavcopts vcodec=mpeg4:vhq -vf scale -zoom -xy 640 -o $FILE.avi
    exit $?
    fi

    if [[ $Q = l ]]; then 
    # If l passed, use low quality. not really worth it, 
    # hardly any smaller but much crappier
    mencoder dvd://$TITLE -alang en -oac mp3lame -lameopts br=96:vbr -ovc lavc -lavcopts vcodec=mpeg4:vhq -vf scale -zoom -xy 320 -o $FILE.avi
    exit $?
    fi

Here is an explanation of the various quality levels:

-   High: movie is 800px wide, audio is 320kbps mp3.
-   Normal: movie is 640px wide, audio is 160kbps mp3.
-   Low: movie is 320px wide, audio is 96kbps mp3.

To use the script, copy and paste it into an appropriately named file
(such as dvdrip.sh), and then execute chmod +x <file>.

Hopefully the script is quite easy to understand so you can change it as
needed. See man mencoder for more information.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dvd2Avi&oldid=198598"

Categories:

-   Scripts
-   Audio/Video

-   This page was last modified on 23 April 2012, at 18:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
