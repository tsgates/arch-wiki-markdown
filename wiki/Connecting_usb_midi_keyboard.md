Connecting usb midi keyboard
============================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with USB Midi    
                           Keyboards.               
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Connecting USB MIDI Keyboard in Arch Linux
------------------------------------------

1.  We need to install qsynth, jack, qjackctl
2.  Launch qjackctl and check the settings:

     Server Path: jackd
     Driver: alsa
     Realtime=enable; Priority:0
     Frames/Period:512
     Soft Mode=enable; Periods/Buffer:2
     Rest of parameters=disable(by default)
     Dither: None
     Audio: Duplex

1.  Start jackd using qjackctl (the Play button)
2.  Connect your USB keyboard
3.  Start QSynth and go to Setup, where you need to load soundfont in
    SF2 format. You can get free SoundFonts from
    http://soundfonts.narod.ru/ (in Russian)

Note:After loading the SoundFont, you will have to restart QSynth when
it as you to do so.

1.  Go to qjackctl, click Connect and choose the ALSA tab. On the left
    side you will see connected MIDI keyboard, on the left side -
    QSynth. Choose MIDI keyboard and QSynth, and click Connect.

Now, try to play on your midi keyboard!

Retrieved from
"https://wiki.archlinux.org/index.php?title=Connecting_usb_midi_keyboard&oldid=262386"

Category:

-   Other hardware

-   This page was last modified on 11 June 2013, at 17:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
