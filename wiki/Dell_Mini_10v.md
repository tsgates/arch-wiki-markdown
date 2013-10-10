Dell Mini 10v
=============

> Summary

This articles details the installation and configuration of Arch Linux
on the Dell Mini 10v. The Dell Mini 10v is a netbook with 10" display
from Dell. This article covers the configuration of the graphics card,
wireless card and touchpad.

> Related

Beginners' Guide

Laptop

Touchpad Synaptics

Acer Aspire One

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Before you begin                                                   |
| -   2 Xorg                                                               |
|     -   2.1 Video Driver                                                 |
|     -   2.2 Touchpad                                                     |
|                                                                          |
| -   3 Wireless                                                           |
| -   4 Power                                                              |
|     -   4.1 Battery status                                               |
|     -   4.2 Suspend to RAM                                               |
|                                                                          |
| -   5 Extras                                                             |
|     -   5.1 Sound and Microphone                                         |
|     -   5.2 Webcam                                                       |
|     -   5.3 Bluetooth                                                    |
|     -   5.4 SD card reader                                               |
|     -   5.5 Solid-state drive                                            |
|     -   5.6 custom kernel installation                                   |
|     -   5.7 Desktop installation                                         |
+--------------------------------------------------------------------------+

Before you begin
----------------

This article is intended to assist users with the specifics of
installing Arch Linux on the Dell Mini 10v. It is assumed that a user is
also following an installation guide such as the Beginners' Guide.

Dell Mini 10v hardware may vary, however the following list of hardware
has been assumed in this article:

 Audio
    Intel Corporation 82801G card
    Realtek ALC272 Chip (from alsamixer)

 Video
    Intel Corporation Mobile 945GME

 Wired NIC
    Realtek RTL8101E/RTL8102E

 Wireless NIC
    Broadcom Corporation BCM4312 802.11b/g

 Bluetooth
    Dell 365 Bluetooth 2.1+EDR

 Webcam
    Syntek Integrated Webcam

To list hardware, issue this command:

    $ lspci && lsusb

The Dell Mini 10v does not have an optical drive. This means you will
need to install Arch Linux through one of the alternative methods:

-   USB stick (recommended)
-   External USB CD-ROM drive.

To select the required boot media to install Arch Linux, press F12 to
open the Boot Menu when booting the Dell Mini 10v.

Xorg
----

After reaching the Install X and configure ALSA section of the
Beginners' Guide, follow these Dell Mini 10v guidelines:

> Video Driver

Replace vesa with Intel

    # pacman -R xf86-video-vesa
    # pacman -S xf86-video-intel

    /etc/X11/xorg.conf.d/20-gpudriver.conf

    Section "Device"
            Identifier "Card0"
            Driver     "intel"
    EndSection

> Touchpad

The synaptics package is required to use the touchpad. For help refer to
the Synaptics guide. Manual configuration is needed as follows to ignore
movements, scrolling and tapping on the bottom section of the touchpad,
where the touchpad buttons are located.

Firstly install the synaptics package:

    # pacman -S xf86-input-synaptics

Add the 'JumpyCursorThreshold' and 'AreaBottomEdge' options to
/etc/X11/xorg.conf.d/10-synaptics.conf:

    /etc/X11/xorg.conf.d/10-synaptics.conf

    Section "InputClass"
        Identifier "touchpad catchall"
        Driver "synaptics"
        MatchIsTouchpad "on"
            Option "TapButton1" "1"
            Option "TapButton2" "2"
            Option "TapButton3" "3"
            Option "JumpyCursorThreshold" "90"
            Option "AreaBottomEdge" "4100"
    EndSection

Once X has been restarted, the bottom part of the touchpad will be
disabled, allowing a user to click without unintentional movements of
the mouse. See the synaptics manual page for available options:

    $ man synaptics

Wireless
--------

The Wireless NIC is supported by the b43 module and is included in
kernel from 2.6.32 on. Firmware must be installed for this hardware, as
outlined in the Wireless Setup article.

If you have difficulty with connection, or have unstable connection, try
the option

    qos=0

when loading the b43 module. This can be done with

    rmmod b43    # remove the module
    modprobe b43  qos=0  # reload it with the option

Once confirming that it works, you can create a file
/etc/modprobe.d/b43.conf with the following line

    options b43 qos=0

permanently.

-- other option - to use broadcom-wl driver from AUR repository

    yaourt -S broadcom-wl

Power
-----

> Battery status

For utilities to monitor the battery status, see the Laptop article.

> Suspend to RAM

To suspend to RAM, install both pm-utils and acpid:

    # pacman -S pm-utils acpid

The acpid package handles events such as pressing the the power button
or closing the laptop lid. For more information, see the Acpid article.
To suspend to RAM, edit /etc/acpi/handlers.sh to tell the acpid package
to call the pm-suspend script (part of pm-utils), when an event such as
closing the laptop lid occurs. Below, /usr/sbin/pm-suspend has been
added to the button/lid and button/power sections:

    /etc/acpi/handlers.sh

    #!/bin/sh
    # Default acpi script that takes an entry for all actions

    .....

    case "$1" in
        button/power)
            #echo "PowerButton pressed!">/dev/tty5
            /usr/sbin/pm-suspend # <<<< ADDED HERE
            case "$2" in
                PWRF)   logger "PowerButton pressed: $2" ;;
                *)      logger "ACPI action undefined: $2" ;;
            esac
            ;;

     .....

        button/lid)
            #echo "LID switched!">/dev/tty5
            /usr/sbin/pm-suspend # <<<< ADDED HERE
            ;;
        *)
            logger "ACPI group/action undefined: $1 / $2"
            ;;
    esac

The netbook will now suspend to RAM when the laptop lid is closed or
power button pressed. To wake the netbook, open the lid or press the
power button once more.

It may happen that the resume takes more than 5 seconds of black screen
before coming back. This may be caused by the b43 firmware loading
delay. A close inspection of 'dmesg' should reveal the cause: check the
line containing 'b43-phy0' to see if reload it takes a long time. If so,
create a file /etc/pm/config.d/modules and add

    /etc/pm/config.d/modules

    SUSPEND_MODULES="b43"

This should reduce the resume time significantly to the extent that the
graphical display comes back almost instantaneously.

Extras
------

> Sound and Microphone

Sound can be set up as outlined in the ALSA section of Beginners' Guide.
The microphone and speaker can be unmuted and volume increased by using
alsamixer:

    $ alsamixer

Firstly, press Fn+F5 to view both Playback and Capture cards. Now press
M to unmute Master, PCM, Mic and Capture. Arrows can be used to select
the channel and increase volume.

To save these ALSA settings, issue this command:

    # alsactl store

> Webcam

The inbuilt webcam works out of the box, with the latest kernel. You may
use the cheese package to test the webcam, however this package depends
on gnome-desktop. Also check that the normal user is a member of the
video group:

    $ groups $USER

> Bluetooth

Follow the Bluetooth article for setting up Bluetooth.

> SD card reader

The SD card reader works out of the box.

> Solid-state drive

For maximising performace of a SSD, refer to this article.

> custom kernel installation

best kernel for Dell Mini 10v - kernel-netbook
https://aur.archlinux.org/packages.php?ID=34625

    yaourt -S kernel-netbook

(since kernel.org server is currently down due to server security
breach, you have to edit PKGBUILD)

    # Maintainer: Dieghen89 <dieghen89@gmail.com>

    BFQ_IO_SCHEDULER="y"
    TUX_ON_ICE="y"

    pkgname=kernel-netbook
    true && pkgname=('kernel-netbook' 'kernel-netbook-headers')
    makedepends=('dmidecode' 'xmlto' 'docbook-xsl' 'linux-firmware')
    optdepends=('hibernate-script: tux on ice default script' 'tuxonice-userui: graphical interface for toi [AUR]')
    _basekernel=3.0
    pkgver=${_basekernel}.6
    pkgrel=1
    pkgdesc="Static kernel for netbooks with Intel Atom N270/N280/N450/N550 such as eeepc with the add-on of external firmware (broadcom-wl) and patchset (BFS + TOI + BFQ optional) - Only Intel GPU - Give more power to your netbook!"
    options=('!strip')
    arch=('i686')
    license=('GPL2')
    url=('http://code.google.com/p/kernel-netbook')

    ####################################
    md5sums=('398e95866794def22b12dfbc15ce89c0'
             '792f01cc8874d03a84e47fd0e7065df8'
             'c0074a1622c75916442e26763ddf47d0'
             'bca399a46c7d83affdace85b9c633e36'
             'a325f43707984c93672d8f4aaf76fc2b'
             'e1064f82d5faab2119af5f6dbeae2cb1'
             '5d7307a9b6bf0271ee55cae6c6fe2610'
             'afbd01926c57fc5b82ee6034dc9311e5'
             'e8c333eaeac43f5c6a1d7b2f47af12e2'
             '5974286ba3e9716bfbad83d3f4ee985a'
             'a6f0377c814da594cffcacbc0785ec1a'
             '2bb172117ede96c14289f9f9bc34f58f'
             'aee89fe7f034aea2f2ca95322774c1b5'
             '21ce3f7967d7305064bf7eb60030ffea'
             '263725f20c0b9eb9c353040792d644e5'
             '9d3c56a4b999c8bfbd4018089a62f662'
             '9cd62013cee44d529de140821dd75654'
             '5b4d6028d85320dc6bc4034991dfab9d')
    ###################################
    #  external drivers  and firmware #
    ###################################

    #Broadcom-wl:
    broadcom_ver=5.100.82.38
    broadcom="hybrid-portsrc_x86_32-v${broadcom_ver//./_}"
    #BFS: - http://users.on.net/~ckolivas/kernel/ -
    _ckpatchversion=1
    _ckpatchname="patch-${_basekernel}.0-ck${_ckpatchversion}"
    #BFQ: - http://algo.ing.unimo.it/people/paolo/disk_sched/ -
    _bfqpatchversion="1"
    _bfqpath="http://algo.ing.unimo.it/people/paolo/disk_sched/patches/3.0.0"
    #TuxOnIce:
    _toipatch="current-tuxonice-for-3.0.patch.bz2"

    ##### Sources #####
    source=( #kernel sources and arch patchset
    	"http://lame.lut.fi/linux/kernel/v3.0/linux-${_basekernel}.tar.bz2"
    	#"http://lame.lut.fi/linux/kernel/v3.0/patch-${pkgver}.bz2"
    	"ftp://ftp.archlinux.org/other/linux/patch-${pkgver}.gz"
    	#external drivers:
    	"http://www.broadcom.com/docs/linux_sta/${broadcom}.tar.gz"
    	#"http://switch.dl.sourceforge.net/sourceforge/syntekdriver/stk11xx-$stk11xx_ver.tar.gz"
    	#BFS patch:
    	"http://kernelorg.mirrors.tds.net/pub/linux/kernel/people/ck/patches/3.0/${_basekernel}.0-ck${_ckpatchversion}/${_ckpatchname}.bz2"
    	#BFQ patch:
    	"${_bfqpath}/0001-block-prepare-I-O-context-code-for-BFQ-v3-for-3.0.patch"
    	"${_bfqpath}/0002-block-cgroups-kconfig-build-bits-for-BFQ-v3-3.0.patch"
    	"${_bfqpath}/0003-block-introduce-the-BFQ-v3-I-O-sched-for-3.0.patch"
    	#TuxOnIce:
    	"http://tuxonice.net/files/${_toipatch}"
    	#Arch Logo
    	"logo_linux_mono.pbm"
            "logo_linux_clut224.ppm"
    	"logo_linux_vga16.ppm"
    	#Others:
    	"license.patch"
    	"semaphore.patch"
    	"mutex-sema.patch"
    	"fix-i915.patch"
            "change-default-console-loglevel.patch"
    	"kernel-netbook.preset"
    	"config")
    	
    build() {
      cd ${srcdir}/linux-$_basekernel

      # Patching Time:

      # minorversion patch:
      patch -p1 -i "${srcdir}/patch-${pkgver}"

      # fix #19234 i1915 display size
      patch -Np1 -i "${srcdir}/fix-i915.patch"

      # set DEFAULT_CONSOLE_LOGLEVEL to 4 (same value as the 'quiet' kernel param)
      # remove this when a Kconfig knob is made available by upstream
      # (relevant patch sent upstream: https://lkml.org/lkml/2011/7/26/227)
      patch -Np1 -i "${srcdir}/change-default-console-loglevel.patch"
      
      # replace tux logo with arch one
      install -m644 ${srcdir}/logo_linux_clut224.ppm drivers/video/logo/
      install -m644 ${srcdir}/logo_linux_mono.pbm drivers/video/logo/
      install -m644 ${srcdir}/logo_linux_vga16.ppm drivers/video/logo/

      # --> BFS
      msg "Patching source with BFS patch:"
      #Adjust localversion
      sed -i -e "s/-ck${_ckpatchversion}//g" ${srcdir}/${_ckpatchname}
      #patching time
      patch -Np1 -i ${srcdir}/${_ckpatchname}

      # --> TOI
      if [ $TUX_ON_ICE = "y" ] ; then
        msg "Patching source with TuxOnIce patch"
        bzip2 -dck ${srcdir}/${_toipatch} \
            | sed 's/printk(KERN_INFO "PM: Creating hibernation image:\\n/printk(KERN_INFO "PM: Creating hibernation image: \\n/' \
            | patch -Np1 -F4 || { echo "Failed TOI"; return 1 ; }
      fi

      # --> BFQ
      if [ $BFQ_IO_SCHEDULER = "y" ] ; then
        msg "Patching source with BFQ patches"
        for i in $(ls ${srcdir}/000*.patch); do
          patch -Np1 -i $i
        done
      fi


      ### Clean tree and copy ARCH config over
      msg "Running make mrproper to clean source tree"
      make mrproper

      # copy config
      cp ../config ./.config

      make prepare

      # make defconfig
      # configure kernel    
      # use menuconfig, if you want to change the configuration
      make menuconfig
      # make gconfig
      yes "" | make config
      # build kernel
      msg "Now starts something magic:"
      make ${MAKEFLAGS} bzImage modules
    }

    package_kernel-netbook() {
      pkgdesc='Static kernel for netbooks with Intel Atom N270/N280/N450/N550 such as eeepc with the add-on of external firmware (broadcom-wl) - Only Intel GPU - Give more power to your netbook!'
      depends=('coreutils' 'module-init-tools')
      install=kernel-netbook.install
      optdepends=('crda: for wireless regulatory domain support' 
    	      'linux-firmware: firmware for rt2860, tigon3, brcmsmac'
    	      'hibernate-script: tux on ice default script'
    	      'tuxonice-userui: graphical interface for toi [AUR]')
      groups=(eee)

      cd ${srcdir}/linux-$_basekernel
      # install our modules
      mkdir -p $pkgdir/{lib/modules,boot}
      make INSTALL_MOD_PATH=$pkgdir modules_install
      
      # Get kernel version
      _kernver="$(make kernelrelease)"

      # remove build and source links
      rm -r $pkgdir/lib/modules/$_kernver/{source,build}
      
      # remove the firmware directory
      rm -rf ${pkgdir}/lib/firmware

      # install the kernel
      install -D -m644 ${srcdir}/linux-$_basekernel/System.map $pkgdir/boot/System.map-netbook
      install -D -m644 ${srcdir}/linux-$_basekernel/arch/x86/boot/bzImage ${pkgdir}/boot/vmlinuz-netbook
      install -D -m644 ${srcdir}/linux-$_basekernel/.config $pkgdir/boot/kconfig-netbook

      # install preset file for mkinitcpio
      sed -i -e "s/ALL_kver=.*/ALL_kver=\'${_kernver}\'/g" ${srcdir}/${pkgname}.preset
      install -m644 -D ${srcdir}/${pkgname}.preset ${pkgdir}/etc/mkinitcpio.d/${pkgname}.preset

      # set correct depmod command for install
      sed -i -e "s/KERNEL_VERSION=.*/KERNEL_VERSION=${_kernver}/g" $startdir/$pkgname.install

    ##Section: Broadcom-wl
      #msg "Compiling broadcom-wl module:"
      #cd ${srcdir}/
      ##patching broadcom as broadcom-wl package on AUR
      #patch -p1 < license.patch
      #patch -p1 < semaphore.patch
      #patch -p1 < mutex-sema.patch
      #make -C ${srcdir}/linux-$_basekernel M=`pwd`
      #install -D -m 755 wl.ko ${pkgdir}/lib/modules/$_kernver/kernel/drivers/net/wireless/wl.ko
      
      # gzip -9 all modules to safe a lot of MB of space
      find "$pkgdir" -name '*.ko' -exec gzip -9 {} \;
    }

    package_kernel-netbook-headers() {
      KARCH=x86
      pkgdesc='Header files and scripts for building modules for kernel-netbook'

      mkdir -p "${pkgdir}/lib/modules/${_kernver}"

      cd "${pkgdir}/lib/modules/${_kernver}"
      ln -sf ../../../usr/src/linux-${_kernver} build

      cd "${srcdir}/linux-${_basekernel}"
      install -D -m644 Makefile \
        "${pkgdir}/usr/src/linux-${_kernver}/Makefile"
      install -D -m644 kernel/Makefile \
        "${pkgdir}/usr/src/linux-${_kernver}/kernel/Makefile"
      install -D -m644 .config \
        "${pkgdir}/usr/src/linux-${_kernver}/.config"

      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/include"

      for i in acpi asm-generic config crypto drm generated linux math-emu \
        media net pcmcia scsi sound trace video xen; do
        cp -a include/${i} "${pkgdir}/usr/src/linux-${_kernver}/include/"
      done

      # copy arch includes for external modules
      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/arch/x86"
      cp -a arch/x86/include "${pkgdir}/usr/src/linux-${_kernver}/arch/x86/"

      # copy files necessary for later builds, like nvidia and vmware
      cp Module.symvers "${pkgdir}/usr/src/linux-${_kernver}"
      cp -a scripts "${pkgdir}/usr/src/linux-${_kernver}"

      # fix permissions on scripts dir
      chmod og-w -R "${pkgdir}/usr/src/linux-${_kernver}/scripts"
      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/.tmp_versions"

      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/arch/${KARCH}/kernel"

      cp arch/${KARCH}/Makefile "${pkgdir}/usr/src/linux-${_kernver}/arch/${KARCH}/"

      if [ "${CARCH}" = "i686" ]; then
        cp arch/${KARCH}/Makefile_32.cpu "${pkgdir}/usr/src/linux-${_kernver}/arch/${KARCH}/"
      fi

      cp arch/${KARCH}/kernel/asm-offsets.s "${pkgdir}/usr/src/linux-${_kernver}/arch/${KARCH}/kernel/"

      # add headers for lirc package
      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/drivers/media/video"

      cp drivers/media/video/*.h  "${pkgdir}/usr/src/linux-${_kernver}/drivers/media/video/"

      for i in bt8xx cpia2 cx25840 cx88 em28xx et61x251 pwc saa7134 sn9c102; do
        mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/drivers/media/video/${i}"
        cp -a drivers/media/video/${i}/*.h "${pkgdir}/usr/src/linux-${_kernver}/drivers/media/video/${i}"
      done

      # add docbook makefile
      install -D -m644 Documentation/DocBook/Makefile \
        "${pkgdir}/usr/src/linux-${_kernver}/Documentation/DocBook/Makefile"

      # add dm headers
      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/drivers/md"
      cp drivers/md/*.h "${pkgdir}/usr/src/linux-${_kernver}/drivers/md"

      # add inotify.h
      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/include/linux"
      cp include/linux/inotify.h "${pkgdir}/usr/src/linux-${_kernver}/include/linux/"

      # add wireless headers
      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/net/mac80211/"
      cp net/mac80211/*.h "${pkgdir}/usr/src/linux-${_kernver}/net/mac80211/"

      # add dvb headers for external modules
      # in reference to:
      # http://bugs.archlinux.org/task/9912
      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/drivers/media/dvb/dvb-core"
      cp drivers/media/dvb/dvb-core/*.h "${pkgdir}/usr/src/linux-${_kernver}/drivers/media/dvb/dvb-core/"
      # and...
      # http://bugs.archlinux.org/task/11194
      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/include/config/dvb/"
      cp include/config/dvb/*.h "${pkgdir}/usr/src/linux-${_kernver}/include/config/dvb/"

      # add dvb headers for http://mcentral.de/hg/~mrec/em28xx-new
      # in reference to:
      # http://bugs.archlinux.org/task/13146
      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/drivers/media/dvb/frontends/"
      cp drivers/media/dvb/frontends/lgdt330x.h "${pkgdir}/usr/src/linux-${_kernver}/drivers/media/dvb/frontends/"
      cp drivers/media/video/msp3400-driver.h "${pkgdir}/usr/src/linux-${_kernver}/drivers/media/dvb/frontends/"

      # add dvb headers
      # in reference to:
      # http://bugs.archlinux.org/task/20402
      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/drivers/media/dvb/dvb-usb"
      cp drivers/media/dvb/dvb-usb/*.h "${pkgdir}/usr/src/linux-${_kernver}/drivers/media/dvb/dvb-usb/"
      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/drivers/media/dvb/frontends"
      cp drivers/media/dvb/frontends/*.h "${pkgdir}/usr/src/linux-${_kernver}/drivers/media/dvb/frontends/"
      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/drivers/media/common/tuners"
      cp drivers/media/common/tuners/*.h "${pkgdir}/usr/src/linux-${_kernver}/drivers/media/common/tuners/"

      # add xfs and shmem for aufs building
      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/fs/xfs"
      mkdir -p "${pkgdir}/usr/src/linux-${_kernver}/mm"
      cp fs/xfs/xfs_sb.h "${pkgdir}/usr/src/linux-${_kernver}/fs/xfs/xfs_sb.h"

      # copy in Kconfig files
      for i in `find . -name "Kconfig*"`; do
        mkdir -p "${pkgdir}"/usr/src/linux-${_kernver}/`echo ${i} | sed 's|/Kconfig.*||'`
        cp ${i} "${pkgdir}/usr/src/linux-${_kernver}/${i}"
      done

      chown -R root.root "${pkgdir}/usr/src/linux-${_kernver}"
      find "${pkgdir}/usr/src/linux-${_kernver}" -type d -exec chmod 755 {} \;

      # strip scripts directory
      find "${pkgdir}/usr/src/linux-${_kernver}/scripts" -type f -perm -u+w 2>/dev/null | while read binary ; do
        case "$(file -bi "${binary}")" in
          *application/x-sharedlib*) # Libraries (.so)
            /usr/bin/strip ${STRIP_SHARED} "${binary}";;
          *application/x-archive*) # Libraries (.a)
            /usr/bin/strip ${STRIP_STATIC} "${binary}";;
          *application/x-executable*) # Binaries
            /usr/bin/strip ${STRIP_BINARIES} "${binary}";;
        esac
      done

      # remove unneeded architectures
      rm -rf "${pkgdir}"/usr/src/linux-${_kernver}/arch/{alpha,arm,arm26,avr32,blackfin,cris,frv,h8300,ia64,m32r,m68k,m68knommu,mips,microblaze,mn10300,parisc,powerpc,ppc,s390,sh,sh64,sparc,sparc64,um,v850,xtensa}
    }

create initrd

    cd /lib/modules/3.0.6-netbook
    mkinitcpio -k 3.0.6-netbook -g /boot/initramfs-netbook.img

edit grub menu.lst

    #  Arch netbook
    title  Arch netbook
    root   (hdx,x)
    kernel /boot/vmlinuz-netbook root=/dev/disk/by-uuid/xxxxxxxx-xxxx-xxxx-xxxx-xxxxx$
    initrd /boot/initramfs-netbook.img

> Desktop installation

gnome works best on Dell mini 10v. KDE seems to be too heavy for Dell
mini Atom processor

    pacman -Syu gnome gdm

use gdm as login manager

    nano /etc/inittab

    x:5:respawn:/usr/sbin/gdm -nodaemon

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Mini_10v&oldid=234316"

Category:

-   Dell
