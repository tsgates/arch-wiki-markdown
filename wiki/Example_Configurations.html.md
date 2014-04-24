Advanced Linux Sound Architecture/Example Configurations
========================================================

The following should serve as a guide for more advanced ALSA setups. The
configuration takes place in /etc/asound.conf as mentioned in the main
article. None of the following configurations are guaranteed to work.

Note:Most things discussed here are much easier to accomplish using alsa
plugins like upmix which are explained in the main article.

> Upmixing of stereo sources to 7.1 using dmix while saturated sources do not get upmixed

    # 2008-11-15
    #
    # This .asoundrc will allow the following:
    #
    # - upmix stereo files to 7.1 speakers.
    # - playback real 7.1 sounds, on 7.1 speakers,
    # - allow the playback of both stereo (upmixed) and surround(7.1) sources at the same time.
    # - use the 6th and 7th channel (side speakers) as a separate soundcard, i.e. for headphones
    #   (This is called the "alternate" output throughout the file, device names prefixed with 'a')
    # - play mono sources in stereo (like skype & ekiga) on the alterate output
    #
    # Make sure you have "8 Channels" and NOT "6 Channels" selected in alsamixer!
    #
    # Please try the following commands, to make sure everything is working as it should.
    #
    # To test stereo upmix :      speaker-test -c2 -Ddefault -twav
    # To test surround(5.1):      speaker-test -c6 -Dplug:dmix6 -twav
    # To test surround(7.1):      speaker-test -c6 -Dplug:dmix8 -twav
    # To test alternative output: speaker-test -c2 -Daduplex -twav
    # To test mono upmix:         speaker-test -c1 -Dmonoduplex -twav
    #
    #
    # It may not work out of the box for all cards. If it doesnt work for you, read the comments throughout the file.
    # The basis of this file was written by wishie of #alsa, and then modified with info from various sources by 
    # squisher. Svenstaro modified it for 7.1 output support.

    #Define the soundcard to use
    pcm.snd_card {
        type hw
        card 0
        device 0
    }

    # 8 channel dmix - output whatever audio, to all 8 speakers
    pcm.dmix8 {
        type dmix
        ipc_key 1024
        ipc_key_add_uid false
        ipc_perm 0660
        slave {
            pcm "snd_card"
            rate 48000
            channels 8
            period_time 0
            period_size 1024
            buffer_time 0
            buffer_size 5120
        }

    # Some cards, like the "nforce" variants require the following to be uncommented. 
    # It routes the audio to the correct speakers.
    #    bindings {
    #        0 0
    #        1 1
    #        2 4
    #        3 5
    #        4 2
    #        5 3
    #        6 6
    #        7 7
    #    }
    }

    # upmixing - duplicate stereo data to all 8 channels
    pcm.ch71dup {
        type route
        slave.pcm dmix8
        slave.channels 8
        ttable.0.0 1
        ttable.1.1 1
        ttable.0.2 1
        ttable.1.3 1
        ttable.0.4 0.5
        ttable.1.4 0.5
        ttable.0.5 0.5
        ttable.1.5 0.5
        ttable.0.6 1
        ttable.1.7 1
    }

    # this creates a six channel soundcard
    # and outputs to the eight channel one
    # i.e. for usage in mplayer I had to define in ~/.mplayer/config:
    #   ao=alsa:device=dmix6
    #   channels=6
    pcm.dmix6 {
        type route
        slave.pcm dmix8
        slave.channels 8
        ttable.0.0 1
        ttable.1.1 1
        ttable.2.2 1
        ttable.3.3 1
        ttable.4.4 1
        ttable.5.5 1
        ttable.6.6 1
        ttable.7.7 1
    }

    # share the microphone, i.e. because virtualbox grabs it by default
    pcm.microphone {
        type dsnoop
        ipc_key 1027
        slave {
            pcm "snd_card"
        }
    }

    # rate conversion, needed i.e. for wine
    pcm.2chplug {
        type plug
        slave.pcm "ch71dup"
    }
    pcm.a2chplug {
        type plug
        slave.pcm "dmix8"
    }

    # routes the channel for the alternative
    # 2 channel output, which becomes the 7th and 8th channel 
    # on the real soundcard
    #pcm.alt2ch {
    #    type route
    #    slave.pcm "a2chplug"
    #    slave.channels 8
    #    ttable.0.6    1
    #    ttable.1.7    1
    #}

    # skype and ekiga are only mono, so route left channel to the right channel
    # note: this gets routed to the alternative 2 channels
    pcm.mono_playback {
        type route
        slave.pcm "a2chplug"
        slave.channels 8
        # Send Skype channel 0 to the L and R speakers at full volume
        #ttable.0.6    1
        #ttable.0.7    1
    }

    # 'full-duplex' device for use with aoss
    pcm.duplex {
        type asym
        playback.pcm "2chplug"
        capture.pcm "microphone"
    }

    #pcm.aduplex {
    #    type asym
    #    playback.pcm "alt2ch"
    #    capture.pcm "microphone"
    #}

    pcm.monoduplex {
        type asym
        playback.pcm "mono_playback"
        capture.pcm "microphone"
    }

    # for aoss
    pcm.dsp0 "duplex"
    ctl.mixer0 "duplex"

    # softvol manages volume in alsa
    # i.e. wine likes this
    pcm.mainvol {
        type softvol
        slave.pcm "duplex"
        control {
            name "2ch-Upmix Master"
            card 0
        }
    }

    #pcm.!default "mainvol"

    # set the default device according to the environment
    # variable ALSA_DEFAULT_PCM and default to mainvol
    pcm.!default {
        @func refer
        name { @func concat 
               strings [ "pcm."
                         { @func getenv
                           vars [ ALSA_DEFAULT_PCM ]
                           default "mainvol"
                         }
               ]
             }
    }

    # uncomment the following if you want to be able to control
    # the mixer device through environment variables as well
    #ctl.!default {
    #    @func refer
    #    name { @func concat 
    #           strings [ "ctl."
    #                     { @func getenv
    #                       vars [ ALSA_DEFAULT_CTL
    #                              ALSA_DEFAULT_PCM
    #                       ]
    #                       default "duplex"
    #                     }
    #           ]
    #         }
    #}

> Surround51 incl. upmix stereo & dmix, swap L/R, bad speaker position in room

Bad practice but works fine for almost everything without additional
per-program/file customization:

    pcm.!default {
        type route
    ## forwards to the mixer pcm defined below
        slave.pcm dmix51
        slave.channels 6

    ## "Native Channels" stereo, swap left/right
        ttable.0.1 1
        ttable.1.0 1
    ## original normal left/right commented out
    #    ttable.0.0 1
    #    ttable.1.1 1

    ## route "native surround" so it still works but weaken signal (+ RL/RF swap) 
    ## because my rear speakers are more like random than really behind me
        ttable.2.3 0.7
        ttable.3.2 0.7
        ttable.4.4 0.7
        ttable.5.5 0.7

    ## stereo => quad speaker "upmix" for "rear" speakers + swap L/R
        ttable.0.3 1
        ttable.1.2 1

    ## stereo L+R => join to Center & Subwoofer 50%/50%
        ttable.0.4 0.5
        ttable.1.4 0.5
        ttable.0.5 0.5
        ttable.1.5 0.5
    ## to test: "$ speaker-test -c6 -twav" and: "$ speaker-test -c2 -twav"
    }

    pcm.dmix51 {
    	type dmix
    	ipc_key 1024
    # let multiple users share
    	ipc_key_add_uid false 
    # IPC permissions (octal, default 0600)
    # I think changing this fixed something - but I'm not sure what.
    	ipc_perm 0660 # 
    	slave {
    ## this is specific to my hda_intel. Often hd:0 is just allready it; To find: $ aplay -L 
    		pcm surround51 
    # this rate makes my soundcard crackle
    #		rate 44100
    # this rate stops flash in firefox from playing audio, but I do not need that
           rate 48000
           channels 6
    ## Any other values in the 4 lines below seem to make my soundcard crackle, too
           period_time 0
           period_size 1024
           buffer_time 0
           buffer_size 4096
    	}
    }

Retrieved from
"https://wiki.archlinux.org/index.php?title=Advanced_Linux_Sound_Architecture/Example_Configurations&oldid=207051"

Category:

-   Audio/Video

-   This page was last modified on 13 June 2012, at 15:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
