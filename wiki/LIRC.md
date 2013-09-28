LIRC
====

  Summary
  ---------------------------------------------------------------------
  This article covers using LIRC with serial or USB infrared devices.

LIRC stands for "Linux Infrared Remote Control", a program to use
infrared devices (like your remote control from your TV) with linux.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Supported hardware                                                 |
| -   2 Installation                                                       |
| -   3 Serial receivers                                                   |
|     -   3.1 Serial receivers that depend on lirc_serial                  |
|     -   3.2 Other serial receivers                                       |
|     -   3.3 Building the lirc_serial module for another ttySx            |
|     -   3.4 Loading                                                      |
|                                                                          |
| -   4 USB receivers including most onboard devices                       |
|     -   4.1 Setup a HID device with LIRC                                 |
|                                                                          |
| -   5 Other receivers                                                    |
| -   6 Checking module based receivers                                    |
| -   7 LIRC daemon configuration                                          |
| -   8 Making a configuration file                                        |
|     -   8.1 Testing                                                      |
|                                                                          |
| -   9 Run LIRC at bootup                                                 |
|     -   9.1 Your serial port support is compiled as a module in the      |
|         kernel                                                           |
|     -   9.2 Your serial port support is compiled into the kernel         |
|                                                                          |
| -   10 Program specific configuration                                    |
|     -   10.1 Generate your own lircrc with Mythbuntu's lircrc-generator  |
|     -   10.2 Enable LIRC support in xine                                 |
|         -   10.2.1 Compile xine with LIRC support                        |
|         -   10.2.2 Configure xine to use LIRC                            |
|                                                                          |
|     -   10.3 Configure Amarok2 to use LIRC                               |
|     -   10.4 Configure Audacious(2) to use LIRC                          |
|     -   10.5 Configure Mplayer to use LIRC                               |
|                                                                          |
| -   11 Device Specific Examples                                          |
|     -   11.1 X10                                                         |
|     -   11.2 Asus DH Deluxe series motherboard                           |
|     -   11.3 ASRock ION series (Nuvoton) quickstart                      |
|     -   11.4 Streamzap PC Remote (USB)                                   |
|     -   11.5 Serial Port "Home Brew" IR Receiver                         |
|     -   11.6 Receivers that do not depend on a kernel module             |
|                                                                          |
| -   12 Troubleshooting                                                   |
|     -   12.1 Buttons processed several times when pressed                |
|     -   12.2 After upgrading or installing Arch, an existing             |
|         configuration stopped working                                    |
|         -   12.2.1 Kernel module change                                  |
|                                                                          |
|     -   12.3 Problems using default systemd lirc.service file            |
|                                                                          |
| -   13 See also                                                          |
+--------------------------------------------------------------------------+

Supported hardware
------------------

First of all, check the official list of supported hardware. Check the
table to know, which LIRC kernel modules and lircd driver required for
your infrared receiver.

Installation
------------

Install the lirc-utils package, which is available in the official
repositories.

The most of LIRC kernel drivers are already included in the mainline
kernel. You need to install lirc package only, if your hardware requires
lirc_atiusb, lirc_i2c or lirc_wpc8769l modules.

Serial receivers
----------------

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

> Other serial receivers

See LIRC#Other_receivers

> Building the lirc_serial module for another ttySx

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

> Loading

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

USB receivers including most onboard devices
--------------------------------------------

This outlines the general procedure, the mceusb module which is used by
many devices is used as an example.

    # modprobe mceusb

Start the LIRC daemon:

    $ /etc/rc.d/lircd start

Test it with irw, it will output the commands received by the IR
receiver that match your lircd.conf file. So start irw, point your
remote and start pressing buttons.

    $ irw
    000000037ff07bfe 00 One mceusb
    000000037ff07bfd 00 Two mceusb
    000000037ff07bfd 01 Two mceusb
    000000037ff07bf2 00 Home mceusb
    000000037ff07bf2 01 Home mceusb

The above procedure however has been simplified and may not work that
easily. One of the reasons the lircd daemon may not be working is
because it expects to be run at startup and needs root permissions
because it will create device nodes in /dev. Try "man lircd" for more
information.

Continue with #Making a configuration file

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

Other receivers
---------------

There are many receivers that do not need any kernel module at all. This
applies to any type of receiver, including serial receivers and usb
receivers. Check the next link to see what kernel modules you need to
load, if any:

LIRC supported devices

Checking module based receivers
-------------------------------

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

LIRC daemon configuration
-------------------------

The lircd configuration lives under /etc/conf.d/lircd.conf, and it is
all you need to setup your device if it does not require any special
kernel module.

IMPORTANT:lirc-utils package on ArchLinux has a bug. You will have to
create your own systemd unit or find another workaround. See bug#31890

Making a configuration file
---------------------------

You need a configuration file for your remote control copied or
symlinked to /etc/lirc/lircd.conf. A number of devices have already been
included with the lirc package, they can be found in
/usr/share/lirc/remotes. If your specific device is not included, the
LIRC site offers configuration files for a large number of extra
devices.

If your device does not already have a config file, you can create it
yourself with the following command. You should avoid interference (see
above) while creating the config file.

    # irrecord -d /dev/lirc0 /tmp/my_remote

Just follow the instructions. To get a list of valid button names, refer
to the output of

    # irrecord --list-namespace

The resulting file, /tmp/my_remote, should then be copied to
/etc/lirc/lircd.conf. If you want to use several remotes, you repeat the
irrecord step with each remote and different filenames, and then
concatenate all the resulting files into /etc/lirc/lircd.conf:

    # cat /tmp/my_remote /tmp/my_remote2 /tmp/my_remote3 > /etc/lirc/lircd.conf

Note:As of lirc-0.8.6 the default location of lircd, lircmd and lircrcd
config files was moved to /etc/lirc/lircd.conf, /etc/lirc/lircmd.conf
and /etc/lirc/lircrc. If the config files are not found in that
location, they are still searched at the old location in /etc/.

> Testing

First start the lircd daemon:

    # /etc/rc.d/lircd start

A good way to see if LIRC is running is to run irw.

    $ irw

When you press a button, you should see something like this:

    0000000000000001 00 play sony2
    0000000000000001 01 play sony2
    0000000000000001 02 play sony2
    0000000000000001 03 play sony2

In this case the remote is called sony2, the button is called play, and
LIRC has seen it 4 times.

Run LIRC at bootup
------------------

Remember if you had to execute the setserial command while loading the
module?

If so, your serial port support is compiled into the kernel

> Your serial port support is compiled as a module in the kernel

This is rather easy: you will just have to add lirc_serial to the
modules list and lircd to the daemons list in /etc/rc.conf

> Your serial port support is compiled into the kernel

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

Program specific configuration
------------------------------

> Generate your own lircrc with Mythbuntu's lircrc-generator

mythbuntu-lircrc-generator is intended to be started from a system with
LIRC installed. It requires that you choose a remote via the LIRC
package or have a lircd.conf handy prior to running. It will then
produce a sane .lircrc for the current user.

Mythbuntu's Lirc/Lircrc Generator is available on AUR  
 Man page

> Enable LIRC support in xine

Now LIRC works, but you have no program that can communicate with LIRC.
This section will explain how to make xine work, but you can use xmms
and mplayer (and probably a lot of other programs too) to work with
LIRC.

Compile xine with LIRC support

Download the xine-ui PKGBUILD with ABS.

Add " --enable-lirc" to the ./configure line

Compile:

    $ makepkg

Uninstall old xine-ui and install the new one

    # pacman -R xine-ui
    # pacman -U xine-filename.pkg.tar.gz

Configure xine to use LIRC

Let xine produce a default .lircrc file. In your home directory, type:

    $ xine --keymap=lirc>.lircrc

Now, in order to have a functioning xine+lirc, edit the .lircrc file to
your preferences.

However, you may choose to configure LIRC to control more than just
xine. If this is the case, you will need to manually edit the .lircrc
file, and add elements.

Xine-ui Mplayer Totem Vlc Rhythmbox

All work with LIRC, but you must enable LIRC support in the program in
some cases, such as VLC. Simply copy the vlc packagebuild and edit it so
that "--enable-lirc" is one of the compile options for VLC not FFMPEG!

> Configure Amarok2 to use LIRC

Depending on your controller model, the following configuration works
with Amarok2-svn. This configuration file will work with the MCEUSB
controller.

    ~/.lircrc

    ##amarok2

    begin
    button = Play
    prog   = irexec
    repeat = 0
    config = qdbus org.mpris.amarok /Player Play
    end

    begin
    button = Pause
    prog   = irexec
    repeat = 0
    config = qdbus org.mpris.amarok /Player Pause
    end

    begin
    button = Stop
    prog   = irexec
    repeat = 0
    config = qdbus org.mpris.amarok /Player Stop
    end

    begin
    button = Skip
    prog   = irexec
    repeat = 0
    config = qdbus org.mpris.amarok /Player Next
    end

    begin
    button = Replay
    prog   = irexec
    repeat = 0
    config = qdbus org.mpris.amarok /Player Prev
    end

> Configure Audacious(2) to use LIRC

Depending on your controller model, the following configuration works
with all versions of Audacious, including the mercurial builds. This
configuration file will work with the MCEUSB controller.

    ~/.lircrc

    ##audacious

    begin
         prog = audacious
         button = Play
         config = PLAY
         repeat = 0
    end

    begin
         prog = audacious
         button = Pause
         config = PAUSE
         repeat = 0
    end

    begin
         prog = audacious
         button = Stop
         config = STOP
         repeat = 0
    end

    begin
         prog = audacious
         button = Skip
         config = NEXT
         repeat = 0
    end

    begin
         prog = audacious
         button = Replay
         config = PREV
         repeat = 0
    end

    begin
         prog = audacious
         button = VolUp
         config = VOL_UP
         repeat = 1
    end

    begin
         prog = audacious
         button = VolDown
         config = VOL_DOWN
         repeat = 1
    end

Additionally, there are other values that may be set according to the
model set forth above. This was taken from the lirc.c file from
audacious-plugins source code:

    lirc.c

    PLAY
    STOP
    PAUSE
    PLAYPAUSE
    NEXT
    PREV
    SHUFFLE
    REPEAT
    FWD
    BWD
    VOL_UP
    VOL_DOWN
    QUIT
    MUTE
    BAL_LEFT
    BAL_RIGHT
    BAL_CENTER
    LIST
    PLAYLIST_CLEAR
    PLAYLIST_ADD

> Configure Mplayer to use LIRC

    ~/.lircrc

    ##mplayer

    begin
        button = PLAY/PAUSE
        prog = mplayer
        config = pause
        repeat = 1
    end
    begin
        button = FWD
        prog = mplayer
        config = seek 5
    end
    begin
        button = REV
        prog = mplayer
        config = seek -5
    end
    begin
        button = MAXIMIZE
        prog = mplayer
        config = vo_fullscreen
    end

only change PLAY/PAUSE, FWD etc. on keys from your /etc/lircd.conf

Device Specific Examples
------------------------

> X10

There is a dedicated wiki page with information about X10

> Asus DH Deluxe series motherboard

Check the output of:

    $ cat /dev/usb/hiddevX

where X is 0,1 or bigger, and press some buttons on remote. If you can
see reply, device works fine, follow steps:  

1. In file /etc/conf.d/lircd.conf add:  

    LIRC_DRIVER="dvico"

2. Reload LIRC:

    /etc/rc.d/lircd restart

> ASRock ION series (Nuvoton) quickstart

    $ ln -s /usr/share/lirc/remotes/lirc_wb677/lircd.conf.wb677 /etc/lirc/lircd.conf
    $ /etc/rc.d/lircd restart

> Streamzap PC Remote (USB)

Note:Xorg now auto recognizes this remote as a keybaord!

To disable this behavior, add the following to
/etc/X11/xorg.conf.d/90-streamzap.conf:

    Section "InputClass"
      Identifier "Ignore Streamzap IR"
      MatchProduct "Streamzap"
      MatchIsKeyboard "true"
      Option "Ignore" "true"
    EndSection

1.  Install both packages (lirc lirc-utils)
2.  Modprobe both kernel mods (lirc_dev and streamzap) (add these to
    your MODULES array in /etc/rc.conf to survive a reboot)
3.  Create your /etc/lirc/lircd.conf (for this remote, copy
    /usr/share/lirc/remotes/streamzap/lircd.conf.streamzap to
    /etc/lirc/lircd.conf)
4.  Start lircd via /etc/rc.d/lircd start (add lircd to your DAEMONS
    array in /etc/rc.conf to survive a reboot)
5.  Test the remote/lirc with irw

    $ irw
    00000000000028cc 00 CH_UP Streamzap_PC_Remote
    00000000000028ce 00 CH_DOWN Streamzap_PC_Remote
    00000000000028c8 00 8 Streamzap_PC_Remote
    00000000000028c5 00 5 Streamzap_PC_Remote
    00000000000028d2 00 OK Streamzap_PC_Remote
    00000000000028d1 00 LEFT Streamzap_PC_Remote
    00000000000028d1 01 LEFT Streamzap_PC_Remote
    00000000000028d1 00 LEFT Streamzap_PC_Remote
    00000000000028d3 00 RIGHT Streamzap_PC_Remote
    00000000000028d3 00 RIGHT Streamzap_PC_Remote
    00000000000028d3 00 RIGHT Streamzap_PC_Remote
    00000000000028d3 00 RIGHT Streamzap_PC_Remote
    00000000000028d4 00 DOWN Streamzap_PC_Remote
    00000000000028d4 00 DOWN Streamzap_PC_Remote
    00000000000028d4 00 DOWN Streamzap_PC_Remote

Note:When the batteries in this remote are low, it may stop working even
though the red LED on the received still flashes when you hit buttons!

  

> Serial Port "Home Brew" IR Receiver

Here's how to get a "Home Brew" serial port IR receiver working:

1. Create a udev rule to give non-privleged users read/write access to
the serial port. I will be using ttyS0 in my example.

    /etc/udev/rules.d/z98-serial.rules

    # For serial port ttyS0 and LIRC
    KERNEL=="ttyS0",SUBSYSTEM=="tty",DRIVERS=="serial",MODE="0666"

2. Create the needed modprobe configs

    /etc/modules-load.d/lirc_serial.conf

    lirc_serial

    /etc/modprobe.d/lirc_serial.conf

    install lirc_serial /usr/bin/setserial /dev/ttyS0 uart none && /sbin/modprobe --first-time --ignore-install lirc_serial
    options lirc_serial type=0
    remove lirc_serial /sbin/modprobe -r --first-time --ignore-remove lirc_serial && /sbin/modprobe -r lirc_dev

Note:Using udev rules to run the setserial command does not work in my
experience because lirc_serial gets loaded before the serial port rules
are applied.

3. Install your systemd service file.

    /etc/systemd/system/lirc.service

    [Unit]
    Description=Linux Infrared Remote Control
    After=network.target

    [Service]
    Type=simple
    PIDFile=/run/lirc/lircd.pid
    ExecStartPre=/bin/rm -f /dev/lirc /dev/lircd /var/run/lirc/lircd
    ExecStart=/usr/sbin/lircd -n -r -P /run/lirc/lircd.pid -d /dev/lirc0 -o /run/lirc/lircd
    ExecStartPost=/usr/bin/ln -sf /run/lirc/lircd /dev/lircd
    ExecStartPost=/usr/bin/ln -sf /dev/lirc0 /dev/lirc
    ExecReload=/bin/kill -SIGHUP $MAINPID

    [Install]
    WantedBy=multi-user.target

4. We still need the default tmpfiles to be created, so copy that config
file to /etc/tmpfiles.d/lirc.conf.

    # cp -a /usr/lib/tmpfiles.d/lirc.conf /etc/tmpfiles.d/lirc.conf

5. Create a .lircrc file in your home directory for your user or a
/etc/lirc/lircrc file for system wide use.

6. Have your service start at boot and then test with a reboot

    # systemctl enable lirc.service
    # systemctl reboot

or load the module and start the lirc.service.

    # modprobe lirc_serial
    # systemctl start lirc.service

> Receivers that do not depend on a kernel module

Usually, you only need to specify your the device where the receiver is
plugged in and the lirc driver. This is an example for pinnacle or miro
serial receivers):

     LIRC_DEVICE="/dev/ttySX"
     LIRC_DRIVER="pinsys"

Then, start lircd daemon and create the remote/s configuration
(/etc/lirc/lircd.conf), either by copying one of the configured defaults
that comes with lirc-utils or by using irrecord. Even if you find your
remote in the list of preconfigured remotes it might not work so you
will have to use irrecord anyway.

After this you can use irw to check the remote, create your ~/.lircrc to
assign remote buttons to actions and start irexec if you need to run
arbitrary commands.

Troubleshooting
---------------

> Buttons processed several times when pressed

Problem in module ir_core which processes IR commands with LIRC at the
same time. Simply blacklist it by creating the following file:

    /etc/modprobe.d/remote_blacklist.conf

    # Prevent processing button several times when pressed
    blacklist ir_core

> After upgrading or installing Arch, an existing configuration stopped working

Kernel module change

As of kernel 2.6.36, LIRC modules have been included in the kernel.
Arch's lirc package has included the older kernel modules, which work
with lircd without any additional configuration. However, a recent
update removed those older modules, which results in the stock kernel
modules being used. Unfortunately, these kernel modules treat the remote
as a keyboard by default, which is incompatible for lircd. To correct
this, put the following line to /etc/rc.local:

    /etc/rc.local

    echo lirc > /sys/class/rc/rc0/protocols

You may also run that command as root to enable LIRC for your current
session.

Systemd has moved away from rc.local. It is possible to use tmpfiles.d
(read "man tmpfiles.d") to run the command
echo lirc > /sys/class/rc/rc0/protocols. Create the file
/etc/tmpfiles.d/lirc-protocols.conf:

    /etc/tmpfiles.d/lirc-protocols.conf

    w /sys/class/rc/rc0/protocols - - - - lirc

Note:It is also a good idea to remove the old LIRC kernel module from
your MODULES array in /etc/rc.conf, as it is no longer present.

> Problems using default systemd lirc.service file

There is a bug in lirc-utils that makes lirc.service ignore
/etc/conf.d/lircd.conf. See [FS#31890]

/var/log/lirc shows error finding /dev/lirc:

    lircd: could not get file information for /dev/lirc

Workaround: make a symbolic link for /dev/lirc that points to /dev/lirc0
with file

    /etc/tmpfiles.d/lirc-dev.conf

    L /dev/lirc - - - - /dev/lirc0

See also
--------

-   http://www.mythtv.org/wiki/Category:Remote_Controls -- MythTV wiki
    main LIRC article
-   http://www.mythtv.org/wiki/MCE_Remote -- MythTV wiki on MCE remotes
-   http://en.gentoo-wiki.com/wiki/LIRC -- Gentoo wiki LIRC how-to
-   https://aur.archlinux.org/packages.php?ID=33849 -- Lirc/Lircrc
    Configuration Generator

Retrieved from
"https://wiki.archlinux.org/index.php?title=LIRC&oldid=243275"

Categories:

-   Other hardware
-   Audio/Video
