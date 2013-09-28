Arch Linux for the blind
========================

This page describes a bootable CD / USB image customized for blind
users. The modified version is mostly equivalent to the official
"netinstall CD", but the system should start speaking as soon as you
boot with it. Speech is provided via the sound card, using the eSpeak
software synthesizer and the Speakup screenreader. It is also possible
to use a braille display, via brltty. You can obtain the image from this
page.

The image can be used with both the i686 or the x86_64 architecture.
Also, it is suitable for either a recordable CD or a USB stick. Just
download it and write it to the medium of your choice.

A detached GPG signature is provided on the download page. The signature
is made with the gpg key associated with the address chris at
the-brannons dot com. The key ID is 6521E06D. The fingerprint is 66BD
74A0 36D5 22F5 1DD7 0A3C 7F2A 1672 6521 E06D

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Credits                                                            |
| -   2 Installing from the CD                                             |
| -   3 Braille Support                                                    |
| -   4 Maintaining Your Speech-enabled Arch Linux Installation            |
| -   5 Mastering Speech-enabled ISO Images                                |
| -   6 Further Resources                                                  |
| -   7 Disclaimer                                                         |
+--------------------------------------------------------------------------+

> Credits

The images are produced and hosted by Chris Brannon. Thanks to the
following people for submitting valuable feedback regarding this
project: Chuck Hallenbeck, Julien Claassen, Alastair Irving, Tyler
Spivey, Keith Hinton, and many others. Thanks also go to Tyler
Littlefield, who previously hosted the files.

Installing from the CD
----------------------

The following list of steps is a brief guide to installing Arch Linux
using this CD. The instructions assume that your root partition will be
mounted on /mnt.

1.  This is a dual-architecture .iso file. If you're booting on an i686
    machine, then you can just press enter at the boot prompt, or wait
    for the bootloader to time-out. If you're booting on an x86_64
    system, then do this. Wait for the boot prompt. If you're lucky,
    then you have a console speaker, and you'll hear a beep when the
    bootloader is ready. If you don't have a console speaker, just wait
    for your CD-ROM drive to stop spinning, or alternatively, wait 20 or
    30 seconds when booting from USB. Once you've reached the boot
    prompt, press escape and type arch64 and press enter.
2.  You are strongly encouraged to read the Arch Linux documentation,
    especially the Installation Guide and Beginners Guide. Do the
    installation procedure described in the Installation Guide, as
    modified by the instructions below.
3.  You'll need to install the espeakup and alsa-utils packages. The
    Installation Guide mentions that you can install additional packages
    by appending their names to the packstrap command. For example,
    pacstrap /mnt base espeakup alsa-utils
4.  Enable the espeakup systemd service by typing
    chroot /mnt systemctl enable espeakup.service
5.  You also need to save the state of the sound card, so that it will
    be retrieved on reboot. Execute the command
    alsactl -f /var/lib/alsa/asound.state store and copy the file
    /var/lib/alsa/asound.state to /mnt/var/lib/alsa/asound.state.
    Alternatively, alsactl -f /mnt/var/lib/alsa/asound.state store will
    do this with one command.
6.  When you boot the system from the hard disk, it should start
    speaking.

Braille Support
---------------

The latest image includes brltty, for those who own braille displays.
The brltty package available on the CD was compiled with as few
dependencies as possible. It is packaged as brltty-minimal in the Arch
User Repository. If you wish to use braille, you will need to supply the
brltty parameter at the boot prompt. Alternatively, you can start brltty
from the shell, after the system has booted.

The brltty boot-time parameter consists of three comma-separated fields:
driver, device, and table. The first is the driver for your display, the
second is the name of the device file, and the third is a relative path
to a translation table. You can use "auto" to specify that the driver
should be automatically detected. I encourage you to read the brltty
documentation for a fuller explanation of the program.

For example, suppose that you have a device connected to /dev/ttyS0, the
first serial port. You wish to use the US English text table, and the
driver should be automatically detected. Here is what you should type at
the boot prompt:

    arch32 brltty=auto,ttyS0,en_US

Once brltty is running, you may wish to disable speech. You can do so
via the "print screen" key, also known as sysrq. On my qwerty keyboard,
that key is located directly above the insert key, between F12 and
scroll lock.

Maintaining Your Speech-enabled Arch Linux Installation
-------------------------------------------------------

You shouldn't need to do anything extraordinary to maintain the
installation. Everything should just seamlessly work.

Mastering Speech-enabled ISO Images
-----------------------------------

This process is now fairly straightforward. Just grab and install the
talkingarch-git package from the AUR. It depends on archiso-git, so you
need that as well. See /usr/share/doc/talkingarch/README for full
instructions.

Further Resources
-----------------

Michael Whapples made an audio tutorial demonstrating the process of
installing ArchLinux using this CD. Click here to listen to it! Note
that it is out of date, as of the 2012.07.23 snapshot.

Disclaimer
----------

This is not an official release. It is not endorsed by anyone other than
Chris Brannon. It is provided solely for the convenience of its creator
and other blind users, and it comes with absolutely no warranty.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_Linux_for_the_blind&oldid=236820"

Categories:

-   Getting and installing Arch
-   Accessibility
