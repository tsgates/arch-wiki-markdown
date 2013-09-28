DVD Playing
===========

Summary

An introduction to playing DVD-Video.

Series

DVD Playing

DVD Ripping

DVD Burning

Related

Codecs

MPlayer

DVD, also known as Digital Versatile Disc or Digital Video Disc, is an
optical disc storage media format used for video and data storage.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Requirements                                                       |
| -   2 DVD players                                                        |
|     -   2.1 MPlayer                                                      |
|     -   2.2 VLC                                                          |
|         -   2.2.1 Default in GNOME                                       |
|         -   2.2.2 Error "... could not open the disc /dev/dvd"           |
|                                                                          |
|     -   2.3 xine                                                         |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 DVD drive is noisy                                           |
|     -   3.2 Playback does not work with new computer (new DVD-Drive)     |
+--------------------------------------------------------------------------+

Requirements
------------

If you wish to play encrypted DVDs, you must install the libdvd*
packages:

-   libdvdread
-   libdvdcss
-   libdvdnav

Additionally, you must install player software. Popular DVD players are
MPlayer, xine and VLC.

Tip:Users may need to belong to the optical group to be able to access
the DVD drive. To add USERNAME to the optical group, run the following:

    # gpasswd -a USERNAME optical

Do not forget to log the user out and back in for the changes to take
effect. You can see your user's current groups with groups command.

DVD players
-----------

See also: List_of_Applications#Video_Players

> MPlayer

MPlayer is efficient and supports a wide variety of media formats (i.e.
almost everything). To play a DVD with MPlayer:

    $ mplayer dvd://N

...where N is the desired chapter number. Start at 1 and work up if
unsure.

Mplayer checks /dev/dvd by default. Tell it to use /dev/sr0 with the
dvd-device option at the command line, or the dvd-device variable in
~/.mplayer/config.

To play a DVD image file:

    $ mplayer -dvd-device movie.iso dvd://N

To enable the DVD menu use (NOTE: you use arrow keys to navigate and the
Enter key to choose):

    $ mplayer dvdnav://

To enable mouse support in DVD menus use:

    $ mplayer -mouse-movements dvdnav://

To find the audio language, start MPlayer with the -v switch to output
audio IDs. An audio track is selected with -aid <audio_id>. Set a
default audio language by editing ~/.mplayer/config and adding the line
alang=en for English.

With MPlayer, the DVD could be set to a low volume. To increase the
maximum volume to 400%, use softvol=yes and softvol-max=400. The startup
volume defaults to 100% of software volume and the global mixer levels
will remain untouched. Using the 9 and 0 keys, volume can be adjusted
between 0 and 400 percent.

     alang=en
     softvol=yes
     softvol-max=400

MPlayer home page

> VLC

vlc is a portable, capable, open source media player written in Qt (VLC
home page).

Default in GNOME

Copy the system desktop file to the local one (local .desktop files
supersede the global ones):

    cp /usr/share/applications/vlc.desktop ~/.local/share/applications/

Define its mime types (known playback file type abilities) by doing:

    sed -i 's|^Mimetype.*$|MimeType=video/dv;video/mpeg;video/x-mpeg;video/msvideo;video/quicktime;video/x-anim;video/x-avi;video/x-ms-asf;video/x-ms-wmv;video/x-msvideo;video/x-nsv;video/x-flc;video/x-fli;application/ogg;application/x-ogg;application/x-matroska;audio/x-mp3;audio/x-mpeg;audio/mpeg;audio/x-wav;audio/x-mpegurl;audio/x-scpls;audio/x-m4a;audio/x-ms-asf;audio/x-ms-asx;audio/x-ms-wax;application/vnd.rn-realmedia;audio/x-real-audio;audio/x-pn-realaudio;application/x-flac;audio/x-flac;application/x-shockwave-flash;misc/ultravox;audio/vnd.rn-realaudio;audio/x-pn-aiff;audio/x-pn-au;audio/x-pn-wav;audio/x-pn-windows-acm;image/vnd.rn-realpix;video/vnd.rn-realvideo;audio/x-pn-realaudio-plugin;application/x-extension-mp4;audio/mp4;video/mp4;video/mp4v-es;x-content/video-vcd;x-content/video-svcd;x-content/video-dvd;x-content/audio-cdda;x-content/audio-player;|' ~/.local/share/applications/vlc.desktop

Then in System Settings > Details >> Default Applications and on the
Video drop-down menu, select Open VLC media player.}}

Error "... could not open the disc /dev/dvd"

If you get the error, "vlc dvdread could not open the disc "/dev/dvd""
it may be because there is no device node /dev/dvd on your system. Udev
no longer creates /dev/dvd and instead uses /dev/sr0. To fix this edit
the VLC configuration file (~/.config/vlc/vlcrc):

    # DVD device (string)                                                           
    dvd=/dev/sr0

> xine

A lightweight media player supporting DVD menus.

xine home page

Troubleshooting
---------------

> DVD drive is noisy

If playing DVD videos causes the system to be very loud, it may be
because the disk is spinning faster than it needs to. To temporarily
change the speed of the drive, as root, run:

    # eject -x 12 /dev/dvd

sometimes:

    # hdparm -E12 /dev/dvd

Any speed that is supported by the drive can be used, or 0 for the
maximum speed.

Setting CD-ROM and DVD-ROM drive speed

> Playback does not work with new computer (new DVD-Drive)

If playback does not work and you have a new computer (new DVD-Drive)
the reason might be that the region code is not set. You can read and
set the region code with regionset from the Arch User Repository.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DVD_Playing&oldid=226210"

Categories:

-   Player
-   Optical
