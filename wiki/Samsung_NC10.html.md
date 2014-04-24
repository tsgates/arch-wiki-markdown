Samsung NC10
============

This article aims to provide information on installing and setting up
Arch Linux on the Samsung NC10.

A lot of the information is derived from the Arch Forum, and from
several hints scattered around in the ArchWiki.

Contents
--------

-   1 Common issues
-   2 Installation
-   3 Configure your installation
    -   3.1 Network
    -   3.2 Video
    -   3.3 Initial brightness
    -   3.4 Graphics adapter
        -   3.4.1 External VGA
    -   3.5 Audio
    -   3.6 Suspend and hibernate
    -   3.7 Fn keys
    -   3.8 Power saving
    -   3.9 BIOS

Common issues
-------------

-   using KMS (as of xorg-video-intel 2.8.1), No brightness control with
    xbacklight. (workaround with setpci, the issue might be solved with
    the next intel driver 2.9)
-   On kernel 2.6.29 :
    -   webccam works perfectly.
    -   All fn-keys can be bound, except fn-f4
    -   Suspend to ram and to disk work perfectly (without any quirks)
    -   rfkill controls for bluetooth and Wifi do not work (but it's
        possible to write a script to do it and bind it to the propper
        key with xbindkeys)
-   On kernel 2.6.30 :
    -   webcam stopped working correctly.
    -   fastboot feature (not NC10 specific)
-   On kernel 2.6.31 :
    -   webcam is working again
    -   rfkill interface is working.
-   On kernel 3.6.2-1 and 3.6.3-1:
    -   system will not boot unless acpi=off is added as kernel
        parameter
    -   "dmesg | grep microcode" will show "Atom PSE erratum detected",
        see Microcode page for a solution

Installation
------------

Use the USB image provided at the official download locations or the ISO
if you have an external optical drive. You can also use unetbootin to
easily create a boot device. If you use an usbkey, be aware that you
must (arguably) format it in FAT32.

Configure your installation
---------------------------

> Network

LAN uses the sky2 module and should work out-of-the-box. Kernels prior
to 2.6.37 use the ath5k module for WLAN. Later kernels use
brcmsmac/brcmfmac and may require blacklisting bcma. See Broadcom
wireless#brcmsmac/brcmfmac for details.

> Video

> Initial brightness

The brightness can be set with the following command:

    setpci -s 00:02.1 F4.B=FF

Where FF is the highest level of brightness. This parameter moves in the
range 00 to FF. Don't set it too low otherwise your backlight will turn
off!

> Graphics adapter

The Video controller is a typical Intel chipset that works with the
xf86-video-intel driver.

To save some interrupts, and therefore power, you can disable dri in
your xorg.conf. This disables 3D effects; however if you do not need
them this could be an option.

    Section "Device"
    Option "NoDRI"
    Identifier "Card0"
    Driver "intel"
    VendorName "Intel Corporation"
    BoardName "Mobile 945GME Express Integrated Graphics Controller"
    BusID "PCI:0:2:0"
    EndSection

External VGA

External VGA works out of the box with xorg-xrandr.

In order to prevent problems when switching to console or when
unplugging the external monitor, make sure to specify the frequency
along with the mode, for example :

    xrandr --output VGA --mode 1280x1024 --rate 60

Dual head positioning works also perfectly: Xorg#Multiple monitors.

> Audio

The audio device is an Intel HD. You will need to follow the
instructions at ALSA#No_Sound_with_Onboard_Intel_Sound_Card to get
output from the main speakers.

Since alsa 1.0.19 distributed in Archlinux repositories, you do not need
to manually install alsa driver. Everything is working out of the box:
onboard microphone and speakers, audio off on earphone plugging.

> Troubleshooting :

-   If the volume is too low, or lower than in Windows run alsamixer,
    and set "front" to 100%.

-   If the microphone does not work, press F4 in alsamixer and play with
    the settings (boost to 0, digital and capture to mid-values, and
    input to front-mic should be a sensible default).

Note that settings can be saved with "alsactl store".

-   One user reported that he had to disable every snd module in his
    rc.conf except for two: snd_hda_intel and snd_pcm_oss.

-   [deprecated] if the speakers do not mute when you plug in
    headphones, you may need to compile alsa (i use v1.0.18a ,here)

Extract the tar.bz2 and open a console on alsa source folder, install
alsa-utils and execute these commands:

    $ ./configure --with-cards=hda-intel --with-oss=yes --with-sequencer=yes
    $ make
    # make install

Then configure sound volume with alsamixer and reboot.

> Suspend and hibernate

If you want to use Suspend to RAM using pm-utils then you'll need the
following command to resume properly:

    pm-suspend --quirk-vbestate-restore

Note:pm-suspend should work correctly without any quirks at the moment.

You can use this command not only to suspend from terminal but also in
combination with acpid.

If after closing the lid your machine doesn't wake up from suspend
correctly and needs to be resumed multiple times, you can try using the
following workaround. This is an excerpt from /etc/acpid/handler.sh
file:

        button/lid)
           if [ $(/bin/awk '{print $2}' /proc/acpi/button/lid/LID0/state) = closed ]; then
               /usr/sbin/pm-suspend
           fi
           ;;

In contrast hibernate works without "modifications" (except the ones
mentioned in the pm-utils article).

If you are a kde4/kdemod user you can take advantage of powerdevil
(included in kdemod-core/kdemod-kdebase-workspace since release 4.2).
Screen brightness, cpu scaling, suspend and hibernate all work
flawlessly, without any hack.

Right after resume you may notice (i.e. in powertop) lost support for C2
and C4 CPU states. Those modes are likely to return within several
minutes.

> Fn keys

Volume Controls worked out of the box in kdemod 4.2.

To bind the Fn keys to action, read Extra Keyboard Keys. The suspend key
(Fn+ESC) and disable touchpad (Fn+F10) keys should work out of the box.
Note that suspend key is handled in /etc/acpi/handler.sh (see
"power/sleep" case entry). If you use pm-utils, you should substitute
the default action with the call to pm-suspend or pm-hibernate.

As an example, here is how to bind the keys for volume control:

1.  Install xbindkeys and xorg-xbacklight for brightness control.
2.  Crate a config file in your home directory with the following
    content:

    ~/.xbindkeysrc

     "amixer sset Master 2+ &"
         m:0x0 + c:176
     "amixer sset Master 2- &"
         m:0x0 + c:174
     #"amixer sset Master 0 &"
     "amixer sset Master toggle &"
         m:0x0 + c:160
     #"sudo pm-suspend"
     #    m:0x0 + c:223
     "xbacklight +10"
         m:0x0 + c:233
     "xbacklight -10"
         m:0x0 + c:232

For your NC10 Fn keysums may differ. If any Fn keys do not work with the
above .xbindkeysrc, you should check the keysum values with
xbindkeys -k.

3. Run xbindkeys and volume control should work within an X session!

To add additional bindings, you can get the codes of most of the Fn-keys
with xbindkeys -k.

For the keys that are not recongnized, see:

    dmesg | tail

This will help to find errors and find the solution.

If your screen is not bright enough, boot into Windows and set the
brightness to maximum or just do it the boot process.

> Power saving

See power saving.

> BIOS

There is no official support from Samsung on how to upgrade your BIOS
from anything else than Windows XP / 7, although there's an exellent
guide on how to update your BIOS without Windows installed on your
computer at all here.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samsung_NC10&oldid=280852"

Category:

-   Samsung

-   This page was last modified on 1 November 2013, at 16:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
