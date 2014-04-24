Streaming With Icecast
======================

Icecast is a program for streaming audio such as music across a network.
Different types of clients connect to the IceCast server, either to
provide a "mount point", control the server, or listen to the audio
being cast.

Icecast has support for streaming many audio streams simultaneously -
each stream has a "mount point" which a client can access, usually
through a network uri, such as:

    http://server:8000/mpd.ogg.m3u

This refers to a mount point called "mpd".

Contents
--------

-   1 Setting up Icecast
-   2 Icecast paths
    -   2.1 Global
    -   2.2 Local user
-   3 Running icecast
-   4 Streaming with MPD
    -   4.1 Step 1: Set Up MPD and Install a Client
    -   4.2 Step 2: Ensure Icecast is running
    -   4.3 Step 3: Configure MPD to be an Icecast Source
    -   4.4 Step 4: Running MPD with Icecast
    -   4.5 Step 5: Test / use the stream
    -   4.6 mpd
    -   4.7 Sonata
    -   4.8 MPlayer
-   5 Streaming with oggfwd and ffmpeg2theora
-   6 Playing the stream
-   7 References

Setting up Icecast
------------------

-   Install IceCast via Pacman

     # pacman -S icecast

-   Edit the configuration file.

Open up /etc/icecast.xml in your text editor. The main section you want
to pay attention to is <authentication>. Inside the <authentication>
block there are all the passwords that icecast use. IT'S STRONGLY
RECOMMEND you change them. Icecast defaults to listening on port 8000,
and you may also change that if you wish.

Since icecast 2.3.2-4 the daemon is started as nobody user. If you edit
IceCast configuration to start the daemon with a different user, then
you need to edit the getPID function into the init script:
getPID() { pgrep -u <USER_NAME> icecast 2>/dev/null }

Icecast paths
-------------

> Global

If you plan on running icecast globally (one per machine) change the
paths section to the following:

     <paths>
         <basedir>/usr/share/icecast</basedir>
         <logdir>/log</logdir>
         <webroot>/web</webroot>
         <adminroot>/admin</adminroot>
     </paths>

> Local user

Note that if you're running icecast under a local user (i.e. one that
doesn't use /etc/icecast.xml) then you'll need to copy the icecast web
xml files from /usr/share otherwise you'll get errors about XSLT and the
web interface won't work.

    $ cp -R /usr/share/icecast/web ~/icecast/

Running icecast
---------------

-   Start icecast

You can start icecast as a single user by executing:

    # icecast -b -c /etc/icecast.xml

If you want icecast to remain in the foreground of your terminal, remove
the -b flag.

To run icecast as a system daemon:

    # systemctl start icecast

-   Test it.

Make sure Icecast is running by opening up http://localhost:8000/ in
your web browser. You should be greeted by an Icecast2 Status page. This
indicates everything is running properly.

Or run

    # systemctl status icecast

Streaming with MPD
------------------

MPD is a program for playing music via a daemon process instead of using
a client. It also incorporates a music database for quick access,
playlists, and a variety of front-end options.

Note:MPD has its own built-in HTTP Streaming, and using Icecast+mpd may
not be needed. See Music Player Daemon : HTTP Streaming for more
information.

> Step 1: Set Up MPD and Install a Client

Use the MPD Install Guide to install and configure MPD and a client.

> Step 2: Ensure Icecast is running

    # /etc/rc.d/icecast start

> Step 3: Configure MPD to be an Icecast Source

Edit /etc/mpd.conf and enable the Icecast audio_output by adding the
following:

    audio_output {
        type        "shout"
        encoding    "ogg"
        name        "my cool stream"
        host        "localhost"
        port        "8000"
        mount       "/mpd.ogg"

    # This is the source password in icecast.xml
        password    "hackme"

    # Set either quality or bit rate
    #   quality     "5.0"
        bitrate     "64"

        format      "44100:16:1"

    # Optional Parameters
        user        "source"
    #   description "here's my long description"
    #   genre       "jazz"
    } # end of audio_output

    # Need this so that mpd still works if icecast is not running
    audio_output {
        type "alsa"
        name "fake out"
        driver "null"
    }

> Step 4: Running MPD with Icecast

You can run both MPD and Icecast with the rc.d scripts:

    # /etc/rc.d/icecast start
    # /etc/rc.d/mpd start

Note that icecast must be started first for the stream to work.

> Step 5: Test / use the stream

Now that you have installed the necessary software you probably want to
test/use the stream. Realize that you'll need your client to do two
things:

1.  Connect to the mpd server so you can control it
2.  Connect to the stream to actually hear the music. Connecting to the
    mpd server will alter output to the Icecast server but you won't
    hear it.

Sonata (a graphical mpd client) and mplayer (a command line client) are
just two of the available clients. Note that if you use mplayer, you'll
need another way to control the remote mpd server (for example ssh)

> mpd

You can play an icecast stream from another mpd instance, on another
computer, for example.

Use mpc to add the url to mpd's playlist

    $ mpc add http://ip.of.server:8000/mpd.ogg.m3u

You can then play the stream as if it was a song belonging to your local
mpd instance.

> Sonata

-   Install Sonata:

    # pacman -S sonata

-   Start it up and you should be greeted by Sonata's preferences.
-   Set 'Name' to the name of your server.
-   Set 'Host' to the IP address of your server.
-   Set 'Port' to '6600'.
-   Click the '+' and repeat the previous steps but instead about your
    local computer (ie. it's name and IP).
-   Right-click->'Connections' and select your server. Then click on the
    'Library' tab, if all is well, you should see your entire music
    selection that's on your server. Find a folder, right-click and
    click 'Add'. Clicking on the 'Current' tab will show you your
    current playlist, which should have the contents of whatever folder
    you just chose from the library. Double-click on a song. You should
    see the text get bold and the progress bar show up, just like it's
    playing, but you won't hear anything. Fear not.
-   Right-click->'Connections' and select your local computer. Then
    click the 'Streams' tab. Right-click and click 'New'. Make 'Stream
    Name' the name from your servers /etc/mpd.conf file's audio_output {
    } section and make the URL IP.of.server:8000/mpd.ogg.m3u.
    Double-click on this stream.
-   Click on the 'Current' tab and you'll see the URL of the stream as
    your only item. Double-click on it and after a delay you should hear
    whatever song you had chosen on the server.

> MPlayer

-   Install mplayer

    # pacman -S mplayer

-   Start it, telling it to play the playlist that icecast places in the
    icecast root directory (the playlist redirects mplayer to mpd.ogg)

    $ mplayer -playlist http://ip.of.server:8000/mpd.ogg.m3u

To control the remote mpd server, if you have an ssh server on the same
machine, you can login and use [nc]mpc[pp] to control it.

Or, if your mpd server is listening on an accessible interface/port
($ ss -p -l -t on the mpd machine will show mpd listening on 0.0.0.0,
for example) then you can set the MPD_HOST variable which directs a
local client like mpc to the remote server.

    $ export MPD_HOST=ip.of.server
    $ export MPD_PORT=6600      # optional
    $ mpc play

Streaming with oggfwd and ffmpeg2theora
---------------------------------------

If you want to stream a single track, for example, you can use this
method instead of changing your mpd setup.

-   Install ffmpeg2theora from community and oggfwd from the AUR.

    # pacman -S ffmpeg2theora

-   Start icecast using a previously setup config file

    $ icecast -c path/to/config.xml

or

    # /etc/rc.d/icecast start

-   Start ffmpeg2theora, sending its output to oggfwd, which forwards to
    the icecast server for you.

    $ ffmpeg2theora --no-skeleton --novideo -o - path/to/audio/file | \
      oggfwd localhost 8000 source_password_here /mountpoint_name_here.ogg

Alternatively, you can use this script:

    #!/bin/sh

    if [ $# -eq 1 ] 
    then
      music="$1"
    else
      echo "Usage: $0 music-file"
      exit 1
    fi

    pass="source_password"
    mountpt="mount_point_name"

    set -e
    ffmpeg2theora --no-skeleton --novideo -o - "$music" 2> /dev/null | \ 
      oggfwd localhost 8000 "$pass" /"$mountpt".ogg

Playing the stream
------------------

The above mentioned sonata and mplayer methods can be used.

References
----------

-   MPD Wiki: Configuration
-   [1] - oggfwd and ffmpeg2theora howto.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Streaming_With_Icecast&oldid=291358"

Category:

-   Streaming

-   This page was last modified on 2 January 2014, at 12:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
