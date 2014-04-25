USB Midi Keyboards
==================

  

Contents
--------

-   1 USB Midi Keyboards
-   2 Preliminary Testing
    -   2.1 USB
    -   2.2 ALSA
-   3 Plugging the keyboard
-   4 Verifying Events
-   5 Playing

USB Midi Keyboards
------------------

This how-to assumes that you are using a 2.6 kernel and ALSA. Known to
work using this how-to is the Evolution MK-631 USB midi keyboard with SB
Live! Value card. Execute these instructions as an unprivileged user
unless otherwise noted.

Preliminary Testing
-------------------

> USB

First let us make sure that USB is working properly. When you type lsmod
you should see some modules such as ehci, uhci or such. Also, when you
type lsusb you should see something like:

    Bus 004 Device 001: ID 0000:0000
    Bus 003 Device 001: ID 0000:0000
    Bus 002 Device 001: ID 0000:0000
    Bus 001 Device 001: ID 0000:0000

This list might contain some USB devices if you have them plugged in or
more or less items, depending on how many USB ports you have.

> ALSA

You should have ALSA set-up properly (alsa-lib and alsa-utils packages).
When you type lsmod | grep snd you should see a bunch of various snd
drivers.

Try typing aseqdump. If you get an error stating that "aseqdump cannot
find /dev/snd/seq" or similar, you might not have the snd-seq module
loaded. To rectify that, type (as root) modprobe snd-seq. You might also
want to add (again as root) snd-seq to your /etc/rc.conf file in the
modules list. If the module is succesfully loaded, typing aseqdump
should show something like:

    Waiting for data at port 128:0. Press Ctrl+C to end.
    Source_ Event_________________ Ch _Data__

Not much will show up there, so press Ctrl+C to quit the program.

Plugging the keyboard
---------------------

Now plug the keyboard in and turn it on. The keyboard should power up.
Output of lsusb should contain:

    Bus 002 Device 002: ID 0a4d:00a0 Evolution Electronics, Ltd

Output of lsmod | grep usb should contain the following modules:

    usb_midi               25348  0
    snd_usb_audio          70592  0
    snd_usb_lib            16640  1 snd_usb_audio

Now type aconnect -i. The output should contain:

    client 72: 'MK-361 USB MIDI keyboard' [type=kernel]
        0 'MK-361 USB MIDI keyboard MIDI 1'

The client number is probably going to be different though. Take note of
it.

Verifying Events
----------------

Type aseqdump -p ## where you should replace ## with the client number
of your keyboard. You should see:

     72:0   Active Sensing

popping out all the time. Pressing a key should produce:

     72:0   Note on                 0  65  94
     72:0   Note on                 0  65   0

Various other events (turning control knobs, changing channels, etc.)
should register in the list. This is a handy way of ensuring that your
keyboard is running properly.

Playing
-------

Now type aconnect -o to list the devices listed as ALSA midi outputs. It
depends a lot on your sound card. On SB Live! Value, you get the
following output:

    client 64: 'EMU10K1 MPU-401 (UART)' [type=kernel]
        0 'EMU10K1 MPU-401 (UART)'
    client 65: 'Emu10k1 WaveTable' [type=kernel]
        0 'Emu10k1 Port 0  '
        1 'Emu10k1 Port 1  '
        2 'Emu10k1 Port 2  '
        3 'Emu10k1 Port 3  '

Here client 65 is the actual MIDI synthesizer. Assuming the soundcard is
set up properly, you should be able to route the output of the keyboard
to the MIDI synthesizer. Assuming out is the output client number (65 in
our example) and in is the input client number (72 in our example), type
aconnect in out. Now you can play your keyboard via the MIDI output of
your sound card.

Retrieved from
"https://wiki.archlinux.org/index.php?title=USB_Midi_Keyboards&oldid=289764"

Category:

-   Other hardware

-   This page was last modified on 21 December 2013, at 11:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
