Pianobar
========

Pianobar is a free/open-source, console-based client for the
personalized online radio Pandora.

http://6xq.net/projects/pianobar/

Installation
------------

Sync and install with pacman:

    # pacman -S pianobar

Troubleshooting
---------------

If you are experiencing sound/quality issues when running pianobar, and
you are currently using ALSA as your sound driver, the following fix may
be useful:

-   Install alsa-oss. See the ALSA page for more information.
-   Change the default libao driver from alsa to oss.

    /etc/libao.conf

    default_driver=oss

-   Now to run pianobar:

    $ aoss pianobar

-   Alternatively, you can use pulseaudio.

    /etc/libao.conf

    default_driver=pulse

Be sure to remove the dev=default option of the alsa driver or adjust it
to specify a specific Pulse sink name or number.

Note:The provided fix may affect other applications that use audio since
the default driver is being changed. Switch back to the normal
configuration at anytime by editing /etc/libao.conf

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pianobar&oldid=247928"

Category:

-   Audio/Video
