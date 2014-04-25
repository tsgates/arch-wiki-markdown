Optical Disc Drive
==================

Related articles

-   Codecs
-   MPlayer
-   dvdbackup
-   MEncoder
-   ScriptForDvdBackup
-   BluRay

From Wikipedia

In computing, an optical disc drive (ODD) is a disk drive that uses
laser light or electromagnetic waves within or near the visible light
spectrum as part of the process of reading or writing data to or from
optical discs. Some drives can only read from discs, but recent drives
are commonly both readers and recorders, also called burners or writers.
Compact discs, DVDs, and Blu-ray discs are common types of optical media
which can be read and recorded by such drives. Optical drive is the
generic name; drives are usually described as "CD" "DVD", or "Blu-ray",
followed by "drive", "writer", etc.

Contents
--------

-   1 Burning
    -   1.1 Install burning utilities
    -   1.2 Making an ISO image from existing files on hard disk
        -   1.2.1 Basic switches
        -   1.2.2 graft-points
    -   1.3 Mounting an ISO image
    -   1.4 Converting img/ccd to an ISO image
    -   1.5 Learning the name of your optical drive
    -   1.6 Reading the volume label of a CD or DVD
    -   1.7 Reading an ISO image from a CD, DVD, or BD
    -   1.8 Erasing CD-RW and DVD-RW
    -   1.9 Burning an ISO image to CD, DVD, or BD
    -   1.10 Verifying the burnt ISO image
    -   1.11 ISO 9660 and Burning On-The-Fly
    -   1.12 Multi-session
        -   1.12.1 Multi-session by wodim
        -   1.12.2 Multi-session by growisofs
        -   1.12.3 Multi-session by xorriso
    -   1.13 BD Defect Management
    -   1.14 Burning an audio CD
    -   1.15 Burning a bin/cue
        -   1.15.1 TOC/CUE/BIN for mixed-mode disks
    -   1.16 Burn backend problems
    -   1.17 Burning CD/DVD/BD with a GUI
        -   1.17.1 Free GUI Programs
        -   1.17.2 Nero Linux
-   2 DVD playing
-   3 DVD ripping
    -   3.1 dvd::rip
-   4 Troubleshooting
    -   4.1 K3b locale error
    -   4.2 Brasero fails to find blank discs
    -   4.3 Brasero fails to normalize audio CD
    -   4.4 VLC: Error "... could not open the disc /dev/dvd"
    -   4.5 DVD drive is noisy
    -   4.6 Playback does not work with new computer (new DVD-Drive)
    -   4.7 None of the above programs are able to rip/encode a DVD to
        my hard disk!
    -   4.8 GUI program log indicates problems with backend program
        -   4.8.1 Special case: medium error / write error
-   5 See also

Burning
-------

The burning process of optical disc drives consists of creating or
obtaining an image and writing it to an optical medium. The image may in
principle be any data file. If you want to mount the resulting medium,
then it is usually an ISO 9660 file system image file. Audio and
multi-media CDs are often burned from a BIN file, under control of a TOC
file or a CUE file which tell the desired track layout.

> Install burning utilities

If you want to use programs with graphical user interface, then follow
this link to the list of GUI programs.

The programs listed here are the back ends which are used by most free
GUI programs for CD, DVD, and BD. They are command line oriented. GUI
users might get to them when it comes to troubleshooting or to scripting
of burn activities.

You need at least one program for creation of file system images and one
program that is able to burn data onto your desired media type.

Available programs for ISO 9660 image creation are:

-   genisoimage from package cdrkit
-   mkisofs from package cdrtools
-   xorriso and xorrisofs from package libisoburn

The traditional choice is genisoimage.

Available programs for burning to media are:

-   cdrdao from package cdrdao (CD only, TOC/CUE/BIN only)
-   cdrecord from package cdrtools
-   cdrskin from package libburn
-   growisofs from package dvd+rw-tools (DVD and BD only)
-   wodim from package cdrkit (CD only, DVD deprecated)
-   xorriso and xorrecord from package libisoburn

The traditional choices are wodim for CD and growisofs for DVD and
Blu-ray Disk. For growisofs and BD-R see the bug workaround below. For
writing TOC/CUE/BIN files to CD, install cdrdao.

The free GUI programs for CD, DVD, and BD burning depend on at least one
of the above packages.

The programs genisoimage, mkisofs, and xorrisofs all three support the
genisoimage options which are shown in this document.

The programs cdrecord, cdrskin, and wodim all three support the shown
wodim options. Program xorrecord supports those which do not deal with
audio CD.

> Note:

-   The installed files of packages cdrkit and cdrtools are in conflict.
    Install only one of them.
-   If you want to install cdrtools, make sure that you build a package
    using makepkg and install with pacman. Pacman wrappers may resolve
    to cdrkit instead.

> Making an ISO image from existing files on hard disk

The simplest way to create an ISO image is to first copy the needed
files to one folder, for example: ./for_iso.

Then use genisoimage in the manner of the following example:

    $ genisoimage -V "ARCHIVE_2013_07_27" -J -r -o isoimage.iso ./for_iso

Each of those flags/switches are explained in the following sections.

Basic switches

-V
    Specifies the name (that is assigned to) of the file system. The ISO
    9660 standard specs impose the limitations of 32-character string
    length, as well as limiting the characters allowed to sets of: "A"
    to "Z", "0" to "9", and "_". This volume label will probably show up
    as mount point if the medium is mounted automatically.
-J
    Prepares names of up to 64 UTF-16 characters for MS-Windows readers.
    Also known as "Joliet".
-joliet-long
    Would allow 103 UTF-16 characters for MS-Windows readers.
    Non-compliant to Joliet specs.
-r
    Prepares names of up to 255 characters for Unix readers and gives
    read permission for everybody. Also known as "Rock Ridge".
-o
    Sets the file path for the resulting ISO image.

graft-points

It is also possible to let genisoimage collect files and directories
from various paths

    $ genisoimage -V "BACKUP_2013_07_27" -J -r -o backup_2013_07_27.iso \
      -graft-points \
      /photos=/home/user/photos \
      /mail=/home/user/mail \
      /photos/holidays=/home/user/holidays/photos

-graft-points
    Enables the recognition of pathspecs which consist of a target
    address in the ISO file system (e.g. /photos) and a source address
    on hard disk (e.g. /home/user/photos). Both are separated by a "="
    character.

So this example puts the disk directory /home/user/photos,
/home/user/mail and /home/user/holidays/photos, respectively in the ISO
image as /photos, /mail and /photos/holidays.

Programs mkisofs and xorrisofs accept the same options. For secure
backups, consider using xorrisofs with option --for_backup, which
records eventual ACLs and stores an MD5 checksum for each data file.

See the manuals of the ISO 9660 programs for more info about their
options:

-   genisoimage
-   mkisofs
-   xorrisofs

Tip:This process can be thought of alternately as:

-   creating an archive (which is not that different, on one level, from
    creating a ZIP archive or tarball (e.g. .tar.gz))
-   creating and populating a file system volume, manifested in the form
    of a "disk" image (file), which preserves as much as possible
    (content, name, relative directory structure/hierarchy/placement,
    and possibly other file system overhead metadata / properties
    (aspects)) such as timestamp(s), ownership, permissions.

> Mounting an ISO image

To test if the ISO image is proper, you can mount it (as root):

    # mount -t iso9660 -o ro,loop=/dev/loop0 cd_image /cdrom

You have to first load the loop module:

    # modprobe loop

Do not forget to unmount the image when your inspection of the image is
done:

    # umount /cdrom

See also Mounting images as user for mounting without root privileges.

> Converting img/ccd to an ISO image

To convert an img/ccd image, you can use ccd2iso:

    $ ccd2iso ~/image.img ~/image.iso

> Learning the name of your optical drive

For the remainder of this section the name of your recording device is
assumed to be /dev/sr0.

Check this by

    $ wodim dev=/dev/sr0 -checkdrive

which should report "Vendor_info" and "Identification" of the drive.

If no drive is found, check whether any /dev/sr* exist and whether they
offer read/write permission (wr-) to you or your group. If no /dev/sr*
exists then try

    # modprobe sr_mod

> Reading the volume label of a CD or DVD

If you want to get the name/label of the media, use dd:

    $ dd if=/dev/sr0 bs=1 skip=32808 count=32

> Reading an ISO image from a CD, DVD, or BD

You should determine the size of the ISO file system before copying it
to hard disk. Most media types deliver more data than was written to
them with the most recent burn run.

Use program isosize out of package util-linux to obtain the image size

    $ blocks=$(expr $(isosize /dev/sr0) / 2048)

Have a look whether the obtained number of blocks is plausible

    $ echo "That would be $(expr $blocks / 512) MB"

    That would be 589 MB

Then copy the determined amount of data from medium to hard disk :

    $ dd if=/dev/sr0 of=isoimage.iso bs=2048 count=$blocks

Omit count=$blocks if you did not determine the size. You will probably
get more data than needed. The resulting file will nevertheless be
mountable. It should still fit onto a medium of the same type as the
medium from which the image was copied.

If the original medium was bootable, then the copy will be a bootable
image. You may use it as pseudo CD for a virtual machine or burn it onto
optical media which should then become bootable.

> Erasing CD-RW and DVD-RW

Used CD-RW media need to be erased before you can write over the
previously recorded data. This is done by

    $ wodim -v dev=/dev/sr0 blank=fast

Unformatted DVD-RW media need the same treatment before re-use. But fast
blanking deprives them of the capability for multi-session and recording
of streams of unpredicted length. So one should apply

    $ dvd+rw-format -blank=full /dev/sr0

dvd+rw-format is part of package dvd+rw-tools. Alternative commands are

    $ cdrecord -v dev=/dev/sr0 blank=all
    $ cdrskin -v dev=/dev/sr0 blank=all
    $ xorriso -outdev /dev/sr0 -blank as_needed

Formatted DVD-RW media can be overwritten without such erasure. So
consider to apply once in their life time

    $ dvd+rw-format -force /dev/sr0

Alternative commands are

    $ cdrskin -v dev=/dev/sr0 blank=format_overwrite
    $ xorriso -outdev /dev/sr0 -format as_needed

All other media are either write-once (CD-R, DVD-R, DVD+R, BD-R) or are
overwritable without the need for erasing (DVD-RAM, DVD+RW, BD-RE).

> Burning an ISO image to CD, DVD, or BD

To burn a readily prepared ISO image file isoimage.iso onto an optical
medium, run for CD:

    $ wodim -v -sao dev=/dev/sr0 isoimage.iso

and for DVD or BD:

    $ growisofs -dvd-compat -Z /dev/sr0=isoimage.iso

The programs cdrecord, cdrskin, and xorrecord may be used on all kinds
of media with the options shown with wodim.

> Note:

-   Make sure that the medium is not mounted when you begin to write to
    it. Mounting may happen automatically if the medium contains a
    readable file system. In best case it will prevent the burn programs
    from using the burner device. In worst case there will be misburns
    because read operations disturbed the drive.

So if in doubt, do:

    # umount /dev/sr0

-   growisofs has a small bug with blank BD-R media. It issues an error
    message after the burning is complete. Programs like k3b then
    believe the whole burn run failed.

To prevent this, either

-   -   format the blank BD-R by dvd+rw-format /dev/sr0 before
        submitting it to growisofs
    -   or use growisofs option -use-the-force-luke=spare:none

> Verifying the burnt ISO image

You can verify the integrity of the burnt medium to make sure it
contains no errors. Always eject the medium and reinsert it before
verifying. The kernel will learn about the new content only by that
reinsertion.

First calculate the MD5 checksum of the original ISO image:

    $ md5sum isoimage.iso

     e5643e18e05f5646046bb2e4236986d8 isoimage.iso

Next calculate the MD5 checksum of the ISO file system on the medium.
Although some media types deliver exactly the same amount of data as
have been submitted to the burn program, many others append trailing
garbage when being read. So you should restrict reading to the size of
the ISO image file.

    $ blocks=$(expr $(du -b isoimage.iso | awk '{print $1}') / 2048)

    $ dd if=/dev/sr0 bs=2048 count=$blocks | md5sum

     43992+0 records in
     43992+0 records out
     90095616 bytes (90 MB) copied, 0.359539 s, 251 MB/s
     e5643e18e05f5646046bb2e4236986d8  -

Both runs should yield the same MD5 checksum (here:
e5643e18e05f5646046bb2e4236986d8). If they do not, you will probably
also get an I/O error message from the dd run. dmesg might then tell
about SCSI errors and block numbers, if you are interested.

> ISO 9660 and Burning On-The-Fly

It is not necessary to store an emerging ISO file system on hard disk
before writing it to optical media. Only very old CD drives at very old
computers could suffer failed burns due to empty drive buffer.

If you omit option -o from genisoimage then it writes the ISO image to
standard output. This can be piped into the standard input of burn
programs.

    $ genisoimage -V "ARCHIVE_2013_07_27" -J -r ./for_iso | \
      wodim -v dev=/dev/sr0 -waiti -

Option -waiti is not really needed here. It prevents wodim from writing
to the medium before genisoimage starts its output. This would allow
genisoimage to read the medium without disturbing an already started
burn run. See next section about multi-session.

On DVD and BD, you may letgrowisofs operate genisoimage for you and burn
its output on-the-fly

    $ export MKISOFS="genisoimage"
    $ growisofs -Z /dev/sr0 -V "ARCHIVE_2013_07_27" -r -J ./for_iso

> Multi-session

ISO 9660 multi-session means that a medium with readable file system is
still writable at its first unused block address, and that a new ISO
directory tree gets written to this unused part. The new tree is
accompanied by the content blocks of newly added or overwritten data
files. The blocks of data files, which shall stay as in the old ISO
tree, will not be written again.

Linux and many other operating systems will mount the directory tree in
the last session on the medium. This youngest tree will normally show
the files of the older sessions, too.

Multi-session by wodim

CD-R and CD-RW stay writable (aka "appendable") if wodim option -multi
was used

    $ wodim -v -multi dev=/dev/sr0 isoimage.iso

Then the medium can be inquired for the parameters of the next session

    $ m=$(wodim dev=/dev/sr0 -msinfo)

By help of these parameters and of the readable medium in the drive you
can produce the add-on ISO session

    $ genisoimage -M /dev/sr0 -C "$m" \
       -V "ARCHIVE_2013_07_28" -J -r -o session2.iso ./more_for_iso

Finally append the session to the medium and keep it appendable again

    $ wodim -v -multi dev=/dev/sr0 session2.iso

Programs cdrskin and xorrecord do this too with DVD-R, DVD+R, BD-R and
unformatted DVD-RW. Program cdrecord does multi-session with at least
DVD-R and DVD-RW. They all do with CD-R and CD-RW, of course.

Most re-usable media types do not record a session history that would be
recognizable for a mounting kernel. But with ISO 9660 it is possible to
achieve the multi-session effect even on those media.

growisofs and xorriso can do this and hide most of the complexity.

Multi-session by growisofs

growisofs forwards most of its program arguments to a program that is
compatible to mkisofs. See above examples of genisoimage. It bans option
-o and deprecates option -C. By default it uses the installed program
named "mkisofs". You may let it choose one of the others by setting
environment variable MKISOFS

    $ export MKISOFS="genisoimage"
    $ export MKISOFS="xorrisofs"

The wish to begin with a new ISO file system on the optical medium is
expressed by option -Z

    $ growisofs -Z /dev/sr0 -V "ARCHIVE_2013_07_27" -r -J ./for_iso

The wish to append more files as new session to an existing ISO file
system is expressed by option -M

    $ growisofs -M /dev/sr0 -V "ARCHIVE_2013_07_28" -r -J ./more_for_iso

For details see the growisofs manual and the manuals of genisoimage,
mkisofs, xorrisofs.

Multi-session by xorriso

xorriso learns the wish to begin with a new ISO file system from the
blank state of the medium. So it is appropriate to blank it if it
contains data. The command -blank as_needed applies to all kinds of
re-usable media and even to ISO images in data files on hard disk. It
does not cause error if applied to a blank write-once medium.

    $ xorriso -outdev /dev/sr0 -blank as_needed \
              -volid "ARCHIVE_2013_07_27" -joliet on -add ./for_iso --

On non-blank writable media xorriso appends the newly given disk files
if command -dev is used rather than -outdev. Of course, no command
-blank should be given here

    $ xorriso -dev /dev/sr0 \
              -volid "ARCHIVE_2013_07_28" -joliet on -add ./more_for_iso --

For details see the manual page and especially its examples

> BD Defect Management

BD-RE and formatted BD-R media are normally written with enabled Defect
Management. This feature reads the written blocks while they are still
stored in the drive buffer. In case of poor read quality the blocks get
written again or redirected to the Spare Area where the data get stored
in replacement blocks.

This checkreading reduces write speed to at most half of the nominal
speed of drive and BD medium. Sometimes it is even worse. Heavy use of
the Spare Area causes long delays during read operations. So Defect
Management is not always desirable.

cdrecord does not format BD-R. It has no means to prevent Defect
Management on BD-RE media, though.

growisofs formats BD-R by default. This can be prevented by option
-use-the-force-luke=spare:none. It has no means to prevent Defect
Management on BD-RE media, though.

cdrskin, xorriso, and xorrecord do not format BD-R by default. They do
with cdrskin blank=format_if_needed, resp. xorriso -format as_needed,
resp. xorrecord blank=format_overwrite. These three programs can disable
Defect Management with BD-RE and already formatted BD-R by
cdrskin stream_recording=on, resp. xorriso -stream_recording on, resp.
xorrecord stream_recording=on.

> Burning an audio CD

Create your audio tracks and store them as uncompressed, 16-bit stereo
WAV files. To convert MP3 to WAV, ensure lame is installed, cd to the
directoy with your MP3 files, and run:

    $ for i in *.mp3; do lame --decode "$i" "$(basename "$i" .mp3)".wav; done

In case you get an error when trying to burn WAV files converted with
lame try decoding with mpg123:

    $ for i in *.mp3; do mpg123 --rate 44100 --stereo --buffer 3072 --resync -w $(basename $i .mp3).wav $i; done

Name the audio files in a manner that will cause them to be listed in
the desired track order when listed alphabetically, such as 01.wav,
02.wav, 03.wav, etc. Use the following command to simulate burning the
wav files as an audio CD:

    $ wodim -dummy -v -pad speed=1 dev=/dev/sr0 -dao -swab *.wav

In case you detect errors or empty tracks like:

    Track 01: audio    0 MB (00:00.00) no preemp pad

try another decoder (e.g. mpg123) or try using cdrecord from the
cdrtools package.

Note that cdrkit also contains a cdrecord command but it is just a
softlink to wodim. If anything worked you can remove the dummy flag to
really burn the CD

To test the new audio CD, use MPlayer:

    $ mplayer cdda://

> Burning a bin/cue

To burn a bin/cue image run:

    $ cdrdao write --device /dev/sr0 image.cue

TOC/CUE/BIN for mixed-mode disks

ISO images only store a single data track. If you want to create an
image of a mixed-mode disk (data track with multiple audio tracks) then
you need to make a TOC/BIN pair:

    $ cdrdao read-cd --read-raw --datafile IMAGE.bin --driver generic-mmc:0x20000 --device /dev/cdrom IMAGE.toc

Some software only likes CUE/BIN pair, you can make a CUE sheet with
toc2cue (part of cdrdao):

    $ toc2cue IMAGE.toc IMAGE.cue

> Burn backend problems

If you experience problems, you may ask for advise at mailing list
cdwrite@other.debian.org . Or ask for advise at the support mail
addresses if some are listed near the end of the program's man page.

Tell the command lines you tried, the medium type (e.g. CD-R, DVD+RW,
...), and the symptoms of failure (program messages, disappointed user
expectation, ...). You will possibly get asked to obtain the newest
release or development version of the affected program and to make test
runs. But the answer might as well be, that your drive dislikes the
particular medium.

> Burning CD/DVD/BD with a GUI

See the Wikipedia article on this subject for more information:
Comparison of disc authoring software

There are several applications available to burn CDs in a graphical
environment.

Free GUI Programs

-   AcetoneISO — All-in-one ISO tool (supports BIN, MDF, NRG, IMG, DAA,
    DMG, CDI, B5I, BWI, PDI and ISO).

http://sourceforge.net/projects/acetoneiso || acetoneiso2

-   BashBurn — Lightweight terminal based menu frontend for CD/DVD
    burning tools.

http://bashburn.dose.se/ || bashburn

-   Brasero — Disc burning application for the GNOME desktop that is
    designed to be as simple as possible. Part of gnome-extra.

https://wiki.gnome.org/Apps/Brasero || brasero

-   cdw — Ncurses frontend to cdrecord, mkisofs, growisofs,
    dvd+rw-mediainfo, dvd+rw-format, xorriso.

http://cdw.sourceforge.net/ || cdw

-   GnomeBaker — Full featured CD/DVD burning application for the GNOME
    desktop.

http://gnomebaker.sourceforge.net/ || gnomebaker

-   Graveman — GTK-based CD/DVD burning application. It requires
    configuration to point to correct devices.

http://graveman.tuxfamily.org/ || graveman

-   isomaster — ISO image editor.

http://littlesvr.ca/isomaster || isomaster

-   K3b — Feature-rich and easy to handle CD burning application based
    on KDElibs.

http://www.k3b.org/ || k3b

-   Silicon empire — Qt-based set of tools to manage and organize your
    optical discs like CDs, DVDs and Blu-rays.

http://getsilicon.org/ || silicon-empire

-   X-CD-Roast — Lightweight cdrtools front-end for CD and DVD writing.

http://www.xcdroast.org/ || xcdroast

-   Xfburn — Simple front-end to the libburnia libraries with support
    for CD/DVD(-RW), ISO images, and BurnFree.

http://goodies.xfce.org/projects/applications/xfburn || xfburn

-   xorriso-tcltk — Graphical front-end to ISO and CD/DVD/BD burn tool
    xorriso

https://www.gnu.org/software/xorriso/xorriso-tcltk-screen.gif ||
libisoburn

Nero Linux

Nero Linux is a commercial burning suite from makers of Nero for Windows
- Nero AG. The biggest advantage of Nero Linux is its interface which
similar to window version. Hence, users migrating from windows might
find it easy to operate. The Linux version now includes Nero Express, a
wizard which takes users through the process of burning CDs and DVDs
step-by-step, which users will be familiar with from the Windows
version. Also new in version 4 is Blu-ray Disc defect management,
integration of Isolinux for creating bootable media and support for
Musepack and AIFF audio formats...

Nero Linux 4 retails at $19.99 with a free trial version also available.

-   Nero Linux 4
-   nerolinux AUR package.

Nero Linux offers some features, like:

-   Easy, wizard-style user interface for guided burning with Nero Linux
    Express 4.
-   Full Blu-ray burning support.
-   Supports burning of audio CD (CD-DA), ISO 9660 (Joliet support),
    CD-text, ISOLINUX bootable, Multi-session discs, DVD-Video and
    miniDVD, DVD double layer support.
-   Advanced burning with Nero Burning ROM and command line client.

Note:The necessary sg module should be loaded automatically, otherwise
see Kernel modules#Configuration for information about manual
configuration.

DVD playing
-----------

DVD, also known as Digital Versatile Disc or Digital Video Disc, is an
optical disc storage media format used for video and data storage.

If you wish to play encrypted DVDs, you must install the libdvd*
packages:

-   libdvdread
-   libdvdcss
-   libdvdnav

Additionally, you must install player software. Popular DVD players are
MPlayer, xine and VLC. See the video players list and the specific
instructions for MPlayer.

DVD ripping
-----------

Ripping is the process of copying audio or video content to a hard disk,
typically from removable media or media streams.

Often, the process of ripping a DVD can be broken down into two
subtasks:

1.  Data extraction - Copying the audio and/or video data to a hard
    disk,
2.  Transcoding - Converting the extracted data into a suitable format.

Some utilities perform both tasks, whilst others focus on one aspect or
the other:

-   dvd-vr — Tool which easily converts VRO files extracted from a
    DVD-VR and splits them in regular VOB files.

http://www.pixelbeat.org/programs/dvd-vr/ || dvd-vr

-   dvdbackup — Tool for pure data extraction which does not transcode.
    It is useful for creating exact copies of encrypted DVDs in
    conjunction with libdvdcss or for decrypting video for other
    utilities unable to read encrypted DVDs.

http://dvdbackup.sourceforge.net/ || dvdbackup

-   FFmpeg — Complete and free Internet live audio and video
    broadcasting solution for Linux/Unix, capable to do a direct rip in
    any format (audio/video) from a DVD-Video ISO image, just select the
    input as the ISO image and proceed with the desired options. It also
    allows to downmixing, shrinking, spliting, selecting streams among
    other features.

http://ffmpeg.org/ || See article

-   HandBrake — Multithreaded video transcoder, which offers both a
    graphical and command-line interface with many preset
    configurations.

http://handbrake.fr/ || handbrake

-   Hybrid — Multi platform Qt based frontend for a bunch of other tools
    which can convert nearly every input to x264/Xvid/VP8 +
    ac3/ogg/mp3/aac/flac inside an mp4/m2ts/mkv/webm/mov/avi container,
    a Blu-ray or an AVCHD structure.

http://www.selur.de/ || hybrid-encoder

-   MEncoder — Free command line video decoding, encoding and filtering
    tool released under the GNU General Public License. It is a close
    sibling to MPlayer and can convert all the formats that MPlayer
    understands into a variety of compressed and uncompressed formats
    using different codecs. Wrapper programs like h264enc and undvd can
    provide an assistive interface. Many front-ends are available.

http://www.mplayerhq.hu/ || mencoder

-   Transcode — Video/DVD ripper and encoder for the terminal/console.

http://tcforge.berlios.de/ || transcode

> dvd::rip

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

The dvd::rip preferences are mostly well-documented/self-explanatory. If
you need help with something, see
http://www.exit1.org/dvdrip/doc/gui-gui_pref.cipp.

Ripping a DVD is often a simple matter of selecting the preferred
codec(s), selecting the desired titles, then clicking the "Rip" button.

Troubleshooting
---------------

> K3b locale error

When running K3B, if the following message appears:

    System locale charset is ANSI_X3.4-1968
    Your system's locale charset (i.e. the charset used to encode file names) is 
    set to ANSI_X3.4-1968. It is highly unlikely that this has been done intentionally.
    Most likely the locale is not set at all. An invalid setting will result in
    problems when creating data projects.Solution: To properly set the locale 
    charset make sure the LC_* environment variables are set. Normally the distribution 
    setup tools take care of this.

It means that your locale is not set well.

To fix it,

-   Remove /etc/locale.gen
-   Re-install glibc
-   Edit /etc/locale.gen, uncommenting all lines lines that corresponds
    to your language AND the en_US options, for compatibility:

    en_US.UTF-8 UTF-8
    en_US ISO-8859-1

-   Re-generate the profiles with locale-gen:

    # locale-gen

    Generating locales...
    en_US.UTF-8... done
    en_US.ISO-8859-1... done
    pt_BR.UTF-8... done
    pt_BR.ISO-8859-1... done
    Generation complete.

More info here.

> Brasero fails to find blank discs

Brasero uses gvfs to manage CD/DVD burning devices. Also make sure that
your session is not broken.

> Brasero fails to normalize audio CD

If you try to burn it may stop at the first step called Normalization.

As a workaround you can disable the normalization plugin using the Edit
> Plugins menu

> VLC: Error "... could not open the disc /dev/dvd"

If you get the error, "vlc dvdread could not open the disc "/dev/dvd""
it may be because there is no device node /dev/dvd on your system. Udev
no longer creates /dev/dvd and instead uses /dev/sr0. To fix this, edit
the VLC configuration file (~/.config/vlc/vlcrc):

    # DVD device (string)                                                           
    dvd=/dev/sr0

> DVD drive is noisy

If playing DVD videos causes the system to be very loud, it may be
because the disk is spinning faster than it needs to. To temporarily
change the speed of the drive, as root, run:

    # eject -x 12 /dev/dvd

Sometimes:

    # hdparm -E12 /dev/dvd

Any speed that is supported by the drive can be used, or 0 for the
maximum speed.

Setting CD-ROM and DVD-ROM drive speed

> Playback does not work with new computer (new DVD-Drive)

If playback does not work and you have a new computer (new DVD-Drive)
the reason might be that the region code is not set. You can read and
set the region code with regionset from the AUR.

> None of the above programs are able to rip/encode a DVD to my hard disk!

Make sure the region of your DVD reader is set correctly; otherwise, you
will get loads of inexplicable CSS-related errors. Use regionset to do
so.

> GUI program log indicates problems with backend program

If you use a GUI program and experience problems which the program's log
blames on some backend program, then try to reproduce the problem by the
logged backend program arguments. Whether you succeed with reproducing
or not, you may report the logged lines and your own findings to the
places mentioned in section Burn Backend Problems.

Special case: medium error / write error

Here are some typical messages about the drive disliking the medium.
This can only be solved by using a different drive or a different
medium. A different program will hardly help.

K3b with backend wodim:

    Sense Bytes: 70 00 03 00 00 00 00 12 00 00 00 00 0C 00 00 00
    Sense Key: 0x3 Medium Error, Segment 0
    Sense Code: 0x0C Qual 0x00 (write error) Fru 0x0

Brasero with backend growisofs:

    BraseroGrowisofs stderr: :-[ WRITE@LBA=0h failed with SK=3h/ASC=0Ch/ACQ=00h]: Input/output error

Brasero with backend libburn:

    BraseroLibburn Libburn reported an error SCSI error on write(16976,16): [3 0C 00] Write error

See also
--------

-   RIAA and actual laws allow backup of physically obtained media under
    these conditions RIAA - the law.
-   Convert any Movie to DVD Video
-   Main page of the project Libburnia

Retrieved from
"https://wiki.archlinux.org/index.php?title=Optical_Disc_Drive&oldid=299374"

Categories:

-   Optical
-   Audio/Video

-   This page was last modified on 21 February 2014, at 12:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
