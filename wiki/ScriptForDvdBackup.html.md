ScriptForDvdBackup
==================

I created a simple script for backing up a DVD and thought I'd share.

First you need wine, libdvdcss and libdvdread installed and have wine
configure itself for your user

    sudo pacman -S wine libdvdcss libdvdread

Then download and install DVDShrink 3.1 from
http://www.afterdawn.com/software/video_software/dvd_rippers/dvd_shrink.cfm:

    unzip dvdshrink*.zip
    wine dvdshrink*.exe

You also need to find dvdbackup.c and compile it

    gcc -o dvdbackup -ldvdread dvdbackup.c

And for simplicity's sake make a batch script to have wine run DVDShrink
3.1

    echo wine /home/username/.wine/drive/c/Program\ Files/DVD\ Shrink/DVD\ Shrink\3.1.exe > wine_dvdshrink

Almost everything is in place just need to move some files around

    chmod 555 dvdbackup
    chmod 555 wine_dvdshrink
    sudo mv dvdbackup /usr/bin/
    sudo mv wine_dvdshrink /usr/bin/

All done now except for the actual script which does all of the work.
Copy and paste this into a new file and chmod it executable. Then just
run this script and follow the prompts. The first few lines define
variables so you can adjust what drive you want to read, burn and where
you want to store the temporary VOB files.

    #!/bin/sh

    #setup for reader and directories
    TheDVDReader="/dev/cdroms/cdrom1"
    TheRIPFolder="/mnt/extrahdd/dvd_backups/"
    TheDVDBurner="/dev/cdroms/cdrom0"
    # Most likely you do not need to edit the "MOVIE=" line
    MOVIE=`dvdbackup -i $TheDVDReader -I 2> /dev/null || grep "DVD-Video information" || sed -e 's/.* //g'`

    clear
    echo "################## $MOVIE #######################"
    echo "Are you ready to start copying the DVD to disk [[Y/n]]?"
    read ready

    if [ "$ready" = "n" ]; then
      echo "Cancelled, exiting.."
      exit 0
    fi

    if [ "$ready" = "N" ]; then
      echo "Cancelled, exiting.."
      exit 0
    fi

    dvdbackup -M -i $TheDVDReader -o $TheRIPFolder


    clear
    echo "################## $MOVIE #######################"
    echo "DVDShrink will now run under wine."
    echo "Make whatever changes you need to and"
    echo "save your iso as z:\$TheRIPFolder/$MOVIE.ISO"

    wine_dvdshrink

    clear
    echo "################## $MOVIE #######################"
    echo "Hit return when you are ready."
    echo "All files will be deleted except for your .iso"
    echo " "
    echo "Also make sure to  insert a blank DVD into your writer now."
    read ready

    if [ "$ready" = "n" ]; then
      echo "Cancelled, exiting.."
      exit 0
    fi

    if [ "$ready" = "N" ]; then
      echo "Cancelled, exiting.."
      exit 0
    fi

    #delete temp files since now we have a .iso
    rm -rf $TheRIPFolder/$MOVIE

    growisofs -dvd-compat -Z $TheDVDBurner=$TheRIPFolder/$MOVIE.ISO

    clear
    echo "################## $MOVIE #######################"
    echo "Would you like to delete the .iso at this time? [[Y/n]]"
    read ready

    if [ "$ready" = "n" ]; then
      echo "Cancelled, exiting.."
      exit 0
    fi

    if [[ "$ready" = "N" ]; then
      echo "Cancelled, exiting.."
      exit 0
    fi

    rm -f $TheRIPFolder/$MOVIE.ISO

Any alterations with this is welcomed. I've only tried this on my
install, so I might be missing a thing or two.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ScriptForDvdBackup&oldid=198608"

Categories:

-   Audio/Video
-   Scripts

-   This page was last modified on 23 April 2012, at 18:23.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
