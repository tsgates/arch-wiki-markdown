MIDI
====

MIDI itself, which stands for "Musical Instrument Digital Interface", is
just a protocol and standard for communication between musical
instruments and any device that understands the language. It can be used
to control an array of synthesizers, make a tin can sound like a drum,
or even operate industrial equipments.

The scope of this article, however, will mainly focus on the usage of
MIDI in computer systems for playback of files that contain MIDI data.
These files usually come with the .mid extension, and were hugely
popular in the golden days of multimedia computing to share music. In
professional music composition/arrangement, it still plays a vital role.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 MIDI File                                                          |
| -   2 GM Bank                                                            |
| -   3 Playback                                                           |
|     -   3.1 Hardware                                                     |
|         -   3.1.1 SB Audigy 1 - Emu10k1 WaveTable                        |
|                                                                          |
|     -   3.2 Software                                                     |
|         -   3.2.1 VLC                                                    |
|         -   3.2.2 Timidity++                                             |
|         -   3.2.3 FluidSynth                                             |
|                                                                          |
| -   4 External Links                                                     |
+--------------------------------------------------------------------------+

MIDI File
---------

Without going into the details of what the format is composed of, you
just need to understand that a MIDI file eg. foobar.mid does not contain
any digital audio data, hence no "PCM stream". It is a common
misconception that MIDI is a sound file format, and as such you usually
see people complaining that music players like Amarok cannot play the
file. Here is a very newbie-friendly outline of what a MIDI/MID file
contains:

    # FOOBAR.MID
    Note ON
      Use Instrument #1
      Play Note C1
      Set Volume at 100
      Set Pitch at 50

In order for such a file to be useful, there needs to be an "engine"
that can translate the data to music. This engine will have a "tone
generator", and this is what we call a "synthesizer". So any player that
can play back a MIDI file without MIDI-capable hardware (your computer's
sound device), has a synthesizer built-in or uses an external one. A
typical keyboard (not the thing you are typing on) is actually made up
of two components - a MIDI "controller" (the keys) and a synthesizer
(tone generator/module; the thing that makes sound).

So up to this point, you should be able to understand that:

-   There needs to be a synthesizer to play a MIDI file.
-   A synthesizer can be hardware or software.
-   Most computer soundcards/chipsets do NOT have synthesizers.
-   You need a synthesizer with a proper "bank" (collection of sounds)
    to be able to enjoy all the glory of MIDI files.
-   If a certain instrument is not in the bank, your synthesizer will
    not play anything for notes using that instrument.
-   If a certain instrument in the file corresponds to a different one
    in the bank, your synthesizer will play a different sound
    (obviously).

GM Bank
-------

General MIDI (GM) is a specification to standardise numerous
MIDI-related matters, particularly that of instruments layout in a
collection of sounds. A "soundbank" which is GM-compatible means that it
meets the criteria of General MIDI, and as long as the MIDI file is also
GM-compatible (as in nothing extraordinary is defined - such as
introducing a new instrument or having one in a different location of
the bank), the playback will be as intended since the bank has the
correct instrument/handler for the MIDI message/event. One of the most
popular soundbank formats is that of SoundFont, particularly SF2.

-   If you have a soundcard which can make use of soundfonts, you can
    load a .sf2 file onto it.

-   If you do not have a soundcard which can make use of soundfonts
    (basically no hardware synthesizer), you can use a software
    synthesizer and load the SF2 file. In turn, you can find some way to
    globally make use of this synthesizer.

Playback
========

"Why can I play MIDI with Windows Media Player, then?"

Well, because Windows has a default software synthesizer which acts
globally. Even then, it lacks the quality which should be expected of
modern computers. If there were a way to do it on Linux, you would be
able to play back MIDI from any player too. Perhaps a MIDI server (which
will hold a synthesizer of choice like TiMidity++ or FluidSynth) that
sits within the sound server, like Phonon or PulseAudio. Nevertheless,
nothing of this sort has been implemented and you can only play MIDI
with a player that has a plug-in to source a synthesizer (for example
XMMS or Audacious - this is unfortunately not the case with
GStreamer-based players yet, see the GStreamer FAQ for reference) or has
a synthesizer itself.

Hardware
--------

(More details on soundcards and MIDI, possibly links to SBLive MIDI
here...)

SB Audigy 1 - Emu10k1 WaveTable

First, make sure that the Synth mixer control is not muted and that
Audigy Analog/Digital output Jack is set to [Off].  
 To check and adjust them, use alsamixer or your mixer of choice.

Next, build and install the awesfx package from the AUR. Then, load a
SoundFont file on the Emux WaveTable, like so:

    $ asfxload /path/to/any/file.sf2

The .SF2 file can be any SoundFont. If you have access to 2GMGSMT.SF2 on
Windows, you can use that one.

  
 You should be all set now. If you want to play your .mid files in
Audacious, you will need to configure it as follows:

-   File > Preferences > Plugins > Input > AMIDI-Plug > Preferences
    -   AMIDI PLug (tab) > Backend selection > ALSA Backend
    -   ALSA Backend (tab)
        -   17:0 Emu10k1 WaveTable Emu10k1 Port 0
        -   17:1 Emu10k1 WaveTable Emu10k1 Port 1
        -   17:2 Emu10k1 WaveTable Emu10k1 Port 2
        -   17:3 Emu10k1 WaveTable Emu10k1 Port 3
        -   Mixer settings > Soundcard > SB Audigy 1 [SB0092]
        -   Mixer control > Synth

Software
--------

(Details on options available, like TiMidity++ or FluidSynth. Can be
merged or linked if page exists, eg. there's an article for Timidity
already.)

> VLC

You can play MIDI files on VLC if you configure the location of the
Sound Font file. Previously you need to install a sound sample, as well
as the fluidsynth package.

On VLC -> Tools -> Preferences

You have to show all settings. Then, go to input/codecs -> audio codecs
-> FluidSynth.

And, if you installed fluidr3 as wiki says, set the location to:

/usr/share/soundfonts/fluidr3/FluidR3GM.SF2

> Timidity++

MIDI to WAVE converter and player.

> FluidSynth

MIDI player and a daemon adding MIDI support to ALSA.

External Links
==============

set up midi

Retrieved from
"https://wiki.archlinux.org/index.php?title=MIDI&oldid=254305"

Category:

-   Audio/Video
