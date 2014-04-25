FluidSynth
==========

FluidSynth is a real-time software synthesizer based on the SoundFont 2
specifications.

Contents
--------

-   1 Installing FluidSynth
-   2 How to use FluidSynth
    -   2.1 Standalone mode
    -   2.2 ALSA daemon mode
-   3 How to convert MIDI to OGG

Installing FluidSynth
---------------------

The first step is to install fluidsynth from the official repositories.

However, FluidSynth will not produce any sound yet. This is because
FluidSynth does not include any instrument samples. To produce sound,
instrument patches and/or soundfonts need to be installed and fluidsynth
configured so it knows where to find them. You can install SoundFont
sample.

How to use FluidSynth
---------------------

There are two ways to use FluidSynth. Either as MIDI player or as daemon
adding MIDI support to ALSA.

> Standalone mode

You can simply use fluidsynth to play MIDI files:

    $ fluidsynth -a alsa -m alsa_seq -l -i /usr/share/soundfonts/fluidr3/FluidR3GM.SF2 example.midi

Assuming than you installed fluidr3.

There are many other options to fluidsynth; see manpage or use -h to get
help.

One may wish to use pulseaudio instead of alsa as the argument to the -a
option.

> ALSA daemon mode

If you want fluidsynth to run as ALSA daemon, edit
/usr/lib/systemd/system/fluidsynth.service and append the ExecStart Line
with the soundfont you want to use, for fluidr3:

    ExecStart=/usr/bin/fluidsynth -is -a alsa -m alsa_seq -r 48000 "/usr/share/soundfonts/fluidr3/FluidR3GM.SF2"

After that, you can start fluidsynth service and possibly enable it.

This will give you an output software MIDI port (in addition of hardware
MIDI ports on your system, if any):

    $ aconnect -o

    client 128: 'FLUID Synth (5117)' [type=user]
       0 'Synth input port (5117:0)'

An example of usage for this is aplaymidi:

    $ aplaymidi -p128:0 example.midi

How to convert MIDI to OGG
--------------------------

Simple command lines to convert midi to ogg:

    $ fluidsynth -nli -r 48000 -o synth.cpu-cores=2 -T oga -F example.ogg /usr/share/soundfonts/fluidr3/FluidR3GM.SF2 example.MID

Here's a little script to convert multiple midi files to ogg in
parallel:

    #!/bin/bash
    maxjobs=$(grep processor /proc/cpuinfo | wc -l)
    midi2ogg() {
    	name=$(echo $@ | sed -r s/[.][mM][iI][dD][iI]?$//g | sed s/^[.][/]//g)
    	for arg; do 
    	fluidsynth -nli -r 48000 -o synth.cpu-cores=$maxjobs -F "/dev/shm/$name.raw" /usr/share/soundfonts/fluidr3/FluidR3GM.SF2 "$@"
    	oggenc -r -B 16 -C 2 -R 48000 "/dev/shm/$name.raw" -o "$name.ogg"
    	rm "/dev/shm/$name.raw"
    	## Uncomment for replaygain tagging
    	#vorbisgain -f "$name.ogg" 
    	done
    }
    export -f midi2ogg
    find . -regex '.*[.][mM][iI][dD][iI]?$' -print0 | xargs -0 -n 1 -P $maxjobs bash -c 'midi2ogg "$@"' --

Retrieved from
"https://wiki.archlinux.org/index.php?title=FluidSynth&oldid=303936"

Category:

-   Audio/Video

-   This page was last modified on 10 March 2014, at 19:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
