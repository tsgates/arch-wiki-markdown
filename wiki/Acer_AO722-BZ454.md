Acer AO722-BZ454
================

  
 This page assumes that you will be using it as a reference along with
the Beginners' guide. In addition, a discussion of general setup is
available from the main article on the Acer Aspire One, although the
hardware is quite different. A discussion of various other issues and
tweaks is available in the Ubuntu forums.

Contents
--------

-   1 Hardware Information
    -   1.1 lspci
    -   1.2 lsusb
    -   1.3 lsmod
-   2 Setup Issues
    -   2.1 Video
    -   2.2 Networking
    -   2.3 Audio
        -   2.3.1 HDMI Audio issue
    -   2.4 Beep on Power Cord Plug-In/Out
    -   2.5 Dual Boot

Hardware Information
--------------------

The Acer AO722-BZ454 is a 64-bit computer. For additional information
see the Arch64 FAQ.

    Note: This page also applies to other AO722 models, not just the BZ454.

> lspci

    00:00.0 Host bridge: Advanced Micro Devices [AMD] Pavilion DM1Z-3000 Host bridge
    00:01.0 VGA compatible controller: ATI Technologies Inc Device 9807
    00:01.1 Audio device: ATI Technologies Inc Device 1314
    00:11.0 SATA controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
    00:12.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
    00:12.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
    00:13.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
    00:13.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
    00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 42)
    00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA) (rev 40)
    00:14.3 ISA bridge: ATI Technologies Inc SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
    00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (rev 40)
    00:15.0 PCI bridge: ATI Technologies Inc Device 43a0
    00:15.2 PCI bridge: ATI Technologies Inc Device 43a2
    00:15.3 PCI bridge: ATI Technologies Inc Device 43a3
    00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 0 (rev 43)
    00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 1
    00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 2
    00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 3
    00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 4
    00:18.5 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 6
    00:18.6 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 5
    00:18.7 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 7
    06:00.0 Ethernet controller: Atheros Communications AR8152 v2.0 Fast Ethernet (rev c1)
    07:00.0 Network controller: Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller (rev 01)

> lsusb

    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 002 Device 003: ID 04f2:b209 Chicony Electronics Co., Ltd 
    Bus 003 Device 002: ID 045e:00d2 Microsoft Corp. 

> lsmod

    Module                  Size  Used by
    uas                     8088  0 
    ums_realtek             4458  0 
    usb_storage            44263  1 ums_realtek
    appletalk              26298  0 
    ipx                    20395  0 
    p8022                   1171  1 ipx
    psnap                   1973  2 appletalk,ipx
    llc                     3761  2 p8022,psnap
    p8023                   1068  1 ipx
    ipv6                  290855  20 
    joydev                  9895  0 
    fuse                   67290  3 
    snd_hda_codec_conexant    46356  1 
    snd_hda_codec_hdmi     22092  1 
    snd_hda_intel          22122  0 
    arc4                    1410  2 
    snd_hda_codec          77927  3 snd_hda_codec_conexant,snd_hda_codec_hdmi,snd_hda_intel
    snd_hwdep               6325  1 snd_hda_codec
    brcmsmac              594688  0 
    brcmutil                6563  1 brcmsmac
    mac80211              215908  1 brcmsmac
    snd_pcm                73952  3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec
    radeon                993027  2 
    uvcvideo               64963  0 
    videodev               78006  1 uvcvideo
    ttm                    54360  1 radeon
    drm_kms_helper         25409  1 radeon
    media                  10437  2 uvcvideo,videodev
    psmouse                55192  0 
    evdev                   9530  8 
    snd_timer              19416  1 snd_pcm
    snd                    57818  7 snd_hda_codec_conexant,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
    sparse_keymap           3088  0 
    atl1c                  32528  0 
    pcspkr                  1819  0 
    serio_raw               4294  0 
    drm                   183380  4 radeon,ttm,drm_kms_helper
    v4l2_compat_ioctl32     8292  1 videodev
    cfg80211              160772  2 brcmsmac,mac80211
    wmi                     8347  0 
    battery                 6317  0 
    button                  4470  0 
    processor              24256  2 
    k10temp                 2883  0 
    rfkill                 15402  1 cfg80211
    crc_ccitt               1331  1 brcmsmac
    i2c_algo_bit            5199  1 radeon
    i2c_piix4               8224  0 
    soundcore               6146  1 snd
    video                  11228  0 
    ac                      2376  0 
    sg                     25557  0 
    i2c_core               20133  6 radeon,videodev,drm_kms_helper,drm,i2c_algo_bit,i2c_piix4
    sp5100_tco              4568  0 
    snd_page_alloc          7121  2 snd_hda_intel,snd_pcm
    ext4                  370462  1 
    mbcache                 5817  1 ext4
    jbd2                   71074  1 ext4
    crc16                   1297  1 ext4
    usbhid                 35256  0 
    hid                    81635  1 usbhid
    sd_mod                 28307  4 
    ohci_hcd               21714  0 
    ahci                   20897  3 
    libahci                18885  1 ahci
    libata                173297  2 ahci,libahci
    ehci_hcd               39543  0 
    scsi_mod              131546  5 uas,usb_storage,sg,sd_mod,libata
    usbcore               142576  8 uas,ums_realtek,usb_storage,uvcvideo,usbhid,ohci_hcd,ehci_hcd

Setup Issues
------------

Most things on the Acer Aspire One 722 work more or less out of the box,
as long as you do what the Beginners' guide says to do. There are
however some special steps required.

> Video

The xf86-video-ati driver is recommended, read ATI for more information.

> Networking

Note:If you experience freezes when turning on the wireless
card/connecting to wireless networks, select "Network Boot" as first
boot device in the BIOS. (Press F2 during Acer boot screen to access the
BIOS options.)

Wireless ethernet driver brcmsmac should automatically load at startup.

This should no longer be needed, but in the past, the modules bcma and
acer-wmi caused conflicts and had to be blacklisted.

Setup may be further configured by reading Wireless network
configuration.

> Audio

Initially, audio doesn't work, except for beeping. The problem may be
corrected by editing /usr/share/alsa/alsa.conf and replacing every
instance of card 0 with card 1.

As of kernel 3.1, the headphone jack is correctly supported.

For kernel versions < 3.1, a bash script may be used to switch between
the internal speakers and headphones. First, download hda-verb from the
AUR. The package is now out of date, so use the following PKGBUILD
script:

    pkgname='hda-verb'
    pkgver=0.4
    pkgrel=1
    pkgdesc="Tool to send commands (verbs) to HD-Audio codecs"
    arch=('i686' 'x86_64')
    depends=('glibc')
    url="ftp://ftp.suse.com/pub/people/tiwai/misc/"
    license=('GPL')
    source=(ftp://ftp.suse.com/pub/people/tiwai/misc/$pkgname-$pkgver.tar.gz)
    md5sums=('60be775c58feb2f8b9644dfeca0ad0d8')

    build() {
    	cd $srcdir/$pkgname-$pkgver

    	make || return 1
    	install -D $pkgname $pkgdir/usr/bin/$pkgname
    }

  
 Next, save the following bash script:

    #!/bin/bash

    # If needed, change these to the pins of the headphones and speakers, can be found using hda analyzer
    pin_headphones="0x19"
    pin_speakers="0x1f"

    case "$1" in
      [Hh]*)
        hda-verb /dev/snd/hwC1D0 "${pin_headphones}" \
          set_pin_wid 0xc0
        hda-verb /dev/snd/hwC1D0 "${pin_speakers}" \
          set_pin_wid 0x00
        ;;
      [Ss]*)
        hda-verb /dev/snd/hwC1D0 "${pin_headphones}" \
          set_pin_wid 0x00
        hda-verb /dev/snd/hwC1D0 "${pin_speakers}" \
          set_pin_wid 0x40
        ;;
    esac

Run the script as root with h or s as an argument to switch to
headphones or speakers. Sometimes the command must be run again if a new
audio program is started. (Taken with modifications from this discussion
in the forums.)

HDMI Audio issue

The hdmi video display works fine out of box (as of 2014-1-1, using ATI
driver), however, HDMI audio doesn't work. Searching the forum, there is
some indication this is due to video driver issue.

> Beep on Power Cord Plug-In/Out

To lower the loudness of the beep when the power cord to an acceptable
level, open alsamixer, select the "HDA ATI SB" sound card using F6 and
mute the "Beep" by using arrow chars and then pressing "m"

> Dual Boot

See Windows and Arch Dual Boot for general information. Note that this
netbook does not come with recovery CDs. If an attempt to set up dual
boot goes awry and you can't boot the machine at all, or can't boot into
Windows, you can restore the original Windows configuration by booting
into /dev/sda1, the recovery partition, as if it were an ordinary
Windows installation. The recovery program says it will wipe the whole
disk but will only wipe the partition on which Windows resides. (You can
install grub from the Arch installation media onto a thumbdrive and take
it from there.)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_AO722-BZ454&oldid=298177"

Category:

-   Acer

-   This page was last modified on 16 February 2014, at 07:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
