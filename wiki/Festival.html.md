Festival
========

Festival is a general multi-lingual speech synthesis system developed at
CSTR (Centre for Speech Technology Research).

Festival offers a general framework for building speech synthesis
systems as well as including examples of various modules. As a whole it
offers full text to speech through a number APIs: from shell level,
though a Scheme command interpreter, as a C++ library, from Java, and an
Emacs interface. Festival is multi-lingual (currently British English,
American English, and Spanish.)

Contents
--------

-   1 Installation
    -   1.1 HTS compatibility patches
    -   1.2 Using with PulseAudio
-   2 Configuration
-   3 Usage
    -   3.1 Interactive mode (testing voices etc.)
    -   3.2 Example script
-   4 Troubleshooting
    -   4.1 Can't open /dev/dsp
    -   4.2 Alsa playing at wrong speed
    -   4.3 aplay Command not found
-   5 See also

Installation
------------

Install festival from official repositories. You need a voice package
like festival-english or festival-us. Further languages are available in
official repositories and in AUR.

Test festival:

    $ echo "This is an example. Arch is the best." | festival --tts

If your hear all the example text, you sucessfully installed a TTS
system.

If you do not hear anything, hear something strange, or get a message
about /dev/dsp, see the Troubleshooting section.

> HTS compatibility patches

Some say that HTS voices for Festival are the best ones freely
available. Sadly they are not compatible with Festival >2.1 without
patching it (and the new voice versions are not made available for
downloading).

You can install the patched version from AUR: festival-patched-hts and
festival-hts-voices-patched

> Using with PulseAudio

Add these lines to the end of your .festivalrc file, or to
/usr/share/festival/festival.scm :

    (Parameter.set 'Audio_Required_Format 'aiff)
    (Parameter.set 'Audio_Method 'Audio_Command)
    (Parameter.set 'Audio_Command "paplay $FILE --client-name=Festival --stream-name=Speech")

Configuration
-------------

You can set a default voice by adding these lines to the end of your
~/.festivalrc file, or to /usr/share/festival/festival.scm:

    (set! voice_default 'voice_cmu_us_slt_arctic_hts)

You can also set the default voice in /usr/share/festival/voices.scm You
must be root and the voices are at the end of the file. Just switch them
around

Usage
-----

Read a text file:

    $ festival --tts /path/to/letter.txt

Read a text file to wav:

    $ cat letter.txt | text2wave -o letter.wav

> Interactive mode (testing voices etc.)

festival has an interactive prompt you can use for testing. Some
examples (with sample output):

    $ festival 
    [...]
    festival> 

List available voices:

    festival> (voice.list)
    (cstr_us_awb_arctic_multisyn kal_diphone don_diphone)

Set voice:

    festival> (voice_cstr_us_awb_arctic_multisyn)
    #<voice 0x1545b90>

Speak:

    festival> (SayText '"test this is a test oh no a test bla test")
    inserting pause after: t.
    Inserting pause
    [...]
    id _63 ; name t ; 
    id _65 ; name # ; 
    #<Utterance 0x7f7c0c144810>

More:

    festival> help 
    "The Festival Speech Synthesizer System: Help

Quit: ctrl+d or

    festival> (quit)

> Example script

One classic app that can make use of this is ping. Use this script to
constantly ping a host, and return ping if success, fail is not:

    #!/bin/bash
    while :; do
        ping -c 1 $1 && (echo "Ping" 

Note that this does not really work on multisynth voices, as they take a
while to prepare before playing.

Troubleshooting
---------------

> Can't open /dev/dsp

If festival returns the following error message:

    Linux: can't open /dev/dsp

Switch to ALSA output by adding these lines to the end of your
.festivalrc file, or to /usr/share/festival/festival.scm (source):

    (Parameter.set 'Audio_Method 'Audio_Command)
    (Parameter.set 'Audio_Command "aplay -q -c 1 -t raw -f s16 -r $SR $FILE")

> Alsa playing at wrong speed

If the solution above gives you a squeaky voice, you might want to try:

    (Parameter.set 'Audio_Method 'Audio_Command)
    (Parameter.set 'Audio_Command "aplay -Dplug:default -f S16_LE -r $SR $FILE")

> aplay Command not found

Install alsa-utils.

See also
--------

-   Festival manual

Retrieved from
"https://wiki.archlinux.org/index.php?title=Festival&oldid=280782"

Categories:

-   Accessibility
-   Audio/Video

-   This page was last modified on 1 November 2013, at 11:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
