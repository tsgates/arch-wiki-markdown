Samsung Series 7 Slate XE700T1A
===============================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 System Specification                                               |
| -   2 Installation                                                       |
| -   3 Network                                                            |
|     -   3.1 Wireless                                                     |
|     -   3.2 Bluetooth                                                    |
|                                                                          |
| -   4 Buttons                                                            |
| -   5 Graphics                                                           |
| -   6 TouchScreen                                                        |
|     -   6.1 Screen Rotation                                              |
|         -   6.1.1 Rotate on button press (Gnome)                         |
|                                                                          |
|     -   6.2 Multitouch                                                   |
|                                                                          |
| -   7 Accelerometer/Magenetometer                                        |
| -   8 Sound                                                              |
| -   9 Webcam                                                             |
| -   10 Accessories                                                       |
|     -   10.1 Dock                                                        |
|     -   10.2 Keyboard                                                    |
|     -   10.3 Stylus                                                      |
+--------------------------------------------------------------------------+

System Specification
--------------------

-   CPU: Intel® Core™ i5 Processor 2467M (1.6GHz, 3MB L3 Cache)
-   Memory: 4GB DDR3 System Memory at 1333MHz
-   Hard-Drive: 64GB Solid-state Drive (128GB is also available)
-   Screen: 11.6" LCD (1366x768)
-   Integrated Graphics: Intel® HD Graphics 3000
-   Touchscreen: Atmel maXTouch Digitizer (10 points)
-   Accelerometer: STMicroelectronics 6-Axis Accelerometer/Magnetometer
    (LSM303DLH)
-   WiFi: Intel® Centrino® Advanced-N 6230, 2 x 2 802.11abg/n
-   Bluetooth: Bluetooth 3.0

Installation
------------

Getting into and navigating the BIOS is a challenge in itself.

-   Turn the Tablet on and then press the home button a few times.
-   A menu will come, up but only briefly, you must press one of the
    volume rocker buttons before it disappears. Pressing the home button
    at this point will close this dialogue so do not keep pressing the
    home button for too long.
-   Select the setup option with the volume rockers and then press the
    screen lock button to select it. The BIOS will now load.

To get directly into the BIOS menu, and to skip the above menu, it is
generally much easier to simply hold the home button after pressing the
power button until the menu pops up.

To Navigate the BIOS, the home, button is escape, the lock button is
enter, the volume rocker buttons are up and down and the volume rocker
buttons and the lock button pressed simultaneously are left and right.

Use this to enable Legacy USB. This allowed me to use a USB keyboard,
and gave me the option to boot from USB. From here it's your classic
Arch install. (Official Installation Guide)

Network
-------

> Wireless

The wireless chip works out of the box, both with network and
network-manager. However, if you put the networkmanager daemon before
the display manager, if you have one, it wireless can sometimes cut out.

> Bluetooth

Simply install bluez, and whatever front-end (or lack thereof) you like.
Enable on startup with systemd by running

    # systemctl enable bluetooth.service

Buttons
-------

The volume rocker buttons and power button seem to be recognised by
default. How the rotation lock and home buttons do not.

Press the lock button and the home button, then run

    $ dmesg | tail

You should get an output like this

    [11888.422895] atkbd serio0: Use 'setkeycodes e027 <keycode>' to make it known.
    [11888.664814] atkbd serio0: Unknown key released (translated set 2, code 0xa7 on isa0060/serio0).
    [11888.664820] atkbd serio0: Use 'setkeycodes e027 <keycode>' to make it known.
    [11890.058469] atkbd serio0: Unknown key pressed (translated set 2, code 0xad on isa0060/serio0).
    [11890.058476] atkbd serio0: Use 'setkeycodes e02d <keycode>' to make it known.
    [11890.058941] atkbd serio0: Unknown key released (translated set 2, code 0xad on isa0060/serio0).
    [11890.058947] atkbd serio0: Use 'setkeycodes e02d <keycode>' to make it known.

See the following article, Setkeycodes, on how to set up these 2 keys.

In addition to that article, before run setkeycodes, you can easily
check whether the key you are about to set it to is already set by
running

    # getkeycodes | grep ###

where ### is your desired keycode.

It is also worth noting, that if you want to use it for a shortcut in
Gnome, then you have to try a few different keys, as it's easy to choose
a value which Gnome won't allow as it may be a letter in a foreign
alphabet or similar. Gnome also won't seem to let you use a value which
is not set to anything, so you basically need to find some really
obscure keys to use.

In the end I went for 167 (Audio Record) and 171 (Tools)

Graphics
--------

The xf86-video-intel driver works well with no need for an
configuration.

The brightness is most easily changed using the ACPI method detailed on
the Backlight#ACPI page.

TouchScreen
-----------

The touch screen works out of the box (all-be-it only single touch) with
x86-input-evdev and the pen works almost perfectly with x86-input-wacom.

In order to get the pen button to emulate a right click, go into the
Wacom settings in System Preferences.

  

> Screen Rotation

If you like to use the tablet in portrait mode, or some other
orientation than, normal. Simply setting the screen rotation isn't
enough since the touchscreen and wacom inputs will still be calibrated
to the standard landscape mode.

The touchscreen is calibrated via axis inversion and axes swap. Swapping
the axes basically means that the x axis becomes the y and vice verse.
Inverting the axis swaps up and down or left and right.

The wacom tablet however, simply uses a number, 0, 1, 2 or 3, however,
these don't correspond to the XRandR numbers.

  Orientation   XRandR   Evdev Axis Inversion   Evdev Axis Swap   Wacom Rotation
  ------------- -------- ---------------------- ----------------- ----------------
  0°            0        0 0                    0                 0
  90°           1        1 0                    1                 2
  180°          2        1 1                    0                 3
  270°          3        0 1                    1                 1

For non-permanent rotations, there is a simple sh script. Download
slate.sh

To rotate 90°

    $ ./shate.sh -r

To rotate to a specific XRandR position

    $ ./slate.sh -r [0|1|2|3]

Rotate on button press (Gnome)

You can set the screen to rotate when you press a key combination, or
the side buttons if you have set them up #Buttons above. Go to System
Settings > Keyboard > Shortcuts > Custom Shortcuts Click the add button
and under the commans, add the path to slate.sh -r. Eg:

    /home/USERNAME/scripts/slate.sh -r

Then add. You can now set a shortcut by clicking on it, and pressing the
keys you want.

> Multitouch

To get multitouch working, install xf86-input-evdev-multitouch-git from
the AUR and mtdev from Extra. I also installed ginn and all Ubuntu's
uTouch (dependencies of ginn). The default setup gave me 2 finger
scrolling in all the apps I tested.

You can test multitouch by running:

    # mtview /dev/input/event##

I recommend using the pen to make the window full screen.

I order to get per pixel scrolling rather than just relying on gestures,
install gtk3-ubuntu. It currently seems a bit buggy for me perhaps it
should be left to the more adventurous.

Accelerometer/Magenetometer
---------------------------

The Series 7 Slate, as far as I can tell uses a STMicroelectronics
LSM303DLH Accelerometer/Magenetometer. I am currently trying to get that
up and running. Once I do, I'll post instructions on the LSM303DLH page.

Sound
-----

After installing Gnome, the sound works without any extras. The rocker
buttons on the side also work without any problems.

Webcam
------

The to get the webcam to work, gstreamer0.10-bad-plugins or similar is
required.

Accessories
-----------

> Dock

I have had no issues with the dock. It seems to be working as expected.

> Keyboard

There are instructions on how to set up a Bluetooth Keyboard, however,
if you have Gnome installed, run System Settings > Bluetooth. Make sure
bluetooth is on. Now press and hold the power button on the keyboard
until the LED starts to blink.

Back in the Bluetooth window on the tablet, press the + button below the
list of devices. This will take you through a wizard which will pair the
keyboard for you. When it gives a code, simply type it in on the
keyboard and press enter.

If you make a mistake, the backspace key works as expected.

> Stylus

If you have installed the wacom driver, the stylus works fine.

I use xournal for writing notes, and found enabling, "Use XInput",
"Eraser Tip" and "Pressure sensitivity", as well as setting "Button 3
Mapping" to "Eraser" gave the best, and expected results.

The only issue I had was that I like to rest my hand while writing,
which of course meant it was registering on the touch screen. Since the
touch screen and stylus are independent, you can disable the touch
screen with the command

    $ xinput set-prop 13 "Device Enabled" 0

and then re-enable it again with

    $ xinput set-prop 13 "Device Enabled" 1

While the touch screen is disabled, the pen still works as expected,
meaning that you can write your notes, whilst resting you hand on the
tablet.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samsung_Series_7_Slate_XE700T1A&oldid=246731"

Category:

-   Samsung
