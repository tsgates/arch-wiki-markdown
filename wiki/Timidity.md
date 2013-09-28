Timidity
========

Timidity++ is a software synthesizer that can play MIDI files without a
hardware synthesizer. It can either render to the sound card in real
time, or it can save the result to a file, such as a PCM .wav file.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Soundfonts                                                   |
|         -   2.1.1 Freepats                                               |
|         -   2.1.2 Fluidr3                                                |
|                                                                          |
|     -   2.2 Daemon                                                       |
|                                                                          |
| -   3 Usage                                                              |
|     -   3.1 Play files                                                   |
|         -   3.1.1 Standalone mode                                        |
|         -   3.1.2 Daemon mode                                            |
|         -   3.1.3 Connect to virtual MIDI device                         |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 timidity++ does not play MIDI files                          |
|     -   4.2 Daemon mode won't start                                      |
|     -   4.3 Daemon mode plays sound out of pace                          |
|                                                                          |
| -   5 Tips and tricks                                                    |
|     -   5.1 Convert files                                                |
|     -   5.2 How to make DOSBox use Timidity++                            |
|                                                                          |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install the timidity++ package from the Official repositories.

You should also install a soundfont to be able to produce sound. Here is
a list of soundfonts:

-   timidity-freepats from the Official repositories.
-   fluidr3 from the AUR

Configuration
-------------

> Soundfonts

Configure your choosed soundfont:

Freepats

The Freepats project provides a set of instrument samples which are
compatible with timidity++.

To use Freepats with timidity, add the following lines to timidity.cfg:

    /etc/timidity++/timidity.cfg

    dir /usr/share/timidity/freepats
    source /etc/timidity++/freepats/freepats.cfg

Fluidr3

There are other soundfonts available. This will show how to install the
fluidr3 soundfont.

Now we have to add its path to the timidity++ configuration file. Just
add this line:

    /etc/timidity++/timidity.cfg

    soundfont /usr/share/soundfonts/fluidr3/FluidR3GM.SF2

> Daemon

Start and configure to autostart the timidity.service. Read Daemons for
more details.

If you are using PulseAudio, that may not work. You may want to add the
following command as an auto start program in your desktop environment.
Or, if you just want to start timidity in daemon mode once, you can use
the following command which will make console output viewable:

    $ timidity -iA

Usage
-----

> Play files

There are two ways to use timidity++. Either as MIDI player or as daemon
adding MIDI support to ALSA.

Standalone mode

You can simply use timidity++ to play MIDI files:

    $ timidity example.midi

Add option -in or -ig for a text-based/gtk+ interface. E.g. as a
Xfce/GNOME user you may want to set MIDI files to open with the custom
command timidity -ig. There are many other options to timidity; see
man timidity or use -h to get help.

The GTK+ interface offers such features as a playlist, track length
estimates, volume control, a file load dialog box, play and pause
buttons, rewind and fast forward buttons, as well as options to change
the pitch of or speed up or slow down the playback of a midi file.

Daemon mode

If you are runing timidity as a #Daemon (ALSA sequencer client), it will
provide MIDI output support for other programs such as rosegarden,
aplaymidi, vkeybd, etc.

This will give you four output software MIDI ports (in addition of
hardware MIDI ports on your system, if any):

    $  aconnect -o

    client 128: 'TiMidity' [type=user]
        0 'TiMidity port 0 '
        1 'TiMidity port 1 '
        2 'TiMidity port 2 '
        3 'TiMidity port 3 '

You can now play MIDI files using aplaymidi:

    $ aplaymidi filename.mid --port 128:0

Another example is vkeybd, a virtual MIDI keyboard for X.

You can install vkeybd from the AUR.

    $ vkeybd --addr 128:0

Option --addr 128:0 connects the input (readable) software MIDI port
provided by vkeybd to the first output (writable) ALSA port provided by
Timidity. Alternatively you can use aconnect(1), community/aconnectgui
or AUR packages patchage, kaconnect. As a result when you play around
with the keys on the vkeybd timidity plays the appropriate notes.

Connect to virtual MIDI device

Once you have the timidity++ daemon running and it is working with
aplaymidi, you can connect it to a virtual MIDI device that will work in
programs such as rosegarden or scala.

Load the snd-virmidi kernel module and (optionally) configure it to be
loaded at boot. Read Kernel modules for more information.

Use aconnect to verify the port numbers:

    $ aconnect -o

     client 14: 'Midi Through' [type=kernel]
         0 'Midi Through Port-0'
     client 20: 'Virtual Raw MIDI 1-0' [type=kernel]
         0 'VirMIDI 1-0     '
     client 21: 'Virtual Raw MIDI 1-1' [type=kernel]
         0 'VirMIDI 1-1     '
     client 22: 'Virtual Raw MIDI 1-2' [type=kernel]
         0 'VirMIDI 1-2     '
     client 23: 'Virtual Raw MIDI 1-3' [type=kernel]
         0 'VirMIDI 1-3     '
     client 128: 'TiMidity' [type=user]
         0 'TiMidity port 0 '
         1 'TiMidity port 1 '
         2 'TiMidity port 2 '
         3 'TiMidity port 3 '

Now create the connection:

    $ aconnect 20:0 128:0

You should now have a working MIDI output device on your system
(/dev/snd/midiC1D0).

Troubleshooting
---------------

> timidity++ does not play MIDI files

It may be that your soundfile is not set up correctly. Just run:

    $ timidity example.midi

If you find a line like this in the terminal output, your soundfile is
not set up properly.

    No instrument mapped to tone bank 0, program XX - \
    this instrument will not be heard

Make sure you've installed some samples and your soundfile is added to
/etc/timidity++/timidity.cfg. See #Soundfonts above for more details.

> Daemon mode won't start

First, make sure you are in the audio group. If not, add yourself to it:

    # gpasswd audio -a yourusername

After group change, you should re-login.

If you are using PulseAudio, instead of enabling the timidity.service,
start timidity++ as an user:

    $ timidity -iA -OO

If you want to run timidity++ in background, do not use timidity++'s
daemonize option, append & instead.

> Daemon mode plays sound out of pace

timidity++'s ALSA output module (default) may cause this issue in ALSA
server mode. Try another output option, for example, libao:

    $ timidity -iA -OO

And test it using aplaymidi. If this does not work, you may want to
configure JACK and set timidity++'s output to jack.

Tips and tricks
---------------

> Convert files

timidity++ can also convert MIDI files into other formats. The following
command saves the resulting sound to a WAV file:

    $ timidity input.mid -Ow -o out.wav

To convert to another formats, you can use FFmpeg. This will convert it
to mp3:

    $ timidity input.mid -Ow -o - | ffmpeg -i - -acodec libmp3lame -ab 256k out.mp3

> How to make DOSBox use Timidity++

Note:The following method is tested in version DOSBox 0.72

First of all, you need to write a config file. Input the following in
DOSBox to create a configuration file:

    config -writeconf dosbox.conf

you can replace dosbox.conf by any name that you want, add a dot in
front of it if you want to hide it.

Make sure you statred Timidity++ as #Daemon as the instructions above,
use the aconnect command.

Edit this configuration file with any editor, go to the section:

    dosbox.conf

    [midi]
    mpu401=intelligent
    device=default
    config=

put the ALSA connection port into the back of config=, in default:

    config=128:0

Restart DOSBox within a terminal so you can see its debug messages, by
no accident you should see a successful initiation on port 128:0.

See also
--------

-   USB Midi Keyboards

Retrieved from
"https://wiki.archlinux.org/index.php?title=Timidity&oldid=247841"

Category:

-   Audio/Video
