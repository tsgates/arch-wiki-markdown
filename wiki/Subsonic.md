Subsonic
========

Subsonic is a music server that lets you store your music on one machine
and play it from other machines, cell phones, via a web interface, or
various other applications. It can be installed using the subsonic
package on AUR.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Additional config                                                  |
|     -   1.1 Run subsonic daemon NOT as root                              |
|     -   1.2 Install Transcoders                                          |
|     -   1.3 Systemd Setup                                                |
|                                                                          |
| -   2 Troubleshooting                                                    |
|     -   2.1 UTF-8 file names not added to the database                   |
|     -   2.2 FLAC playback                                                |
|                                                                          |
| -   3 External links                                                     |
+--------------------------------------------------------------------------+

Additional config
-----------------

> Run subsonic daemon NOT as root

By default, subsonic runs as root. This can be changed at any time after
installation, even if the daemon has never run.

Stop the daemon, if it's running:

    # rc.d stop subsonic

Add a system user "subsonic" without home folder and add it to "audio"
group if you want to use the jukebox feature:

    # useradd --system --groups audio subsonic

Change folder owners as follow. Path may change, and the ones listed
below are the current (2013-02-05) defaults. If the transcode folder
does not exist, you should #Install Transcoders.

    # chown -R subsonic:subsonic /tmp/subsonic
    # chown -R subsonic:subsonic /var/subsonic
    # chown -R root:root /var/subsonic/transcode
    # chown -R root:root /var/subsonic/jetty/*/webapp

Change this line in /var/subsonic/subsonic.sh:

    ${JAVA} -Xmx${SUBSONIC_MAX_MEMORY}m \

to this:

    sudo -u subsonic ${JAVA} -Xmx${SUBSONIC_MAX_MEMORY}m \

and restart the subsonic daemon.

    # rc.d start subsonic

> Install Transcoders

By default, Subsonic uses FFmpeg to transcode videos and songs to an
appropriate format and bitrate on-the-fly. After installation, you can
change these defaults so that, for example, Subsonic will transcode FLAC
files using FLAC + LAME instead of FFmpeg. At a minimum, you should
Install the ffmpeg package from the official repositories. You may also
want to install flac and lame.

For security reasons, Subsonic will not search the system for any
transcoders. Instead, the user has to create links to the necessary
transcoders in the /var/subsonic/transcode folder. Create the transcode
folder if it does not already exist, then make the necessary symlinks.

    # mkdir /var/subsonic/transcode
    $ cd /var/subsonic/transcode
    # ln -s `which ffmpeg`
    # ln -s `which flac`
    # ln -s `which lame`

Finally, restart subsonic daemon.

    # rc.d start subsonic

> Systemd Setup

The subsonic installation includes a systemd service file. To install
it:

    # cp /var/subsonic/subsonic.service /usr/lib/systemd/system/subsonic.service

Then, run:

    # systemctl --system daemon-reload 

And finally enable it:

    # systemctl enable subsonic.service

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
Using FLAC + LAME instead of FFmpeg solves this issue. This workaround
requires that the FLAC and LAME transcoders have been installed, as
explained in #Install Transcoders.

Start Subsonic and go to settings > transcoding. Ensure that the default
FFmpeg transcoder does not get used on files with a "flac" extension,
then add a new entry. You'll end up with something like this:

  Name          Convert from       Convert to   Step 1                               Step 2
  ------------- ------------------ ------------ ------------------------------------ --------------------------
  mp3 default   ... NOT flac ...   mp3          ffmpeg ...                            
  mp3 flac      flac               mp3          flac --silent --decode --stdout %s   lame --silent -h -b %b -

External links
--------------

-   Official web site

Retrieved from
"https://wiki.archlinux.org/index.php?title=Subsonic&oldid=247137"

Category:

-   Audio/Video
