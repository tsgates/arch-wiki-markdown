Arduino
=======

Arduino is an open-source electronics prototyping platform based on
flexible, easy-to-use hardware and software. It is intended for artists,
designers, hobbyists, and anyone interested in creating interactive
objects or environments. More information is available on the Arduino
HomePage.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Arduino Due                                                  |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Accessing serial                                             |
|                                                                          |
| -   3 stty                                                               |
| -   4 Working with Uno/Mega2560                                          |
| -   5 Running Arduino Uno                                                |
| -   6 Alternatives for IDE                                               |
|     -   6.1 ArduIDE                                                      |
|     -   6.2 gnoduino                                                     |
|     -   6.3 Scons                                                        |
|     -   6.4 Makefile                                                     |
|     -   6.5 Arduino-CMake                                                |
|                                                                          |
| -   7 Troubleshooting                                                    |
|     -   7.1 delay() function does not work                               |
|     -   7.2 Error when launching Arduino IDE or uploading sketch         |
|     -   7.3 Error opening serial port                                    |
|     -   7.4 Arduino Mega2560 and new gcc-avr                             |
|     -   7.5 Arduino Mega2560 and deprecated items in avr-libc            |
|     -   7.6 Missing twi.o                                                |
|     -   7.7 Unable to upload sketch to your Arduino                      |
|     -   7.8 Consistent naming of arduino devices                         |
|                                                                          |
| -   8 Bugs                                                               |
| -   9 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

-   Install arduino from the AUR.
-   Add yourself to the uucp group. (More information in the next
    section: "Accessing serial")

> Arduino Due

You need the version 1.5beta of the arduino ide. You can download an
archive with the compiled version at the Arduino software download page.

Configuration
-------------

> Accessing serial

The arduino board communicates with the PC via a serial connection or a
serial over USB connection. So the user needs read/write access to the
serial device file. Udev creates files in /dev/tts/ owned by group uucp
so adding the user to the uucp group gives the required read/write
access.

    gpasswd -a <user> uucp

Note:You will have to logout and login again for this to take effect.

Briefly run the arduino command and stop it, then modify
~/.arduino/preferences.txt .

Change serial port from COM1 to your serial port. With your arduino
board connected, you can find out what your serial port is with:

     ls /dev/ttyUSB* /dev/ttyACM*

If in doubt, unconnect the board and look which of these disappears,
and/or monitor /var/log/everything.log.

The line to change in ~/.arduino/preferences.txt should look something
like this when you are done:

     serial.port=/dev/ttyACM3

Rerun arduino. If you get a message like "Arduino Uno on /dev/tty*"
message in the GUI's lower right corner, connection has been
established.

stty
----

Preparing

    stty -F /dev/ttyACM0 cs8 9600 ignbrk -brkint -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts

Sending commands through Terminal without new line after command

    echo -n "Hello World" > /dev/ttyACM0

Reading what your Arduino has to tell you

    cat /dev/ttyACM0

Working with Uno/Mega2560
-------------------------

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

Running Arduino Uno
-------------------

Once Arduino is running you must ensure you have selected the correct
board from the Tools->Boards menu item:

    Arduino Uno

Secondly you must ensure you have selected the correct serial port from
the Tools->Serial Port menu item as explained above.

Once these are done you should be able to write and upload sketches to
your Arduino Uno without any issues.

Alternatives for IDE
--------------------

> ArduIDE

ArduIDE is a Qt-based IDE for Arduino. arduide-git is available in the
AUR.

If you prefer working from terminal, below there are some other options
to choose from.

> gnoduino

gnoduino is an implementation of original Arduino IDE for GNOME
available in the AUR. The original Arduino IDE software is written in
Java. This is a Python implementation and it is targeted at GNOME but
will work on xfce4 and other WM. Its purpose is to be light, while
maintaining compatibility with the original Arduino IDE. The source
editor is based on gtksourceview.

> Scons

Using scons together with arscons it is very easy to use to compile and
upload Arduino projects from the command line. Scons is based on python
and you will need python-pyserial to use the serial interface. Install
everything with

    # pacman -S python-pyserial scons

That will get the dependencies you need too. You will also need Arduino
itself so install it as described above. Create project directory (eg.
test), then create a arduino project file in your new directory. Use the
same name as the directory and add .pde (eg. test.pde). Get the
SConstruct script from arscons and put it in your directory. Have a peek
in it and, if necessary, edit it. It is a python script. Edit your
project as you please, then run

    $ scons                # This will build the project
    $ scons upload         # This will upload the project to your Arduino

> Makefile

Update 2011-03-12. Arduino Is not shipping a Makefile with version (22).
The Makefile from the dogm128 project works for me though.

Instead of using the arduino IDE it is possible to use another editor
and a Makefile.

Set up a directory to program your Arduino and copy the Makefile into
this directory. A copy of the Makefile can be obtained from
/usr/share/arduino/hardware/cores/arduino/Makefile

You will have to modify this a little bit to reflect your settings. The
makefile should be pretty self explainatory. Here are some lines you may
have to edit.

    PORT = usually /dev/ttyUSBx, where x is the usb serial port your arduino is plugged into
    TARGET = your sketch's name
    ARDUINO = /usr/share/arduino/lib/targets/arduino

Depending on which library functions you call in your sketch, you may
need to compile parts of the library. To do that you need to edit your
SRC and CXXSRC to include the required libraries.

Now you should be able to make && make upload to your board to execute
your sketch.

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

Troubleshooting
---------------

> delay() function does not work

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: the current      
                           arduino-git package is   
                           reported in the talk     
                           page as not being        
                           affected by this issue.  
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

There are some cases where the delay() function does not work, causing
programs such as the example Blink to malfunction. It appears that the
Arch compiler sometimes generates code that writes to addresses before
the start of memory. RAM starts at address 0x200 on the mega, but the
Blink code has the delay() timer variables located at 0x100-0x10b. This
only seems to happen when the code contains no initialized global
variables (.data segment in asm-speak) - the linker is told that the
data segment starts at 0x200, but if there is nothing to go in it it
generates an incorrect start address for the uninitialized global
variables (.bss segment). Since the timer variables are uninitialized
globals (or globals initialized to zero) they end up at an illegal
address.

There are currently two ways to bypass this issue.

-   Use Serial.begin(9600); in setup() function. [Source post]

    /*
      Blink
      Turns on an LED on for one second, then off for one second, repeatedly.
     
      This example code is in the public domain.
     */

    void setup() {                
      // initialize the digital pin as an output.
      // Pin 13 has an LED connected on most Arduino boards:
      pinMode(13, OUTPUT);     
      Serial.begin(9600);
    }

    void loop() {
      digitalWrite(13, HIGH);   // set the LED on
      delay(1000);              // wait for a second
      digitalWrite(13, LOW);    // set the LED off
      delay(1000);              // wait for a second
    }

-   Use an initialized global variable. [Source post]

    char dummyvariablecuzmaintainerborkedthecompiler = 123; // force something into the .data segment with non-zero initializer
    /*
      Blink
      Turns on an LED on for one second, then off for one second, repeatedly.
     
      This example code is in the public domain.
     */

    void setup() {  
      dummyvariablecuzmaintainerborkedthecompiler++;  // stops the linker from removing the global variable
      
      // initialize the digital pin as an output.
      // Pin 13 has an LED connected on most Arduino boards:
      pinMode(13, OUTPUT);     
    }

    void loop() {
      digitalWrite(13, HIGH);   // set the LED on
      delay(1000);              // wait for a second
      digitalWrite(13, LOW);    // set the LED off
      delay(1000);              // wait for a second
    }

Related pages:

-   http://arduino.cc/forum/index.php/topic,56841.0.html
-   http://arduino.cc/forum/index.php/topic,49900.0.html
-   http://arduino.cc/forum/index.php?topic=59409.0.html

Fedora has the same problem with binutils 2.21 (bug report). Downgraded
packages that work are binutils-avr 2.20.1-3 and gcc-avr 4.5.1-2. There
is also an upstream bug report here but no one has replied yet.

> Error when launching Arduino IDE or uploading sketch

If you run the Arduino IDE as a normal user (you should do that of
course), you may get this error message : check_group_uucp(): error
testing lock file creation Error details:Permission denied

You may also find that your Tools > Serial Port menu is greyed out, and
you get this error message when attempting to upload a sketch: Serial
port '/dev/ttyACM0' not found. Did you select the right one from the
Tools > Serial Port menu?

Either way, this is probably because you don't have write permissions on
/run/lock directory. Try this to see if this solves your problem :

    sudo chmod 777 /run/lock

/run/lock is created on boot by /usr/lib/tmpfiles.d/legacy.conf (both on
systemd and initscripts). To make the permissions permanent, copy the
file /usr/lib/tmpfiles.d/legacy.conf to /etc/tmpfiles.d/ and edit it
there. Find the line that sets the permissions of /run/lock and change
it to

    d /run/lock 0775 root lock -

Then add yourself to the lock group using

    gpasswd -a username lock

and reboot.

> Error opening serial port

You may see the serial port initially when the IDE starts, but the TX/RX
leds do nothing when uploading. You may have previously changed the
baudrate in the serial monitor to something it does not like. Edit
~/.arduino/preferences.txt so that serial.debug_rate is a different
speed, like 115200.

> Arduino Mega2560 and new gcc-avr

If you are using gcc-avr >= 4.3.5 then there is a C++ bug in the gcc-avr
toolchain which builds bad firmware for the Atmel2560 processors.
gcc-avr must be rebuilt using a patch found at [3]. You can read more
about the problems at [4]. This bug has been fixed in 4.7.0 and
backported to 4.5.4 [5].

Here is the patch for gcc:

    --- gcc-4.5.1.orig/gcc/config/avr/libgcc.S	2009-05-23 17:16:07 +1000
    +++ gcc-4.5.1/gcc/config/avr/libgcc.S	2010-08-12 09:38:05 +1000
    @@ -802,7 +802,9 @@
     	mov_h	r31, r29
     	mov_l	r30, r28
     	out     __RAMPZ__, r20
    +	push	r20
     	XCALL	__tablejump_elpm__
    +	pop	r20
     .L__do_global_ctors_start:
     	cpi	r28, lo8(__ctors_start)
     	cpc	r29, r17
    @@ -843,7 +845,9 @@
     	mov_h	r31, r29
     	mov_l	r30, r28
     	out     __RAMPZ__, r20
    +	push	r20
     	XCALL	__tablejump_elpm__
    +	pop	r20
     .L__do_global_dtors_start:
     	cpi	r28, lo8(__dtors_end)
     	cpc	r29, r17

The easiest way to rebuild gcc-avr is using ABS and makepkg.

> Arduino Mega2560 and deprecated items in avr-libc

The following error is known to occur when compiling using avr-libc
versions newer than 1.8.0 with the Arduino Mega 2560.

    build/core/HardwareSerial.cpp:107:41: error: attempt to use poisoned "SIG_USART0_RECV"
     #if !defined(USART_RX_vect) && !defined(SIG_USART0_RECV) && \
                                             ^
    build/core/HardwareSerial.cpp:117:15: error: attempt to use poisoned "SIG_USART0_RECV"
     #elif defined(SIG_USART0_RECV)
                   ^
    build/core/HardwareSerial.cpp:161:15: error: attempt to use poisoned "SIG_USART1_RECV"
     #elif defined(SIG_USART1_RECV)
                   ^
    build/core/HardwareSerial.cpp:178:15: error: attempt to use poisoned "SIG_USART2_RECV"
     #elif defined(SIG_USART2_RECV)
                   ^
    build/core/HardwareSerial.cpp:195:15: error: attempt to use poisoned "SIG_USART3_RECV"
     #elif defined(SIG_USART3_RECV)

This problem is discussed in further detail here. To fix this, you need
to enable deprecated avr-libc items in an Arduino header file.

    /usr/share/arduino/hardware/arduino/cores/arduino/Arduino.h

    #ifndef Arduino_h
    #define Arduino_h

    // start: fix the compatibility issue
    #define __AVR_LIBC_DEPRECATED_ENABLE__ 1
    // end: fix the compatibility issue

    #include <stdlib.h>
    ...

> Missing twi.o

If the file /usr/share/arduino/lib/targets/libraries/Wire/utility/twi.o
does not exist arduino may try to create it. Normal users do not have
permission to write there so this will fail. Run arduino as root so it
can create the file, after the file has been created arduino can be run
under a normal user.

> Unable to upload sketch to your Arduino

Install the rxtx package from the AUR. That package is the working Java
library for Serial IO.

> Consistent naming of arduino devices

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

Bugs
----

This section is targeted at the package maintainers.

  Symptom                  Cause / Upstream bug report              Patches / Workarounds   Patched Packages / End-User solutions
  ------------------------ ---------------------------------------- ----------------------- ---------------------------------------
  delay() sleeps forever    ???                                     workaround              none
  progmem error            bug in gcc-avr (fixed, but unreleased)   workaround              aur/gcc-avr-svn or aur/arduino

See also
--------

-   https://bbs.archlinux.org/viewtopic.php?pid=295312
-   http://regomodoslinux.blogspot.com/2007/10/how-to-install-arduino-ide-in-archlinux.html
-   http://gunnewiek.com/2011/open-pde-files-with-arduino-ide-in-linux/
-   https://bbs.archlinux.org/viewtopic.php?pid=981348
-   http://answers.ros.org/question/9097/how-can-i-get-a-unique-device-path-for-my-arduinoftdi-device/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arduino&oldid=256131"

Categories:

-   Development
-   Mathematics and science
