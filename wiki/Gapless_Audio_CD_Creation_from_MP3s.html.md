Gapless Audio CD Creation from MP3s
===================================

Contents
--------

-   1 Introduction
-   2 Setup
-   3 Decode the MP3s
-   4 Create a Table of Contents file
-   5 Burn

Introduction
------------

Some albums are meant to be played without any silent gap between tracks
-- especially live albums. Furthermore, when you copy a regular album
that has gaps, the ripped audio files will actually include this gap at
the end of each track -- to burn these tracks with a gap will actually
increase the length of silence between tracks. Therefore, in almost all
cases, you are better off burning all your CD backups gaplessly.

Here's an easy way to burn a gapless audio CD from the shell using
cdrdao.

Setup
-----

We'll be using a few programs for this.

    pacman -S lame cdrdao

Optional: Let's configure cdrdao to use our CD burner. Open up
/etc/cdrdao.conf (as root), and enter the /dev entry for your burner in
this format:

    write_device: "/dev/cdrw"

Decode the MP3s
---------------

First of all, copy all the songs you want on the CD to a folder. If
necessary, rename them to reflect the order you want the tracks to be
laid out (such as 01.mp3, 02.mp3, etc). Now we're going to decode all
the mp3s into uncompressed wav files. Take note that a full album can
take up more than 800MB in wav files alone.

    mkdir wav
    for file in *.mp3 ; do
       lame --decode "$file" "wav/$file.wav" ;
    done

Create a Table of Contents file
-------------------------------

Once finished, let's make a Table of Contents file that describes the
layout of the CD.

    cd wav
    {
      echo "CD_DA"
      for file in *.wav ; do
        echo "TRACK AUDIO"
        echo "FILE \"$file\" 0"
      done
    } > toc

Optionally, if you would like to insert a 2-second gap between certain
tracks, you can edit the toc file and insert this line between the TRACK
AUDIO and FILE lines for that track:

    PREGAP 00:02:00

Of course, you can change the gap length to any time you desire.

Burn
----

Finally, all we have to do is burn the CD.

    cdrdao write toc

Some people prefer to burn audio CDs at a low speed for higher quality.
Here's an example for burning at 8x:

    cdrdao write --speed 8 toc

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gapless_Audio_CD_Creation_from_MP3s&oldid=204850"

Category:

-   Audio/Video

-   This page was last modified on 13 June 2012, at 08:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
