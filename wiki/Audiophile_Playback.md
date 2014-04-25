Audiophile Playback
===================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: This is very work 
                           in progress stuff, feel  
                           welcome to edit and      
                           correct :) (Discuss)     
  ------------------------ ------------------------ ------------------------

This settings are meant for HD audio playback at 24bit depth and 96000Hz
frequency. So there's no need to change anything default if your audio
sources have standard CD quality.

Contents
--------

-   1 Alsa
-   2 Pulseaudio
-   3 Jack
-   4 List of linux-friendly audiophile sound cards
-   5 Checking actual output parameters

Alsa
----

    ~/.asoundrc

    defaults.pcm.!rate_converter "samplerate_best"	
    defaults.pcm.dmix.!rate 96000	
    defaults.pcm.dmix.!format S24_LE

An exclamation sign causes a previous definition to be overridden. This
syntax can be used with any configuration file assignment.

Dmix is enabled as default for soundcards which do not support hardware
mixing.

Pulseaudio
----------

Since Pulseaudio server is not intended to deliver high quality streams
for the sake of usability, it is recommended to just not install it.

    /etc/pulse/daemon.conf 

    resample-method = src-sinc-medium-quality
    default-sample-format = s24le
    default-sample-rate = 96000

SRC resampling algorithm is very cpu intensive. Setting it to medium
quality should work better.

Jack
----

List of linux-friendly audiophile sound cards
---------------------------------------------

Audiotrak Prodigy HD2

Checking actual output parameters
---------------------------------

Check the contents of /proc/asound/cardX/pcmYp/subZ/hw_params, where X,
Y, and Z are numbers depending on your system. In order to find this
file, execute the following command while playing some sound:  

find /proc/asound/ -name hw_params | xargs -I FILE grep -v -l "closed" FILE | grep '/proc/asound/card./pcm.p/sub./hw_params'  
 Indeed, there exist a hw_params file for each sound input/ouput
subsystem whose content is either "closed" if unused, or the actual
format of the played sound.

Here is an example of an hw_param contents for a stereo 96kHz /
24bits:  

    /proc/asound/cardX/pcmYp/subZ/hw_params

    access: MMAP_INTERLEAVED
    format: S32_LE
    subformat: STD
    channels: 2
    rate: 96000 (96000/1)
    period_size: 9000
    buffer_size: 288000

More info available in the alsa documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=Audiophile_Playback&oldid=277073"

Categories:

-   Sound
-   Audio/Video

-   This page was last modified on 29 September 2013, at 23:50.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
