Music Player Daemon/Tips and Tricks
===================================

Go back to Music Player Daemon.

Contents
--------

-   1 Organizing
-   2 Last.fm/Libre.fm scrobbling
    -   2.1 mpdas
    -   2.2 mpdcron
    -   2.3 mpdscribble
        -   2.3.1 systemd user service
    -   2.4 Sonata
    -   2.5 lastfmsubmitd
-   3 Never play on start
-   4 Example configuration: Output with 44.1 KHz at e. g. 16 bit depth,
    multiple programs at once
-   5 Control MPD with lirc
-   6 MPD and PulseAudio
    -   6.1 Local (as your own user)
    -   6.2 Local (with separate mpd user)
    -   6.3 Remote
-   7 Cue Files
-   8 HTTP Streaming

Organizing
----------

MPD does not provide a tool to preserve the file structure of your audio
files. Check out beets or picard.

Last.fm/Libre.fm scrobbling
---------------------------

Note:mpd release 0.18 removed Last.fm support. Many clients still
support scrobbling.

To scrobble your songs to Last.fm or Libre.fm when using MPD, there are
several possibilities.

> mpdas

mpdas is an AudioScrobbler client for MPD written in C++. It uses curl
and libmpd. mpdas supports the latest AudioScrobbler protocol (2.0) and
will also cache unscrobbled plays in ~/.mpdascache if there's no network
connectivity.

mpdas is available in the AUR.

Configuration of mpdas is very simple, see the official README. A very
basic example of /etc/mpdasrc is also available as /etc/mpdasrc.

To get your password in md5 hash, just run:

    echo -n 'PASSWORD' | md5sum | cut -f 1 -d " "

To autostart mpdas along with mpd, add an entry for it into the file in
which you start mpd (e.g. xinitrc):

    [[ -z $(pgrep -xU $UID mpdas) ]] && mpdas &

> mpdcron

mpdcron is a cron-like daemon for MPD that listens for events and
executes user defined actions. It can be extended via modules to show
notifications, submit songs to Last.fm or Libre.fm (scrobbling), or to
collect statistics about played songs.

mpdcron-git is available in the AUR.

See the official page for information about configuration and modules.

To autostart mpdcron along with mpd, add an entry for it into the file
in which you start mpd (e.g. xinitrc):

    [[ -z $(pgrep -xU $UID mpdcron) ]] && mpdcron &

> mpdscribble

mpdscribble is a daemon available in the AUR (if you prefer,
mpdscribble-git is also available). This is arguably the best
alternative, because it is the semi-official MPD scrobbler and uses the
new "idle" feature in MPD for more accurate scrobbling. Also, you do not
need root access to configure it, because it does not need any changes
to /etc at all. Visit the official website for more information.

After you have installed mpdscribble, do the following (not as root):

    $ mkdir ~/.mpdscribble

-   Create the file ~/.mpdscribble/mpdscribble.conf and add the
    following:

    ~/.mpdscribble/mpdscribble.conf

    [mpdscribble]
     host = your mpd host # optional, defaults to $MPD_HOST or localhost
     port = your mpd port # optional, defaults to $MPD_PORT or 6600
     log = /home/YOUR_USERNAME/.mpdscribble/mpdscribble.log
     verbose = 2
     sleep = 1
     musicdir = your music directory
     proxy = your proxy # optional, e. g. http://your.proxy:8080, defaults to none

     [last.fm]
     # last.fm section, comment if you do not use last.fm
     url = http://post.audioscrobbler.com/
     username = your last.fm username
     password = your last.fm password
     journal = /home/YOUR_USERNAME/.mpdscribble/lastfm.journal

     [libre.fm]
     # libre.fm section, comment if you do not use libre.fm
     url = http://turtle.libre.fm/
     username = your libre.fm username
     password = your libre.fm password
     journal = /home/YOUR_USERNAME/.mpdscribble/librefm.journal

Please note that passwords can also be written down as MD5:

    echo -n 'PASSWORD' | md5sum | cut -f 1 -d " "

-   Add mpdscribble to the file in which you start mpd as well (e.g.
    ~/.xinitrc):

    pidof mpdscribble >& /dev/null
    if [ $? -ne 0 ]; then
     mpdscribble &
    fi

systemd user service

Use the following service to start mpdscribble under systemd user
instance. See systemd/User for details.

    ~/.config/systemd/user/mpdscribble.service

    [Unit]
    Description=MPD Scribbler

    [Service]
    ExecStart=/usr/bin/mpdscribble -D
    Restart=always

    [Install]
    WantedBy=default.target

> Sonata

Sonata has built-in support for scrobbling, although that requires the
program to run the whole time. Additionally, Sonata does not cache the
songs if they cannot be forwarded to Last.fm at the time of playing,
meaning they will not be added to the statistics.

> lastfmsubmitd

The daemon lastfmsubmitd is a daemon which may be installed from the
official repositories as well. To install it, first edit
/etc/lastfmsubmitd.conf to reflect your requirements and activate both
lastfmsubmitd and lastmp systemd services.

Never play on start
-------------------

This feature is present in mpd after version 0.16.2. When this feature
is enabled, the mpd process will always start in the "paused" state,
even if a song was playing when mpd was stopped. Add the line below to
your mpd.conf file to enable this feature.

    restore_paused "yes"

Example configuration: Output with 44.1 KHz at e. g. 16 bit depth, multiple programs at once
--------------------------------------------------------------------------------------------

Why these formats? Because they are standard CDA, because ALSA on its
own allows more than one program "to sound" only with dmix — whose
resampling algorithm is inferior — and because dmix by default resamples
anything lower to 48 KHz (or whatever higher format is playing at the
time). Also, some get clicking sounds if at least mpd.conf is not
changed this way.

What is the downside? These settings cause everything (if necessary) to
be resampled to this format, such as material from DVD or TV which
usually is at 48 KHz. But there is no known way to have ALSA dynamically
change the format, and particularly if you listen to far more CDs than
anything else the occasional 48 → 44.1 is not too great a loss.

The following assumes that there are not already other settings which
conflict resp. overwrite it. This applies especially to the current
user's potential ~/.asoundrc — which MPD as its own user ignores,
therefore the following should go to /etc/asound.conf:

    /etc/asound.conf

    defaults.pcm.dmix.rate 44100 # Force 44.1 KHz
    defaults.pcm.dmix.format S16_LE # Force 16 bits

    /etc/mpd.conf

    audio_output {
            type                    "alsa" # Use the ALSA output plugin.
    	name			"HDA Intel" # Can be called anything or nothing tmk, but must be present.
            options                 "dev=dmixer"
            device                  "plug:dmix" # Both lines cause MPD to output to dmix.
    	format	        	"44100:16:2" # the actual format
    	auto_resample		"no" # This bypasses ALSA's own algorithms, which generally are inferior. See below how to choose a different one.
    	use_mmap		"yes" # Minor speed improvement, should work with all modern cards.
    }

    samplerate_converter		"0" # MPD's best, most CPU intensive algorithm. See 'man mpd.conf' for others — for anything other than the poorest "internal", libsamplerate must be installed.

Note:MPD gives the mp3 format a special treatment at decoding: it is
always put out as 24 bit. (The conversion as forced by the format line
only comes after that.)

If one wants to leave the bit depth decision to ALSA resp. MPD, comment
out resp. omit the dmix.format line and change the one for mpd with
format to "44100:*:2".

Note:Crossfading between files decoded at two different bit depths (say,
one mp3 and one 16 bit flac) does not work unless conversion is active.

Control MPD with lirc
---------------------

There are already some clients designed for communications between lircd
and MPD, however, as far as the practical use, they are not very useful
since their functions are limited.

It is recommended to use mpc with irexec. mpc is a command line player
which only sends the command to MPD and exits immediately, which is
perfect for irexec, the command runner included in lirc. What irexec
does is that it runs a specified command once received a remote control
button.

First of all, please setup your remotes as referred to the Lirc article.

Edit your favored lirc startup configuration file, default location is
~/.lircrc.

Fill the file with the following pattern:

    begin
         prog = irexec
         button = <button_name>
         config = <command_to_run>
         repeat = <0 or 1>
    end

An useful example:

    ## irexec
    begin
         prog = irexec
         button = play_pause
         config = mpc toggle
         repeat = 0
    end

    begin
         prog = irexec
         button = stop
         config = mpc stop
         repeat = 0
    end
    begin
         prog = irexec
         button = previous
         config = mpc prev
         repeat = 0
    end
    begin
         prog = irexec
         button = next
         config = mpc next
         repeat = 0
    end
    begin
         prog = irexec
         button = volup
         config = mpc volume +2
         repeat = 1
    end
    begin
         prog = irexec
         button = voldown
         config = mpc volume -2
         repeat = 1
    end
    begin
         prog = irexec
         button = pbc
         config = mpc random
         repeat = 0
    end
    begin
         prog = irexec
         button = pdvd
         config = mpc update
         repeat = 0
    end
    begin
         prog = irexec
         button = right
         config = mpc seek +00:00:05
         repeat = 0
    end
    begin
         prog = irexec
         button = left
         config = mpc seek -00:00:05
         repeat = 0
    end
    begin
         prog = irexec
         button = up
         config = mpc seek +1%
         repeat = 0
    end
    begin
         prog = irexec
         button = down
         config = mpc seek -1%
         repeat = 0
    end

There are more functions for mpc, run man mpc for more info.

MPD and PulseAudio
------------------

mpd supports both local and remote use of PulseAudio.

> Local (as your own user)

No special options are required; just add a pulse output as described in
the comments of mpd's config file.

If you want to start mpd with systemd, put the following file into
/etc/systemd/system/mpd-myuser.service:

    .include /usr/lib/systemd/system/mpd.service

    [Unit]
    Description=Music Player Daemon (running as MYUSER)

    [Service]
    User=MYUSER
    PAMName=system-local-login

(replacing MYUSER for your username). Then do
sudo systemctl enable mpd-myuser && sudo systemctl start mpd-myuser.

> Local (with separate mpd user)

When run as its own user as per the wiki instructions, mpd will be
unable to send sound to another user's pulseaudio server. Rather than
setting up pulseaudio as a system-wide daemon, a practice strongly
discouraged by upstream, you can instead configure mpd to use
pulseaudio's tcp module to send sound to localhost:

First, uncomment the tcp module in /etc/pulse/default.pa or
$XDG_CONFIG_HOME/default.pa (typically ~/.config/pulse/default.pa) and
set 127.0.0.1 as an allowed IP address; the home directory takes
precedence:

    ### Network access (may be configured with paprefs, so leave this commented
    ### here if you plan to use paprefs)
    #load-module module-esound-protocol-tcp
    load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
    #load-module module-zeroconf-publish

Additional IP ranges in cidr notation may be added using ; as the
separator. Once this is complete, restart pulseaudio:

    $ pulseaudio --kill
    $ pulseaudio --start -or- start-pulseaudio-x11/kde

Next, edit /etc/mpd.conf and add a new pulse output pointing to
127.0.0.1 as a "remote" server:

    audio_output {
           type		"pulse"
           name		"Local Music Player Daemon"
           server		"127.0.0.1"
    }

Once this is added, restart mpd.

Enable the output in mpd; you should now have a working local mpd,
usable by all users whose pulseaudio servers allow sound from 127.0.0.1.

> Remote

As with any PulseAudio-enabled program, mpd can send sound over the
network. The complete PulseAudio system is not required on the server
running mpd; libpulse is the only requirement to act as a source and is
already a dependency of mpd.

In order to send audio from mpd to another computer follow the
directions above, editing /etc/mpd.conf on the server running mpd using
the IP address of the target computer and /etc/pulse/default.pa or
$XDG_CONFIG_HOME/default.pa (typically ~/.config/pulse/default.pa) on
the target computer using the IP address of the server.

Once this is done, the server's mpd source should show up on the target
computer while playing or paused as a normal source able to be rerouted
and controlled as usual; there will be no visible source on the target
while mpd is stopped.

Cue Files
---------

No additional steps are needed for cue support in mpd since 0.17. MPD
has its own integrated parser which works with both external and
embedded cuesheets. For example, the command mpc load albumx/x.cue loads
the file music_directory/albumx/x.cue as playlist; or in the case of an
CUESHEET tag, mpc load albumx/x.flac.

HTTP Streaming
--------------

Since version 0.15 there is a built-in HTTP streaming daemon/server that
comes with MPD. To activate this server simply set it as output device
in mpd.conf:

    audio_output {    
    	type		"httpd"    
    	name		"My HTTP Stream"
    	encoder		"vorbis"		# optional, vorbis or lame
    	port		"8000"
    #	quality		"5.0"			# do not define if bitrate is defined
    	bitrate		"128"			# do not define if quality is defined
    	format		"44100:16:1"
    }

Then to listen to this stream simply open the URL of your mpd server
(along with the specified port) in your favorite music player. Note: You
may have to specify the file format of the stream using an appropriate
file extension in the URL. For example, using Winamp 5.5, You would use
http://192.168.1.2:8000/mpd.ogg rather than http://192.168.1.2:8000/.

To use mpd to connect to the stream from another computer.

    mpc add http://192.168.1.2:8000

Retrieved from
"https://wiki.archlinux.org/index.php?title=Music_Player_Daemon/Tips_and_Tricks&oldid=294972"

Category:

-   Player

-   This page was last modified on 30 January 2014, at 07:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
