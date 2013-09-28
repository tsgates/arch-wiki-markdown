ESD
===

The Enlightened Sound Daemon was used by gnome to play system sounds on
certain events - like login, logout, etc. It has since been replaced by
"libcanberra for event sounds or GStreamer/PulseAudio for everything
else."[1].

There is one built with alsa support(the normal one) and an additional
built with oss support in the AUR

Starting ESD
============

There's not much to setup apart from adding esd to the DAEMONS line in
/etc/rc.conf like this:

    DAEMONS=(syslog-ng network netfs crond alsa esd mpd hal fam gdm cupsd)

Troubleshooting
===============

-Is esd hogging your sound device and you can't uninstall it since gnome
requires it to install/build?

put

    esdctl off

in a startup file(like .xinitrc, or use gnome-session, kde....)

problem solved!

to see if anything is hogging your sound devices run fuser as root or
sudo.

    sudo fuser /dev/snd/*

and

    sudo fuser /dev/sound/*

example:

    kris|~$ sudo fuser /dev/sound/*
    /dev/sound/mixer:     3504

Then you can use

    ps auxw|grep 3504

for example, to see what is hogging the device.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ESD&oldid=205610"

Category:

-   Audio/Video
