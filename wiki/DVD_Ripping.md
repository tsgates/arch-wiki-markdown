DVD Ripping
===========

Summary

Discusses various methods and tools used for copying DVDs.

Series

DVD Playing

DVD Ripping

DVD Burning

Related

dvdbackup

MEncoder

ScriptForDvdBackup

Ripping is the process of copying audio or video content to a hard disk,
typically from removable media or media streams.[1]

Often, the process of ripping a DVD can be broken down into two
subtasks:

1.  Data extraction -- copying the audio and/or video data to a hard
    disk
2.  Transcoding -- converting the extracted data into a suitable format

Some utilities perform both tasks, whilst others focus on one aspect or
the other.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 dvdbackup                                                          |
| -   2 dvd::rip                                                           |
| -   3 HandBrake                                                          |
| -   4 MEncoder                                                           |
|     -   4.1 Dvd2Avi                                                      |
|     -   4.2 dvdcopy                                                      |
|     -   4.3 MEncoder GUIs                                                |
|                                                                          |
| -   5 Hybrid                                                             |
| -   6 Troubleshooting                                                    |
|     -   6.1 None of the above programs are able to rip / encode a DVD to |
|         my hard disk!                                                    |
+--------------------------------------------------------------------------+

dvdbackup
---------

dvdbackup is used simply for data extraction, and does not transcode.
This tool is useful for creating exact copies of encrypted DVDs in
conjunction with libdvdcss or for decrypting video for other utilities
unable to read encrypted DVDs.

dvd::rip
--------

dvd::rip is a front-end to transcode, used to extract and transcode
on-the-fly.

The following packages should be installed:

-   dvdrip: GTK front-end for transcode, which performs the ripping and
    encoding
-   libdv: Software codec for DV video
-   xvidcore: If you want to encode your ripped files as XviD, an open
    source MPEG-4 video codec (free alternative to DivX)
-   divx4linux: If you want to encode your ripped files as DivX
    (available in the AUR)

    # pacman -S dvdrip libdv xvidcore

The dvd::rip preferences are mostly well-documented/self-explanatory. If
you need help with something, see
http://www.exit1.org/dvdrip/doc/gui-gui_pref.cipp.

Ripping a DVD is often a simple matter of selecting the preferred
codec(s), selecting the desired titles, then clicking the "Rip" button.

HandBrake
---------

HandBrake is a multithreaded video transcoder, which offers both a
graphical and command-line interface with many preset configurations.
The package is available in [Community]: handbrake.

MEncoder
--------

MEncoder is a free command line video decoding, encoding and filtering
tool released under the GNU General Public License. It is a close
sibling to MPlayer and can convert all the formats that MPlayer
understands into a variety of compressed and uncompressed formats using
different codecs.[2]

MEncoder is included with the mplayer package.

See the Gentoo Linux Wiki article on this subject for more information:
Mencoder

> Dvd2Avi

A simple Bash script using MEncoder can be found here.

> dvdcopy

dvdcopy is a more complex tool available in the AUR that backs up a DVD9
to a DVD5. Has several options for modification.

> MEncoder GUIs

If you dislike the command line, or just want access to more of
MEncoder's options, then there are several GUI programs available.

The official MPlayer homepage has a comprehensive list of available
front-ends here.

Hybrid
------

Hybrid is a multi platform (Linux/Mac OS X/Windows) Qt based frontend
for a bunch of other tools which can convert nearly every input to
x264/Xvid/VP8 + ac3/ogg/mp3/aac/flac inside an mp4/m2ts/mkv/webm/mov/avi
container, a Blu-ray or an AVCHD structure.

A package is available in the AUR -> hybrid-encoder

For detailed information visit: http://www.selur.de/

Troubleshooting
---------------

> None of the above programs are able to rip / encode a DVD to my hard disk!

Make sure the region of your DVD-reader is set correctly, otherwise
you'll get loads of unexplainable CSS-related errors. Use regionset to
do so.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DVD_Ripping&oldid=248270"

Categories:

-   Audio/Video
-   Optical
