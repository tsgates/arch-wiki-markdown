Audiobook
=========

Summary

The purpose of this article is to detail a process to create an iPod
friendly audiobook from digital media using Linux native tools. It is
arranged in goal-oriented scenarios.

Related

iPod

An audiobook for iPods is nothing more than a discrete audio stream +
metadata wrapped together in an m4b container. The audio must be an aac
encoded stream and the chapter-index metadata has its own Quicktime
standard. Multiple tools can be used to create these.

See the Wikipedia article on this subject for more information: .m4b

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Tools                                                              |
|     -   1.1 GUI based tools                                              |
|     -   1.2 CLI based tools                                              |
|                                                                          |
| -   2 Make an m4b file from multiple audio CDs                           |
|     -   2.1 Extract audio from CDs and making multiple tracks, one per   |
|         chapter                                                          |
|     -   2.2 Use m4baker to assemble the indiviual tracks into a single   |
|         m4b file                                                         |
|                                                                          |
| -   3 Make an m4b file from a single mp3 file or from multiple mp3 files |
|     -   3.1 Predominantly using m4baker                                  |
|         -   3.1.1 Make a single mp3 file                                 |
|         -   3.1.2 Split the file into chapters                           |
|         -   3.1.3 Use m4baker to assemble the indiviual tracks into a    |
|             single m4b file                                              |
|                                                                          |
|     -   3.2 Using only CLI tools                                         |
|         -   3.2.1 Decode and make aac formatted file(s)                  |
|         -   3.2.2 Optionally combine multiple aac files into a single    |
|             file                                                         |
|         -   3.2.3 Create metadata for chapter marks                      |
|         -   3.2.4 Hardcode the metadata into the audio file              |
|         -   3.2.5 Rename the merged file                                 |
|                                                                          |
| -   4 Add chapter marks to an existing m4b file without them             |
| -   5 Break up an m4b file into individual files                         |
|     -   5.1 Into equal chunks                                            |
|     -   5.2 Based on metadata in original m4b file                       |
+--------------------------------------------------------------------------+

Tools
-----

> GUI based tools

-   m4baker - Used to combine a group of already ripped audiofiles into
    a single m4b file with chapter marks.

> CLI based tools

-   neroaacenc - Aac encoder.
-   lame - Mp3 encoder/decoder
-   gpac - Needed for manipulating mp4 files.
-   mediainfo - Displays many aspects of audio and video files.
-   makechapterlist - Makes a chapter list automatically.

Make an m4b file from multiple audio CDs
----------------------------------------

> Extract audio from CDs and making multiple tracks, one per chapter

Use one of the many fine CD rippers available to extract and encode the
many CDs in a typical audiobook into aac encoded files. (Out of scope
for this tutorial).

Note:File extensions need not be .aac but the audio stream DOES need to
be in aac format.

> Use m4baker to assemble the indiviual tracks into a single m4b file

Usage of m4baker is very straightforward. Detailed usage is explained on
the [project wiki]. Be aware that the default qualitizer setting for
faac is 100. Some sources may require tweaking. Faac takes values of 10
- 500 for the -q option.

Make an m4b file from a single mp3 file or from multiple mp3 files
------------------------------------------------------------------

> Predominantly using m4baker

Note:This guide assumes that the requisite mp3 file(s) do not correspond
to the natural chapter breaks of the narrative.

Users have several options to define chapter marks. One is to define
arbitrary "chapter markers" using a set time interval (i.e. 10 min) to
define the chapter breaks. Another method can make use of silence
detection to automatically break up chapter points. In either case, a
single file is required.

Make a single mp3 file

If not already starting from one, simply concatenate them into a single
file:

    $ MP4Box -cat 1.mp3 -cat 2.mp3 final.mp3

Split the file into chapters

Split the single file into chapters. In this example, a contains time of
10 min is used:

    $ mp3splt -f -t 10.0 final.mp3 -o @n

See the mp3splt manpage for additional options and for an explanation of
the options used above.

This example uses the auto silence mode wherein the file is scanned for
periods of silence and split points generated from them.

    $ mp3splt -f -s -p -min=3 final.mp3

Note:This mode is NOT general and requires considerable tweaking to
work. See the man page for more options.

Use m4baker to assemble the indiviual tracks into a single m4b file

Usage of m4baker is very straightforward. Detailed usage is explained on
the [project wiki]. Be aware that the default qualitizer setting for
faac is 100. Some sources may require tweaking. Faac takes values of 10
- 500 for the -q option.

> Using only CLI tools

Decode and make aac formatted file(s)

Since iPods require aac formatted audio, mp3 files need to be transcoded
into aac. First, decode the source mp3 file to wav. Repeat if multiple
mp3 files constitute an entire book:

    $ lame --decode book.mp3

Encode the wav file(s) to aac:

    $ neroAacEnc -q 0.7 -if book.wav -of book.aac

Tip:If multiple files are used, make use of a for loop to process them
in one line.

    $ for i in *.mp3; do lame --decode "$i"; done
    $ for i in *.wav; do neroAacEnc -q 0.7 -if "$i" -of "${i%.*}".aac; done

Optionally combine multiple aac files into a single file

Multiple aac files need to be concatenated into a single file:

    $ MP4Box -cat 1.aac -cat 2.aac book.aac

Create metadata for chapter marks

Determine the overall length of the aac:

    $ mediainfo --inform="Audio;%Duration/String3%" book.aac
    19:04:53.874

In this example, the file is 19h 4m and 54 s long.

Create a chapter list to break up the file into "chapters" or more
digestible parts. The list itself is nothing more than a text file in a
specific format (Nero chapter format to be precise). Use makechapterlist
to make this automatically.

Note:The current version of makechapterlist simply makes chapter marks
at 10 minute intervals. To have the chapter marks coincide with the
actual chapter breaks in the audio file, knowledge about when a chapter
begins/ends is needed.

The example file calls for roughly 19h 5m of content, but the script
uses 10 m intervals so a sane value is simply 19x6=114 chapters.

    $ makechapterlist
    Writes chapter files using a 10 min interval for each chapter

    How many chapters are needed: 114
    Done!  /home/facade/chapter.list written.

Hardcode the metadata into the audio file

The next step is to merge the metadata in chapter.list with the audio
file. This is accomplished using MP4Box:

    $ MP4Box -add book.aac -chap chapters.list book.mp4

The resulting file now needs to be converted to Quicktime chapter
markers using mp4chaps:

    $ mp4chaps –convert –chapter-qt book.mp4

Rename the merged file

The final step is to simply rename the mp4 file to the m4b extension:

    $ mv book.mp4 book.m4b

Users can now optionally edit the tags in the file with any number of
tools. Using vlc is easy. Simply load the file and hit Ctrl + i to bring
up a tag window. Save the metadata before exiting.

Add chapter marks to an existing m4b file without them
------------------------------------------------------

This process is identical to steps 3-5 detailed in Scenario 2.

Break up an m4b file into individual files
------------------------------------------

Some stereo systems in cars are not capable of using the metadata
(chapter marks) within an m4b file. It is therefore necessary to break
up the m4b file into individual "chapter" files.

> Into equal chunks

1.  Rename the m4b file to mp4
2.  Invoke the -split sec option of MP4Box:

    $ mv target.m4b target.mp4
    $ MP4Box -split 600 target.mp4

> Based on metadata in original m4b file

Retrieved from
"https://wiki.archlinux.org/index.php?title=Audiobook&oldid=207391"

Category:

-   Audio/Video
