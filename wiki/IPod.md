iPod
====

Related articles

-   Audiobook

The purpose of this article is to demonstrate the use of an
iPod/idevices under Arch Linux.

Contents
--------

-   1 Changing iPod Mountpoint
-   2 Importing videos and pictures
    -   2.1 HTML5 videos
    -   2.2 Importing pictures and deleting them
-   3 Converting video for iPod
    -   3.1 Gen 5/5.5
    -   3.2 Handbrake
        -   3.2.1 DVD to iPod
        -   3.2.2 Video File to iPod
    -   3.3 More Advanced/Configurable Methods
        -   3.3.1 Avidemux
        -   3.3.2 Mencoder
        -   3.3.3 FFMpeg
-   4 iPhone/iPod Touch
    -   4.1 Introduction
    -   4.2 Making Friends with the Device
        -   4.2.1 The SSHFS Way
        -   4.2.2 The iFuse Way
        -   4.2.3 Generating HashInfo file
    -   4.3 Unobfuscating the Database
    -   4.4 Syncing
    -   4.5 The iFuse Way - iPhone OS 3.x and 4.x
    -   4.6 Rhythmbox
-   5 iPod Classic/Nano3g
-   6 iPod management apps
-   7 See also

Changing iPod Mountpoint
------------------------

Traditional iPods are accessed just like a normal USB storage device
containing a vfat file system (in rare cases hfsplus), and can be
accessed as such. See the USB Storage Devices article for detailed
instructions.

If udisks2 is running, it will mount an attached iPod to
/run/media/$USER/iPod name (the older udisks will use
/media/<iPod name>).

If the volume label of your iPod is long, or contains a mixture of
spaces, and/or lower-case and capital letters, it may present an
inconvenience. You may easily change the volume label for more expedient
access using dosfslabel from the dosfstools package:

-   Get and confirm the current volume label:

    # dosfslabel /dev/sdXY

-   Set the new volume label:

    # dosfslabel /dev/sdXY ArchPod

-   Unmount the device:

    $ udisksctl unmount -b /dev/sdXY

-   Mount it again:

    $ udisksctl mount -b /dev/sdXY

where /dev/sdxx is the current device node of your iPod.

Importing videos and pictures
-----------------------------

Both videos and photos can be found in typically in
<mountpoint>/DCIM/100APPLE.

> HTML5 videos

Typically you want to convert MOV files to a HTML5 video format like OGV
using ffmpeg2theora. Note that the creation date metadata is not in the
converted video, so you need to use a script like:

       find -name "*.MOV" | while read mov
       do
           d=$(gst-discoverer-0.10 -v $mov | awk '/datetime:/{print $2}' | tr -d \")
           base=${mov%.*}
           if test -f $base.ogv
           then
                   touch -d${d} $base.ogv
                   ls -l $base.ogv
           else
                   echo $base.ogv missing
           fi
       done

And use cp -a or rsync -t in order to preserve the file's date & time.

> Importing pictures and deleting them

You can move photos and videos out of <mountpoint>/DCIM/100APPLE,
however you need to trigger a rebuild of the "Camera Roll" database by
deleting the old databases.

       PhotoData$ sudo rm Photos* com.apple.photos.caches_metadata.plist

Converting video for iPod
-------------------------

> Gen 5/5.5

> Handbrake

Handbrake is a nifty tool with presets for a variety of iPod versions.
CLI and GTK versions are available from pacman as handbrake-cli and
handbrake respectively.

If you do decide to take the CLI way, a good guide is available at
http://trac.handbrake.fr/wiki/CLIGuide.

DVD to iPod

Get from: podencoder  
 Depends on: aur/gpac mplayer

Has detailed help, and is fairly self explanatory.

An alternative is to use a method suggested at DVD Ripping then use one
of the programs listed below to convert that to an iPod-friendly format.

Video File to iPod

Get from: http://thomer.com/howtos/mp4ize  
 Depends on: mplayer

This is a Ruby script to convert video files to an mp4 suitable for an
iPod or iPhone.

> More Advanced/Configurable Methods

Avidemux

Install avidemux-gtk or avidemux-qt from the official repositories.

This can convert to mp4 files. If you enforce a hard max of bit rate @
700ish and keep the video size to 720x480 or 320x240 than it works fine
for video file exporting.

Mencoder

Install the mplayer package from the official repositories.

Has extremely comprehensive configuration support, which will be able to
spit out iPod-compatible video files. Check out man mencoder; a lot of
MPlayer opts will also affect encoding.

A basic guide is also available at Mencoder.

An example command to encode iPhone/iPod Touch-compatible video:

    mencoder INPUT -o output.mp4 \
    -vf scale=480:-10,harddup \
    -oac faac -faacopts mpeg=4:object=2:raw:br=128 \
    -of lavf -lavfopts format=mp4 \
    -ovc x264 -x264encopts nocabac:level_idc=30:bframes=0

FFMpeg

Install the ffmpeg package from the official repositories.

Another encoder with comprehensive configuration support. Example
command to encode for 5G iPod:

    ffmpeg -vcodec xvid -b 300 -qmin 3 -qmax 5 -bufsize 4096 \
    -g 300 -acodec aac -ab 96 -i INPUT -s 320x240 \
    -aspect 4:3 output.mp4

or iPod Touch/iPhone compatible video output:

    ffmpeg -f mp4 -vcodec mpeg4 -maxrate 1000 -b 700 -qmin 3 -qmax 5\
    -bufsize 4096 -g 300 -acodec aac -ab 192 -s 480×320 -aspect 4:3 -i INPUT output.mp4

iPhone/iPod Touch
-----------------

> Introduction

By default, neither the iPhone nor the iPod Touch present mass storage
capability over USB, though there exist two solutions for accessing your
files.

The first is to mount your device through the FUSE file system SSHFS.
This requires jailbreaking, which can be done on any major OS using e.g.
Absinthe for recent iOS versions. After jailbreaking, an SSH server will
also need to be installed on the device, which can be done through the
Cydia program, installed on the device during the jailbreak process.

The second is to use a different FUSE file system called iFuse, which
allows you to mount your device through USB, as you normally would. This
method requires no hacking and is in general the better solution, though
be aware that the software is still under heavy development. As of late,
however, it has proven to be rather reliable and stable.

Note:The current releases of libgpod and gtkpod support the iPod Touch
and the iPhone OS 3.1.x up to iOS 4.3.x. It is possible to transfer
pictures and music without limitations.

Refer to this page:[1]

> Making Friends with the Device

The SSHFS Way

After this the easiest way to properly initialise a few things on the
device's side is with the iPod convenience script. This is available in
the AUR as ipod-convenience

Next do modprobe fuse to actually load the fuse module. You may also
want to add it to your MODULES array in /etc/rc.conf to have it loaded
on boot.

A few things may need changing in the script, depending on your setup.
If you do not use sudo, replace:

    sudo lsusb -v -d 05ac: | grep iSerial | awk '{print $3}' | cut -b1-16 | xargs printf "FirewireGuid: 0x%s" >> $MOUNTPOINT/iTunes_Control/Device/SysInfo

with:

    su -c "lsusb -v -d 05ac: | grep iSerial | awk '{print $3}' | cut -b1-16 | xargs printf \"FirewireGuid: 0x%s\" >> $MOUNTPOINT/iTunes_Control/Device/SysInfo"

in the file /usr/share/ipod-convenience/mount-umount. You may also need
to replace:

    PROCESS=`ssh root@$IPADDRESS ps x | grep MobileMusicPlayer | grep -v grep | awk '{print $1}'`

with:

    PROCESS=`ssh root@$IPADDRESS ps ax | grep MobileMusicPlayer | grep -v grep | awk '{print $1}'`

(I'm not sure under what circumstances this is necessary; it was on my
iPod Touch running 2.2.1, and it will not have any adverse affect under
other firmware version)

After that, edit the /etc/default/ipod-convenience file with details of
your device's IP address, and create the mount point, which is
/media/ipod by default (make sure to set the permissions correctly if
you want it accessible by a regular user)

To actually mount the device, run ipod-touch-mount or iphone-mount (they
both do exactly the same thing so it doesn't matter which). This should
prompt for the root password of the device twice, which is 'alpine' by
default in firmware versions 1.1 and up. This will need to be done every
time you want to sync. (This can be done without having to type the
password each time by using SSH keys - see Using SSH Keys for more
information)

The iFuse Way

Note:If using an iPad/iPad2 that has a screen password, one must unlock
the device to gain access through the USB interface.

Note:The current version of ifuse is unable to mount an iPad2 using iOS
v5.0.1. The git version of libimobiledevice in AUR works with an iPod
using iOS v5.1.1

You will need to install usbmuxd, libplist, libimobiledevice, ifuse. You
can pull in all four with:

    # pacman -S ifuse

Now make sure that you have the fuse module loaded by doing
modprobe fuse, assuming that you do not have it in /etc/rc.conf already.

You can now mount your device. Make sure it is unlocked before you plug
it in, or it won't be recognized.

    # ifuse <mountpoint>

The mountpoint field is where you want to have it mounted.

And you're done! You should be able to point your syncing software of
choice to the mount point and be able to transfer files.

To unmount your device:

    # umount <mountpoint>

Generating HashInfo file

If you have not previously synced your device using iTunes specifically,
you will get error messages telling you that the HashInfo file is
missing. This can be fixed by making an iTunes installation on MacOS or
Windows create it (by plugging in the iPod there). Alternatively you can
create this file yourself, instructions can be found on this website.

> Unobfuscating the Database

Since firmware version 2.0, Apple has obfuscated the music database. If
you are using recent firmware, the file
/System/Library/Lockdown/Checkpoint.xml can be modified to enable use of
the older, non-obfuscated database. Replace:

    <key>DBVersion</key>
    <integer>4</integer>

with:

    <key>DBVersion</key>
    <integer>2</integer>

Then reboot your device.

If syncing fails with "ERROR: Unsupported checksum type '0' in cbk file
generation!", you may need to leave this at 4. libgpod seems to expect a
hashed database.

> Syncing

Use your favourite iPod-compatible program. Individual configuration
will vary, but in general, pointing your program to your specified mount
point should yield good results.

After you've synced, run ipod-touch-umount (or iphone-umount, depending
on your taste) to unmount the SSHFS file system and restart the
MobileMusicPlayer process on the device, so that the new music database
is read.

If you used iFuse, simply type:

    # umount <mountpoint>

You will still need to reload the MobileMusicPlayer process. If your
device is not jailbroken, then you are stuck restarting it.

> The iFuse Way - iPhone OS 3.x and 4.x

Warning: this software is considered unstable and should probably not be
used in a productive environment

Make sure you already installed base-devel, which contains several
programs needed to compile your new components. If you did not, just
run:

    # pacman -S base-devel

which will install everything you will need.

You will need to install libplist, libimobiledevice, libgpod, usbmuxd
and ifuse.

Now make sure that you have the fuse module loaded by doing
modprobe fuse, assuming that you do not have it in /etc/rc.conf already.
Check if the group "usbmux" has been created and add your user using

    # gpasswd -a <user> usbmux

To make sure the new rules apply, execute

    $ udevadm control --reload-rules

and plug in your iPod/iPhone.

Run as ROOT:

    # usbmuxd

Now you should the be able to mount your device by running

    $ ifuse ~/ipod

or similar. Make sure the directory used exists and is accessible to
your user.

Mount the device and create the iTunes_Control/Device directory. Then,
get your UUID. It should be in the syslog from usbmuxd, or you can find
it by running

    $ lsusb -v | egrep "iSerial.*[a-f0-9]{40}"

It should be 40 characters long. Then, run

    $ ipod-read-sysinfo-extended <uuid> <mountpoint>. 

This should generate a file named iTunes_Control/Device/SysInfoExtended.

Now, start up your favourite app, it should detect the device via
libgpod. I recommend using gtkpod-git for the time being, as that is
what the libgpod developers seem to be using for debugging purposes.

Note:If gtkpod/gtkpod-git seems to work only from root/sudo while your
user only gets the slash screen, you can delete your ~/.gtkpod folder
and retry. Note that gtkpod will forget your preferences.

> Rhythmbox

Rhythmbox uses the Gnome Virtual File System to detect mobile devices.
If using the iFuse way, gvfs-afc needs to be installed:

    # pacman -S gvfs-afc

iPod Classic/Nano3g
-------------------

You need to set up the iPod to make libgpod able to find its FireWire
ID. For this, you will need to get your FireWire ID manually

1) Mount the iPod as a rw mount point. In the following example, I will
use /mnt/ipod.

2 ) Find the serial number by typing

      sudo lsusb -v | grep -i Serial 

this should print a 16 character long string like 00A1234567891231 (it
will have no colons or hyphens)

3) Once you have that number, create or edit
/mnt/ipod/iPod_Control/Device/SysInfo. Add to that file the line below:

      FirewireGuid: 0xffffffffffffffff

(replace ffffffffffffffff with the 16 digit string you obtained at the
previous step and do not forget the leading 0x before the string)

Your iPod can now be managed with Amarok or gtkpod.

iPod management apps
--------------------

-   Rhythmbox
    -   GTK interface (GNOME)
    -   Is part of the official GNOME projects.
    -   Fast, light interface.
    -   Manage music on your computer and iPod
    -   Download or stream podcasts and video podcasts
    -   Queue up songs and podcasts
    -   Last.fm integration
    -   Live radio stations
    -   Jamendo and Magnatune support
    -   Audio CD burning
    -   Album cover display
    -   Song lyrics display
    -   DAAP sharing

-   Banshee
    -   GTK interface (GNOME)
    -   Uses Mono so it is slower and more resource hogging than
        rhythmbox
    -   Device Sync: Sync your music and videos to your Android, iPod,
        or other device - or import its media
    -   Podcasts: Download or stream podcasts and video podcasts
    -   Play Queue: Queue up songs, videos, and podcasts, or let the
        Auto DJ take over
    -   Shuffle Modes: Shuffle (or Auto DJ) by artist, album, rating, or
        even songs' acoustic similarity
    -   Album Art: Artwork is automatically fetched as you listen
    -   Powerful Search, Smart Playlists: Find exactly what you want,
        fast
    -   Video Support: All the power of Banshee, now for your videos

-   Yamipod
    -   GTK interface (GNOME)
    -   super lightweight application for managing ONLY music on your
        iPod (not on your computer)
    -   easy ratings edit
    -   PC to iPod synchronization
    -   News RSS and podcasts to iPod upload
    -   Last.fm support
    -   playlist support

-   gtkpod
    -   GTK interface (GNOME)
    -   Read your existing iTunesDB (i.e. import the existing contents
        of your iPod including play counts, ratings and on-the-go
        playlists).
    -   Add MP3, WAV, M4A (non-protected AAC), M4B (audio book),
        podcasts, and various video files (single files, directories or
        existing playlists) to the **iPod. You need a third party
        product to download podcasts, like 'bashpodder' or 'gpodder'
    -   View, add and modify Cover Art
    -   Browse the contents of your local hard disk by
        album/artist/genre by adding all your songs to the 'local'
        database. From there the tracks can be **dragged over to the
        iPod/Shuffle easily.
    -   Create and modify playlists, including smart playlists.
    -   You can choose the charset the ID3 tags are encoded in from
        within gtkpod. The default is the charset currently used by your
        locale setting.
    -   Extract tag information (artist, album, title...) from the
        filename if you supply a template.
    -   Detect duplicates when adding songs (optional).
    -   Remove and export tracks from your iPod.
    -   Modify ID3 tags -- changes are also updated in the original file
        (optional).
    -   Refresh ID3 tags from file (if you have changed the tags in the
        original file).
    -   Sync directories.
    -   Normalize the volume of your tracks (uses mp3gain or the
        replay-gain tag)
    -   Write the updated iTunesDB and added songs to your iPod.
    -   Work offline and synchronize your new playlists / songs with the
        iPod at a later time.
    -   Export your
        korganizer/kaddressbook/Thunderbird/evocalendar/evolution/webcalendar...
        data to the iPod (scripts for other programs can be added).

-   Floola
    -   GTK interface (GNOME)

-   Amarok
    -   KDE/qt interface

-   qPod
    -   KDE/qt interface
    -   front-end for GNUpod

-   GNUpod
    -   command-line only

-   jakpod
    -   JakPod is based on Java and allows you to copy music and video
        files to your iPod.
    -   iPod Nano 6th support
    -   jakpod

See also
--------

-   -   More information about iPhone/iPod Touch support
    -   Apple trailers downloader script

Retrieved from
"https://wiki.archlinux.org/index.php?title=IPod&oldid=305953"

Category:

-   Sound

-   This page was last modified on 20 March 2014, at 17:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
