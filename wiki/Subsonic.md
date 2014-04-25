Subsonic
========

Subsonic is a music server that lets you store your music on one machine
and play it from other machines, cell phones, via a web interface, or
various other applications. It can be installed using the subsonic
package on AUR.

Contents
--------

-   1 Configuration
    -   1.1 Configure permissions
    -   1.2 Install transcoders
    -   1.3 HTTPS Setup
-   2 Troubleshooting
    -   2.1 UTF-8 file names not added to the database
    -   2.2 FLAC playback
-   3 Madsonic
-   4 External links

Configuration
-------------

After performing any configuration, remember to restart the daemon.

    # systemctl restart subsonic

For details on using systemctl, see Systemd#Using_units.

> Configure permissions

By default, Subsonic runs as root. The following instructions make
Subsonic run as user "subsonic".

Stop the daemon if it's running. Add a system user named "subsonic".
Optionally, add this user to the "audio" group to enable the jukebox
feature.

    # systemctl stop subsonic
    # useradd --system subsonic
    # gpasswd --add subsonic audio

Create several folders and customize their permissions.

    # cd /var/subsonic
    # chown -R subsonic:subsonic .
    # test -d transcode || mkdir transcode
    # chown -R root:root transcode

Change this line in /var/subsonic/subsonic.sh:

    ${JAVA} -Xmx${SUBSONIC_MAX_MEMORY}m \

to this:

    sudo -u subsonic ${JAVA} -Xmx${SUBSONIC_MAX_MEMORY}m \

> Install transcoders

By default, Subsonic uses FFmpeg to transcode videos and songs to an
appropriate format and bitrate on-the-fly. After installation, you can
change these defaults so that, for example, Subsonic will transcode FLAC
files using FLAC and LAME instead of FFmpeg. You should therefore
Install the ffmpeg, and you may also want to install flac and lame.

For security reasons, Subsonic will not search the system for any
transcoders. Instead, the user must create symlinks to the transcoders
in the /var/subsonic/transcode folder. Create the transcode folder if it
does not already exist, then make the necessary symlinks.

    # mkdir /var/subsonic/transcode
    $ cd /var/subsonic/transcode
    # ln -s "$(which ffmpeg)"
    # ln -s "$(which flac)"
    # ln -s "$(which lame)"

> HTTPS Setup

To enable HTTPS browsing and streaming, edit /var/subsonic/subsonic.sh
and change this line:

    SUBSONIC_HTTPS_PORT=0

To this:

    SUBSONIC_HTTPS_PORT=8443

Note:port 8443 seems hard-coded somewhere. When attempting to change it
to port 8080 it will automatically redirect the browser to port 8443
after manually accepting the invalid HTTPS certificate. You will still
be able to re-navigate to port 8080 after the warning page and have it
work on that port.

Troubleshooting
---------------

> UTF-8 file names not added to the database

You must have at least one UTF-8 locale installed.

If you start subsonic using /etc/rc.d/subsonic, and your /etc/rc.conf
has DAEMON_LOCALE="no", then the subsonic daemon will be started with
the C locale, and Java will skip any folders with "international
characters" (e.g. ßðþøæå etc.). Either set DAEMON_LOCALE to "yes" (but
this will affect all rc.daemons), or add a line to the beginning of
/var/subsonic/subsonic.sh which sets LANG to an installed UTF-8 locale,
e.g. LANG=nn_NO.utf8.

> FLAC playback

The FFmpeg transcoder doesn't handle FLAC files well, and clients will
often fail to play the resultant streams. (at least, on my machine)
Using FLAC and LAME instead of FFmpeg solves this issue. This workaround
requires that the FLAC and LAME transcoders have been installed, as
explained in #Install Transcoders.

Start Subsonic and go to settings > transcoding. Ensure that the default
FFmpeg transcoder does not get used on files with a "flac" extension,
then add a new entry. You'll end up with something like this:

  Name          Convert from       Convert to   Step 1                               Step 2
  ------------- ------------------ ------------ ------------------------------------ --------------------------
  mp3 default   ... NOT flac ...   mp3          ffmpeg ...                            
  mp3 flac      flac               mp3          flac --silent --decode --stdout %s   lame --silent -h -b %b -

Madsonic
--------

Madsonic is a fork of Subsonic with extra features, does not require a
registration fee (read completely free) and is available in AUR.

Once you start the server, pay close attention to the Transcoding
options, as you will probably have to change the command from
"Audioffmpeg" to "ffmpeg".

External links
--------------

-   Official web site

Retrieved from
"https://wiki.archlinux.org/index.php?title=Subsonic&oldid=306195"

Category:

-   Audio/Video

-   This page was last modified on 21 March 2014, at 04:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
