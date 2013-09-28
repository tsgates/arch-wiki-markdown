Ventrilo
========

Ventrilo is a voice communication program for Windows that runs quite
well on the latest Wine. This article outlines a few workarounds
necessary to using Ventrilo naturally on Linux.

Note:Running Ventrilo under Wine is no longer necessary; Mangler is a
stable open-source client in the AUR that connects to Ventrilo 3.0
servers.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Global Push to Talk Hotkey                                         |
|     -   1.1 Finding the input device                                     |
|     -   1.2 Startup Script                                               |
|     -   1.3 Example Ventrilo Startup Script                              |
|     -   1.4 Allowing sudo for ventriloctrl                               |
|                                                                          |
| -   2 Mangler and ALSA                                                   |
| -   3 Additional Resources                                               |
+--------------------------------------------------------------------------+

Global Push to Talk Hotkey
--------------------------

One problem that Wine Ventrilo users face is that the push to talk
hotkey only being detected when a Wine window (such as Ventrilo itself)
is in focus. The solution to this is using ventriloctrl, a simple
program that sends X input to Ventrilo.

> Finding the input device

The acceptable input devices are in /dev/input/. If you want to use a
mouse use the event-mouse in /dev/input/by-id/. For a keyboard use
/dev/input/event[#].

You will probably need to do a bit of trial and error to find the proper
event number or device. The best way to do this is just to run
ventriloctrl /dev/input/[whatever] as root, and press keys or click your
mouse and see if it is detected by the program. If it is detected, it
will show an example line with a number at the end. That number is the
button number that you will use to run ventriloctrl in the future.

For example, my
ventriloctrl /dev/input/by-id/usb-Logitech_USB_Receiver-event-mouse
shows:

    # ventriloctrl /dev/input/by-id/usb-Logitech_USB_Receiver-event-mouse 272

If that was the button I wanted to use, I would run ventriloctrl with
that line in the future.

> Startup Script

Now we will make a script to run ventriloctrl using the parameters you
discovered. This could also be done with an alias or other user-specific
methods. Edit your script with your favorite editor and call it whatever
you want. Mine is going to be called ventriloctrl+.

    # nano /usr/bin/ventriloctrl+

By default, a normal user does not have the access to the /dev/input/
devices that ventriloctrl needs to use. To get around this you can
either make a udev rule, or just use sudo. So far, I am just going to
show what your script should look like with sudo.

    #!/bin/sh
    sudo ventriloctrl /dev/input/by-id/usb-Logitech_USB_Receiver-event-mouse 272

Of course, the device and event number should be replaced with the ones
you found earlier. Essentially you just want to add sudo to the front of
your previous input device line.

Make sure your script is executable:

    # chmod +x /usr/bin/ventriloctrl+

All done. Now you just need to make the ventriloctrl+ script run when
ventrilo runs.

> Example Ventrilo Startup Script

We previously made a script to start ventriloctrl. Now, you may wish to
make a script that starts ventriloctrl after Ventrilo starts. The tough
part about this is determining when Ventrilo has started completely, as
it is a Wine app. If anyone else has a better way of doing this please
add it. Otherwise, here is my method.

Take a look at the first post in the self-made command line utilities
thread on the Arch forums. The script we are going to use from that is
the try script.

Copy it into a script file such as /usr/bin/try. Make sure the script is
executable.

    # chmod +x /usr/bin/try

Now create another script to start Ventrilo named whatever you want.
Mine will be called ventrilo.

    # nano /usr/bin/ventrilo

In the script, you will first want to cd to your Ventrilo install. By
default, this should work for any users that have it installed to their
default ~/.wine directory. In my example, I run Ventrilo.exe and save
its pid to the VENT variable, and then I use the try script to run
ventriloctrl+ and save its pid to the CTRL variable. Then I wait until
VENT finishes, and kill CTRL. The effect? Ventrilo starts and
ventriloctrl attempts to start until it does, then it runs until
Ventrilo closes. Here is my script:

    #!/bin/bash
    cd ~/.wine/drive_c/Program\ Files/Ventrilo
    wine Ventrilo.exe 2>/dev/null & VENT=$!
    try ventriloctrl+ & CTRL=$!
    wait $VENT
    kill $CTRL

Also make sure your ventrilo script is executable.

    # chmod +x /usr/bin/ventrilo

That should be it. You should now be able to run Ventrilo with the
ventrilo command.

> Allowing sudo for ventriloctrl

You might also want to run ventriloctrl with nopasswd for sudo. To do
this, edit sudo's config file:

    # visudo

Add a line like the following. %wheel can be replaced with specific
usernames if desired, otherwise it will work for any users in the wheel
group.

    %wheel ALL=NOPASSWD:/usr/bin/ventriloctrl

Mangler and ALSA
----------------

Currently, mangler and mangler-svn from the AUR defaults to using
pulseaudio at launch, regardless if it's not installed and will cause
the application to hang at the terminal or not start at all. To build
Mangler without pulseaudio, edit the PKGBUILD's ./configure line, add
--without-pulseaudio, like so:

    ./configure --prefix=/usr --without-pulseaudio

Also, should your microphone fail to transmit any audio or should you
get an error from a terminal that looks like this:

    (snd_pcm_set_params) Rate doesn't match (requested 32000Hz, get 0Hz)

It is due to the recording device failing to re-sample to the Ventrillo
server's rate. To fix this, go Edit -> Settings and then the Audio tab
and select Custom for the input device and type in:

    plughw:X,0

Where X is your microphone or recording device ID. To determine your
recording device ID:

    cat /proc/asound/cards

The number next to each device is the device ID. Also, don't forget to
raise the volume on your recording device through alsamixer.

Should none of this work and problems still persist, switching to
pulseaudio might be the way to go, at least until Mangler is fixed.

Additional Resources
--------------------

-   WineHQ's AppDB entry for Ventrilo
-   Ubuntu Forums Source

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ventrilo&oldid=238253"

Categories:

-   Telephony and Voice
-   Wine
