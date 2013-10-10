Video2dvdiso
============

A simple Bash script to Convert any Movie to DVD Video's ISO; which can
be directly burn't to blank DVD using k3b iso burning.

> Summary

A simple Bash script to Convert any Movie to DVD Video ISO; this
requires ffmpeg to convert video to dvd compatible video, dvdauthor to
create dvd video structure, mkisofs to create dvd iso, mplayer to test
video dvd.iso, dvd+rw-tools to burn the iso

> Related

DVD Ripping

Dvd2Avi

MPlayer

Mencoder

    #!/bin/bash  
    # AVI or any video 2 DVD iso Script  
    # DvdAuthor 7 and up needs this
    export VIDEO_FORMAT=PAL  
    # Change to "ntsc" if you'd like to create NTSC disks  
    format="pal"  
      
    # Check we have enough command line arguments  
    if [ $# != 1 ]  
    then  
        echo "Usage: $0 <input file>"  
        exit  
    fi  
      
    # Check for dependencies  
    missing=0  
    dependencies=( "mencoder" "ffmpeg" "dvdauthor" "mkisofs" )  
    for command in ${dependencies[@]}  
    do  
        if ! command -v $command &>/dev/null  
        then  
            echo "$command not found"  
            missing=1  
        fi  
    done  
      
    if [ $missing = 1 ]  
    then  
        echo "Please install the missing applications and try again"  
        exit  
    fi  
      
    function emphasise() {  
        echo ""  
        echo "********** $1 **********"  
        echo ""  
    }  
      
    # Check the file exists  
    input_file=$1  
    if [ ! -e "$input_file" ]  
    then  
        echo "Input file not found"  
        exit  
    fi  
      
    emphasise "Converting AVI to MPG"  
      
    ffmpeg -i "$1" -y -target ${format}-dvd -sameq -aspect 16:9 "$1.mpg"
      
    if [ $? != 0 ]  
    then  
        emphasise "Conversion failed"  
        exit  
    fi  
      
    emphasise "Creating DVD contents"  

    dvdauthor --title -o dvd -f "$1.mpg"
    first=$?  
    dvdauthor -o dvd -T  
    second=$?  
      
    if [ $first != 0 || $second != 0 ]  
    then  
        emphasise "DVD Creation failed"  
        exit  
    fi  
      
    emphasise "Creating ISO image"  
      
    mkisofs -dvd-video -o dvd.iso dvd/  
      
    if [ $? != 0 ]  
    then  
        emphasise "ISO Creation failed"  
        exit  
    fi  
      
    # Everything passed. Cleanup  
    rm -f "$1.mpg"
    rm -rf dvd/  
      
    emphasise "Success: dvd.iso image created"  

To use the script, copy and paste it into an appropriately named file
(such as video2dvdiso.sh), and then execute chmod +x <file>.

Hopefully the script is quite easy to understand so you can change it as
needed. See man ffmpeg man mkisofs man dvdauthor for more information.

Example usage

    video2dvd.sh video.avi

will result in dvd.iso

To check the dvd.iso will play as dvd or not:

    mplayer dvd.iso

Retrieved from
"https://wiki.archlinux.org/index.php?title=Video2dvdiso&oldid=207098"

Categories:

-   Scripts
-   Audio/Video
-   Optical
