TalkingArch
===========

This page describes a bootable CD / USB image customized for blind
users. The modified version is mostly equivalent to the official
"netinstall CD", but the system should start speaking as soon as you
boot with it. Speech is provided via the sound card, using the eSpeak
software synthesizer and the Speakup screenreader. It is also possible
to use a braille display, via brltty. You can obtain the image from this
page.

The image can be used with both the i686 and the x86_64 architecture.
Also, it is suitable for either a recordable CD or a USB stick. Just
download it and write it to the medium of your choice.

A detached GPG signature is provided on the download page. The signature
for the current iso build is made with the gpg key associated with the
address kyle at gmx dot ca with ID CD915EAD and fingerprint 1E14 FA26
0F57 7600 7047 9320 0DD7 721A DC85 709B, and the key associated with the
address kprescott at coolip dot net with ID 75689861 and fingerprint
C6A7 7B5C 1989 9997 DF34 196E BE8F DD31 7568 9861. These keys can be
found on your favorite OpenPGP-compatible keyserver.

Contents
--------

-   1 Credits
-   2 Installing from the CD
-   3 Braille Support
-   4 Maintaining Your Speech-enabled Arch Linux Installation
-   5 Mastering Speech-enabled ISO Images
-   6 Further Resources
-   7 Disclaimer

> Credits

The build system, which is a respin of the Archiso releng configuration,
is maintained by Kelly Prescott and by Kyle, and the images and main
website are hosted by Kyle. Thanks to Chris Brannon, the past
maintainer, and to the following people for submitting valuable feedback
regarding this project: Chuck Hallenbeck, Julien Claassen, Alastair
Irving, Tyler Spivey, Keith Hinton, and many others. Thanks also go to
Tyler Littlefield, who previously hosted the files.

Installing from the CD
----------------------

The following list of steps is a brief guide to installing Arch Linux
using this CD. The instructions assume that your root partition will be
mounted on /mnt.

1.  This is a dual-architecture .iso file. You can just press enter at
    the boot prompt, or wait for the bootloader to time-out. Your
    processor should be automatically detected, and the appropriate
    architecture should be loaded automatically. If you have a console
    speaker, you will hear a beep when the boot prompt is on screen.
    Otherwise, wait about 10 to 20 seconds after the CD starts spinning,
    or about 3 to 5 seconds after the system begins to boot from USB,
    and then press enter to boot the image.
2.  You are strongly encouraged to read the Arch Linux documentation,
    especially the Installation guide and Beginners' guide. Do the
    installation procedure described in the Installation guide, as
    modified by the instructions below.
3.  You'll need to install the espeakup and alsa-utils packages. The
    Installation guide mentions that you can install additional packages
    by appending their names to the packstrap command. For example,
    pacstrap /mnt base espeakup alsa-utils
4.  If you heard a voice recording informing you that multiple sound
    cards were detected, and you selected a card by pressing enter at
    the beep, a /etc/asound.conf file was generated that will configure
    ALSA to use your selected card as the default. You will need to copy
    this file by executing cp /etc/asound.conf /mnt/etc
5.  While in the arch-chroot, Enable the espeakup systemd service by
    executing systemctl enable espeakup.service
6.  You also need to save the state of the sound card, so that it will
    be retrieved on reboot. Execute the command alsactl store from
    inside of the arch-chroot.
7.  When you boot the system from the hard disk, it should start
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

TalkingArch now has an IRC channel at #talkingarch on irc.freenode.net.
Feel free to drop in and talk to the maintainers or anyone else in the
channel. You may also reach the maintainers by e-mail at support [at]
talkingarch [dot] tk.

Disclaimer
----------

This is not an official release. It is not endorsed by anyone other than
its maintainers. It is provided solely for the convenience of blind and
visually impaired users, and it comes with absolutely no warranty.

Retrieved from
"https://wiki.archlinux.org/index.php?title=TalkingArch&oldid=303907"

Categories:

-   Getting and installing Arch
-   Accessibility

-   This page was last modified on 10 March 2014, at 15:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
