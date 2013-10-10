Samsung N120
============

This article aims on providing the informations on installing and
setting up Arch Linux on the Samsung N120. Basically I used information
from Samsung NC10 netbook wiki.

A lot of the information is derived from the NC10 Arch Forum and N120
Arch Forum and several hints scattered around in the ArchWiki.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prior to Installation, current state and Common Issues You Should  |
|     Be Aware Of                                                          |
| -   2 Installation                                                       |
| -   3 Configure your installation                                        |
|     -   3.1 Network                                                      |
|         -   3.1.1 Ethernet                                               |
|         -   3.1.2 Wireless                                               |
|                                                                          |
|     -   3.2 Video                                                        |
|     -   3.3 Initial Brightness                                           |
|     -   3.4 Graphics Adapter                                             |
|         -   3.4.1 External VGA                                           |
|                                                                          |
|     -   3.5 Audio                                                        |
|     -   3.6 Suspend and Hibernate                                        |
|     -   3.7 Fn Keys                                                      |
|         -   3.7.1 Fix Fn + key combinations does not produce key release |
|             events                                                       |
|                                                                          |
|     -   3.8 Power saving                                                 |
+--------------------------------------------------------------------------+

Prior to Installation, current state and Common Issues You Should Be Aware Of
=============================================================================

Following information is based on kernel 2.6.32 (2010.04.08).

-   Suspend to RAM and Suspend to Disk works perfectly.
-   Webcam works out-of-the-box, even with Skype.
-   Volume controls and LAN works.
-   WLAN works out of the box for Atheros hardware and with Realtek
    hardware after installing firmware.
-   Audio (including onboard microphone, speakers and audio off on
    earphone plugging) is working flawlessly.
-   It is possible to get all Fn+key combinations working (See Fn-keys
    and fix).
-   Updating BIOS to version 07CE (or later) fixes some brightness
    control issues.
-   If you encounter problems with the installation from USB disk, add
    acpi=off to the kernel parameters.

Installation
============

You can use the usb image provided at the official download locations or
the iso, if you have an external optical drive. If installation fails
try to add acpi=off to the kernel parameters.

Configure your installation
===========================

Network
-------

> Ethernet

Works out-of-the-box with stock kernel module sky2.

> Wireless

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: needs to be      
                           confirmed that the       
                           firmware still isn't     
                           provided (Discuss)       
  ------------------------ ------------------------ ------------------------

-   With devices based on Atheros chip use the stock kernel module
    ath5k.
-   With Realtek based devices wireless works with stock kernel module
    r8192e_pci.

    02:00.0 Network controller: Realtek Semiconductor Co., Ltd. Device 8192 (rev 01)

You can use rtl8192e-firmware-git from AUR to install the firmware files
or get pre-created package from here:
rtl8192e-firmware-git-20100424-1-any.pkg.tar.xz.

The driver needs firmware files that are not currently included in
linux-firmware, so grab them as follows:

    cd /tmp
    git clone git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/firmware.git
    # run these as root:
    cp -av firmware/RTL8192E /lib/firmware/
    depmod -a
    modprobe r8192e_pci

Video
-----

Initial Brightness
------------------

The full brightness can be set with the following command

    setpci -s 00:02.1 F4.B=FF

where FF is the highest level of brightness. That parameter moves in the
range 00..FF. Don't set it too low because your backlight will turn off!
I tried different parameters and optimal are F.4B=45 or F.4B=50. I added
setpci -s 00:02.1 F4.B=40 to my /etc/rc.local.

Graphics Adapter
----------------

The Video controller is a typical Intel chipset that works with the
xf86-video-intel driver (or xf86-video-intel-new from AUR)

To save some interrupts and therefore power you can disable dri in your
xorg.conf. This disables 3D effects but if you do not need them this
could be an option.

    Section "Device"
    Option "NoDRI"
    Identifier "Card0"
    Driver "intel"
    VendorName "Intel Corporation"
    BoardName "Mobile 945GME Express Integrated Graphics Controller"
    BusID "PCI:0:2:0"
    EndSection

> External VGA

External VGA works out of the box with xrandr

in order to prevent problems when switching to console or when
unplugging the external monitor, make sure to specify the frequency
along with the mode, for example :

    xrandr --output VGA --mode 1280x1024 --rate 60

You can also use randr frontend, lxrandr for example.

Dual head positioning works also perfectly : Xorg#Multi-monitor_setups

Audio
-----

The audio device is an Intel HD. Since alsa 1.0.19 distributed in
archlinux extra repository, you do not need to manually install alsa
driver. Everything is working out of the box: onboard microphone and
speakers, audio off on earphone plugging.

> Troubleshooting :

-   If the volume is too low, or lower than in Windows run alsamixer,
    and set "front" to 100%.

-   If the microphone does not work, press F4 in alsamixer and play with
    the settings (boost to 0, digital and capture to mid-values, and
    input to front-mic should be a sane default).

Note that settings can be saved with "alsactl store"

-   One user reported that he had to disable every snd module in his
    rc.conf except for two: snd_hda_intel and snd_pcm_oss.

-   [deprecated] if the speakers do not mute when you plug in
    headphones, you may need to compile alsa.

Download latest alsa build. Extract the tar.bz2 and open a console on
alsa source folder

    1.execute this command : ./configure --with-cards=hda-intel --with-oss=yes --with-sequencer=yes
    2.execute this command : make
    3.execute this command : sudo make install
    4.get alsa-utils with pacman
    5.configure sound volume with alsamixer , reboot , and enjoy :)

Suspend and Hibernate
---------------------

Pm-suspend should work correctly without any quirks at the moment.

You can use this command not only to suspend from terminal but also in
combination with acpid

If after closing the lid your machine doesn't wake up from suspend
correctly and needs to be resumed multiple times, you can try using the
following workaround. This is an excerpt from /etc/acpid/handler.sh
file:

        button/lid)
           if [ `/bin/awk '{print $2}' /proc/acpi/button/lid/LID0/state` = closed ]; then
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
and C4 CPU states. Don't panic. Those modes are likely to return in
several minutes.

Fn Keys
-------

You need at least kernel 2.6.28.4 to get the Fn keys to work correctly.

(Volume Controls worked out of the box in kdemod 4.2)

To bind the Fn keys to action, read Extra_Keyboard_Keys#The_quick_way
and also Extra Keyboard Keys in Xorg. The suspend key (Fn+ESC) and
disable touchpad (Fn+F10) keys should work out of the box. Note, that
suspend key is handled in /etc/acpi/handler.sh (see "power/sleep" case
entry). If you use pm-utils, you should substitute the default action
with the call to pm-suspend or pm-hibernate.

This tweak taken from Ubuntu wiki. To get volume and brightness Fn keys
work in Gnome you have to make sure that gnome-power-manager is running
and add ";N120" to the list of Samsung models in
/usr/share/hal/fdi/information/10freedesktop/30-keymap-misc.fdi, i.e.

    <match key="/org/freedesktop/Hal/devices/computer:system.hardware.product" 
    contains_outof="SP55S;SQ45S70S;SX60P;R59P/R60P/R61P;Q310;X05">

becomes

    <match key="/org/freedesktop/Hal/devices/computer:system.hardware.product" 
    contains_outof="SP55S;SQ45S70S;SX60P;R59P/R60P/R61P;Q310;X05;N120">

  
 Also you can play with xbindkey. As an example, here is how to bind the
keys for volume control :

1) install xbindkeys (and xbacklight from package xorg-server-utils for
brightness control):

    pacman -S xbindkeys xorg-server-utils

2) crate a config file in your home directory :

    vi .xbindkeysrc

3) with the following content :

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

    xbindkeys -k

4) run xbindkeys :

    xbindkeys

and volume control should work within an X session !

to add aditional bindings, you can get the codes of most of the Fn-keys
with

    xbindkeys -k

For the keys that are not recongnized, see

    dmesg |tail

to make the kernel recognize them.

(If your Screen is not bright enough, boot into Windows and set the
Brightness to maximum)

(you can adjust Brightness during the boot process without returning
into Windows and you need to set maximum brightness on battery only
mode)

Alternatively, you can add needed broghtness level on the boot, simply
add line setpci -s 00:02.1 F4.B=FF (00..FF) to your /etc/rc.local.

> Fix Fn + key combinations does not produce key release events

Run and add following command to /etc/rc.local to fix Fn-key behavior
(14052):

    echo 133-139,143,147,236,227 > /sys/devices/platform/i8042/serio0/force_release

For example the brightness controls (Fn+Up/Down) should now work as
expected.

Power saving
------------

See power saving.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samsung_N120&oldid=238263"

Category:

-   Samsung
