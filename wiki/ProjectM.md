ProjectM
========

ProjectM is an open source music visualizer based on the Milkdrop plugin
for Windows/Winamp. It now has a Qt GUI that can visualize your audio
output through either JACK or PulseAudio, in addition to a libvisual
component. This wiki currently focuses on the PulseAudio standalone GUI.

Installation
------------

ProjectM can be installed with the projectm-pulseaudio package,
available in the official repositories.

Support for other sound servers is provided by projectm-jack and
projectm-libvisual-alsa from the AUR.

Run
---

Once everything is install just do the following from the command line:

    $ projectM-pulseaudio

Controls (these are listed in the menu under "hotkeys":

    m - brings up a menu
    f - toggles fullscreen on/off
    l - "locks" to a particular preset
    y - toggles shuffle mode
    n - next preset
    p - previous preset
    r - selects random preset
    F1 - Help menu
    F2 - Toggles song title on/off (doesn't work in libvisual or pulseaudio as far as I can tell)
    F3 - Toggle preset name on/off
    F4 - Toggel rendering info on/off
    F5 - Shows fps

Troubleshooting
---------------

The first PulseAudio sound output device is used from the list shown by
the command

    pacmd list-sources

If this is not the device you want to use, the easiest thing to do is to
press 'm' to bring up the menu, then Settings > Pulse Audio Settings.
Uncheck the checkbox at the bottom which says "Try first available
playback monitor," then select the correct device. Most likely it is one
which ends in ".monitor" (if you want the visualizer to visualize what's
being output/played).

Some information on usage and configuration can be found in the ProjectM
FAQ

Otherwise a good place to ask question are the projectM help forums on
Sourceforge.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ProjectM&oldid=250159"

Category:

-   Audio/Video
