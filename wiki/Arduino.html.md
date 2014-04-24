Arduino
=======

Arduino is an open-source electronics prototyping platform based on
flexible, easy-to-use hardware and software. It is intended for artists,
designers, hobbyists, and anyone interested in creating interactive
objects or environments. More information is available on the Arduino
HomePage.

Contents
--------

-   1 Installation
    -   1.1 Intel Galileo
-   2 Configuration
    -   2.1 Accessing serial
-   3 stty
-   4 Alternatives for IDE
    -   4.1 ArduIDE
    -   4.2 Arduino-CMake
    -   4.3 gnoduino
    -   4.4 Ino
    -   4.5 Makefile
    -   4.6 Scons
-   5 Troubleshooting
    -   5.1 Consistent naming of Arduino devices
    -   5.2 Error opening serial port
    -   5.3 Permissions to open serial port and create lockfile
    -   5.4 Missing twi.o
    -   5.5 Working with Uno/Mega2560
-   6 See also

Installation
------------

Warning:Arduino 1.0.5 has an issue that prevents uploading to Arduino
boards, it is recommend that you download the JSCC nightly build 32-bit
or 64-bit version until 1.5.6 BETA is released. You will also need to
have libusb-compat installed.

-   Install arduino from the AUR.
-   Add yourself to the uucp group. (More information in the next
    section: "Accessing serial")

> Intel Galileo

The version of the Arduino IDE that supports the Intel Galileo board can
be downloaded here.

Configuration
-------------

> Accessing serial

The arduino board communicates with the computer via a serial connection
or a serial over USB connection. So the user needs read/write access to
the serial device file. Udev creates files in /dev/tts/ owned by group
uucp so adding the user to the uucp group gives the required read/write
access.

    gpasswd -a $USER uucp

Note:You will have to logout and login again for this to take effect.

The arduino board appears as /dev/ttyACMx so if the above doesn't work
try adding the user to the group tty

    gpasswd -a $USER tty

Before uploading to the Arduino, be sure to set the correct serial port,
board, and processor from the Tools menu.

stty
----

Preparing:

    # stty -F /dev/ttyACM0 cs8 9600 ignbrk -brkint -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts

Sending commands through Terminal without new line after command

    # echo -n "Hello World" > /dev/ttyACM0

Note: As autoreset on serial connection is activated by default on most
boards, you need to disable this feature if you want to communicate
directly with your board with the last command instead of a terminal
emulator (arduino IDE, screen, picocom...). If you have a Leonardo
board, you are not concerned by this, because it does not autoreset. If
you have a Uno board, connect a 10 µF capacitor between the RESET and
GND pins. If you have another board, connect a 120 ohms resistor between
the RESET and 5V pins. See
http://playground.arduino.cc/Main/DisablingAutoResetOnSerialConnection
for more details.

Reading what your Arduino has to tell you

    $ cat /dev/ttyACM0

Alternatives for IDE
--------------------

> ArduIDE

ArduIDE is a Qt-based IDE for Arduino. arduide-git is available in the
AUR.

If you prefer working from terminal, below there are some other options
to choose from.

> Arduino-CMake

Using arduino-cmake and CMake you can build Arduino firmware from the
command line using multiple build systems. CMake lets you generate the
build system that fits your needs, using the tools you like. It can
generate any type of build system, from simple Makefiles, to complete
projects for Eclipse, Visual Studio, XCode, etc.

Requirements:

-   CMake
-   Arduino SDK
-   gcc-avr
-   binutils-avr
-   avr-libc
-   avrdude

> gnoduino

gnoduino is an implementation of original Arduino IDE for GNOME
available in the AUR. The original Arduino IDE software is written in
Java. This is a Python implementation and it is targeted at GNOME but
will work on xfce4 and other WM. Its purpose is to be light, while
maintaining compatibility with the original Arduino IDE. The source
editor is based on gtksourceview.

> Ino

Ino is a command line toolkit for working with arduino hardware. ino is
available in the AUR.

Note that Ino looks for the file avrdude.conf in
/etc/avrdude/avrdude.conf, while pacman appears to place this file (upon
installation of avrdude) in /etc/avrdude.conf. Create the directory
/etc/avrdude and make a symlink ( ln -s /etc/avrdude.conf
/etc/avrdude/avrdude.conf ) if ino gives you troubles.

> Makefile

Note:Update 2011-03-12. Arduino Is not shipping a Makefile with version
(22). The Makefile from the dogm128 project works for me though.

Instead of using the Arduino IDE it is possible to use another editor
and a Makefile.

Set up a directory to program your Arduino and copy the Makefile into
this directory. A copy of the Makefile can be obtained from
/usr/share/arduino/hardware/cores/arduino/Makefile

You will have to modify this a little bit to reflect your settings. The
makefile should be pretty self explanatory. Here are some lines you may
have to edit.

    PORT = usually /dev/ttyUSBx, where x is the usb serial port your arduino is plugged into
    TARGET = your sketch's name
    ARDUINO = /usr/share/arduino/lib/targets/arduino

Depending on which library functions you call in your sketch, you may
need to compile parts of the library. To do that you need to edit your
SRC and CXXSRC to include the required libraries.

Now you should be able to make && make upload to your board to execute
your sketch.

> Scons

Using scons together with arscons it is very easy to use to compile and
upload Arduino projects from the command line. Scons is based on python
and you will need python-pyserial to use the serial interface. Install
python-pyserial and scons.

That will get the dependencies you need too. You will also need Arduino
itself so install it as described above. Create project directory (eg.
test), then create a arduino project file in your new directory. Use the
same name as the directory and add .ino (eg. test.ino). Get the
SConstruct script from arscons and put it in your directory. Have a peek
in it and, if necessary, edit it. It is a python script. Edit your
project as you please, then run

    $ scons                # This will build the project
    $ scons upload         # This will upload the project to your Arduino

Troubleshooting
---------------

> Consistent naming of Arduino devices

If you have more than one arduino you may have noticed that they names
/dev/ttyUSB[0-9] are assigned in the order of connection. In the IDE
this is not so much of a problem, but when you have programmed your own
software to communicate with an arduino project in the background this
can be annoying. Use the following udev rules to assign static symlinks
to your arduino's:

    /etc/udev/rules.d/52-arduino.rules

    SUBSYSTEMS=="usb", KERNEL=="ttyUSB[0-9]*", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", SYMLINK+="sensors/ftdi_%s{serial}"

Your arduino's will be available under names like
"/dev/sensors/ftdi_A700dzaF". If you want you can also assign more
meaningfull names to several devices like this:

    /etc/udev/rules.d/52-arduino.rules

    SUBSYSTEMS=="usb", KERNEL=="ttyUSB[0-9]*", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", ATTRS{serial}=="A700dzaF", SYMLINK+="arduino/nano"

which will create a symlink in /dev/arduino/nano to the device with the
specified serialnumber. You do need to unplug and replug your arduino
for this to take effect or run

    udevadm trigger

> Error opening serial port

You may see the serial port initially when the IDE starts, but the TX/RX
leds do nothing when uploading. You may have previously changed the
baudrate in the serial monitor to something it does not like. Edit
~/.arduino/preferences.txt so that serial.debug_rate is a different
speed, like 115200.

> Permissions to open serial port and create lockfile

Arduino uses java-rxtx to do the serial communications. It expects to
create lock files in /var/lock/lockdev, so you need to be in the lock
group. USB serial devices such as /dev/ttyUSB0 or /dev/ttyACM0 will
often be assigned to the uucp group, so as long as you are adding
yourself to groups, you should add that one too.

> Missing twi.o

If the file /usr/share/arduino/lib/targets/libraries/Wire/utility/twi.o
does not exist arduino may try to create it. Normal users do not have
permission to write there so this will fail. Run arduino as root so it
can create the file, after the file has been created arduino can be run
under a normal user.

> Working with Uno/Mega2560

The Arduino Uno and Mega2560 have an onboard USB interface (an Atmel
8U2) that accepts serial data, so they are accessed through /dev/ttyACM0
created by the cdc-acm kernel module when it is plugged in.

The 8U2 firmware may need an update to ease serial communications. See
[1] for more details and reply #11 for a fix. The original arduino bbs,
where you can find an image explaining how to get your Uno into DFU, is
now in a read-only state. If you do not have an account to view the
image, see [2].

You can perform a general function test of the Uno by putting it in
loopback mode and typing characters into the arduino serial monitor at
115200 baud. It should echo the characters back to you. To put it in
loopback, short pins 0 -> 1 on the digital side and either hold the
reset button or short the GND -> RESET pins while you type.

See also
--------

-   https://bbs.archlinux.org/viewtopic.php?pid=295312
-   https://bbs.archlinux.org/viewtopic.php?pid=981348
-   http://answers.ros.org/question/9097/how-can-i-get-a-unique-device-path-for-my-arduinoftdi-device/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arduino&oldid=305936"

Categories:

-   Development
-   Mathematics and science

-   This page was last modified on 20 March 2014, at 17:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
