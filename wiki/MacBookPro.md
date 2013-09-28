MacBookPro
==========

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  Summary
  ------------------------------------------------
  MacBook
  MacBookPro
  MacBook_Pro_7,1
  MacBook_Pro_8,1_/_8,2_/_8,3_(2011_Macbook_Pro)
  MacBook_Pro_9,2_(Mid-2012)

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 WARNING OUTDATED                                                   |
| -   2 Installing Arch Linux on MacbookPro                                |
|     -   2.1 Arch Only System                                             |
|     -   2.2 Dual Boot (Arch & Mac OS X)                                  |
|         -   2.2.1 Another way                                            |
|         -   2.2.2 Other ways: Two possibilities:                         |
|         -   2.2.3 GRUB                                                   |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 rc.conf                                                      |
|     -   3.2 Xorg                                                         |
|     -   3.3 Wireless                                                     |
|     -   3.4 Pommed                                                       |
|     -   3.5 Suspend                                                      |
|                                                                          |
| -   4 TODO                                                               |
+--------------------------------------------------------------------------+

WARNING OUTDATED
----------------

Please see MacBook Aluminum for newest 5,1 and 5,2 unibody Macbook Pros
or MacBook for general Macbook information.

also see:
https://help.ubuntu.com/community/MactelSupportTeam/AppleIntelInstallation

Installing Arch Linux on MacbookPro
-----------------------------------

These instructions could work for the most part for the regular MacBook.

You will need Arch Linux 0.8 alpha3 or newer at least since GRUB and the
kernel will work fine from this version.

> Arch Only System

To install Arch and replace OSX you need to change the partition table
type in Mac OS X from bootcamp. Download bootcamp, install and run.
Change disk from GPT to MBR partition table.

Reboot, hold down the "C" key to boot from CD.

Install Arch as normal. Do not forget to set one partition as bootable.

After install you need to configure a couple of things...

> Dual Boot (Arch & Mac OS X)

Another way

- Prepare:

1.  Arch Linux Install CD

- Begin to install

1. Resize the partition with Disk Utils in Mac OS X

2. Install REFI in Mac OS X.

3. Boot to Arch Linux Installation CD

1) pacman -S gpt-fdisk and install 'gptsync' package from AUR

2) gptsync /dev/sda4 # TODO is this required?

3) partition with gdisk. # type code must be 0700

4) gptsync /dev/sda4 # TODO is this required?

5) begin install with /arch/setup, but don't install bootloader

6) gptsync /dev/sda4

7) install bootloader to /dev/sda3 manually. # be careful, not /dev/sda

       mount /dev/sda4 /mnt
       grub-install --root-directory=/mnt /dev/sda4
       # edit /mnt/boot/grub/menu.lst

Other ways: Two possibilities:

- Install Bootcamp, resize the Mac OS X partition

When Mac OS X installation is finished. Go on
http://refit.sourceforge.net and download rEFIT (Mac disk image)

To install rEFIT, mount the rEFIT.dmg file (it is normally automatic).

There is an other way (refer to rEFIT documentation) but you can open a
terminal then you copy /Volumes/rEFIT/efi/ to /

    # cp -r /Volumes/rEFIT/efi /

To install rEFIT :

    # cd /efi/refit/
    # ./enable.sh

Now we can synchronized MBR with GPT partition table thanks to rEFIT so
you restart your computer. You can see rEFIT, you press down key to
access to the Partitioning Tool. You press y to accept.

Put your Arch Linux CD in the CD-ROM drive first then restart the
computer. You can press C to boot from the CD or you can choose it in
the rEFIT menu.

Now it is the typical Arch Linux installation.

At the end of the installation DO NOT install the bootloader in the MBR,
but in a partition (e.g. sda3). This may add complications; see below.

GRUB

Macs are partitioned using the EFI system, which GRUBv1 is not
compatible with. Some versions of GRUB2 are compatible - however, GRUB2
is not on the installation CD as of the 2011.08.19 release. In order to
work around this, rEFIt creates a MBR (Master Boot Record), which must
be updated every time the partitions are modified or reformatted.
However, only the first 4 partitions are put into the MBR; if you are
dual booting, those first two will belong to the regular macbook
installation.

To install Arch Linux with GRUB as a dual-boot, follow these steps
(tested on a Macbook Pro(6,2)):

1.  Use the Disk Utility to resize your Mac partition, and create new
    partitions for your Linux installation. These can be formatted to
    anything - the Arch installation can reformat them as ext3 or ext4.
    Make sure that the / partition AND the /boot partition are BOTH in
    the first four partitions - or simply do not have a separate /boot
    partition, it isn't necessary.
2.  Install rEFIt as above, reboot, and update the MBR (choose "Start
    Partitioning Tool" from the rEFIt menu on boot)
3.  Insert the Arch Linux installation CD, reboot, and boot from the CD.
4.  Install Arch Linux, choosing a GRUB bootloader installation, but
    being careful to hit CANCEL when asked to install it to the MBR. The
    installation will consider this section 'FAILED', which is true, but
    we will take care of this.
5.  Reboot, update the MBR (same as step 2), and boot from the CD.
6.  Now we install GRUB:

     # cd /
     # mount -t ext3 /dev/sdaN /mnt # where sdaN is the location you installed to.
     # mount -t ext3 /dev/sdaM /mnt/boot # where sdaM is the location of the /boot partition, if you have a separate one
     # mount -t proc proc /mnt/proc
     # mount -t sysfs sys /mnt/sys
     # mount -o bind /dev /mnt/dev
     # chroot /mnt /bin/bash
     # grub
     grub> root (hd0,M-1)
     grub> setup (hd0,M-1)
     grub> quit
     # reboot

7.  From the rEFIt menu on boot, choose "Boot Linux from Partition
    X"<\li> <\ol> Now you are at an Arch Linux command-line.

    Configuration
    -------------

    > rc.conf

    Make sure your rc.conf at least has the following modules:

        MODULES=(sky2 fglrx speedstep_centrino)

    For CPU scaling use the powernowd package.

    > Xorg

    Install:

        pacman -S ati-fglrx-utils

    A sample xorg.conf follows (Outdated! See Xorg Input Hotplugging):

        /etc/X11/xorg.conf

        Section "ServerLayout"
          Identifier     "Simple Layout"
          Screen      0  "aticonfig-Screen[0]" 0 0
          InputDevice    "Mouse1" "CorePointer"
          InputDevice    "Keyboard1" "CoreKeyboard"
        EndSection

        Section "Files"
          FontPath     "/usr/share/fonts/misc"
          FontPath     "/usr/share/fonts/75dpi"
          FontPath     "/usr/share/fonts/100dpi"
          FontPath     "/usr/share/fonts/Type1"
        EndSection

        Section "Module"
          Load "freetype"
          Load "xtt"
          Load  "dbe"  	# Double buffer extension
          SubSection "extmod"
          	Option	    "omit xfree86-dga"   # do not initialize the DGA extension
          EndSubSection
        EndSection

        Section "InputDevice"
          Identifier  "Keyboard1"
          Driver      "kbd"
          Option	    "AutoRepeat" "500 30"
          Option	    "XkbRules" "xorg"
          Option	    "XkbModel" "pc105"
          Option	    "XkbLayout" "latam"
          Option            "XkbOptions"    "lv3:rwin_switch"
        EndSection

        Section "InputDevice"
          Identifier  "Mouse1"
          Driver      "mouse"
          Option	    "Protocol" "Auto"	# Auto detect
          Option	    "Device" "/dev/input/mice"
          Option	    "ZAxisMapping" "4 5 6 7"
          Option            "MinSpeed"              "1.0"
          Option            "MaxSpeed"              "1.0"
        EndSection

        Section "Monitor"
          Identifier   "aticonfig-Monitor[0]"
          Option	    "VendorName" "ATI Proprietary Driver"
          Option	    "ModelName" "Generic Autodetecting Monitor"
          Option	    "DPMS" "true"
        EndSection

        Section "Device"
          Identifier  "aticonfig-Device[0]"
          Driver      "fglrx"
        EndSection

        Section "Screen"
          Identifier "aticonfig-Screen[0]"
          Device     "aticonfig-Device[0]"
          Monitor    "aticonfig-Monitor[0]"
          DefaultDepth     24
          SubSection "Display"
          	Viewport   0 0
          	Depth     24
          EndSubSection
        EndSection

        Section "DRI"
          Mode 0666
        EndSection

    OR you can just make the necessary changes: (ADD these to your
    xorg.conf, do not replace)

    Configure Xorg using xorgconfig. Once done edit your "xorg.conf" and
    change the driver type to "fglrx".

        Section "Device"
          Driver      "fglrx"
        EndSection 

    Configure your keyboard: (make right "apple key" right ALT key)

        Section "InputDevice"
          Option          "XkbOptions"    "lv3:rwin_switch"
        EndSection

    Configure your trackpad:

        Section "InputDevice"
          Option          "Protocol"              "Auto"
          Option          "MinSpeed"              "1.0"
          Option          "MaxSpeed"              "1.0"
        EndSection

    OR you may want to use this, that emulates the Mac OS X behavior:

        Section "InputDevice"
         Identifier "Synaptics Touchpad"
           Driver "synaptics"
           Option          "CorePointer"
           Option          "Device"                "/dev/input/mouse1"
           Option          "Protocol"              "auto-dev"
           Option          "LeftEdge"              "60"
           Option          "RightEdge"             "900"
           Option          "BottomEdge"            "511"
           Option          "HorizScrollDelta"      "0"
           Option          "MinSpeed"              "0.4"
           Option          "MaxSpeed"              "1"
           Option          "AccelFactor"           "0.08"
           Option          "MaxTapTime"            "0"
           Option          "TapButton1"            "0"
           #Two Finger Scroll
           Option          "VertTwoFingerScroll"   "1"
           Option          "HorizTwoFingerScroll"  "1"
        EndSection

    Configure modules:

        Section "Module"
          Load  "dbe"  	# Double buffer extension
          SubSection "extmod"
            Option	    "omit xfree86-dga"   # do not initialize the DGA extension
          EndSubSection
        EndSection

    > Wireless

    The airport card in the newest MacBook (PCI-ID 168c:0024) is not yet
    supported by Madwifi. In short: Madwifi does not yet have a version
    of the (binary-only) HAL (hardware-abstraction layer) for the new
    chipset and ETA is unknown. Workaround: If your kernel is 32-bit,
    you can use ndiswrapper in combination with the 32-bit windows
    driver for the D-Link DWA-645. It is ugly, but it works. Some ubuntu
    users report it working with 64-bit too, albeit some have issues
    with WPA1/2.

    Madwifi drivers work on my second generation MBP following these
    instructions.

    > Pommed

    Pommed handles the hotkeys and is able to adjusts the LCD backlight,
    sound volume, keyboard backlight or to eject the CD-ROM drive.

    Pommed is in [community], there is also a GUI built on GTK (gpomme)

    > Suspend

    Suspend works most of the time (occasionally it dose not wake up)
    with the latest version of pm-utils.

        sudo pacman -S pm-utils

    Run the following to test suspension. (Pressing the power button,
    plugging in a usb device, or closing/opening the lid will resume.)

        sudo pm-suspend

    To suspend on closing of laptop lid, make sure you have acpi, and
    acpid installed with pacman, and that the acpid daemon is running.
    Then edit /etc/acpi/handler.sh and change the "button/lid)" section
    to look like the following:

        	button/lid)
        		#echo "LID switched!">/dev/tty5
        		if grep -q closed /proc/acpi/button/lid/LID0/state
        		then pm-suspend
        		fi
        		;;

    Acpid calls the button/lid) section whenever the lid is opened or
    closed. If pm-suspend is just added to this section, it will suspend
    when the lid is opened, and when the lid is closed. Causing it to
    wake up, and then immediately suspend again when you open the lid.
    Checking to see if the lid is closed with grep and only running
    pm-suspend when the lid is closed fixes this issue.

    TODO
    ----

    I WILL get around to doing these! I promise! In the mean time I just
    put them here to remind me to do them.

    - make package for refit (EDIT: refit is actually in [community])

    - make section for isight

Retrieved from
"https://wiki.archlinux.org/index.php?title=MacBookPro&oldid=253718"

Category:

-   Apple
