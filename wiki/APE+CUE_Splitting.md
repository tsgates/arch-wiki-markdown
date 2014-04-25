APE+CUE Splitting
=================

This article describes how to split audio file basing on CUE metadata.

Contents
--------

-   1 Installation
-   2 Splitting
-   3 Tagging
-   4 Alternatives
-   5 References

Installation
------------

To split the audio files you'll need to install shntool:

     pacman -S shntool

If you want to split iso/bin files, you will also need bchunk:

     pacman -S bchunk

You'll need to install decoders to read the files, for example:

     pacman -S mac flac wavpack

To encode files to any format other than wav you'll need to install
encoders, for example:

     pacman -S flac lame vorbis-tools

To tag the files you'll need extra tools such as:

     pacman -S cuetools mp3info vorbis-tools

Splitting
---------

To split a disc audio file accompanied by a cue sheet use the shnsplit
command, for example:

     shnsplit -f file.cue file.ape

     shnsplit -f file.cue file.wv

To split bin files with cue sheets use

     bchunk -v -w file.bin file.cue out

All these commands produce .wav files. You probably want to compress the
audio files with formats like flac or mp3.

shnsplits gives the possibility to convert on the fly to most lossless
formats, like flac. It can be used like so:

     shnsplit -f file.cue -o flac file.ape

If you need more control over the conversion you may change the
converter parameters inline:

     shnsplit -f file.cue -o "flac flac -s -8 -o %f -" file.ape

The formats shnsplit supports can be view using the command

     shntool -a

  
 For other situations, like wanting to convert to lossy formats like
vorbis or mp3 and when using bchunk, refer to Convert Any To Mp3 for
examples.

Tagging
-------

You'll need cuetools to use cuetag.sh.

To copy the metadata from a cue sheet to the splitted files you can use:

     cuetag.sh file.cue *.mp3

or if you need to select only certain files:

     cuetag.sh file.cue track01.mp3 track02.mp3 track03.mp3 track04.mp3

cuetag.sh supports id3 tags for .mp3 files and vorbis tags for .ogg and
.flac files.

Alternatives
------------

-   This is a script that splits and converts files to tagged FLAC:
    https://bbs.archlinux.org/viewtopic.php?id=75774.
-   You can also try the split2flac script from the AUR.
-   You may also use flacon, a graphical Qt program that splits,
    converts and tags album audio files into song audio files.

References
----------

-   What is APE?
-   What is CUE?
-   Convert Any To Mp3
-   Rip Audio CDs

Retrieved from
"https://wiki.archlinux.org/index.php?title=APE%2BCUE_Splitting&oldid=278631"

Category:

-   Audio/Video

-   This page was last modified on 13 October 2013, at 22:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
