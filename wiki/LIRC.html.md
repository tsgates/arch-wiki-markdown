LIRC
====

Related articles

-   LIRC Device Examples

This article covers setup and usage of LIRC "Linux Infrared Remote
Control" with serial or USB infrared devices.

Contents
--------

-   1 Overview
    -   1.1 The Central Dogma of LIRC
    -   1.2 Summary of Required Files
-   2 Installation
-   3 Setup
    -   3.1 The LIRC Config File
        -   3.1.1 Use a Prebuild Config File
        -   3.1.2 Create a Config File
-   4 Testing the Remote
-   5 Program Specific Configuration
-   6 Troubleshooting
    -   6.1 Remote functions as a keyboard
-   7 Legacy Info Which Needs to be Modernized and Vetted for Accuracy
    -   7.1 Setup a HID device with LIRC
    -   7.2 Serial receivers that depend on lirc_serial
        -   7.2.1 Building the lirc_serial module for another ttySx
        -   7.2.2 Loading
    -   7.3 Checking module based receivers
    -   7.4 Your serial port support is compiled as a module in the
        kernel
    -   7.5 Your serial port support is compiled into the kernel
-   8 See also

Overview
--------

LIRC is a daemon that can translate key presses on a supported remote
into program specific commands. In this context, the term, "program
specific" means that a key press can do different things depending on
which program is running and taking commands from LIRC.

> The Central Dogma of LIRC

The list below attempts to show the flow of information from the remote
to the program using LIRC:

-   User hits a button on the remote causing it to transmit an IR or RF
    signal.
-   The signal is received by the receiver connected to the Linux box.
-   The kernel (via the correct module) uses /dev/lirc0 to characterize
    the pulse-length information from the receiver.
-   /usr/bin/lircd uses the information from /etc/lirc/lircd.conf
    convert the pulse-lengths into button press information.
-   Programs that use LIRC translate the button press info from
    /usr/bin/lircd into user-defined actions according to ~/.lircrc.

> Summary of Required Files

-   /etc/lirc/lircd.conf - System-level config translating scancodes -->
    keys. Is specific to each remote control/receiver on the system and
    can contain configure for multiple remotes and/or receivers if need
    be.
-   ~/.lircrc - File containing an include statement pointing to each
    program's lirc map, i.e., ~/.lirc/foo, ~/.lirc/bar, etc.
-   ~/.lirc/foo - User-level config translating of keys --> actions. Is
    specific to each remote and to application foo.

Installation
------------

Install the lirc-utils package, which is available in the official
repositories. The most of LIRC kernel drivers are already included in
the mainline kernel. Install the lirc package only, if the hardware
requires the lirc_wpc8769l module.

Setup
-----

Some remotes are identified as "keyboards" and function as such without
LIRC. This is problematic and can result in a doubling of commands. Test
if this is the case by opening a shell or a text editor, and by pressing
buttons on the remote itself. If letters/numbers appear, or if the
up/down/left/right arrow keys behave as the up/down/left/right arrow
keys on the physical keyboard, a workaround to disable this is required.
See, LIRC#Remote_functions_as_a_keyboard for a solution before
continuing.

> The LIRC Config File

Defining /etc/lirc/lircd.conf which is specific to each remote/IR
receiver is the first step in setting up a remote.

Note:Common configs are provided by lirc-utils, like those bundled with
TV cards that can be installed automatically. The primary source of
config files is the LIRC homepage. Check the official list of supported
hardware to know, which LIRC kernel modules and lircd driver required.

Use a Prebuild Config File

Identify which remote/receiver is to be used and see if /usr/share/lirc
contains a pre-built config file for it. Once identified, create/edit
/etc/lirc/lircd.conf to use an include statement that points to the
selected one.

Example:

    /etc/lirc/lircd.conf

     include "/usr/share/lirc/streamzap/lircd.conf.streamzap"

Create a Config File

Users with unsupported hardware will need to either find a config file
someone else has created (i.e. google) or create one. Creating one is
fairly straightforward using the included /usr/bin/irrecord program
which guides users along the needed process. If using a detected remote,
invoke it like so:

    irrecord --device=/dev/lirc0 MyRemote

The program will ask users to begin hitting keys on the remote in an
attempt to learn it. If all goes well, the user will be prompted to map
out each key press to a specific scancode LIRC uses to identify that
specific key press. The process should take no more than 10 minutes.
When finished, save the resulting file to /etc/lirc/lircd.conf and
proceed.

Note:Consider sending the finished config file to the email address
mentioned in the program so it can be made available to others.

Testing the Remote
------------------

Start the LIRC daemon:

    # systemctl start lirc

Test the remote using /usr/bin/irw, which simply echos anything received
by LIRC when users push buttons on the remote to stdout.

Example:

    $ irw
    000000037ff07bfe 00 One mceusb
    000000037ff07bfd 00 Two mceusb
    000000037ff07bfd 01 Two mceusb
    000000037ff07bf2 00 Home mceusb
    000000037ff07bf2 01 Home mceusb

Program Specific Configuration
------------------------------

LIRC has the ability to allow for different programs to use the same
keypress and result in unique commands. In other words, mplayer and vlc
can respond differently to a given key press.

Decide which programs are to use LIRC commands. Common programs include:
mplayer, mythtv, totem, vlc, and xbmc.

Note:XBMC implements LIRC in a non-standard way. Users must edit
~/.xbmc/userdata/Lircmap.xml which is a unique xml file, rather than the
LIRC standard files the rest of the programs use. Interested users
should consult the Xbmc#Using_a_remote_controller article.

Users should create the expected files showing LIRC where the various
program-specific maps reside:

    $ mkdir ~/.lirc
    $ touch ~/.lircrc

-   Populate ~/.lirc with the program specific config files named for
    each program.

Example:

    $ ls ~/.lirc
    mplayer
    mythtv
    vlc

Note:Providing an exhaustive listing of keymaps for each program is
beyond the scope of this wiki article. Many pre-made files unique to
each remote/program are available via googling.

-   Edit ~/.lircrc to contain an include statement pointing to
    ~/.lirc/foo and repeat for each program that is to be controlled by
    LIRC.

Example:

    ~/.lircrc

    include "~/.lirc/mplayer"
    include "~/.lirc/mythtv"
    include "~/.lirc/vlc"

Troubleshooting
---------------

> Remote functions as a keyboard

Xorg detects some remotes, such as the Streamzap USB PC Remote, as a
Human Interface Device (HID) which means some or all of the keys will
show up as key strokes as if entered from the physical keyboard. This
behavior will present problems if LIRC is to be used to manage the
device. To disable, create the following file and restart X:

    /etc/X11/xorg.conf.d/90-streamzap.conf

    Section "InputClass"
      Identifier "Ignore Streamzap IR"
      MatchProduct "Streamzap"
      MatchIsKeyboard "true"
      Option "Ignore" "true"
    EndSection

Don't forget to alter the MatchProduct property according to one shown
in Name from output of

    $ cat /proc/bus/input/devices | grep -e IR

For example WinFast for N: Name="cx88 IR (WinFast DTV2000 H rev."

Legacy Info Which Needs to be Modernized and Vetted for Accuracy
----------------------------------------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Someone with     
                           greater knowledge needs  
                           vet everything below     
                           this line for accuracy.  
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Parts of the     
                           following are            
                           out-of-date and need to  
                           be modernized. (Discuss) 
  ------------------------ ------------------------ ------------------------

> Setup a HID device with LIRC

Some remotes are supported in the kernel where they are treated as a
keyboard and mouse. Every button on the device is recognized as keyboard
or mouse events which can be used even without LIRC. LIRC can still be
used with these devices to gain greater control over the events raised
and integrate with programs that expect a LIRC remote rather than a
keyboard. As drivers are migrated to the kernel, devices which use to
only be useable through LIRC with their own lirc.conf files become
standard HID devices.

Some HID remotes actually simulate a USB infrared keyboard and mouse.
These remotes show up as two devices so you need to add two LIRC devices
to lircd.conf.

First we need the /dev/input device for our remote:

     $ ls /sys/class/rc/rc0

One of the files should be input#, where the number matches the event#
of the device. (To clarify you can check that directory, it will have an
event# file.

Note:If you have more than one ir device then there may be multiple
directories under /sys/class/rc. Under event# cat name to verify which
device you are looking at.

then go to /dev/input/by-id

     $ ls -l /dev/input/by-id

You should find a file that symlinks to the input# above, and possibly
others with a similar names for mouse events.

     lrwxrwxrwx 1 root root  9 10月 14 06:43 usb-3353_3713-event-if00 -> ../event9
     lrwxrwxrwx 1 root root 10 10月 14 06:43 usb-3353_3713-event-if01 -> ../event10

Here 'usb-3353_3713-event-if00' and 'usb-3353_3713-event-if01' are the
Linux input device event for our HID device, one for the keyboard,
another for the mouse.

Then, we need to edit /etc/conf.d/lircd.conf. This file contains the
parameters for LIRC daemon

     #
     #Parameters for daemon
     #
     
     LIRC_DEVICE="/dev/input/by-id/usb-3353_3713-event-if00"
     LIRC_DRIVER="devinput"
     LIRC_EXTRAOPS=""
     LIRC_CONFIGFILE="/etc/lirc/lircd.conf"

Note:Here we set up a LIRC device with the id 3353_3713, you should
replace it with your own device input event name, whatever it is.

The latest version of the config file for HID remotes exists in the LIRC
git repository [1]. Simply save it as /etc/lirc/lircd.conf.

In order to launch the LIRC daemon for HID remote, You must enable evdev
module first

    # modprobe evdev

Note:LIRC 0.8.6 has changed the default socket location from /dev/lircd
to /var/run/lirc/lircd, but many applications still look for the socket
in the old location. Since lirc-utils 0.8.6-3 the /etc/rc.d/lircd script
creates a symlink from /dev/lircd to the /var/run/lirc/lircd socket when
it starts the lircd daemon and removes the link when the daemon is
stopped.

> Serial receivers that depend on lirc_serial

Make sure that your serial port is activated in the BIOS. There you can
also set and lookup I/O address and IRQ settings of your ports.

Now there might be a problem: the module lirc_serial is build to use
ttyS0 (COM1), if your device is not connected to ttyS0, you will have to
either change the module-options or rebuild the LIRC module. If your
device is connected to ttyS0, you can skip this step

To change the options for the lirc_serial module, you edit
/etc/modprobe.d/modprobe.conf and add this line:

    options lirc_serial io=0x2f8 irq=3

You should change the values after io and irq to reflect you serial port
settings, the values above may work for you if you are using ttyS1
(COM2) to connect your IR-device. But you will find the correct values
by checking dmesg:

    $ dmesg | grep ttyS

Building the lirc_serial module for another ttySx

Update abs

    # abs

Copy the LIRC files to a directory you choose yourself:

    $ cp /var/abs/extra/system/lirc /some/dir

    $ cd /some/dir

Edit the PKGBUILD in that directory.

Replace the line:

    ./configure --enable-sandboxed --prefix=/usr \
        --with-driver=all \\
        return 1[/code]

with:

    ./configure --enable-sandboxed --prefix=/usr \
        --with-driver=com2 \
        || return 1[/code]

Where you replace com2 with the com-port you need.

Build and install the package:

    $ makepkg
    # pacman -U lirc-version.pkg.tar.gz

Loading

Now try to load the serial module:

    # modprobe lirc_serial

If this produces an error which says your serial port is not ready, you
have the problem that your serial port support is build into the kernel
and not as a module (in the default arch kernel it is build into the
kernel)

If it is built into the kernel you will have to do the following
(remember that it is built into the kernel, you will need to make some
changes later too)

You will have to release the serial port:

    # setserial /dev/ttySx uart none

(Replace x with your port number)

Load the module again:

    # modprobe lirc_serial

Now it should not show any errors, and the modules lirc_serial should be
listed in lsmod

> Checking module based receivers

NOTE: This section only applies if your device requires a lirc_[driver]
kernel module.

Before you start using lirc, you should check if your receiver is
working, and if there is IR interference. Possible sources of
interference include monitors/televisions (especially plasma displays),
fluorescent lamps and direct or ambient sunlight. Start the following
command to display raw receiver input.

    # mode2 -d /dev/lirc0 

If you press buttons on any IR remote, you should see a series of pulses
and spaces. If there is very frequent output without pressing buttons on
your remote, your receiver suffers from interference. You want to avoid
such interference, e.g. by placing the receiver behind or under your
plasma tv.

If you can't make out where the interference is coming from, you can try
to put a cardboard roll right in front of the receiving diode, so that
it only gets light from a specific direction. Invoke mode2 as above.
Then point at different locations till you receive IR noise.

> Your serial port support is compiled as a module in the kernel

This is rather easy: you will just have to add lirc_serial to the
modules list and lircd to the daemons list in /etc/rc.conf

> Your serial port support is compiled into the kernel

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: initscripts is   
                           deprecated (Discuss)     
  ------------------------ ------------------------ ------------------------

This is more complicated, you cannot just add the lirc_serial to the
modules list in /etc/rc.conf, as the serial port should be released
first.

So I created a custom startup script to fix this problem.

    /etc/rc.d/start_lirc

    #!/bin/bash
    #/etc/rc.d/start_lirc
    #releases ttySx and loads lirc_serial module
     
    . /etc/rc.conf
    . /etc/rc.d/functions
     
    case "$1" in
      start)
        stat_busy "release ttySx"
        setserial /dev/ttySx uart none
        #load lirc module
        modprobe lirc_serial
        stat_done
        ;;
      stop)
        stat_busy "unload lirc module"
        rmmod lirc_serial
        stat_done
        ;;
      restart)
        $0 stop
        $0 start
        ;;
      *)
        echo "usage: $0 {start|stop|restart}"
    esac
    exit 0

Now load the daemons: add "start_lirc" and "lircd" to the daemons list
in /etc/rc.conf

See also
--------

-   MythTV Wiki:Remotes article
-   Official list of supported hardware

Retrieved from
"https://wiki.archlinux.org/index.php?title=LIRC&oldid=301760"

Categories:

-   Other hardware
-   Audio/Video

-   This page was last modified on 24 February 2014, at 15:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
