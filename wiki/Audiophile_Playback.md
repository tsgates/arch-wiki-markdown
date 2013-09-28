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

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Alsa                                                               |
| -   2 Pulseaudio                                                         |
| -   3 Jack                                                               |
| -   4 List of linux-friendly audiophile sound cards                      |
+--------------------------------------------------------------------------+

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

Retrieved from
"https://wiki.archlinux.org/index.php?title=Audiophile_Playback&oldid=247237"

Categories:

-   Sound
-   Audio/Video
