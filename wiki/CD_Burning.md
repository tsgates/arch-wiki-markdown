CD Burning
==========

Summary

This document outlines various methods of burning CDs.

Related

DVD Burning

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Command-line CD-burning                                            |
|     -   1.1 Install CD-burning utilities                                 |
|     -   1.2 Modifying the CD-RW                                          |
|     -   1.3 Erasing CD-RW                                                |
|     -   1.4 Burning an ISO image                                         |
|     -   1.5 Verify the burnt ISO image                                   |
|     -   1.6 Burning an audio CD                                          |
|     -   1.7 Burning a bin/cue                                            |
|     -   1.8 Making an ISO image from an existing CD                      |
|         -   1.8.1 TOC/CUE/BIN for mixed-mode disks                       |
|                                                                          |
|     -   1.9 Making an ISO image from existing files on hard disk         |
|     -   1.10 Mounting an ISO image                                       |
|     -   1.11 Converting to an ISO image                                  |
|                                                                          |
| -   2 Burning CDs with a GUI                                             |
|     -   2.1 Nero Linux                                                   |
|         -   2.1.1 Features                                               |
|         -   2.1.2 License:                                               |
|         -   2.1.3 Note:                                                  |
|                                                                          |
|     -   2.2 K3b                                                          |
|     -   2.3 Brasero                                                      |
|     -   2.4 Graveman                                                     |
|     -   2.5 Bashburn                                                     |
|     -   2.6 Xfburn                                                       |
|     -   2.7 Recorder                                                     |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 About Locale                                                 |
|     -   3.2 Brasero fails to find blank discs                            |
+--------------------------------------------------------------------------+

Command-line CD-burning
-----------------------

> Install CD-burning utilities

From http://www.cdrkit.org/:

cdrkit is a suite of programs for recording CDs and DVDs, blanking CD-RW
media, creating ISO-9660 filesystem images, extracting audio CD data,
and more. The programs included in the cdrkit package were originally
derived from several sources, most notably mkisofs by Eric Youngdale and
others, cdda2wav by Heiko Eissfeldt, and cdrecord by Jörg Schilling.
However, cdrkit is not affiliated with any of these authors; it is now
an independent project.

The cdrkit package is available in the official repositories.

If you intend to use cdrdao (for writing cue/bin files to CD), install
that package instead.

Note:If you face any issues with cdrkit, it is recommended to install
cdrtools from the community repository (cdrkit is a fork of cdrtools).
cdrtools is being actively developed and supports CD, DVD and Blu-ray
burning along with complete CDRWIN cue/bin support. cdrtools does not
depend on cdrdao. For more information, see this page from the cdrtools
site.

Note:Make sure that you build a package using makepkg and install with
pacman. Pacman wrappers may resolve to cdrkit instead.

> Modifying the CD-RW

For the remainder of this section the name of your recording device is
assumed to be /dev/cdrw. If that is not the case, modify the commands
accordingly. In order to write to the CD it needs to be unmounted. If it
is not, wodim will give you an error message.

You can try to let wodim locate your burning device with this command:

     $ wodim -checkdrive

> Erasing CD-RW

CD-RW media usually need to be erased before you can write new data on
it. To blank CD-RW medium use this command:

    $ wodim -v dev=/dev/cdrw -blank=fast

As you might have guessed, this blanks your medium really fast, but you
can also use some other options, just replace the word fast with one of
the following:

all
    blank the entire disk
disc
    blank the entire disk
disk
    blank the entire disk
fast
    minimally blank the entire disk (PMA, TOC, pregap)
minimal
    minimally blank the entire disk (PMA, TOC, pregap)
track
    blank a track
unreserve
    unreserve a track
trtail
    blank a track tail
unclose
    unclose last session
session
    blank last session

> Burning an ISO image

To burn an ISO image run:

    $ cdrecord -v dev=/dev/sr0 isoimage.iso

> Verify the burnt ISO image

You can verify the integrity of the burnt CD to make sure it contains no
errors. Always eject the CD and reinsert it before verifying.

First calculate the md5sum of the original ISO image:

    $ md5sum isoimage.iso
    e5643e18e05f5646046bb2e4236986d8 isoimage.iso

If the CD was burnt in DAO (Disc At Once) mode by passing the -dao
option to cdrecord you can calculate the md5sum of the burnt CD as
follows:

    $ md5sum /dev/sr0
    e5643e18e05f5646046bb2e4236986d8 /dev/sr0

If the CD was burnt in TAO (Track At Once) mode it can be verified with
dd and md5sum. You need to know the number of sectors to check. You can
calculate this by dividing the size of the ISO file by 2048, but for
your convenience this is included in the output of cdrecord:

    Track 01: Total bytes read/written: 90095616/90095616 (43992 sectors).

Then check if this matches the md5sum of the burnt image, replacing
"count" with the number of sectors:

    $ dd if=/dev/sr0 bs=2048 count=43992 | md5sum
    43992+0 records in
    43992+0 records out
    90095616 bytes (90 MB) copied, 0.359539 s, 251 MB/s
    e5643e18e05f5646046bb2e4236986d8  -

> Burning an audio CD

1. Create your audio tracks and store them as uncompressed, 16-bit
stereo WAV files.

Tip:To convert MP3 to WAV, ensure lame is installed, cd to the directoy
with your MP3 files, and run:

    $ for i in *.mp3; do lame --decode "$i" "`basename "$i" .mp3`".wav; done

Note: In case you get an error when trying to burn WAV files converted
with lame try decoding with mpg123:

    $ for i in *.mp3; do mpg123 --rate 44100 --stereo --buffer 3072 --resync -w `basename $i .mp3`.wav $i; done

2. Name the audio files in a manner that will cause them to be listed in
the desired track order when listed alphabetically, such as 01.wav,
02.wav, 03.wav, etc.

3. Use the following command to simulate burning the wav files as an
audio CD:

    $ wodim -dummy -v -pad speed=1 dev=/dev/cdrw -dao -swab *.wav

In case you detect errors or empty tracks like

    Track 01: audio    0 MB (00:00.00) no preemp pad

try another decoder (e.g. mpg123) or try using cdrecord from the
cdrtools package. Note that cdrkit also contains a cdrecord command but
it is just a softlink to wodim.

4. If anything worked you can remove the dummy flag to really burn the
CD

To test the new audio CD, use MPlayer:

    $ mplayer cdda://

> Burning a bin/cue

To burn a bin/cue image run:

    $ cdrdao write --device /dev/cdrw image.cue

> Making an ISO image from an existing CD

To copy an existing CD just type:

    $ dd if=/dev/cdrw of=/home/user/isoimage.iso

or even simpler:

    $ cat /dev/cdrw > isoimage.iso

Or use the readcd program, also in the cdrkit package

    $ readcd -v dev=/dev/cdrw -f isoimage.iso

If the original CD was bootable it will be a bootable image.

TOC/CUE/BIN for mixed-mode disks

ISO images only store a single data track. If you want to create an
image of a mixed-mode disk (data track with multiple audio tracks) then
you need to make a TOC/BIN pair:

    $ cdrdao read-cd --read-raw --datafile IMAGE.bin --driver generic-mmc:0x20000 --device /dev/cdrom IMAGE.toc

Some software only likes CUE/BIN pair, you can make a CUE sheet with
toc2cue (part of cdrdao):

    $ toc2cue IMAGE.toc IMAGE.cue

> Making an ISO image from existing files on hard disk

To make an iso image just copy the needed files to one folder, then do:

    $ mkisofs -V volume_name -J -r -o isoimage.iso ~/folder

> Mounting an ISO image

To test if the ISO image is proper, you can mount it (as root):

    # mount -t iso9660 -o ro,loop=/dev/loop0 cd_image /cdrom

You have to first load the loop module:

    # modprobe loop

> Converting to an ISO image

To convert an img/ccd image, you can use ccd2iso:

    # pacman -S ccd2iso
    $ ccd2iso ~/image.img ~/image.iso

Burning CDs with a GUI
----------------------

There are several applications available to burn CDs in a graphical
environment. The use of these programs are self-explanatory.

> Nero Linux

NERO LINUX is a commercial burning suite from makers of Nero for windows
- Nero AG. the biggest advantage of nero linux is its interface which
similar to window version. Hence, users migrating from windows might
find it easy to operate. The Linux version now includes Nero Express, a
wizard which takes users through the process of burning CDs and DVDs
step-by-step, which users will be familiar with from the Windows
version. Also new in version 4 is Blu-ray Disc defect management,
integration of Isolinux for creating bootable media and support for
Musepack and AIFF audio formats...

-   Nero Linux 4
-   nerolinux AUR package

Features

-   Easy, wizard-style user interface for guided burning with Nero Linux
    Express 4
-   Full Blu-ray Burning Support
-   Supports Burning of Audio CD (CD-DA), ISO 9660 (Joliet support),
    CD-Text, ISOLINUX Bootable, Multi-session Discs, DVD-Video and
    miniDVD, DVD double layer support.
-   Advanced burning with Nero Burning ROM and command line client

License:

Nero Linux 4 retails at £17.99 with a free trial version also available.

Note:

For Nero Linux you need

MODULES=( sg )

in rc.conf. Some updates ago the sg module wasn't auto loaded any more
and Nero needs it.

> K3b

According to [1], k3b is "The CD/DVD Kreator for Linux - optimized for
KDE". K3b uses the Qt toolkit.

The k3b package is available in the official repositories.

    # pacman -S k3b

Run k3bsetup to set up your preferences, permissions, etc.; run k3b to
execute the main program.

> Brasero

Brasero is another solution to CD burning if you are using GNOME.

-   Install brasero with pacman.

-   Run brasero to run the main program.

> Graveman

Graveman is a simple and almost dependency-free application for burning
CDs.

-   graveman is available in the AUR.

-   Run graveman as a regular user to create the configuration file in
    ~/.config/graveman/graveman.conf (if you run graveman as root first,
    the permissions for this file will be wrong).
-   Now, in graveman, go to menu File > Preferences... > Devices and add
    your CD burners (If necessary, run graveman as root). Devices may
    already be set up correctly.
-   Note that you may have to manually add your own device in Graveman's
    preferences and point it at /dev/cdrom instead of /dev/hdc
-   If graveman's automatic detection points to 1,0,0 or something like
    that, and you get the "Currently: no media" error you may point it
    to /dev/sr0 or /dev/cdrom as noted above

> Bashburn

Alternatively theres also Bashburn in official repositories as a
semi-GUI solution. BashBurn is the new name for the CD burning shell
script Magma. It is not the best looking CD-burning application out
there, but it does what you want it to do.

-   Install bashburn with pacman.

> Xfburn

Xfburn is a simple CD/DVD burning tool from the Xfce project, and is
based on libburnia libraries. It can blank CD-RWs, burn and create ISO
images, as well as burn personal compositions of data to either CD or
DVD.

It can be found in the official repositories.

-   Install xfburn with pacman.

> Recorder

Warning: there is a critical bug in Recorder where it tries to remove
files in your $HOME: see https://bugs.archlinux.org/task/31673 It is
also no longer supported upstream.

Recorder is a graphical front-end of cdrkit/cdrtools, cdrdao, mkisofs
and growisofs. It aims to be simple and easy to use, free of large
configurations and useless options, following the KISS principle and
offering a disc burning of quality, nothing more.

-   Install recorder from the AUR
-   Discussion thread: Recorder - A simple GTK+ disc burner

Troubleshooting
---------------

About Locale

When running K3B, if the following message appears

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

    # rm /etc/locale.gen

-   Re-install glibc

    # pacman -S glibc

-   Edit /etc/locale.gen, uncommenting all lines lines that corresponds
    to your language AND the en_US options, for compatibility.

    en_US.UTF-8 UTF-8
    en_US ISO-8859-1

-   Re-generate the profiles with locale-gen

    # locale-gen

    Generating locales...
    en_US.UTF-8... done
    en_US.ISO-8859-1... done
    pt_BR.UTF-8... done
    pt_BR.ISO-8859-1... done
    Generation complete.

More info here

Brasero fails to find blank discs

Brasero uses gvfs to manage CD/DVD burning devices.

-   Install gvfs with pacman.

Retrieved from
"https://wiki.archlinux.org/index.php?title=CD_Burning&oldid=252373"

Category:

-   Optical
